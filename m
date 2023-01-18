Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC37671D1C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjARNJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbjARNI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:08:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852675A82B;
        Wed, 18 Jan 2023 04:32:44 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7cM-00074W-He; Wed, 18 Jan 2023 13:32:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/9] netfilter: conntrack: avoid reload of ct->status
Date:   Wed, 18 Jan 2023 13:32:02 +0100
Message-Id: <20230118123208.17167-4-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230118123208.17167-1-fw@strlen.de>
References: <20230118123208.17167-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compiler can't merge the two test_bit() calls, so load ct->status
once and use non-atomic accesses.

This is fine because IPS_EXPECTED or NAT_CLASH are either set at ct
creation time or not at all, but compiler can't know that.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c      |  9 +++++----
 net/netfilter/nf_conntrack_proto_udp.c | 10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 81ece117033a..9e12cade4e0f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1854,14 +1854,15 @@ resolve_normal_ct(struct nf_conn *tmpl,
 	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY) {
 		ctinfo = IP_CT_ESTABLISHED_REPLY;
 	} else {
+		unsigned long status = READ_ONCE(ct->status);
+
 		/* Once we've had two way comms, always ESTABLISHED. */
-		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (likely(status & IPS_SEEN_REPLY))
 			ctinfo = IP_CT_ESTABLISHED;
-		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
+		else if (status & IPS_EXPECTED)
 			ctinfo = IP_CT_RELATED;
-		} else {
+		else
 			ctinfo = IP_CT_NEW;
-		}
 	}
 	nf_ct_set(skb, ct, ctinfo);
 	return 0;
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3b516cffc779..6b9206635b24 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -88,6 +88,7 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 			    const struct nf_hook_state *state)
 {
 	unsigned int *timeouts;
+	unsigned long status;
 
 	if (udp_error(skb, dataoff, state))
 		return -NF_ACCEPT;
@@ -96,26 +97,27 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 	if (!timeouts)
 		timeouts = udp_get_timeouts(nf_ct_net(ct));
 
-	if (!nf_ct_is_confirmed(ct))
+	status = READ_ONCE(ct->status);
+	if ((status & IPS_CONFIRMED) == 0)
 		ct->proto.udp.stream_ts = 2 * HZ + jiffies;
 
 	/* If we've seen traffic both ways, this is some kind of UDP
 	 * stream. Set Assured.
 	 */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+	if (status & IPS_SEEN_REPLY_BIT) {
 		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
 		bool stream = false;
 
 		/* Still active after two seconds? Extend timeout. */
 		if (time_after(jiffies, ct->proto.udp.stream_ts)) {
 			extra = timeouts[UDP_CT_REPLIED];
-			stream = true;
+			stream = (status & IPS_ASSURED) == 0;
 		}
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
 		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
-		if (unlikely((ct->status & IPS_NAT_CLASH)))
+		if (unlikely((status & IPS_NAT_CLASH)))
 			return NF_ACCEPT;
 
 		/* Also, more likely to be important, and not a probe */
-- 
2.38.2

