Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9458F41C90C
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344254AbhI2QBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:01:04 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12980 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345447AbhI2P7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:47 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLbJ05PrzWY0l;
        Wed, 29 Sep 2021 23:56:44 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:03 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:02 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 050/167] net: hsr: use netdev feature helpers
Date:   Wed, 29 Sep 2021 23:51:37 +0800
Message-ID: <20210929155334.12454-51-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev_feature_xxx helpers to replace the logical operation
for netdev features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 net/hsr/hsr_device.c   | 21 ++++++++++++---------
 net/hsr/hsr_forward.c  | 11 +++++++----
 net/hsr/hsr_framereg.c |  3 ++-
 net/hsr/hsr_slave.c    |  3 ++-
 4 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7e6dd372711f..b7ba16bdb8e0 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -183,7 +183,7 @@ static void hsr_features_recompute(struct hsr_priv *hsr,
 	netdev_features_t mask;
 	struct hsr_port *port;
 
-	mask = *features;
+	netdev_feature_copy(&mask, *features);
 
 	/* Mask out all features that, if supported by one device, should be
 	 * enabled for all devices (see NETIF_F_ONE_FOR_ALL).
@@ -192,7 +192,7 @@ static void hsr_features_recompute(struct hsr_priv *hsr,
 	 * that were in features originally, and also is in NETIF_F_ONE_FOR_ALL,
 	 * may become enabled.
 	 */
-	*features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
 	hsr_for_each_port(hsr, port)
 		netdev_increment_features(features, *features,
 					  port->dev->features, mask);
@@ -445,22 +445,25 @@ void hsr_dev_setup(struct net_device *dev)
 
 	dev->needs_free_netdev = true;
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HIGHDMA |
-			   NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
-			   NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_feature_zero(&dev->hw_features);
+	netdev_feature_set_bits(NETIF_F_SG | NETIF_F_FRAGLIST |
+				NETIF_F_HIGHDMA |
+				NETIF_F_GSO_MASK | NETIF_F_HW_CSUM |
+				NETIF_F_HW_VLAN_CTAG_TX, &dev->hw_features);
 
-	dev->features = dev->hw_features;
+	netdev_feature_copy(&dev->features, dev->hw_features);
 
 	/* Prevent recursive tx locking */
-	dev->features |= NETIF_F_LLTX;
+	netdev_feature_set_bit(NETIF_F_LLTX_BIT, &dev->features);
+
 	/* VLAN on top of HSR needs testing and probably some work on
 	 * hsr_header_create() etc.
 	 */
-	dev->features |= NETIF_F_VLAN_CHALLENGED;
+	netdev_feature_set_bit(NETIF_F_VLAN_CHALLENGED_BIT, &dev->features);
 	/* Not sure about this. Taken from bridge code. netdev_features.h says
 	 * it means "Does not change network namespaces".
 	 */
-	dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_feature_set_bit(NETIF_F_NETNS_LOCAL_BIT, &dev->features);
 }
 
 /* Return true if dev is a HSR master; return false otherwise.
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ceb8afb2a62f..6b3aa5f93be0 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -249,7 +249,8 @@ struct sk_buff *hsr_create_tagged_frame(struct hsr_frame_info *frame,
 		/* set the lane id properly */
 		hsr_set_path_id(hsr_ethhdr, port);
 		return skb_clone(frame->skb_hsr, GFP_ATOMIC);
-	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+	} else if (netdev_feature_test_bit(NETIF_F_HW_HSR_TAG_INS_BIT,
+					   port->dev->features)) {
 		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
@@ -293,7 +294,8 @@ struct sk_buff *prp_create_tagged_frame(struct hsr_frame_info *frame,
 			return NULL;
 		}
 		return skb_clone(frame->skb_prp, GFP_ATOMIC);
-	} else if (port->dev->features & NETIF_F_HW_HSR_TAG_INS) {
+	} else if (netdev_feature_test_bit(NETIF_F_HW_HSR_TAG_INS_BIT,
+					   port->dev->features)) {
 		return skb_clone(frame->skb_std, GFP_ATOMIC);
 	}
 
@@ -349,7 +351,7 @@ bool prp_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
 
 bool hsr_drop_frame(struct hsr_frame_info *frame, struct hsr_port *port)
 {
-	if (port->dev->features & NETIF_F_HW_HSR_FWD)
+	if (netdev_feature_test_bit(NETIF_F_HW_HSR_FWD_BIT, port->dev->features))
 		return prp_drop_frame(frame, port);
 
 	return false;
@@ -390,7 +392,8 @@ static void hsr_forward_do(struct hsr_frame_info *frame)
 		/* If hardware duplicate generation is enabled, only send out
 		 * one port.
 		 */
-		if ((port->dev->features & NETIF_F_HW_HSR_DUP) && sent)
+		if (netdev_feature_test_bit(NETIF_F_HW_HSR_DUP_BIT,
+					    port->dev->features) && sent)
 			continue;
 
 		/* Don't send frame over port where it has been sent before.
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index e31949479305..d0b1d9fe4f4f 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -397,7 +397,8 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
 	 * ensures entries of restarted nodes gets pruned so that they can
 	 * re-register and resume communications.
 	 */
-	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	if (!netdev_feature_test_bit(NETIF_F_HW_HSR_TAG_RM_BIT,
+				     port->dev->features) &&
 	    seq_nr_before(sequence_nr, node->seq_out[port->type]))
 		return;
 
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index b70e6bbf6021..a21a3035f6d2 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -54,7 +54,8 @@ static rx_handler_result_t hsr_handle_frame(struct sk_buff **pskb)
 	 */
 	protocol = eth_hdr(skb)->h_proto;
 
-	if (!(port->dev->features & NETIF_F_HW_HSR_TAG_RM) &&
+	if (!netdev_feature_test_bit(NETIF_F_HW_HSR_TAG_RM_BIT,
+				     port->dev->features) &&
 	    hsr->proto_ops->invalid_dan_ingress_frame &&
 	    hsr->proto_ops->invalid_dan_ingress_frame(protocol))
 		goto finish_pass;
-- 
2.33.0

