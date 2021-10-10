Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F1B427F79
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 09:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhJJHDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 03:03:43 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:29492 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbhJJHDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 03:03:36 -0400
Received: from pop-os.home ([90.126.248.220])
        by mwinf5d27 with ME
        id 471Z2600n4m3Hzu0371aVc; Sun, 10 Oct 2021 09:01:36 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 10 Oct 2021 09:01:36 +0200
X-ME-IP: 90.126.248.220
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        rmody@marvell.com, skalluru@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, tariqt@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ethernet: Remove redundant 'flush_workqueue()' calls
Date:   Sun, 10 Oct 2021 09:01:32 +0200
Message-Id: <3dadac919f6f4a991953965ddbb975f2586e6ecf.1633848953.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                 | 2 --
 drivers/net/ethernet/brocade/bna/bnad.c                  | 1 -
 drivers/net/ethernet/cavium/liquidio/lio_core.c          | 1 -
 drivers/net/ethernet/emulex/benet/be_main.c              | 1 -
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c          | 1 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c          | 2 --
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c      | 1 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c     | 1 -
 drivers/net/ethernet/mellanox/mlx4/cmd.c                 | 2 --
 drivers/net/ethernet/mellanox/mlx4/en_main.c             | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 1 -
 drivers/net/ethernet/qlogic/qed/qed_sriov.c              | 1 -
 12 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index b5bf5af8db5f..30d24d19f40d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1912,10 +1912,8 @@ static int xgbe_close(struct net_device *netdev)
 	clk_disable_unprepare(pdata->ptpclk);
 	clk_disable_unprepare(pdata->sysclk);
 
-	flush_workqueue(pdata->an_workqueue);
 	destroy_workqueue(pdata->an_workqueue);
 
-	flush_workqueue(pdata->dev_workqueue);
 	destroy_workqueue(pdata->dev_workqueue);
 
 	set_bit(XGBE_DOWN, &pdata->dev_state);
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index b1947fd9a07c..bbdc829c3524 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3515,7 +3515,6 @@ static void
 bnad_uninit(struct bnad *bnad)
 {
 	if (bnad->work_q) {
-		flush_workqueue(bnad->work_q);
 		destroy_workqueue(bnad->work_q);
 		bnad->work_q = NULL;
 	}
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
index ec7928b54e4a..73cb03266549 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
@@ -490,7 +490,6 @@ void cleanup_rx_oom_poll_fn(struct net_device *netdev)
 		wq = &lio->rxq_status_wq[q_no];
 		if (wq->wq) {
 			cancel_delayed_work_sync(&wq->wk.work);
-			flush_workqueue(wq->wq);
 			destroy_workqueue(wq->wq);
 			wq->wq = NULL;
 		}
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index ef60e2da05a4..736a6ea86eb1 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4621,7 +4621,6 @@ static void be_destroy_err_recovery_workq(void)
 	if (!be_err_recovery_workq)
 		return;
 
-	flush_workqueue(be_err_recovery_workq);
 	destroy_workqueue(be_err_recovery_workq);
 	be_err_recovery_workq = NULL;
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index d379a35c4618..186d00a9ab35 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1519,7 +1519,6 @@ static int cgx_lmac_exit(struct cgx *cgx)
 	int i;
 
 	if (cgx->cgx_cmd_workq) {
-		flush_workqueue(cgx->cgx_cmd_workq);
 		destroy_workqueue(cgx->cgx_cmd_workq);
 		cgx->cgx_cmd_workq = NULL;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 4cb24e91e648..0a1e9f6e216a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2399,7 +2399,6 @@ static void rvu_mbox_destroy(struct mbox_wq_info *mw)
 	int devid;
 
 	if (mw->mbox_wq) {
-		flush_workqueue(mw->mbox_wq);
 		destroy_workqueue(mw->mbox_wq);
 		mw->mbox_wq = NULL;
 	}
@@ -2944,7 +2943,6 @@ static int rvu_register_interrupts(struct rvu *rvu)
 static void rvu_flr_wq_destroy(struct rvu *rvu)
 {
 	if (rvu->flr_wq) {
-		flush_workqueue(rvu->flr_wq);
 		destroy_workqueue(rvu->flr_wq);
 		rvu->flr_wq = NULL;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index c3842e454657..2ca182a4ce82 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -324,7 +324,6 @@ static int cgx_lmac_event_handler_init(struct rvu *rvu)
 static void rvu_cgx_wq_destroy(struct rvu *rvu)
 {
 	if (rvu->cgx_evh_wq) {
-		flush_workqueue(rvu->cgx_evh_wq);
 		destroy_workqueue(rvu->cgx_evh_wq);
 		rvu->cgx_evh_wq = NULL;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 980219a7e6fe..e6cb8cd0787d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -279,7 +279,6 @@ static void otx2vf_vfaf_mbox_destroy(struct otx2_nic *vf)
 	struct mbox *mbox = &vf->mbox;
 
 	if (vf->mbox_wq) {
-		flush_workqueue(vf->mbox_wq);
 		destroy_workqueue(vf->mbox_wq);
 		vf->mbox_wq = NULL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 94ead263081f..e10b7b04b894 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -2480,7 +2480,6 @@ int mlx4_multi_func_init(struct mlx4_dev *dev)
 	return 0;
 
 err_thread:
-	flush_workqueue(priv->mfunc.master.comm_wq);
 	destroy_workqueue(priv->mfunc.master.comm_wq);
 err_slaves:
 	while (i--) {
@@ -2587,7 +2586,6 @@ void mlx4_multi_func_cleanup(struct mlx4_dev *dev)
 	int i, port;
 
 	if (mlx4_is_master(dev)) {
-		flush_workqueue(priv->mfunc.master.comm_wq);
 		destroy_workqueue(priv->mfunc.master.comm_wq);
 		for (i = 0; i < dev->num_slaves; i++) {
 			for (port = 1; port <= MLX4_MAX_PORTS; port++)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_main.c b/drivers/net/ethernet/mellanox/mlx4/en_main.c
index 109472d6b61f..f1259bdb1a29 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_main.c
@@ -237,7 +237,6 @@ static void mlx4_en_remove(struct mlx4_dev *dev, void *endev_ptr)
 		if (mdev->pndev[i])
 			mlx4_en_destroy_netdev(mdev->pndev[i]);
 
-	flush_workqueue(mdev->workqueue);
 	destroy_workqueue(mdev->workqueue);
 	(void) mlx4_mr_free(dev, &mdev->mr);
 	iounmap(mdev->uar_map);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index f9cf9fb31547..da1bec04efff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1069,7 +1069,6 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	mlx5_fw_tracer_clean_saved_traces_array(tracer);
 	mlx5_fw_tracer_free_strings_db(tracer);
 	mlx5_fw_tracer_destroy_log_buf(tracer);
-	flush_workqueue(tracer->work_queue);
 	destroy_workqueue(tracer->work_queue);
 	kvfree(tracer);
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index f88f58ec2a20..8ac38828ba45 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -5224,7 +5224,6 @@ void qed_iov_wq_stop(struct qed_dev *cdev, bool schedule_first)
 			cancel_delayed_work_sync(&cdev->hwfns[i].iov_task);
 		}
 
-		flush_workqueue(cdev->hwfns[i].iov_wq);
 		destroy_workqueue(cdev->hwfns[i].iov_wq);
 	}
 }
-- 
2.30.2

