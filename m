Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434C946AF0E
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378318AbhLGAZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:25:12 -0500
Received: from aposti.net ([89.234.176.197]:52500 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378304AbhLGAZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:25:09 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 4/5] mmc: jz4740: Use the new PM macros
Date:   Tue,  7 Dec 2021 00:21:01 +0000
Message-Id: <20211207002102.26414-5-paul@crapouillou.net>
In-Reply-To: <20211207002102.26414-1-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Use DEFINE_SIMPLE_DEV_PM_OPS() instead of the SIMPLE_DEV_PM_OPS()
  macro. This makes it possible to remove the __maybe_unused flags on
  the callback functions.
- Since we only have callbacks for suspend/resume, we can conditionally
  compile the dev_pm_ops structure for when CONFIG_PM_SLEEP is enabled;
  so use the pm_sleep_ptr() macro instead of pm_ptr().

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/mmc/host/jz4740_mmc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 80a2c270d502..bb612fce7ead 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1103,17 +1103,17 @@ static int jz4740_mmc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __maybe_unused jz4740_mmc_suspend(struct device *dev)
+static int jz4740_mmc_suspend(struct device *dev)
 {
 	return pinctrl_pm_select_sleep_state(dev);
 }
 
-static int __maybe_unused jz4740_mmc_resume(struct device *dev)
+static int jz4740_mmc_resume(struct device *dev)
 {
 	return pinctrl_select_default_state(dev);
 }
 
-static SIMPLE_DEV_PM_OPS(jz4740_mmc_pm_ops, jz4740_mmc_suspend,
+DEFINE_SIMPLE_DEV_PM_OPS(jz4740_mmc_pm_ops, jz4740_mmc_suspend,
 	jz4740_mmc_resume);
 
 static struct platform_driver jz4740_mmc_driver = {
@@ -1123,7 +1123,7 @@ static struct platform_driver jz4740_mmc_driver = {
 		.name = "jz4740-mmc",
 		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
 		.of_match_table = of_match_ptr(jz4740_mmc_of_match),
-		.pm = pm_ptr(&jz4740_mmc_pm_ops),
+		.pm = pm_sleep_ptr(&jz4740_mmc_pm_ops),
 	},
 };
 
-- 
2.33.0

