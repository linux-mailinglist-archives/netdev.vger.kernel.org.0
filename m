Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3852C7030
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 18:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732315AbgK1ETg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 23:19:36 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8457 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731486AbgK1ENf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 23:13:35 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CjcxS36hJzhhXK;
        Sat, 28 Nov 2020 11:51:40 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Sat, 28 Nov 2020 11:51:47 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH V2 net-next 1/7] net: hns3: add support for RX completion checksum
Date:   Sat, 28 Nov 2020 11:51:44 +0800
Message-ID: <1606535510-44346-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
References: <1606535510-44346-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases (for example ip fragment), hardware will
calculate the checksum of whole packet in RX, and setup
the HNS3_RXD_L2_CSUM_B flag in the descriptor, so add
support to utilize this checksum.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 21 +++++++++++++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  7 +++++++
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 632ad42..1647877 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2798,6 +2798,22 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	return 0;
 }
 
+static void hns3_checksum_complete(struct hns3_enet_ring *ring,
+				   struct sk_buff *skb, u32 l234info)
+{
+	u32 lo, hi;
+
+	u64_stats_update_begin(&ring->syncp);
+	ring->stats.csum_complete++;
+	u64_stats_update_end(&ring->syncp);
+	skb->ip_summed = CHECKSUM_COMPLETE;
+	lo = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_L_M,
+			     HNS3_RXD_L2_CSUM_L_S);
+	hi = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_H_M,
+			     HNS3_RXD_L2_CSUM_H_S);
+	skb->csum = csum_unfold((__force __sum16)(lo | hi << 8));
+}
+
 static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 			     u32 l234info, u32 bd_base_info, u32 ol_info)
 {
@@ -2812,6 +2828,11 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (!(netdev->features & NETIF_F_RXCSUM))
 		return;
 
+	if (l234info & BIT(HNS3_RXD_L2_CSUM_B)) {
+		hns3_checksum_complete(ring, skb, l234info);
+		return;
+	}
+
 	/* check if hardware has done checksum */
 	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
 		return;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 8d33652..40681a0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -82,6 +82,12 @@ enum hns3_nic_state {
 #define HNS3_RXD_STRP_TAGP_S			13
 #define HNS3_RXD_STRP_TAGP_M			(0x3 << HNS3_RXD_STRP_TAGP_S)
 
+#define HNS3_RXD_L2_CSUM_B			15
+#define HNS3_RXD_L2_CSUM_L_S			4
+#define HNS3_RXD_L2_CSUM_L_M			(0xff << HNS3_RXD_L2_CSUM_L_S)
+#define HNS3_RXD_L2_CSUM_H_S			24
+#define HNS3_RXD_L2_CSUM_H_M			(0xff << HNS3_RXD_L2_CSUM_H_S)
+
 #define HNS3_RXD_L2E_B				16
 #define HNS3_RXD_L3E_B				17
 #define HNS3_RXD_L4E_B				18
@@ -371,6 +377,7 @@ struct ring_stats {
 			u64 err_bd_num;
 			u64 l2_err;
 			u64 l3l4_csum_err;
+			u64 csum_complete;
 			u64 rx_multicast;
 			u64 non_reuse_pg;
 		};
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index c30d5d3..3cca3c1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -55,6 +55,7 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 	HNS3_TQP_STAT("err_bd_num", err_bd_num),
 	HNS3_TQP_STAT("l2_err", l2_err),
 	HNS3_TQP_STAT("l3l4_csum_err", l3l4_csum_err),
+	HNS3_TQP_STAT("csum_complete", csum_complete),
 	HNS3_TQP_STAT("multicast", rx_multicast),
 	HNS3_TQP_STAT("non_reuse_pg", non_reuse_pg),
 };
-- 
2.7.4

