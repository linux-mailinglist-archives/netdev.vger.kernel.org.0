Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2B844C264
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhKJNuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:20 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:27126 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbhKJNuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:16 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hq5h74HgNz1DJGF;
        Wed, 10 Nov 2021 21:45:11 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:25 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/8] net: hns3: sync rx ring head in echo common pull
Date:   Wed, 10 Nov 2021 21:42:52 +0800
Message-ID: <20211110134256.25025-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

When the driver processes rx packets, the head pointer is updated only
after the number of received packets reaches 16. However, hardware
relies on the head pointer to calculate the number of FBDs. As a result,
the hardware calculates the FBD incorrectly. Therefore, the driver
proactively updates the head pointer in each common poll to ensure that
the number of FBDs calculated by the hardware is correct.

Fixes: 68752b24f51a ("net: hns3: schedule the polling again when allocation fails")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  7 ++++
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         |  1 +
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  1 +
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 32 +++++++++++++++++++
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  9 ++++++
 5 files changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index a2b993d62822..9ccebbaa0d69 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -4210,6 +4210,13 @@ int hns3_clean_rx_ring(struct hns3_enet_ring *ring, int budget,
 	}
 
 out:
+	/* sync head pointer before exiting, since hardware will calculate
+	 * FBD number with head pointer
+	 */
+	if (unused_count > 0)
+		failure = failure ||
+			  hns3_nic_alloc_rx_buffers(ring, unused_count);
+
 	return failure ? budget : recv_pkts;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index c327df9dbac4..c5d5466810bb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -483,6 +483,7 @@ static int hclge_firmware_compat_config(struct hclge_dev *hdev, bool en)
 		if (hnae3_dev_phy_imp_supported(hdev))
 			hnae3_set_bit(compat, HCLGE_PHY_IMP_EN_B, 1);
 		hnae3_set_bit(compat, HCLGE_MAC_STATS_EXT_EN_B, 1);
+		hnae3_set_bit(compat, HCLGE_SYNC_RX_RING_HEAD_EN_B, 1);
 
 		req->compat = cpu_to_le32(compat);
 	}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index c38b57fc6c6a..d24e59028798 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1151,6 +1151,7 @@ struct hclge_query_ppu_pf_other_int_dfx_cmd {
 #define HCLGE_NCSI_ERROR_REPORT_EN_B	1
 #define HCLGE_PHY_IMP_EN_B		2
 #define HCLGE_MAC_STATS_EXT_EN_B	3
+#define HCLGE_SYNC_RX_RING_HEAD_EN_B	4
 struct hclge_firmware_compat_cmd {
 	__le32 compat;
 	u8 rsv[20];
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index f89bfb352adf..e605c2c5bcce 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -434,8 +434,28 @@ int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
 	return ret;
 }
 
+static int hclgevf_firmware_compat_config(struct hclgevf_dev *hdev, bool en)
+{
+	struct hclgevf_firmware_compat_cmd *req;
+	struct hclgevf_desc desc;
+	u32 compat = 0;
+
+	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_IMP_COMPAT_CFG, false);
+
+	if (en) {
+		req = (struct hclgevf_firmware_compat_cmd *)desc.data;
+
+		hnae3_set_bit(compat, HCLGEVF_SYNC_RX_RING_HEAD_EN_B, 1);
+
+		req->compat = cpu_to_le32(compat);
+	}
+
+	return hclgevf_cmd_send(&hdev->hw, &desc, 1);
+}
+
 int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 {
+	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
 	int ret;
 
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
@@ -484,6 +504,17 @@ int hclgevf_cmd_init(struct hclgevf_dev *hdev)
 		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
 				 HNAE3_FW_VERSION_BYTE0_SHIFT));
 
+	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3) {
+		/* ask the firmware to enable some features, driver can work
+		 * without it.
+		 */
+		ret = hclgevf_firmware_compat_config(hdev, true);
+		if (ret)
+			dev_warn(&hdev->pdev->dev,
+				 "Firmware compatible features not enabled(%d).\n",
+				 ret);
+	}
+
 	return 0;
 
 err_cmd_init:
@@ -508,6 +539,7 @@ static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
 
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 {
+	hclgevf_firmware_compat_config(hdev, false);
 	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
 	/* wait to ensure that the firmware completes the possible left
 	 * over commands.
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 39d0b589c720..edc9e154061a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -15,6 +15,12 @@
 struct hclgevf_hw;
 struct hclgevf_dev;
 
+#define HCLGEVF_SYNC_RX_RING_HEAD_EN_B	4
+struct hclgevf_firmware_compat_cmd {
+	__le32 compat;
+	u8 rsv[20];
+};
+
 struct hclgevf_desc {
 	__le16 opcode;
 	__le16 flag;
@@ -107,6 +113,9 @@ enum hclgevf_opcode_type {
 	HCLGEVF_OPC_RSS_TC_MODE		= 0x0D08,
 	/* Mailbox cmd */
 	HCLGEVF_OPC_MBX_VF_TO_PF	= 0x2001,
+
+	/* IMP stats command */
+	HCLGEVF_OPC_IMP_COMPAT_CFG	= 0x701A,
 };
 
 #define HCLGEVF_TQP_REG_OFFSET		0x80000
-- 
2.33.0

