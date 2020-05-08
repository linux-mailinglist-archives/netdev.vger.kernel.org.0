Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307071CA7B9
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 11:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgEHJ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 05:59:43 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:58318 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgEHJ7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 05:59:42 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0489xONv112705;
        Fri, 8 May 2020 04:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588931964;
        bh=1mP5NZoPz79Fbrm2hSfkRM1/h90PP/Hph3S5iklvqt4=;
        h=From:To:CC:Subject:Date;
        b=P/mubhP8oH6A01orrIyzG3BobORJNErVYONBVkgZrRyeOrqs1NJfr6HUUs03VtqZC
         P6jhZs3C0RyGHbYcpYvN48piVMB7t/LFN4L+wnKXH9pJK3TAeeujlQQgGd9VaoxEgS
         2Qf1vvO/h1AenNouIZ1K/p8rYvOOBWwqsxUFeAvo=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0489xOJb089360
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 8 May 2020 04:59:24 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 8 May
 2020 04:59:23 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 8 May 2020 04:59:23 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0489xMcH052428;
        Fri, 8 May 2020 04:59:23 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
CC:     <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Clay McClure <clay@daemons.net>, Dan Murphy <dmurphy@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net v3] net: ethernet: ti: fix build and remove TI_CPTS_MOD workaround
Date:   Fri, 8 May 2020 12:59:14 +0300
Message-ID: <20200508095914.20509-1-grygorii.strashko@ti.com>
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
 - use IS_REACHABLE(CONFIG_TI_CPTS) in code instead of IS_ENABLED()
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
Cc: Murali Karicheri <m-karicheri2@ti.com>
Fixes: b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Clay McClure <clay@daemons.net>
[grygorii.strashko@ti.com: rewording, add deps cpsw/netcp from cpts]
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm/configs/keystone_defconfig    |  1 +
 arch/arm/configs/omap2plus_defconfig   |  1 +
 drivers/net/ethernet/ti/Kconfig        | 16 ++++++----------
 drivers/net/ethernet/ti/Makefile       |  2 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c |  2 +-
 drivers/net/ethernet/ti/cpts.h         |  3 +--
 drivers/net/ethernet/ti/netcp_ethss.c  | 10 +++++-----
 7 files changed, 16 insertions(+), 19 deletions(-)

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
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index fa54efe3be63..19a7370a4188 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -709,7 +709,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	return ret;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
 {
 	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
diff --git a/drivers/net/ethernet/ti/cpts.h b/drivers/net/ethernet/ti/cpts.h
index bb997c11ee15..782e24c78e7a 100644
--- a/drivers/net/ethernet/ti/cpts.h
+++ b/drivers/net/ethernet/ti/cpts.h
@@ -8,7 +8,7 @@
 #ifndef _TI_CPTS_H_
 #define _TI_CPTS_H_
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 
 #include <linux/clk.h>
 #include <linux/clkdev.h>
@@ -171,5 +171,4 @@ static inline bool cpts_can_timestamp(struct cpts *cpts, struct sk_buff *skb)
 }
 #endif
 
-
 #endif
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index fb36115e9c51..3de1d25128b7 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -181,7 +181,7 @@
 
 #define HOST_TX_PRI_MAP_DEFAULT			0x00000000
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 /* Px_TS_CTL register fields */
 #define TS_RX_ANX_F_EN				BIT(0)
 #define TS_RX_VLAN_LT1_EN			BIT(1)
@@ -2000,7 +2000,7 @@ static int keystone_set_link_ksettings(struct net_device *ndev,
 	return phy_ethtool_ksettings_set(phy, cmd);
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 static int keystone_get_ts_info(struct net_device *ndev,
 				struct ethtool_ts_info *info)
 {
@@ -2532,7 +2532,7 @@ static int gbe_del_vid(void *intf_priv, int vid)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 
 static void gbe_txtstamp(void *context, struct sk_buff *skb)
 {
@@ -2977,7 +2977,7 @@ static int gbe_close(void *intf_priv, struct net_device *ndev)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_TI_CPTS)
+#if IS_REACHABLE(CONFIG_TI_CPTS)
 static void init_slave_ts_ctl(struct gbe_slave *slave)
 {
 	slave->ts_ctl.uni = 1;
@@ -3718,7 +3718,7 @@ static int gbe_probe(struct netcp_device *netcp_device, struct device *dev,
 
 	gbe_dev->cpts = cpts_create(gbe_dev->dev, gbe_dev->cpts_reg, cpts_node);
 	of_node_put(cpts_node);
-	if (IS_ENABLED(CONFIG_TI_CPTS) && IS_ERR(gbe_dev->cpts)) {
+	if (IS_REACHABLE(CONFIG_TI_CPTS) && IS_ERR(gbe_dev->cpts)) {
 		ret = PTR_ERR(gbe_dev->cpts);
 		goto free_sec_ports;
 	}
-- 
2.17.1

