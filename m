Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D4B3ED383
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhHPMAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:00:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:29352 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231390AbhHPMAh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:00:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="212726701"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="212726701"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="487324077"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2021 05:00:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 08A10107; Mon, 16 Aug 2021 15:00:02 +0300 (EEST)
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
Subject: [PATCH v1 2/6] gpio: mlxbf2: Drop wrong use of ACPI_PTR()
Date:   Mon, 16 Aug 2021 14:59:49 +0300
Message-Id: <20210816115953.72533-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ACPI_PTR() is more harmful than helpful. For example, in this case
if CONFIG_ACPI=n, the ID table left unused which is not what we want.

Instead of adding ifdeffery here and there, drop ACPI_PTR() and
replace acpi.h with mod_devicetable.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index 68c471c10fa4..c0aa622fef76 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/bitops.h>
 #include <linux/device.h>
@@ -8,6 +7,7 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
+#include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -307,14 +307,14 @@ static SIMPLE_DEV_PM_OPS(mlxbf2_pm_ops, mlxbf2_gpio_suspend, mlxbf2_gpio_resume)
 
 static const struct acpi_device_id __maybe_unused mlxbf2_gpio_acpi_match[] = {
 	{ "MLNXBF22", 0 },
-	{},
+	{}
 };
 MODULE_DEVICE_TABLE(acpi, mlxbf2_gpio_acpi_match);
 
 static struct platform_driver mlxbf2_gpio_driver = {
 	.driver = {
 		.name = "mlxbf2_gpio",
-		.acpi_match_table = ACPI_PTR(mlxbf2_gpio_acpi_match),
+		.acpi_match_table = mlxbf2_gpio_acpi_match,
 		.pm = &mlxbf2_pm_ops,
 	},
 	.probe    = mlxbf2_gpio_probe,
-- 
2.30.2

