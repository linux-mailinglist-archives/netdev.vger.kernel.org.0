Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F734F007
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhC3RoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232101AbhC3Rn2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:43:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E757619D6;
        Tue, 30 Mar 2021 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617126207;
        bh=oJFKuCUfkKRL7zkTo3uhLRMFcjPrNPutwqIV6AWcUUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aczD3+BA9FjpTgcNUhiYA6AdAoLO0jJQioJVqdFN+VQkRX4CxxXewXc6uybN4UgOU
         m4aYzk+MvJ5tBJmJijW5DqSxl3WVCZgZ5FwN5AOdJnfwygy0Op4wCCUtSuWoQXJe6j
         OnaWH+wC2hT7LVF+/4tbZGpvBdQEt7AQxKbmSVNn18Uy/HU/rZp9eoxOqnLBkkLd6m
         VxyyLcQM5HN8prUBZrLim6HhoaMUD3Ov1bSsJ4hblswe7i3LZRJBBNQ7/XFyPX3EnP
         jcvlGRhiO7DoPO+xP5Zl8kGJGNffDo7ykjlYW7LBESWu63efhsUJjwdAwnQgaJ3Y9Q
         yaJospq8aBiiw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, nic_swsd@realtek.com,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 3/3] ARM: iop32x: disable N2100 PCI parity reporting
Date:   Tue, 30 Mar 2021 12:43:18 -0500
Message-Id: <20210330174318.1289680-4-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210330174318.1289680-1-helgaas@kernel.org>
References: <20210330174318.1289680-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

On the N2100, instead of just marking the r8169 chips as having
broken_parity_status, disable parity error reporting for them entirely.

This was the only relevant place that set broken_parity_status, so we no
longer need to check for it in the r8169 error interrupt handler.

[bhelgaas: squash into one patch, commit log]
Link: https://lore.kernel.org/r/0c0dcbf2-5f1e-954c-ebd7-e6ccfae5c60e@gmail.com
Link: https://lore.kernel.org/r/9e312679-a684-e9c7-2656-420723706451@gmail.com
---
 arch/arm/mach-iop32x/n2100.c              |  8 ++++----
 drivers/net/ethernet/realtek/r8169_main.c | 14 --------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index 78b9a5ee41c9..bf99e718f8b8 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -116,16 +116,16 @@ static struct hw_pci n2100_pci __initdata = {
 };
 
 /*
- * Both r8169 chips on the n2100 exhibit PCI parity problems.  Set
- * the ->broken_parity_status flag for both ports so that the r8169
- * driver knows it should ignore error interrupts.
+ * Both r8169 chips on the n2100 exhibit PCI parity problems.  Turn
+ * off parity reporting for both ports so we don't get error interrupts
+ * for them.
  */
 static void n2100_fixup_r8169(struct pci_dev *dev)
 {
 	if (dev->bus->number == 0 &&
 	    (dev->devfn == PCI_DEVFN(1, 0) ||
 	     dev->devfn == PCI_DEVFN(2, 0)))
-		dev->broken_parity_status = 1;
+		pci_disable_parity(dev);
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f704da3f214c..a6aff0d993eb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4358,20 +4358,6 @@ static void rtl8169_pcierr_interrupt(struct net_device *dev)
 	if (net_ratelimit())
 		netdev_err(dev, "PCI error (cmd = 0x%04x, status_errs = 0x%04x)\n",
 			   pci_cmd, pci_status_errs);
-	/*
-	 * The recovery sequence below admits a very elaborated explanation:
-	 * - it seems to work;
-	 * - I did not see what else could be done;
-	 * - it makes iop3xx happy.
-	 *
-	 * Feel free to adjust to your needs.
-	 */
-	if (pdev->broken_parity_status)
-		pci_cmd &= ~PCI_COMMAND_PARITY;
-	else
-		pci_cmd |= PCI_COMMAND_SERR | PCI_COMMAND_PARITY;
-
-	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 
 	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 }
-- 
2.25.1

