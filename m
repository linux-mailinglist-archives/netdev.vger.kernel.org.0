Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2B46CEE72
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbjC2QBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjC2QAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:00:54 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58B64C2C;
        Wed, 29 Mar 2023 08:59:56 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phYDH-0003RC-1w;
        Wed, 29 Mar 2023 17:59:51 +0200
Date:   Wed, 29 Mar 2023 16:59:47 +0100
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
Subject: [RFC PATCH net-next v3 11/15] net: dsa: mt7530: skip locking if MDIO
 bus isn't present
Message-ID: <4e6d1cbba2ff16cad5b9ac48ccdf4407f45c7857.1680105013.git.daniel@makrotopia.org>
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

As MT7530 and MT7531 internally use 32-bit wide registers, each access
to any register of the switch requires several operations on the MDIO
bus. Hence if there is congruent access, e.g. due to PCS or PHY
polling, this can mess up and interfere with another ongoing register
access sequence.

However, the MDIO bus mutex is only relevant for MDIO-connected
switches. Prepare switches which have there registers directly mapped
into the SoCs register space via MMIO which do not require such
locking. There we can simply use regmap's default locking mechanism.

Hence guard mutex operations to only be performed in case of MDIO
connected switches.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ce2665abaaf57..c6fad2d156160 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -145,13 +145,15 @@ core_write_mmd_indirect(struct mt7530_priv *priv, int prtad,
 static void
 mt7530_mutex_lock(struct mt7530_priv *priv)
 {
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	if (priv->bus)
+		mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 }
 
 static void
 mt7530_mutex_unlock(struct mt7530_priv *priv)
 {
-	mutex_unlock(&priv->bus->mdio_lock);
+	if (priv->bus)
+		mutex_unlock(&priv->bus->mdio_lock);
 }
 
 static void
-- 
2.39.2

