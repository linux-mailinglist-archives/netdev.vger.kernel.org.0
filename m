Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393D8340BBD
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhCRRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:25:35 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:11438 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhCRRZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 13:25:12 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4F1YnF5htvz9txP2;
        Thu, 18 Mar 2021 18:25:05 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id u6-wYqBpyfgH; Thu, 18 Mar 2021 18:25:05 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4F1YnF4bNwz9txP1;
        Thu, 18 Mar 2021 18:25:05 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 60F828B939;
        Thu, 18 Mar 2021 18:25:07 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id iyUSsK_HpcYD; Thu, 18 Mar 2021 18:25:07 +0100 (CET)
Received: from po16121vm.idsi0.si.c-s.fr (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id E86068B92D;
        Thu, 18 Mar 2021 18:25:06 +0100 (CET)
Received: by po16121vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id A66BA675F0; Thu, 18 Mar 2021 17:25:06 +0000 (UTC)
Message-Id: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH] watchdog: Remove MV64x60 watchdog driver
To:     Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 18 Mar 2021 17:25:06 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
removed the last selector of CONFIG_MV64X60.

Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
can be removed.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
 drivers/watchdog/Kconfig       |   4 -
 drivers/watchdog/Makefile      |   1 -
 drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
 include/linux/mv643xx.h        |   8 -
 4 files changed, 337 deletions(-)
 delete mode 100644 drivers/watchdog/mv64x60_wdt.c

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 1fe0042a48d2..178296bda151 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1831,10 +1831,6 @@ config 8xxx_WDT
 
 	  For BookE processors (MPC85xx) use the BOOKE_WDT driver instead.
 
-config MV64X60_WDT
-	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
-	depends on MV64X60 || COMPILE_TEST
-
 config PIKA_WDT
 	tristate "PIKA FPGA Watchdog"
 	depends on WARP || (PPC64 && COMPILE_TEST)
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index f3a6540e725e..752c6513f731 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -175,7 +175,6 @@ obj-$(CONFIG_PIC32_DMT) += pic32-dmt.o
 # POWERPC Architecture
 obj-$(CONFIG_GEF_WDT) += gef_wdt.o
 obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
-obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
 obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
deleted file mode 100644
index 894aa63488d3..000000000000
--- a/drivers/watchdog/mv64x60_wdt.c
+++ /dev/null
@@ -1,324 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * mv64x60_wdt.c - MV64X60 (Marvell Discovery) watchdog userspace interface
- *
- * Author: James Chapman <jchapman@katalix.com>
- *
- * Platform-specific setup code should configure the dog to generate
- * interrupt or reset as required.  This code only enables/disables
- * and services the watchdog.
- *
- * Derived from mpc8xx_wdt.c, with the following copyright.
- *
- * 2002 (c) Florian Schirmer <jolt@tuxbox.org>
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/miscdevice.h>
-#include <linux/module.h>
-#include <linux/watchdog.h>
-#include <linux/platform_device.h>
-#include <linux/mv643xx.h>
-#include <linux/uaccess.h>
-#include <linux/io.h>
-
-#define MV64x60_WDT_WDC_OFFSET	0
-
-/*
- * The watchdog configuration register contains a pair of 2-bit fields,
- *   1.  a reload field, bits 27-26, which triggers a reload of
- *       the countdown register, and
- *   2.  an enable field, bits 25-24, which toggles between
- *       enabling and disabling the watchdog timer.
- * Bit 31 is a read-only field which indicates whether the
- * watchdog timer is currently enabled.
- *
- * The low 24 bits contain the timer reload value.
- */
-#define MV64x60_WDC_ENABLE_SHIFT	24
-#define MV64x60_WDC_SERVICE_SHIFT	26
-#define MV64x60_WDC_ENABLED_SHIFT	31
-
-#define MV64x60_WDC_ENABLED_TRUE	1
-#define MV64x60_WDC_ENABLED_FALSE	0
-
-/* Flags bits */
-#define MV64x60_WDOG_FLAG_OPENED	0
-
-static unsigned long wdt_flags;
-static int wdt_status;
-static void __iomem *mv64x60_wdt_regs;
-static int mv64x60_wdt_timeout;
-static int mv64x60_wdt_count;
-static unsigned int bus_clk;
-static char expect_close;
-static DEFINE_SPINLOCK(mv64x60_wdt_spinlock);
-
-static bool nowayout = WATCHDOG_NOWAYOUT;
-module_param(nowayout, bool, 0);
-MODULE_PARM_DESC(nowayout,
-		"Watchdog cannot be stopped once started (default="
-				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-static int mv64x60_wdt_toggle_wdc(int enabled_predicate, int field_shift)
-{
-	u32 data;
-	u32 enabled;
-	int ret = 0;
-
-	spin_lock(&mv64x60_wdt_spinlock);
-	data = readl(mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
-	enabled = (data >> MV64x60_WDC_ENABLED_SHIFT) & 1;
-
-	/* only toggle the requested field if enabled state matches predicate */
-	if ((enabled ^ enabled_predicate) == 0) {
-		/* We write a 1, then a 2 -- to the appropriate field */
-		data = (1 << field_shift) | mv64x60_wdt_count;
-		writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
-
-		data = (2 << field_shift) | mv64x60_wdt_count;
-		writel(data, mv64x60_wdt_regs + MV64x60_WDT_WDC_OFFSET);
-		ret = 1;
-	}
-	spin_unlock(&mv64x60_wdt_spinlock);
-
-	return ret;
-}
-
-static void mv64x60_wdt_service(void)
-{
-	mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
-			       MV64x60_WDC_SERVICE_SHIFT);
-}
-
-static void mv64x60_wdt_handler_enable(void)
-{
-	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_FALSE,
-				   MV64x60_WDC_ENABLE_SHIFT)) {
-		mv64x60_wdt_service();
-		pr_notice("watchdog activated\n");
-	}
-}
-
-static void mv64x60_wdt_handler_disable(void)
-{
-	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
-				   MV64x60_WDC_ENABLE_SHIFT))
-		pr_notice("watchdog deactivated\n");
-}
-
-static void mv64x60_wdt_set_timeout(unsigned int timeout)
-{
-	/* maximum bus cycle count is 0xFFFFFFFF */
-	if (timeout > 0xFFFFFFFF / bus_clk)
-		timeout = 0xFFFFFFFF / bus_clk;
-
-	mv64x60_wdt_count = timeout * bus_clk >> 8;
-	mv64x60_wdt_timeout = timeout;
-}
-
-static int mv64x60_wdt_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags))
-		return -EBUSY;
-
-	if (nowayout)
-		__module_get(THIS_MODULE);
-
-	mv64x60_wdt_handler_enable();
-
-	return stream_open(inode, file);
-}
-
-static int mv64x60_wdt_release(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42)
-		mv64x60_wdt_handler_disable();
-	else {
-		pr_crit("unexpected close, not stopping timer!\n");
-		mv64x60_wdt_service();
-	}
-	expect_close = 0;
-
-	clear_bit(MV64x60_WDOG_FLAG_OPENED, &wdt_flags);
-
-	return 0;
-}
-
-static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
-				 size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		mv64x60_wdt_service();
-	}
-
-	return len;
-}
-
-static long mv64x60_wdt_ioctl(struct file *file,
-					unsigned int cmd, unsigned long arg)
-{
-	int timeout;
-	int options;
-	void __user *argp = (void __user *)arg;
-	static const struct watchdog_info info = {
-		.options =	WDIOF_SETTIMEOUT	|
-				WDIOF_MAGICCLOSE	|
-				WDIOF_KEEPALIVEPING,
-		.firmware_version = 0,
-		.identity = "MV64x60 watchdog",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &info, sizeof(info)))
-			return -EFAULT;
-		break;
-
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		if (put_user(wdt_status, (int __user *)argp))
-			return -EFAULT;
-		wdt_status &= ~WDIOF_KEEPALIVEPING;
-		break;
-
-	case WDIOC_GETTEMP:
-		return -EOPNOTSUPP;
-
-	case WDIOC_SETOPTIONS:
-		if (get_user(options, (int __user *)argp))
-			return -EFAULT;
-
-		if (options & WDIOS_DISABLECARD)
-			mv64x60_wdt_handler_disable();
-
-		if (options & WDIOS_ENABLECARD)
-			mv64x60_wdt_handler_enable();
-		break;
-
-	case WDIOC_KEEPALIVE:
-		mv64x60_wdt_service();
-		wdt_status |= WDIOF_KEEPALIVEPING;
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(timeout, (int __user *)argp))
-			return -EFAULT;
-		mv64x60_wdt_set_timeout(timeout);
-		fallthrough;
-
-	case WDIOC_GETTIMEOUT:
-		if (put_user(mv64x60_wdt_timeout, (int __user *)argp))
-			return -EFAULT;
-		break;
-
-	default:
-		return -ENOTTY;
-	}
-
-	return 0;
-}
-
-static const struct file_operations mv64x60_wdt_fops = {
-	.owner = THIS_MODULE,
-	.llseek = no_llseek,
-	.write = mv64x60_wdt_write,
-	.unlocked_ioctl = mv64x60_wdt_ioctl,
-	.compat_ioctl = compat_ptr_ioctl,
-	.open = mv64x60_wdt_open,
-	.release = mv64x60_wdt_release,
-};
-
-static struct miscdevice mv64x60_wdt_miscdev = {
-	.minor = WATCHDOG_MINOR,
-	.name = "watchdog",
-	.fops = &mv64x60_wdt_fops,
-};
-
-static int mv64x60_wdt_probe(struct platform_device *dev)
-{
-	struct mv64x60_wdt_pdata *pdata = dev_get_platdata(&dev->dev);
-	struct resource *r;
-	int timeout = 10;
-
-	bus_clk = 133;			/* in MHz */
-	if (pdata) {
-		timeout = pdata->timeout;
-		bus_clk = pdata->bus_clk;
-	}
-
-	/* Since bus_clk is truncated MHz, actual frequency could be
-	 * up to 1MHz higher.  Round up, since it's better to time out
-	 * too late than too soon.
-	 */
-	bus_clk++;
-	bus_clk *= 1000000;		/* convert to Hz */
-
-	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!r)
-		return -ENODEV;
-
-	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
-	if (mv64x60_wdt_regs == NULL)
-		return -ENOMEM;
-
-	mv64x60_wdt_set_timeout(timeout);
-
-	mv64x60_wdt_handler_disable();	/* in case timer was already running */
-
-	return misc_register(&mv64x60_wdt_miscdev);
-}
-
-static int mv64x60_wdt_remove(struct platform_device *dev)
-{
-	misc_deregister(&mv64x60_wdt_miscdev);
-
-	mv64x60_wdt_handler_disable();
-
-	return 0;
-}
-
-static struct platform_driver mv64x60_wdt_driver = {
-	.probe = mv64x60_wdt_probe,
-	.remove = mv64x60_wdt_remove,
-	.driver = {
-		.name = MV64x60_WDT_NAME,
-	},
-};
-
-static int __init mv64x60_wdt_init(void)
-{
-	pr_info("MV64x60 watchdog driver\n");
-
-	return platform_driver_register(&mv64x60_wdt_driver);
-}
-
-static void __exit mv64x60_wdt_exit(void)
-{
-	platform_driver_unregister(&mv64x60_wdt_driver);
-}
-
-module_init(mv64x60_wdt_init);
-module_exit(mv64x60_wdt_exit);
-
-MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
-MODULE_DESCRIPTION("MV64x60 watchdog driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:" MV64x60_WDT_NAME);
diff --git a/include/linux/mv643xx.h b/include/linux/mv643xx.h
index 47e5679b48e1..000b126acfb6 100644
--- a/include/linux/mv643xx.h
+++ b/include/linux/mv643xx.h
@@ -918,12 +918,4 @@
 
 extern void mv64340_irq_init(unsigned int base);
 
-/* Watchdog Platform Device, Driver Data */
-#define	MV64x60_WDT_NAME			"mv64x60_wdt"
-
-struct mv64x60_wdt_pdata {
-	int	timeout;	/* watchdog expiry in seconds, default 10 */
-	int	bus_clk;	/* bus clock in MHz, default 133 */
-};
-
 #endif /* __ASM_MV643XX_H */
-- 
2.25.0

