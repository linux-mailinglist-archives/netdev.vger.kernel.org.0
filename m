Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15FA6DCE62
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 02:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDKALZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 20:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDKALY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 20:11:24 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8224226AB;
        Mon, 10 Apr 2023 17:11:22 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pm1bP-0007rm-1O;
        Tue, 11 Apr 2023 02:11:15 +0200
Date:   Tue, 11 Apr 2023 01:11:07 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dsa: mt7530: fix support for MT7531BE
Message-ID: <ZDSlm-0gyyDZXy_k@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two variants of the MT7531 switch IC which got different
features (and pins) regarding port 5:
 * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes
 * MT7531BE: RGMII

Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to
mt7530_probe function") works fine for MT7531AE which got two instances
of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup to setup
clocks before the single PCS on port 6 (usually used as CPU port)
starts to work and hence the PCS creation failed on MT7531BE.

Fix this by introducing a pointer to mt7531_create_sgmii function in
struct mt7530_priv and call it again at the end of mt753x_setup like it
was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
creation to mt7530_probe function").

Fixes: 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530-mdio.c | 14 +++++++-------
 drivers/net/dsa/mt7530.c      |  6 ++++++
 drivers/net/dsa/mt7530.h      |  4 ++++
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
index 34a547b88e497..f17eab67d15fa 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -81,14 +81,17 @@ static const struct regmap_bus mt7530_regmap_bus = {
 };
 
 static int
-mt7531_create_sgmii(struct mt7530_priv *priv)
+mt7531_create_sgmii(struct mt7530_priv *priv, bool dual_sgmii)
 {
 	struct regmap_config *mt7531_pcs_config[2];
 	struct phylink_pcs *pcs;
 	struct regmap *regmap;
 	int i, ret = 0;
 
-	for (i = 0; i < 2; i++) {
+	/* MT7531AE has two SGMII units for port 5 and port 6
+	 * MT7531BE has only one SGMII unit for port 6
+	 */
+	for (i = dual_sgmii ? 0 : 1; i < 2; i++) {
 		mt7531_pcs_config[i] = devm_kzalloc(priv->dev,
 						    sizeof(struct regmap_config),
 						    GFP_KERNEL);
@@ -208,11 +211,8 @@ mt7530_probe(struct mdio_device *mdiodev)
 	if (IS_ERR(priv->regmap))
 		return PTR_ERR(priv->regmap);
 
-	if (priv->id == ID_MT7531) {
-		ret = mt7531_create_sgmii(priv);
-		if (ret)
-			return ret;
-	}
+	if (priv->id == ID_MT7531)
+		priv->create_sgmii = mt7531_create_sgmii;
 
 	return dsa_register_switch(priv->ds);
 }
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e4bb5037d3525..c680873819b01 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3018,6 +3018,12 @@ mt753x_setup(struct dsa_switch *ds)
 	if (ret && priv->irq)
 		mt7530_free_irq_common(priv);
 
+	if (priv->create_sgmii) {
+		ret = priv->create_sgmii(priv, mt7531_dual_sgmii_supported(priv));
+		if (ret && priv->irq)
+			mt7530_free_irq(priv);
+	}
+
 	return ret;
 }
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 01db5c9724fa8..6e89578b4de02 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -752,6 +752,8 @@ struct mt753x_info {
  * @irq:		IRQ number of the switch
  * @irq_domain:		IRQ domain of the switch irq_chip
  * @irq_enable:		IRQ enable bits, synced to SYS_INT_EN
+ *
+ * @create_sgmii:	Pointer to function creating SGMII PCS instance(s)
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -778,6 +780,8 @@ struct mt7530_priv {
 	int irq;
 	struct irq_domain *irq_domain;
 	u32 irq_enable;
+
+	int (*create_sgmii)(struct mt7530_priv *priv, bool dual_sgmii);
 };
 
 struct mt7530_hw_vlan_entry {
-- 
2.40.0

