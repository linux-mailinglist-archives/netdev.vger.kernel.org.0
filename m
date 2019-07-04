Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCC15F514
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfGDJDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:03:41 -0400
Received: from mx140-tc.baidu.com ([61.135.168.140]:37667 "EHLO
        tc-sys-mailedm03.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727092AbfGDJDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 05:03:41 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm03.tc.baidu.com (Postfix) with ESMTP id 7A0A0450005F
        for <netdev@vger.kernel.org>; Thu,  4 Jul 2019 17:03:26 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] net: remove unused parameter from skb_checksum_try_convert
Date:   Thu,  4 Jul 2019 17:03:26 +0800
Message-Id: <1562231006-16341-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the check parameter is never used

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/skbuff.h | 8 +++-----
 net/ipv4/gre_demux.c   | 2 +-
 net/ipv4/udp.c         | 3 +--
 net/ipv6/udp.c         | 3 +--
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c922ac8a8bd6..f0b5adeb644d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3914,18 +3914,16 @@ static inline bool __skb_checksum_convert_check(struct sk_buff *skb)
 	return (skb->ip_summed == CHECKSUM_NONE && skb->csum_valid);
 }
 
-static inline void __skb_checksum_convert(struct sk_buff *skb,
-					  __sum16 check, __wsum pseudo)
+static inline void __skb_checksum_convert(struct sk_buff *skb, __wsum pseudo)
 {
 	skb->csum = ~pseudo;
 	skb->ip_summed = CHECKSUM_COMPLETE;
 }
 
-#define skb_checksum_try_convert(skb, proto, check, compute_pseudo)	\
+#define skb_checksum_try_convert(skb, proto, compute_pseudo)	\
 do {									\
 	if (__skb_checksum_convert_check(skb))				\
-		__skb_checksum_convert(skb, check,			\
-				       compute_pseudo(skb, proto));	\
+		__skb_checksum_convert(skb, compute_pseudo(skb, proto)); \
 } while (0)
 
 static inline void skb_remcsum_adjust_partial(struct sk_buff *skb, void *ptr,
diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 293acfb36376..44bfeecac33e 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -83,7 +83,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	options = (__be32 *)(greh + 1);
 	if (greh->flags & GRE_CSUM) {
 		if (!skb_checksum_simple_validate(skb)) {
-			skb_checksum_try_convert(skb, IPPROTO_GRE, 0,
+			skb_checksum_try_convert(skb, IPPROTO_GRE,
 						 null_compute_pseudo);
 		} else if (csum_err) {
 			*csum_err = true;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1b971bd95786..c21862ba9c02 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2224,8 +2224,7 @@ static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 	int ret;
 
 	if (inet_get_convert_csum(sk) && uh->check && !IS_UDPLITE(sk))
-		skb_checksum_try_convert(skb, IPPROTO_UDP, uh->check,
-					 inet_compute_pseudo);
+		skb_checksum_try_convert(skb, IPPROTO_UDP, inet_compute_pseudo);
 
 	ret = udp_queue_rcv_skb(sk, skb);
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 66ca5a4b17c4..4406e059da68 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -826,8 +826,7 @@ static int udp6_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
 	int ret;
 
 	if (inet_get_convert_csum(sk) && uh->check && !IS_UDPLITE(sk))
-		skb_checksum_try_convert(skb, IPPROTO_UDP, uh->check,
-					 ip6_compute_pseudo);
+		skb_checksum_try_convert(skb, IPPROTO_UDP, ip6_compute_pseudo);
 
 	ret = udpv6_queue_rcv_skb(sk, skb);
 
-- 
2.16.2

