Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E14435EB7
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhJUKKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:10:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33842 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbhJUKKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:10:47 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E464263F40;
        Thu, 21 Oct 2021 12:06:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/8] netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6
Date:   Thu, 21 Oct 2021 12:08:18 +0200
Message-Id: <20211021100821.964677-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211021100821.964677-1-pablo@netfilter.org>
References: <20211021100821.964677-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

In rt_mt6(), when it's a nonlinear skb, the 1st skb_header_pointer()
only copies sizeof(struct ipv6_rt_hdr) to _route that rh points to.
The access by ((const struct rt0_hdr *)rh)->reserved will overflow
the buffer. So this access should be moved below the 2nd call to
skb_header_pointer().

Besides, after the 2nd skb_header_pointer(), its return value should
also be checked, othersize, *rp may cause null-pointer-ref.

v1->v2:
  - clean up some old debugging log.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6t_rt.c | 48 +++++-------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 733c83d38b30..4ad8b2032f1f 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -25,12 +25,7 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static inline bool
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 {
-	bool r;
-	pr_debug("segsleft_match:%c 0x%x <= 0x%x <= 0x%x\n",
-		 invert ? '!' : ' ', min, id, max);
-	r = (id >= min && id <= max) ^ invert;
-	pr_debug(" result %s\n", r ? "PASS" : "FAILED");
-	return r;
+	return (id >= min && id <= max) ^ invert;
 }
 
 static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
@@ -65,30 +60,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		return false;
 	}
 
-	pr_debug("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-	pr_debug("TYPE %04X ", rh->type);
-	pr_debug("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
-
-	pr_debug("IPv6 RT segsleft %02X ",
-		 segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-				rh->segments_left,
-				!!(rtinfo->invflags & IP6T_RT_INV_SGS)));
-	pr_debug("type %02X %02X %02X ",
-		 rtinfo->rt_type, rh->type,
-		 (!(rtinfo->flags & IP6T_RT_TYP) ||
-		  ((rtinfo->rt_type == rh->type) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-	pr_debug("len %02X %04X %02X ",
-		 rtinfo->hdrlen, hdrlen,
-		 !(rtinfo->flags & IP6T_RT_LEN) ||
-		  ((rtinfo->hdrlen == hdrlen) ^
-		   !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
-	pr_debug("res %02X %02X %02X ",
-		 rtinfo->flags & IP6T_RT_RES,
-		 ((const struct rt0_hdr *)rh)->reserved,
-		 !((rtinfo->flags & IP6T_RT_RES) &&
-		   (((const struct rt0_hdr *)rh)->reserved)));
-
 	ret = (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
 			      rh->segments_left,
 			      !!(rtinfo->invflags & IP6T_RT_INV_SGS))) &&
@@ -107,22 +78,22 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 						       reserved),
 					sizeof(_reserved),
 					&_reserved);
+		if (!rp) {
+			par->hotdrop = true;
+			return false;
+		}
 
 		ret = (*rp == 0);
 	}
 
-	pr_debug("#%d ", rtinfo->addrnr);
 	if (!(rtinfo->flags & IP6T_RT_FST)) {
 		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
-		pr_debug("Not strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
 			unsigned int i = 0;
 
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0;
 			     temp < (unsigned int)((hdrlen - 8) / 16);
 			     temp++) {
@@ -138,26 +109,20 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 					return false;
 				}
 
-				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					pr_debug("i=%d temp=%d;\n", i, temp);
+				if (ipv6_addr_equal(ap, &rtinfo->addrs[i]))
 					i++;
-				}
 				if (i == rtinfo->addrnr)
 					break;
 			}
-			pr_debug("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
 			else
 				return false;
 		}
 	} else {
-		pr_debug("Strict ");
 		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
-			pr_debug("There isn't enough space\n");
 			return false;
 		} else {
-			pr_debug("#%d ", rtinfo->addrnr);
 			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
@@ -173,7 +138,6 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 				if (!ipv6_addr_equal(ap, &rtinfo->addrs[temp]))
 					break;
 			}
-			pr_debug("temp=%d #%d\n", temp, rtinfo->addrnr);
 			if (temp == rtinfo->addrnr &&
 			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
-- 
2.30.2

