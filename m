Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F569A487
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjBQDnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjBQDm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:42:59 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8280713500
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W4YdDWf/ZfXoNp0eW0XBGH4diC+x1T1UIoNkkfx1asA=; b=u/KyPKYw90n0N8YrKFOFesDHPw
        h9QvzkA7BTy03caB2JEey64fwE7M/ac8QNa99ctI9QT6DbY7FYO81sTSM1FCKf5+TAyT9Q69hDnGb
        Cj7h6Zoj41Q4eLilsc1VZTUq7cA63um98qd4tnKrOMCm0A6sSQ3cMHRFa84lDSuMlOr8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSre0-005F6R-4z; Fri, 17 Feb 2023 04:42:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 07/18] net: fec: Move fec_enet_eee_mode_set() and helper earlier
Date:   Fri, 17 Feb 2023 04:42:19 +0100
Message-Id: <20230217034230.1249661-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FEC is about to get its EEE code re-written. To allow this, move
fec_enet_eee_mode_set() before fec_enet_adjust_link() which will
need to call it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 79 ++++++++++++-----------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c73e25f8995e..195df75ee614 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1919,6 +1919,46 @@ static int fec_get_mac(struct net_device *ndev)
 /*
  * Phy section
  */
+
+/* LPI Sleep Ts count base on tx clk (clk_ref).
+ * The lpi sleep cnt value = X us / (cycle_ns).
+ */
+static int fec_enet_us_to_tx_cycle(struct net_device *ndev, int us)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	return us * (fep->clk_ref_rate / 1000) / 1000;
+}
+
+static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct ethtool_eee *p = &fep->eee;
+	unsigned int sleep_cycle, wake_cycle;
+	int ret = 0;
+
+	if (enable) {
+		ret = phy_init_eee(ndev->phydev, false);
+		if (ret)
+			return ret;
+
+		sleep_cycle = fec_enet_us_to_tx_cycle(ndev, p->tx_lpi_timer);
+		wake_cycle = sleep_cycle;
+	} else {
+		sleep_cycle = 0;
+		wake_cycle = 0;
+	}
+
+	p->tx_lpi_enabled = enable;
+	p->eee_enabled = enable;
+	p->eee_active = enable;
+
+	writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
+	writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
+
+	return 0;
+}
+
 static void fec_enet_adjust_link(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -3057,45 +3097,6 @@ static int fec_enet_set_tunable(struct net_device *netdev,
 	return ret;
 }
 
-/* LPI Sleep Ts count base on tx clk (clk_ref).
- * The lpi sleep cnt value = X us / (cycle_ns).
- */
-static int fec_enet_us_to_tx_cycle(struct net_device *ndev, int us)
-{
-	struct fec_enet_private *fep = netdev_priv(ndev);
-
-	return us * (fep->clk_ref_rate / 1000) / 1000;
-}
-
-static int fec_enet_eee_mode_set(struct net_device *ndev, bool enable)
-{
-	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct ethtool_eee *p = &fep->eee;
-	unsigned int sleep_cycle, wake_cycle;
-	int ret = 0;
-
-	if (enable) {
-		ret = phy_init_eee(ndev->phydev, false);
-		if (ret)
-			return ret;
-
-		sleep_cycle = fec_enet_us_to_tx_cycle(ndev, p->tx_lpi_timer);
-		wake_cycle = sleep_cycle;
-	} else {
-		sleep_cycle = 0;
-		wake_cycle = 0;
-	}
-
-	p->tx_lpi_enabled = enable;
-	p->eee_enabled = enable;
-	p->eee_active = enable;
-
-	writel(sleep_cycle, fep->hwp + FEC_LPI_SLEEP);
-	writel(wake_cycle, fep->hwp + FEC_LPI_WAKE);
-
-	return 0;
-}
-
 static int
 fec_enet_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
-- 
2.39.1

