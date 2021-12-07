Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B9A46AF11
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378338AbhLGAZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:25:18 -0500
Received: from aposti.net ([89.234.176.197]:52512 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378271AbhLGAZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:25:18 -0500
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
Subject: [PATCH 5/5] mmc: mxc: Use the new PM macros
Date:   Tue,  7 Dec 2021 00:21:02 +0000
Message-Id: <20211207002102.26414-6-paul@crapouillou.net>
In-Reply-To: <20211207002102.26414-1-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_SIMPLE_DEV_PM_OPS() instead of the SIMPLE_DEV_PM_OPS()
macro, along with using pm_sleep_ptr() as this driver doesn't handle
runtime PM. This makes it possible to remove the #ifdef CONFIG_PM
guard around the suspend/resume functions.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 drivers/mmc/host/mxcmmc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 2fe6fcdbb1b3..98c218bd6669 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -1183,7 +1183,6 @@ static int mxcmci_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int mxcmci_suspend(struct device *dev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(dev);
@@ -1210,9 +1209,8 @@ static int mxcmci_resume(struct device *dev)
 
 	return ret;
 }
-#endif
 
-static SIMPLE_DEV_PM_OPS(mxcmci_pm_ops, mxcmci_suspend, mxcmci_resume);
+DEFINE_SIMPLE_DEV_PM_OPS(mxcmci_pm_ops, mxcmci_suspend, mxcmci_resume);
 
 static struct platform_driver mxcmci_driver = {
 	.probe		= mxcmci_probe,
@@ -1220,7 +1218,7 @@ static struct platform_driver mxcmci_driver = {
 	.driver		= {
 		.name		= DRIVER_NAME,
 		.probe_type	= PROBE_PREFER_ASYNCHRONOUS,
-		.pm	= &mxcmci_pm_ops,
+		.pm	= pm_sleep_ptr(&mxcmci_pm_ops),
 		.of_match_table	= mxcmci_of_match,
 	}
 };
-- 
2.33.0

