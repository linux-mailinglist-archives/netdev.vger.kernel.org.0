Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B914A3920F2
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhEZTes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:34:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:17299 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234251AbhEZTeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 15:34:46 -0400
IronPort-SDR: YaI/khUR/StpxGKi6mv65lSK99MkJS6s0XqqtR7sO6TP+KVNcHzRmtBNEgLYC6Vv50b28u2TdL
 qtzOEIq88fPg==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="202314545"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="202314545"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:33:11 -0700
IronPort-SDR: u5Dsla4+nA3YXcRtVgubHz+WtYEUida1UdESPh5X61zZuSIm6ARXQRD1b5pTeA7eWHlTlWzYkl
 SAeRcmWumKrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="397439038"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 26 May 2021 12:33:09 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 5308CB7; Wed, 26 May 2021 22:33:31 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/2] can: mcp251xfd: Try to get crystal clock rate from property
Date:   Wed, 26 May 2021 22:33:26 +0300
Message-Id: <20210526193327.70468-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, mainly ACPI-based, the clock frequency of the device
is supplied by very well established 'clock-frequency' property. Hence, try
to get it from the property at last if no other providers are available.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: new patch
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index e0ae00e34c7b..e42f87c3f2ec 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2856,7 +2856,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	struct gpio_desc *rx_int;
 	struct regulator *reg_vdd, *reg_xceiver;
 	struct clk *clk;
-	u32 freq;
+	u32 freq, rate;
 	int err;
 
 	if (!spi->irq)
@@ -2883,11 +2883,16 @@ static int mcp251xfd_probe(struct spi_device *spi)
 		return dev_err_probe(&spi->dev, PTR_ERR(reg_xceiver),
 				     "Failed to get Transceiver regulator!\n");
 
-	clk = devm_clk_get(&spi->dev, NULL);
+	/* Always ask for fixed clock rate from a property. */
+	device_property_read_u32(&spi->dev, "clock-frequency", &rate);
+
+	clk = devm_clk_get_optional(&spi->dev, NULL);
 	if (IS_ERR(clk))
 		return dev_err_probe(&spi->dev, PTR_ERR(clk),
 				     "Failed to get Oscillator (clock)!\n");
 	freq = clk_get_rate(clk);
+	if (freq == 0)
+		freq = rate;
 
 	/* Sanity check */
 	if (freq < MCP251XFD_SYSCLOCK_HZ_MIN ||
-- 
2.30.2

