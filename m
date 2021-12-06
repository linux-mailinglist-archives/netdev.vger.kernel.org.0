Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E170146A135
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379312AbhLFQ1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:27:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:25573 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379238AbhLFQ1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:27:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="298147080"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="298147080"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 08:23:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="542444034"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2021 08:23:27 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 2856D1A0; Mon,  6 Dec 2021 18:23:33 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 4/4] can: hi311x: Convert to use dev_err_probe()
Date:   Mon,  6 Dec 2021 18:23:23 +0200
Message-Id: <20211206162323.29281-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206162323.29281-1-andriy.shevchenko@linux.intel.com>
References: <20211206162323.29281-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When deferred the reason is saved for further debugging. Besides that,
it's fine to call dev_err_probe() in ->probe() when error code is known.
Convert the driver to use dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/hi311x.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 78044ec24575..a17641d36468 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -837,10 +837,8 @@ static int hi3110_can_probe(struct spi_device *spi)
 	int ret;
 
 	clk = devm_clk_get_optional(&spi->dev, NULL);
-	if (IS_ERR(clk)) {
-		dev_err(&spi->dev, "no CAN clock source defined\n");
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "no CAN clock source defined\n");
 
 	if (clk) {
 		freq = clk_get_rate(clk);
@@ -925,9 +923,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 
 	ret = hi3110_hw_probe(spi);
 	if (ret) {
-		if (ret == -ENODEV)
-			dev_err(&spi->dev, "Cannot initialize %x. Wrong wiring?\n",
-				priv->model);
+		dev_err_probe(dev, ret, "Cannot initialize %x. Wrong wiring?\n", priv->model);
 		goto error_probe;
 	}
 	hi3110_hw_sleep(spi);
@@ -950,8 +946,7 @@ static int hi3110_can_probe(struct spi_device *spi)
  out_free:
 	free_candev(net);
 
-	dev_err(&spi->dev, "Probe failed, err=%d\n", -ret);
-	return ret;
+	return dev_err_probe(dev, ret, "Probe failed\n");
 }
 
 static int hi3110_can_remove(struct spi_device *spi)
-- 
2.33.0

