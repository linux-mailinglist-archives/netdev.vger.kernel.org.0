Return-Path: <netdev+bounces-8097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BB3722AD4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 526AE281366
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:21:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081532106B;
	Mon,  5 Jun 2023 15:20:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16D01F948
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:20:25 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897AA94;
	Mon,  5 Jun 2023 08:20:24 -0700 (PDT)
Received: from arisu.mtl.collabora.ca (mtl.collabora.ca [66.171.169.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id E42276600368;
	Mon,  5 Jun 2023 16:20:21 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685978423;
	bh=xpeq38cfgQQIS99Dt7IROQJs9BvsNDk2k4YOmuCa7/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAncdZhz14XT4YtegG7wiTpZWl/MO5695rm6EHGELS7WFTfsNcBNMJd0lbkDbuIgq
	 528JnaSeu1KrSDoxL191xi6mho6MuWqh1/pl7NcHn0DL2Hnztb0fjfOdD3194R4A2W
	 N//4KG2XO+mtim0AK08WrT+1Q5ugg8lI86b9q4Rju7L9sGH1mT0SGOZU1FskVBXfWd
	 PMkUHyZrMcUGHyQaF3TU2EwYMLoQVaQpmOQvCjuKd8fjzAoOTq/HNdHvyQ1DbTGZ9v
	 L35dbzM7uwnbpogz4/tgs+sUrY8p7nyJU5VFpFrjp4RhJ0Jvu1WFWLOTczly/UQzd1
	 9wKOVXVNl4qbQ==
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
Subject: [PATCH v3 3/3] net: phy: realtek: Disable clock on suspend
Date: Mon,  5 Jun 2023 11:19:53 -0400
Message-Id: <20230605151953.48539-4-detlev.casanova@collabora.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230605151953.48539-1-detlev.casanova@collabora.com>
References: <20230605151953.48539-1-detlev.casanova@collabora.com>
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
 drivers/net/phy/realtek.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index b13dd0b3c99e..62eac4835def 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -426,10 +426,28 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int rtl821x_suspend(struct phy_device *phydev)
+{
+	struct rtl821x_priv *priv = phydev->priv;
+	int ret = genphy_suspend(phydev);
+
+	if (ret)
+		return ret;
+
+	if (!phydev->wol_enabled)
+		clk_disable_unprepare(priv->clk);
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
@@ -934,10 +952,11 @@ static struct phy_driver realtek_drvs[] = {
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
@@ -946,10 +965,11 @@ static struct phy_driver realtek_drvs[] = {
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


