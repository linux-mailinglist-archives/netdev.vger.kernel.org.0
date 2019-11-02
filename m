Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F99ECCAA
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 02:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKBBOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 21:14:17 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:33019 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728027AbfKBBOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 21:14:16 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5A7FA22F99;
        Sat,  2 Nov 2019 02:14:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572657254;
        bh=HasNe59EriHKNWIjhQxCq1uV9us9lQpNyWOkluI4I2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyz8JYPqsqOKHei0ZmXHuLOWJGA1L7UaPF0nhIU13aAXV5ElhwhpjgYYfzCX/M91V
         mixdO+ph6ZLIrDwcASymim7Dnv0F1w3nk84zMS7fNRqSbYQZTFxCJ8Ye7w6Q/fT0++
         76B8HjJgAfAcRftE4Sal+vR74xrDb+EUUzbhg1lk=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>
Subject: [PATCH 4/5] net: phy: at803x: mention AR8033 as same as AR8031
Date:   Sat,  2 Nov 2019 02:13:50 +0100
Message-Id: <20191102011351.6467-5-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191102011351.6467-1-michael@walle.cc>
References: <20191102011351.6467-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AR8033 is the AR8031 without PTP support. All other registers are
the same. Unfortunately, they share the same PHY ID. Therefore, we
cannot distinguish between the one with PTP support and the one without.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/Kconfig  |  2 +-
 drivers/net/phy/at803x.c | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 1b884ebb4e48..8bccadf17e60 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -442,7 +442,7 @@ config NXP_TJA11XX_PHY
 config AT803X_PHY
 	tristate "Qualcomm Atheros AR803X PHYs"
 	help
-	  Currently supports the AR8030, AR8031 and AR8035 model
+	  Currently supports the AR8030, AR8031, AR8033 and AR8035 model
 
 config QSEMI_PHY
 	tristate "Quality Semiconductor PHYs"
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index a30a2ff57068..49a1eebc7825 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -94,7 +94,7 @@
 #define AT803X_CLK_OUT_125MHZ_DSP		7
 
 /* Unfortunately, the AR8035 has another mask which is incompatible
- * with the AR8031 PHY. Also, it only supports 25MHz and 50MHz.
+ * with the AR8031/AR8033 PHY. Also, it only supports 25MHz and 50MHz.
  */
 #define AT8035_CLK_OUT_MASK			GENMASK(4, 3)
 
@@ -450,7 +450,9 @@ static int at803x_parse_dt(struct phy_device *phydev)
 		}
 	}
 
-	/* Only supported on AR8031, the AR8030/AR8035 use strapping options */
+	/* Only supported on AR8031/AR8033, the AR8030/AR8035 use strapping
+	 * options.
+	 */
 	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
 		if (of_property_read_bool(node, "qca,keep-pll-enabled"))
 			priv->flags |= AT803X_KEEP_PLL_ENABLED;
@@ -735,9 +737,9 @@ static struct phy_driver at803x_driver[] = {
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
 }, {
-	/* ATHEROS 8031 */
+	/* ATHEROS 8031/8033 */
 	.phy_id			= ATH8031_PHY_ID,
-	.name			= "Atheros 8031 ethernet",
+	.name			= "Atheros 8031/8033 ethernet",
 	.phy_id_mask		= AT803X_PHY_ID_MASK,
 	.probe			= at803x_probe,
 	.config_init		= at803x_config_init,
-- 
2.20.1

