Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212096C839B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjCXRrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCXRr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:47:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C931A486;
        Fri, 24 Mar 2023 10:47:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OH2r7W001150;
        Fri, 24 Mar 2023 10:47:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=YLg7fBizamqpcT+QXE3Dc4rKa6tDAkvztVDZ5KQchM8=;
 b=MajjehlJ6F5nQoD2luoWAD3V5We5cYMi4BE1hqCBUgJ3zPu5nSGJ8nFqMg7Z7LUU+GDw
 foNlRTqTyNXIx06lexwhuIwbYtn4QxdzcnXA3baIc9mQ6N1/E9tXuao/sL0O3KJv1dSE
 hHtRgrj/2FSQ7mivfXioStVfk5so1GklVxaGui8FHzE8jXlx6k53C6XoSBCbXf6bGfU0
 fgCETTOLwStHH3tQvx3h8R3lFJ2bBjmchpIW+K1y8qceYMsGNajV3R4RvrMKXerDjH3C
 htM9kdJ0RjJPIxbrKwxLC06Nr9eZB4JDe2ro2MDvV5u5UUtceeX0NYWkZiusnUJmcLk6 iA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pgxmfkdp2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:47:14 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 24 Mar
 2023 10:47:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 24 Mar 2023 10:47:13 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 1330D3F7059;
        Fri, 24 Mar 2023 10:47:13 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v5 2/8] octeon_ep: poll for control messages
Date:   Fri, 24 Mar 2023 10:46:57 -0700
Message-ID: <20230324174704.9752-3-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20230324174704.9752-1-vburru@marvell.com>
References: <20230324174704.9752-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: NuLIAEWot7LgDnVMVUSyCv5ipDEIqqVb
X-Proofpoint-ORIG-GUID: NuLIAEWot7LgDnVMVUSyCv5ipDEIqqVb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
v4 -> v5:
 * no change

v3-> v4:
 * resovled review comments
   https://lore.kernel.org/all/Y+vIHjaUvkWXw55x@boxer/
   - changed return type from integer to bool, where the possible
     return values are only 0 and 1.
   - reverted an unnecessary change that caused rct breakage.

v2-> v3:
 * resovled review comment; fixed reverse christmas tree.

v1 -> v2:
 * removed device status oct->status, as it is not required with the
   modified implementation in 0001-xxxx.patch

 .../marvell/octeon_ep/octep_cn9k_pf.c         | 47 +++++++++----------
 .../ethernet/marvell/octeon_ep/octep_main.c   | 35 ++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
 4 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index 6ad88d0fe43f..adc2279bc66d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -352,19 +352,28 @@ static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
 	mbox->mbox_read_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_VF_PF_DATA(q_no);
 }
 
-/* Mailbox Interrupt handler */
-static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
+/* Process non-ioq interrupts required to keep pf interface running.
+ * OEI_RINT is needed for control mailbox
+ */
+static bool octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
 {
-	u64 mbox_int_val = 0ULL, val = 0ULL, qno = 0ULL;
+	bool handled = false;
+	u64 reg0;
 
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
+		handled = true;
 	}
 
-	writeq(mbox_int_val, oct->mbox[0]->mbox_int_reg);
+	return handled;
 }
 
 /* Interrupts handler for all non-queue generic interrupts. */
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
index 0a50da52dc27..a3e4d9355681 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -17,6 +17,7 @@
 #include "octep_main.h"
 #include "octep_ctrl_net.h"
 
+#define OCTEP_INTR_POLL_TIME_MSECS    100
 struct workqueue_struct *octep_wq;
 
 /* Supported Devices */
@@ -511,6 +512,7 @@ static int octep_open(struct net_device *netdev)
 	ret = octep_get_link_status(oct);
 	if (!ret)
 		octep_set_link_status(oct, true);
+	oct->poll_non_ioq_intr = false;
 
 	/* Enable the input and output queues for this Octeon device */
 	oct->hw_ops.enable_io_queues(oct);
@@ -572,6 +574,11 @@ static int octep_stop(struct net_device *netdev)
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
@@ -864,6 +871,28 @@ static const struct net_device_ops octep_netdev_ops = {
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
@@ -1099,6 +1128,10 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	INIT_WORK(&octep_dev->tx_timeout_task, octep_tx_timeout_task);
 	INIT_WORK(&octep_dev->ctrl_mbox_task, octep_ctrl_mbox_task);
+	INIT_DELAYED_WORK(&octep_dev->intr_poll_task, octep_intr_poll_task);
+	octep_dev->poll_non_ioq_intr = true;
+	queue_delayed_work(octep_wq, &octep_dev->intr_poll_task,
+			   msecs_to_jiffies(OCTEP_INTR_POLL_TIME_MSECS));
 
 	netdev->netdev_ops = &octep_netdev_ops;
 	octep_set_ethtool_ops(netdev);
@@ -1159,6 +1192,8 @@ static void octep_remove(struct pci_dev *pdev)
 	if (netdev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(netdev);
 
+	oct->poll_non_ioq_intr = false;
+	cancel_delayed_work_sync(&oct->intr_poll_task);
 	octep_device_cleanup(oct);
 	pci_release_mem_regions(pdev);
 	free_netdev(netdev);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 123ffc13754d..836d990ba3fa 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -73,6 +73,7 @@ struct octep_hw_ops {
 
 	void (*enable_interrupts)(struct octep_device *oct);
 	void (*disable_interrupts)(struct octep_device *oct);
+	bool (*poll_non_ioq_interrupts)(struct octep_device *oct);
 
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

