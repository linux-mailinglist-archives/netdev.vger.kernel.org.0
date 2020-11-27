Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4F62C6127
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 09:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgK0Irw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 03:47:52 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7742 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgK0Iru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 03:47:50 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cj7Xw30cKzkgwT;
        Fri, 27 Nov 2020 16:47:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 16:47:34 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/7] net: hns3: add more info to hns3_dbg_bd_info()
Date:   Fri, 27 Nov 2020 16:47:20 +0800
Message-ID: <1606466842-57749-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
References: <1606466842-57749-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since TX hardware checksum and RX completion checksum have been
supported now, so add related information in hns3_dbg_bd_info().

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 50 +++++++++++++++++-----
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index cb0cc6d..3b27cab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -179,6 +179,7 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	u32 q_num, value;
 	dma_addr_t addr;
 	u16 mss_hw_csum;
+	u32 l234info;
 	int cnt;
 
 	cnt = sscanf(&cmd_buf[8], "%u %u", &q_num, &tx_index);
@@ -213,17 +214,35 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	dev_info(dev, "(TX)vlan_tag: %u\n", le16_to_cpu(tx_desc->tx.vlan_tag));
 	dev_info(dev, "(TX)send_size: %u\n",
 		 le16_to_cpu(tx_desc->tx.send_size));
-	dev_info(dev, "(TX)vlan_tso: %u\n", tx_desc->tx.type_cs_vlan_tso);
-	dev_info(dev, "(TX)l2_len: %u\n", tx_desc->tx.l2_len);
-	dev_info(dev, "(TX)l3_len: %u\n", tx_desc->tx.l3_len);
-	dev_info(dev, "(TX)l4_len: %u\n", tx_desc->tx.l4_len);
+
+	if (mss_hw_csum & BIT(HNS3_TXD_HW_CS_B)) {
+		u32 offset = le32_to_cpu(tx_desc->tx.ol_type_vlan_len_msec);
+		u32 start = le32_to_cpu(tx_desc->tx.type_cs_vlan_tso_len);
+
+		dev_info(dev, "(TX)csum start: %u\n",
+			 hnae3_get_field(start,
+					 HNS3_TXD_CSUM_START_M,
+					 HNS3_TXD_CSUM_START_S));
+		dev_info(dev, "(TX)csum offset: %u\n",
+			 hnae3_get_field(offset,
+					 HNS3_TXD_CSUM_OFFSET_M,
+					 HNS3_TXD_CSUM_OFFSET_S));
+	} else {
+		dev_info(dev, "(TX)vlan_tso: %u\n",
+			 tx_desc->tx.type_cs_vlan_tso);
+		dev_info(dev, "(TX)l2_len: %u\n", tx_desc->tx.l2_len);
+		dev_info(dev, "(TX)l3_len: %u\n", tx_desc->tx.l3_len);
+		dev_info(dev, "(TX)l4_len: %u\n", tx_desc->tx.l4_len);
+		dev_info(dev, "(TX)vlan_msec: %u\n",
+			 tx_desc->tx.ol_type_vlan_msec);
+		dev_info(dev, "(TX)ol2_len: %u\n", tx_desc->tx.ol2_len);
+		dev_info(dev, "(TX)ol3_len: %u\n", tx_desc->tx.ol3_len);
+		dev_info(dev, "(TX)ol4_len: %u\n", tx_desc->tx.ol4_len);
+	}
+
 	dev_info(dev, "(TX)vlan_tag: %u\n",
 		 le16_to_cpu(tx_desc->tx.outer_vlan_tag));
 	dev_info(dev, "(TX)tv: %u\n", le16_to_cpu(tx_desc->tx.tv));
-	dev_info(dev, "(TX)vlan_msec: %u\n", tx_desc->tx.ol_type_vlan_msec);
-	dev_info(dev, "(TX)ol2_len: %u\n", tx_desc->tx.ol2_len);
-	dev_info(dev, "(TX)ol3_len: %u\n", tx_desc->tx.ol3_len);
-	dev_info(dev, "(TX)ol4_len: %u\n", tx_desc->tx.ol4_len);
 	dev_info(dev, "(TX)paylen_ol4cs: %u\n",
 		 le32_to_cpu(tx_desc->tx.paylen_ol4cs));
 	dev_info(dev, "(TX)vld_ra_ri: %u\n",
@@ -236,10 +255,21 @@ static int hns3_dbg_bd_info(struct hnae3_handle *h, const char *cmd_buf)
 	rx_desc = &ring->desc[rx_index];
 
 	addr = le64_to_cpu(rx_desc->addr);
+	l234info = le32_to_cpu(rx_desc->rx.l234_info);
 	dev_info(dev, "RX Queue Num: %u, BD Index: %u\n", q_num, rx_index);
 	dev_info(dev, "(RX)addr: %pad\n", &addr);
-	dev_info(dev, "(RX)l234_info: %u\n",
-		 le32_to_cpu(rx_desc->rx.l234_info));
+	dev_info(dev, "(RX)l234_info: %u\n", l234info);
+
+	if (l234info & BIT(HNS3_RXD_L2_CSUM_B)) {
+		__sum16 csum;
+
+		csum = hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_L_M,
+				       HNS3_RXD_L2_CSUM_L_S);
+		csum |= hnae3_get_field(l234info, HNS3_RXD_L2_CSUM_H_M,
+					HNS3_RXD_L2_CSUM_H_S) << 8;
+		dev_info(dev, "(RX)csum: %u\n", csum);
+	}
+
 	dev_info(dev, "(RX)pkt_len: %u\n", le16_to_cpu(rx_desc->rx.pkt_len));
 	dev_info(dev, "(RX)size: %u\n", le16_to_cpu(rx_desc->rx.size));
 	dev_info(dev, "(RX)rss_hash: %u\n", le32_to_cpu(rx_desc->rx.rss_hash));
-- 
2.7.4

