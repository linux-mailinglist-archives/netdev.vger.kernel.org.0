Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A60436C26
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 22:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhJUUcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 16:32:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:46175 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhJUUcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 16:32:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10144"; a="315343857"
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="315343857"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:23 -0700
X-IronPort-AV: E=Sophos;i="5.87,170,1631602800"; 
   d="scan'208";a="527625056"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 13:28:22 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH 03/14] net: wwan: t7xx: Add core components
Date:   Thu, 21 Oct 2021 13:27:27 -0700
Message-Id: <20211021202738.729-4-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
References: <20211021202738.729-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Registers the t7xx device driver with the kernel. Setup all the core
components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
modem control operations, modem state machine, and build
infrastructure.

* PCIe layer code implements driver probe and removal.
* MHCCIF provides interrupt channels to communicate events
  such as handshake, PM and port enumeration.
* Modem control implements the entry point for modem init,
  reset and exit.
* The modem status monitor is a state machine used by modem control
  to complete initialization and stop. It is used also to propagate
  exception events reported by other components.

Signed-off-by: Haijun Lio <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/Kconfig                   |  14 +
 drivers/net/wwan/Makefile                  |   1 +
 drivers/net/wwan/t7xx/Makefile             |  13 +
 drivers/net/wwan/t7xx/t7xx_common.h        |  69 +++
 drivers/net/wwan/t7xx/t7xx_mhccif.c        |  99 ++++
 drivers/net/wwan/t7xx/t7xx_mhccif.h        |  29 +
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 480 +++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |  82 +++
 drivers/net/wwan/t7xx/t7xx_monitor.h       | 137 +++++
 drivers/net/wwan/t7xx/t7xx_pci.c           | 228 ++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h           |  59 ++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.c      | 270 ++++++++++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.h      |  29 +
 drivers/net/wwan/t7xx/t7xx_reg.h           | 389 ++++++++++++++
 drivers/net/wwan/t7xx/t7xx_skb_util.c      | 354 ++++++++++++
 drivers/net/wwan/t7xx/t7xx_skb_util.h      | 102 ++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 591 +++++++++++++++++++++
 17 files changed, 2946 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/Makefile
 create mode 100644 drivers/net/wwan/t7xx/t7xx_common.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_monitor.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_skb_util.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_skb_util.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.c

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 77dbfc418bce..244cb522e2c5 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -79,6 +79,20 @@ config IOSM
 
 	  If unsure, say N.
 
+config MTK_T7XX
+	tristate "MediaTek PCIe 5G WWAN modem T7XX device"
+	depends on PCI
+	help
+	  Enables MediaTek PCIe based 5G WWAN modem (T700 series) device.
+	  Adapts WWAN framework and provides network interface like wwan0
+	  and tty interfaces like wwan0at0 (AT protocol), wwan0mbim0
+	  (MBIM protocol), etc.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called mtk_t7xx.
+
+	  If unsure, say N.
+
 endif # WWAN
 
 endmenu
diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
index fe51feedac21..ae913797efa4 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
 obj-$(CONFIG_MHI_WWAN_MBIM) += mhi_wwan_mbim.o
 obj-$(CONFIG_RPMSG_WWAN_CTRL) += rpmsg_wwan_ctrl.o
 obj-$(CONFIG_IOSM) += iosm/
+obj-$(CONFIG_MTK_T7XX) += t7xx/
diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
new file mode 100644
index 000000000000..dc0e6e025d55
--- /dev/null
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+ccflags-y += -Werror
+
+obj-${CONFIG_MTK_T7XX} := mtk_t7xx.o
+mtk_t7xx-y:=	t7xx_pci.o \
+		t7xx_pcie_mac.o \
+		t7xx_mhccif.o \
+		t7xx_state_monitor.o  \
+		t7xx_modem_ops.o \
+		t7xx_skb_util.o \
+		t7xx_cldma.o \
+		t7xx_hif_cldma.o  \
diff --git a/drivers/net/wwan/t7xx/t7xx_common.h b/drivers/net/wwan/t7xx/t7xx_common.h
new file mode 100644
index 000000000000..2b0340236c2e
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_common.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_COMMON_H__
+#define __T7XX_COMMON_H__
+
+#include <linux/bits.h>
+#include <linux/types.h>
+
+struct ccci_header {
+	/* do not assume data[1] is data length in rx */
+	u32 data[2];
+	u32 status;
+	u32 reserved;
+};
+
+enum txq_type {
+	TXQ_NORMAL,
+	TXQ_FAST,
+	TXQ_TYPE_CNT
+};
+
+enum direction {
+	MTK_IN,
+	MTK_OUT,
+	MTK_INOUT,
+};
+
+#define HDR_FLD_AST		BIT(31)
+#define HDR_FLD_SEQ		GENMASK(30, 16)
+#define HDR_FLD_CHN		GENMASK(15, 0)
+
+#define CCCI_H_LEN		16
+/* CCCI_H_LEN + reserved space that is used in exception flow */
+#define CCCI_H_ELEN		128
+
+#define CCCI_HEADER_NO_DATA	0xffffffff
+
+/* Control identification numbers for AP<->MD messages  */
+#define CTL_ID_HS1_MSG		0x0
+#define CTL_ID_HS2_MSG		0x1
+#define CTL_ID_HS3_MSG		0x2
+#define CTL_ID_MD_EX		0x4
+#define CTL_ID_DRV_VER_ERROR	0x5
+#define CTL_ID_MD_EX_ACK	0x6
+#define CTL_ID_MD_EX_PASS	0x8
+#define CTL_ID_PORT_ENUM	0x9
+
+/* Modem exception check identification number */
+#define MD_EX_CHK_ID		0x45584350
+/* Modem exception check acknowledge identification number */
+#define MD_EX_CHK_ACK_ID	0x45524543
+
+enum md_state {
+	MD_STATE_INVALID, /* no traffic */
+	MD_STATE_GATED, /* no traffic */
+	MD_STATE_WAITING_FOR_HS1,
+	MD_STATE_WAITING_FOR_HS2,
+	MD_STATE_READY,
+	MD_STATE_EXCEPTION,
+	MD_STATE_RESET, /* no traffic */
+	MD_STATE_WAITING_TO_STOP,
+	MD_STATE_STOPPED,
+};
+
+#endif
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.c b/drivers/net/wwan/t7xx/t7xx_mhccif.c
new file mode 100644
index 000000000000..c68d98a3d765
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/completion.h>
+#include <linux/pci.h>
+
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+
+static void mhccif_clear_interrupts(struct mtk_pci_dev *mtk_dev, u32 mask)
+{
+	void __iomem *mhccif_pbase;
+
+	mhccif_pbase = mtk_dev->base_addr.mhccif_rc_base;
+
+	/* Clear level 2 interrupt */
+	iowrite32(mask, mhccif_pbase + REG_EP2RC_SW_INT_ACK);
+
+	/* Read back to ensure write is done */
+	mhccif_read_sw_int_sts(mtk_dev);
+
+	/* Clear level 1 interrupt */
+	mtk_pcie_mac_clear_int_status(mtk_dev, MHCCIF_INT);
+}
+
+static irqreturn_t mhccif_isr_thread(int irq, void *data)
+{
+	struct mtk_pci_dev *mtk_dev;
+	u32 int_sts;
+
+	mtk_dev = data;
+
+	/* Use 1*4 bits to avoid low power bits*/
+	iowrite32(L1_1_DISABLE_BIT(1) | L1_2_DISABLE_BIT(1),
+		  IREG_BASE(mtk_dev) + DIS_ASPM_LOWPWR_SET_0);
+
+	int_sts = mhccif_read_sw_int_sts(mtk_dev);
+	if (int_sts & mtk_dev->mhccif_bitmask)
+		mtk_pci_mhccif_isr(mtk_dev);
+
+	/* Clear 2 & 1 level interrupts */
+	mhccif_clear_interrupts(mtk_dev, int_sts);
+
+	/* Enable corresponding interrupt */
+	mtk_pcie_mac_set_int(mtk_dev, MHCCIF_INT);
+	return IRQ_HANDLED;
+}
+
+u32 mhccif_read_sw_int_sts(struct mtk_pci_dev *mtk_dev)
+{
+	return ioread32(mtk_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_STS);
+}
+
+void mhccif_mask_set(struct mtk_pci_dev *mtk_dev, u32 val)
+{
+	iowrite32(val, mtk_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_EAP_MASK_SET);
+}
+
+void mhccif_mask_clr(struct mtk_pci_dev *mtk_dev, u32 val)
+{
+	iowrite32(val, mtk_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_EAP_MASK_CLR);
+}
+
+u32 mhccif_mask_get(struct mtk_pci_dev *mtk_dev)
+{
+	/* mtk_dev is validated in calling function */
+	return ioread32(mtk_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_EAP_MASK);
+}
+
+static irqreturn_t mhccif_isr_handler(int irq, void *data)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+void mhccif_init(struct mtk_pci_dev *mtk_dev)
+{
+	mtk_dev->base_addr.mhccif_rc_base = mtk_dev->base_addr.pcie_ext_reg_base +
+					    MHCCIF_RC_DEV_BASE -
+					    mtk_dev->base_addr.pcie_dev_reg_trsl_addr;
+
+	/* Register MHCCHIF int handler to handle */
+	mtk_dev->intr_handler[MHCCIF_INT] = mhccif_isr_handler;
+	mtk_dev->intr_thread[MHCCIF_INT] = mhccif_isr_thread;
+	mtk_dev->callback_param[MHCCIF_INT] = mtk_dev;
+}
+
+void mhccif_h2d_swint_trigger(struct mtk_pci_dev *mtk_dev, u32 channel)
+{
+	void __iomem *mhccif_pbase;
+
+	mhccif_pbase = mtk_dev->base_addr.mhccif_rc_base;
+	iowrite32(BIT(channel), mhccif_pbase + REG_RC2EP_SW_BSY);
+	iowrite32(channel, mhccif_pbase + REG_RC2EP_SW_TCHNUM);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.h b/drivers/net/wwan/t7xx/t7xx_mhccif.h
new file mode 100644
index 000000000000..ad25945a74e5
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_MHCCIF_H__
+#define __T7XX_MHCCIF_H__
+
+#include <linux/types.h>
+
+#include "t7xx_pci.h"
+#include "t7xx_reg.h"
+
+#define D2H_SW_INT_MASK (D2H_INT_EXCEPTION_INIT |		\
+			 D2H_INT_EXCEPTION_INIT_DONE |		\
+			 D2H_INT_EXCEPTION_CLEARQ_DONE |	\
+			 D2H_INT_EXCEPTION_ALLQ_RESET |		\
+			 D2H_INT_PORT_ENUM |			\
+			 D2H_INT_ASYNC_MD_HK)
+
+void mhccif_mask_set(struct mtk_pci_dev *mtk_dev, u32 val);
+void mhccif_mask_clr(struct mtk_pci_dev *mtk_dev, u32 val);
+u32 mhccif_mask_get(struct mtk_pci_dev *mtk_dev);
+void mhccif_init(struct mtk_pci_dev *mtk_dev);
+u32 mhccif_read_sw_int_sts(struct mtk_pci_dev *mtk_dev);
+void mhccif_h2d_swint_trigger(struct mtk_pci_dev *mtk_dev, u32 channel);
+
+#endif /*__T7XX_MHCCIF_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
new file mode 100644
index 000000000000..b47ce6e55758
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -0,0 +1,480 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_monitor.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+
+#define RGU_RESET_DELAY_US	20
+#define PORT_RESET_DELAY_US	2000
+
+enum mtk_feature_support_type {
+	MTK_FEATURE_DOES_NOT_EXIST,
+	MTK_FEATURE_NOT_SUPPORTED,
+	MTK_FEATURE_MUST_BE_SUPPORTED,
+};
+
+static inline unsigned int get_interrupt_status(struct mtk_pci_dev *mtk_dev)
+{
+	return mhccif_read_sw_int_sts(mtk_dev) & D2H_SW_INT_MASK;
+}
+
+/**
+ * mtk_pci_mhccif_isr() - Process MHCCIF interrupts
+ * @mtk_dev: MTK device
+ *
+ * Check the interrupt status, and queue commands accordingly
+ *
+ * Returns: 0 on success or -EINVAL on failure
+ */
+int mtk_pci_mhccif_isr(struct mtk_pci_dev *mtk_dev)
+{
+	struct md_sys_info *md_info;
+	struct ccci_fsm_ctl *ctl;
+	struct mtk_modem *md;
+	unsigned int int_sta;
+	unsigned long flags;
+	u32 mask;
+
+	md = mtk_dev->md;
+	ctl = fsm_get_entry();
+	if (!ctl) {
+		dev_err(&mtk_dev->pdev->dev,
+			"process MHCCIF interrupt before modem monitor was initialized\n");
+		return -EINVAL;
+	}
+
+	md_info = md->md_info;
+	spin_lock_irqsave(&md_info->exp_spinlock, flags);
+	int_sta = get_interrupt_status(mtk_dev);
+	md_info->exp_id |= int_sta;
+
+	if (md_info->exp_id & D2H_INT_PORT_ENUM) {
+		md_info->exp_id &= ~D2H_INT_PORT_ENUM;
+		if (ctl->curr_state == CCCI_FSM_INIT ||
+		    ctl->curr_state == CCCI_FSM_PRE_START ||
+		    ctl->curr_state == CCCI_FSM_STOPPED)
+			ccci_fsm_recv_md_interrupt(MD_IRQ_PORT_ENUM);
+	}
+
+	if (md_info->exp_id & D2H_INT_EXCEPTION_INIT) {
+		if (ctl->md_state == MD_STATE_INVALID ||
+		    ctl->md_state == MD_STATE_WAITING_FOR_HS1 ||
+		    ctl->md_state == MD_STATE_WAITING_FOR_HS2 ||
+		    ctl->md_state == MD_STATE_READY) {
+			md_info->exp_id &= ~D2H_INT_EXCEPTION_INIT;
+			ccci_fsm_recv_md_interrupt(MD_IRQ_CCIF_EX);
+		}
+	} else if (ctl->md_state == MD_STATE_WAITING_FOR_HS1) {
+		/* start handshake if MD not assert */
+		mask = mhccif_mask_get(mtk_dev);
+		if ((md_info->exp_id & D2H_INT_ASYNC_MD_HK) && !(mask & D2H_INT_ASYNC_MD_HK)) {
+			md_info->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+			queue_work(md->handshake_wq, &md->handshake_work);
+		}
+	}
+
+	spin_unlock_irqrestore(&md_info->exp_spinlock, flags);
+
+	return 0;
+}
+
+static void clr_device_irq_via_pcie(struct mtk_pci_dev *mtk_dev)
+{
+	struct mtk_addr_base *pbase_addr;
+	void __iomem *rgu_pciesta_reg;
+
+	pbase_addr = &mtk_dev->base_addr;
+	rgu_pciesta_reg = pbase_addr->pcie_ext_reg_base + TOPRGU_CH_PCIE_IRQ_STA -
+			  pbase_addr->pcie_dev_reg_trsl_addr;
+
+	/* clear RGU PCIe IRQ state */
+	iowrite32(ioread32(rgu_pciesta_reg), rgu_pciesta_reg);
+}
+
+void mtk_clear_rgu_irq(struct mtk_pci_dev *mtk_dev)
+{
+	/* clear L2 */
+	clr_device_irq_via_pcie(mtk_dev);
+	/* clear L1 */
+	mtk_pcie_mac_clear_int_status(mtk_dev, SAP_RGU_INT);
+}
+
+static int mtk_acpi_reset(struct mtk_pci_dev *mtk_dev, char *fn_name)
+{
+#ifdef CONFIG_ACPI
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	acpi_status acpi_ret;
+	struct device *dev;
+	acpi_handle handle;
+
+	dev = &mtk_dev->pdev->dev;
+
+	if (acpi_disabled) {
+		dev_err(dev, "acpi function isn't enabled\n");
+		return -EFAULT;
+	}
+
+	handle = ACPI_HANDLE(dev);
+	if (!handle) {
+		dev_err(dev, "acpi handle isn't found\n");
+		return -EFAULT;
+	}
+
+	if (!acpi_has_method(handle, fn_name)) {
+		dev_err(dev, "%s method isn't found\n", fn_name);
+		return -EFAULT;
+	}
+
+	acpi_ret = acpi_evaluate_object(handle, fn_name, NULL, &buffer);
+	if (ACPI_FAILURE(acpi_ret)) {
+		dev_err(dev, "%s method fail: %s\n", fn_name, acpi_format_exception(acpi_ret));
+		return -EFAULT;
+	}
+#endif
+	return 0;
+}
+
+int mtk_acpi_fldr_func(struct mtk_pci_dev *mtk_dev)
+{
+	return mtk_acpi_reset(mtk_dev, "_RST");
+}
+
+static void reset_device_via_pmic(struct mtk_pci_dev *mtk_dev)
+{
+	unsigned int val;
+
+	val = ioread32(IREG_BASE(mtk_dev) + PCIE_MISC_DEV_STATUS);
+
+	if (val & MISC_RESET_TYPE_PLDR)
+		mtk_acpi_reset(mtk_dev, "MRST._RST");
+	else if (val & MISC_RESET_TYPE_FLDR)
+		mtk_acpi_fldr_func(mtk_dev);
+}
+
+static irqreturn_t rgu_isr_thread(int irq, void *data)
+{
+	struct mtk_pci_dev *mtk_dev;
+	struct mtk_modem *modem;
+
+	mtk_dev = data;
+	modem = mtk_dev->md;
+
+	msleep(RGU_RESET_DELAY_US);
+	reset_device_via_pmic(modem->mtk_dev);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rgu_isr_handler(int irq, void *data)
+{
+	struct mtk_pci_dev *mtk_dev;
+	struct mtk_modem *modem;
+
+	mtk_dev = data;
+	modem = mtk_dev->md;
+
+	mtk_clear_rgu_irq(mtk_dev);
+
+	if (!mtk_dev->rgu_pci_irq_en)
+		return IRQ_HANDLED;
+
+	atomic_set(&modem->rgu_irq_asserted, 1);
+	mtk_pcie_mac_clear_int(mtk_dev, SAP_RGU_INT);
+	return IRQ_WAKE_THREAD;
+}
+
+static void mtk_pcie_register_rgu_isr(struct mtk_pci_dev *mtk_dev)
+{
+	/* registers RGU callback isr with PCIe driver */
+	mtk_pcie_mac_clear_int(mtk_dev, SAP_RGU_INT);
+	mtk_pcie_mac_clear_int_status(mtk_dev, SAP_RGU_INT);
+
+	mtk_dev->intr_handler[SAP_RGU_INT] = rgu_isr_handler;
+	mtk_dev->intr_thread[SAP_RGU_INT] = rgu_isr_thread;
+	mtk_dev->callback_param[SAP_RGU_INT] = mtk_dev;
+	mtk_pcie_mac_set_int(mtk_dev, SAP_RGU_INT);
+}
+
+static void md_exception(struct mtk_modem *md, enum hif_ex_stage stage)
+{
+	struct mtk_pci_dev *mtk_dev;
+
+	mtk_dev = md->mtk_dev;
+
+	if (stage == HIF_EX_CLEARQ_DONE)
+		/* give DHL time to flush data.
+		 * this is an empirical value that assure
+		 * that DHL have enough time to flush all the date.
+		 */
+		msleep(PORT_RESET_DELAY_US);
+
+	cldma_exception(ID_CLDMA1, stage);
+
+	if (stage == HIF_EX_INIT)
+		mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_EXCEPTION_ACK);
+	else if (stage == HIF_EX_CLEARQ_DONE)
+		mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_EXCEPTION_CLEARQ_ACK);
+}
+
+static int wait_hif_ex_hk_event(struct mtk_modem *md, int event_id)
+{
+	struct md_sys_info *md_info;
+	int sleep_time = 10;
+	int retries = 500; /* MD timeout is 5s */
+
+	md_info = md->md_info;
+	do {
+		if (md_info->exp_id & event_id)
+			return 0;
+
+		msleep(sleep_time);
+	} while (--retries);
+
+	return -EFAULT;
+}
+
+static void md_sys_sw_init(struct mtk_pci_dev *mtk_dev)
+{
+	/* Register the MHCCIF isr for MD exception, port enum and
+	 * async handshake notifications.
+	 */
+	mhccif_mask_set(mtk_dev, D2H_SW_INT_MASK);
+	mtk_dev->mhccif_bitmask = D2H_SW_INT_MASK;
+	mhccif_mask_clr(mtk_dev, D2H_INT_PORT_ENUM);
+
+	/* register RGU irq handler for sAP exception notification */
+	mtk_dev->rgu_pci_irq_en = true;
+	mtk_pcie_register_rgu_isr(mtk_dev);
+}
+
+static void md_hk_wq(struct work_struct *work)
+{
+	struct ccci_fsm_ctl *ctl;
+	struct mtk_modem *md;
+
+	ctl = fsm_get_entry();
+
+	cldma_switch_cfg(ID_CLDMA1);
+	cldma_start(ID_CLDMA1);
+	fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
+	md = container_of(work, struct mtk_modem, handshake_work);
+	atomic_set(&md->core_md.ready, 1);
+	wake_up(&ctl->async_hk_wq);
+}
+
+void mtk_md_event_notify(struct mtk_modem *md, enum md_event_id evt_id)
+{
+	struct md_sys_info *md_info;
+	void __iomem *mhccif_base;
+	struct ccci_fsm_ctl *ctl;
+	unsigned int int_sta;
+	unsigned long flags;
+
+	ctl = fsm_get_entry();
+	md_info = md->md_info;
+
+	switch (evt_id) {
+	case FSM_PRE_START:
+		mhccif_mask_clr(md->mtk_dev, D2H_INT_PORT_ENUM);
+		break;
+
+	case FSM_START:
+		mhccif_mask_set(md->mtk_dev, D2H_INT_PORT_ENUM);
+		spin_lock_irqsave(&md_info->exp_spinlock, flags);
+		int_sta = get_interrupt_status(md->mtk_dev);
+		md_info->exp_id |= int_sta;
+		if (md_info->exp_id & D2H_INT_EXCEPTION_INIT) {
+			atomic_set(&ctl->exp_flg, 1);
+			md_info->exp_id &= ~D2H_INT_EXCEPTION_INIT;
+			md_info->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+		} else if (atomic_read(&ctl->exp_flg)) {
+			md_info->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+		} else if (md_info->exp_id & D2H_INT_ASYNC_MD_HK) {
+			queue_work(md->handshake_wq, &md->handshake_work);
+			md_info->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+			mhccif_base = md->mtk_dev->base_addr.mhccif_rc_base;
+			iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
+			mhccif_mask_set(md->mtk_dev, D2H_INT_ASYNC_MD_HK);
+		} else {
+			/* unmask async handshake interrupt */
+			mhccif_mask_clr(md->mtk_dev, D2H_INT_ASYNC_MD_HK);
+		}
+
+		spin_unlock_irqrestore(&md_info->exp_spinlock, flags);
+		/* unmask exception interrupt */
+		mhccif_mask_clr(md->mtk_dev,
+				D2H_INT_EXCEPTION_INIT |
+				D2H_INT_EXCEPTION_INIT_DONE |
+				D2H_INT_EXCEPTION_CLEARQ_DONE |
+				D2H_INT_EXCEPTION_ALLQ_RESET);
+		break;
+
+	case FSM_READY:
+		/* mask async handshake interrupt */
+		mhccif_mask_set(md->mtk_dev, D2H_INT_ASYNC_MD_HK);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static void md_structure_reset(struct mtk_modem *md)
+{
+	struct md_sys_info *md_info;
+
+	md_info = md->md_info;
+	md_info->exp_id = 0;
+	spin_lock_init(&md_info->exp_spinlock);
+}
+
+void mtk_md_exception_handshake(struct mtk_modem *md)
+{
+	struct mtk_pci_dev *mtk_dev;
+	int ret;
+
+	mtk_dev = md->mtk_dev;
+	md_exception(md, HIF_EX_INIT);
+	ret = wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_INIT_DONE);
+
+	if (ret)
+		dev_err(&mtk_dev->pdev->dev, "EX CCIF HS timeout, RCH 0x%lx\n",
+			D2H_INT_EXCEPTION_INIT_DONE);
+
+	md_exception(md, HIF_EX_INIT_DONE);
+	ret = wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_CLEARQ_DONE);
+	if (ret)
+		dev_err(&mtk_dev->pdev->dev, "EX CCIF HS timeout, RCH 0x%lx\n",
+			D2H_INT_EXCEPTION_CLEARQ_DONE);
+
+	md_exception(md, HIF_EX_CLEARQ_DONE);
+	ret = wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_ALLQ_RESET);
+	if (ret)
+		dev_err(&mtk_dev->pdev->dev, "EX CCIF HS timeout, RCH 0x%lx\n",
+			D2H_INT_EXCEPTION_ALLQ_RESET);
+
+	md_exception(md, HIF_EX_ALLQ_RESET);
+}
+
+static struct mtk_modem *ccci_md_alloc(struct mtk_pci_dev *mtk_dev)
+{
+	struct mtk_modem *md;
+
+	md = devm_kzalloc(&mtk_dev->pdev->dev, sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return NULL;
+
+	md->md_info = devm_kzalloc(&mtk_dev->pdev->dev, sizeof(*md->md_info), GFP_KERNEL);
+	if (!md->md_info)
+		return NULL;
+
+	md->mtk_dev = mtk_dev;
+	mtk_dev->md = md;
+	atomic_set(&md->core_md.ready, 0);
+	md->handshake_wq = alloc_workqueue("%s",
+					   WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
+					   0, "md_hk_wq");
+	if (!md->handshake_wq)
+		return NULL;
+
+	INIT_WORK(&md->handshake_work, md_hk_wq);
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] &= ~FEATURE_MSK;
+	md->core_md.feature_set[RT_ID_MD_PORT_ENUM] |=
+		FIELD_PREP(FEATURE_MSK, MTK_FEATURE_MUST_BE_SUPPORTED);
+	return md;
+}
+
+void mtk_md_reset(struct mtk_pci_dev *mtk_dev)
+{
+	struct mtk_modem *md;
+
+	md = mtk_dev->md;
+	md->md_init_finish = false;
+	md_structure_reset(md);
+	ccci_fsm_reset();
+	cldma_reset(ID_CLDMA1);
+	md->md_init_finish = true;
+}
+
+/**
+ * mtk_md_init() - Initialize modem
+ * @mtk_dev: MTK device
+ *
+ * Allocate and initialize MD ctrl block, and initialize data path
+ * Register MHCCIF ISR and RGU ISR, and start the state machine
+ *
+ * Return: 0 on success or -ENOMEM on allocation failure
+ */
+int mtk_md_init(struct mtk_pci_dev *mtk_dev)
+{
+	struct ccci_fsm_ctl *fsm_ctl;
+	struct mtk_modem *md;
+	int ret;
+
+	/* allocate and initialize md ctrl memory */
+	md = ccci_md_alloc(mtk_dev);
+	if (!md)
+		return -ENOMEM;
+
+	ret = cldma_alloc(ID_CLDMA1, mtk_dev);
+	if (ret)
+		goto err_alloc;
+
+	/* initialize md ctrl block */
+	md_structure_reset(md);
+
+	ret = ccci_fsm_init(md);
+	if (ret)
+		goto err_alloc;
+
+	ret = cldma_init(ID_CLDMA1);
+	if (ret)
+		goto err_fsm_init;
+
+	fsm_ctl = fsm_get_entry();
+	fsm_append_command(fsm_ctl, CCCI_COMMAND_START, 0);
+
+	md_sys_sw_init(mtk_dev);
+
+	md->md_init_finish = true;
+	return 0;
+
+err_fsm_init:
+	ccci_fsm_uninit();
+err_alloc:
+	destroy_workqueue(md->handshake_wq);
+
+	dev_err(&mtk_dev->pdev->dev, "modem init failed\n");
+	return ret;
+}
+
+void mtk_md_exit(struct mtk_pci_dev *mtk_dev)
+{
+	struct mtk_modem *md = mtk_dev->md;
+	struct ccci_fsm_ctl *fsm_ctl;
+
+	md = mtk_dev->md;
+
+	mtk_pcie_mac_clear_int(mtk_dev, SAP_RGU_INT);
+
+	if (!md->md_init_finish)
+		return;
+
+	fsm_ctl = fsm_get_entry();
+	/* change FSM state, will auto jump to stopped */
+	fsm_append_command(fsm_ctl, CCCI_COMMAND_PRE_STOP, 1);
+	cldma_exit(ID_CLDMA1);
+	ccci_fsm_uninit();
+	destroy_workqueue(md->handshake_wq);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
new file mode 100644
index 000000000000..1d2fee18b559
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_MODEM_OPS_H__
+#define __T7XX_MODEM_OPS_H__
+
+#include <linux/bits.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+#include "t7xx_pci.h"
+
+#define RT_ID_MD_PORT_ENUM 0
+#define FEATURE_COUNT 64
+/* Modem feature query identification number */
+#define MD_FEATURE_QUERY_ID	0x49434343
+
+#define FEATURE_VER GENMASK(7, 4)
+#define FEATURE_MSK GENMASK(3, 0)
+
+/**
+ * enum hif_ex_stage -	HIF exception handshake stages with the HW
+ * @HIF_EX_INIT:        disable and clear TXQ
+ * @HIF_EX_INIT_DONE:   polling for init to be done
+ * @HIF_EX_CLEARQ_DONE: disable RX, flush TX/RX workqueues and clear RX
+ * @HIF_EX_ALLQ_RESET:  HW is back in safe mode for reinitialization and restart
+ */
+enum hif_ex_stage {
+	HIF_EX_INIT = 0,
+	HIF_EX_INIT_DONE,
+	HIF_EX_CLEARQ_DONE,
+	HIF_EX_ALLQ_RESET,
+};
+
+struct mtk_runtime_feature {
+	u8 feature_id;
+	u8 support_info;
+	u8 reserved[2];
+	u32 data_len;
+	u8 data[];
+};
+
+enum md_event_id {
+	FSM_PRE_START,
+	FSM_START,
+	FSM_READY,
+};
+
+struct core_sys_info {
+	atomic_t ready;
+	u8 feature_set[FEATURE_COUNT];
+};
+
+struct mtk_modem {
+	struct md_sys_info *md_info;
+	struct mtk_pci_dev *mtk_dev;
+	struct core_sys_info core_md;
+	bool md_init_finish;
+	atomic_t rgu_irq_asserted;
+	struct workqueue_struct *handshake_wq;
+	struct work_struct handshake_work;
+};
+
+struct md_sys_info {
+	unsigned int	exp_id;
+	spinlock_t	exp_spinlock; /* protect exp_id containing EX events */
+};
+
+void mtk_md_exception_handshake(struct mtk_modem *md);
+void mtk_md_event_notify(struct mtk_modem *md, enum md_event_id evt_id);
+void mtk_md_reset(struct mtk_pci_dev *mtk_dev);
+int mtk_md_init(struct mtk_pci_dev *mtk_dev);
+void mtk_md_exit(struct mtk_pci_dev *mtk_dev);
+void mtk_clear_rgu_irq(struct mtk_pci_dev *mtk_dev);
+int mtk_acpi_fldr_func(struct mtk_pci_dev *mtk_dev);
+int mtk_pci_mhccif_isr(struct mtk_pci_dev *mtk_dev);
+
+#endif	/* __T7XX_MODEM_OPS_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_monitor.h b/drivers/net/wwan/t7xx/t7xx_monitor.h
new file mode 100644
index 000000000000..42dec0e19035
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_monitor.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_MONITOR_H__
+#define __T7XX_MONITOR_H__
+
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include "t7xx_common.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_monitor.h"
+#include "t7xx_skb_util.h"
+
+enum ccci_fsm_state {
+	CCCI_FSM_INIT,
+	CCCI_FSM_PRE_START,
+	CCCI_FSM_STARTING,
+	CCCI_FSM_READY,
+	CCCI_FSM_EXCEPTION,
+	CCCI_FSM_STOPPING,
+	CCCI_FSM_STOPPED,
+};
+
+enum ccci_fsm_event_state {
+	CCCI_EVENT_INVALID,
+	CCCI_EVENT_MD_EX,
+	CCCI_EVENT_MD_EX_REC_OK,
+	CCCI_EVENT_MD_EX_PASS,
+	CCCI_EVENT_MAX
+};
+
+enum ccci_fsm_cmd_state {
+	CCCI_COMMAND_INVALID,
+	CCCI_COMMAND_START,
+	CCCI_COMMAND_EXCEPTION,
+	CCCI_COMMAND_PRE_STOP,
+	CCCI_COMMAND_STOP,
+};
+
+enum ccci_ex_reason {
+	EXCEPTION_HS_TIMEOUT,
+	EXCEPTION_EE,
+	EXCEPTION_EVENT,
+};
+
+enum md_irq_type {
+	MD_IRQ_WDT,
+	MD_IRQ_CCIF_EX,
+	MD_IRQ_PORT_ENUM,
+};
+
+enum fsm_cmd_result {
+	FSM_CMD_RESULT_PENDING,
+	FSM_CMD_RESULT_OK,
+	FSM_CMD_RESULT_FAIL,
+};
+
+#define FSM_CMD_FLAG_WAITING_TO_COMPLETE	BIT(0)
+#define FSM_CMD_FLAG_FLIGHT_MODE		BIT(1)
+
+#define EVENT_POLL_INTERVAL_MS			20
+#define MD_EX_REC_OK_TIMEOUT_MS			10000
+#define MD_EX_PASS_TIMEOUT_MS			(45 * 1000)
+
+struct ccci_fsm_monitor {
+	dev_t dev_n;
+	wait_queue_head_t rx_wq;
+	struct ccci_skb_queue rx_skb_list;
+};
+
+struct ccci_fsm_ctl {
+	struct mtk_modem *md;
+	enum md_state md_state;
+	unsigned int curr_state;
+	unsigned int last_state;
+	struct list_head command_queue;
+	struct list_head event_queue;
+	wait_queue_head_t command_wq;
+	wait_queue_head_t event_wq;
+	wait_queue_head_t async_hk_wq;
+	spinlock_t event_lock;		/* protects event_queue */
+	spinlock_t command_lock;	/* protects command_queue */
+	spinlock_t cmd_complete_lock;	/* protects fsm_command */
+	struct task_struct *fsm_thread;
+	atomic_t exp_flg;
+	struct ccci_fsm_monitor monitor_ctl;
+	spinlock_t notifier_lock;	/* protects notifier_list */
+	struct list_head notifier_list;
+};
+
+struct ccci_fsm_event {
+	struct list_head entry;
+	enum ccci_fsm_event_state event_id;
+	unsigned int length;
+	unsigned char data[];
+};
+
+struct ccci_fsm_command {
+	struct list_head entry;
+	enum ccci_fsm_cmd_state cmd_id;
+	unsigned int flag;
+	enum fsm_cmd_result result;
+	wait_queue_head_t complete_wq;
+};
+
+struct fsm_notifier_block {
+	struct list_head entry;
+	int (*notifier_fn)(enum md_state state, void *data);
+	void *data;
+};
+
+int fsm_append_command(struct ccci_fsm_ctl *ctl, enum ccci_fsm_cmd_state cmd_id,
+		       unsigned int flag);
+int fsm_append_event(struct ccci_fsm_ctl *ctl, enum ccci_fsm_event_state event_id,
+		     unsigned char *data, unsigned int length);
+void fsm_clear_event(struct ccci_fsm_ctl *ctl, enum ccci_fsm_event_state event_id);
+
+struct ccci_fsm_ctl *fsm_get_entity_by_device_number(dev_t dev_n);
+struct ccci_fsm_ctl *fsm_get_entry(void);
+
+void fsm_broadcast_state(struct ccci_fsm_ctl *ctl, enum md_state state);
+void ccci_fsm_reset(void);
+int ccci_fsm_init(struct mtk_modem *md);
+void ccci_fsm_uninit(void);
+void ccci_fsm_recv_md_interrupt(enum md_irq_type type);
+enum md_state ccci_fsm_get_md_state(void);
+unsigned int ccci_fsm_get_current_state(void);
+void fsm_notifier_register(struct fsm_notifier_block *notifier);
+void fsm_notifier_unregister(struct fsm_notifier_block *notifier);
+
+#endif /* __T7XX_MONITOR_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
new file mode 100644
index 000000000000..c16b3a2557f1
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+#include "t7xx_skb_util.h"
+
+#define	PCI_IREG_BASE			0
+#define	PCI_EREG_BASE			2
+
+static int mtk_request_irq(struct pci_dev *pdev)
+{
+	struct mtk_pci_dev *mtk_dev;
+	int ret, i;
+
+	mtk_dev = pci_get_drvdata(pdev);
+
+	for (i = 0; i < EXT_INT_NUM; i++) {
+		const char *irq_descr;
+		int irq_vec;
+
+		if (!mtk_dev->intr_handler[i])
+			continue;
+
+		irq_descr = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_%d", pdev->driver->name, i);
+		if (!irq_descr)
+			return -ENOMEM;
+
+		irq_vec = pci_irq_vector(pdev, i);
+		ret = request_threaded_irq(irq_vec, mtk_dev->intr_handler[i],
+					   mtk_dev->intr_thread[i], 0, irq_descr,
+					   mtk_dev->callback_param[i]);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to request_irq: %d, int: %d, ret: %d\n",
+				irq_vec, i, ret);
+			while (i--) {
+				if (!mtk_dev->intr_handler[i])
+					continue;
+
+				free_irq(pci_irq_vector(pdev, i), mtk_dev->callback_param[i]);
+			}
+
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int mtk_setup_msix(struct mtk_pci_dev *mtk_dev)
+{
+	int ret;
+
+	/* We are interested only in 6 interrupts, but HW-design requires power-of-2
+	 * IRQs allocation.
+	 */
+	ret = pci_alloc_irq_vectors(mtk_dev->pdev, EXT_INT_NUM, EXT_INT_NUM, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(&mtk_dev->pdev->dev, "Failed to allocate MSI-X entry, errno: %d\n", ret);
+		return ret;
+	}
+
+	ret = mtk_request_irq(mtk_dev->pdev);
+	if (ret) {
+		pci_free_irq_vectors(mtk_dev->pdev);
+		return ret;
+	}
+
+	/* Set MSIX merge config */
+	mtk_pcie_mac_msix_cfg(mtk_dev, EXT_INT_NUM);
+	return 0;
+}
+
+static int mtk_interrupt_init(struct mtk_pci_dev *mtk_dev)
+{
+	int ret, i;
+
+	if (!mtk_dev->pdev->msix_cap)
+		return -EINVAL;
+
+	ret = mtk_setup_msix(mtk_dev);
+	if (ret)
+		return ret;
+
+	/* let the IPs enable interrupts when they are ready */
+	for (i = EXT_INT_START; i < EXT_INT_START + EXT_INT_NUM; i++)
+		PCIE_MAC_MSIX_MSK_SET(mtk_dev, i);
+
+	return 0;
+}
+
+static inline void mtk_pci_infracfg_ao_calc(struct mtk_pci_dev *mtk_dev)
+{
+	mtk_dev->base_addr.infracfg_ao_base = mtk_dev->base_addr.pcie_ext_reg_base +
+					      INFRACFG_AO_DEV_CHIP -
+					      mtk_dev->base_addr.pcie_dev_reg_trsl_addr;
+}
+
+static int mtk_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct mtk_pci_dev *mtk_dev;
+	int ret;
+
+	mtk_dev = devm_kzalloc(&pdev->dev, sizeof(*mtk_dev), GFP_KERNEL);
+	if (!mtk_dev)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, mtk_dev);
+	mtk_dev->pdev = pdev;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	ret = pcim_iomap_regions(pdev, BIT(PCI_IREG_BASE) | BIT(PCI_EREG_BASE), pci_name(pdev));
+	if (ret) {
+		dev_err(&pdev->dev, "PCIm iomap regions fail %d\n", ret);
+		return -ENOMEM;
+	}
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (ret) {
+		ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(&pdev->dev, "Could not set PCI DMA mask, err: %d\n", ret);
+			return ret;
+		}
+	}
+
+	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (ret) {
+		ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(&pdev->dev, "Could not set consistent PCI DMA mask, err: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	IREG_BASE(mtk_dev) = pcim_iomap_table(pdev)[PCI_IREG_BASE];
+	mtk_dev->base_addr.pcie_ext_reg_base = pcim_iomap_table(pdev)[PCI_EREG_BASE];
+
+	ret = ccci_skb_pool_alloc(&mtk_dev->pools);
+	if (ret)
+		return ret;
+
+	mtk_pcie_mac_atr_init(mtk_dev);
+	mtk_pci_infracfg_ao_calc(mtk_dev);
+	mhccif_init(mtk_dev);
+
+	ret = mtk_md_init(mtk_dev);
+	if (ret)
+		goto err;
+
+	mtk_pcie_mac_interrupts_dis(mtk_dev);
+	ret = mtk_interrupt_init(mtk_dev);
+	if (ret)
+		goto err;
+
+	mtk_pcie_mac_set_int(mtk_dev, MHCCIF_INT);
+	mtk_pcie_mac_interrupts_en(mtk_dev);
+	pci_set_master(pdev);
+
+	return 0;
+
+err:
+	ccci_skb_pool_free(&mtk_dev->pools);
+	return ret;
+}
+
+static void mtk_pci_remove(struct pci_dev *pdev)
+{
+	struct mtk_pci_dev *mtk_dev;
+	int i;
+
+	mtk_dev = pci_get_drvdata(pdev);
+	mtk_md_exit(mtk_dev);
+
+	for (i = 0; i < EXT_INT_NUM; i++) {
+		if (!mtk_dev->intr_handler[i])
+			continue;
+
+		free_irq(pci_irq_vector(pdev, i), mtk_dev->callback_param[i]);
+	}
+
+	pci_free_irq_vectors(mtk_dev->pdev);
+	ccci_skb_pool_free(&mtk_dev->pools);
+}
+
+static const struct pci_device_id t7xx_pci_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x4d75) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, t7xx_pci_table);
+
+static struct pci_driver mtk_pci_driver = {
+	.name = "mtk_t7xx",
+	.id_table = t7xx_pci_table,
+	.probe = mtk_pci_probe,
+	.remove = mtk_pci_remove,
+};
+
+static int __init mtk_pci_init(void)
+{
+	return pci_register_driver(&mtk_pci_driver);
+}
+module_init(mtk_pci_init);
+
+static void __exit mtk_pci_cleanup(void)
+{
+	pci_unregister_driver(&mtk_pci_driver);
+}
+module_exit(mtk_pci_cleanup);
+
+MODULE_AUTHOR("MediaTek Inc");
+MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem t7xx driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
new file mode 100644
index 000000000000..fc27c8c9bf12
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_PCI_H__
+#define __T7XX_PCI_H__
+
+#include <linux/pci.h>
+#include <linux/types.h>
+
+#include "t7xx_reg.h"
+#include "t7xx_skb_util.h"
+
+/* struct mtk_addr_base - holds base addresses
+ * @pcie_mac_ireg_base: PCIe MAC register base
+ * @pcie_ext_reg_base: used to calculate base addresses for CLDMA, DPMA and MHCCIF registers
+ * @pcie_dev_reg_trsl_addr: used to calculate the register base address
+ * @infracfg_ao_base: base address used in CLDMA reset operations
+ * @mhccif_rc_base: host view of MHCCIF rc base addr
+ */
+struct mtk_addr_base {
+	void __iomem *pcie_mac_ireg_base;
+	void __iomem *pcie_ext_reg_base;
+	u32 pcie_dev_reg_trsl_addr;
+	void __iomem *infracfg_ao_base;
+	void __iomem *mhccif_rc_base;
+};
+
+typedef irqreturn_t (*mtk_intr_callback)(int irq, void *param);
+
+/* struct mtk_pci_dev - MTK device context structure
+ * @intr_handler: array of handler function for request_threaded_irq
+ * @intr_thread: array of thread_fn for request_threaded_irq
+ * @callback_param: array of cookie passed back to interrupt functions
+ * @mhccif_bitmask: device to host interrupt mask
+ * @pdev: pci device
+ * @base_addr: memory base addresses of HW components
+ * @md: modem interface
+ * @ccmni_ctlb: context structure used to control the network data path
+ * @rgu_pci_irq_en: RGU callback isr registered and active
+ * @pools: pre allocated skb pools
+ */
+struct mtk_pci_dev {
+	mtk_intr_callback	intr_handler[EXT_INT_NUM];
+	mtk_intr_callback	intr_thread[EXT_INT_NUM];
+	void			*callback_param[EXT_INT_NUM];
+	u32			mhccif_bitmask;
+	struct pci_dev		*pdev;
+	struct mtk_addr_base	base_addr;
+	struct mtk_modem	*md;
+
+	struct ccmni_ctl_block	*ccmni_ctlb;
+	bool			rgu_pci_irq_en;
+	struct skb_pools	pools;
+};
+
+#endif /* __T7XX_PCI_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_pcie_mac.c b/drivers/net/wwan/t7xx/t7xx_pcie_mac.c
new file mode 100644
index 000000000000..9e512010245d
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pcie_mac.c
@@ -0,0 +1,270 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/msi.h>
+
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+
+#define PCIE_REG_BAR			2
+#define PCIE_REG_PORT			ATR_SRC_PCI_WIN0
+#define PCIE_REG_TABLE_NUM		0
+#define PCIE_REG_TRSL_PORT		ATR_DST_AXIM_0
+
+#define PCIE_DEV_DMA_PORT_START		ATR_SRC_AXIS_0
+#define PCIE_DEV_DMA_PORT_END		ATR_SRC_AXIS_2
+#define PCIE_DEV_DMA_TABLE_NUM		0
+#define PCIE_DEV_DMA_TRSL_ADDR		0x00000000
+#define PCIE_DEV_DMA_SRC_ADDR		0x00000000
+#define PCIE_DEV_DMA_TRANSPARENT	1
+#define PCIE_DEV_DMA_SIZE		0
+
+enum mtk_atr_src_port {
+	ATR_SRC_PCI_WIN0,
+	ATR_SRC_PCI_WIN1,
+	ATR_SRC_AXIS_0,
+	ATR_SRC_AXIS_1,
+	ATR_SRC_AXIS_2,
+	ATR_SRC_AXIS_3,
+};
+
+enum mtk_atr_dst_port {
+	ATR_DST_PCI_TRX,
+	ATR_DST_PCI_CONFIG,
+	ATR_DST_AXIM_0 = 4,
+	ATR_DST_AXIM_1,
+	ATR_DST_AXIM_2,
+	ATR_DST_AXIM_3,
+};
+
+struct mtk_atr_config {
+	u64			src_addr;
+	u64			trsl_addr;
+	u64			size;
+	u32			port;
+	u32			table;
+	enum mtk_atr_dst_port	trsl_id;
+	u32			transparent;
+};
+
+static void mtk_pcie_mac_atr_tables_dis(void __iomem *pbase, enum mtk_atr_src_port port)
+{
+	void __iomem *reg;
+	int i, offset;
+
+	for (i = 0; i < ATR_TABLE_NUM_PER_ATR; i++) {
+		offset = (ATR_PORT_OFFSET * port) + (ATR_TABLE_OFFSET * i);
+
+		/* Disable table by SRC_ADDR */
+		reg = pbase + ATR_PCIE_WIN0_T0_ATR_PARAM_SRC_ADDR + offset;
+		iowrite64(0, reg);
+	}
+}
+
+static int mtk_pcie_mac_atr_cfg(struct mtk_pci_dev *mtk_dev, struct mtk_atr_config *cfg)
+{
+	int atr_size, pos, offset;
+	void __iomem *pbase;
+	struct device *dev;
+	void __iomem *reg;
+	u64 value;
+
+	dev = &mtk_dev->pdev->dev;
+	pbase = IREG_BASE(mtk_dev);
+
+	if (cfg->transparent) {
+		/* No address conversion is performed */
+		atr_size = ATR_TRANSPARENT_SIZE;
+	} else {
+		if (cfg->src_addr & (cfg->size - 1)) {
+			dev_err(dev, "src addr is not aligned to size\n");
+			return -EINVAL;
+		}
+
+		if (cfg->trsl_addr & (cfg->size - 1)) {
+			dev_err(dev, "trsl addr %llx not aligned to size %llx\n",
+				cfg->trsl_addr, cfg->size - 1);
+			return -EINVAL;
+		}
+
+		pos = ffs(lower_32_bits(cfg->size));
+		if (!pos)
+			pos = ffs(upper_32_bits(cfg->size)) + 32;
+
+		/* The HW calculates the address translation space as 2^(atr_size + 1)
+		 * but we also need to consider that ffs() starts counting from 1.
+		 */
+		atr_size = pos - 2;
+	}
+
+	/* Calculate table offset */
+	offset = ATR_PORT_OFFSET * cfg->port + ATR_TABLE_OFFSET * cfg->table;
+
+	reg = pbase + ATR_PCIE_WIN0_T0_TRSL_ADDR + offset;
+	value = cfg->trsl_addr & ATR_PCIE_WIN0_ADDR_ALGMT;
+	iowrite64(value, reg);
+
+	reg = pbase + ATR_PCIE_WIN0_T0_TRSL_PARAM + offset;
+	iowrite32(cfg->trsl_id, reg);
+
+	reg = pbase + ATR_PCIE_WIN0_T0_ATR_PARAM_SRC_ADDR + offset;
+	value = (cfg->src_addr & ATR_PCIE_WIN0_ADDR_ALGMT) | (atr_size << 1) | BIT(0);
+	iowrite64(value, reg);
+
+	/* Read back to ensure ATR is set */
+	ioread64(reg);
+	return 0;
+}
+
+/**
+ * mtk_pcie_mac_atr_init() - initialize address translation
+ * @mtk_dev: MTK device
+ *
+ * Setup ATR for ports & device.
+ *
+ */
+void mtk_pcie_mac_atr_init(struct mtk_pci_dev *mtk_dev)
+{
+	struct mtk_atr_config cfg;
+	u32 i;
+
+	/* Disable all ATR table for all ports */
+	for (i = ATR_SRC_PCI_WIN0; i <= ATR_SRC_AXIS_3; i++)
+		mtk_pcie_mac_atr_tables_dis(IREG_BASE(mtk_dev), i);
+
+	memset(&cfg, 0, sizeof(cfg));
+	/* Config ATR for RC to access device's register */
+	cfg.src_addr = pci_resource_start(mtk_dev->pdev, PCIE_REG_BAR);
+	cfg.size = PCIE_REG_SIZE_CHIP;
+	cfg.trsl_addr = PCIE_REG_TRSL_ADDR_CHIP;
+	cfg.port = PCIE_REG_PORT;
+	cfg.table = PCIE_REG_TABLE_NUM;
+	cfg.trsl_id = PCIE_REG_TRSL_PORT;
+	mtk_pcie_mac_atr_tables_dis(IREG_BASE(mtk_dev), cfg.port);
+	mtk_pcie_mac_atr_cfg(mtk_dev, &cfg);
+
+	/* Update translation base */
+	mtk_dev->base_addr.pcie_dev_reg_trsl_addr = PCIE_REG_TRSL_ADDR_CHIP;
+
+	/* Config ATR for EP to access RC's memory */
+	for (i = PCIE_DEV_DMA_PORT_START; i <= PCIE_DEV_DMA_PORT_END; i++) {
+		cfg.src_addr = PCIE_DEV_DMA_SRC_ADDR;
+		cfg.size = PCIE_DEV_DMA_SIZE;
+		cfg.trsl_addr = PCIE_DEV_DMA_TRSL_ADDR;
+		cfg.port = i;
+		cfg.table = PCIE_DEV_DMA_TABLE_NUM;
+		cfg.trsl_id = ATR_DST_PCI_TRX;
+		/* Enable transparent translation */
+		cfg.transparent = PCIE_DEV_DMA_TRANSPARENT;
+		mtk_pcie_mac_atr_tables_dis(IREG_BASE(mtk_dev), cfg.port);
+		mtk_pcie_mac_atr_cfg(mtk_dev, &cfg);
+	}
+}
+
+/**
+ * mtk_pcie_mac_enable_disable_int() - enable/disable interrupts
+ * @mtk_dev: MTK device
+ * @enable: enable/disable
+ *
+ * Enable or disable device interrupts.
+ *
+ */
+static void mtk_pcie_mac_enable_disable_int(struct mtk_pci_dev *mtk_dev, bool enable)
+{
+	u32 value;
+
+	value = ioread32(IREG_BASE(mtk_dev) + ISTAT_HST_CTRL);
+	if (enable)
+		value &= ~ISTAT_HST_CTRL_DIS;
+	else
+		value |= ISTAT_HST_CTRL_DIS;
+
+	iowrite32(value, IREG_BASE(mtk_dev) + ISTAT_HST_CTRL);
+}
+
+void mtk_pcie_mac_interrupts_en(struct mtk_pci_dev *mtk_dev)
+{
+	mtk_pcie_mac_enable_disable_int(mtk_dev, true);
+}
+
+void mtk_pcie_mac_interrupts_dis(struct mtk_pci_dev *mtk_dev)
+{
+	mtk_pcie_mac_enable_disable_int(mtk_dev, false);
+}
+
+/**
+ * mtk_pcie_mac_clear_set_int() - clear/set interrupt by type
+ * @mtk_dev: MTK device
+ * @int_type: interrupt type
+ * @clear: clear/set
+ *
+ * Clear or set device interrupt by type.
+ *
+ */
+static void mtk_pcie_mac_clear_set_int(struct mtk_pci_dev *mtk_dev,
+				       enum pcie_int int_type, bool clear)
+{
+	void __iomem *reg;
+
+	if (mtk_dev->pdev->msix_enabled) {
+		if (clear)
+			reg = IREG_BASE(mtk_dev) + IMASK_HOST_MSIX_CLR_GRP0_0;
+		else
+			reg = IREG_BASE(mtk_dev) + IMASK_HOST_MSIX_SET_GRP0_0;
+	} else {
+		if (clear)
+			reg = IREG_BASE(mtk_dev) + INT_EN_HST_CLR;
+		else
+			reg = IREG_BASE(mtk_dev) + INT_EN_HST_SET;
+	}
+
+	iowrite32(BIT(EXT_INT_START + int_type), reg);
+}
+
+void mtk_pcie_mac_clear_int(struct mtk_pci_dev *mtk_dev, enum pcie_int int_type)
+{
+	mtk_pcie_mac_clear_set_int(mtk_dev, int_type, true);
+}
+
+void mtk_pcie_mac_set_int(struct mtk_pci_dev *mtk_dev, enum pcie_int int_type)
+{
+	mtk_pcie_mac_clear_set_int(mtk_dev, int_type, false);
+}
+
+/**
+ * mtk_pcie_mac_clear_int_status() - clear interrupt status by type
+ * @mtk_dev: MTK device
+ * @int_type: interrupt type
+ *
+ * Enable or disable device interrupts' status by type.
+ *
+ */
+void mtk_pcie_mac_clear_int_status(struct mtk_pci_dev *mtk_dev, enum pcie_int int_type)
+{
+	void __iomem *reg;
+
+	if (mtk_dev->pdev->msix_enabled)
+		reg = IREG_BASE(mtk_dev) + MSIX_ISTAT_HST_GRP0_0;
+	else
+		reg = IREG_BASE(mtk_dev) + ISTAT_HST;
+
+	iowrite32(BIT(EXT_INT_START + int_type), reg);
+}
+
+/**
+ * mtk_pcie_mac_msix_cfg() - write MSIX control configuration
+ * @mtk_dev: MTK device
+ * @irq_count: number of MSIX IRQ vectors
+ *
+ * Write IRQ count to device.
+ *
+ */
+void mtk_pcie_mac_msix_cfg(struct mtk_pci_dev *mtk_dev, unsigned int irq_count)
+{
+	iowrite32(ffs(irq_count) * 2 - 1, IREG_BASE(mtk_dev) + PCIE_CFG_MSIX);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_pcie_mac.h b/drivers/net/wwan/t7xx/t7xx_pcie_mac.h
new file mode 100644
index 000000000000..bba0998179ae
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pcie_mac.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_PCIE_MAC_H__
+#define __T7XX_PCIE_MAC_H__
+
+#include <linux/bitops.h>
+#include <linux/io.h>
+
+#include "t7xx_pci.h"
+#include "t7xx_reg.h"
+
+#define IREG_BASE(mtk_dev)	((mtk_dev)->base_addr.pcie_mac_ireg_base)
+
+#define PCIE_MAC_MSIX_MSK_SET(mtk_dev, ext_id)	\
+	iowrite32(BIT(ext_id), IREG_BASE(mtk_dev) + IMASK_HOST_MSIX_SET_GRP0_0)
+
+void mtk_pcie_mac_interrupts_en(struct mtk_pci_dev *mtk_dev);
+void mtk_pcie_mac_interrupts_dis(struct mtk_pci_dev *mtk_dev);
+void mtk_pcie_mac_atr_init(struct mtk_pci_dev *mtk_dev);
+void mtk_pcie_mac_clear_int(struct mtk_pci_dev *mtk_dev, enum pcie_int int_type);
+void mtk_pcie_mac_set_int(struct mtk_pci_dev *mtk_dev, enum pcie_int int_type);
+void mtk_pcie_mac_clear_int_status(struct mtk_pci_dev *mtk_dev, enum pcie_int int_type);
+void mtk_pcie_mac_msix_cfg(struct mtk_pci_dev *mtk_dev, unsigned int irq_count);
+
+#endif /* __T7XX_PCIE_MAC_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
new file mode 100644
index 000000000000..8e4b5507a3c8
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_reg.h
@@ -0,0 +1,389 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_REG_H__
+#define __T7XX_REG_H__
+
+#include <linux/bits.h>
+
+/* RC part */
+
+/* Device base address offset - update if reg BAR base is changed */
+#define MHCCIF_RC_DEV_BASE			0x10024000
+
+#define REG_RC2EP_SW_BSY			0x04
+#define REG_RC2EP_SW_INT_START			0x08
+
+#define REG_RC2EP_SW_TCHNUM			0x0c
+#define H2D_CH_EXCEPTION_ACK			1
+#define H2D_CH_EXCEPTION_CLEARQ_ACK		2
+#define H2D_CH_DS_LOCK				3
+/* Channels 4-8 are reserved */
+#define H2D_CH_SUSPEND_REQ			9
+#define H2D_CH_RESUME_REQ			10
+#define H2D_CH_SUSPEND_REQ_AP			11
+#define H2D_CH_RESUME_REQ_AP			12
+#define H2D_CH_DEVICE_RESET			13
+#define H2D_CH_DRM_DISABLE_AP			14
+
+#define REG_EP2RC_SW_INT_STS			0x10
+#define REG_EP2RC_SW_INT_ACK			0x14
+#define REG_EP2RC_SW_INT_EAP_MASK		0x20
+#define REG_EP2RC_SW_INT_EAP_MASK_SET		0x30
+#define REG_EP2RC_SW_INT_EAP_MASK_CLR		0x40
+
+#define D2H_INT_DS_LOCK_ACK			BIT(0)
+#define D2H_INT_EXCEPTION_INIT			BIT(1)
+#define D2H_INT_EXCEPTION_INIT_DONE		BIT(2)
+#define D2H_INT_EXCEPTION_CLEARQ_DONE		BIT(3)
+#define D2H_INT_EXCEPTION_ALLQ_RESET		BIT(4)
+#define D2H_INT_PORT_ENUM			BIT(5)
+/* bits 6-10 are reserved */
+#define D2H_INT_SUSPEND_ACK			BIT(11)
+#define D2H_INT_RESUME_ACK			BIT(12)
+#define D2H_INT_SUSPEND_ACK_AP			BIT(13)
+#define D2H_INT_RESUME_ACK_AP			BIT(14)
+#define D2H_INT_ASYNC_SAP_HK			BIT(15)
+#define D2H_INT_ASYNC_MD_HK			BIT(16)
+
+/* EP part */
+
+/* Device base address offset */
+#define MHCCIF_EP_DEV_BASE			0x10025000
+
+/* Reg base */
+#define INFRACFG_AO_DEV_CHIP			0x10001000
+
+/* ATR setting */
+#define PCIE_REG_TRSL_ADDR_CHIP			0x10000000
+#define PCIE_REG_SIZE_CHIP			0x00400000
+
+/* RGU */
+#define TOPRGU_CH_PCIE_IRQ_STA			0x1000790c
+
+#define EXP_BAR0				0x0c
+#define EXP_BAR2				0x04
+#define EXP_BAR4				0x0c
+#define EXP_BAR0_SIZE				0x00008000
+#define EXP_BAR2_SIZE				0x00800000
+#define EXP_BAR4_SIZE				0x00800000
+
+#define ATR_PORT_OFFSET				0x100
+#define ATR_TABLE_OFFSET			0x20
+#define ATR_TABLE_NUM_PER_ATR			8
+#define ATR_TRANSPARENT_SIZE			0x3f
+
+/* PCIE_MAC_IREG Register Definition */
+
+#define INT_EN_HST				0x0188
+#define ISTAT_HST				0x018c
+
+#define ISTAT_HST_CTRL				0x01ac
+#define ISTAT_HST_CTRL_DIS			BIT(0)
+
+#define INT_EN_HST_SET				0x01f0
+#define INT_EN_HST_CLR				0x01f4
+
+#define PCIE_MISC_CTRL				0x0348
+#define PCIE_MISC_MAC_SLEEP_DIS			BIT(7)
+
+#define PCIE_CFG_MSIX				0x03ec
+#define ATR_PCIE_WIN0_T0_ATR_PARAM_SRC_ADDR	0x0600
+#define ATR_PCIE_WIN0_T0_TRSL_ADDR		0x0608
+#define ATR_PCIE_WIN0_T0_TRSL_PARAM		0x0610
+#define ATR_PCIE_WIN0_ADDR_ALGMT		GENMASK_ULL(63, 12)
+
+#define ATR_SRC_ADDR_INVALID			0x007f
+
+#define PCIE_PM_RESUME_STATE			0x0d0c
+enum mtk_pm_resume_state {
+	PM_RESUME_REG_STATE_L3,
+	PM_RESUME_REG_STATE_L1,
+	PM_RESUME_REG_STATE_INIT,
+	PM_RESUME_REG_STATE_EXP,
+	PM_RESUME_REG_STATE_L2,
+	PM_RESUME_REG_STATE_L2_EXP,
+};
+
+#define PCIE_MISC_DEV_STATUS			0x0d1c
+#define MISC_STAGE_MASK				GENMASK(2, 0)
+#define MISC_RESET_TYPE_PLDR			BIT(26)
+#define MISC_RESET_TYPE_FLDR			BIT(27)
+#define LINUX_STAGE				4
+
+#define PCIE_RESOURCE_STATUS			0x0d28
+#define PCIE_RESOURCE_STATUS_MSK		GENMASK(4, 0)
+
+#define DIS_ASPM_LOWPWR_SET_0			0x0e50
+#define DIS_ASPM_LOWPWR_CLR_0			0x0e54
+#define DIS_ASPM_LOWPWR_SET_1			0x0e58
+#define DIS_ASPM_LOWPWR_CLR_1			0x0e5c
+#define L1_DISABLE_BIT(i)			BIT((i) * 4 + 1)
+#define L1_1_DISABLE_BIT(i)			BIT((i) * 4 + 2)
+#define L1_2_DISABLE_BIT(i)			BIT((i) * 4 + 3)
+
+#define MSIX_SW_TRIG_SET_GRP0_0			0x0e80
+#define MSIX_ISTAT_HST_GRP0_0			0x0f00
+#define IMASK_HOST_MSIX_SET_GRP0_0		0x3000
+#define IMASK_HOST_MSIX_CLR_GRP0_0		0x3080
+#define IMASK_HOST_MSIX_GRP0_0			0x3100
+#define EXT_INT_START				24
+#define EXT_INT_NUM				8
+#define MSIX_MSK_SET_ALL			GENMASK(31, 24)
+enum pcie_int {
+	DPMAIF_INT = 0,
+	CLDMA0_INT,
+	CLDMA1_INT,
+	CLDMA2_INT,
+	MHCCIF_INT,
+	DPMAIF2_INT,
+	SAP_RGU_INT,
+	CLDMA3_INT,
+};
+
+/* DPMA definitions */
+
+#define DPMAIF_PD_BASE				0x1022d000
+#define BASE_DPMAIF_UL				DPMAIF_PD_BASE
+#define BASE_DPMAIF_DL				(DPMAIF_PD_BASE + 0x100)
+#define BASE_DPMAIF_AP_MISC			(DPMAIF_PD_BASE + 0x400)
+#define BASE_DPMAIF_MMW_HPC			(DPMAIF_PD_BASE + 0x600)
+#define BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX		(DPMAIF_PD_BASE + 0x900)
+#define BASE_DPMAIF_PD_SRAM_DL			(DPMAIF_PD_BASE + 0xc00)
+#define BASE_DPMAIF_PD_SRAM_UL			(DPMAIF_PD_BASE + 0xd00)
+
+#define DPMAIF_AO_BASE				0x10014000
+#define BASE_DPMAIF_AO_UL			DPMAIF_AO_BASE
+#define BASE_DPMAIF_AO_DL			(DPMAIF_AO_BASE + 0x400)
+
+/* dpmaif_ul */
+#define DPMAIF_UL_ADD_DESC			(BASE_DPMAIF_UL + 0x00)
+#define DPMAIF_UL_CHK_BUSY			(BASE_DPMAIF_UL + 0x88)
+#define DPMAIF_UL_RESERVE_AO_RW			(BASE_DPMAIF_UL + 0xac)
+#define DPMAIF_UL_ADD_DESC_CH0			(BASE_DPMAIF_UL + 0xb0)
+
+/* dpmaif_dl */
+#define DPMAIF_DL_BAT_INIT			(BASE_DPMAIF_DL + 0x00)
+#define DPMAIF_DL_BAT_ADD			(BASE_DPMAIF_DL + 0x04)
+#define DPMAIF_DL_BAT_INIT_CON0			(BASE_DPMAIF_DL + 0x08)
+#define DPMAIF_DL_BAT_INIT_CON1			(BASE_DPMAIF_DL + 0x0c)
+#define DPMAIF_DL_BAT_INIT_CON2			(BASE_DPMAIF_DL + 0x10)
+#define DPMAIF_DL_BAT_INIT_CON3			(BASE_DPMAIF_DL + 0x50)
+#define DPMAIF_DL_CHK_BUSY			(BASE_DPMAIF_DL + 0xb4)
+
+/* dpmaif_ap_misc */
+#define DPMAIF_AP_L2TISAR0			(BASE_DPMAIF_AP_MISC + 0x00)
+#define DPMAIF_AP_APDL_L2TISAR0			(BASE_DPMAIF_AP_MISC + 0x50)
+#define DPMAIF_AP_IP_BUSY			(BASE_DPMAIF_AP_MISC + 0x60)
+#define DPMAIF_AP_CG_EN				(BASE_DPMAIF_AP_MISC + 0x68)
+#define DPMAIF_AP_OVERWRITE_CFG			(BASE_DPMAIF_AP_MISC + 0x90)
+#define DPMAIF_AP_MEM_CLR			(BASE_DPMAIF_AP_MISC + 0x94)
+#define DPMAIF_AP_ALL_L2TISAR0_MASK		GENMASK(31, 0)
+#define DPMAIF_AP_APDL_ALL_L2TISAR0_MASK	GENMASK(31, 0)
+#define DPMAIF_AP_IP_BUSY_MASK			GENMASK(31, 0)
+
+/* dpmaif_ao_ul */
+#define DPMAIF_AO_UL_INIT_SET			(BASE_DPMAIF_AO_UL + 0x0)
+#define DPMAIF_AO_UL_CHNL_ARB0			(BASE_DPMAIF_AO_UL + 0x1c)
+#define DPMAIF_AO_UL_AP_L2TIMR0			(BASE_DPMAIF_AO_UL + 0x80)
+#define DPMAIF_AO_UL_AP_L2TIMCR0		(BASE_DPMAIF_AO_UL + 0x84)
+#define DPMAIF_AO_UL_AP_L2TIMSR0		(BASE_DPMAIF_AO_UL + 0x88)
+#define DPMAIF_AO_UL_AP_L1TIMR0			(BASE_DPMAIF_AO_UL + 0x8c)
+#define DPMAIF_AO_UL_APDL_L2TIMR0		(BASE_DPMAIF_AO_UL + 0x90)
+#define DPMAIF_AO_UL_APDL_L2TIMCR0		(BASE_DPMAIF_AO_UL + 0x94)
+#define DPMAIF_AO_UL_APDL_L2TIMSR0		(BASE_DPMAIF_AO_UL + 0x98)
+#define DPMAIF_AO_AP_DLUL_IP_BUSY_MASK		(BASE_DPMAIF_AO_UL + 0x9c)
+
+/* dpmaif_pd_sram_ul */
+#define DPMAIF_AO_UL_CHNL0_CON0			(BASE_DPMAIF_PD_SRAM_UL + 0x10)
+#define DPMAIF_AO_UL_CHNL0_CON1			(BASE_DPMAIF_PD_SRAM_UL + 0x14)
+#define DPMAIF_AO_UL_CHNL0_CON2			(BASE_DPMAIF_PD_SRAM_UL + 0x18)
+#define DPMAIF_AO_UL_CH0_STA			(BASE_DPMAIF_PD_SRAM_UL + 0x70)
+
+/* dpmaif_ao_dl */
+#define DPMAIF_AO_DL_INIT_SET			(BASE_DPMAIF_AO_DL + 0x00)
+#define DPMAIF_AO_DL_IRQ_MASK			(BASE_DPMAIF_AO_DL + 0x0c)
+#define DPMAIF_AO_DL_DLQPIT_INIT_CON5		(BASE_DPMAIF_AO_DL + 0x28)
+#define DPMAIF_AO_DL_DLQPIT_TRIG_THRES		(BASE_DPMAIF_AO_DL + 0x34)
+
+/* dpmaif_pd_sram_dl */
+#define DPMAIF_AO_DL_PKTINFO_CON0		(BASE_DPMAIF_PD_SRAM_DL + 0x00)
+#define DPMAIF_AO_DL_PKTINFO_CON1		(BASE_DPMAIF_PD_SRAM_DL + 0x04)
+#define DPMAIF_AO_DL_PKTINFO_CON2		(BASE_DPMAIF_PD_SRAM_DL + 0x08)
+#define DPMAIF_AO_DL_RDY_CHK_THRES		(BASE_DPMAIF_PD_SRAM_DL + 0x0c)
+#define DPMAIF_AO_DL_RDY_CHK_FRG_THRES		(BASE_DPMAIF_PD_SRAM_DL + 0x10)
+
+#define DPMAIF_AO_DL_DLQ_AGG_CFG		(BASE_DPMAIF_PD_SRAM_DL + 0x20)
+#define DPMAIF_AO_DL_DLQPIT_TIMEOUT0		(BASE_DPMAIF_PD_SRAM_DL + 0x24)
+#define DPMAIF_AO_DL_DLQPIT_TIMEOUT1		(BASE_DPMAIF_PD_SRAM_DL + 0x28)
+#define DPMAIF_AO_DL_HPC_CNTL			(BASE_DPMAIF_PD_SRAM_DL + 0x38)
+#define DPMAIF_AO_DL_PIT_SEQ_END		(BASE_DPMAIF_PD_SRAM_DL + 0x40)
+
+#define DPMAIF_AO_DL_BAT_RIDX			(BASE_DPMAIF_PD_SRAM_DL + 0xd8)
+#define DPMAIF_AO_DL_BAT_WRIDX			(BASE_DPMAIF_PD_SRAM_DL + 0xdc)
+#define DPMAIF_AO_DL_PIT_RIDX			(BASE_DPMAIF_PD_SRAM_DL + 0xec)
+#define DPMAIF_AO_DL_PIT_WRIDX			(BASE_DPMAIF_PD_SRAM_DL + 0x60)
+#define DPMAIF_AO_DL_FRGBAT_WRIDX		(BASE_DPMAIF_PD_SRAM_DL + 0x78)
+#define DPMAIF_AO_DL_DLQ_WRIDX			(BASE_DPMAIF_PD_SRAM_DL + 0xa4)
+
+/* dpmaif_hpc */
+#define DPMAIF_HPC_INTR_MASK			(BASE_DPMAIF_MMW_HPC + 0x0f4)
+#define DPMA_HPC_ALL_INT_MASK			GENMASK(15, 0)
+
+#define DPMAIF_HPC_DLQ_PATH_MODE		3
+#define DPMAIF_HPC_ADD_MODE_DF			0
+#define DPMAIF_HPC_TOTAL_NUM			8
+#define DPMAIF_HPC_MAX_TOTAL_NUM		8
+
+/* dpmaif_dlq */
+#define DPMAIF_DL_DLQPIT_INIT			(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x00)
+#define DPMAIF_DL_DLQPIT_ADD			(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x10)
+#define DPMAIF_DL_DLQPIT_INIT_CON0		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x14)
+#define DPMAIF_DL_DLQPIT_INIT_CON1		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x18)
+#define DPMAIF_DL_DLQPIT_INIT_CON2		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x1c)
+#define DPMAIF_DL_DLQPIT_INIT_CON3		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x20)
+#define DPMAIF_DL_DLQPIT_INIT_CON4		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x24)
+#define DPMAIF_DL_DLQPIT_INIT_CON5		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x28)
+#define DPMAIF_DL_DLQPIT_INIT_CON6		(BASE_DPMAIF_DL_DLQ_REMOVEAO_IDX + 0x2c)
+
+/* common include function */
+#define DPMAIF_ULQSAR_n(q)			(DPMAIF_AO_UL_CHNL0_CON0 + 0x10 * (q))
+#define DPMAIF_UL_DRBSIZE_ADDRH_n(q)		(DPMAIF_AO_UL_CHNL0_CON1 + 0x10 * (q))
+#define DPMAIF_UL_DRB_ADDRH_n(q)		(DPMAIF_AO_UL_CHNL0_CON2 + 0x10 * (q))
+#define DPMAIF_ULQ_STA0_n(q)			(DPMAIF_AO_UL_CH0_STA + 0x04 * (q))
+#define DPMAIF_ULQ_ADD_DESC_CH_n(q)		(DPMAIF_UL_ADD_DESC_CH0 + 0x04 * (q))
+
+#define DPMAIF_UL_DRB_RIDX_OFFSET		16
+
+#define DPMAIF_AP_RGU_ASSERT			0x10001150
+#define DPMAIF_AP_RGU_DEASSERT			0x10001154
+#define DPMAIF_AP_RST_BIT			BIT(2)
+
+#define DPMAIF_AP_AO_RGU_ASSERT			0x10001140
+#define DPMAIF_AP_AO_RGU_DEASSERT		0x10001144
+#define DPMAIF_AP_AO_RST_BIT			BIT(6)
+
+/* DPMAIF init/restore */
+#define DPMAIF_UL_ADD_NOT_READY			BIT(31)
+#define DPMAIF_UL_ADD_UPDATE			BIT(31)
+#define DPMAIF_UL_ADD_COUNT_MASK		GENMASK(15, 0)
+#define DPMAIF_UL_ALL_QUE_ARB_EN		GENMASK(11, 8)
+
+#define DPMAIF_DL_ADD_UPDATE			BIT(31)
+#define DPMAIF_DL_ADD_NOT_READY			BIT(31)
+#define DPMAIF_DL_FRG_ADD_UPDATE		BIT(16)
+#define DPMAIF_DL_ADD_COUNT_MASK		GENMASK(15, 0)
+
+#define DPMAIF_DL_BAT_INIT_ALLSET		BIT(0)
+#define DPMAIF_DL_BAT_FRG_INIT			BIT(16)
+#define DPMAIF_DL_BAT_INIT_EN			BIT(31)
+#define DPMAIF_DL_BAT_INIT_NOT_READY		BIT(31)
+#define DPMAIF_DL_BAT_INIT_ONLY_ENABLE_BIT	0
+
+#define DPMAIF_DL_PIT_INIT_ALLSET		BIT(0)
+#define DPMAIF_DL_PIT_INIT_EN			BIT(31)
+#define DPMAIF_DL_PIT_INIT_NOT_READY		BIT(31)
+
+#define DPMAIF_PKT_ALIGN64_MODE			0
+#define DPMAIF_PKT_ALIGN128_MODE		1
+
+#define DPMAIF_BAT_REMAIN_SZ_BASE		16
+#define DPMAIF_BAT_BUFFER_SZ_BASE		128
+#define DPMAIF_FRG_BUFFER_SZ_BASE		128
+
+#define DLQ_PIT_IDX_SIZE			0x20
+
+#define DPMAIF_PIT_SIZE_MSK			GENMASK(17, 0)
+
+#define DPMAIF_PIT_REM_CNT_MSK			GENMASK(17, 0)
+
+#define DPMAIF_BAT_EN_MSK			BIT(16)
+#define DPMAIF_FRG_EN_MSK			BIT(28)
+#define DPMAIF_BAT_SIZE_MSK			GENMASK(15, 0)
+
+#define DPMAIF_BAT_BID_MAXCNT_MSK		GENMASK(31, 16)
+#define DPMAIF_BAT_REMAIN_MINSZ_MSK		GENMASK(15, 8)
+#define DPMAIF_PIT_CHK_NUM_MSK			GENMASK(31, 24)
+#define DPMAIF_BAT_BUF_SZ_MSK			GENMASK(16, 8)
+#define DPMAIF_FRG_BUF_SZ_MSK			GENMASK(16, 8)
+#define DPMAIF_BAT_RSV_LEN_MSK			GENMASK(7, 0)
+#define DPMAIF_PKT_ALIGN_MSK			GENMASK(23, 22)
+
+#define DPMAIF_BAT_CHECK_THRES_MSK		GENMASK(21, 16)
+#define DPMAIF_FRG_CHECK_THRES_MSK		GENMASK(7, 0)
+
+#define DPMAIF_PKT_ALIGN_EN			BIT(23)
+
+#define DPMAIF_DRB_SIZE_MSK			GENMASK(15, 0)
+
+#define DPMAIF_DL_PIT_WRIDX_MSK			GENMASK(17, 0)
+#define DPMAIF_DL_BAT_WRIDX_MSK			GENMASK(17, 0)
+#define DPMAIF_DL_FRG_WRIDX_MSK			GENMASK(17, 0)
+
+/* Bit fields of registers */
+/* DPMAIF_UL_CHK_BUSY */
+#define DPMAIF_UL_IDLE_STS			BIT(11)
+/* DPMAIF_DL_CHK_BUSY */
+#define DPMAIF_DL_IDLE_STS			BIT(23)
+/* DPMAIF_AO_DL_RDY_CHK_THRES */
+#define DPMAIF_DL_PKT_CHECKSUM_EN		BIT(31)
+#define DPMAIF_PORT_MODE_PCIE			BIT(30)
+#define DPMAIF_DL_BURST_PIT_EN			BIT(13)
+/* DPMAIF_DL_BAT_INIT_CON1 */
+#define DPMAIF_DL_BAT_CACHE_PRI			BIT(22)
+/* DPMAIF_AP_MEM_CLR */
+#define DPMAIF_MEM_CLR				BIT(0)
+/* DPMAIF_AP_OVERWRITE_CFG */
+#define DPMAIF_SRAM_SYNC			BIT(0)
+/* DPMAIF_AO_UL_INIT_SET */
+#define DPMAIF_UL_INIT_DONE			BIT(0)
+/* DPMAIF_AO_DL_INIT_SET */
+#define DPMAIF_DL_INIT_DONE			BIT(0)
+/* DPMAIF_AO_DL_PIT_SEQ_END */
+#define DPMAIF_DL_PIT_SEQ_MSK			GENMASK(7, 0)
+/* DPMAIF_UL_RESERVE_AO_RW */
+#define DPMAIF_PCIE_MODE_SET_VALUE		0x55
+/* DPMAIF_AP_CG_EN */
+#define DPMAIF_CG_EN				0x7f
+
+/* DPMAIF interrupt */
+#define _UL_INT_DONE_OFFSET			0
+#define _UL_INT_EMPTY_OFFSET			4
+#define _UL_INT_MD_NOTRDY_OFFSET		8
+#define _UL_INT_PWR_NOTRDY_OFFSET		12
+#define _UL_INT_LEN_ERR_OFFSET			16
+
+#define DPMAIF_DL_INT_BATCNT_LEN_ERR		BIT(2)
+#define DPMAIF_DL_INT_PITCNT_LEN_ERR		BIT(3)
+
+#define DPMAIF_UL_INT_QDONE_MSK			GENMASK(3, 0)
+#define DPMAIF_UL_INT_ERR_MSK			GENMASK(19, 16)
+
+#define DPMAIF_UDL_IP_BUSY			BIT(0)
+#define DPMAIF_DL_INT_DLQ0_QDONE		BIT(8)
+#define DPMAIF_DL_INT_DLQ1_QDONE		BIT(9)
+#define DPMAIF_DL_INT_DLQ0_PITCNT_LEN		BIT(10)
+#define DPMAIF_DL_INT_DLQ1_PITCNT_LEN		BIT(11)
+#define DPMAIF_DL_INT_Q2TOQ1			BIT(24)
+#define DPMAIF_DL_INT_Q2APTOP			BIT(25)
+
+#define DPMAIF_DLQ_LOW_TIMEOUT_THRES_MKS	GENMASK(15, 0)
+#define DPMAIF_DLQ_HIGH_TIMEOUT_THRES_MSK	GENMASK(31, 16)
+
+/* DPMAIF DLQ HW configure */
+#define DPMAIF_AGG_MAX_LEN_DF			65535
+#define DPMAIF_AGG_TBL_ENT_NUM_DF		50
+#define DPMAIF_HASH_PRIME_DF			13
+#define DPMAIF_MID_TIMEOUT_THRES_DF		100
+#define DPMAIF_DLQ_TIMEOUT_THRES_DF		100
+#define DPMAIF_DLQ_PRS_THRES_DF			10
+#define DPMAIF_DLQ_HASH_BIT_CHOOSE_DF		0
+
+#define DPMAIF_DLQPIT_EN_MSK			BIT(20)
+#define DPMAIF_DLQPIT_CHAN_OFS			16
+#define DPMAIF_ADD_DLQ_PIT_CHAN_OFS		20
+
+#endif /* __T7XX_REG_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_skb_util.c b/drivers/net/wwan/t7xx/t7xx_skb_util.c
new file mode 100644
index 000000000000..0194a7c65934
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_skb_util.c
@@ -0,0 +1,354 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/delay.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/skbuff.h>
+
+#include "t7xx_pci.h"
+#include "t7xx_skb_util.h"
+
+/* define the pool size of each different skb length */
+#define SKB_64K_POOL_SIZE	50
+#define SKB_4K_POOL_SIZE	256
+#define SKB_16_POOL_SIZE	64
+
+/* reload pool if pool size dropped below 1/RELOAD_TH */
+#define RELOAD_TH		3
+
+#define ALLOC_SKB_RETRY		20
+
+static struct sk_buff *alloc_skb_from_pool(struct skb_pools *pools, size_t size)
+{
+	if (size > MTK_SKB_4K)
+		return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_64k);
+	else if (size > MTK_SKB_16)
+		return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_4k);
+	else if (size > 0)
+		return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_16);
+
+	return NULL;
+}
+
+static struct sk_buff *alloc_skb_from_kernel(size_t size, gfp_t gfp_mask)
+{
+	if (size > MTK_SKB_4K)
+		return __dev_alloc_skb(MTK_SKB_64K, gfp_mask);
+	else if (size > MTK_SKB_1_5K)
+		return __dev_alloc_skb(MTK_SKB_4K, gfp_mask);
+	else if (size > MTK_SKB_16)
+		return __dev_alloc_skb(MTK_SKB_1_5K, gfp_mask);
+	else if (size > 0)
+		return __dev_alloc_skb(MTK_SKB_16, gfp_mask);
+
+	return NULL;
+}
+
+struct sk_buff *ccci_skb_dequeue(struct workqueue_struct *reload_work_queue,
+				 struct ccci_skb_queue *queue)
+{
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->skb_list.lock, flags);
+	skb = __skb_dequeue(&queue->skb_list);
+	if (queue->max_occupied < queue->max_len - queue->skb_list.qlen)
+		queue->max_occupied = queue->max_len - queue->skb_list.qlen;
+
+	queue->deq_count++;
+	if (queue->pre_filled && queue->skb_list.qlen < queue->max_len / RELOAD_TH)
+		queue_work(reload_work_queue, &queue->reload_work);
+
+	spin_unlock_irqrestore(&queue->skb_list.lock, flags);
+
+	return skb;
+}
+
+void ccci_skb_enqueue(struct ccci_skb_queue *queue, struct sk_buff *skb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->skb_list.lock, flags);
+	if (queue->skb_list.qlen < queue->max_len) {
+		queue->enq_count++;
+		__skb_queue_tail(&queue->skb_list, skb);
+		if (queue->skb_list.qlen > queue->max_history)
+			queue->max_history = queue->skb_list.qlen;
+	} else {
+		dev_kfree_skb_any(skb);
+	}
+
+	spin_unlock_irqrestore(&queue->skb_list.lock, flags);
+}
+
+int ccci_skb_queue_alloc(struct ccci_skb_queue *queue, size_t skb_size, size_t max_len, bool fill)
+{
+	skb_queue_head_init(&queue->skb_list);
+	queue->max_len = max_len;
+	if (fill) {
+		unsigned int i;
+
+		for (i = 0; i < queue->max_len; i++) {
+			struct sk_buff *skb;
+
+			skb = alloc_skb_from_kernel(skb_size, GFP_KERNEL);
+
+			if (!skb) {
+				while ((skb = skb_dequeue(&queue->skb_list)))
+					dev_kfree_skb_any(skb);
+				return -ENOMEM;
+			}
+
+			skb_queue_tail(&queue->skb_list, skb);
+		}
+
+		queue->pre_filled = true;
+	} else {
+		queue->pre_filled = false;
+	}
+
+	queue->max_history = 0;
+
+	return 0;
+}
+
+/**
+ * ccci_alloc_skb_from_pool() - allocate memory for skb from pre-allocated pools
+ * @pools: skb pools
+ * @size: allocation size
+ * @blocking : true for blocking operation
+ *
+ * Returns pointer to skb on success, NULL on failure.
+ */
+struct sk_buff *ccci_alloc_skb_from_pool(struct skb_pools *pools, size_t size, bool blocking)
+{
+	struct ccci_buffer_ctrl *buf_ctrl;
+	struct sk_buff *skb;
+	int count;
+
+	if (!size || size > MTK_SKB_64K)
+		return NULL;
+
+	for (count = 0; count < ALLOC_SKB_RETRY; count++) {
+		skb = alloc_skb_from_pool(pools, size);
+		if (skb || !blocking)
+			break;
+
+		/* no memory at the pool.
+		 * waiting for pools reload_work which will allocate new memory from kernel
+		 */
+		might_sleep();
+		msleep(MTK_SKB_WAIT_FOR_POOLS_RELOAD_MS);
+	}
+
+	if (skb && skb_headroom(skb) == NET_SKB_PAD) {
+		buf_ctrl = skb_push(skb, sizeof(*buf_ctrl));
+		buf_ctrl->head_magic = CCCI_BUF_MAGIC;
+		buf_ctrl->policy = MTK_SKB_POLICY_RECYCLE;
+		buf_ctrl->ioc_override = 0;
+		skb_pull(skb, sizeof(struct ccci_buffer_ctrl));
+	}
+
+	return skb;
+}
+
+/**
+ * ccci_alloc_skb() - allocate memory for skb from the kernel
+ * @size: allocation size
+ * @blocking : true for blocking operation
+ *
+ * Returns pointer to skb on success, NULL on failure.
+ */
+struct sk_buff *ccci_alloc_skb(size_t size, bool blocking)
+{
+	struct sk_buff *skb;
+	int count;
+
+	if (!size || size > MTK_SKB_64K)
+		return NULL;
+
+	if (blocking) {
+		might_sleep();
+		skb = alloc_skb_from_kernel(size, GFP_KERNEL);
+	} else {
+		for (count = 0; count < ALLOC_SKB_RETRY; count++) {
+			skb = alloc_skb_from_kernel(size, GFP_ATOMIC);
+			if (skb)
+				return skb;
+		}
+	}
+
+	return skb;
+}
+
+static void free_skb_from_pool(struct skb_pools *pools, struct sk_buff *skb)
+{
+	if (skb_size(skb) < MTK_SKB_4K)
+		ccci_skb_enqueue(&pools->skb_pool_16, skb);
+	else if (skb_size(skb) < MTK_SKB_64K)
+		ccci_skb_enqueue(&pools->skb_pool_4k, skb);
+	else
+		ccci_skb_enqueue(&pools->skb_pool_64k, skb);
+}
+
+void ccci_free_skb(struct skb_pools *pools, struct sk_buff *skb)
+{
+	struct ccci_buffer_ctrl *buf_ctrl;
+	enum data_policy policy;
+	int offset;
+
+	if (!skb)
+		return;
+
+	offset = NET_SKB_PAD - sizeof(*buf_ctrl);
+	buf_ctrl = (struct ccci_buffer_ctrl *)(skb->head + offset);
+	policy = MTK_SKB_POLICY_FREE;
+
+	if (buf_ctrl->head_magic == CCCI_BUF_MAGIC) {
+		policy = buf_ctrl->policy;
+		memset(buf_ctrl, 0, sizeof(*buf_ctrl));
+	}
+
+	if (policy != MTK_SKB_POLICY_RECYCLE || skb->dev ||
+	    skb_size(skb) < NET_SKB_PAD + MTK_SKB_16)
+		policy = MTK_SKB_POLICY_FREE;
+
+	switch (policy) {
+	case MTK_SKB_POLICY_RECYCLE:
+		skb->data = skb->head;
+		skb->len = 0;
+		skb_reset_tail_pointer(skb);
+		/* reserve memory as netdev_alloc_skb */
+		skb_reserve(skb, NET_SKB_PAD);
+		/* enqueue */
+		free_skb_from_pool(pools, skb);
+		break;
+
+	case MTK_SKB_POLICY_FREE:
+		dev_kfree_skb_any(skb);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static void reload_work_64k(struct work_struct *work)
+{
+	struct ccci_skb_queue *queue;
+	struct sk_buff *skb;
+
+	queue = container_of(work, struct ccci_skb_queue, reload_work);
+
+	while (queue->skb_list.qlen < SKB_64K_POOL_SIZE) {
+		skb = alloc_skb_from_kernel(MTK_SKB_64K, GFP_KERNEL);
+		if (skb)
+			skb_queue_tail(&queue->skb_list, skb);
+	}
+}
+
+static void reload_work_4k(struct work_struct *work)
+{
+	struct ccci_skb_queue *queue;
+	struct sk_buff *skb;
+
+	queue = container_of(work, struct ccci_skb_queue, reload_work);
+
+	while (queue->skb_list.qlen < SKB_4K_POOL_SIZE) {
+		skb = alloc_skb_from_kernel(MTK_SKB_4K, GFP_KERNEL);
+		if (skb)
+			skb_queue_tail(&queue->skb_list, skb);
+	}
+}
+
+static void reload_work_16(struct work_struct *work)
+{
+	struct ccci_skb_queue *queue;
+	struct sk_buff *skb;
+
+	queue = container_of(work, struct ccci_skb_queue, reload_work);
+
+	while (queue->skb_list.qlen < SKB_16_POOL_SIZE) {
+		skb = alloc_skb_from_kernel(MTK_SKB_16, GFP_KERNEL);
+		if (skb)
+			skb_queue_tail(&queue->skb_list, skb);
+	}
+}
+
+int ccci_skb_pool_alloc(struct skb_pools *pools)
+{
+	struct sk_buff *skb;
+	int ret;
+
+	ret = ccci_skb_queue_alloc(&pools->skb_pool_64k,
+				   MTK_SKB_64K, SKB_64K_POOL_SIZE, true);
+	if (ret)
+		return ret;
+
+	ret = ccci_skb_queue_alloc(&pools->skb_pool_4k,
+				   MTK_SKB_4K, SKB_4K_POOL_SIZE, true);
+	if (ret)
+		goto err_pool_4k;
+
+	ret = ccci_skb_queue_alloc(&pools->skb_pool_16,
+				   MTK_SKB_16, SKB_16_POOL_SIZE, true);
+	if (ret)
+		goto err_pool_16k;
+
+	pools->reload_work_queue = alloc_workqueue("pool_reload_work",
+						   WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
+						   1);
+	if (!pools->reload_work_queue) {
+		ret = -ENOMEM;
+		goto err_wq;
+	}
+
+	INIT_WORK(&pools->skb_pool_64k.reload_work, reload_work_64k);
+	INIT_WORK(&pools->skb_pool_4k.reload_work, reload_work_4k);
+	INIT_WORK(&pools->skb_pool_16.reload_work, reload_work_16);
+
+	return ret;
+
+err_wq:
+	while ((skb = skb_dequeue(&pools->skb_pool_16.skb_list)))
+		dev_kfree_skb_any(skb);
+err_pool_16k:
+	while ((skb = skb_dequeue(&pools->skb_pool_4k.skb_list)))
+		dev_kfree_skb_any(skb);
+err_pool_4k:
+	while ((skb = skb_dequeue(&pools->skb_pool_64k.skb_list)))
+		dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+void ccci_skb_pool_free(struct skb_pools *pools)
+{
+	struct ccci_skb_queue *queue;
+	struct sk_buff *newsk;
+
+	flush_work(&pools->skb_pool_64k.reload_work);
+	flush_work(&pools->skb_pool_4k.reload_work);
+	flush_work(&pools->skb_pool_16.reload_work);
+
+	if (pools->reload_work_queue)
+		destroy_workqueue(pools->reload_work_queue);
+
+	queue = &pools->skb_pool_64k;
+	while ((newsk = skb_dequeue(&queue->skb_list)) != NULL)
+		dev_kfree_skb_any(newsk);
+
+	queue = &pools->skb_pool_4k;
+	while ((newsk = skb_dequeue(&queue->skb_list)) != NULL)
+		dev_kfree_skb_any(newsk);
+
+	queue = &pools->skb_pool_16;
+	while ((newsk = skb_dequeue(&queue->skb_list)) != NULL)
+		dev_kfree_skb_any(newsk);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_skb_util.h b/drivers/net/wwan/t7xx/t7xx_skb_util.h
new file mode 100644
index 000000000000..0d6860a4eac9
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_skb_util.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#ifndef __T7XX_SKB_UTIL_H__
+#define __T7XX_SKB_UTIL_H__
+
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include <linux/wwan.h>
+
+#define MTK_SKB_64K	64528		/* 63kB + CCCI header */
+#define MTK_SKB_4K	3584		/* 3.5kB */
+#define MTK_SKB_1_5K	(WWAN_DEFAULT_MTU + 16)	/* net MTU + CCCI_H, for network packet */
+#define MTK_SKB_16	16		/* for struct ccci_header */
+#define NET_RX_BUF	MTK_SKB_4K
+
+#define CCCI_BUF_MAGIC	0xFECDBA89
+
+#define MTK_SKB_WAIT_FOR_POOLS_RELOAD_MS	20
+
+struct ccci_skb_queue {
+	struct sk_buff_head	skb_list;
+	unsigned int		max_len;
+	struct work_struct	reload_work;
+	bool			pre_filled;
+	unsigned int		max_history;
+	unsigned int		max_occupied;
+	unsigned int		enq_count;
+	unsigned int		deq_count;
+};
+
+struct skb_pools {
+	struct ccci_skb_queue skb_pool_64k;
+	struct ccci_skb_queue skb_pool_4k;
+	struct ccci_skb_queue skb_pool_16;
+	struct workqueue_struct *reload_work_queue;
+};
+
+/**
+ * enum data_policy - tells the request free routine how to handle the skb
+ * @FREE: free the skb
+ * @RECYCLE: put the skb back into our pool
+ *
+ * The driver request structure will always be recycled, but its skb
+ * can have a different policy. The driver request can work as a wrapper
+ * because the network subsys will handle the skb itself.
+ * TX: policy is determined by sender
+ * RX: policy is determined by receiver
+ */
+enum data_policy {
+	MTK_SKB_POLICY_FREE = 0,
+	MTK_SKB_POLICY_RECYCLE,
+};
+
+/* Get free skb flags */
+#define	GFS_NONE_BLOCKING	0
+#define	GFS_BLOCKING		1
+
+/* CCCI buffer control structure. Must be less than NET_SKB_PAD */
+struct ccci_buffer_ctrl {
+	unsigned int		head_magic;
+	enum data_policy	policy;
+	unsigned char		ioc_override;
+	unsigned char		blocking;
+};
+
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+static inline unsigned int skb_size(struct sk_buff *skb)
+{
+	return skb->end;
+}
+
+static inline unsigned int skb_data_size(struct sk_buff *skb)
+{
+	return skb->head + skb->end - skb->data;
+}
+#else
+static inline unsigned int skb_size(struct sk_buff *skb)
+{
+	return skb->end - skb->head;
+}
+
+static inline unsigned int skb_data_size(struct sk_buff *skb)
+{
+	return skb->end - skb->data;
+}
+#endif
+
+int ccci_skb_pool_alloc(struct skb_pools *pools);
+void ccci_skb_pool_free(struct skb_pools *pools);
+struct sk_buff *ccci_alloc_skb_from_pool(struct skb_pools *pools, size_t size, bool blocking);
+struct sk_buff *ccci_alloc_skb(size_t size, bool blocking);
+void ccci_free_skb(struct skb_pools *pools, struct sk_buff *skb);
+struct sk_buff *ccci_skb_dequeue(struct workqueue_struct *reload_work_queue,
+				 struct ccci_skb_queue *queue);
+void ccci_skb_enqueue(struct ccci_skb_queue *queue, struct sk_buff *skb);
+int ccci_skb_queue_alloc(struct ccci_skb_queue *queue, size_t skb_size, size_t max_len, bool fill);
+
+#endif /* __T7XX_SKB_UTIL_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
new file mode 100644
index 000000000000..e4d7fd9fa8b1
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -0,0 +1,591 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_monitor.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+
+#define FSM_DRM_DISABLE_DELAY_MS 200
+#define FSM_EX_REASON GENMASK(23, 16)
+
+static struct ccci_fsm_ctl *ccci_fsm_entry;
+
+void fsm_notifier_register(struct fsm_notifier_block *notifier)
+{
+	struct ccci_fsm_ctl *ctl;
+	unsigned long flags;
+
+	ctl = ccci_fsm_entry;
+	spin_lock_irqsave(&ctl->notifier_lock, flags);
+	list_add_tail(&notifier->entry, &ctl->notifier_list);
+	spin_unlock_irqrestore(&ctl->notifier_lock, flags);
+}
+
+void fsm_notifier_unregister(struct fsm_notifier_block *notifier)
+{
+	struct fsm_notifier_block *notifier_cur, *notifier_next;
+	struct ccci_fsm_ctl *ctl;
+	unsigned long flags;
+
+	ctl = ccci_fsm_entry;
+	spin_lock_irqsave(&ctl->notifier_lock, flags);
+	list_for_each_entry_safe(notifier_cur, notifier_next,
+				 &ctl->notifier_list, entry) {
+		if (notifier_cur == notifier)
+			list_del(&notifier->entry);
+	}
+
+	spin_unlock_irqrestore(&ctl->notifier_lock, flags);
+}
+
+static void fsm_state_notify(enum md_state state)
+{
+	struct fsm_notifier_block *notifier;
+	struct ccci_fsm_ctl *ctl;
+	unsigned long flags;
+
+	ctl = ccci_fsm_entry;
+	spin_lock_irqsave(&ctl->notifier_lock, flags);
+	list_for_each_entry(notifier, &ctl->notifier_list, entry) {
+		spin_unlock_irqrestore(&ctl->notifier_lock, flags);
+		if (notifier->notifier_fn)
+			notifier->notifier_fn(state, notifier->data);
+
+		spin_lock_irqsave(&ctl->notifier_lock, flags);
+	}
+
+	spin_unlock_irqrestore(&ctl->notifier_lock, flags);
+}
+
+void fsm_broadcast_state(struct ccci_fsm_ctl *ctl, enum md_state state)
+{
+	if (ctl->md_state != MD_STATE_WAITING_FOR_HS2 && state == MD_STATE_READY)
+		return;
+
+	ctl->md_state = state;
+
+	fsm_state_notify(state);
+}
+
+static void fsm_finish_command(struct ccci_fsm_ctl *ctl, struct ccci_fsm_command *cmd, int result)
+{
+	unsigned long flags;
+
+	if (cmd->flag & FSM_CMD_FLAG_WAITING_TO_COMPLETE) {
+		/* The processing thread may see the list, after a command is added,
+		 * without being woken up. Hence a spinlock is needed.
+		 */
+		spin_lock_irqsave(&ctl->cmd_complete_lock, flags);
+		cmd->result = result;
+		wake_up_all(&cmd->complete_wq);
+		spin_unlock_irqrestore(&ctl->cmd_complete_lock, flags);
+	} else {
+		/* no one is waiting for this command, free to kfree */
+		kfree(cmd);
+	}
+}
+
+/* call only with protection of event_lock */
+static void fsm_finish_event(struct ccci_fsm_ctl *ctl, struct ccci_fsm_event *event)
+{
+	list_del(&event->entry);
+	kfree(event);
+}
+
+static void fsm_flush_queue(struct ccci_fsm_ctl *ctl)
+{
+	struct ccci_fsm_event *event, *evt_next;
+	struct ccci_fsm_command *cmd, *cmd_next;
+	unsigned long flags;
+	struct device *dev;
+
+	dev = &ctl->md->mtk_dev->pdev->dev;
+	spin_lock_irqsave(&ctl->command_lock, flags);
+	list_for_each_entry_safe(cmd, cmd_next, &ctl->command_queue, entry) {
+		dev_warn(dev, "unhandled command %d\n", cmd->cmd_id);
+		list_del(&cmd->entry);
+		fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+	}
+
+	spin_unlock_irqrestore(&ctl->command_lock, flags);
+	spin_lock_irqsave(&ctl->event_lock, flags);
+	list_for_each_entry_safe(event, evt_next, &ctl->event_queue, entry) {
+		dev_warn(dev, "unhandled event %d\n", event->event_id);
+		fsm_finish_event(ctl, event);
+	}
+
+	spin_unlock_irqrestore(&ctl->event_lock, flags);
+}
+
+/* cmd is not NULL only when reason is ordinary exception */
+static void fsm_routine_exception(struct ccci_fsm_ctl *ctl, struct ccci_fsm_command *cmd,
+				  enum ccci_ex_reason reason)
+{
+	bool rec_ok = false;
+	struct ccci_fsm_event *event;
+	unsigned long flags;
+	struct device *dev;
+	int cnt;
+
+	dev = &ctl->md->mtk_dev->pdev->dev;
+	dev_err(dev, "exception %d, from %ps\n", reason, __builtin_return_address(0));
+	/* state sanity check */
+	if (ctl->curr_state != CCCI_FSM_READY && ctl->curr_state != CCCI_FSM_STARTING) {
+		if (cmd)
+			fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+		return;
+	}
+
+	ctl->last_state = ctl->curr_state;
+	ctl->curr_state = CCCI_FSM_EXCEPTION;
+
+	/* check exception reason */
+	switch (reason) {
+	case EXCEPTION_HS_TIMEOUT:
+		dev_err(dev, "BOOT_HS_FAIL\n");
+		break;
+
+	case EXCEPTION_EVENT:
+		fsm_broadcast_state(ctl, MD_STATE_EXCEPTION);
+		mtk_md_exception_handshake(ctl->md);
+		cnt = 0;
+		while (cnt < MD_EX_REC_OK_TIMEOUT_MS / EVENT_POLL_INTERVAL_MS) {
+			if (kthread_should_stop())
+				return;
+
+			spin_lock_irqsave(&ctl->event_lock, flags);
+			if (!list_empty(&ctl->event_queue)) {
+				event = list_first_entry(&ctl->event_queue,
+							 struct ccci_fsm_event, entry);
+				if (event->event_id == CCCI_EVENT_MD_EX) {
+					fsm_finish_event(ctl, event);
+				} else if (event->event_id == CCCI_EVENT_MD_EX_REC_OK) {
+					rec_ok = true;
+					fsm_finish_event(ctl, event);
+				}
+			}
+
+			spin_unlock_irqrestore(&ctl->event_lock, flags);
+			if (rec_ok)
+				break;
+
+			cnt++;
+			msleep(EVENT_POLL_INTERVAL_MS);
+		}
+
+		cnt = 0;
+		while (cnt < MD_EX_PASS_TIMEOUT_MS / EVENT_POLL_INTERVAL_MS) {
+			if (kthread_should_stop())
+				return;
+
+			spin_lock_irqsave(&ctl->event_lock, flags);
+			if (!list_empty(&ctl->event_queue)) {
+				event = list_first_entry(&ctl->event_queue,
+							 struct ccci_fsm_event, entry);
+				if (event->event_id == CCCI_EVENT_MD_EX_PASS)
+					fsm_finish_event(ctl, event);
+			}
+
+			spin_unlock_irqrestore(&ctl->event_lock, flags);
+			cnt++;
+			msleep(EVENT_POLL_INTERVAL_MS);
+		}
+
+		break;
+
+	default:
+		break;
+	}
+
+	if (cmd)
+		fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_OK);
+}
+
+static void fsm_stopped_handler(struct ccci_fsm_ctl *ctl)
+{
+	ctl->last_state = ctl->curr_state;
+	ctl->curr_state = CCCI_FSM_STOPPED;
+
+	fsm_broadcast_state(ctl, MD_STATE_STOPPED);
+	mtk_md_reset(ctl->md->mtk_dev);
+}
+
+static void fsm_routine_stopped(struct ccci_fsm_ctl *ctl, struct ccci_fsm_command *cmd)
+{
+	/* state sanity check */
+	if (ctl->curr_state == CCCI_FSM_STOPPED) {
+		fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+		return;
+	}
+
+	fsm_stopped_handler(ctl);
+	fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_OK);
+}
+
+static void fsm_routine_stopping(struct ccci_fsm_ctl *ctl, struct ccci_fsm_command *cmd)
+{
+	struct mtk_pci_dev *mtk_dev;
+	int err;
+
+	/* state sanity check */
+	if (ctl->curr_state == CCCI_FSM_STOPPED || ctl->curr_state == CCCI_FSM_STOPPING) {
+		fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+		return;
+	}
+
+	ctl->last_state = ctl->curr_state;
+	ctl->curr_state = CCCI_FSM_STOPPING;
+
+	fsm_broadcast_state(ctl, MD_STATE_WAITING_TO_STOP);
+	/* stop HW */
+	cldma_stop(ID_CLDMA1);
+
+	mtk_dev = ctl->md->mtk_dev;
+	if (!atomic_read(&ctl->md->rgu_irq_asserted)) {
+		/* disable DRM before FLDR */
+		mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_DRM_DISABLE_AP);
+		msleep(FSM_DRM_DISABLE_DELAY_MS);
+		/* try FLDR first */
+		err = mtk_acpi_fldr_func(mtk_dev);
+		if (err)
+			mhccif_h2d_swint_trigger(mtk_dev, H2D_CH_DEVICE_RESET);
+	}
+
+	/* auto jump to stopped state handler */
+	fsm_stopped_handler(ctl);
+
+	fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_OK);
+}
+
+static void fsm_routine_ready(struct ccci_fsm_ctl *ctl)
+{
+	struct mtk_modem *md;
+
+	ctl->last_state = ctl->curr_state;
+	ctl->curr_state = CCCI_FSM_READY;
+	fsm_broadcast_state(ctl, MD_STATE_READY);
+	md = ctl->md;
+	mtk_md_event_notify(md, FSM_READY);
+}
+
+static void fsm_routine_starting(struct ccci_fsm_ctl *ctl)
+{
+	struct mtk_modem *md;
+	struct device *dev;
+
+	ctl->last_state = ctl->curr_state;
+	ctl->curr_state = CCCI_FSM_STARTING;
+
+	fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS1);
+	md = ctl->md;
+	dev = &md->mtk_dev->pdev->dev;
+	mtk_md_event_notify(md, FSM_START);
+
+	wait_event_interruptible_timeout(ctl->async_hk_wq,
+					 atomic_read(&md->core_md.ready) ||
+					 atomic_read(&ctl->exp_flg), HZ * 60);
+
+	if (atomic_read(&ctl->exp_flg))
+		dev_err(dev, "MD exception is captured during handshake\n");
+
+	if (!atomic_read(&md->core_md.ready)) {
+		dev_err(dev, "MD handshake timeout\n");
+		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
+	} else {
+		fsm_routine_ready(ctl);
+	}
+}
+
+static void fsm_routine_start(struct ccci_fsm_ctl *ctl, struct ccci_fsm_command *cmd)
+{
+	struct mtk_modem *md;
+	struct device *dev;
+	u32 dev_status;
+
+	md = ctl->md;
+	if (!md)
+		return;
+
+	dev = &md->mtk_dev->pdev->dev;
+	/* state sanity check */
+	if (ctl->curr_state != CCCI_FSM_INIT &&
+	    ctl->curr_state != CCCI_FSM_PRE_START &&
+	    ctl->curr_state != CCCI_FSM_STOPPED) {
+		fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+		return;
+	}
+
+	ctl->last_state = ctl->curr_state;
+	ctl->curr_state = CCCI_FSM_PRE_START;
+	mtk_md_event_notify(md, FSM_PRE_START);
+
+	read_poll_timeout(ioread32, dev_status, (dev_status & MISC_STAGE_MASK) == LINUX_STAGE,
+			  20000, 2000000, false, IREG_BASE(md->mtk_dev) + PCIE_MISC_DEV_STATUS);
+	if ((dev_status & MISC_STAGE_MASK) != LINUX_STAGE) {
+		dev_err(dev, "invalid device status 0x%lx\n", dev_status & MISC_STAGE_MASK);
+		fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+		return;
+	}
+	cldma_hif_hw_init(ID_CLDMA1);
+	fsm_routine_starting(ctl);
+	fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_OK);
+}
+
+static int fsm_main_thread(void *data)
+{
+	struct ccci_fsm_command *cmd;
+	struct ccci_fsm_ctl *ctl;
+	unsigned long flags;
+
+	ctl = data;
+
+	while (!kthread_should_stop()) {
+		if (wait_event_interruptible(ctl->command_wq, !list_empty(&ctl->command_queue) ||
+					     kthread_should_stop()))
+			continue;
+		if (kthread_should_stop())
+			break;
+
+		spin_lock_irqsave(&ctl->command_lock, flags);
+		cmd = list_first_entry(&ctl->command_queue, struct ccci_fsm_command, entry);
+		list_del(&cmd->entry);
+		spin_unlock_irqrestore(&ctl->command_lock, flags);
+
+		switch (cmd->cmd_id) {
+		case CCCI_COMMAND_START:
+			fsm_routine_start(ctl, cmd);
+			break;
+
+		case CCCI_COMMAND_EXCEPTION:
+			fsm_routine_exception(ctl, cmd, FIELD_GET(FSM_EX_REASON, cmd->flag));
+			break;
+
+		case CCCI_COMMAND_PRE_STOP:
+			fsm_routine_stopping(ctl, cmd);
+			break;
+
+		case CCCI_COMMAND_STOP:
+			fsm_routine_stopped(ctl, cmd);
+			break;
+
+		default:
+			fsm_finish_command(ctl, cmd, FSM_CMD_RESULT_FAIL);
+			fsm_flush_queue(ctl);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+int fsm_append_command(struct ccci_fsm_ctl *ctl, enum ccci_fsm_cmd_state cmd_id, unsigned int flag)
+{
+	struct ccci_fsm_command *cmd;
+	unsigned long flags;
+	int result = 0;
+
+	cmd = kmalloc(sizeof(*cmd),
+		      (in_irq() || in_softirq() || irqs_disabled()) ? GFP_ATOMIC : GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&cmd->entry);
+	init_waitqueue_head(&cmd->complete_wq);
+	cmd->cmd_id = cmd_id;
+	cmd->result = FSM_CMD_RESULT_PENDING;
+	if (in_irq() || irqs_disabled())
+		flag &= ~FSM_CMD_FLAG_WAITING_TO_COMPLETE;
+
+	cmd->flag = flag;
+
+	spin_lock_irqsave(&ctl->command_lock, flags);
+	list_add_tail(&cmd->entry, &ctl->command_queue);
+	spin_unlock_irqrestore(&ctl->command_lock, flags);
+	/* after this line, only dereference command when "waiting-to-complete" */
+	wake_up(&ctl->command_wq);
+	if (flag & FSM_CMD_FLAG_WAITING_TO_COMPLETE) {
+		wait_event(cmd->complete_wq, cmd->result != FSM_CMD_RESULT_PENDING);
+		if (cmd->result != FSM_CMD_RESULT_OK)
+			result = -EINVAL;
+
+		spin_lock_irqsave(&ctl->cmd_complete_lock, flags);
+		kfree(cmd);
+		spin_unlock_irqrestore(&ctl->cmd_complete_lock, flags);
+	}
+
+	return result;
+}
+
+int fsm_append_event(struct ccci_fsm_ctl *ctl, enum ccci_fsm_event_state event_id,
+		     unsigned char *data, unsigned int length)
+{
+	struct ccci_fsm_event *event;
+	unsigned long flags;
+	struct device *dev;
+
+	dev = &ctl->md->mtk_dev->pdev->dev;
+
+	if (event_id <= CCCI_EVENT_INVALID || event_id >= CCCI_EVENT_MAX) {
+		dev_err(dev, "invalid event %d\n", event_id);
+		return -EINVAL;
+	}
+
+	event = kmalloc(struct_size(event, data, length),
+			in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&event->entry);
+	event->event_id = event_id;
+	event->length = length;
+	if (data && length)
+		memcpy(event->data, data, flex_array_size(event, data, event->length));
+
+	spin_lock_irqsave(&ctl->event_lock, flags);
+	list_add_tail(&event->entry, &ctl->event_queue);
+	spin_unlock_irqrestore(&ctl->event_lock, flags);
+	wake_up_all(&ctl->event_wq);
+	return 0;
+}
+
+void fsm_clear_event(struct ccci_fsm_ctl *ctl, enum ccci_fsm_event_state event_id)
+{
+	struct ccci_fsm_event *event, *evt_next;
+	unsigned long flags;
+	struct device *dev;
+
+	dev = &ctl->md->mtk_dev->pdev->dev;
+
+	spin_lock_irqsave(&ctl->event_lock, flags);
+	list_for_each_entry_safe(event, evt_next, &ctl->event_queue, entry) {
+		dev_err(dev, "unhandled event %d\n", event->event_id);
+		if (event->event_id == event_id)
+			fsm_finish_event(ctl, event);
+	}
+
+	spin_unlock_irqrestore(&ctl->event_lock, flags);
+}
+
+struct ccci_fsm_ctl *fsm_get_entity_by_device_number(dev_t dev_n)
+{
+	if (ccci_fsm_entry && ccci_fsm_entry->monitor_ctl.dev_n == dev_n)
+		return ccci_fsm_entry;
+
+	return NULL;
+}
+
+struct ccci_fsm_ctl *fsm_get_entry(void)
+{
+	return ccci_fsm_entry;
+}
+
+enum md_state ccci_fsm_get_md_state(void)
+{
+	struct ccci_fsm_ctl *ctl;
+
+	ctl = ccci_fsm_entry;
+	if (ctl)
+		return ctl->md_state;
+	else
+		return MD_STATE_INVALID;
+}
+
+unsigned int ccci_fsm_get_current_state(void)
+{
+	struct ccci_fsm_ctl *ctl;
+
+	ctl = ccci_fsm_entry;
+	if (ctl)
+		return ctl->curr_state;
+	else
+		return CCCI_FSM_STOPPED;
+}
+
+void ccci_fsm_recv_md_interrupt(enum md_irq_type type)
+{
+	struct ccci_fsm_ctl *ctl;
+
+	ctl = ccci_fsm_entry;
+	if (type == MD_IRQ_PORT_ENUM) {
+		fsm_append_command(ctl, CCCI_COMMAND_START, 0);
+	} else if (type == MD_IRQ_CCIF_EX) {
+		/* interrupt handshake flow */
+		atomic_set(&ctl->exp_flg, 1);
+		wake_up(&ctl->async_hk_wq);
+		fsm_append_command(ctl, CCCI_COMMAND_EXCEPTION,
+				   FIELD_PREP(FSM_EX_REASON, EXCEPTION_EE));
+	}
+}
+
+void ccci_fsm_reset(void)
+{
+	struct ccci_fsm_ctl *ctl;
+
+	ctl = ccci_fsm_entry;
+	/* Clear event and command queues */
+	fsm_flush_queue(ctl);
+
+	ctl->last_state = CCCI_FSM_INIT;
+	ctl->curr_state = CCCI_FSM_STOPPED;
+	atomic_set(&ctl->exp_flg, 0);
+}
+
+int ccci_fsm_init(struct mtk_modem *md)
+{
+	struct ccci_fsm_ctl *ctl;
+
+	ctl = devm_kzalloc(&md->mtk_dev->pdev->dev, sizeof(*ctl), GFP_KERNEL);
+	if (!ctl)
+		return -ENOMEM;
+
+	ccci_fsm_entry = ctl;
+	ctl->md = md;
+	ctl->last_state = CCCI_FSM_INIT;
+	ctl->curr_state = CCCI_FSM_INIT;
+	INIT_LIST_HEAD(&ctl->command_queue);
+	INIT_LIST_HEAD(&ctl->event_queue);
+	init_waitqueue_head(&ctl->async_hk_wq);
+	init_waitqueue_head(&ctl->event_wq);
+	INIT_LIST_HEAD(&ctl->notifier_list);
+	init_waitqueue_head(&ctl->command_wq);
+	spin_lock_init(&ctl->event_lock);
+	spin_lock_init(&ctl->command_lock);
+	spin_lock_init(&ctl->cmd_complete_lock);
+	atomic_set(&ctl->exp_flg, 0);
+	spin_lock_init(&ctl->notifier_lock);
+
+	ctl->fsm_thread = kthread_run(fsm_main_thread, ctl, "ccci_fsm");
+	if (IS_ERR(ctl->fsm_thread)) {
+		dev_err(&md->mtk_dev->pdev->dev, "failed to start monitor thread\n");
+		return PTR_ERR(ctl->fsm_thread);
+	}
+
+	return 0;
+}
+
+void ccci_fsm_uninit(void)
+{
+	struct ccci_fsm_ctl *ctl;
+
+	ctl = ccci_fsm_entry;
+	if (!ctl)
+		return;
+
+	if (ctl->fsm_thread)
+		kthread_stop(ctl->fsm_thread);
+
+	fsm_flush_queue(ctl);
+}
-- 
2.17.1

