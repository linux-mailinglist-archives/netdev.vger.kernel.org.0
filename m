Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FF56D0971
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbjC3PYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjC3PXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:23:35 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FACCDC9;
        Thu, 30 Mar 2023 08:23:13 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phu6W-0006hA-2e;
        Thu, 30 Mar 2023 17:22:21 +0200
Date:   Thu, 30 Mar 2023 16:22:17 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>,
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
Subject: [PATCH net-next 09/15] net: dsa: mt7530: introduce
 mt7530_remove_common helper function
Message-ID: <81b371db995cf19b670169ab1cdeeaf626ae5390.1680180959.git.daniel@makrotopia.org>
References: <cover.1680180959.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680180959.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move commonly used parts from mt7530_remove into new
mt7530_remove_common helper function which will be used by both,
mt7530_remove and the to-be-introduced mt7988_remove.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index b3a9eb40e45a9..de2fa5df9332c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3264,6 +3264,17 @@ mt7530_probe(struct mdio_device *mdiodev)
 	return dsa_register_switch(priv->ds);
 }
 
+static void
+mt7530_remove_common(struct mt7530_priv *priv)
+{
+	if (priv->irq)
+		mt7530_free_irq(priv);
+
+	dsa_unregister_switch(priv->ds);
+
+	mutex_destroy(&priv->reg_mutex);
+}
+
 static void
 mt7530_remove(struct mdio_device *mdiodev)
 {
@@ -3283,15 +3294,10 @@ mt7530_remove(struct mdio_device *mdiodev)
 		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
 			ret);
 
-	if (priv->irq)
-		mt7530_free_irq(priv);
-
-	dsa_unregister_switch(priv->ds);
+	mt7530_remove_common(priv);
 
 	for (i = 0; i < 2; ++i)
 		mtk_pcs_lynxi_destroy(priv->ports[5 + i].sgmii_pcs);
-
-	mutex_destroy(&priv->reg_mutex);
 }
 
 static void mt7530_shutdown(struct mdio_device *mdiodev)
-- 
2.39.2

