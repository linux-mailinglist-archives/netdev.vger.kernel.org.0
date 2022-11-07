Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F85F61EBF7
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiKGH1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiKGH0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:26:48 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D826FE7;
        Sun,  6 Nov 2022 23:26:47 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2A76qsoE030458;
        Sun, 6 Nov 2022 23:26:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=sPBz+DlrDCkXJlyk9418pb/Ox8aziKF0OyqHaT0xWRQ=;
 b=F1RCTYAPeQzx4jTfGYRbE8o+U0HeLvYb4efZJviFYw/2A97CPJ2vz/lIBHPd1bf1rVDw
 Gos3hNrx798gby6brzKcOul/DUxSaSS1wUxfm1SzpudqCtfQFxfwYf7vwvjGnjJcl0fD
 Oc+Fp2KATwXY2HaHYuZ0jPYpIbtcVTRIshlueUDGBIq5/oCFY0d2bgz//UTTdo3N8zld
 +8V8hiUXp09/jTVNHssQnpiBeYXDAYbUoPULcUOvGCgcC8z19TBFt18m3/so8pDC9zrQ
 et6O4OhL91uchgJuhntvvTrksb3I6PIVllxfsfvv5vFjM+F82yjrzzyuQ3uuKtBQqd9m Ag== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kpw4wg3fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Nov 2022 23:26:36 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 6 Nov
 2022 23:26:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 6 Nov 2022 23:26:34 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 2CC973F704F;
        Sun,  6 Nov 2022 23:26:34 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/9] octeon_ep: poll for control messages
Date:   Sun, 6 Nov 2022 23:25:16 -0800
Message-ID: <20221107072524.9485-3-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221107072524.9485-1-vburru@marvell.com>
References: <20221107072524.9485-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: tUtB-DcOZO99tgEjvY6EfTpNOdH9abom
X-Proofpoint-ORIG-GUID: tUtB-DcOZO99tgEjvY6EfTpNOdH9abom
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Poll for control messages until interrupts are enabled.
All the interrupts are enabled in ndo_open().
Add ability to listen for notifications from firmware before ndo_open().
Once interrupts are enabled, this polling is disabled and all the
messages are processed by bottom half of interrupt handler.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
 .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
 .../ethernet/marvell/octeon_ep/octep_main.c   | 42 +++++++++++++++-
 .../ethernet/marvell/octeon_ep/octep_main.h   | 15 ++++--
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
 4 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index 6ad88d0fe43f..ace2dfd1e918 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -352,27 +352,36 @@ static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
 	mbox->mbox_read_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_VF_PF_DATA(q_no);
 }
 
-/* Mailbox Interrupt handler */
-static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
+/* Process non-ioq interrupts required to keep pf interface running.
+ * OEI_RINT is needed for control mailbox
+ */
+static int octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
 {
-	u64 mbox_int_val = 0ULL, val = 0ULL, qno = 0ULL;
+	u64 reg0;
+	int handled = 0;
 
-	mbox_int_val = readq(oct->mbox[0]->mbox_int_reg);
-	for (qno = 0; qno < OCTEP_MAX_VF; qno++) {
-		val = readq(oct->mbox[qno]->mbox_read_reg);
-		dev_dbg(&oct->pdev->dev,
-			"PF MBOX READ: val:%llx from VF:%llx\n", val, qno);
+	/* Check for OEI INTR */
+	reg0 = octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
+	if (reg0) {
+		dev_info(&oct->pdev->dev,
+			 "Received OEI_RINT intr: 0x%llx\n",
+			 reg0);
+		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg0);
+		if (reg0 & CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX)
+			queue_work(octep_wq, &oct->ctrl_mbox_task);
+
+		handled = 1;
 	}
 
-	writeq(mbox_int_val, oct->mbox[0]->mbox_int_reg);
+	return handled;
 }
 
 /* Interrupts handler for all non-queue generic interrupts. */
 static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
 {
 	struct octep_device *oct = (struct octep_device *)dev;
-	struct pci_dev *pdev = oct->pdev;
 	u64 reg_val = 0;
+	struct pci_dev *pdev = oct->pdev;
 	int i = 0;
 
 	/* Check for IRERR INTR */
@@ -434,24 +443,9 @@ static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
 		goto irq_handled;
 	}
 
-	/* Check for MBOX INTR */
-	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_MBOX_RINT(0));
-	if (reg_val) {
-		dev_info(&pdev->dev,
-			 "Received MBOX_RINT intr: 0x%llx\n", reg_val);
-		cn93_handle_pf_mbox_intr(oct);
+	/* Check for MBOX INTR and OEI INTR */
+	if (octep_poll_non_ioq_interrupts_cn93_pf(oct))
 		goto irq_handled;
-	}
-
-	/* Check for OEI INTR */
-	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
-	if (reg_val) {
-		dev_info(&pdev->dev,
-			 "Received OEI_EINT intr: 0x%llx\n", reg_val);
-		octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT, reg_val);
-		queue_work(octep_wq, &oct->ctrl_mbox_task);
-		goto irq_handled;
-	}
 
 	/* Check for DMA INTR */
 	reg_val = octep_read_csr64(oct, CN93_SDP_EPF_DMA_RINT);
@@ -712,6 +706,7 @@ void octep_device_setup_cn93_pf(struct octep_device *oct)
 
 	oct->hw_ops.enable_interrupts = octep_enable_interrupts_cn93_pf;
 	oct->hw_ops.disable_interrupts = octep_disable_interrupts_cn93_pf;
+	oct->hw_ops.poll_non_ioq_interrupts = octep_poll_non_ioq_interrupts_cn93_pf;
 
 	oct->hw_ops.update_iq_read_idx = octep_update_iq_read_index_cn93_pf;
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 488159217030..93d234b5a84b 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -18,6 +18,7 @@
 #include "octep_main.h"
 #include "octep_ctrl_net.h"
 
+#define OCTEP_INTR_POLL_TIME_MSECS    100
 struct workqueue_struct *octep_wq;
 
 /* Supported Devices */
@@ -512,6 +513,7 @@ static int octep_open(struct net_device *netdev)
 	ret = octep_get_link_status(oct);
 	if (!ret)
 		octep_set_link_status(oct, true);
+	oct->poll_non_ioq_intr = false;
 
 	/* Enable the input and output queues for this Octeon device */
 	oct->hw_ops.enable_io_queues(oct);
@@ -575,6 +577,11 @@ static int octep_stop(struct net_device *netdev)
 	oct->hw_ops.reset_io_queues(oct);
 	octep_free_oqs(oct);
 	octep_free_iqs(oct);
+
+	oct->poll_non_ioq_intr = true;
+	queue_delayed_work(octep_wq, &oct->intr_poll_task,
+			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
+
 	netdev_info(netdev, "Device stopped !!\n");
 	return 0;
 }
@@ -872,9 +879,37 @@ static void cancel_all_tasks(struct octep_device *oct)
 {
 	cancel_work_sync(&oct->tx_timeout_task);
 	cancel_work_sync(&oct->ctrl_mbox_task);
+	oct->poll_non_ioq_intr = false;
+	cancel_delayed_work_sync(&oct->intr_poll_task);
 	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
 }
 
+/**
+ * octep_intr_poll_task - work queue task to process non-ioq interrupts.
+ *
+ * @work: pointer to mbox work_struct
+ *
+ * Process non-ioq interrupts to handle control mailbox, pfvf mailbox.
+ **/
+static void octep_intr_poll_task(struct work_struct *work)
+{
+	struct octep_device *oct = container_of(work, struct octep_device,
+						intr_poll_task.work);
+	int status;
+
+	status = atomic_read(&oct->status);
+	if ((status != OCTEP_DEV_STATUS_INIT &&
+	     status != OCTEP_DEV_STATUS_READY) ||
+	    !oct->poll_non_ioq_intr) {
+		dev_info(&oct->pdev->dev, "Interrupt poll task stopped.\n");
+		return;
+	}
+
+	oct->hw_ops.poll_non_ioq_interrupts(oct);
+	queue_delayed_work(octep_wq, &oct->intr_poll_task,
+			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
+}
+
 /**
  * octep_ctrl_mbox_task - work queue task to handle ctrl mbox messages.
  *
@@ -989,6 +1024,10 @@ int octep_device_setup(struct octep_device *oct)
 
 	INIT_WORK(&oct->tx_timeout_task, octep_tx_timeout_task);
 	INIT_WORK(&oct->ctrl_mbox_task, octep_ctrl_mbox_task);
+	INIT_DELAYED_WORK(&oct->intr_poll_task, octep_intr_poll_task);
+	oct->poll_non_ioq_intr = true;
+	queue_delayed_work(octep_wq, &oct->intr_poll_task,
+			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
 
 	return 0;
 
@@ -1110,6 +1149,7 @@ static void octep_dev_setup_task(struct work_struct *work)
 		return;
 	}
 	atomic_set(&oct->status, OCTEP_DEV_STATUS_READY);
+	dev_info(&oct->pdev->dev, "Device setup successful\n");
 }
 
 /**
@@ -1165,7 +1205,7 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	atomic_set(&octep_dev->status, OCTEP_DEV_STATUS_ALLOC);
 	INIT_WORK(&octep_dev->dev_setup_task, octep_dev_setup_task);
-	queue_work(octep_wq, &octep_dev->dev_setup_task);
+	schedule_work(&octep_dev->dev_setup_task);
 	dev_info(&pdev->dev, "Device setup task queued\n");
 
 	return 0;
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 45226282bf21..5546b2b09d25 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -73,6 +73,7 @@ struct octep_hw_ops {
 
 	void (*enable_interrupts)(struct octep_device *oct);
 	void (*disable_interrupts)(struct octep_device *oct);
+	int (*poll_non_ioq_interrupts)(struct octep_device *oct);
 
 	void (*enable_io_queues)(struct octep_device *oct);
 	void (*disable_io_queues)(struct octep_device *oct);
@@ -274,16 +275,22 @@ struct octep_device {
 
 	/* control mbox over pf */
 	struct octep_ctrl_mbox ctrl_mbox;
-
 	/* offset for iface stats */
 	u32 ctrl_mbox_ifstats_offset;
-
-	/* Work entry to handle ctrl mbox interrupt */
+	/* Work entry to process ctrl mbox */
 	struct work_struct ctrl_mbox_task;
+	/* Wait queue for host to firmware requests */
+	wait_queue_head_t ctrl_req_wait_q;
+	/* List of objects waiting for h2f response */
+	struct list_head ctrl_req_wait_list;
+
+	/* Enable non-ioq interrupt polling */
+	bool poll_non_ioq_intr;
+	/* Work entry to poll non-ioq interrupts */
+	struct delayed_work intr_poll_task;
 
 	/* Work entry to handle device setup */
 	struct work_struct dev_setup_task;
-
 	/* Device status */
 	atomic_t status;
 };
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
index 3d5d39a52fe6..0466fd9a002d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
@@ -364,4 +364,8 @@
 
 /* Number of non-queue interrupts in CN93xx */
 #define    CN93_NUM_NON_IOQ_INTR    16
+
+/* bit 0 for control mbox interrupt */
+#define CN93_SDP_EPF_OEI_RINT_DATA_BIT_MBOX	BIT_ULL(0)
+
 #endif /* _OCTEP_REGS_CN9K_PF_H_ */
-- 
2.36.0

