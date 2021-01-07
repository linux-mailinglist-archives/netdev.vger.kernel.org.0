Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0B62ED506
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbhAGRGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:06:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:22136 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbhAGRGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:06:31 -0500
IronPort-SDR: YagXXWHE50D2nodM6jfPfTlIIn6CSpnaPP3yEy7XjSThCOA+kRzWuxBodXUy6hFpYgnFQhV9X8
 D+TYvsox4J6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="173951946"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="173951946"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 09:05:50 -0800
IronPort-SDR: hA9pvmmp4vCfTB5Bv6phudHA//hfWofXrhjMGY4VrD+guaS/NZtFt8YBKteeeEJyy4cwzTJBm7
 8DHN9UVDUouA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="422643689"
Received: from bgsxx0031.iind.intel.com ([10.106.222.40])
  by orsmga001.jf.intel.com with ESMTP; 07 Jan 2021 09:05:48 -0800
From:   M Chetan Kumar <m.chetan.kumar@intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com
Subject: [PATCH 02/18] net: iosm: irq handling
Date:   Thu,  7 Jan 2021 22:35:07 +0530
Message-Id: <20210107170523.26531-3-m.chetan.kumar@intel.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210107170523.26531-1-m.chetan.kumar@intel.com>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) Request interrupt vector, frees allocated resource.
2) Registers IRQ handler.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_irq.c | 89 ++++++++++++++++++++++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_irq.h | 35 ++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h

diff --git a/drivers/net/wwan/iosm/iosm_ipc_irq.c b/drivers/net/wwan/iosm/iosm_ipc_irq.c
new file mode 100644
index 000000000000..190d6b6b274d
--- /dev/null
+++ b/drivers/net/wwan/iosm/iosm_ipc_irq.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Intel Corporation.
+ */
+
+#include "iosm_ipc_pcie.h"
+#include "iosm_ipc_protocol.h"
+
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
+	int i, rc = -1;
+
+	ipc_pcie->nvec = pci_alloc_irq_vectors(pdev, IPC_MSI_VECTORS,
+					       IPC_MSI_VECTORS, PCI_IRQ_MSI);
+
+	if (ipc_pcie->nvec < 0)
+		return ipc_pcie->nvec;
+
+	if (!pdev->msi_enabled)
+		goto error;
+
+	for (i = 0; i < ipc_pcie->nvec; ++i) {
+		rc = request_threaded_irq(pdev->irq + i, NULL,
+					  ipc_msi_interrupt, 0, KBUILD_MODNAME,
+					  ipc_pcie);
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
index 000000000000..ca270d396730
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
+ * ipc_release_irq - Release the IRQ handler.
+ * @ipc_pcie:	Pointer to iosm_pcie struct
+ */
+void ipc_release_irq(struct iosm_pcie *ipc_pcie);
+
+/**
+ * ipc_acquire_irq - acquire IRQ & register IRQ handler.
+ * @ipc_pcie:	Pointer to iosm_pcie struct
+ *
+ * Return: 0 on success and -1 on failure
+ */
+int ipc_acquire_irq(struct iosm_pcie *ipc_pcie);
+
+#endif
-- 
2.12.3

