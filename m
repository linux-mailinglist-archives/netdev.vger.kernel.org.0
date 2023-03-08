Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459E96B1200
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 20:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCHTa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 14:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCHTax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 14:30:53 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B496362DAF;
        Wed,  8 Mar 2023 11:30:52 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pZzUv-0003pi-Ld; Wed, 08 Mar 2023 20:30:49 +0100
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
Subject: [PATCH net-next 3/9] netfilter: bridge: check len before accessing more nh data
Date:   Wed,  8 Mar 2023 20:30:27 +0100
Message-Id: <20230308193033.13965-4-fw@strlen.de>
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

In the while loop of br_nf_check_hbh_len(), similar to ip6_parse_tlv(),
before accessing 'nh[off + 1]', it should add a check 'len < 2'; and
before parsing IPV6_TLV_JUMBO, it should add a check 'optlen > len',
in case of overflows.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_ipv6.c | 45 +++++++++++++++-------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index afd1c718b683..8be3c5c8b925 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -50,54 +50,49 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 	u32 pkt_len;
 
 	if (!pskb_may_pull(skb, off + 8))
-		goto bad;
+		return -1;
 	nh = (unsigned char *)(ipv6_hdr(skb) + 1);
 	len = (nh[1] + 1) << 3;
 
 	if (!pskb_may_pull(skb, off + len))
-		goto bad;
+		return -1;
 	nh = skb_network_header(skb);
 
 	off += 2;
 	len -= 2;
-
 	while (len > 0) {
-		int optlen = nh[off + 1] + 2;
-
-		switch (nh[off]) {
-		case IPV6_TLV_PAD1:
-			optlen = 1;
-			break;
+		int optlen;
 
-		case IPV6_TLV_PADN:
-			break;
+		if (nh[off] == IPV6_TLV_PAD1) {
+			off++;
+			len--;
+			continue;
+		}
+		if (len < 2)
+			return -1;
+		optlen = nh[off + 1] + 2;
+		if (optlen > len)
+			return -1;
 
-		case IPV6_TLV_JUMBO:
+		if (nh[off] == IPV6_TLV_JUMBO) {
 			if (nh[off + 1] != 4 || (off & 3) != 2)
-				goto bad;
+				return -1;
 			pkt_len = ntohl(*(__be32 *)(nh + off + 2));
 			if (pkt_len <= IPV6_MAXPLEN ||
 			    ipv6_hdr(skb)->payload_len)
-				goto bad;
+				return -1;
 			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
-				goto bad;
+				return -1;
 			if (pskb_trim_rcsum(skb,
 					    pkt_len + sizeof(struct ipv6hdr)))
-				goto bad;
+				return -1;
 			nh = skb_network_header(skb);
-			break;
-		default:
-			if (optlen > len)
-				goto bad;
-			break;
 		}
 		off += optlen;
 		len -= optlen;
 	}
-	if (len == 0)
-		return 0;
-bad:
-	return -1;
+
+	return len ? -1 : 0;
 }
 
 int br_validate_ipv6(struct net *net, struct sk_buff *skb)
-- 
2.39.2

