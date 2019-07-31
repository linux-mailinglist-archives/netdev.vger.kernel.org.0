Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6EA97CDD0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfGaUGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:06:22 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:59499 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfGaUGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:06:21 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MODeL-1hhZ8Q40pV-00OV4y; Wed, 31 Jul 2019 22:05:44 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] ARM: orion/mvebu: unify debug-ll virtual addresses
Date:   Wed, 31 Jul 2019 21:56:55 +0200
Message-Id: <20190731195713.3150463-14-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Y/ESiM0kAuRteAugQmjXsl6x4cLpUBC4xLlaR2JUNWvARfLIQGO
 TQM095s/TFn8AV8/Qoc4eHOnBtqAJBMExhkEcMP0vX7+87jSCb1X3nhD4ghe9K9doUwcdXD
 05hEPdynsX/S9HHVozpw1JB6YUC5Qd0YS3ObojFB40I00QQE7cjOe+ixkJ6PWNW01oqP1w3
 UjMSkHlzdbzCeitJ9hg3A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fpfWvaEJtdo=:siCKSImWLjyCiT9PWAwOxl
 kzxySF8EIQd3cR7E2wjBeYRa1Acqc8iLK0RL//ox/DCx3W933S2VozzKlUNdX2jgf62v2+vPs
 lK17Y7VALtRB/PGpUsiWNGFVQ88jDpI89DJP3VNTSCF5F480mUb2F1z6pGQOze4ZIUU9N/q48
 7rImV7js4LckRi8TskduWf+xuhgV5dXl1MB1cYwfILDqe/76r/q2XYQd6QudkDWK909llddKU
 9bR6Lc46bzk0jv2OatvcjiEQC0eyaVGkDqGNmGMiU1qRGG423e7VNUPAjnQYUvsHjIJqqePmz
 HfA2ZCn1DhSfyzyMbxEltQ1w0QhA8hsq6Nf17NQPPnu5nm07PUEv3l+GUAprV9UaC+YPZzJzk
 mafDi0rVyKNTFNcSOz+gjiybL2xfqK1+y8iKUpZS90i+B7la/AqAsQ0/MbwsqHMwTl/i23Gyk
 VXHY7Lqs+rUPtECbf9gzg4V/iKuBxAj55MkIU0b6FxjY4IWWYI+R866bjwofevADHKQOpHxRF
 uoYL06eJdLBLHVv6xenXeNdsEJ221gFa2EJQle4LlRJVjiLtqFzKSfVogE0AwHANpY3RmD5O/
 fonLICMrJSBR2X5f+GmESwgAKCrA9H4Oe4EjDGCNw+Gy6kSxB8qnllEOcETJAjW01BifOX9pq
 1lJ3kRo767Tsz99Zwm3pLSn4JJHhh+Hn7QKoCVm/gUrzZcVARaBm646FvB0om/1J4KgykR6w8
 EAp7pnbJhUaVFKokfOy2tCYPtHGWnObLJawqvg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a multiplatform configuration, enabling DEBUG_LL breaks booting
on all platforms with incompatible settings. In case of the Marvell
platforms of the Orion/MVEBU family, the physical addresses are
all the same, we just map them at different virtual addresses,
which makes it impossible to run a kernel with DEBUG_LL enabled on
a combination of the merged mvebu and the legacy boardfile based
platforms.

This is easily solved by using the same virtual address everywhere.
I picked the address that is already used by mach-mvebu for UART0:
0xfec12000. All these platforms have a 1MB region with their internal
registers, almost always at physical address 0xf1000000, so I'm
updating the iotable for that entry.

In case of mach-dove, this is slightly trickier, as the existing
mapping is 8MB and a second 8MB mapping is already at the 0xfec00000
address. I have verified from the datasheet that the last 7MB of the
physical mapping are "reserved" and nothing in Linux tries to use
it either. I'm putting this 1MB mapping at the same address as the
others, and the second 8MB register area immediately before that.

Link: https://lore.kernel.org/linux-arm-kernel/87si3eb1z8.fsf@free-electrons.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I posted this in 2015, and Gregory said he would like to see
some testing on it. I don't think anyone ever tested it, but
we probably still want to have this.
---
 arch/arm/Kconfig.debug          |  5 +----
 arch/arm/mach-dove/dove.h       | 10 +++++-----
 arch/arm/mach-mv78xx0/mv78xx0.h |  4 ++--
 arch/arm/mach-orion5x/orion5x.h |  4 ++--
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 85710e078afb..0ad316a160c7 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1772,10 +1772,7 @@ config DEBUG_UART_VIRT
 	default 0xfc705000 if DEBUG_ZTE_ZX
 	default 0xfcfe8600 if DEBUG_BCM63XX_UART
 	default 0xfd000000 if DEBUG_SPEAR3XX || DEBUG_SPEAR13XX
-	default 0xfd012000 if DEBUG_MVEBU_UART0_ALTERNATE && ARCH_MV78XX0
 	default 0xfd883000 if DEBUG_ALPINE_UART0
-	default 0xfde12000 if DEBUG_MVEBU_UART0_ALTERNATE && ARCH_DOVE
-	default 0xfe012000 if DEBUG_MVEBU_UART0_ALTERNATE && ARCH_ORION5X
 	default 0xfe017000 if DEBUG_MMP_UART2
 	default 0xfe018000 if DEBUG_MMP_UART3
 	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
@@ -1790,7 +1787,7 @@ config DEBUG_UART_VIRT
 	default 0xfec02000 if DEBUG_SOCFPGA_UART0
 	default 0xfec02100 if DEBUG_SOCFPGA_ARRIA10_UART1
 	default 0xfec03000 if DEBUG_SOCFPGA_CYCLONE5_UART1
-	default 0xfec12000 if (DEBUG_MVEBU_UART0 || DEBUG_MVEBU_UART0_ALTERNATE) && ARCH_MVEBU
+	default 0xfec12000 if DEBUG_MVEBU_UART0 || DEBUG_MVEBU_UART0_ALTERNATE
 	default 0xfec12100 if DEBUG_MVEBU_UART1_ALTERNATE
 	default 0xfec10000 if DEBUG_SIRFATLAS7_UART0
 	default 0xfec20000 if DEBUG_DAVINCI_DMx_UART0
diff --git a/arch/arm/mach-dove/dove.h b/arch/arm/mach-dove/dove.h
index 539e735f968d..320ed1696abd 100644
--- a/arch/arm/mach-dove/dove.h
+++ b/arch/arm/mach-dove/dove.h
@@ -18,8 +18,8 @@
  * c8000000	fdb00000	1M	Cryptographic SRAM
  * e0000000	@runtime	128M	PCIe-0 Memory space
  * e8000000	@runtime	128M	PCIe-1 Memory space
- * f1000000	fde00000	8M	on-chip south-bridge registers
- * f1800000	fe600000	8M	on-chip north-bridge registers
+ * f1000000	fec00000	1M	on-chip south-bridge registers
+ * f1800000	fe400000	8M	on-chip north-bridge registers
  * f2000000	fee00000	1M	PCIe-0 I/O space
  * f2100000	fef00000	1M	PCIe-1 I/O space
  */
@@ -42,11 +42,11 @@
 #define DOVE_SCRATCHPAD_SIZE		SZ_1M
 
 #define DOVE_SB_REGS_PHYS_BASE		0xf1000000
-#define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
-#define DOVE_SB_REGS_SIZE		SZ_8M
+#define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfec00000)
+#define DOVE_SB_REGS_SIZE		SZ_1M
 
 #define DOVE_NB_REGS_PHYS_BASE		0xf1800000
-#define DOVE_NB_REGS_VIRT_BASE		IOMEM(0xfe600000)
+#define DOVE_NB_REGS_VIRT_BASE		IOMEM(0xfe400000)
 #define DOVE_NB_REGS_SIZE		SZ_8M
 
 #define DOVE_PCIE0_IO_PHYS_BASE		0xf2000000
diff --git a/arch/arm/mach-mv78xx0/mv78xx0.h b/arch/arm/mach-mv78xx0/mv78xx0.h
index 2db1265ec121..c1a9a1d1b295 100644
--- a/arch/arm/mach-mv78xx0/mv78xx0.h
+++ b/arch/arm/mach-mv78xx0/mv78xx0.h
@@ -37,7 +37,7 @@
  * fee50000	f0d00000	64K	PCIe #5 I/O space
  * fee60000	f0e00000	64K	PCIe #6 I/O space
  * fee70000	f0f00000	64K	PCIe #7 I/O space
- * fd000000	f1000000	1M	on-chip peripheral registers
+ * fec00000	f1000000	1M	on-chip peripheral registers
  */
 #define MV78XX0_CORE0_REGS_PHYS_BASE	0xf1020000
 #define MV78XX0_CORE1_REGS_PHYS_BASE	0xf1024000
@@ -49,7 +49,7 @@
 #define MV78XX0_PCIE_IO_SIZE		SZ_1M
 
 #define MV78XX0_REGS_PHYS_BASE		0xf1000000
-#define MV78XX0_REGS_VIRT_BASE		IOMEM(0xfd000000)
+#define MV78XX0_REGS_VIRT_BASE		IOMEM(0xfec00000)
 #define MV78XX0_REGS_SIZE		SZ_1M
 
 #define MV78XX0_PCIE_MEM_PHYS_BASE	0xc0000000
diff --git a/arch/arm/mach-orion5x/orion5x.h b/arch/arm/mach-orion5x/orion5x.h
index 3364df331f01..2b66120fba86 100644
--- a/arch/arm/mach-orion5x/orion5x.h
+++ b/arch/arm/mach-orion5x/orion5x.h
@@ -31,13 +31,13 @@
  * fc000000	device bus mappings (cs0/cs1)
  *
  * virt		phys		size
- * fe000000	f1000000	1M	on-chip peripheral registers
+ * fec00000	f1000000	1M	on-chip peripheral registers
  * fee00000	f2000000	64K	PCIe I/O space
  * fee10000	f2100000	64K	PCI I/O space
  * fd000000	f0000000	16M	PCIe WA space (Orion-1/Orion-NAS only)
  ****************************************************************************/
 #define ORION5X_REGS_PHYS_BASE		0xf1000000
-#define ORION5X_REGS_VIRT_BASE		IOMEM(0xfe000000)
+#define ORION5X_REGS_VIRT_BASE		IOMEM(0xfec00000)
 #define ORION5X_REGS_SIZE		SZ_1M
 
 #define ORION5X_PCIE_IO_PHYS_BASE	0xf2000000
-- 
2.20.0

