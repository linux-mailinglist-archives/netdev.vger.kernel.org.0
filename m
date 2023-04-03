Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F9B6D3B5E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjDCBTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjDCBTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:19:04 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D79C65C;
        Sun,  2 Apr 2023 18:18:35 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pj8q8-0004jw-1f;
        Mon, 03 Apr 2023 03:18:32 +0200
Date:   Mon, 3 Apr 2023 02:18:28 +0100
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
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next v2 07/14] net: dsa: mt7530: move p5_intf_modes()
 function to mt7530.c
Message-ID: <f466e49e811b0f1dab3854dd36b9522cf7e8831a.1680483896.git.daniel@makrotopia.org>
References: <cover.1680483895.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680483895.git.daniel@makrotopia.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mt7530.c | 18 ++++++++++++++++++
 drivers/net/dsa/mt7530.h | 18 ------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9d49cbc8ddcb2..1215d5e4dd38a 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -943,6 +943,24 @@ mt7530_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
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
2.40.0

