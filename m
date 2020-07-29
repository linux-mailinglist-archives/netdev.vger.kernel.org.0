Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15E8231703
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgG2A73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:59:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48256 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729867AbgG2A71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 20:59:27 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2B954661292273F7B9AF;
        Wed, 29 Jul 2020 08:59:25 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Wed, 29 Jul 2020 08:59:15 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next] hinic: add generating mailbox random index support
Date:   Wed, 29 Jul 2020 08:59:19 +0800
Message-ID: <20200729005919.11293-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add support to generate mailbox random id for VF to ensure that
the mailbox message from VF is valid and PF should check whether
the cmd from VF is supported before passing it to hw.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_cmdq.h |   8 +
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  13 +
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 309 +++++++++++++++++-
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |  22 ++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   2 +
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |  70 +++-
 6 files changed, 422 insertions(+), 2 deletions(-)

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
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 2fb5f784f116..dc6e645f2689 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -28,6 +28,8 @@
 #define HINIC_MGMT_STATUS_EXIST				0x6
 #define HINIC_MGMT_CMD_UNSUPPORTED			0xFF
 
+#define HINIC_CMD_VER_FUNC_ID				2
+
 struct hinic_cap {
 	u16     max_qps;
 	u16     num_qps;
@@ -313,6 +315,17 @@ struct hinic_msix_config {
 	u8	rsvd1[3];
 };
 
+struct hinic_set_random_id {
+	u8    status;
+	u8    version;
+	u8    rsvd0[6];
+
+	u8    vf_in_pf;
+	u8    rsvd1;
+	u16   func_idx;
+	u32   random_id;
+};
+
 struct hinic_board_info {
 	u32	board_type;
 	u32	port_num;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
index 47c93f946b94..cbc78b267b06 100644
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
@@ -486,6 +516,111 @@ static void recv_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
 	kfree(rcv_mbox_temp);
 }
 
+static int set_vf_mbox_random_id(struct hinic_hwdev *hwdev, u16 func_id)
+{
+	struct hinic_mbox_func_to_func *func_to_func = hwdev->func_to_func;
+	struct hinic_set_random_id rand_info = {0};
+	u16 out_size = sizeof(rand_info);
+	struct hinic_pfhwdev *pfhwdev;
+	int ret;
+
+	pfhwdev = container_of(hwdev, struct hinic_pfhwdev, hwdev);
+
+	rand_info.version = HINIC_CMD_VER_FUNC_ID;
+	rand_info.func_idx = func_id;
+	rand_info.vf_in_pf = (u8)(func_id - hinic_glb_pf_vf_offset(hwdev->hwif));
+	get_random_bytes(&rand_info.random_id, sizeof(u32));
+
+	func_to_func->vf_mbx_rand_id[func_id] = rand_info.random_id;
+
+	ret = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_COMM,
+				HINIC_MGMT_CMD_SET_VF_RANDOM_ID,
+				&rand_info, sizeof(rand_info),
+				&rand_info, &out_size, HINIC_MGMT_MSG_SYNC);
+	if ((rand_info.status != HINIC_MGMT_CMD_UNSUPPORTED &&
+	     rand_info.status) || !out_size || ret) {
+		dev_err(&hwdev->hwif->pdev->dev, "Set VF random id failed, err: %d, status: 0x%x, out size: 0x%x\n",
+			ret, rand_info.status, out_size);
+		return -EIO;
+	}
+
+	if (rand_info.status == HINIC_MGMT_CMD_UNSUPPORTED)
+		return rand_info.status;
+
+	func_to_func->vf_mbx_old_rand_id[func_id] =
+				func_to_func->vf_mbx_rand_id[func_id];
+
+	return 0;
+}
+
+static void update_random_id_work_handler(struct work_struct *work)
+{
+	struct hinic_mbox_work *mbox_work =
+			container_of(work, struct hinic_mbox_work, work);
+	struct hinic_mbox_func_to_func *func_to_func;
+	u16 src = mbox_work->src_func_idx;
+
+	func_to_func = mbox_work->func_to_func;
+
+	if (set_vf_mbox_random_id(func_to_func->hwdev, src))
+		dev_warn(&func_to_func->hwdev->hwif->pdev->dev, "Update VF id: 0x%x random id failed\n",
+			 mbox_work->src_func_idx);
+
+	kfree(mbox_work);
+}
+
+bool check_vf_mbox_random_id(struct hinic_mbox_func_to_func *func_to_func,
+			     u8 *header)
+{
+	struct hinic_hwdev *hwdev = func_to_func->hwdev;
+	struct hinic_mbox_work *mbox_work = NULL;
+	u64 mbox_header = *((u64 *)header);
+	u16 offset, src;
+	u32 random_id;
+	int vf_in_pf;
+
+	src = HINIC_MBOX_HEADER_GET(mbox_header, SRC_GLB_FUNC_IDX);
+
+	if (IS_PF_OR_PPF_SRC(src) || !func_to_func->support_vf_random)
+		return true;
+
+	if (!HINIC_IS_PPF(hwdev->hwif)) {
+		offset = hinic_glb_pf_vf_offset(hwdev->hwif);
+		vf_in_pf = src - offset;
+
+		if (vf_in_pf < 1 || vf_in_pf > hwdev->nic_cap.max_vf) {
+			dev_warn(&hwdev->hwif->pdev->dev,
+				 "Receive vf id(0x%x) is invalid, vf id should be from 0x%x to 0x%x\n",
+				 src, offset + 1,
+				 hwdev->nic_cap.max_vf + offset);
+			return false;
+		}
+	}
+
+	random_id = be32_to_cpu(*(u32 *)(header + MBOX_SEG_LEN +
+					 MBOX_HEADER_SZ));
+
+	if (random_id == func_to_func->vf_mbx_rand_id[src] ||
+	    random_id == func_to_func->vf_mbx_old_rand_id[src])
+		return true;
+
+	dev_warn(&hwdev->hwif->pdev->dev,
+		 "The mailbox random id(0x%x) of func_id(0x%x) doesn't match with pf reservation(0x%x)\n",
+		 random_id, src, func_to_func->vf_mbx_rand_id[src]);
+
+	mbox_work = kzalloc(sizeof(*mbox_work), GFP_KERNEL);
+	if (!mbox_work)
+		return false;
+
+	mbox_work->func_to_func = func_to_func;
+	mbox_work->src_func_idx = src;
+
+	INIT_WORK(&mbox_work->work, update_random_id_work_handler);
+	queue_work(func_to_func->workq, &mbox_work->work);
+
+	return false;
+}
+
 void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
 {
 	struct hinic_mbox_func_to_func *func_to_func;
@@ -504,6 +639,9 @@ void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
 		return;
 	}
 
+	if (!check_vf_mbox_random_id(func_to_func, header))
+		return;
+
 	recv_mbox = (dir == HINIC_HWIF_DIRECT_SEND) ?
 		    &func_to_func->mbox_send[src] :
 		    &func_to_func->mbox_resp[src];
@@ -1097,15 +1235,156 @@ static void free_mbox_wb_status(struct hinic_mbox_func_to_func *func_to_func)
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
@@ -1210,3 +1489,31 @@ void hinic_func_to_func_free(struct hinic_hwdev *hwdev)
 
 	kfree(func_to_func);
 }
+
+int hinic_vf_mbox_random_id_init(struct hinic_hwdev *hwdev)
+{
+	u8 vf_in_pf;
+	int err = 0;
+
+	if (HINIC_IS_VF(hwdev->hwif))
+		return 0;
+
+	for (vf_in_pf = 1; vf_in_pf <= hwdev->nic_cap.max_vf; vf_in_pf++) {
+		err = set_vf_mbox_random_id(hwdev, hinic_glb_pf_vf_offset
+					    (hwdev->hwif) + vf_in_pf);
+		if (err)
+			break;
+	}
+
+	if (err == HINIC_MGMT_CMD_UNSUPPORTED) {
+		hwdev->func_to_func->support_vf_random = false;
+		err = 0;
+		dev_warn(&hwdev->hwif->pdev->dev, "Mgmt is unsupported to set VF%d random id\n",
+			 vf_in_pf - 1);
+	} else if (!err) {
+		hwdev->func_to_func->support_vf_random = true;
+		dev_info(&hwdev->hwif->pdev->dev, "PF Set VF random id success\n");
+	}
+
+	return err;
+}
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
index 7b18559bfe80..46953190d29e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
@@ -22,6 +22,14 @@
 #define HINIC_FUNC_CSR_MAILBOX_RESULT_H_OFF		0x0108
 #define HINIC_FUNC_CSR_MAILBOX_RESULT_L_OFF		0x010C
 
+#define MAX_FUNCTION_NUM		512
+
+struct vf_cmd_check_handle {
+	u8 cmd;
+	bool (*check_cmd)(struct hinic_hwdev *hwdev, u16 src_func_idx,
+			  void *buf_in, u16 in_size);
+};
+
 enum hinic_mbox_ack_type {
 	MBOX_ACK,
 	MBOX_NO_ACK,
@@ -100,6 +108,10 @@ struct hinic_mbox_func_to_func {
 
 	/* lock for mbox event flag */
 	spinlock_t mbox_lock;
+
+	u32 vf_mbx_old_rand_id[MAX_FUNCTION_NUM];
+	u32 vf_mbx_rand_id[MAX_FUNCTION_NUM];
+	bool support_vf_random;
 };
 
 struct hinic_mbox_work {
@@ -116,6 +128,14 @@ struct vf_cmd_msg_handle {
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
@@ -151,4 +171,6 @@ int hinic_mbox_to_vf(struct hinic_hwdev *hwdev,
 		     enum hinic_mod_type mod, u16 vf_id, u8 cmd, void *buf_in,
 		     u16 in_size, void *buf_out, u16 *out_size, u32 timeout);
 
+int hinic_vf_mbox_random_id_init(struct hinic_hwdev *hwdev);
+
 #endif
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index f626100b85c1..4ca81cc838db 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -93,6 +93,8 @@ enum hinic_comm_cmd {
 
 	HINIC_COMM_CMD_WATCHDOG_INFO	= 0x56,
 
+	HINIC_MGMT_CMD_SET_VF_RANDOM_ID = 0x61,
+
 	HINIC_COMM_CMD_MAX,
 };
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index 141206917e4d..28aedd10a061 100644
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
@@ -980,7 +1032,16 @@ static int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
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
+		err = HINIC_MBOX_VF_CMD_ERROR;
+		return err;
+	}
 
 	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
 	nic_io = &dev->func_to_io;
@@ -1108,6 +1169,13 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
 	int err = 0;
 	u32 size, i;
 
+	err = hinic_vf_mbox_random_id_init(hwdev);
+	if (err) {
+		dev_err(&hwdev->hwif->pdev->dev, "Failed to init vf mbox random id, err: %d\n",
+			err);
+		return err;
+	}
+
 	nic_io = &hwdev->func_to_io;
 
 	if (HINIC_IS_VF(hwdev->hwif)) {
-- 
2.17.1

