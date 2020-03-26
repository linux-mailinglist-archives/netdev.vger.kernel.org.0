Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A21939AC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCZHdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:33:49 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:53715 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726322AbgCZHdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:33:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0TtfX3XQ_1585208018;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TtfX3XQ_1585208018)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 Mar 2020 15:33:38 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     Konstantin Khlebnikov <koct9i@gmail.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH net-next] net: Fix typo of SKB_SGO_CB_OFFSET
Date:   Thu, 26 Mar 2020 15:33:14 +0800
Message-Id: <20200326073314.55633-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SKB_SGO_CB_OFFSET should be SKB_GSO_CB_OFFSET which means the
offset of the GSO in skb cb. This patch fixes the typo.

Fixes: 9207f9d45b0a ("net: preserve IP control block during GSO segmentation")
Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 include/linux/skbuff.h     | 4 ++--
 net/core/dev.c             | 4 ++--
 net/ipv4/ip_output.c       | 2 +-
 net/ipv4/udp.c             | 2 +-
 net/openvswitch/datapath.c | 2 +-
 net/xfrm/xfrm_output.c     | 4 ++--
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e59620234415..56ed6eb26680 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4397,8 +4397,8 @@ struct skb_gso_cb {
 	__wsum	csum;
 	__u16	csum_start;
 };
-#define SKB_SGO_CB_OFFSET	32
-#define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_SGO_CB_OFFSET))
+#define SKB_GSO_CB_OFFSET	32
+#define SKB_GSO_CB(skb) ((struct skb_gso_cb *)((skb)->cb + SKB_GSO_CB_OFFSET))
 
 static inline int skb_tnl_header_len(const struct sk_buff *inner_skb)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 500bba8874b0..a38a8b53b916 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3266,7 +3266,7 @@ static inline bool skb_needs_check(struct sk_buff *skb, bool tx_path)
  *	It may return NULL if the skb requires no segmentation.  This is
  *	only possible when GSO is used for verifying header integrity.
  *
- *	Segmentation preserves SKB_SGO_CB_OFFSET bytes of previous skb cb.
+ *	Segmentation preserves SKB_GSO_CB_OFFSET bytes of previous skb cb.
  */
 struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 				  netdev_features_t features, bool tx_path)
@@ -3295,7 +3295,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
 
-	BUILD_BUG_ON(SKB_SGO_CB_OFFSET +
+	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
 		     sizeof(*SKB_GSO_CB(skb)) > sizeof(skb->cb));
 
 	SKB_GSO_CB(skb)->mac_offset = skb_headroom(skb);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d84819893db9..6cbb8b7e56b0 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -263,7 +263,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 *    insufficent MTU.
 	 */
 	features = netif_skb_features(skb);
-	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_SGO_CB_OFFSET);
+	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
 	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 08a41f1e1cd2..05a120df90e4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2107,7 +2107,7 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	if (likely(!udp_unexpected_gso(sk, skb)))
 		return udp_queue_rcv_one_skb(sk, skb);
 
-	BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_SGO_CB_OFFSET);
+	BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
 	__skb_push(skb, -skb_mac_offset(skb));
 	segs = udp_rcv_segment(sk, skb, true);
 	skb_list_walk_safe(segs, skb, next) {
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 07a7dd185995..d8ae541d22a8 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -305,7 +305,7 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	struct sk_buff *segs, *nskb;
 	int err;
 
-	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_SGO_CB_OFFSET);
+	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
 	segs = __skb_gso_segment(skb, NETIF_F_SG, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index fafc7aba705f..2fd3d990d992 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -535,8 +535,8 @@ static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb
 {
 	struct sk_buff *segs, *nskb;
 
-	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_SGO_CB_OFFSET);
-	BUILD_BUG_ON(sizeof(*IP6CB(skb)) > SKB_SGO_CB_OFFSET);
+	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
+	BUILD_BUG_ON(sizeof(*IP6CB(skb)) > SKB_GSO_CB_OFFSET);
 	segs = skb_gso_segment(skb, 0);
 	kfree_skb(skb);
 	if (IS_ERR(segs))
-- 
2.16.6

