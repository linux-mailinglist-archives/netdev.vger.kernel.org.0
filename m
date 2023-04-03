Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7B76D3B56
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjDCBR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjDCBR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:17:56 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F6EAF3C;
        Sun,  2 Apr 2023 18:17:48 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pj8pO-0004hA-1f;
        Mon, 03 Apr 2023 03:17:46 +0200
Date:   Mon, 3 Apr 2023 02:17:40 +0100
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
Subject: [PATCH net-next v2 03/14] net: dsa: mt7530: use unlocked regmap
 accessors
Message-ID: <57a3b497841ba5d2e0b2486ea91001c2ccd4c628.1680483896.git.daniel@makrotopia.org>
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

Instead of wrapping the locked register accessor functions, use the
unlocked variants and add locking wrapper functions to let regmap
handle the locking.

This is a preparation towards being able to always use regmap to
access switch registers instead of open-coded accessor functions.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mt7530.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 5685c71bc9173..d8b041d79f2b7 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2900,7 +2900,7 @@ static int mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val
 {
 	struct mt7530_priv *priv = context;
 
-	*val = mt7530_read(priv, reg);
+	*val = mt7530_mii_read(priv, reg);
 	return 0;
 };
 
@@ -2908,23 +2908,25 @@ static int mt7530_regmap_write(void *context, unsigned int reg, unsigned int val
 {
 	struct mt7530_priv *priv = context;
 
-	mt7530_write(priv, reg, val);
+	mt7530_mii_write(priv, reg, val);
 	return 0;
 };
 
-static int mt7530_regmap_update_bits(void *context, unsigned int reg,
-				     unsigned int mask, unsigned int val)
+static void
+mt7530_mdio_regmap_lock(void *mdio_lock)
 {
-	struct mt7530_priv *priv = context;
+	mutex_lock_nested(mdio_lock, MDIO_MUTEX_NESTED);
+}
 
-	mt7530_rmw(priv, reg, mask, val);
-	return 0;
-};
+static void
+mt7530_mdio_regmap_unlock(void *mdio_lock)
+{
+	mutex_unlock(mdio_lock);
+}
 
 static const struct regmap_bus mt7531_regmap_bus = {
 	.reg_write = mt7530_regmap_write,
 	.reg_read = mt7530_regmap_read,
-	.reg_update_bits = mt7530_regmap_update_bits,
 };
 
 static int
@@ -2950,6 +2952,9 @@ mt7531_create_sgmii(struct mt7530_priv *priv)
 		mt7531_pcs_config[i]->reg_stride = 4;
 		mt7531_pcs_config[i]->reg_base = MT7531_SGMII_REG_BASE(5 + i);
 		mt7531_pcs_config[i]->max_register = 0x17c;
+		mt7531_pcs_config[i]->lock = mt7530_mdio_regmap_lock;
+		mt7531_pcs_config[i]->unlock = mt7530_mdio_regmap_unlock;
+		mt7531_pcs_config[i]->lock_arg = &priv->bus->mdio_lock;
 
 		regmap = devm_regmap_init(priv->dev,
 					  &mt7531_regmap_bus, priv,
-- 
2.40.0

