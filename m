Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA86CEE53
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjC2QAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjC2P7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:59:17 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D017059E7;
        Wed, 29 Mar 2023 08:58:42 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYC7-0003Ne-1w;
        Wed, 29 Mar 2023 17:58:40 +0200
Date:   Wed, 29 Mar 2023 16:58:35 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [RFC PATCH net-next v3 06/15] net: dsa: mt7530: move p5_intf_modes()
 function to mt7530.c
Message-ID: <98fc2eec00985854010e3d0d16ba7f4c924ab49f.1680105013.git.daniel@makrotopia.org>
References: <cover.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of splitting mt7530.c into a driver for MDIO-connected
as well as MDIO-accessed built-in switches on one hand and MMIO-accessed
built-in switches move the p5_inft_modes() function from mt7530.h to
mt7530.c. The function is only needed there and will trigger a compiler
warning about a defined but unused function otherwise when including
mt7530.h in the to-be-introduced bus-specific drivers.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 18 ++++++++++++++++++
 drivers/net/dsa/mt7530.h | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 033e70b42b12a..221d56cf9e710 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -946,6 +946,24 @@ mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 	return 0;
 }
 
+static const char *p5_intf_modes(unsigned int p5_interface)
+{
+	switch (p5_interface) {
+	case P5_DISABLED:
+		return "DISABLED";
+	case P5_INTF_SEL_PHY_P0:
+		return "PHY P0";
+	case P5_INTF_SEL_PHY_P4:
+		return "PHY P4";
+	case P5_INTF_SEL_GMAC5:
+		return "GMAC5";
+	case P5_INTF_SEL_GMAC5_SGMII:
+		return "GMAC5_SGMII";
+	default:
+		return "unknown";
+	}
+}
+
 static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 39aaca50961bd..2a611173a7d08 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -682,24 +682,6 @@ enum p5_interface_select {
 	P5_INTF_SEL_GMAC5_SGMII,
 };
 
-static const char *p5_intf_modes(unsigned int p5_interface)
-{
-	switch (p5_interface) {
-	case P5_DISABLED:
-		return "DISABLED";
-	case P5_INTF_SEL_PHY_P0:
-		return "PHY P0";
-	case P5_INTF_SEL_PHY_P4:
-		return "PHY P4";
-	case P5_INTF_SEL_GMAC5:
-		return "GMAC5";
-	case P5_INTF_SEL_GMAC5_SGMII:
-		return "GMAC5_SGMII";
-	default:
-		return "unknown";
-	}
-}
-
 struct mt7530_priv;
 
 struct mt753x_pcs {
-- 
2.39.2

