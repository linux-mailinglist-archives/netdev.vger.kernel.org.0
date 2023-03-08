Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D108A6B1202
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCHTbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCHTa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:30:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE555C080C;
        Wed,  8 Mar 2023 11:30:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzUz-0003q7-PE; Wed, 08 Mar 2023 20:30:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH net-next 4/9] netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
Date:   Wed,  8 Mar 2023 20:30:28 +0100
Message-Id: <20230308193033.13965-5-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308193033.13965-1-fw@strlen.de>
References: <20230308193033.13965-1-fw@strlen.de>
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

From: Xin Long <lucien.xin@gmail.com>

br_nf_check_hbh_len() is a function to check the Hop-by-hop option
header, and shouldn't do pskb_trim_rcsum() there. This patch is to
pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
after calling br_validate_ipv6() instead.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 8be3c5c8b925..a0d6dfb3e255 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -43,11 +43,10 @@
 /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
  * anyway
  */
-static int br_nf_check_hbh_len(struct sk_buff *skb)
+static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
 {
 	int len, off = sizeof(struct ipv6hdr);
 	unsigned char *nh;
-	u32 pkt_len;
 
 	if (!pskb_may_pull(skb, off + 8))
 		return -1;
@@ -75,6 +74,8 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 			return -1;
 
 		if (nh[off] == IPV6_TLV_JUMBO) {
+			u32 pkt_len;
+
 			if (nh[off + 1] != 4 || (off & 3) != 2)
 				return -1;
 			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
@@ -83,10 +84,7 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 				return -1;
 			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
 				return -1;
-			if (pskb_trim_rcsum(skb,
-					    pkt_len + sizeof(struct ipv6hdr)))
-				return -1;
-			nh = skb_network_header(skb);
+			*plen = pkt_len;
 		}
 		off += optlen;
 		len -= optlen;
@@ -114,22 +112,19 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 		goto inhdr_error;
 
 	pkt_len = ntohs(hdr->payload_len);
+	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
+		goto drop;
 
-	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
-		if (pkt_len + ip6h_len > skb->len) {
-			__IP6_INC_STATS(net, idev,
-					IPSTATS_MIB_INTRUNCATEDPKTS);
-			goto drop;
-		}
-		if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
-			__IP6_INC_STATS(net, idev,
-					IPSTATS_MIB_INDISCARDS);
-			goto drop;
-		}
-		hdr = ipv6_hdr(skb);
+	if (pkt_len + ip6h_len > skb->len) {
+		__IP6_INC_STATS(net, idev,
+				IPSTATS_MIB_INTRUNCATEDPKTS);
+		goto drop;
 	}
-	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb))
+	if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
+		__IP6_INC_STATS(net, idev,
+				IPSTATS_MIB_INDISCARDS);
 		goto drop;
+	}
 
 	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
 	/* No IP options in IPv6 header; however it should be
-- 
2.39.2

