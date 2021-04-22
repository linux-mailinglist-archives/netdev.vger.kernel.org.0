Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E851B368182
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbhDVNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDVNf2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 09:35:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8AB56145D;
        Thu, 22 Apr 2021 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619098493;
        bh=IS0hEeTiqs7XtMtPtK1m8yhZxLJIwCvBXliPep3errM=;
        h=From:To:Cc:Subject:Date:From;
        b=q3JCD4F6Dd/N483qhRLRYC7LbkxO6oCIp2aXl1OH9bHSphEncru6ggEWHy2kheGK+
         dOvy5eDPTqSJRWKqC4w0sfwW4fSkfbHULn3aWHt7k0cXEm9mPUyjyr/rhcphE/uM3q
         LlYAR/s14UQ/QMFeDSbiNeYndIuDG6OwKZiEU9eeXRsEZtYcvHkEamahoKBjEbNLJ8
         7kRdCAqR0niaw/YVDUSoh63/T8jDzQUSn2Libqujcj2JoDlq4netcosQzte/w1kC7t
         U2OC5z5X2u4RPguYuQdvKMtvEy6VnJFCb63eWO8bv+DknJR7xKz/b8uPcN6J6OlW8H
         aHtd4HFPSa7CA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shachar Raindel <shacharr@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mana: fix PCI_HYPERV dependency
Date:   Thu, 22 Apr 2021 15:34:34 +0200
Message-Id: <20210422133444.1793327-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The MANA driver causes a build failure in some configurations when
it selects an unavailable symbol:

WARNING: unmet direct dependencies detected for PCI_HYPERV
  Depends on [n]: PCI [=y] && X86_64 [=y] && HYPERV [=n] && PCI_MSI [=y] && PCI_MSI_IRQ_DOMAIN [=y] && SYSFS [=y]
  Selected by [y]:
  - MICROSOFT_MANA [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICROSOFT [=y] && PCI_MSI [=y] && X86_64 [=y]
drivers/pci/controller/pci-hyperv.c: In function 'hv_irq_unmask':
drivers/pci/controller/pci-hyperv.c:1217:9: error: implicit declaration of function 'hv_set_msi_entry_from_desc' [-Werror=implicit-function-declaration]
 1217 |         hv_set_msi_entry_from_desc(&params->int_entry.msi_entry, msi_desc);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~

A PCI driver should never depend on a particular host bridge
implementation in the first place, but if we have this dependency
it's better to express it as a 'depends on' rather than 'select'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/microsoft/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index e1ac0a5d808d..fe4e7a7d9c0b 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_MICROSOFT
 config MICROSOFT_MANA
 	tristate "Microsoft Azure Network Adapter (MANA) support"
 	depends on PCI_MSI && X86_64
-	select PCI_HYPERV
+	depends on PCI_HYPERV
 	help
 	  This driver supports Microsoft Azure Network Adapter (MANA).
 	  So far, the driver is only supported on X86_64.
-- 
2.29.2

