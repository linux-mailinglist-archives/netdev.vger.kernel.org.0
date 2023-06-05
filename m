Return-Path: <netdev+bounces-8105-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76864722B78
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D50701C2095E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6BDC22601;
	Mon,  5 Jun 2023 15:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF4C1F93A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:40:23 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE4AE4B;
	Mon,  5 Jun 2023 08:40:20 -0700 (PDT)
Received: from arisu.mtl.collabora.ca (mtl.collabora.ca [66.171.169.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id DE055660036A;
	Mon,  5 Jun 2023 16:40:17 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685979619;
	bh=pTp6/xk/Wg5wGQWw/vjAgqilJMAtoUJefEJPkScDWl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1OzFLkh72ZNfGgey0ZL3otcPLcUv/LkTVp4ChTBsreaddqesNNasKhY8YiqvZ1yp
	 vrd/u6f53c06Hr/BAAgyWFj2qkH6q/5xkiSkMdPNDxG8DU/DhlbMSAKgurRqAe+7LH
	 19FveSBeXeiGBz1LB7ZT9yQ2AivStSzOFgvHvIPuzDGCEA+KGcg/Ea77qsxxSDFrLk
	 XIYtAgu8unZcVqLdRp4dIu+WLSobvCgnf/52qBNVL682PaYh9j5D9nfhOq6cPCYx/z
	 DDuMAteufcIUIYAgTtyjYnJAl5CodOT6CTnRLdCJrUrzHkCGLHRA7a/HArc5GpPwa6
	 FUAY8b75bqbLg==
From: Detlev Casanova <detlev.casanova@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH v4 3/3] net: phy: realtek: Disable clock on suspend
Date: Mon,  5 Jun 2023 11:40:10 -0400
Message-Id: <20230605154010.49611-4-detlev.casanova@collabora.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230605154010.49611-1-detlev.casanova@collabora.com>
References: <20230605154010.49611-1-detlev.casanova@collabora.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For PHYs that call rtl821x_probe() where an external clock can be
configured, make sure that the clock is disabled
when ->suspend() is called and enabled on resume.

The PHY_ALWAYS_CALL_SUSPEND is added to ensure that the suspend function
is actually always called.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
---
 drivers/net/phy/realtek.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index b13dd0b3c99e..894172a3e15f 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -426,10 +426,31 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int rtl821x_suspend(struct phy_device *phydev)
+{
+	struct rtl821x_priv *priv = phydev->priv;
+	int ret = 0;
+
+	if (!phydev->wol_enabled) {
+		ret = genphy_suspend(phydev);
+
+		if (ret)
+			return ret;
+
+		clk_disable_unprepare(priv->clk);
+	}
+
+	return ret;
+}
+
 static int rtl821x_resume(struct phy_device *phydev)
 {
+	struct rtl821x_priv *priv = phydev->priv;
 	int ret;
 
+	if (!phydev->wol_enabled)
+		clk_prepare_enable(priv->clk);
+
 	ret = genphy_resume(phydev);
 	if (ret < 0)
 		return ret;
@@ -934,10 +955,11 @@ static struct phy_driver realtek_drvs[] = {
 		.read_status	= rtlgen_read_status,
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
-		.suspend	= genphy_suspend,
+		.suspend	= rtl821x_suspend,
 		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.flags		= PHY_ALWAYS_CALL_SUSPEND,
 	}, {
 		PHY_ID_MATCH_EXACT(RTL_8211FVD_PHYID),
 		.name		= "RTL8211F-VD Gigabit Ethernet",
@@ -946,10 +968,11 @@ static struct phy_driver realtek_drvs[] = {
 		.read_status	= rtlgen_read_status,
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
-		.suspend	= genphy_suspend,
+		.suspend	= rtl821x_suspend,
 		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.flags		= PHY_ALWAYS_CALL_SUSPEND,
 	}, {
 		.name		= "Generic FE-GE Realtek PHY",
 		.match_phy_device = rtlgen_match_phy_device,
-- 
2.39.3


