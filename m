Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B1063C0A2
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiK2NKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiK2NKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:10:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C303E59850;
        Tue, 29 Nov 2022 05:09:58 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxlr4029885;
        Tue, 29 Nov 2022 05:09:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=SX9OZ5AkCCRAaaYz+M7H15sQW1iR/wdkk/6dQF9ancM=;
 b=J6EY3/U7O0GjB4EtPbbX91HeoRNSgCZCTwoahdeek/QlnDdE/NYqujo9cBiscHV+AxuS
 GO2JMCIb47v1MATBqiPH39Dia1RPMCmfWnDbe4VdGqIs7hSGlkBX7TmLj5MjD/LfQZe0
 LaUfMMQZDzVkzgbLFBEv/aArthntCaH63OrOhWHgXsbkLUQjOchxDCe5nm1kg/7vS90L
 VHi2aE9G0vyd+91rYN7BLlyJ2uR+8646OHVM+ydtau2QovpqXLCkwrjABeSMw2tiJodt
 lvc7noUpcsZWGHQBdrLpD1sk1JgzADXLFLGBIFatEQExtaaCN1ZRI1t0UhneQksTE9VM LQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m5a509ytq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:49 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 29 Nov
 2022 05:09:47 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:47 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 9073C3F7084;
        Tue, 29 Nov 2022 05:09:47 -0800 (PST)
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
Subject: [PATCH net-next v2 8/9] octeon_ep: add PF-VF mailbox communication
Date:   Tue, 29 Nov 2022 05:09:31 -0800
Message-ID: <20221129130933.25231-9-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221129130933.25231-1-vburru@marvell.com>
References: <20221129130933.25231-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -hHH9UPfdGjQVhoK_UWcxzVtnndlYNlg
X-Proofpoint-GUID: -hHH9UPfdGjQVhoK_UWcxzVtnndlYNlg
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

Implement mailbox communication between PF and VFs.
PF-VF mailbox is used for all control commands from VF to PF and
asynchronous notification messages from PF to VF.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
---
v1 -> v2:
 * reworked the patch for changes made to preceding patches.
 * removed device status oct->status, as it is not required with the
   modified implementation.

 .../net/ethernet/marvell/octeon_ep/Makefile   |   3 +-
 .../marvell/octeon_ep/octep_cn9k_pf.c         |  42 ++-
 .../ethernet/marvell/octeon_ep/octep_main.c   |  15 +-
 .../ethernet/marvell/octeon_ep/octep_main.h   |  44 +--
 .../marvell/octeon_ep/octep_pfvf_mbox.c       | 305 ++++++++++++++++++
 .../marvell/octeon_ep/octep_pfvf_mbox.h       | 126 ++++++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   9 +
 .../net/ethernet/marvell/octeon_ep/octep_tx.h |  24 +-
 8 files changed, 523 insertions(+), 45 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.h

diff --git a/drivers/net/ethernet/marvell/octeon_ep/Makefile b/drivers/net/ethernet/marvell/octeon_ep/Makefile
index 2026c8118158..6cfa7198fdbd 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/Makefile
+++ b/drivers/net/ethernet/marvell/octeon_ep/Makefile
@@ -6,4 +6,5 @@
 obj-$(CONFIG_OCTEON_EP) += octeon_ep.o
 
 octeon_ep-y := octep_main.o octep_cn9k_pf.o octep_tx.o octep_rx.o \
-	       octep_ethtool.o octep_ctrl_mbox.o octep_ctrl_net.o
+	       octep_ethtool.o octep_ctrl_mbox.o octep_ctrl_net.o \
+	       octep_pfvf_mbox.o
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index e307bae62673..4840133477dc 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -354,26 +354,50 @@ static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
 {
 	struct octep_mbox *mbox = oct->mbox[q_no];
 
-	mbox->q_no = q_no;
-
-	/* PF mbox interrupt reg */
-	mbox->mbox_int_reg = oct->mmio[0].hw_addr + CN93_SDP_EPF_MBOX_RINT(0);
-
 	/* PF to VF DATA reg. PF writes into this reg */
-	mbox->mbox_write_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_PF_VF_DATA(q_no);
+	mbox->pf_vf_data_reg = oct->mmio[0].hw_addr + CN93_SDP_MBOX_PF_VF_DATA(q_no);
 
 	/* VF to PF DATA reg. PF reads from this reg */
-	mbox->mbox_read_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_VF_PF_DATA(q_no);
+	mbox->vf_pf_data_reg = oct->mmio[0].hw_addr + CN93_SDP_MBOX_VF_PF_DATA(q_no);
 }
 
 /* Process non-ioq interrupts required to keep pf interface running.
  * OEI_RINT is needed for control mailbox
+ * MBOX_RINT is needed for pfvf mailbox
  */
 static int octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
 {
-	u64 reg0;
+	u32 vf, active_vfs, active_rings_per_vf, vf_mbox_queue;
+	u64 reg0, reg1;
 	int handled = 0;
 
+	reg0 = octep_read_csr64(oct, CN93_SDP_EPF_MBOX_RINT(0));
+	reg1 = octep_read_csr64(oct, CN93_SDP_EPF_MBOX_RINT(1));
+	if (reg0 || reg1) {
+		dev_info(&oct->pdev->dev,
+			 "Received MBOX_RINT intr: reg0 0x%llx reg1 0x%llx\n",
+			 reg0, reg1);
+
+		active_vfs = CFG_GET_ACTIVE_VFS(oct->conf);
+		active_rings_per_vf = CFG_GET_ACTIVE_RPVF(oct->conf);
+		for (vf = 0; vf < active_vfs; vf++) {
+			vf_mbox_queue = vf * active_rings_per_vf;
+			if (!(reg0 & (0x1UL << vf_mbox_queue)))
+				continue;
+
+			if (!oct->mbox[vf_mbox_queue]) {
+				dev_err(&oct->pdev->dev, "bad mbox vf %d\n", vf);
+				continue;
+			}
+			schedule_work(&oct->mbox[vf_mbox_queue]->wk.work);
+		}
+		if (reg0)
+			octep_write_csr64(oct, CN93_SDP_EPF_MBOX_RINT(0), reg0);
+		if (reg1)
+			octep_write_csr64(oct, CN93_SDP_EPF_MBOX_RINT(1), reg1);
+
+		handled = 1;
+	}
 	/* Check for OEI INTR */
 	reg0 = octep_read_csr64(oct, CN93_SDP_EPF_OEI_RINT);
 	if (reg0) {
@@ -562,6 +586,8 @@ static void octep_enable_interrupts_cn93_pf(struct octep_device *oct)
 	octep_write_csr64(oct, CN93_SDP_EPF_OEI_RINT_ENA_W1S, -1ULL);
 	octep_write_csr64(oct, CN93_SDP_EPF_MISC_RINT_ENA_W1S, intr_mask);
 	octep_write_csr64(oct, CN93_SDP_EPF_DMA_RINT_ENA_W1S, intr_mask);
+	octep_write_csr64(oct, CN93_SDP_EPF_MBOX_RINT_ENA_W1S(0), -1ULL);
+	octep_write_csr64(oct, CN93_SDP_EPF_MBOX_RINT_ENA_W1S(1), -1ULL);
 }
 
 /* Disable all interrupts */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index d43161d1e38a..cd0d77ceb868 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -17,6 +17,7 @@
 #include "octep_config.h"
 #include "octep_main.h"
 #include "octep_ctrl_net.h"
+#include "octep_pfvf_mbox.h"
 
 #define OCTEP_INTR_POLL_TIME_MSECS    100
 struct workqueue_struct *octep_wq;
@@ -1001,11 +1002,7 @@ static void octep_device_cleanup(struct octep_device *oct)
 
 	dev_info(&oct->pdev->dev, "Cleaning up Octeon Device ...\n");
 
-	for (i = 0; i < OCTEP_MAX_VF; i++) {
-		vfree(oct->mbox[i]);
-		oct->mbox[i] = NULL;
-	}
-
+	octep_delete_pfvf_mbox(oct);
 	octep_ctrl_net_uninit(oct);
 
 	oct->hw_ops.soft_reset(oct);
@@ -1100,6 +1097,14 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev, "Device setup failed\n");
 		goto err_octep_config;
 	}
+
+	err = octep_setup_pfvf_mbox(octep_dev);
+	if (err) {
+		dev_err(&pdev->dev, " pfvf mailbox setup failed\n");
+		octep_ctrl_net_uninit(octep_dev);
+		return err;
+	}
+
 	INIT_WORK(&octep_dev->tx_timeout_task, octep_tx_timeout_task);
 	INIT_WORK(&octep_dev->ctrl_mbox_task, octep_ctrl_mbox_task);
 	INIT_DELAYED_WORK(&octep_dev->intr_poll_task, octep_intr_poll_task);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 70cc3e236cb4..ad6d324bd525 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -94,28 +94,27 @@ struct octep_mbox_data {
 	u64 *data;
 };
 
+#define MAX_VF_PF_MBOX_DATA_SIZE 384
+/* wrappers around work structs */
+struct octep_pfvf_mbox_wk {
+	struct work_struct work;
+	void *ctxptr;
+	u64 ctxul;
+};
+
 /* Octeon device mailbox */
 struct octep_mbox {
-	/* A spinlock to protect access to this q_mbox. */
-	spinlock_t lock;
-
-	u32 q_no;
-	u32 state;
-
-	/* SLI_MAC_PF_MBOX_INT for PF, SLI_PKT_MBOX_INT for VF. */
-	u8 __iomem *mbox_int_reg;
-
-	/* SLI_PKT_PF_VF_MBOX_SIG(0) for PF,
-	 * SLI_PKT_PF_VF_MBOX_SIG(1) for VF.
-	 */
-	u8 __iomem *mbox_write_reg;
-
-	/* SLI_PKT_PF_VF_MBOX_SIG(1) for PF,
-	 * SLI_PKT_PF_VF_MBOX_SIG(0) for VF.
-	 */
-	u8 __iomem *mbox_read_reg;
-
+	/* A mutex to protect access to this q_mbox. */
+	struct mutex lock;
+	u32 vf_id;
+	u32 config_data_index;
+	u32 message_len;
+	u8 __iomem *pf_vf_data_reg;
+	u8 __iomem *vf_pf_data_reg;
+	struct octep_pfvf_mbox_wk wk;
+	struct octep_device *oct;
 	struct octep_mbox_data mbox_data;
+	u8 config_data[MAX_VF_PF_MBOX_DATA_SIZE];
 };
 
 /* Tx/Rx queue vector per interrupt. */
@@ -193,6 +192,11 @@ struct octep_iface_link_info {
 	u8  oper_up;
 };
 
+/* The Octeon VF device specific info data structure.*/
+struct octep_pfvf_info {
+	u8 mac_addr[ETH_ALEN];
+};
+
 /* The Octeon device specific private data structure.
  * Each Octeon device has this structure to represent all its components.
  */
@@ -259,6 +263,8 @@ struct octep_device {
 
 	/* Mailbox to talk to VFs */
 	struct octep_mbox *mbox[OCTEP_MAX_VF];
+	/* VFs info */
+	struct octep_pfvf_info vf_info[OCTEP_MAX_VF];
 
 	/* Work entry to handle Tx timeout */
 	struct work_struct tx_timeout_task;
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
new file mode 100644
index 000000000000..01ead735a2e8
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+#include <linux/types.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mutex.h>
+#include <linux/jiffies.h>
+#include <linux/sched.h>
+#include <linux/sched/signal.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/etherdevice.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+#include "octep_pfvf_mbox.h"
+#include "octep_ctrl_net.h"
+
+static void octep_pfvf_validate_version(struct octep_device *oct,  u32 vf_id,
+					union octep_pfvf_mbox_word cmd,
+					union octep_pfvf_mbox_word *rsp)
+{
+	u32 vf_version = (u32)cmd.s_version.version;
+
+	if (vf_version <= OCTEP_PF_MBOX_VERSION)
+		rsp->s_version.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+	else
+		rsp->s_version.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+}
+
+static void octep_pfvf_get_link_status(struct octep_device *oct, u32 vf_id,
+				       union octep_pfvf_mbox_word cmd,
+				       union octep_pfvf_mbox_word *rsp)
+{
+	int status;
+
+	status = octep_ctrl_net_get_link_status(oct, vf_id);
+	if (status < 0) {
+		rsp->s_link_status.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		dev_err(&oct->pdev->dev, "Get VF link status failed via host control Mbox\n");
+		return;
+	}
+	rsp->s_link_status.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+	rsp->s_link_status.status = status;
+}
+
+static void octep_pfvf_set_link_status(struct octep_device *oct, u32 vf_id,
+				       union octep_pfvf_mbox_word cmd,
+				       union octep_pfvf_mbox_word *rsp)
+{
+	int err;
+
+	err = octep_ctrl_net_set_link_status(oct, vf_id, cmd.s_link_status.status, true);
+	if (err) {
+		rsp->s_link_status.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		dev_err(&oct->pdev->dev, "Set VF link status failed via host control Mbox\n");
+		return;
+	}
+	rsp->s_link_status.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+}
+
+static void octep_pfvf_set_rx_state(struct octep_device *oct, u32 vf_id,
+				    union octep_pfvf_mbox_word cmd,
+				    union octep_pfvf_mbox_word *rsp)
+{
+	int err;
+
+	err = octep_ctrl_net_set_rx_state(oct, vf_id, cmd.s_link_state.state, true);
+	if (err) {
+		rsp->s_link_state.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		dev_err(&oct->pdev->dev, "Set VF Rx link state failed via host control Mbox\n");
+		return;
+	}
+	rsp->s_link_state.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+}
+
+static void octep_pfvf_set_mtu(struct octep_device *oct, u32 vf_id,
+			       union octep_pfvf_mbox_word cmd,
+			       union octep_pfvf_mbox_word *rsp)
+{
+	int err;
+
+	err = octep_ctrl_net_set_mtu(oct, vf_id, cmd.s_set_mtu.mtu, true);
+	if (err) {
+		rsp->s_set_mtu.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		dev_err(&oct->pdev->dev, "Set VF MTU failed via host control Mbox\n");
+		return;
+	}
+	rsp->s_set_mtu.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+}
+
+static void octep_pfvf_set_mac_addr(struct octep_device *oct,  u32 vf_id,
+				    union octep_pfvf_mbox_word cmd,
+				    union octep_pfvf_mbox_word *rsp)
+{
+	int err;
+
+	err = octep_ctrl_net_set_mac_addr(oct, vf_id, cmd.s_set_mac.mac_addr, true);
+	if (err) {
+		rsp->s_set_mac.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		dev_err(&oct->pdev->dev, "Set VF MAC address failed via host control Mbox\n");
+		return;
+	}
+	rsp->s_set_mac.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+}
+
+static void octep_pfvf_get_mac_addr(struct octep_device *oct,  u32 vf_id,
+				    union octep_pfvf_mbox_word cmd,
+				    union octep_pfvf_mbox_word *rsp)
+{
+	int err;
+
+	err = octep_ctrl_net_get_mac_addr(oct, vf_id, rsp->s_set_mac.mac_addr);
+	if (err) {
+		rsp->s_set_mac.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		dev_err(&oct->pdev->dev, "Get VF MAC address failed via host control Mbox\n");
+		return;
+	}
+	rsp->s_set_mac.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+}
+
+int octep_setup_pfvf_mbox(struct octep_device *oct)
+{
+	int i = 0, num_vfs = 0, rings_per_vf = 0;
+	int ring = 0;
+
+	num_vfs = oct->conf->sriov_cfg.active_vfs;
+	rings_per_vf = oct->conf->sriov_cfg.max_rings_per_vf;
+
+	for (i = 0; i < num_vfs; i++) {
+		ring  = rings_per_vf * i;
+		oct->mbox[ring] = vzalloc(sizeof(*oct->mbox[ring]));
+
+		if (!oct->mbox[ring])
+			goto free_mbox;
+
+		memset(oct->mbox[ring], 0, sizeof(struct octep_mbox));
+		mutex_init(&oct->mbox[ring]->lock);
+		INIT_WORK(&oct->mbox[ring]->wk.work, octep_pfvf_mbox_work);
+		oct->mbox[ring]->wk.ctxptr = oct->mbox[i];
+
+		if (!oct->mbox[i])
+			oct->mbox[ring]->wk.ctxptr = oct->mbox[ring];
+
+		oct->mbox[ring]->oct = oct;
+		oct->mbox[ring]->vf_id = i;
+		oct->hw_ops.setup_mbox_regs(oct, ring);
+	}
+	return 0;
+
+free_mbox:
+	while (i) {
+		i--;
+		ring  = rings_per_vf * i;
+		cancel_work_sync(&oct->mbox[ring]->wk.work);
+		mutex_destroy(&oct->mbox[ring]->lock);
+		vfree(oct->mbox[ring]);
+		oct->mbox[ring] = NULL;
+	}
+	return 1;
+}
+
+void octep_delete_pfvf_mbox(struct octep_device *oct)
+{
+	int rings_per_vf = oct->conf->sriov_cfg.max_rings_per_vf;
+	int num_vfs = oct->conf->sriov_cfg.active_vfs;
+	int i = 0, ring = 0, vf_srn = 0;
+
+	for (i = 0; i < num_vfs; i++) {
+		ring  = vf_srn + rings_per_vf * i;
+		if (!oct->mbox[ring])
+			continue;
+
+		if (work_pending(&oct->mbox[ring]->wk.work))
+			cancel_work_sync(&oct->mbox[ring]->wk.work);
+		vfree(oct->mbox[ring]);
+		oct->mbox[ring] = NULL;
+	}
+}
+
+static void octep_pfvf_pf_get_data(struct octep_device *oct,
+				   struct octep_mbox *mbox, int vf_id,
+				   union octep_pfvf_mbox_word cmd,
+				   union octep_pfvf_mbox_word *rsp)
+{
+	int length = 0;
+	int i = 0;
+	int err;
+	struct octep_iface_link_info link_info;
+	struct octep_iface_rx_stats rx_stats;
+	struct octep_iface_tx_stats tx_stats;
+
+	rsp->s_data.type = OCTEP_PFVF_MBOX_TYPE_RSP_ACK;
+
+	if (cmd.s_data.frag != OCTEP_PFVF_MBOX_MORE_FRAG_FLAG) {
+		mbox->config_data_index = 0;
+		memset(mbox->config_data, 0, MAX_VF_PF_MBOX_DATA_SIZE);
+		/* Based on the OPCODE CMD the PF driver
+		 * specific API should be called to fetch
+		 * the requested data
+		 */
+		switch (cmd.s.opcode) {
+		case OCTEP_PFVF_MBOX_CMD_GET_LINK_INFO:
+			memset(&link_info, 0, sizeof(link_info));
+			err = octep_ctrl_net_get_link_info(oct, vf_id, &link_info);
+			if (!err) {
+				mbox->message_len = sizeof(link_info);
+				*((int32_t *)rsp->s_data.data) = mbox->message_len;
+				memcpy(mbox->config_data, (u8 *)&link_info, sizeof(link_info));
+			} else {
+				rsp->s_data.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+				return;
+			}
+			break;
+		case OCTEP_PFVF_MBOX_CMD_GET_STATS:
+			memset(&rx_stats, 0, sizeof(rx_stats));
+			memset(&tx_stats, 0, sizeof(tx_stats));
+			err = octep_ctrl_net_get_if_stats(oct, vf_id, &rx_stats, &tx_stats);
+			if (!err) {
+				mbox->message_len = sizeof(rx_stats) + sizeof(tx_stats);
+				*((int32_t *)rsp->s_data.data) = mbox->message_len;
+				memcpy(mbox->config_data, (u8 *)&rx_stats, sizeof(rx_stats));
+				memcpy(mbox->config_data + sizeof(rx_stats), (u8 *)&tx_stats,
+				       sizeof(tx_stats));
+
+			} else {
+				rsp->s_data.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+				return;
+			}
+			break;
+		}
+		*((int32_t *)rsp->s_data.data) = mbox->message_len;
+		return;
+	}
+
+	if (mbox->message_len > OCTEP_PFVF_MBOX_MAX_DATA_SIZE)
+		length = OCTEP_PFVF_MBOX_MAX_DATA_SIZE;
+	else
+		length = mbox->message_len;
+
+	mbox->message_len -= length;
+
+	for (i = 0; i < length; i++) {
+		rsp->s_data.data[i] =
+			mbox->config_data[mbox->config_data_index];
+		mbox->config_data_index++;
+	}
+}
+
+void octep_pfvf_mbox_work(struct work_struct *work)
+{
+	struct octep_pfvf_mbox_wk *wk = container_of(work, struct octep_pfvf_mbox_wk, work);
+	union octep_pfvf_mbox_word cmd = { 0 };
+	union octep_pfvf_mbox_word rsp = { 0 };
+	struct octep_mbox *mbox = NULL;
+	struct octep_device *oct = NULL;
+	int vf_id;
+
+	mbox = (struct octep_mbox *)wk->ctxptr;
+	oct = (struct octep_device *)mbox->oct;
+	vf_id = mbox->vf_id;
+
+	mutex_lock(&mbox->lock);
+	cmd.u64 = readq(mbox->vf_pf_data_reg);
+	rsp.u64 = 0;
+
+	switch (cmd.s.opcode) {
+	case OCTEP_PFVF_MBOX_CMD_VERSION:
+		octep_pfvf_validate_version(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_GET_LINK_STATUS:
+		octep_pfvf_get_link_status(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_SET_LINK_STATUS:
+		octep_pfvf_set_link_status(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_SET_RX_STATE:
+		octep_pfvf_set_rx_state(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_SET_MTU:
+		octep_pfvf_set_mtu(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_SET_MAC_ADDR:
+		octep_pfvf_set_mac_addr(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_GET_MAC_ADDR:
+		octep_pfvf_get_mac_addr(oct, vf_id, cmd, &rsp);
+		break;
+	case OCTEP_PFVF_MBOX_CMD_GET_LINK_INFO:
+	case OCTEP_PFVF_MBOX_CMD_GET_STATS:
+		octep_pfvf_pf_get_data(oct, mbox, vf_id, cmd, &rsp);
+		break;
+	default:
+		dev_err(&oct->pdev->dev, "PF-VF mailbox: invalid opcode %d\n", cmd.s.opcode);
+		rsp.s.type = OCTEP_PFVF_MBOX_TYPE_RSP_NACK;
+		break;
+	}
+	writeq(rsp.u64, mbox->vf_pf_data_reg);
+	mutex_unlock(&mbox->lock);
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.h b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.h
new file mode 100644
index 000000000000..d113f1310655
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.h
@@ -0,0 +1,126 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+#ifndef _OCTEP_PFVF_MBOX_H_
+#define _OCTEP_PFVF_MBOX_H_
+
+#define OCTEP_PF_MBOX_VERSION 1
+
+enum octep_pfvf_mbox_opcode {
+	OCTEP_PFVF_MBOX_CMD_VERSION,
+	OCTEP_PFVF_MBOX_CMD_SET_MTU,
+	OCTEP_PFVF_MBOX_CMD_SET_MAC_ADDR,
+	OCTEP_PFVF_MBOX_CMD_GET_MAC_ADDR,
+	OCTEP_PFVF_MBOX_CMD_GET_LINK_INFO,
+	OCTEP_PFVF_MBOX_CMD_GET_STATS,
+	OCTEP_PFVF_MBOX_CMD_SET_RX_STATE,
+	OCTEP_PFVF_MBOX_CMD_SET_LINK_STATUS,
+	OCTEP_PFVF_MBOX_CMD_GET_LINK_STATUS,
+	OCTEP_PFVF_MBOX_CMD_LAST,
+};
+
+enum octep_pfvf_mbox_word_type {
+	OCTEP_PFVF_MBOX_TYPE_CMD,
+	OCTEP_PFVF_MBOX_TYPE_RSP_ACK,
+	OCTEP_PFVF_MBOX_TYPE_RSP_NACK,
+};
+
+enum octep_pfvf_mbox_cmd_status {
+	OCTEP_PFVF_MBOX_CMD_STATUS_NOT_SETUP = 1,
+	OCTEP_PFVF_MBOX_CMD_STATUS_TIMEDOUT = 2,
+	OCTEP_PFVF_MBOX_CMD_STATUS_NACK = 3,
+	OCTEP_PFVF_MBOX_CMD_STATUS_BUSY = 4
+};
+
+enum octep_pfvf_mbox_state {
+	OCTEP_PFVF_MBOX_STATE_IDLE = 0,
+	OCTEP_PFVF_MBOX_STATE_BUSY = 1,
+};
+
+enum octep_pfvf_link_status {
+	OCTEP_PFVF_LINK_STATUS_DOWN,
+	OCTEP_PFVF_LINK_STATUS_UP,
+};
+
+enum octep_pfvf_link_speed {
+	OCTEP_PFVF_LINK_SPEED_NONE,
+	OCTEP_PFVF_LINK_SPEED_1000,
+	OCTEP_PFVF_LINK_SPEED_10000,
+	OCTEP_PFVF_LINK_SPEED_25000,
+	OCTEP_PFVF_LINK_SPEED_40000,
+	OCTEP_PFVF_LINK_SPEED_50000,
+	OCTEP_PFVF_LINK_SPEED_100000,
+	OCTEP_PFVF_LINK_SPEED_LAST,
+};
+
+enum octep_pfvf_link_duplex {
+	OCTEP_PFVF_LINK_HALF_DUPLEX,
+	OCTEP_PFVF_LINK_FULL_DUPLEX,
+};
+
+enum octep_pfvf_link_autoneg {
+	OCTEP_PFVF_LINK_AUTONEG,
+	OCTEP_PFVF_LINK_FIXED,
+};
+
+#define OCTEP_PFVF_MBOX_TIMEOUT_MS     500
+#define OCTEP_PFVF_MBOX_MAX_RETRIES    2
+#define OCTEP_PFVF_MBOX_VERSION        0
+#define OCTEP_PFVF_MBOX_MAX_DATA_SIZE  6
+#define OCTEP_PFVF_MBOX_MORE_FRAG_FLAG 1
+#define OCTEP_PFVF_MBOX_WRITE_WAIT_TIME msecs_to_jiffies(1)
+
+union octep_pfvf_mbox_word {
+	u64 u64;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u64 data:48;
+	} s;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 frag:1;
+		u64 rsvd:5;
+		u8 data[6];
+	} s_data;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u64 version:48;
+	} s_version;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u8 mac_addr[6];
+	} s_set_mac;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 rsvd:6;
+		u64 mtu:48;
+	} s_set_mtu;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 state:1;
+		u64 rsvd:53;
+	} s_link_state;
+	struct {
+		u64 opcode:8;
+		u64 type:2;
+		u64 status:1;
+		u64 rsvd:53;
+	} s_link_status;
+} __packed;
+
+void octep_pfvf_mbox_work(struct work_struct *work);
+int octep_setup_pfvf_mbox(struct octep_device *oct);
+void octep_delete_pfvf_mbox(struct octep_device *oct);
+#endif
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
index 0466fd9a002d..f29c4344fc41 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
@@ -208,6 +208,9 @@
 #define    CN93_SDP_R_MBOX_PF_VF_INT_START        0x10220
 #define    CN93_SDP_R_MBOX_VF_PF_DATA_START       0x10230
 
+#define    CN93_SDP_MBOX_VF_PF_DATA_START       0x24000
+#define    CN93_SDP_MBOX_PF_VF_DATA_START       0x22000
+
 #define    CN93_SDP_R_MBOX_PF_VF_DATA(ring)		\
 	(CN93_SDP_R_MBOX_PF_VF_DATA_START + ((ring) * CN93_RING_OFFSET))
 
@@ -217,6 +220,12 @@
 #define    CN93_SDP_R_MBOX_VF_PF_DATA(ring)		\
 	(CN93_SDP_R_MBOX_VF_PF_DATA_START + ((ring) * CN93_RING_OFFSET))
 
+#define    CN93_SDP_MBOX_VF_PF_DATA(ring)          \
+	(CN93_SDP_MBOX_VF_PF_DATA_START + ((ring) * CN93_EPVF_RING_OFFSET))
+
+#define    CN93_SDP_MBOX_PF_VF_DATA(ring)      \
+	(CN93_SDP_MBOX_PF_VF_DATA_START + ((ring) * CN93_EPVF_RING_OFFSET))
+
 /* ##################### Interrupt Registers ########################## */
 #define	   CN93_SDP_R_ERR_TYPE_START	          0x10400
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
index 2ef57980eb47..05788bf2cf08 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
@@ -45,6 +45,18 @@ struct octep_tx_buffer {
 
 /* Hardware interface Tx statistics */
 struct octep_iface_tx_stats {
+	/* Total frames sent on the interface */
+	u64 pkts;
+
+	/* Total octets sent on the interface */
+	u64 octs;
+
+	/* Packets sent to a broadcast DMAC */
+	u64 bcst;
+
+	/* Packets sent to the multicast DMAC */
+	u64 mcst;
+
 	/* Packets dropped due to excessive collisions */
 	u64 xscol;
 
@@ -61,12 +73,6 @@ struct octep_iface_tx_stats {
 	 */
 	u64 scol;
 
-	/* Total octets sent on the interface */
-	u64 octs;
-
-	/* Total frames sent on the interface */
-	u64 pkts;
-
 	/* Packets sent with an octet count < 64 */
 	u64 hist_lt64;
 
@@ -91,12 +97,6 @@ struct octep_iface_tx_stats {
 	/* Packets sent with an octet count of > 1518 */
 	u64 hist_gt1518;
 
-	/* Packets sent to a broadcast DMAC */
-	u64 bcst;
-
-	/* Packets sent to the multicast DMAC */
-	u64 mcst;
-
 	/* Packets sent that experienced a transmit underflow and were
 	 * truncated
 	 */
-- 
2.36.0

