Return-Path: <netdev+bounces-1602-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00AB96FE7C3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1A652815AE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A7E1E517;
	Wed, 10 May 2023 22:57:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFAE17FFB
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 22:57:25 +0000 (UTC)
Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8ED4690;
	Wed, 10 May 2023 15:57:17 -0700 (PDT)
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.96)
	(envelope-from <daniel@makrotopia.org>)
	id 1pwskF-0004Qx-2b;
	Wed, 10 May 2023 22:57:16 +0000
Date: Thu, 11 May 2023 00:55:11 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH net-next 3/8] net: phy: realtek: use genphy_soft_reset for
 2.5G PHYs
Message-ID: <0c1e578a5b02fe49e1114ea75e3c6282eb230ad3.1683756691.git.daniel@makrotopia.org>
References: <cover.1683756691.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683756691.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some vendor bootloaders do weird things with those PHYs which result in
link modes being reported wrongly. Start from a clean sheet by resetting
the PHY.

Reported-by: Yevhen Kolomeiko <jarvis2709@gmail.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/phy/realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 4a2c1ad02d48..0cf7846c9812 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -1038,6 +1038,7 @@ static struct phy_driver realtek_drvs[] = {
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtl822x_read_mmd,
 		.write_mmd	= rtl822x_write_mmd,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc840),
 		.name		= "RTL8226B_RTL8221B 2.5Gbps PHY",
@@ -1051,6 +1052,7 @@ static struct phy_driver realtek_drvs[] = {
 		.write_page	= rtl821x_write_page,
 		.read_mmd	= rtl822x_read_mmd,
 		.write_mmd	= rtl822x_write_mmd,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc838),
 		.name           = "RTL8226-CG 2.5Gbps PHY",
@@ -1061,6 +1063,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc848),
 		.name           = "RTL8226B-CG_RTL8221B-CG 2.5Gbps PHY",
@@ -1072,6 +1075,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc849),
 		.name           = "RTL8221B-VB-CG 2.5Gbps PHY",
@@ -1083,6 +1087,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc84a),
 		.name           = "RTL8221B-VM-CG 2.5Gbps PHY",
@@ -1094,6 +1099,7 @@ static struct phy_driver realtek_drvs[] = {
 		.resume         = rtlgen_resume,
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
+		.soft_reset     = genphy_soft_reset,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.40.0


