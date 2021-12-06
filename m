Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A92A46A13B
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379634AbhLFQ1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:27:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:40001 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379238AbhLFQ1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:27:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="300732988"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="300732988"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 08:23:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="679041657"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 06 Dec 2021 08:23:27 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 07EE7144; Mon,  6 Dec 2021 18:23:32 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 1/4] can: hi311x: Use devm_clk_get_optional() to get the input clock
Date:   Mon,  6 Dec 2021 18:23:20 +0200
Message-Id: <20211206162323.29281-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not clear what was the intention of redundant usage of IS_ERR()
around the clock pointer since with the error check of devm_clk_get()
followed by bailout it can't be invalid,

Simplify the code which fetches the input clock by using
devm_clk_get_optional(). It will allow to switch to device properties
approach in the future.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/hi311x.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 89d9c986a229..13fb979645cf 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -835,7 +835,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 	struct clk *clk;
 	int freq, ret;
 
-	clk = devm_clk_get(&spi->dev, NULL);
+	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&spi->dev, "no CAN clock source defined\n");
 		return PTR_ERR(clk);
@@ -851,11 +851,9 @@ static int hi3110_can_probe(struct spi_device *spi)
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
 
 	net->netdev_ops = &hi3110_netdev_ops;
 	net->flags |= IFF_ECHO;
@@ -938,8 +936,7 @@ static int hi3110_can_probe(struct spi_device *spi)
 	hi3110_power_enable(priv->power, 0);
 
  out_clk:
-	if (!IS_ERR(clk))
-		clk_disable_unprepare(clk);
+	clk_disable_unprepare(clk);
 
  out_free:
 	free_candev(net);
@@ -957,8 +954,7 @@ static int hi3110_can_remove(struct spi_device *spi)
 
 	hi3110_power_enable(priv->power, 0);
 
-	if (!IS_ERR(priv->clk))
-		clk_disable_unprepare(priv->clk);
+	clk_disable_unprepare(priv->clk);
 
 	free_candev(net);
 
-- 
2.33.0

