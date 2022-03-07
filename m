Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65554CF598
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbiCGJaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238417AbiCGJ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:29:10 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E0A66F8B;
        Mon,  7 Mar 2022 01:27:19 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2278qQAk024110;
        Mon, 7 Mar 2022 01:26:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=o5OLRF+d6fLAlBzLtGKN/VVolq0Bx8KMaDQbvLPcoCI=;
 b=Ui9kLQ6e78izCmqWbxCq4vk9l1x1j8DNntoZJO5WIgWVRBXXG/K4EpoMCHI5QhmlRAn3
 bVmMByr3AQCGw1/RZ9i7WBYXH0pHCm/5XLFNkLljku7U+KRnjeUbA6OWMKR0Vab8Jm3a
 IjiDo94ckZoKJeHe8n9NCd43T46ErPDu3JQuqYj5NdYyEhTlSinZrNyjNiumtlq8U4Hk
 gnY+owKttIhGnK5tAX+TXkwm+HxCS3trtAjwZVNECgegfzGUbHh2N9YgIT+70SzLQIKp
 u/iaUDgwEUqpodEx7dREj4w3CnIKooPPnqiWwpx1FiiaMyYjpGm1UjR50tcEIAQTkGbL bA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3em88re1h5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 01:26:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Mar
 2022 01:26:49 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 7 Mar 2022 01:26:49 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 5F1D53F7044;
        Mon,  7 Mar 2022 01:26:49 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <vburru@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <corbet@lwn.net>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: [PATCH v3 1/7] octeon_ep: Add driver framework and device initialization
Date:   Mon, 7 Mar 2022 01:26:40 -0800
Message-ID: <20220307092646.17156-2-vburru@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220307092646.17156-1-vburru@marvell.com>
References: <20220307092646.17156-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: hR94wpMzJQ3Gte2QkXgXuYs7K5A72AiG
X-Proofpoint-GUID: hR94wpMzJQ3Gte2QkXgXuYs7K5A72AiG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_01,2022-03-04_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver framework and device setup and initialization for Octeon
PCI Endpoint NIC.

Add implementation to load module, initilaize, register network device,
cleanup and unload module.

Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
Signed-off-by: Satananda Burla <sburla@marvell.com>
---
V2 -> V3:
  - fix the Title overline & underline mismatch in octeon_ep.rst,
    reported by kernel test robot:
    Reported-by: kernel test robot <lkp@intel.com>

V1 -> V2:
  - split the patch into smaller patches.
  - fix build errors observed with clang and "make W=1 C=1".

 .../device_drivers/ethernet/index.rst         |   1 +
 .../ethernet/marvell/octeon_ep.rst            |  35 ++
 MAINTAINERS                                   |   7 +
 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/Makefile         |   1 +
 .../net/ethernet/marvell/octeon_ep/Kconfig    |  20 +
 .../net/ethernet/marvell/octeon_ep/Makefile   |   9 +
 .../marvell/octeon_ep/octep_cn9k_pf.c         | 241 +++++++++
 .../ethernet/marvell/octeon_ep/octep_config.h | 204 +++++++
 .../marvell/octeon_ep/octep_ctrl_mbox.c       |  84 +++
 .../marvell/octeon_ep/octep_ctrl_mbox.h       | 170 ++++++
 .../marvell/octeon_ep/octep_ctrl_net.c        |  42 ++
 .../marvell/octeon_ep/octep_ctrl_net.h        | 299 ++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.c   | 512 ++++++++++++++++++
 .../ethernet/marvell/octeon_ep/octep_main.h   | 379 +++++++++++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    | 367 +++++++++++++
 .../net/ethernet/marvell/octeon_ep/octep_rx.c |  42 ++
 .../net/ethernet/marvell/octeon_ep/octep_rx.h | 199 +++++++
 .../net/ethernet/marvell/octeon_ep/octep_tx.c |  43 ++
 .../net/ethernet/marvell/octeon_ep/octep_tx.h | 284 ++++++++++
 20 files changed, 2940 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Makefile
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_config.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h

diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 6b5dc203da2b..21a97703421d 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -39,6 +39,7 @@ Contents:
    intel/iavf
    intel/ice
    marvell/octeontx2
+   marvell/octeon_ep
    mellanox/mlx5
    microsoft/netvsc
    neterion/s2io
diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
new file mode 100644
index 000000000000..bc562c49011b
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+====================================================================
+Linux kernel networking driver for Marvell's Octeon PCI Endpoint NIC
+====================================================================
+
+Network driver for Marvell's Octeon PCI EndPoint NIC.
+Copyright (c) 2020 Marvell International Ltd.
+
+Contents
+========
+
+- `Overview`_
+- `Supported Devices`_
+- `Interface Control`_
+
+Overview
+========
+This driver implements networking functionality of Marvell's Octeon PCI
+EndPoint NIC.
+
+Supported Devices
+=================
+Currently, this driver support following devices:
+ * Network controller: Cavium, Inc. Device b200
+
+Interface Control
+=================
+Network Interface control like changing mtu, link speed, link down/up are
+done by writing command to mailbox command queue, a mailbox interface
+implemented through a reserved region in BAR4.
+This driver writes the commands into the mailbox and the firmware on the
+Octeon device processes them. The firmware also sends unsolicited notifications
+to driver for events suchs as link change, through notification queue
+implemented as part of mailbox interface.
diff --git a/MAINTAINERS b/MAINTAINERS
index cb75c5d6d78b..41e9d60930b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11606,6 +11606,13 @@ S:	Supported
 F:	Documentation/devicetree/bindings/mmc/marvell,xenon-sdhci.txt
 F:	drivers/mmc/host/sdhci-xenon*
 
+MARVELL OCTEON ENDPOINT DRIVER
+M:	Veerasenareddy Burru <vburru@marvell.com>
+M:	Abhijit Ayarekar <aayarekar@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/ethernet/marvell/octeon_ep
+
 MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
index fe0989c0fc25..4cb55724001b 100644
--- a/drivers/net/ethernet/marvell/Kconfig
+++ b/drivers/net/ethernet/marvell/Kconfig
@@ -177,6 +177,7 @@ config SKY2_DEBUG
 
 
 source "drivers/net/ethernet/marvell/octeontx2/Kconfig"
+source "drivers/net/ethernet/marvell/octeon_ep/Kconfig"
 source "drivers/net/ethernet/marvell/prestera/Kconfig"
 
 endif # NET_VENDOR_MARVELL
diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/marvell/Makefile
index 9f88fe822555..ceba4aa4f026 100644
--- a/drivers/net/ethernet/marvell/Makefile
+++ b/drivers/net/ethernet/marvell/Makefile
@@ -11,5 +11,6 @@ obj-$(CONFIG_MVPP2) += mvpp2/
 obj-$(CONFIG_PXA168_ETH) += pxa168_eth.o
 obj-$(CONFIG_SKGE) += skge.o
 obj-$(CONFIG_SKY2) += sky2.o
+obj-y		+= octeon_ep/
 obj-y		+= octeontx2/
 obj-y		+= prestera/
diff --git a/drivers/net/ethernet/marvell/octeon_ep/Kconfig b/drivers/net/ethernet/marvell/octeon_ep/Kconfig
new file mode 100644
index 000000000000..0d7db815340e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/Kconfig
@@ -0,0 +1,20 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Marvell's Octeon PCI Endpoint NIC Driver Configuration
+#
+
+config OCTEON_EP
+	tristate "Marvell Octeon PCI Endpoint NIC Driver"
+	depends on 64BIT
+	depends on PCI
+	depends on PTP_1588_CLOCK_OPTIONAL
+	help
+	  This driver supports networking functionality of Marvell's
+	  Octeon PCI Endpoint NIC.
+
+	  To know the list of devices supported by this driver, refer
+	  documentation in
+	  <file:Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst>.
+
+	  To compile this drivers as a module, choose M here. Name of the
+	  module is octeon_ep.
diff --git a/drivers/net/ethernet/marvell/octeon_ep/Makefile b/drivers/net/ethernet/marvell/octeon_ep/Makefile
new file mode 100644
index 000000000000..6e2db8e80b4a
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Network driver for Marvell's Octeon PCI Endpoint NIC
+#
+
+obj-$(CONFIG_OCTEON_EP) += octeon_ep.o
+
+octeon_ep-y := octep_main.o octep_cn9k_pf.o octep_tx.o octep_rx.o \
+	       octep_ctrl_mbox.o octep_ctrl_net.o
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
new file mode 100644
index 000000000000..a38b52788619
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -0,0 +1,241 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+#include "octep_regs_cn9k_pf.h"
+
+/* Names of Hardware non-queue generic interrupts */
+static char *cn93_non_ioq_msix_names[] = {
+	"epf_ire_rint",
+	"epf_ore_rint",
+	"epf_vfire_rint0",
+	"epf_vfire_rint1",
+	"epf_vfore_rint0",
+	"epf_vfore_rint1",
+	"epf_mbox_rint0",
+	"epf_mbox_rint1",
+	"epf_oei_rint",
+	"epf_dma_rint",
+	"epf_dma_vf_rint0",
+	"epf_dma_vf_rint1",
+	"epf_pp_vf_rint0",
+	"epf_pp_vf_rint1",
+	"epf_misc_rint",
+	"epf_rsvd",
+};
+
+/* Reset all hardware Tx/Rx queues */
+static void octep_reset_io_queues_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Initialize windowed addresses to access some hardware registers */
+static void octep_setup_pci_window_regs_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Configure Hardware mapping: inform hardware which rings belong to PF. */
+static void octep_configure_ring_mapping_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Initialize configuration limits and initial active config 93xx PF. */
+static void octep_init_config_cn93_pf(struct octep_device *oct)
+{
+	struct octep_config *conf = oct->conf;
+	struct pci_dev *pdev = oct->pdev;
+	u64 val;
+
+	/* Read ring configuration:
+	 * PF ring count, number of VFs and rings per VF supported
+	 */
+	val = octep_read_csr64(oct, CN93_SDP_EPF_RINFO);
+	conf->sriov_cfg.max_rings_per_vf = CN93_SDP_EPF_RINFO_RPVF(val);
+	conf->sriov_cfg.active_rings_per_vf = conf->sriov_cfg.max_rings_per_vf;
+	conf->sriov_cfg.max_vfs = CN93_SDP_EPF_RINFO_NVFS(val);
+	conf->sriov_cfg.active_vfs = conf->sriov_cfg.max_vfs;
+	conf->sriov_cfg.vf_srn = CN93_SDP_EPF_RINFO_SRN(val);
+
+	val = octep_read_csr64(oct, CN93_SDP_MAC_PF_RING_CTL(oct->pcie_port));
+	conf->pf_ring_cfg.srn =  CN93_SDP_MAC_PF_RING_CTL_SRN(val);
+	conf->pf_ring_cfg.max_io_rings = CN93_SDP_MAC_PF_RING_CTL_RPPF(val);
+	conf->pf_ring_cfg.active_io_rings = conf->pf_ring_cfg.max_io_rings;
+	dev_info(&pdev->dev, "pf_srn=%u rpvf=%u nvfs=%u rppf=%u\n",
+		 conf->pf_ring_cfg.srn, conf->sriov_cfg.active_rings_per_vf,
+		 conf->sriov_cfg.active_vfs, conf->pf_ring_cfg.active_io_rings);
+
+	conf->iq.num_descs = OCTEP_IQ_MAX_DESCRIPTORS;
+	conf->iq.instr_type = OCTEP_64BYTE_INSTR;
+	conf->iq.pkind = 0;
+	conf->iq.db_min = OCTEP_DB_MIN;
+	conf->iq.intr_threshold = OCTEP_IQ_INTR_THRESHOLD;
+
+	conf->oq.num_descs = OCTEP_OQ_MAX_DESCRIPTORS;
+	conf->oq.buf_size = OCTEP_OQ_BUF_SIZE;
+	conf->oq.refill_threshold = OCTEP_OQ_REFILL_THRESHOLD;
+	conf->oq.oq_intr_pkt = OCTEP_OQ_INTR_PKT_THRESHOLD;
+	conf->oq.oq_intr_time = OCTEP_OQ_INTR_TIME_THRESHOLD;
+
+	conf->msix_cfg.non_ioq_msix = CN93_NUM_NON_IOQ_INTR;
+	conf->msix_cfg.ioq_msix = conf->pf_ring_cfg.active_io_rings;
+	conf->msix_cfg.non_ioq_msix_names = cn93_non_ioq_msix_names;
+
+	conf->ctrl_mbox_cfg.barmem_addr = (void __iomem *)oct->mmio[2].hw_addr + (0x400000ull * 7);
+}
+
+/* Setup registers for a hardware Tx Queue  */
+static void octep_setup_iq_regs_cn93_pf(struct octep_device *oct, int iq_no)
+{
+}
+
+/* Setup registers for a hardware Rx Queue  */
+static void octep_setup_oq_regs_cn93_pf(struct octep_device *oct, int oq_no)
+{
+}
+
+/* Setup registers for a PF mailbox */
+static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
+{
+}
+
+/* Interrupts handler for all non-queue generic interrupts. */
+static irqreturn_t octep_non_ioq_intr_handler_cn93_pf(void *dev)
+{
+	return IRQ_HANDLED;
+}
+
+/* Tx/Rx queue interrupt handler */
+static irqreturn_t octep_ioq_intr_handler_cn93_pf(void *data)
+{
+	return IRQ_HANDLED;
+}
+
+/* soft reset of 93xx */
+static int octep_soft_reset_cn93_pf(struct octep_device *oct)
+{
+	dev_info(&oct->pdev->dev, "CN93XX: Doing soft reset\n");
+
+	octep_write_csr64(oct, CN93_SDP_WIN_WR_MASK_REG, 0xFF);
+
+	/* Set core domain reset bit */
+	OCTEP_PCI_WIN_WRITE(oct, CN93_RST_CORE_DOMAIN_W1S, 1);
+	/* Wait for 100ms as Octeon resets. */
+	mdelay(100);
+	/* clear core domain reset bit */
+	OCTEP_PCI_WIN_WRITE(oct, CN93_RST_CORE_DOMAIN_W1C, 1);
+
+	return 0;
+}
+
+/* Re-initialize Octeon hardware registers */
+static void octep_reinit_regs_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Enable all interrupts */
+static void octep_enable_interrupts_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Disable all interrupts */
+static void octep_disable_interrupts_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Get new Octeon Read Index: index of descriptor that Octeon reads next. */
+static u32 octep_update_iq_read_index_cn93_pf(struct octep_iq *iq)
+{
+	return 0;
+}
+
+/* Enable a hardware Tx Queue */
+static void octep_enable_iq_cn93_pf(struct octep_device *oct, int iq_no)
+{
+}
+
+/* Enable a hardware Rx Queue */
+static void octep_enable_oq_cn93_pf(struct octep_device *oct, int oq_no)
+{
+}
+
+/* Enable all hardware Tx/Rx Queues assined to PF */
+static void octep_enable_io_queues_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Disable a hardware Tx Queue assined to PF */
+static void octep_disable_iq_cn93_pf(struct octep_device *oct, int iq_no)
+{
+}
+
+/* Disable a hardware Rx Queue assined to PF */
+static void octep_disable_oq_cn93_pf(struct octep_device *oct, int oq_no)
+{
+}
+
+/* Disable all hardware Tx/Rx Queues assined to PF */
+static void octep_disable_io_queues_cn93_pf(struct octep_device *oct)
+{
+}
+
+/* Dump hardware registers (including Tx/Rx queues) for debugging. */
+static void octep_dump_registers_cn93_pf(struct octep_device *oct)
+{
+}
+
+/**
+ * octep_device_setup_cn93_pf() - Setup Octeon device.
+ *
+ * @oct: Octeon device private data structure.
+ *
+ * - initialize hardware operations.
+ * - get target side pcie port number for the device.
+ * - setup window access to hardware registers.
+ * - set initial configuration and max limits.
+ * - setup hardware mapping of rings to the PF device.
+ */
+void octep_device_setup_cn93_pf(struct octep_device *oct)
+{
+	oct->hw_ops.setup_iq_regs = octep_setup_iq_regs_cn93_pf;
+	oct->hw_ops.setup_oq_regs = octep_setup_oq_regs_cn93_pf;
+	oct->hw_ops.setup_mbox_regs = octep_setup_mbox_regs_cn93_pf;
+
+	oct->hw_ops.non_ioq_intr_handler = octep_non_ioq_intr_handler_cn93_pf;
+	oct->hw_ops.ioq_intr_handler = octep_ioq_intr_handler_cn93_pf;
+	oct->hw_ops.soft_reset = octep_soft_reset_cn93_pf;
+	oct->hw_ops.reinit_regs = octep_reinit_regs_cn93_pf;
+
+	oct->hw_ops.enable_interrupts = octep_enable_interrupts_cn93_pf;
+	oct->hw_ops.disable_interrupts = octep_disable_interrupts_cn93_pf;
+
+	oct->hw_ops.update_iq_read_idx = octep_update_iq_read_index_cn93_pf;
+
+	oct->hw_ops.enable_iq = octep_enable_iq_cn93_pf;
+	oct->hw_ops.enable_oq = octep_enable_oq_cn93_pf;
+	oct->hw_ops.enable_io_queues = octep_enable_io_queues_cn93_pf;
+
+	oct->hw_ops.disable_iq = octep_disable_iq_cn93_pf;
+	oct->hw_ops.disable_oq = octep_disable_oq_cn93_pf;
+	oct->hw_ops.disable_io_queues = octep_disable_io_queues_cn93_pf;
+	oct->hw_ops.reset_io_queues = octep_reset_io_queues_cn93_pf;
+
+	oct->hw_ops.dump_registers = octep_dump_registers_cn93_pf;
+
+	octep_setup_pci_window_regs_cn93_pf(oct);
+
+	oct->pcie_port = octep_read_csr64(oct, CN93_SDP_MAC_NUMBER) & 0xff;
+	dev_info(&oct->pdev->dev,
+		 "Octeon device using PCIE Port %d\n", oct->pcie_port);
+
+	octep_init_config_cn93_pf(oct);
+	octep_configure_ring_mapping_cn93_pf(oct);
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_config.h b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
new file mode 100644
index 000000000000..f208f3f9a447
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_config.h
@@ -0,0 +1,204 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef _OCTEP_CONFIG_H_
+#define _OCTEP_CONFIG_H_
+
+/* Tx instruction types by length */
+#define OCTEP_32BYTE_INSTR  32
+#define OCTEP_64BYTE_INSTR  64
+
+/* Tx Queue: maximum descriptors per ring */
+#define OCTEP_IQ_MAX_DESCRIPTORS    1024
+/* Minimum input (Tx) requests to be enqueued to ring doorbell */
+#define OCTEP_DB_MIN                1
+/* Packet threshold for Tx queue interrupt */
+#define OCTEP_IQ_INTR_THRESHOLD     0x0
+
+/* Rx Queue: maximum descriptors per ring */
+#define OCTEP_OQ_MAX_DESCRIPTORS   1024
+
+/* Rx buffer size: Use page size buffers.
+ * Build skb from allocated page buffer once the packet is received.
+ * When a gathered packet is received, make head page as skb head and
+ * page buffers in consecutive Rx descriptors as fragments.
+ */
+#define OCTEP_OQ_BUF_SIZE          (SKB_WITH_OVERHEAD(PAGE_SIZE))
+#define OCTEP_OQ_PKTS_PER_INTR     128
+#define OCTEP_OQ_REFILL_THRESHOLD  (OCTEP_OQ_MAX_DESCRIPTORS / 4)
+
+#define OCTEP_OQ_INTR_PKT_THRESHOLD   1
+#define OCTEP_OQ_INTR_TIME_THRESHOLD  10
+
+#define OCTEP_MSIX_NAME_SIZE      (IFNAMSIZ + 32)
+
+/* Tx Queue wake threshold
+ * wakeup a stopped Tx queue if minimum 2 descriptors are available.
+ * Even a skb with fragments consume only one Tx queue descriptor entry.
+ */
+#define OCTEP_WAKE_QUEUE_THRESHOLD 2
+
+/* Minimum MTU supported by Octeon network interface */
+#define OCTEP_MIN_MTU        ETH_MIN_MTU
+/* Maximum MTU supported by Octeon interface*/
+#define OCTEP_MAX_MTU        (10000 - (ETH_HLEN + ETH_FCS_LEN))
+/* Default MTU */
+#define OCTEP_DEFAULT_MTU    1500
+
+/* Macros to get octeon config params */
+#define CFG_GET_IQ_CFG(cfg)             ((cfg)->iq)
+#define CFG_GET_IQ_NUM_DESC(cfg)        ((cfg)->iq.num_descs)
+#define CFG_GET_IQ_INSTR_TYPE(cfg)      ((cfg)->iq.instr_type)
+#define CFG_GET_IQ_PKIND(cfg)           ((cfg)->iq.pkind)
+#define CFG_GET_IQ_INSTR_SIZE(cfg)      (64)
+#define CFG_GET_IQ_DB_MIN(cfg)          ((cfg)->iq.db_min)
+#define CFG_GET_IQ_INTR_THRESHOLD(cfg)  ((cfg)->iq.intr_threshold)
+
+#define CFG_GET_OQ_NUM_DESC(cfg)          ((cfg)->oq.num_descs)
+#define CFG_GET_OQ_BUF_SIZE(cfg)          ((cfg)->oq.buf_size)
+#define CFG_GET_OQ_REFILL_THRESHOLD(cfg)  ((cfg)->oq.refill_threshold)
+#define CFG_GET_OQ_INTR_PKT(cfg)          ((cfg)->oq.oq_intr_pkt)
+#define CFG_GET_OQ_INTR_TIME(cfg)         ((cfg)->oq.oq_intr_time)
+
+#define CFG_GET_PORTS_MAX_IO_RINGS(cfg)    ((cfg)->pf_ring_cfg.max_io_rings)
+#define CFG_GET_PORTS_ACTIVE_IO_RINGS(cfg) ((cfg)->pf_ring_cfg.active_io_rings)
+#define CFG_GET_PORTS_PF_SRN(cfg)          ((cfg)->pf_ring_cfg.srn)
+
+#define CFG_GET_DPI_PKIND(cfg)            ((cfg)->core_cfg.dpi_pkind)
+#define CFG_GET_CORE_TICS_PER_US(cfg)     ((cfg)->core_cfg.core_tics_per_us)
+#define CFG_GET_COPROC_TICS_PER_US(cfg)   ((cfg)->core_cfg.coproc_tics_per_us)
+
+#define CFG_GET_MAX_VFS(cfg)        ((cfg)->sriov_cfg.max_vfs)
+#define CFG_GET_ACTIVE_VFS(cfg)     ((cfg)->sriov_cfg.active_vfs)
+#define CFG_GET_MAX_RPVF(cfg)       ((cfg)->sriov_cfg.max_rings_per_vf)
+#define CFG_GET_ACTIVE_RPVF(cfg)    ((cfg)->sriov_cfg.active_rings_per_vf)
+#define CFG_GET_VF_SRN(cfg)         ((cfg)->sriov_cfg.vf_srn)
+
+#define CFG_GET_IOQ_MSIX(cfg)            ((cfg)->msix_cfg.ioq_msix)
+#define CFG_GET_NON_IOQ_MSIX(cfg)        ((cfg)->msix_cfg.non_ioq_msix)
+#define CFG_GET_NON_IOQ_MSIX_NAMES(cfg)  ((cfg)->msix_cfg.non_ioq_msix_names)
+
+#define CFG_GET_CTRL_MBOX_MEM_ADDR(cfg)  ((cfg)->ctrl_mbox_cfg.barmem_addr)
+
+/* Hardware Tx Queue configuration. */
+struct octep_iq_config {
+	/* Size of the Input queue (number of commands) */
+	u16 num_descs;
+
+	/* Command size - 32 or 64 bytes */
+	u16 instr_type;
+
+	/* pkind for packets sent to Octeon */
+	u16 pkind;
+
+	/* Minimum number of commands pending to be posted to Octeon before driver
+	 * hits the Input queue doorbell.
+	 */
+	u16 db_min;
+
+	/* Trigger the IQ interrupt when processed cmd count reaches
+	 * this level.
+	 */
+	u32 intr_threshold;
+};
+
+/* Hardware Rx Queue configuration. */
+struct octep_oq_config {
+	/* Size of Output queue (number of descriptors) */
+	u16 num_descs;
+
+	/* Size of buffer in this Output queue. */
+	u16 buf_size;
+
+	/* The number of buffers that were consumed during packet processing
+	 * by the driver on this Output queue before the driver attempts to
+	 * replenish the descriptor ring with new buffers.
+	 */
+	u16 refill_threshold;
+
+	/* Interrupt Coalescing (Packet Count). Octeon will interrupt the host
+	 * only if it sent as many packets as specified by this field.
+	 * The driver usually does not use packet count interrupt coalescing.
+	 */
+	u32 oq_intr_pkt;
+
+	/* Interrupt Coalescing (Time Interval). Octeon will interrupt the host
+	 * if at least one packet was sent in the time interval specified by
+	 * this field. The driver uses time interval interrupt coalescing by
+	 * default. The time is specified in microseconds.
+	 */
+	u32 oq_intr_time;
+};
+
+/* Tx/Rx configuration */
+struct octep_pf_ring_config {
+	/* Max number of IOQs */
+	u16 max_io_rings;
+
+	/* Number of active IOQs */
+	u16 active_io_rings;
+
+	/* Starting IOQ number: this changes based on which PEM is used */
+	u16 srn;
+};
+
+/* Octeon Hardware SRIOV config */
+struct octep_sriov_config {
+	/* Max number of VF devices supported */
+	u16 max_vfs;
+
+	/* Number of VF devices enabled   */
+	u16 active_vfs;
+
+	/* Max number of rings assigned to VF  */
+	u8 max_rings_per_vf;
+
+	/* Number of rings enabled per VF */
+	u8 active_rings_per_vf;
+
+	/* starting ring number of VF's: ring-0 of VF-0 of the PF */
+	u16 vf_srn;
+};
+
+/* Octeon MSI-x config. */
+struct octep_msix_config {
+	/* Number of IOQ interrupts */
+	u16 ioq_msix;
+
+	/* Number of Non IOQ interrupts */
+	u16 non_ioq_msix;
+
+	/* Names of Non IOQ interrupts */
+	char **non_ioq_msix_names;
+};
+
+struct octep_ctrl_mbox_config {
+	/* Barmem address for control mbox */
+	void __iomem *barmem_addr;
+};
+
+/* Data Structure to hold configuration limits and active config */
+struct octep_config {
+	/* Input Queue attributes. */
+	struct octep_iq_config iq;
+
+	/* Output Queue attributes. */
+	struct octep_oq_config oq;
+
+	/* NIC Port Configuration */
+	struct octep_pf_ring_config pf_ring_cfg;
+
+	/* SRIOV configuration of the PF */
+	struct octep_sriov_config sriov_cfg;
+
+	/* MSI-X interrupt config */
+	struct octep_msix_config msix_cfg;
+
+	/* ctrl mbox config */
+	struct octep_ctrl_mbox_config ctrl_mbox_cfg;
+};
+#endif /* _OCTEP_CONFIG_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
new file mode 100644
index 000000000000..72a60c2a3cf0
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
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
+#include "octep_ctrl_mbox.h"
+#include "octep_config.h"
+#include "octep_main.h"
+
+/* Timeout in msecs for message response */
+#define OCTEP_CTRL_MBOX_MSG_TIMEOUT_MS			100
+/* Time in msecs to wait for message response */
+#define OCTEP_CTRL_MBOX_MSG_WAIT_MS			10
+
+#define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(m)	(m)
+#define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(m)	((m) + 8)
+#define OCTEP_CTRL_MBOX_INFO_HOST_VERSION_OFFSET(m)	((m) + 16)
+#define OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(m)	((m) + 24)
+#define OCTEP_CTRL_MBOX_INFO_FW_VERSION_OFFSET(m)	((m) + 136)
+#define OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(m)	((m) + 144)
+
+#define OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)		((m) + OCTEP_CTRL_MBOX_INFO_SZ)
+#define OCTEP_CTRL_MBOX_H2FQ_PROD_OFFSET(m)		(OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m))
+#define OCTEP_CTRL_MBOX_H2FQ_CONS_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 4)
+#define OCTEP_CTRL_MBOX_H2FQ_ELEM_SZ_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 8)
+#define OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(m)		((OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)) + 12)
+
+#define OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)		((m) + \
+							 OCTEP_CTRL_MBOX_INFO_SZ + \
+							 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ)
+#define OCTEP_CTRL_MBOX_F2HQ_PROD_OFFSET(m)		(OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m))
+#define OCTEP_CTRL_MBOX_F2HQ_CONS_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 4)
+#define OCTEP_CTRL_MBOX_F2HQ_ELEM_SZ_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 8)
+#define OCTEP_CTRL_MBOX_F2HQ_ELEM_CNT_OFFSET(m)		((OCTEP_CTRL_MBOX_F2HQ_INFO_OFFSET(m)) + 12)
+
+#define OCTEP_CTRL_MBOX_Q_OFFSET(m, i)			((m) + \
+							 (sizeof(struct octep_ctrl_mbox_msg) * (i)))
+
+static inline u32 octep_ctrl_mbox_circq_inc(u32 index, u32 mask)
+{
+	return (index + 1) & mask;
+}
+
+static inline u32 octep_ctrl_mbox_circq_space(u32 pi, u32 ci, u32 mask)
+{
+	return mask - ((pi - ci) & mask);
+}
+
+static inline u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
+{
+	return ((pi - ci) & mask);
+}
+
+int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
+{
+	return -EINVAL;
+}
+
+int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
+{
+	return -EINVAL;
+}
+
+int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg)
+{
+	return -EINVAL;
+}
+
+int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox)
+{
+	return -EINVAL;
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
new file mode 100644
index 000000000000..d5ad58c6bbaa
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+ #ifndef __OCTEP_CTRL_MBOX_H__
+#define __OCTEP_CTRL_MBOX_H__
+
+/*              barmem structure
+ * |===========================================|
+ * |Info (16 + 120 + 120 = 256 bytes)          |
+ * |-------------------------------------------|
+ * |magic number (8 bytes)                     |
+ * |bar memory size (4 bytes)                  |
+ * |reserved (4 bytes)                         |
+ * |-------------------------------------------|
+ * |host version (8 bytes)                     |
+ * |host status (8 bytes)                      |
+ * |host reserved (104 bytes)                  |
+ * |-------------------------------------------|
+ * |fw version (8 bytes)                       |
+ * |fw status (8 bytes)                        |
+ * |fw reserved (104 bytes)                    |
+ * |===========================================|
+ * |Host to Fw Queue info (16 bytes)           |
+ * |-------------------------------------------|
+ * |producer index (4 bytes)                   |
+ * |consumer index (4 bytes)                   |
+ * |element size (4 bytes)                     |
+ * |element count (4 bytes)                    |
+ * |===========================================|
+ * |Fw to Host Queue info (16 bytes)           |
+ * |-------------------------------------------|
+ * |producer index (4 bytes)                   |
+ * |consumer index (4 bytes)                   |
+ * |element size (4 bytes)                     |
+ * |element count (4 bytes)                    |
+ * |===========================================|
+ * |Host to Fw Queue                           |
+ * |-------------------------------------------|
+ * |((elem_sz + hdr(8 bytes)) * elem_cnt) bytes|
+ * |===========================================|
+ * |===========================================|
+ * |Fw to Host Queue                           |
+ * |-------------------------------------------|
+ * |((elem_sz + hdr(8 bytes)) * elem_cnt) bytes|
+ * |===========================================|
+ */
+
+#define OCTEP_CTRL_MBOX_MAGIC_NUMBER			0xdeaddeadbeefbeefull
+
+/* Size of mbox info in bytes */
+#define OCTEP_CTRL_MBOX_INFO_SZ				256
+/* Size of mbox host to target queue info in bytes */
+#define OCTEP_CTRL_MBOX_H2FQ_INFO_SZ			16
+/* Size of mbox target to host queue info in bytes */
+#define OCTEP_CTRL_MBOX_F2HQ_INFO_SZ			16
+/* Size of mbox queue in bytes */
+#define OCTEP_CTRL_MBOX_Q_SZ(sz, cnt)			(((sz) + 8) * (cnt))
+/* Size of mbox in bytes */
+#define OCTEP_CTRL_MBOX_SZ(hsz, hcnt, fsz, fcnt)	(OCTEP_CTRL_MBOX_INFO_SZ + \
+							 OCTEP_CTRL_MBOX_H2FQ_INFO_SZ + \
+							 OCTEP_CTRL_MBOX_F2HQ_INFO_SZ + \
+							 OCTEP_CTRL_MBOX_Q_SZ(hsz, hcnt) + \
+							 OCTEP_CTRL_MBOX_Q_SZ(fsz, fcnt))
+
+/* Valid request message */
+#define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ		BIT(0)
+/* Valid response message */
+#define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_RESP		BIT(1)
+/* Valid notification, no response required */
+#define OCTEP_CTRL_MBOX_MSG_HDR_FLAG_NOTIFY		BIT(2)
+
+enum octep_ctrl_mbox_status {
+	OCTEP_CTRL_MBOX_STATUS_INVALID = 0,
+	OCTEP_CTRL_MBOX_STATUS_INIT,
+	OCTEP_CTRL_MBOX_STATUS_READY,
+	OCTEP_CTRL_MBOX_STATUS_UNINIT
+};
+
+/* mbox message */
+union octep_ctrl_mbox_msg_hdr {
+	u64 word0;
+	struct {
+		/* OCTEP_CTRL_MBOX_MSG_HDR_FLAG_* */
+		u32 flags;
+		/* size of message in words excluding header */
+		u32 sizew;
+	};
+};
+
+/* mbox message */
+struct octep_ctrl_mbox_msg {
+	/* mbox transaction header */
+	union octep_ctrl_mbox_msg_hdr hdr;
+	/* pointer to message buffer */
+	void *msg;
+};
+
+/* Mbox queue */
+struct octep_ctrl_mbox_q {
+	/* q element size, should be aligned to unsigned long */
+	u16 elem_sz;
+	/* q element count, should be power of 2 */
+	u16 elem_cnt;
+	/* q mask */
+	u16 mask;
+	/* producer address in bar mem */
+	void __iomem *hw_prod;
+	/* consumer address in bar mem */
+	void __iomem *hw_cons;
+	/* q base address in bar mem */
+	void __iomem *hw_q;
+};
+
+struct octep_ctrl_mbox {
+	/* host driver version */
+	u64 version;
+	/* size of bar memory */
+	u32 barmem_sz;
+	/* pointer to BAR memory */
+	void __iomem *barmem;
+	/* user context for callback, can be null */
+	void *user_ctx;
+	/* callback handler for processing request, called from octep_ctrl_mbox_recv */
+	int (*process_req)(void *user_ctx, struct octep_ctrl_mbox_msg *msg);
+	/* host-to-fw queue */
+	struct octep_ctrl_mbox_q h2fq;
+	/* fw-to-host queue */
+	struct octep_ctrl_mbox_q f2hq;
+	/* lock for h2fq */
+	struct mutex h2fq_lock;
+	/* lock for f2hq */
+	struct mutex f2hq_lock;
+};
+
+/* Initialize control mbox.
+ *
+ * @param mbox: non-null pointer to struct octep_ctrl_mbox.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox);
+
+/* Send mbox message.
+ *
+ * @param mbox: non-null pointer to struct octep_ctrl_mbox.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_ctrl_mbox_send(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg);
+
+/* Retrieve mbox message.
+ *
+ * @param mbox: non-null pointer to struct octep_ctrl_mbox.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_ctrl_mbox_recv(struct octep_ctrl_mbox *mbox, struct octep_ctrl_mbox_msg *msg);
+
+/* Uninitialize control mbox.
+ *
+ * @param ep: non-null pointer to struct octep_ctrl_mbox.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox);
+
+#endif /* __OCTEP_CTRL_MBOX_H__ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
new file mode 100644
index 000000000000..021f888d8f6d
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/etherdevice.h>
+#include <linux/pci.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+#include "octep_ctrl_net.h"
+
+int octep_get_link_status(struct octep_device *oct)
+{
+	return 0;
+}
+
+void octep_set_link_status(struct octep_device *oct, bool up)
+{
+}
+
+void octep_set_rx_state(struct octep_device *oct, bool up)
+{
+}
+
+int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
+{
+	return -1;
+}
+
+int octep_get_link_info(struct octep_device *oct)
+{
+	return -1;
+}
+
+int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info)
+{
+	return -1;
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
new file mode 100644
index 000000000000..f23b58381322
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
@@ -0,0 +1,299 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+#ifndef __OCTEP_CTRL_NET_H__
+#define __OCTEP_CTRL_NET_H__
+
+/* Supported commands */
+enum octep_ctrl_net_cmd {
+	OCTEP_CTRL_NET_CMD_GET = 0,
+	OCTEP_CTRL_NET_CMD_SET,
+};
+
+/* Supported states */
+enum octep_ctrl_net_state {
+	OCTEP_CTRL_NET_STATE_DOWN = 0,
+	OCTEP_CTRL_NET_STATE_UP,
+};
+
+/* Supported replies */
+enum octep_ctrl_net_reply {
+	OCTEP_CTRL_NET_REPLY_OK = 0,
+	OCTEP_CTRL_NET_REPLY_GENERIC_FAIL,
+	OCTEP_CTRL_NET_REPLY_INVALID_PARAM,
+};
+
+/* Supported host to fw commands */
+enum octep_ctrl_net_h2f_cmd {
+	OCTEP_CTRL_NET_H2F_CMD_INVALID = 0,
+	OCTEP_CTRL_NET_H2F_CMD_MTU,
+	OCTEP_CTRL_NET_H2F_CMD_MAC,
+	OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS,
+	OCTEP_CTRL_NET_H2F_CMD_GET_XSTATS,
+	OCTEP_CTRL_NET_H2F_CMD_GET_Q_STATS,
+	OCTEP_CTRL_NET_H2F_CMD_LINK_STATUS,
+	OCTEP_CTRL_NET_H2F_CMD_RX_STATE,
+	OCTEP_CTRL_NET_H2F_CMD_LINK_INFO,
+};
+
+/* Supported fw to host commands */
+enum octep_ctrl_net_f2h_cmd {
+	OCTEP_CTRL_NET_F2H_CMD_INVALID = 0,
+	OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS,
+};
+
+struct octep_ctrl_net_req_hdr {
+	/* sender id */
+	u16 sender;
+	/* receiver id */
+	u16 receiver;
+	/* octep_ctrl_net_h2t_cmd */
+	u16 cmd;
+	/* reserved */
+	u16 rsvd0;
+};
+
+/* get/set mtu request */
+struct octep_ctrl_net_h2f_req_cmd_mtu {
+	/* enum octep_ctrl_net_cmd */
+	u16 cmd;
+	/* 0-65535 */
+	u16 val;
+};
+
+/* get/set mac request */
+struct octep_ctrl_net_h2f_req_cmd_mac {
+	/* enum octep_ctrl_net_cmd */
+	u16 cmd;
+	/* xx:xx:xx:xx:xx:xx */
+	u8 addr[ETH_ALEN];
+};
+
+/* get if_stats, xstats, q_stats request */
+struct octep_ctrl_net_h2f_req_cmd_get_stats {
+	/* offset into barmem where fw should copy over stats */
+	u32 offset;
+};
+
+/* get/set link state, rx state */
+struct octep_ctrl_net_h2f_req_cmd_state {
+	/* enum octep_ctrl_net_cmd */
+	u16 cmd;
+	/* enum octep_ctrl_net_state */
+	u16 state;
+};
+
+/* link info */
+struct octep_ctrl_net_link_info {
+	/* Bitmap of Supported link speeds/modes */
+	u64 supported_modes;
+	/* Bitmap of Advertised link speeds/modes */
+	u64 advertised_modes;
+	/* Autonegotation state; bit 0=disabled; bit 1=enabled */
+	u8 autoneg;
+	/* Pause frames setting. bit 0=disabled; bit 1=enabled */
+	u8 pause;
+	/* Negotiated link speed in Mbps */
+	u32 speed;
+};
+
+/* get/set link info */
+struct octep_ctrl_net_h2f_req_cmd_link_info {
+	/* enum octep_ctrl_net_cmd */
+	u16 cmd;
+	/* struct octep_ctrl_net_link_info */
+	struct octep_ctrl_net_link_info info;
+};
+
+/* Host to fw request data */
+struct octep_ctrl_net_h2f_req {
+	struct octep_ctrl_net_req_hdr hdr;
+	union {
+		struct octep_ctrl_net_h2f_req_cmd_mtu mtu;
+		struct octep_ctrl_net_h2f_req_cmd_mac mac;
+		struct octep_ctrl_net_h2f_req_cmd_get_stats get_stats;
+		struct octep_ctrl_net_h2f_req_cmd_state link;
+		struct octep_ctrl_net_h2f_req_cmd_state rx;
+		struct octep_ctrl_net_h2f_req_cmd_link_info link_info;
+	};
+} __packed;
+
+struct octep_ctrl_net_resp_hdr {
+	/* sender id */
+	u16 sender;
+	/* receiver id */
+	u16 receiver;
+	/* octep_ctrl_net_h2t_cmd */
+	u16 cmd;
+	/* octep_ctrl_net_reply */
+	u16 reply;
+};
+
+/* get mtu response */
+struct octep_ctrl_net_h2f_resp_cmd_mtu {
+	/* 0-65535 */
+	u16 val;
+};
+
+/* get mac response */
+struct octep_ctrl_net_h2f_resp_cmd_mac {
+	/* xx:xx:xx:xx:xx:xx */
+	u8 addr[ETH_ALEN];
+};
+
+/* get link state, rx state response */
+struct octep_ctrl_net_h2f_resp_cmd_state {
+	/* enum octep_ctrl_net_state */
+	u16 state;
+};
+
+/* Host to fw response data */
+struct octep_ctrl_net_h2f_resp {
+	struct octep_ctrl_net_resp_hdr hdr;
+	union {
+		struct octep_ctrl_net_h2f_resp_cmd_mtu mtu;
+		struct octep_ctrl_net_h2f_resp_cmd_mac mac;
+		struct octep_ctrl_net_h2f_resp_cmd_state link;
+		struct octep_ctrl_net_h2f_resp_cmd_state rx;
+		struct octep_ctrl_net_link_info link_info;
+	};
+} __packed;
+
+/* link state notofication */
+struct octep_ctrl_net_f2h_req_cmd_state {
+	/* enum octep_ctrl_net_state */
+	u16 state;
+};
+
+/* Fw to host request data */
+struct octep_ctrl_net_f2h_req {
+	struct octep_ctrl_net_req_hdr hdr;
+	union {
+		struct octep_ctrl_net_f2h_req_cmd_state link;
+	};
+};
+
+/* Fw to host response data */
+struct octep_ctrl_net_f2h_resp {
+	struct octep_ctrl_net_resp_hdr hdr;
+};
+
+/* Size of host to fw octep_ctrl_mbox queue element */
+union octep_ctrl_net_h2f_data_sz {
+	struct octep_ctrl_net_h2f_req h2f_req;
+	struct octep_ctrl_net_h2f_resp h2f_resp;
+};
+
+/* Size of fw to host octep_ctrl_mbox queue element */
+union octep_ctrl_net_f2h_data_sz {
+	struct octep_ctrl_net_f2h_req f2h_req;
+	struct octep_ctrl_net_f2h_resp f2h_resp;
+};
+
+/* size of host to fw data in words */
+#define OCTEP_CTRL_NET_H2F_DATA_SZW		((sizeof(union octep_ctrl_net_h2f_data_sz)) / \
+						 (sizeof(unsigned long)))
+
+/* size of fw to host data in words */
+#define OCTEP_CTRL_NET_F2H_DATA_SZW		((sizeof(union octep_ctrl_net_f2h_data_sz)) / \
+						 (sizeof(unsigned long)))
+
+/* size in words of get/set mtu request */
+#define OCTEP_CTRL_NET_H2F_MTU_REQ_SZW			2
+/* size in words of get/set mac request */
+#define OCTEP_CTRL_NET_H2F_MAC_REQ_SZW			2
+/* size in words of get stats request */
+#define OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW		2
+/* size in words of get/set state request */
+#define OCTEP_CTRL_NET_H2F_STATE_REQ_SZW		2
+/* size in words of get/set link info request */
+#define OCTEP_CTRL_NET_H2F_LINK_INFO_REQ_SZW		4
+
+/* size in words of get mtu response */
+#define OCTEP_CTRL_NET_H2F_GET_MTU_RESP_SZW		2
+/* size in words of set mtu response */
+#define OCTEP_CTRL_NET_H2F_SET_MTU_RESP_SZW		1
+/* size in words of get mac response */
+#define OCTEP_CTRL_NET_H2F_GET_MAC_RESP_SZW		2
+/* size in words of set mac response */
+#define OCTEP_CTRL_NET_H2F_SET_MAC_RESP_SZW		1
+/* size in words of get state request */
+#define OCTEP_CTRL_NET_H2F_GET_STATE_RESP_SZW		2
+/* size in words of set state request */
+#define OCTEP_CTRL_NET_H2F_SET_STATE_RESP_SZW		1
+/* size in words of get link info request */
+#define OCTEP_CTRL_NET_H2F_GET_LINK_INFO_RESP_SZW	4
+/* size in words of set link info request */
+#define OCTEP_CTRL_NET_H2F_SET_LINK_INFO_RESP_SZW	1
+
+/** Get link status from firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ *
+ * return value: link status 0=down, 1=up.
+ */
+int octep_get_link_status(struct octep_device *oct);
+
+/** Set link status in firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ * @param up: boolean status.
+ */
+void octep_set_link_status(struct octep_device *oct, bool up);
+
+/** Set rx state in firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ * @param up: boolean status.
+ */
+void octep_set_rx_state(struct octep_device *oct, bool up);
+
+/** Get mac address from firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ * @param addr: non-null pointer to mac address.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_get_mac_addr(struct octep_device *oct, u8 *addr);
+
+/** Set mac address in firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ * @param addr: non-null pointer to mac address.
+ */
+int octep_set_mac_addr(struct octep_device *oct, u8 *addr);
+
+/** Set mtu in firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ * @param mtu: mtu.
+ */
+int octep_set_mtu(struct octep_device *oct, int mtu);
+
+/** Get interface statistics from firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_get_if_stats(struct octep_device *oct);
+
+/** Get link info from firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ *
+ * return value: 0 on success, -errno on failure.
+ */
+int octep_get_link_info(struct octep_device *oct);
+
+/** Set link info in firmware.
+ *
+ * @param oct: non-null pointer to struct octep_device.
+ */
+int octep_set_link_info(struct octep_device *oct, struct octep_iface_link_info *link_info);
+
+#endif /* __OCTEP_CTRL_NET_H__ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
new file mode 100644
index 000000000000..fc142a5f500b
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -0,0 +1,512 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/aer.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/vmalloc.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+#include "octep_ctrl_net.h"
+
+struct workqueue_struct *octep_wq;
+
+/* Supported Devices */
+static const struct pci_device_id octep_pci_id_tbl[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CN93_PF)},
+	{0, },
+};
+MODULE_DEVICE_TABLE(pci, octep_pci_id_tbl);
+
+MODULE_AUTHOR("Veerasenareddy Burru <vburru@marvell.com>");
+MODULE_DESCRIPTION(OCTEP_DRV_STRING);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(OCTEP_DRV_VERSION_STR);
+
+static void octep_link_up(struct net_device *netdev)
+{
+	netif_carrier_on(netdev);
+	netif_tx_start_all_queues(netdev);
+}
+
+/**
+ * octep_open() - start the octeon network device.
+ *
+ * @netdev: pointer to kernel network device.
+ *
+ * setup Tx/Rx queues, interrupts and enable hardware operation of Tx/Rx queues
+ * and interrupts..
+ *
+ * Return: 0, on successfully setting up device and bring it up.
+ *         -1, on any error.
+ */
+static int octep_open(struct net_device *netdev)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+	int err, ret;
+
+	netdev_info(netdev, "Starting netdev ...\n");
+	netif_carrier_off(netdev);
+
+	oct->hw_ops.reset_io_queues(oct);
+
+	if (octep_setup_iqs(oct))
+		goto setup_iq_err;
+	if (octep_setup_oqs(oct))
+		goto setup_oq_err;
+
+	err = netif_set_real_num_tx_queues(netdev, oct->num_oqs);
+	if (err)
+		goto set_queues_err;
+	err = netif_set_real_num_rx_queues(netdev, oct->num_iqs);
+	if (err)
+		goto set_queues_err;
+
+	oct->link_info.admin_up = 1;
+	octep_set_rx_state(oct, true);
+
+	ret = octep_get_link_status(oct);
+	if (!ret)
+		octep_set_link_status(oct, true);
+
+	/* Enable the input and output queues for this Octeon device */
+	oct->hw_ops.enable_io_queues(oct);
+
+	/* Enable Octeon device interrupts */
+	oct->hw_ops.enable_interrupts(oct);
+
+	octep_oq_dbell_init(oct);
+
+	ret = octep_get_link_status(oct);
+	if (ret)
+		octep_link_up(netdev);
+
+	return 0;
+
+set_queues_err:
+	octep_free_oqs(oct);
+setup_oq_err:
+	octep_free_iqs(oct);
+setup_iq_err:
+	return -1;
+}
+
+/**
+ * octep_stop() - stop the octeon network device.
+ *
+ * @netdev: pointer to kernel network device.
+ *
+ * stop the device Tx/Rx operations, bring down the link and
+ * free up all resources allocated for Tx/Rx queues and interrupts.
+ */
+static int octep_stop(struct net_device *netdev)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+
+	netdev_info(netdev, "Stopping the device ...\n");
+
+	/* Stop Tx from stack */
+	netif_tx_stop_all_queues(netdev);
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
+	octep_set_link_status(oct, false);
+	octep_set_rx_state(oct, false);
+
+	oct->link_info.admin_up = 0;
+	oct->link_info.oper_up = 0;
+
+	oct->hw_ops.disable_interrupts(oct);
+
+	octep_clean_iqs(oct);
+
+	oct->hw_ops.disable_io_queues(oct);
+	oct->hw_ops.reset_io_queues(oct);
+	octep_free_oqs(oct);
+	octep_free_iqs(oct);
+	netdev_info(netdev, "Device stopped !!\n");
+	return 0;
+}
+
+/**
+ * octep_start_xmit() - Enqueue packet to Octoen hardware Tx Queue.
+ *
+ * @skb: packet skbuff pointer.
+ * @netdev: kernel network device.
+ *
+ * Return: NETDEV_TX_BUSY, if Tx Queue is full.
+ *         NETDEV_TX_OK, if successfully enqueued to hardware Tx queue.
+ */
+static netdev_tx_t octep_start_xmit(struct sk_buff *skb,
+				    struct net_device *netdev)
+{
+	return NETDEV_TX_OK;
+}
+
+/**
+ * octep_tx_timeout_task - work queue task to Handle Tx queue timeout.
+ *
+ * @work: pointer to Tx queue timeout work_struct
+ *
+ * Stop and start the device so that it frees up all queue resources
+ * and restarts the queues, that potentially clears a Tx queue timeout
+ * condition.
+ **/
+static void octep_tx_timeout_task(struct work_struct *work)
+{
+	struct octep_device *oct = container_of(work, struct octep_device,
+						tx_timeout_task);
+	struct net_device *netdev = oct->netdev;
+
+	rtnl_lock();
+	if (netif_running(netdev)) {
+		octep_stop(netdev);
+		octep_open(netdev);
+	}
+	rtnl_unlock();
+}
+
+/**
+ * octep_tx_timeout() - Handle Tx Queue timeout.
+ *
+ * @netdev: pointer to kernel network device.
+ * @txqueue: Timed out Tx queue number.
+ *
+ * Schedule a work to handle Tx queue timeout.
+ */
+static void octep_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+{
+	struct octep_device *oct = netdev_priv(netdev);
+
+	queue_work(octep_wq, &oct->tx_timeout_task);
+}
+
+static const struct net_device_ops octep_netdev_ops = {
+	.ndo_open                = octep_open,
+	.ndo_stop                = octep_stop,
+	.ndo_start_xmit          = octep_start_xmit,
+	.ndo_tx_timeout          = octep_tx_timeout,
+};
+
+/**
+ * octep_ctrl_mbox_task - work queue task to handle ctrl mbox messages.
+ *
+ * @work: pointer to ctrl mbox work_struct
+ *
+ * Poll ctrl mbox message queue and handle control messages from firmware.
+ **/
+static void octep_ctrl_mbox_task(struct work_struct *work)
+{
+	struct octep_device *oct = container_of(work, struct octep_device,
+						ctrl_mbox_task);
+	struct net_device *netdev = oct->netdev;
+	struct octep_ctrl_net_f2h_req req = {};
+	struct octep_ctrl_mbox_msg msg;
+	int ret = 0;
+
+	msg.msg = &req;
+	while (true) {
+		ret = octep_ctrl_mbox_recv(&oct->ctrl_mbox, &msg);
+		if (ret)
+			break;
+
+		switch (req.hdr.cmd) {
+		case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
+			if (netif_running(netdev)) {
+				if (req.link.state) {
+					dev_info(&oct->pdev->dev, "netif_carrier_on\n");
+					netif_carrier_on(netdev);
+				} else {
+					dev_info(&oct->pdev->dev, "netif_carrier_off\n");
+					netif_carrier_off(netdev);
+				}
+			}
+			break;
+		default:
+			pr_info("Unknown mbox req : %u\n", req.hdr.cmd);
+			break;
+		}
+	}
+}
+
+/**
+ * octep_device_setup() - Setup Octeon Device.
+ *
+ * @oct: Octeon device private data structure.
+ *
+ * Setup Octeon device hardware operations, configuration, etc ...
+ */
+int octep_device_setup(struct octep_device *oct)
+{
+	struct octep_ctrl_mbox *ctrl_mbox;
+	struct pci_dev *pdev = oct->pdev;
+	int i, ret;
+
+	/* allocate memory for oct->conf */
+	oct->conf = kzalloc(sizeof(*oct->conf), GFP_KERNEL);
+	if (!oct->conf)
+		return -ENOMEM;
+
+	/* Map BAR regions */
+	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
+		oct->mmio[i].hw_addr =
+			ioremap(pci_resource_start(oct->pdev, i * 2),
+				pci_resource_len(oct->pdev, i * 2));
+		oct->mmio[i].mapped = 1;
+	}
+
+	oct->chip_id = pdev->device;
+	oct->rev_id = pdev->revision;
+	dev_info(&pdev->dev, "chip_id = 0x%x\n", pdev->device);
+
+	switch (oct->chip_id) {
+	case OCTEP_PCI_DEVICE_ID_CN93_PF:
+		dev_info(&pdev->dev,
+			 "Setting up OCTEON CN93XX PF PASS%d.%d\n",
+			 OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
+		octep_device_setup_cn93_pf(oct);
+		break;
+	default:
+		dev_err(&pdev->dev,
+			"%s: unsupported device\n", __func__);
+		goto unsupported_dev;
+	}
+
+	oct->pkind = CFG_GET_IQ_PKIND(oct->conf);
+
+	/* Initialize control mbox */
+	ctrl_mbox = &oct->ctrl_mbox;
+	ctrl_mbox->version = OCTEP_DRV_VERSION;
+	ctrl_mbox->barmem = CFG_GET_CTRL_MBOX_MEM_ADDR(oct->conf);
+	ret = octep_ctrl_mbox_init(ctrl_mbox);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize control mbox\n");
+		return -1;
+	}
+	oct->ctrl_mbox_ifstats_offset = OCTEP_CTRL_MBOX_SZ(ctrl_mbox->h2fq.elem_sz,
+							   ctrl_mbox->h2fq.elem_cnt,
+							   ctrl_mbox->f2hq.elem_sz,
+							   ctrl_mbox->f2hq.elem_cnt);
+
+	return 0;
+
+unsupported_dev:
+	return -1;
+}
+
+/**
+ * octep_device_cleanup() - Cleanup Octeon Device.
+ *
+ * @oct: Octeon device private data structure.
+ *
+ * Cleanup Octeon device allocated resources.
+ */
+static void octep_device_cleanup(struct octep_device *oct)
+{
+	int i;
+
+	dev_info(&oct->pdev->dev, "Cleaning up Octeon Device ...\n");
+
+	for (i = 0; i < OCTEP_MAX_VF; i++) {
+		if (oct->mbox[i])
+			vfree(oct->mbox[i]);
+		oct->mbox[i] = NULL;
+	}
+
+	octep_ctrl_mbox_uninit(&oct->ctrl_mbox);
+
+	oct->hw_ops.soft_reset(oct);
+	for (i = 0; i < OCTEP_MMIO_REGIONS; i++) {
+		if (oct->mmio[i].mapped)
+			iounmap(oct->mmio[i].hw_addr);
+	}
+
+	kfree(oct->conf);
+	oct->conf = NULL;
+}
+
+/**
+ * octep_probe() - Octeon PCI device probe handler.
+ *
+ * @pdev: PCI device structure.
+ * @ent: entry in Octeon PCI device ID table.
+ *
+ * Initializes and enables the Octeon PCI device for network operations.
+ * Initializes Octeon private data structure and registers a network device.
+ */
+static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct octep_device *octep_dev = NULL;
+	struct net_device *netdev;
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		return  err;
+	}
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
+	if (err) {
+		dev_err(&pdev->dev, "Failed to set DMA mask !!\n");
+		goto err_dma_mask;
+	}
+
+	err = pci_request_mem_regions(pdev, OCTEP_DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to map PCI memory regions\n");
+		goto err_pci_regions;
+	}
+
+	pci_enable_pcie_error_reporting(pdev);
+	pci_set_master(pdev);
+
+	netdev = alloc_etherdev_mq(sizeof(struct octep_device),
+				   OCTEP_MAX_QUEUES);
+	if (!netdev) {
+		dev_err(&pdev->dev, "Failed to allocate netdev\n");
+		err = -ENOMEM;
+		goto err_alloc_netdev;
+	}
+	SET_NETDEV_DEV(netdev, &pdev->dev);
+
+	octep_dev = netdev_priv(netdev);
+	octep_dev->netdev = netdev;
+	octep_dev->pdev = pdev;
+	octep_dev->dev = &pdev->dev;
+	pci_set_drvdata(pdev, octep_dev);
+
+	err = octep_device_setup(octep_dev);
+	if (err) {
+		dev_err(&pdev->dev, "Device setup failed\n");
+		goto err_octep_config;
+	}
+	INIT_WORK(&octep_dev->tx_timeout_task, octep_tx_timeout_task);
+	INIT_WORK(&octep_dev->ctrl_mbox_task, octep_ctrl_mbox_task);
+
+	netdev->netdev_ops = &octep_netdev_ops;
+	netif_carrier_off(netdev);
+
+	netdev->hw_features = NETIF_F_SG;
+	netdev->features |= netdev->hw_features;
+	netdev->min_mtu = OCTEP_MIN_MTU;
+	netdev->max_mtu = OCTEP_MAX_MTU;
+	netdev->mtu = OCTEP_DEFAULT_MTU;
+
+	octep_get_mac_addr(octep_dev, octep_dev->mac_addr);
+	eth_hw_addr_set(netdev, octep_dev->mac_addr);
+
+	if (register_netdev(netdev)) {
+		dev_err(&pdev->dev, "Failed to register netdev\n");
+		goto register_dev_err;
+	}
+	dev_info(&pdev->dev, "Device probe successful\n");
+	return 0;
+
+register_dev_err:
+	octep_device_cleanup(octep_dev);
+err_octep_config:
+	free_netdev(netdev);
+err_alloc_netdev:
+	pci_disable_pcie_error_reporting(pdev);
+	pci_release_mem_regions(pdev);
+err_pci_regions:
+err_dma_mask:
+	pci_disable_device(pdev);
+	return err;
+}
+
+/**
+ * octep_remove() - Remove Octeon PCI device from driver control.
+ *
+ * @pdev: PCI device structure of the Octeon device.
+ *
+ * Cleanup all resources allocated for the Octeon device.
+ * Unregister from network device and disable the PCI device.
+ */
+static void octep_remove(struct pci_dev *pdev)
+{
+	struct octep_device *oct = pci_get_drvdata(pdev);
+	struct net_device *netdev;
+
+	if (!oct)
+		return;
+
+	cancel_work_sync(&oct->tx_timeout_task);
+	cancel_work_sync(&oct->ctrl_mbox_task);
+	netdev = oct->netdev;
+	if (netdev->reg_state == NETREG_REGISTERED)
+		unregister_netdev(netdev);
+
+	octep_device_cleanup(oct);
+	pci_release_mem_regions(pdev);
+	free_netdev(netdev);
+	pci_disable_pcie_error_reporting(pdev);
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver octep_driver = {
+	.name = OCTEP_DRV_NAME,
+	.id_table = octep_pci_id_tbl,
+	.probe = octep_probe,
+	.remove = octep_remove,
+};
+
+/**
+ * octep_init_module() - Module initialiation.
+ *
+ * create common resource for the driver and register PCI driver.
+ */
+static int __init octep_init_module(void)
+{
+	int ret;
+
+	pr_info("%s: Loading %s ...\n", OCTEP_DRV_NAME, OCTEP_DRV_STRING);
+
+	/* work queue for all deferred tasks */
+	octep_wq = create_singlethread_workqueue(OCTEP_DRV_NAME);
+	if (!octep_wq) {
+		pr_err("%s: Failed to create common workqueue\n",
+		       OCTEP_DRV_NAME);
+		return -ENOMEM;
+	}
+
+	ret = pci_register_driver(&octep_driver);
+	if (ret < 0) {
+		pr_err("%s: Failed to register PCI driver; err=%d\n",
+		       OCTEP_DRV_NAME, ret);
+		return ret;
+	}
+
+	pr_info("%s: Loaded successfully !\n", OCTEP_DRV_NAME);
+
+	return ret;
+}
+
+/**
+ * octep_exit_module() - Module exit routine.
+ *
+ * unregister the driver with PCI subsystem and cleanup common resources.
+ */
+static void __exit octep_exit_module(void)
+{
+	pr_info("%s: Unloading ...\n", OCTEP_DRV_NAME);
+
+	pci_unregister_driver(&octep_driver);
+	flush_workqueue(octep_wq);
+	destroy_workqueue(octep_wq);
+
+	pr_info("%s: Unloading complete\n", OCTEP_DRV_NAME);
+}
+
+module_init(octep_init_module);
+module_exit(octep_exit_module);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
new file mode 100644
index 000000000000..bd372ede51ec
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -0,0 +1,379 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef _OCTEP_MAIN_H_
+#define _OCTEP_MAIN_H_
+
+#include "octep_tx.h"
+#include "octep_rx.h"
+#include "octep_ctrl_mbox.h"
+
+#define OCTEP_DRV_VERSION_MAJOR		1
+#define OCTEP_DRV_VERSION_MINOR		0
+#define OCTEP_DRV_VERSION_VARIANT	0
+
+#define OCTEP_DRV_VERSION	((OCTEP_DRV_VERSION_MAJOR << 16) + \
+				  (OCTEP_DRV_VERSION_MINOR << 8) + \
+				  OCTEP_DRV_VERSION_VARIANT)
+
+#define OCTEP_DRV_VERSION_STR	"1.0.0"
+#define OCTEP_DRV_NAME		"octeon_ep"
+#define OCTEP_DRV_STRING	"Marvell Octeon EndPoint NIC Driver"
+
+#define  OCTEP_PCIID_CN93_PF  0xB200177d
+#define  OCTEP_PCIID_CN93_VF  0xB203177d
+
+#define  OCTEP_PCI_DEVICE_ID_CN93_PF 0xB200
+#define  OCTEP_PCI_DEVICE_ID_CN93_VF 0xB203
+
+#define  OCTEP_MAX_QUEUES   63
+#define  OCTEP_MAX_IQ       OCTEP_MAX_QUEUES
+#define  OCTEP_MAX_OQ       OCTEP_MAX_QUEUES
+#define  OCTEP_MAX_VF       64
+
+#define OCTEP_MAX_MSIX_VECTORS OCTEP_MAX_OQ
+
+/* Flags to disable and enable Interrupts */
+#define  OCTEP_INPUT_INTR    (1)
+#define  OCTEP_OUTPUT_INTR   (2)
+#define  OCTEP_MBOX_INTR     (4)
+#define  OCTEP_ALL_INTR      0xff
+
+#define  OCTEP_IQ_INTR_RESEND_BIT  59
+#define  OCTEP_OQ_INTR_RESEND_BIT  59
+
+#define  OCTEP_MMIO_REGIONS     3
+/* PCI address space mapping information.
+ * Each of the 3 address spaces given by BAR0, BAR2 and BAR4 of
+ * Octeon gets mapped to different physical address spaces in
+ * the kernel.
+ */
+struct octep_mmio {
+	/* The physical address to which the PCI address space is mapped. */
+	u8 __iomem *hw_addr;
+
+	/* Flag indicating the mapping was successful. */
+	int mapped;
+};
+
+struct octep_pci_win_regs {
+	u8 *pci_win_wr_addr;
+	u8 *pci_win_rd_addr;
+	u8 *pci_win_wr_data;
+	u8 *pci_win_rd_data;
+};
+
+struct octep_hw_ops {
+	void (*setup_iq_regs)(struct octep_device *oct, int q);
+	void (*setup_oq_regs)(struct octep_device *oct, int q);
+	void (*setup_mbox_regs)(struct octep_device *oct, int mbox);
+
+	irqreturn_t (*non_ioq_intr_handler)(void *ioq_vector);
+	irqreturn_t (*ioq_intr_handler)(void *ioq_vector);
+	int (*soft_reset)(struct octep_device *oct);
+	void (*reinit_regs)(struct octep_device *oct);
+	u32  (*update_iq_read_idx)(struct octep_iq *iq);
+
+	void (*enable_interrupts)(struct octep_device *oct);
+	void (*disable_interrupts)(struct octep_device *oct);
+
+	void (*enable_io_queues)(struct octep_device *oct);
+	void (*disable_io_queues)(struct octep_device *oct);
+	void (*enable_iq)(struct octep_device *oct, int q);
+	void (*disable_iq)(struct octep_device *oct, int q);
+	void (*enable_oq)(struct octep_device *oct, int q);
+	void (*disable_oq)(struct octep_device *oct, int q);
+	void (*reset_io_queues)(struct octep_device *oct);
+	void (*dump_registers)(struct octep_device *oct);
+};
+
+/* wrappers around work structs */
+struct octep_wk {
+	struct delayed_work work;
+	void *ctxptr;
+	u64 ctxul;
+};
+
+/* Octeon device work queue for all service tasks */
+struct octep_wq {
+	struct workqueue_struct *wq;
+	struct octep_wk wk;
+};
+
+/* Octeon mailbox data */
+struct octep_mbox_data {
+	u32 cmd;
+	u32 total_len;
+	u32 recv_len;
+	u32 rsvd;
+	u64 *data;
+};
+
+/* Octeon device mailbox */
+struct octep_mbox {
+	/* A spinlock to protect access to this q_mbox. */
+	spinlock_t lock;
+
+	u32 q_no;
+	u32 state;
+
+	/* SLI_MAC_PF_MBOX_INT for PF, SLI_PKT_MBOX_INT for VF. */
+	void *mbox_int_reg;
+
+	/* SLI_PKT_PF_VF_MBOX_SIG(0) for PF,
+	 * SLI_PKT_PF_VF_MBOX_SIG(1) for VF.
+	 */
+	void *mbox_write_reg;
+
+	/* SLI_PKT_PF_VF_MBOX_SIG(1) for PF,
+	 * SLI_PKT_PF_VF_MBOX_SIG(0) for VF.
+	 */
+	void *mbox_read_reg;
+
+	struct octep_mbox_data mbox_data;
+};
+
+/* Tx/Rx queue vector per interrupt. */
+struct octep_ioq_vector {
+	char name[OCTEP_MSIX_NAME_SIZE];
+	struct napi_struct napi;
+	struct octep_device *octep_dev;
+	struct octep_iq *iq;
+	struct octep_oq *oq;
+	cpumask_t affinity_mask;
+};
+
+/* Octeon hardware/firmware offload capability flags. */
+#define OCTEP_CAP_TX_CHECKSUM BIT(0)
+#define OCTEP_CAP_RX_CHECKSUM BIT(1)
+#define OCTEP_CAP_TSO         BIT(2)
+
+/* Link modes */
+enum octep_link_mode_bit_indices {
+	OCTEP_LINK_MODE_10GBASE_T    = 0,
+	OCTEP_LINK_MODE_10GBASE_R,
+	OCTEP_LINK_MODE_10GBASE_CR,
+	OCTEP_LINK_MODE_10GBASE_KR,
+	OCTEP_LINK_MODE_10GBASE_LR,
+	OCTEP_LINK_MODE_10GBASE_SR,
+	OCTEP_LINK_MODE_25GBASE_CR,
+	OCTEP_LINK_MODE_25GBASE_KR,
+	OCTEP_LINK_MODE_25GBASE_SR,
+	OCTEP_LINK_MODE_40GBASE_CR4,
+	OCTEP_LINK_MODE_40GBASE_KR4,
+	OCTEP_LINK_MODE_40GBASE_LR4,
+	OCTEP_LINK_MODE_40GBASE_SR4,
+	OCTEP_LINK_MODE_50GBASE_CR2,
+	OCTEP_LINK_MODE_50GBASE_KR2,
+	OCTEP_LINK_MODE_50GBASE_SR2,
+	OCTEP_LINK_MODE_50GBASE_CR,
+	OCTEP_LINK_MODE_50GBASE_KR,
+	OCTEP_LINK_MODE_50GBASE_LR,
+	OCTEP_LINK_MODE_50GBASE_SR,
+	OCTEP_LINK_MODE_100GBASE_CR4,
+	OCTEP_LINK_MODE_100GBASE_KR4,
+	OCTEP_LINK_MODE_100GBASE_LR4,
+	OCTEP_LINK_MODE_100GBASE_SR4,
+	OCTEP_LINK_MODE_NBITS
+};
+
+/* Hardware interface link state information. */
+struct octep_iface_link_info {
+	/* Bitmap of Supported link speeds/modes. */
+	u64 supported_modes;
+
+	/* Bitmap of Advertised link speeds/modes. */
+	u64 advertised_modes;
+
+	/* Negotiated link speed in Mbps. */
+	u32 speed;
+
+	/* MTU */
+	u16 mtu;
+
+	/* Autonegotation state. */
+#define OCTEP_LINK_MODE_AUTONEG_SUPPORTED   BIT(0)
+#define OCTEP_LINK_MODE_AUTONEG_ADVERTISED  BIT(1)
+	u8 autoneg;
+
+	/* Pause frames setting. */
+#define OCTEP_LINK_MODE_PAUSE_SUPPORTED   BIT(0)
+#define OCTEP_LINK_MODE_PAUSE_ADVERTISED  BIT(1)
+	u8 pause;
+
+	/* Admin state of the link (ifconfig <iface> up/down */
+	u8  admin_up;
+
+	/* Operational state of the link: physical link is up down */
+	u8  oper_up;
+};
+
+/* The Octeon device specific private data structure.
+ * Each Octeon device has this structure to represent all its components.
+ */
+struct octep_device {
+	struct octep_config *conf;
+
+	/* Octeon Chip type. */
+	u16 chip_id;
+	u16 rev_id;
+
+	/* Device capabilities enabled */
+	u64 caps_enabled;
+	/* Device capabilities supported */
+	u64 caps_supported;
+
+	/* Pointer to basic Linux device */
+	struct device *dev;
+	/* Linux PCI device pointer */
+	struct pci_dev *pdev;
+	/* Netdev corresponding to the Octeon device */
+	struct net_device *netdev;
+
+	/* memory mapped io range */
+	struct octep_mmio mmio[OCTEP_MMIO_REGIONS];
+
+	/* MAC address */
+	u8 mac_addr[ETH_ALEN];
+
+	/* Tx queues (IQ: Instruction Queue) */
+	u16 num_iqs;
+	/* pkind value to be used in every Tx hardware descriptor */
+	u8 pkind;
+	/* Pointers to Octeon Tx queues */
+	struct octep_iq *iq[OCTEP_MAX_IQ];
+
+	/* Rx queues (OQ: Output Queue) */
+	u16 num_oqs;
+	/* Pointers to Octeon Rx queues */
+	struct octep_oq *oq[OCTEP_MAX_OQ];
+
+	/* Hardware port number of the PCIe interface */
+	u16 pcie_port;
+
+	/* PCI Window registers to access some hardware CSRs */
+	struct octep_pci_win_regs pci_win_regs;
+	/* Hardware operations */
+	struct octep_hw_ops hw_ops;
+
+	/* IRQ info */
+	u16 num_irqs;
+	u16 num_non_ioq_irqs;
+	char *non_ioq_irq_names;
+	struct msix_entry *msix_entries;
+	/* IOq information of it's corresponding MSI-X interrupt. */
+	struct octep_ioq_vector *ioq_vector[OCTEP_MAX_QUEUES];
+
+	/* Hardware Interface Tx statistics */
+	struct octep_iface_tx_stats iface_tx_stats;
+	/* Hardware Interface Rx statistics */
+	struct octep_iface_rx_stats iface_rx_stats;
+
+	/* Hardware Interface Link info like supported modes, aneg support */
+	struct octep_iface_link_info link_info;
+
+	/* Mailbox to talk to VFs */
+	struct octep_mbox *mbox[OCTEP_MAX_VF];
+
+	/* Work entry to handle Tx timeout */
+	struct work_struct tx_timeout_task;
+
+	/* control mbox over pf */
+	struct octep_ctrl_mbox ctrl_mbox;
+
+	/* offset for iface stats */
+	u32 ctrl_mbox_ifstats_offset;
+
+	/* Work entry to handle ctrl mbox interrupt */
+	struct work_struct ctrl_mbox_task;
+
+};
+
+static inline u16 OCTEP_MAJOR_REV(struct octep_device *oct)
+{
+	u16 rev = (oct->rev_id & 0xC) >> 2;
+
+	return (rev == 0) ? 1 : rev;
+}
+
+static inline u16 OCTEP_MINOR_REV(struct octep_device *oct)
+{
+	return (oct->rev_id & 0x3);
+}
+
+/* Octeon CSR read/write access APIs */
+#define octep_write_csr(octep_dev, reg_off, value) \
+	writel(value, (u8 *)(octep_dev)->mmio[0].hw_addr + (reg_off))
+
+#define octep_write_csr64(octep_dev, reg_off, val64) \
+	writeq(val64, (u8 *)(octep_dev)->mmio[0].hw_addr + (reg_off))
+
+#define octep_read_csr(octep_dev, reg_off)         \
+	readl((u8 *)(octep_dev)->mmio[0].hw_addr + (reg_off))
+
+#define octep_read_csr64(octep_dev, reg_off)         \
+	readq((u8 *)(octep_dev)->mmio[0].hw_addr + (reg_off))
+
+/* Read windowed register.
+ * @param  oct   -  pointer to the Octeon device.
+ * @param  addr  -  Address of the register to read.
+ *
+ * This routine is called to read from the indirectly accessed
+ * Octeon registers that are visible through a PCI BAR0 mapped window
+ * register.
+ * @return  - 64 bit value read from the register.
+ */
+static inline u64
+OCTEP_PCI_WIN_READ(struct octep_device *oct, u64 addr)
+{
+	u64 val64;
+
+	addr |= 1ull << 53; /* read 8 bytes */
+	writeq(addr, oct->pci_win_regs.pci_win_rd_addr);
+	val64 = readq(oct->pci_win_regs.pci_win_rd_data);
+
+	dev_dbg(&oct->pdev->dev,
+		"%s: reg: 0x%016llx val: 0x%016llx\n", __func__, addr, val64);
+
+	return val64;
+}
+
+/* Write windowed register.
+ * @param  oct  -  pointer to the Octeon device.
+ * @param  addr -  Address of the register to write
+ * @param  val  -  Value to write
+ *
+ * This routine is called to write to the indirectly accessed
+ * Octeon registers that are visible through a PCI BAR0 mapped window
+ * register.
+ * @return   Nothing.
+ */
+static inline void
+OCTEP_PCI_WIN_WRITE(struct octep_device *oct, u64 addr, u64 val)
+{
+	writeq(addr, oct->pci_win_regs.pci_win_wr_addr);
+	writeq(val, oct->pci_win_regs.pci_win_wr_data);
+
+	dev_dbg(&oct->pdev->dev,
+		"%s: reg: 0x%016llx val: 0x%016llx\n", __func__, addr, val);
+}
+
+extern struct workqueue_struct *octep_wq;
+
+int octep_device_setup(struct octep_device *oct);
+int octep_setup_iqs(struct octep_device *oct);
+void octep_free_iqs(struct octep_device *oct);
+void octep_clean_iqs(struct octep_device *oct);
+int octep_setup_oqs(struct octep_device *oct);
+void octep_free_oqs(struct octep_device *oct);
+void octep_oq_dbell_init(struct octep_device *oct);
+void octep_device_setup_cn93_pf(struct octep_device *oct);
+int octep_iq_process_completions(struct octep_iq *iq, u16 budget);
+int octep_oq_process_rx(struct octep_oq *oq, int budget);
+void octep_set_ethtool_ops(struct net_device *netdev);
+
+#endif /* _OCTEP_MAIN_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
new file mode 100644
index 000000000000..cc51149790ff
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
@@ -0,0 +1,367 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef _OCTEP_REGS_CN9K_PF_H_
+#define _OCTEP_REGS_CN9K_PF_H_
+
+/* ############################ RST ######################### */
+#define    CN93_RST_BOOT               0x000087E006001600ULL
+#define    CN93_RST_CORE_DOMAIN_W1S    0x000087E006001820ULL
+#define    CN93_RST_CORE_DOMAIN_W1C    0x000087E006001828ULL
+
+#define     CN93_CONFIG_XPANSION_BAR             0x38
+#define     CN93_CONFIG_PCIE_CAP                 0x70
+#define     CN93_CONFIG_PCIE_DEVCAP              0x74
+#define     CN93_CONFIG_PCIE_DEVCTL              0x78
+#define     CN93_CONFIG_PCIE_LINKCAP             0x7C
+#define     CN93_CONFIG_PCIE_LINKCTL             0x80
+#define     CN93_CONFIG_PCIE_SLOTCAP             0x84
+#define     CN93_CONFIG_PCIE_SLOTCTL             0x88
+
+#define     CN93_PCIE_SRIOV_FDL                  0x188      /* 0x98 */
+#define     CN93_PCIE_SRIOV_FDL_BIT_POS          0x10
+#define     CN93_PCIE_SRIOV_FDL_MASK             0xFF
+
+#define     CN93_CONFIG_PCIE_FLTMSK              0x720
+
+/* ################# Offsets of RING, EPF, MAC ######################### */
+#define    CN93_RING_OFFSET                      (0x1ULL << 17)
+#define    CN93_EPF_OFFSET                       (0x1ULL << 25)
+#define    CN93_MAC_OFFSET                       (0x1ULL << 4)
+#define    CN93_BIT_ARRAY_OFFSET                 (0x1ULL << 4)
+#define    CN93_EPVF_RING_OFFSET                 (0x1ULL << 4)
+
+/* ################# Scratch Registers ######################### */
+#define    CN93_SDP_EPF_SCRATCH                  0x205E0
+
+/* ################# Window Registers ######################### */
+#define    CN93_SDP_WIN_WR_ADDR64                0x20000
+#define    CN93_SDP_WIN_RD_ADDR64                0x20010
+#define    CN93_SDP_WIN_WR_DATA64                0x20020
+#define    CN93_SDP_WIN_WR_MASK_REG              0x20030
+#define    CN93_SDP_WIN_RD_DATA64                0x20040
+
+#define    CN93_SDP_MAC_NUMBER                   0x2C100
+
+/* ################# Global Previliged registers ######################### */
+#define    CN93_SDP_EPF_RINFO                    0x205F0
+
+#define    CN93_SDP_EPF_RINFO_SRN(val)           ((val) & 0xFF)
+#define    CN93_SDP_EPF_RINFO_RPVF(val)          (((val) >> 32) & 0xF)
+#define    CN93_SDP_EPF_RINFO_NVFS(val)          (((val) >> 48) && 0xFF)
+
+/* SDP Function select */
+#define    CN93_SDP_FUNC_SEL_EPF_BIT_POS         8
+#define    CN93_SDP_FUNC_SEL_FUNC_BIT_POS        0
+
+/* ##### RING IN (Into device from PCI: Tx Ring) REGISTERS #### */
+#define    CN93_SDP_R_IN_CONTROL_START           0x10000
+#define    CN93_SDP_R_IN_ENABLE_START            0x10010
+#define    CN93_SDP_R_IN_INSTR_BADDR_START       0x10020
+#define    CN93_SDP_R_IN_INSTR_RSIZE_START       0x10030
+#define    CN93_SDP_R_IN_INSTR_DBELL_START       0x10040
+#define    CN93_SDP_R_IN_CNTS_START              0x10050
+#define    CN93_SDP_R_IN_INT_LEVELS_START        0x10060
+#define    CN93_SDP_R_IN_PKT_CNT_START           0x10080
+#define    CN93_SDP_R_IN_BYTE_CNT_START          0x10090
+
+#define    CN93_SDP_R_IN_CONTROL(ring)		\
+	(CN93_SDP_R_IN_CONTROL_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_ENABLE(ring)		\
+	(CN93_SDP_R_IN_ENABLE_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_INSTR_BADDR(ring)	\
+	(CN93_SDP_R_IN_INSTR_BADDR_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_INSTR_RSIZE(ring)	\
+	(CN93_SDP_R_IN_INSTR_RSIZE_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_INSTR_DBELL(ring)	\
+	(CN93_SDP_R_IN_INSTR_DBELL_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_CNTS(ring)		\
+	(CN93_SDP_R_IN_CNTS_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_INT_LEVELS(ring)	\
+	(CN93_SDP_R_IN_INT_LEVELS_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_PKT_CNT(ring)		\
+	(CN93_SDP_R_IN_PKT_CNT_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_BYTE_CNT(ring)		\
+	(CN93_SDP_R_IN_BYTE_CNT_START + ((ring) * CN93_RING_OFFSET))
+
+/* Rings per Virtual Function */
+#define    CN93_R_IN_CTL_RPVF_MASK	(0xF)
+#define    CN93_R_IN_CTL_RPVF_POS	(48)
+
+/* Number of instructions to be read in one MAC read request.
+ * setting to Max value(4)
+ */
+#define    CN93_R_IN_CTL_IDLE                    (0x1ULL << 28)
+#define    CN93_R_IN_CTL_RDSIZE                  (0x3ULL << 25)
+#define    CN93_R_IN_CTL_IS_64B                  (0x1ULL << 24)
+#define    CN93_R_IN_CTL_D_NSR                   (0x1ULL << 8)
+#define    CN93_R_IN_CTL_D_ESR                   (0x1ULL << 6)
+#define    CN93_R_IN_CTL_D_ROR                   (0x1ULL << 5)
+#define    CN93_R_IN_CTL_NSR                     (0x1ULL << 3)
+#define    CN93_R_IN_CTL_ESR                     (0x1ULL << 1)
+#define    CN93_R_IN_CTL_ROR                     (0x1ULL << 0)
+
+#define    CN93_R_IN_CTL_MASK  (CN93_R_IN_CTL_RDSIZE | CN93_R_IN_CTL_IS_64B)
+
+/* ##### RING OUT (out from device to PCI host: Rx Ring) REGISTERS #### */
+#define    CN93_SDP_R_OUT_CNTS_START              0x10100
+#define    CN93_SDP_R_OUT_INT_LEVELS_START        0x10110
+#define    CN93_SDP_R_OUT_SLIST_BADDR_START       0x10120
+#define    CN93_SDP_R_OUT_SLIST_RSIZE_START       0x10130
+#define    CN93_SDP_R_OUT_SLIST_DBELL_START       0x10140
+#define    CN93_SDP_R_OUT_CONTROL_START           0x10150
+#define    CN93_SDP_R_OUT_ENABLE_START            0x10160
+#define    CN93_SDP_R_OUT_PKT_CNT_START           0x10180
+#define    CN93_SDP_R_OUT_BYTE_CNT_START          0x10190
+
+#define    CN93_SDP_R_OUT_CONTROL(ring)          \
+	(CN93_SDP_R_OUT_CONTROL_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_ENABLE(ring)          \
+	(CN93_SDP_R_OUT_ENABLE_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_SLIST_BADDR(ring)          \
+	(CN93_SDP_R_OUT_SLIST_BADDR_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_SLIST_RSIZE(ring)          \
+	(CN93_SDP_R_OUT_SLIST_RSIZE_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_SLIST_DBELL(ring)          \
+	(CN93_SDP_R_OUT_SLIST_DBELL_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_CNTS(ring)          \
+	(CN93_SDP_R_OUT_CNTS_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_INT_LEVELS(ring)          \
+	(CN93_SDP_R_OUT_INT_LEVELS_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_PKT_CNT(ring)          \
+	(CN93_SDP_R_OUT_PKT_CNT_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_BYTE_CNT(ring)          \
+	(CN93_SDP_R_OUT_BYTE_CNT_START + ((ring) * CN93_RING_OFFSET))
+
+/*------------------ R_OUT Masks ----------------*/
+#define    CN93_R_OUT_INT_LEVELS_BMODE            BIT_ULL(63)
+#define    CN93_R_OUT_INT_LEVELS_TIMET            (32)
+
+#define    CN93_R_OUT_CTL_IDLE                    BIT_ULL(40)
+#define    CN93_R_OUT_CTL_ES_I                    BIT_ULL(34)
+#define    CN93_R_OUT_CTL_NSR_I                   BIT_ULL(33)
+#define    CN93_R_OUT_CTL_ROR_I                   BIT_ULL(32)
+#define    CN93_R_OUT_CTL_ES_D                    BIT_ULL(30)
+#define    CN93_R_OUT_CTL_NSR_D                   BIT_ULL(29)
+#define    CN93_R_OUT_CTL_ROR_D                   BIT_ULL(28)
+#define    CN93_R_OUT_CTL_ES_P                    BIT_ULL(26)
+#define    CN93_R_OUT_CTL_NSR_P                   BIT_ULL(25)
+#define    CN93_R_OUT_CTL_ROR_P                   BIT_ULL(24)
+#define    CN93_R_OUT_CTL_IMODE                   BIT_ULL(23)
+
+/* ############### Interrupt Moderation Registers ############### */
+#define CN93_SDP_R_IN_INT_MDRT_CTL0_START         0x10280
+#define CN93_SDP_R_IN_INT_MDRT_CTL1_START         0x102A0
+#define CN93_SDP_R_IN_INT_MDRT_DBG_START          0x102C0
+
+#define CN93_SDP_R_OUT_INT_MDRT_CTL0_START        0x10380
+#define CN93_SDP_R_OUT_INT_MDRT_CTL1_START        0x103A0
+#define CN93_SDP_R_OUT_INT_MDRT_DBG_START         0x103C0
+
+#define    CN93_SDP_R_IN_INT_MDRT_CTL0(ring)		\
+	(CN93_SDP_R_IN_INT_MDRT_CTL0_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_INT_MDRT_CTL1(ring)		\
+	(CN93_SDP_R_IN_INT_MDRT_CTL1_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_INT_MDRT_DBG(ring)		\
+	(CN93_SDP_R_IN_INT_MDRT_DBG_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_INT_MDRT_CTL0(ring)		\
+	(CN93_SDP_R_OUT_INT_MDRT_CTL0_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_INT_MDRT_CTL1(ring)		\
+	(CN93_SDP_R_OUT_INT_MDRT_CTL1_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_INT_MDRT_DBG(ring)		\
+	(CN93_SDP_R_OUT_INT_MDRT_DBG_START + ((ring) * CN93_RING_OFFSET))
+
+/* ##################### Mail Box Registers ########################## */
+/* INT register for VF. when a MBOX write from PF happed to a VF,
+ * corresponding bit will be set in this register as well as in
+ * PF_VF_INT register.
+ *
+ * This is a RO register, the int can be cleared by writing 1 to PF_VF_INT
+ */
+/* Basically first 3 are from PF to VF. The last one is data from VF to PF */
+#define    CN93_SDP_R_MBOX_PF_VF_DATA_START       0x10210
+#define    CN93_SDP_R_MBOX_PF_VF_INT_START        0x10220
+#define    CN93_SDP_R_MBOX_VF_PF_DATA_START       0x10230
+
+#define    CN93_SDP_R_MBOX_PF_VF_DATA(ring)		\
+	(CN93_SDP_R_MBOX_PF_VF_DATA_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_MBOX_PF_VF_INT(ring)		\
+	(CN93_SDP_R_MBOX_PF_VF_INT_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_MBOX_VF_PF_DATA(ring)		\
+	(CN93_SDP_R_MBOX_VF_PF_DATA_START + ((ring) * CN93_RING_OFFSET))
+
+/* ##################### Interrupt Registers ########################## */
+#define	   CN93_SDP_R_ERR_TYPE_START	          0x10400
+
+#define    CN93_SDP_R_ERR_TYPE(ring)		\
+	(CN93_SDP_R_ERR_TYPE_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_MBOX_ISM_START              0x10500
+#define    CN93_SDP_R_OUT_CNTS_ISM_START          0x10510
+#define    CN93_SDP_R_IN_CNTS_ISM_START           0x10520
+
+#define    CN93_SDP_R_MBOX_ISM(ring)		\
+	(CN93_SDP_R_MBOX_ISM_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_OUT_CNTS_ISM(ring)	\
+	(CN93_SDP_R_OUT_CNTS_ISM_START + ((ring) * CN93_RING_OFFSET))
+
+#define    CN93_SDP_R_IN_CNTS_ISM(ring)		\
+	(CN93_SDP_R_IN_CNTS_ISM_START + ((ring) * CN93_RING_OFFSET))
+
+#define	   CN93_SDP_EPF_MBOX_RINT_START	          0x20100
+#define	   CN93_SDP_EPF_MBOX_RINT_W1S_START	  0x20120
+#define	   CN93_SDP_EPF_MBOX_RINT_ENA_W1C_START   0x20140
+#define	   CN93_SDP_EPF_MBOX_RINT_ENA_W1S_START   0x20160
+
+#define	   CN93_SDP_EPF_VFIRE_RINT_START          0x20180
+#define	   CN93_SDP_EPF_VFIRE_RINT_W1S_START      0x201A0
+#define	   CN93_SDP_EPF_VFIRE_RINT_ENA_W1C_START  0x201C0
+#define	   CN93_SDP_EPF_VFIRE_RINT_ENA_W1S_START  0x201E0
+
+#define	   CN93_SDP_EPF_IRERR_RINT                0x20200
+#define	   CN93_SDP_EPF_IRERR_RINT_W1S            0x20210
+#define	   CN93_SDP_EPF_IRERR_RINT_ENA_W1C        0x20220
+#define	   CN93_SDP_EPF_IRERR_RINT_ENA_W1S        0x20230
+
+#define	   CN93_SDP_EPF_VFORE_RINT_START          0x20240
+#define	   CN93_SDP_EPF_VFORE_RINT_W1S_START      0x20260
+#define	   CN93_SDP_EPF_VFORE_RINT_ENA_W1C_START  0x20280
+#define	   CN93_SDP_EPF_VFORE_RINT_ENA_W1S_START  0x202A0
+
+#define	   CN93_SDP_EPF_ORERR_RINT                0x20320
+#define	   CN93_SDP_EPF_ORERR_RINT_W1S            0x20330
+#define	   CN93_SDP_EPF_ORERR_RINT_ENA_W1C        0x20340
+#define	   CN93_SDP_EPF_ORERR_RINT_ENA_W1S        0x20350
+
+#define	   CN93_SDP_EPF_OEI_RINT                  0x20360
+#define	   CN93_SDP_EPF_OEI_RINT_W1S              0x20370
+#define	   CN93_SDP_EPF_OEI_RINT_ENA_W1C          0x20380
+#define	   CN93_SDP_EPF_OEI_RINT_ENA_W1S          0x20390
+
+#define	   CN93_SDP_EPF_DMA_RINT                  0x20400
+#define	   CN93_SDP_EPF_DMA_RINT_W1S              0x20410
+#define	   CN93_SDP_EPF_DMA_RINT_ENA_W1C          0x20420
+#define	   CN93_SDP_EPF_DMA_RINT_ENA_W1S          0x20430
+
+#define	   CN93_SDP_EPF_DMA_INT_LEVEL_START	    0x20440
+#define	   CN93_SDP_EPF_DMA_CNT_START	            0x20460
+#define	   CN93_SDP_EPF_DMA_TIM_START	            0x20480
+
+#define	   CN93_SDP_EPF_MISC_RINT                 0x204A0
+#define	   CN93_SDP_EPF_MISC_RINT_W1S	            0x204B0
+#define	   CN93_SDP_EPF_MISC_RINT_ENA_W1C         0x204C0
+#define	   CN93_SDP_EPF_MISC_RINT_ENA_W1S         0x204D0
+
+#define	   CN93_SDP_EPF_DMA_VF_RINT_START           0x204E0
+#define	   CN93_SDP_EPF_DMA_VF_RINT_W1S_START       0x20500
+#define	   CN93_SDP_EPF_DMA_VF_RINT_ENA_W1C_START   0x20520
+#define	   CN93_SDP_EPF_DMA_VF_RINT_ENA_W1S_START   0x20540
+
+#define	   CN93_SDP_EPF_PP_VF_RINT_START            0x20560
+#define	   CN93_SDP_EPF_PP_VF_RINT_W1S_START        0x20580
+#define	   CN93_SDP_EPF_PP_VF_RINT_ENA_W1C_START    0x205A0
+#define	   CN93_SDP_EPF_PP_VF_RINT_ENA_W1S_START    0x205C0
+
+#define	   CN93_SDP_EPF_MBOX_RINT(index)		\
+		(CN93_SDP_EPF_MBOX_RINT_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_MBOX_RINT_W1S(index)		\
+		(CN93_SDP_EPF_MBOX_RINT_W1S_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_MBOX_RINT_ENA_W1C(index)	\
+		(CN93_SDP_EPF_MBOX_RINT_ENA_W1C_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_MBOX_RINT_ENA_W1S(index)	\
+		(CN93_SDP_EPF_MBOX_RINT_ENA_W1S_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+
+#define	   CN93_SDP_EPF_VFIRE_RINT(index)		\
+		(CN93_SDP_EPF_VFIRE_RINT_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_VFIRE_RINT_W1S(index)		\
+		(CN93_SDP_EPF_VFIRE_RINT_W1S_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_VFIRE_RINT_ENA_W1C(index)	\
+		(CN93_SDP_EPF_VFIRE_RINT_ENA_W1C_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_VFIRE_RINT_ENA_W1S(index)	\
+		(CN93_SDP_EPF_VFIRE_RINT_ENA_W1S_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+
+#define	   CN93_SDP_EPF_VFORE_RINT(index)		\
+		(CN93_SDP_EPF_VFORE_RINT_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_VFORE_RINT_W1S(index)		\
+		(CN93_SDP_EPF_VFORE_RINT_W1S_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_VFORE_RINT_ENA_W1C(index)	\
+		(CN93_SDP_EPF_VFORE_RINT_ENA_W1C_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_VFORE_RINT_ENA_W1S(index)	\
+		(CN93_SDP_EPF_VFORE_RINT_ENA_W1S_START + ((index) * CN93_BIT_ARRAY_OFFSET))
+
+#define	   CN93_SDP_EPF_DMA_VF_RINT(index)		\
+		(CN93_SDP_EPF_DMA_VF_RINT_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_DMA_VF_RINT_W1S(index)		\
+		(CN93_SDP_EPF_DMA_VF_RINT_W1S_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_DMA_VF_RINT_ENA_W1C(index)	\
+		(CN93_SDP_EPF_DMA_VF_RINT_ENA_W1C_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_DMA_VF_RINT_ENA_W1S(index)	\
+		(CN93_SDP_EPF_DMA_VF_RINT_ENA_W1S_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+
+#define	   CN93_SDP_EPF_PP_VF_RINT(index)		\
+		(CN93_SDP_EPF_PP_VF_RINT_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_PP_VF_RINT_W1S(index)		\
+		(CN93_SDP_EPF_PP_VF_RINT_W1S_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_PP_VF_RINT_ENA_W1C(index)	\
+		(CN93_SDP_EPF_PP_VF_RINT_ENA_W1C_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+#define	   CN93_SDP_EPF_PP_VF_RINT_ENA_W1S(index)	\
+		(CN93_SDP_EPF_PP_VF_RINT_ENA_W1S_START + ((index) + CN93_BIT_ARRAY_OFFSET))
+
+/*------------------ Interrupt Masks ----------------*/
+#define	   CN93_INTR_R_SEND_ISM       BIT_ULL(63)
+#define	   CN93_INTR_R_OUT_INT        BIT_ULL(62)
+#define    CN93_INTR_R_IN_INT         BIT_ULL(61)
+#define    CN93_INTR_R_MBOX_INT       BIT_ULL(60)
+#define    CN93_INTR_R_RESEND         BIT_ULL(59)
+#define    CN93_INTR_R_CLR_TIM        BIT_ULL(58)
+
+/* ####################### Ring Mapping Registers ################################## */
+#define    CN93_SDP_EPVF_RING_START          0x26000
+#define    CN93_SDP_IN_RING_TB_MAP_START     0x28000
+#define    CN93_SDP_IN_RATE_LIMIT_START      0x2A000
+#define    CN93_SDP_MAC_PF_RING_CTL_START    0x2C000
+
+#define	   CN93_SDP_EPVF_RING(ring)		\
+		(CN93_SDP_EPVF_RING_START + ((ring) * CN93_EPVF_RING_OFFSET))
+#define	   CN93_SDP_IN_RING_TB_MAP(ring)	\
+		(CN93_SDP_N_RING_TB_MAP_START + ((ring) * CN93_EPVF_RING_OFFSET))
+#define	   CN93_SDP_IN_RATE_LIMIT(ring)		\
+		(CN93_SDP_IN_RATE_LIMIT_START + ((ring) * CN93_EPVF_RING_OFFSET))
+#define	   CN93_SDP_MAC_PF_RING_CTL(mac)	\
+		(CN93_SDP_MAC_PF_RING_CTL_START + ((mac) * CN93_MAC_OFFSET))
+
+#define    CN93_SDP_MAC_PF_RING_CTL_NPFS(val)  ((val) & 0xF)
+#define    CN93_SDP_MAC_PF_RING_CTL_SRN(val)   (((val) >> 8) & 0xFF)
+#define    CN93_SDP_MAC_PF_RING_CTL_RPPF(val)  (((val) >> 16) & 0x3F)
+
+/* Number of non-queue interrupts in CN93xx */
+#define    CN93_NUM_NON_IOQ_INTR    16
+#endif /* _OCTEP_REGS_CN9K_PF_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
new file mode 100644
index 000000000000..4fa67f305cc8
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/etherdevice.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+
+/**
+ * octep_setup_oqs() - setup resources for all Rx queues.
+ *
+ * @oct: Octeon device private data structure.
+ */
+int octep_setup_oqs(struct octep_device *oct)
+{
+	return -1;
+}
+
+/**
+ * octep_oq_dbell_init() - Initialize Rx queue doorbell.
+ *
+ * @oct: Octeon device private data structure.
+ *
+ * Write number of descriptors to Rx queue doorbell register.
+ */
+void octep_oq_dbell_init(struct octep_device *oct)
+{
+}
+
+/**
+ * octep_free_oqs() - Free resources of all Rx queues.
+ *
+ * @oct: Octeon device private data structure.
+ */
+void octep_free_oqs(struct octep_device *oct)
+{
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
new file mode 100644
index 000000000000..782a24f27f3e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
@@ -0,0 +1,199 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef _OCTEP_RX_H_
+#define _OCTEP_RX_H_
+
+/* struct octep_oq_desc_hw - Octeon Hardware OQ descriptor format.
+ *
+ * The descriptor ring is made of descriptors which have 2 64-bit values:
+ *
+ *   @buffer_ptr: DMA address of the skb->data
+ *   @info_ptr:  DMA address of host memory, used to update pkt count by hw.
+ *               This is currently unused to save pci writes.
+ */
+struct octep_oq_desc_hw {
+	dma_addr_t buffer_ptr;
+	u64 info_ptr;
+};
+
+#define OCTEP_OQ_DESC_SIZE    (sizeof(struct octep_oq_desc_hw))
+
+#define OCTEP_CSUM_L4_VERIFIED 0x1
+#define OCTEP_CSUM_IP_VERIFIED 0x2
+#define OCTEP_CSUM_VERIFIED (OCTEP_CSUM_L4_VERIFIED | OCTEP_CSUM_IP_VERIFIED)
+
+/* Extended Response Header in packet data received from Hardware.
+ * Includes metadata like checksum status.
+ * this is valid only if hardware/firmware published support for this.
+ * This is at offset 0 of packet data (skb->data).
+ */
+struct octep_oq_resp_hw_ext {
+	/* Reserved. */
+	u64 reserved:62;
+
+	/* checksum verified. */
+	u64 csum_verified:2;
+};
+
+#define  OCTEP_OQ_RESP_HW_EXT_SIZE   (sizeof(struct octep_oq_resp_hw_ext))
+
+/* Length of Rx packet DMA'ed by Octeon to Host.
+ * this is in bigendian; so need to be converted to cpu endian.
+ * Octeon writes this at the beginning of Rx buffer (skb->data).
+ */
+struct octep_oq_resp_hw {
+	/* The Length of the packet. */
+	__be64 length;
+};
+
+#define OCTEP_OQ_RESP_HW_SIZE   (sizeof(struct octep_oq_resp_hw))
+
+/* Pointer to data buffer.
+ * Driver keeps a pointer to the data buffer that it made available to
+ * the Octeon device. Since the descriptor ring keeps physical (bus)
+ * addresses, this field is required for the driver to keep track of
+ * the virtual address pointers. The fields are operated by
+ * OS-dependent routines.
+ */
+struct octep_rx_buffer {
+	struct page *page;
+
+	/* length from rx hardware descriptor after converting to cpu endian */
+	u64 len;
+};
+
+#define OCTEP_OQ_RECVBUF_SIZE    (sizeof(struct octep_rx_buffer))
+
+/* Output Queue statistics. Each output queue has four stats fields. */
+struct octep_oq_stats {
+	/* Number of packets received from the Device. */
+	u64 packets;
+
+	/* Number of bytes received from the Device. */
+	u64 bytes;
+
+	/* Number of times failed to allocate buffers. */
+	u64 alloc_failures;
+};
+
+#define OCTEP_OQ_STATS_SIZE   (sizeof(struct octep_oq_stats))
+
+/* Hardware interface Rx statistics */
+struct octep_iface_rx_stats {
+	/* Received packets */
+	u64 pkts;
+
+	/* Octets of received packets */
+	u64 octets;
+
+	/* Received PAUSE and Control packets */
+	u64 pause_pkts;
+
+	/* Received PAUSE and Control octets */
+	u64 pause_octets;
+
+	/* Filtered DMAC0 packets */
+	u64 dmac0_pkts;
+
+	/* Filtered DMAC0 octets */
+	u64 dmac0_octets;
+
+	/* Packets dropped due to RX FIFO full */
+	u64 dropped_pkts_fifo_full;
+
+	/* Octets dropped due to RX FIFO full */
+	u64 dropped_octets_fifo_full;
+
+	/* Error packets */
+	u64 err_pkts;
+
+	/* Filtered DMAC1 packets */
+	u64 dmac1_pkts;
+
+	/* Filtered DMAC1 octets */
+	u64 dmac1_octets;
+
+	/* NCSI-bound packets dropped */
+	u64 ncsi_dropped_pkts;
+
+	/* NCSI-bound octets dropped */
+	u64 ncsi_dropped_octets;
+
+	/* Multicast packets received. */
+	u64 mcast_pkts;
+
+	/* Broadcast packets received. */
+	u64 bcast_pkts;
+
+};
+
+/* The Descriptor Ring Output Queue structure.
+ * This structure has all the information required to implement a
+ * Octeon OQ.
+ */
+struct octep_oq {
+	u32 q_no;
+
+	struct octep_device *octep_dev;
+	struct net_device *netdev;
+	struct device *dev;
+
+	struct napi_struct *napi;
+
+	/* The receive buffer list. This list has the virtual addresses
+	 * of the buffers.
+	 */
+	struct octep_rx_buffer *buff_info;
+
+	/* Pointer to the mapped packet credit register.
+	 * Host writes number of info/buffer ptrs available to this register
+	 */
+	u8 __iomem *pkts_credit_reg;
+
+	/* Pointer to the mapped packet sent register.
+	 * Octeon writes the number of packets DMA'ed to host memory
+	 * in this register.
+	 */
+	u8 __iomem *pkts_sent_reg;
+
+	/* Statistics for this OQ. */
+	struct octep_oq_stats stats;
+
+	/* Packets pending to be processed */
+	u32 pkts_pending;
+	u32 last_pkt_count;
+
+	/* Index in the ring where the driver should read the next packet */
+	u32 host_read_idx;
+
+	/* Number of  descriptors in this ring. */
+	u32 max_count;
+	u32 ring_size_mask;
+
+	/* The number of descriptors pending refill. */
+	u32 refill_count;
+
+	/* Index in the ring where the driver will refill the
+	 * descriptor's buffer
+	 */
+	u32 host_refill_idx;
+	u32 refill_threshold;
+
+	/* The size of each buffer pointed by the buffer pointer. */
+	u32 buffer_size;
+	u32 max_single_buffer_size;
+
+	/* The 8B aligned descriptor ring starts at this address. */
+	struct octep_oq_desc_hw *desc_ring;
+
+	/* DMA mapped address of the OQ descriptor ring. */
+	dma_addr_t desc_ring_dma;
+};
+
+#define OCTEP_OQ_SIZE   (sizeof(struct octep_oq))
+#endif	/* _OCTEP_RX_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
new file mode 100644
index 000000000000..f0e1cc142b2e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#include <linux/pci.h>
+#include <linux/etherdevice.h>
+
+#include "octep_config.h"
+#include "octep_main.h"
+
+/**
+ * octep_clean_iqs()  - Clean Tx queues to shutdown the device.
+ *
+ * @oct: Octeon device private data structure.
+ *
+ * Free the buffers in Tx queue descriptors pending completion and
+ * reset queue indices
+ */
+void octep_clean_iqs(struct octep_device *oct)
+{
+}
+
+/**
+ * octep_setup_iqs() - setup resources for all Tx queues.
+ *
+ * @oct: Octeon device private data structure.
+ */
+int octep_setup_iqs(struct octep_device *oct)
+{
+	return -1;
+}
+
+/**
+ * octep_free_iqs() - Free resources of all Tx queues.
+ *
+ * @oct: Octeon device private data structure.
+ */
+void octep_free_iqs(struct octep_device *oct)
+{
+}
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
new file mode 100644
index 000000000000..ee525c32cc81
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_tx.h
@@ -0,0 +1,284 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell Octeon EP (EndPoint) Ethernet Driver
+ *
+ * Copyright (C) 2020 Marvell.
+ *
+ */
+
+#ifndef _OCTEP_TX_H_
+#define _OCTEP_TX_H_
+
+#define IQ_SEND_OK          0
+#define IQ_SEND_STOP        1
+#define IQ_SEND_FAILED     -1
+
+#define TX_BUFTYPE_NONE          0
+#define TX_BUFTYPE_NET           1
+#define TX_BUFTYPE_NET_SG        2
+#define NUM_TX_BUFTYPES          3
+
+/* Hardware format for Scatter/Gather list */
+struct octep_tx_sglist_desc {
+	u16 len[4];
+	dma_addr_t dma_ptr[4];
+};
+
+/* Each Scatter/Gather entry sent to hardwar hold four pointers.
+ * So, number of entries required is (MAX_SKB_FRAGS + 1)/4, where '+1'
+ * is for main skb which also goes as a gather buffer to Octeon hardware.
+ * To allocate sufficent SGLIST entries for a packet with max fragments,
+ * align by adding 3 before calcuating max SGLIST entries per packet.
+ */
+#define OCTEP_SGLIST_ENTRIES_PER_PKT ((MAX_SKB_FRAGS + 1 + 3) / 4)
+#define OCTEP_SGLIST_SIZE_PER_PKT \
+	(OCTEP_SGLIST_ENTRIES_PER_PKT * sizeof(struct octep_tx_sglist_desc))
+
+struct octep_tx_buffer {
+	struct sk_buff *skb;
+	dma_addr_t dma;
+	struct octep_tx_sglist_desc *sglist;
+	dma_addr_t sglist_dma;
+	u8 gather;
+};
+
+#define OCTEP_IQ_TXBUFF_INFO_SIZE (sizeof(struct octep_tx_buffer))
+
+/* Hardware interface Tx statistics */
+struct octep_iface_tx_stats {
+	/* Packets dropped due to excessive collisions */
+	u64 xscol;
+
+	/* Packets dropped due to excessive deferral */
+	u64 xsdef;
+
+	/* Packets sent that experienced multiple collisions before successful
+	 * transmission
+	 */
+	u64 mcol;
+
+	/* Packets sent that experienced a single collision before successful
+	 * transmission
+	 */
+	u64 scol;
+
+	/* Total octets sent on the interface */
+	u64 octs;
+
+	/* Total frames sent on the interface */
+	u64 pkts;
+
+	/* Packets sent with an octet count < 64 */
+	u64 hist_lt64;
+
+	/* Packets sent with an octet count == 64 */
+	u64 hist_eq64;
+
+	/* Packets sent with an octet count of 65–127 */
+	u64 hist_65to127;
+
+	/* Packets sent with an octet count of 128–255 */
+	u64 hist_128to255;
+
+	/* Packets sent with an octet count of 256–511 */
+	u64 hist_256to511;
+
+	/* Packets sent with an octet count of 512–1023 */
+	u64 hist_512to1023;
+
+	/* Packets sent with an octet count of 1024-1518 */
+	u64 hist_1024to1518;
+
+	/* Packets sent with an octet count of > 1518 */
+	u64 hist_gt1518;
+
+	/* Packets sent to a broadcast DMAC */
+	u64 bcst;
+
+	/* Packets sent to the multicast DMAC */
+	u64 mcst;
+
+	/* Packets sent that experienced a transmit underflow and were
+	 * truncated
+	 */
+	u64 undflw;
+
+	/* Control/PAUSE packets sent */
+	u64 ctl;
+};
+
+/* Input Queue statistics. Each input queue has four stats fields. */
+struct octep_iq_stats {
+	/* Instructions posted to this queue. */
+	u64 instr_posted;
+
+	/* Instructions copied by hardware for processing. */
+	u64 instr_completed;
+
+	/* Instructions that could not be processed. */
+	u64 instr_dropped;
+
+	/* Bytes sent through this queue. */
+	u64 bytes_sent;
+
+	/* Gather entries sent through this queue. */
+	u64 sgentry_sent;
+
+	/* Number of transmit failures due to TX_BUSY */
+	u64 tx_busy;
+
+	/* Number of times the queue is restarted */
+	u64 restart_cnt;
+};
+
+/* The instruction (input) queue.
+ * The input queue is used to post raw (instruction) mode data or packet
+ * data to Octeon device from the host. Each input queue (upto 4) for
+ * a Octeon device has one such structure to represent it.
+ */
+struct octep_iq {
+	u32 q_no;
+
+	struct octep_device *octep_dev;
+	struct net_device *netdev;
+	struct device *dev;
+	struct netdev_queue *netdev_q;
+
+	/* Index in input ring where driver should write the next packet */
+	u16 host_write_index;
+
+	/* Index in input ring where Octeon is expected to read next packet */
+	u16 octep_read_index;
+
+	/* This index aids in finding the window in the queue where Octeon
+	 * has read the commands.
+	 */
+	u16 flush_index;
+
+	/* Statistics for this input queue. */
+	struct octep_iq_stats stats;
+
+	/* This field keeps track of the instructions pending in this queue. */
+	atomic_t instr_pending;
+
+	/* Pointer to the Virtual Base addr of the input ring. */
+	struct octep_tx_desc_hw *desc_ring;
+
+	/* DMA mapped base address of the input descriptor ring. */
+	dma_addr_t desc_ring_dma;
+
+	/* Info of Tx buffers pending completion. */
+	struct octep_tx_buffer *buff_info;
+
+	/* Base pointer to Scatter/Gather lists for all ring descriptors. */
+	struct octep_tx_sglist_desc *sglist;
+
+	/* DMA mapped addr of Scatter Gather Lists */
+	dma_addr_t sglist_dma;
+
+	/* Octeon doorbell register for the ring. */
+	u8 __iomem *doorbell_reg;
+
+	/* Octeon instruction count register for this ring. */
+	u8 __iomem *inst_cnt_reg;
+
+	/* interrupt level register for this ring */
+	u8 __iomem *intr_lvl_reg;
+
+	/* Maximum no. of instructions in this queue. */
+	u32 max_count;
+	u32 ring_size_mask;
+
+	u32 pkt_in_done;
+	u32 pkts_processed;
+
+	u32 status;
+
+	/* Number of instructions pending to be posted to Octeon. */
+	u32 fill_cnt;
+
+	/* The max. number of instructions that can be held pending by the
+	 * driver before ringing doorbell.
+	 */
+	u32 fill_threshold;
+};
+
+/* Hardware Tx Instruction Header */
+struct octep_instr_hdr {
+	/* Data Len */
+	u64 tlen:16;
+
+	/* Reserved */
+	u64 rsvd:20;
+
+	/* PKIND for SDP */
+	u64 pkind:6;
+
+	/* Front Data size */
+	u64 fsz:6;
+
+	/* No. of entries in gather list */
+	u64 gsz:14;
+
+	/* Gather indicator 1=gather*/
+	u64 gather:1;
+
+	/* Reserved3 */
+	u64 reserved3:1;
+};
+
+/* Hardware Tx completion response header */
+struct octep_instr_resp_hdr {
+	/* Request ID  */
+	u64 rid:16;
+
+	/* PCIe port to use for response */
+	u64 pcie_port:3;
+
+	/* Scatter indicator  1=scatter */
+	u64 scatter:1;
+
+	/* Size of Expected result OR no. of entries in scatter list */
+	u64 rlenssz:14;
+
+	/* Desired destination port for result */
+	u64 dport:6;
+
+	/* Opcode Specific parameters */
+	u64 param:8;
+
+	/* Opcode for the return packet  */
+	u64 opcode:16;
+};
+
+/* 64-byte Tx instruction format.
+ * Format of instruction for a 64-byte mode input queue.
+ *
+ * only first 16-bytes (dptr and ih) are mandatory; rest are optional
+ * and filled by the driver based on firmware/hardware capabilities.
+ * These optional headers together called Front Data and its size is
+ * described by ih->fsz.
+ */
+struct octep_tx_desc_hw {
+	/* Pointer where the input data is available. */
+	u64 dptr;
+
+	/* Instruction Header. */
+	union {
+		struct octep_instr_hdr ih;
+		u64 ih64;
+	};
+
+	/* Pointer where the response for a RAW mode packet will be written
+	 * by Octeon.
+	 */
+	u64 rptr;
+
+	/* Input Instruction Response Header. */
+	struct octep_instr_resp_hdr irh;
+
+	/* Additional headers available in a 64-byte instruction. */
+	u64 exhdr[4];
+};
+
+#define OCTEP_IQ_DESC_SIZE (sizeof(struct octep_tx_desc_hw))
+#endif /* _OCTEP_TX_H_ */
-- 
2.17.1

