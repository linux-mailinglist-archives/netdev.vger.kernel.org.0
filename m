Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1F2671BEE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 13:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjARMWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 07:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjARMVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 07:21:10 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F145259761;
        Wed, 18 Jan 2023 03:43:09 -0800 (PST)
X-UUID: 44b8774e972511eda06fc9ecc4dadd91-20230118
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=wMUizuzoq4ZzZ31EhsUMsPGUVKG4zxJGM/5uxAshVWI=;
        b=ejn/PRgOVsNq8iiBXBSzR/9hIxBvHTQ3xELYTaYos8RazXVipP8Q3fXE87jxIcQpblsGvt7bkRm1FR/IlHm32d2U/P7y86I3m92f0irtGfnrqnOutHCjg+lIiQ9AA8aFBz/WxPhNL5TiCommywoVhC2PuFuCxzlPgPX7kqfyU9k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:03d0f707-c900-4cf7-b378-370900ce601f,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.18,REQID:03d0f707-c900-4cf7-b378-370900ce601f,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:3ca2d6b,CLOUDID:dcb20355-dd49-462e-a4be-2143a3ddc739,B
        ulkID:230118194305BFKP7N7K,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:1,OS
        I:0,OSA:0
X-CID-BVR: 2,OSH
X-UUID: 44b8774e972511eda06fc9ecc4dadd91-20230118
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1507024063; Wed, 18 Jan 2023 19:43:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 18 Jan 2023 19:43:02 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 18 Jan 2023 19:43:00 +0800
From:   Yanchao Yang <yanchao.yang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Yanchao Yang <yanchao.yang@mediatek.com>,
        Lambert Wang <lambert.wang@mediatek.com>,
        Mingchuang Qiao <mingchuang.qiao@mediatek.com>,
        Xiayu Zhang <xiayu.zhang@mediatek.com>,
        Haozhe Chang <haozhe.chang@mediatek.com>
Subject: [PATCH net-next v2 05/12] net: wwan: tmi: Add FSM thread
Date:   Wed, 18 Jan 2023 19:38:52 +0800
Message-ID: <20230118113859.175836-6-yanchao.yang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20230118113859.175836-1-yanchao.yang@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
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
 drivers/net/wwan/mediatek/Makefile            |    3 +-
 drivers/net/wwan/mediatek/mtk_cldma.c         |   35 +
 drivers/net/wwan/mediatek/mtk_cldma.h         |    2 +
 drivers/net/wwan/mediatek/mtk_ctrl_plane.c    |  267 +++-
 drivers/net/wwan/mediatek/mtk_ctrl_plane.h    |    9 +
 drivers/net/wwan/mediatek/mtk_dev.c           |   17 +
 drivers/net/wwan/mediatek/mtk_dev.h           |    4 +
 drivers/net/wwan/mediatek/mtk_fsm.c           | 1307 +++++++++++++++++
 drivers/net/wwan/mediatek/mtk_fsm.h           |  178 +++
 drivers/net/wwan/mediatek/mtk_port.c          |  319 +++-
 drivers/net/wwan/mediatek/mtk_port.h          |    7 +
 drivers/net/wwan/mediatek/mtk_port_io.c       |    5 +-
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.c   |   45 +
 .../wwan/mediatek/pcie/mtk_cldma_drv_t800.h   |    2 +
 drivers/net/wwan/mediatek/pcie/mtk_pci.c      |    8 +
 drivers/net/wwan/mediatek/pcie/mtk_reg.h      |   11 +
 16 files changed, 2189 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/wwan/mediatek/mtk_fsm.c
 create mode 100644 drivers/net/wwan/mediatek/mtk_fsm.h

diff --git a/drivers/net/wwan/mediatek/Makefile b/drivers/net/wwan/mediatek/Makefile
index 1e83300eb6d7..a6c1252dfe46 100644
--- a/drivers/net/wwan/mediatek/Makefile
+++ b/drivers/net/wwan/mediatek/Makefile
@@ -9,7 +9,8 @@ mtk_tmi-y = \
 	mtk_cldma.o \
 	pcie/mtk_cldma_drv_t800.o \
 	mtk_port.o \
-	mtk_port_io.o
+	mtk_port_io.o \
+	mtk_fsm.o
 
 ccflags-y += -I$(srctree)/$(src)/
 ccflags-y += -I$(srctree)/$(src)/pcie/
diff --git a/drivers/net/wwan/mediatek/mtk_cldma.c b/drivers/net/wwan/mediatek/mtk_cldma.c
index f9531f48f898..03190c5a01b2 100644
--- a/drivers/net/wwan/mediatek/mtk_cldma.c
+++ b/drivers/net/wwan/mediatek/mtk_cldma.c
@@ -35,6 +35,7 @@ static int mtk_cldma_init(struct mtk_ctrl_trans *trans)
 	cd->hw_ops.txq_free = mtk_cldma_txq_free_t800;
 	cd->hw_ops.rxq_free = mtk_cldma_rxq_free_t800;
 	cd->hw_ops.start_xfer = mtk_cldma_start_xfer_t800;
+	cd->hw_ops.fsm_state_listener = mtk_cldma_fsm_state_listener_t800;
 
 	trans->dev[CLDMA_CLASS_ID] = cd;
 
@@ -252,9 +253,43 @@ static int mtk_cldma_trb_process(void *dev, struct sk_buff *skb)
 	return err;
 }
 
+static void mtk_cldma_fsm_state_listener(struct mtk_fsm_param *param, struct mtk_ctrl_trans *trans)
+{
+	struct cldma_dev *cd = trans->dev[CLDMA_CLASS_ID];
+	struct cldma_hw *hw;
+	int i;
+
+	switch (param->to) {
+	case FSM_STATE_POSTDUMP:
+		cd->hw_ops.init(cd, CLDMA0);
+		break;
+	case FSM_STATE_DOWNLOAD:
+		if (param->fsm_flag & FSM_F_DL_PORT_CREATE)
+			cd->hw_ops.init(cd, CLDMA0);
+		break;
+	case FSM_STATE_BOOTUP:
+		for (i = 0; i < NR_CLDMA; i++)
+			cd->hw_ops.init(cd, i);
+		break;
+	case FSM_STATE_OFF:
+		for (i = 0; i < NR_CLDMA; i++)
+			cd->hw_ops.exit(cd, i);
+		break;
+	case FSM_STATE_MDEE:
+		if (param->fsm_flag & FSM_F_MDEE_INIT)
+			cd->hw_ops.init(cd, CLDMA1);
+		hw = cd->cldma_hw[CLDMA1 & HIF_ID_BITMASK];
+		cd->hw_ops.fsm_state_listener(param, hw);
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
diff --git a/drivers/net/wwan/mediatek/mtk_ctrl_plane.c b/drivers/net/wwan/mediatek/mtk_ctrl_plane.c
index 0a855f94bf3c..06932feb6bed 100644
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
 /**
  * mtk_ctrl_trb_submit() - Submit TRB event.
  * @blk: pointer to mtk_ctrl_blk
@@ -123,12 +282,108 @@ int mtk_ctrl_trb_submit(struct mtk_ctrl_blk *blk, struct sk_buff *skb)
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
+	if ((param->to == FSM_STATE_MDEE && param->fsm_flag & FSM_F_MDEE_ALLQ_RESET) ||
+	    (param->to == FSM_STATE_MDEE && param->fsm_flag & FSM_F_MDEE_INIT) ||
+	    param->to == FSM_STATE_POSTDUMP || param->to == FSM_STATE_DOWNLOAD ||
+	    param->to == FSM_STATE_BOOTUP) {
+		mtk_ctrl_trans_fsm_state_handler(param, ctrl_blk);
+		mtk_port_mngr_fsm_state_handler(param, ctrl_blk->port_mngr);
+	} else {
+		mtk_port_mngr_fsm_state_handler(param, ctrl_blk->port_mngr);
+		mtk_ctrl_trans_fsm_state_handler(param, ctrl_blk);
+	}
+}
+
 /**
  * mtk_ctrl_init() - allocate ctrl plane control block and initialize it
  * @mdev: pointer to mtk_md_dev
@@ -151,8 +406,17 @@ int mtk_ctrl_init(struct mtk_md_dev *mdev)
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
 
@@ -169,6 +433,7 @@ int mtk_ctrl_exit(struct mtk_md_dev *mdev)
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
index 7c4aac438775..408a30ce3d3a 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.c
+++ b/drivers/net/wwan/mediatek/mtk_dev.c
@@ -5,20 +5,37 @@
 
 #include "mtk_ctrl_plane.h"
 #include "mtk_dev.h"
+#include "mtk_fsm.h"
 
 int mtk_dev_init(struct mtk_md_dev *mdev)
 {
 	int ret;
 
+	ret = mtk_fsm_init(mdev);
+	if (ret)
+		goto err_fsm_init;
+
 	ret = mtk_ctrl_init(mdev);
 	if (ret)
 		goto err_ctrl_init;
 
 err_ctrl_init:
+	mtk_fsm_exit(mdev);
+err_fsm_init:
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
index 575c5da00aaf..bc824294f17c 100644
--- a/drivers/net/wwan/mediatek/mtk_dev.h
+++ b/drivers/net/wwan/mediatek/mtk_dev.h
@@ -128,6 +128,7 @@ struct mtk_hw_ops {
  * @hw_ver:     to keep HW chip ID.
  * @msi_nvecs:  to keep the amount of aollocated irq vectors.
  * @dev_str:    to keep device B-D-F information.
+ * @fsm:        pointer to the context of fsm submodule.
  * @ctrl_blk:   pointer to the context of control plane submodule.
  * @bm_ctrl:    pointer to the context of buffer management submodule.
  */
@@ -138,12 +139,15 @@ struct mtk_md_dev {
 	u32 hw_ver;
 	int msi_nvecs;
 	char dev_str[MTK_DEV_STR_LEN];
+
+	struct mtk_md_fsm *fsm;
 	void *ctrl_blk;
 	struct mtk_bm_ctrl *bm_ctrl;
 };
 
 int mtk_dev_init(struct mtk_md_dev *mdev);
 void mtk_dev_exit(struct mtk_md_dev *mdev);
+int mtk_dev_start(struct mtk_md_dev *mdev);
 /**
  * mtk_hw_read32() - Read dword from register.
  * @mdev: Device instance.
diff --git a/drivers/net/wwan/mediatek/mtk_fsm.c b/drivers/net/wwan/mediatek/mtk_fsm.c
new file mode 100644
index 000000000000..cbcf2c9749c9
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_fsm.c
@@ -0,0 +1,1307 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2022, MediaTek Inc.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/completion.h>
+#include <linux/device.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/sched/signal.h>
+#include <linux/skbuff.h>
+#include <linux/timer.h>
+#include <linux/wait.h>
+
+#include "mtk_common.h"
+#include "mtk_fsm.h"
+#include "mtk_port.h"
+#include "mtk_port_io.h"
+#include "mtk_reg.h"
+
+#define EVT_TF_PAUSE (0)
+#define EVT_TF_GATECLOSED (1)
+
+#define FSM_HS_START_MASK	(FSM_F_SAP_HS_START | FSM_F_MD_HS_START)
+#define FSM_HS2_DONE_MASK	(FSM_F_SAP_HS2_DONE | FSM_F_MD_HS2_DONE)
+
+#define EXT_EVT_D2H_MDEE_MASK	(EXT_EVT_D2H_EXCEPT_INIT | EXT_EVT_D2H_EXCEPT_INIT_DONE |\
+				 EXT_EVT_D2H_EXCEPT_CLEARQ_DONE | EXT_EVT_D2H_EXCEPT_ALLQ_RESET)
+#define RTFT_DATA_SIZE		(3 * 1024)
+
+#define MDEE_CHK_ID		0x45584350
+#define MDEE_REC_OK_CHK_ID	0x45524543
+
+#define REGION_BITMASK		0xF
+#define BROM_EVT_SHIFT		4
+#define LK_EVT_SHIFT		8
+#define DEVICE_CFG_SHIFT	24
+#define DEVICE_CFG_REGION_MASK	0x3
+
+#define HOST_EVT_SHIFT		28
+#define HOST_REGION_BITMASK	0xF0000000
+
+enum host_event {
+	HOST_EVT_INIT = 0,
+	HOST_ENTER_DA = 2,
+};
+
+enum brom_event {
+	BROM_EVT_NORMAL = 0,
+	BROM_EVT_JUMP_BL,
+	BROM_EVT_TIME_OUT,
+	BROM_EVT_JUMP_DA,
+	BROM_EVT_START_DL,
+};
+
+enum lk_event {
+	LK_EVT_NORMAL = 0,
+	LK_EVT_CREATE_PD_PORT,
+};
+
+enum device_stage {
+	DEV_STAGE_INIT = 0,
+	DEV_STAGE_BROM1,
+	DEV_STAGE_BROM2,
+	DEV_STAGE_LK,
+	DEV_STAGE_LINUX,
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
+	CTRL_MSG_MDEE = 4,
+	CTRL_MSG_MDEE_REC_OK = 6,
+	CTRL_MSG_MDEE_PASS = 8,
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
+	/* fill control message header */
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	ctrl_msg_h->id = cpu_to_le32(CTRL_MSG_HS1);
+	ctrl_msg_h->ex_msg = 0;
+	ctrl_msg_h->data_len = cpu_to_le32(sizeof(*ft_query));
+
+	/* fill feature query structure */
+	ft_query = (struct feature_query *)(skb->data + sizeof(*ctrl_msg_h));
+	ft_query->head_pattern = cpu_to_le32(FEATURE_QUERY_PATTERN);
+	memcpy(ft_query->ft_set, hs_info->query_ft_set, sizeof(hs_info->query_ft_set));
+	ft_query->tail_pattern = cpu_to_le32(FEATURE_QUERY_PATTERN);
+
+	/* send handshake1 message to device */
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
+	switch (FIELD_GET(FEATURE_TYPE, rtft_info_st.feature)) {
+	case RTFT_TYPE_NOT_EXIST:
+		fallthrough;
+	case RTFT_TYPE_NOT_SUPPORT:
+		*cur_ft_spt = RTFT_TYPE_NOT_EXIST;
+		break;
+	case RTFT_TYPE_MUST_SUPPORT:
+		if (FIELD_GET(FEATURE_TYPE, rtft_info_cfg.feature) == RTFT_TYPE_NOT_EXIST ||
+		    FIELD_GET(FEATURE_TYPE, rtft_info_cfg.feature) == RTFT_TYPE_NOT_SUPPORT)
+			ret = -EPROTO;
+		else
+			*cur_ft_spt = RTFT_TYPE_MUST_SUPPORT;
+		break;
+	case RTFT_TYPE_OPTIONAL_SUPPORT:
+		if (FIELD_GET(FEATURE_TYPE, rtft_info_cfg.feature) == RTFT_TYPE_NOT_EXIST ||
+		    FIELD_GET(FEATURE_TYPE, rtft_info_cfg.feature) == RTFT_TYPE_NOT_SUPPORT) {
+			*cur_ft_spt = RTFT_TYPE_NOT_SUPPORT;
+		} else {
+			if (FIELD_GET(FEATURE_VER, rtft_info_st.feature) ==
+			    FIELD_GET(FEATURE_VER, rtft_info_cfg.feature))
+				*cur_ft_spt = RTFT_TYPE_MUST_SUPPORT;
+			else
+				*cur_ft_spt = RTFT_TYPE_NOT_SUPPORT;
+		}
+		break;
+	case RTFT_TYPE_SUPPORT_BACKWARD_COMPAT:
+		if (FIELD_GET(FEATURE_VER, rtft_info_st.feature) >=
+		    FIELD_GET(FEATURE_VER, rtft_info_cfg.feature))
+			*cur_ft_spt = RTFT_TYPE_MUST_SUPPORT;
+		else
+			*cur_ft_spt = RTFT_TYPE_NOT_EXIST;
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
+	u8 version;
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
+	/* parse runtime feature query and fill runtime feature entry */
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
+			if (FIELD_GET(FEATURE_VER, ft_query->ft_set[ft_id].feature) ==
+			    FIELD_GET(FEATURE_VER, hs_info->supported_ft_set[ft_id].feature) &&
+			    FIELD_GET(FEATURE_TYPE, hs_info->supported_ft_set[ft_id].feature) >=
+			    RTFT_TYPE_MUST_SUPPORT)
+				rtft_entry->support_info.feature =
+					FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_MUST_SUPPORT);
+			else
+				rtft_entry->support_info.feature =
+					FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_NOT_SUPPORT);
+			version = FIELD_GET(FEATURE_VER, hs_info->supported_ft_set[ft_id].feature);
+			rtft_entry->support_info.feature |= FIELD_PREP(FEATURE_VER, version);
+			break;
+		case RTFT_TYPE_SUPPORT_BACKWARD_COMPAT:
+			if (FIELD_GET(FEATURE_VER, ft_query->ft_set[ft_id].feature) >=
+			    FIELD_GET(FEATURE_VER, hs_info->supported_ft_set[ft_id].feature))
+				rtft_entry->support_info.feature =
+					FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_MUST_SUPPORT);
+			else
+				rtft_entry->support_info.feature =
+					FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_NOT_SUPPORT);
+			version = FIELD_GET(FEATURE_VER, hs_info->supported_ft_set[ft_id].feature);
+			rtft_entry->support_info.feature |= FIELD_PREP(FEATURE_VER, version);
+			break;
+		}
+
+		if (FIELD_GET(FEATURE_TYPE, rtft_entry->support_info.feature) ==
+		    RTFT_TYPE_MUST_SUPPORT) {
+			if (rtft_action[ft_id]) {
+				ret = rtft_action[ft_id](mdev, rtft_entry->data);
+				if (ret < 0)
+					goto hs_err;
+			}
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
+	/* fill control message header */
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
+	/* send handshake3 message to device */
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
+	u32 ex_msg;
+
+	ctrl_msg_h = (struct ctrl_msg_header *)skb->data;
+	ex_msg = le32_to_cpu(ctrl_msg_h->ex_msg);
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
+	case CTRL_MSG_MDEE:
+		if (ex_msg != MDEE_CHK_ID)
+			dev_err(fsm->mdev->dev, "Unable to match MDEE packet(0x%x)\n",
+				ex_msg);
+		else
+			mtk_fsm_evt_submit(fsm->mdev, FSM_EVT_MDEE,
+					   FSM_F_MDEE_MSG, hs_info, sizeof(*hs_info), 0);
+		break;
+	case CTRL_MSG_MDEE_REC_OK:
+		if (ex_msg != MDEE_REC_OK_CHK_ID)
+			dev_err(fsm->mdev->dev, "Unable to match MDEE REC OK packet(0x%x)\n",
+				ex_msg);
+		else
+			mtk_fsm_evt_submit(fsm->mdev, FSM_EVT_MDEE,
+					   FSM_F_MDEE_RECV_OK, NULL, 0, 0);
+		break;
+	case CTRL_MSG_MDEE_PASS:
+		mtk_fsm_evt_submit(fsm->mdev, FSM_EVT_MDEE, FSM_F_MDEE_PASS, NULL, 0, 0);
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
+static void mtk_fsm_host_evt_ack(struct mtk_md_dev *mdev, enum host_event id)
+{
+	u32 dev_state;
+
+	dev_state = mtk_hw_get_dev_state(mdev);
+	dev_state &= ~HOST_REGION_BITMASK;
+	dev_state |= id << HOST_EVT_SHIFT;
+	mtk_hw_ack_dev_state(mdev, dev_state);
+}
+
+static void mtk_fsm_brom_evt_handler(struct mtk_md_dev *mdev, u32 dev_state)
+{
+	u32 brom_evt = dev_state >> BROM_EVT_SHIFT & REGION_BITMASK;
+
+	switch (brom_evt) {
+	case BROM_EVT_JUMP_BL:
+		mtk_fsm_evt_submit(mdev, FSM_EVT_DOWNLOAD, FSM_F_DL_JUMPBL, NULL, 0, 0);
+		break;
+	case BROM_EVT_TIME_OUT:
+		mtk_fsm_evt_submit(mdev, FSM_EVT_DOWNLOAD, FSM_F_DL_TIMEOUT, NULL, 0, 0);
+		break;
+	case BROM_EVT_JUMP_DA:
+		mtk_fsm_host_evt_ack(mdev, HOST_ENTER_DA);
+		mtk_fsm_evt_submit(mdev, FSM_EVT_DOWNLOAD, FSM_F_DL_DA, NULL, 0, 0);
+		break;
+	case BROM_EVT_START_DL:
+		mtk_fsm_evt_submit(mdev, FSM_EVT_DOWNLOAD, FSM_F_DL_PORT_CREATE, NULL, 0, 0);
+		break;
+	default:
+		dev_err(mdev->dev, "Invalid brom event, value = 0x%x\n", dev_state);
+	}
+}
+
+static void mtk_fsm_lk_evt_handler(struct mtk_md_dev *mdev, u32 dev_state)
+{
+	u32 lk_evt = dev_state >> LK_EVT_SHIFT & REGION_BITMASK;
+
+	if (lk_evt != LK_EVT_CREATE_PD_PORT) {
+		dev_err(mdev->dev, "Invalid LK event, value = 0x%x\n", dev_state);
+		return;
+	}
+
+	mtk_fsm_evt_submit(mdev, FSM_EVT_POSTDUMP, FSM_F_DFLT, NULL, 0, 0);
+}
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
+
+	mtk_hw_unmask_ext_evt(mdev, EXT_EVT_D2H_MDEE_MASK);
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
+	switch (dev_stage) {
+	case DEV_STAGE_BROM1:
+		fallthrough;
+	case DEV_STAGE_BROM2:
+		mtk_fsm_brom_evt_handler(mdev, dev_state);
+		break;
+	case DEV_STAGE_LK:
+		mtk_fsm_lk_evt_handler(mdev, dev_state);
+		break;
+	case DEV_STAGE_LINUX:
+		mtk_fsm_linux_evt_handler(mdev, dev_state, fsm);
+		break;
+	}
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
+	if (!hs_info->ctrl_port) {
+		hs_info->ctrl_port = mtk_port_internal_open(fsm->mdev, hs_info->port_name, 0);
+		if (!hs_info->ctrl_port) {
+			dev_err(fsm->mdev->dev, "Failed to open ctrl port(%s)\n",
+				hs_info->port_name);
+			return -ENODEV;
+		}
+		mtk_port_internal_recv_register(hs_info->ctrl_port,
+						ctrl_msg_handler[hs_info->id], fsm);
+	}
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
+				 enum mtk_fsm_state to_state,
+				 struct mtk_fsm_evt *event)
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
+	if (fsm->state != FSM_STATE_ON && fsm->state != FSM_STATE_DOWNLOAD &&
+	    fsm->state != FSM_STATE_BOOTUP) {
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
+static int mtk_fsm_mdee_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+	struct ctrl_msg_header *ctrl_msg_h;
+	struct fsm_hs_info *hs_info;
+	struct sk_buff *ctrl_msg;
+	int ret;
+
+	if (fsm->state != FSM_STATE_ON && fsm->state != FSM_STATE_BOOTUP &&
+	    fsm->state != FSM_STATE_READY && fsm->state != FSM_STATE_MDEE) {
+		dev_err(mdev->dev, "Unable to handle the event in the state %d\n", fsm->state);
+		return -EPROTO;
+	}
+
+	mtk_fsm_switch_state(fsm, FSM_STATE_MDEE, event);
+
+	switch (event->fsm_flag) {
+	case FSM_F_MDEE_INIT:
+		mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_EXCEPT_ACK);
+		mtk_fsm_ctrl_ch_start(fsm, &fsm->hs_info[HS_ID_MD]);
+		break;
+	case FSM_F_MDEE_CLEARQ_DONE:
+		mtk_hw_send_ext_evt(mdev, EXT_EVT_H2D_EXCEPT_CLEARQ_ACK);
+		break;
+	case FSM_F_MDEE_MSG:
+		hs_info = event->data;
+		ctrl_msg = __dev_alloc_skb(sizeof(*ctrl_msg), GFP_KERNEL);
+		if (!ctrl_msg) {
+			dev_err(mdev->dev, "Unable to alloc ctrl message packet\n");
+			return -ENOMEM;
+		}
+		skb_put(ctrl_msg, sizeof(*ctrl_msg_h));
+		/* fill control message header */
+		ctrl_msg_h = (struct ctrl_msg_header *)ctrl_msg->data;
+		ctrl_msg_h->id = cpu_to_le32(CTRL_MSG_MDEE);
+		ctrl_msg_h->ex_msg = cpu_to_le32(MDEE_CHK_ID);
+		ctrl_msg_h->data_len = 0;
+
+		ret = mtk_port_internal_write(hs_info->ctrl_port, ctrl_msg);
+		if (ret <= 0) {
+			dev_err(mdev->dev, "Unable to send MDEE message\n");
+			return -EPROTO;
+		}
+		break;
+	case FSM_F_MDEE_RECV_OK:
+		dev_info(mdev->dev, "MDEE handshake1 successfully\n");
+		break;
+	case FSM_F_MDEE_PASS:
+		dev_info(mdev->dev, "MDEE handshake2 successfully\n");
+		break;
+	}
+
+	return 0;
+}
+
+static int mtk_fsm_download_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+
+	if (fsm->state != FSM_STATE_ON && fsm->state != FSM_STATE_DOWNLOAD) {
+		dev_err(mdev->dev, "Unable to handle the event in the state %d\n", fsm->state);
+		return -EPROTO;
+	}
+
+	mtk_fsm_switch_state(fsm, FSM_STATE_DOWNLOAD, event);
+
+	return 0;
+}
+
+static int mtk_fsm_postdump_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+
+	if (fsm->state != FSM_STATE_ON && fsm->state != FSM_STATE_DOWNLOAD) {
+		dev_err(mdev->dev, "Unable to handle the event in the state %d\n", fsm->state);
+		return -EPROTO;
+	}
+
+	mtk_fsm_switch_state(fsm, FSM_STATE_POSTDUMP, event);
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
+static int mtk_fsm_mdee_handler(u32 status, void *__fsm)
+{
+	u32 handled_mdee_mhccif_ch = 0;
+	struct mtk_md_fsm *fsm = __fsm;
+	struct mtk_md_dev *mdev;
+
+	mdev = fsm->mdev;
+	if (status & EXT_EVT_D2H_EXCEPT_INIT) {
+		mtk_fsm_evt_submit(mdev, FSM_EVT_MDEE,
+				   FSM_F_MDEE_INIT, NULL, 0, 0);
+		handled_mdee_mhccif_ch |= EXT_EVT_D2H_EXCEPT_INIT;
+	}
+
+	if (status & EXT_EVT_D2H_EXCEPT_INIT_DONE) {
+		mtk_fsm_evt_submit(mdev, FSM_EVT_MDEE,
+				   FSM_F_MDEE_INIT_DONE, NULL, 0, 0);
+		handled_mdee_mhccif_ch |= EXT_EVT_D2H_EXCEPT_INIT_DONE;
+	}
+
+	if (status & EXT_EVT_D2H_EXCEPT_CLEARQ_DONE) {
+		mtk_fsm_evt_submit(mdev, FSM_EVT_MDEE,
+				   FSM_F_MDEE_CLEARQ_DONE, NULL, 0, 0);
+		handled_mdee_mhccif_ch |= EXT_EVT_D2H_EXCEPT_CLEARQ_DONE;
+	}
+
+	if (status & EXT_EVT_D2H_EXCEPT_ALLQ_RESET) {
+		mtk_fsm_evt_submit(mdev, FSM_EVT_MDEE,
+				   FSM_F_MDEE_ALLQ_RESET, NULL, 0, 0);
+		handled_mdee_mhccif_ch |= EXT_EVT_D2H_EXCEPT_ALLQ_RESET;
+	}
+
+	mtk_hw_mask_ext_evt(mdev, handled_mdee_mhccif_ch);
+	mtk_hw_clear_ext_evt(mdev, handled_mdee_mhccif_ch);
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
+		hs_info->ctrl_port = NULL;
+		switch (hs_id) {
+		case HS_ID_MD:
+			snprintf(hs_info->port_name, PORT_NAME_LEN, "MDCTRL");
+			hs_info->mhccif_ch = EXT_EVT_D2H_ASYNC_HS_NOTIFY_MD;
+			hs_info->fsm_flag_hs1 = FSM_F_MD_HS_START;
+			hs_info->fsm_flag_hs2 = FSM_F_MD_HS2_DONE;
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_ENUM].feature =
+				FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_MUST_SUPPORT);
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_ENUM].feature |=
+				FIELD_PREP(FEATURE_VER, 0);
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_CFG].feature =
+				FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_OPTIONAL_SUPPORT);
+			hs_info->query_ft_set[RTFT_ID_MD_PORT_CFG].feature |=
+				FIELD_PREP(FEATURE_VER, 0);
+			break;
+		case HS_ID_SAP:
+			snprintf(hs_info->port_name, PORT_NAME_LEN, "SAPCTRL");
+			hs_info->mhccif_ch = EXT_EVT_D2H_ASYNC_HS_NOTIFY_SAP;
+			hs_info->fsm_flag_hs1 = FSM_F_SAP_HS_START;
+			hs_info->fsm_flag_hs2 = FSM_F_SAP_HS2_DONE;
+			hs_info->query_ft_set[RTFT_ID_SAP_PORT_ENUM].feature =
+				FIELD_PREP(FEATURE_TYPE, RTFT_TYPE_MUST_SUPPORT);
+			hs_info->query_ft_set[RTFT_ID_SAP_PORT_ENUM].feature |=
+				FIELD_PREP(FEATURE_VER, 0);
+			break;
+		}
+		mtk_hw_register_ext_evt(mdev, hs_info->mhccif_ch,
+					mtk_fsm_hs1_handler, hs_info);
+	}
+
+	mtk_hw_register_ext_evt(mdev, EXT_EVT_D2H_MDEE_MASK, mtk_fsm_mdee_handler, fsm);
+}
+
+static void mtk_fsm_hs_info_exit(struct mtk_md_fsm *fsm)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+	struct fsm_hs_info *hs_info;
+	int hs_id;
+
+	mtk_hw_unregister_ext_evt(mdev, EXT_EVT_D2H_MDEE_MASK);
+	for (hs_id = 0; hs_id < HS_ID_MAX; hs_id++) {
+		hs_info = &fsm->hs_info[hs_id];
+		mtk_hw_unregister_ext_evt(mdev, hs_info->mhccif_ch);
+	}
+}
+
+static void mtk_fsm_reset(struct mtk_md_fsm *fsm)
+{
+	unsigned long flags;
+
+	fsm->t_flag = 0;
+	reinit_completion(&fsm->paused);
+	fsm->last_dev_state = 0;
+
+	fsm->state = FSM_STATE_INVALID;
+	fsm->fsm_flag = FSM_F_DFLT;
+
+	spin_lock_irqsave(&fsm->evtq_lock, flags);
+	if (!list_empty(&fsm->evtq))
+		mtk_fsm_evt_cleanup(fsm, &fsm->evtq);
+	spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+
+	mtk_fsm_hs_info_init(fsm);
+	mtk_hw_register_ext_evt(fsm->mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC,
+				mtk_fsm_early_bootup_handler, fsm);
+}
+
+static int mtk_fsm_dev_reinit_act(struct mtk_md_fsm *fsm, struct mtk_fsm_evt *event)
+{
+	struct mtk_md_dev *mdev = fsm->mdev;
+
+	if (fsm->state != FSM_STATE_OFF) {
+		dev_err(mdev->dev, "Unable to handle the event in state %d\n", fsm->state);
+		return -EPROTO;
+	}
+
+	if (event->fsm_flag == FSM_F_FULL_REINIT) {
+		mtk_hw_reinit(mdev, REINIT_TYPE_EXP);
+		event->fsm_flag = 0;
+	} else {
+		mtk_hw_reinit(mdev, REINIT_TYPE_RESUME);
+	}
+
+	mtk_fsm_reset(fsm);
+	mtk_fsm_switch_state(fsm, FSM_STATE_ON, event);
+	mtk_hw_unmask_ext_evt(mdev, EXT_EVT_D2H_BOOT_FLOW_SYNC);
+
+	return 0;
+}
+
+static int (*evts_act_tbl[FSM_EVT_MAX])(struct mtk_md_fsm *__fsm, struct mtk_fsm_evt *event) = {
+	[FSM_EVT_DOWNLOAD] = mtk_fsm_download_act,
+	[FSM_EVT_POSTDUMP] = mtk_fsm_postdump_act,
+	[FSM_EVT_STARTUP] = mtk_fsm_startup_act,
+	[FSM_EVT_LINKDOWN] = mtk_fsm_enter_off_state,
+	[FSM_EVT_AER] = mtk_fsm_enter_off_state,
+	[FSM_EVT_COLD_RESUME] = mtk_fsm_enter_off_state,
+	[FSM_EVT_REINIT] = mtk_fsm_dev_reinit_act,
+	[FSM_EVT_MDEE] = mtk_fsm_mdee_act,
+	[FSM_EVT_DEV_RESET_REQ] = mtk_fsm_enter_off_state,
+	[FSM_EVT_DEV_RM] = mtk_fsm_dev_rm_act,
+	[FSM_EVT_DEV_ADD] = mtk_fsm_dev_add_act,
+};
+
+/**
+ * mtk_fsm_start() - start FSM service
+ * @mdev: mdev pointer to mtk_md_dev
+ *
+ * This function start a fsm service to handle fsm event.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_fsm_start(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+
+	if (!fsm)
+		return -EINVAL;
+
+	dev_info(mdev->dev, "Start fsm by %ps!\n", __builtin_return_address(0));
+	clear_bit(EVT_TF_PAUSE, &fsm->t_flag);
+	if (!fsm->fsm_handler)
+		return -EFAULT;
+
+	wake_up_process(fsm->fsm_handler);
+	return 0;
+}
+
+/**
+ * mtk_fsm_pause() - pause fsm service
+ * @mdev: pointer to mtk_md_dev.
+ *
+ * If the function is called in irq context, it is able to be paused, or
+ * it will return as soon. It can only work in process context.
+ *
+ * Return:
+ * * 0: the fsm handler thread is paused.
+ * * <0: fail to pause fsm handler thread.
+ */
+int mtk_fsm_pause(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+
+	if (!fsm)
+		return -EINVAL;
+
+	dev_info(mdev->dev, "Pause fsm by %ps!\n", __builtin_return_address(0));
+	if (!test_and_set_bit(EVT_TF_PAUSE, &fsm->t_flag)) {
+		reinit_completion(&fsm->paused);
+		wake_up_process(fsm->fsm_handler);
+	}
+
+	wait_for_completion(&fsm->paused);
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
+/**
+ * mtk_fsm_notifier_register() - register notifier callback
+ * @mdev: pointer to mtk_md_dev
+ * @id: user id
+ * @cb: pointer to notification callback provided by user
+ * @data: pointer to user data if any
+ * @prio: PRIO_0, PRIO_1
+ * @is_pre: 1: pre switch, 0: post switch
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_fsm_notifier_register(struct mtk_md_dev *mdev,
+			      enum mtk_user_id id,
+			      void (*cb)(struct mtk_fsm_param *, void *data),
+			      void *data,
+			      enum mtk_fsm_prio prio,
+			      bool is_pre)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	struct mtk_fsm_notifier *notifier;
+
+	if (!fsm)
+		return -EINVAL;
+
+	if (id >= MTK_USER_MAX || !cb || prio >= FSM_PRIO_MAX)
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
+/**
+ * mtk_fsm_notifier_unregister() - unregister notifier callback
+ * @mdev: pointer to mtk_md_dev
+ * @id: user id
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
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
+/**
+ * mtk_fsm_evt_submit() - submit event
+ * @mdev: pointer to mtk_md_dev
+ * @id: event id
+ * @flag: state flag
+ * @data: user data
+ * @len: data length
+ * @mode: EVT_MODE_BLOCKING(1<<0) means that submit blocking until
+ *        event is handled, EVT_MODE_TOHEAD(1<<1) means the event
+ *        will be handled in high priority.
+ *
+ * Return: 0 will be returned, if the event is appended (non-blocking)
+ *         or event is completed(blocking), -1 will be returned if
+ *         timeout, 1 will be returned if it is finished.
+ */
+int mtk_fsm_evt_submit(struct mtk_md_dev *mdev,
+		       enum mtk_fsm_evt_id id,
+		       enum mtk_fsm_flag flag,
+		       void *data, unsigned int len,
+		       unsigned char mode)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	struct mtk_fsm_evt *event;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!fsm || id >= FSM_EVT_MAX)
+		return FSM_EVT_RET_FAIL;
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
+	dev_info(mdev->dev, "Event%d(with mode 0x%x) is appended by %ps\n",
+		 event->id, event->mode, __builtin_return_address(0));
+
+	spin_lock_irqsave(&fsm->evtq_lock, flags);
+	if (!test_bit(EVT_TF_GATECLOSED, &fsm->t_flag)) {
+		if (mode & EVT_MODE_TOHEAD)
+			list_add(&event->entry, &fsm->evtq);
+		else
+			list_add_tail(&event->entry, &fsm->evtq);
+		spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+	} else {
+		spin_unlock_irqrestore(&fsm->evtq_lock, flags);
+		mtk_fsm_evt_put(event);
+		dev_err(mdev->dev, "Failed to add event, fsm dev has been removed!\n");
+		return FSM_EVT_RET_FAIL;
+	}
+
+	wake_up_process(fsm->fsm_handler);
+	if (mode & EVT_MODE_BLOCKING) {
+		kref_get(&event->kref);
+		wait_event_interruptible(fsm->evt_waitq, (event->status != 0));
+		ret = event->status;
+		mtk_fsm_evt_put(event);
+	}
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
+	while (!kthread_should_stop() &&
+	       !test_bit(EVT_TF_PAUSE, &fsm->t_flag) && !list_empty(&fsm->evtq)) {
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
+	if (test_bit(EVT_TF_PAUSE, &fsm->t_flag))
+		complete_all(&fsm->paused);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	schedule();
+
+	if (fatal_signal_pending(current)) {
+		/* event handler thread is killed by fatal signal,
+		 * all the waiters will be waken up.
+		 */
+		complete_all(&fsm->paused);
+		mtk_fsm_evt_cleanup(fsm, &fsm->evtq);
+		return -ERESTARTSYS;
+	}
+	goto wake_up;
+}
+
+/**
+ * mtk_fsm_init() - allocate FSM control block and initialize it
+ * @mdev: pointer to mtk_md_dev
+ *
+ * This function creates a mtk_md_fsm structure dynamically and hook
+ * it up to mtk_md_dev. When you are finished with this structure,
+ * call mtk_fsm_exit() and the structure will be dynamically freed.
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
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
+		goto err_create;
+	}
+
+	fsm->mdev = mdev;
+	init_completion(&fsm->paused);
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
+err_create:
+	devm_kfree(mdev->dev, fsm);
+	return ret;
+}
+
+/**
+ * mtk_fsm_exit() - free FSM control block
+ * @mdev: pointer to mtk_md_dev
+ *
+ * Return: return value is 0 on success, a negative error code on failure.
+ */
+int mtk_fsm_exit(struct mtk_md_dev *mdev)
+{
+	struct mtk_md_fsm *fsm = mdev->fsm;
+	unsigned long flags;
+
+	if (!fsm)
+		return -EINVAL;
+
+	if (fsm->fsm_handler) {
+		kthread_stop(fsm->fsm_handler);
+		fsm->fsm_handler = NULL;
+	}
+	complete_all(&fsm->paused);
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
index 000000000000..3d2594b26a34
--- /dev/null
+++ b/drivers/net/wwan/mediatek/mtk_fsm.h
@@ -0,0 +1,178 @@
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
+#define EVT_HANDLER_TIMEOUT	(5 * HZ)
+#define EVT_MODE_BLOCKING	(0x01)
+#define EVT_MODE_TOHEAD		(0x02)
+
+#define FSM_EVT_RET_FAIL	(-1)
+#define FSM_EVT_RET_ONGOING	(0)
+#define FSM_EVT_RET_DONE	(1)
+
+enum mtk_fsm_flag {
+	FSM_F_DFLT = 0,
+	FSM_F_DL_PORT_CREATE	= BIT(0),
+	FSM_F_DL_DA		= BIT(1),
+	FSM_F_DL_JUMPBL		= BIT(2),
+	FSM_F_DL_TIMEOUT	= BIT(3),
+	FSM_F_SAP_HS_START	= BIT(4),
+	FSM_F_SAP_HS2_DONE	= BIT(5),
+	FSM_F_MD_HS_START	= BIT(6),
+	FSM_F_MD_HS2_DONE	= BIT(7),
+	FSM_F_MDEE_INIT		= BIT(8),
+	FSM_F_MDEE_INIT_DONE	= BIT(9),
+	FSM_F_MDEE_CLEARQ_DONE	= BIT(10),
+	FSM_F_MDEE_ALLQ_RESET	= BIT(11),
+	FSM_F_MDEE_MSG		= BIT(12),
+	FSM_F_MDEE_RECV_OK	= BIT(13),
+	FSM_F_MDEE_PASS		= BIT(14),
+	FSM_F_FULL_REINIT	= BIT(15),
+};
+
+enum mtk_fsm_state {
+	FSM_STATE_INVALID = 0,
+	FSM_STATE_OFF,
+	FSM_STATE_ON,
+	FSM_STATE_POSTDUMP,
+	FSM_STATE_DOWNLOAD,
+	FSM_STATE_BOOTUP,
+	FSM_STATE_READY,
+	FSM_STATE_MDEE,
+};
+
+enum mtk_fsm_evt_id {
+	FSM_EVT_DOWNLOAD = 0,
+	FSM_EVT_POSTDUMP,
+	FSM_EVT_STARTUP,
+	FSM_EVT_LINKDOWN,
+	FSM_EVT_AER,
+	FSM_EVT_COLD_RESUME,
+	FSM_EVT_REINIT,
+	FSM_EVT_MDEE,
+	FSM_EVT_DEV_RESET_REQ,
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
+	/* the feature that the host has supported */
+	struct runtime_feature_info supported_ft_set[FEATURE_CNT];
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
+	/* completion for event thread paused */
+	struct completion paused;
+	u32 last_dev_state;
+	/* fsm current state & flag */
+	enum mtk_fsm_state state;
+	unsigned int fsm_flag;
+	struct list_head evtq;
+	/* protect evtq */
+	spinlock_t evtq_lock;
+	/* waitq for fsm blocking submit */
+	wait_queue_head_t evt_waitq;
+	/* notifiers before state transition */
+	struct list_head pre_notifiers;
+	/* notifiers after state transition */
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
+int mtk_fsm_pause(struct mtk_md_dev *mdev);
+int mtk_fsm_notifier_register(struct mtk_md_dev *mdev,
+			      enum mtk_user_id id,
+			      void (*cb)(struct mtk_fsm_param *, void *data),
+			      void *data,
+			      enum mtk_fsm_prio prio,
+			      bool is_pre);
+int mtk_fsm_notifier_unregister(struct mtk_md_dev *mdev,
+				enum mtk_user_id id);
+int mtk_fsm_evt_submit(struct mtk_md_dev *mdev,
+		       enum mtk_fsm_evt_id id,
+		       enum mtk_fsm_flag flag,
+		       void *data, unsigned int len,
+		       unsigned char mode);
+
+#endif /* __MTK_FSM_H__ */
diff --git a/drivers/net/wwan/mediatek/mtk_port.c b/drivers/net/wwan/mediatek/mtk_port.c
index c86e4e836c0f..6a7447ab385e 100644
--- a/drivers/net/wwan/mediatek/mtk_port.c
+++ b/drivers/net/wwan/mediatek/mtk_port.c
@@ -14,6 +14,10 @@
 #include "mtk_port.h"
 #include "mtk_port_io.h"
 
+#define MTK_PORT_ENUM_VER			(0)
+/* this is an empirical value, negotiate with device designer */
+#define MTK_PORT_ENUM_HEAD_PATTERN		(0x5a5a5a5a)
+#define MTK_PORT_ENUM_TAIL_PATTERN		(0xa5a5a5a5)
 #define MTK_DFLT_TRB_TIMEOUT			(5 * HZ)
 #define MTK_DFLT_TRB_STATUS			(0x1)
 #define MTK_CHECK_RX_SEQ_MASK			(0x7fff)
@@ -457,8 +461,10 @@ static int mtk_port_open_trb_complete(struct sk_buff *skb)
 	port->rx_mtu = port_mngr->vq_info[trb->vqno].rx_mtu;
 
 	/* Minus the len of the header */
-	port->tx_mtu -= MTK_CCCI_H_ELEN;
-	port->rx_mtu -= MTK_CCCI_H_ELEN;
+	if (!(port->info.flags & PORT_F_RAW_DATA)) {
+		port->tx_mtu -= MTK_CCCI_H_ELEN;
+		port->rx_mtu -= MTK_CCCI_H_ELEN;
+	}
 
 out:
 	wake_up_interruptible_all(&port->trb_wq);
@@ -636,31 +642,36 @@ static int mtk_port_rx_dispatch(struct sk_buff *skb, int len, void *priv)
 	skb_reset_tail_pointer(skb);
 	skb_put(skb, len);
 
-	ccci_h = mtk_port_strip_header(skb);
-	if (unlikely(!ccci_h)) {
-		dev_warn(port_mngr->ctrl_blk->mdev->dev,
-			 "Unsupported: skb length(%d) is less than ccci header\n",
-			 skb->len);
-		goto drop_data;
-	}
+	/* If ccci header field has been loaded in skb data,
+	 * the data should be dispatched by port manager
+	 */
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
 
-	/* The sequence number must be continuous */
-	ret = mtk_port_check_rx_seq(port, ccci_h);
-	if (unlikely(ret))
-		goto drop_data;
+		/* The sequence number must be continuous */
+		ret = mtk_port_check_rx_seq(port, ccci_h);
+		if (unlikely(ret))
+			goto drop_data;
 
-	port->rx_seq = FIELD_GET(MTK_HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+		port->rx_seq = FIELD_GET(MTK_HDR_FLD_SEQ, le32_to_cpu(ccci_h->status));
+	}
 
 	ret = ports_ops[port->info.type]->recv(port, skb);
 
@@ -672,6 +683,61 @@ static int mtk_port_rx_dispatch(struct sk_buff *skb, int len, void *priv)
 	return ret;
 }
 
+static void mtk_port_reset(struct mtk_port_mngr *port_mngr)
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
+			ports_ops[port->info.type]->reset(port);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+}
+
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
 /**
  * mtk_port_add_header() - Add mtk_ccci_header to TX packet.
  * @skb: pointer to socket buffer
@@ -741,6 +807,71 @@ struct mtk_ccci_header *mtk_port_strip_header(struct sk_buff *skb)
 	return ccci_h;
 }
 
+/**
+ * mtk_port_status_update() - Update ports enumeration information.
+ * @mdev: pointer to mtk_md_dev.
+ * @data: pointer to mtk_port_enum_msg, which brings enumeration information.
+ *
+ * This function called when host driver is doing handshake.
+ * Structure mtk_port_enum_msg brings ports' enumeration information
+ * from modem, and this function handles it and set "enable" of mtk_port
+ * to "true" or "false".
+ *
+ * This function can sleep or can be called from interrupt context.
+ *
+ * Return:
+ * * 0:		success to update ports' status
+ * * -EINVAL:	input parameter or members in input structure is illegal
+ */
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
+		goto err;
+	}
+
+	ctrl_blk = mdev->ctrl_blk;
+	port_mngr = ctrl_blk->port_mngr;
+	if (le16_to_cpu(msg->version) != MTK_PORT_ENUM_VER) {
+		ret = -EPROTO;
+		goto err;
+	}
+
+	if (le32_to_cpu(msg->head_pattern) != MTK_PORT_ENUM_HEAD_PATTERN ||
+	    le32_to_cpu(msg->tail_pattern) != MTK_PORT_ENUM_TAIL_PATTERN) {
+		ret = -EPROTO;
+		goto err;
+	}
+
+	for (port_id = 0; port_id < le16_to_cpu(msg->port_cnt); port_id++) {
+		port_info = (struct mtk_port_info *)(msg->data +
+						   (sizeof(*port_info) * port_id));
+		if (!port_info) {
+			dev_err(mdev->dev, "Invalid port info, the index %d\n", port_id);
+			ret = -EINVAL;
+			goto err;
+		}
+		ch_id = FIELD_GET(MTK_INFO_FLD_CHID, le16_to_cpu(port_info->channel));
+		port = mtk_port_search_by_id(port_mngr, ch_id);
+		if (!port) {
+			dev_err(mdev->dev, "Failed to find the port 0x%x\n", ch_id);
+			continue;
+		}
+		port->enable = FIELD_GET(MTK_INFO_FLD_EN, le16_to_cpu(port_info->channel));
+	}
+err:
+	return ret;
+}
+
 /**
  * mtk_port_mngr_vq_status_check() - Checking VQ status before enable or disable VQ.
  * @skb: pointer to socket buffer
@@ -901,6 +1032,146 @@ int mtk_port_vq_disable(struct mtk_port *port)
 	return ret;
 }
 
+static void mtk_port_mngr_vqs_enable(struct mtk_port_mngr *port_mngr)
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
+			port->tx_seq = 0;
+			/* After MDEE, cldma reset rx_seq start at 1, not 0 */
+			port->rx_seq = 0;
+
+			if (!port->enable)
+				continue;
+
+			mtk_port_vq_enable(port);
+			set_bit(PORT_S_RDWR, &port->status);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+}
+
+static void mtk_port_mngr_vqs_disable(struct mtk_port_mngr *port_mngr)
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
+			if (!port->enable)
+				continue;
+
+			/* Disable R/W after VQ close because device is removed suddenly
+			 * or start to sleep.
+			 */
+			mutex_lock(&port->write_lock);
+			clear_bit(PORT_S_RDWR, &port->status);
+			mutex_unlock(&port->write_lock);
+			mtk_port_vq_disable(port);
+		}
+		tbl_type++;
+	} while (tbl_type < PORT_TBL_MAX);
+}
+
+/**
+ * mtk_port_mngr_fsm_state_handler() - Handle fsm event after state has been changed.
+ * @fsm_param: pointer to mtk_fsm_param, which including fsm state and event.
+ * @arg: fsm will pass mtk_port_mngr structure back by using this parameter.
+ *
+ * This function will be registered to fsm by control block. If registered successful,
+ * after fsm state has been changed, the fsm will call this function.
+ *
+ * This function can sleep or can be called from interrupt context.
+ *
+ * Return: No return value.
+ */
+void mtk_port_mngr_fsm_state_handler(struct mtk_fsm_param *fsm_param, void *arg)
+{
+	struct mtk_port_mngr *port_mngr;
+	struct mtk_port *port;
+	int evt_id;
+	int flag;
+
+	if (!fsm_param || !arg) {
+		pr_err("[TMI] Invalid input fsm_param or arg\n");
+		return;
+	}
+
+	port_mngr = arg;
+	evt_id = fsm_param->evt_id;
+	flag = fsm_param->fsm_flag;
+
+	dev_info(port_mngr->ctrl_blk->mdev->dev, "Fsm state %d & fsm flag 0x%x\n",
+		 fsm_param->to, flag);
+
+	switch (fsm_param->to) {
+	case FSM_STATE_ON:
+		if (evt_id == FSM_EVT_REINIT)
+			mtk_port_reset(port_mngr);
+		break;
+	case FSM_STATE_BOOTUP:
+		if (flag & FSM_F_MD_HS_START) {
+			port = mtk_port_search_by_id(port_mngr, CCCI_CONTROL_RX);
+			if (!port) {
+				dev_err(port_mngr->ctrl_blk->mdev->dev,
+					"Failed to find MD ctrl port\n");
+				goto err;
+			}
+			ports_ops[port->info.type]->enable(port);
+		} else if (flag & FSM_F_SAP_HS_START) {
+			port = mtk_port_search_by_id(port_mngr, CCCI_SAP_CONTROL_RX);
+			if (!port) {
+				dev_err(port_mngr->ctrl_blk->mdev->dev,
+					"Failed to find sAP ctrl port\n");
+				goto err;
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
+	case FSM_STATE_MDEE:
+		if (flag & FSM_F_MDEE_INIT) {
+			port = mtk_port_search_by_id(port_mngr, CCCI_CONTROL_RX);
+			if (!port) {
+				dev_err(port_mngr->ctrl_blk->mdev->dev, "Failed to find MD ctrl port\n");
+				goto err;
+			}
+			port->enable = true;
+			ports_ops[port->info.type]->enable(port);
+		} else if (flag & FSM_F_MDEE_CLEARQ_DONE) {
+			/* the time 2000ms recommended by device-end
+			 * it's for wait device prepares the data
+			 */
+			msleep(2000);
+			mtk_port_mngr_vqs_disable(port_mngr);
+		} else if (flag & FSM_F_MDEE_ALLQ_RESET) {
+			mtk_port_mngr_vqs_enable(port_mngr);
+		}
+		break;
+	default:
+		dev_warn(port_mngr->ctrl_blk->mdev->dev,
+			 "Unsupported fsm state %d & fsm flag 0x%x\n", fsm_param->to, flag);
+		break;
+	}
+err:
+	return;
+}
+
 /**
  * mtk_port_mngr_init() - Initialize mtk_port_mngr and mtk_stale_list.
  * @ctrl_blk: pointer to mtk_ctrl_blk.
@@ -910,7 +1181,7 @@ int mtk_port_vq_disable(struct mtk_port *port)
  * and this function alloc memory for it.
  * If port manager can't find stale list in stale list group by
  * using dev_str, it will also alloc memory for structure mtk_stale_list.
- * And then it will initialize port table.
+ * And then it will initialize port table and register fsm callback.
  *
  * Return:
  * * 0:			-success to initialize mtk_port_mngr
diff --git a/drivers/net/wwan/mediatek/mtk_port.h b/drivers/net/wwan/mediatek/mtk_port.h
index 6f591aadb06a..9ab1c392cde9 100644
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
 
@@ -67,6 +69,7 @@ enum mtk_ccci_ch {
 
 enum mtk_port_flag {
 	PORT_F_DFLT = 0,
+	PORT_F_RAW_DATA = BIT(0),
 	PORT_F_BLOCKING = BIT(1),
 	PORT_F_ALLOW_DROP = BIT(2),
 };
@@ -89,9 +92,11 @@ struct mtk_internal_port {
 
 /**
  * union mtk_port_priv - Contains private data for different type of ports.
+ * @cdev: private data for character device port.
  * @i_priv: private data for internal other user.
  */
 union mtk_port_priv {
+	struct cdev *cdev;
 	struct mtk_internal_port i_priv;
 };
 
@@ -219,8 +224,10 @@ void mtk_port_stale_list_grp_cleanup(void);
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
index 2fd681eed9c8..050ec0a1bb04 100644
--- a/drivers/net/wwan/mediatek/mtk_port_io.c
+++ b/drivers/net/wwan/mediatek/mtk_port_io.c
@@ -205,10 +205,7 @@ void *mtk_port_internal_open(struct mtk_md_dev *mdev, char *name, int flag)
 		goto err;
 	}
 
-	if (flag & O_NONBLOCK)
-		port->info.flags &= ~PORT_F_BLOCKING;
-	else
-		port->info.flags |= PORT_F_BLOCKING;
+	port->info.flags |= PORT_F_BLOCKING;
 err:
 	return port;
 }
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
index bd9a7a7bf18f..06c84afbd9ee 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.c
@@ -937,3 +937,48 @@ int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno)
 
 	return 0;
 }
+
+static void mtk_cldma_hw_reset(struct mtk_md_dev *mdev, int hif_id)
+{
+	u32 val = mtk_hw_read32(mdev, REG_DEV_INFRA_BASE + REG_INFRA_RST0_SET);
+
+	val |= (REG_CLDMA0_RST_SET_BIT + hif_id);
+	mtk_hw_write32(mdev, REG_DEV_INFRA_BASE + REG_INFRA_RST0_SET, val);
+
+	val = mtk_hw_read32(mdev, REG_DEV_INFRA_BASE + REG_INFRA_RST0_CLR);
+	val |= (REG_CLDMA0_RST_CLR_BIT + hif_id);
+	mtk_hw_write32(mdev, REG_DEV_INFRA_BASE + REG_INFRA_RST0_CLR, val);
+}
+
+void mtk_cldma_fsm_state_listener_t800(struct mtk_fsm_param *param, struct cldma_hw *hw)
+{
+	struct txq *txq;
+	int i;
+
+	if (!param || !hw)
+		return;
+
+	if (param->to == FSM_STATE_MDEE) {
+		if (param->fsm_flag & FSM_F_MDEE_INIT) {
+			mtk_cldma_stop_queue(hw->mdev, hw->base_addr, DIR_TX, ALLQ);
+			for (i = 0; i < HW_QUEUE_NUM; i++) {
+				txq = hw->txq[i];
+				if (txq)
+					txq->is_stopping = true;
+			}
+		} else if (param->fsm_flag & FSM_F_MDEE_CLEARQ_DONE) {
+			mtk_cldma_hw_reset(hw->mdev, hw->hif_id);
+		} else if (param->fsm_flag & FSM_F_MDEE_ALLQ_RESET) {
+			mtk_cldma_hw_init(hw->mdev, hw->base_addr);
+			for (i = 0; i < HW_QUEUE_NUM; i++) {
+				txq = hw->txq[i];
+				if (txq)
+					txq->is_stopping = false;
+			}
+			/* After leaving lowpower L2 states, PCIe will reset,
+			 * so CLDMA L1 register needs to be set again.
+			 */
+			mtk_hw_unmask_irq(hw->mdev, hw->pci_ext_irq_id);
+		}
+	}
+}
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
index b89d45a81c4f..470a40015f77 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
+++ b/drivers/net/wwan/mediatek/pcie/mtk_cldma_drv_t800.h
@@ -9,6 +9,7 @@
 #include <linux/skbuff.h>
 
 #include "mtk_cldma.h"
+#include "mtk_fsm.h"
 
 int mtk_cldma_hw_init_t800(struct cldma_dev *cd, int hif_id);
 int mtk_cldma_hw_exit_t800(struct cldma_dev *cd, int hif_id);
@@ -17,4 +18,5 @@ int mtk_cldma_txq_free_t800(struct cldma_hw *hw, int vqno);
 struct rxq *mtk_cldma_rxq_alloc_t800(struct cldma_hw *hw, struct sk_buff *skb);
 int mtk_cldma_rxq_free_t800(struct cldma_hw *hw, int vqno);
 int mtk_cldma_start_xfer_t800(struct cldma_hw *hw, int qno);
+void mtk_cldma_fsm_state_listener_t800(struct mtk_fsm_param *param, struct cldma_hw *hw);
 #endif
diff --git a/drivers/net/wwan/mediatek/pcie/mtk_pci.c b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
index 326b1e0b845c..5a821e55771f 100644
--- a/drivers/net/wwan/mediatek/pcie/mtk_pci.c
+++ b/drivers/net/wwan/mediatek/pcie/mtk_pci.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include "mtk_fsm.h"
 #include "mtk_pci.h"
 #include "mtk_port_io.h"
 #include "mtk_reg.h"
@@ -1031,9 +1032,16 @@ static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_save_state;
 	}
 
+	ret = mtk_dev_start(mdev);
+	if (ret) {
+		dev_err(mdev->dev, "Failed to start dev.\n");
+		goto err_dev_start;
+	}
 	dev_info(mdev->dev, "Probe done hw_ver=0x%x\n", mdev->hw_ver);
 	return 0;
 
+err_dev_start:
+	pci_load_and_free_saved_state(pdev, &priv->saved_state);
 err_save_state:
 	pci_disable_pcie_error_reporting(pdev);
 	pci_clear_master(pdev);
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

