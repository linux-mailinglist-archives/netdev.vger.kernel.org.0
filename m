Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 774E16CEE7B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjC2QCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjC2QBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:01:39 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FDF6A72;
        Wed, 29 Mar 2023 09:00:25 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYDc-0003S1-1W;
        Wed, 29 Mar 2023 18:00:13 +0200
Date:   Wed, 29 Mar 2023 17:00:06 +0100
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
Subject: [RFC PATCH net-next v3 12/15] net: dsa: mt7530: add support for
 single-chip reset line
Message-ID: <0f696278bd8d13121a500f80cfe2f806debe4da5.1680105013.git.daniel@makrotopia.org>
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

Similar to multi-chip-module MT7530 also MT7988 uses an internal
reset line instead of using an optional reset GPIO like it is the
case for external MT7530 and MT7531 ICs.
Add support for internal but non-MCM reset line in preparation for
adding support for MT7988.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c6fad2d156160..fd55ddc2d1eb3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3066,6 +3066,12 @@ mt7530_probe_common(struct mt7530_priv *priv)
 			dev_err(dev, "Couldn't get our reset line\n");
 			return PTR_ERR(priv->rstc);
 		}
+	} else if (!priv->bus) {
+		priv->rstc = devm_reset_control_get(dev, NULL);
+		if (IS_ERR(priv->rstc)) {
+			dev_err(dev, "Couldn't get our reset line\n");
+			return PTR_ERR(priv->rstc);
+		}
 	} else {
 		priv->reset = devm_gpiod_get_optional(dev, "reset",
 						      GPIOD_OUT_LOW);
-- 
2.39.2

