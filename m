Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134363ED381
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbhHPMAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:00:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:54602 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233017AbhHPMAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:00:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="237908839"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="237908839"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="530472812"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2021 05:00:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id F01D394; Mon, 16 Aug 2021 15:00:02 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Subject: [PATCH v1 1/6] gpio: mlxbf2: Convert to device PM ops
Date:   Mon, 16 Aug 2021 14:59:48 +0300
Message-Id: <20210816115953.72533-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert driver to use modern device PM ops interface.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index befa5e109943..68c471c10fa4 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -47,12 +47,10 @@
 #define YU_GPIO_MODE0_SET		0x54
 #define YU_GPIO_MODE0_CLEAR		0x58
 
-#ifdef CONFIG_PM
 struct mlxbf2_gpio_context_save_regs {
 	u32 gpio_mode0;
 	u32 gpio_mode1;
 };
-#endif
 
 /* BlueField-2 gpio block context structure. */
 struct mlxbf2_gpio_context {
@@ -61,9 +59,7 @@ struct mlxbf2_gpio_context {
 	/* YU GPIO blocks address */
 	void __iomem *gpio_io;
 
-#ifdef CONFIG_PM
 	struct mlxbf2_gpio_context_save_regs *csave_regs;
-#endif
 };
 
 /* BlueField-2 gpio shared structure. */
@@ -284,11 +280,9 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int mlxbf2_gpio_suspend(struct platform_device *pdev,
-				pm_message_t state)
+static int __maybe_unused mlxbf2_gpio_suspend(struct device *dev)
 {
-	struct mlxbf2_gpio_context *gs = platform_get_drvdata(pdev);
+	struct mlxbf2_gpio_context *gs = dev_get_drvdata(dev);
 
 	gs->csave_regs->gpio_mode0 = readl(gs->gpio_io +
 		YU_GPIO_MODE0);
@@ -298,9 +292,9 @@ static int mlxbf2_gpio_suspend(struct platform_device *pdev,
 	return 0;
 }
 
-static int mlxbf2_gpio_resume(struct platform_device *pdev)
+static int __maybe_unused mlxbf2_gpio_resume(struct device *dev)
 {
-	struct mlxbf2_gpio_context *gs = platform_get_drvdata(pdev);
+	struct mlxbf2_gpio_context *gs = dev_get_drvdata(dev);
 
 	writel(gs->csave_regs->gpio_mode0, gs->gpio_io +
 		YU_GPIO_MODE0);
@@ -309,7 +303,7 @@ static int mlxbf2_gpio_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#endif
+static SIMPLE_DEV_PM_OPS(mlxbf2_pm_ops, mlxbf2_gpio_suspend, mlxbf2_gpio_resume);
 
 static const struct acpi_device_id __maybe_unused mlxbf2_gpio_acpi_match[] = {
 	{ "MLNXBF22", 0 },
@@ -321,12 +315,9 @@ static struct platform_driver mlxbf2_gpio_driver = {
 	.driver = {
 		.name = "mlxbf2_gpio",
 		.acpi_match_table = ACPI_PTR(mlxbf2_gpio_acpi_match),
+		.pm = &mlxbf2_pm_ops,
 	},
 	.probe    = mlxbf2_gpio_probe,
-#ifdef CONFIG_PM
-	.suspend  = mlxbf2_gpio_suspend,
-	.resume   = mlxbf2_gpio_resume,
-#endif
 };
 
 module_platform_driver(mlxbf2_gpio_driver);
-- 
2.30.2

