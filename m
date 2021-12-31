Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A6248236B
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhLaK2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:28:10 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:30133 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhLaK1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:44 -0500
Received: from kwepemi100007.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JQLps6sQfz1DKPY;
        Fri, 31 Dec 2021 18:24:21 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100007.china.huawei.com (7.221.188.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:41 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 10/13] net: hns3: create common cmdq init and uninit APIs
Date:   Fri, 31 Dec 2021 18:22:40 +0800
Message-ID: <20211231102243.3006-11-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
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

The PF and VF cmdq init and uninit APIs are also almost same espect the
suffixes of API names.

This patch creates common cmdq init and uninit APIs needed by PF and VF
cmdq modules. The next patch will use the new unified APIs to replace init
and uninit APIs in PF module.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hns3/hns3_common/hclge_comm_cmd.c         | 144 ++++++++++++++++++
 .../hns3/hns3_common/hclge_comm_cmd.h         |  19 +++
 2 files changed, 163 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index 06bb95677ad4..e3c9d2e400e4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -480,3 +480,147 @@ int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
 
 	return ret;
 }
+
+static void hclge_comm_cmd_uninit_regs(struct hclge_comm_hw *hw)
+{
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_BASEADDR_L_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_BASEADDR_H_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_DEPTH_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_HEAD_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CSQ_TAIL_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_BASEADDR_L_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_BASEADDR_H_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_DEPTH_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_HEAD_REG, 0);
+	hclge_comm_write_dev(hw, HCLGE_COMM_NIC_CRQ_TAIL_REG, 0);
+}
+
+void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev, bool is_pf,
+			   struct hclge_comm_hw *hw)
+{
+	struct hclge_comm_cmq *cmdq = &hw->cmq;
+
+	hclge_comm_firmware_compat_config(ae_dev, is_pf, hw, false);
+	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hw->comm_state);
+
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGE_COMM_CMDQ_CLEAR_WAIT_TIME);
+	spin_lock_bh(&cmdq->csq.lock);
+	spin_lock(&cmdq->crq.lock);
+	hclge_comm_cmd_uninit_regs(hw);
+	spin_unlock(&cmdq->crq.lock);
+	spin_unlock_bh(&cmdq->csq.lock);
+
+	hclge_comm_free_cmd_desc(&cmdq->csq);
+	hclge_comm_free_cmd_desc(&cmdq->crq);
+}
+
+int hclge_comm_cmd_queue_init(struct pci_dev *pdev, struct hclge_comm_hw *hw)
+{
+	struct hclge_comm_cmq *cmdq = &hw->cmq;
+	int ret;
+
+	/* Setup the lock for command queue */
+	spin_lock_init(&cmdq->csq.lock);
+	spin_lock_init(&cmdq->crq.lock);
+
+	cmdq->csq.pdev = pdev;
+	cmdq->crq.pdev = pdev;
+
+	/* Setup the queue entries for use cmd queue */
+	cmdq->csq.desc_num = HCLGE_COMM_NIC_CMQ_DESC_NUM;
+	cmdq->crq.desc_num = HCLGE_COMM_NIC_CMQ_DESC_NUM;
+
+	/* Setup Tx write back timeout */
+	cmdq->tx_timeout = HCLGE_COMM_CMDQ_TX_TIMEOUT;
+
+	/* Setup queue rings */
+	ret = hclge_comm_alloc_cmd_queue(hw, HCLGE_COMM_TYPE_CSQ);
+	if (ret) {
+		dev_err(&pdev->dev, "CSQ ring setup error %d\n", ret);
+		return ret;
+	}
+
+	ret = hclge_comm_alloc_cmd_queue(hw, HCLGE_COMM_TYPE_CRQ);
+	if (ret) {
+		dev_err(&pdev->dev, "CRQ ring setup error %d\n", ret);
+		goto err_csq;
+	}
+
+	return 0;
+err_csq:
+	hclge_comm_free_cmd_desc(&hw->cmq.csq);
+	return ret;
+}
+
+int hclge_comm_cmd_init(struct hnae3_ae_dev *ae_dev, struct hclge_comm_hw *hw,
+			u32 *fw_version, bool is_pf,
+			unsigned long reset_pending)
+{
+	struct hclge_comm_cmq *cmdq = &hw->cmq;
+	int ret;
+
+	spin_lock_bh(&cmdq->csq.lock);
+	spin_lock(&cmdq->crq.lock);
+
+	cmdq->csq.next_to_clean = 0;
+	cmdq->csq.next_to_use = 0;
+	cmdq->crq.next_to_clean = 0;
+	cmdq->crq.next_to_use = 0;
+
+	hclge_comm_cmd_init_regs(hw);
+
+	spin_unlock(&cmdq->crq.lock);
+	spin_unlock_bh(&cmdq->csq.lock);
+
+	clear_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hw->comm_state);
+
+	/* Check if there is new reset pending, because the higher level
+	 * reset may happen when lower level reset is being processed.
+	 */
+	if (reset_pending) {
+		ret = -EBUSY;
+		goto err_cmd_init;
+	}
+
+	/* get version and device capabilities */
+	ret = hclge_comm_cmd_query_version_and_capability(ae_dev, hw,
+							  fw_version, is_pf);
+	if (ret) {
+		dev_err(&ae_dev->pdev->dev,
+			"failed to query version and capabilities, ret = %d\n",
+			ret);
+		goto err_cmd_init;
+	}
+
+	dev_info(&ae_dev->pdev->dev,
+		 "The firmware version is %lu.%lu.%lu.%lu\n",
+		 hnae3_get_field(*fw_version, HNAE3_FW_VERSION_BYTE3_MASK,
+				 HNAE3_FW_VERSION_BYTE3_SHIFT),
+		 hnae3_get_field(*fw_version, HNAE3_FW_VERSION_BYTE2_MASK,
+				 HNAE3_FW_VERSION_BYTE2_SHIFT),
+		 hnae3_get_field(*fw_version, HNAE3_FW_VERSION_BYTE1_MASK,
+				 HNAE3_FW_VERSION_BYTE1_SHIFT),
+		 hnae3_get_field(*fw_version, HNAE3_FW_VERSION_BYTE0_MASK,
+				 HNAE3_FW_VERSION_BYTE0_SHIFT));
+
+	if (!is_pf && ae_dev->dev_version < HNAE3_DEVICE_VERSION_V3)
+		return 0;
+
+	/* ask the firmware to enable some features, driver can work without
+	 * it.
+	 */
+	ret = hclge_comm_firmware_compat_config(ae_dev, is_pf, hw, true);
+	if (ret)
+		dev_warn(&ae_dev->pdev->dev,
+			 "Firmware compatible features not enabled(%d).\n",
+			 ret);
+	return 0;
+
+err_cmd_init:
+	set_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hw->comm_state);
+
+	return ret;
+}
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index 2d28197fd6cf..2dd30a161cab 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -27,6 +27,9 @@
 #define HCLGE_COMM_TYPE_CRQ			0
 #define HCLGE_COMM_TYPE_CSQ			1
 
+#define HCLGE_COMM_CMDQ_CLEAR_WAIT_TIME		200
+
+/* bar registers for cmdq */
 #define HCLGE_COMM_NIC_CSQ_BASEADDR_L_REG	0x27000
 #define HCLGE_COMM_NIC_CSQ_BASEADDR_H_REG	0x27004
 #define HCLGE_COMM_NIC_CSQ_DEPTH_REG		0x27008
@@ -37,11 +40,20 @@
 #define HCLGE_COMM_NIC_CRQ_DEPTH_REG		0x27020
 #define HCLGE_COMM_NIC_CRQ_TAIL_REG		0x27024
 #define HCLGE_COMM_NIC_CRQ_HEAD_REG		0x27028
+/* Vector0 interrupt CMDQ event source register(RW) */
+#define HCLGE_COMM_VECTOR0_CMDQ_SRC_REG		0x27100
+/* Vector0 interrupt CMDQ event status register(RO) */
+#define HCLGE_COMM_VECTOR0_CMDQ_STATE_REG	0x27104
+#define HCLGE_COMM_CMDQ_INTR_EN_REG		0x27108
+#define HCLGE_COMM_CMDQ_INTR_GEN_REG		0x2710C
+#define HCLGE_COMM_CMDQ_INTR_STS_REG		0x27104
 
 /* this bit indicates that the driver is ready for hardware reset */
 #define HCLGE_COMM_NIC_SW_RST_RDY_B		16
 #define HCLGE_COMM_NIC_SW_RST_RDY		BIT(HCLGE_COMM_NIC_SW_RST_RDY_B)
 #define HCLGE_COMM_NIC_CMQ_DESC_NUM_S		3
+#define HCLGE_COMM_NIC_CMQ_DESC_NUM		1024
+#define HCLGE_COMM_CMDQ_TX_TIMEOUT		30000
 
 enum hclge_comm_cmd_return_status {
 	HCLGE_COMM_CMD_EXEC_SUCCESS	= 0,
@@ -205,4 +217,11 @@ void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring);
 void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
 				     enum hclge_comm_opcode_type opcode,
 				     bool is_read);
+void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev, bool is_pf,
+			   struct hclge_comm_hw *hw);
+int hclge_comm_cmd_queue_init(struct pci_dev *pdev, struct hclge_comm_hw *hw);
+int hclge_comm_cmd_init(struct hnae3_ae_dev *ae_dev, struct hclge_comm_hw *hw,
+			u32 *fw_version, bool is_pf,
+			unsigned long reset_pending);
+
 #endif
-- 
2.33.0

