Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD393482341
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhLaKUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:20:09 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:31132 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhLaKT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:19:59 -0500
Received: from kwepemi100005.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JQLfv0TmTz8wB2;
        Fri, 31 Dec 2021 18:17:27 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100005.china.huawei.com (7.221.188.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:19:56 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 08/10] net: hns3: refactor PF cmdq init and uninit APIs with new common APIs
Date:   Fri, 31 Dec 2021 18:14:57 +0800
Message-ID: <20211231101459.56083-9-huangguangbin2@huawei.com>
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
PF cmdq module init and uninit modules. Then the old PF init and uninit
APIs is deleted.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 149 ------------------
 .../hisilicon/hns3/hns3pf/hclge_cmd.h         |  11 --
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  46 +++---
 .../hisilicon/hns3/hns3pf/hclge_main.h        |  13 --
 .../hisilicon/hns3/hns3pf/hclge_mbx.c         |   5 +-
 5 files changed, 27 insertions(+), 197 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 0f4b934c0683..6a066d3ac86e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -24,152 +24,3 @@ int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num)
 {
 	return hclge_comm_cmd_send(&hw->hw, desc, num, true);
 }
-
-int hclge_cmd_queue_init(struct hclge_dev *hdev)
-{
-	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-	int ret;
-
-	/* Setup the lock for command queue */
-	spin_lock_init(&cmdq->csq.lock);
-	spin_lock_init(&cmdq->crq.lock);
-
-	cmdq->csq.pdev = hdev->pdev;
-	cmdq->crq.pdev = hdev->pdev;
-
-	/* Setup the queue entries for use cmd queue */
-	cmdq->csq.desc_num = HCLGE_NIC_CMQ_DESC_NUM;
-	cmdq->crq.desc_num = HCLGE_NIC_CMQ_DESC_NUM;
-
-	/* Setup Tx write back timeout */
-	cmdq->tx_timeout = HCLGE_CMDQ_TX_TIMEOUT;
-
-	/* Setup queue rings */
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
-	hclge_comm_free_cmd_desc(&hdev->hw.hw.cmq.csq);
-	return ret;
-}
-
-int hclge_cmd_init(struct hclge_dev *hdev)
-{
-	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-	int ret;
-
-	spin_lock_bh(&cmdq->csq.lock);
-	spin_lock(&cmdq->crq.lock);
-
-	cmdq->csq.next_to_clean = 0;
-	cmdq->csq.next_to_use = 0;
-	cmdq->crq.next_to_clean = 0;
-	cmdq->crq.next_to_use = 0;
-
-	hclge_comm_cmd_init_regs(&hdev->hw.hw);
-
-	spin_unlock(&cmdq->crq.lock);
-	spin_unlock_bh(&cmdq->csq.lock);
-
-	clear_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-
-	/* Check if there is new reset pending, because the higher level
-	 * reset may happen when lower level reset is being processed.
-	 */
-	if ((hclge_is_reset_pending(hdev))) {
-		dev_err(&hdev->pdev->dev,
-			"failed to init cmd since reset %#lx pending\n",
-			hdev->reset_pending);
-		ret = -EBUSY;
-		goto err_cmd_init;
-	}
-
-	/* get version and device capabilities */
-	ret = hclge_comm_cmd_query_version_and_capability(hdev->ae_dev,
-							  &hdev->hw.hw,
-							  &hdev->fw_version,
-							  true);
-	if (ret) {
-		dev_err(&hdev->pdev->dev,
-			"failed to query version and capabilities, ret = %d\n",
-			ret);
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
-	/* ask the firmware to enable some features, driver can work without
-	 * it.
-	 */
-	ret = hclge_comm_firmware_compat_config(hdev->ae_dev, true,
-						&hdev->hw.hw, true);
-	if (ret)
-		dev_warn(&hdev->pdev->dev,
-			 "Firmware compatible features not enabled(%d).\n",
-			 ret);
-
-	return 0;
-
-err_cmd_init:
-	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-
-	return ret;
-}
-
-static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
-{
-	hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_L_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CSQ_BASEADDR_H_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CSQ_DEPTH_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CSQ_HEAD_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CSQ_TAIL_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CRQ_BASEADDR_L_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CRQ_BASEADDR_H_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CRQ_DEPTH_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CRQ_HEAD_REG, 0);
-	hclge_write_dev(hw, HCLGE_NIC_CRQ_TAIL_REG, 0);
-}
-
-void hclge_cmd_uninit(struct hclge_dev *hdev)
-{
-	struct hclge_comm_cmq *cmdq = &hdev->hw.hw.cmq;
-
-	cmdq->csq.pdev = hdev->pdev;
-
-	hclge_comm_firmware_compat_config(hdev->ae_dev, true, &hdev->hw.hw,
-					  false);
-
-	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
-	/* wait to ensure that the firmware completes the possible left
-	 * over commands.
-	 */
-	msleep(HCLGE_CMDQ_CLEAR_WAIT_TIME);
-	spin_lock_bh(&cmdq->csq.lock);
-	spin_lock(&cmdq->crq.lock);
-	hclge_cmd_uninit_regs(&hdev->hw);
-	spin_unlock(&cmdq->crq.lock);
-	spin_unlock_bh(&cmdq->csq.lock);
-
-	hclge_comm_free_cmd_desc(&cmdq->csq);
-	hclge_comm_free_cmd_desc(&cmdq->crq);
-}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index b239b5bde1de..ac0f2f17275b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -9,9 +9,6 @@
 #include "hnae3.h"
 #include "hclge_comm_cmd.h"
 
-#define HCLGE_CMDQ_TX_TIMEOUT		30000
-#define HCLGE_CMDQ_CLEAR_WAIT_TIME	200
-
 struct hclge_dev;
 
 #define HCLGE_CMDQ_RX_INVLD_B		0
@@ -928,9 +925,6 @@ struct hclge_common_lb_cmd {
 #define HCLGE_DEFAULT_NON_DCB_DV	0x7800	/* 30K byte */
 #define HCLGE_NON_DCB_ADDITIONAL_BUF	0x1400	/* 5120 byte */
 
-#define HCLGE_NIC_CMQ_DESC_NUM		1024
-#define HCLGE_NIC_CMQ_DESC_NUM_S	3
-
 #define HCLGE_LED_LOCATE_STATE_S	0
 #define HCLGE_LED_LOCATE_STATE_M	GENMASK(1, 0)
 
@@ -1135,15 +1129,10 @@ struct hclge_phy_reg_cmd {
 	u8 rsv1[18];
 };
 
-int hclge_cmd_init(struct hclge_dev *hdev);
-
 struct hclge_hw;
 int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num);
 enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
 						struct hclge_desc *desc);
 enum hclge_comm_cmd_status hclge_cmd_mdio_read(struct hclge_hw *hw,
 					       struct hclge_desc *desc);
-
-void hclge_cmd_uninit(struct hclge_dev *hdev);
-int hclge_cmd_queue_init(struct hclge_dev *hdev);
 #endif
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 068d0adaab68..9eab97f804c8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -91,20 +91,20 @@ static const struct pci_device_id ae_algo_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, ae_algo_pci_tbl);
 
-static const u32 cmdq_reg_addr_list[] = {HCLGE_NIC_CSQ_BASEADDR_L_REG,
-					 HCLGE_NIC_CSQ_BASEADDR_H_REG,
-					 HCLGE_NIC_CSQ_DEPTH_REG,
-					 HCLGE_NIC_CSQ_TAIL_REG,
-					 HCLGE_NIC_CSQ_HEAD_REG,
-					 HCLGE_NIC_CRQ_BASEADDR_L_REG,
-					 HCLGE_NIC_CRQ_BASEADDR_H_REG,
-					 HCLGE_NIC_CRQ_DEPTH_REG,
-					 HCLGE_NIC_CRQ_TAIL_REG,
-					 HCLGE_NIC_CRQ_HEAD_REG,
-					 HCLGE_VECTOR0_CMDQ_SRC_REG,
-					 HCLGE_CMDQ_INTR_STS_REG,
-					 HCLGE_CMDQ_INTR_EN_REG,
-					 HCLGE_CMDQ_INTR_GEN_REG};
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
+					 HCLGE_COMM_CMDQ_INTR_STS_REG,
+					 HCLGE_COMM_CMDQ_INTR_EN_REG,
+					 HCLGE_COMM_CMDQ_INTR_GEN_REG};
 
 static const u32 common_reg_addr_list[] = {HCLGE_MISC_VECTOR_REG_BASE,
 					   HCLGE_PF_OTHER_INT_REG,
@@ -4032,13 +4032,13 @@ static void hclge_reset_handshake(struct hclge_dev *hdev, bool enable)
 {
 	u32 reg_val;
 
-	reg_val = hclge_read_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG);
+	reg_val = hclge_read_dev(&hdev->hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG);
 	if (enable)
 		reg_val |= HCLGE_COMM_NIC_SW_RST_RDY;
 	else
 		reg_val &= ~HCLGE_COMM_NIC_SW_RST_RDY;
 
-	hclge_write_dev(&hdev->hw, HCLGE_NIC_CSQ_DEPTH_REG, reg_val);
+	hclge_write_dev(&hdev->hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG, reg_val);
 }
 
 static int hclge_func_reset_notify_vf(struct hclge_dev *hdev)
@@ -4075,7 +4075,7 @@ static int hclge_reset_prepare_wait(struct hclge_dev *hdev)
 		/* After performaning pf reset, it is not necessary to do the
 		 * mailbox handling or send any command to firmware, because
 		 * any mailbox handling or command to firmware is only valid
-		 * after hclge_cmd_init is called.
+		 * after hclge_comm_cmd_init is called.
 		 */
 		set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state);
 		hdev->rst_stats.pf_rst_cnt++;
@@ -11775,12 +11775,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_pci_uninit;
 
 	/* Firmware command queue initialize */
-	ret = hclge_cmd_queue_init(hdev);
+	ret = hclge_comm_cmd_queue_init(hdev->pdev, &hdev->hw.hw);
 	if (ret)
 		goto err_devlink_uninit;
 
 	/* Firmware command initialize */
-	ret = hclge_cmd_init(hdev);
+	ret = hclge_comm_cmd_init(hdev->ae_dev, &hdev->hw.hw, &hdev->fw_version,
+				  true, hdev->reset_pending);
 	if (ret)
 		goto err_cmd_uninit;
 
@@ -11953,7 +11954,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 err_msi_uninit:
 	pci_free_irq_vectors(pdev);
 err_cmd_uninit:
-	hclge_cmd_uninit(hdev);
+	hclge_comm_cmd_uninit(hdev->ae_dev, true, &hdev->hw.hw);
 err_devlink_uninit:
 	hclge_devlink_uninit(hdev);
 err_pci_uninit:
@@ -12204,7 +12205,8 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
 		hclge_reset_umv_space(hdev);
 	}
 
-	ret = hclge_cmd_init(hdev);
+	ret = hclge_comm_cmd_init(hdev->ae_dev, &hdev->hw.hw, &hdev->fw_version,
+				  true, hdev->reset_pending);
 	if (ret) {
 		dev_err(&pdev->dev, "Cmd queue init failed\n");
 		return ret;
@@ -12344,7 +12346,7 @@ static void hclge_uninit_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_config_nic_hw_error(hdev, false);
 	hclge_config_rocee_ras_interrupt(hdev, false);
 
-	hclge_cmd_uninit(hdev);
+	hclge_comm_cmd_uninit(hdev->ae_dev, true, &hdev->hw.hw);
 	hclge_misc_irq_uninit(hdev);
 	hclge_devlink_uninit(hdev);
 	hclge_pci_uninit(hdev);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 531dec523671..9764094aadec 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -38,20 +38,7 @@
 #define HCLGE_VECTOR_REG_OFFSET_H	0x1000
 #define HCLGE_VECTOR_VF_OFFSET		0x100000
 
-#define HCLGE_NIC_CSQ_BASEADDR_L_REG	0x27000
-#define HCLGE_NIC_CSQ_BASEADDR_H_REG	0x27004
 #define HCLGE_NIC_CSQ_DEPTH_REG		0x27008
-#define HCLGE_NIC_CSQ_TAIL_REG		0x27010
-#define HCLGE_NIC_CSQ_HEAD_REG		0x27014
-#define HCLGE_NIC_CRQ_BASEADDR_L_REG	0x27018
-#define HCLGE_NIC_CRQ_BASEADDR_H_REG	0x2701C
-#define HCLGE_NIC_CRQ_DEPTH_REG		0x27020
-#define HCLGE_NIC_CRQ_TAIL_REG		0x27024
-#define HCLGE_NIC_CRQ_HEAD_REG		0x27028
-
-#define HCLGE_CMDQ_INTR_STS_REG		0x27104
-#define HCLGE_CMDQ_INTR_EN_REG		0x27108
-#define HCLGE_CMDQ_INTR_GEN_REG		0x2710C
 
 /* bar registers for common func */
 #define HCLGE_GRO_EN_REG		0x28000
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 908351234238..db13033b60f4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -661,7 +661,7 @@ static void hclge_handle_link_change_event(struct hclge_dev *hdev,
 
 static bool hclge_cmd_crq_empty(struct hclge_hw *hw)
 {
-	u32 tail = hclge_read_dev(hw, HCLGE_NIC_CRQ_TAIL_REG);
+	u32 tail = hclge_read_dev(hw, HCLGE_COMM_NIC_CRQ_TAIL_REG);
 
 	return tail == hw->hw.cmq.crq.next_to_use;
 }
@@ -868,5 +868,6 @@ void hclge_mbx_handler(struct hclge_dev *hdev)
 	}
 
 	/* Write back CMDQ_RQ header pointer, M7 need this pointer */
-	hclge_write_dev(&hdev->hw, HCLGE_NIC_CRQ_HEAD_REG, crq->next_to_use);
+	hclge_write_dev(&hdev->hw, HCLGE_COMM_NIC_CRQ_HEAD_REG,
+			crq->next_to_use);
 }
-- 
2.33.0

