Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321687F68A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388834AbfHBMK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:10:27 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39673 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729980AbfHBMK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:10:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so33624049pls.6;
        Fri, 02 Aug 2019 05:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pZ90nECOiZ+MBp6n218gSUUPL3dRz+oX6/yZLA6xm6g=;
        b=nO3LMnE0jpH/uJ4SdYblGBhaKfbqm6pj0tUmJWOIiLw88bTYTVY6Za7VwmyQzhGWVO
         iaYdHWKd3BVEDnnnWrl9bT6pXNwel4cewK6eicapodyUgKK05aurNtkm7EJbi0ZSXdx1
         Moy2kHKmVX+6Fat9ySBeOKyYkBVuIPWB1wTPii/NXFq/Fro5iKgZs5Axg18DxDNHM75J
         Sih+vMpcLd7rpGhN06f0z+xWQog0Nl4ndgzwSKRnAMJmTNGG46TxfSL4H5p7mAOmwp5X
         4kyLBuq8rs/sIS1axIHgumGfceyh/E6qNJ43DMVgG36tjH9NAgUcIZGt99TAfUARCbhZ
         DDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pZ90nECOiZ+MBp6n218gSUUPL3dRz+oX6/yZLA6xm6g=;
        b=K7i+tOZu6z5rXevO1w9v+9osKujOJcuMgXpnJedfwFi1lho4nELNSFK3FB4IHPTJgO
         y6Afgjlx9FcOis4jLO8ynCvHHIslG3RrHtohWQnvsvc5sv72wq4OJeBKx7wfENQFLdEz
         +EOfgl14OlwG2S8s9K+/6Jbhms+cKgKUmPfWpoaiijgeUQ00WZUFho51W8nRNb/qNyh3
         vouhPX0eeAJ14Zs/b9H9qjzXrUcapD9fDWnFcrfAyiue/jD/GF+27mML6wkwNIyIvY92
         eRIT6lZa6hNvxVgzrAaCZDICri4ugr2GPQZW1ZxB+wKQ9RqfSMIAdAfPaBhWWHTeUtyp
         bSUw==
X-Gm-Message-State: APjAAAVGSXF+NrIa2biiTxHQO9Ibr3AJ7LjQkOsTATOk+Ct2VrxrShES
        8u5/z+zR6dsuO3Dv2tSMSDYVJcQLpa7cbg==
X-Google-Smtp-Source: APXvYqza0I53SHNcmsIKVmM/993aRE1GGZu0Br/N8gLDT8bMinzCat0AygBR0igUCoiRc1/IRtJXEQ==
X-Received: by 2002:a17:902:e281:: with SMTP id cf1mr126916954plb.271.1564747825815;
        Fri, 02 Aug 2019 05:10:25 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id 131sm7563296pge.37.2019.08.02.05.10.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:10:24 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net/mlx4_core: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 20:10:20 +0800
Message-Id: <20190802121020.1181-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Also convert refcount from 0-based to 1-based.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 .../ethernet/mellanox/mlx4/resource_tracker.c | 90 +++++++++----------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 4356f3a58002..d7e26935fd76 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -114,7 +114,7 @@ struct res_qp {
 	struct list_head	mcg_list;
 	spinlock_t		mcg_spl;
 	int			local_qpn;
-	atomic_t		ref_count;
+	refcount_t		ref_count;
 	u32			qpc_flags;
 	/* saved qp params before VST enforcement in order to restore on VGT */
 	u8			sched_queue;
@@ -143,7 +143,7 @@ static inline const char *mtt_states_str(enum res_mtt_states state)
 struct res_mtt {
 	struct res_common	com;
 	int			order;
-	atomic_t		ref_count;
+	refcount_t		ref_count;
 };
 
 enum res_mpt_states {
@@ -179,7 +179,7 @@ enum res_cq_states {
 struct res_cq {
 	struct res_common	com;
 	struct res_mtt	       *mtt;
-	atomic_t		ref_count;
+	refcount_t		ref_count;
 };
 
 enum res_srq_states {
@@ -192,7 +192,7 @@ struct res_srq {
 	struct res_common	com;
 	struct res_mtt	       *mtt;
 	struct res_cq	       *cq;
-	atomic_t		ref_count;
+	refcount_t		ref_count;
 };
 
 enum res_counter_states {
@@ -1050,7 +1050,7 @@ static struct res_common *alloc_qp_tr(int id)
 	ret->local_qpn = id;
 	INIT_LIST_HEAD(&ret->mcg_list);
 	spin_lock_init(&ret->mcg_spl);
-	atomic_set(&ret->ref_count, 0);
+	refcount_set(&ret->ref_count, 1);
 
 	return &ret->com;
 }
@@ -1066,7 +1066,7 @@ static struct res_common *alloc_mtt_tr(int id, int order)
 	ret->com.res_id = id;
 	ret->order = order;
 	ret->com.state = RES_MTT_ALLOCATED;
-	atomic_set(&ret->ref_count, 0);
+	refcount_set(&ret->ref_count, 1);
 
 	return &ret->com;
 }
@@ -1110,7 +1110,7 @@ static struct res_common *alloc_cq_tr(int id)
 
 	ret->com.res_id = id;
 	ret->com.state = RES_CQ_ALLOCATED;
-	atomic_set(&ret->ref_count, 0);
+	refcount_set(&ret->ref_count, 1);
 
 	return &ret->com;
 }
@@ -1125,7 +1125,7 @@ static struct res_common *alloc_srq_tr(int id)
 
 	ret->com.res_id = id;
 	ret->com.state = RES_SRQ_ALLOCATED;
-	atomic_set(&ret->ref_count, 0);
+	refcount_set(&ret->ref_count, 1);
 
 	return &ret->com;
 }
@@ -1325,10 +1325,10 @@ static int add_res_range(struct mlx4_dev *dev, int slave, u64 base, int count,
 
 static int remove_qp_ok(struct res_qp *res)
 {
-	if (res->com.state == RES_QP_BUSY || atomic_read(&res->ref_count) ||
+	if (res->com.state == RES_QP_BUSY || refcount_read(&res->ref_count) != 1 ||
 	    !list_empty(&res->mcg_list)) {
 		pr_err("resource tracker: fail to remove qp, state %d, ref_count %d\n",
-		       res->com.state, atomic_read(&res->ref_count));
+		       res->com.state, refcount_read(&res->ref_count));
 		return -EBUSY;
 	} else if (res->com.state != RES_QP_RESERVED) {
 		return -EPERM;
@@ -1340,11 +1340,11 @@ static int remove_qp_ok(struct res_qp *res)
 static int remove_mtt_ok(struct res_mtt *res, int order)
 {
 	if (res->com.state == RES_MTT_BUSY ||
-	    atomic_read(&res->ref_count)) {
+	    refcount_read(&res->ref_count) != 1) {
 		pr_devel("%s-%d: state %s, ref_count %d\n",
 			 __func__, __LINE__,
 			 mtt_states_str(res->com.state),
-			 atomic_read(&res->ref_count));
+			 refcount_read(&res->ref_count));
 		return -EBUSY;
 	} else if (res->com.state != RES_MTT_ALLOCATED)
 		return -EPERM;
@@ -1675,7 +1675,7 @@ static int cq_res_start_move_to(struct mlx4_dev *dev, int slave, int cqn,
 	} else if (state == RES_CQ_ALLOCATED) {
 		if (r->com.state != RES_CQ_HW)
 			err = -EINVAL;
-		else if (atomic_read(&r->ref_count))
+		else if (refcount_read(&r->ref_count) != 1)
 			err = -EBUSY;
 		else
 			err = 0;
@@ -1715,7 +1715,7 @@ static int srq_res_start_move_to(struct mlx4_dev *dev, int slave, int index,
 	} else if (state == RES_SRQ_ALLOCATED) {
 		if (r->com.state != RES_SRQ_HW)
 			err = -EINVAL;
-		else if (atomic_read(&r->ref_count))
+		else if (refcount_read(&r->ref_count) != 1)
 			err = -EBUSY;
 	} else if (state != RES_SRQ_HW || r->com.state != RES_SRQ_ALLOCATED) {
 		err = -EINVAL;
@@ -2808,7 +2808,7 @@ int mlx4_SW2HW_MPT_wrapper(struct mlx4_dev *dev, int slave,
 		goto ex_put;
 
 	if (!phys) {
-		atomic_inc(&mtt->ref_count);
+		refcount_inc(&mtt->ref_count);
 		put_res(dev, slave, mtt->com.res_id, RES_MTT);
 	}
 
@@ -2845,7 +2845,7 @@ int mlx4_HW2SW_MPT_wrapper(struct mlx4_dev *dev, int slave,
 		goto ex_abort;
 
 	if (mpt->mtt)
-		atomic_dec(&mpt->mtt->ref_count);
+		refcount_dec(&mpt->mtt->ref_count);
 
 	res_end_move(dev, slave, RES_MPT, id);
 	return 0;
@@ -3007,18 +3007,18 @@ int mlx4_RST2INIT_QP_wrapper(struct mlx4_dev *dev, int slave,
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 	if (err)
 		goto ex_put_srq;
-	atomic_inc(&mtt->ref_count);
+	refcount_inc(&mtt->ref_count);
 	qp->mtt = mtt;
-	atomic_inc(&rcq->ref_count);
+	refcount_inc(&rcq->ref_count);
 	qp->rcq = rcq;
-	atomic_inc(&scq->ref_count);
+	refcount_inc(&scq->ref_count);
 	qp->scq = scq;
 
 	if (scqn != rcqn)
 		put_res(dev, slave, scqn, RES_CQ);
 
 	if (use_srq) {
-		atomic_inc(&srq->ref_count);
+		refcount_inc(&srq->ref_count);
 		put_res(dev, slave, srqn, RES_SRQ);
 		qp->srq = srq;
 	}
@@ -3113,7 +3113,7 @@ int mlx4_SW2HW_EQ_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		goto out_put;
 
-	atomic_inc(&mtt->ref_count);
+	refcount_inc(&mtt->ref_count);
 	eq->mtt = mtt;
 	put_res(dev, slave, mtt->com.res_id, RES_MTT);
 	res_end_move(dev, slave, RES_EQ, res_id);
@@ -3310,7 +3310,7 @@ int mlx4_HW2SW_EQ_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		goto ex_put;
 
-	atomic_dec(&eq->mtt->ref_count);
+	refcount_dec(&eq->mtt->ref_count);
 	put_res(dev, slave, eq->mtt->com.res_id, RES_MTT);
 	res_end_move(dev, slave, RES_EQ, res_id);
 	rem_res_range(dev, slave, res_id, 1, RES_EQ, 0);
@@ -3445,7 +3445,7 @@ int mlx4_SW2HW_CQ_wrapper(struct mlx4_dev *dev, int slave,
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 	if (err)
 		goto out_put;
-	atomic_inc(&mtt->ref_count);
+	refcount_inc(&mtt->ref_count);
 	cq->mtt = mtt;
 	put_res(dev, slave, mtt->com.res_id, RES_MTT);
 	res_end_move(dev, slave, RES_CQ, cqn);
@@ -3474,7 +3474,7 @@ int mlx4_HW2SW_CQ_wrapper(struct mlx4_dev *dev, int slave,
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 	if (err)
 		goto out_move;
-	atomic_dec(&cq->mtt->ref_count);
+	refcount_dec(&cq->mtt->ref_count);
 	res_end_move(dev, slave, RES_CQ, cqn);
 	return 0;
 
@@ -3539,9 +3539,9 @@ static int handle_resize(struct mlx4_dev *dev, int slave,
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 	if (err)
 		goto ex_put1;
-	atomic_dec(&orig_mtt->ref_count);
+	refcount_dec(&orig_mtt->ref_count);
 	put_res(dev, slave, orig_mtt->com.res_id, RES_MTT);
-	atomic_inc(&mtt->ref_count);
+	refcount_inc(&mtt->ref_count);
 	cq->mtt = mtt;
 	put_res(dev, slave, mtt->com.res_id, RES_MTT);
 	return 0;
@@ -3627,7 +3627,7 @@ int mlx4_SW2HW_SRQ_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		goto ex_put_mtt;
 
-	atomic_inc(&mtt->ref_count);
+	refcount_inc(&mtt->ref_count);
 	srq->mtt = mtt;
 	put_res(dev, slave, mtt->com.res_id, RES_MTT);
 	res_end_move(dev, slave, RES_SRQ, srqn);
@@ -3657,9 +3657,9 @@ int mlx4_HW2SW_SRQ_wrapper(struct mlx4_dev *dev, int slave,
 	err = mlx4_DMA_wrapper(dev, slave, vhcr, inbox, outbox, cmd);
 	if (err)
 		goto ex_abort;
-	atomic_dec(&srq->mtt->ref_count);
+	refcount_dec(&srq->mtt->ref_count);
 	if (srq->cq)
-		atomic_dec(&srq->cq->ref_count);
+		refcount_dec(&srq->cq->ref_count);
 	res_end_move(dev, slave, RES_SRQ, srqn);
 
 	return 0;
@@ -3988,11 +3988,11 @@ int mlx4_2RST_QP_wrapper(struct mlx4_dev *dev, int slave,
 	if (err)
 		goto ex_abort;
 
-	atomic_dec(&qp->mtt->ref_count);
-	atomic_dec(&qp->rcq->ref_count);
-	atomic_dec(&qp->scq->ref_count);
+	refcount_dec(&qp->mtt->ref_count);
+	refcount_dec(&qp->rcq->ref_count);
+	refcount_dec(&qp->scq->ref_count);
 	if (qp->srq)
-		atomic_dec(&qp->srq->ref_count);
+		refcount_dec(&qp->srq->ref_count);
 	res_end_move(dev, slave, RES_QP, qpn);
 	return 0;
 
@@ -4456,7 +4456,7 @@ int mlx4_QP_FLOW_STEERING_ATTACH_wrapper(struct mlx4_dev *dev, int slave,
 	if (mlx4_is_bonded(dev))
 		mlx4_do_mirror_rule(dev, rrule);
 
-	atomic_inc(&rqp->ref_count);
+	refcount_inc(&rqp->ref_count);
 
 err_put_rule:
 	put_res(dev, slave, vhcr->out_param, RES_FS_RULE);
@@ -4540,7 +4540,7 @@ int mlx4_QP_FLOW_STEERING_DETACH_wrapper(struct mlx4_dev *dev, int slave,
 		       MLX4_QP_FLOW_STEERING_DETACH, MLX4_CMD_TIME_CLASS_A,
 		       MLX4_CMD_NATIVE);
 	if (!err)
-		atomic_dec(&rqp->ref_count);
+		refcount_dec(&rqp->ref_count);
 out:
 	put_res(dev, slave, qpn, RES_QP);
 	return err;
@@ -4702,11 +4702,11 @@ static void rem_slave_qps(struct mlx4_dev *dev, int slave)
 					if (err)
 						mlx4_dbg(dev, "rem_slave_qps: failed to move slave %d qpn %d to reset\n",
 							 slave, qp->local_qpn);
-					atomic_dec(&qp->rcq->ref_count);
-					atomic_dec(&qp->scq->ref_count);
-					atomic_dec(&qp->mtt->ref_count);
+					refcount_dec(&qp->rcq->ref_count);
+					refcount_dec(&qp->scq->ref_count);
+					refcount_dec(&qp->mtt->ref_count);
 					if (qp->srq)
-						atomic_dec(&qp->srq->ref_count);
+						refcount_dec(&qp->srq->ref_count);
 					state = RES_QP_MAPPED;
 					break;
 				default:
@@ -4768,9 +4768,9 @@ static void rem_slave_srqs(struct mlx4_dev *dev, int slave)
 						mlx4_dbg(dev, "rem_slave_srqs: failed to move slave %d srq %d to SW ownership\n",
 							 slave, srqn);
 
-					atomic_dec(&srq->mtt->ref_count);
+					refcount_dec(&srq->mtt->ref_count);
 					if (srq->cq)
-						atomic_dec(&srq->cq->ref_count);
+						refcount_dec(&srq->cq->ref_count);
 					state = RES_SRQ_ALLOCATED;
 					break;
 
@@ -4805,7 +4805,7 @@ static void rem_slave_cqs(struct mlx4_dev *dev, int slave)
 	spin_lock_irq(mlx4_tlock(dev));
 	list_for_each_entry_safe(cq, tmp, cq_list, com.list) {
 		spin_unlock_irq(mlx4_tlock(dev));
-		if (cq->com.owner == slave && !atomic_read(&cq->ref_count)) {
+		if (cq->com.owner == slave && refcount_read(&cq->ref_count) == 1) {
 			cqn = cq->com.res_id;
 			state = cq->com.from_state;
 			while (state != 0) {
@@ -4832,7 +4832,7 @@ static void rem_slave_cqs(struct mlx4_dev *dev, int slave)
 					if (err)
 						mlx4_dbg(dev, "rem_slave_cqs: failed to move slave %d cq %d to SW ownership\n",
 							 slave, cqn);
-					atomic_dec(&cq->mtt->ref_count);
+					refcount_dec(&cq->mtt->ref_count);
 					state = RES_CQ_ALLOCATED;
 					break;
 
@@ -4900,7 +4900,7 @@ static void rem_slave_mrs(struct mlx4_dev *dev, int slave)
 						mlx4_dbg(dev, "rem_slave_mrs: failed to move slave %d mpt %d to SW ownership\n",
 							 slave, mptn);
 					if (mpt->mtt)
-						atomic_dec(&mpt->mtt->ref_count);
+						refcount_dec(&mpt->mtt->ref_count);
 					state = RES_MPT_MAPPED;
 					break;
 				default:
@@ -5144,7 +5144,7 @@ static void rem_slave_eqs(struct mlx4_dev *dev, int slave)
 					if (err)
 						mlx4_dbg(dev, "rem_slave_eqs: failed to move slave %d eqs %d to SW ownership\n",
 							 slave, eqn & 0x3ff);
-					atomic_dec(&eq->mtt->ref_count);
+					refcount_dec(&eq->mtt->ref_count);
 					state = RES_EQ_RESERVED;
 					break;
 
-- 
2.20.1

