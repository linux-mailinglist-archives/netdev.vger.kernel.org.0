Return-Path: <netdev+bounces-11799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6039F7347AC
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 20:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 917071C20923
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 18:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2C6BA25;
	Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A348A93E
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 18:41:46 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A21196
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 11:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=mE4oo0ypC52IUN3a0oJSnBJy+TOwCuQjAtwAUMgrmJc=; b=lz+RwQzYyb+NPtlG74wvvq+hTw
	YeCaK5LxschYcQrD5/IvQTT8/mRJ5u9R2Jmd7Id+Rzf6+cpmYabFPXdiivqwOXys1Q4+X9syg3OQU
	BXXShofG25Ih+WRufTjK6Qbr/g3rM0SLb9JAqiR8uzXVvAdWOzUExfIVBf8KUqUj97K0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qAxLC-00Gr3Q-NF; Sun, 18 Jun 2023 20:41:34 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v4 net-next 8/9] net: fec: Move fec_enet_eee_mode_set() and helper earlier
Date: Sun, 18 Jun 2023 20:41:18 +0200
Message-Id: <20230618184119.4017149-9-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230618184119.4017149-1-andrew@lunn.ch>
References: <20230618184119.4017149-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

FEC is about to get its EEE code re-written. To allow this, move
fec_enet_eee_mode_set() before fec_enet_adjust_link() which will
need to call it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 79 ++++++++++++-----------
 1 file changed, 40 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 4d37a811ae15..69c62e49c7e6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1904,6 +1904,46 @@ static int fec_get_mac(struct net_device *ndev)
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
@@ -3044,45 +3084,6 @@ static int fec_enet_set_tunable(struct net_device *netdev,
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
2.40.1


