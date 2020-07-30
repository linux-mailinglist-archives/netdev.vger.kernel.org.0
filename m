Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220AB232EC2
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgG3IhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:37:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50794 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728646AbgG3IhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 04:37:16 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 596973A42266DF529B08;
        Thu, 30 Jul 2020 16:37:13 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 30 Jul 2020 16:37:03 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v1 1/2] hinic: add generating mailbox random index support
Date:   Thu, 30 Jul 2020 16:37:15 +0800
Message-ID: <20200730083716.4613-2-luobin9@huawei.com>
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

add support to generate mailbox random id of VF to ensure that
mailbox messages PF received are from the correct VF.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  13 ++
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.c | 136 ++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_hw_mbox.h |   8 ++
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h |   2 +
 .../net/ethernet/huawei/hinic/hinic_sriov.c   |   7 +
 5 files changed, 166 insertions(+)

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
index 47c93f946b94..570beeb3048f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c
@@ -486,6 +486,111 @@ static void recv_mbox_handler(struct hinic_mbox_func_to_func *func_to_func,
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
@@ -504,6 +609,9 @@ void hinic_mbox_func_aeqe_handler(void *handle, void *header, u8 size)
 		return;
 	}
 
+	if (!check_vf_mbox_random_id(func_to_func, header))
+		return;
+
 	recv_mbox = (dir == HINIC_HWIF_DIRECT_SEND) ?
 		    &func_to_func->mbox_send[src] :
 		    &func_to_func->mbox_resp[src];
@@ -1210,3 +1318,31 @@ void hinic_func_to_func_free(struct hinic_hwdev *hwdev)
 
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
index 7b18559bfe80..0618fe515d9c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h
@@ -22,6 +22,8 @@
 #define HINIC_FUNC_CSR_MAILBOX_RESULT_H_OFF		0x0108
 #define HINIC_FUNC_CSR_MAILBOX_RESULT_L_OFF		0x010C
 
+#define MAX_FUNCTION_NUM		512
+
 enum hinic_mbox_ack_type {
 	MBOX_ACK,
 	MBOX_NO_ACK,
@@ -100,6 +102,10 @@ struct hinic_mbox_func_to_func {
 
 	/* lock for mbox event flag */
 	spinlock_t mbox_lock;
+
+	u32 vf_mbx_old_rand_id[MAX_FUNCTION_NUM];
+	u32 vf_mbx_rand_id[MAX_FUNCTION_NUM];
+	bool support_vf_random;
 };
 
 struct hinic_mbox_work {
@@ -151,4 +157,6 @@ int hinic_mbox_to_vf(struct hinic_hwdev *hwdev,
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
index 141206917e4d..1d8a115cb9ec 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -1108,6 +1108,13 @@ int hinic_vf_func_init(struct hinic_hwdev *hwdev)
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

