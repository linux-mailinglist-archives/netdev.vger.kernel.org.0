Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAF07CD95
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbfGaUCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:02:01 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:32947 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfGaUB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:01:59 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MhWx1-1iWd3A2AUt-00eeFu; Wed, 31 Jul 2019 22:01:23 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] net: lpc-enet: move phy setup into platform code
Date:   Wed, 31 Jul 2019 21:56:49 +0200
Message-Id: <20190731195713.3150463-8-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190731195713.3150463-1-arnd@arndb.de>
References: <20190731195713.3150463-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:DV0nUYbe0M7LEh69rBwpnzpxoNTB5NYut5sl+C1tAwRs+femstR
 Rb6T5pxzGUFSlJsJr98GJFWfI00qzelp0DSmJSBm+Ss1XOrjdPC5tHy4ZIHY7Q6wBFxXTCi
 jscc3Pqo7B3jvlmH+w27lTB9SaeK/1nbLjChGfLrc4ixR1DkgFO4ps4co9wrutnuhPxqLiW
 y2YJJujXV4RZ7aFFguoGQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4vEuAYs9ZXo=:GFoO+dSjJ1TDEX2+SUxnDx
 yqMghV4hxbjcUD6ijCuXiSaE3N3EEyyYw7YM+VDvmzD4V4clIdZVgbBBszYBg79h8zPiA/fi7
 PuHfqfZqc+YQKoLOz+Y05GtP1lQAKrt0dQunuwjuYVj565TjXwI0ZcNaWQmSzMHSO3AYGkO1t
 tM3cMJRzZpJKtFWZEmnaKy2bbsC3s+GFBnbjaRLVTA3VFHzURqYoRYLLOL2ilIvgCyHhVjFj4
 yeLFKXWVDO0GIQIdPorev9o1bd/H1DmbfTrvz7zfVCHzkq4s5r+z73cccXlotHP6nf7wedmXt
 iPeCk8sfxTrDcKlUg284A0JtFkg4URHi/sTKtsaLbno3CgnL5KdsqZXsDM8UpvjhA8905I7CI
 YJbJU2SP9RecnuZH+CvrVjWpjabuD6r8lfTHGhuF362RgQmSzRPuBf1Kk9yYGbKBqqQLCHZuO
 U0jagpJqBuZImzDYWYdne+7T8b1DpFvxzqpHXDX2P4AB4M/M7j1LBS3ZfDnXvKMFEfyyQF26w
 pBe2X3fJhusESwtQQuWiLhw/KlycsLnS6O5uZ20SL2VWN07a0meZDYTp15FQYWB7celFqw2cd
 WHnOcLv5jLsOgzWmcibU+4717eTSAv+Kn4hBKPs3pxhAP2mhxdtAlvmScDxXB/xPZ8hWJEhxJ
 /4n8Cmy85oczi2XHhkWw/t3JGfi2JLAtRqIK5N6g53zMPo3AaRWATfQamQ91y8XyQR8WublTd
 vvhb/nkpfBwQtPx27wK+aKf9DM4T9mjgAEcATg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting the phy mode requires touching a platform specific
register, which prevents us from building the driver without
its header files.

Move it into a separate function in arch/arm/mach/lpc32xx
to hide the core registers from the network driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-lpc32xx/common.c       | 12 ++++++++++++
 drivers/net/ethernet/nxp/lpc_eth.c   | 12 +-----------
 include/linux/soc/nxp/lpc32xx-misc.h |  5 +++++
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
index f648324d5fb4..a475339333c1 100644
--- a/arch/arm/mach-lpc32xx/common.c
+++ b/arch/arm/mach-lpc32xx/common.c
@@ -63,6 +63,18 @@ u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaaddr)
 }
 EXPORT_SYMBOL_GPL(lpc32xx_return_iram);
 
+void lpc32xx_set_phy_interface_mode(phy_interface_t mode)
+{
+	u32 tmp = __raw_readl(LPC32XX_CLKPWR_MACCLK_CTRL);
+	tmp &= ~LPC32XX_CLKPWR_MACCTRL_PINS_MSK;
+	if (mode == PHY_INTERFACE_MODE_MII)
+		tmp |= LPC32XX_CLKPWR_MACCTRL_USE_MII_PINS;
+	else
+		tmp |= LPC32XX_CLKPWR_MACCTRL_USE_RMII_PINS;
+	__raw_writel(tmp, LPC32XX_CLKPWR_MACCLK_CTRL);
+}
+EXPORT_SYMBOL_GPL(lpc32xx_set_phy_interface_mode);
+
 static struct map_desc lpc32xx_io_desc[] __initdata = {
 	{
 		.virtual	= (unsigned long)IO_ADDRESS(LPC32XX_AHB0_START),
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index bcdd0adcfb0c..0893b77c385d 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -20,9 +20,6 @@
 #include <linux/spinlock.h>
 #include <linux/soc/nxp/lpc32xx-misc.h>
 
-#include <mach/hardware.h>
-#include <mach/platform.h>
-
 #define MODNAME "lpc-eth"
 #define DRV_VERSION "1.00"
 
@@ -1237,16 +1234,9 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	dma_addr_t dma_handle;
 	struct resource *res;
 	int irq, ret;
-	u32 tmp;
 
 	/* Setup network interface for RMII or MII mode */
-	tmp = __raw_readl(LPC32XX_CLKPWR_MACCLK_CTRL);
-	tmp &= ~LPC32XX_CLKPWR_MACCTRL_PINS_MSK;
-	if (lpc_phy_interface_mode(dev) == PHY_INTERFACE_MODE_MII)
-		tmp |= LPC32XX_CLKPWR_MACCTRL_USE_MII_PINS;
-	else
-		tmp |= LPC32XX_CLKPWR_MACCTRL_USE_RMII_PINS;
-	__raw_writel(tmp, LPC32XX_CLKPWR_MACCLK_CTRL);
+	lpc32xx_set_phy_interface_mode(lpc_phy_interface_mode(dev));
 
 	/* Get platform resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/include/linux/soc/nxp/lpc32xx-misc.h b/include/linux/soc/nxp/lpc32xx-misc.h
index f232e1a1bcdc..af4f82f6cf3b 100644
--- a/include/linux/soc/nxp/lpc32xx-misc.h
+++ b/include/linux/soc/nxp/lpc32xx-misc.h
@@ -9,9 +9,11 @@
 #define __SOC_LPC32XX_MISC_H
 
 #include <linux/types.h>
+#include <linux/phy.h>
 
 #ifdef CONFIG_ARCH_LPC32XX
 extern u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaaddr);
+extern void lpc32xx_set_phy_interface_mode(phy_interface_t mode);
 #else
 static inline u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaaddr)
 {
@@ -19,6 +21,9 @@ static inline u32 lpc32xx_return_iram(void __iomem **mapbase, dma_addr_t *dmaadd
 	*dmaaddr = 0;
 	return 0;
 }
+static inline void lpc32xx_set_phy_interface_mode(phy_interface_t mode)
+{
+}
 #endif
 
 #endif  /* __SOC_LPC32XX_MISC_H */
-- 
2.20.0

