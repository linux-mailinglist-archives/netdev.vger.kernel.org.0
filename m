Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8D34F003
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhC3Rn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232001AbhC3RnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:43:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0B9619D3;
        Tue, 30 Mar 2021 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617126204;
        bh=cHgRyNPea/tk/h7ppogF/FAqeVM0OOIbYOAsae8a4D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1TPDcvpdDQl2zz/6dTzoGc2yPvj9XebTivOzAM94u9CqcWuIn58HEE5DIrWgn30q
         sQzyt0FN+NxgG9CLTd9gzAZDeCc+5eZjIBsWOtzDDUs0CfcI/LzBQi8H3rVL5GqX60
         ktbThATq2tyDS++YxOeSJX4FDM07vD03T89DtlPOFzuGQJKAMU7uUKl7CY/hcsX1cF
         zXDttl8kS85SMWyLpdFL0K1Nv4tIq17S8+7wYNuQTBwGzeLInm5157UjnHV2ZP8H7f
         nSKZkIleTCQD1Xa4gGQCVp9FCsX4ntHqX+8fTMpp8fU1jvFWhQ3pb4Mei/VENjtpzc
         SxQsu2nRgwFpA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nic_swsd@realtek.com,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v4 1/3] PCI: Add pci_disable_parity()
Date:   Tue, 30 Mar 2021 12:43:16 -0500
Message-Id: <20210330174318.1289680-2-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330174318.1289680-1-helgaas@kernel.org>
References: <20210330174318.1289680-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

Add pci_disable_parity() to disable reporting of parity errors for a
device by clearing PCI_COMMAND_PARITY.

The device will still set PCI_STATUS_DETECTED_PARITY when it detects
a parity error or receives a Poisoned TLP, but it will not set
PCI_STATUS_PARITY, which means it will not assert PERR#
(conventional PCI) or report Poisoned TLPs (PCIe).

Based-on: https://lore.kernel.org/linux-arm-kernel/d375987c-ea4f-dd98-4ef8-99b2fbfe7c33@gmail.com/
Based-on-patch-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.c   | 17 +++++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 16a17215f633..b1845e5e5c8f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4453,6 +4453,23 @@ void pci_clear_mwi(struct pci_dev *dev)
 }
 EXPORT_SYMBOL(pci_clear_mwi);
 
+/**
+ * pci_disable_parity - disable parity checking for device
+ * @dev: the PCI device to operate on
+ *
+ * Disable parity checking for device @dev
+ */
+void pci_disable_parity(struct pci_dev *dev)
+{
+	u16 cmd;
+
+	pci_read_config_word(dev, PCI_COMMAND, &cmd);
+	if (cmd & PCI_COMMAND_PARITY) {
+		cmd &= ~PCI_COMMAND_PARITY;
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	}
+}
+
 /**
  * pci_intx - enables/disables PCI INTx for device dev
  * @pdev: the PCI device to operate on
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 86c799c97b77..4eaa773115da 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1201,6 +1201,7 @@ int __must_check pci_set_mwi(struct pci_dev *dev);
 int __must_check pcim_set_mwi(struct pci_dev *dev);
 int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
+void pci_disable_parity(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
 bool pci_check_and_mask_intx(struct pci_dev *dev);
 bool pci_check_and_unmask_intx(struct pci_dev *dev);
-- 
2.25.1

