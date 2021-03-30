Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A2634F006
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232457AbhC3RoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhC3Rn0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D67DC619B1;
        Tue, 30 Mar 2021 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617126206;
        bh=Km5/NLiFu9OztdWOHL1dLNiUdzRJVym2mzxhMR0v5vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwPz5nc3+J7j2MN8YbjU7mUMEr18QE5iZVQXWndh0M9HTYDs3dipL+4GwbuZ8uB+h
         az2KcvOEBOk70fA/hV9D0Q6PuqZ6yHm2jHk6YpmATrC2uarho7TWWFyGujwhssOXfL
         vzx7eRe3OA66bIKoB2tXQWCjl8wN1OvDGsa7FpU+ZrpUI53ZxAJaxGqoW6zq5HuFac
         JANRq49fqDXrGMt+2+ljXTS8oqlhgc57kB63RKn2KhQVnh3wqlvLCfJzWfpMp+xDqi
         1LoCO/BnxDGo33MQCGZXggMqpBYfCXRNbbL7cHbq3heGXWZpHOnhXbhcNeRqByEj2l
         UInxIbtM45Dig==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nic_swsd@realtek.com,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 2/3] IB/mthca: Disable parity reporting
Date:   Tue, 30 Mar 2021 12:43:17 -0500
Message-Id: <20210330174318.1289680-3-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330174318.1289680-1-helgaas@kernel.org>
References: <20210330174318.1289680-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

For Mellanox Tavor devices, we previously set dev->broken_parity_status,
which does not change the device's behavior; it merely prevents the EDAC
PCI error reporting from warning about Master Data Parity Error, Signaled
System Error, or Detected Parity Error for this device.

Instead, disable Parity Error Response so the device doesn't report
parity errors in the first place.

[bhelgaas: split out pci_disable_parity(), commit log, keep quirk static]
Link: https://lore.kernel.org/r/d375987c-ea4f-dd98-4ef8-99b2fbfe7c33@gmail.com
---
 drivers/pci/quirks.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 653660e3ba9e..6aa9df411604 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -206,16 +206,11 @@ DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
 				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
 
 /*
- * The Mellanox Tavor device gives false positive parity errors.  Mark this
- * device with a broken_parity_status to allow PCI scanning code to "skip"
- * this now blacklisted device.
+ * The Mellanox Tavor device gives false positive parity errors.  Disable
+ * parity error reporting.
  */
-static void quirk_mellanox_tavor(struct pci_dev *dev)
-{
-	dev->broken_parity_status = 1;	/* This device gives false positives */
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, quirk_mellanox_tavor);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, quirk_mellanox_tavor);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR, pci_disable_parity);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_MELLANOX, PCI_DEVICE_ID_MELLANOX_TAVOR_BRIDGE, pci_disable_parity);
 
 /*
  * Deal with broken BIOSes that neglect to enable passive release,
-- 
2.25.1

