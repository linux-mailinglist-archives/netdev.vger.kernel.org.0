Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6F712F39B
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 04:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgACDvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 22:51:14 -0500
Received: from mx60.baidu.com ([61.135.168.60]:24783 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726292AbgACDvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 22:51:14 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 7A3831EBA002
        for <netdev@vger.kernel.org>; Fri,  3 Jan 2020 11:51:00 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] net: remove the check argument from __skb_gro_checksum_convert
Date:   Fri,  3 Jan 2020 11:51:00 +0800
Message-Id: <1578023460-12331-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The argument is always ignored, so remove it.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/netdevice.h | 6 +++---
 net/ipv4/gre_offload.c    | 2 +-
 net/ipv4/udp_offload.c    | 2 +-
 net/ipv6/udp_offload.c    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2fd19fb8826d..2741aa35bec6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2826,16 +2826,16 @@ static inline bool __skb_gro_checksum_convert_check(struct sk_buff *skb)
 }
 
 static inline void __skb_gro_checksum_convert(struct sk_buff *skb,
-					      __sum16 check, __wsum pseudo)
+					      __wsum pseudo)
 {
 	NAPI_GRO_CB(skb)->csum = ~pseudo;
 	NAPI_GRO_CB(skb)->csum_valid = 1;
 }
 
-#define skb_gro_checksum_try_convert(skb, proto, check, compute_pseudo)	\
+#define skb_gro_checksum_try_convert(skb, proto, compute_pseudo)	\
 do {									\
 	if (__skb_gro_checksum_convert_check(skb))			\
-		__skb_gro_checksum_convert(skb, check,			\
+		__skb_gro_checksum_convert(skb, 			\
 					   compute_pseudo(skb, proto));	\
 } while (0)
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 4de7e962d3da..2e6d1b7a7bc9 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -174,7 +174,7 @@ static struct sk_buff *gre_gro_receive(struct list_head *head,
 		if (skb_gro_checksum_simple_validate(skb))
 			goto out_unlock;
 
-		skb_gro_checksum_try_convert(skb, IPPROTO_GRE, 0,
+		skb_gro_checksum_try_convert(skb, IPPROTO_GRE,
 					     null_compute_pseudo);
 	}
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index a3908e55ed89..b25e42100ceb 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -480,7 +480,7 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 						 inet_gro_compute_pseudo))
 		goto flush;
 	else if (uh->check)
-		skb_gro_checksum_try_convert(skb, IPPROTO_UDP, uh->check,
+		skb_gro_checksum_try_convert(skb, IPPROTO_UDP,
 					     inet_gro_compute_pseudo);
 skip:
 	NAPI_GRO_CB(skb)->is_ipv6 = 0;
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 64b8f05d6735..f0d5fc27d0b5 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -127,7 +127,7 @@ struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
 						 ip6_gro_compute_pseudo))
 		goto flush;
 	else if (uh->check)
-		skb_gro_checksum_try_convert(skb, IPPROTO_UDP, uh->check,
+		skb_gro_checksum_try_convert(skb, IPPROTO_UDP,
 					     ip6_gro_compute_pseudo);
 
 skip:
-- 
2.16.2

