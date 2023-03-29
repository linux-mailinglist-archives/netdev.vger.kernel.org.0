Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DC66CEE34
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjC2P6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231193AbjC2P6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:58:37 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCBB61AF;
        Wed, 29 Mar 2023 08:58:10 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYAv-0003K3-0f;
        Wed, 29 Mar 2023 17:57:25 +0200
Date:   Wed, 29 Mar 2023 16:57:21 +0100
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
Subject: [RFC PATCH net-next v3 01/15] net: dsa: mt7530: refactor SGMII PCS
 creation
Message-ID: <921a8076420545206612e873753edfd0868e7a36.1680105013.git.daniel@makrotopia.org>
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

Instead of macro templates use a dedidated function and allocated
regmap_config when creating the regmaps for the pcs-mtk-lynxi
instances.
This is in preparation to switching to use unlocked regmap accessors
and have regmap's locking API handle locking for us.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 74 +++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a0d99af897ace..9b88ce5cee5bd 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2926,26 +2926,56 @@ static const struct regmap_bus mt7531_regmap_bus = {
 	.reg_update_bits = mt7530_regmap_update_bits,
 };
 
-#define MT7531_PCS_REGMAP_CONFIG(_name, _reg_base) \
-	{				\
-		.name = _name,		\
-		.reg_bits = 16,		\
-		.val_bits = 32,		\
-		.reg_stride = 4,	\
-		.reg_base = _reg_base,	\
-		.max_register = 0x17c,	\
-	}
-
-static const struct regmap_config mt7531_pcs_config[] = {
-	MT7531_PCS_REGMAP_CONFIG("port5", MT7531_SGMII_REG_BASE(5)),
-	MT7531_PCS_REGMAP_CONFIG("port6", MT7531_SGMII_REG_BASE(6)),
-};
+static int
+mt7531_create_sgmii(struct mt7530_priv *priv)
+{
+	struct regmap_config *mt7531_pcs_config[2];
+	struct phylink_pcs *pcs;
+	struct regmap *regmap;
+	int i, ret = 0;
+
+	for (i = 0; i < 2; i++) {
+		mt7531_pcs_config[i] = devm_kzalloc(priv->dev,
+						    sizeof(struct regmap_config),
+						    GFP_KERNEL);
+		if (!mt7531_pcs_config[i]) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		mt7531_pcs_config[i]->name = i ? "port6" : "port5";
+		mt7531_pcs_config[i]->reg_bits = 16;
+		mt7531_pcs_config[i]->val_bits = 32;
+		mt7531_pcs_config[i]->reg_stride = 4;
+		mt7531_pcs_config[i]->reg_base = MT7531_SGMII_REG_BASE(5 + i);
+		mt7531_pcs_config[i]->max_register = 0x17c;
+
+		regmap = devm_regmap_init(priv->dev,
+					  &mt7531_regmap_bus, priv,
+					  mt7531_pcs_config[i]);
+		if (IS_ERR(regmap)) {
+			ret = PTR_ERR(regmap);
+			break;
+		}
+		pcs = mtk_pcs_lynxi_create(priv->dev, regmap,
+					   MT7531_PHYA_CTRL_SIGNAL3, 0);
+		if (!pcs) {
+			ret = -ENXIO;
+			break;
+		}
+		priv->ports[5 + i].sgmii_pcs = pcs;
+	}
+
+	if (ret && i)
+		mtk_pcs_lynxi_destroy(priv->ports[5].sgmii_pcs);
+
+	return ret;
+}
 
 static int
 mt753x_setup(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
-	struct regmap *regmap;
 	int i, ret;
 
 	/* Initialise the PCS devices */
@@ -2967,15 +2997,11 @@ mt753x_setup(struct dsa_switch *ds)
 	if (ret && priv->irq)
 		mt7530_free_irq_common(priv);
 
-	if (priv->id == ID_MT7531)
-		for (i = 0; i < 2; i++) {
-			regmap = devm_regmap_init(ds->dev,
-						  &mt7531_regmap_bus, priv,
-						  &mt7531_pcs_config[i]);
-			priv->ports[5 + i].sgmii_pcs =
-				mtk_pcs_lynxi_create(ds->dev, regmap,
-						     MT7531_PHYA_CTRL_SIGNAL3, 0);
-		}
+	if (priv->id == ID_MT7531) {
+		ret = mt7531_create_sgmii(priv);
+		if (ret && priv->irq)
+			mt7530_free_irq_common(priv);
+	}
 
 	return ret;
 }
-- 
2.39.2

