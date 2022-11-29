Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BADB63C096
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiK2NJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiK2NJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:09:55 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC1759170;
        Tue, 29 Nov 2022 05:09:53 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxieV022509;
        Tue, 29 Nov 2022 05:09:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=KSroYBbL09gyFVWOrNzHD8aigHxM9GK0ec5s7DtKJSU=;
 b=RZz7Wdf4sSqlFn0nLgyioZzJrdHulA43XTSI/rRgN0jMeDmCPqAMa/oasjti61pxwevz
 qmqDJLswzCo8WK/xCren21c5Pnh8e8JgBVfvRwCZuo4zhdv9oeSUQgg5QFKKcB2ESONX
 /p8A/I1wGzOsQEInyl/DhCaqDNmlppu+hFPil93evyw+BogdPZ9dR0YiOEuTAgAft38X
 RpnD5+dZ6zEb9J2P0ffnXh26Ki9S+BbpH1iut5YyYpa7Boeq+7AC7QpPeu1M3qGm7vx5
 kObi2mdvEpfXjINp7EWkn8ytG80FnHd73x7c8iRNBgDb9Hi4tp3inrVSjH+DdrwuYsC2 iA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m3k6wbcnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:43 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Nov
 2022 05:09:41 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:41 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id E2FE53F7084;
        Tue, 29 Nov 2022 05:09:40 -0800 (PST)
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
Subject: [PATCH net-next v2 2/9] octeon_ep: poll for control messages
Date:   Tue, 29 Nov 2022 05:09:25 -0800
Message-ID: <20221129130933.25231-3-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: KiIfv64uTlBXOpzZx3Kw6JhsP_q7_UyJ
X-Proofpoint-ORIG-GUID: KiIfv64uTlBXOpzZx3Kw6JhsP_q7_UyJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
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
v1 -> v2:
 * removed device status oct->status, as it is not required with the
   modified implementation in 0001-xxxx.patch

 .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
 .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
 4 files changed, 71 insertions(+), 28 deletions(-)

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
index aa7d0ced9807..c07588461030 100644
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
@@ -573,6 +575,11 @@ static int octep_stop(struct net_device *netdev)
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
@@ -865,6 +872,28 @@ static const struct net_device_ops octep_netdev_ops = {
 	.ndo_change_mtu          = octep_change_mtu,
 };
 
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
+
+	if (!oct->poll_non_ioq_intr) {
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
@@ -1101,6 +1130,10 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	INIT_WORK(&octep_dev->tx_timeout_task, octep_tx_timeout_task);
 	INIT_WORK(&octep_dev->ctrl_mbox_task, octep_ctrl_mbox_task);
+	INIT_DELAYED_WORK(&octep_dev->intr_poll_task, octep_intr_poll_task);
+	octep_dev->poll_non_ioq_intr = true;
+	queue_delayed_work(octep_wq, &octep_dev->intr_poll_task,
+			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
 
 	netdev->netdev_ops = &octep_netdev_ops;
 	octep_set_ethtool_ops(netdev);
@@ -1162,6 +1195,8 @@ static void octep_remove(struct pci_dev *pdev)
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(netdev);
 
+	oct->poll_non_ioq_intr = false;
+	cancel_delayed_work_sync(&oct->intr_poll_task);
 	octep_device_cleanup(oct);
 	pci_release_mem_regions(pdev);
 	free_netdev(netdev);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 123ffc13754d..70cc3e236cb4 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -73,6 +73,7 @@ struct octep_hw_ops {
 
 	void (*enable_interrupts)(struct octep_device *oct);
 	void (*disable_interrupts)(struct octep_device *oct);
+	int (*poll_non_ioq_interrupts)(struct octep_device *oct);
 
 	void (*enable_io_queues)(struct octep_device *oct);
 	void (*disable_io_queues)(struct octep_device *oct);
@@ -270,7 +271,15 @@ struct octep_device {
 
 	/* Work entry to handle ctrl mbox interrupt */
 	struct work_struct ctrl_mbox_task;
-
+	/* Wait queue for host to firmware requests */
+	wait_queue_head_t ctrl_req_wait_q;
+	/* List of objects waiting for h2f response */
+	struct list_head ctrl_req_wait_list;
+
+	/* Enable non-ioq interrupt polling */
+	bool poll_non_ioq_intr;
+	/* Work entry to poll non-ioq interrupts */
+	struct delayed_work intr_poll_task;
 };
 
 static inline u16 OCTEP_MAJOR_REV(struct octep_device *oct)
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

