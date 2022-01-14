Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998E648E1F1
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 02:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238630AbiANBG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 20:06:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:55112 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238612AbiANBGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 20:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642122415; x=1673658415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=BBtO98a8JFLpp2aBSNG8KwvY/WCHrZrU6XzT7DCY1/I=;
  b=iqgTxXcb7UL8esA3U+NrNNmGu/m/ZJy0lv4dfxSvEFki+UDqVNp+QIX9
   Qle+hlQUd2sbWR0k6hZ7aqOue5ytjDODdbD5eLWo7m/6OFZCGmBS4rpgM
   2OeOYctGqQnASGB/G/z8hSwaeqQJ419JkgD9v1N6pgd76N+m7lxU2k8Lv
   isO8Clpc1YjXtGCAqafiGgPaQNq/1yqPhmZFkF+rOfBGtlU4exSY/20GM
   gBp/oYQtf0dSUBk4yLyRq8z3hv6W0KlzVuwdyPvvtubZIQ8eRT1zzJxrJ
   qPEy4osZVb3mTlz3RPh3pM3tahjmq4jalE5yM9cUBN2D54xIJOlJ3Sr+I
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268516442"
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="268516442"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,287,1635231600"; 
   d="scan'208";a="692014192"
Received: from rmarti10-desk.jf.intel.com ([134.134.150.146])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 17:06:52 -0800
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, ilpo.johannes.jarvinen@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next v4 03/13] net: wwan: t7xx: Add core components
Date:   Thu, 13 Jan 2022 18:06:17 -0700
Message-Id: <20220114010627.21104-4-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haijun Liu <haijun.liu@mediatek.com>

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

Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/Kconfig                   |  14 +
 drivers/net/wwan/Makefile                  |   1 +
 drivers/net/wwan/t7xx/Makefile             |  12 +
 drivers/net/wwan/t7xx/t7xx_mhccif.c        |  98 ++++
 drivers/net/wwan/t7xx/t7xx_mhccif.h        |  37 ++
 drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 434 +++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_modem_ops.h     |  84 ++++
 drivers/net/wwan/t7xx/t7xx_pci.c           | 223 +++++++++
 drivers/net/wwan/t7xx/t7xx_pci.h           |  67 +++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.c      | 277 +++++++++++
 drivers/net/wwan/t7xx/t7xx_pcie_mac.h      |  37 ++
 drivers/net/wwan/t7xx/t7xx_reg.h           | 379 +++++++++++++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.c | 539 +++++++++++++++++++++
 drivers/net/wwan/t7xx/t7xx_state_monitor.h | 123 +++++
 14 files changed, 2325 insertions(+)
 create mode 100644 drivers/net/wwan/t7xx/Makefile
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_mhccif.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_modem_ops.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pci.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_pcie_mac.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_reg.h
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_state_monitor.h

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 609fd4a2c865..3486ffe94ac4 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -105,6 +105,20 @@ config IOSM
 
 	  If unsure, say N.
 
+config MTK_T7XX
+	tristate "MediaTek PCIe 5G WWAN modem T7xx device"
+	depends on PCI
+	help
+	  Enables MediaTek PCIe based 5G WWAN modem (T7xx series) device.
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
index e722650bebea..3960c0ae2445 100644
--- a/drivers/net/wwan/Makefile
+++ b/drivers/net/wwan/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_MHI_WWAN_MBIM) += mhi_wwan_mbim.o
 obj-$(CONFIG_QCOM_BAM_DMUX) += qcom_bam_dmux.o
 obj-$(CONFIG_RPMSG_WWAN_CTRL) += rpmsg_wwan_ctrl.o
 obj-$(CONFIG_IOSM) += iosm/
+obj-$(CONFIG_MTK_T7XX) += t7xx/
diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
new file mode 100644
index 000000000000..6a49013bc343
--- /dev/null
+++ b/drivers/net/wwan/t7xx/Makefile
@@ -0,0 +1,12 @@
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
+		t7xx_cldma.o \
+		t7xx_hif_cldma.o  \
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.c b/drivers/net/wwan/t7xx/t7xx_mhccif.c
new file mode 100644
index 000000000000..20aae457629c
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/completion.h>
+#include <linux/dev_printk.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+
+static void t7xx_mhccif_clear_interrupts(struct t7xx_pci_dev *t7xx_dev, u32 mask)
+{
+	void __iomem *mhccif_pbase = t7xx_dev->base_addr.mhccif_rc_base;
+
+	/* Clear level 2 interrupt */
+	iowrite32(mask, mhccif_pbase + REG_EP2RC_SW_INT_ACK);
+	/* Ensure write is complete */
+	t7xx_mhccif_read_sw_int_sts(t7xx_dev);
+	/* Clear level 1 interrupt */
+	t7xx_pcie_mac_clear_int_status(t7xx_dev, MHCCIF_INT);
+}
+
+static irqreturn_t t7xx_mhccif_isr_thread(int irq, void *data)
+{
+	struct t7xx_pci_dev *t7xx_dev = data;
+	u32 int_sts, val;
+
+	val = L1_1_DISABLE_BIT(1) | L1_2_DISABLE_BIT(1);
+	iowrite32(val, IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_SET_0);
+
+	int_sts = t7xx_mhccif_read_sw_int_sts(t7xx_dev);
+	if (int_sts & t7xx_dev->mhccif_bitmask)
+		t7xx_pci_mhccif_isr(t7xx_dev);
+
+	t7xx_mhccif_clear_interrupts(t7xx_dev, int_sts);
+	t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
+	return IRQ_HANDLED;
+}
+
+u32 t7xx_mhccif_read_sw_int_sts(struct t7xx_pci_dev *t7xx_dev)
+{
+	return ioread32(t7xx_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_STS);
+}
+
+void t7xx_mhccif_mask_set(struct t7xx_pci_dev *t7xx_dev, u32 val)
+{
+	iowrite32(val, t7xx_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_EAP_MASK_SET);
+}
+
+void t7xx_mhccif_mask_clr(struct t7xx_pci_dev *t7xx_dev, u32 val)
+{
+	iowrite32(val, t7xx_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_EAP_MASK_CLR);
+}
+
+u32 t7xx_mhccif_mask_get(struct t7xx_pci_dev *t7xx_dev)
+{
+	return ioread32(t7xx_dev->base_addr.mhccif_rc_base + REG_EP2RC_SW_INT_EAP_MASK);
+}
+
+static irqreturn_t t7xx_mhccif_isr_handler(int irq, void *data)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+void t7xx_mhccif_init(struct t7xx_pci_dev *t7xx_dev)
+{
+	t7xx_dev->base_addr.mhccif_rc_base = t7xx_dev->base_addr.pcie_ext_reg_base +
+					    MHCCIF_RC_DEV_BASE -
+					    t7xx_dev->base_addr.pcie_dev_reg_trsl_addr;
+
+	t7xx_dev->intr_handler[MHCCIF_INT] = t7xx_mhccif_isr_handler;
+	t7xx_dev->intr_thread[MHCCIF_INT] = t7xx_mhccif_isr_thread;
+	t7xx_dev->callback_param[MHCCIF_INT] = t7xx_dev;
+}
+
+void t7xx_mhccif_h2d_swint_trigger(struct t7xx_pci_dev *t7xx_dev, u32 channel)
+{
+	void __iomem *mhccif_pbase = t7xx_dev->base_addr.mhccif_rc_base;
+
+	iowrite32(BIT(channel), mhccif_pbase + REG_RC2EP_SW_BSY);
+	iowrite32(channel, mhccif_pbase + REG_RC2EP_SW_TCHNUM);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_mhccif.h b/drivers/net/wwan/t7xx/t7xx_mhccif.h
new file mode 100644
index 000000000000..62e9afa59296
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_mhccif.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
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
+void t7xx_mhccif_mask_set(struct t7xx_pci_dev *t7xx_dev, u32 val);
+void t7xx_mhccif_mask_clr(struct t7xx_pci_dev *t7xx_dev, u32 val);
+u32 t7xx_mhccif_mask_get(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_mhccif_init(struct t7xx_pci_dev *t7xx_dev);
+u32 t7xx_mhccif_read_sw_int_sts(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_mhccif_h2d_swint_trigger(struct t7xx_pci_dev *t7xx_dev, u32 channel);
+
+#endif /*__T7XX_MHCCIF_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
new file mode 100644
index 000000000000..a106dbb526ea
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -0,0 +1,434 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/acpi.h>
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/gfp.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/kthread.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+#include "t7xx_state_monitor.h"
+
+#define RGU_RESET_DELAY_MS	10
+#define PORT_RESET_DELAY_MS	2000
+#define EX_HS_TIMEOUT_MS	5000
+#define EX_HS_POLL_DELAY_MS	10
+
+static unsigned int t7xx_get_interrupt_status(struct t7xx_pci_dev *t7xx_dev)
+{
+	return t7xx_mhccif_read_sw_int_sts(t7xx_dev) & D2H_SW_INT_MASK;
+}
+
+/**
+ * t7xx_pci_mhccif_isr() - Process MHCCIF interrupts.
+ * @t7xx_dev: MTK device.
+ *
+ * Check the interrupt status and queue commands accordingly.
+ *
+ * Returns:
+ ** 0		- Success.
+ ** -EINVAL	- Failure to get FSM control.
+ */
+int t7xx_pci_mhccif_isr(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct t7xx_modem *md = t7xx_dev->md;
+	struct t7xx_fsm_ctl *ctl;
+	unsigned int int_sta;
+	u32 mask;
+
+	ctl = md->fsm_ctl;
+	if (!ctl) {
+		dev_err_ratelimited(&t7xx_dev->pdev->dev,
+				    "MHCCIF interrupt received before initializing MD monitor\n");
+		return -EINVAL;
+	}
+
+	spin_lock_bh(&md->exp_lock);
+	int_sta = t7xx_get_interrupt_status(t7xx_dev);
+
+	md->exp_id |= int_sta;
+	if (md->exp_id & D2H_INT_PORT_ENUM) {
+		md->exp_id &= ~D2H_INT_PORT_ENUM;
+
+		if (ctl->curr_state == FSM_STATE_INIT || ctl->curr_state == FSM_STATE_PRE_START ||
+		    ctl->curr_state == FSM_STATE_STOPPED)
+			t7xx_fsm_recv_md_intr(ctl, MD_IRQ_PORT_ENUM);
+	}
+
+	if (md->exp_id & D2H_INT_EXCEPTION_INIT) {
+		if (ctl->md_state == MD_STATE_INVALID ||
+		    ctl->md_state == MD_STATE_WAITING_FOR_HS1 ||
+		    ctl->md_state == MD_STATE_WAITING_FOR_HS2 ||
+		    ctl->md_state == MD_STATE_READY) {
+			md->exp_id &= ~D2H_INT_EXCEPTION_INIT;
+			t7xx_fsm_recv_md_intr(ctl, MD_IRQ_CCIF_EX);
+		}
+	} else if (ctl->md_state == MD_STATE_WAITING_FOR_HS1) {
+		mask = t7xx_mhccif_mask_get(t7xx_dev);
+		if ((md->exp_id & D2H_INT_ASYNC_MD_HK) && !(mask & D2H_INT_ASYNC_MD_HK)) {
+			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+			queue_work(md->handshake_wq, &md->handshake_work);
+		}
+	}
+
+	spin_unlock_bh(&md->exp_lock);
+
+	return 0;
+}
+
+static void t7xx_clr_device_irq_via_pcie(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct t7xx_addr_base *pbase_addr = &t7xx_dev->base_addr;
+	void __iomem *reset_pcie_reg;
+	u32 val;
+
+	reset_pcie_reg = pbase_addr->pcie_ext_reg_base + TOPRGU_CH_PCIE_IRQ_STA -
+			  pbase_addr->pcie_dev_reg_trsl_addr;
+	val = ioread32(reset_pcie_reg);
+	iowrite32(val, reset_pcie_reg);
+}
+
+void t7xx_clear_rgu_irq(struct t7xx_pci_dev *t7xx_dev)
+{
+	/* Clear L2 */
+	t7xx_clr_device_irq_via_pcie(t7xx_dev);
+	/* Clear L1 */
+	t7xx_pcie_mac_clear_int_status(t7xx_dev, SAP_RGU_INT);
+}
+
+static int t7xx_acpi_reset(struct t7xx_pci_dev *t7xx_dev, char *fn_name)
+{
+#ifdef CONFIG_ACPI
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct device *dev = &t7xx_dev->pdev->dev;
+	acpi_status acpi_ret;
+	acpi_handle handle;
+
+	handle = ACPI_HANDLE(dev);
+	if (!handle) {
+		dev_err(dev, "ACPI handle not found\n");
+		return -EFAULT;
+	}
+
+	if (!acpi_has_method(handle, fn_name)) {
+		dev_err(dev, "%s method not found\n", fn_name);
+		return -EFAULT;
+	}
+
+	acpi_ret = acpi_evaluate_object(handle, fn_name, NULL, &buffer);
+	if (ACPI_FAILURE(acpi_ret)) {
+		dev_err(dev, "%s method fail: %s\n", fn_name, acpi_format_exception(acpi_ret));
+		return -EFAULT;
+	}
+
+#endif
+	return 0;
+}
+
+int t7xx_acpi_fldr_func(struct t7xx_pci_dev *t7xx_dev)
+{
+	return t7xx_acpi_reset(t7xx_dev, "_RST");
+}
+
+static void t7xx_reset_device_via_pmic(struct t7xx_pci_dev *t7xx_dev)
+{
+	u32 val;
+
+	val = ioread32(IREG_BASE(t7xx_dev) + PCIE_MISC_DEV_STATUS);
+	if (val & MISC_RESET_TYPE_PLDR)
+		t7xx_acpi_reset(t7xx_dev, "MRST._RST");
+	else if (val & MISC_RESET_TYPE_FLDR)
+		t7xx_acpi_fldr_func(t7xx_dev);
+}
+
+static irqreturn_t t7xx_rgu_isr_thread(int irq, void *data)
+{
+	struct t7xx_pci_dev *t7xx_dev = data;
+
+	msleep(RGU_RESET_DELAY_MS);
+	t7xx_reset_device_via_pmic(t7xx_dev);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t t7xx_rgu_isr_handler(int irq, void *data)
+{
+	struct t7xx_pci_dev *t7xx_dev = data;
+	struct t7xx_modem *modem;
+
+	t7xx_clear_rgu_irq(t7xx_dev);
+	if (!t7xx_dev->rgu_pci_irq_en)
+		return IRQ_HANDLED;
+
+	modem = t7xx_dev->md;
+	modem->rgu_irq_asserted = true;
+	t7xx_pcie_mac_clear_int(t7xx_dev, SAP_RGU_INT);
+	return IRQ_WAKE_THREAD;
+}
+
+static void t7xx_pcie_register_rgu_isr(struct t7xx_pci_dev *t7xx_dev)
+{
+	/* Registers RGU callback ISR with PCIe driver */
+	t7xx_pcie_mac_clear_int(t7xx_dev, SAP_RGU_INT);
+	t7xx_pcie_mac_clear_int_status(t7xx_dev, SAP_RGU_INT);
+
+	t7xx_dev->intr_handler[SAP_RGU_INT] = t7xx_rgu_isr_handler;
+	t7xx_dev->intr_thread[SAP_RGU_INT] = t7xx_rgu_isr_thread;
+	t7xx_dev->callback_param[SAP_RGU_INT] = t7xx_dev;
+	t7xx_pcie_mac_set_int(t7xx_dev, SAP_RGU_INT);
+}
+
+static void t7xx_md_exception(struct t7xx_modem *md, enum hif_ex_stage stage)
+{
+	struct t7xx_pci_dev *t7xx_dev = md->t7xx_dev;
+
+	if (stage == HIF_EX_CLEARQ_DONE) {
+		/* Give DHL time to flush data */
+		msleep(PORT_RESET_DELAY_MS);
+	}
+
+	t7xx_cldma_exception(md->md_ctrl[ID_CLDMA1], stage);
+
+	if (stage == HIF_EX_INIT)
+		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_EXCEPTION_ACK);
+	else if (stage == HIF_EX_CLEARQ_DONE)
+		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_EXCEPTION_CLEARQ_ACK);
+}
+
+static int t7xx_wait_hif_ex_hk_event(struct t7xx_modem *md, int event_id)
+{
+	unsigned int waited_time_ms = 0;
+
+	do {
+		if (md->exp_id & event_id)
+			return 0;
+
+		waited_time_ms += EX_HS_POLL_DELAY_MS;
+		msleep(EX_HS_POLL_DELAY_MS);
+	} while (waited_time_ms < EX_HS_TIMEOUT_MS);
+
+	return -EFAULT;
+}
+
+static void t7xx_md_sys_sw_init(struct t7xx_pci_dev *t7xx_dev)
+{
+	/* Register the MHCCIF ISR for MD exception, port enum and
+	 * async handshake notifications.
+	 */
+	t7xx_mhccif_mask_set(t7xx_dev, D2H_SW_INT_MASK);
+	t7xx_dev->mhccif_bitmask = D2H_SW_INT_MASK;
+	t7xx_mhccif_mask_clr(t7xx_dev, D2H_INT_PORT_ENUM);
+
+	/* Register RGU IRQ handler for sAP exception notification */
+	t7xx_dev->rgu_pci_irq_en = true;
+	t7xx_pcie_register_rgu_isr(t7xx_dev);
+}
+
+static void t7xx_md_hk_wq(struct work_struct *work)
+{
+	struct t7xx_modem *md = container_of(work, struct t7xx_modem, handshake_work);
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+
+	t7xx_cldma_switch_cfg(md->md_ctrl[ID_CLDMA1]);
+	t7xx_cldma_start(md->md_ctrl[ID_CLDMA1]);
+	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS2);
+	md->core_md.ready = true;
+	wake_up(&ctl->async_hk_wq);
+}
+
+void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id)
+{
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+	void __iomem *mhccif_base;
+	unsigned int int_sta;
+	unsigned long flags;
+
+	switch (evt_id) {
+	case FSM_PRE_START:
+		t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_PORT_ENUM);
+		break;
+
+	case FSM_START:
+		t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_PORT_ENUM);
+		spin_lock_irqsave(&md->exp_lock, flags);
+		int_sta = t7xx_get_interrupt_status(md->t7xx_dev);
+
+		md->exp_id |= int_sta;
+		if (md->exp_id & D2H_INT_EXCEPTION_INIT) {
+			ctl->exp_flg = true;
+			md->exp_id &= ~D2H_INT_EXCEPTION_INIT;
+			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+		} else if (ctl->exp_flg) {
+			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+		} else if (md->exp_id & D2H_INT_ASYNC_MD_HK) {
+			queue_work(md->handshake_wq, &md->handshake_work);
+			md->exp_id &= ~D2H_INT_ASYNC_MD_HK;
+			mhccif_base = md->t7xx_dev->base_addr.mhccif_rc_base;
+			iowrite32(D2H_INT_ASYNC_MD_HK, mhccif_base + REG_EP2RC_SW_INT_ACK);
+			t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+		} else {
+			t7xx_mhccif_mask_clr(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+		}
+
+		spin_unlock_irqrestore(&md->exp_lock, flags);
+
+		t7xx_mhccif_mask_clr(md->t7xx_dev,
+				     D2H_INT_EXCEPTION_INIT |
+				     D2H_INT_EXCEPTION_INIT_DONE |
+				     D2H_INT_EXCEPTION_CLEARQ_DONE |
+				     D2H_INT_EXCEPTION_ALLQ_RESET);
+		break;
+
+	case FSM_READY:
+		t7xx_mhccif_mask_set(md->t7xx_dev, D2H_INT_ASYNC_MD_HK);
+		break;
+
+	default:
+		break;
+	}
+}
+
+void t7xx_md_exception_handshake(struct t7xx_modem *md)
+{
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	int ret;
+
+	t7xx_md_exception(md, HIF_EX_INIT);
+	ret = t7xx_wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_INIT_DONE);
+	if (ret)
+		dev_err(dev, "EX CCIF HS timeout, RCH 0x%lx\n", D2H_INT_EXCEPTION_INIT_DONE);
+
+	t7xx_md_exception(md, HIF_EX_INIT_DONE);
+	ret = t7xx_wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_CLEARQ_DONE);
+	if (ret)
+		dev_err(dev, "EX CCIF HS timeout, RCH 0x%lx\n", D2H_INT_EXCEPTION_CLEARQ_DONE);
+
+	t7xx_md_exception(md, HIF_EX_CLEARQ_DONE);
+	ret = t7xx_wait_hif_ex_hk_event(md, D2H_INT_EXCEPTION_ALLQ_RESET);
+	if (ret)
+		dev_err(dev, "EX CCIF HS timeout, RCH 0x%lx\n", D2H_INT_EXCEPTION_ALLQ_RESET);
+
+	t7xx_md_exception(md, HIF_EX_ALLQ_RESET);
+}
+
+static struct t7xx_modem *t7xx_md_alloc(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct device *dev = &t7xx_dev->pdev->dev;
+	struct t7xx_modem *md;
+
+	md = devm_kzalloc(dev, sizeof(*md), GFP_KERNEL);
+	if (!md)
+		return NULL;
+
+	md->t7xx_dev = t7xx_dev;
+	t7xx_dev->md = md;
+	md->core_md.ready = false;
+	spin_lock_init(&md->exp_lock);
+	md->handshake_wq = alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI,
+					   0, "md_hk_wq");
+	if (!md->handshake_wq)
+		return NULL;
+
+	INIT_WORK(&md->handshake_work, t7xx_md_hk_wq);
+	return md;
+}
+
+void t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct t7xx_modem *md = t7xx_dev->md;
+
+	md->md_init_finish = false;
+	md->exp_id = 0;
+	spin_lock_init(&md->exp_lock);
+	t7xx_fsm_reset(md);
+	t7xx_cldma_reset(md->md_ctrl[ID_CLDMA1]);
+	md->md_init_finish = true;
+}
+
+/**
+ * t7xx_md_init() - Initialize modem.
+ * @t7xx_dev: MTK device.
+ *
+ * Allocate and initialize MD control block, and initialize data path.
+ * Register MHCCIF ISR and RGU ISR, and start the state machine.
+ *
+ * Return:
+ ** 0		- Success.
+ ** -ENOMEM	- Allocation failure.
+ */
+int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct t7xx_modem *md;
+	int ret;
+
+	md = t7xx_md_alloc(t7xx_dev);
+	if (!md)
+		return -ENOMEM;
+
+	ret = t7xx_cldma_alloc(ID_CLDMA1, t7xx_dev);
+	if (ret)
+		goto err_destroy_hswq;
+
+	ret = t7xx_fsm_init(md);
+	if (ret)
+		goto err_destroy_hswq;
+
+	ret = t7xx_cldma_init(md, md->md_ctrl[ID_CLDMA1]);
+	if (ret)
+		goto err_uninit_fsm;
+
+	t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_START, 0);
+	t7xx_md_sys_sw_init(t7xx_dev);
+	md->md_init_finish = true;
+	return 0;
+
+err_uninit_fsm:
+	t7xx_fsm_uninit(md);
+
+err_destroy_hswq:
+	destroy_workqueue(md->handshake_wq);
+	dev_err(&t7xx_dev->pdev->dev, "Modem init failed\n");
+	return ret;
+}
+
+void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct t7xx_modem *md = t7xx_dev->md;
+
+	t7xx_pcie_mac_clear_int(t7xx_dev, SAP_RGU_INT);
+
+	if (!md->md_init_finish)
+		return;
+
+	t7xx_fsm_append_cmd(md->fsm_ctl, FSM_CMD_PRE_STOP, FSM_CMD_FLAG_WAIT_FOR_COMPLETION);
+	t7xx_cldma_exit(md->md_ctrl[ID_CLDMA1]);
+	t7xx_fsm_uninit(md);
+	destroy_workqueue(md->handshake_wq);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.h b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
new file mode 100644
index 000000000000..24d2ee5bfbda
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_MODEM_OPS_H__
+#define __T7XX_MODEM_OPS_H__
+
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+#include "t7xx_common.h"
+#include "t7xx_pci.h"
+
+#define FEATURE_COUNT		64
+
+/**
+ * enum hif_ex_stage -	HIF exception handshake stages with the HW.
+ * @HIF_EX_INIT:        Disable and clear TXQ.
+ * @HIF_EX_INIT_DONE:   Polling for initialization to be done.
+ * @HIF_EX_CLEARQ_DONE: Disable RX, flush TX/RX workqueues and clear RX.
+ * @HIF_EX_ALLQ_RESET:  HW is back in safe mode for re-initialization and restart.
+ */
+enum hif_ex_stage {
+	HIF_EX_INIT,
+	HIF_EX_INIT_DONE,
+	HIF_EX_CLEARQ_DONE,
+	HIF_EX_ALLQ_RESET,
+};
+
+struct mtk_runtime_feature {
+	u8				feature_id;
+	u8				support_info;
+	u8				reserved[2];
+	__le32				data_len;
+};
+
+enum md_event_id {
+	FSM_PRE_START,
+	FSM_START,
+	FSM_READY,
+};
+
+struct t7xx_sys_info {
+	bool				ready;
+};
+
+struct t7xx_modem {
+	struct cldma_ctrl		*md_ctrl[CLDMA_NUM];
+	struct t7xx_pci_dev		*t7xx_dev;
+	struct t7xx_sys_info		core_md;
+	bool				md_init_finish;
+	bool				rgu_irq_asserted;
+	struct workqueue_struct		*handshake_wq;
+	struct work_struct		handshake_work;
+	struct t7xx_fsm_ctl		*fsm_ctl;
+	struct port_proxy		*port_prox;
+	unsigned int			exp_id;
+	spinlock_t			exp_lock; /* Protects exception events */
+};
+
+void t7xx_md_exception_handshake(struct t7xx_modem *md);
+void t7xx_md_event_notify(struct t7xx_modem *md, enum md_event_id evt_id);
+void t7xx_md_reset(struct t7xx_pci_dev *t7xx_dev);
+int t7xx_md_init(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_md_exit(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_clear_rgu_irq(struct t7xx_pci_dev *t7xx_dev);
+int t7xx_acpi_fldr_func(struct t7xx_pci_dev *t7xx_dev);
+int t7xx_pci_mhccif_isr(struct t7xx_pci_dev *t7xx_dev);
+
+#endif	/* __T7XX_MODEM_OPS_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
new file mode 100644
index 000000000000..6dd8897dfcbb
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -0,0 +1,223 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ */
+
+#include <linux/atomic.h>
+#include <linux/bits.h>
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/gfp.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+
+#define PCI_IREG_BASE			0
+#define PCI_EREG_BASE			2
+
+static int t7xx_request_irq(struct pci_dev *pdev)
+{
+	struct t7xx_pci_dev *t7xx_dev;
+	int ret, i;
+
+	t7xx_dev = pci_get_drvdata(pdev);
+
+	for (i = 0; i < EXT_INT_NUM; i++) {
+		const char *irq_descr;
+		int irq_vec;
+
+		if (!t7xx_dev->intr_handler[i])
+			continue;
+
+		irq_descr = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%s_%d",
+					   dev_driver_string(&pdev->dev), i);
+		if (!irq_descr) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		irq_vec = pci_irq_vector(pdev, i);
+		ret = request_threaded_irq(irq_vec, t7xx_dev->intr_handler[i],
+					   t7xx_dev->intr_thread[i], 0, irq_descr,
+					   t7xx_dev->callback_param[i]);
+		if (ret) {
+			dev_err(&pdev->dev, "Failed to request IRQ: %d\n", ret);
+			break;
+		}
+	}
+
+	if (ret) {
+		while (i--) {
+			if (!t7xx_dev->intr_handler[i])
+				continue;
+
+			free_irq(pci_irq_vector(pdev, i), t7xx_dev->callback_param[i]);
+		}
+	}
+
+	return ret;
+}
+
+static int t7xx_setup_msix(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct pci_dev *pdev = t7xx_dev->pdev;
+	int ret;
+
+	/* Only using 6 interrupts, but HW-design requires power-of-2 IRQs allocation */
+	ret = pci_alloc_irq_vectors(pdev, EXT_INT_NUM, EXT_INT_NUM, PCI_IRQ_MSIX);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to allocate MSI-X entry: %d\n", ret);
+		return ret;
+	}
+
+	ret = t7xx_request_irq(pdev);
+	if (ret) {
+		pci_free_irq_vectors(pdev);
+		return ret;
+	}
+
+	t7xx_pcie_set_mac_msix_cfg(t7xx_dev, EXT_INT_NUM);
+	return 0;
+}
+
+static int t7xx_interrupt_init(struct t7xx_pci_dev *t7xx_dev)
+{
+	int ret, i;
+
+	if (!t7xx_dev->pdev->msix_cap)
+		return -EINVAL;
+
+	ret = t7xx_setup_msix(t7xx_dev);
+	if (ret)
+		return ret;
+
+	/* IPs enable interrupts when ready */
+	for (i = EXT_INT_START; i < EXT_INT_START + EXT_INT_NUM; i++)
+		PCIE_MAC_MSIX_MSK_SET(t7xx_dev, i);
+
+	return 0;
+}
+
+static void t7xx_pci_infracfg_ao_calc(struct t7xx_pci_dev *t7xx_dev)
+{
+	t7xx_dev->base_addr.infracfg_ao_base = t7xx_dev->base_addr.pcie_ext_reg_base +
+					      INFRACFG_AO_DEV_CHIP -
+					      t7xx_dev->base_addr.pcie_dev_reg_trsl_addr;
+}
+
+static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct t7xx_pci_dev *t7xx_dev;
+	int ret;
+
+	t7xx_dev = devm_kzalloc(&pdev->dev, sizeof(*t7xx_dev), GFP_KERNEL);
+	if (!t7xx_dev)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, t7xx_dev);
+	t7xx_dev->pdev = pdev;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	ret = pcim_iomap_regions(pdev, BIT(PCI_IREG_BASE) | BIT(PCI_EREG_BASE), pci_name(pdev));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not request BARs: %d\n", ret);
+		return -ENOMEM;
+	}
+
+	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set PCI DMA mask: %d\n", ret);
+		return ret;
+	}
+
+	ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
+	if (ret) {
+		dev_err(&pdev->dev, "Could not set consistent PCI DMA mask: %d\n", ret);
+		return ret;
+	}
+
+	IREG_BASE(t7xx_dev) = pcim_iomap_table(pdev)[PCI_IREG_BASE];
+	t7xx_dev->base_addr.pcie_ext_reg_base = pcim_iomap_table(pdev)[PCI_EREG_BASE];
+
+	t7xx_pcie_mac_atr_init(t7xx_dev);
+	t7xx_pci_infracfg_ao_calc(t7xx_dev);
+	t7xx_mhccif_init(t7xx_dev);
+
+	ret = t7xx_md_init(t7xx_dev);
+	if (ret)
+		return ret;
+
+	t7xx_pcie_mac_interrupts_dis(t7xx_dev);
+
+	ret = t7xx_interrupt_init(t7xx_dev);
+	if (ret)
+		return ret;
+
+	t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
+	t7xx_pcie_mac_interrupts_en(t7xx_dev);
+
+	return 0;
+}
+
+static void t7xx_pci_remove(struct pci_dev *pdev)
+{
+	struct t7xx_pci_dev *t7xx_dev;
+	int i;
+
+	t7xx_dev = pci_get_drvdata(pdev);
+	t7xx_md_exit(t7xx_dev);
+
+	for (i = 0; i < EXT_INT_NUM; i++) {
+		if (!t7xx_dev->intr_handler[i])
+			continue;
+
+		free_irq(pci_irq_vector(pdev, i), t7xx_dev->callback_param[i]);
+	}
+
+	pci_free_irq_vectors(t7xx_dev->pdev);
+}
+
+static const struct pci_device_id t7xx_pci_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x4d75) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, t7xx_pci_table);
+
+static struct pci_driver t7xx_pci_driver = {
+	.name = "mtk_t7xx",
+	.id_table = t7xx_pci_table,
+	.probe = t7xx_pci_probe,
+	.remove = t7xx_pci_remove,
+};
+
+module_pci_driver(t7xx_pci_driver);
+
+MODULE_AUTHOR("MediaTek Inc");
+MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem T7xx driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.h b/drivers/net/wwan/t7xx/t7xx_pci.h
new file mode 100644
index 000000000000..b52aaa182a10
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pci.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ */
+
+#ifndef __T7XX_PCI_H__
+#define __T7XX_PCI_H__
+
+#include <linux/irqreturn.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+
+#include "t7xx_reg.h"
+
+/* struct t7xx_addr_base - holds base addresses
+ * @pcie_mac_ireg_base: PCIe MAC register base
+ * @pcie_ext_reg_base: used to calculate base addresses for CLDMA, DPMA and MHCCIF registers
+ * @pcie_dev_reg_trsl_addr: used to calculate the register base address
+ * @infracfg_ao_base: base address used in CLDMA reset operations
+ * @mhccif_rc_base: host view of MHCCIF rc base addr
+ */
+struct t7xx_addr_base {
+	void __iomem		*pcie_mac_ireg_base;
+	void __iomem		*pcie_ext_reg_base;
+	u32			pcie_dev_reg_trsl_addr;
+	void __iomem		*infracfg_ao_base;
+	void __iomem		*mhccif_rc_base;
+};
+
+typedef irqreturn_t (*t7xx_intr_callback)(int irq, void *param);
+
+/* struct t7xx_pci_dev - MTK device context structure
+ * @intr_handler: array of handler function for request_threaded_irq
+ * @intr_thread: array of thread_fn for request_threaded_irq
+ * @callback_param: array of cookie passed back to interrupt functions
+ * @mhccif_bitmask: device to host interrupt mask
+ * @pdev: PCI device
+ * @base_addr: memory base addresses of HW components
+ * @md: modem interface
+ * @ccmni_ctlb: context structure used to control the network data path
+ * @rgu_pci_irq_en: RGU callback isr registered and active
+ * @pools: pre allocated skb pools
+ */
+struct t7xx_pci_dev {
+	t7xx_intr_callback	intr_handler[EXT_INT_NUM];
+	t7xx_intr_callback	intr_thread[EXT_INT_NUM];
+	void			*callback_param[EXT_INT_NUM];
+	u32			mhccif_bitmask;
+	struct pci_dev		*pdev;
+	struct t7xx_addr_base	base_addr;
+	struct t7xx_modem	*md;
+	struct t7xx_ccmni_ctrl	*ccmni_ctlb;
+	bool			rgu_pci_irq_en;
+};
+
+#endif /* __T7XX_PCI_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_pcie_mac.c b/drivers/net/wwan/t7xx/t7xx_pcie_mac.c
new file mode 100644
index 000000000000..fa5effa4e07a
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pcie_mac.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/bitops.h>
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include <linux/types.h>
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
+#define PCIE_DEV_DMA_TRSL_ADDR		0
+#define PCIE_DEV_DMA_SRC_ADDR		0
+#define PCIE_DEV_DMA_TRANSPARENT	1
+#define PCIE_DEV_DMA_SIZE		0
+
+enum t7xx_atr_src_port {
+	ATR_SRC_PCI_WIN0,
+	ATR_SRC_PCI_WIN1,
+	ATR_SRC_AXIS_0,
+	ATR_SRC_AXIS_1,
+	ATR_SRC_AXIS_2,
+	ATR_SRC_AXIS_3,
+};
+
+enum t7xx_atr_dst_port {
+	ATR_DST_PCI_TRX,
+	ATR_DST_PCI_CONFIG,
+	ATR_DST_AXIM_0 = 4,
+	ATR_DST_AXIM_1,
+	ATR_DST_AXIM_2,
+	ATR_DST_AXIM_3,
+};
+
+struct t7xx_atr_config {
+	u64			src_addr;
+	u64			trsl_addr;
+	u64			size;
+	u32			port;
+	u32			table;
+	enum t7xx_atr_dst_port	trsl_id;
+	u32			transparent;
+};
+
+static void t7xx_pcie_mac_atr_tables_dis(void __iomem *pbase, enum t7xx_atr_src_port port)
+{
+	void __iomem *reg;
+	int i, offset;
+
+	for (i = 0; i < ATR_TABLE_NUM_PER_ATR; i++) {
+		offset = ATR_PORT_OFFSET * port + ATR_TABLE_OFFSET * i;
+		reg = pbase + ATR_PCIE_WIN0_T0_ATR_PARAM_SRC_ADDR + offset;
+		iowrite64(0, reg);
+	}
+}
+
+static int t7xx_pcie_mac_atr_cfg(struct t7xx_pci_dev *t7xx_dev, struct t7xx_atr_config *cfg)
+{
+	struct device *dev = &t7xx_dev->pdev->dev;
+	void __iomem *pbase = IREG_BASE(t7xx_dev);
+	int atr_size, pos, offset;
+	void __iomem *reg;
+	u64 value;
+
+	if (cfg->transparent) {
+		/* No address conversion is performed */
+		atr_size = ATR_TRANSPARENT_SIZE;
+	} else {
+		if (cfg->src_addr & (cfg->size - 1)) {
+			dev_err(dev, "Source address is not aligned to size\n");
+			return -EINVAL;
+		}
+
+		if (cfg->trsl_addr & (cfg->size - 1)) {
+			dev_err(dev, "Translation address %llx is not aligned to size %llx\n",
+				cfg->trsl_addr, cfg->size - 1);
+			return -EINVAL;
+		}
+
+		pos = __ffs64(cfg->size);
+
+		/* HW calculates the address translation space as 2^(atr_size + 1) */
+		atr_size = pos - 1;
+	}
+
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
+	/* Ensure ATR is set */
+	ioread64(reg);
+	return 0;
+}
+
+/**
+ * t7xx_pcie_mac_atr_init() - Initialize address translation.
+ * @t7xx_dev: MTK device.
+ *
+ * Setup ATR for ports & device.
+ */
+void t7xx_pcie_mac_atr_init(struct t7xx_pci_dev *t7xx_dev)
+{
+	struct t7xx_atr_config cfg;
+	u32 i;
+
+	/* Disable for all ports */
+	for (i = ATR_SRC_PCI_WIN0; i <= ATR_SRC_AXIS_3; i++)
+		t7xx_pcie_mac_atr_tables_dis(IREG_BASE(t7xx_dev), i);
+
+	memset(&cfg, 0, sizeof(cfg));
+	/* Config ATR for RC to access device's register */
+	cfg.src_addr = pci_resource_start(t7xx_dev->pdev, PCIE_REG_BAR);
+	cfg.size = PCIE_REG_SIZE_CHIP;
+	cfg.trsl_addr = PCIE_REG_TRSL_ADDR_CHIP;
+	cfg.port = PCIE_REG_PORT;
+	cfg.table = PCIE_REG_TABLE_NUM;
+	cfg.trsl_id = PCIE_REG_TRSL_PORT;
+	t7xx_pcie_mac_atr_tables_dis(IREG_BASE(t7xx_dev), cfg.port);
+	t7xx_pcie_mac_atr_cfg(t7xx_dev, &cfg);
+
+	t7xx_dev->base_addr.pcie_dev_reg_trsl_addr = PCIE_REG_TRSL_ADDR_CHIP;
+
+	/* Config ATR for EP to access RC's memory */
+	for (i = PCIE_DEV_DMA_PORT_START; i <= PCIE_DEV_DMA_PORT_END; i++) {
+		cfg.src_addr = PCIE_DEV_DMA_SRC_ADDR;
+		cfg.size = PCIE_DEV_DMA_SIZE;
+		cfg.trsl_addr = PCIE_DEV_DMA_TRSL_ADDR;
+		cfg.port = i;
+		cfg.table = PCIE_DEV_DMA_TABLE_NUM;
+		cfg.trsl_id = ATR_DST_PCI_TRX;
+		cfg.transparent = PCIE_DEV_DMA_TRANSPARENT;
+		t7xx_pcie_mac_atr_tables_dis(IREG_BASE(t7xx_dev), cfg.port);
+		t7xx_pcie_mac_atr_cfg(t7xx_dev, &cfg);
+	}
+}
+
+/**
+ * t7xx_pcie_mac_enable_disable_int() - Enable/disable interrupts.
+ * @t7xx_dev: MTK device.
+ * @enable: Enable/disable.
+ *
+ * Enable or disable device interrupts.
+ */
+static void t7xx_pcie_mac_enable_disable_int(struct t7xx_pci_dev *t7xx_dev, bool enable)
+{
+	u32 value;
+
+	value = ioread32(IREG_BASE(t7xx_dev) + ISTAT_HST_CTRL);
+
+	if (enable)
+		value &= ~ISTAT_HST_CTRL_DIS;
+	else
+		value |= ISTAT_HST_CTRL_DIS;
+
+	iowrite32(value, IREG_BASE(t7xx_dev) + ISTAT_HST_CTRL);
+}
+
+void t7xx_pcie_mac_interrupts_en(struct t7xx_pci_dev *t7xx_dev)
+{
+	t7xx_pcie_mac_enable_disable_int(t7xx_dev, true);
+}
+
+void t7xx_pcie_mac_interrupts_dis(struct t7xx_pci_dev *t7xx_dev)
+{
+	t7xx_pcie_mac_enable_disable_int(t7xx_dev, false);
+}
+
+/**
+ * t7xx_pcie_mac_clear_set_int() - Clear/set interrupt by type.
+ * @t7xx_dev: MTK device.
+ * @int_type: Interrupt type.
+ * @clear: Clear/set.
+ *
+ * Clear or set device interrupt by type.
+ */
+static void t7xx_pcie_mac_clear_set_int(struct t7xx_pci_dev *t7xx_dev,
+					enum pcie_int int_type, bool clear)
+{
+	void __iomem *reg;
+	u32 val;
+
+	if (t7xx_dev->pdev->msix_enabled) {
+		if (clear)
+			reg = IREG_BASE(t7xx_dev) + IMASK_HOST_MSIX_CLR_GRP0_0;
+		else
+			reg = IREG_BASE(t7xx_dev) + IMASK_HOST_MSIX_SET_GRP0_0;
+	} else {
+		if (clear)
+			reg = IREG_BASE(t7xx_dev) + INT_EN_HST_CLR;
+		else
+			reg = IREG_BASE(t7xx_dev) + INT_EN_HST_SET;
+	}
+
+	val = BIT(EXT_INT_START + int_type);
+	iowrite32(val, reg);
+}
+
+void t7xx_pcie_mac_clear_int(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type)
+{
+	t7xx_pcie_mac_clear_set_int(t7xx_dev, int_type, true);
+}
+
+void t7xx_pcie_mac_set_int(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type)
+{
+	t7xx_pcie_mac_clear_set_int(t7xx_dev, int_type, false);
+}
+
+/**
+ * t7xx_pcie_mac_clear_int_status() - Clear interrupt status by type.
+ * @t7xx_dev: MTK device.
+ * @int_type: Interrupt type.
+ *
+ * Enable or disable device interrupts' status by type.
+ */
+void t7xx_pcie_mac_clear_int_status(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type)
+{
+	void __iomem *reg;
+	u32 val;
+
+	if (t7xx_dev->pdev->msix_enabled)
+		reg = IREG_BASE(t7xx_dev) + MSIX_ISTAT_HST_GRP0_0;
+	else
+		reg = IREG_BASE(t7xx_dev) + ISTAT_HST;
+
+	val = BIT(EXT_INT_START + int_type);
+	iowrite32(val, reg);
+}
+
+/**
+ * t7xx_pcie_set_mac_msix_cfg() - Write MSIX control configuration.
+ * @t7xx_dev: MTK device.
+ * @irq_count: Number of MSIX IRQ vectors.
+ *
+ * Write IRQ count to device.
+ */
+void t7xx_pcie_set_mac_msix_cfg(struct t7xx_pci_dev *t7xx_dev, unsigned int irq_count)
+{
+	u32 val;
+
+	val = ffs(irq_count) * 2 - 1;
+	iowrite32(val, IREG_BASE(t7xx_dev) + PCIE_CFG_MSIX);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_pcie_mac.h b/drivers/net/wwan/t7xx/t7xx_pcie_mac.h
new file mode 100644
index 000000000000..7cb6942fd44f
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_pcie_mac.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ *
+ * Contributors:
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ */
+
+#ifndef __T7XX_PCIE_MAC_H__
+#define __T7XX_PCIE_MAC_H__
+
+#include <linux/bits.h>
+#include <linux/io.h>
+
+#include "t7xx_pci.h"
+#include "t7xx_reg.h"
+
+#define IREG_BASE(t7xx_dev)	((t7xx_dev)->base_addr.pcie_mac_ireg_base)
+
+#define PCIE_MAC_MSIX_MSK_SET(t7xx_dev, ext_id)	\
+	iowrite32(BIT(ext_id), IREG_BASE(t7xx_dev) + IMASK_HOST_MSIX_SET_GRP0_0)
+
+void t7xx_pcie_mac_interrupts_en(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_pcie_mac_interrupts_dis(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_pcie_mac_atr_init(struct t7xx_pci_dev *t7xx_dev);
+void t7xx_pcie_mac_clear_int(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type);
+void t7xx_pcie_mac_set_int(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type);
+void t7xx_pcie_mac_clear_int_status(struct t7xx_pci_dev *t7xx_dev, enum pcie_int int_type);
+void t7xx_pcie_set_mac_msix_cfg(struct t7xx_pci_dev *t7xx_dev, unsigned int irq_count);
+
+#endif /* __T7XX_PCIE_MAC_H__ */
diff --git a/drivers/net/wwan/t7xx/t7xx_reg.h b/drivers/net/wwan/t7xx/t7xx_reg.h
new file mode 100644
index 000000000000..ba2127ca8501
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_reg.h
@@ -0,0 +1,379 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
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
+/* Bits 6-10 are reserved */
+#define D2H_INT_SUSPEND_ACK			BIT(11)
+#define D2H_INT_RESUME_ACK			BIT(12)
+#define D2H_INT_SUSPEND_ACK_AP			BIT(13)
+#define D2H_INT_RESUME_ACK_AP			BIT(14)
+#define D2H_INT_ASYNC_SAP_HK			BIT(15)
+#define D2H_INT_ASYNC_MD_HK			BIT(16)
+
+/* EP part */
+
+/* Register base */
+#define INFRACFG_AO_DEV_CHIP			0x10001000
+
+/* ATR setting */
+#define PCIE_REG_TRSL_ADDR_CHIP			0x10000000
+#define PCIE_REG_SIZE_CHIP			0x00400000
+
+/* Reset Generic Unit (RGU) */
+#define TOPRGU_CH_PCIE_IRQ_STA			0x1000790c
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
+
+enum t7xx_pm_resume_state {
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
+
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
+/* DPMAIF UL */
+#define DPMAIF_UL_ADD_DESC			(BASE_DPMAIF_UL + 0x00)
+#define DPMAIF_UL_CHK_BUSY			(BASE_DPMAIF_UL + 0x88)
+#define DPMAIF_UL_RESERVE_AO_RW			(BASE_DPMAIF_UL + 0xac)
+#define DPMAIF_UL_ADD_DESC_CH0			(BASE_DPMAIF_UL + 0xb0)
+
+/* DPMAIF DL */
+#define DPMAIF_DL_BAT_INIT			(BASE_DPMAIF_DL + 0x00)
+#define DPMAIF_DL_BAT_ADD			(BASE_DPMAIF_DL + 0x04)
+#define DPMAIF_DL_BAT_INIT_CON0			(BASE_DPMAIF_DL + 0x08)
+#define DPMAIF_DL_BAT_INIT_CON1			(BASE_DPMAIF_DL + 0x0c)
+#define DPMAIF_DL_BAT_INIT_CON2			(BASE_DPMAIF_DL + 0x10)
+#define DPMAIF_DL_BAT_INIT_CON3			(BASE_DPMAIF_DL + 0x50)
+#define DPMAIF_DL_CHK_BUSY			(BASE_DPMAIF_DL + 0xb4)
+
+/* DPMAIF AP misc */
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
+/* DPMAIF AO UL */
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
+/* DPMAIF PD SRAM UL */
+#define DPMAIF_AO_UL_CHNL0_CON0			(BASE_DPMAIF_PD_SRAM_UL + 0x10)
+#define DPMAIF_AO_UL_CHNL0_CON1			(BASE_DPMAIF_PD_SRAM_UL + 0x14)
+#define DPMAIF_AO_UL_CHNL0_CON2			(BASE_DPMAIF_PD_SRAM_UL + 0x18)
+#define DPMAIF_AO_UL_CH0_STA			(BASE_DPMAIF_PD_SRAM_UL + 0x70)
+
+/* DPMAIF AO DL */
+#define DPMAIF_AO_DL_INIT_SET			(BASE_DPMAIF_AO_DL + 0x00)
+#define DPMAIF_AO_DL_IRQ_MASK			(BASE_DPMAIF_AO_DL + 0x0c)
+#define DPMAIF_AO_DL_DLQPIT_INIT_CON5		(BASE_DPMAIF_AO_DL + 0x28)
+#define DPMAIF_AO_DL_DLQPIT_TRIG_THRES		(BASE_DPMAIF_AO_DL + 0x34)
+
+/* DPMAIF PD SRAM DL */
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
+/* DPMAIF HPC */
+#define DPMAIF_HPC_INTR_MASK			(BASE_DPMAIF_MMW_HPC + 0x0f4)
+#define DPMA_HPC_ALL_INT_MASK			GENMASK(15, 0)
+
+#define DPMAIF_HPC_DLQ_PATH_MODE		3
+#define DPMAIF_HPC_ADD_MODE_DF			0
+#define DPMAIF_HPC_TOTAL_NUM			8
+#define DPMAIF_HPC_MAX_TOTAL_NUM		8
+
+/* DPMAIF DL queue */
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
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
new file mode 100644
index 000000000000..a353eac3e23b
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
@@ -0,0 +1,539 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *
+ * Contributors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/bitfield.h>
+#include <linux/completion.h>
+#include <linux/dev_printk.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/iopoll.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include "t7xx_hif_cldma.h"
+#include "t7xx_mhccif.h"
+#include "t7xx_modem_ops.h"
+#include "t7xx_pci.h"
+#include "t7xx_pcie_mac.h"
+#include "t7xx_reg.h"
+#include "t7xx_state_monitor.h"
+
+#define FSM_DRM_DISABLE_DELAY_MS		200
+#define FSM_EVENT_POLL_INTERVAL_MS		20
+#define FSM_MD_EX_REC_OK_TIMEOUT_MS		10000
+#define FSM_MD_EX_PASS_TIMEOUT_MS		45000
+#define FSM_CMD_TIMEOUT_MS			2000
+
+void t7xx_fsm_notifier_register(struct t7xx_modem *md, struct t7xx_fsm_notifier *notifier)
+{
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctl->notifier_lock, flags);
+	list_add_tail(&notifier->entry, &ctl->notifier_list);
+	spin_unlock_irqrestore(&ctl->notifier_lock, flags);
+}
+
+void t7xx_fsm_notifier_unregister(struct t7xx_modem *md, struct t7xx_fsm_notifier *notifier)
+{
+	struct t7xx_fsm_notifier *notifier_cur, *notifier_next;
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctl->notifier_lock, flags);
+	list_for_each_entry_safe(notifier_cur, notifier_next, &ctl->notifier_list, entry) {
+		if (notifier_cur == notifier)
+			list_del(&notifier->entry);
+	}
+
+	spin_unlock_irqrestore(&ctl->notifier_lock, flags);
+}
+
+static void fsm_state_notify(struct t7xx_modem *md, enum md_state state)
+{
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+	struct t7xx_fsm_notifier *notifier;
+	unsigned long flags;
+
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
+void t7xx_fsm_broadcast_state(struct t7xx_fsm_ctl *ctl, enum md_state state)
+{
+	if (ctl->md_state != MD_STATE_WAITING_FOR_HS2 && state == MD_STATE_READY)
+		return;
+
+	ctl->md_state = state;
+
+	fsm_state_notify(ctl->md, state);
+}
+
+static void fsm_finish_command(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd, int result)
+{
+	if (cmd->flag & FSM_CMD_FLAG_WAIT_FOR_COMPLETION) {
+		*cmd->ret = result;
+		complete_all(cmd->done);
+	}
+
+	kfree(cmd);
+}
+
+static void fsm_del_kf_event(struct t7xx_fsm_event *event)
+{
+	list_del(&event->entry);
+	kfree(event);
+}
+
+static void fsm_flush_event_cmd_qs(struct t7xx_fsm_ctl *ctl)
+{
+	struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
+	struct t7xx_fsm_event *event, *evt_next;
+	struct t7xx_fsm_command *cmd, *cmd_next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctl->command_lock, flags);
+	list_for_each_entry_safe(cmd, cmd_next, &ctl->command_queue, entry) {
+		dev_warn(dev, "Unhandled command %d\n", cmd->cmd_id);
+		list_del(&cmd->entry);
+		fsm_finish_command(ctl, cmd, -EINVAL);
+	}
+
+	spin_unlock_irqrestore(&ctl->command_lock, flags);
+	spin_lock_irqsave(&ctl->event_lock, flags);
+	list_for_each_entry_safe(event, evt_next, &ctl->event_queue, entry) {
+		dev_warn(dev, "Unhandled event %d\n", event->event_id);
+		fsm_del_kf_event(event);
+	}
+
+	spin_unlock_irqrestore(&ctl->event_lock, flags);
+}
+
+static void fsm_wait_for_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id,
+			       enum t7xx_fsm_event_state event_ignore, int timeout)
+{
+	struct t7xx_fsm_event *event;
+	unsigned long flags;
+	bool ackd = false;
+	int cnt = 0;
+
+	while (cnt++ < timeout / FSM_EVENT_POLL_INTERVAL_MS) {
+		if (kthread_should_stop())
+			return;
+
+		spin_lock_irqsave(&ctl->event_lock, flags);
+		event = list_first_entry_or_null(&ctl->event_queue,
+						 struct t7xx_fsm_event, entry);
+		if (event) {
+			if (event->event_id == event_ignore) {
+				fsm_del_kf_event(event);
+			} else if (event->event_id == event_id) {
+				ackd = true;
+				fsm_del_kf_event(event);
+			}
+		}
+
+		spin_unlock_irqrestore(&ctl->event_lock, flags);
+		if (ackd)
+			break;
+
+		msleep(FSM_EVENT_POLL_INTERVAL_MS);
+	}
+}
+
+static void fsm_routine_exception(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd,
+				  enum t7xx_ex_reason reason)
+{
+	struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
+
+	dev_err(dev, "Exception %d, from %ps\n", reason, __builtin_return_address(0));
+
+	if (ctl->curr_state != FSM_STATE_READY && ctl->curr_state != FSM_STATE_STARTING) {
+		if (cmd)
+			fsm_finish_command(ctl, cmd, -EINVAL);
+
+		return;
+	}
+
+	ctl->curr_state = FSM_STATE_EXCEPTION;
+
+	switch (reason) {
+	case EXCEPTION_HS_TIMEOUT:
+		dev_err(dev, "BOOT_HS_FAIL\n");
+		break;
+
+	case EXCEPTION_EVENT:
+		t7xx_fsm_broadcast_state(ctl, MD_STATE_EXCEPTION);
+		t7xx_md_exception_handshake(ctl->md);
+
+		fsm_wait_for_event(ctl, FSM_EVENT_MD_EX_REC_OK, FSM_EVENT_MD_EX,
+				   FSM_MD_EX_REC_OK_TIMEOUT_MS);
+		fsm_wait_for_event(ctl, FSM_EVENT_MD_EX_PASS, FSM_EVENT_INVALID,
+				   FSM_MD_EX_PASS_TIMEOUT_MS);
+		break;
+
+	default:
+		break;
+	}
+
+	if (cmd)
+		fsm_finish_command(ctl, cmd, 0);
+}
+
+static void fsm_stopped_handler(struct t7xx_fsm_ctl *ctl)
+{
+	ctl->curr_state = FSM_STATE_STOPPED;
+
+	t7xx_fsm_broadcast_state(ctl, MD_STATE_STOPPED);
+	t7xx_md_reset(ctl->md->t7xx_dev);
+}
+
+static void fsm_routine_stopped(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
+{
+	if (ctl->curr_state == FSM_STATE_STOPPED) {
+		fsm_finish_command(ctl, cmd, -EINVAL);
+		return;
+	}
+
+	fsm_stopped_handler(ctl);
+	fsm_finish_command(ctl, cmd, 0);
+}
+
+static void fsm_routine_stopping(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
+{
+	struct t7xx_pci_dev *t7xx_dev;
+	struct cldma_ctrl *md_ctrl;
+	int err;
+
+	if (ctl->curr_state == FSM_STATE_STOPPED || ctl->curr_state == FSM_STATE_STOPPING) {
+		fsm_finish_command(ctl, cmd, -EINVAL);
+		return;
+	}
+
+	md_ctrl = ctl->md->md_ctrl[ID_CLDMA1];
+	t7xx_dev = ctl->md->t7xx_dev;
+
+	ctl->curr_state = FSM_STATE_STOPPING;
+	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_TO_STOP);
+	t7xx_cldma_stop(md_ctrl);
+
+	if (!ctl->md->rgu_irq_asserted) {
+		t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DRM_DISABLE_AP);
+		/* Wait for the DRM disable to take effect */
+		msleep(FSM_DRM_DISABLE_DELAY_MS);
+
+		err = t7xx_acpi_fldr_func(t7xx_dev);
+		if (err)
+			t7xx_mhccif_h2d_swint_trigger(t7xx_dev, H2D_CH_DEVICE_RESET);
+	}
+
+	fsm_stopped_handler(ctl);
+	fsm_finish_command(ctl, cmd, 0);
+}
+
+static void fsm_routine_ready(struct t7xx_fsm_ctl *ctl)
+{
+	struct t7xx_modem *md = ctl->md;
+
+	ctl->curr_state = FSM_STATE_READY;
+	t7xx_fsm_broadcast_state(ctl, MD_STATE_READY);
+	t7xx_md_event_notify(md, FSM_READY);
+}
+
+static void fsm_routine_starting(struct t7xx_fsm_ctl *ctl)
+{
+	struct t7xx_modem *md = ctl->md;
+	struct device *dev;
+
+	ctl->curr_state = FSM_STATE_STARTING;
+
+	t7xx_fsm_broadcast_state(ctl, MD_STATE_WAITING_FOR_HS1);
+	t7xx_md_event_notify(md, FSM_START);
+
+	wait_event_interruptible_timeout(ctl->async_hk_wq, md->core_md.ready || ctl->exp_flg,
+					 HZ * 60);
+	dev = &md->t7xx_dev->pdev->dev;
+
+	if (ctl->exp_flg)
+		dev_err(dev, "MD exception is captured during handshake\n");
+
+	if (!md->core_md.ready) {
+		dev_err(dev, "MD handshake timeout\n");
+		fsm_routine_exception(ctl, NULL, EXCEPTION_HS_TIMEOUT);
+	} else {
+		fsm_routine_ready(ctl);
+	}
+}
+
+static void fsm_routine_start(struct t7xx_fsm_ctl *ctl, struct t7xx_fsm_command *cmd)
+{
+	struct t7xx_modem *md = ctl->md;
+	u32 dev_status;
+	int ret;
+
+	if (!md)
+		return;
+
+	if (ctl->curr_state != FSM_STATE_INIT && ctl->curr_state != FSM_STATE_PRE_START &&
+	    ctl->curr_state != FSM_STATE_STOPPED) {
+		fsm_finish_command(ctl, cmd, -EINVAL);
+		return;
+	}
+
+	ctl->curr_state = FSM_STATE_PRE_START;
+	t7xx_md_event_notify(md, FSM_PRE_START);
+
+	ret = read_poll_timeout(ioread32, dev_status,
+				(dev_status & MISC_STAGE_MASK) == LINUX_STAGE, 20000, 2000000,
+				false, IREG_BASE(md->t7xx_dev) + PCIE_MISC_DEV_STATUS);
+	if (ret) {
+		struct device *dev = &md->t7xx_dev->pdev->dev;
+
+		dev_err(dev, "Invalid device status 0x%lx\n", dev_status & MISC_STAGE_MASK);
+		fsm_finish_command(ctl, cmd, -ETIMEDOUT);
+		return;
+	}
+
+	t7xx_cldma_hif_hw_init(md->md_ctrl[ID_CLDMA1]);
+	fsm_routine_starting(ctl);
+	fsm_finish_command(ctl, cmd, 0);
+}
+
+static int fsm_main_thread(void *data)
+{
+	struct t7xx_fsm_ctl *ctl = data;
+	struct t7xx_fsm_command *cmd;
+	unsigned long flags;
+
+	while (!kthread_should_stop()) {
+		if (wait_event_interruptible(ctl->command_wq, !list_empty(&ctl->command_queue) ||
+					     kthread_should_stop()))
+			continue;
+
+		if (kthread_should_stop())
+			break;
+
+		spin_lock_irqsave(&ctl->command_lock, flags);
+		cmd = list_first_entry(&ctl->command_queue, struct t7xx_fsm_command, entry);
+		list_del(&cmd->entry);
+		spin_unlock_irqrestore(&ctl->command_lock, flags);
+
+		switch (cmd->cmd_id) {
+		case FSM_CMD_START:
+			fsm_routine_start(ctl, cmd);
+			break;
+
+		case FSM_CMD_EXCEPTION:
+			fsm_routine_exception(ctl, cmd, FIELD_GET(FSM_CMD_EX_REASON, cmd->flag));
+			break;
+
+		case FSM_CMD_PRE_STOP:
+			fsm_routine_stopping(ctl, cmd);
+			break;
+
+		case FSM_CMD_STOP:
+			fsm_routine_stopped(ctl, cmd);
+			break;
+
+		default:
+			fsm_finish_command(ctl, cmd, -EINVAL);
+			fsm_flush_event_cmd_qs(ctl);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id, unsigned int flag)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct t7xx_fsm_command *cmd;
+	unsigned long flags;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), flag & FSM_CMD_FLAG_IN_INTERRUPT ? GFP_ATOMIC : GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&cmd->entry);
+	cmd->cmd_id = cmd_id;
+	cmd->flag = flag;
+	if (flag & FSM_CMD_FLAG_WAIT_FOR_COMPLETION) {
+		cmd->done = &done;
+		cmd->ret = &ret;
+	}
+
+	spin_lock_irqsave(&ctl->command_lock, flags);
+	list_add_tail(&cmd->entry, &ctl->command_queue);
+	spin_unlock_irqrestore(&ctl->command_lock, flags);
+
+	wake_up(&ctl->command_wq);
+
+	if (flag & FSM_CMD_FLAG_WAIT_FOR_COMPLETION) {
+		unsigned long wait_ret;
+
+		wait_ret = wait_for_completion_timeout(&done,
+						       msecs_to_jiffies(FSM_CMD_TIMEOUT_MS));
+		if (!wait_ret)
+			return -ETIMEDOUT;
+
+		return ret;
+	}
+
+	return 0;
+}
+
+int t7xx_fsm_append_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id,
+			  unsigned char *data, unsigned int length)
+{
+	struct device *dev = &ctl->md->t7xx_dev->pdev->dev;
+	struct t7xx_fsm_event *event;
+	unsigned long flags;
+
+	if (event_id <= FSM_EVENT_INVALID || event_id >= FSM_EVENT_MAX) {
+		dev_err(dev, "Invalid event %d\n", event_id);
+		return -EINVAL;
+	}
+
+	event = kmalloc(sizeof(*event) + length, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&event->entry);
+	event->event_id = event_id;
+	event->length = length;
+
+	if (data && length)
+		memcpy((void *)event + sizeof(*event), data, length);
+
+	spin_lock_irqsave(&ctl->event_lock, flags);
+	list_add_tail(&event->entry, &ctl->event_queue);
+	spin_unlock_irqrestore(&ctl->event_lock, flags);
+	wake_up_all(&ctl->event_wq);
+	return 0;
+}
+
+void t7xx_fsm_clr_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id)
+{
+	struct t7xx_fsm_event *event, *evt_next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctl->event_lock, flags);
+	list_for_each_entry_safe(event, evt_next, &ctl->event_queue, entry) {
+		if (event->event_id == event_id)
+			fsm_del_kf_event(event);
+	}
+
+	spin_unlock_irqrestore(&ctl->event_lock, flags);
+}
+
+enum md_state t7xx_fsm_get_md_state(struct t7xx_fsm_ctl *ctl)
+{
+	if (ctl)
+		return ctl->md_state;
+
+	return MD_STATE_INVALID;
+}
+
+unsigned int t7xx_fsm_get_ctl_state(struct t7xx_fsm_ctl *ctl)
+{
+	if (ctl)
+		return ctl->curr_state;
+
+	return FSM_STATE_STOPPED;
+}
+
+void t7xx_fsm_recv_md_intr(struct t7xx_fsm_ctl *ctl, enum t7xx_md_irq_type type)
+{
+	unsigned int cmd_flags = FSM_CMD_FLAG_IN_INTERRUPT;
+
+	if (type == MD_IRQ_PORT_ENUM) {
+		t7xx_fsm_append_cmd(ctl, FSM_CMD_START, cmd_flags);
+	} else if (type == MD_IRQ_CCIF_EX) {
+		ctl->exp_flg = true;
+		wake_up(&ctl->async_hk_wq);
+		cmd_flags |= FIELD_PREP(FSM_CMD_EX_REASON, EXCEPTION_EVENT);
+		t7xx_fsm_append_cmd(ctl, FSM_CMD_EXCEPTION, cmd_flags);
+	}
+}
+
+void t7xx_fsm_reset(struct t7xx_modem *md)
+{
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+
+	fsm_flush_event_cmd_qs(ctl);
+	ctl->curr_state = FSM_STATE_STOPPED;
+	ctl->exp_flg = false;
+}
+
+int t7xx_fsm_init(struct t7xx_modem *md)
+{
+	struct device *dev = &md->t7xx_dev->pdev->dev;
+	struct t7xx_fsm_ctl *ctl;
+
+	ctl = devm_kzalloc(dev, sizeof(*ctl), GFP_KERNEL);
+	if (!ctl)
+		return -ENOMEM;
+
+	md->fsm_ctl = ctl;
+	ctl->md = md;
+	ctl->curr_state = FSM_STATE_INIT;
+	INIT_LIST_HEAD(&ctl->command_queue);
+	INIT_LIST_HEAD(&ctl->event_queue);
+	init_waitqueue_head(&ctl->async_hk_wq);
+	init_waitqueue_head(&ctl->event_wq);
+	INIT_LIST_HEAD(&ctl->notifier_list);
+	init_waitqueue_head(&ctl->command_wq);
+	spin_lock_init(&ctl->event_lock);
+	spin_lock_init(&ctl->command_lock);
+	ctl->exp_flg = false;
+	spin_lock_init(&ctl->notifier_lock);
+
+	ctl->fsm_thread = kthread_run(fsm_main_thread, ctl, "t7xx_fsm");
+	return PTR_ERR_OR_ZERO(ctl->fsm_thread);
+}
+
+void t7xx_fsm_uninit(struct t7xx_modem *md)
+{
+	struct t7xx_fsm_ctl *ctl = md->fsm_ctl;
+
+	if (!ctl)
+		return;
+
+	if (ctl->fsm_thread)
+		kthread_stop(ctl->fsm_thread);
+
+	fsm_flush_event_cmd_qs(ctl);
+}
diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.h b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
new file mode 100644
index 000000000000..39c89b10a3bb
--- /dev/null
+++ b/drivers/net/wwan/t7xx/t7xx_state_monitor.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (c) 2021, MediaTek Inc.
+ * Copyright (c) 2021, Intel Corporation.
+ *
+ * Authors:
+ *  Amir Hanania <amir.hanania@intel.com>
+ *  Haijun Liu <haijun.liu@mediatek.com>
+ *  Moises Veleta <moises.veleta@intel.com>
+ *
+ * Contributors:
+ *  Eliot Lee <eliot.lee@intel.com>
+ *  Ricardo Martinez<ricardo.martinez@linux.intel.com>
+ *  Sreehari Kancharla <sreehari.kancharla@intel.com>
+ */
+
+#ifndef __T7XX_MONITOR_H__
+#define __T7XX_MONITOR_H__
+
+#include <linux/bits.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+
+#include "t7xx_common.h"
+#include "t7xx_modem_ops.h"
+
+enum t7xx_fsm_state {
+	FSM_STATE_INIT,
+	FSM_STATE_PRE_START,
+	FSM_STATE_STARTING,
+	FSM_STATE_READY,
+	FSM_STATE_EXCEPTION,
+	FSM_STATE_STOPPING,
+	FSM_STATE_STOPPED,
+};
+
+enum t7xx_fsm_event_state {
+	FSM_EVENT_INVALID,
+	FSM_EVENT_MD_EX,
+	FSM_EVENT_MD_EX_REC_OK,
+	FSM_EVENT_MD_EX_PASS,
+	FSM_EVENT_MAX
+};
+
+enum t7xx_fsm_cmd_state {
+	FSM_CMD_INVALID,
+	FSM_CMD_START,
+	FSM_CMD_EXCEPTION,
+	FSM_CMD_PRE_STOP,
+	FSM_CMD_STOP,
+};
+
+enum t7xx_ex_reason {
+	EXCEPTION_HS_TIMEOUT,
+	EXCEPTION_EVENT,
+};
+
+enum t7xx_md_irq_type {
+	MD_IRQ_WDT,
+	MD_IRQ_CCIF_EX,
+	MD_IRQ_PORT_ENUM,
+};
+
+#define FSM_CMD_FLAG_WAIT_FOR_COMPLETION	BIT(0)
+#define FSM_CMD_FLAG_FLIGHT_MODE		BIT(1)
+#define FSM_CMD_FLAG_IN_INTERRUPT		BIT(2)
+#define FSM_CMD_EX_REASON			GENMASK(23, 16)
+
+struct t7xx_fsm_ctl {
+	struct t7xx_modem	*md;
+	enum md_state		md_state;
+	unsigned int		curr_state;
+	struct list_head	command_queue;
+	struct list_head	event_queue;
+	wait_queue_head_t	command_wq;
+	wait_queue_head_t	event_wq;
+	wait_queue_head_t	async_hk_wq;
+	spinlock_t		event_lock;		/* Protects event queue */
+	spinlock_t		command_lock;		/* Protects command queue */
+	struct task_struct	*fsm_thread;
+	bool			exp_flg;
+	spinlock_t		notifier_lock;		/* Protects notifier list */
+	struct list_head	notifier_list;
+};
+
+struct t7xx_fsm_event {
+	struct list_head	entry;
+	enum t7xx_fsm_event_state event_id;
+	unsigned int		length;
+};
+
+struct t7xx_fsm_command {
+	struct list_head	entry;
+	enum t7xx_fsm_cmd_state	cmd_id;
+	unsigned int		flag;
+	struct completion	*done;
+	int			*ret;
+};
+
+struct t7xx_fsm_notifier {
+	struct list_head	entry;
+	int (*notifier_fn)(enum md_state state, void *data);
+	void			*data;
+};
+
+int t7xx_fsm_append_cmd(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_cmd_state cmd_id,
+			unsigned int flag);
+int t7xx_fsm_append_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id,
+			  unsigned char *data, unsigned int length);
+void t7xx_fsm_clr_event(struct t7xx_fsm_ctl *ctl, enum t7xx_fsm_event_state event_id);
+void t7xx_fsm_broadcast_state(struct t7xx_fsm_ctl *ctl, enum md_state state);
+void t7xx_fsm_reset(struct t7xx_modem *md);
+int t7xx_fsm_init(struct t7xx_modem *md);
+void t7xx_fsm_uninit(struct t7xx_modem *md);
+void t7xx_fsm_recv_md_intr(struct t7xx_fsm_ctl *ctl, enum t7xx_md_irq_type type);
+enum md_state t7xx_fsm_get_md_state(struct t7xx_fsm_ctl *ctl);
+unsigned int t7xx_fsm_get_ctl_state(struct t7xx_fsm_ctl *ctl);
+void t7xx_fsm_notifier_register(struct t7xx_modem *md, struct t7xx_fsm_notifier *notifier);
+void t7xx_fsm_notifier_unregister(struct t7xx_modem *md, struct t7xx_fsm_notifier *notifier);
+
+#endif /* __T7XX_MONITOR_H__ */
-- 
2.17.1

