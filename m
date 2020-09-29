Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5140827C159
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgI2JfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:35:05 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14713 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728054AbgI2Je5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 05:34:57 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A71B77B768E2B691996D;
        Tue, 29 Sep 2020 17:34:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:34:45 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 7/7] net: hns3: dump tqp enable status in debugfs
Date:   Tue, 29 Sep 2020 17:32:05 +0800
Message-ID: <1601371925-49426-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
References: <1601371925-49426-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guangbin Huang <huangguangbin2@huawei.com>

Adds debugfs to dump tqp enable status.

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |  3 +++
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 22 ++++++++++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |  2 ++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index f6d0702..912c51e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -130,6 +130,9 @@ enum HNAE3_DEV_CAP_BITS {
 #define hnae3_dev_stash_supported(hdev) \
 	test_bit(HNAE3_DEV_SUPPORT_STASH_B, (hdev)->ae_dev->caps)
 
+#define hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev) \
+	test_bit(HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B, (ae_dev)->caps)
+
 #define ring_ptr_move_fw(ring, p) \
 	((ring)->p = ((ring)->p + 1) % (ring)->desc_num)
 #define ring_ptr_move_bw(ring, p) \
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index d6f8817..dc9a857 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -15,6 +15,7 @@ static struct dentry *hns3_dbgfs_root;
 static int hns3_dbg_queue_info(struct hnae3_handle *h,
 			       const char *cmd_buf)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
 	struct hns3_nic_priv *priv = h->priv;
 	struct hns3_enet_ring *ring;
 	u32 base_add_l, base_add_h;
@@ -118,8 +119,25 @@ static int hns3_dbg_queue_info(struct hnae3_handle *h,
 
 		value = readl_relaxed(ring->tqp->io_base +
 				      HNS3_RING_TX_RING_PKTNUM_RECORD_REG);
-		dev_info(&h->pdev->dev, "TX(%u) RING PKTNUM: %u\n\n", i,
-			 value);
+		dev_info(&h->pdev->dev, "TX(%u) RING PKTNUM: %u\n", i, value);
+
+		value = readl_relaxed(ring->tqp->io_base + HNS3_RING_EN_REG);
+		dev_info(&h->pdev->dev, "TX/RX(%u) RING EN: %s\n", i,
+			 value ? "enable" : "disable");
+
+		if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev)) {
+			value = readl_relaxed(ring->tqp->io_base +
+					      HNS3_RING_TX_EN_REG);
+			dev_info(&h->pdev->dev, "TX(%u) RING EN: %s\n", i,
+				 value ? "enable" : "disable");
+
+			value = readl_relaxed(ring->tqp->io_base +
+					      HNS3_RING_RX_EN_REG);
+			dev_info(&h->pdev->dev, "RX(%u) RING EN: %s\n", i,
+				 value ? "enable" : "disable");
+		}
+
+		dev_info(&h->pdev->dev, "\n");
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 35b0375..1c81dea 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -43,6 +43,8 @@ enum hns3_nic_state {
 #define HNS3_RING_TX_RING_EBD_OFFSET_REG	0x00070
 #define HNS3_RING_TX_RING_BD_ERR_REG		0x00074
 #define HNS3_RING_EN_REG			0x00090
+#define HNS3_RING_RX_EN_REG			0x00098
+#define HNS3_RING_TX_EN_REG			0x000D4
 
 #define HNS3_RX_HEAD_SIZE			256
 
-- 
2.7.4

