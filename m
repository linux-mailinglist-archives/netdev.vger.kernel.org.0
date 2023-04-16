Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87C6E37E8
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDPMJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjDPMJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:09:07 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8079261B2;
        Sun, 16 Apr 2023 05:08:30 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1po1B7-00081r-0z;
        Sun, 16 Apr 2023 14:08:21 +0200
Date:   Sun, 16 Apr 2023 13:08:14 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v2] net: dsa: mt7530: fix support for MT7531BE
Message-ID: <ZDvlLhhqheobUvOK@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two variants of the MT7531 switch IC which got different
features (and pins) regarding port 5:
 * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes PCS
 * MT7531BE: RGMII

Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation
to mt7530_probe function") works fine for MT7531AE which got two
instances of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup
to setup clocks before the single PCS on port 6 (usually used as CPU
port) starts to work and hence the PCS creation failed on MT7531BE.

Fix this by introducing a pointer to mt7531_create_sgmii function in
struct mt7530_priv and call it again at the end of mt753x_setup like it
was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
creation to mt7530_probe function").

Fixes: 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530-mdio.c | 16 ++++++++--------
 drivers/net/dsa/mt7530.c      |  6 ++++++
 drivers/net/dsa/mt7530.h      |  4 ++--
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
index 34a547b88e497..088533663b83b 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -81,14 +81,17 @@ static const struct regmap_bus mt7530_regmap_bus = {
 };
 
 static int
-mt7531_create_sgmii(struct mt7530_priv *priv)
+mt7531_create_sgmii(struct mt7530_priv *priv, bool dual_sgmii)
 {
-	struct regmap_config *mt7531_pcs_config[2];
+	struct regmap_config *mt7531_pcs_config[2] = {};
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
index 01db5c9724fa8..5084f48a88691 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -748,10 +748,10 @@ struct mt753x_info {
  *			registers
  * @p6_interface	Holding the current port 6 interface
  * @p5_intf_sel:	Holding the current port 5 interface select
- *
  * @irq:		IRQ number of the switch
  * @irq_domain:		IRQ domain of the switch irq_chip
  * @irq_enable:		IRQ enable bits, synced to SYS_INT_EN
+ * @create_sgmii:	Pointer to function creating SGMII PCS instance(s)
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -770,7 +770,6 @@ struct mt7530_priv {
 	unsigned int		p5_intf_sel;
 	u8			mirror_rx;
 	u8			mirror_tx;
-
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	struct mt753x_pcs	pcs[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
@@ -778,6 +777,7 @@ struct mt7530_priv {
 	int irq;
 	struct irq_domain *irq_domain;
 	u32 irq_enable;
+	int (*create_sgmii)(struct mt7530_priv *priv, bool dual_sgmii);
 };
 
 struct mt7530_hw_vlan_entry {

base-commit: e61caf04b9f8a2626714ffd12e734c555c758af4
-- 
2.40.0

