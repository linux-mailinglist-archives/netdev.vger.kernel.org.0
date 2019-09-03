Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7356FA68C7
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfICMnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:43:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:38782 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729067AbfICMnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 08:43:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 05:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="357724988"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 03 Sep 2019 05:43:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B8DE7BD; Tue,  3 Sep 2019 15:42:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/4] can: mcp251x: Use devm_clk_get_optional() to get the input clock
Date:   Tue,  3 Sep 2019 15:42:56 +0300
Message-Id: <20190903124259.60920-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
References: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the code which fetches the input clock by using
devm_clk_get_optional(). This comes with a small functional change: previously
all errors were ignored when platform data is present. Now all errors are
treated as errors. If no input clock is present devm_clk_get_optional() will
return NULL instead of an error which matches the behavior of the old code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/mcp251x.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 58992fd61cb9..e04b578f2b1f 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1014,15 +1014,13 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	struct clk *clk;
 	int freq, ret;
 
-	clk = devm_clk_get(&spi->dev, NULL);
-	if (IS_ERR(clk)) {
-		if (pdata)
-			freq = pdata->oscillator_frequency;
-		else
-			return PTR_ERR(clk);
-	} else {
-		freq = clk_get_rate(clk);
-	}
+	clk = devm_clk_get_optional(&spi->dev, NULL);
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	freq = clk_get_rate(clk);
+	if (freq == 0 && pdata)
+		freq = pdata->oscillator_frequency;
 
 	/* Sanity check */
 	if (freq < 1000000 || freq > 25000000)
@@ -1033,11 +1031,9 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	if (!net)
 		return -ENOMEM;
 
-	if (!IS_ERR(clk)) {
-		ret = clk_prepare_enable(clk);
-		if (ret)
-			goto out_free;
-	}
+	ret = clk_prepare_enable(clk);
+	if (ret)
+		goto out_free;
 
 	net->netdev_ops = &mcp251x_netdev_ops;
 	net->flags |= IFF_ECHO;
@@ -1122,8 +1118,7 @@ static int mcp251x_can_probe(struct spi_device *spi)
 	mcp251x_power_enable(priv->power, 0);
 
 out_clk:
-	if (!IS_ERR(clk))
-		clk_disable_unprepare(clk);
+	clk_disable_unprepare(clk);
 
 out_free:
 	free_candev(net);
@@ -1141,8 +1136,7 @@ static int mcp251x_can_remove(struct spi_device *spi)
 
 	mcp251x_power_enable(priv->power, 0);
 
-	if (!IS_ERR(priv->clk))
-		clk_disable_unprepare(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
 
-- 
2.23.0.rc1

