Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D28E5400
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfJYSyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:36976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfJYSym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 14:54:42 -0400
Received: from localhost.localdomain (unknown [151.66.57.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7E7206DD;
        Fri, 25 Oct 2019 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572029681;
        bh=3eM7XLL/eXi+zcfYxSlVvINLbBDfNSQJrF7Zj1DNRqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zw/N/HBJ4dCnFl3TpPVb1Z0QwedthwkG4BwEgWiIsegFS+tgnMI8Gm3x5Za7U3+Rb
         augptrE1iAXIOk4FA7XBsD5Bf5nvSHZUFkYUblGCuKaSgjNuJmk1AqQ8GqDg9NNYFH
         ahuWze3ka9f/9Q8MSkb0fNK4dS6sC5ouWM4a5w/k=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: [PATCH v2 wireless-drivers 1/2] mt76: mt76x2e: disable pcie_aspm by default
Date:   Fri, 25 Oct 2019 20:54:13 +0200
Message-Id: <60372a0fd1ff74f649d14dbe48d5a8c0382dd711.1572029407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572029407.git.lorenzo@kernel.org>
References: <cover.1572029407.git.lorenzo@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/mmio.c     | 42 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
 3 files changed, 45 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 1c974df1fe25..218b139563b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
  */
 
+#include <linux/pci.h>
+
 #include "mt76.h"
 #include "trace.h"
 
@@ -78,6 +80,46 @@ void mt76_set_irq_mask(struct mt76_dev *dev, u32 addr,
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

