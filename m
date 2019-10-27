Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE1E6522
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 20:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbfJ0Txg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 15:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfJ0Txg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 15:53:36 -0400
Received: from localhost.localdomain (unknown [151.66.57.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E79A20650;
        Sun, 27 Oct 2019 19:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572206015;
        bh=MzubQBUSSLxgrzhRneK0OoJ2aTvF7dNg3YN6/OHjT6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pN/RHBeBaRrViWurhFMSf0tr6KETiixvVbsrEj6m/F3VF8XUGXrKlqh3iFahmaWRv
         GqDHmRcOFreqL3815HXGSSrlwl15X5aKb4wriG00+iQq3JqZVC0TYWsO19gm6TUAqs
         bZ+FH9kmUhQlZtS3UYNzcGKG0WyqK+oPYnqghtTc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: [PATCH v3 wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by default
Date:   Sun, 27 Oct 2019 20:53:08 +0100
Message-Id: <cbd541284b80a966e2050ac809a495c55cfb591e.1572204430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572204430.git.lorenzo@kernel.org>
References: <cover.1572204430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs and
instability. Since mt76x2 series does not manage PCIE PS states, first we
try to disable ASPM using pci_disable_link_state. If it fails, we will
disable PCIE PS configuring PCI registers.
This patch has been successfully tested on U7612E-H1 mini-pice card

Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
 drivers/net/wireless/mediatek/mt76/pci.c      | 46 +++++++++++++++++++
 4 files changed, 51 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/pci.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 4d03596e891f..d7a1ddc9e407 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -8,6 +8,8 @@ mt76-y := \
 	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o \
 	tx.o agg-rx.o mcu.o
 
+mt76-$(CONFIG_PCI) += pci.o
+
 mt76-usb-y := usb.o usb_trace.o
 
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 570c159515a0..dc468ed9434a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -578,6 +578,7 @@ bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
 #define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
 
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
+void mt76_pci_disable_aspm(struct pci_dev *pdev);
 
 static inline u16 mt76_chip(struct mt76_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 73c3104f8858..cf611d1b817c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -81,6 +81,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
 	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
 
+	mt76_pci_disable_aspm(pdev);
+
 	return 0;
 
 error:
diff --git a/drivers/net/wireless/mediatek/mt76/pci.c b/drivers/net/wireless/mediatek/mt76/pci.c
new file mode 100644
index 000000000000..04c5a692bc85
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/pci.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (C) 2019 Lorenzo Bianconi <lorenzo@kernel.org>
+ */
+
+#include <linux/pci.h>
+
+void mt76_pci_disable_aspm(struct pci_dev *pdev)
+{
+	struct pci_dev *parent = pdev->bus->self;
+	u16 aspm_conf, parent_aspm_conf = 0;
+
+	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
+	aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
+	if (parent) {
+		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
+					  &parent_aspm_conf);
+		parent_aspm_conf &= PCI_EXP_LNKCTL_ASPMC;
+	}
+
+	if (!aspm_conf && (!parent || !parent_aspm_conf)) {
+		/* aspm already disabled */
+		return;
+	}
+
+	dev_info(&pdev->dev, "disabling ASPM %s %s\n",
+		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S) ? "L0s" : "",
+		 (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1) ? "L1" : "");
+
+	if (IS_ENABLED(CONFIG_PCIEASPM)) {
+		int err;
+
+		err = pci_disable_link_state(pdev, aspm_conf);
+		if (!err)
+			return;
+	}
+
+	/* both device and parent should have the same ASPM setting.
+	 * disable ASPM in downstream component first and then upstream.
+	 */
+	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_conf);
+	if (parent)
+		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
+					   aspm_conf);
+}
+EXPORT_SYMBOL_GPL(mt76_pci_disable_aspm);
-- 
2.21.0

