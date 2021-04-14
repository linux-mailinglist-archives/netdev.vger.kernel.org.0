Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B13935F8CB
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351520AbhDNQNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351578AbhDNQN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:13:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC0BC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:13:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lWi8Y-0005rN-LL; Wed, 14 Apr 2021 18:13:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 1/3] flow: remove spi key from flowi struct
Date:   Wed, 14 Apr 2021 18:12:51 +0200
Message-Id: <20210414161253.27586-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210414161253.27586-1-fw@strlen.de>
References: <20210414161253.27586-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm session decode ipv4 path (but not ipv6) sets this, but there are no
consumers.  Remove it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/flow.h     |  3 ---
 net/xfrm/xfrm_policy.c | 39 ---------------------------------------
 2 files changed, 42 deletions(-)

diff --git a/include/net/flow.h b/include/net/flow.h
index 39d0cedcddee..6f5e70240071 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -59,7 +59,6 @@ union flowi_uli {
 		__le16	sport;
 	} dnports;
 
-	__be32		spi;
 	__be32		gre_key;
 
 	struct {
@@ -90,7 +89,6 @@ struct flowi4 {
 #define fl4_dport		uli.ports.dport
 #define fl4_icmp_type		uli.icmpt.type
 #define fl4_icmp_code		uli.icmpt.code
-#define fl4_ipsec_spi		uli.spi
 #define fl4_mh_type		uli.mht.type
 #define fl4_gre_key		uli.gre_key
 } __attribute__((__aligned__(BITS_PER_LONG/8)));
@@ -150,7 +148,6 @@ struct flowi6 {
 #define fl6_dport		uli.ports.dport
 #define fl6_icmp_type		uli.icmpt.type
 #define fl6_icmp_code		uli.icmpt.code
-#define fl6_ipsec_spi		uli.spi
 #define fl6_mh_type		uli.mht.type
 #define fl6_gre_key		uli.gre_key
 	__u32			mp_hash;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b74f28cabe24..c49f20657cdb 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3326,39 +3326,6 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 				fl4->fl4_icmp_code = icmp[1];
 			}
 			break;
-		case IPPROTO_ESP:
-			if (xprth + 4 < skb->data ||
-			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be32 *ehdr;
-
-				xprth = skb_network_header(skb) + ihl * 4;
-				ehdr = (__be32 *)xprth;
-
-				fl4->fl4_ipsec_spi = ehdr[0];
-			}
-			break;
-		case IPPROTO_AH:
-			if (xprth + 8 < skb->data ||
-			    pskb_may_pull(skb, xprth + 8 - skb->data)) {
-				__be32 *ah_hdr;
-
-				xprth = skb_network_header(skb) + ihl * 4;
-				ah_hdr = (__be32 *)xprth;
-
-				fl4->fl4_ipsec_spi = ah_hdr[1];
-			}
-			break;
-		case IPPROTO_COMP:
-			if (xprth + 4 < skb->data ||
-			    pskb_may_pull(skb, xprth + 4 - skb->data)) {
-				__be16 *ipcomp_hdr;
-
-				xprth = skb_network_header(skb) + ihl * 4;
-				ipcomp_hdr = (__be16 *)xprth;
-
-				fl4->fl4_ipsec_spi = htonl(ntohs(ipcomp_hdr[1]));
-			}
-			break;
 		case IPPROTO_GRE:
 			if (xprth + 12 < skb->data ||
 			    pskb_may_pull(skb, xprth + 12 - skb->data)) {
@@ -3377,7 +3344,6 @@ decode_session4(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			}
 			break;
 		default:
-			fl4->fl4_ipsec_spi = 0;
 			break;
 		}
 	}
@@ -3470,12 +3436,7 @@ decode_session6(struct sk_buff *skb, struct flowi *fl, bool reverse)
 			fl6->flowi6_proto = nexthdr;
 			return;
 #endif
-		/* XXX Why are there these headers? */
-		case IPPROTO_AH:
-		case IPPROTO_ESP:
-		case IPPROTO_COMP:
 		default:
-			fl6->fl6_ipsec_spi = 0;
 			fl6->flowi6_proto = nexthdr;
 			return;
 		}
-- 
2.26.3

