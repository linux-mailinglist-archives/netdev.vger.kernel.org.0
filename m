Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6AA61B850B
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 11:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgDYJEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 05:04:51 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3291 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbgDYJEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 05:04:46 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 19633E113486855A837E;
        Sat, 25 Apr 2020 17:04:37 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Sat, 25 Apr 2020 17:04:26 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <luobin9@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
Subject: [PATCH net-next v1 2/3] hinic: add sriov feature support
Date:   Sat, 25 Apr 2020 01:21:10 +0000
Message-ID: <20200425012111.4297-3-luobin9@huawei.com>
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

adds support of basic sriov feature including initialization and
tx/rx capabilities of virtual function

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/Makefile    |   2 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h |   3 +
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.c |  18 +-
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |   2 +-
 .../net/ethernet/huawei/hinic/hinic_hw_dev.c  | 123 +--
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  46 ++
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.c  |  98 ++-
 .../net/ethernet/huawei/hinic/hinic_hw_eqs.h  |   4 +-
 .../net/ethernet/huawei/hinic/hinic_hw_io.c   |  49 ++
 .../net/ethernet/huawei/hinic/hinic_hw_io.h   |  23 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c |  17 +-
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |  11 +-
 .../net/ethernet/huawei/hinic/hinic_hw_qp.c   |   7 +-
 .../net/ethernet/huawei/hinic/hinic_hw_qp.h   |   4 +-
 .../net/ethernet/huawei/hinic/hinic_hw_wq.c   |   9 +-
 .../net/ethernet/huawei/hinic/hinic_hw_wq.h   |   6 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  77 +-
 .../net/ethernet/huawei/hinic/hinic_port.c    |  76 +-
 .../net/ethernet/huawei/hinic/hinic_port.h    |   4 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c  |  15 +-
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 698 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.h   |  79 ++
 drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  17 +-
 23 files changed, 1195 insertions(+), 193 deletions(-)
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_sriov.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_sriov.h

diff --git a/drivers/net/ethernet/huawei/hinic/Makefile b/drivers/net/ethernet/huawei/hinic/Makefile
index a73862a64690..32a011ca44c3 100644
--- a/drivers/net/ethernet/huawei/hinic/Makefile
+++ b/drivers/net/ethernet/huawei/hinic/Makefile
@@ -4,4 +4,4 @@ obj-$(CONFIG_HINIC) += hinic.o
 hinic-y := hinic_main.o hinic_tx.o hinic_rx.o hinic_port.o hinic_hw_dev.o \
 	   hinic_hw_io.o hinic_hw_qp.o hinic_hw_cmdq.o hinic_hw_wq.o \
 	   hinic_hw_mgmt.o hinic_hw_api_cmd.o hinic_hw_eqs.o hinic_hw_if.o \
-	   hinic_common.o hinic_ethtool.o hinic_hw_mbox.o
+	   hinic_common.o hinic_ethtool.o hinic_hw_mbox.o hinic_sriov.o
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
index a209b14160cc..a621ebbf7610 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_dev.h
@@ -16,6 +16,7 @@
 #include "hinic_hw_dev.h"
 #include "hinic_tx.h"
 #include "hinic_rx.h"
+#include "hinic_sriov.h"
 
 #define HINIC_DRV_NAME          "hinic"
 
@@ -23,6 +24,7 @@ enum hinic_flags {
 	HINIC_LINK_UP = BIT(0),
 	HINIC_INTF_UP = BIT(1),
 	HINIC_RSS_ENABLE = BIT(2),
+	HINIC_LINK_DOWN = BIT(3),
 };
 
 struct hinic_rx_mode_work {
@@ -78,6 +80,7 @@ struct hinic_dev {
 	struct hinic_rss_type		rss_type;
 	u8				*rss_hkey_user;
 	s32				*rss_indir_user;
+	struct hinic_sriov_info sriov_info;
 };
 
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
index 5f2d57d1b2d3..33c5333657c1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c
@@ -64,7 +64,7 @@
 #define CMDQ_WQE_SIZE                   64
 #define CMDQ_DEPTH                      SZ_4K
 
-#define CMDQ_WQ_PAGE_SIZE               SZ_4K
+#define CMDQ_WQ_PAGE_SIZE               SZ_256K
 
 #define WQE_LCMD_SIZE                   64
 #define WQE_SCMD_SIZE                   64
@@ -705,7 +705,7 @@ static void cmdq_init_queue_ctxt(struct hinic_cmdq_ctxt *cmdq_ctxt,
 	/* The data in the HW is in Big Endian Format */
 	wq_first_page_paddr = be64_to_cpu(*wq->block_vaddr);
 
-	pfn = CMDQ_PFN(wq_first_page_paddr, wq->wq_page_size);
+	pfn = CMDQ_PFN(wq_first_page_paddr, SZ_4K);
 
 	ctxt_info->curr_wqe_page_pfn =
 		HINIC_CMDQ_CTXT_PAGE_INFO_SET(pfn, CURR_WQE_PAGE_PFN)   |
@@ -714,16 +714,19 @@ static void cmdq_init_queue_ctxt(struct hinic_cmdq_ctxt *cmdq_ctxt,
 		HINIC_CMDQ_CTXT_PAGE_INFO_SET(1, CEQ_EN)                |
 		HINIC_CMDQ_CTXT_PAGE_INFO_SET(cmdq->wrapped, WRAPPED);
 
-	/* block PFN - Read Modify Write */
-	cmdq_first_block_paddr = cmdq_pages->page_paddr;
+	if (wq->num_q_pages != 1) {
+		/* block PFN - Read Modify Write */
+		cmdq_first_block_paddr = cmdq_pages->page_paddr;
 
-	pfn = CMDQ_PFN(cmdq_first_block_paddr, wq->wq_page_size);
+		pfn = CMDQ_PFN(cmdq_first_block_paddr, wq->wq_page_size);
+	}
 
 	ctxt_info->wq_block_pfn =
 		HINIC_CMDQ_CTXT_BLOCK_INFO_SET(pfn, WQ_BLOCK_PFN) |
 		HINIC_CMDQ_CTXT_BLOCK_INFO_SET(atomic_read(&wq->cons_idx), CI);
 
 	cmdq_ctxt->func_idx = HINIC_HWIF_FUNC_IDX(cmdqs->hwif);
+	cmdq_ctxt->ppf_idx = HINIC_HWIF_PPF_IDX(cmdqs->hwif);
 	cmdq_ctxt->cmdq_type  = cmdq->cmdq_type;
 }
 
@@ -795,11 +798,6 @@ static int init_cmdqs_ctxt(struct hinic_hwdev *hwdev,
 	size_t cmdq_ctxts_size;
 	int err;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI function type\n");
-		return -EINVAL;
-	}
-
 	cmdq_ctxts_size = HINIC_MAX_CMDQ_TYPES * sizeof(*cmdq_ctxts);
 	cmdq_ctxts = devm_kzalloc(&pdev->dev, cmdq_ctxts_size, GFP_KERNEL);
 	if (!cmdq_ctxts)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
index 7a434b653faa..3e4b0aef9fe6 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
@@ -122,7 +122,7 @@ struct hinic_cmdq_ctxt {
 
 	u16     func_idx;
 	u8      cmdq_type;
-	u8      rsvd1[1];
+	u8      ppf_idx;
 
 	u8      rsvd2[4];
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index f2cf6f7ffc34..e5cab58e4ddd 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -15,7 +15,9 @@
 #include <linux/jiffies.h>
 #include <linux/log2.h>
 #include <linux/err.h>
+#include <linux/netdevice.h>
 
+#include "hinic_sriov.h"
 #include "hinic_hw_if.h"
 #include "hinic_hw_eqs.h"
 #include "hinic_hw_mgmt.h"
@@ -46,20 +48,6 @@ enum hw_ioctxt_set_cmdq_depth {
 	HW_IOCTXT_SET_CMDQ_DEPTH_DEFAULT,
 };
 
-/* HW struct */
-struct hinic_dev_cap {
-	u8      status;
-	u8      version;
-	u8      rsvd0[6];
-
-	u8      rsvd1[5];
-	u8      intr_type;
-	u8      rsvd2[66];
-	u16     max_sqs;
-	u16     max_rqs;
-	u8      rsvd3[208];
-};
-
 /**
  * get_capability - convert device capabilities to NIC capabilities
  * @hwdev: the HW device to set and convert device capabilities for
@@ -67,16 +55,13 @@ struct hinic_dev_cap {
  *
  * Return 0 - Success, negative - Failure
  **/
-static int get_capability(struct hinic_hwdev *hwdev,
-			  struct hinic_dev_cap *dev_cap)
+static int parse_capability(struct hinic_hwdev *hwdev,
+			    struct hinic_dev_cap *dev_cap)
 {
 	struct hinic_cap *nic_cap = &hwdev->nic_cap;
 	int num_aeqs, num_ceqs, num_irqs;
 
-	if (!HINIC_IS_PF(hwdev->hwif) && !HINIC_IS_PPF(hwdev->hwif))
-		return -EINVAL;
-
-	if (dev_cap->intr_type != INTR_MSIX_TYPE)
+	if (!HINIC_IS_VF(hwdev->hwif) && dev_cap->intr_type != INTR_MSIX_TYPE)
 		return -EFAULT;
 
 	num_aeqs = HINIC_HWIF_NUM_AEQS(hwdev->hwif);
@@ -89,13 +74,19 @@ static int get_capability(struct hinic_hwdev *hwdev,
 	if (nic_cap->num_qps > HINIC_Q_CTXT_MAX)
 		nic_cap->num_qps = HINIC_Q_CTXT_MAX;
 
-	nic_cap->max_qps = dev_cap->max_sqs + 1;
-	if (nic_cap->max_qps != (dev_cap->max_rqs + 1))
-		return -EFAULT;
+	if (!HINIC_IS_VF(hwdev->hwif))
+		nic_cap->max_qps = dev_cap->max_sqs + 1;
+	else
+		nic_cap->max_qps = dev_cap->max_sqs;
 
 	if (nic_cap->num_qps > nic_cap->max_qps)
 		nic_cap->num_qps = nic_cap->max_qps;
 
+	if (!HINIC_IS_VF(hwdev->hwif)) {
+		nic_cap->max_vf = dev_cap->max_vf;
+		nic_cap->max_vf_qps = dev_cap->max_vf_sqs + 1;
+	}
+
 	return 0;
 }
 
@@ -105,27 +96,26 @@ static int get_capability(struct hinic_hwdev *hwdev,
  *
  * Return 0 - Success, negative - Failure
  **/
-static int get_cap_from_fw(struct hinic_pfhwdev *pfhwdev)
+static int get_capability(struct hinic_pfhwdev *pfhwdev)
 {
 	struct hinic_hwdev *hwdev = &pfhwdev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_dev_cap dev_cap;
-	u16 in_len, out_len;
+	u16 out_len;
 	int err;
 
-	in_len = 0;
 	out_len = sizeof(dev_cap);
 
 	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_CFGM,
-				HINIC_CFG_NIC_CAP, &dev_cap, in_len, &dev_cap,
-				&out_len, HINIC_MGMT_MSG_SYNC);
+				HINIC_CFG_NIC_CAP, &dev_cap, sizeof(dev_cap),
+				&dev_cap, &out_len, HINIC_MGMT_MSG_SYNC);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to get capability from FW\n");
 		return err;
 	}
 
-	return get_capability(hwdev, &dev_cap);
+	return parse_capability(hwdev, &dev_cap);
 }
 
 /**
@@ -144,15 +134,14 @@ static int get_dev_cap(struct hinic_hwdev *hwdev)
 	switch (HINIC_FUNC_TYPE(hwif)) {
 	case HINIC_PPF:
 	case HINIC_PF:
+	case HINIC_VF:
 		pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
-
-		err = get_cap_from_fw(pfhwdev);
+		err = get_capability(pfhwdev);
 		if (err) {
-			dev_err(&pdev->dev, "Failed to get capability from FW\n");
+			dev_err(&pdev->dev, "Failed to get capability\n");
 			return err;
 		}
 		break;
-
 	default:
 		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
 		return -EINVAL;
@@ -225,15 +214,8 @@ static void disable_msix(struct hinic_hwdev *hwdev)
 int hinic_port_msg_cmd(struct hinic_hwdev *hwdev, enum hinic_port_cmd cmd,
 		       void *buf_in, u16 in_size, void *buf_out, u16 *out_size)
 {
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
 
 	return hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC, cmd,
@@ -252,14 +234,9 @@ static int init_fw_ctxt(struct hinic_hwdev *hwdev)
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_cmd_fw_ctxt fw_ctxt;
-	u16 out_size;
+	u16 out_size = sizeof(fw_ctxt);
 	int err;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	fw_ctxt.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 	fw_ctxt.rx_buf_sz = HINIC_RX_BUF_SZ;
 
@@ -288,14 +265,8 @@ static int set_hw_ioctxt(struct hinic_hwdev *hwdev, unsigned int rq_depth,
 {
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct hinic_cmd_hw_ioctxt hw_ioctxt;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	hw_ioctxt.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 	hw_ioctxt.ppf_idx = HINIC_HWIF_PPF_IDX(hwif);
 
@@ -374,11 +345,6 @@ static int clear_io_resources(struct hinic_hwdev *hwdev)
 	struct hinic_pfhwdev *pfhwdev;
 	int err;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	/* sleep 100ms to wait for firmware stopping I/O */
 	msleep(100);
 
@@ -410,14 +376,8 @@ static int set_resources_state(struct hinic_hwdev *hwdev,
 {
 	struct hinic_cmd_set_res_state res_state;
 	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	res_state.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 	res_state.state = state;
 
@@ -441,8 +401,8 @@ static int get_base_qpn(struct hinic_hwdev *hwdev, u16 *base_qpn)
 {
 	struct hinic_cmd_base_qpn cmd_base_qpn;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(cmd_base_qpn);
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
 	int err;
 
 	cmd_base_qpn.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
@@ -488,7 +448,7 @@ int hinic_hwdev_ifup(struct hinic_hwdev *hwdev)
 	num_ceqs = HINIC_HWIF_NUM_CEQS(hwif);
 
 	ceq_msix_entries = &hwdev->msix_entries[num_aeqs];
-
+	func_to_io->hwdev = hwdev;
 	err = hinic_io_init(func_to_io, hwif, nic_cap->max_qps, num_ceqs,
 			    ceq_msix_entries);
 	if (err) {
@@ -558,17 +518,10 @@ void hinic_hwdev_cb_register(struct hinic_hwdev *hwdev,
 					     u16 in_size, void *buf_out,
 					     u16 *out_size))
 {
-	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
 	struct hinic_nic_cb *nic_cb;
 	u8 cmd_cb;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "unsupported PCI Function type\n");
-		return;
-	}
-
 	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
 
 	cmd_cb = cmd - HINIC_MGMT_MSG_CMD_BASE;
@@ -588,15 +541,12 @@ void hinic_hwdev_cb_unregister(struct hinic_hwdev *hwdev,
 			       enum hinic_mgmt_msg_cmd cmd)
 {
 	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
 	struct hinic_nic_cb *nic_cb;
 	u8 cmd_cb;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "unsupported PCI Function type\n");
+	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif))
 		return;
-	}
 
 	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
 
@@ -742,12 +692,6 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 		return ERR_PTR(err);
 	}
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		err = -EFAULT;
-		goto err_func_type;
-	}
-
 	pfhwdev = devm_kzalloc(&pdev->dev, sizeof(*pfhwdev), GFP_KERNEL);
 	if (!pfhwdev) {
 		err = -ENOMEM;
@@ -791,6 +735,12 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 		goto err_dev_cap;
 	}
 
+	err = hinic_vf_func_init(hwdev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to init nic mbox\n");
+		goto err_vf_func_init;
+	}
+
 	err = init_fw_ctxt(hwdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to init function table\n");
@@ -807,6 +757,8 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 
 err_resources_state:
 err_init_fw_ctxt:
+	hinic_vf_func_free(hwdev);
+err_vf_func_init:
 err_dev_cap:
 	free_pfhwdev(pfhwdev);
 
@@ -818,7 +770,6 @@ struct hinic_hwdev *hinic_init_hwdev(struct pci_dev *pdev)
 
 err_init_msix:
 err_pfhwdev_alloc:
-err_func_type:
 	hinic_free_hwif(hwif);
 	return ERR_PTR(err);
 }
@@ -949,15 +900,9 @@ int hinic_hwdev_hw_ci_addr_set(struct hinic_hwdev *hwdev, struct hinic_sq *sq,
 {
 	struct hinic_qp *qp = container_of(sq, struct hinic_qp, sq);
 	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_pfhwdev *pfhwdev;
 	struct hinic_cmd_hw_ci hw_ci;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "Unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	hw_ci.dma_attr_off  = 0;
 	hw_ci.pending_limit = pending_limit;
 	hw_ci.coalesc_timer = coalesc_timer;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 2574086aa314..531d1072e0df 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -23,12 +23,20 @@
 #define HINIC_MGMT_NUM_MSG_CMD  (HINIC_MGMT_MSG_CMD_MAX - \
 				 HINIC_MGMT_MSG_CMD_BASE)
 
+#define HINIC_PF_SET_VF_ALREADY				0x4
+#define HINIC_MGMT_STATUS_EXIST				0x6
+
 struct hinic_cap {
 	u16     max_qps;
 	u16     num_qps;
+	u8		max_vf;
+	u16     max_vf_qps;
 };
 
 enum hinic_port_cmd {
+	HINIC_PORT_CMD_VF_REGISTER = 0x0,
+	HINIC_PORT_CMD_VF_UNREGISTER = 0x1,
+
 	HINIC_PORT_CMD_CHANGE_MTU       = 2,
 
 	HINIC_PORT_CMD_ADD_VLAN         = 3,
@@ -84,10 +92,18 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_GET_GLOBAL_QPN   = 102,
 
+	HINIC_PORT_CMD_SET_VF_VLAN	= 106,
+
+	HINIC_PORT_CMD_CLR_VF_VLAN,
+
 	HINIC_PORT_CMD_SET_TSO          = 112,
 
 	HINIC_PORT_CMD_SET_RQ_IQ_MAP	= 115,
 
+	HINIC_PORT_CMD_LINK_STATUS_REPORT = 160,
+
+	HINIC_PORT_CMD_UPDATE_MAC = 164,
+
 	HINIC_PORT_CMD_GET_CAP          = 170,
 
 	HINIC_PORT_CMD_SET_LRO_TIMER	= 244,
@@ -192,6 +208,17 @@ struct hinic_cmd_set_res_state {
 	u32     rsvd2;
 };
 
+struct hinic_ceq_ctrl_reg {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	u16 func_id;
+	u16 q_id;
+	u32 ctrl0;
+	u32 ctrl1;
+};
+
 struct hinic_cmd_base_qpn {
 	u8      status;
 	u8      version;
@@ -248,6 +275,25 @@ struct hinic_pfhwdev {
 	struct hinic_nic_cb             nic_cb[HINIC_MGMT_NUM_MSG_CMD];
 };
 
+struct hinic_dev_cap {
+	u8      status;
+	u8      version;
+	u8      rsvd0[6];
+
+	u8      rsvd1[5];
+	u8      intr_type;
+	u8	max_cos_id;
+	u8	er_id;
+	u8	port_id;
+	u8      max_vf;
+	u8      rsvd2[62];
+	u16     max_sqs;
+	u16	max_rqs;
+	u16	max_vf_sqs;
+	u16     max_vf_rqs;
+	u8      rsvd3[204];
+};
+
 void hinic_hwdev_cb_register(struct hinic_hwdev *hwdev,
 			     enum hinic_mgmt_msg_cmd cmd, void *handle,
 			     void (*handler)(void *handle, void *buf_in,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index c0b6bcb067cd..397936cac304 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -17,6 +17,7 @@
 #include <asm/byteorder.h>
 #include <asm/barrier.h>
 
+#include "hinic_hw_dev.h"
 #include "hinic_hw_csr.h"
 #include "hinic_hw_if.h"
 #include "hinic_hw_eqs.h"
@@ -416,11 +417,11 @@ static irqreturn_t ceq_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static void set_ctrl0(struct hinic_eq *eq)
+static u32 get_ctrl0_val(struct hinic_eq *eq, u32 addr)
 {
 	struct msix_entry *msix_entry = &eq->msix_entry;
 	enum hinic_eq_type type = eq->type;
-	u32 addr, val, ctrl0;
+	u32 val, ctrl0;
 
 	if (type == HINIC_AEQ) {
 		/* RMW Ctrl0 */
@@ -440,9 +441,7 @@ static void set_ctrl0(struct hinic_eq *eq)
 			HINIC_AEQ_CTRL_0_SET(EQ_INT_MODE_ARMED, INT_MODE);
 
 		val |= ctrl0;
-
-		hinic_hwif_write_reg(eq->hwif, addr, val);
-	} else if (type == HINIC_CEQ) {
+	} else {
 		/* RMW Ctrl0 */
 		addr = HINIC_CSR_CEQ_CTRL_0_ADDR(eq->q_id);
 
@@ -462,16 +461,28 @@ static void set_ctrl0(struct hinic_eq *eq)
 			HINIC_CEQ_CTRL_0_SET(EQ_INT_MODE_ARMED, INTR_MODE);
 
 		val |= ctrl0;
-
-		hinic_hwif_write_reg(eq->hwif, addr, val);
 	}
+	return val;
 }
 
-static void set_ctrl1(struct hinic_eq *eq)
+static void set_ctrl0(struct hinic_eq *eq)
 {
+	u32 val, addr;
+
+	if (eq->type == HINIC_AEQ)
+		addr = HINIC_CSR_AEQ_CTRL_0_ADDR(eq->q_id);
+	else
+		addr = HINIC_CSR_CEQ_CTRL_0_ADDR(eq->q_id);
+
+	val = get_ctrl0_val(eq, addr);
+
+	hinic_hwif_write_reg(eq->hwif, addr, val);
+}
+
+static u32 get_ctrl1_val(struct hinic_eq *eq, u32 addr)
+{
+	u32 page_size_val, elem_size, val, ctrl1;
 	enum hinic_eq_type type = eq->type;
-	u32 page_size_val, elem_size;
-	u32 addr, val, ctrl1;
 
 	if (type == HINIC_AEQ) {
 		/* RMW Ctrl1 */
@@ -491,9 +502,7 @@ static void set_ctrl1(struct hinic_eq *eq)
 			HINIC_AEQ_CTRL_1_SET(page_size_val, PAGE_SIZE);
 
 		val |= ctrl1;
-
-		hinic_hwif_write_reg(eq->hwif, addr, val);
-	} else if (type == HINIC_CEQ) {
+	} else {
 		/* RMW Ctrl1 */
 		addr = HINIC_CSR_CEQ_CTRL_1_ADDR(eq->q_id);
 
@@ -508,19 +517,70 @@ static void set_ctrl1(struct hinic_eq *eq)
 			HINIC_CEQ_CTRL_1_SET(page_size_val, PAGE_SIZE);
 
 		val |= ctrl1;
+	}
+	return val;
+}
 
-		hinic_hwif_write_reg(eq->hwif, addr, val);
+static void set_ctrl1(struct hinic_eq *eq)
+{
+	u32 addr, val;
+
+	if (eq->type == HINIC_AEQ)
+		addr = HINIC_CSR_AEQ_CTRL_1_ADDR(eq->q_id);
+	else
+		addr = HINIC_CSR_CEQ_CTRL_1_ADDR(eq->q_id);
+
+	val = get_ctrl1_val(eq, addr);
+
+	hinic_hwif_write_reg(eq->hwif, addr, val);
+}
+
+static int set_ceq_ctrl_reg(struct hinic_eq *eq)
+{
+	struct hinic_ceq_ctrl_reg ceq_ctrl = {0};
+	struct hinic_hwdev *hwdev = eq->hwdev;
+	u16 out_size = sizeof(ceq_ctrl);
+	u16 in_size = sizeof(ceq_ctrl);
+	struct hinic_pfhwdev *pfhwdev;
+	u32 addr;
+	int err;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	addr = HINIC_CSR_CEQ_CTRL_0_ADDR(eq->q_id);
+	ceq_ctrl.ctrl0 = get_ctrl0_val(eq, addr);
+	addr = HINIC_CSR_CEQ_CTRL_1_ADDR(eq->q_id);
+	ceq_ctrl.ctrl1 = get_ctrl1_val(eq, addr);
+
+	ceq_ctrl.func_id = HINIC_HWIF_FUNC_IDX(hwdev->hwif);
+	ceq_ctrl.q_id = eq->q_id;
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_CEQ_CTRL_REG_WR_BY_UP,
+				&ceq_ctrl, in_size,
+				&ceq_ctrl, &out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || !out_size || ceq_ctrl.status) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"Failed to set ceq %d ctrl reg, err: %d status: 0x%x, out_size: 0x%x\n",
+			eq->q_id, err, ceq_ctrl.status, out_size);
+		return -EFAULT;
 	}
+
+	return 0;
 }
 
 /**
  * set_eq_ctrls - setting eq's ctrl registers
  * @eq: the Event Queue for setting
  **/
-static void set_eq_ctrls(struct hinic_eq *eq)
+static int set_eq_ctrls(struct hinic_eq *eq)
 {
+	if (HINIC_IS_VF(eq->hwif) && eq->type == HINIC_CEQ)
+		return set_ceq_ctrl_reg(eq);
+
 	set_ctrl0(eq);
 	set_ctrl1(eq);
+	return 0;
 }
 
 /**
@@ -703,7 +763,12 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 		return -EINVAL;
 	}
 
-	set_eq_ctrls(eq);
+	err = set_eq_ctrls(eq);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set eq ctrls\n");
+		return err;
+	}
+
 	eq_update_ci(eq, EQ_ARMED);
 
 	err = alloc_eq_pages(eq);
@@ -859,6 +924,7 @@ int hinic_ceqs_init(struct hinic_ceqs *ceqs, struct hinic_hwif *hwif,
 	ceqs->num_ceqs = num_ceqs;
 
 	for (q_id = 0; q_id < num_ceqs; q_id++) {
+		ceqs->ceq[q_id].hwdev = ceqs->hwdev;
 		err = init_eq(&ceqs->ceq[q_id], hwif, HINIC_CEQ, q_id, q_len,
 			      page_size, msix_entries[q_id]);
 		if (err) {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
index d73256da4b80..74b9ff90640c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h
@@ -172,7 +172,7 @@ struct hinic_eq_work {
 
 struct hinic_eq {
 	struct hinic_hwif       *hwif;
-
+	struct hinic_hwdev      *hwdev;
 	enum hinic_eq_type      type;
 	int                     q_id;
 	u32                     q_len;
@@ -220,7 +220,7 @@ struct hinic_ceq_cb {
 
 struct hinic_ceqs {
 	struct hinic_hwif       *hwif;
-
+	struct hinic_hwdev		*hwdev;
 	struct hinic_eq         ceq[HINIC_MAX_CEQS];
 	int                     num_ceqs;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
index d66f86fa3f46..a4581c988a63 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/err.h>
 
+#include "hinic_hw_dev.h"
 #include "hinic_hw_if.h"
 #include "hinic_hw_eqs.h"
 #include "hinic_hw_wqe.h"
@@ -34,6 +35,8 @@
 #define DB_IDX(db, db_base)             \
 	(((unsigned long)(db) - (unsigned long)(db_base)) / HINIC_DB_PAGE_SIZE)
 
+#define HINIC_PAGE_SIZE_HW(pg_size)	((u8)ilog2((u32)((pg_size) >> 12)))
+
 enum io_cmd {
 	IO_CMD_MODIFY_QUEUE_CTXT = 0,
 	IO_CMD_CLEAN_QUEUE_CTXT,
@@ -484,6 +487,33 @@ void hinic_io_destroy_qps(struct hinic_func_to_io *func_to_io, int num_qps)
 	devm_kfree(&pdev->dev, func_to_io->qps);
 }
 
+int hinic_set_wq_page_size(struct hinic_hwdev *hwdev, u16 func_idx,
+			   u32 page_size)
+{
+	struct hinic_wq_page_size page_size_info = {0};
+	u16 out_size = sizeof(page_size_info);
+	struct hinic_pfhwdev *pfhwdev;
+	int err;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	page_size_info.func_idx = func_idx;
+	page_size_info.ppf_idx = HINIC_HWIF_PPF_IDX(hwdev->hwif);
+	page_size_info.page_size = HINIC_PAGE_SIZE_HW(page_size);
+
+	err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_COMM_CMD_PAGESIZE_SET, &page_size_info,
+				sizeof(page_size_info), &page_size_info,
+				&out_size, HINIC_MGMT_MSG_SYNC);
+	if (err || !out_size || page_size_info.status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set wq page size, err: %d, status: 0x%x, out_size: 0x%0x\n",
+			err, page_size_info.status, out_size);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 /**
  * hinic_io_init - Initialize the IO components
  * @func_to_io: func to io channel that holds the IO components
@@ -506,6 +536,7 @@ int hinic_io_init(struct hinic_func_to_io *func_to_io,
 	func_to_io->hwif = hwif;
 	func_to_io->qps = NULL;
 	func_to_io->max_qps = max_qps;
+	func_to_io->ceqs.hwdev = func_to_io->hwdev;
 
 	err = hinic_ceqs_init(&func_to_io->ceqs, hwif, num_ceqs,
 			      HINIC_DEFAULT_CEQ_LEN, HINIC_EQ_PAGE_SIZE,
@@ -541,6 +572,14 @@ int hinic_io_init(struct hinic_func_to_io *func_to_io,
 		func_to_io->cmdq_db_area[cmdq] = db_area;
 	}
 
+	err = hinic_set_wq_page_size(func_to_io->hwdev,
+				     HINIC_HWIF_FUNC_IDX(hwif),
+				     HINIC_DEFAULT_WQ_PAGE_SIZE);
+	if (err) {
+		dev_err(&func_to_io->hwif->pdev->dev, "Failed to set wq page size\n");
+		goto init_wq_pg_size_err;
+	}
+
 	err = hinic_init_cmdqs(&func_to_io->cmdqs, hwif,
 			       func_to_io->cmdq_db_area);
 	if (err) {
@@ -551,6 +590,11 @@ int hinic_io_init(struct hinic_func_to_io *func_to_io,
 	return 0;
 
 err_init_cmdqs:
+	if (!HINIC_IS_VF(func_to_io->hwif))
+		hinic_set_wq_page_size(func_to_io->hwdev,
+				       HINIC_HWIF_FUNC_IDX(hwif),
+				       HINIC_HW_WQ_PAGE_SIZE);
+init_wq_pg_size_err:
 err_db_area:
 	for (type = HINIC_CMDQ_SYNC; type < cmdq; type++)
 		return_db_area(func_to_io, func_to_io->cmdq_db_area[type]);
@@ -575,6 +619,11 @@ void hinic_io_free(struct hinic_func_to_io *func_to_io)
 
 	hinic_free_cmdqs(&func_to_io->cmdqs);
 
+	if (!HINIC_IS_VF(func_to_io->hwif))
+		hinic_set_wq_page_size(func_to_io->hwdev,
+				       HINIC_HWIF_FUNC_IDX(func_to_io->hwif),
+				       HINIC_HW_WQ_PAGE_SIZE);
+
 	for (cmdq = HINIC_CMDQ_SYNC; cmdq < HINIC_MAX_CMDQ_TYPES; cmdq++)
 		return_db_area(func_to_io, func_to_io->cmdq_db_area[cmdq]);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
index cac2b722e7dc..28c0594f636d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_io.h
@@ -20,6 +20,8 @@
 
 #define HINIC_DB_PAGE_SIZE      SZ_4K
 #define HINIC_DB_SIZE           SZ_4M
+#define HINIC_HW_WQ_PAGE_SIZE	SZ_4K
+#define HINIC_DEFAULT_WQ_PAGE_SIZE SZ_256K
 
 #define HINIC_DB_MAX_AREAS      (HINIC_DB_SIZE / HINIC_DB_PAGE_SIZE)
 
@@ -47,7 +49,7 @@ struct hinic_free_db_area {
 
 struct hinic_func_to_io {
 	struct hinic_hwif       *hwif;
-
+	struct hinic_hwdev      *hwdev;
 	struct hinic_ceqs       ceqs;
 
 	struct hinic_wqs        wqs;
@@ -69,8 +71,27 @@ struct hinic_func_to_io {
 	void __iomem                    *cmdq_db_area[HINIC_MAX_CMDQ_TYPES];
 
 	struct hinic_cmdqs              cmdqs;
+
+	u16			max_vfs;
+	struct vf_data_storage	*vf_infos;
+	u8			link_status;
 };
 
+struct hinic_wq_page_size {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+
+	u16	func_idx;
+	u8	ppf_idx;
+	u8	page_size;
+
+	u32	rsvd1;
+};
+
+int hinic_set_wq_page_size(struct hinic_hwdev *hwdev, u16 func_idx,
+			   u32 page_size);
+
 int hinic_io_create_qps(struct hinic_func_to_io *func_to_io,
 			u16 base_qpn, int num_qps,
 			struct msix_entry *sq_msix_entries,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index 8995e32dd1c0..eef855f11a01 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -353,7 +353,11 @@ int hinic_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		return -EINVAL;
 	}
 
-	return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
+	if (HINIC_IS_VF(hwif))
+		return hinic_mbox_to_pf(pf_to_mgmt->hwdev, mod, cmd, buf_in,
+					in_size, buf_out, out_size, 0);
+	else
+		return msg_to_mgmt_sync(pf_to_mgmt, mod, cmd, buf_in, in_size,
 				buf_out, out_size, MGMT_DIRECT_SEND,
 				MSG_NOT_RESP);
 }
@@ -390,8 +394,8 @@ static void mgmt_recv_msg_handler(struct hinic_pf_to_mgmt *pf_to_mgmt,
 			    recv_msg->msg, recv_msg->msg_len,
 			    buf_out, &out_size);
 	else
-		dev_err(&pdev->dev, "No MGMT msg handler, mod = %d\n",
-			recv_msg->mod);
+		dev_err(&pdev->dev, "No MGMT msg handler, mod: %d, cmd: %d\n",
+			recv_msg->mod, recv_msg->cmd);
 
 	mgmt_cb->state &= ~HINIC_MGMT_CB_RUNNING;
 
@@ -553,6 +557,10 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 	int err;
 
 	pf_to_mgmt->hwif = hwif;
+	pf_to_mgmt->hwdev = hwdev;
+
+	if (HINIC_IS_VF(hwif))
+		return 0;
 
 	sema_init(&pf_to_mgmt->sync_msg_lock, 1);
 	pf_to_mgmt->sync_msg_id = 0;
@@ -584,6 +592,9 @@ void hinic_pf_to_mgmt_free(struct hinic_pf_to_mgmt *pf_to_mgmt)
 	struct hinic_pfhwdev *pfhwdev = mgmt_to_pfhwdev(pf_to_mgmt);
 	struct hinic_hwdev *hwdev = &pfhwdev->hwdev;
 
+	if (HINIC_IS_VF(hwdev->hwif))
+		return;
+
 	hinic_aeq_unregister_hw_cb(&hwdev->aeqs, HINIC_MSG_FROM_MGMT_CPU);
 	hinic_api_cmd_free(pf_to_mgmt->cmd_chain);
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index a5ab044f98cc..c2b142c08b0e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -62,6 +62,7 @@ enum hinic_cfg_cmd {
 enum hinic_comm_cmd {
 	HINIC_COMM_CMD_START_FLR          = 0x1,
 	HINIC_COMM_CMD_IO_STATUS_GET    = 0x3,
+	HINIC_COMM_CMD_DMA_ATTR_SET	    = 0x4,
 
 	HINIC_COMM_CMD_CMDQ_CTXT_SET    = 0x10,
 	HINIC_COMM_CMD_CMDQ_CTXT_GET    = 0x11,
@@ -75,7 +76,13 @@ enum hinic_comm_cmd {
 
 	HINIC_COMM_CMD_IO_RES_CLEAR     = 0x29,
 
-	HINIC_COMM_CMD_MAX              = 0x32,
+	HINIC_COMM_CMD_CEQ_CTRL_REG_WR_BY_UP = 0x33,
+
+	HINIC_COMM_CMD_L2NIC_RESET		= 0x4b,
+
+	HINIC_COMM_CMD_PAGESIZE_SET	= 0x50,
+
+	HINIC_COMM_CMD_MAX              = 0x51,
 };
 
 enum hinic_mgmt_cb_state {
@@ -108,7 +115,7 @@ struct hinic_mgmt_cb {
 
 struct hinic_pf_to_mgmt {
 	struct hinic_hwif               *hwif;
-
+	struct hinic_hwdev		*hwdev;
 	struct semaphore                sync_msg_lock;
 	u16                             sync_msg_id;
 	u8                              *sync_msg_buf;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
index be364b7a7019..20c5c8ea452e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c
@@ -108,7 +108,12 @@ void hinic_sq_prepare_ctxt(struct hinic_sq_ctxt *sq_ctxt,
 	wq_page_pfn_hi = upper_32_bits(wq_page_pfn);
 	wq_page_pfn_lo = lower_32_bits(wq_page_pfn);
 
-	wq_block_pfn = HINIC_WQ_BLOCK_PFN(wq->block_paddr);
+	/* If only one page, use 0-level CLA */
+	if (wq->num_q_pages == 1)
+		wq_block_pfn = HINIC_WQ_BLOCK_PFN(wq_page_addr);
+	else
+		wq_block_pfn = HINIC_WQ_BLOCK_PFN(wq->block_paddr);
+
 	wq_block_pfn_hi = upper_32_bits(wq_block_pfn);
 	wq_block_pfn_lo = lower_32_bits(wq_block_pfn);
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
index 79091e131418..c30d092e48d5 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h
@@ -38,8 +38,8 @@
 #define HINIC_SQ_WQEBB_SIZE                     64
 #define HINIC_RQ_WQEBB_SIZE                     32
 
-#define HINIC_SQ_PAGE_SIZE                      SZ_4K
-#define HINIC_RQ_PAGE_SIZE                      SZ_4K
+#define HINIC_SQ_PAGE_SIZE                      SZ_256K
+#define HINIC_RQ_PAGE_SIZE                      SZ_256K
 
 #define HINIC_SQ_DEPTH                          SZ_4K
 #define HINIC_RQ_DEPTH                          SZ_4K
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
index 03363216ff59..5dc3743f8091 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c
@@ -503,7 +503,7 @@ static int alloc_wq_pages(struct hinic_wq *wq, struct hinic_hwif *hwif,
  * Return 0 - Success, negative - Failure
  **/
 int hinic_wq_allocate(struct hinic_wqs *wqs, struct hinic_wq *wq,
-		      u16 wqebb_size, u16 wq_page_size, u16 q_depth,
+		      u16 wqebb_size, u32 wq_page_size, u16 q_depth,
 		      u16 max_wqe_size)
 {
 	struct hinic_hwif *hwif = wqs->hwif;
@@ -600,7 +600,7 @@ void hinic_wq_free(struct hinic_wqs *wqs, struct hinic_wq *wq)
  **/
 int hinic_wqs_cmdq_alloc(struct hinic_cmdq_pages *cmdq_pages,
 			 struct hinic_wq *wq, struct hinic_hwif *hwif,
-			 int cmdq_blocks, u16 wqebb_size, u16 wq_page_size,
+			 int cmdq_blocks, u16 wqebb_size, u32 wq_page_size,
 			 u16 q_depth, u16 max_wqe_size)
 {
 	struct pci_dev *pdev = hwif->pdev;
@@ -768,7 +768,10 @@ struct hinic_hw_wqe *hinic_get_wqe(struct hinic_wq *wq, unsigned int wqe_size,
 
 	*prod_idx = curr_prod_idx;
 
-	if (curr_pg != end_pg) {
+	/* If we only have one page, still need to get shadown wqe when
+	 * wqe rolling-over page
+	 */
+	if (curr_pg != end_pg || MASKED_WQE_IDX(wq, end_prod_idx) < *prod_idx) {
 		void *shadow_addr = &wq->shadow_wqe[curr_pg * wq->max_wqe_size];
 
 		copy_wqe_to_shadow(wq, shadow_addr, num_wqebbs, *prod_idx);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h
index 811eef744140..b06f8c0255de 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_wq.h
@@ -26,7 +26,7 @@ struct hinic_wq {
 	int             block_idx;
 
 	u16             wqebb_size;
-	u16             wq_page_size;
+	u32             wq_page_size;
 	u16             q_depth;
 	u16             max_wqe_size;
 	u16             num_wqebbs_per_page;
@@ -76,7 +76,7 @@ struct hinic_cmdq_pages {
 
 int hinic_wqs_cmdq_alloc(struct hinic_cmdq_pages *cmdq_pages,
 			 struct hinic_wq *wq, struct hinic_hwif *hwif,
-			 int cmdq_blocks, u16 wqebb_size, u16 wq_page_size,
+			 int cmdq_blocks, u16 wqebb_size, u32 wq_page_size,
 			 u16 q_depth, u16 max_wqe_size);
 
 void hinic_wqs_cmdq_free(struct hinic_cmdq_pages *cmdq_pages,
@@ -88,7 +88,7 @@ int hinic_wqs_alloc(struct hinic_wqs *wqs, int num_wqs,
 void hinic_wqs_free(struct hinic_wqs *wqs);
 
 int hinic_wq_allocate(struct hinic_wqs *wqs, struct hinic_wq *wq,
-		      u16 wqebb_size, u16 wq_page_size, u16 q_depth,
+		      u16 wqebb_size, u32 wq_page_size, u16 q_depth,
 		      u16 max_wqe_size);
 
 void hinic_wq_free(struct hinic_wqs *wqs, struct hinic_wq *wq);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 13560975c103..cd71249f9b1c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -29,6 +29,7 @@
 #include "hinic_tx.h"
 #include "hinic_rx.h"
 #include "hinic_dev.h"
+#include "hinic_sriov.h"
 
 MODULE_AUTHOR("Huawei Technologies CO., Ltd");
 MODULE_DESCRIPTION("Huawei Intelligent NIC driver");
@@ -46,6 +47,7 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 #define HINIC_DEV_ID_DUAL_PORT_100GE        0x0200
 #define HINIC_DEV_ID_DUAL_PORT_100GE_MEZZ   0x0205
 #define HINIC_DEV_ID_QUAD_PORT_25GE_MEZZ    0x0210
+#define HINIC_DEV_ID_VF    0x375e
 
 #define HINIC_WQ_NAME                   "hinic_dev"
 
@@ -65,6 +67,8 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 #define rx_mode_work_to_nic_dev(rx_mode_work) \
 		container_of(rx_mode_work, struct hinic_dev, rx_mode_work)
 
+#define HINIC_WAIT_SRIOV_CFG_TIMEOUT	15000
+
 static int change_mac_addr(struct net_device *netdev, const u8 *addr);
 
 static int set_features(struct hinic_dev *nic_dev,
@@ -423,8 +427,9 @@ static int hinic_open(struct net_device *netdev)
 		goto err_func_port_state;
 	}
 
-	/* Wait up to 3 sec between port enable to link state */
-	msleep(3000);
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		/* Wait up to 3 sec between port enable to link state */
+		msleep(3000);
 
 	down(&nic_dev->mgmt_lock);
 
@@ -434,6 +439,9 @@ static int hinic_open(struct net_device *netdev)
 		goto err_port_link;
 	}
 
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		hinic_notify_all_vfs_link_changed(nic_dev->hwdev, link_state);
+
 	if (link_state == HINIC_LINK_STATE_UP)
 		nic_dev->flags |= HINIC_LINK_UP;
 
@@ -497,6 +505,9 @@ static int hinic_close(struct net_device *netdev)
 
 	up(&nic_dev->mgmt_lock);
 
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		hinic_notify_all_vfs_link_changed(nic_dev->hwdev, 0);
+
 	err = hinic_port_set_func_state(nic_dev, HINIC_FUNC_PORT_DISABLE);
 	if (err) {
 		netif_err(nic_dev, drv, netdev,
@@ -685,7 +696,7 @@ static int hinic_vlan_rx_add_vid(struct net_device *netdev,
 	}
 
 	err = hinic_port_add_mac(nic_dev, netdev->dev_addr, vid);
-	if (err) {
+	if (err && err != HINIC_PF_SET_VF_ALREADY) {
 		netif_err(nic_dev, drv, netdev, "Failed to set mac\n");
 		goto err_add_mac;
 	}
@@ -737,8 +748,6 @@ static void set_rx_mode(struct work_struct *work)
 	struct hinic_rx_mode_work *rx_mode_work = work_to_rx_mode_work(work);
 	struct hinic_dev *nic_dev = rx_mode_work_to_nic_dev(rx_mode_work);
 
-	netif_info(nic_dev, drv, nic_dev->netdev, "set rx mode work\n");
-
 	hinic_port_set_rx_mode(nic_dev, rx_mode_work->rx_mode);
 
 	__dev_uc_sync(nic_dev->netdev, add_mac_addr, remove_mac_addr);
@@ -896,6 +905,10 @@ static void link_status_event_handler(void *handle, void *buf_in, u16 in_size,
 		netif_info(nic_dev, drv, nic_dev->netdev, "HINIC_Link is DOWN\n");
 	}
 
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		hinic_notify_all_vfs_link_changed(nic_dev->hwdev,
+						  link_status->link);
+
 	ret_link_status = buf_out;
 	ret_link_status->status = 0;
 
@@ -969,7 +982,9 @@ static int nic_dev_init(struct pci_dev *pdev)
 	}
 
 	hinic_set_ethtool_ops(netdev);
+
 	netdev->netdev_ops = &hinic_netdev_ops;
+
 	netdev->max_mtu = ETH_MAX_MTU;
 
 	nic_dev = netdev_priv(netdev);
@@ -981,6 +996,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	nic_dev->rxqs = NULL;
 	nic_dev->tx_weight = tx_weight;
 	nic_dev->rx_weight = rx_weight;
+	nic_dev->sriov_info.hwdev = hwdev;
+	nic_dev->sriov_info.pdev = pdev;
 
 	sema_init(&nic_dev->mgmt_lock, 1);
 
@@ -1007,11 +1024,25 @@ static int nic_dev_init(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, netdev);
 
 	err = hinic_port_get_mac(nic_dev, netdev->dev_addr);
-	if (err)
-		dev_warn(&pdev->dev, "Failed to get mac address\n");
+	if (err) {
+		dev_err(&pdev->dev, "Failed to get mac address\n");
+		goto err_get_mac;
+	}
+
+	if (!is_valid_ether_addr(netdev->dev_addr)) {
+		if (!HINIC_IS_VF(nic_dev->hwdev->hwif)) {
+			dev_err(&pdev->dev, "Invalid MAC address\n");
+			err = -EIO;
+			goto err_add_mac;
+		}
+
+		dev_info(&pdev->dev, "Invalid MAC address %pM, using random\n",
+			 netdev->dev_addr);
+		eth_hw_addr_random(netdev);
+	}
 
 	err = hinic_port_add_mac(nic_dev, netdev->dev_addr, 0);
-	if (err) {
+	if (err && err != HINIC_PF_SET_VF_ALREADY) {
 		dev_err(&pdev->dev, "Failed to add mac\n");
 		goto err_add_mac;
 	}
@@ -1053,6 +1084,7 @@ static int nic_dev_init(struct pci_dev *pdev)
 	cancel_work_sync(&rx_mode_work->work);
 
 err_set_mtu:
+err_get_mac:
 err_add_mac:
 	pci_set_drvdata(pdev, NULL);
 	destroy_workqueue(nic_dev->workq);
@@ -1126,12 +1158,37 @@ static int hinic_probe(struct pci_dev *pdev,
 	return err;
 }
 
+#define HINIC_WAIT_SRIOV_CFG_TIMEOUT	15000
+
+static void wait_sriov_cfg_complete(struct hinic_dev *nic_dev)
+{
+	struct hinic_sriov_info *sriov_info = &nic_dev->sriov_info;
+	u32 loop_cnt = 0;
+
+	set_bit(HINIC_FUNC_REMOVE, &sriov_info->state);
+	usleep_range(9900, 10000);
+
+	while (loop_cnt < HINIC_WAIT_SRIOV_CFG_TIMEOUT) {
+		if (!test_bit(HINIC_SRIOV_ENABLE, &sriov_info->state) &&
+		    !test_bit(HINIC_SRIOV_DISABLE, &sriov_info->state))
+			return;
+
+		usleep_range(9900, 10000);
+		loop_cnt++;
+	}
+}
+
 static void hinic_remove(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_rx_mode_work *rx_mode_work;
 
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif)) {
+		wait_sriov_cfg_complete(nic_dev);
+		hinic_pci_sriov_disable(pdev);
+	}
+
 	unregister_netdev(netdev);
 
 	hinic_hwdev_cb_unregister(nic_dev->hwdev,
@@ -1144,6 +1201,8 @@ static void hinic_remove(struct pci_dev *pdev)
 
 	destroy_workqueue(nic_dev->workq);
 
+	hinic_vf_func_free(nic_dev->hwdev);
+
 	hinic_free_hwdev(nic_dev->hwdev);
 
 	free_netdev(netdev);
@@ -1164,6 +1223,7 @@ static const struct pci_device_id hinic_pci_table[] = {
 	{ PCI_VDEVICE(HUAWEI, HINIC_DEV_ID_DUAL_PORT_100GE), 0},
 	{ PCI_VDEVICE(HUAWEI, HINIC_DEV_ID_DUAL_PORT_100GE_MEZZ), 0},
 	{ PCI_VDEVICE(HUAWEI, HINIC_DEV_ID_QUAD_PORT_25GE_MEZZ), 0},
+	{ PCI_VDEVICE(HUAWEI, HINIC_DEV_ID_VF), 0},
 	{ 0, 0}
 };
 MODULE_DEVICE_TABLE(pci, hinic_pci_table);
@@ -1174,6 +1234,7 @@ static struct pci_driver hinic_driver = {
 	.probe          = hinic_probe,
 	.remove         = hinic_remove,
 	.shutdown       = hinic_shutdown,
+	.sriov_configure = hinic_pci_sriov_configure,
 };
 
 module_pci_driver(hinic_driver);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.c b/drivers/net/ethernet/huawei/hinic/hinic_port.c
index 1e389a004e50..b7fe0adcc29a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.c
@@ -37,20 +37,14 @@ enum mac_op {
 static int change_mac(struct hinic_dev *nic_dev, const u8 *addr,
 		      u16 vlan_id, enum mac_op op)
 {
-	struct net_device *netdev = nic_dev->netdev;
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_port_mac_cmd port_mac_cmd;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(port_mac_cmd);
 	struct pci_dev *pdev = hwif->pdev;
 	enum hinic_port_cmd cmd;
-	u16 out_size;
 	int err;
 
-	if (vlan_id >= VLAN_N_VID) {
-		netif_err(nic_dev, drv, netdev, "Invalid VLAN number\n");
-		return -EINVAL;
-	}
-
 	if (op == MAC_SET)
 		cmd = HINIC_PORT_CMD_SET_MAC;
 	else
@@ -63,12 +57,25 @@ static int change_mac(struct hinic_dev *nic_dev, const u8 *addr,
 	err = hinic_port_msg_cmd(hwdev, cmd, &port_mac_cmd,
 				 sizeof(port_mac_cmd),
 				 &port_mac_cmd, &out_size);
-	if (err || (out_size != sizeof(port_mac_cmd)) || port_mac_cmd.status) {
+	if (err || out_size != sizeof(port_mac_cmd) ||
+	    (port_mac_cmd.status  &&
+	    port_mac_cmd.status != HINIC_PF_SET_VF_ALREADY &&
+	    port_mac_cmd.status != HINIC_MGMT_STATUS_EXIST)) {
 		dev_err(&pdev->dev, "Failed to change MAC, ret = %d\n",
 			port_mac_cmd.status);
 		return -EFAULT;
 	}
 
+	if (cmd == HINIC_PORT_CMD_SET_MAC && port_mac_cmd.status ==
+	    HINIC_PF_SET_VF_ALREADY) {
+		dev_warn(&pdev->dev, "PF has already set VF mac, Ignore set operation\n");
+		return HINIC_PF_SET_VF_ALREADY;
+	}
+
+	if (cmd == HINIC_PORT_CMD_SET_MAC && port_mac_cmd.status ==
+	    HINIC_MGMT_STATUS_EXIST)
+		dev_warn(&pdev->dev, "MAC is repeated. Ignore set operation\n");
+
 	return 0;
 }
 
@@ -112,8 +119,8 @@ int hinic_port_get_mac(struct hinic_dev *nic_dev, u8 *addr)
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_port_mac_cmd port_mac_cmd;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(port_mac_cmd);
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
 	int err;
 
 	port_mac_cmd.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
@@ -144,9 +151,9 @@ int hinic_port_set_mtu(struct hinic_dev *nic_dev, int new_mtu)
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_port_mtu_cmd port_mtu_cmd;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(port_mtu_cmd);
 	struct pci_dev *pdev = hwif->pdev;
 	int err, max_frame;
-	u16 out_size;
 
 	if (new_mtu < HINIC_MIN_MTU_SIZE) {
 		netif_err(nic_dev, drv, netdev, "mtu < MIN MTU size");
@@ -248,14 +255,9 @@ int hinic_port_link_state(struct hinic_dev *nic_dev,
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct hinic_port_link_cmd link_cmd;
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(link_cmd);
 	int err;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "unsupported PCI Function type\n");
-		return -EINVAL;
-	}
-
 	link_cmd.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
 
 	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_GET_LINK_STATE,
@@ -284,13 +286,11 @@ int hinic_port_set_state(struct hinic_dev *nic_dev, enum hinic_port_state state)
 	struct hinic_port_state_cmd port_state;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(port_state);
 	int err;
 
-	if (!HINIC_IS_PF(hwif) && !HINIC_IS_PPF(hwif)) {
-		dev_err(&pdev->dev, "unsupported PCI Function type\n");
-		return -EINVAL;
-	}
+	if (HINIC_IS_VF(hwdev->hwif))
+		return 0;
 
 	port_state.state = state;
 
@@ -320,7 +320,7 @@ int hinic_port_set_func_state(struct hinic_dev *nic_dev,
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(func_state);
 	int err;
 
 	func_state.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
@@ -351,7 +351,7 @@ int hinic_port_get_cap(struct hinic_dev *nic_dev,
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(*port_cap);
 	int err;
 
 	port_cap->func_idx = HINIC_HWIF_FUNC_IDX(hwif);
@@ -382,7 +382,7 @@ int hinic_port_set_tso(struct hinic_dev *nic_dev, enum hinic_tso_state state)
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct hinic_tso_config tso_cfg = {0};
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(tso_cfg);
 	int err;
 
 	tso_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -405,9 +405,9 @@ int hinic_set_rx_csum_offload(struct hinic_dev *nic_dev, u32 en)
 {
 	struct hinic_checksum_offload rx_csum_cfg = {0};
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	u16 out_size = sizeof(rx_csum_cfg);
 	struct hinic_hwif *hwif;
 	struct pci_dev *pdev;
-	u16 out_size;
 	int err;
 
 	if (!hwdev)
@@ -443,6 +443,7 @@ int hinic_set_rx_vlan_offload(struct hinic_dev *nic_dev, u8 en)
 	if (!hwdev)
 		return -EINVAL;
 
+	out_size = sizeof(vlan_cfg);
 	hwif = hwdev->hwif;
 	pdev = hwif->pdev;
 	vlan_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -465,8 +466,8 @@ int hinic_set_max_qnum(struct hinic_dev *nic_dev, u8 num_rqs)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
-	struct pci_dev *pdev = hwif->pdev;
 	struct hinic_rq_num rq_num = { 0 };
+	struct pci_dev *pdev = hwif->pdev;
 	u16 out_size = sizeof(rq_num);
 	int err;
 
@@ -491,8 +492,8 @@ static int hinic_set_rx_lro(struct hinic_dev *nic_dev, u8 ipv4_en, u8 ipv6_en,
 			    u8 max_wqe_num)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
-	struct hinic_hwif *hwif = hwdev->hwif;
 	struct hinic_lro_config lro_cfg = { 0 };
+	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
 	u16 out_size = sizeof(lro_cfg);
 	int err;
@@ -568,6 +569,9 @@ int hinic_set_rx_lro_state(struct hinic_dev *nic_dev, u8 lro_en,
 	if (err)
 		return err;
 
+	if (HINIC_IS_VF(nic_dev->hwdev->hwif))
+		return 0;
+
 	err = hinic_set_rx_lro_timer(nic_dev, lro_timer);
 	if (err)
 		return err;
@@ -741,9 +745,9 @@ int hinic_get_rss_type(struct hinic_dev *nic_dev, u32 tmpl_idx,
 {
 	struct hinic_rss_context_table ctx_tbl = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	u16 out_size = sizeof(ctx_tbl);
 	struct hinic_hwif *hwif;
 	struct pci_dev *pdev;
-	u16 out_size = sizeof(ctx_tbl);
 	int err;
 
 	if (!hwdev || !rss_type)
@@ -784,7 +788,7 @@ int hinic_rss_set_template_tbl(struct hinic_dev *nic_dev, u32 template_id,
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct hinic_rss_key rss_key = { 0 };
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(rss_key);
 	int err;
 
 	rss_key.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -809,9 +813,9 @@ int hinic_rss_get_template_tbl(struct hinic_dev *nic_dev, u32 tmpl_idx,
 {
 	struct hinic_rss_template_key temp_key = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	u16 out_size = sizeof(temp_key);
 	struct hinic_hwif *hwif;
 	struct pci_dev *pdev;
-	u16 out_size = sizeof(temp_key);
 	int err;
 
 	if (!hwdev || !temp)
@@ -844,7 +848,7 @@ int hinic_rss_set_hash_engine(struct hinic_dev *nic_dev, u8 template_id,
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(rss_engine);
 	int err;
 
 	rss_engine.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -868,9 +872,9 @@ int hinic_rss_get_hash_engine(struct hinic_dev *nic_dev, u8 tmpl_idx, u8 *type)
 {
 	struct hinic_rss_engine_type hash_type = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
+	u16 out_size = sizeof(hash_type);
 	struct hinic_hwif *hwif;
 	struct pci_dev *pdev;
-	u16 out_size = sizeof(hash_type);
 	int err;
 
 	if (!hwdev || !type)
@@ -901,7 +905,7 @@ int hinic_rss_cfg(struct hinic_dev *nic_dev, u8 rss_en, u8 template_id)
 	struct hinic_rss_config rss_cfg = { 0 };
 	struct hinic_hwif *hwif = hwdev->hwif;
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
+	u16 out_size = sizeof(rss_cfg);
 	int err;
 
 	rss_cfg.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -927,8 +931,8 @@ int hinic_rss_template_alloc(struct hinic_dev *nic_dev, u8 *tmpl_idx)
 	struct hinic_rss_template_mgmt template_mgmt = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(template_mgmt);
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
 	int err;
 
 	template_mgmt.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -953,8 +957,8 @@ int hinic_rss_template_free(struct hinic_dev *nic_dev, u8 tmpl_idx)
 	struct hinic_rss_template_mgmt template_mgmt = { 0 };
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_hwif *hwif = hwdev->hwif;
+	u16 out_size = sizeof(template_mgmt);
 	struct pci_dev *pdev = hwif->pdev;
-	u16 out_size;
 	int err;
 
 	template_mgmt.func_id = HINIC_HWIF_FUNC_IDX(hwif);
@@ -1043,9 +1047,9 @@ int hinic_get_mgmt_version(struct hinic_dev *nic_dev, u8 *mgmt_ver)
 {
 	struct hinic_hwdev *hwdev = nic_dev->hwdev;
 	struct hinic_version_info up_ver = {0};
+	u16 out_size = sizeof(up_ver);
 	struct hinic_hwif *hwif;
 	struct pci_dev *pdev;
-	u16 out_size;
 	int err;
 
 	if (!hwdev)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_port.h b/drivers/net/ethernet/huawei/hinic/hinic_port.h
index 44772fd47fc1..5ad04fb6722a 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_port.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_port.h
@@ -148,9 +148,9 @@ struct hinic_port_link_status {
 	u8      version;
 	u8      rsvd0[6];
 
-	u16     rsvd1;
+	u16     func_id;
 	u8      link;
-	u8      rsvd2;
+	u8      port_id;
 };
 
 struct hinic_port_func_state_cmd {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index 815649e37cb1..af20d0dd6de7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -432,9 +432,11 @@ static int rx_poll(struct napi_struct *napi, int budget)
 		return budget;
 
 	napi_complete(napi);
-	hinic_hwdev_set_msix_state(nic_dev->hwdev,
-				   rq->msix_entry,
-				   HINIC_MSIX_ENABLE);
+
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		hinic_hwdev_set_msix_state(nic_dev->hwdev,
+					   rq->msix_entry,
+					   HINIC_MSIX_ENABLE);
 
 	return pkts;
 }
@@ -461,9 +463,10 @@ static irqreturn_t rx_irq(int irq, void *data)
 
 	/* Disable the interrupt until napi will be completed */
 	nic_dev = netdev_priv(rxq->netdev);
-	hinic_hwdev_set_msix_state(nic_dev->hwdev,
-				   rq->msix_entry,
-				   HINIC_MSIX_DISABLE);
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		hinic_hwdev_set_msix_state(nic_dev->hwdev,
+					   rq->msix_entry,
+					   HINIC_MSIX_DISABLE);
 
 	nic_dev = netdev_priv(rxq->netdev);
 	hinic_hwdev_msix_cnt_set(nic_dev->hwdev, rq->msix_entry);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
new file mode 100644
index 000000000000..d1c4e1428b38
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -0,0 +1,698 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#include <linux/pci.h>
+#include <linux/if_vlan.h>
+#include <linux/interrupt.h>
+#include <linux/etherdevice.h>
+#include <linux/netdevice.h>
+
+#include "hinic_hw_dev.h"
+#include "hinic_dev.h"
+#include "hinic_hw_mbox.h"
+#include "hinic_hw_cmdq.h"
+#include "hinic_port.h"
+#include "hinic_sriov.h"
+
+static unsigned char set_vf_link_state;
+module_param(set_vf_link_state, byte, 0444);
+MODULE_PARM_DESC(set_vf_link_state, "Set vf link state, 0 represents link auto, 1 represents link always up, 2 represents link always down. - default is 0.");
+
+#define HINIC_VLAN_PRIORITY_SHIFT 13
+#define HINIC_ADD_VLAN_IN_MAC 0x8000
+
+int hinic_set_mac(struct hinic_hwdev *hwdev, const u8 *mac_addr, u16 vlan_id,
+		  u16 func_id)
+{
+	struct hinic_port_mac_cmd mac_info = {0};
+	u16 out_size = sizeof(mac_info);
+	int err;
+
+	mac_info.func_idx = func_id;
+	mac_info.vlan_id = vlan_id;
+	memcpy(mac_info.mac, mac_addr, ETH_ALEN);
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_SET_MAC, &mac_info,
+				 sizeof(mac_info), &mac_info, &out_size);
+	if (err || out_size != sizeof(mac_info) ||
+	    (mac_info.status && mac_info.status != HINIC_PF_SET_VF_ALREADY &&
+	    mac_info.status != HINIC_MGMT_STATUS_EXIST)) {
+		dev_err(&hwdev->func_to_io.hwif->pdev->dev, "Failed to change MAC, ret = %d\n",
+			mac_info.status);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static void hinic_notify_vf_link_status(struct hinic_hwdev *hwdev, u16 vf_id,
+					u8 link_status)
+{
+	struct vf_data_storage *vf_infos = hwdev->func_to_io.vf_infos;
+	struct hinic_port_link_status link = {0};
+	u16 out_size = sizeof(link);
+	int err;
+
+	if (vf_infos[HW_VF_ID_TO_OS(vf_id)].registered) {
+		link.link = link_status;
+		link.func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+		err = hinic_mbox_to_vf(hwdev, HINIC_MOD_L2NIC,
+				       vf_id, HINIC_PORT_CMD_LINK_STATUS_REPORT,
+				       &link, sizeof(link),
+				       &link, &out_size, 0);
+		if (err || !out_size || link.status)
+			dev_err(&hwdev->hwif->pdev->dev,
+				"Send link change event to VF %d failed, err: %d, status: 0x%x, out_size: 0x%x\n",
+				HW_VF_ID_TO_OS(vf_id), err,
+				link.status, out_size);
+	}
+}
+
+/* send link change event mbox msg to active vfs under the pf */
+void hinic_notify_all_vfs_link_changed(struct hinic_hwdev *hwdev,
+				       u8 link_status)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	u16 i;
+
+	nic_io->link_status = link_status;
+	for (i = 1; i <= nic_io->max_vfs; i++) {
+		if (!nic_io->vf_infos[HW_VF_ID_TO_OS(i)].link_forced)
+			hinic_notify_vf_link_status(hwdev, i,  link_status);
+	}
+}
+
+u16 hinic_vf_info_vlanprio(struct hinic_hwdev *hwdev, int vf_id)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	u16 pf_vlan, vlanprio;
+	u8 pf_qos;
+
+	pf_vlan = nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_vlan;
+	pf_qos = nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_qos;
+	vlanprio = pf_vlan | pf_qos << HINIC_VLAN_PRIORITY_SHIFT;
+
+	return vlanprio;
+}
+
+int hinic_set_vf_vlan(struct hinic_hwdev *hwdev, bool add, u16 vid,
+		      u8 qos, int vf_id)
+{
+	struct hinic_vf_vlan_config vf_vlan = {0};
+	u16 out_size = sizeof(vf_vlan);
+	int err;
+	u8 cmd;
+
+	/* VLAN 0 is a special case, don't allow it to be removed */
+	if (!vid && !add)
+		return 0;
+
+	vf_vlan.func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+	vf_vlan.vlan_id = vid;
+	vf_vlan.qos = qos;
+
+	if (add)
+		cmd = HINIC_PORT_CMD_SET_VF_VLAN;
+	else
+		cmd = HINIC_PORT_CMD_CLR_VF_VLAN;
+
+	err = hinic_port_msg_cmd(hwdev, cmd, &vf_vlan,
+				 sizeof(vf_vlan), &vf_vlan, &out_size);
+	if (err || !out_size || vf_vlan.status) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to set VF %d vlan, err: %d, status: 0x%x, out size: 0x%x\n",
+			HW_VF_ID_TO_OS(vf_id), err, vf_vlan.status, out_size);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int hinic_init_vf_config(struct hinic_hwdev *hwdev, u16 vf_id)
+{
+	struct vf_data_storage *vf_info;
+	u16 func_id, vlan_id;
+	int err = 0;
+
+	vf_info = hwdev->func_to_io.vf_infos + HW_VF_ID_TO_OS(vf_id);
+	if (vf_info->pf_set_mac) {
+		func_id = hinic_glb_pf_vf_offset(hwdev->hwif) + vf_id;
+
+		vlan_id = 0;
+
+		err = hinic_set_mac(hwdev, vf_info->vf_mac_addr, vlan_id,
+				    func_id);
+		if (err) {
+			dev_err(&hwdev->func_to_io.hwif->pdev->dev, "Failed to set VF %d MAC\n",
+				HW_VF_ID_TO_OS(vf_id));
+			return err;
+		}
+	}
+
+	if (hinic_vf_info_vlanprio(hwdev, vf_id)) {
+		err = hinic_set_vf_vlan(hwdev, true, vf_info->pf_vlan,
+					vf_info->pf_qos, vf_id);
+		if (err) {
+			dev_err(&hwdev->hwif->pdev->dev, "Failed to add VF %d VLAN_QOS\n",
+				HW_VF_ID_TO_OS(vf_id));
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+int hinic_register_vf_msg_handler(void *hwdev, u16 vf_id,
+				  void *buf_in, u16 in_size,
+				  void *buf_out, u16 *out_size)
+{
+	struct hinic_register_vf *register_info = buf_out;
+	struct hinic_hwdev *hw_dev = hwdev;
+	struct hinic_func_to_io *nic_io;
+	int err;
+
+	nic_io = &hw_dev->func_to_io;
+	if (vf_id > nic_io->max_vfs) {
+		dev_err(&hw_dev->hwif->pdev->dev, "Register VF id %d exceed limit[0-%d]\n",
+			HW_VF_ID_TO_OS(vf_id), HW_VF_ID_TO_OS(nic_io->max_vfs));
+		register_info->status = EFAULT;
+		return -EFAULT;
+	}
+
+	*out_size = sizeof(*register_info);
+	err = hinic_init_vf_config(hw_dev, vf_id);
+	if (err) {
+		register_info->status = EFAULT;
+		return err;
+	}
+
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].registered = true;
+
+	return 0;
+}
+
+int hinic_unregister_vf_msg_handler(void *hwdev, u16 vf_id,
+				    void *buf_in, u16 in_size,
+				    void *buf_out, u16 *out_size)
+{
+	struct hinic_hwdev *hw_dev = hwdev;
+	struct hinic_func_to_io *nic_io;
+
+	nic_io = &hw_dev->func_to_io;
+	*out_size = 0;
+	if (vf_id > nic_io->max_vfs)
+		return 0;
+
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].registered = false;
+
+	return 0;
+}
+
+int hinic_change_vf_mtu_msg_handler(void *hwdev, u16 vf_id,
+				    void *buf_in, u16 in_size,
+				    void *buf_out, u16 *out_size)
+{
+	struct hinic_hwdev *hw_dev = hwdev;
+	int err;
+
+	err = hinic_port_msg_cmd(hwdev, HINIC_PORT_CMD_CHANGE_MTU, buf_in,
+				 in_size, buf_out, out_size);
+	if (err) {
+		dev_err(&hw_dev->hwif->pdev->dev, "Failed to set VF %u mtu\n",
+			vf_id);
+		return err;
+	}
+
+	return 0;
+}
+
+int hinic_get_vf_mac_msg_handler(void *hwdev, u16 vf_id,
+				 void *buf_in, u16 in_size,
+				 void *buf_out, u16 *out_size)
+{
+	struct hinic_port_mac_cmd *mac_info = buf_out;
+	struct hinic_hwdev *dev = hwdev;
+	struct hinic_func_to_io *nic_io;
+	struct vf_data_storage *vf_info;
+
+	nic_io = &dev->func_to_io;
+	vf_info = nic_io->vf_infos + HW_VF_ID_TO_OS(vf_id);
+
+	memcpy(mac_info->mac, vf_info->vf_mac_addr, ETH_ALEN);
+	mac_info->status = 0;
+	*out_size = sizeof(*mac_info);
+
+	return 0;
+}
+
+int hinic_set_vf_mac_msg_handler(void *hwdev, u16 vf_id,
+				 void *buf_in, u16 in_size,
+				 void *buf_out, u16 *out_size)
+{
+	struct hinic_port_mac_cmd *mac_out = buf_out;
+	struct hinic_port_mac_cmd *mac_in = buf_in;
+	struct hinic_hwdev *hw_dev = hwdev;
+	struct hinic_func_to_io *nic_io;
+	struct vf_data_storage *vf_info;
+	int err;
+
+	nic_io =  &hw_dev->func_to_io;
+	vf_info = nic_io->vf_infos + HW_VF_ID_TO_OS(vf_id);
+	if (vf_info->pf_set_mac && !(vf_info->trust) &&
+	    is_valid_ether_addr(mac_in->mac)) {
+		dev_warn(&hw_dev->hwif->pdev->dev, "PF has already set VF %d MAC address\n",
+			 HW_VF_ID_TO_OS(vf_id));
+		mac_out->status = HINIC_PF_SET_VF_ALREADY;
+		*out_size = sizeof(*mac_out);
+		return 0;
+	}
+
+	err = hinic_port_msg_cmd(hw_dev, HINIC_PORT_CMD_SET_MAC, buf_in,
+				 in_size, buf_out, out_size);
+	if ((err &&  err != HINIC_MBOX_PF_BUSY_ACTIVE_FW) || !(*out_size)) {
+		dev_err(&hw_dev->hwif->pdev->dev,
+			"Failed to set VF %d MAC address, err: %d, status: 0x%x, out size: 0x%x\n",
+			HW_VF_ID_TO_OS(vf_id), err, mac_out->status, *out_size);
+		return -EFAULT;
+	}
+
+	return err;
+}
+
+int hinic_del_vf_mac_msg_handler(void *hwdev, u16 vf_id,
+				 void *buf_in, u16 in_size,
+				 void *buf_out, u16 *out_size)
+{
+	struct hinic_port_mac_cmd *mac_out = buf_out;
+	struct hinic_port_mac_cmd *mac_in = buf_in;
+	struct hinic_hwdev *hw_dev = hwdev;
+	struct hinic_func_to_io *nic_io;
+	struct vf_data_storage *vf_info;
+	int err;
+
+	nic_io = &hw_dev->func_to_io;
+	vf_info = nic_io->vf_infos + HW_VF_ID_TO_OS(vf_id);
+	if (vf_info->pf_set_mac  && is_valid_ether_addr(mac_in->mac) &&
+	    !memcmp(vf_info->vf_mac_addr, mac_in->mac, ETH_ALEN)) {
+		dev_warn(&hw_dev->hwif->pdev->dev, "PF has already set VF mac.\n");
+		mac_out->status = HINIC_PF_SET_VF_ALREADY;
+		*out_size = sizeof(*mac_out);
+		return 0;
+	}
+
+	err = hinic_port_msg_cmd(hw_dev, HINIC_PORT_CMD_DEL_MAC, buf_in,
+				 in_size, buf_out, out_size);
+	if ((err && err != HINIC_MBOX_PF_BUSY_ACTIVE_FW) || !(*out_size)) {
+		dev_err(&hw_dev->hwif->pdev->dev, "Failed to delete VF %d MAC, err: %d, status: 0x%x, out size: 0x%x\n",
+			HW_VF_ID_TO_OS(vf_id), err, mac_out->status, *out_size);
+		return -EFAULT;
+	}
+
+	return err;
+}
+
+int hinic_get_vf_link_status_msg_handler(void *hwdev, u16 vf_id,
+					 void *buf_in, u16 in_size,
+					 void *buf_out, u16 *out_size)
+{
+	struct hinic_port_link_cmd *get_link = buf_out;
+	struct hinic_hwdev *hw_dev = hwdev;
+	struct vf_data_storage *vf_infos;
+	struct hinic_func_to_io *nic_io;
+	bool link_forced, link_up;
+
+	nic_io = &hw_dev->func_to_io;
+	vf_infos = nic_io->vf_infos;
+	link_forced = vf_infos[HW_VF_ID_TO_OS(vf_id)].link_forced;
+	link_up = vf_infos[HW_VF_ID_TO_OS(vf_id)].link_up;
+
+	if (link_forced)
+		get_link->state = link_up ?
+			HINIC_LINK_STATE_UP : HINIC_LINK_STATE_DOWN;
+	else
+		get_link->state = nic_io->link_status;
+
+	get_link->status = 0;
+	*out_size = sizeof(*get_link);
+
+	return 0;
+}
+
+struct vf_cmd_msg_handle nic_vf_cmd_msg_handler[] = {
+	{HINIC_PORT_CMD_VF_REGISTER, hinic_register_vf_msg_handler},
+	{HINIC_PORT_CMD_VF_UNREGISTER, hinic_unregister_vf_msg_handler},
+	{HINIC_PORT_CMD_CHANGE_MTU, hinic_change_vf_mtu_msg_handler},
+	{HINIC_PORT_CMD_GET_MAC, hinic_get_vf_mac_msg_handler},
+	{HINIC_PORT_CMD_SET_MAC, hinic_set_vf_mac_msg_handler},
+	{HINIC_PORT_CMD_DEL_MAC, hinic_del_vf_mac_msg_handler},
+	{HINIC_PORT_CMD_GET_LINK_STATE, hinic_get_vf_link_status_msg_handler},
+};
+
+#define CHECK_IPSU_15BIT	0X8000
+
+struct hinic_sriov_info *hinic_get_sriov_info_by_pcidev(struct pci_dev *pdev)
+{
+	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct hinic_dev *nic_dev = netdev_priv(netdev);
+
+	return &nic_dev->sriov_info;
+}
+
+int hinic_kill_vf_vlan(struct hinic_hwdev *hwdev, int vf_id)
+{
+	struct hinic_func_to_io *nic_io = &hwdev->func_to_io;
+	int err;
+
+	err = hinic_set_vf_vlan(hwdev, false,
+				nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_vlan,
+				nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_qos,
+				vf_id);
+	if (err)
+		return err;
+
+	dev_info(&hwdev->hwif->pdev->dev, "Remove VLAN %d on VF %d\n",
+		 nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_vlan,
+		 HW_VF_ID_TO_OS(vf_id));
+
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_vlan = 0;
+	nic_io->vf_infos[HW_VF_ID_TO_OS(vf_id)].pf_qos = 0;
+
+	return 0;
+}
+
+/* pf receive message from vf */
+int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
+			u16 in_size, void *buf_out, u16 *out_size)
+{
+	struct vf_cmd_msg_handle *vf_msg_handle;
+	struct hinic_hwdev *dev = hwdev;
+	struct hinic_func_to_io *nic_io;
+	struct hinic_pfhwdev *pfhwdev;
+	u32 i, cmd_number;
+	int err = 0;
+
+	if (!hwdev)
+		return -EFAULT;
+
+	cmd_number = sizeof(nic_vf_cmd_msg_handler) /
+			    sizeof(struct vf_cmd_msg_handle);
+	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
+	nic_io = &dev->func_to_io;
+	for (i = 0; i < cmd_number; i++) {
+		vf_msg_handle = &nic_vf_cmd_msg_handler[i];
+		if (cmd == vf_msg_handle->cmd &&
+		    vf_msg_handle->cmd_msg_handler) {
+			err = vf_msg_handle->cmd_msg_handler(hwdev, vf_id,
+							     buf_in, in_size,
+							     buf_out,
+							     out_size);
+			break;
+		}
+	}
+	if (i == cmd_number)
+		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
+					cmd, buf_in, in_size, buf_out,
+					out_size, HINIC_MGMT_MSG_SYNC);
+
+	if (err &&  err != HINIC_MBOX_PF_BUSY_ACTIVE_FW)
+		dev_err(&nic_io->hwif->pdev->dev, "PF receive VF L2NIC cmd: %d process error, err:%d\n",
+			cmd, err);
+	return err;
+}
+
+static int cfg_mbx_pf_proc_vf_msg(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
+				  u16 in_size, void *buf_out, u16 *out_size)
+{
+	struct hinic_dev_cap *dev_cap = buf_out;
+	struct hinic_hwdev *dev = hwdev;
+	struct hinic_cap *cap;
+
+	cap = &dev->nic_cap;
+	memset(dev_cap, 0, sizeof(*dev_cap));
+
+	dev_cap->max_vf = cap->max_vf;
+	dev_cap->max_sqs = cap->max_vf_qps;
+	dev_cap->max_rqs = cap->max_vf_qps;
+
+	*out_size = sizeof(*dev_cap);
+
+	return 0;
+}
+
+static int hinic_init_vf_infos(struct hinic_func_to_io *nic_io, u16 vf_id)
+{
+	struct vf_data_storage *vf_infos = nic_io->vf_infos;
+
+	if (set_vf_link_state > HINIC_IFLA_VF_LINK_STATE_DISABLE) {
+		dev_warn(&nic_io->hwif->pdev->dev, "Module Parameter set_vf_link_state value %d is out of range, resetting to %d\n",
+			 set_vf_link_state, HINIC_IFLA_VF_LINK_STATE_AUTO);
+		set_vf_link_state = HINIC_IFLA_VF_LINK_STATE_AUTO;
+	}
+
+	switch (set_vf_link_state) {
+	case HINIC_IFLA_VF_LINK_STATE_AUTO:
+		vf_infos[vf_id].link_forced = false;
+		break;
+	case HINIC_IFLA_VF_LINK_STATE_ENABLE:
+		vf_infos[vf_id].link_forced = true;
+		vf_infos[vf_id].link_up = true;
+		break;
+	case HINIC_IFLA_VF_LINK_STATE_DISABLE:
+		vf_infos[vf_id].link_forced = true;
+		vf_infos[vf_id].link_up = false;
+		break;
+	default:
+		dev_err(&nic_io->hwif->pdev->dev, "Invalid input parameter set_vf_link_state: %d\n",
+			set_vf_link_state);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+void hinic_clear_vf_infos(struct hinic_dev *nic_dev, u16 vf_id)
+{
+	struct vf_data_storage *vf_infos;
+	u16 func_id;
+
+	func_id = hinic_glb_pf_vf_offset(nic_dev->hwdev->hwif) + vf_id;
+	vf_infos = nic_dev->hwdev->func_to_io.vf_infos + HW_VF_ID_TO_OS(vf_id);
+	if (vf_infos->pf_set_mac)
+		hinic_port_del_mac(nic_dev, vf_infos->vf_mac_addr, 0);
+
+	if (hinic_vf_info_vlanprio(nic_dev->hwdev, vf_id))
+		hinic_kill_vf_vlan(nic_dev->hwdev, vf_id);
+
+	memset(vf_infos, 0, sizeof(*vf_infos));
+	/* set vf_infos to default */
+	hinic_init_vf_infos(&nic_dev->hwdev->func_to_io, HW_VF_ID_TO_OS(vf_id));
+}
+
+int hinic_deinit_vf_hw(struct hinic_sriov_info *sriov_info, u16 start_vf_id,
+		       u16 end_vf_id)
+{
+	struct hinic_dev *nic_dev;
+	u16 func_idx, idx;
+
+	nic_dev = container_of(sriov_info, struct hinic_dev, sriov_info);
+
+	for (idx = start_vf_id; idx <= end_vf_id; idx++) {
+		func_idx = hinic_glb_pf_vf_offset(nic_dev->hwdev->hwif) + idx;
+		hinic_set_wq_page_size(nic_dev->hwdev, func_idx,
+				       HINIC_HW_WQ_PAGE_SIZE);
+		hinic_clear_vf_infos(nic_dev, idx);
+	}
+
+	return 0;
+}
+
+int hinic_vf_func_init(struct hinic_hwdev *hwdev)
+{
+	struct hinic_register_vf register_info = {0};
+	u16 out_size = sizeof(register_info);
+	struct hinic_func_to_io *nic_io;
+	int err = 0;
+	u32 size, i;
+
+	nic_io = &hwdev->func_to_io;
+
+	if (HINIC_IS_VF(hwdev->hwif)) {
+		err = hinic_mbox_to_pf(hwdev, HINIC_MOD_L2NIC,
+				       HINIC_PORT_CMD_VF_REGISTER,
+				       &register_info, sizeof(register_info),
+				       &register_info, &out_size, 0);
+		if (err || register_info.status || !out_size) {
+			dev_err(&hwdev->hwif->pdev->dev,
+				"Failed to register VF, err: %d, status: 0x%x, out size: 0x%x\n",
+				err, register_info.status, out_size);
+			hinic_unregister_vf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
+			return -EIO;
+		}
+	} else {
+		err = hinic_register_pf_mbox_cb(hwdev, HINIC_MOD_CFGM,
+						cfg_mbx_pf_proc_vf_msg);
+		if (err) {
+			dev_err(&hwdev->hwif->pdev->dev,
+				"Register PF mailbox callback failed\n");
+			return err;
+		}
+		nic_io->max_vfs = hwdev->nic_cap.max_vf;
+		size = sizeof(*nic_io->vf_infos) * nic_io->max_vfs;
+		if (size != 0) {
+			nic_io->vf_infos = kzalloc(size, GFP_KERNEL);
+			if (!nic_io->vf_infos) {
+				err = -ENOMEM;
+				goto out_free_nic_io;
+			}
+
+			for (i = 0; i < nic_io->max_vfs; i++) {
+				err = hinic_init_vf_infos(nic_io, i);
+				if (err)
+					goto err_init_vf_infos;
+			}
+
+			err = hinic_register_pf_mbox_cb(hwdev, HINIC_MOD_L2NIC,
+							nic_pf_mbox_handler);
+			if (err)
+				goto err_register_pf_mbox_cb;
+		}
+	}
+
+	return 0;
+
+err_register_pf_mbox_cb:
+err_init_vf_infos:
+	kfree(nic_io->vf_infos);
+out_free_nic_io:
+	return err;
+}
+
+void hinic_vf_func_free(struct hinic_hwdev *hwdev)
+{
+	struct hinic_register_vf unregister = {0};
+	u16 out_size = sizeof(unregister);
+	int err;
+
+	if (HINIC_IS_VF(hwdev->hwif)) {
+		err = hinic_mbox_to_pf(hwdev, HINIC_MOD_L2NIC,
+				       HINIC_PORT_CMD_VF_UNREGISTER,
+				       &unregister, sizeof(unregister),
+				       &unregister, &out_size, 0);
+		if (err || !out_size || unregister.status)
+			dev_err(&hwdev->hwif->pdev->dev, "Failed to unregister VF, err: %d, status: 0x%x, out_size: 0x%x\n",
+				err, unregister.status, out_size);
+	} else {
+		if (hwdev->func_to_io.vf_infos) {
+			hinic_unregister_pf_mbox_cb(hwdev, HINIC_MOD_L2NIC);
+			kfree(hwdev->func_to_io.vf_infos);
+		}
+	}
+}
+
+int hinic_init_vf_hw(struct hinic_hwdev *hwdev, u16 start_vf_id, u16 end_vf_id)
+{
+	u16 i, func_idx;
+	int err;
+
+	/* vf use 256K as default wq page size, and can't change it */
+	for (i = start_vf_id; i <= end_vf_id; i++) {
+		func_idx = hinic_glb_pf_vf_offset(hwdev->hwif) + i;
+		err = hinic_set_wq_page_size(hwdev, func_idx,
+					     HINIC_DEFAULT_WQ_PAGE_SIZE);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int hinic_pci_sriov_disable(struct pci_dev *pdev)
+{
+	struct hinic_sriov_info *sriov_info;
+	u16 tmp_vfs;
+
+	sriov_info = hinic_get_sriov_info_by_pcidev(pdev);
+	/* if SR-IOV is already disabled then nothing will be done */
+	if (!sriov_info->sriov_enabled)
+		return 0;
+
+	set_bit(HINIC_SRIOV_DISABLE, &sriov_info->state);
+
+	/* If our VFs are assigned we cannot shut down SR-IOV
+	 * without causing issues, so just leave the hardware
+	 * available but disabled
+	 */
+	if (pci_vfs_assigned(sriov_info->pdev)) {
+		clear_bit(HINIC_SRIOV_DISABLE, &sriov_info->state);
+		dev_warn(&pdev->dev, "Unloading driver while VFs are assigned - VFs will not be deallocated\n");
+		return -EPERM;
+	}
+	sriov_info->sriov_enabled = false;
+
+	/* disable iov and allow time for transactions to clear */
+	pci_disable_sriov(sriov_info->pdev);
+
+	tmp_vfs = (u16)sriov_info->num_vfs;
+	sriov_info->num_vfs = 0;
+	hinic_deinit_vf_hw(sriov_info, OS_VF_ID_TO_HW(0),
+			   OS_VF_ID_TO_HW(tmp_vfs - 1));
+
+	clear_bit(HINIC_SRIOV_DISABLE, &sriov_info->state);
+
+	return 0;
+}
+
+int hinic_pci_sriov_enable(struct pci_dev *pdev, int num_vfs)
+{
+	struct hinic_sriov_info *sriov_info;
+	int err;
+
+	sriov_info = hinic_get_sriov_info_by_pcidev(pdev);
+
+	if (test_and_set_bit(HINIC_SRIOV_ENABLE, &sriov_info->state)) {
+		dev_err(&pdev->dev,
+			"SR-IOV enable in process, please wait, num_vfs %d\n",
+			num_vfs);
+		return -EPERM;
+	}
+
+	err = hinic_init_vf_hw(sriov_info->hwdev, OS_VF_ID_TO_HW(0),
+			       OS_VF_ID_TO_HW((u16)num_vfs - 1));
+	if (err) {
+		dev_err(&sriov_info->pdev->dev,
+			"Failed to init vf in hardware before enable sriov, error %d\n",
+			err);
+		clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
+		return err;
+	}
+
+	err = pci_enable_sriov(sriov_info->pdev, num_vfs);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Failed to enable SR-IOV, error %d\n", err);
+		clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
+		return err;
+	}
+
+	sriov_info->sriov_enabled = true;
+	sriov_info->num_vfs = num_vfs;
+	clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
+
+	return num_vfs;
+}
+
+int hinic_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
+{
+	struct hinic_sriov_info *sriov_info;
+
+	sriov_info = hinic_get_sriov_info_by_pcidev(dev);
+
+	if (test_bit(HINIC_FUNC_REMOVE, &sriov_info->state))
+		return -EBUSY;
+
+	if (!num_vfs)
+		return hinic_pci_sriov_disable(dev);
+	else
+		return hinic_pci_sriov_enable(dev, num_vfs);
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.h b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
new file mode 100644
index 000000000000..4889eabe7b7c
--- /dev/null
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Huawei HiNIC PCI Express Linux driver
+ * Copyright(c) 2017 Huawei Technologies Co., Ltd
+ */
+
+#ifndef HINIC_SRIOV_H
+#define HINIC_SRIOV_H
+
+#include "hinic_hw_dev.h"
+
+#define OS_VF_ID_TO_HW(os_vf_id) ((os_vf_id) + 1)
+#define HW_VF_ID_TO_OS(hw_vf_id) ((hw_vf_id) - 1)
+
+enum hinic_sriov_state {
+	HINIC_SRIOV_DISABLE,
+	HINIC_SRIOV_ENABLE,
+	HINIC_FUNC_REMOVE,
+};
+
+enum {
+	HINIC_IFLA_VF_LINK_STATE_AUTO,	/* link state of the uplink */
+	HINIC_IFLA_VF_LINK_STATE_ENABLE,	/* link always up */
+	HINIC_IFLA_VF_LINK_STATE_DISABLE,	/* link always down */
+};
+
+struct hinic_sriov_info {
+	struct pci_dev *pdev;
+	struct hinic_hwdev *hwdev;
+	bool sriov_enabled;
+	unsigned int num_vfs;
+	unsigned long state;
+};
+
+struct vf_data_storage {
+	u8 vf_mac_addr[ETH_ALEN];
+	bool registered;
+	bool pf_set_mac;
+	u16 pf_vlan;
+	u8 pf_qos;
+	u32 max_rate;
+	u32 min_rate;
+
+	bool link_forced;
+	bool link_up;		/* only valid if VF link is forced */
+	bool spoofchk;
+	bool trust;
+};
+
+struct hinic_register_vf {
+	u8	status;
+	u8	version;
+	u8	rsvd0[6];
+};
+
+struct hinic_vf_vlan_config {
+	u8 status;
+	u8 version;
+	u8 rsvd0[6];
+
+	u16 func_id;
+	u16 vlan_id;
+	u8  qos;
+	u8  rsvd1[7];
+};
+
+void hinic_notify_all_vfs_link_changed(struct hinic_hwdev *hwdev,
+				       u8 link_status);
+
+int hinic_pci_sriov_disable(struct pci_dev *dev);
+
+int hinic_pci_sriov_enable(struct pci_dev *dev, int num_vfs);
+
+int hinic_vf_func_init(struct hinic_hwdev *hwdev);
+
+void hinic_vf_func_free(struct hinic_hwdev *hwdev);
+
+int hinic_pci_sriov_configure(struct pci_dev *dev, int num_vfs);
+
+#endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
index 365016450bdb..4c66a0bc1b28 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
@@ -673,9 +673,11 @@ static int free_tx_poll(struct napi_struct *napi, int budget)
 
 	if (pkts < budget) {
 		napi_complete(napi);
-		hinic_hwdev_set_msix_state(nic_dev->hwdev,
-					   sq->msix_entry,
-					   HINIC_MSIX_ENABLE);
+		if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+			hinic_hwdev_set_msix_state(nic_dev->hwdev,
+						   sq->msix_entry,
+						   HINIC_MSIX_ENABLE);
+
 		return pkts;
 	}
 
@@ -701,10 +703,11 @@ static irqreturn_t tx_irq(int irq, void *data)
 
 	nic_dev = netdev_priv(txq->netdev);
 
-	/* Disable the interrupt until napi will be completed */
-	hinic_hwdev_set_msix_state(nic_dev->hwdev,
-				   txq->sq->msix_entry,
-				   HINIC_MSIX_DISABLE);
+	if (!HINIC_IS_VF(nic_dev->hwdev->hwif))
+		/* Disable the interrupt until napi will be completed */
+		hinic_hwdev_set_msix_state(nic_dev->hwdev,
+					   txq->sq->msix_entry,
+					   HINIC_MSIX_DISABLE);
 
 	hinic_hwdev_msix_cnt_set(nic_dev->hwdev, txq->sq->msix_entry);
 
-- 
2.17.1

