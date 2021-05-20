Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D9B38B0F2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbhETOGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:06:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:5047 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236882AbhETOFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:05:33 -0400
IronPort-SDR: ZQWC0PCTR1aNb1STCG943FxhRRswGPzr7qc9KsS2dSWTgCihcMEYVnT0SvsCDEVyJZO3gr0LSL
 xJiwyep5dq6w==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="198144514"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="198144514"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:02:29 -0700
IronPort-SDR: Rbrym9VCfjhVre0Kr3NkVoNKMS3wOS5uhDAIPeAt0LDKfXRJ0sgbnf+mSsjQo300JmiRw9juZx
 b6+YP7KgVgww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="631407459"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2021 07:02:28 -0700
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V3 02/16] net: iosm: irq handling
Date:   Thu, 20 May 2021 19:31:44 +0530
Message-Id: <20210520140158.10132-3-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210520140158.10132-1-m.chetan.kumar@intel.com>
References: <20210520140158.10132-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Request interrupt vector, frees allocated resource.
2) Registers IRQ handler.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
v3:
* Removed inline keyword in .c file.
* Aligned ipc_ prefix for function name to be consistent across file.
v2: Streamline multiple returns using goto.
---
 drivers/net/wwan/iosm/iosm_ipc_irq.c | 90 ++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_irq.h | 33 ++++++++++
 2 files changed, 123 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_irq.c b/drivers/net/wwan/iosm/iosm_ipc_irq.c
new file mode 100644
index 000000000000..702f50a48151
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_irq.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#include "iosm_ipc_pcie.h"
+#include "iosm_ipc_protocol.h"
+
+static void ipc_write_dbell_reg(struct iosm_pcie *ipc_pcie, int irq_n, u32 data)
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
+	ipc_write_dbell_reg(ipc_pcie, irq_n, data);
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
+	if (!test_bit(0, &ipc_pcie->suspend))
+		ipc_imem_irq_process(ipc_pcie->imem, instance);
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
+	int i, rc = -EINVAL;
+
+	ipc_pcie->nvec = pci_alloc_irq_vectors(pdev, IPC_MSI_VECTORS,
+					       IPC_MSI_VECTORS, PCI_IRQ_MSI);
+
+	if (ipc_pcie->nvec < 0) {
+		rc = ipc_pcie->nvec;
+		goto error;
+	}
+
+	if (!pdev->msi_enabled)
+		goto error;
+
+	for (i = 0; i < ipc_pcie->nvec; ++i) {
+		rc = request_threaded_irq(pdev->irq + i, NULL,
+					  ipc_msi_interrupt, IRQF_ONESHOT,
+					  KBUILD_MODNAME, ipc_pcie);
+		if (rc) {
+			dev_err(ipc_pcie->dev, "unable to grab IRQ, rc=%d", rc);
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
index 000000000000..a8ed596cb6a5
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_irq.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ *
+ * Copyright (C) 2020-21 Intel Corporation.
+ */
+
+#ifndef IOSM_IPC_IRQ_H
+#define IOSM_IPC_IRQ_H
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
+ * ipc_release_irq - Release the IRQ handler.
+ * @ipc_pcie:	Pointer to iosm_pcie struct
+ */
+void ipc_release_irq(struct iosm_pcie *ipc_pcie);
+
+/**
+ * ipc_acquire_irq - acquire IRQ & register IRQ handler.
+ * @ipc_pcie:	Pointer to iosm_pcie struct
+ *
+ * Return: 0 on success and failure value on error
+ */
+int ipc_acquire_irq(struct iosm_pcie *ipc_pcie);
+
+#endif
-- 
2.25.1

