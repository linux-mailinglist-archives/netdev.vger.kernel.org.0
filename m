Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6206A68E5CA
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 03:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjBHCHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 21:07:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjBHCHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 21:07:02 -0500
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 522D2303D9;
        Tue,  7 Feb 2023 18:06:58 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.125])
        by APP-03 (Coremail) with SMTP id rQCowADnK4y3A+NjA37sAw--.15544S2;
        Wed, 08 Feb 2023 10:06:49 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     skashyap@marvell.com, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux@armlinux.org.uk
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] scsi: qedf: Add missing checks for create_workqueue
Date:   Wed,  8 Feb 2023 10:06:46 +0800
Message-Id: <20230208020646.36294-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: rQCowADnK4y3A+NjA37sAw--.15544S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw13JF17Kr13Gry8ur4fuFg_yoWxJFWxpF
        W3Xa9Yyrs5Ww4UWa4DJr4qgFnIgr4qvFW8CrWIkw43XFsYkrWvq3W0gryjvrWfKrZ5Gw1j
        yF1UtrWUC3y2ywUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
        8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
        ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
        0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
        Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoO
        J5UUUUU
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the checks for the return value of the create_workqueue in order to
avoid NULL pointer dereference.
Moreover, the allocated "qedf->link_update_wq" should be destroyed when
__qedf_probe fails later in order to avoid memory leak.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/scsi/qedf/qedf_main.c | 56 ++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 35e16600fc63..ff90291530a7 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3360,6 +3360,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	sprintf(host_buf, "qedf_%u_link",
 	    qedf->lport->host->host_no);
 	qedf->link_update_wq = create_workqueue(host_buf);
+	if (!qedf->link_update_wq) {
+		QEDF_ERR(&(qedf->dbg_ctx), "Failed to link workqueue.\n");
+		rc = -ENOMEM;
+		goto err1;
+	}
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
 	INIT_DELAYED_WORK(&qedf->grcdump_work, qedf_wq_grcdump);
@@ -3394,14 +3399,14 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		}
 		QEDF_ERR(&qedf->dbg_ctx, "common probe failed.\n");
 		rc = -ENODEV;
-		goto err1;
+		goto err2;
 	}
 
 	/* Learn information crucial for qedf to progress */
 	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to dev info.\n");
-		goto err1;
+		goto err2;
 	}
 
 	QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
@@ -3420,7 +3425,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	rc = qedf_set_fcoe_pf_param(qedf);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Cannot set fcoe pf param.\n");
-		goto err2;
+		goto err3;
 	}
 	qed_ops->common->update_pf_params(qedf->cdev, &qedf->pf_params);
 
@@ -3428,7 +3433,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	rc = qed_ops->fill_dev_info(qedf->cdev, &qedf->dev_info);
 	if (rc) {
 		QEDF_ERR(&qedf->dbg_ctx, "Failed to fill dev info.\n");
-		goto err2;
+		goto err3;
 	}
 
 	if (mode != QEDF_MODE_RECOVERY) {
@@ -3437,7 +3442,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 			QEDF_ERR(&qedf->dbg_ctx, "Cannot register devlink\n");
 			rc = PTR_ERR(qedf->devlink);
 			qedf->devlink = NULL;
-			goto err2;
+			goto err3;
 		}
 	}
 
@@ -3454,7 +3459,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	if (rc) {
 
 		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");
-		goto err2;
+		goto err3;
 	}
 
 	/* Start the Slowpath-process */
@@ -3467,7 +3472,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	rc = qed_ops->common->slowpath_start(qedf->cdev, &slowpath_params);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");
-		goto err2;
+		goto err3;
 	}
 
 	/*
@@ -3480,13 +3485,13 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	rc = qedf_setup_int(qedf);
 	if (rc) {
 		QEDF_ERR(&qedf->dbg_ctx, "Setup interrupts failed.\n");
-		goto err3;
+		goto err4;
 	}
 
 	rc = qed_ops->start(qedf->cdev, &qedf->tasks);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Cannot start FCoE function.\n");
-		goto err4;
+		goto err5;
 	}
 	task_start = qedf_get_task_mem(&qedf->tasks, 0);
 	task_end = qedf_get_task_mem(&qedf->tasks, MAX_TID_BLOCKS_FCOE - 1);
@@ -3546,7 +3551,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	if (!qedf->cmd_mgr) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to allocate cmd mgr.\n");
 		rc = -ENOMEM;
-		goto err5;
+		goto err6;
 	}
 
 	if (mode != QEDF_MODE_RECOVERY) {
@@ -3559,7 +3564,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		if (rc) {
 			QEDF_WARN(&qedf->dbg_ctx,
 				  "Error adding Scsi_Host rc=0x%x.\n", rc);
-			goto err6;
+			goto err7;
 		}
 	}
 
@@ -3574,7 +3579,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	if (!qedf->ll2_recv_wq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to LL2 workqueue.\n");
 		rc = -ENOMEM;
-		goto err7;
+		goto err8;
 	}
 
 #ifdef CONFIG_DEBUG_FS
@@ -3587,7 +3592,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	rc = qed_ops->ll2->start(qedf->cdev, &params);
 	if (rc) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Could not start Light L2.\n");
-		goto err7;
+		goto err8;
 	}
 	set_bit(QEDF_LL2_STARTED, &qedf->flags);
 
@@ -3607,7 +3612,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		if (rc) {
 			QEDF_ERR(&(qedf->dbg_ctx),
 			    "qedf_lport_setup failed.\n");
-			goto err7;
+			goto err8;
 		}
 	}
 
@@ -3618,7 +3623,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
 			  "workqueue.\n");
 		rc = -ENOMEM;
-		goto err7;
+		goto err8;
 	}
 
 	/* DPC workqueue is not reaped during recovery unload */
@@ -3626,6 +3631,11 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		sprintf(host_buf, "qedf_%u_dpc",
 		    qedf->lport->host->host_no);
 		qedf->dpc_wq = create_workqueue(host_buf);
+		if (!qedf->dpc_wq) {
+			QEDF_ERR(&(qedf->dbg_ctx), "Failed to dpc workqueue.\n");
+			rc = -ENOMEM;
+			goto err9;
+		}
 	}
 	INIT_DELAYED_WORK(&qedf->recovery_work, qedf_recovery_handler);
 
@@ -3682,7 +3692,9 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	/* All good */
 	return 0;
 
-err7:
+err9:
+	destroy_workqueue(qedf->timer_work_queue);
+err8:
 	if (qedf->ll2_recv_wq)
 		destroy_workqueue(qedf->ll2_recv_wq);
 	fc_remove_host(qedf->lport->host);
@@ -3690,17 +3702,19 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 #ifdef CONFIG_DEBUG_FS
 	qedf_dbg_host_exit(&(qedf->dbg_ctx));
 #endif
-err6:
+err7:
 	qedf_cmd_mgr_free(qedf->cmd_mgr);
-err5:
+err6:
 	qed_ops->stop(qedf->cdev);
-err4:
+err5:
 	qedf_free_fcoe_pf_param(qedf);
 	qedf_sync_free_irqs(qedf);
-err3:
+err4:
 	qed_ops->common->slowpath_stop(qedf->cdev);
-err2:
+err3:
 	qed_ops->common->remove(qedf->cdev);
+err2:
+	destroy_workqueue(qedf->link_update_wq);
 err1:
 	scsi_host_put(lport->host);
 err0:
-- 
2.25.1

