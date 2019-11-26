Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5C109B3F
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfKZJaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:30:13 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46737 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbfKZJaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:30:13 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iZXAg-0003KE-2e; Tue, 26 Nov 2019 10:30:10 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iZXAf-00059J-AB; Tue, 26 Nov 2019 10:30:09 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@protonic.nl
Subject: [PATCH v2] net: dsa: sja1105: print info about probed chip only after everything was done.
Date:   Tue, 26 Nov 2019 10:30:08 +0100
Message-Id: <20191126093008.19742-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we will get "Probed switch chip" notification multiple times
if first probe failed by some reason. To avoid this confusing notifications move
dev_info to the end of probe.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index aa140662c7c2..34544b1c30dc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2191,8 +2191,6 @@ static int sja1105_probe(struct spi_device *spi)
 		return rc;
 	}
 
-	dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
-
 	ds = dsa_switch_alloc(dev, SJA1105_NUM_PORTS);
 	if (!ds)
 		return -ENOMEM;
@@ -2218,7 +2216,13 @@ static int sja1105_probe(struct spi_device *spi)
 
 	sja1105_tas_setup(ds);
 
-	return dsa_register_switch(priv->ds);
+	rc = dsa_register_switch(priv->ds);
+	if (rc)
+		return rc;
+
+	dev_info(dev, "Probed switch chip: %s\n", priv->info->name);
+
+	return 0;
 }
 
 static int sja1105_remove(struct spi_device *spi)
-- 
2.24.0

