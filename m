Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55D9381B66
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhEOWQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235320AbhEOWQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C03B613B9;
        Sat, 15 May 2021 22:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116897;
        bh=LL2SXlEM9d+UGyoB6GXZRVdk1oOzIrZOHV16BdNidzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6ftIzDnd++F43q3y2xDnob0u/2XOMwkkVuqOHIY05J+n4y2L+LQ+EIX5BBsypb3a
         nMoFjes5jvA1tr4EM1JIz0P7CV8xpZlVZ6fKxVWwn6jq3VLbX6NagI2C/IEO50kKDW
         UhlC+5G+2mXP1JauNxdEUwtLbCrJdMr9BEA2gNCO+UZ/5K5GU9uaiVlf4FCuY8lfrV
         onR+jfoP3BfOHF9mL+42ZwqC4feUND0o0htAwv909Ev9YWqIrenbJdtIrMZbMgrJJE
         hq4/IqPT6TjLRRA5IfpJG3Gw8S7dPWFY2uKsHstvSeC5Zvr1GK3KAXF7yEj4qNb6WY
         JLa77ue1ElykA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 08/13] [net-next] make legacy ISA probe optional
Date:   Sun, 16 May 2021 00:13:15 +0200
Message-Id: <20210515221320.1255291-9-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are very few ISA drivers left that rely on the static probing from
drivers/net/Space.o. Make them all select a new CONFIG_NETDEV_LEGACY_INIT
symbol, and drop the entire probe logic when that is disabled.

The 9 drivers that are called from Space.c are the same set that
calls netdev_boot_setup_check().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Kconfig                 | 7 +++++++
 drivers/net/Makefile                | 3 ++-
 drivers/net/appletalk/Kconfig       | 4 +++-
 drivers/net/ethernet/3com/Kconfig   | 1 +
 drivers/net/ethernet/8390/Kconfig   | 3 +++
 drivers/net/ethernet/8390/ne.c      | 2 ++
 drivers/net/ethernet/amd/Kconfig    | 2 ++
 drivers/net/ethernet/cirrus/Kconfig | 1 +
 drivers/net/ethernet/smsc/Kconfig   | 1 +
 9 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 74dc8e249faa..6dccd68a99d3 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -603,4 +603,11 @@ config NET_FAILOVER
 	  a VM with direct attached VF by failing over to the paravirtual
 	  datapath when the VF is unplugged.
 
+config NETDEV_LEGACY_INIT
+	bool
+	depends on ISA
+	help
+	  Drivers that call netdev_boot_setup_check() should select this
+	  symbol, everything else no longer needs it.
+
 endif # NETDEVICES
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 7ffd2d03efaf..e0ce373c68dd 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -18,7 +18,8 @@ obj-$(CONFIG_MACVLAN) += macvlan.o
 obj-$(CONFIG_MACVTAP) += macvtap.o
 obj-$(CONFIG_MII) += mii.o
 obj-$(CONFIG_MDIO) += mdio.o
-obj-$(CONFIG_NET) += Space.o loopback.o
+obj-$(CONFIG_NET) += loopback.o
+obj-$(CONFIG_NETDEV_LEGACY_INIT) += Space.o
 obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-y += phy/
 obj-y += mdio/
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index 43918398f0d3..90b9f1d6eda9 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -52,7 +52,9 @@ config LTPC
 
 config COPS
 	tristate "COPS LocalTalk PC support"
-	depends on DEV_APPLETALK && (ISA || EISA)
+	depends on DEV_APPLETALK && ISA
+	depends on NETDEVICES
+	select NETDEV_LEGACY_INIT
 	help
 	  This allows you to use COPS AppleTalk cards to connect to LocalTalk
 	  networks. You also need version 1.3.3 or later of the netatalk
diff --git a/drivers/net/ethernet/3com/Kconfig b/drivers/net/ethernet/3com/Kconfig
index a52a3740f0c9..706bd59bf645 100644
--- a/drivers/net/ethernet/3com/Kconfig
+++ b/drivers/net/ethernet/3com/Kconfig
@@ -34,6 +34,7 @@ config EL3
 config 3C515
 	tristate "3c515 ISA \"Fast EtherLink\""
 	depends on ISA && ISA_DMA_API && !PPC32
+	select NETDEV_LEGACY_INIT
 	help
 	  If you have a 3Com ISA EtherLink XL "Corkscrew" 3c515 Fast Ethernet
 	  network card, say Y here.
diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
index 9f4b302fd2ce..a4130e643342 100644
--- a/drivers/net/ethernet/8390/Kconfig
+++ b/drivers/net/ethernet/8390/Kconfig
@@ -102,6 +102,7 @@ config MCF8390
 config NE2000
 	tristate "NE2000/NE1000 support"
 	depends on (ISA || (Q40 && m) || MACH_TX49XX || ATARI_ETHERNEC)
+	select NETDEV_LEGACY_INIT if ISA
 	select CRC32
 	help
 	  If you have a network (Ethernet) card of this type, say Y here.
@@ -169,6 +170,7 @@ config STNIC
 config ULTRA
 	tristate "SMC Ultra support"
 	depends on ISA
+	select NETDEV_LEGACY_INIT
 	select CRC32
 	help
 	  If you have a network (Ethernet) card of this type, say Y here.
@@ -186,6 +188,7 @@ config ULTRA
 config WD80x3
 	tristate "WD80*3 support"
 	depends on ISA
+	select NETDEV_LEGACY_INIT
 	select CRC32
 	help
 	  If you have a network (Ethernet) card of this type, say Y here.
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index e9756d0ea5b8..d0bbe2180b9e 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -951,6 +951,7 @@ static int __init ne_init(void)
 }
 module_init(ne_init);
 
+#ifdef CONFIG_NETDEV_LEGACY_INIT
 struct net_device * __init ne_probe(int unit)
 {
 	int this_dev;
@@ -991,6 +992,7 @@ struct net_device * __init ne_probe(int unit)
 
 	return ERR_PTR(-ENODEV);
 }
+#endif
 #endif /* MODULE */
 
 static void __exit ne_exit(void)
diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
index d0b0609bbe23..c6a3abec86f5 100644
--- a/drivers/net/ethernet/amd/Kconfig
+++ b/drivers/net/ethernet/amd/Kconfig
@@ -46,6 +46,7 @@ config AMD8111_ETH
 config LANCE
 	tristate "AMD LANCE and PCnet (AT1500 and NE2100) support"
 	depends on ISA && ISA_DMA_API && !ARM && !PPC32
+	select NETDEV_LEGACY_INIT
 	help
 	  If you have a network (Ethernet) card of this type, say Y here.
 	  Some LinkSys cards are of this type.
@@ -132,6 +133,7 @@ config PCMCIA_NMCLAN
 config NI65
 	tristate "NI6510 support"
 	depends on ISA && ISA_DMA_API && !ARM && !PPC32
+	select NETDEV_LEGACY_INIT
 	help
 	  If you have a network (Ethernet) card of this type, say Y here.
 
diff --git a/drivers/net/ethernet/cirrus/Kconfig b/drivers/net/ethernet/cirrus/Kconfig
index 7141340a8b0e..dac1764ba740 100644
--- a/drivers/net/ethernet/cirrus/Kconfig
+++ b/drivers/net/ethernet/cirrus/Kconfig
@@ -26,6 +26,7 @@ config CS89x0_ISA
 	depends on ISA
 	depends on !PPC32
 	depends on CS89x0_PLATFORM=n
+	select NETDEV_LEGACY_INIT
 	select CS89x0
 	help
 	  Support for CS89x0 chipset based Ethernet cards. If you have a
diff --git a/drivers/net/ethernet/smsc/Kconfig b/drivers/net/ethernet/smsc/Kconfig
index c52a38df0e0d..72e42a868346 100644
--- a/drivers/net/ethernet/smsc/Kconfig
+++ b/drivers/net/ethernet/smsc/Kconfig
@@ -23,6 +23,7 @@ config SMC9194
 	tristate "SMC 9194 support"
 	depends on ISA
 	select CRC32
+	select NETDEV_LEGACY_INIT
 	help
 	  This is support for the SMC9xxx based Ethernet cards. Choose this
 	  option if you have a DELL laptop with the docking station, or
-- 
2.29.2

