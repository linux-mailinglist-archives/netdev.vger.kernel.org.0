Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F1B368EA7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241480AbhDWIO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:14:58 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:50540 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbhDWIOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:14:54 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 597A5800059;
        Fri, 23 Apr 2021 10:14:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:14:17 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 10:14:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3B5203180454; Fri, 23 Apr 2021 10:14:16 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/4] flow: remove spi key from flowi struct
Date:   Fri, 23 Apr 2021 10:14:06 +0200
Message-ID: <20210423081409.729557-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210423081409.729557-1-steffen.klassert@secunet.com>
References: <20210423081409.729557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

xfrm session decode ipv4 path (but not ipv6) sets this, but there are no
consumers.  Remove it.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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
index 156347fd7e2e..cc6e02eb76c2 100644
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
2.25.1

