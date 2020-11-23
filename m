Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE142C0C32
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgKWNvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:51:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:1467 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbgKWNvz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:51:55 -0500
IronPort-SDR: HF5z9zPQznQlLzXPWez9YgSGLp7c8KX22jPQP3VspdtdLtm673FnRDKdtsc18PaevFUCRl4Inn
 P4ZaLgAFO3Uw==
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="170981415"
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="170981415"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2020 05:51:54 -0800
IronPort-SDR: 5NlwpLIH2Qo+ZO4m3d2sJv9cOZw4Ms5LMl1lbdK6O+9XGTWGVF/DnBGT997EKa34yV/arWgTDh
 aPt2YpNJJhKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,363,1599548400"; 
   d="scan'208";a="370035473"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga007.jf.intel.com with ESMTP; 23 Nov 2020 05:51:52 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [RFC 02/18] net: iosm: irq handling
Date:   Mon, 23 Nov 2020 19:21:07 +0530
Message-Id: <20201123135123.48892-3-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20201123135123.48892-1-m.chetan.kumar@intel.com>
References: <20201123135123.48892-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Request interrupt vector, frees allocated resource.
2) Registers IRQ handler.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_irq.c | 95 ++++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_irq.h | 35 +++++++++++++
 2 files changed, 130 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_irq.c b/drivers/net/wwan/iosm/iosm_ipc_irq.c
new file mode 100644
index 000000000000..b9e1bc7959db
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_irq.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include "iosm_ipc_pcie.h"
+#include "iosm_ipc_protocol.h"
+
+/* Write to the specified register offset for doorbell interrupt */
+static inline void write_dbell_reg(struct iosm_pcie *ipc_pcie, int irq_n,
+				   u32 data)
+{
+	void __iomem *write_reg;
+
+	/* Select the first doorbell register, which is only currently needed
+	 * by CP.
+	 */
+	write_reg = (void __iomem *)((u8 __iomem *)ipc_pcie->ipc_regs +
+				     ipc_pcie->doorbell_write +
+				     (irq_n * ipc_pcie->doorbell_reg_offset));
+
+	/* Fire the doorbell irq by writing data on the doorbell write pointer
+	 * register.
+	 */
+	iowrite32(data, write_reg);
+}
+
+void ipc_doorbell_fire(struct iosm_pcie *ipc_pcie, int irq_n, u32 data)
+{
+	if (!ipc_pcie || !ipc_pcie->ipc_regs)
+		return;
+
+	write_dbell_reg(ipc_pcie, irq_n, data);
+}
+
+/* Threaded Interrupt handler for MSI interrupts */
+static irqreturn_t ipc_msi_interrupt(int irq, void *dev_id)
+{
+	struct iosm_pcie *ipc_pcie = dev_id;
+	int instance = irq - ipc_pcie->pci->irq;
+
+	/* Shift the MSI irq actions to the IPC tasklet. IRQ_NONE means the
+	 * irq was not from the IPC device or could not be served.
+	 */
+	if (instance >= ipc_pcie->nvec)
+		return IRQ_NONE;
+
+	ipc_imem_irq_process(ipc_pcie->imem, instance);
+
+	return IRQ_HANDLED;
+}
+
+void ipc_release_irq(struct iosm_pcie *ipc_pcie)
+{
+	struct pci_dev *pdev = ipc_pcie->pci;
+
+	if (pdev->msi_enabled) {
+		while (--ipc_pcie->nvec >= 0)
+			free_irq(pdev->irq + ipc_pcie->nvec, ipc_pcie);
+	}
+	pci_free_irq_vectors(pdev);
+}
+
+int ipc_acquire_irq(struct iosm_pcie *ipc_pcie)
+{
+	struct pci_dev *pdev = ipc_pcie->pci;
+	int i, rc = 0;
+
+	ipc_pcie->nvec = pci_alloc_irq_vectors(pdev, IPC_MSI_VECTORS,
+					       IPC_MSI_VECTORS, PCI_IRQ_MSI);
+
+	if (ipc_pcie->nvec < 0)
+		return ipc_pcie->nvec;
+
+	if (!pdev->msi_enabled) {
+		rc = -1;
+		goto error;
+	}
+
+	for (i = 0; i < ipc_pcie->nvec; ++i) {
+		rc = request_threaded_irq(pdev->irq + i, NULL,
+					  ipc_msi_interrupt, 0, KBUILD_MODNAME,
+					  ipc_pcie);
+		if (rc) {
+			dev_err(ipc_pcie->dev, "unable to grab IRQ %d, rc=%d",
+				pdev->irq, rc);
+			ipc_pcie->nvec = i;
+			ipc_release_irq(ipc_pcie);
+			goto error;
+		}
+	}
+
+error:
+	return rc;
+}
diff --git a/drivers/net/wwan/iosm/iosm_ipc_irq.h b/drivers/net/wwan/iosm/iosm_ipc_irq.h
new file mode 100644
index 000000000000..db207cb95a8a
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_irq.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_IRQ_H
+#define IOSM_IPC_IRQ_H
+
+#include "iosm_ipc_pcie.h"
+
+struct iosm_pcie;
+
+/**
+ * ipc_doorbell_fire - fire doorbell to CP
+ * @ipc_pcie:	Pointer to iosm_pcie
+ * @irq_n:	Doorbell type
+ * @data:	ipc state
+ */
+void ipc_doorbell_fire(struct iosm_pcie *ipc_pcie, int irq_n, u32 data);
+
+/**
+ * ipc_release_irq - Remove the IRQ handler.
+ * @ipc_pcie:	Pointer to iosm_pcie struct
+ */
+void ipc_release_irq(struct iosm_pcie *ipc_pcie);
+
+/**
+ * ipc_acquire_irq - Install the IPC IRQ handler.
+ * @ipc_pcie:	Pointer to iosm_pcie struct
+ *
+ * Return: 0 on success and -1 on failure
+ */
+int ipc_acquire_irq(struct iosm_pcie *ipc_pcie);
+
+#endif
-- 
2.12.3

