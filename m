Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B6F48233E
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhLaKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:20:07 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30131 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhLaKT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:19:59 -0500
Received: from kwepemi100001.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JQLdw5VNCz1DKPD;
        Fri, 31 Dec 2021 18:16:36 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100001.china.huawei.com (7.221.188.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 09/10] net: hns3: refactor VF cmdq init and uninit APIs with new common APIs
Date:   Fri, 31 Dec 2021 18:14:58 +0800
Message-ID: <20211231101459.56083-10-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231101459.56083-1-huangguangbin2@huawei.com>
References: <20211231101459.56083-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

This patch uses common cmdq init and uninit APIs to replace the old APIs in
VF cmdq module init and uninit module. Then the old VF init and uninit
APIs is deleted.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.c       | 134 +-----------------
 .../hisilicon/hns3/hns3vf/hclgevf_cmd.h       |  25 +---
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  58 ++++----
 .../hisilicon/hns3/hns3vf/hclgevf_main.h      |  19 ---
 .../hisilicon/hns3/hns3vf/hclgevf_mbx.c       |   4 +-
 5 files changed, 36 insertions(+), 204 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 9e0d900d2fb5..fc9dc506cfd2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -24,147 +24,15 @@ int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num)
 	return hclge_comm_cmd_send(&hw->hw, desc, num, false);
 }
 
-int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev)
+void hclgevf_arq_init(struct hclgevf_dev *hdev)
 {
 	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-	int ret;
 
-	/* Setup the lock for command queue */
-	spin_lock_init(&cmdq->csq.lock);
-	spin_lock_init(&cmdq->crq.lock);
-
-	cmdq->csq.pdev = hdev->pdev;
-	cmdq->crq.pdev = hdev->pdev;
-	cmdq->tx_timeout = HCLGEVF_CMDQ_TX_TIMEOUT;
-	cmdq->csq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
-	cmdq->crq.desc_num = HCLGEVF_NIC_CMQ_DESC_NUM;
-
-	ret = hclge_comm_alloc_cmd_queue(&hdev->hw.hw, HCLGE_COMM_TYPE_CSQ);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"CSQ ring setup error %d\n", ret);
-		return ret;
-	}
-
-	ret = hclge_comm_alloc_cmd_queue(&hdev->hw.hw, HCLGE_COMM_TYPE_CRQ);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"CRQ ring setup error %d\n", ret);
-		goto err_csq;
-	}
-
-	return 0;
-err_csq:
-	hclge_comm_free_cmd_desc(&cmdq->csq);
-	return ret;
-}
-
-int hclgevf_cmd_init(struct hclgevf_dev *hdev)
-{
-	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(hdev->pdev);
-	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-	int ret;
-
-	spin_lock_bh(&cmdq->csq.lock);
 	spin_lock(&cmdq->crq.lock);
-
 	/* initialize the pointers of async rx queue of mailbox */
 	hdev->arq.hdev = hdev;
 	hdev->arq.head = 0;
 	hdev->arq.tail = 0;
 	atomic_set(&hdev->arq.count, 0);
-	cmdq->csq.next_to_clean = 0;
-	cmdq->csq.next_to_use = 0;
-	cmdq->crq.next_to_clean = 0;
-	cmdq->crq.next_to_use = 0;
-
-	hclge_comm_cmd_init_regs(&hdev->hw.hw);
-
 	spin_unlock(&cmdq->crq.lock);
-	spin_unlock_bh(&cmdq->csq.lock);
-
-	clear_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-
-	/* Check if there is new reset pending, because the higher level
-	 * reset may happen when lower level reset is being processed.
-	 */
-	if (hclgevf_is_reset_pending(hdev)) {
-		ret = -EBUSY;
-		goto err_cmd_init;
-	}
-
-	/* get version and device capabilities */
-	ret = hclge_comm_cmd_query_version_and_capability(hdev->ae_dev,
-							  &hdev->hw.hw,
-							  &hdev->fw_version,
-							  false);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to query version and capabilities, ret = %d\n", ret);
-		goto err_cmd_init;
-	}
-
-	dev_info(&hdev->pdev->dev, "The firmware version is %lu.%lu.%lu.%lu\n",
-		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
-				 HNAE3_FW_VERSION_BYTE3_SHIFT),
-		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE2_MASK,
-				 HNAE3_FW_VERSION_BYTE2_SHIFT),
-		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE1_MASK,
-				 HNAE3_FW_VERSION_BYTE1_SHIFT),
-		 hnae3_get_field(hdev->fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
-				 HNAE3_FW_VERSION_BYTE0_SHIFT));
-
-	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V3) {
-		/* ask the firmware to enable some features, driver can work
-		 * without it.
-		 */
-		ret = hclge_comm_firmware_compat_config(hdev->ae_dev, false,
-							&hdev->hw.hw, true);
-		if (ret)
-			dev_warn(&hdev->pdev->dev,
-				 "Firmware compatible features not enabled(%d).\n",
-				 ret);
-	}
-
-	return 0;
-
-err_cmd_init:
-	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-
-	return ret;
-}
-
-static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
-{
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_L_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_BASEADDR_H_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_DEPTH_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_HEAD_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CSQ_TAIL_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_L_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_BASEADDR_H_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_DEPTH_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_HEAD_REG, 0);
-	hclgevf_write_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG, 0);
-}
-
-void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
-{
-	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-	hclge_comm_firmware_compat_config(hdev->ae_dev, false, &hdev->hw.hw,
-					  false);
-	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-
-	/* wait to ensure that the firmware completes the possible left
-	 * over commands.
-	 */
-	msleep(HCLGEVF_CMDQ_CLEAR_WAIT_TIME);
-	spin_lock_bh(&cmdq->csq.lock);
-	spin_lock(&cmdq->crq.lock);
-	hclgevf_cmd_uninit_regs(&hdev->hw);
-	spin_unlock(&cmdq->crq.lock);
-	spin_unlock_bh(&cmdq->csq.lock);
-
-	hclge_comm_free_cmd_desc(&cmdq->csq);
-	hclge_comm_free_cmd_desc(&cmdq->crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index 1ed70849bf63..ab8329e7d2bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -8,8 +8,6 @@
 #include "hnae3.h"
 #include "hclge_comm_cmd.h"
 
-#define HCLGEVF_CMDQ_TX_TIMEOUT		30000
-#define HCLGEVF_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGEVF_CMDQ_RX_INVLD_B		0
 #define HCLGEVF_CMDQ_RX_OUTVLD_B	1
 
@@ -17,24 +15,6 @@ struct hclgevf_hw;
 struct hclgevf_dev;
 
 #define HCLGEVF_SYNC_RX_RING_HEAD_EN_B	4
-struct hclgevf_firmware_compat_cmd {
-	__le32 compat;
-	u8 rsv[20];
-};
-
-#define HCLGEVF_CMD_FLAG_IN_VALID_SHIFT		0
-#define HCLGEVF_CMD_FLAG_OUT_VALID_SHIFT	1
-#define HCLGEVF_CMD_FLAG_NEXT_SHIFT		2
-#define HCLGEVF_CMD_FLAG_WR_OR_RD_SHIFT		3
-#define HCLGEVF_CMD_FLAG_NO_INTR_SHIFT		4
-#define HCLGEVF_CMD_FLAG_ERR_INTR_SHIFT		5
-
-#define HCLGEVF_CMD_FLAG_IN		BIT(HCLGEVF_CMD_FLAG_IN_VALID_SHIFT)
-#define HCLGEVF_CMD_FLAG_OUT		BIT(HCLGEVF_CMD_FLAG_OUT_VALID_SHIFT)
-#define HCLGEVF_CMD_FLAG_NEXT		BIT(HCLGEVF_CMD_FLAG_NEXT_SHIFT)
-#define HCLGEVF_CMD_FLAG_WR		BIT(HCLGEVF_CMD_FLAG_WR_OR_RD_SHIFT)
-#define HCLGEVF_CMD_FLAG_NO_INTR	BIT(HCLGEVF_CMD_FLAG_NO_INTR_SHIFT)
-#define HCLGEVF_CMD_FLAG_ERR_INTR	BIT(HCLGEVF_CMD_FLAG_ERR_INTR_SHIFT)
 
 enum hclgevf_opcode_type {
 	/* Generic command */
@@ -220,9 +200,6 @@ struct hclgevf_dev_specs_1_cmd {
 	u8 rsv1[18];
 };
 
-int hclgevf_cmd_init(struct hclgevf_dev *hdev);
-void hclgevf_cmd_uninit(struct hclgevf_dev *hdev);
-int hclgevf_cmd_queue_init(struct hclgevf_dev *hdev);
-
 int hclgevf_cmd_send(struct hclgevf_hw *hw, struct hclge_desc *desc, int num);
+void hclgevf_arq_init(struct hclgevf_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 30eafb6251c6..2889c75195c5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -40,20 +40,20 @@ static const u8 hclgevf_hash_key[] = {
 
 MODULE_DEVICE_TABLE(pci, ae_algovf_pci_tbl);
 
-static const u32 cmdq_reg_addr_list[] = {HCLGEVF_NIC_CSQ_BASEADDR_L_REG,
-					 HCLGEVF_NIC_CSQ_BASEADDR_H_REG,
-					 HCLGEVF_NIC_CSQ_DEPTH_REG,
-					 HCLGEVF_NIC_CSQ_TAIL_REG,
-					 HCLGEVF_NIC_CSQ_HEAD_REG,
-					 HCLGEVF_NIC_CRQ_BASEADDR_L_REG,
-					 HCLGEVF_NIC_CRQ_BASEADDR_H_REG,
-					 HCLGEVF_NIC_CRQ_DEPTH_REG,
-					 HCLGEVF_NIC_CRQ_TAIL_REG,
-					 HCLGEVF_NIC_CRQ_HEAD_REG,
-					 HCLGEVF_VECTOR0_CMDQ_SRC_REG,
-					 HCLGEVF_VECTOR0_CMDQ_STATE_REG,
-					 HCLGEVF_CMDQ_INTR_EN_REG,
-					 HCLGEVF_CMDQ_INTR_GEN_REG};
+static const u32 cmdq_reg_addr_list[] = {HCLGE_COMM_NIC_CSQ_BASEADDR_L_REG,
+					 HCLGE_COMM_NIC_CSQ_BASEADDR_H_REG,
+					 HCLGE_COMM_NIC_CSQ_DEPTH_REG,
+					 HCLGE_COMM_NIC_CSQ_TAIL_REG,
+					 HCLGE_COMM_NIC_CSQ_HEAD_REG,
+					 HCLGE_COMM_NIC_CRQ_BASEADDR_L_REG,
+					 HCLGE_COMM_NIC_CRQ_BASEADDR_H_REG,
+					 HCLGE_COMM_NIC_CRQ_DEPTH_REG,
+					 HCLGE_COMM_NIC_CRQ_TAIL_REG,
+					 HCLGE_COMM_NIC_CRQ_HEAD_REG,
+					 HCLGE_COMM_VECTOR0_CMDQ_SRC_REG,
+					 HCLGE_COMM_VECTOR0_CMDQ_STATE_REG,
+					 HCLGE_COMM_CMDQ_INTR_EN_REG,
+					 HCLGE_COMM_CMDQ_INTR_GEN_REG};
 
 static const u32 common_reg_addr_list[] = {HCLGEVF_MISC_VECTOR_REG_BASE,
 					   HCLGEVF_RST_ING,
@@ -1894,13 +1894,13 @@ static void hclgevf_reset_handshake(struct hclgevf_dev *hdev, bool enable)
 {
 	u32 reg_val;
 
-	reg_val = hclgevf_read_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG);
+	reg_val = hclgevf_read_dev(&hdev->hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG);
 	if (enable)
 		reg_val |= HCLGEVF_NIC_SW_RST_RDY;
 	else
 		reg_val &= ~HCLGEVF_NIC_SW_RST_RDY;
 
-	hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG,
+	hclgevf_write_dev(&hdev->hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG,
 			  reg_val);
 }
 
@@ -1980,9 +1980,9 @@ static void hclgevf_dump_rst_info(struct hclgevf_dev *hdev)
 	dev_info(&hdev->pdev->dev, "vector0 interrupt enable status: 0x%x\n",
 		 hclgevf_read_dev(&hdev->hw, HCLGEVF_MISC_VECTOR_REG_BASE));
 	dev_info(&hdev->pdev->dev, "vector0 interrupt status: 0x%x\n",
-		 hclgevf_read_dev(&hdev->hw, HCLGEVF_VECTOR0_CMDQ_STATE_REG));
+		 hclgevf_read_dev(&hdev->hw, HCLGE_COMM_VECTOR0_CMDQ_STATE_REG));
 	dev_info(&hdev->pdev->dev, "handshake status: 0x%x\n",
-		 hclgevf_read_dev(&hdev->hw, HCLGEVF_NIC_CSQ_DEPTH_REG));
+		 hclgevf_read_dev(&hdev->hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG));
 	dev_info(&hdev->pdev->dev, "function reset status: 0x%x\n",
 		 hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING));
 	dev_info(&hdev->pdev->dev, "hdev state: 0x%lx\n", hdev->state);
@@ -2418,7 +2418,7 @@ static void hclgevf_service_task(struct work_struct *work)
 
 static void hclgevf_clear_event_cause(struct hclgevf_dev *hdev, u32 regclr)
 {
-	hclgevf_write_dev(&hdev->hw, HCLGEVF_VECTOR0_CMDQ_SRC_REG, regclr);
+	hclgevf_write_dev(&hdev->hw, HCLGE_COMM_VECTOR0_CMDQ_SRC_REG, regclr);
 }
 
 static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
@@ -2428,7 +2428,7 @@ static enum hclgevf_evt_cause hclgevf_check_evt_cause(struct hclgevf_dev *hdev,
 
 	/* fetch the events from their corresponding regs */
 	cmdq_stat_reg = hclgevf_read_dev(&hdev->hw,
-					 HCLGEVF_VECTOR0_CMDQ_STATE_REG);
+					 HCLGE_COMM_VECTOR0_CMDQ_STATE_REG);
 	if (BIT(HCLGEVF_VECTOR0_RST_INT_B) & cmdq_stat_reg) {
 		rst_ing_reg = hclgevf_read_dev(&hdev->hw, HCLGEVF_RST_ING);
 		dev_info(&hdev->pdev->dev,
@@ -3234,7 +3234,7 @@ static int hclgevf_query_dev_specs(struct hclgevf_dev *hdev)
 	for (i = 0; i < HCLGEVF_QUERY_DEV_SPECS_BD_NUM - 1; i++) {
 		hclgevf_cmd_setup_basic_desc(&desc[i],
 					     HCLGEVF_OPC_QUERY_DEV_SPECS, true);
-		desc[i].flag |= cpu_to_le16(HCLGEVF_CMD_FLAG_NEXT);
+		desc[i].flag |= cpu_to_le16(HCLGE_COMM_CMD_FLAG_NEXT);
 	}
 	hclgevf_cmd_setup_basic_desc(&desc[i], HCLGEVF_OPC_QUERY_DEV_SPECS,
 				     true);
@@ -3316,7 +3316,10 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
-	ret = hclgevf_cmd_init(hdev);
+	hclgevf_arq_init(hdev);
+	ret = hclge_comm_cmd_init(hdev->ae_dev, &hdev->hw.hw,
+				  &hdev->fw_version, false,
+				  hdev->reset_pending);
 	if (ret) {
 		dev_err(&pdev->dev, "cmd failed %d\n", ret);
 		return ret;
@@ -3362,11 +3365,14 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	if (ret)
 		goto err_devlink_init;
 
-	ret = hclgevf_cmd_queue_init(hdev);
+	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
 		goto err_cmd_queue_init;
 
-	ret = hclgevf_cmd_init(hdev);
+	hclgevf_arq_init(hdev);
+	ret = hclge_comm_cmd_init(hdev->ae_dev, &hdev->hw.hw,
+				  &hdev->fw_version, false,
+				  hdev->reset_pending);
 	if (ret)
 		goto err_cmd_init;
 
@@ -3466,7 +3472,7 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	hclgevf_state_uninit(hdev);
 	hclgevf_uninit_msi(hdev);
 err_cmd_init:
-	hclgevf_cmd_uninit(hdev);
+	hclge_comm_cmd_uninit(hdev->ae_dev, false, &hdev->hw.hw);
 err_cmd_queue_init:
 	hclgevf_devlink_uninit(hdev);
 err_devlink_init:
@@ -3490,7 +3496,7 @@ static void hclgevf_uninit_hdev(struct hclgevf_dev *hdev)
 		hclgevf_uninit_msi(hdev);
 	}
 
-	hclgevf_cmd_uninit(hdev);
+	hclge_comm_cmd_uninit(hdev->ae_dev, false, &hdev->hw.hw);
 	hclgevf_devlink_uninit(hdev);
 	hclgevf_pci_uninit(hdev);
 	hclgevf_uninit_mac_list(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index ae90925c4f4b..20db6edab306 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -32,21 +32,6 @@
 #define HCLGEVF_VECTOR_REG_OFFSET	0x4
 #define HCLGEVF_VECTOR_VF_OFFSET		0x100000
 
-/* bar registers for cmdq */
-#define HCLGEVF_NIC_CSQ_BASEADDR_L_REG		0x27000
-#define HCLGEVF_NIC_CSQ_BASEADDR_H_REG		0x27004
-#define HCLGEVF_NIC_CSQ_DEPTH_REG		0x27008
-#define HCLGEVF_NIC_CSQ_TAIL_REG		0x27010
-#define HCLGEVF_NIC_CSQ_HEAD_REG		0x27014
-#define HCLGEVF_NIC_CRQ_BASEADDR_L_REG		0x27018
-#define HCLGEVF_NIC_CRQ_BASEADDR_H_REG		0x2701C
-#define HCLGEVF_NIC_CRQ_DEPTH_REG		0x27020
-#define HCLGEVF_NIC_CRQ_TAIL_REG		0x27024
-#define HCLGEVF_NIC_CRQ_HEAD_REG		0x27028
-
-#define HCLGEVF_CMDQ_INTR_EN_REG		0x27108
-#define HCLGEVF_CMDQ_INTR_GEN_REG		0x2710C
-
 /* bar registers for common func */
 #define HCLGEVF_GRO_EN_REG			0x28000
 #define HCLGEVF_RXD_ADV_LAYOUT_EN_REG		0x28008
@@ -86,10 +71,6 @@
 #define HCLGEVF_TQP_INTR_GL2_REG		0x20300
 #define HCLGEVF_TQP_INTR_RL_REG			0x20900
 
-/* Vector0 interrupt CMDQ event source register(RW) */
-#define HCLGEVF_VECTOR0_CMDQ_SRC_REG	0x27100
-/* Vector0 interrupt CMDQ event status register(RO) */
-#define HCLGEVF_VECTOR0_CMDQ_STATE_REG	0x27104
 /* CMDQ register bits for RX event(=MBX event) */
 #define HCLGEVF_VECTOR0_RX_CMDQ_INT_B	1
 /* RST register bits for RESET event */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index a1040bab9a10..d5e0a3f762f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -152,7 +152,7 @@ int hclgevf_send_mbx_msg(struct hclgevf_dev *hdev,
 
 static bool hclgevf_cmd_crq_empty(struct hclgevf_hw *hw)
 {
-	u32 tail = hclgevf_read_dev(hw, HCLGEVF_NIC_CRQ_TAIL_REG);
+	u32 tail = hclgevf_read_dev(hw, HCLGE_COMM_NIC_CRQ_TAIL_REG);
 
 	return tail == hw->hw.cmq.crq.next_to_use;
 }
@@ -271,7 +271,7 @@ void hclgevf_mbx_handler(struct hclgevf_dev *hdev)
 	}
 
 	/* Write back CMDQ_RQ header pointer, M7 need this pointer */
-	hclgevf_write_dev(&hdev->hw, HCLGEVF_NIC_CRQ_HEAD_REG,
+	hclgevf_write_dev(&hdev->hw, HCLGE_COMM_NIC_CRQ_HEAD_REG,
 			  crq->next_to_use);
 }
 
-- 
2.33.0

