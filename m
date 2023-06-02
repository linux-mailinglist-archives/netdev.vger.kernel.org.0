Return-Path: <netdev+bounces-7531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E85D72091C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29446281A76
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:27:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB431DDE9;
	Fri,  2 Jun 2023 18:27:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ED91C746
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:27:11 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED1018C;
	Fri,  2 Jun 2023 11:27:10 -0700 (PDT)
Received: from arisu.hitronhub.home (unknown [23.233.251.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id 442146606ED9;
	Fri,  2 Jun 2023 19:27:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685730428;
	bh=Bhe0llT4DF8ZqHEPdTT4fQ2FZEjkEvA9p05FaGSuRXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6YWzhwuoHa0va1FR4AvEuwCw7FFiMWU9MoNvKXcKDqu80zNoLdWl3i8xSDl0Vf4S
	 0B3K8Ccml1Ures4OmFJA+w70k88KLkaRG3ZNlXpxezTY+AHzOzWhyIYkIDZDSA6h8u
	 0molKGU8pboV1HaXp2jME9vmrJ2EG2ySAoqlaTGDNVRSDJVZ9jLadn1Ot2mYm5Sz1g
	 nV94/UlyPf9Nx2lxU1o54WQTAKn/MCCviN3jarDSbd8he4PHUTT038Vwwh3iwAA7nV
	 /mJWENaNJScN+jc9+ZVUOBjXrmEqNvyMDbcGrDa9uS1hK3vlSfa/2nPGT0Rd1OWoo6
	 jlHL3lQ2Gi2Tw==
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
	Detlev Casanova <detlev.casanova@collabora.com>
Subject: [PATCH v2 1/3] net: phy: realtek: Add optional external PHY clock
Date: Fri,  2 Jun 2023 14:26:57 -0400
Message-Id: <20230602182659.307876-2-detlev.casanova@collabora.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230602182659.307876-1-detlev.casanova@collabora.com>
References: <20230602182659.307876-1-detlev.casanova@collabora.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In some cases, the PHY can use an external clock source instead of a
crystal.

Add an optional clock in the phy node to make sure that the clock source
is enabled, if specified, before probing.

Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
---
 drivers/net/phy/realtek.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 3d99fd6664d7..b13dd0b3c99e 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -12,6 +12,7 @@
 #include <linux/phy.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/clk.h>
 
 #define RTL821x_PHYSR				0x11
 #define RTL821x_PHYSR_DUPLEX			BIT(13)
@@ -80,6 +81,7 @@ struct rtl821x_priv {
 	u16 phycr1;
 	u16 phycr2;
 	bool has_phycr2;
+	struct clk *clk;
 };
 
 static int rtl821x_read_page(struct phy_device *phydev)
@@ -103,6 +105,11 @@ static int rtl821x_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->clk = devm_clk_get_optional_enabled(dev, NULL);
+	if (IS_ERR(priv->clk))
+		return dev_err_probe(dev, PTR_ERR(priv->clk),
+				     "failed to get phy clock\n");
+
 	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
 	if (ret < 0)
 		return ret;
-- 
2.39.3


