Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AB46BE427
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjCQIpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjCQIoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:44:38 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBFD1CF4B;
        Fri, 17 Mar 2023 01:43:20 -0700 (PDT)
X-UUID: 7fb09306c49b11ed91027fb02e0f1d65-20230317
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=agO2MFAf3Y8zU6zIJM4IUfnlOog4jrKmih9LFxBZdQ0=;
        b=ntvxAD58k1UvJw34VC72N08DBkZhRhVyVRIHdBzhPD42arBHAiTUR2lQMkaHsT5WvsAbO1MkytJ/hgkHRAwrQxc5DSXmGp1g1eS6/R7cu+P+lpREPEm2lDQg+NhJYOq0q6+lOTvZOLm0CQu9jJZWVdd8Y/3jVzqAcI8jf+p5J6c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.21,REQID:589272e6-c625-4b30-944f-b02096d1f2f6,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-25
X-CID-META: VersionHash:83295aa,CLOUDID:1ac31af6-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 7fb09306c49b11ed91027fb02e0f1d65-20230317
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 700838892; Fri, 17 Mar 2023 16:12:45 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 17 Mar 2023 16:12:44 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 17 Mar 2023 16:12:42 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev ML <netdev@vger.kernel.org>,
        kernel ML <linux-kernel@vger.kernel.org>
CC:     Intel experts <linuxwwan@intel.com>,
        Chetan <m.chetan.kumar@intel.com>,
        MTK ML <linux-mediatek@lists.infradead.org>,
        Liang Lu <liang.lu@mediatek.com>,
        Haijun Liu <haijun.liu@mediatek.com>,
        Hua Yang <hua.yang@mediatek.com>,
        Ting Wang <ting.wang@mediatek.com>,
        Felix Chen <felix.chen@mediatek.com>,
        Mingliang Xu <mingliang.xu@mediatek.com>,
        Min Dong <min.dong@mediatek.com>,
        Aiden Wang <aiden.wang@mediatek.com>,
        Guohao Zhang <guohao.zhang@mediatek.com>,
        Chris Feng <chris.feng@mediatek.com>,
        "Yanchao Yang" <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v4 05/10] net: wwan: tmi: Add FSM thread
Date:   Fri, 17 Mar 2023 16:09:37 +0800
Message-ID: <20230317080942.183514-6-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230317080942.183514-1-yanchao.yang@mediatek.com>
References: <20230317080942.183514-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FSM (Finite-state Machine) thread is responsible for synchronizing the
actions of different modules. The asynchronous events from the device or the
OS will trigger a state transition.

The FSM thread will append it to the event queue when an event arrives. It
handles the events sequentially. After processing the event, the FSM thread
notifies other modules before and after the state transition.

Seven FSM states are defined. They can transition from one state to another,
self-transition in some states, and transition in some sub-states.

Signed-off-by: Yanchao Yang <yanchao.yang@mediatek.com>
Signed-off-by: Mingliang Xu <mingliang.xu@mediatek.com>
---
 drivers/net/wwan/mediatek/Makefile            |   3 +-
 drivers/net/wwan/mediatek/mtk_cldma.c         |  20 +
 drivers/net/wwan/mediatek/mtk_cldma.h         |   2 +
 drivers/net/wwan/mediatek/mtk_common.h        |  30 +
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c    | 264 +++++-
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h    |   9 +
 drivers/net/wwan/mediatek/mtk_dev.c           |  19 +-
 drivers/net/wwan/mediatek/mtk_dev.h           |   3 +
 drivers/net/wwan/mediatek/mtk_fsm.c           | 835 ++++++++++++++++++
 drivers/net/wwan/mediatek/mtk_fsm.h           | 145 +++
 drivers/net/wwan/mediatek/mtk_port.c          | 189 +++-
 drivers/net/wwan/mediatek/mtk_port.h          |   6 +
 drivers/net/wwan/mediatek/mtk_port_io.c       |   5 +-
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.h   |   2 +
 drivers/net/wwan/mediatek/pcie/mtk_pci.c      |   9 +
 drivers/net/wwan/mediatek/pcie/mtk_reg.h      |  11 +
 16 files changed, 1523 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_common.h
 create mode 100644 drivers/net/wwan/mediatek/mtk_fsm.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_fsm.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index e3afd8ecb494..c3f13c81b6b0 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -9,6 +9,7 @@ mtk_tmi-y = \
 	mtk_cldma.o \
 	pcie/mtk_cldma_drv_t800.o \
 	mtk_port.o \
-	mtk_port_io.o
+	mtk_port_io.o \
+	mtk_fsm.o
 
 obj-$(CONFIG_MTK_TMI) += mtk_tmi.o
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.c b/drivers/net/wwan/mediatek/mtk_cldma.c
index a1c5564e670f..6530b61b67db 100644
--- a/drivers/net/wwan/mediatek/mtk_cldma.c
+++ b/drivers/net/wwan/mediatek/mtk_cldma.c
@@ -252,9 +252,29 @@ static int mtk_cldma_trb_process(void *dev, struct sk_buff *skb)
 	return err;
 }
 
+static void mtk_cldma_fsm_state_listener(struct mtk_fsm_param *param, struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd = trans->dev[CLDMA_CLASS_ID];
+	int i;
+
+	switch (param->to) {
+	case FSM_STATE_BOOTUP:
+		for (i = 0; i < NR_CLDMA; i++)
+			cd->hw_ops.init(cd, i);
+		break;
+	case FSM_STATE_OFF:
+		for (i = 0; i < NR_CLDMA; i++)
+			cd->hw_ops.exit(cd, i);
+		break;
+	default:
+		break;
+	}
+}
+
 struct hif_ops cldma_ops = {
 	.init = mtk_cldma_init,
 	.exit = mtk_cldma_exit,
 	.trb_process = mtk_cldma_trb_process,
 	.submit_tx = mtk_cldma_submit_tx,
+	.fsm_state_listener = mtk_cldma_fsm_state_listener,
 };
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.h b/drivers/net/wwan/mediatek/mtk_cldma.h
index 4fd5f826bcf6..c9656aa31455 100644
--- a/drivers/net/wwan/mediatek/mtk_cldma.h
+++ b/drivers/net/wwan/mediatek/mtk_cldma.h
@@ -10,6 +10,7 @@
 
 #include "mtk_ctrl_plane.h"
 #include "mtk_dev.h"
+#include "mtk_fsm.h"
 
 #define HW_QUEUE_NUM				8
 #define ALLQ					(0XFF)
@@ -134,6 +135,7 @@ struct cldma_hw_ops {
 	int (*txq_free)(struct cldma_hw *hw, int vqno);
 	int (*rxq_free)(struct cldma_hw *hw, int vqno);
 	int (*start_xfer)(struct cldma_hw *hw, int qno);
+	void (*fsm_state_listener)(struct mtk_fsm_param *param, struct cldma_hw *hw);
 };
 
 struct cldma_hw {
diff --git a/drivers/net/wwan/mediatek/mtk_common.h b/drivers/net/wwan/mediatek/mtk_common.h
new file mode 100644
index 000000000000..516d3d9e02cf
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_common.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef _MTK_COMMON_H
+#define _MTK_COMMON_H
+
+#include <linux/device.h>
+
+#define MTK_UEVENT_INFO_LEN 128
+
+/* MTK uevent */
+enum mtk_uevent_id {
+	MTK_UEVENT_FSM = 1,
+	MTK_UEVENT_MAX
+};
+
+static inline void mtk_uevent_notify(struct device *dev, enum mtk_uevent_id id, const char *info)
+{
+	char buf[MTK_UEVENT_INFO_LEN];
+	char *ext[2] = {NULL, NULL};
+
+	snprintf(buf, MTK_UEVENT_INFO_LEN, "%s:event_id=%d, info=%s",
+		 dev->kobj.name, id, info);
+	ext[0] = buf;
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, ext);
+}
+
+#endif /* _MTK_COMMON_H */
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
index 8adb1f53ec64..f5ac493f0146 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
@@ -14,6 +14,11 @@
 #include "mtk_ctrl_plane.h"
 #include "mtk_port.h"
 
+static const struct virtq vq_tbl[] = {
+	{VQ(0), CLDMA0, TXQ(0), RXQ(0), VQ_MTU_3_5K, VQ_MTU_3_5K, TX_REQ_NUM, RX_REQ_NUM},
+	{VQ(1), CLDMA1, TXQ(0), RXQ(0), VQ_MTU_3_5K, VQ_MTU_3_5K, TX_REQ_NUM, RX_REQ_NUM},
+};
+
 static int mtk_ctrl_get_hif_id(unsigned char peer_id)
 {
 	if (peer_id == MTK_PEER_ID_SAP)
@@ -95,6 +100,160 @@ int mtk_ctrl_vq_color_cleanup(struct mtk_ctrl_blk *ctrl_blk, unsigned char peer_
 	return 0;
 }
 
+static bool mtk_ctrl_vqs_is_empty(struct trb_srv *srv)
+{
+	int i;
+
+	for (i = srv->vq_start; i < srv->vq_cnt; i++) {
+		if (!skb_queue_empty(&srv->trans->skb_list[i]))
+			return false;
+	}
+
+	return true;
+}
+
+static void mtk_ctrl_vq_flush(struct trb_srv *srv, int vqno)
+{
+	struct mtk_ctrl_trans *trans = srv->trans;
+	struct sk_buff *skb;
+	struct trb *trb;
+
+	while (!skb_queue_empty(&trans->skb_list[vqno])) {
+		skb = skb_dequeue(&trans->skb_list[vqno]);
+		trb = (struct trb *)skb->cb;
+		trb->status = -EIO;
+		trb->trb_complete(skb);
+	}
+}
+
+static void mtk_ctrl_vqs_flush(struct trb_srv *srv)
+{
+	int i;
+
+	for (i = srv->vq_start; i < srv->vq_cnt; i++)
+		mtk_ctrl_vq_flush(srv, i);
+}
+
+static void mtk_ctrl_trb_process(struct trb_srv *srv)
+{
+	struct mtk_ctrl_trans *trans = srv->trans;
+	struct sk_buff *skb, *skb_next;
+	struct trb *trb, *trb_next;
+	int tx_burst_cnt = 0;
+	struct virtq *vq;
+	int loop;
+	int idx;
+	int err;
+	int i;
+
+	for (i = srv->vq_start; i < srv->vq_cnt; i++) {
+		loop = 0;
+		do {
+			if (skb_queue_empty(&trans->skb_list[i]))
+				break;
+
+			skb = skb_peek(&trans->skb_list[i]);
+			trb = (struct trb *)skb->cb;
+			vq = trans->vq_tbl + trb->vqno;
+			idx = (vq->hif_id >> HIF_CLASS_SHIFT) & (HIF_CLASS_WIDTH - 1);
+			if (idx < 0 || idx >= HIF_CLASS_NUM)
+				break;
+
+			switch (trb->cmd) {
+			case TRB_CMD_ENABLE:
+			case TRB_CMD_DISABLE:
+				skb_unlink(skb, &trans->skb_list[i]);
+				err = mtk_port_mngr_vq_status_check(skb);
+				if (!err && trb->cmd == TRB_CMD_DISABLE)
+					mtk_ctrl_vq_flush(srv, i);
+				break;
+			case TRB_CMD_TX:
+				mtk_port_add_header(skb);
+				err = trans->ops[idx]->submit_tx(trans->dev[idx], skb);
+				if (err)
+					break;
+
+				tx_burst_cnt++;
+				if (tx_burst_cnt >= TX_BURST_MAX_CNT ||
+				    skb_queue_is_last(&trans->skb_list[i], skb)) {
+					tx_burst_cnt = 0;
+				} else {
+					skb_next = skb_peek_next(skb, &trans->skb_list[i]);
+					trb_next = (struct trb *)skb_next->cb;
+					if (trb_next->cmd != TRB_CMD_TX)
+						tx_burst_cnt = 0;
+				}
+
+				skb_unlink(skb, &trans->skb_list[i]);
+				err = tx_burst_cnt;
+				break;
+			default:
+				err = -EFAULT;
+			}
+
+			if (!err)
+				trans->ops[idx]->trb_process(trans->dev[idx], skb);
+
+			loop++;
+		} while (loop < TRB_NUM_PER_ROUND);
+	}
+}
+
+static int mtk_ctrl_trb_thread(void *args)
+{
+	struct trb_srv *srv = args;
+
+	while (!kthread_should_stop()) {
+		if (mtk_ctrl_vqs_is_empty(srv))
+			wait_event_freezable(srv->trb_waitq,
+					     !mtk_ctrl_vqs_is_empty(srv) ||
+					     kthread_should_stop() || kthread_should_park());
+
+		if (kthread_should_stop())
+			break;
+
+		if (kthread_should_park())
+			kthread_parkme();
+
+		do {
+			mtk_ctrl_trb_process(srv);
+			if (need_resched())
+				cond_resched();
+		} while (!mtk_ctrl_vqs_is_empty(srv) && !kthread_should_stop() &&
+			 !kthread_should_park());
+	}
+	mtk_ctrl_vqs_flush(srv);
+	return 0;
+}
+
+static int mtk_ctrl_trb_srv_init(struct mtk_ctrl_trans *trans)
+{
+	struct trb_srv *srv;
+
+	srv = devm_kzalloc(trans->mdev->dev, sizeof(*srv), GFP_KERNEL);
+	if (!srv)
+		return -ENOMEM;
+
+	srv->trans = trans;
+	srv->vq_start = 0;
+	srv->vq_cnt = VQ_NUM;
+
+	init_waitqueue_head(&srv->trb_waitq);
+	srv->trb_thread = kthread_run(mtk_ctrl_trb_thread, srv, "mtk_trb_srv_%s",
+				      trans->mdev->dev_str);
+	trans->trb_srv = srv;
+
+	return 0;
+}
+
+static void mtk_ctrl_trb_srv_exit(struct mtk_ctrl_trans *trans)
+{
+	struct trb_srv *srv = trans->trb_srv;
+
+	kthread_stop(srv->trb_thread);
+	devm_kfree(trans->mdev->dev, srv);
+}
+
 int mtk_ctrl_trb_submit(struct mtk_ctrl_blk *blk, struct sk_buff *skb)
 {
 	struct mtk_ctrl_trans *trans = blk->trans;
@@ -112,12 +271,105 @@ int mtk_ctrl_trb_submit(struct mtk_ctrl_blk *blk, struct sk_buff *skb)
 	if (VQ_LIST_FULL(trans, vqno) && trb->cmd != TRB_CMD_DISABLE)
 		return -EAGAIN;
 
-	/* This function will implement in next patch */
+	if (trb->cmd == TRB_CMD_DISABLE)
+		skb_queue_head(&trans->skb_list[vqno], skb);
+	else
+		skb_queue_tail(&trans->skb_list[vqno], skb);
+
 	wake_up(&trans->trb_srv->trb_waitq);
 
 	return 0;
 }
 
+static int mtk_ctrl_trans_init(struct mtk_ctrl_blk *ctrl_blk)
+{
+	struct mtk_ctrl_trans *trans;
+	int err;
+	int i;
+
+	trans = devm_kzalloc(ctrl_blk->mdev->dev, sizeof(*trans), GFP_KERNEL);
+	if (!trans)
+		return -ENOMEM;
+
+	trans->ctrl_blk = ctrl_blk;
+	trans->vq_tbl = (struct virtq *)vq_tbl;
+	trans->ops[CLDMA_CLASS_ID] = &cldma_ops;
+	trans->mdev = ctrl_blk->mdev;
+
+	for (i = 0; i < VQ_NUM; i++)
+		skb_queue_head_init(&trans->skb_list[i]);
+
+	for (i = 0; i < HIF_CLASS_NUM; i++) {
+		err = trans->ops[i]->init(trans);
+		if (err)
+			goto err_exit;
+	}
+
+	err = mtk_ctrl_trb_srv_init(trans);
+	if (err)
+		goto err_exit;
+
+	ctrl_blk->trans = trans;
+	atomic_set(&trans->available, 1);
+
+	return 0;
+
+err_exit:
+	for (i--; i >= 0; i--)
+		trans->ops[i]->exit(trans);
+
+	devm_kfree(ctrl_blk->mdev->dev, trans);
+	return err;
+}
+
+static int mtk_ctrl_trans_exit(struct mtk_ctrl_blk *ctrl_blk)
+{
+	struct mtk_ctrl_trans *trans = ctrl_blk->trans;
+	int i;
+
+	atomic_set(&trans->available, 0);
+	mtk_ctrl_trb_srv_exit(trans);
+
+	for (i = 0; i < HIF_CLASS_NUM; i++)
+		trans->ops[i]->exit(trans);
+
+	devm_kfree(ctrl_blk->mdev->dev, trans);
+	return 0;
+}
+
+static void mtk_ctrl_trans_fsm_state_handler(struct mtk_fsm_param *param,
+					     struct mtk_ctrl_blk *ctrl_blk)
+{
+	int i;
+
+	switch (param->to) {
+	case FSM_STATE_OFF:
+		for (i = 0; i < HIF_CLASS_NUM; i++)
+			ctrl_blk->trans->ops[i]->fsm_state_listener(param, ctrl_blk->trans);
+		mtk_ctrl_trans_exit(ctrl_blk);
+		break;
+	case FSM_STATE_ON:
+		mtk_ctrl_trans_init(ctrl_blk);
+		fallthrough;
+	default:
+		for (i = 0; i < HIF_CLASS_NUM; i++)
+			ctrl_blk->trans->ops[i]->fsm_state_listener(param, ctrl_blk->trans);
+	}
+}
+
+static void mtk_ctrl_fsm_state_listener(struct mtk_fsm_param *param, void *data)
+{
+	struct mtk_ctrl_blk *ctrl_blk = data;
+
+	if (param->to == FSM_STATE_BOOTUP) {
+		mtk_ctrl_trans_fsm_state_handler(param, ctrl_blk);
+		mtk_port_mngr_fsm_state_handler(param, ctrl_blk->port_mngr);
+	} else {
+		mtk_port_mngr_fsm_state_handler(param, ctrl_blk->port_mngr);
+		mtk_ctrl_trans_fsm_state_handler(param, ctrl_blk);
+	}
+}
+
 int mtk_ctrl_init(struct mtk_md_dev *mdev)
 {
 	struct mtk_ctrl_blk *ctrl_blk;
@@ -134,8 +386,17 @@ int mtk_ctrl_init(struct mtk_md_dev *mdev)
 	if (err)
 		goto err_free_mem;
 
+	err = mtk_fsm_notifier_register(mdev, MTK_USER_CTRL, mtk_ctrl_fsm_state_listener,
+					ctrl_blk, FSM_PRIO_1, false);
+	if (err) {
+		dev_err(mdev->dev, "Fail to register fsm notification(ret = %d)\n", err);
+		goto err_port_exit;
+	}
+
 	return 0;
 
+err_port_exit:
+	mtk_port_mngr_exit(ctrl_blk);
 err_free_mem:
 	devm_kfree(mdev->dev, ctrl_blk);
 
@@ -146,6 +407,7 @@ int mtk_ctrl_exit(struct mtk_md_dev *mdev)
 {
 	struct mtk_ctrl_blk *ctrl_blk = mdev->ctrl_blk;
 
+	mtk_fsm_notifier_unregister(mdev, MTK_USER_CTRL);
 	mtk_port_mngr_exit(ctrl_blk);
 	devm_kfree(mdev->dev, ctrl_blk);
 
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
index 2e1f21d43644..0885a434616e 100644
--- a/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
+++ b/drivers/net/wwan/mediatek/mtk_ctrl_plane.h
@@ -10,17 +10,25 @@
 #include <linux/skbuff.h>
 
 #include "mtk_dev.h"
+#include "mtk_fsm.h"
 
 #define VQ(N)				(N)
 #define VQ_NUM				(2)
+#define TX_REQ_NUM			(16)
+#define RX_REQ_NUM			(TX_REQ_NUM)
 
+#define VQ_MTU_2K			(0x800)
 #define VQ_MTU_3_5K			(0xE00)
+#define VQ_MTU_7K			(0x1C00)
 #define VQ_MTU_63K			(0xFC00)
 
+#define TRB_NUM_PER_ROUND		(16)
 #define SKB_LIST_MAX_LEN		(16)
+#define TX_BURST_MAX_CNT		(5)
 
 #define HIF_CLASS_NUM			(1)
 #define HIF_CLASS_SHIFT			(8)
+#define HIF_CLASS_WIDTH			(8)
 #define HIF_ID_BITMASK			(0x01)
 
 #define VQ_LIST_FULL(trans, vqno)	((trans)->skb_list[vqno].qlen >= SKB_LIST_MAX_LEN)
@@ -70,6 +78,7 @@ struct hif_ops {
 	int (*exit)(struct mtk_ctrl_trans *trans);
 	int (*submit_tx)(void *dev, struct sk_buff *skb);
 	int (*trb_process)(void *dev, struct sk_buff *skb);
+	void (*fsm_state_listener)(struct mtk_fsm_param *param, struct mtk_ctrl_trans *trans);
 };
 
 struct mtk_ctrl_trans {
diff --git a/drivers/net/wwan/mediatek/mtk_dev.c b/drivers/net/wwan/mediatek/mtk_dev.c
index d34c3933e84d..db41acc5e733 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -5,21 +5,38 @@
 
 #include "mtk_ctrl_plane.h"
 #include "mtk_dev.h"
+#include "mtk_fsm.h"
 
 int mtk_dev_init(struct mtk_md_dev *mdev)
 {
 	int ret;
 
-	ret = mtk_ctrl_init(mdev);
+	ret = mtk_fsm_init(mdev);
 	if (ret)
 		goto exit;
 
+	ret = mtk_ctrl_init(mdev);
+	if (ret)
+		goto free_fsm;
+
 	return 0;
+free_fsm:
+	mtk_fsm_exit(mdev);
 exit:
 	return ret;
 }
 
 void mtk_dev_exit(struct mtk_md_dev *mdev)
 {
+	mtk_fsm_evt_submit(mdev, FSM_EVT_DEV_RM, 0, NULL, 0,
+			   EVT_MODE_BLOCKING | EVT_MODE_TOHEAD);
 	mtk_ctrl_exit(mdev);
+	mtk_fsm_exit(mdev);
+}
+
+int mtk_dev_start(struct mtk_md_dev *mdev)
+{
+	mtk_fsm_evt_submit(mdev, FSM_EVT_DEV_ADD, 0, NULL, 0, 0);
+	mtk_fsm_start(mdev);
+	return 0;
 }
diff --git a/drivers/net/wwan/mediatek/mtk_dev.h b/drivers/net/wwan/mediatek/mtk_dev.h
index d48fc55ddef0..23cedb93e51a 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -101,11 +101,14 @@ struct mtk_md_dev {
 	u32 hw_ver;
 	int msi_nvecs;
 	char dev_str[MTK_DEV_STR_LEN];
+
+	struct mtk_md_fsm *fsm;
 	void *ctrl_blk;
 };
 
 int mtk_dev_init(struct mtk_md_dev *mdev);
 void mtk_dev_exit(struct mtk_md_dev *mdev);
+int mtk_dev_start(struct mtk_md_dev *mdev);
 static inline u32 mtk_hw_read32(struct mtk_md_dev *mdev, u64 addr)
 {
 	return mdev->hw_ops->read32(mdev, addr);
diff --git a/drivers/net/wwan/mediatek/mtk_fsm.c b/drivers/net/wwan/mediatek/mtk_fsm.c
new file mode 100644
index 000000000000..be63f8adcb15
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_fsm.c
@@ -0,0 +1,835 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/sched/signal.h>
+#include <linux/skbuff.h>
+#include <linux/wait.h>
+
+#include "mtk_common.h"
+#include "mtk_fsm.h"
+#include "mtk_port.h"
+#include "mtk_port_io.h"
+#include "pcie/mtk_reg.h"
+
+#define EVT_TF_GATECLOSED (1)
+
+#define FSM_HS_START_MASK	(FSM_F_SAP_HS_START | FSM_F_MD_HS_START)
+#define FSM_HS2_DONE_MASK	(FSM_F_SAP_HS2_DONE | FSM_F_MD_HS2_DONE)
+
+#define RTFT_DATA_SIZE		(3 * 1024)
+
+#define REGION_BITMASK		0xF
+#define DEVICE_CFG_SHIFT	24
+#define DEVICE_CFG_REGION_MASK	0x3
+
+enum device_stage {
+	DEV_STAGE_LINUX = 4,
+	DEV_STAGE_MAX
+};
+
+enum device_cfg {
+	DEV_CFG_NORMAL = 0,
+	DEV_CFG_MD_ONLY,
+};
+
+enum runtime_feature_support_type {
+	RTFT_TYPE_NOT_EXIST = 0,
+	RTFT_TYPE_NOT_SUPPORT = 1,
+	RTFT_TYPE_MUST_SUPPORT = 2,
+	RTFT_TYPE_OPTIONAL_SUPPORT = 3,
+	RTFT_TYPE_SUPPORT_BACKWARD_COMPAT = 4,
+};
+
+enum runtime_feature_id {
+	RTFT_ID_MD_PORT_ENUM = 0,
+	RTFT_ID_SAP_PORT_ENUM = 1,
+	RTFT_ID_MD_PORT_CFG = 2,
+	RTFT_ID_MAX
+};
+
+enum ctrl_msg_id {
+	CTRL_MSG_HS1 = 0,
+	CTRL_MSG_HS2 = 1,
+	CTRL_MSG_HS3 = 2,
+};
+
+struct ctrl_msg_header {
+	__le32 id;
+	__le32 ex_msg;
+	__le32 data_len;
+	u8 reserved[];
+} __packed;
+
+struct runtime_feature_entry {
+	u8 feature_id;
+	struct runtime_feature_info support_info;
+	u8 reserved[2];
+	__le32 data_len;
+	u8 data[];
+};
+
+struct feature_query {
+	__le32 head_pattern;
+	struct runtime_feature_info ft_set[FEATURE_CNT];
+	__le32 tail_pattern;
+};
+
+static int mtk_fsm_send_hs1_msg(struct fsm_hs_info *hs_info)
+{
+	struct mtk_md_fsm *fsm = container_of(hs_info, struct mtk_md_fsm, hs_info[hs_info->id]);
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct feature_query *ft_query;
+	struct sk_buff *skb;
+	int ret, msg_size;
+
+	msg_size = sizeof(*ctrl_msg_h) + sizeof(*ft_query);
+	skb = __dev_alloc_skb(msg_size, GFP_KERNEL);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto hs_err;
+	}
+
+	skb_put(skb, msg_size);
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	ctrl_msg_h->id = cpu_to_le32(CTRL_MSG_HS1);
+	ctrl_msg_h->ex_msg = 0;
+	ctrl_msg_h->data_len = cpu_to_le32(sizeof(*ft_query));
+
+	ft_query = (struct feature_query *)(skb->data + sizeof(*ctrl_msg_h));
+	ft_query->head_pattern = cpu_to_le32(FEATURE_QUERY_PATTERN);
+	memcpy(ft_query->ft_set, hs_info->query_ft_set, sizeof(hs_info->query_ft_set));
+	ft_query->tail_pattern = cpu_to_le32(FEATURE_QUERY_PATTERN);
+
+	ret = mtk_port_internal_write(hs_info->ctrl_port, skb);
+	if (ret > 0)
+		return 0;
+hs_err:
+	dev_err(fsm->mdev->dev, "Failed to send handshake1 message,ret=%d\n", ret);
+	return ret;
+}
+
+static int mtk_fsm_feature_set_match(enum runtime_feature_support_type *cur_ft_spt,
+				     struct runtime_feature_info rtft_info_st,
+				     struct runtime_feature_info rtft_info_cfg)
+{
+	int ret = 0;
+
+	switch (FIELD_GET(FEATURE_TYPE, rtft_info_cfg.feature)) {
+	case RTFT_TYPE_NOT_EXIST:
+		*cur_ft_spt = RTFT_TYPE_NOT_SUPPORT;
+		break;
+	case RTFT_TYPE_MUST_SUPPORT:
+		if (FIELD_GET(FEATURE_TYPE, rtft_info_st.feature) != RTFT_TYPE_MUST_SUPPORT)
+			ret = -EPROTO;
+		else
+			*cur_ft_spt = RTFT_TYPE_MUST_SUPPORT;
+		break;
+	case RTFT_TYPE_OPTIONAL_SUPPORT:
+		*cur_ft_spt = FIELD_PREP(FEATURE_TYPE, rtft_info_st.feature);
+		break;
+	default:
+		ret = -EPROTO;
+	}
+
+	return ret;
+}
+
+static int (*rtft_action[FEATURE_CNT])(struct mtk_md_dev *mdev, void *rt_data) = {
+	[RTFT_ID_MD_PORT_ENUM] = mtk_port_status_update,
+	[RTFT_ID_SAP_PORT_ENUM] = mtk_port_status_update,
+};
+
+static int mtk_fsm_parse_hs2_msg(struct fsm_hs_info *hs_info)
+{
+	struct mtk_md_fsm *fsm = container_of(hs_info, struct mtk_md_fsm, hs_info[hs_info->id]);
+	char *rt_data = ((struct sk_buff *)hs_info->rt_data)->data;
+	enum runtime_feature_support_type cur_ft_spt;
+	struct runtime_feature_entry *rtft_entry;
+	int ft_id, ret = 0, offset;
+
+	offset = sizeof(struct feature_query);
+	for (ft_id = 0; ft_id < FEATURE_CNT && offset < hs_info->rt_data_len; ft_id++) {
+		rtft_entry = (struct runtime_feature_entry *)(rt_data + offset);
+		ret = mtk_fsm_feature_set_match(&cur_ft_spt,
+						rtft_entry->support_info,
+						hs_info->query_ft_set[ft_id]);
+		if (ret < 0)
+			break;
+
+		if (cur_ft_spt == RTFT_TYPE_MUST_SUPPORT)
+			if (rtft_action[ft_id])
+				ret = rtft_action[ft_id](fsm->mdev, rtft_entry->data);
+		if (ret < 0)
+			break;
+
+		offset += sizeof(rtft_entry) + le32_to_cpu(rtft_entry->data_len);
+	}
+
+	if (ft_id != FEATURE_CNT) {
+		dev_err(fsm->mdev->dev, "Unable to handle mistake hs2 message,fd_id=%d\n", ft_id);
+		ret = -EPROTO;
+	}
+
+	return ret;
+}
+
+static int mtk_fsm_append_rtft_entries(struct mtk_md_dev *mdev, void *feature_data,
+				       unsigned int *len, struct fsm_hs_info *hs_info)
+{
+	char *rt_data = ((struct sk_buff *)hs_info->rt_data)->data;
+	struct runtime_feature_entry *rtft_entry;
+	int ft_id, ret = 0, rtdata_len = 0;
+	struct feature_query *ft_query;
+
+	ft_query = (struct feature_query *)rt_data;
+	if (le32_to_cpu(ft_query->head_pattern) != FEATURE_QUERY_PATTERN ||
+	    le32_to_cpu(ft_query->tail_pattern) != FEATURE_QUERY_PATTERN) {
+		dev_err(mdev->dev,
+			"Failed to match ft_query pattern: head=0x%x,tail=0x%x\n",
+			le32_to_cpu(ft_query->head_pattern), le32_to_cpu(ft_query->tail_pattern));
+		ret = -EPROTO;
+		goto hs_err;
+	}
+
+	rtft_entry = feature_data;
+	for (ft_id = 0; ft_id < FEATURE_CNT && rtdata_len < RTFT_DATA_SIZE; ft_id++) {
+		rtft_entry->feature_id = ft_id;
+		rtft_entry->data_len = 0;
+
+		switch (FIELD_GET(FEATURE_TYPE, ft_query->ft_set[ft_id].feature)) {
+		case RTFT_TYPE_NOT_EXIST:
+			fallthrough;
+		case RTFT_TYPE_NOT_SUPPORT:
+			fallthrough;
+		case RTFT_TYPE_MUST_SUPPORT:
+			rtft_entry->support_info = ft_query->ft_set[ft_id];
+			break;
+		case RTFT_TYPE_OPTIONAL_SUPPORT:
+			fallthrough;
+		case RTFT_TYPE_SUPPORT_BACKWARD_COMPAT:
+			rtft_entry->support_info.feature = FEATURE_TYPE_NOT;
+			rtft_entry->support_info.feature |= FEATURE_VER_0;
+			break;
+		}
+
+		rtdata_len += sizeof(*rtft_entry) + le32_to_cpu(rtft_entry->data_len);
+		rtft_entry = (struct runtime_feature_entry *)(feature_data + rtdata_len);
+	}
+	*len = rtdata_len;
+	return 0;
+hs_err:
+	*len = 0;
+	return ret;
+}
+
+static int mtk_fsm_send_hs3_msg(struct fsm_hs_info *hs_info)
+{
+	struct mtk_md_fsm *fsm = container_of(hs_info, struct mtk_md_fsm, hs_info[hs_info->id]);
+	unsigned int data_len, msg_size = 0;
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = __dev_alloc_skb(RTFT_DATA_SIZE, GFP_KERNEL);
+	if (!skb) {
+		ret = -ENOMEM;
+		goto hs_err;
+	}
+
+	msg_size += sizeof(*ctrl_msg_h);
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	ctrl_msg_h->id = cpu_to_le32(CTRL_MSG_HS3);
+	ctrl_msg_h->ex_msg = 0;
+	ret = mtk_fsm_append_rtft_entries(fsm->mdev,
+					  skb->data + sizeof(*ctrl_msg_h),
+					  &data_len, hs_info);
+	if (ret)
+		goto hs_err;
+
+	ctrl_msg_h->data_len = cpu_to_le32(data_len);
+	msg_size += data_len;
+	skb_put(skb, msg_size);
+
+	ret = mtk_port_internal_write(hs_info->ctrl_port, skb);
+	if (ret > 0)
+		return 0;
+hs_err:
+	dev_err(fsm->mdev->dev, "Failed to send handshake3 message:ret=%d\n", ret);
+	return ret;
+}
+
+static int mtk_fsm_sap_ctrl_msg_handler(void *__fsm, struct sk_buff *skb)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct mtk_md_fsm *fsm = __fsm;
+	struct fsm_hs_info *hs_info;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	skb_pull(skb, sizeof(*ctrl_msg_h));
+
+	hs_info = &fsm->hs_info[HS_ID_SAP];
+	if (le32_to_cpu(ctrl_msg_h->id) != CTRL_MSG_HS2)
+		return -EPROTO;
+
+	hs_info->rt_data = skb;
+	hs_info->rt_data_len = skb->len;
+	mtk_fsm_evt_submit(fsm->mdev, FSM_EVT_STARTUP,
+			   hs_info->fsm_flag_hs2, hs_info, sizeof(*hs_info), 0);
+
+	return 0;
+}
+
+static int mtk_fsm_md_ctrl_msg_handler(void *__fsm, struct sk_buff *skb)
+{
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct mtk_md_fsm *fsm = __fsm;
+	struct fsm_hs_info *hs_info;
+	bool need_free_data = true;
+	int ret = 0;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	hs_info = &fsm->hs_info[HS_ID_MD];
+	switch (le32_to_cpu(ctrl_msg_h->id)) {
+	case CTRL_MSG_HS2:
+		need_free_data = false;
+		skb_pull(skb, sizeof(*ctrl_msg_h));
+		hs_info->rt_data = skb;
+		hs_info->rt_data_len = skb->len;
+		mtk_fsm_evt_submit(fsm->mdev, FSM_EVT_STARTUP,
+				   hs_info->fsm_flag_hs2, hs_info, sizeof(*hs_info), 0);
+		break;
+	default:
+		dev_err(fsm->mdev->dev, "Invalid control message id\n");
+	}
+
+	if (need_free_data)
+		dev_kfree_skb(skb);
+
+	return ret;
+}
+
+static int (*ctrl_msg_handler[HS_ID_MAX])(void *__fsm, struct sk_buff *skb) = {
+	[HS_ID_MD] = mtk_fsm_md_ctrl_msg_handler,
+	[HS_ID_SAP] = mtk_fsm_sap_ctrl_msg_handler,
+};
+
+static void mtk_fsm_linux_evt_handler(struct mtk_md_dev *mdev,
+				      u32 dev_state, struct mtk_md_fsm *fsm)
+{
+	u32 dev_cfg = dev_state >> DEVICE_CFG_SHIFT & DEVICE_CFG_REGION_MASK;
+	int hs_id;
+
+	if (dev_cfg == DEV_CFG_MD_ONLY)
+		fsm->hs_done_flag = FSM_F_MD_HS_START | FSM_F_MD_HS2_DONE;
+	else
+		fsm->hs_done_flag = FSM_HS_START_MASK | FSM_HS2_DONE_MASK;
+
+	for (hs_id = 0; hs_id < HS_ID_MAX; hs_id++)
+		mtk_hw_unmask_ext_evt(mdev, fsm->hs_info[hs_id].mhccif_ch);
+}
+
+static int mtk_fsm_early_bootup_handler(u32 status, void *__fsm)
+{
+	struct mtk_md_fsm *fsm = __fsm;
+	struct mtk_md_dev *mdev;
+	u32 dev_state, dev_stage;
+
+	mdev = fsm->mdev;
+	mtk_hw_mask_ext_evt(mdev, status);
+	mtk_hw_clear_ext_evt(mdev, status);
+
+	dev_state = mtk_hw_get_dev_state(mdev);
+	dev_stage = dev_state & REGION_BITMASK;
+	if (dev_stage >= DEV_STAGE_MAX) {
+		dev_err(mdev->dev, "Invalid dev state 0x%x\n", dev_state);
+		return -ENXIO;
+	}
+
+	if (dev_state == fsm->last_dev_state)
+		goto exit;
+	dev_info(mdev->dev, "Device stage change 0x%x->0x%x\n", fsm->last_dev_state, dev_state);
+	fsm->last_dev_state = dev_state;
+
+	if (dev_stage == DEV_STAGE_LINUX)
+		mtk_fsm_linux_evt_handler(mdev, dev_state, fsm);
+
+exit:
+	if (dev_stage != DEV_STAGE_LINUX)
+		mtk_hw_unmask_ext_evt(mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC);
+
+	return 0;
+}
+
+static int mtk_fsm_ctrl_ch_start(struct mtk_md_fsm *fsm, struct fsm_hs_info *hs_info)
+{
+	hs_info->ctrl_port = mtk_port_internal_open(fsm->mdev, hs_info->port_name, 0);
+	if (!hs_info->ctrl_port) {
+		dev_err(fsm->mdev->dev, "Failed to open ctrl port(%s)\n",
+			hs_info->port_name);
+		return -ENODEV;
+	}
+	mtk_port_internal_recv_register(hs_info->ctrl_port,
+					ctrl_msg_handler[hs_info->id], fsm);
+
+	return 0;
+}
+
+static void mtk_fsm_ctrl_ch_stop(struct mtk_md_fsm *fsm)
+{
+	struct fsm_hs_info *hs_info;
+	int hs_id;
+
+	for (hs_id = 0; hs_id < HS_ID_MAX; hs_id++) {
+		hs_info = &fsm->hs_info[hs_id];
+		mtk_port_internal_close(hs_info->ctrl_port);
+	}
+}
+
+static void mtk_fsm_switch_state(struct mtk_md_fsm *fsm,
+				 enum mtk_fsm_state to_state, struct mtk_fsm_evt *event)
+{
+	char uevent_info[MTK_UEVENT_INFO_LEN];
+	struct mtk_fsm_notifier *nt;
+	struct mtk_fsm_param param;
+
+	param.from = fsm->state;
+	param.to = to_state;
+	param.evt_id = event->id;
+	param.fsm_flag = event->fsm_flag;
+
+	list_for_each_entry(nt, &fsm->pre_notifiers, entry)
+		nt->cb(&param, nt->data);
+
+	fsm->state = to_state;
+	fsm->fsm_flag |= event->fsm_flag;
+	dev_info(fsm->mdev->dev, "FSM transited to state=%d, fsm_flag=0x%x\n",
+		 to_state, fsm->fsm_flag);
+
+	snprintf(uevent_info, MTK_UEVENT_INFO_LEN,
+		 "state=%d, fsm_flag=0x%x", to_state, fsm->fsm_flag);
+	mtk_uevent_notify(fsm->mdev->dev, MTK_UEVENT_FSM, uevent_info);
+
+	list_for_each_entry(nt, &fsm->post_notifiers, entry)
+		nt->cb(&param, nt->data);
+}
+
+static int mtk_fsm_startup_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	enum mtk_fsm_state to_state = FSM_STATE_BOOTUP;
+	struct fsm_hs_info *hs_info = event->data;
+	struct mtk_md_dev *mdev = fsm->mdev;
+	int ret = 0;
+
+	if (fsm->state != FSM_STATE_ON && fsm->state != FSM_STATE_BOOTUP) {
+		ret = -EPROTO;
+		goto hs_err;
+	}
+
+	if (event->fsm_flag & FSM_HS_START_MASK) {
+		mtk_fsm_switch_state(fsm, to_state, event);
+
+		ret = mtk_fsm_ctrl_ch_start(fsm, hs_info);
+		if (!ret)
+			ret = mtk_fsm_send_hs1_msg(hs_info);
+		if (ret)
+			goto hs_err;
+	} else if (event->fsm_flag & FSM_HS2_DONE_MASK) {
+		ret = mtk_fsm_parse_hs2_msg(hs_info);
+		if (!ret) {
+			mtk_fsm_switch_state(fsm, to_state, event);
+			ret = mtk_fsm_send_hs3_msg(hs_info);
+		}
+		dev_kfree_skb(hs_info->rt_data);
+		if (ret)
+			goto hs_err;
+	}
+
+	if (((fsm->fsm_flag | event->fsm_flag) & fsm->hs_done_flag) == fsm->hs_done_flag) {
+		to_state = FSM_STATE_READY;
+		mtk_fsm_switch_state(fsm, to_state, event);
+	}
+
+	return 0;
+hs_err:
+	dev_err(mdev->dev, "Failed to handshake with device %d:0x%x", fsm->state, fsm->fsm_flag);
+	return ret;
+}
+
+static int mtk_fsm_dev_add_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+
+	if (fsm->state != FSM_STATE_OFF && fsm->state != FSM_STATE_INVALID) {
+		dev_err(mdev->dev, "Unable to handle the event in the state %d\n", fsm->state);
+		return -EPROTO;
+	}
+
+	mtk_fsm_switch_state(fsm, FSM_STATE_ON, event);
+	mtk_hw_unmask_ext_evt(mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC);
+
+	return 0;
+}
+
+static void mtk_fsm_evt_release(struct kref *kref)
+{
+	struct mtk_fsm_evt *event = container_of(kref, struct mtk_fsm_evt, kref);
+
+	devm_kfree(event->mdev->dev, event);
+}
+
+static void mtk_fsm_evt_put(struct mtk_fsm_evt *event)
+{
+	kref_put(&event->kref, mtk_fsm_evt_release);
+}
+
+static void mtk_fsm_evt_finish(struct mtk_md_fsm *fsm,
+			       struct mtk_fsm_evt *event, int retval)
+{
+	if (event->mode & EVT_MODE_BLOCKING) {
+		event->status = retval;
+		wake_up_interruptible(&fsm->evt_waitq);
+	}
+	mtk_fsm_evt_put(event);
+}
+
+static void mtk_fsm_evt_cleanup(struct mtk_md_fsm *fsm, struct list_head *evtq)
+{
+	struct mtk_fsm_evt *event, *tmp;
+
+	list_for_each_entry_safe(event, tmp, evtq, entry) {
+		mtk_fsm_evt_finish(fsm, event, FSM_EVT_RET_FAIL);
+		list_del(&event->entry);
+	}
+}
+
+static int mtk_fsm_enter_off_state(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+
+	if (fsm->state == FSM_STATE_OFF || fsm->state == FSM_STATE_INVALID) {
+		dev_err(mdev->dev, "Unable to handle the event in the state %d\n", fsm->state);
+		return -EPROTO;
+	}
+
+	mtk_hw_mask_ext_evt(mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC);
+	mtk_fsm_ctrl_ch_stop(fsm);
+	mtk_fsm_switch_state(fsm, FSM_STATE_OFF, event);
+
+	return 0;
+}
+
+static int mtk_fsm_dev_rm_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fsm->evtq_lock, flags);
+	set_bit(EVT_TF_GATECLOSED, &fsm->t_flag);
+	mtk_fsm_evt_cleanup(fsm, &fsm->evtq);
+	spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+
+	return mtk_fsm_enter_off_state(fsm, event);
+}
+
+static int mtk_fsm_hs1_handler(u32 status, void *__hs_info)
+{
+	struct fsm_hs_info *hs_info = __hs_info;
+	struct mtk_md_dev *mdev;
+	struct mtk_md_fsm *fsm;
+
+	fsm = container_of(hs_info, struct mtk_md_fsm, hs_info[hs_info->id]);
+	mdev = fsm->mdev;
+	mtk_fsm_evt_submit(mdev, FSM_EVT_STARTUP,
+			   hs_info->fsm_flag_hs1, hs_info, sizeof(*hs_info), 0);
+	mtk_hw_mask_ext_evt(mdev, hs_info->mhccif_ch);
+	mtk_hw_clear_ext_evt(mdev, hs_info->mhccif_ch);
+
+	return 0;
+}
+
+static void mtk_fsm_hs_info_init(struct mtk_md_fsm *fsm)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+	struct fsm_hs_info *hs_info;
+	int hs_id;
+
+	for (hs_id = 0; hs_id < HS_ID_MAX; hs_id++) {
+		hs_info = &fsm->hs_info[hs_id];
+		hs_info->id = hs_id;
+		switch (hs_id) {
+		case HS_ID_MD:
+			snprintf(hs_info->port_name, PORT_NAME_LEN, "MDCTRL");
+			hs_info->mhccif_ch = EXT_EVT_D2H_ASYNC_HS_NOTIFY_MD;
+			hs_info->fsm_flag_hs1 = FSM_F_MD_HS_START;
+			hs_info->fsm_flag_hs2 = FSM_F_MD_HS2_DONE;
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_ENUM].feature = FEATURE_TYPE_MUST;
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_ENUM].feature |= FEATURE_VER_0;
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_CFG].feature = FEATURE_TYPE_OPTIONAL;
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_CFG].feature |= FEATURE_VER_0;
+			break;
+		case HS_ID_SAP:
+			snprintf(hs_info->port_name, PORT_NAME_LEN, "SAPCTRL");
+			hs_info->mhccif_ch = EXT_EVT_D2H_ASYNC_HS_NOTIFY_SAP;
+			hs_info->fsm_flag_hs1 = FSM_F_SAP_HS_START;
+			hs_info->fsm_flag_hs2 = FSM_F_SAP_HS2_DONE;
+			hs_info->query_ft_set[RTFT_ID_SAP_PORT_ENUM].feature = FEATURE_TYPE_MUST;
+			hs_info->query_ft_set[RTFT_ID_SAP_PORT_ENUM].feature |= FEATURE_VER_0;
+			break;
+		}
+		mtk_hw_register_ext_evt(mdev, hs_info->mhccif_ch,
+					mtk_fsm_hs1_handler, hs_info);
+	}
+}
+
+static void mtk_fsm_hs_info_exit(struct mtk_md_fsm *fsm)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+	struct fsm_hs_info *hs_info;
+	int hs_id;
+
+	for (hs_id = 0; hs_id < HS_ID_MAX; hs_id++) {
+		hs_info = &fsm->hs_info[hs_id];
+		mtk_hw_unregister_ext_evt(mdev, hs_info->mhccif_ch);
+	}
+}
+
+static int (*evts_act_tbl[FSM_EVT_MAX])(struct mtk_md_fsm *__fsm, struct mtk_fsm_evt *event) = {
+	[FSM_EVT_STARTUP] = mtk_fsm_startup_act,
+	[FSM_EVT_DEV_RM] = mtk_fsm_dev_rm_act,
+	[FSM_EVT_DEV_ADD] = mtk_fsm_dev_add_act,
+};
+
+int mtk_fsm_start(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+
+	wake_up_process(fsm->fsm_handler);
+	return 0;
+}
+
+static void mkt_fsm_notifier_cleanup(struct mtk_md_dev *mdev, struct list_head *ntq)
+{
+	struct mtk_fsm_notifier *nt, *tmp;
+
+	list_for_each_entry_safe(nt, tmp, ntq, entry) {
+		list_del(&nt->entry);
+		devm_kfree(mdev->dev, nt);
+	}
+}
+
+static void mtk_fsm_notifier_insert(struct mtk_fsm_notifier *notifier, struct list_head *head)
+{
+	struct mtk_fsm_notifier *nt;
+
+	list_for_each_entry(nt, head, entry) {
+		if (notifier->prio > nt->prio) {
+			list_add(&notifier->entry, nt->entry.prev);
+			return;
+		}
+	}
+	list_add_tail(&notifier->entry, head);
+}
+
+int mtk_fsm_notifier_register(struct mtk_md_dev *mdev, enum mtk_user_id id,
+			      void (*cb)(struct mtk_fsm_param *, void *data),
+			      void *data, enum mtk_fsm_prio prio, bool is_pre)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	struct mtk_fsm_notifier *notifier;
+
+	if (!fsm)
+		return -EINVAL;
+
+	notifier = devm_kzalloc(mdev->dev, sizeof(*notifier), GFP_KERNEL);
+	if (!notifier)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&notifier->entry);
+	notifier->id = id;
+	notifier->cb = cb;
+	notifier->data = data;
+	notifier->prio = prio;
+
+	if (is_pre)
+		mtk_fsm_notifier_insert(notifier, &fsm->pre_notifiers);
+	else
+		mtk_fsm_notifier_insert(notifier, &fsm->post_notifiers);
+
+	return 0;
+}
+
+int mtk_fsm_notifier_unregister(struct mtk_md_dev *mdev, enum mtk_user_id id)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	struct mtk_fsm_notifier *nt, *tmp;
+
+	if (!fsm)
+		return -EINVAL;
+
+	list_for_each_entry_safe(nt, tmp, &fsm->pre_notifiers, entry) {
+		if (nt->id == id) {
+			list_del(&nt->entry);
+			devm_kfree(mdev->dev, nt);
+			break;
+		}
+	}
+	list_for_each_entry_safe(nt, tmp, &fsm->post_notifiers, entry) {
+		if (nt->id == id) {
+			list_del(&nt->entry);
+			devm_kfree(mdev->dev, nt);
+			break;
+		}
+	}
+	return 0;
+}
+
+int mtk_fsm_evt_submit(struct mtk_md_dev *mdev,
+		       enum mtk_fsm_evt_id id, enum mtk_fsm_flag flag,
+		       void *data, unsigned int len, unsigned char mode)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	struct mtk_fsm_evt *event;
+	unsigned long flags;
+	int ret = 0;
+
+	event = devm_kzalloc(mdev->dev, sizeof(*event),
+			     (in_irq() || in_softirq() || irqs_disabled()) ?
+			     GFP_ATOMIC : GFP_KERNEL);
+	if (!event)
+		return FSM_EVT_RET_FAIL;
+
+	kref_init(&event->kref);
+	event->mdev = mdev;
+	event->id = id;
+	event->fsm_flag = flag;
+	event->status = FSM_EVT_RET_ONGOING;
+	event->data = data;
+	event->len = len;
+	event->mode = mode;
+	dev_info(mdev->dev, "Event%d(with mode 0x%x) is appended\n",
+		 event->id, event->mode);
+
+	spin_lock_irqsave(&fsm->evtq_lock, flags);
+	if (test_bit(EVT_TF_GATECLOSED, &fsm->t_flag)) {
+		spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+		mtk_fsm_evt_put(event);
+		dev_err(mdev->dev, "Failed to add event, fsm dev has been removed!\n");
+		return FSM_EVT_RET_FAIL;
+	}
+
+	kref_get(&event->kref);
+	if (mode & EVT_MODE_TOHEAD)
+		list_add(&event->entry, &fsm->evtq);
+	else
+		list_add_tail(&event->entry, &fsm->evtq);
+	spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+
+	wake_up_process(fsm->fsm_handler);
+	if (mode & EVT_MODE_BLOCKING) {
+		wait_event_interruptible(fsm->evt_waitq, (event->status != 0));
+		ret = event->status;
+	}
+	mtk_fsm_evt_put(event);
+
+	return ret;
+}
+
+static int mtk_fsm_evt_handler(void *__fsm)
+{
+	struct mtk_md_fsm *fsm = __fsm;
+	struct mtk_fsm_evt *event;
+	unsigned long flags;
+
+wake_up:
+	while (!kthread_should_stop() && !list_empty(&fsm->evtq)) {
+		spin_lock_irqsave(&fsm->evtq_lock, flags);
+		event = list_first_entry(&fsm->evtq, struct mtk_fsm_evt, entry);
+		list_del(&event->entry);
+		spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+
+		dev_info(fsm->mdev->dev, "Event%d(0x%x) is under handling\n",
+			 event->id, event->fsm_flag);
+		if (event->id < FSM_EVT_MAX && evts_act_tbl[event->id](fsm, event) != 0)
+			mtk_fsm_evt_finish(fsm, event, FSM_EVT_RET_FAIL);
+		else
+			mtk_fsm_evt_finish(fsm, event, FSM_EVT_RET_DONE);
+	}
+
+	if (kthread_should_stop())
+		return 0;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule();
+
+	if (fatal_signal_pending(current)) {
+		mtk_fsm_evt_cleanup(fsm, &fsm->evtq);
+		return -ERESTARTSYS;
+	}
+	goto wake_up;
+}
+
+int mtk_fsm_init(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_fsm *fsm;
+	int ret;
+
+	fsm = devm_kzalloc(mdev->dev, sizeof(*fsm), GFP_KERNEL);
+	if (!fsm)
+		return -ENOMEM;
+
+	fsm->fsm_handler = kthread_create(mtk_fsm_evt_handler, fsm, "fsm_evt_thread%d_%s",
+					  mdev->hw_ver, mdev->dev_str);
+	if (IS_ERR(fsm->fsm_handler)) {
+		ret = PTR_ERR(fsm->fsm_handler);
+		goto exit;
+	}
+
+	fsm->mdev = mdev;
+	fsm->state = FSM_STATE_INVALID;
+	fsm->fsm_flag = FSM_F_DFLT;
+
+	INIT_LIST_HEAD(&fsm->evtq);
+	spin_lock_init(&fsm->evtq_lock);
+	init_waitqueue_head(&fsm->evt_waitq);
+
+	INIT_LIST_HEAD(&fsm->pre_notifiers);
+	INIT_LIST_HEAD(&fsm->post_notifiers);
+
+	mtk_fsm_hs_info_init(fsm);
+	mtk_hw_register_ext_evt(mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC,
+				mtk_fsm_early_bootup_handler, fsm);
+	mdev->fsm = fsm;
+	return 0;
+exit:
+	devm_kfree(mdev->dev, fsm);
+	return ret;
+}
+
+int mtk_fsm_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	unsigned long flags;
+
+	kthread_stop(fsm->fsm_handler);
+
+	spin_lock_irqsave(&fsm->evtq_lock, flags);
+	if (WARN_ON(!list_empty(&fsm->evtq)))
+		mtk_fsm_evt_cleanup(fsm, &fsm->evtq);
+	spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+
+	mkt_fsm_notifier_cleanup(mdev, &fsm->pre_notifiers);
+	mkt_fsm_notifier_cleanup(mdev, &fsm->post_notifiers);
+
+	mtk_hw_unregister_ext_evt(mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC);
+	mtk_fsm_hs_info_exit(fsm);
+
+	devm_kfree(mdev->dev, fsm);
+	return 0;
+}
diff --git a/drivers/net/wwan/mediatek/mtk_fsm.h b/drivers/net/wwan/mediatek/mtk_fsm.h
new file mode 100644
index 000000000000..35509a1738dd
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_fsm.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: BSD-3-Clause-Clear
+ *
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#ifndef __MTK_FSM_H__
+#define __MTK_FSM_H__
+
+#include "mtk_dev.h"
+
+#define FEATURE_CNT		(64)
+#define FEATURE_QUERY_PATTERN	(0x49434343)
+
+#define FEATURE_TYPE		GENMASK(3, 0)
+#define FEATURE_VER		GENMASK(7, 4)
+
+#define FEATURE_TYPE_NOT	FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_NOT_SUPPORT)
+#define FEATURE_TYPE_MUST	FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_MUST_SUPPORT)
+#define FEATURE_TYPE_OPTIONAL	FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_OPTIONAL_SUPPORT)
+#define FEATURE_VER_0		FIELD_PREP(FEATURE_VER, 0)
+
+#define EVT_MODE_BLOCKING	(0x01)
+#define EVT_MODE_TOHEAD		(0x02)
+
+#define FSM_EVT_RET_FAIL	(-1)
+#define FSM_EVT_RET_ONGOING	(0)
+#define FSM_EVT_RET_DONE	(1)
+
+enum mtk_fsm_flag {
+	FSM_F_DFLT = 0,
+	FSM_F_SAP_HS_START	= BIT(0),
+	FSM_F_SAP_HS2_DONE	= BIT(1),
+	FSM_F_MD_HS_START	= BIT(2),
+	FSM_F_MD_HS2_DONE	= BIT(3),
+};
+
+enum mtk_fsm_state {
+	FSM_STATE_INVALID = 0,
+	FSM_STATE_OFF,
+	FSM_STATE_ON,
+	FSM_STATE_BOOTUP,
+	FSM_STATE_READY,
+};
+
+enum mtk_fsm_evt_id {
+	FSM_EVT_STARTUP = 0,
+	FSM_EVT_DEV_RM,
+	FSM_EVT_DEV_ADD,
+	FSM_EVT_MAX
+};
+
+enum mtk_fsm_prio {
+	FSM_PRIO_0 = 0,
+	FSM_PRIO_1 = 1,
+	FSM_PRIO_MAX
+};
+
+struct mtk_fsm_param {
+	enum mtk_fsm_state from;
+	enum mtk_fsm_state to;
+	enum mtk_fsm_evt_id evt_id;
+	enum mtk_fsm_flag fsm_flag;
+};
+
+#define PORT_NAME_LEN 20
+
+enum handshake_info_id {
+	HS_ID_MD = 0,
+	HS_ID_SAP,
+	HS_ID_MAX
+};
+
+struct runtime_feature_info {
+	u8 feature;
+};
+
+struct fsm_hs_info {
+	unsigned char id;
+	void *ctrl_port;
+	char port_name[PORT_NAME_LEN];
+	unsigned int mhccif_ch;
+	unsigned int fsm_flag_hs1;
+	unsigned int fsm_flag_hs2;
+	/* the feature that the device should support */
+	struct runtime_feature_info query_ft_set[FEATURE_CNT];
+	/* runtime data from device need to be parsed by host */
+	void *rt_data;
+	unsigned int rt_data_len;
+};
+
+struct mtk_md_fsm {
+	struct mtk_md_dev *mdev;
+	struct task_struct *fsm_handler;
+	struct fsm_hs_info hs_info[HS_ID_MAX];
+	unsigned int hs_done_flag;
+	unsigned long t_flag;
+	u32 last_dev_state;
+	enum mtk_fsm_state state;
+	unsigned int fsm_flag;
+	struct list_head evtq;
+	/* protect evtq */
+	spinlock_t evtq_lock;
+	/* waitq for fsm blocking submit */
+	wait_queue_head_t evt_waitq;
+	struct list_head pre_notifiers;
+	struct list_head post_notifiers;
+};
+
+struct mtk_fsm_evt {
+	struct list_head entry;
+	struct kref kref;
+	struct mtk_md_dev *mdev;
+	enum mtk_fsm_evt_id id;
+	unsigned int fsm_flag;
+	/* event handling status
+	 * -1: fail,
+	 * 0: on-going,
+	 * 1: successfully
+	 */
+	int status;
+	unsigned char mode;
+	unsigned int len;
+	void *data;
+};
+
+struct mtk_fsm_notifier {
+	struct list_head entry;
+	enum mtk_user_id id;
+	void (*cb)(struct mtk_fsm_param *param, void *data);
+	void *data;
+	enum mtk_fsm_prio prio;
+};
+
+int mtk_fsm_init(struct mtk_md_dev *mdev);
+int mtk_fsm_exit(struct mtk_md_dev *mdev);
+int mtk_fsm_start(struct mtk_md_dev *mdev);
+int mtk_fsm_notifier_register(struct mtk_md_dev *mdev, enum mtk_user_id id,
+			      void (*cb)(struct mtk_fsm_param *, void *data),
+			      void *data, enum mtk_fsm_prio prio, bool is_pre);
+int mtk_fsm_notifier_unregister(struct mtk_md_dev *mdev, enum mtk_user_id id);
+int mtk_fsm_evt_submit(struct mtk_md_dev *mdev,
+		       enum mtk_fsm_evt_id id, enum mtk_fsm_flag flag,
+		       void *data, unsigned int len, unsigned char mode);
+
+#endif /* __MTK_FSM_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_port.c b/drivers/net/wwan/mediatek/mtk_port.c
index 12097a279aa0..208817225645 100644
--- a/drivers/net/wwan/mediatek/mtk_port.c
+++ b/drivers/net/wwan/mediatek/mtk_port.c
@@ -14,6 +14,9 @@
 #include "mtk_port.h"
 #include "mtk_port_io.h"
 
+#define MTK_PORT_ENUM_VER			(0)
+#define MTK_PORT_ENUM_HEAD_PATTERN		(0x5a5a5a5a)
+#define MTK_PORT_ENUM_TAIL_PATTERN		(0xa5a5a5a5)
 #define MTK_DFLT_TRB_TIMEOUT			(5 * HZ)
 #define MTK_DFLT_TRB_STATUS			(0x1)
 #define MTK_CHECK_RX_SEQ_MASK			(0x7fff)
@@ -423,8 +426,10 @@ static int mtk_port_open_trb_complete(struct sk_buff *skb)
 	port->tx_mtu = port_mngr->vq_info[trb->vqno].tx_mtu;
 	port->rx_mtu = port_mngr->vq_info[trb->vqno].rx_mtu;
 
-	port->tx_mtu -= MTK_CCCI_H_ELEN;
-	port->rx_mtu -= MTK_CCCI_H_ELEN;
+	if (!(port->info.flags & PORT_F_RAW_DATA)) {
+		port->tx_mtu -= MTK_CCCI_H_ELEN;
+		port->rx_mtu -= MTK_CCCI_H_ELEN;
+	}
 
 out:
 	wake_up_interruptible_all(&port->trb_wq);
@@ -588,30 +593,32 @@ static int mtk_port_rx_dispatch(struct sk_buff *skb, int len, void *priv)
 	skb_reset_tail_pointer(skb);
 	skb_put(skb, len);
 
-	ccci_h = mtk_port_strip_header(skb);
-	if (unlikely(!ccci_h)) {
-		dev_warn(port_mngr->ctrl_blk->mdev->dev,
-			 "Unsupported: skb length(%d) is less than ccci header\n",
-			 skb->len);
-		goto drop_data;
-	}
+	if (!(port->info.flags & PORT_F_RAW_DATA)) {
+		ccci_h = mtk_port_strip_header(skb);
+		if (unlikely(!ccci_h)) {
+			dev_warn(port_mngr->ctrl_blk->mdev->dev,
+				 "Unsupported: skb length(%d) is less than ccci header\n",
+				 skb->len);
+			goto drop_data;
+		}
 
-	dev_dbg(port_mngr->ctrl_blk->mdev->dev,
-		"RX header:%08x %08x\n", ccci_h->packet_len, ccci_h->status);
+		dev_dbg(port_mngr->ctrl_blk->mdev->dev,
+			"RX header:%08x %08x\n", ccci_h->packet_len, ccci_h->status);
 
-	channel = FIELD_GET(MTK_HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
-	port = mtk_port_search_by_id(port_mngr, channel);
-	if (unlikely(!port)) {
-		dev_warn(port_mngr->ctrl_blk->mdev->dev,
-			 "Failed to find port by channel:%d\n", channel);
-		goto drop_data;
-	}
+		channel = FIELD_GET(MTK_HDR_FLD_CHN, le32_to_cpu(ccci_h->status));
+		port = mtk_port_search_by_id(port_mngr, channel);
+		if (unlikely(!port)) {
+			dev_warn(port_mngr->ctrl_blk->mdev->dev,
+				 "Failed to find port by channel:%d\n", channel);
+			goto drop_data;
+		}
 
-	ret = mtk_port_check_rx_seq(port, ccci_h);
-	if (unlikely(ret))
-		goto drop_data;
+		ret = mtk_port_check_rx_seq(port, ccci_h);
+		if (unlikely(ret))
+			goto drop_data;
 
-	port->rx_seq = FIELD_GET(MTK_HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+		port->rx_seq = FIELD_GET(MTK_HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+	}
 
 	ret = ports_ops[port->info.type]->recv(port, skb);
 
@@ -623,6 +630,43 @@ static int mtk_port_rx_dispatch(struct sk_buff *skb, int len, void *priv)
 	return ret;
 }
 
+static int mtk_port_enable(struct mtk_port_mngr *port_mngr)
+{
+	int tbl_type = PORT_TBL_SAP;
+	struct radix_tree_iter iter;
+	struct mtk_port *port;
+	void __rcu **slot;
+
+	do {
+		radix_tree_for_each_slot(slot, &port_mngr->port_tbl[tbl_type], &iter, 0) {
+			MTK_PORT_SEARCH_FROM_RADIX_TREE(port, slot);
+			MTK_PORT_INTERNAL_NODE_CHECK(port, slot, iter);
+			if (port->enable)
+				ports_ops[port->info.type]->enable(port);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+	return 0;
+}
+
+static void mtk_port_disable(struct mtk_port_mngr *port_mngr)
+{
+	int tbl_type = PORT_TBL_SAP;
+	struct radix_tree_iter iter;
+	struct mtk_port *port;
+	void __rcu **slot;
+
+	do {
+		radix_tree_for_each_slot(slot, &port_mngr->port_tbl[tbl_type], &iter, 0) {
+			MTK_PORT_SEARCH_FROM_RADIX_TREE(port, slot);
+			MTK_PORT_INTERNAL_NODE_CHECK(port, slot, iter);
+			port->enable = false;
+			ports_ops[port->info.type]->disable(port);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+}
+
 int mtk_port_add_header(struct sk_buff *skb)
 {
 	struct mtk_ccci_header *ccci_h;
@@ -669,6 +713,55 @@ struct mtk_ccci_header *mtk_port_strip_header(struct sk_buff *skb)
 	return ccci_h;
 }
 
+int mtk_port_status_update(struct mtk_md_dev *mdev, void *data)
+{
+	struct mtk_port_enum_msg *msg = data;
+	struct mtk_port_info *port_info;
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_ctrl_blk *ctrl_blk;
+	struct mtk_port *port;
+	int port_id;
+	int ret = 0;
+	u16 ch_id;
+
+	if (unlikely(!mdev || !msg)) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	ctrl_blk = mdev->ctrl_blk;
+	port_mngr = ctrl_blk->port_mngr;
+	if (le16_to_cpu(msg->version) != MTK_PORT_ENUM_VER) {
+		ret = -EPROTO;
+		goto end;
+	}
+
+	if (le32_to_cpu(msg->head_pattern) != MTK_PORT_ENUM_HEAD_PATTERN ||
+	    le32_to_cpu(msg->tail_pattern) != MTK_PORT_ENUM_TAIL_PATTERN) {
+		ret = -EPROTO;
+		goto end;
+	}
+
+	for (port_id = 0; port_id < le16_to_cpu(msg->port_cnt); port_id++) {
+		port_info = (struct mtk_port_info *)(msg->data +
+						   (sizeof(*port_info) * port_id));
+		if (!port_info) {
+			dev_err(mdev->dev, "Invalid port info, the index %d\n", port_id);
+			ret = -EINVAL;
+			goto end;
+		}
+		ch_id = FIELD_GET(MTK_INFO_FLD_CHID, le16_to_cpu(port_info->channel));
+		port = mtk_port_search_by_id(port_mngr, ch_id);
+		if (!port) {
+			dev_err(mdev->dev, "Failed to find the port 0x%x\n", ch_id);
+			continue;
+		}
+		port->enable = FIELD_GET(MTK_INFO_FLD_EN, le16_to_cpu(port_info->channel));
+	}
+end:
+	return ret;
+}
+
 int mtk_port_mngr_vq_status_check(struct sk_buff *skb)
 {
 	struct trb *trb = (struct trb *)skb->cb;
@@ -791,6 +884,58 @@ int mtk_port_vq_disable(struct mtk_port *port)
 	return ret;
 }
 
+void mtk_port_mngr_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *arg)
+{
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_port *port;
+	int flag;
+
+	if (!fsm_param || !arg) {
+		pr_err("[TMI] Invalid input fsm_param or arg\n");
+		return;
+	}
+
+	port_mngr = arg;
+	flag = fsm_param->fsm_flag;
+
+	dev_info(port_mngr->ctrl_blk->mdev->dev, "Fsm state %d & fsm flag 0x%x\n",
+		 fsm_param->to, flag);
+
+	switch (fsm_param->to) {
+	case FSM_STATE_BOOTUP:
+		if (flag & FSM_F_MD_HS_START) {
+			port = mtk_port_search_by_id(port_mngr, CCCI_CONTROL_RX);
+			if (!port) {
+				dev_err(port_mngr->ctrl_blk->mdev->dev,
+					"Failed to find MD ctrl port\n");
+				goto end;
+			}
+			ports_ops[port->info.type]->enable(port);
+		} else if (flag & FSM_F_SAP_HS_START) {
+			port = mtk_port_search_by_id(port_mngr, CCCI_SAP_CONTROL_RX);
+			if (!port) {
+				dev_err(port_mngr->ctrl_blk->mdev->dev,
+					"Failed to find sAP ctrl port\n");
+				goto end;
+			}
+			ports_ops[port->info.type]->enable(port);
+		}
+		break;
+	case FSM_STATE_READY:
+		mtk_port_enable(port_mngr);
+		break;
+	case FSM_STATE_OFF:
+		mtk_port_disable(port_mngr);
+		break;
+	default:
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Unsupported fsm state %d & fsm flag 0x%x\n", fsm_param->to, flag);
+		break;
+	}
+end:
+	return;
+}
+
 int mtk_port_mngr_init(struct mtk_ctrl_blk *ctrl_blk)
 {
 	struct mtk_port_mngr *port_mngr;
diff --git a/drivers/net/wwan/mediatek/mtk_port.h b/drivers/net/wwan/mediatek/mtk_port.h
index dd6d47092028..55ab640e1c8b 100644
--- a/drivers/net/wwan/mediatek/mtk_port.h
+++ b/drivers/net/wwan/mediatek/mtk_port.h
@@ -14,6 +14,7 @@
 
 #include "mtk_ctrl_plane.h"
 #include "mtk_dev.h"
+#include "mtk_fsm.h"
 
 #define MTK_PEER_ID_MASK	(0xF000)
 #define MTK_PEER_ID_SHIFT	(12)
@@ -22,6 +23,7 @@
 #define MTK_PEER_ID_MD		(0x2)
 #define MTK_CH_ID_MASK		(0x0FFF)
 #define MTK_CH_ID(ch)		((ch) & MTK_CH_ID_MASK)
+#define MTK_PORT_NAME_HDR	"wwanD"
 #define MTK_DFLT_MAX_DEV_CNT	(10)
 #define MTK_DFLT_PORT_NAME_LEN	(20)
 
@@ -54,6 +56,7 @@ enum mtk_ccci_ch {
 
 enum mtk_port_flag {
 	PORT_F_DFLT = 0,
+	PORT_F_RAW_DATA = BIT(0),
 	PORT_F_BLOCKING = BIT(1),
 	PORT_F_ALLOW_DROP = BIT(2),
 };
@@ -75,6 +78,7 @@ struct mtk_internal_port {
 };
 
 union mtk_port_priv {
+	struct cdev *cdev;
 	struct mtk_internal_port i_priv;
 };
 
@@ -162,8 +166,10 @@ void mtk_port_stale_list_grp_cleanup(void);
 int mtk_port_add_header(struct sk_buff *skb);
 struct mtk_ccci_header *mtk_port_strip_header(struct sk_buff *skb);
 int mtk_port_send_data(struct mtk_port *port, void *data);
+int mtk_port_status_update(struct mtk_md_dev *mdev, void *data);
 int mtk_port_vq_enable(struct mtk_port *port);
 int mtk_port_vq_disable(struct mtk_port *port);
+void mtk_port_mngr_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *arg);
 int mtk_port_mngr_vq_status_check(struct sk_buff *skb);
 int mtk_port_mngr_init(struct mtk_ctrl_blk *ctrl_blk);
 void mtk_port_mngr_exit(struct mtk_ctrl_blk *ctrl_blk);
diff --git a/drivers/net/wwan/mediatek/mtk_port_io.c b/drivers/net/wwan/mediatek/mtk_port_io.c
index 2ddd131dfe16..0a59c2049a4a 100644
--- a/drivers/net/wwan/mediatek/mtk_port_io.c
+++ b/drivers/net/wwan/mediatek/mtk_port_io.c
@@ -187,10 +187,7 @@ void *mtk_port_internal_open(struct mtk_md_dev *mdev, char *name, int flag)
 		goto end;
 	}
 
-	if (flag & O_NONBLOCK)
-		port->info.flags &= ~PORT_F_BLOCKING;
-	else
-		port->info.flags |= PORT_F_BLOCKING;
+	port->info.flags |= PORT_F_BLOCKING;
 end:
 	return port;
 }
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
index 21e2f62acce2..03b7c73927b2 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
@@ -9,6 +9,7 @@
 #include <linux/skbuff.h>
 
 #include "../mtk_cldma.h"
+#include "../mtk_fsm.h"
 
 int mtk_cldma_hw_init_t800(struct cldma_dev *cd, int hif_id);
 int mtk_cldma_hw_exit_t800(struct cldma_dev *cd, int hif_id);
@@ -17,4 +18,5 @@ int mtk_cldma_txq_free_t800(struct cldma_hw *hw, int vqno);
 struct rxq *mtk_cldma_rxq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb);
 int mtk_cldma_rxq_free_t800(struct cldma_hw *hw, int vqno);
 int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno);
+void mtk_cldma_fsm_state_listener_t800(struct mtk_fsm_param *param, struct cldma_hw *hw);
 #endif
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index d1cf4bf10f6a..fc0f88cf25ce 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include "../mtk_fsm.h"
 #include "../mtk_port_io.h"
 #include "mtk_pci.h"
 #include "mtk_reg.h"
@@ -859,9 +860,17 @@ static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mtk_pci_unmask_irq(mdev, priv->mhccif_irq_id);
 
+	ret = mtk_dev_start(mdev);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to start dev.\n");
+		goto clear_master_and_device;
+	}
 	dev_info(mdev->dev, "Probe done hw_ver=0x%x\n", mdev->hw_ver);
 	return 0;
 
+clear_master_and_device:
+	pci_clear_master(pdev);
+	mtk_dev_exit(mdev);
 free_irq:
 	mtk_pci_free_irq(mdev);
 free_mhccif:
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_reg.h b/drivers/net/wwan/mediatek/pcie/mtk_reg.h
index 23fa7fd9518e..1159c29685c5 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_reg.h
+++ b/drivers/net/wwan/mediatek/pcie/mtk_reg.h
@@ -18,6 +18,17 @@ enum mtk_ext_evt_h2d {
 	EXT_EVT_H2D_DEVICE_RESET           = 1 << 13,
 };
 
+enum mtk_ext_evt_d2h {
+	EXT_EVT_D2H_PCIE_DS_LOCK_ACK       = 1 << 0,
+	EXT_EVT_D2H_EXCEPT_INIT            = 1 << 1,
+	EXT_EVT_D2H_EXCEPT_INIT_DONE       = 1 << 2,
+	EXT_EVT_D2H_EXCEPT_CLEARQ_DONE     = 1 << 3,
+	EXT_EVT_D2H_EXCEPT_ALLQ_RESET      = 1 << 4,
+	EXT_EVT_D2H_BOOT_FLOW_SYNC         = 1 << 5,
+	EXT_EVT_D2H_ASYNC_HS_NOTIFY_SAP    = 1 << 15,
+	EXT_EVT_D2H_ASYNC_HS_NOTIFY_MD     = 1 << 16,
+};
+
 #define REG_PCIE_SW_TRIG_INT			0x00BC
 #define REG_PCIE_LTSSM_STATUS			0x0150
 #define REG_IMASK_LOCAL				0x0180
-- 
2.32.0

