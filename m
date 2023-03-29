Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC46CEE56
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjC2QAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjC2P72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:59:28 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BF06A6F;
        Wed, 29 Mar 2023 08:58:56 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYCM-0003O6-1l;
        Wed, 29 Mar 2023 17:58:54 +0200
Date:   Wed, 29 Mar 2023 16:58:50 +0100
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
Subject: [RFC PATCH net-next v3 07/15] net: dsa: mt7530: introduce
 mt7530_probe_common helper function
Message-ID: <d5147ef8738c1425fdd4fb351c1f3d98786fc19f.1680105013.git.daniel@makrotopia.org>
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

Move commonly used parts from mt7530_probe into new mt7530_probe_common
helper function which will be used by both, mt7530_probe and the
to-be-introduced mt7988_probe.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 86 ++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 221d56cf9e710..32875762b3d96 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3145,44 +3145,47 @@ static const struct of_device_id mt7530_of_match[] = {
 MODULE_DEVICE_TABLE(of, mt7530_of_match);
 
 static int
-mt7530_probe(struct mdio_device *mdiodev)
+mt7530_probe_common(struct mt7530_priv *priv)
 {
-	static struct regmap_config *regmap_config;
-	struct mt7530_priv *priv;
-	struct device_node *dn;
-	int ret;
-
-	dn = mdiodev->dev.of_node;
-
-	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	struct device *dev = priv->dev;
+	struct device_node *dn = dev->of_node;
 
-	priv->ds = devm_kzalloc(&mdiodev->dev, sizeof(*priv->ds), GFP_KERNEL);
+	priv->ds = devm_kzalloc(dev, sizeof(*priv->ds), GFP_KERNEL);
 	if (!priv->ds)
 		return -ENOMEM;
 
-	priv->ds->dev = &mdiodev->dev;
+	priv->ds->dev = dev;
 	priv->ds->num_ports = MT7530_NUM_PORTS;
 
 	/* Use medatek,mcm property to distinguish hardware type that would
-	 * casues a little bit differences on power-on sequence.
+	 * cause a little bit differences on power-on sequence.
+	 * Note MCM that indicates switch works as the remote standalone
+	 * integrated circuit so the GPIO pin would be used to complete
+	 * the reset, otherwise memory-mapped register accessing used
+	 * through syscon provides in the case of MCM.
 	 */
 	priv->mcm = of_property_read_bool(dn, "mediatek,mcm");
 	if (priv->mcm) {
-		dev_info(&mdiodev->dev, "MT7530 adapts as multi-chip module\n");
+		dev_dbg(dev, "MT7530 adapts as multi-chip module\n");
 
-		priv->rstc = devm_reset_control_get(&mdiodev->dev, "mcm");
+		priv->rstc = devm_reset_control_get(dev, "mcm");
 		if (IS_ERR(priv->rstc)) {
-			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
+			dev_err(dev, "Couldn't get our reset line\n");
 			return PTR_ERR(priv->rstc);
 		}
+	} else {
+		priv->reset = devm_gpiod_get_optional(dev, "reset",
+						      GPIOD_OUT_LOW);
+		if (IS_ERR(priv->reset)) {
+			dev_err(dev, "Couldn't get our reset line\n");
+			return PTR_ERR(priv->reset);
+		}
 	}
 
 	/* Get the hardware identifier from the devicetree node.
 	 * We will need it for some of the clock and regulator setup.
 	 */
-	priv->info = of_device_get_match_data(&mdiodev->dev);
+	priv->info = of_device_get_match_data(dev);
 	if (!priv->info)
 		return -EINVAL;
 
@@ -3196,6 +3199,32 @@ mt7530_probe(struct mdio_device *mdiodev)
 		return -EINVAL;
 
 	priv->id = priv->info->id;
+	priv->dev = dev;
+	priv->ds->priv = priv;
+	priv->ds->ops = &mt7530_switch_ops;
+	mutex_init(&priv->reg_mutex);
+	dev_set_drvdata(dev, priv);
+
+	return 0;
+}
+
+static int
+mt7530_probe(struct mdio_device *mdiodev)
+{
+	static struct regmap_config *regmap_config;
+	struct mt7530_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->bus = mdiodev->bus;
+	priv->dev = &mdiodev->dev;
+
+	ret = mt7530_probe_common(priv);
+	if (ret)
+		return ret;
 
 	if (priv->id == ID_MT7530) {
 		priv->core_pwr = devm_regulator_get(&mdiodev->dev, "core");
@@ -3207,27 +3236,6 @@ mt7530_probe(struct mdio_device *mdiodev)
 			return PTR_ERR(priv->io_pwr);
 	}
 
-	/* Not MCM that indicates switch works as the remote standalone
-	 * integrated circuit so the GPIO pin would be used to complete
-	 * the reset, otherwise memory-mapped register accessing used
-	 * through syscon provides in the case of MCM.
-	 */
-	if (!priv->mcm) {
-		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
-						      GPIOD_OUT_LOW);
-		if (IS_ERR(priv->reset)) {
-			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
-			return PTR_ERR(priv->reset);
-		}
-	}
-
-	priv->bus = mdiodev->bus;
-	priv->dev = &mdiodev->dev;
-	priv->ds->priv = priv;
-	priv->ds->ops = &mt7530_switch_ops;
-	mutex_init(&priv->reg_mutex);
-	dev_set_drvdata(&mdiodev->dev, priv);
-
 	regmap_config = devm_kzalloc(&mdiodev->dev, sizeof(*regmap_config),
 				     GFP_KERNEL);
 	if (!regmap_config)
-- 
2.39.2

