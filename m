Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FBB2EACE5
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbhAEOFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:05:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:57644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbhAEOFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:05:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 79861AEC1;
        Tue,  5 Jan 2021 14:03:45 +0000 (UTC)
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
Subject: [PATCH 08/10] rtc: tx4939: Remove driver
Date:   Tue,  5 Jan 2021 15:02:53 +0100
Message-Id: <20210105140305.141401-9-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210105140305.141401-1-tsbogend@alpha.franken.de>
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CPU support for TX49xx is getting removed, so remove rtc driver for it.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/rtc/Kconfig      |   7 -
 drivers/rtc/Makefile     |   1 -
 drivers/rtc/rtc-tx4939.c | 303 ---------------------------------------
 3 files changed, 311 deletions(-)
 delete mode 100644 drivers/rtc/rtc-tx4939.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 6123f9f4fbc9..3b5510c9bffa 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1587,13 +1587,6 @@ config RTC_DRV_STARFIRE
 	  If you say Y here you will get support for the RTC found on
 	  Starfire systems.
 
-config RTC_DRV_TX4939
-	tristate "TX4939 SoC"
-	depends on SOC_TX4939 || COMPILE_TEST
-	help
-	  Driver for the internal RTC (Realtime Clock) module found on
-	  Toshiba TX4939 SoC.
-
 config RTC_DRV_MV
 	tristate "Marvell SoC RTC"
 	depends on ARCH_DOVE || ARCH_MVEBU || COMPILE_TEST
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index bb8f319b09fb..a020adde4bbd 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -171,7 +171,6 @@ obj-$(CONFIG_RTC_DRV_TPS6586X)	+= rtc-tps6586x.o
 obj-$(CONFIG_RTC_DRV_TPS65910)	+= rtc-tps65910.o
 obj-$(CONFIG_RTC_DRV_TPS80031)	+= rtc-tps80031.o
 obj-$(CONFIG_RTC_DRV_TWL4030)	+= rtc-twl.o
-obj-$(CONFIG_RTC_DRV_TX4939)	+= rtc-tx4939.o
 obj-$(CONFIG_RTC_DRV_V3020)	+= rtc-v3020.o
 obj-$(CONFIG_RTC_DRV_VR41XX)	+= rtc-vr41xx.o
 obj-$(CONFIG_RTC_DRV_VRTC)	+= rtc-mrst.o
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
deleted file mode 100644
index c3309db5448d..000000000000
--- a/drivers/rtc/rtc-tx4939.c
+++ /dev/null
@@ -1,303 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * TX4939 internal RTC driver
- * Based on RBTX49xx patch from CELF patch archive.
- *
- * (C) Copyright TOSHIBA CORPORATION 2005-2007
- */
-#include <linux/rtc.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/gfp.h>
-
-#define TX4939_RTCCTL_ALME	0x00000080
-#define TX4939_RTCCTL_ALMD	0x00000040
-#define TX4939_RTCCTL_BUSY	0x00000020
-
-#define TX4939_RTCCTL_COMMAND	0x00000007
-#define TX4939_RTCCTL_COMMAND_NOP	0x00000000
-#define TX4939_RTCCTL_COMMAND_GETTIME	0x00000001
-#define TX4939_RTCCTL_COMMAND_SETTIME	0x00000002
-#define TX4939_RTCCTL_COMMAND_GETALARM	0x00000003
-#define TX4939_RTCCTL_COMMAND_SETALARM	0x00000004
-
-#define TX4939_RTCTBC_PM	0x00000080
-#define TX4939_RTCTBC_COMP	0x0000007f
-
-#define TX4939_RTC_REG_RAMSIZE	0x00000100
-#define TX4939_RTC_REG_RWBSIZE	0x00000006
-
-struct tx4939_rtc_reg {
-	__u32 ctl;
-	__u32 adr;
-	__u32 dat;
-	__u32 tbc;
-};
-
-struct tx4939rtc_plat_data {
-	struct rtc_device *rtc;
-	struct tx4939_rtc_reg __iomem *rtcreg;
-	spinlock_t lock;
-};
-
-static int tx4939_rtc_cmd(struct tx4939_rtc_reg __iomem *rtcreg, int cmd)
-{
-	int i = 0;
-
-	__raw_writel(cmd, &rtcreg->ctl);
-	/* This might take 30us (next 32.768KHz clock) */
-	while (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_BUSY) {
-		/* timeout on approx. 100us (@ GBUS200MHz) */
-		if (i++ > 200 * 100)
-			return -EBUSY;
-		cpu_relax();
-	}
-	return 0;
-}
-
-static int tx4939_rtc_set_time(struct device *dev, struct rtc_time *tm)
-{
-	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	unsigned long secs = rtc_tm_to_time64(tm);
-	int i, ret;
-	unsigned char buf[6];
-
-	buf[0] = 0;
-	buf[1] = 0;
-	buf[2] = secs;
-	buf[3] = secs >> 8;
-	buf[4] = secs >> 16;
-	buf[5] = secs >> 24;
-	spin_lock_irq(&pdata->lock);
-	__raw_writel(0, &rtcreg->adr);
-	for (i = 0; i < 6; i++)
-		__raw_writel(buf[i], &rtcreg->dat);
-	ret = tx4939_rtc_cmd(rtcreg,
-			     TX4939_RTCCTL_COMMAND_SETTIME |
-			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
-	spin_unlock_irq(&pdata->lock);
-	return ret;
-}
-
-static int tx4939_rtc_read_time(struct device *dev, struct rtc_time *tm)
-{
-	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	int i, ret;
-	unsigned long sec;
-	unsigned char buf[6];
-
-	spin_lock_irq(&pdata->lock);
-	ret = tx4939_rtc_cmd(rtcreg,
-			     TX4939_RTCCTL_COMMAND_GETTIME |
-			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
-	if (ret) {
-		spin_unlock_irq(&pdata->lock);
-		return ret;
-	}
-	__raw_writel(2, &rtcreg->adr);
-	for (i = 2; i < 6; i++)
-		buf[i] = __raw_readl(&rtcreg->dat);
-	spin_unlock_irq(&pdata->lock);
-	sec = ((unsigned long)buf[5] << 24) | (buf[4] << 16) |
-		(buf[3] << 8) | buf[2];
-	rtc_time64_to_tm(sec, tm);
-	return 0;
-}
-
-static int tx4939_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	int i, ret;
-	unsigned long sec;
-	unsigned char buf[6];
-
-	sec = rtc_tm_to_time64(&alrm->time);
-	buf[0] = 0;
-	buf[1] = 0;
-	buf[2] = sec;
-	buf[3] = sec >> 8;
-	buf[4] = sec >> 16;
-	buf[5] = sec >> 24;
-	spin_lock_irq(&pdata->lock);
-	__raw_writel(0, &rtcreg->adr);
-	for (i = 0; i < 6; i++)
-		__raw_writel(buf[i], &rtcreg->dat);
-	ret = tx4939_rtc_cmd(rtcreg, TX4939_RTCCTL_COMMAND_SETALARM |
-			     (alrm->enabled ? TX4939_RTCCTL_ALME : 0));
-	spin_unlock_irq(&pdata->lock);
-	return ret;
-}
-
-static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-{
-	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	int i, ret;
-	unsigned long sec;
-	unsigned char buf[6];
-	u32 ctl;
-
-	spin_lock_irq(&pdata->lock);
-	ret = tx4939_rtc_cmd(rtcreg,
-			     TX4939_RTCCTL_COMMAND_GETALARM |
-			     (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALME));
-	if (ret) {
-		spin_unlock_irq(&pdata->lock);
-		return ret;
-	}
-	__raw_writel(2, &rtcreg->adr);
-	for (i = 2; i < 6; i++)
-		buf[i] = __raw_readl(&rtcreg->dat);
-	ctl = __raw_readl(&rtcreg->ctl);
-	alrm->enabled = (ctl & TX4939_RTCCTL_ALME) ? 1 : 0;
-	alrm->pending = (ctl & TX4939_RTCCTL_ALMD) ? 1 : 0;
-	spin_unlock_irq(&pdata->lock);
-	sec = ((unsigned long)buf[5] << 24) | (buf[4] << 16) |
-		(buf[3] << 8) | buf[2];
-	rtc_time64_to_tm(sec, &alrm->time);
-	return rtc_valid_tm(&alrm->time);
-}
-
-static int tx4939_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev);
-
-	spin_lock_irq(&pdata->lock);
-	tx4939_rtc_cmd(pdata->rtcreg,
-		       TX4939_RTCCTL_COMMAND_NOP |
-		       (enabled ? TX4939_RTCCTL_ALME : 0));
-	spin_unlock_irq(&pdata->lock);
-	return 0;
-}
-
-static irqreturn_t tx4939_rtc_interrupt(int irq, void *dev_id)
-{
-	struct tx4939rtc_plat_data *pdata = dev_get_drvdata(dev_id);
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	unsigned long events = RTC_IRQF;
-
-	spin_lock(&pdata->lock);
-	if (__raw_readl(&rtcreg->ctl) & TX4939_RTCCTL_ALMD) {
-		events |= RTC_AF;
-		tx4939_rtc_cmd(rtcreg, TX4939_RTCCTL_COMMAND_NOP);
-	}
-	spin_unlock(&pdata->lock);
-	rtc_update_irq(pdata->rtc, 1, events);
-
-	return IRQ_HANDLED;
-}
-
-static const struct rtc_class_ops tx4939_rtc_ops = {
-	.read_time		= tx4939_rtc_read_time,
-	.read_alarm		= tx4939_rtc_read_alarm,
-	.set_alarm		= tx4939_rtc_set_alarm,
-	.set_time		= tx4939_rtc_set_time,
-	.alarm_irq_enable	= tx4939_rtc_alarm_irq_enable,
-};
-
-static int tx4939_nvram_read(void *priv, unsigned int pos, void *val,
-			     size_t bytes)
-{
-	struct tx4939rtc_plat_data *pdata = priv;
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	u8 *buf = val;
-
-	spin_lock_irq(&pdata->lock);
-	for (; bytes; bytes--) {
-		__raw_writel(pos++, &rtcreg->adr);
-		*buf++ = __raw_readl(&rtcreg->dat);
-	}
-	spin_unlock_irq(&pdata->lock);
-	return 0;
-}
-
-static int tx4939_nvram_write(void *priv, unsigned int pos, void *val,
-			      size_t bytes)
-{
-	struct tx4939rtc_plat_data *pdata = priv;
-	struct tx4939_rtc_reg __iomem *rtcreg = pdata->rtcreg;
-	u8 *buf = val;
-
-	spin_lock_irq(&pdata->lock);
-	for (; bytes; bytes--) {
-		__raw_writel(pos++, &rtcreg->adr);
-		__raw_writel(*buf++, &rtcreg->dat);
-	}
-	spin_unlock_irq(&pdata->lock);
-	return 0;
-}
-
-static int __init tx4939_rtc_probe(struct platform_device *pdev)
-{
-	struct rtc_device *rtc;
-	struct tx4939rtc_plat_data *pdata;
-	int irq, ret;
-	struct nvmem_config nvmem_cfg = {
-		.name = "tx4939_nvram",
-		.size = TX4939_RTC_REG_RAMSIZE,
-		.reg_read = tx4939_nvram_read,
-		.reg_write = tx4939_nvram_write,
-	};
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return -ENODEV;
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return -ENOMEM;
-	platform_set_drvdata(pdev, pdata);
-
-	pdata->rtcreg = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(pdata->rtcreg))
-		return PTR_ERR(pdata->rtcreg);
-
-	spin_lock_init(&pdata->lock);
-	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
-	if (devm_request_irq(&pdev->dev, irq, tx4939_rtc_interrupt,
-			     0, pdev->name, &pdev->dev) < 0)
-		return -EBUSY;
-	rtc = devm_rtc_allocate_device(&pdev->dev);
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
-
-	rtc->ops = &tx4939_rtc_ops;
-	rtc->range_max = U32_MAX;
-
-	pdata->rtc = rtc;
-
-	nvmem_cfg.priv = pdata;
-	ret = devm_rtc_nvmem_register(rtc, &nvmem_cfg);
-	if (ret)
-		return ret;
-
-	return devm_rtc_register_device(rtc);
-}
-
-static int __exit tx4939_rtc_remove(struct platform_device *pdev)
-{
-	struct tx4939rtc_plat_data *pdata = platform_get_drvdata(pdev);
-
-	spin_lock_irq(&pdata->lock);
-	tx4939_rtc_cmd(pdata->rtcreg, TX4939_RTCCTL_COMMAND_NOP);
-	spin_unlock_irq(&pdata->lock);
-	return 0;
-}
-
-static struct platform_driver tx4939_rtc_driver = {
-	.remove		= __exit_p(tx4939_rtc_remove),
-	.driver		= {
-		.name	= "tx4939rtc",
-	},
-};
-
-module_platform_driver_probe(tx4939_rtc_driver, tx4939_rtc_probe);
-
-MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
-MODULE_DESCRIPTION("TX4939 internal RTC driver");
-MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:tx4939rtc");
-- 
2.29.2

