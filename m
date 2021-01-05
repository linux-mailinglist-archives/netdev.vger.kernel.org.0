Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC532EACD6
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbhAEOFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:05:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:57718 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbhAEOFM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:05:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16936AEE0;
        Tue,  5 Jan 2021 14:03:44 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 06/10] mtd: Remove drivers used by TX49xx
Date:   Tue,  5 Jan 2021 15:02:51 +0100
Message-Id: <20210105140305.141401-7-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPU support for TX49xx is getting removed, so remove MTD support for it.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/mtd/maps/Kconfig                 |   6 -
 drivers/mtd/maps/Makefile                |   1 -
 drivers/mtd/maps/rbtx4939-flash.c        | 133 -------
 drivers/mtd/nand/raw/Kconfig             |   7 -
 drivers/mtd/nand/raw/Makefile            |   1 -
 drivers/mtd/nand/raw/txx9ndfmc.c         | 423 -----------------------
 include/linux/platform_data/txx9/ndfmc.h |  28 --
 7 files changed, 599 deletions(-)
 delete mode 100644 drivers/mtd/maps/rbtx4939-flash.c
 delete mode 100644 drivers/mtd/nand/raw/txx9ndfmc.c
 delete mode 100644 include/linux/platform_data/txx9/ndfmc.h

diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
index 6650acbc961e..17579ce04922 100644
--- a/drivers/mtd/maps/Kconfig
+++ b/drivers/mtd/maps/Kconfig
@@ -380,12 +380,6 @@ config MTD_INTEL_VR_NOR
 	  Map driver for a NOR flash bank located on the Expansion Bus of the
 	  Intel Vermilion Range chipset.
 
-config MTD_RBTX4939
-	tristate "Map driver for RBTX4939 board"
-	depends on TOSHIBA_RBTX4939 && MTD_CFI && MTD_COMPLEX_MAPPINGS
-	help
-	  Map driver for NOR flash chips on RBTX4939 board.
-
 config MTD_PLATRAM
 	tristate "Map driver for platform device RAM (mtd-ram)"
 	select MTD_RAM
diff --git a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
index 79f018cf412f..408a2217b0f2 100644
--- a/drivers/mtd/maps/Makefile
+++ b/drivers/mtd/maps/Makefile
@@ -43,6 +43,5 @@ obj-$(CONFIG_MTD_SCB2_FLASH)	+= scb2_flash.o
 obj-$(CONFIG_MTD_IXP4XX)	+= ixp4xx.o
 obj-$(CONFIG_MTD_PLATRAM)	+= plat-ram.o
 obj-$(CONFIG_MTD_INTEL_VR_NOR)	+= intel_vr_nor.o
-obj-$(CONFIG_MTD_RBTX4939)	+= rbtx4939-flash.o
 obj-$(CONFIG_MTD_VMU)		+= vmu-flash.o
 obj-$(CONFIG_MTD_LANTIQ)	+= lantiq-flash.o
diff --git a/drivers/mtd/maps/rbtx4939-flash.c b/drivers/mtd/maps/rbtx4939-flash.c
deleted file mode 100644
index 39c86c0b0ec1..000000000000
--- a/drivers/mtd/maps/rbtx4939-flash.c
+++ /dev/null
@@ -1,133 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * rbtx4939-flash (based on physmap.c)
- *
- * This is a simplified physmap driver with map_init callback function.
- *
- * Copyright (C) 2009 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/partitions.h>
-#include <asm/txx9/rbtx4939.h>
-
-struct rbtx4939_flash_info {
-	struct mtd_info *mtd;
-	struct map_info map;
-};
-
-static int rbtx4939_flash_remove(struct platform_device *dev)
-{
-	struct rbtx4939_flash_info *info;
-
-	info = platform_get_drvdata(dev);
-	if (!info)
-		return 0;
-
-	if (info->mtd) {
-		mtd_device_unregister(info->mtd);
-		map_destroy(info->mtd);
-	}
-	return 0;
-}
-
-static const char * const rom_probe_types[] = {
-	"cfi_probe", "jedec_probe", NULL };
-
-static int rbtx4939_flash_probe(struct platform_device *dev)
-{
-	struct rbtx4939_flash_data *pdata;
-	struct rbtx4939_flash_info *info;
-	struct resource *res;
-	const char * const *probe_type;
-	int err = 0;
-	unsigned long size;
-
-	pdata = dev_get_platdata(&dev->dev);
-	if (!pdata)
-		return -ENODEV;
-
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-	info = devm_kzalloc(&dev->dev, sizeof(struct rbtx4939_flash_info),
-			    GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	platform_set_drvdata(dev, info);
-
-	size = resource_size(res);
-	pr_notice("rbtx4939 platform flash device: %pR\n", res);
-
-	if (!devm_request_mem_region(&dev->dev, res->start, size,
-				     dev_name(&dev->dev)))
-		return -EBUSY;
-
-	info->map.name = dev_name(&dev->dev);
-	info->map.phys = res->start;
-	info->map.size = size;
-	info->map.bankwidth = pdata->width;
-
-	info->map.virt = devm_ioremap(&dev->dev, info->map.phys, size);
-	if (!info->map.virt)
-		return -EBUSY;
-
-	if (pdata->map_init)
-		(*pdata->map_init)(&info->map);
-	else
-		simple_map_init(&info->map);
-
-	probe_type = rom_probe_types;
-	for (; !info->mtd && *probe_type; probe_type++)
-		info->mtd = do_map_probe(*probe_type, &info->map);
-	if (!info->mtd) {
-		dev_err(&dev->dev, "map_probe failed\n");
-		err = -ENXIO;
-		goto err_out;
-	}
-	info->mtd->dev.parent = &dev->dev;
-	err = mtd_device_register(info->mtd, pdata->parts, pdata->nr_parts);
-
-	if (err)
-		goto err_out;
-	return 0;
-
-err_out:
-	rbtx4939_flash_remove(dev);
-	return err;
-}
-
-#ifdef CONFIG_PM
-static void rbtx4939_flash_shutdown(struct platform_device *dev)
-{
-	struct rbtx4939_flash_info *info = platform_get_drvdata(dev);
-
-	if (mtd_suspend(info->mtd) == 0)
-		mtd_resume(info->mtd);
-}
-#else
-#define rbtx4939_flash_shutdown NULL
-#endif
-
-static struct platform_driver rbtx4939_flash_driver = {
-	.probe		= rbtx4939_flash_probe,
-	.remove		= rbtx4939_flash_remove,
-	.shutdown	= rbtx4939_flash_shutdown,
-	.driver		= {
-		.name	= "rbtx4939-flash",
-	},
-};
-
-module_platform_driver(rbtx4939_flash_driver);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("RBTX4939 MTD map driver");
-MODULE_ALIAS("platform:rbtx4939-flash");
diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 442a039b92f3..9e74a63b18a4 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -313,13 +313,6 @@ config MTD_NAND_DAVINCI
 	  Enable the driver for NAND flash chips on Texas Instruments
 	  DaVinci/Keystone processors.
 
-config MTD_NAND_TXX9NDFMC
-	tristate "TXx9 NAND controller"
-	depends on SOC_TX4938 || SOC_TX4939 || COMPILE_TEST
-	depends on HAS_IOMEM
-	help
-	  This enables the NAND flash controller on the TXx9 SoCs.
-
 config MTD_NAND_SOCRATES
 	tristate "Socrates NAND controller"
 	depends on SOCRATES
diff --git a/drivers/mtd/nand/raw/Makefile b/drivers/mtd/nand/raw/Makefile
index 32475a28d8f8..07cb86321403 100644
--- a/drivers/mtd/nand/raw/Makefile
+++ b/drivers/mtd/nand/raw/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_MTD_NAND_MLC_LPC32XX)      += lpc32xx_mlc.o
 obj-$(CONFIG_MTD_NAND_SH_FLCTL)		+= sh_flctl.o
 obj-$(CONFIG_MTD_NAND_MXC)		+= mxc_nand.o
 obj-$(CONFIG_MTD_NAND_SOCRATES)		+= socrates_nand.o
-obj-$(CONFIG_MTD_NAND_TXX9NDFMC)	+= txx9ndfmc.o
 obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
 obj-$(CONFIG_MTD_NAND_VF610_NFC)	+= vf610_nfc.o
 obj-$(CONFIG_MTD_NAND_RICOH)		+= r852.o
diff --git a/drivers/mtd/nand/raw/txx9ndfmc.c b/drivers/mtd/nand/raw/txx9ndfmc.c
deleted file mode 100644
index 1a9449e53bf9..000000000000
--- a/drivers/mtd/nand/raw/txx9ndfmc.c
+++ /dev/null
@@ -1,423 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * TXx9 NAND flash memory controller driver
- * Based on RBTX49xx patch from CELF patch archive.
- *
- * (C) Copyright TOSHIBA CORPORATION 2004-2007
- * All Rights Reserved.
- */
-#include <linux/err.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/delay.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/rawnand.h>
-#include <linux/mtd/partitions.h>
-#include <linux/io.h>
-#include <linux/platform_data/txx9/ndfmc.h>
-
-/* TXX9 NDFMC Registers */
-#define TXX9_NDFDTR	0x00
-#define TXX9_NDFMCR	0x04
-#define TXX9_NDFSR	0x08
-#define TXX9_NDFISR	0x0c
-#define TXX9_NDFIMR	0x10
-#define TXX9_NDFSPR	0x14
-#define TXX9_NDFRSTR	0x18	/* not TX4939 */
-
-/* NDFMCR : NDFMC Mode Control */
-#define TXX9_NDFMCR_WE	0x80
-#define TXX9_NDFMCR_ECC_ALL	0x60
-#define TXX9_NDFMCR_ECC_RESET	0x60
-#define TXX9_NDFMCR_ECC_READ	0x40
-#define TXX9_NDFMCR_ECC_ON	0x20
-#define TXX9_NDFMCR_ECC_OFF	0x00
-#define TXX9_NDFMCR_CE	0x10
-#define TXX9_NDFMCR_BSPRT	0x04	/* TX4925/TX4926 only */
-#define TXX9_NDFMCR_ALE	0x02
-#define TXX9_NDFMCR_CLE	0x01
-/* TX4939 only */
-#define TXX9_NDFMCR_X16	0x0400
-#define TXX9_NDFMCR_DMAREQ_MASK	0x0300
-#define TXX9_NDFMCR_DMAREQ_NODMA	0x0000
-#define TXX9_NDFMCR_DMAREQ_128	0x0100
-#define TXX9_NDFMCR_DMAREQ_256	0x0200
-#define TXX9_NDFMCR_DMAREQ_512	0x0300
-#define TXX9_NDFMCR_CS_MASK	0x0c
-#define TXX9_NDFMCR_CS(ch)	((ch) << 2)
-
-/* NDFMCR : NDFMC Status */
-#define TXX9_NDFSR_BUSY	0x80
-/* TX4939 only */
-#define TXX9_NDFSR_DMARUN	0x40
-
-/* NDFMCR : NDFMC Reset */
-#define TXX9_NDFRSTR_RST	0x01
-
-struct txx9ndfmc_priv {
-	struct platform_device *dev;
-	struct nand_chip chip;
-	int cs;
-	const char *mtdname;
-};
-
-#define MAX_TXX9NDFMC_DEV	4
-struct txx9ndfmc_drvdata {
-	struct mtd_info *mtds[MAX_TXX9NDFMC_DEV];
-	void __iomem *base;
-	unsigned char hold;	/* in gbusclock */
-	unsigned char spw;	/* in gbusclock */
-	struct nand_controller controller;
-};
-
-static struct platform_device *mtd_to_platdev(struct mtd_info *mtd)
-{
-	struct nand_chip *chip = mtd_to_nand(mtd);
-	struct txx9ndfmc_priv *txx9_priv = nand_get_controller_data(chip);
-	return txx9_priv->dev;
-}
-
-static void __iomem *ndregaddr(struct platform_device *dev, unsigned int reg)
-{
-	struct txx9ndfmc_drvdata *drvdata = platform_get_drvdata(dev);
-	struct txx9ndfmc_platform_data *plat = dev_get_platdata(&dev->dev);
-
-	return drvdata->base + (reg << plat->shift);
-}
-
-static u32 txx9ndfmc_read(struct platform_device *dev, unsigned int reg)
-{
-	return __raw_readl(ndregaddr(dev, reg));
-}
-
-static void txx9ndfmc_write(struct platform_device *dev,
-			    u32 val, unsigned int reg)
-{
-	__raw_writel(val, ndregaddr(dev, reg));
-}
-
-static uint8_t txx9ndfmc_read_byte(struct nand_chip *chip)
-{
-	struct platform_device *dev = mtd_to_platdev(nand_to_mtd(chip));
-
-	return txx9ndfmc_read(dev, TXX9_NDFDTR);
-}
-
-static void txx9ndfmc_write_buf(struct nand_chip *chip, const uint8_t *buf,
-				int len)
-{
-	struct platform_device *dev = mtd_to_platdev(nand_to_mtd(chip));
-	void __iomem *ndfdtr = ndregaddr(dev, TXX9_NDFDTR);
-	u32 mcr = txx9ndfmc_read(dev, TXX9_NDFMCR);
-
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_WE, TXX9_NDFMCR);
-	while (len--)
-		__raw_writel(*buf++, ndfdtr);
-	txx9ndfmc_write(dev, mcr, TXX9_NDFMCR);
-}
-
-static void txx9ndfmc_read_buf(struct nand_chip *chip, uint8_t *buf, int len)
-{
-	struct platform_device *dev = mtd_to_platdev(nand_to_mtd(chip));
-	void __iomem *ndfdtr = ndregaddr(dev, TXX9_NDFDTR);
-
-	while (len--)
-		*buf++ = __raw_readl(ndfdtr);
-}
-
-static void txx9ndfmc_cmd_ctrl(struct nand_chip *chip, int cmd,
-			       unsigned int ctrl)
-{
-	struct txx9ndfmc_priv *txx9_priv = nand_get_controller_data(chip);
-	struct platform_device *dev = txx9_priv->dev;
-	struct txx9ndfmc_platform_data *plat = dev_get_platdata(&dev->dev);
-
-	if (ctrl & NAND_CTRL_CHANGE) {
-		u32 mcr = txx9ndfmc_read(dev, TXX9_NDFMCR);
-
-		mcr &= ~(TXX9_NDFMCR_CLE | TXX9_NDFMCR_ALE | TXX9_NDFMCR_CE);
-		mcr |= ctrl & NAND_CLE ? TXX9_NDFMCR_CLE : 0;
-		mcr |= ctrl & NAND_ALE ? TXX9_NDFMCR_ALE : 0;
-		/* TXX9_NDFMCR_CE bit is 0:high 1:low */
-		mcr |= ctrl & NAND_NCE ? TXX9_NDFMCR_CE : 0;
-		if (txx9_priv->cs >= 0 && (ctrl & NAND_NCE)) {
-			mcr &= ~TXX9_NDFMCR_CS_MASK;
-			mcr |= TXX9_NDFMCR_CS(txx9_priv->cs);
-		}
-		txx9ndfmc_write(dev, mcr, TXX9_NDFMCR);
-	}
-	if (cmd != NAND_CMD_NONE)
-		txx9ndfmc_write(dev, cmd & 0xff, TXX9_NDFDTR);
-	if (plat->flags & NDFMC_PLAT_FLAG_DUMMYWRITE) {
-		/* dummy write to update external latch */
-		if ((ctrl & NAND_CTRL_CHANGE) && cmd == NAND_CMD_NONE)
-			txx9ndfmc_write(dev, 0, TXX9_NDFDTR);
-	}
-}
-
-static int txx9ndfmc_dev_ready(struct nand_chip *chip)
-{
-	struct platform_device *dev = mtd_to_platdev(nand_to_mtd(chip));
-
-	return !(txx9ndfmc_read(dev, TXX9_NDFSR) & TXX9_NDFSR_BUSY);
-}
-
-static int txx9ndfmc_calculate_ecc(struct nand_chip *chip, const uint8_t *dat,
-				   uint8_t *ecc_code)
-{
-	struct platform_device *dev = mtd_to_platdev(nand_to_mtd(chip));
-	int eccbytes;
-	u32 mcr = txx9ndfmc_read(dev, TXX9_NDFMCR);
-
-	mcr &= ~TXX9_NDFMCR_ECC_ALL;
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_OFF, TXX9_NDFMCR);
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_READ, TXX9_NDFMCR);
-	for (eccbytes = chip->ecc.bytes; eccbytes > 0; eccbytes -= 3) {
-		ecc_code[1] = txx9ndfmc_read(dev, TXX9_NDFDTR);
-		ecc_code[0] = txx9ndfmc_read(dev, TXX9_NDFDTR);
-		ecc_code[2] = txx9ndfmc_read(dev, TXX9_NDFDTR);
-		ecc_code += 3;
-	}
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_OFF, TXX9_NDFMCR);
-	return 0;
-}
-
-static int txx9ndfmc_correct_data(struct nand_chip *chip, unsigned char *buf,
-				  unsigned char *read_ecc,
-				  unsigned char *calc_ecc)
-{
-	int eccsize;
-	int corrected = 0;
-	int stat;
-
-	for (eccsize = chip->ecc.size; eccsize > 0; eccsize -= 256) {
-		stat = rawnand_sw_hamming_correct(chip, buf, read_ecc,
-						  calc_ecc);
-		if (stat < 0)
-			return stat;
-		corrected += stat;
-		buf += 256;
-		read_ecc += 3;
-		calc_ecc += 3;
-	}
-	return corrected;
-}
-
-static void txx9ndfmc_enable_hwecc(struct nand_chip *chip, int mode)
-{
-	struct platform_device *dev = mtd_to_platdev(nand_to_mtd(chip));
-	u32 mcr = txx9ndfmc_read(dev, TXX9_NDFMCR);
-
-	mcr &= ~TXX9_NDFMCR_ECC_ALL;
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_RESET, TXX9_NDFMCR);
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_OFF, TXX9_NDFMCR);
-	txx9ndfmc_write(dev, mcr | TXX9_NDFMCR_ECC_ON, TXX9_NDFMCR);
-}
-
-static void txx9ndfmc_initialize(struct platform_device *dev)
-{
-	struct txx9ndfmc_platform_data *plat = dev_get_platdata(&dev->dev);
-	struct txx9ndfmc_drvdata *drvdata = platform_get_drvdata(dev);
-	int tmout = 100;
-
-	if (plat->flags & NDFMC_PLAT_FLAG_NO_RSTR)
-		; /* no NDFRSTR.  Write to NDFSPR resets the NDFMC. */
-	else {
-		/* reset NDFMC */
-		txx9ndfmc_write(dev,
-				txx9ndfmc_read(dev, TXX9_NDFRSTR) |
-				TXX9_NDFRSTR_RST,
-				TXX9_NDFRSTR);
-		while (txx9ndfmc_read(dev, TXX9_NDFRSTR) & TXX9_NDFRSTR_RST) {
-			if (--tmout == 0) {
-				dev_err(&dev->dev, "reset failed.\n");
-				break;
-			}
-			udelay(1);
-		}
-	}
-	/* setup Hold Time, Strobe Pulse Width */
-	txx9ndfmc_write(dev, (drvdata->hold << 4) | drvdata->spw, TXX9_NDFSPR);
-	txx9ndfmc_write(dev,
-			(plat->flags & NDFMC_PLAT_FLAG_USE_BSPRT) ?
-			TXX9_NDFMCR_BSPRT : 0, TXX9_NDFMCR);
-}
-
-#define TXX9NDFMC_NS_TO_CYC(gbusclk, ns) \
-	DIV_ROUND_UP((ns) * DIV_ROUND_UP(gbusclk, 1000), 1000000)
-
-static int txx9ndfmc_attach_chip(struct nand_chip *chip)
-{
-	struct mtd_info *mtd = nand_to_mtd(chip);
-
-	if (chip->ecc.engine_type != NAND_ECC_ENGINE_TYPE_ON_HOST)
-		return 0;
-
-	chip->ecc.strength = 1;
-
-	if (mtd->writesize >= 512) {
-		chip->ecc.size = 512;
-		chip->ecc.bytes = 6;
-	} else {
-		chip->ecc.size = 256;
-		chip->ecc.bytes = 3;
-	}
-
-	chip->ecc.calculate = txx9ndfmc_calculate_ecc;
-	chip->ecc.correct = txx9ndfmc_correct_data;
-	chip->ecc.hwctl = txx9ndfmc_enable_hwecc;
-
-	return 0;
-}
-
-static const struct nand_controller_ops txx9ndfmc_controller_ops = {
-	.attach_chip = txx9ndfmc_attach_chip,
-};
-
-static int __init txx9ndfmc_probe(struct platform_device *dev)
-{
-	struct txx9ndfmc_platform_data *plat = dev_get_platdata(&dev->dev);
-	int hold, spw;
-	int i;
-	struct txx9ndfmc_drvdata *drvdata;
-	unsigned long gbusclk = plat->gbus_clock;
-	struct resource *res;
-
-	drvdata = devm_kzalloc(&dev->dev, sizeof(*drvdata), GFP_KERNEL);
-	if (!drvdata)
-		return -ENOMEM;
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	drvdata->base = devm_ioremap_resource(&dev->dev, res);
-	if (IS_ERR(drvdata->base))
-		return PTR_ERR(drvdata->base);
-
-	hold = plat->hold ?: 20; /* tDH */
-	spw = plat->spw ?: 90; /* max(tREADID, tWP, tRP) */
-
-	hold = TXX9NDFMC_NS_TO_CYC(gbusclk, hold);
-	spw = TXX9NDFMC_NS_TO_CYC(gbusclk, spw);
-	if (plat->flags & NDFMC_PLAT_FLAG_HOLDADD)
-		hold -= 2;	/* actual hold time : (HOLD + 2) BUSCLK */
-	spw -= 1;	/* actual wait time : (SPW + 1) BUSCLK */
-	hold = clamp(hold, 1, 15);
-	drvdata->hold = hold;
-	spw = clamp(spw, 1, 15);
-	drvdata->spw = spw;
-	dev_info(&dev->dev, "CLK:%ldMHz HOLD:%d SPW:%d\n",
-		 (gbusclk + 500000) / 1000000, hold, spw);
-
-	nand_controller_init(&drvdata->controller);
-	drvdata->controller.ops = &txx9ndfmc_controller_ops;
-
-	platform_set_drvdata(dev, drvdata);
-	txx9ndfmc_initialize(dev);
-
-	for (i = 0; i < MAX_TXX9NDFMC_DEV; i++) {
-		struct txx9ndfmc_priv *txx9_priv;
-		struct nand_chip *chip;
-		struct mtd_info *mtd;
-
-		if (!(plat->ch_mask & (1 << i)))
-			continue;
-		txx9_priv = kzalloc(sizeof(struct txx9ndfmc_priv),
-				    GFP_KERNEL);
-		if (!txx9_priv)
-			continue;
-		chip = &txx9_priv->chip;
-		mtd = nand_to_mtd(chip);
-		mtd->dev.parent = &dev->dev;
-
-		chip->legacy.read_byte = txx9ndfmc_read_byte;
-		chip->legacy.read_buf = txx9ndfmc_read_buf;
-		chip->legacy.write_buf = txx9ndfmc_write_buf;
-		chip->legacy.cmd_ctrl = txx9ndfmc_cmd_ctrl;
-		chip->legacy.dev_ready = txx9ndfmc_dev_ready;
-		chip->legacy.chip_delay = 100;
-		chip->controller = &drvdata->controller;
-
-		nand_set_controller_data(chip, txx9_priv);
-		txx9_priv->dev = dev;
-
-		if (plat->ch_mask != 1) {
-			txx9_priv->cs = i;
-			txx9_priv->mtdname = kasprintf(GFP_KERNEL, "%s.%u",
-						       dev_name(&dev->dev), i);
-		} else {
-			txx9_priv->cs = -1;
-			txx9_priv->mtdname = kstrdup(dev_name(&dev->dev),
-						     GFP_KERNEL);
-		}
-		if (!txx9_priv->mtdname) {
-			kfree(txx9_priv);
-			dev_err(&dev->dev, "Unable to allocate MTD name.\n");
-			continue;
-		}
-		if (plat->wide_mask & (1 << i))
-			chip->options |= NAND_BUSWIDTH_16;
-
-		if (nand_scan(chip, 1)) {
-			kfree(txx9_priv->mtdname);
-			kfree(txx9_priv);
-			continue;
-		}
-		mtd->name = txx9_priv->mtdname;
-
-		mtd_device_register(mtd, NULL, 0);
-		drvdata->mtds[i] = mtd;
-	}
-
-	return 0;
-}
-
-static int __exit txx9ndfmc_remove(struct platform_device *dev)
-{
-	struct txx9ndfmc_drvdata *drvdata = platform_get_drvdata(dev);
-	int ret, i;
-
-	if (!drvdata)
-		return 0;
-	for (i = 0; i < MAX_TXX9NDFMC_DEV; i++) {
-		struct mtd_info *mtd = drvdata->mtds[i];
-		struct nand_chip *chip;
-		struct txx9ndfmc_priv *txx9_priv;
-
-		if (!mtd)
-			continue;
-		chip = mtd_to_nand(mtd);
-		txx9_priv = nand_get_controller_data(chip);
-
-		ret = mtd_device_unregister(nand_to_mtd(chip));
-		WARN_ON(ret);
-		nand_cleanup(chip);
-		kfree(txx9_priv->mtdname);
-		kfree(txx9_priv);
-	}
-	return 0;
-}
-
-#ifdef CONFIG_PM
-static int txx9ndfmc_resume(struct platform_device *dev)
-{
-	if (platform_get_drvdata(dev))
-		txx9ndfmc_initialize(dev);
-	return 0;
-}
-#else
-#define txx9ndfmc_resume NULL
-#endif
-
-static struct platform_driver txx9ndfmc_driver = {
-	.remove		= __exit_p(txx9ndfmc_remove),
-	.resume		= txx9ndfmc_resume,
-	.driver		= {
-		.name	= "txx9ndfmc",
-	},
-};
-
-module_platform_driver_probe(txx9ndfmc_driver, txx9ndfmc_probe);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("TXx9 SoC NAND flash controller driver");
-MODULE_ALIAS("platform:txx9ndfmc");
diff --git a/include/linux/platform_data/txx9/ndfmc.h b/include/linux/platform_data/txx9/ndfmc.h
deleted file mode 100644
index 7aaa4cd34d31..000000000000
--- a/include/linux/platform_data/txx9/ndfmc.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *
- * (C) Copyright TOSHIBA CORPORATION 2007
- */
-#ifndef __TXX9_NDFMC_H
-#define __TXX9_NDFMC_H
-
-#define NDFMC_PLAT_FLAG_USE_BSPRT	0x01
-#define NDFMC_PLAT_FLAG_NO_RSTR		0x02
-#define NDFMC_PLAT_FLAG_HOLDADD		0x04
-#define NDFMC_PLAT_FLAG_DUMMYWRITE	0x08
-
-struct txx9ndfmc_platform_data {
-	unsigned int shift;
-	unsigned int gbus_clock;
-	unsigned int hold;		/* hold time in nanosecond */
-	unsigned int spw;		/* strobe pulse width in nanosecond */
-	unsigned int flags;
-	unsigned char ch_mask;		/* available channel bitmask */
-	unsigned char wp_mask;		/* write-protect bitmask */
-	unsigned char wide_mask;	/* 16bit-nand bitmask */
-};
-
-void txx9_ndfmc_init(unsigned long baseaddr,
-		     const struct txx9ndfmc_platform_data *plat_data);
-
-#endif /* __TXX9_NDFMC_H */
-- 
2.29.2

