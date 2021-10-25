Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA2443984F
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbhJYOQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbhJYOQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:16:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8F9C061745;
        Mon, 25 Oct 2021 07:14:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mf0jy-0004HF-5J; Mon, 25 Oct 2021 16:14:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>, lschlesinger@drivenets.com,
        dsahern@kernel.org, pablo@netfilter.org, crosser@average.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 2/2] vrf: run conntrack only in context of lower/physdev for locally generated packets
Date:   Mon, 25 Oct 2021 16:14:00 +0200
Message-Id: <20211025141400.13698-3-fw@strlen.de>
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

This is a problem when NAT rules are configured.

To avoid any conntrack involvement in round 1, tag skbs as 'untracked'
to prevent conntrack from picking them up.

This gets cleared before the packet gets handed to the ip stack so
conntrack will be active on the second iteration.

One remaining issue is that a rule like

  output ... oif $vrfname notrack

won't propagate to the second round because we can't tell
'notrack set via ruleset' and 'notrack set by vrf driver' apart.
However, this isn't a regression: the 'notrack' removal happens
instead of unconditional nf_reset_ct().
I'd also like to avoid leaking more vrf specific conditionals into the
netfilter infra.

For ingress, conntrack has already been done before the packet makes it
to the vrf driver, with this patch egress does connection tracking with
lower/physical device as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/vrf.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index bf2fac913942..546aa1aacb77 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -35,6 +35,7 @@
 #include <net/l3mdev.h>
 #include <net/fib_rules.h>
 #include <net/netns/generic.h>
+#include <net/netfilter/nf_conntrack.h>
 
 #define DRV_NAME	"vrf"
 #define DRV_VERSION	"1.1"
@@ -424,12 +425,26 @@ static int vrf_local_xmit(struct sk_buff *skb, struct net_device *dev,
 	return NETDEV_TX_OK;
 }
 
+static void vrf_nf_set_untracked(struct sk_buff *skb)
+{
+	if (skb_get_nfct(skb) == 0)
+		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+}
+
+static void vrf_nf_reset_ct(struct sk_buff *skb)
+{
+	if (skb_get_nfct(skb) == IP_CT_UNTRACKED)
+		nf_reset_ct(skb);
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 static int vrf_ip6_local_out(struct net *net, struct sock *sk,
 			     struct sk_buff *skb)
 {
 	int err;
 
+	vrf_nf_reset_ct(skb);
+
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net,
 		      sk, skb, NULL, skb_dst(skb)->dev, dst_output);
 
@@ -508,6 +523,8 @@ static int vrf_ip_local_out(struct net *net, struct sock *sk,
 {
 	int err;
 
+	vrf_nf_reset_ct(skb);
+
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, skb_dst(skb)->dev, dst_output);
 	if (likely(err == 1))
@@ -626,8 +643,7 @@ static void vrf_finish_direct(struct sk_buff *skb)
 		skb_pull(skb, ETH_HLEN);
 	}
 
-	/* reset skb device */
-	nf_reset_ct(skb);
+	vrf_nf_reset_ct(skb);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -641,7 +657,7 @@ static int vrf_finish_output6(struct net *net, struct sock *sk,
 	struct neighbour *neigh;
 	int ret;
 
-	nf_reset_ct(skb);
+	vrf_nf_reset_ct(skb);
 
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
@@ -752,6 +768,8 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
 
 	skb->dev = vrf_dev;
 
+	vrf_nf_set_untracked(skb);
+
 	err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
 
@@ -858,7 +876,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	struct neighbour *neigh;
 	bool is_v6gw = false;
 
-	nf_reset_ct(skb);
+	vrf_nf_reset_ct(skb);
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
@@ -980,6 +998,8 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
 
 	skb->dev = vrf_dev;
 
+	vrf_nf_set_untracked(skb);
+
 	err = nf_hook(NFPROTO_IPV4, NF_INET_LOCAL_OUT, net, sk,
 		      skb, NULL, vrf_dev, vrf_ip_out_direct_finish);
 
-- 
2.32.0

