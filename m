Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3609746A12F
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377548AbhLFQ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:27:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:44750 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376747AbhLFQ1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:27:00 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="237160181"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="237160181"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 08:23:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="605082770"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 06 Dec 2021 08:23:27 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 14B38B8; Mon,  6 Dec 2021 18:23:33 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 2/4] can: hi311x: try to get crystal clock rate from property
Date:   Mon,  6 Dec 2021 18:23:21 +0200
Message-Id: <20211206162323.29281-2-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206162323.29281-1-andriy.shevchenko@linux.intel.com>
References: <20211206162323.29281-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, mainly ACPI-based, the clock frequency of the
device is supplied by very well established 'clock-frequency'
property. Hence, try to get it from the property at last if no other
providers are available.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/hi311x.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 13fb979645cf..1e4ff904be0f 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -828,19 +828,26 @@ MODULE_DEVICE_TABLE(spi, hi3110_id_table);
 
 static int hi3110_can_probe(struct spi_device *spi)
 {
-	const struct of_device_id *of_id = of_match_device(hi3110_of_match,
-							   &spi->dev);
+	struct device *dev = &spi->dev;
 	struct net_device *net;
 	struct hi3110_priv *priv;
 	struct clk *clk;
-	int freq, ret;
+	u32 freq;
+	int ret;
 
 	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&spi->dev, "no CAN clock source defined\n");
 		return PTR_ERR(clk);
 	}
-	freq = clk_get_rate(clk);
+
+	if (clk) {
+		freq = clk_get_rate(clk);
+	} else {
+		ret = device_property_read_u32(dev, "clock-frequency", &freq);
+		if (ret)
+			return dev_err_probe(dev, ret, "Failed to get clock-frequency!\n");
+	}
 
 	/* Sanity check */
 	if (freq > 40000000)
-- 
2.33.0

