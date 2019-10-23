Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EFDE2658
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436742AbfJWWYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:24:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436651AbfJWWYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 18:24:23 -0400
Received: from lore-desk.lan (unknown [151.66.11.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD5302173B;
        Wed, 23 Oct 2019 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571869462;
        bh=9Rf/2A2133N2RaTq0AUraTZm7Ddefm9mGc7uW0+g0xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mtQDBqZR+uxSfwoyPtDXzCryBoLFjzAk2LdBXvrTqfnnVvxVDvKeep8PkEqk+SGRe
         iuqJZ/54c3dodivjW7enr9jDJkNxsIvarkx09+9HNtmu9Olci2YRnh5u4hrBPqh+GV
         ZDsvLO7WeWq0nIDuqeL71qEALt7lEDDQ21t3dL08=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: [PATCH wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by default
Date:   Thu, 24 Oct 2019 00:23:15 +0200
Message-Id: <fec60f066bab1936d58b2e69bae3f20e645d1304.1571868221.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571868221.git.lorenzo@kernel.org>
References: <cover.1571868221.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On same device (e.g. U7612E-H1) PCIE_ASPM causes continuous mcu hangs and
instability and so let's disable PCIE_ASPM by default. This patch has
been successfully tested on U7612E-H1 mini-pice card

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mmio.c     | 47 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
 3 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 1c974df1fe25..f991a8f1c42a 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
  */
 
+#include <linux/pci.h>
+
 #include "mt76.h"
 #include "trace.h"
 
@@ -78,6 +80,51 @@ void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr,
 }
 EXPORT_SYMBOL_GPL(mt76_set_irq_mask);
 
+void mt76_mmio_disable_aspm(struct pci_dev *pdev)
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
+#ifdef CONFIG_PCIEASPM
+	pci_disable_link_state(pdev, aspm_conf);
+
+	/* Double-check ASPM control.  If not disabled by the above, the
+	 * BIOS is preventing that from happening (or CONFIG_PCIEASPM is
+	 * not enabled); override by writing PCI config space directly.
+	 */
+	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &aspm_conf);
+	if (!(aspm_conf & PCI_EXP_LNKCTL_ASPMC))
+		return;
+#endif /* CONFIG_PCIEASPM */
+
+	/* Both device and parent should have the same ASPM setting.
+	 * Disable ASPM in downstream component first and then upstream.
+	 */
+	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_conf);
+
+	if (parent)
+		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
+					   aspm_conf);
+}
+EXPORT_SYMBOL_GPL(mt76_mmio_disable_aspm);
+
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
 {
 	static const struct mt76_bus_ops mt76_mmio_ops = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 570c159515a0..962812b6247d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -578,6 +578,7 @@ bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
 #define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
 
 void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
+void mt76_mmio_disable_aspm(struct pci_dev *pdev);
 
 static inline u16 mt76_chip(struct mt76_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 73c3104f8858..264bef87e5c7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -81,6 +81,8 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
 	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
 
+	mt76_mmio_disable_aspm(pdev);
+
 	return 0;
 
 error:
-- 
2.21.0

