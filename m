Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69427F21E5
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732934AbfKFWhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:37:31 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:48345 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbfKFWg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 17:36:59 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 317CB23E4A;
        Wed,  6 Nov 2019 23:36:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573079817;
        bh=bHgzmPWMQvRLD4IDF6kRyjvUWHwW1NVG2ZzBKrWk2cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5r7NCOuLDM+GY2Md38faRERyiNuUNtONA1JvvJmarD9B/Ba72YVr+F8ryeCspVrH
         3eQKOhuLu/Jp2Ud/hXMROrk2iv9pwkn0JZhvOKqa7IRLZfUJvPlp3lYPGV+RrQOF6O
         +cmbr8572/zwexutMVoIa2T+7u3hNh+bYAq+28l4=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 4/6] net: phy: at803x: mention AR8033 as same as AR8031
Date:   Wed,  6 Nov 2019 23:36:15 +0100
Message-Id: <20191106223617.1655-5-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106223617.1655-1-michael@walle.cc>
References: <20191106223617.1655-1-michael@walle.cc>
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
 drivers/net/phy/at803x.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

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
index aa782b28615b..716672edd415 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -93,8 +93,8 @@
 #define AT803X_CLK_OUT_125MHZ_PLL		6
 #define AT803X_CLK_OUT_125MHZ_DSP		7
 
-/* The AR8035 has another mask which is compatible with the AR8031 mask but
- * doesn't support choosing between XTAL/PLL and DSP.
+/* The AR8035 has another mask which is compatible with the AR8031/AR8033 mask
+ * but doesn't support choosing between XTAL/PLL and DSP.
  */
 #define AT8035_CLK_OUT_MASK			GENMASK(4, 3)
 
@@ -449,7 +449,9 @@ static int at803x_parse_dt(struct phy_device *phydev)
 		}
 	}
 
-	/* Only supported on AR8031, the AR8030/AR8035 use strapping options */
+	/* Only supported on AR8031/AR8033, the AR8030/AR8035 use strapping
+	 * options.
+	 */
 	if (at803x_match_phy_id(phydev, ATH8031_PHY_ID)) {
 		if (of_property_read_bool(node, "qca,keep-pll-enabled"))
 			priv->flags |= AT803X_KEEP_PLL_ENABLED;
@@ -734,9 +736,9 @@ static struct phy_driver at803x_driver[] = {
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

