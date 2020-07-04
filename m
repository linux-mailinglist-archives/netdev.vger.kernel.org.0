Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238CD21447C
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 09:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgGDHfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 03:35:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7370 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbgGDHfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Jul 2020 03:35:05 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4B15C5F4DE94B68CEE44;
        Sat,  4 Jul 2020 15:33:13 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Sat, 4 Jul 2020 15:33:03 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net] hinic: fix sending mailbox timeout in aeq event work
Date:   Sat, 4 Jul 2020 15:32:43 +0800
Message-ID: <20200704073243.6842-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending mailbox in the work of aeq event, another aeq event
will be triggered. because the last aeq work is not exited and only
one work can be excuted simultaneously in the same workqueue, mailbox
sending function will return failure of timeout. We create and use
another workqueue to fix this.

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 91 +++++++++++++++----
 .../net/ethernet/huawei/hinic/hinic_hw_mgmt.h | 16 ++++
 2 files changed, 88 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
index c33eb1147055..e0f5a81d8620 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c
@@ -370,48 +370,89 @@ int hinic_msg_to_mgmt(struct hinic_pf_to_mgmt *pf_to_mgmt,
 				MSG_NOT_RESP, timeout);
 }
 
-/**
- * mgmt_recv_msg_handler - handler for message from mgmt cpu
- * @pf_to_mgmt: PF to MGMT channel
- * @recv_msg: received message details
- **/
-static void mgmt_recv_msg_handler(struct hinic_pf_to_mgmt *pf_to_mgmt,
-				  struct hinic_recv_msg *recv_msg)
+static void recv_mgmt_msg_work_handler(struct work_struct *work)
 {
-	struct hinic_hwif *hwif = pf_to_mgmt->hwif;
-	struct pci_dev *pdev = hwif->pdev;
-	u8 *buf_out = recv_msg->buf_out;
+	struct hinic_mgmt_msg_handle_work *mgmt_work =
+		container_of(work, struct hinic_mgmt_msg_handle_work, work);
+	struct hinic_pf_to_mgmt *pf_to_mgmt = mgmt_work->pf_to_mgmt;
+	struct pci_dev *pdev = pf_to_mgmt->hwif->pdev;
+	u8 *buf_out = pf_to_mgmt->mgmt_ack_buf;
 	struct hinic_mgmt_cb *mgmt_cb;
 	unsigned long cb_state;
 	u16 out_size = 0;
 
-	if (recv_msg->mod >= HINIC_MOD_MAX) {
+	memset(buf_out, 0, MAX_PF_MGMT_BUF_SIZE);
+
+	if (mgmt_work->mod >= HINIC_MOD_MAX) {
 		dev_err(&pdev->dev, "Unknown MGMT MSG module = %d\n",
-			recv_msg->mod);
+			mgmt_work->mod);
+		kfree(mgmt_work->msg);
+		kfree(mgmt_work);
 		return;
 	}
 
-	mgmt_cb = &pf_to_mgmt->mgmt_cb[recv_msg->mod];
+	mgmt_cb = &pf_to_mgmt->mgmt_cb[mgmt_work->mod];
 
 	cb_state = cmpxchg(&mgmt_cb->state,
 			   HINIC_MGMT_CB_ENABLED,
 			   HINIC_MGMT_CB_ENABLED | HINIC_MGMT_CB_RUNNING);
 
 	if ((cb_state == HINIC_MGMT_CB_ENABLED) && (mgmt_cb->cb))
-		mgmt_cb->cb(mgmt_cb->handle, recv_msg->cmd,
-			    recv_msg->msg, recv_msg->msg_len,
+		mgmt_cb->cb(mgmt_cb->handle, mgmt_work->cmd,
+			    mgmt_work->msg, mgmt_work->msg_len,
 			    buf_out, &out_size);
 	else
 		dev_err(&pdev->dev, "No MGMT msg handler, mod: %d, cmd: %d\n",
-			recv_msg->mod, recv_msg->cmd);
+			mgmt_work->mod, mgmt_work->cmd);
 
 	mgmt_cb->state &= ~HINIC_MGMT_CB_RUNNING;
 
-	if (!recv_msg->async_mgmt_to_pf)
+	if (!mgmt_work->async_mgmt_to_pf)
 		/* MGMT sent sync msg, send the response */
-		msg_to_mgmt_async(pf_to_mgmt, recv_msg->mod, recv_msg->cmd,
+		msg_to_mgmt_async(pf_to_mgmt, mgmt_work->mod, mgmt_work->cmd,
 				  buf_out, out_size, MGMT_RESP,
-				  recv_msg->msg_id);
+				  mgmt_work->msg_id);
+
+	kfree(mgmt_work->msg);
+	kfree(mgmt_work);
+}
+
+/**
+ * mgmt_recv_msg_handler - handler for message from mgmt cpu
+ * @pf_to_mgmt: PF to MGMT channel
+ * @recv_msg: received message details
+ **/
+static void mgmt_recv_msg_handler(struct hinic_pf_to_mgmt *pf_to_mgmt,
+				  struct hinic_recv_msg *recv_msg)
+{
+	struct hinic_mgmt_msg_handle_work *mgmt_work = NULL;
+	struct pci_dev *pdev = pf_to_mgmt->hwif->pdev;
+
+	mgmt_work = kzalloc(sizeof(*mgmt_work), GFP_KERNEL);
+	if (!mgmt_work) {
+		dev_err(&pdev->dev, "Allocate mgmt work memory failed\n");
+		return;
+	}
+
+	if (recv_msg->msg_len) {
+		mgmt_work->msg = kzalloc(recv_msg->msg_len, GFP_KERNEL);
+		if (!mgmt_work->msg) {
+			dev_err(&pdev->dev, "Allocate mgmt msg memory failed\n");
+			kfree(mgmt_work);
+			return;
+		}
+	}
+
+	mgmt_work->pf_to_mgmt = pf_to_mgmt;
+	mgmt_work->msg_len = recv_msg->msg_len;
+	memcpy(mgmt_work->msg, recv_msg->msg, recv_msg->msg_len);
+	mgmt_work->msg_id = recv_msg->msg_id;
+	mgmt_work->mod = recv_msg->mod;
+	mgmt_work->cmd = recv_msg->cmd;
+	mgmt_work->async_mgmt_to_pf = recv_msg->async_mgmt_to_pf;
+
+	INIT_WORK(&mgmt_work->work, recv_mgmt_msg_work_handler);
+	queue_work(pf_to_mgmt->workq, &mgmt_work->work);
 }
 
 /**
@@ -546,6 +587,12 @@ static int alloc_msg_buf(struct hinic_pf_to_mgmt *pf_to_mgmt)
 	if (!pf_to_mgmt->sync_msg_buf)
 		return -ENOMEM;
 
+	pf_to_mgmt->mgmt_ack_buf = devm_kzalloc(&pdev->dev,
+						MAX_PF_MGMT_BUF_SIZE,
+						GFP_KERNEL);
+	if (!pf_to_mgmt->mgmt_ack_buf)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -571,6 +618,11 @@ int hinic_pf_to_mgmt_init(struct hinic_pf_to_mgmt *pf_to_mgmt,
 		return 0;
 
 	sema_init(&pf_to_mgmt->sync_msg_lock, 1);
+	pf_to_mgmt->workq = create_singlethread_workqueue("hinic_mgmt");
+	if (!pf_to_mgmt->workq) {
+		dev_err(&pdev->dev, "Failed to initialize MGMT workqueue\n");
+		return -ENOMEM;
+	}
 	pf_to_mgmt->sync_msg_id = 0;
 
 	err = alloc_msg_buf(pf_to_mgmt);
@@ -605,4 +657,5 @@ void hinic_pf_to_mgmt_free(struct hinic_pf_to_mgmt *pf_to_mgmt)
 
 	hinic_aeq_unregister_hw_cb(&hwdev->aeqs, HINIC_MSG_FROM_MGMT_CPU);
 	hinic_api_cmd_free(pf_to_mgmt->cmd_chain);
+	destroy_workqueue(pf_to_mgmt->workq);
 }
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
index c2b142c08b0e..a824fbda59db 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.h
@@ -119,6 +119,7 @@ struct hinic_pf_to_mgmt {
 	struct semaphore                sync_msg_lock;
 	u16                             sync_msg_id;
 	u8                              *sync_msg_buf;
+	void				*mgmt_ack_buf;
 
 	struct hinic_recv_msg           recv_resp_msg_from_mgmt;
 	struct hinic_recv_msg           recv_msg_from_mgmt;
@@ -126,6 +127,21 @@ struct hinic_pf_to_mgmt {
 	struct hinic_api_cmd_chain      *cmd_chain[HINIC_API_CMD_MAX];
 
 	struct hinic_mgmt_cb            mgmt_cb[HINIC_MOD_MAX];
+
+	struct workqueue_struct		*workq;
+};
+
+struct hinic_mgmt_msg_handle_work {
+	struct work_struct work;
+	struct hinic_pf_to_mgmt *pf_to_mgmt;
+
+	void			*msg;
+	u16			msg_len;
+
+	enum hinic_mod_type	mod;
+	u8			cmd;
+	u16			msg_id;
+	int			async_mgmt_to_pf;
 };
 
 void hinic_register_mgmt_msg_cb(struct hinic_pf_to_mgmt *pf_to_mgmt,
-- 
2.17.1

