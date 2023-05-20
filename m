Return-Path: <netdev+bounces-4077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A55C70A902
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 18:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E64B2811C2
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 16:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBC06FC5;
	Sat, 20 May 2023 16:13:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF47A2C9A
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 16:13:38 +0000 (UTC)
X-Greylist: delayed 373 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 20 May 2023 09:13:37 PDT
Received: from smtp.missinglinkelectronics.com (smtp.missinglinkelectronics.com [162.55.135.183])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7650BC4
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 09:13:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp.missinglinkelectronics.com (Postfix) with ESMTP id ECE4D206AF;
	Sat, 20 May 2023 18:07:25 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at missinglinkelectronics.com
Received: from smtp.missinglinkelectronics.com ([127.0.0.1])
	by localhost (mail.missinglinkelectronics.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nJO6GcfklEPP; Sat, 20 May 2023 18:07:25 +0200 (CEST)
Received: from humpen-bionic2.mle (p578c5bfe.dip0.t-ipconnect.de [87.140.91.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: david)
	by smtp.missinglinkelectronics.com (Postfix) with ESMTPSA id 6D8AA2061D;
	Sat, 20 May 2023 18:07:25 +0200 (CEST)
From: David Epping <david.epping@missinglinkelectronics.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	David Epping <david.epping@missinglinkelectronics.com>
Subject: [PATCH net 3/3] net: phy: mscc: enable VSC8501/2 RGMII RX clock
Date: Sat, 20 May 2023 18:06:03 +0200
Message-Id: <20230520160603.32458-4-david.epping@missinglinkelectronics.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
References: <20230520160603.32458-1-david.epping@missinglinkelectronics.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

By default the VSC8501 and VSC8502 RGMII RX clock output is disabled.
To allow packet forwarding towards the MAC it needs to be enabled.
The same may be necessary for GMII and MII modes, but that's currently
unclear.

For VSC853x and VSC854x the respective disable bit is reserved and the
clock output is enabled by default.

Signed-off-by: David Epping <david.epping@missinglinkelectronics.com>
---
 drivers/net/phy/mscc/mscc.h      |  1 +
 drivers/net/phy/mscc/mscc_main.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 79cbb2418664..defe5cc6d4fc 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -179,6 +179,7 @@ enum rgmii_clock_delay {
 #define VSC8502_RGMII_CNTL		  20
 #define VSC8502_RGMII_RX_DELAY_MASK	  0x0070
 #define VSC8502_RGMII_TX_DELAY_MASK	  0x0007
+#define VSC8502_RGMII_RX_CLK_DISABLE	  0x0800
 
 #define MSCC_PHY_WOL_LOWER_MAC_ADDR	  21
 #define MSCC_PHY_WOL_MID_MAC_ADDR	  22
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 29fc27a16805..c7a8f5561c66 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -547,6 +547,26 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
 	return rc;
 }
 
+/* For VSC8501 and VSC8502 the RGMII RX clock output is disabled by default. */
+static int vsc85xx_rgmii_enable_rx_clk(struct phy_device *phydev,
+				       u32 rgmii_cntl)
+{
+	int rc, phy_id;
+
+	phy_id = phydev->drv->phy_id & phydev->drv->phy_id_mask;
+	if (PHY_ID_VSC8501 != phy_id && PHY_ID_VSC8502 != phy_id)
+		return 0;
+
+	mutex_lock(&phydev->lock);
+
+	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2, rgmii_cntl,
+			      VSC8502_RGMII_RX_CLK_DISABLE, 0);
+
+	mutex_unlock(&phydev->lock);
+
+	return rc;
+}
+
 static int vsc85xx_default_config(struct phy_device *phydev)
 {
 	int rc;
@@ -559,6 +579,10 @@ static int vsc85xx_default_config(struct phy_device *phydev)
 					     VSC8502_RGMII_TX_DELAY_MASK);
 		if (rc)
 			return rc;
+
+		rc = vsc85xx_rgmii_enable_rx_clk(phydev, VSC8502_RGMII_CNTL);
+		if (rc)
+			return rc;
 	}
 
 	return 0;
-- 
2.17.1


