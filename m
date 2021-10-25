Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E57B43984D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbhJYOQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbhJYOQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:16:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2A8C061767;
        Mon, 25 Oct 2021 07:14:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mf0jt-0004Gj-VD; Mon, 25 Oct 2021 16:14:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>, lschlesinger@drivenets.com,
        dsahern@kernel.org, pablo@netfilter.org, crosser@average.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 1/2] netfilter: conntrack: skip confirmation and nat hooks in postrouting for vrf
Date:   Mon, 25 Oct 2021 16:13:59 +0200
Message-Id: <20211025141400.13698-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025141400.13698-1-fw@strlen.de>
References: <20211025141400.13698-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VRF driver invokes netfilter for output+postrouting hooks so that users
can create rules that check for 'oif $vrf' rather than lower device name.

Afterwards, ip stack calls those hooks again.

This is a problem when conntrack is used with IP masquerading.
masquerading has an internal check that re-validates the output
interface to account for route changes.

This check will trigger in the vrf case.

If the -j MASQUERADE rule matched on the first iteration, then round 2
finds state->out->ifindex != nat->masq_index: the latter is the vrf
index, but out->ifindex is the lower device.

The packet gets dropped and the conntrack entry is invalidated.

This change makes conntrack postrouting skip the nat hooks.
Also skip confirmation.  This allows the second round
(postrouting invocation from ipv4/ipv6) to create nat bindings.

This also prevents the second round from seeing packets that had their
source address changed by the nat hook.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto.c | 16 ++++++++++++++++
 net/netfilter/nf_nat_core.c        | 12 +++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 8f7a9837349c..d1f2d3c8d2b1 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -155,6 +155,16 @@ unsigned int nf_confirm(struct sk_buff *skb, unsigned int protoff,
 }
 EXPORT_SYMBOL_GPL(nf_confirm);
 
+static bool in_vrf_postrouting(const struct nf_hook_state *state)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	if (state->hook == NF_INET_POST_ROUTING &&
+	    netif_is_l3_master(state->out))
+		return true;
+#endif
+	return false;
+}
+
 static unsigned int ipv4_confirm(void *priv,
 				 struct sk_buff *skb,
 				 const struct nf_hook_state *state)
@@ -166,6 +176,9 @@ static unsigned int ipv4_confirm(void *priv,
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
 		return nf_conntrack_confirm(skb);
 
+	if (in_vrf_postrouting(state))
+		return NF_ACCEPT;
+
 	return nf_confirm(skb,
 			  skb_network_offset(skb) + ip_hdrlen(skb),
 			  ct, ctinfo);
@@ -374,6 +387,9 @@ static unsigned int ipv6_confirm(void *priv,
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
 		return nf_conntrack_confirm(skb);
 
+	if (in_vrf_postrouting(state))
+		return NF_ACCEPT;
+
 	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
 				   &frag_off);
 	if (protoff < 0 || (frag_off & htons(~0x7)) != 0) {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 273117683922..4d50d51db796 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -699,6 +699,16 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
 }
 EXPORT_SYMBOL_GPL(nf_nat_packet);
 
+static bool in_vrf_postrouting(const struct nf_hook_state *state)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	if (state->hook == NF_INET_POST_ROUTING &&
+	    netif_is_l3_master(state->out))
+		return true;
+#endif
+	return false;
+}
+
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state)
@@ -715,7 +725,7 @@ nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	 * packet filter it out, or implement conntrack/NAT for that
 	 * protocol. 8) --RR
 	 */
-	if (!ct)
+	if (!ct || in_vrf_postrouting(state))
 		return NF_ACCEPT;
 
 	nat = nfct_nat(ct);
-- 
2.32.0

