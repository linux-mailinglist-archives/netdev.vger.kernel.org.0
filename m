Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA81C1CF216
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 12:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgELKCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 06:02:51 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59336 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgELKCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 06:02:50 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04CA2bK8048126;
        Tue, 12 May 2020 05:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589277757;
        bh=BGrIbY3cp+/L7d+Mq2hbW6lY+Zs3bK2D/B59HXAbyJQ=;
        h=From:To:CC:Subject:Date;
        b=lL6lcuIbtrbAGkkKLFH9xPCH56NnLBn6xzo0LnGxJmANkKZ5vT0BhSOU7FwVJityx
         VTdaySDWyo3nfL+msZ4wU4TOc1/1anVBda10cHGnwQuR1nqzX8SlACAqAFkRl05ZKl
         nNf0p+0+d33o2ekLkuy/OSB0zVEfjYv2X2wuSvL8=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04CA2bPv084175
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 05:02:37 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 12
 May 2020 05:02:37 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 12 May 2020 05:02:37 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04CA2aB0014537;
        Tue, 12 May 2020 05:02:36 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
CC:     <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net v4] net: ethernet: ti: Remove TI_CPTS_MOD workaround
Date:   Tue, 12 May 2020 13:02:30 +0300
Message-ID: <20200512100230.17752-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Clay McClure <clay@daemons.net>

My recent commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on
PTP_1588_CLOCK") exposes a missing dependency in defconfigs that select
TI_CPTS without selecting PTP_1588_CLOCK, leading to linker errors of the
form:

drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
cpsw.c:(.text+0x680): undefined reference to `cpts_unregister'
 ...

That's because TI_CPTS_MOD (which is the symbol gating the _compilation_ of
cpts.c) now depends on PTP_1588_CLOCK, and so is not enabled in these
configurations, but TI_CPTS (which is the symbol gating _calls_ to the cpts
functions) _is_ enabled. So we end up compiling calls to functions that
don't exist, resulting in the linker errors.

This patch fixes build errors and restores previous behavior by:
 - ensure PTP_1588_CLOCK=y in TI specific configs and CPTS will be built
 - remove TI_CPTS_MOD and, instead, add dependencies from CPTS in
   TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV as below:

   config TI_CPSW_SWITCHDEV
   ...
    depends on TI_CPTS || !TI_CPTS

   which will ensure proper dependencies PTP_1588_CLOCK -> TI_CPTS ->
TI_CPSW/TI_KEYSTONE_NETCP/TI_CPSW_SWITCHDEV and build type selection.

Note. For NFS boot + CPTS all of above configs have to be built-in.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Fixes: b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Clay McClure <clay@daemons.net>
[grygorii.strashko@ti.com: rewording, add deps cpsw/netcp from cpts, drop IS_REACHABLE]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---

v3: https://lkml.org/lkml/2020/5/8/356
v2: https://lkml.org/lkml/2020/5/4/751

 arch/arm/configs/keystone_defconfig  |  1 +
 arch/arm/configs/omap2plus_defconfig |  1 +
 drivers/net/ethernet/ti/Kconfig      | 16 ++++++----------
 drivers/net/ethernet/ti/Makefile     |  2 +-
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm/configs/keystone_defconfig b/arch/arm/configs/keystone_defconfig
index 11e2211f9007..84a3b055f253 100644
--- a/arch/arm/configs/keystone_defconfig
+++ b/arch/arm/configs/keystone_defconfig
@@ -147,6 +147,7 @@ CONFIG_I2C_DAVINCI=y
 CONFIG_SPI=y
 CONFIG_SPI_DAVINCI=y
 CONFIG_SPI_SPIDEV=y
+CONFIG_PTP_1588_CLOCK=y
 CONFIG_PINCTRL_SINGLE=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_SYSFS=y
diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index 395588209b27..c3f749650d5d 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -274,6 +274,7 @@ CONFIG_SPI_TI_QSPI=m
 CONFIG_HSI=m
 CONFIG_OMAP_SSI=m
 CONFIG_SSI_PROTOCOL=m
+CONFIG_PTP_1588_CLOCK=y
 CONFIG_PINCTRL_SINGLE=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_GPIO_SYSFS=y
diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index 8e348780efb6..62f809b67469 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -49,6 +49,7 @@ config TI_CPSW_PHY_SEL
 config TI_CPSW
 	tristate "TI CPSW Switch Support"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
+	depends on TI_CPTS || !TI_CPTS
 	select TI_DAVINCI_MDIO
 	select MFD_SYSCON
 	select PAGE_POOL
@@ -64,6 +65,7 @@ config TI_CPSW_SWITCHDEV
 	tristate "TI CPSW Switch Support with switchdev"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
 	depends on NET_SWITCHDEV
+	depends on TI_CPTS || !TI_CPTS
 	select PAGE_POOL
 	select TI_DAVINCI_MDIO
 	select MFD_SYSCON
@@ -77,23 +79,16 @@ config TI_CPSW_SWITCHDEV
 	  will be called cpsw_new.
 
 config TI_CPTS
-	bool "TI Common Platform Time Sync (CPTS) Support"
-	depends on TI_CPSW || TI_KEYSTONE_NETCP || TI_CPSW_SWITCHDEV || COMPILE_TEST
+	tristate "TI Common Platform Time Sync (CPTS) Support"
+	depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
 	depends on COMMON_CLK
-	depends on POSIX_TIMERS
+	depends on PTP_1588_CLOCK
 	---help---
 	  This driver supports the Common Platform Time Sync unit of
 	  the CPSW Ethernet Switch and Keystone 2 1g/10g Switch Subsystem.
 	  The unit can time stamp PTP UDP/IPv4 and Layer 2 packets, and the
 	  driver offers a PTP Hardware Clock.
 
-config TI_CPTS_MOD
-	tristate
-	depends on TI_CPTS
-	depends on PTP_1588_CLOCK
-	default y if TI_CPSW=y || TI_KEYSTONE_NETCP=y || TI_CPSW_SWITCHDEV=y
-	default m
-
 config TI_K3_AM65_CPSW_NUSS
 	tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
@@ -114,6 +109,7 @@ config TI_KEYSTONE_NETCP
 	select TI_DAVINCI_MDIO
 	depends on OF
 	depends on KEYSTONE_NAVIGATOR_DMA && KEYSTONE_NAVIGATOR_QMSS
+	depends on TI_CPTS || !TI_CPTS
 	---help---
 	  This driver supports TI's Keystone NETCP Core.
 
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Makefile
index 53792190e9c2..cb26a9d21869 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_TI_DAVINCI_EMAC) += ti_davinci_emac.o
 ti_davinci_emac-y := davinci_emac.o davinci_cpdma.o
 obj-$(CONFIG_TI_DAVINCI_MDIO) += davinci_mdio.o
 obj-$(CONFIG_TI_CPSW_PHY_SEL) += cpsw-phy-sel.o
-obj-$(CONFIG_TI_CPTS_MOD) += cpts.o
+obj-$(CONFIG_TI_CPTS) += cpts.o
 obj-$(CONFIG_TI_CPSW) += ti_cpsw.o
 ti_cpsw-y := cpsw.o davinci_cpdma.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
 obj-$(CONFIG_TI_CPSW_SWITCHDEV) += ti_cpsw_new.o
-- 
2.17.1

