Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7382736D80D
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 15:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbhD1NKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 09:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239600AbhD1NKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 09:10:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FA8C061574
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 06:09:58 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbjwr-0004x1-9r; Wed, 28 Apr 2021 15:09:49 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbjwq-0007j5-4p; Wed, 28 Apr 2021 15:09:48 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: [PATCH net-next v1 1/1] net: selftest: fix build issue if INET is disabled
Date:   Wed, 28 Apr 2021 15:09:46 +0200
Message-Id: <20210428130947.29649-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case ethernet driver is enabled and INET is disabled, selftest will
fail to build.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/Kconfig   |  2 +-
 drivers/net/ethernet/freescale/Kconfig |  2 +-
 include/net/selftests.h                | 19 +++++++++++++++++++
 net/Kconfig                            |  2 +-
 net/core/Makefile                      |  2 +-
 net/dsa/Kconfig                        |  2 +-
 6 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/atheros/Kconfig b/drivers/net/ethernet/atheros/Kconfig
index 6842b74b0696..482c58c4c584 100644
--- a/drivers/net/ethernet/atheros/Kconfig
+++ b/drivers/net/ethernet/atheros/Kconfig
@@ -20,8 +20,8 @@ if NET_VENDOR_ATHEROS
 config AG71XX
 	tristate "Atheros AR7XXX/AR9XXX built-in ethernet mac support"
 	depends on ATH79
-	select NET_SELFTESTS
 	select PHYLINK
+	imply NET_SELFTESTS
 	help
 	  If you wish to compile a kernel for AR7XXX/91XXX and enable
 	  ethernet support, then you should always answer Y to this.
diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
index 3d937b4650b2..2d1abdd58fab 100644
--- a/drivers/net/ethernet/freescale/Kconfig
+++ b/drivers/net/ethernet/freescale/Kconfig
@@ -26,8 +26,8 @@ config FEC
 		   ARCH_MXC || SOC_IMX28 || COMPILE_TEST)
 	default ARCH_MXC || SOC_IMX28 if ARM
 	select CRC32
-	select NET_SELFTESTS
 	select PHYLIB
+	imply NET_SELFTESTS
 	imply PTP_1588_CLOCK
 	help
 	  Say Y here if you want to use the built-in 10/100 Fast ethernet
diff --git a/include/net/selftests.h b/include/net/selftests.h
index 9993b9498cf3..61926c33a022 100644
--- a/include/net/selftests.h
+++ b/include/net/selftests.h
@@ -4,9 +4,28 @@
 
 #include <linux/ethtool.h>
 
+#if IS_ENABLED(CONFIG_NET_SELFTESTS)
+
 void net_selftest(struct net_device *ndev, struct ethtool_test *etest,
 		  u64 *buf);
 int net_selftest_get_count(void);
 void net_selftest_get_strings(u8 *data);
 
+#else
+
+static inline void net_selftest(struct net_device *ndev, struct ethtool_test *etest,
+		  u64 *buf)
+{
+}
+
+static inline int net_selftest_get_count(void)
+{
+	return 0;
+}
+
+static inline void net_selftest_get_strings(u8 *data)
+{
+}
+
+#endif
 #endif /* _NET_SELFTESTS */
diff --git a/net/Kconfig b/net/Kconfig
index 8d955195c069..f5ee7c65e6b4 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -431,7 +431,7 @@ config SOCK_VALIDATE_XMIT
 
 config NET_SELFTESTS
 	def_tristate PHYLIB
-	depends on PHYLIB
+	depends on PHYLIB && INET
 
 config NET_SOCK_MSG
 	bool
diff --git a/net/core/Makefile b/net/core/Makefile
index 1a6168d8f23b..f7f16650fe9e 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_NETPOLL) += netpoll.o
 obj-$(CONFIG_FIB_RULES) += fib_rules.o
 obj-$(CONFIG_TRACEPOINTS) += net-traces.o
 obj-$(CONFIG_NET_DROP_MONITOR) += drop_monitor.o
+obj-$(CONFIG_NET_SELFTESTS) += selftests.o
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += timestamping.o
 obj-$(CONFIG_NET_PTP_CLASSIFY) += ptp_classifier.o
 obj-$(CONFIG_CGROUP_NET_PRIO) += netprio_cgroup.o
@@ -33,7 +34,6 @@ obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
 ifeq ($(CONFIG_INET),y)
-obj-$(CONFIG_NET_SELFTESTS) += selftests.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 endif
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index cbc2bd643ab2..183e27b50202 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -9,7 +9,7 @@ menuconfig NET_DSA
 	select NET_SWITCHDEV
 	select PHYLINK
 	select NET_DEVLINK
-	select NET_SELFTESTS
+	imply NET_SELFTESTS
 	help
 	  Say Y if you want to enable support for the hardware switches supported
 	  by the Distributed Switch Architecture.
-- 
2.29.2

