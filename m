Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1C51A184
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350820AbiEDN72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350942AbiEDN7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:59:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948471F615;
        Wed,  4 May 2022 06:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651672535; x=1683208535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hziUNVmt++nnYBmzUV09YMbcy639ADbCMZfzePTO9CI=;
  b=c0V//KqhGytQpO0yQch1VkVmLHU51alGYZFYTHuOlHjq3tLfmM/ZmavZ
   CPFdLsIo8v3uIg1IGcef15aW5frjHhmeAsTdT6UiPfJ+CMDvzBeZEUelm
   vlXDK5+u8w5aOx/VM89igzjqaZ7s5FdEVFhnTTKBeTH+8FQ/Twn0MZkSx
   nyQvImgpHdPhn2E7AG1oNXStY86pY2p9vsaVpb2ANNDl+Ni7n/wbGKSXp
   wfCtXNiFM3X7hR5Ydeznxq4aIZBrI1EpCBFKh+i/wVi2qH8pATkYtaquo
   M5i+z3UQFmxzvbEKTQQEhBpWoBRVKe4AUAy1FX4Z3KL/uaQzrtbX9SwCf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="247682196"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="247682196"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 06:55:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="568113838"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 04 May 2022 06:55:28 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id DE9801A5; Wed,  4 May 2022 16:55:29 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v1 4/4] powerpc/52xx: Convert to use fwnode API
Date:   Wed,  4 May 2022 16:44:49 +0300
Message-Id: <20220504134449.64473-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We may convert the GPT driver to use fwnode API for the sake
of consistency of the used APIs inside the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c | 47 +++++++++++------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 0831f28345af..7006700aeaab 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -53,10 +53,9 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/list.h>
+#include <linux/mod_devicetable.h>
+#include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/of_gpio.h>
 #include <linux/kernel.h>
 #include <linux/property.h>
 #include <linux/slab.h>
@@ -64,7 +63,7 @@
 #include <linux/watchdog.h>
 #include <linux/miscdevice.h>
 #include <linux/uaccess.h>
-#include <linux/module.h>
+
 #include <asm/div64.h>
 #include <asm/mpc52xx.h>
 
@@ -235,18 +234,17 @@ static const struct irq_domain_ops mpc52xx_gpt_irq_ops = {
 	.xlate = mpc52xx_gpt_irq_xlate,
 };
 
-static void
-mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt, struct device_node *node)
+static void mpc52xx_gpt_irq_setup(struct mpc52xx_gpt_priv *gpt)
 {
 	int cascade_virq;
 	unsigned long flags;
 	u32 mode;
 
-	cascade_virq = irq_of_parse_and_map(node, 0);
-	if (!cascade_virq)
+	cascade_virq = platform_get_irq(to_platform_device(gpt->dev), 0);
+	if (cascade_virq < 0)
 		return;
 
-	gpt->irqhost = irq_domain_add_linear(node, 1, &mpc52xx_gpt_irq_ops, gpt);
+	gpt->irqhost = irq_domain_create_linear(dev_fwnode(gpt->dev), 1, &mpc52xx_gpt_irq_ops, gpt);
 	if (!gpt->irqhost) {
 		dev_err(gpt->dev, "irq_domain_add_linear() failed\n");
 		return;
@@ -670,8 +668,7 @@ static int mpc52xx_gpt_wdt_init(void)
 	return err;
 }
 
-static int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
-				 const u32 *period)
+static int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt, const u32 period)
 {
 	u64 real_timeout;
 
@@ -679,14 +676,14 @@ static int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
 	mpc52xx_gpt_wdt = gpt;
 
 	/* configure the wdt if the device tree contained a timeout */
-	if (!period || *period == 0)
+	if (period == 0)
 		return 0;
 
-	real_timeout = (u64) *period * 1000000000ULL;
+	real_timeout = (u64)period * 1000000000ULL;
 	if (mpc52xx_gpt_do_start(gpt, real_timeout, 0, 1))
 		dev_warn(gpt->dev, "starting as wdt failed\n");
 	else
-		dev_info(gpt->dev, "watchdog set to %us timeout\n", *period);
+		dev_info(gpt->dev, "watchdog set to %us timeout\n", period);
 	return 0;
 }
 
@@ -697,8 +694,7 @@ static int mpc52xx_gpt_wdt_init(void)
 	return 0;
 }
 
-static inline int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
-					const u32 *period)
+static inline int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt, const u32 period)
 {
 	return 0;
 }
@@ -726,25 +722,26 @@ static int mpc52xx_gpt_probe(struct platform_device *ofdev)
 	dev_set_drvdata(&ofdev->dev, gpt);
 
 	mpc52xx_gpt_gpio_setup(gpt);
-	mpc52xx_gpt_irq_setup(gpt, ofdev->dev.of_node);
+	mpc52xx_gpt_irq_setup(gpt);
 
 	mutex_lock(&mpc52xx_gpt_list_mutex);
 	list_add(&gpt->list, &mpc52xx_gpt_list);
 	mutex_unlock(&mpc52xx_gpt_list_mutex);
 
 	/* check if this device could be a watchdog */
-	if (of_get_property(ofdev->dev.of_node, "fsl,has-wdt", NULL) ||
-	    of_get_property(ofdev->dev.of_node, "has-wdt", NULL)) {
-		const u32 *on_boot_wdt;
+	if (device_property_present(gpt->dev, "fsl,has-wdt") ||
+	    device_property_present(gpt->dev, "has-wdt")) {
+		u32 on_boot_wdt = 0;
+		int ret;
 
 		gpt->wdt_mode = MPC52xx_GPT_CAN_WDT;
-		on_boot_wdt = of_get_property(ofdev->dev.of_node,
-					      "fsl,wdt-on-boot", NULL);
-		if (on_boot_wdt) {
+		ret = device_property_read_u32(gpt->dev, "fsl,wdt-on-boot", &on_boot_wdt);
+		if (ret) {
+			dev_info(gpt->dev, "can function as watchdog\n");
+		} else {
 			dev_info(gpt->dev, "used as watchdog\n");
 			gpt->wdt_mode |= MPC52xx_GPT_IS_WDT;
-		} else
-			dev_info(gpt->dev, "can function as watchdog\n");
+		}
 		mpc52xx_gpt_wdt_setup(gpt, on_boot_wdt);
 	}
 
-- 
2.35.1

