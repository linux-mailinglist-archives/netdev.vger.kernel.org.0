Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB3B424B74
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhJGBJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240126AbhJGBJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19570610FC;
        Thu,  7 Oct 2021 01:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633568832;
        bh=YimZyYeJAKGzMURSkX3fKQkHXg8br+0zVfguGfu7AtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNA60AzfABch3NJWwlq95mVGeqvi8fGn8J39iyMd6n6o1A0QGbbup2UnwiPigkCNc
         O5JK4njI8TYqo94em6890MOQVmAIjFFCrusMoxeNGQij2kHcZRWeQPSigyfzFnxj/3
         yd9wiqLAIitzq8Te0ucx1Yj8APzogHPXTN46TslSaFna3THf85uQxlfRUD/MChvc2n
         PleyTRdY7v3CQNKD7vI+Zv+QjpsncObhBLfJeNR7ohDO9TDsR3Uc7nB/U/kdaVQx/t
         o4A0QlF8sN+hQfZcur04QhFsa9yU4gwVakgmD2D1E02bMvxk0IqVPcF8LgzeiwjVqd
         htYKwe/JV7+dA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, rafael@kernel.org, saravanak@google.com,
        mw@semihalf.com, andrew@lunn.ch, jeremy.linton@arm.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, heikki.krogerus@linux.intel.com,
        devicetree@vger.kernel.org, snelson@pensando.io,
        Jakub Kicinski <kuba@kernel.org>, Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v3 1/9] of: net: move of_net under net/
Date:   Wed,  6 Oct 2021 18:06:54 -0700
Message-Id: <20211007010702.3438216-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007010702.3438216-1-kuba@kernel.org>
References: <20211007010702.3438216-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob suggests to move of_net.c from under drivers/of/ somewhere
to the networking code.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: new patch
v3: also clean up Kconfig
---
 drivers/net/ethernet/amd/Kconfig    | 2 +-
 drivers/net/ethernet/arc/Kconfig    | 4 ++--
 drivers/net/ethernet/ezchip/Kconfig | 2 +-
 drivers/net/ethernet/litex/Kconfig  | 2 +-
 drivers/net/ethernet/mscc/Kconfig   | 2 +-
 drivers/of/Kconfig                  | 4 ----
 drivers/of/Makefile                 | 1 -
 include/linux/of_net.h              | 2 +-
 net/core/Makefile                   | 1 +
 net/core/net-sysfs.c                | 2 +-
 {drivers/of => net/core}/of_net.c   | 0
 11 files changed, 9 insertions(+), 13 deletions(-)
 rename {drivers/of => net/core}/of_net.c (100%)

diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index 4786f0504691..899c8a2a34b6 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -168,7 +168,7 @@ config SUNLANCE
 
 config AMD_XGBE
 	tristate "AMD 10GbE Ethernet driver"
-	depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM
+	depends on (OF_ADDRESS || ACPI || PCI) && HAS_IOMEM
 	depends on X86 || ARM64 || COMPILE_TEST
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select BITREVERSE
diff --git a/drivers/net/ethernet/arc/Kconfig b/drivers/net/ethernet/arc/Kconfig
index 37a41773dd43..840a9ce7ba1c 100644
--- a/drivers/net/ethernet/arc/Kconfig
+++ b/drivers/net/ethernet/arc/Kconfig
@@ -25,7 +25,7 @@ config ARC_EMAC_CORE
 config ARC_EMAC
 	tristate "ARC EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET
+	depends on OF_IRQ
 	depends on ARC || COMPILE_TEST
 	help
 	  On some legacy ARC (Synopsys) FPGA boards such as ARCAngel4/ML50x
@@ -35,7 +35,7 @@ config ARC_EMAC
 config EMAC_ROCKCHIP
 	tristate "Rockchip EMAC support"
 	select ARC_EMAC_CORE
-	depends on OF_IRQ && OF_NET && REGULATOR
+	depends on OF_IRQ && REGULATOR
 	depends on ARCH_ROCKCHIP || COMPILE_TEST
 	help
 	  Support for Rockchip RK3036/RK3066/RK3188 EMAC ethernet controllers.
diff --git a/drivers/net/ethernet/ezchip/Kconfig b/drivers/net/ethernet/ezchip/Kconfig
index 38aa824efb25..9241b9b1c7a3 100644
--- a/drivers/net/ethernet/ezchip/Kconfig
+++ b/drivers/net/ethernet/ezchip/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_EZCHIP
 
 config EZCHIP_NPS_MANAGEMENT_ENET
 	tristate "EZchip NPS management enet support"
-	depends on OF_IRQ && OF_NET
+	depends on OF_IRQ
 	depends on HAS_IOMEM
 	help
 	  Simple LAN device for debug or management purposes.
diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index 63bf01d28f0c..f99adbf26ab4 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
 
 config LITEX_LITEETH
 	tristate "LiteX Ethernet support"
-	depends on OF_NET
+	depends on OF
 	help
 	  If you wish to compile a kernel for hardware with a LiteX LiteEth
 	  device then you should answer Y to this.
diff --git a/drivers/net/ethernet/mscc/Kconfig b/drivers/net/ethernet/mscc/Kconfig
index b6a73d151dec..8dd8c7f425d2 100644
--- a/drivers/net/ethernet/mscc/Kconfig
+++ b/drivers/net/ethernet/mscc/Kconfig
@@ -28,7 +28,7 @@ config MSCC_OCELOT_SWITCH
 	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
 	depends on HAS_IOMEM
-	depends on OF_NET
+	depends on OF
 	select MSCC_OCELOT_SWITCH_LIB
 	select GENERIC_PHY
 	help
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index 3dfeae8912df..80b5fd44ab1c 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -70,10 +70,6 @@ config OF_IRQ
 	def_bool y
 	depends on !SPARC && IRQ_DOMAIN
 
-config OF_NET
-	depends on NETDEVICES
-	def_bool y
-
 config OF_RESERVED_MEM
 	def_bool OF_EARLY_FLATTREE
 
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index c13b982084a3..e0360a44306e 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -7,7 +7,6 @@ obj-$(CONFIG_OF_EARLY_FLATTREE) += fdt_address.o
 obj-$(CONFIG_OF_PROMTREE) += pdt.o
 obj-$(CONFIG_OF_ADDRESS)  += address.o
 obj-$(CONFIG_OF_IRQ)    += irq.o
-obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_UNITTEST) += unittest.o
 obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
 obj-$(CONFIG_OF_RESOLVE)  += resolver.o
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index daef3b0d9270..cf31188329b5 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -8,7 +8,7 @@
 
 #include <linux/phy.h>
 
-#ifdef CONFIG_OF_NET
+#ifdef CONFIG_OF
 #include <linux/of.h>
 
 struct net_device;
diff --git a/net/core/Makefile b/net/core/Makefile
index 35ced6201814..4268846f2f47 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -36,3 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_OF)	+= of_net.o
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f6197774048b..ae001c2ca2af 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1869,7 +1869,7 @@ static struct class net_class __ro_after_init = {
 	.get_ownership = net_get_ownership,
 };
 
-#ifdef CONFIG_OF_NET
+#ifdef CONFIG_OF
 static int of_dev_node_match(struct device *dev, const void *data)
 {
 	for (; dev; dev = dev->parent) {
diff --git a/drivers/of/of_net.c b/net/core/of_net.c
similarity index 100%
rename from drivers/of/of_net.c
rename to net/core/of_net.c
-- 
2.31.1

