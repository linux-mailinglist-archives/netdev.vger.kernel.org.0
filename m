Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF4B45964D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbhKVUy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229899AbhKVUy0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 15:54:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E771E60F26;
        Mon, 22 Nov 2021 20:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637614279;
        bh=94SMh8yCYVEbldfJs5fMSx82Vtd4ZwBhuyX+pNeSeaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEm8rCCcza+v36jQvZSuvQzsEq2Fz6LLxHlnLvpDBjYyG5ids2a2jaXDxmj3TrmR7
         ecmir6kpVtaUSWm1/LUOsjSsSo77LxTpGgt9TOmuGAAS7nHLQNjVwxGUyvi9HXYYAg
         +RPKHkgtEw61bFEge+grnhE6dypDNyDWRJ7/IT/3BfAM3Gil+ACzV5IF2+G570U4Fx
         C9FJV9igInlBU8Coe0IJEV6BVRzc0BOKjBgZ66F0W7bV2sphEUYUhSbTIXPTzflnMA
         YIYEY5OWL0AnuOGQCInQgTgY19FGFFGNMpswwrN7reINWXE31/AX/rQ9SGNQ16WRfe
         wsSH9nOQv7tTw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/2] net: marvell: mvpp2: Add support for 5gbase-r
Date:   Mon, 22 Nov 2021 21:51:11 +0100
Message-Id: <20211122205111.10156-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122205111.10156-1-kabel@kernel.org>
References: <20211122205111.10156-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PHY_INTERFACE_MODE_5GBASER.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 44 ++++++++++++++++---
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a3aefdf0784e..a48e804c46f2 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1488,6 +1488,7 @@ static bool mvpp2_port_supports_rgmii(struct mvpp2_port *port)
 static bool mvpp2_is_xlg(phy_interface_t interface)
 {
 	return interface == PHY_INTERFACE_MODE_10GBASER ||
+	       interface == PHY_INTERFACE_MODE_5GBASER ||
 	       interface == PHY_INTERFACE_MODE_XAUI;
 }
 
@@ -1627,6 +1628,7 @@ static int mvpp22_gop_init(struct mvpp2_port *port, phy_interface_t interface)
 	case PHY_INTERFACE_MODE_2500BASEX:
 		mvpp22_gop_init_sgmii(port);
 		break;
+	case PHY_INTERFACE_MODE_5GBASER:
 	case PHY_INTERFACE_MODE_10GBASER:
 		if (!mvpp2_port_supports_xlg(port))
 			goto invalid_conf;
@@ -2186,6 +2188,7 @@ static void mvpp22_pcs_reset_deassert(struct mvpp2_port *port,
 	xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
 
 	switch (interface) {
+	case PHY_INTERFACE_MODE_5GBASER:
 	case PHY_INTERFACE_MODE_10GBASER:
 		val = readl(mpcs + MVPP22_MPCS_CLK_RESET);
 		val |= MAC_CLK_RESET_MAC | MAC_CLK_RESET_SD_RX |
@@ -6126,7 +6129,10 @@ static void mvpp2_xlg_pcs_get_state(struct phylink_pcs *pcs,
 	struct mvpp2_port *port = mvpp2_pcs_to_port(pcs);
 	u32 val;
 
-	state->speed = SPEED_10000;
+	if (port->phy_interface == PHY_INTERFACE_MODE_5GBASER)
+		state->speed = SPEED_5000;
+	else
+		state->speed = SPEED_10000;
 	state->duplex = 1;
 	state->an_complete = 1;
 
@@ -6879,12 +6885,36 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 				MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
 		if (mvpp2_port_supports_xlg(port)) {
-			__set_bit(PHY_INTERFACE_MODE_10GBASER,
-				  port->phylink_config.supported_interfaces);
-			__set_bit(PHY_INTERFACE_MODE_XAUI,
-				  port->phylink_config.supported_interfaces);
-			port->phylink_config.mac_capabilities |=
-				MAC_10000FD;
+			/* If a COMPHY is present, we can support any of
+			 * the serdes modes and switch between them.
+			 */
+			if (comphy) {
+				__set_bit(PHY_INTERFACE_MODE_5GBASER,
+					  port->phylink_config.supported_interfaces);
+				__set_bit(PHY_INTERFACE_MODE_10GBASER,
+					  port->phylink_config.supported_interfaces);
+				__set_bit(PHY_INTERFACE_MODE_XAUI,
+					  port->phylink_config.supported_interfaces);
+			} else if (phy_mode == PHY_INTERFACE_MODE_5GBASER) {
+				__set_bit(PHY_INTERFACE_MODE_5GBASER,
+					  port->phylink_config.supported_interfaces);
+			} else if (phy_mode == PHY_INTERFACE_MODE_10GBASER) {
+				__set_bit(PHY_INTERFACE_MODE_10GBASER,
+					  port->phylink_config.supported_interfaces);
+			} else if (phy_mode == PHY_INTERFACE_MODE_XAUI) {
+				__set_bit(PHY_INTERFACE_MODE_XAUI,
+					  port->phylink_config.supported_interfaces);
+			}
+
+			if (comphy)
+				port->phylink_config.mac_capabilities |=
+					MAC_10000FD | MAC_5000FD;
+			else if (phy_mode == PHY_INTERFACE_MODE_5GBASER)
+				port->phylink_config.mac_capabilities |=
+					MAC_5000FD;
+			else
+				port->phylink_config.mac_capabilities |=
+					MAC_10000FD;
 		}
 
 		if (mvpp2_port_supports_rgmii(port))
-- 
2.32.0

