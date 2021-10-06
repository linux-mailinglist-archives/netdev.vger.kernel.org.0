Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626B54243B9
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhJFRN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239440AbhJFRN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C697610A2;
        Wed,  6 Oct 2021 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633540324;
        bh=8SKlAAqyIhBdin3nr+f7pUJuepMezcfgOMpM0sgIZuI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gphAm5FBjpKmd6zuHjTWx6kXYpkLptmiIjNMNJGnvETRFkyO/Tn4P921zUX25F8Ta
         KBMWnp8WLQnGrbFy1yEDXsKotoUKZDRgPU0XIDJ3G71H0qdURWzaw0zUzIQhB72nhz
         NwDqkX1RVKFoRV4SRiaKjSN/ZoFzGoicjVYnkuRoiBElnLDeC4t4gYcjEYA6xBt/3q
         U3xFCBcRwjYaFa8u4qNubwtZl530e98BY+um/xKVcZGJ9OB3vKhvgm6M1D7ki+9Czv
         KLmc2zaJP6aTi7zcyZdcgfiTdxtIQF7GQZquqpqnaq0hzzzODv1dwngyp0OqJBy35W
         XR6nCzXxsiEHw==
Date:   Wed, 6 Oct 2021 10:12:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/9] of: net: move of_net under net/
Message-ID: <20211006101203.4337e9a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL_JsqLRQRmhXZm25WKzUSBUyK6q5d-BspW4zQcztW3Qf56EKg@mail.gmail.com>
References: <20211006154426.3222199-1-kuba@kernel.org>
        <20211006154426.3222199-2-kuba@kernel.org>
        <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
        <YV3QAzAWiYdKFB3m@lunn.ch>
        <CAL_JsqLRQRmhXZm25WKzUSBUyK6q5d-BspW4zQcztW3Qf56EKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 11:58:07 -0500 Rob Herring wrote:
> On Wed, Oct 6, 2021 at 11:34 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Wed, Oct 06, 2021 at 11:18:19AM -0500, Rob Herring wrote:  
> > > The OF_NET kconfig should move or disappear too. I imagine you can do just:  
> >
> > It is used in a few places:  
> 
> Okay, then just move it for now.
> 
> I suspect though that most of these can either be dropped or replaced
> with just 'OF' dependency.

I have something that builds with allmodconfig :) see below.

> > net/ethernet/litex/Kconfig:     depends on OF_NET
> > net/ethernet/amd/Kconfig:       depends on ((OF_NET && OF_ADDRESS) || ACPI || PCI) && HAS_IOMEM  
> 
> If the driver depends on OF or ACPI, then the dependency should just
> be removed because one of those is almost always enabled.

I assumed any OF_* implies OF so just dropping OF_NET.

> > net/ethernet/mscc/Kconfig:      depends on OF_NET
> > net/ethernet/ezchip/Kconfig:    depends on OF_IRQ && OF_NET
> > net/ethernet/arc/Kconfig:       depends on OF_IRQ && OF_NET
> > net/ethernet/arc/Kconfig:       depends on OF_IRQ && OF_NET && REGULATOR  
> 
> I don't see any OF_IRQ dependency (which would be odd). The OF_NET
> dependency is just of_get_phy_mode() from a quick glance and we have a
> stub for it.

Hm. Indeed on the OF_IRQ.

net/ethernet/arc/ has irq_of_parse_and_map()
but I don't see the need in ezchip, but that seems like a separate matter...

--->8-----

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
 
diff --git a/include/linux/of_net.h b/include/linux/of_net.h
index 314b9accd98c..0797e2edb8c2 100644
--- a/include/linux/of_net.h
+++ b/include/linux/of_net.h
@@ -8,7 +8,7 @@
 
 #include <linux/phy.h>
 
-#ifdef CONFIG_OF_NET
+#ifdef CONFIG_OF
 #include <linux/of.h>
 
 struct net_device;
diff --git a/net/core/Makefile b/net/core/Makefile
index 37b1befc39aa..4268846f2f47 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -36,4 +36,4 @@ obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
-obj-$(CONFIG_OF_NET)	+= of_net.o
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
-- 
2.31.1


