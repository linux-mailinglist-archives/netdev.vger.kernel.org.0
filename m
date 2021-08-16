Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4233ED396
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbhHPMB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:01:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:17264 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhHPMBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:01:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="301429167"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="301429167"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 05:00:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="441058459"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 16 Aug 2021 05:00:03 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 0F91512B; Mon, 16 Aug 2021 15:00:03 +0300 (EEST)
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
Subject: [PATCH v1 3/6] gpio: mlxbf2: Use devm_platform_ioremap_resource()
Date:   Mon, 16 Aug 2021 14:59:50 +0300
Message-Id: <20210816115953.72533-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the platform_get_resource() and devm_ioremap_resource()
calls with devm_platform_ioremap_resource().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/gpio/gpio-mlxbf2.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/gpio/gpio-mlxbf2.c b/drivers/gpio/gpio-mlxbf2.c
index c0aa622fef76..c193d1a9a5dd 100644
--- a/drivers/gpio/gpio-mlxbf2.c
+++ b/drivers/gpio/gpio-mlxbf2.c
@@ -228,7 +228,6 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 	struct mlxbf2_gpio_context *gs;
 	struct device *dev = &pdev->dev;
 	struct gpio_chip *gc;
-	struct resource *res;
 	unsigned int npins;
 	int ret;
 
@@ -237,13 +236,9 @@ mlxbf2_gpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* YU GPIO block address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
-	gs->gpio_io = devm_ioremap(dev, res->start, resource_size(res));
-	if (!gs->gpio_io)
-		return -ENOMEM;
+	gs->gpio_io = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(gs->gpio_io))
+		return PTR_ERR(gs->gpio_io);
 
 	ret = mlxbf2_gpio_get_lock_res(pdev);
 	if (ret) {
-- 
2.30.2

