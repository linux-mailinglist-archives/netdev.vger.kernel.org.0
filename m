Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBDF232EBE
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgG3IhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:37:17 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgG3IhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 04:37:16 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 53CBBBD81FA7CBF9C769;
        Thu, 30 Jul 2020 16:37:13 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 30 Jul 2020 16:37:04 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v1 2/2] hinic: add check for mailbox msg from VF
Date:   Thu, 30 Jul 2020 16:37:16 +0800
Message-ID: <20200730083716.4613-3-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730083716.4613-1-luobin9@huawei.com>
References: <20200730083716.4613-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PF should check whether the cmd from VF is supported and its content
is right before passing it to hw.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |   8 +
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 173 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  14 ++
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |  62 ++++++-
 4 files changed, 255 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
index f40c31e1879f..9c413e963a04 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h
@@ -31,6 +31,10 @@
 			(((u64)(val) & HINIC_CMDQ_CTXT_##member##_MASK) \
 			 << HINIC_CMDQ_CTXT_##member##_SHIFT)
 
+#define HINIC_CMDQ_CTXT_PAGE_INFO_GET(val, member)	\
+			(((u64)(val) >> HINIC_CMDQ_CTXT_##member##_SHIFT) \
+			 & HINIC_CMDQ_CTXT_##member##_MASK)
+
 #define HINIC_CMDQ_CTXT_PAGE_INFO_CLEAR(val, member)    \
 			((val) & (~((u64)HINIC_CMDQ_CTXT_##member##_MASK \
 			 << HINIC_CMDQ_CTXT_##member##_SHIFT)))
@@ -45,6 +49,10 @@
 			(((u64)(val) & HINIC_CMDQ_CTXT_##member##_MASK) \
 			 << HINIC_CMDQ_CTXT_##member##_SHIFT)
 
+#define HINIC_CMDQ_CTXT_BLOCK_INFO_GET(val, member)	\
+			(((u64)(val) >> HINIC_CMDQ_CTXT_##member##_SHIFT) \
+			& HINIC_CMDQ_CTXT_##member##_MASK)
+
 #define HINIC_CMDQ_CTXT_BLOCK_INFO_CLEAR(val, member)   \
 			((val) & (~((u64)HINIC_CMDQ_CTXT_##member##_MASK \
 			 << HINIC_CMDQ_CTXT_##member##_SHIFT)))
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index 570beeb3048f..cbc78b267b06 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -153,7 +153,6 @@ enum hinic_mbox_tx_status {
 			(MBOX_MSG_ID(func_to_func_mbox) + 1) & MBOX_MSG_ID_MASK)
 
 #define FUNC_ID_OFF_SET_8B		8
-#define FUNC_ID_OFF_SET_10B		10
 
 /* max message counter wait to process for one function */
 #define HINIC_MAX_MSG_CNT_TO_PROCESS	10
@@ -189,6 +188,37 @@ enum mbox_aeq_trig_type {
 	TRIGGER,
 };
 
+static bool check_func_id(struct hinic_hwdev *hwdev, u16 src_func_idx,
+			  const void *buf_in, u16 in_size, u16 offset)
+{
+	u16 func_idx;
+
+	if (in_size < offset + sizeof(func_idx)) {
+		dev_warn(&hwdev->hwif->pdev->dev,
+			 "Receive mailbox msg len: %d less than %d Bytes is invalid\n",
+			 in_size, offset);
+		return false;
+	}
+
+	func_idx = *((u16 *)((u8 *)buf_in + offset));
+
+	if (src_func_idx != func_idx) {
+		dev_warn(&hwdev->hwif->pdev->dev,
+			 "Receive mailbox function id: 0x%x not equal to msg function id: 0x%x\n",
+			 src_func_idx, func_idx);
+		return false;
+	}
+
+	return true;
+}
+
+bool hinic_mbox_check_func_id_8B(struct hinic_hwdev *hwdev, u16 func_idx,
+				 void *buf_in, u16 in_size)
+{
+	return check_func_id(hwdev, func_idx, buf_in, in_size,
+			     FUNC_ID_OFF_SET_8B);
+}
+
 /**
  * hinic_register_pf_mbox_cb - register mbox callback for pf
  * @hwdev: the pointer to hw device
@@ -1205,15 +1235,156 @@ static void free_mbox_wb_status(struct hinic_mbox_func_to_func *func_to_func)
 			  send_mbox->wb_paddr);
 }
 
+bool hinic_mbox_check_cmd_valid(struct hinic_hwdev *hwdev,
+				struct vf_cmd_check_handle *cmd_handle,
+				u16 vf_id, u8 cmd, void *buf_in,
+				u16 in_size, u8 size)
+{
+	u16 src_idx = vf_id + hinic_glb_pf_vf_offset(hwdev->hwif);
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (cmd == cmd_handle[i].cmd) {
+			if (cmd_handle[i].check_cmd)
+				return cmd_handle[i].check_cmd(hwdev, src_idx,
+							       buf_in, in_size);
+			else
+				return true;
+		}
+	}
+
+	dev_err(&hwdev->hwif->pdev->dev,
+		"PF Receive VF(%d) unsupported cmd(0x%x)\n",
+		vf_id + hinic_glb_pf_vf_offset(hwdev->hwif), cmd);
+
+	return false;
+}
+
+static bool hinic_cmdq_check_vf_ctxt(struct hinic_hwdev *hwdev,
+				     struct hinic_cmdq_ctxt *cmdq_ctxt)
+{
+	struct hinic_cmdq_ctxt_info *ctxt_info = &cmdq_ctxt->ctxt_info;
+	u64 curr_pg_pfn, wq_block_pfn;
+
+	if (cmdq_ctxt->ppf_idx != HINIC_HWIF_PPF_IDX(hwdev->hwif) ||
+	    cmdq_ctxt->cmdq_type > HINIC_MAX_CMDQ_TYPES)
+		return false;
+
+	curr_pg_pfn = HINIC_CMDQ_CTXT_PAGE_INFO_GET
+		(ctxt_info->curr_wqe_page_pfn, CURR_WQE_PAGE_PFN);
+	wq_block_pfn = HINIC_CMDQ_CTXT_BLOCK_INFO_GET
+		(ctxt_info->wq_block_pfn, WQ_BLOCK_PFN);
+	/* VF must use 0-level CLA */
+	if (curr_pg_pfn != wq_block_pfn)
+		return false;
+
+	return true;
+}
+
+static bool check_cmdq_ctxt(struct hinic_hwdev *hwdev, u16 func_idx,
+			    void *buf_in, u16 in_size)
+{
+	if (!hinic_mbox_check_func_id_8B(hwdev, func_idx, buf_in, in_size))
+		return false;
+
+	return hinic_cmdq_check_vf_ctxt(hwdev, buf_in);
+}
+
+#define HW_CTX_QPS_VALID(hw_ctxt)   \
+		((hw_ctxt)->rq_depth >= HINIC_QUEUE_MIN_DEPTH &&	\
+		(hw_ctxt)->rq_depth <= HINIC_QUEUE_MAX_DEPTH &&	\
+		(hw_ctxt)->sq_depth >= HINIC_QUEUE_MIN_DEPTH &&	\
+		(hw_ctxt)->sq_depth <= HINIC_QUEUE_MAX_DEPTH &&	\
+		(hw_ctxt)->rx_buf_sz_idx <= HINIC_MAX_RX_BUFFER_SIZE)
+
+static bool hw_ctxt_qps_param_valid(struct hinic_cmd_hw_ioctxt *hw_ctxt)
+{
+	if (HW_CTX_QPS_VALID(hw_ctxt))
+		return true;
+
+	if (!hw_ctxt->rq_depth && !hw_ctxt->sq_depth &&
+	    !hw_ctxt->rx_buf_sz_idx)
+		return true;
+
+	return false;
+}
+
+static bool check_hwctxt(struct hinic_hwdev *hwdev, u16 func_idx,
+			 void *buf_in, u16 in_size)
+{
+	struct hinic_cmd_hw_ioctxt *hw_ctxt = buf_in;
+
+	if (!hinic_mbox_check_func_id_8B(hwdev, func_idx, buf_in, in_size))
+		return false;
+
+	if (hw_ctxt->ppf_idx != HINIC_HWIF_PPF_IDX(hwdev->hwif))
+		return false;
+
+	if (hw_ctxt->set_cmdq_depth) {
+		if (hw_ctxt->cmdq_depth >= HINIC_QUEUE_MIN_DEPTH &&
+		    hw_ctxt->cmdq_depth <= HINIC_QUEUE_MAX_DEPTH)
+			return true;
+
+		return false;
+	}
+
+	return hw_ctxt_qps_param_valid(hw_ctxt);
+}
+
+static bool check_set_wq_page_size(struct hinic_hwdev *hwdev, u16 func_idx,
+				   void *buf_in, u16 in_size)
+{
+	struct hinic_wq_page_size *page_size_info = buf_in;
+
+	if (!hinic_mbox_check_func_id_8B(hwdev, func_idx, buf_in, in_size))
+		return false;
+
+	if (page_size_info->ppf_idx != HINIC_HWIF_PPF_IDX(hwdev->hwif))
+		return false;
+
+	if (((1U << page_size_info->page_size) * SZ_4K) !=
+	    HINIC_DEFAULT_WQ_PAGE_SIZE)
+		return false;
+
+	return true;
+}
+
+struct vf_cmd_check_handle hw_cmd_support_vf[] = {
+	{HINIC_COMM_CMD_START_FLR, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_DMA_ATTR_SET, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_CMDQ_CTXT_SET, check_cmdq_ctxt},
+	{HINIC_COMM_CMD_CMDQ_CTXT_GET, check_cmdq_ctxt},
+	{HINIC_COMM_CMD_HWCTXT_SET, check_hwctxt},
+	{HINIC_COMM_CMD_HWCTXT_GET, check_hwctxt},
+	{HINIC_COMM_CMD_SQ_HI_CI_SET, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_RES_STATE_SET, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_IO_RES_CLEAR, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_CEQ_CTRL_REG_WR_BY_UP, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_MSI_CTRL_REG_WR_BY_UP, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_MSI_CTRL_REG_RD_BY_UP, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_L2NIC_RESET, hinic_mbox_check_func_id_8B},
+	{HINIC_COMM_CMD_PAGESIZE_SET, check_set_wq_page_size},
+};
+
 static int comm_pf_mbox_handler(void *handle, u16 vf_id, u8 cmd, void *buf_in,
 				u16 in_size, void *buf_out, u16 *out_size)
 {
+	u8 size = ARRAY_SIZE(hw_cmd_support_vf);
 	struct hinic_hwdev *hwdev = handle;
 	struct hinic_pfhwdev *pfhwdev;
 	int err = 0;
 
 	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
 
+	if (!hinic_mbox_check_cmd_valid(handle, hw_cmd_support_vf, vf_id, cmd,
+					buf_in, in_size, size)) {
+		dev_err(&hwdev->hwif->pdev->dev,
+			"PF Receive VF: %d common cmd: 0x%x or mbox len: 0x%x is invalid\n",
+			vf_id + hinic_glb_pf_vf_offset(hwdev->hwif), cmd,
+			in_size);
+		return HINIC_MBOX_VF_CMD_ERROR;
+	}
+
 	if (cmd == HINIC_COMM_CMD_START_FLR) {
 		*out_size = 0;
 	} else {
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
index 0618fe515d9c..46953190d29e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
@@ -24,6 +24,12 @@
 
 #define MAX_FUNCTION_NUM		512
 
+struct vf_cmd_check_handle {
+	u8 cmd;
+	bool (*check_cmd)(struct hinic_hwdev *hwdev, u16 src_func_idx,
+			  void *buf_in, u16 in_size);
+};
+
 enum hinic_mbox_ack_type {
 	MBOX_ACK,
 	MBOX_NO_ACK,
@@ -122,6 +128,14 @@ struct vf_cmd_msg_handle {
 			       void *buf_out, u16 *out_size);
 };
 
+bool hinic_mbox_check_func_id_8B(struct hinic_hwdev *hwdev, u16 func_idx,
+				 void *buf_in, u16 in_size);
+
+bool hinic_mbox_check_cmd_valid(struct hinic_hwdev *hwdev,
+				struct vf_cmd_check_handle *cmd_handle,
+				u16 vf_id, u8 cmd, void *buf_in,
+				u16 in_size, u8 size);
+
 int hinic_register_pf_mbox_cb(struct hinic_hwdev *hwdev,
 			      enum hinic_mod_type mod,
 			      hinic_pf_mbox_cb callback);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index 1d8a115cb9ec..e6525caab823 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -429,6 +429,18 @@ static int hinic_get_vf_link_status_msg_handler(void *hwdev, u16 vf_id,
 	return 0;
 }
 
+static bool check_func_table(struct hinic_hwdev *hwdev, u16 func_idx,
+			     void *buf_in, u16 in_size)
+{
+	struct hinic_cmd_fw_ctxt *function_table = buf_in;
+
+	if (!hinic_mbox_check_func_id_8B(hwdev, func_idx, buf_in, in_size) ||
+	    !function_table->rx_buf_sz)
+		return false;
+
+	return true;
+}
+
 static struct vf_cmd_msg_handle nic_vf_cmd_msg_handler[] = {
 	{HINIC_PORT_CMD_VF_REGISTER, hinic_register_vf_msg_handler},
 	{HINIC_PORT_CMD_VF_UNREGISTER, hinic_unregister_vf_msg_handler},
@@ -439,6 +451,45 @@ static struct vf_cmd_msg_handle nic_vf_cmd_msg_handler[] = {
 	{HINIC_PORT_CMD_GET_LINK_STATE, hinic_get_vf_link_status_msg_handler},
 };
 
+struct vf_cmd_check_handle nic_cmd_support_vf[] = {
+	{HINIC_PORT_CMD_VF_REGISTER, NULL},
+	{HINIC_PORT_CMD_VF_UNREGISTER, NULL},
+	{HINIC_PORT_CMD_CHANGE_MTU, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_ADD_VLAN, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_DEL_VLAN, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_MAC, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_MAC, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_DEL_MAC, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RX_MODE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_PAUSE_INFO, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_LINK_STATE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_LRO, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RX_CSUM, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RX_VLAN_OFFLOAD, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_VPORT_STAT, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_CLEAN_VPORT_STAT, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL,
+	 hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RSS_HASH_ENGINE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_RSS_HASH_ENGINE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_RSS_CTX_TBL, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RSS_CTX_TBL, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_RSS_TEMP_MGR, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_RSS_CFG, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_FWCTXT_INIT, check_func_table},
+	{HINIC_PORT_CMD_GET_MGMT_VERSION, NULL},
+	{HINIC_PORT_CMD_SET_FUNC_STATE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_GLOBAL_QPN, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_TSO, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_RQ_IQ_MAP, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_LINK_STATUS_REPORT, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_UPDATE_MAC, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_CAP, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_LINK_MODE, hinic_mbox_check_func_id_8B},
+};
+
 #define CHECK_IPSU_15BIT	0X8000
 
 static
@@ -972,6 +1023,7 @@ int hinic_ndo_set_vf_link_state(struct net_device *netdev, int vf_id, int link)
 static int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 			       u16 in_size, void *buf_out, u16 *out_size)
 {
+	u8 size = ARRAY_SIZE(nic_cmd_support_vf);
 	struct vf_cmd_msg_handle *vf_msg_handle;
 	struct hinic_hwdev *dev = hwdev;
 	struct hinic_func_to_io *nic_io;
@@ -980,7 +1032,15 @@ static int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 	u32 i;
 
 	if (!hwdev)
-		return -EFAULT;
+		return -EINVAL;
+
+	if (!hinic_mbox_check_cmd_valid(hwdev, nic_cmd_support_vf, vf_id, cmd,
+					buf_in, in_size, size)) {
+		dev_err(&dev->hwif->pdev->dev,
+			"PF Receive VF nic cmd: 0x%x, mbox len: 0x%x is invalid\n",
+			cmd, in_size);
+		return HINIC_MBOX_VF_CMD_ERROR;
+	}
 
 	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
 	nic_io = &dev->func_to_io;
-- 
2.17.1

