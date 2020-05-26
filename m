Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7E11B8507
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 11:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgDYJEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 05:04:40 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37498 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbgDYJEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 05:04:39 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0CA9560FE7C1B536277E;
        Sat, 25 Apr 2020 17:04:32 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Apr 2020 17:04:26 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v1 1/3] hinic: add mailbox function support
Date:   Sat, 25 Apr 2020 01:21:09 +0000
Message-ID: <20200425012111.4297-2-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200425012111.4297-1-luobin9@huawei.com>
References: <20200425012111.4297-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtual function and physical function can communicate with each
other through mailbox channel supported by hw

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/Makefile    |    2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_csr.h  |    2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  |   25 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |    2 +
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.h  |    3 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.c   |   46 +-
 .../net/ethernet/huawei/hinic/hinic_hw_if.h   |   18 +
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 1213 +++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  154 +++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |    1 +
 10 files changed, 1456 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h

diff --git a/drivers/net/ethernet/huawei/hinic/Makefile b/drivers/net/ethernet/huawei/hinic/Makefile
index fe88ab88cacc..a73862a64690 100644
--- a/drivers/net/ethernet/huawei/hinic/Makefile
+++ b/drivers/net/ethernet/huawei/hinic/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_HINIC) += hinic.o
 hinic-y := hinic_main.o hinic_tx.o hinic_rx.o hinic_port.o hinic_hw_dev.o \
 	   hinic_hw_io.o hinic_hw_qp.o hinic_hw_cmdq.o hinic_hw_wq.o \
 	   hinic_hw_mgmt.o hinic_hw_api_cmd.o hinic_hw_eqs.o hinic_hw_if.o \
-	   hinic_common.o hinic_ethtool.o
+	   hinic_common.o hinic_ethtool.o hinic_hw_mbox.o
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h
index cdec1d0a3962..7e84e4e33fff 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h
@@ -10,7 +10,7 @@
 /* HW interface registers */
 #define HINIC_CSR_FUNC_ATTR0_ADDR                       0x0
 #define HINIC_CSR_FUNC_ATTR1_ADDR                       0x4
-
+#define HINIC_CSR_FUNC_ATTR2_ADDR			0x8
 #define HINIC_CSR_FUNC_ATTR4_ADDR                       0x10
 #define HINIC_CSR_FUNC_ATTR5_ADDR                       0x14
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index c7c75b772a86..f2cf6f7ffc34 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -676,10 +676,23 @@ static int init_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 		return err;
 	}
 
-	hinic_register_mgmt_msg_cb(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
-				   pfhwdev, nic_mgmt_msg_handler);
+	err = hinic_func_to_func_init(hwdev);
+	if (err) {
+		dev_err(&hwif->pdev->dev, "Failed to init mailbox\n");
+		hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
+		return err;
+	}
+
+	if (!HINIC_IS_VF(hwif))
+		hinic_register_mgmt_msg_cb(&pfhwdev->pf_to_mgmt,
+					   HINIC_MOD_L2NIC, pfhwdev,
+					   nic_mgmt_msg_handler);
+	else
+		hinic_register_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC,
+					  nic_mgmt_msg_handler);
 
 	hinic_set_pf_action(hwif, HINIC_PF_MGMT_ACTIVE);
+
 	return 0;
 }
 
@@ -693,7 +706,13 @@ static void free_pfhwdev(struct hinic_pfhwdev *pfhwdev)
 
 	hinic_set_pf_action(hwdev->hwif, HINIC_PF_MGMT_INIT);
 
-	hinic_unregister_mgmt_msg_cb(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC);
+	if (!HINIC_IS_VF(hwdev->hwif))
+		hinic_unregister_mgmt_msg_cb(&pfhwdev->pf_to_mgmt,
+					     HINIC_MOD_L2NIC);
+	else
+		hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
+
+	hinic_func_to_func_free(hwdev);
 
 	hinic_pf_to_mgmt_free(&pfhwdev->pf_to_mgmt);
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 66fd2340d447..2574086aa314 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -16,6 +16,7 @@
 #include "hinic_hw_mgmt.h"
 #include "hinic_hw_qp.h"
 #include "hinic_hw_io.h"
+#include "hinic_hw_mbox.h"
 
 #define HINIC_MAX_QPS   32
 
@@ -225,6 +226,7 @@ struct hinic_hwdev {
 
 	struct hinic_aeqs               aeqs;
 	struct hinic_func_to_io         func_to_io;
+	struct hinic_mbox_func_to_func  *func_to_func;
 
 	struct hinic_cap                nic_cap;
 };
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
index d35f2068ee0c..d73256da4b80 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
@@ -143,8 +143,9 @@ enum hinic_eq_type {
 };
 
 enum hinic_aeq_type {
+	HINIC_MBX_FROM_FUNC = 1,
 	HINIC_MSG_FROM_MGMT_CPU = 2,
-
+	HINIC_MBX_SEND_RSLT = 5,
 	HINIC_MAX_AEQ_EVENTS,
 };
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
index 07bbfbf68577..3fbd2eb80582 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.c
@@ -115,8 +115,12 @@ int hinic_msix_attr_cnt_clear(struct hinic_hwif *hwif, u16 msix_index)
  **/
 void hinic_set_pf_action(struct hinic_hwif *hwif, enum hinic_pf_action action)
 {
-	u32 attr5 = hinic_hwif_read_reg(hwif, HINIC_CSR_FUNC_ATTR5_ADDR);
+	u32 attr5;
 
+	if (HINIC_IS_VF(hwif))
+		return;
+
+	attr5 = hinic_hwif_read_reg(hwif, HINIC_CSR_FUNC_ATTR5_ADDR);
 	attr5 = HINIC_FA5_CLEAR(attr5, PF_ACTION);
 	attr5 |= HINIC_FA5_SET(action, PF_ACTION);
 
@@ -203,7 +207,8 @@ static int hwif_ready(struct hinic_hwif *hwif)
  * @attr0: the first attribute that was read from the hw
  * @attr1: the second attribute that was read from the hw
  **/
-static void set_hwif_attr(struct hinic_hwif *hwif, u32 attr0, u32 attr1)
+static void set_hwif_attr(struct hinic_hwif *hwif, u32 attr0, u32 attr1,
+			  u32 attr2)
 {
 	hwif->attr.func_idx     = HINIC_FA0_GET(attr0, FUNC_IDX);
 	hwif->attr.pf_idx       = HINIC_FA0_GET(attr0, PF_IDX);
@@ -214,6 +219,8 @@ static void set_hwif_attr(struct hinic_hwif *hwif, u32 attr0, u32 attr1)
 	hwif->attr.num_ceqs = BIT(HINIC_FA1_GET(attr1, CEQS_PER_FUNC));
 	hwif->attr.num_irqs = BIT(HINIC_FA1_GET(attr1, IRQS_PER_FUNC));
 	hwif->attr.num_dma_attr = BIT(HINIC_FA1_GET(attr1, DMA_ATTR_PER_FUNC));
+	hwif->attr.global_vf_id_of_pf = HINIC_FA2_GET(attr2,
+						      GLOBAL_VF_ID_OF_PF);
 }
 
 /**
@@ -222,7 +229,7 @@ static void set_hwif_attr(struct hinic_hwif *hwif, u32 attr0, u32 attr1)
  **/
 static void read_hwif_attr(struct hinic_hwif *hwif)
 {
-	u32 addr, attr0, attr1;
+	u32 addr, attr0, attr1, attr2;
 
 	addr   = HINIC_CSR_FUNC_ATTR0_ADDR;
 	attr0  = hinic_hwif_read_reg(hwif, addr);
@@ -230,7 +237,10 @@ static void read_hwif_attr(struct hinic_hwif *hwif)
 	addr   = HINIC_CSR_FUNC_ATTR1_ADDR;
 	attr1  = hinic_hwif_read_reg(hwif, addr);
 
-	set_hwif_attr(hwif, attr0, attr1);
+	addr   = HINIC_CSR_FUNC_ATTR2_ADDR;
+	attr2  = hinic_hwif_read_reg(hwif, addr);
+
+	set_hwif_attr(hwif, attr0, attr1, attr2);
 }
 
 /**
@@ -309,6 +319,34 @@ static void dma_attr_init(struct hinic_hwif *hwif)
 		     HINIC_PCIE_SNOOP, HINIC_PCIE_TPH_DISABLE);
 }
 
+u16 hinic_glb_pf_vf_offset(struct hinic_hwif *hwif)
+{
+	if (!hwif)
+		return 0;
+
+	return hwif->attr.global_vf_id_of_pf;
+}
+
+u16 hinic_global_func_id_hw(struct hinic_hwif *hwif)
+{
+	u32 addr, attr0;
+
+	addr   = HINIC_CSR_FUNC_ATTR0_ADDR;
+	attr0  = hinic_hwif_read_reg(hwif, addr);
+
+	return HINIC_FA0_GET(attr0, FUNC_IDX);
+}
+
+u16 hinic_pf_id_of_vf_hw(struct hinic_hwif *hwif)
+{
+	u32 addr, attr0;
+
+	addr   = HINIC_CSR_FUNC_ATTR0_ADDR;
+	attr0  = hinic_hwif_read_reg(hwif, addr);
+
+	return HINIC_FA0_GET(attr0, PF_IDX);
+}
+
 /**
  * hinic_init_hwif - initialize the hw interface
  * @hwif: the HW interface of a pci function device
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
index c7bb9ceca72c..53bb89c1dd26 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
@@ -35,6 +35,7 @@
 #define HINIC_FA0_FUNC_IDX_SHIFT                                0
 #define HINIC_FA0_PF_IDX_SHIFT                                  10
 #define HINIC_FA0_PCI_INTF_IDX_SHIFT                            14
+#define HINIC_FA0_VF_IN_PF_SHIFT				16
 /* reserved members - off 16 */
 #define HINIC_FA0_FUNC_TYPE_SHIFT                               24
 
@@ -42,6 +43,7 @@
 #define HINIC_FA0_PF_IDX_MASK                                   0xF
 #define HINIC_FA0_PCI_INTF_IDX_MASK                             0x3
 #define HINIC_FA0_FUNC_TYPE_MASK                                0x1
+#define HINIC_FA0_VF_IN_PF_MASK					0xFF
 
 #define HINIC_FA0_GET(val, member)                              \
 	(((val) >> HINIC_FA0_##member##_SHIFT) & HINIC_FA0_##member##_MASK)
@@ -64,6 +66,12 @@
 #define HINIC_FA1_GET(val, member)                              \
 	(((val) >> HINIC_FA1_##member##_SHIFT) & HINIC_FA1_##member##_MASK)
 
+#define HINIC_FA2_GLOBAL_VF_ID_OF_PF_SHIFT	16
+#define HINIC_FA2_GLOBAL_VF_ID_OF_PF_MASK	0x3FF
+
+#define HINIC_FA2_GET(val, member)				\
+	(((val) >> HINIC_FA2_##member##_SHIFT) & HINIC_FA2_##member##_MASK)
+
 #define HINIC_FA4_OUTBOUND_STATE_SHIFT                          0
 #define HINIC_FA4_DB_STATE_SHIFT                                1
 
@@ -140,6 +148,7 @@
 #define HINIC_HWIF_PPF_IDX(hwif)        ((hwif)->attr.ppf_idx)
 
 #define HINIC_FUNC_TYPE(hwif)           ((hwif)->attr.func_type)
+#define HINIC_IS_VF(hwif)               (HINIC_FUNC_TYPE(hwif) == HINIC_VF)
 #define HINIC_IS_PF(hwif)               (HINIC_FUNC_TYPE(hwif) == HINIC_PF)
 #define HINIC_IS_PPF(hwif)              (HINIC_FUNC_TYPE(hwif) == HINIC_PPF)
 
@@ -173,6 +182,7 @@ enum hinic_pcie_tph {
 
 enum hinic_func_type {
 	HINIC_PF        = 0,
+	HINIC_VF	    = 1,
 	HINIC_PPF       = 2,
 };
 
@@ -223,6 +233,8 @@ struct hinic_func_attr {
 	u8                      num_ceqs;
 
 	u8                      num_dma_attr;
+
+	u16						global_vf_id_of_pf;
 };
 
 struct hinic_hwif {
@@ -271,6 +283,12 @@ enum hinic_db_state hinic_db_state_get(struct hinic_hwif *hwif);
 void hinic_db_state_set(struct hinic_hwif *hwif,
 			enum hinic_db_state db_state);
 
+u16 hinic_glb_pf_vf_offset(struct hinic_hwif *hwif);
+
+u16 hinic_global_func_id_hw(struct hinic_hwif *hwif);
+
+u16 hinic_pf_id_of_vf_hw(struct hinic_hwif *hwif);
+
 int hinic_init_hwif(struct hinic_hwif *hwif, struct pci_dev *pdev);
 
 void hinic_free_hwif(struct hinic_hwif *hwif);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
new file mode 100644
index 000000000000..f8626dfd192e
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -0,0 +1,1213 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+#include <linux/completion.h>
+#include <linux/semaphore.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+#include "hinic_hw_if.h"
+#include "hinic_hw_mgmt.h"
+#include "hinic_hw_csr.h"
+#include "hinic_hw_dev.h"
+#include "hinic_hw_mbox.h"
+
+#define HINIC_MBOX_INT_DST_FUNC_SHIFT				0
+#define HINIC_MBOX_INT_DST_AEQN_SHIFT				10
+#define HINIC_MBOX_INT_SRC_RESP_AEQN_SHIFT			12
+#define HINIC_MBOX_INT_STAT_DMA_SHIFT				14
+/* The size of data to be sended (unit of 4 bytes) */
+#define HINIC_MBOX_INT_TX_SIZE_SHIFT				20
+/* SO_RO(strong order, relax order) */
+#define HINIC_MBOX_INT_STAT_DMA_SO_RO_SHIFT			25
+#define HINIC_MBOX_INT_WB_EN_SHIFT				28
+
+#define HINIC_MBOX_INT_DST_FUNC_MASK				0x3FF
+#define HINIC_MBOX_INT_DST_AEQN_MASK				0x3
+#define HINIC_MBOX_INT_SRC_RESP_AEQN_MASK			0x3
+#define HINIC_MBOX_INT_STAT_DMA_MASK				0x3F
+#define HINIC_MBOX_INT_TX_SIZE_MASK				0x1F
+#define HINIC_MBOX_INT_STAT_DMA_SO_RO_MASK			0x3
+#define HINIC_MBOX_INT_WB_EN_MASK				0x1
+
+#define HINIC_MBOX_INT_SET(val, field)	\
+			(((val) & HINIC_MBOX_INT_##field##_MASK) << \
+			HINIC_MBOX_INT_##field##_SHIFT)
+
+enum hinic_mbox_tx_status {
+	TX_NOT_DONE = 1,
+};
+
+#define HINIC_MBOX_CTRL_TRIGGER_AEQE_SHIFT			0
+
+/* specifies the issue request for the message data.
+ * 0 - Tx request is done;
+ * 1 - Tx request is in process.
+ */
+#define HINIC_MBOX_CTRL_TX_STATUS_SHIFT				1
+
+#define HINIC_MBOX_CTRL_TRIGGER_AEQE_MASK			0x1
+#define HINIC_MBOX_CTRL_TX_STATUS_MASK				0x1
+
+#define HINIC_MBOX_CTRL_SET(val, field)	\
+			(((val) & HINIC_MBOX_CTRL_##field##_MASK) << \
+			HINIC_MBOX_CTRL_##field##_SHIFT)
+
+#define HINIC_MBOX_HEADER_MSG_LEN_SHIFT				0
+#define HINIC_MBOX_HEADER_MODULE_SHIFT				11
+#define HINIC_MBOX_HEADER_SEG_LEN_SHIFT				16
+#define HINIC_MBOX_HEADER_NO_ACK_SHIFT				22
+#define HINIC_MBOX_HEADER_SEQID_SHIFT				24
+#define HINIC_MBOX_HEADER_LAST_SHIFT				30
+
+/* specifies the mailbox message direction
+ * 0 - send
+ * 1 - receive
+ */
+#define HINIC_MBOX_HEADER_DIRECTION_SHIFT			31
+#define HINIC_MBOX_HEADER_CMD_SHIFT				32
+#define HINIC_MBOX_HEADER_MSG_ID_SHIFT				40
+#define HINIC_MBOX_HEADER_STATUS_SHIFT				48
+#define HINIC_MBOX_HEADER_SRC_GLB_FUNC_IDX_SHIFT		54
+
+#define HINIC_MBOX_HEADER_MSG_LEN_MASK				0x7FF
+#define HINIC_MBOX_HEADER_MODULE_MASK				0x1F
+#define HINIC_MBOX_HEADER_SEG_LEN_MASK				0x3F
+#define HINIC_MBOX_HEADER_NO_ACK_MASK				0x1
+#define HINIC_MBOX_HEADER_SEQID_MASK				0x3F
+#define HINIC_MBOX_HEADER_LAST_MASK				0x1
+#define HINIC_MBOX_HEADER_DIRECTION_MASK			0x1
+#define HINIC_MBOX_HEADER_CMD_MASK				0xFF
+#define HINIC_MBOX_HEADER_MSG_ID_MASK				0xFF
+#define HINIC_MBOX_HEADER_STATUS_MASK				0x3F
+#define HINIC_MBOX_HEADER_SRC_GLB_FUNC_IDX_MASK			0x3FF
+
+#define HINIC_MBOX_HEADER_GET(val, field)	\
+			(((val) >> HINIC_MBOX_HEADER_##field##_SHIFT) & \
+			HINIC_MBOX_HEADER_##field##_MASK)
+#define HINIC_MBOX_HEADER_SET(val, field)	\
+			((u64)((val) & HINIC_MBOX_HEADER_##field##_MASK) << \
+			HINIC_MBOX_HEADER_##field##_SHIFT)
+
+#define MBOX_SEGLEN_MASK			\
+		HINIC_MBOX_HEADER_SET(HINIC_MBOX_HEADER_SEG_LEN_MASK, SEG_LEN)
+
+#define HINIC_MBOX_SEG_LEN			48
+#define HINIC_MBOX_COMP_TIME			8000U
+#define MBOX_MSG_POLLING_TIMEOUT		8000
+
+#define HINIC_MBOX_DATA_SIZE			2040
+
+#define MBOX_MAX_BUF_SZ				2048UL
+#define MBOX_HEADER_SZ				8
+
+#define MBOX_INFO_SZ				4
+
+/* MBOX size is 64B, 8B for mbox_header, 4B reserved */
+#define MBOX_SEG_LEN				48
+#define MBOX_SEG_LEN_ALIGN			4
+#define MBOX_WB_STATUS_LEN			16UL
+
+/* mbox write back status is 16B, only first 4B is used */
+#define MBOX_WB_STATUS_ERRCODE_MASK		0xFFFF
+#define MBOX_WB_STATUS_MASK			0xFF
+#define MBOX_WB_ERROR_CODE_MASK			0xFF00
+#define MBOX_WB_STATUS_FINISHED_SUCCESS		0xFF
+#define MBOX_WB_STATUS_FINISHED_WITH_ERR	0xFE
+#define MBOX_WB_STATUS_NOT_FINISHED		0x00
+
+#define MBOX_STATUS_FINISHED(wb)	\
+	(((wb) & MBOX_WB_STATUS_MASK) != MBOX_WB_STATUS_NOT_FINISHED)
+#define MBOX_STATUS_SUCCESS(wb)		\
+	(((wb) & MBOX_WB_STATUS_MASK) == MBOX_WB_STATUS_FINISHED_SUCCESS)
+#define MBOX_STATUS_ERRCODE(wb)		\
+	((wb) & MBOX_WB_ERROR_CODE_MASK)
+
+#define SEQ_ID_START_VAL			0
+#define SEQ_ID_MAX_VAL				42
+
+#define DST_AEQ_IDX_DEFAULT_VAL			0
+#define SRC_AEQ_IDX_DEFAULT_VAL			0
+#define NO_DMA_ATTRIBUTE_VAL			0
+
+#define HINIC_MGMT_RSP_AEQN			0
+#define HINIC_MBOX_RSP_AEQN			2
+#define HINIC_MBOX_RECV_AEQN			0
+
+#define MBOX_MSG_NO_DATA_LEN			1
+
+#define MBOX_BODY_FROM_HDR(header)	((u8 *)(header) + MBOX_HEADER_SZ)
+#define MBOX_AREA(hwif)			\
+	((hwif)->cfg_regs_bar + HINIC_FUNC_CSR_MAILBOX_DATA_OFF)
+
+#define IS_PF_OR_PPF_SRC(src_func_idx)	((src_func_idx) < HINIC_MAX_PF_FUNCS)
+
+#define MBOX_RESPONSE_ERROR		0x1
+#define MBOX_MSG_ID_MASK		0xFF
+#define MBOX_MSG_ID(func_to_func)	((func_to_func)->send_msg_id)
+#define MBOX_MSG_ID_INC(func_to_func_mbox) (MBOX_MSG_ID(func_to_func_mbox) = \
+			(MBOX_MSG_ID(func_to_func_mbox) + 1) & MBOX_MSG_ID_MASK)
+
+#define FUNC_ID_OFF_SET_8B		8
+#define FUNC_ID_OFF_SET_10B		10
+
+/* max message counter wait to process for one function */
+#define HINIC_MAX_MSG_CNT_TO_PROCESS	10
+
+#define HINIC_QUEUE_MIN_DEPTH		6
+#define HINIC_QUEUE_MAX_DEPTH		12
+#define HINIC_MAX_RX_BUFFER_SIZE		15
+
+enum hinic_hwif_direction_type {
+	HINIC_HWIF_DIRECT_SEND	= 0,
+	HINIC_HWIF_RESPONSE	= 1,
+};
+
+enum mbox_send_mod {
+	MBOX_SEND_MSG_INT,
+};
+
+enum mbox_seg_type {
+	NOT_LAST_SEG,
+	LAST_SEG,
+};
+
+enum mbox_ordering_type {
+	STRONG_ORDER,
+};
+
+enum mbox_write_back_type {
+	WRITE_BACK = 1,
+};
+
+enum mbox_aeq_trig_type {
+	NOT_TRIGGER,
+	TRIGGER,
+};
+
+/**
+ * hinic_register_pf_mbox_cb - register mbox callback for pf
+ * @hwdev: the pointer to hw device
+ * @mod:	specific mod that the callback will handle
+ * @callback:	callback function
+ * Return: 0 - success, negative - failure
+ */
+int hinic_register_pf_mbox_cb(struct hinic_hwdev *hwdev,
+			      enum hinic_mod_type mod,
+			      hinic_pf_mbox_cb callback)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+
+	if (mod >= HINIC_MOD_MAX)
+		return -EFAULT;
+
+	func_to_func->pf_mbox_cb[mod] = callback;
+
+	set_bit(HINIC_PF_MBOX_CB_REG, &func_to_func->pf_mbox_cb_state[mod]);
+
+	return 0;
+}
+
+/**
+ * hinic_register_vf_mbox_cb - register mbox callback for vf
+ * @hwdev: the pointer to hw device
+ * @mod:	specific mod that the callback will handle
+ * @callback:	callback function
+ * Return: 0 - success, negative - failure
+ */
+int hinic_register_vf_mbox_cb(struct hinic_hwdev *hwdev,
+			      enum hinic_mod_type mod,
+			      hinic_vf_mbox_cb callback)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+
+	if (mod >= HINIC_MOD_MAX)
+		return -EFAULT;
+
+	func_to_func->vf_mbox_cb[mod] = callback;
+
+	set_bit(HINIC_VF_MBOX_CB_REG, &func_to_func->vf_mbox_cb_state[mod]);
+
+	return 0;
+}
+
+/**
+ * hinic_unregister_pf_mbox_cb - unregister the mbox callback for pf
+ * @hwdev:	the pointer to hw device
+ * @mod:	specific mod that the callback will handle
+ */
+void hinic_unregister_pf_mbox_cb(struct hinic_hwdev *hwdev,
+				 enum hinic_mod_type mod)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+
+	clear_bit(HINIC_PF_MBOX_CB_REG, &func_to_func->pf_mbox_cb_state[mod]);
+
+	while (test_bit(HINIC_PF_MBOX_CB_RUNNING,
+			&func_to_func->pf_mbox_cb_state[mod]))
+		usleep_range(900, 1000);
+
+	func_to_func->pf_mbox_cb[mod] = NULL;
+}
+
+/**
+ * hinic_unregister_vf_mbox_cb - unregister the mbox callback for vf
+ * @hwdev:	the pointer to hw device
+ * @mod:	specific mod that the callback will handle
+ */
+void hinic_unregister_vf_mbox_cb(struct hinic_hwdev *hwdev,
+				 enum hinic_mod_type mod)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+
+	clear_bit(HINIC_VF_MBOX_CB_REG, &func_to_func->vf_mbox_cb_state[mod]);
+
+	while (test_bit(HINIC_VF_MBOX_CB_RUNNING,
+			&func_to_func->vf_mbox_cb_state[mod]))
+		usleep_range(900, 1000);
+
+	func_to_func->vf_mbox_cb[mod] = NULL;
+}
+
+static int recv_vf_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
+				struct hinic_recv_mbox *recv_mbox,
+				void *buf_out, u16 *out_size)
+{
+	hinic_vf_mbox_cb cb;
+	int ret = 0;
+
+	if (recv_mbox->mod >= HINIC_MOD_MAX) {
+		dev_err(&func_to_func->hwif->pdev->dev, "Receive illegal mbox message, mod = %d\n",
+			recv_mbox->mod);
+		return -EINVAL;
+	}
+
+	set_bit(HINIC_VF_MBOX_CB_RUNNING,
+		&func_to_func->vf_mbox_cb_state[recv_mbox->mod]);
+
+	cb = func_to_func->vf_mbox_cb[recv_mbox->mod];
+	if (cb && test_bit(HINIC_VF_MBOX_CB_REG,
+			   &func_to_func->vf_mbox_cb_state[recv_mbox->mod])) {
+		cb(func_to_func->hwdev, recv_mbox->cmd, recv_mbox->mbox,
+		   recv_mbox->mbox_len, buf_out, out_size);
+	} else {
+		dev_err(&func_to_func->hwif->pdev->dev, "VF mbox cb is not registered\n");
+		ret = -EINVAL;
+	}
+
+	clear_bit(HINIC_VF_MBOX_CB_RUNNING,
+		  &func_to_func->vf_mbox_cb_state[recv_mbox->mod]);
+
+	return ret;
+}
+
+static int
+recv_pf_from_vf_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
+			     struct hinic_recv_mbox *recv_mbox,
+			     u16 src_func_idx, void *buf_out,
+			     u16 *out_size)
+{
+	hinic_pf_mbox_cb cb;
+	u16 vf_id = 0;
+	int ret;
+
+	if (recv_mbox->mod >= HINIC_MOD_MAX) {
+		dev_err(&func_to_func->hwif->pdev->dev, "Receive illegal mbox message, mod = %d\n",
+			recv_mbox->mod);
+		return -EINVAL;
+	}
+
+	set_bit(HINIC_PF_MBOX_CB_RUNNING,
+		&func_to_func->pf_mbox_cb_state[recv_mbox->mod]);
+
+	cb = func_to_func->pf_mbox_cb[recv_mbox->mod];
+	if (cb && test_bit(HINIC_PF_MBOX_CB_REG,
+			   &func_to_func->pf_mbox_cb_state[recv_mbox->mod])) {
+		vf_id = src_func_idx -
+			hinic_glb_pf_vf_offset(func_to_func->hwif);
+		ret = cb(func_to_func->hwdev, vf_id, recv_mbox->cmd,
+			 recv_mbox->mbox, recv_mbox->mbox_len,
+			 buf_out, out_size);
+	} else {
+		dev_err(&func_to_func->hwif->pdev->dev, "PF mbox mod(0x%x) cb is not registered\n",
+			recv_mbox->mod);
+		ret = -EINVAL;
+	}
+
+	clear_bit(HINIC_PF_MBOX_CB_RUNNING,
+		  &func_to_func->pf_mbox_cb_state[recv_mbox->mod]);
+
+	return ret;
+}
+
+static bool check_mbox_seq_id_and_seg_len(struct hinic_recv_mbox *recv_mbox,
+					  u8 seq_id, u8 seg_len)
+{
+	if (seq_id > SEQ_ID_MAX_VAL || seg_len > MBOX_SEG_LEN)
+		return false;
+
+	if (seq_id == 0) {
+		recv_mbox->seq_id = seq_id;
+	} else {
+		if (seq_id != recv_mbox->seq_id + 1)
+			return false;
+
+		recv_mbox->seq_id = seq_id;
+	}
+
+	return true;
+}
+
+static void resp_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
+			      struct hinic_recv_mbox *recv_mbox)
+{
+	spin_lock(&func_to_func->mbox_lock);
+	if (recv_mbox->msg_info.msg_id == func_to_func->send_msg_id &&
+	    func_to_func->event_flag == EVENT_START)
+		complete(&recv_mbox->recv_done);
+	else
+		dev_err(&func_to_func->hwif->pdev->dev,
+			"Mbox response timeout, current send msg id(0x%x), recv msg id(0x%x), status(0x%x)\n",
+			func_to_func->send_msg_id, recv_mbox->msg_info.msg_id,
+			recv_mbox->msg_info.status);
+	spin_unlock(&func_to_func->mbox_lock);
+}
+
+static void recv_func_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
+				   struct hinic_recv_mbox *recv_mbox,
+				   u16 src_func_idx);
+
+static void recv_func_mbox_work_handler(struct work_struct *work)
+{
+	struct hinic_mbox_work *mbox_work =
+			container_of(work, struct hinic_mbox_work, work);
+	struct hinic_recv_mbox *recv_mbox;
+
+	recv_func_mbox_handler(mbox_work->func_to_func, mbox_work->recv_mbox,
+			       mbox_work->src_func_idx);
+
+	recv_mbox =
+		&mbox_work->func_to_func->mbox_send[mbox_work->src_func_idx];
+
+	atomic_dec(&recv_mbox->msg_cnt);
+
+	kfree(mbox_work);
+}
+
+static void recv_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
+			      void *header, struct hinic_recv_mbox *recv_mbox)
+{
+	void *mbox_body = MBOX_BODY_FROM_HDR(header);
+	struct hinic_recv_mbox *rcv_mbox_temp = NULL;
+	u64 mbox_header = *((u64 *)header);
+	struct hinic_mbox_work *mbox_work;
+	u8 seq_id, seg_len;
+	u16 src_func_idx;
+	int pos;
+
+	seq_id = HINIC_MBOX_HEADER_GET(mbox_header, SEQID);
+	seg_len = HINIC_MBOX_HEADER_GET(mbox_header, SEG_LEN);
+	src_func_idx = HINIC_MBOX_HEADER_GET(mbox_header, SRC_GLB_FUNC_IDX);
+
+	if (!check_mbox_seq_id_and_seg_len(recv_mbox, seq_id, seg_len)) {
+		dev_err(&func_to_func->hwif->pdev->dev,
+			"Mailbox sequence and segment check fail, src func id: 0x%x, front id: 0x%x, current id: 0x%x, seg len: 0x%x\n",
+			src_func_idx, recv_mbox->seq_id, seq_id, seg_len);
+		recv_mbox->seq_id = SEQ_ID_MAX_VAL;
+		return;
+	}
+
+	pos = seq_id * MBOX_SEG_LEN;
+	memcpy((u8 *)recv_mbox->mbox + pos, mbox_body,
+	       HINIC_MBOX_HEADER_GET(mbox_header, SEG_LEN));
+
+	if (!HINIC_MBOX_HEADER_GET(mbox_header, LAST))
+		return;
+
+	recv_mbox->cmd = HINIC_MBOX_HEADER_GET(mbox_header, CMD);
+	recv_mbox->mod = HINIC_MBOX_HEADER_GET(mbox_header, MODULE);
+	recv_mbox->mbox_len = HINIC_MBOX_HEADER_GET(mbox_header, MSG_LEN);
+	recv_mbox->ack_type = HINIC_MBOX_HEADER_GET(mbox_header, NO_ACK);
+	recv_mbox->msg_info.msg_id = HINIC_MBOX_HEADER_GET(mbox_header, MSG_ID);
+	recv_mbox->msg_info.status = HINIC_MBOX_HEADER_GET(mbox_header, STATUS);
+	recv_mbox->seq_id = SEQ_ID_MAX_VAL;
+
+	if (HINIC_MBOX_HEADER_GET(mbox_header, DIRECTION) ==
+	    HINIC_HWIF_RESPONSE) {
+		resp_mbox_handler(func_to_func, recv_mbox);
+		return;
+	}
+
+	if (atomic_read(&recv_mbox->msg_cnt) > HINIC_MAX_MSG_CNT_TO_PROCESS) {
+		dev_warn(&func_to_func->hwif->pdev->dev,
+			 "This function(%u) have %d message wait to process,can't add to work queue\n",
+			 src_func_idx, atomic_read(&recv_mbox->msg_cnt));
+		return;
+	}
+
+	rcv_mbox_temp = kzalloc(sizeof(*rcv_mbox_temp), GFP_KERNEL);
+	if (!rcv_mbox_temp)
+		return;
+
+	memcpy(rcv_mbox_temp, recv_mbox, sizeof(*rcv_mbox_temp));
+
+	rcv_mbox_temp->mbox = kzalloc(MBOX_MAX_BUF_SZ, GFP_KERNEL);
+	if (!rcv_mbox_temp->mbox)
+		goto err_alloc_rcv_mbox_msg;
+
+	memcpy(rcv_mbox_temp->mbox, recv_mbox->mbox, MBOX_MAX_BUF_SZ);
+
+	rcv_mbox_temp->buf_out = kzalloc(MBOX_MAX_BUF_SZ, GFP_KERNEL);
+	if (!rcv_mbox_temp->buf_out)
+		goto err_alloc_rcv_mbox_buf;
+
+	mbox_work = kzalloc(sizeof(*mbox_work), GFP_KERNEL);
+	if (!mbox_work)
+		goto err_alloc_mbox_work;
+
+	mbox_work->func_to_func = func_to_func;
+	mbox_work->recv_mbox = rcv_mbox_temp;
+	mbox_work->src_func_idx = src_func_idx;
+
+	atomic_inc(&recv_mbox->msg_cnt);
+	INIT_WORK(&mbox_work->work, recv_func_mbox_work_handler);
+	queue_work(func_to_func->workq, &mbox_work->work);
+
+	return;
+
+err_alloc_mbox_work:
+	kfree(rcv_mbox_temp->buf_out);
+
+err_alloc_rcv_mbox_buf:
+	kfree(rcv_mbox_temp->mbox);
+
+err_alloc_rcv_mbox_msg:
+	kfree(rcv_mbox_temp);
+}
+
+void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
+{
+	struct hinic_mbox_func_to_func *func_to_func;
+	u64 mbox_header = *((u64 *)header);
+	struct hinic_recv_mbox *recv_mbox;
+	u64 src, dir;
+
+	func_to_func = ((struct hinic_hwdev *)handle)->func_to_func;
+
+	dir = HINIC_MBOX_HEADER_GET(mbox_header, DIRECTION);
+	src = HINIC_MBOX_HEADER_GET(mbox_header, SRC_GLB_FUNC_IDX);
+
+	if (src >= HINIC_MAX_FUNCTIONS) {
+		dev_err(&func_to_func->hwif->pdev->dev,
+			"Mailbox source function id:%u is invalid\n", (u32)src);
+		return;
+	}
+
+	recv_mbox = (dir == HINIC_HWIF_DIRECT_SEND) ?
+		    &func_to_func->mbox_send[src] :
+		    &func_to_func->mbox_resp[src];
+
+	recv_mbox_handler(func_to_func, (u64 *)header, recv_mbox);
+}
+
+void hinic_mbox_self_aeqe_handler(void *handle, void *header, u8 size)
+{
+	struct hinic_mbox_func_to_func *func_to_func;
+	struct hinic_send_mbox *send_mbox;
+
+	func_to_func = ((struct hinic_hwdev *)handle)->func_to_func;
+	send_mbox = &func_to_func->send_mbox;
+
+	complete(&send_mbox->send_done);
+}
+
+static void clear_mbox_status(struct hinic_send_mbox *mbox)
+{
+	*mbox->wb_status = 0;
+
+	/* clear mailbox write back status */
+	wmb();
+}
+
+static void mbox_copy_header(struct hinic_hwdev *hwdev,
+			     struct hinic_send_mbox *mbox, u64 *header)
+{
+	u32 i, idx_max = MBOX_HEADER_SZ / sizeof(u32);
+	u32 *data = (u32 *)header;
+
+	for (i = 0; i < idx_max; i++)
+		__raw_writel(*(data + i), mbox->data + i * sizeof(u32));
+}
+
+static void mbox_copy_send_data(struct hinic_hwdev *hwdev,
+				struct hinic_send_mbox *mbox, void *seg,
+				u16 seg_len)
+{
+	u8 mbox_max_buf[MBOX_SEG_LEN] = {0};
+	u32 data_len, chk_sz = sizeof(u32);
+	u32 *data = seg;
+	u32 i, idx_max;
+
+	/* The mbox message should be aligned in 4 bytes. */
+	if (seg_len % chk_sz) {
+		memcpy(mbox_max_buf, seg, seg_len);
+		data = (u32 *)mbox_max_buf;
+	}
+
+	data_len = seg_len;
+	idx_max = ALIGN(data_len, chk_sz) / chk_sz;
+
+	for (i = 0; i < idx_max; i++)
+		__raw_writel(*(data + i),
+			     mbox->data + MBOX_HEADER_SZ + i * sizeof(u32));
+}
+
+static void write_mbox_msg_attr(struct hinic_mbox_func_to_func *func_to_func,
+				u16 dst_func, u16 dst_aeqn, u16 seg_len,
+				int poll)
+{
+	u16 rsp_aeq = (dst_aeqn == 0) ? 0 : HINIC_MBOX_RSP_AEQN;
+	u32 mbox_int, mbox_ctrl;
+
+	mbox_int = HINIC_MBOX_INT_SET(dst_func, DST_FUNC) |
+		   HINIC_MBOX_INT_SET(dst_aeqn, DST_AEQN) |
+		   HINIC_MBOX_INT_SET(rsp_aeq, SRC_RESP_AEQN) |
+		   HINIC_MBOX_INT_SET(NO_DMA_ATTRIBUTE_VAL, STAT_DMA) |
+		   HINIC_MBOX_INT_SET(ALIGN(MBOX_SEG_LEN + MBOX_HEADER_SZ +
+				      MBOX_INFO_SZ, MBOX_SEG_LEN_ALIGN) >> 2,
+				      TX_SIZE) |
+		   HINIC_MBOX_INT_SET(STRONG_ORDER, STAT_DMA_SO_RO) |
+		   HINIC_MBOX_INT_SET(WRITE_BACK, WB_EN);
+
+	hinic_hwif_write_reg(func_to_func->hwif,
+			     HINIC_FUNC_CSR_MAILBOX_INT_OFFSET_OFF, mbox_int);
+
+	wmb(); /* writing the mbox int attributes */
+	mbox_ctrl = HINIC_MBOX_CTRL_SET(TX_NOT_DONE, TX_STATUS);
+
+	if (poll)
+		mbox_ctrl |= HINIC_MBOX_CTRL_SET(NOT_TRIGGER, TRIGGER_AEQE);
+	else
+		mbox_ctrl |= HINIC_MBOX_CTRL_SET(TRIGGER, TRIGGER_AEQE);
+
+	hinic_hwif_write_reg(func_to_func->hwif,
+			     HINIC_FUNC_CSR_MAILBOX_CONTROL_OFF, mbox_ctrl);
+}
+
+void dump_mox_reg(struct hinic_hwdev *hwdev)
+{
+	u32 val;
+
+	val = hinic_hwif_read_reg(hwdev->hwif,
+				  HINIC_FUNC_CSR_MAILBOX_CONTROL_OFF);
+	dev_err(&hwdev->hwif->pdev->dev, "Mailbox control reg: 0x%x\n", val);
+
+	val = hinic_hwif_read_reg(hwdev->hwif,
+				  HINIC_FUNC_CSR_MAILBOX_INT_OFFSET_OFF);
+	dev_err(&hwdev->hwif->pdev->dev, "Mailbox interrupt offset: 0x%x\n",
+		val);
+}
+
+static u16 get_mbox_status(struct hinic_send_mbox *mbox)
+{
+	/* write back is 16B, but only use first 4B */
+	u64 wb_val = be64_to_cpu(*mbox->wb_status);
+
+	rmb(); /* verify reading before check */
+
+	return (u16)(wb_val & MBOX_WB_STATUS_ERRCODE_MASK);
+}
+
+static int
+wait_for_mbox_seg_completion(struct hinic_mbox_func_to_func *func_to_func,
+			     int poll, u16 *wb_status)
+{
+	struct hinic_send_mbox *send_mbox = &func_to_func->send_mbox;
+	struct hinic_hwdev *hwdev = func_to_func->hwdev;
+	struct completion *done = &send_mbox->send_done;
+	u32 cnt = 0;
+	ulong jif;
+
+	if (poll) {
+		while (cnt < MBOX_MSG_POLLING_TIMEOUT) {
+			*wb_status = get_mbox_status(send_mbox);
+			if (MBOX_STATUS_FINISHED(*wb_status))
+				break;
+
+			usleep_range(900, 1000);
+			cnt++;
+		}
+
+		if (cnt == MBOX_MSG_POLLING_TIMEOUT) {
+			dev_err(&hwdev->hwif->pdev->dev, "Send mailbox segment timeout, wb status: 0x%x\n",
+				*wb_status);
+			dump_mox_reg(hwdev);
+			return -ETIMEDOUT;
+		}
+	} else {
+		jif = msecs_to_jiffies(HINIC_MBOX_COMP_TIME);
+		if (!wait_for_completion_timeout(done, jif)) {
+			dev_err(&hwdev->hwif->pdev->dev, "Send mailbox segment timeout\n");
+			dump_mox_reg(hwdev);
+			return -ETIMEDOUT;
+		}
+
+		*wb_status = get_mbox_status(send_mbox);
+	}
+
+	return 0;
+}
+
+static int send_mbox_seg(struct hinic_mbox_func_to_func *func_to_func,
+			 u64 header, u16 dst_func, void *seg, u16 seg_len,
+			 int poll, void *msg_info)
+{
+	struct hinic_send_mbox *send_mbox = &func_to_func->send_mbox;
+	u16 seq_dir = HINIC_MBOX_HEADER_GET(header, DIRECTION);
+	struct hinic_hwdev *hwdev = func_to_func->hwdev;
+	struct completion *done = &send_mbox->send_done;
+	u8 num_aeqs = hwdev->hwif->attr.num_aeqs;
+	u16 dst_aeqn, wb_status = 0, errcode;
+
+	if (num_aeqs >= 4)
+		dst_aeqn = (seq_dir == HINIC_HWIF_DIRECT_SEND) ?
+			   HINIC_MBOX_RECV_AEQN : HINIC_MBOX_RSP_AEQN;
+	else
+		dst_aeqn = 0;
+
+	if (!poll)
+		init_completion(done);
+
+	clear_mbox_status(send_mbox);
+
+	mbox_copy_header(hwdev, send_mbox, &header);
+
+	mbox_copy_send_data(hwdev, send_mbox, seg, seg_len);
+
+	write_mbox_msg_attr(func_to_func, dst_func, dst_aeqn, seg_len, poll);
+
+	wmb(); /* writing the mbox msg attributes */
+
+	if (wait_for_mbox_seg_completion(func_to_func, poll, &wb_status))
+		return -ETIMEDOUT;
+
+	if (!MBOX_STATUS_SUCCESS(wb_status)) {
+		dev_err(&hwdev->hwif->pdev->dev, "Send mailbox segment to function %d error, wb status: 0x%x\n",
+			dst_func, wb_status);
+		errcode = MBOX_STATUS_ERRCODE(wb_status);
+		return errcode ? errcode : -EFAULT;
+	}
+
+	return 0;
+}
+
+static int send_mbox_to_func(struct hinic_mbox_func_to_func *func_to_func,
+			     enum hinic_mod_type mod, u16 cmd, void *msg,
+			     u16 msg_len, u16 dst_func,
+			     enum hinic_hwif_direction_type direction,
+			     enum hinic_mbox_ack_type ack_type,
+			     struct mbox_msg_info *msg_info)
+{
+	struct hinic_hwdev *hwdev = func_to_func->hwdev;
+	u16 seg_len = MBOX_SEG_LEN;
+	u8 *msg_seg = (u8 *)msg;
+	u16 left = msg_len;
+	u32 seq_id = 0;
+	u64 header = 0;
+	int err = 0;
+
+	down(&func_to_func->msg_send_sem);
+
+	header = HINIC_MBOX_HEADER_SET(msg_len, MSG_LEN) |
+		 HINIC_MBOX_HEADER_SET(mod, MODULE) |
+		 HINIC_MBOX_HEADER_SET(seg_len, SEG_LEN) |
+		 HINIC_MBOX_HEADER_SET(ack_type, NO_ACK) |
+		 HINIC_MBOX_HEADER_SET(SEQ_ID_START_VAL, SEQID) |
+		 HINIC_MBOX_HEADER_SET(NOT_LAST_SEG, LAST) |
+		 HINIC_MBOX_HEADER_SET(direction, DIRECTION) |
+		 HINIC_MBOX_HEADER_SET(cmd, CMD) |
+		 /* The vf's offset to it's associated pf */
+		 HINIC_MBOX_HEADER_SET(msg_info->msg_id, MSG_ID) |
+		 HINIC_MBOX_HEADER_SET(msg_info->status, STATUS) |
+		 HINIC_MBOX_HEADER_SET(hinic_global_func_id_hw(hwdev->hwif),
+				       SRC_GLB_FUNC_IDX);
+
+	while (!(HINIC_MBOX_HEADER_GET(header, LAST))) {
+		if (left <= HINIC_MBOX_SEG_LEN) {
+			header &= ~MBOX_SEGLEN_MASK;
+			header |= HINIC_MBOX_HEADER_SET(left, SEG_LEN);
+			header |= HINIC_MBOX_HEADER_SET(LAST_SEG, LAST);
+
+			seg_len = left;
+		}
+
+		err = send_mbox_seg(func_to_func, header, dst_func, msg_seg,
+				    seg_len, MBOX_SEND_MSG_INT, msg_info);
+		if (err) {
+			dev_err(&hwdev->hwif->pdev->dev, "Failed to send mbox seg, seq_id=0x%llx\n",
+				HINIC_MBOX_HEADER_GET(header, SEQID));
+			goto err_send_mbox_seg;
+		}
+
+		left -= HINIC_MBOX_SEG_LEN;
+		msg_seg += HINIC_MBOX_SEG_LEN;
+
+		seq_id++;
+		header &= ~(HINIC_MBOX_HEADER_SET(HINIC_MBOX_HEADER_SEQID_MASK,
+						  SEQID));
+		header |= HINIC_MBOX_HEADER_SET(seq_id, SEQID);
+	}
+
+err_send_mbox_seg:
+	up(&func_to_func->msg_send_sem);
+
+	return err;
+}
+
+static void
+response_for_recv_func_mbox(struct hinic_mbox_func_to_func *func_to_func,
+			    struct hinic_recv_mbox *recv_mbox, int err,
+			    u16 out_size, u16 src_func_idx)
+{
+	struct mbox_msg_info msg_info = {0};
+
+	if (recv_mbox->ack_type == MBOX_ACK) {
+		msg_info.msg_id = recv_mbox->msg_info.msg_id;
+		if (err == HINIC_MBOX_PF_BUSY_ACTIVE_FW)
+			msg_info.status = HINIC_MBOX_PF_BUSY_ACTIVE_FW;
+		else if (err == HINIC_MBOX_VF_CMD_ERROR)
+			msg_info.status = HINIC_MBOX_VF_CMD_ERROR;
+		else if (err)
+			msg_info.status = HINIC_MBOX_PF_SEND_ERR;
+
+		/* if no data needs to response, set out_size to 1 */
+		if (!out_size || err)
+			out_size = MBOX_MSG_NO_DATA_LEN;
+
+		send_mbox_to_func(func_to_func, recv_mbox->mod, recv_mbox->cmd,
+				  recv_mbox->buf_out, out_size, src_func_idx,
+				  HINIC_HWIF_RESPONSE, MBOX_ACK,
+				  &msg_info);
+	}
+}
+
+static void recv_func_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
+				   struct hinic_recv_mbox *recv_mbox,
+				   u16 src_func_idx)
+{
+	void *buf_out = recv_mbox->buf_out;
+	u16 out_size = MBOX_MAX_BUF_SZ;
+	int err = 0;
+
+	if (HINIC_IS_VF(func_to_func->hwif)) {
+		err = recv_vf_mbox_handler(func_to_func, recv_mbox, buf_out,
+					   &out_size);
+	} else {
+		if (IS_PF_OR_PPF_SRC(src_func_idx))
+			dev_warn(&func_to_func->hwif->pdev->dev,
+				 "Unsupported pf2pf mbox msg\n");
+		else
+			err = recv_pf_from_vf_mbox_handler(func_to_func,
+							   recv_mbox,
+							   src_func_idx,
+							   buf_out, &out_size);
+	}
+
+	response_for_recv_func_mbox(func_to_func, recv_mbox, err, out_size,
+				    src_func_idx);
+	kfree(recv_mbox->buf_out);
+	kfree(recv_mbox->mbox);
+	kfree(recv_mbox);
+}
+
+static void set_mbox_to_func_event(struct hinic_mbox_func_to_func *func_to_func,
+				   enum mbox_event_state event_flag)
+{
+	spin_lock(&func_to_func->mbox_lock);
+	func_to_func->event_flag = event_flag;
+	spin_unlock(&func_to_func->mbox_lock);
+}
+
+static int mbox_resp_info_handler(struct hinic_mbox_func_to_func *func_to_func,
+				  struct hinic_recv_mbox *mbox_for_resp,
+				  enum hinic_mod_type mod, u16 cmd,
+				  void *buf_out, u16 *out_size)
+{
+	int err;
+
+	if (mbox_for_resp->msg_info.status) {
+		err = mbox_for_resp->msg_info.status;
+		if (err != HINIC_MBOX_PF_BUSY_ACTIVE_FW)
+			dev_err(&func_to_func->hwif->pdev->dev, "Mbox response error(0x%x)\n",
+				mbox_for_resp->msg_info.status);
+		return err;
+	}
+
+	if (buf_out && out_size) {
+		if (*out_size < mbox_for_resp->mbox_len) {
+			dev_err(&func_to_func->hwif->pdev->dev,
+				"Invalid response mbox message length: %d for mod %d cmd %d, should less than: %d\n",
+				mbox_for_resp->mbox_len, mod, cmd, *out_size);
+			return -EFAULT;
+		}
+
+		if (mbox_for_resp->mbox_len)
+			memcpy(buf_out, mbox_for_resp->mbox,
+			       mbox_for_resp->mbox_len);
+
+		*out_size = mbox_for_resp->mbox_len;
+	}
+
+	return 0;
+}
+
+int hinic_mbox_to_func(struct hinic_mbox_func_to_func *func_to_func,
+		       enum hinic_mod_type mod, u16 cmd, u16 dst_func,
+		       void *buf_in, u16 in_size, void *buf_out,
+		       u16 *out_size, u32 timeout)
+{
+	struct hinic_recv_mbox *mbox_for_resp;
+	struct mbox_msg_info msg_info = {0};
+	ulong timeo;
+	int err;
+
+	mbox_for_resp = &func_to_func->mbox_resp[dst_func];
+
+	down(&func_to_func->mbox_send_sem);
+
+	init_completion(&mbox_for_resp->recv_done);
+
+	msg_info.msg_id = MBOX_MSG_ID_INC(func_to_func);
+
+	set_mbox_to_func_event(func_to_func, EVENT_START);
+
+	err = send_mbox_to_func(func_to_func, mod, cmd, buf_in, in_size,
+				dst_func, HINIC_HWIF_DIRECT_SEND, MBOX_ACK,
+				&msg_info);
+	if (err) {
+		dev_err(&func_to_func->hwif->pdev->dev, "Send mailbox failed, msg_id: %d\n",
+			msg_info.msg_id);
+		set_mbox_to_func_event(func_to_func, EVENT_FAIL);
+		goto err_send_mbox;
+	}
+
+	timeo = msecs_to_jiffies(timeout ? timeout : HINIC_MBOX_COMP_TIME);
+	if (!wait_for_completion_timeout(&mbox_for_resp->recv_done, timeo)) {
+		set_mbox_to_func_event(func_to_func, EVENT_TIMEOUT);
+		dev_err(&func_to_func->hwif->pdev->dev,
+			"Send mbox msg timeout, msg_id: %d\n", msg_info.msg_id);
+		err = -ETIMEDOUT;
+		goto err_send_mbox;
+	}
+
+	set_mbox_to_func_event(func_to_func, EVENT_END);
+
+	err = mbox_resp_info_handler(func_to_func, mbox_for_resp, mod, cmd,
+				     buf_out, out_size);
+
+err_send_mbox:
+	up(&func_to_func->mbox_send_sem);
+
+	return err;
+}
+
+static int mbox_func_params_valid(struct hinic_mbox_func_to_func *func_to_func,
+				  void *buf_in, u16 in_size)
+{
+	if (in_size > HINIC_MBOX_DATA_SIZE) {
+		dev_err(&func_to_func->hwif->pdev->dev,
+			"Mbox msg len(%d) exceed limit(%d)\n",
+			in_size, HINIC_MBOX_DATA_SIZE);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int hinic_mbox_to_pf(struct hinic_hwdev *hwdev,
+		     enum hinic_mod_type mod, u8 cmd, void *buf_in,
+		     u16 in_size, void *buf_out, u16 *out_size, u32 timeout)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+	int err = mbox_func_params_valid(func_to_func, buf_in, in_size);
+
+	if (err)
+		return err;
+
+	if (!HINIC_IS_VF(hwdev->hwif)) {
+		dev_err(&hwdev->hwif->pdev->dev, "Params error, func_type: %d\n",
+			HINIC_FUNC_TYPE(hwdev->hwif));
+		return -EINVAL;
+	}
+
+	return hinic_mbox_to_func(func_to_func, mod, cmd,
+				  hinic_pf_id_of_vf_hw(hwdev->hwif), buf_in,
+				  in_size, buf_out, out_size, timeout);
+}
+
+int hinic_mbox_to_vf(struct hinic_hwdev *hwdev,
+		     enum hinic_mod_type mod, u16 vf_id, u8 cmd, void *buf_in,
+		     u16 in_size, void *buf_out, u16 *out_size, u32 timeout)
+{
+	struct hinic_mbox_func_to_func *func_to_func;
+	u16 dst_func_idx;
+	int err;
+
+	if (!hwdev)
+		return -EINVAL;
+
+	func_to_func = hwdev->func_to_func;
+	err = mbox_func_params_valid(func_to_func, buf_in, in_size);
+	if (err)
+		return err;
+
+	if (HINIC_IS_VF(hwdev->hwif)) {
+		dev_err(&hwdev->hwif->pdev->dev, "Params error, func_type: %d\n",
+			HINIC_FUNC_TYPE(hwdev->hwif));
+		return -EINVAL;
+	}
+
+	if (!vf_id) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"VF id(%d) error!\n", vf_id);
+		return -EINVAL;
+	}
+
+	/* vf_offset_to_pf + vf_id is the vf's global function id of vf in
+	 * this pf
+	 */
+	dst_func_idx = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+
+	return hinic_mbox_to_func(func_to_func, mod, cmd, dst_func_idx, buf_in,
+				  in_size, buf_out, out_size, timeout);
+}
+
+static int init_mbox_info(struct hinic_recv_mbox *mbox_info)
+{
+	int err;
+
+	mbox_info->seq_id = SEQ_ID_MAX_VAL;
+
+	mbox_info->mbox = kzalloc(MBOX_MAX_BUF_SZ, GFP_KERNEL);
+	if (!mbox_info->mbox)
+		return -ENOMEM;
+
+	mbox_info->buf_out = kzalloc(MBOX_MAX_BUF_SZ, GFP_KERNEL);
+	if (!mbox_info->buf_out) {
+		err = -ENOMEM;
+		goto err_alloc_buf_out;
+	}
+
+	atomic_set(&mbox_info->msg_cnt, 0);
+
+	return 0;
+
+err_alloc_buf_out:
+	kfree(mbox_info->mbox);
+
+	return err;
+}
+
+static void clean_mbox_info(struct hinic_recv_mbox *mbox_info)
+{
+	kfree(mbox_info->buf_out);
+	kfree(mbox_info->mbox);
+}
+
+static int alloc_mbox_info(struct hinic_hwdev *hwdev,
+			   struct hinic_recv_mbox *mbox_info)
+{
+	u16 func_idx, i;
+	int err;
+
+	for (func_idx = 0; func_idx < HINIC_MAX_FUNCTIONS; func_idx++) {
+		err = init_mbox_info(&mbox_info[func_idx]);
+		if (err) {
+			dev_err(&hwdev->hwif->pdev->dev, "Failed to init function %d mbox info\n",
+				func_idx);
+			goto err_init_mbox_info;
+		}
+	}
+
+	return 0;
+
+err_init_mbox_info:
+	for (i = 0; i < func_idx; i++)
+		clean_mbox_info(&mbox_info[i]);
+
+	return err;
+}
+
+static void free_mbox_info(struct hinic_recv_mbox *mbox_info)
+{
+	u16 func_idx;
+
+	for (func_idx = 0; func_idx < HINIC_MAX_FUNCTIONS; func_idx++)
+		clean_mbox_info(&mbox_info[func_idx]);
+}
+
+static void prepare_send_mbox(struct hinic_mbox_func_to_func *func_to_func)
+{
+	struct hinic_send_mbox *send_mbox = &func_to_func->send_mbox;
+
+	send_mbox->data = MBOX_AREA(func_to_func->hwif);
+}
+
+static int alloc_mbox_wb_status(struct hinic_mbox_func_to_func *func_to_func)
+{
+	struct hinic_send_mbox *send_mbox = &func_to_func->send_mbox;
+	struct hinic_hwdev *hwdev = func_to_func->hwdev;
+	u32 addr_h, addr_l;
+
+	send_mbox->wb_vaddr = dma_alloc_coherent(&hwdev->hwif->pdev->dev,
+						 MBOX_WB_STATUS_LEN,
+						 &send_mbox->wb_paddr,
+						 GFP_KERNEL);
+	if (!send_mbox->wb_vaddr)
+		return -ENOMEM;
+
+	send_mbox->wb_status = send_mbox->wb_vaddr;
+
+	addr_h = upper_32_bits(send_mbox->wb_paddr);
+	addr_l = lower_32_bits(send_mbox->wb_paddr);
+
+	hinic_hwif_write_reg(hwdev->hwif, HINIC_FUNC_CSR_MAILBOX_RESULT_H_OFF,
+			     addr_h);
+	hinic_hwif_write_reg(hwdev->hwif, HINIC_FUNC_CSR_MAILBOX_RESULT_L_OFF,
+			     addr_l);
+
+	return 0;
+}
+
+static void free_mbox_wb_status(struct hinic_mbox_func_to_func *func_to_func)
+{
+	struct hinic_send_mbox *send_mbox = &func_to_func->send_mbox;
+	struct hinic_hwdev *hwdev = func_to_func->hwdev;
+
+	hinic_hwif_write_reg(hwdev->hwif, HINIC_FUNC_CSR_MAILBOX_RESULT_H_OFF,
+			     0);
+	hinic_hwif_write_reg(hwdev->hwif, HINIC_FUNC_CSR_MAILBOX_RESULT_L_OFF,
+			     0);
+
+	dma_free_coherent(&hwdev->hwif->pdev->dev, MBOX_WB_STATUS_LEN,
+			  send_mbox->wb_vaddr,
+			  send_mbox->wb_paddr);
+}
+
+static int comm_pf_mbox_handler(void *handle, u16 vf_id, u8 cmd, void *buf_in,
+				u16 in_size, void *buf_out, u16 *out_size)
+{
+	struct hinic_hwdev *hwdev = handle;
+	struct hinic_pfhwdev *pfhwdev;
+	int err = 0;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	if (cmd == HINIC_COMM_CMD_START_FLR) {
+		*out_size = 0;
+	} else {
+		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+					cmd, buf_in, in_size, buf_out, out_size,
+					HINIC_MGMT_MSG_SYNC);
+		if (err && err != HINIC_MBOX_PF_BUSY_ACTIVE_FW)
+			dev_err(&hwdev->hwif->pdev->dev,
+				"PF mbox common callback handler err: %d\n",
+				err);
+	}
+
+	return err;
+}
+
+int hinic_func_to_func_init(struct hinic_hwdev *hwdev)
+{
+	struct hinic_mbox_func_to_func *func_to_func;
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	pfhwdev =  container_of(hwdev, struct hinic_pfhwdev, hwdev);
+	func_to_func = kzalloc(sizeof(*func_to_func), GFP_KERNEL);
+	if (!func_to_func)
+		return -ENOMEM;
+
+	hwdev->func_to_func = func_to_func;
+	func_to_func->hwdev = hwdev;
+	func_to_func->hwif = hwdev->hwif;
+	sema_init(&func_to_func->mbox_send_sem, 1);
+	sema_init(&func_to_func->msg_send_sem, 1);
+	spin_lock_init(&func_to_func->mbox_lock);
+	func_to_func->workq = create_singlethread_workqueue(HINIC_MBOX_WQ_NAME);
+	if (!func_to_func->workq) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to initialize MBOX workqueue\n");
+		err = -ENOMEM;
+		goto err_create_mbox_workq;
+	}
+
+	err = alloc_mbox_info(hwdev, func_to_func->mbox_send);
+	if (err) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to alloc mem for mbox_active\n");
+		goto err_alloc_mbox_for_send;
+	}
+
+	err = alloc_mbox_info(hwdev, func_to_func->mbox_resp);
+	if (err) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to alloc mem for mbox_passive\n");
+		goto err_alloc_mbox_for_resp;
+	}
+
+	err = alloc_mbox_wb_status(func_to_func);
+	if (err) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to alloc mbox write back status\n");
+		goto err_alloc_wb_status;
+	}
+
+	prepare_send_mbox(func_to_func);
+
+	hinic_aeq_register_hw_cb(&hwdev->aeqs, HINIC_MBX_FROM_FUNC,
+				 &pfhwdev->hwdev, hinic_mbox_func_aeqe_handler);
+	hinic_aeq_register_hw_cb(&hwdev->aeqs, HINIC_MBX_SEND_RSLT,
+				 &pfhwdev->hwdev, hinic_mbox_self_aeqe_handler);
+
+	if (!HINIC_IS_VF(hwdev->hwif))
+		hinic_register_pf_mbox_cb(hwdev, HINIC_MOD_COMM,
+					  comm_pf_mbox_handler);
+
+	return 0;
+
+err_alloc_wb_status:
+	free_mbox_info(func_to_func->mbox_resp);
+
+err_alloc_mbox_for_resp:
+	free_mbox_info(func_to_func->mbox_send);
+
+err_alloc_mbox_for_send:
+	destroy_workqueue(func_to_func->workq);
+
+err_create_mbox_workq:
+	kfree(func_to_func);
+
+	return err;
+}
+
+void hinic_func_to_func_free(struct hinic_hwdev *hwdev)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+
+	hinic_aeq_unregister_hw_cb(&hwdev->aeqs, HINIC_MBX_FROM_FUNC);
+	hinic_aeq_unregister_hw_cb(&hwdev->aeqs, HINIC_MBX_SEND_RSLT);
+
+	hinic_unregister_pf_mbox_cb(hwdev, HINIC_MOD_COMM);
+	/* destroy workqueue before free related mbox resources in case of
+	 * illegal resource access
+	 */
+	destroy_workqueue(func_to_func->workq);
+
+	free_mbox_wb_status(func_to_func);
+	free_mbox_info(func_to_func->mbox_resp);
+	free_mbox_info(func_to_func->mbox_send);
+
+	kfree(func_to_func);
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
new file mode 100644
index 000000000000..7b18559bfe80
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#ifndef HINIC_MBOX_H_
+#define HINIC_MBOX_H_
+
+#define HINIC_MBOX_PF_SEND_ERR		0x1
+#define HINIC_MBOX_PF_BUSY_ACTIVE_FW	0x2
+#define HINIC_MBOX_VF_CMD_ERROR		0x3
+
+#define HINIC_MAX_FUNCTIONS		512
+
+#define HINIC_MAX_PF_FUNCS		16
+
+#define HINIC_MBOX_WQ_NAME		"hinic_mbox"
+
+#define HINIC_FUNC_CSR_MAILBOX_DATA_OFF			0x80
+#define HINIC_FUNC_CSR_MAILBOX_CONTROL_OFF		0x0100
+#define HINIC_FUNC_CSR_MAILBOX_INT_OFFSET_OFF		0x0104
+#define HINIC_FUNC_CSR_MAILBOX_RESULT_H_OFF		0x0108
+#define HINIC_FUNC_CSR_MAILBOX_RESULT_L_OFF		0x010C
+
+enum hinic_mbox_ack_type {
+	MBOX_ACK,
+	MBOX_NO_ACK,
+};
+
+struct mbox_msg_info {
+	u8 msg_id;
+	u8 status;
+};
+
+struct hinic_recv_mbox {
+	struct completion	recv_done;
+	void			*mbox;
+	u8			cmd;
+	enum hinic_mod_type	mod;
+	u16			mbox_len;
+	void			*buf_out;
+	enum hinic_mbox_ack_type ack_type;
+	struct mbox_msg_info	msg_info;
+	u8			seq_id;
+	atomic_t		msg_cnt;
+};
+
+struct hinic_send_mbox {
+	struct completion	send_done;
+	u8			*data;
+
+	u64			*wb_status;
+	void			*wb_vaddr;
+	dma_addr_t		wb_paddr;
+};
+
+typedef void (*hinic_vf_mbox_cb)(void *handle, u8 cmd, void *buf_in,
+				u16 in_size, void *buf_out, u16 *out_size);
+typedef int (*hinic_pf_mbox_cb)(void *handle, u16 vf_id, u8 cmd, void *buf_in,
+				u16 in_size, void *buf_out, u16 *out_size);
+
+enum mbox_event_state {
+	EVENT_START = 0,
+	EVENT_FAIL,
+	EVENT_TIMEOUT,
+	EVENT_END,
+};
+
+enum hinic_mbox_cb_state {
+	HINIC_VF_MBOX_CB_REG = 0,
+	HINIC_VF_MBOX_CB_RUNNING,
+	HINIC_PF_MBOX_CB_REG,
+	HINIC_PF_MBOX_CB_RUNNING,
+	HINIC_PPF_MBOX_CB_REG,
+	HINIC_PPF_MBOX_CB_RUNNING,
+	HINIC_PPF_TO_PF_MBOX_CB_REG,
+	HINIC_PPF_TO_PF_MBOX_CB_RUNNIG,
+};
+
+struct hinic_mbox_func_to_func {
+	struct hinic_hwdev	*hwdev;
+	struct hinic_hwif		*hwif;
+
+	struct semaphore	mbox_send_sem;
+	struct semaphore	msg_send_sem;
+	struct hinic_send_mbox	send_mbox;
+
+	struct workqueue_struct *workq;
+
+	struct hinic_recv_mbox	mbox_resp[HINIC_MAX_FUNCTIONS];
+	struct hinic_recv_mbox	mbox_send[HINIC_MAX_FUNCTIONS];
+
+	hinic_vf_mbox_cb	vf_mbox_cb[HINIC_MOD_MAX];
+	hinic_pf_mbox_cb	pf_mbox_cb[HINIC_MOD_MAX];
+	unsigned long		pf_mbox_cb_state[HINIC_MOD_MAX];
+	unsigned long		vf_mbox_cb_state[HINIC_MOD_MAX];
+
+	u8 send_msg_id;
+	enum mbox_event_state event_flag;
+
+	/* lock for mbox event flag */
+	spinlock_t mbox_lock;
+};
+
+struct hinic_mbox_work {
+	struct work_struct work;
+	u16 src_func_idx;
+	struct hinic_mbox_func_to_func *func_to_func;
+	struct hinic_recv_mbox *recv_mbox;
+};
+
+struct vf_cmd_msg_handle {
+	u8 cmd;
+	int (*cmd_msg_handler)(void *hwdev, u16 vf_id,
+			       void *buf_in, u16 in_size,
+			       void *buf_out, u16 *out_size);
+};
+
+int hinic_register_pf_mbox_cb(struct hinic_hwdev *hwdev,
+			      enum hinic_mod_type mod,
+			      hinic_pf_mbox_cb callback);
+
+int hinic_register_vf_mbox_cb(struct hinic_hwdev *hwdev,
+			      enum hinic_mod_type mod,
+			      hinic_vf_mbox_cb callback);
+
+void hinic_unregister_pf_mbox_cb(struct hinic_hwdev *hwdev,
+				 enum hinic_mod_type mod);
+
+void hinic_unregister_vf_mbox_cb(struct hinic_hwdev *hwdev,
+				 enum hinic_mod_type mod);
+
+void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size);
+
+void hinic_mbox_self_aeqe_handler(void *handle, void *header, u8 size);
+
+int hinic_func_to_func_init(struct hinic_hwdev *hwdev);
+
+void hinic_func_to_func_free(struct hinic_hwdev *hwdev);
+
+int hinic_mbox_to_pf(struct hinic_hwdev *hwdev, enum hinic_mod_type mod,
+		     u8 cmd, void *buf_in, u16 in_size, void *buf_out,
+		     u16 *out_size, u32 timeout);
+
+int hinic_mbox_to_func(struct hinic_mbox_func_to_func *func_to_func,
+		       enum hinic_mod_type mod, u16 cmd, u16 dst_func,
+		       void *buf_in, u16 in_size, void *buf_out,
+		       u16 *out_size, u32 timeout);
+
+int hinic_mbox_to_vf(struct hinic_hwdev *hwdev,
+		     enum hinic_mod_type mod, u16 vf_id, u8 cmd, void *buf_in,
+		     u16 in_size, void *buf_out, u16 *out_size, u32 timeout);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index 182fba17b643..a5ab044f98cc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -60,6 +60,7 @@ enum hinic_cfg_cmd {
 };
 
 enum hinic_comm_cmd {
+	HINIC_COMM_CMD_START_FLR          = 0x1,
 	HINIC_COMM_CMD_IO_STATUS_GET    = 0x3,
 
 	HINIC_COMM_CMD_CMDQ_CTXT_SET    = 0x10,
-- 
2.17.1

