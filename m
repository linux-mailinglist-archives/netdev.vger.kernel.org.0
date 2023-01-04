Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E8565CFD9
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 10:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbjADJnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 04:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjADJnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 04:43:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8361006F;
        Wed,  4 Jan 2023 01:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB02A61638;
        Wed,  4 Jan 2023 09:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF204C433EF;
        Wed,  4 Jan 2023 09:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672825427;
        bh=8889hpc00KYM5opGbaCqhb7k5Gn9PNfLadr2oKeFiFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUvy9ImUKm5+b1wVwXAnAZJVim1WgHlETXBBq+zyM2GEgmCezzH6Q3EJ/An6aBQQC
         XzQxYOcnYE6yOF5holganol2tI2J1yVY/itjn6mj/oX4C0DilGX7L7TaWoro3CpSzG
         CLd7I/k9XKUmEtfKQVsxucCspt5QuNMxytITsL9rUTF8TRdEZO0r9i3IKqB0Vn8Dcr
         BRBhqMOTDkrXhoZq+5LctYeTKNpLt10D8wDKPOzDlnZRlLPMRuwUhsFfMfJhWJRZeD
         KvB08BMkLZ97CHCrLOpUsNeU2Vsoa/48ZAwuBY3wHHkBSSRHORtNwfLDBDXep19Tr+
         hGz+ep3B2LYwg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Zhang <markzhang@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next v1 1/3] RDMA/mlx: Calling qp event handler in workqueue context
Date:   Wed,  4 Jan 2023 11:43:34 +0200
Message-Id: <0cd17b8331e445f03942f4bb28d447f24ac5669d.1672821186.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672821186.git.leonro@nvidia.com>
References: <cover.1672821186.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Move the call of qp event handler from atomic to workqueue context,
so that the handler is able to block. This is needed by following
patches.

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx4/main.c       |   8 ++
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |   3 +
 drivers/infiniband/hw/mlx4/qp.c         | 121 +++++++++++++++++-------
 drivers/infiniband/hw/mlx5/main.c       |   7 ++
 drivers/infiniband/hw/mlx5/qp.c         | 119 ++++++++++++++++-------
 drivers/infiniband/hw/mlx5/qp.h         |   2 +
 drivers/infiniband/hw/mlx5/qpc.c        |   3 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c |  14 ++-
 include/linux/mlx4/qp.h                 |   1 +
 include/rdma/ib_verbs.h                 |   2 +-
 10 files changed, 202 insertions(+), 78 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index dceebcd885bb..b18e9f2adc82 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3303,6 +3303,10 @@ static int __init mlx4_ib_init(void)
 	if (!wq)
 		return -ENOMEM;
 
+	err = mlx4_ib_qp_event_init();
+	if (err)
+		goto clean_qp_event;
+
 	err = mlx4_ib_cm_init();
 	if (err)
 		goto clean_wq;
@@ -3324,6 +3328,9 @@ static int __init mlx4_ib_init(void)
 	mlx4_ib_cm_destroy();
 
 clean_wq:
+	mlx4_ib_qp_event_cleanup();
+
+clean_qp_event:
 	destroy_workqueue(wq);
 	return err;
 }
@@ -3333,6 +3340,7 @@ static void __exit mlx4_ib_cleanup(void)
 	mlx4_unregister_interface(&mlx4_ib_interface);
 	mlx4_ib_mcg_destroy();
 	mlx4_ib_cm_destroy();
+	mlx4_ib_qp_event_cleanup();
 	destroy_workqueue(wq);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6a3b0f121045..17fee1e73a45 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -940,4 +940,7 @@ int mlx4_ib_umem_calc_optimal_mtt_size(struct ib_umem *umem, u64 start_va,
 int mlx4_ib_cm_init(void);
 void mlx4_ib_cm_destroy(void);
 
+int mlx4_ib_qp_event_init(void);
+void mlx4_ib_qp_event_cleanup(void);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index b17d6ebc5b70..884825b2e5f7 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -102,6 +102,14 @@ enum mlx4_ib_source_type {
 	MLX4_IB_RWQ_SRC	= 1,
 };
 
+struct mlx4_ib_qp_event_work {
+	struct work_struct work;
+	struct mlx4_qp *qp;
+	enum mlx4_event type;
+};
+
+static struct workqueue_struct *mlx4_ib_qp_event_wq;
+
 static int is_tunnel_qp(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 {
 	if (!mlx4_is_master(dev->dev))
@@ -200,50 +208,77 @@ static void stamp_send_wqe(struct mlx4_ib_qp *qp, int n)
 	}
 }
 
+static void mlx4_ib_handle_qp_event(struct work_struct *_work)
+{
+	struct mlx4_ib_qp_event_work *qpe_work =
+		container_of(_work, struct mlx4_ib_qp_event_work, work);
+	struct ib_qp *ibqp = &to_mibqp(qpe_work->qp)->ibqp;
+	struct ib_event event = {};
+
+	event.device = ibqp->device;
+	event.element.qp = ibqp;
+
+	switch (qpe_work->type) {
+	case MLX4_EVENT_TYPE_PATH_MIG:
+		event.event = IB_EVENT_PATH_MIG;
+		break;
+	case MLX4_EVENT_TYPE_COMM_EST:
+		event.event = IB_EVENT_COMM_EST;
+		break;
+	case MLX4_EVENT_TYPE_SQ_DRAINED:
+		event.event = IB_EVENT_SQ_DRAINED;
+		break;
+	case MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE:
+		event.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		break;
+	case MLX4_EVENT_TYPE_WQ_CATAS_ERROR:
+		event.event = IB_EVENT_QP_FATAL;
+		break;
+	case MLX4_EVENT_TYPE_PATH_MIG_FAILED:
+		event.event = IB_EVENT_PATH_MIG_ERR;
+		break;
+	case MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		event.event = IB_EVENT_QP_REQ_ERR;
+		break;
+	case MLX4_EVENT_TYPE_WQ_ACCESS_ERROR:
+		event.event = IB_EVENT_QP_ACCESS_ERR;
+		break;
+	default:
+		pr_warn("Unexpected event type %d on QP %06x\n",
+			qpe_work->type, qpe_work->qp->qpn);
+		goto out;
+	}
+
+	ibqp->event_handler(&event, ibqp->qp_context);
+
+out:
+	mlx4_put_qp(qpe_work->qp);
+	kfree(qpe_work);
+}
+
 static void mlx4_ib_qp_event(struct mlx4_qp *qp, enum mlx4_event type)
 {
-	struct ib_event event;
 	struct ib_qp *ibqp = &to_mibqp(qp)->ibqp;
+	struct mlx4_ib_qp_event_work *qpe_work;
 
 	if (type == MLX4_EVENT_TYPE_PATH_MIG)
 		to_mibqp(qp)->port = to_mibqp(qp)->alt_port;
 
-	if (ibqp->event_handler) {
-		event.device     = ibqp->device;
-		event.element.qp = ibqp;
-		switch (type) {
-		case MLX4_EVENT_TYPE_PATH_MIG:
-			event.event = IB_EVENT_PATH_MIG;
-			break;
-		case MLX4_EVENT_TYPE_COMM_EST:
-			event.event = IB_EVENT_COMM_EST;
-			break;
-		case MLX4_EVENT_TYPE_SQ_DRAINED:
-			event.event = IB_EVENT_SQ_DRAINED;
-			break;
-		case MLX4_EVENT_TYPE_SRQ_QP_LAST_WQE:
-			event.event = IB_EVENT_QP_LAST_WQE_REACHED;
-			break;
-		case MLX4_EVENT_TYPE_WQ_CATAS_ERROR:
-			event.event = IB_EVENT_QP_FATAL;
-			break;
-		case MLX4_EVENT_TYPE_PATH_MIG_FAILED:
-			event.event = IB_EVENT_PATH_MIG_ERR;
-			break;
-		case MLX4_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
-			event.event = IB_EVENT_QP_REQ_ERR;
-			break;
-		case MLX4_EVENT_TYPE_WQ_ACCESS_ERROR:
-			event.event = IB_EVENT_QP_ACCESS_ERR;
-			break;
-		default:
-			pr_warn("Unexpected event type %d "
-			       "on QP %06x\n", type, qp->qpn);
-			return;
-		}
+	if (!ibqp->event_handler)
+		goto out_no_handler;
 
-		ibqp->event_handler(&event, ibqp->qp_context);
-	}
+	qpe_work = kzalloc(sizeof(*qpe_work), GFP_ATOMIC);
+	if (!qpe_work)
+		goto out_no_handler;
+
+	qpe_work->qp = qp;
+	qpe_work->type = type;
+	INIT_WORK(&qpe_work->work, mlx4_ib_handle_qp_event);
+	queue_work(mlx4_ib_qp_event_wq, &qpe_work->work);
+	return;
+
+out_no_handler:
+	mlx4_put_qp(qp);
 }
 
 static void mlx4_ib_wq_event(struct mlx4_qp *qp, enum mlx4_event type)
@@ -4468,3 +4503,17 @@ void mlx4_ib_drain_rq(struct ib_qp *qp)
 
 	handle_drain_completion(cq, &rdrain, dev);
 }
+
+int mlx4_ib_qp_event_init(void)
+{
+	mlx4_ib_qp_event_wq = alloc_ordered_workqueue("mlx4_ib_qp_event_wq", 0);
+	if (!mlx4_ib_qp_event_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx4_ib_qp_event_cleanup(void)
+{
+	destroy_workqueue(mlx4_ib_qp_event_wq);
+}
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 12e8bf99a40e..4b98e35a929e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4403,6 +4403,10 @@ static int __init mlx5_ib_init(void)
 		return -ENOMEM;
 	}
 
+	ret = mlx5_ib_qp_event_init();
+	if (ret)
+		goto qp_event_err;
+
 	mlx5_ib_odp_init();
 	ret = mlx5r_rep_init();
 	if (ret)
@@ -4420,6 +4424,8 @@ static int __init mlx5_ib_init(void)
 mp_err:
 	mlx5r_rep_cleanup();
 rep_err:
+	mlx5_ib_qp_event_cleanup();
+qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
 	free_page((unsigned long)xlt_emergency_page);
 	return ret;
@@ -4431,6 +4437,7 @@ static void __exit mlx5_ib_cleanup(void)
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
 
+	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
 	free_page((unsigned long)xlt_emergency_page);
 }
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0d2374a04064..b22d95b448ac 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -71,6 +71,14 @@ struct mlx5_modify_raw_qp_param {
 	u32 port;
 };
 
+struct mlx5_ib_qp_event_work {
+	struct work_struct work;
+	struct mlx5_core_qp *qp;
+	int type;
+};
+
+static struct workqueue_struct *mlx5_ib_qp_event_wq;
+
 static void get_cqs(enum ib_qp_type qp_type,
 		    struct ib_cq *ib_send_cq, struct ib_cq *ib_recv_cq,
 		    struct mlx5_ib_cq **send_cq, struct mlx5_ib_cq **recv_cq);
@@ -302,51 +310,78 @@ int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
 	return mlx5_ib_read_user_wqe_srq(srq, wqe_index, buffer, buflen, bc);
 }
 
+static void mlx5_ib_handle_qp_event(struct work_struct *_work)
+{
+	struct mlx5_ib_qp_event_work *qpe_work =
+		container_of(_work, struct mlx5_ib_qp_event_work, work);
+	struct ib_qp *ibqp = &to_mibqp(qpe_work->qp)->ibqp;
+	struct ib_event event = {};
+
+	event.device = ibqp->device;
+	event.element.qp = ibqp;
+	switch (qpe_work->type) {
+	case MLX5_EVENT_TYPE_PATH_MIG:
+		event.event = IB_EVENT_PATH_MIG;
+		break;
+	case MLX5_EVENT_TYPE_COMM_EST:
+		event.event = IB_EVENT_COMM_EST;
+		break;
+	case MLX5_EVENT_TYPE_SQ_DRAINED:
+		event.event = IB_EVENT_SQ_DRAINED;
+		break;
+	case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
+		event.event = IB_EVENT_QP_LAST_WQE_REACHED;
+		break;
+	case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
+		event.event = IB_EVENT_QP_FATAL;
+		break;
+	case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
+		event.event = IB_EVENT_PATH_MIG_ERR;
+		break;
+	case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
+		event.event = IB_EVENT_QP_REQ_ERR;
+		break;
+	case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
+		event.event = IB_EVENT_QP_ACCESS_ERR;
+		break;
+	default:
+		pr_warn("mlx5_ib: Unexpected event type %d on QP %06x\n",
+			qpe_work->type, qpe_work->qp->qpn);
+		goto out;
+	}
+
+	ibqp->event_handler(&event, ibqp->qp_context);
+
+out:
+	mlx5_core_res_put(&qpe_work->qp->common);
+	kfree(qpe_work);
+}
+
 static void mlx5_ib_qp_event(struct mlx5_core_qp *qp, int type)
 {
 	struct ib_qp *ibqp = &to_mibqp(qp)->ibqp;
-	struct ib_event event;
+	struct mlx5_ib_qp_event_work *qpe_work;
 
 	if (type == MLX5_EVENT_TYPE_PATH_MIG) {
 		/* This event is only valid for trans_qps */
 		to_mibqp(qp)->port = to_mibqp(qp)->trans_qp.alt_port;
 	}
 
-	if (ibqp->event_handler) {
-		event.device     = ibqp->device;
-		event.element.qp = ibqp;
-		switch (type) {
-		case MLX5_EVENT_TYPE_PATH_MIG:
-			event.event = IB_EVENT_PATH_MIG;
-			break;
-		case MLX5_EVENT_TYPE_COMM_EST:
-			event.event = IB_EVENT_COMM_EST;
-			break;
-		case MLX5_EVENT_TYPE_SQ_DRAINED:
-			event.event = IB_EVENT_SQ_DRAINED;
-			break;
-		case MLX5_EVENT_TYPE_SRQ_LAST_WQE:
-			event.event = IB_EVENT_QP_LAST_WQE_REACHED;
-			break;
-		case MLX5_EVENT_TYPE_WQ_CATAS_ERROR:
-			event.event = IB_EVENT_QP_FATAL;
-			break;
-		case MLX5_EVENT_TYPE_PATH_MIG_FAILED:
-			event.event = IB_EVENT_PATH_MIG_ERR;
-			break;
-		case MLX5_EVENT_TYPE_WQ_INVAL_REQ_ERROR:
-			event.event = IB_EVENT_QP_REQ_ERR;
-			break;
-		case MLX5_EVENT_TYPE_WQ_ACCESS_ERROR:
-			event.event = IB_EVENT_QP_ACCESS_ERR;
-			break;
-		default:
-			pr_warn("mlx5_ib: Unexpected event type %d on QP %06x\n", type, qp->qpn);
-			return;
-		}
+	if (!ibqp->event_handler)
+		goto out_no_handler;
 
-		ibqp->event_handler(&event, ibqp->qp_context);
-	}
+	qpe_work = kzalloc(sizeof(*qpe_work), GFP_ATOMIC);
+	if (!qpe_work)
+		goto out_no_handler;
+
+	qpe_work->qp = qp;
+	qpe_work->type = type;
+	INIT_WORK(&qpe_work->work, mlx5_ib_handle_qp_event);
+	queue_work(mlx5_ib_qp_event_wq, &qpe_work->work);
+	return;
+
+out_no_handler:
+	mlx5_core_res_put(&qp->common);
 }
 
 static int set_rq_size(struct mlx5_ib_dev *dev, struct ib_qp_cap *cap,
@@ -5701,3 +5736,17 @@ int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter)
 	mutex_unlock(&mqp->mutex);
 	return err;
 }
+
+int mlx5_ib_qp_event_init(void)
+{
+	mlx5_ib_qp_event_wq = alloc_ordered_workqueue("mlx5_ib_qp_event_wq", 0);
+	if (!mlx5_ib_qp_event_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx5_ib_qp_event_cleanup(void)
+{
+	destroy_workqueue(mlx5_ib_qp_event_wq);
+}
diff --git a/drivers/infiniband/hw/mlx5/qp.h b/drivers/infiniband/hw/mlx5/qp.h
index 5d4e140db99c..fb2f4e030bb8 100644
--- a/drivers/infiniband/hw/mlx5/qp.h
+++ b/drivers/infiniband/hw/mlx5/qp.h
@@ -44,4 +44,6 @@ void mlx5_core_res_put(struct mlx5_core_rsc_common *res);
 int mlx5_core_xrcd_alloc(struct mlx5_ib_dev *dev, u32 *xrcdn);
 int mlx5_core_xrcd_dealloc(struct mlx5_ib_dev *dev, u32 xrcdn);
 int mlx5_ib_qp_set_counter(struct ib_qp *qp, struct rdma_counter *counter);
+int mlx5_ib_qp_event_init(void);
+void mlx5_ib_qp_event_cleanup(void);
 #endif /* _MLX5_IB_QP_H */
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 73bae024c01a..0d51b4c06c06 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -135,7 +135,8 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	case MLX5_RES_SQ:
 		qp = (struct mlx5_core_qp *)common;
 		qp->event(qp, event_type);
-		break;
+		/* Need to put resource in event handler */
+		return NOTIFY_OK;
 	case MLX5_RES_DCT:
 		dct = (struct mlx5_core_dct *)common;
 		if (event_type == MLX5_EVENT_TYPE_DCT_DRAINED)
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 48cfaa7eaf50..913ed255990f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -46,6 +46,13 @@
 #define MLX4_BF_QP_SKIP_MASK	0xc0
 #define MLX4_MAX_BF_QP_RANGE	0x40
 
+void mlx4_put_qp(struct mlx4_qp *qp)
+{
+	if (refcount_dec_and_test(&qp->refcount))
+		complete(&qp->free);
+}
+EXPORT_SYMBOL_GPL(mlx4_put_qp);
+
 void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
 {
 	struct mlx4_qp_table *qp_table = &mlx4_priv(dev)->qp_table;
@@ -64,10 +71,8 @@ void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
 		return;
 	}
 
+	/* Need to call mlx4_put_qp() in event handler */
 	qp->event(qp, event_type);
-
-	if (refcount_dec_and_test(&qp->refcount))
-		complete(&qp->free);
 }
 
 /* used for INIT/CLOSE port logic */
@@ -523,8 +528,7 @@ EXPORT_SYMBOL_GPL(mlx4_qp_remove);
 
 void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp)
 {
-	if (refcount_dec_and_test(&qp->refcount))
-		complete(&qp->free);
+	mlx4_put_qp(qp);
 	wait_for_completion(&qp->free);
 
 	mlx4_qp_free_icm(dev, qp->qpn);
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9db93e487496..c78b90f2e9a1 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -503,4 +503,5 @@ static inline u16 folded_qp(u32 q)
 
 u16 mlx4_qp_roce_entropy(struct mlx4_dev *dev, u32 qpn);
 
+void mlx4_put_qp(struct mlx4_qp *qp);
 #endif /* MLX4_QP_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a9a429172c0a..949cf4ffc536 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1168,7 +1168,7 @@ enum ib_qp_create_flags {
  */
 
 struct ib_qp_init_attr {
-	/* Consumer's event_handler callback must not block */
+	/* This callback occurs in workqueue context */
 	void                  (*event_handler)(struct ib_event *, void *);
 
 	void		       *qp_context;
-- 
2.38.1

