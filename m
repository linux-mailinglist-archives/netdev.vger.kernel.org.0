Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344966D0967
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 17:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbjC3PXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 11:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjC3PXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 11:23:07 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EE6D304;
        Thu, 30 Mar 2023 08:22:18 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1phu5d-0006dt-15;
        Thu, 30 Mar 2023 17:21:25 +0200
Date:   Thu, 30 Mar 2023 16:21:21 +0100
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
Subject: [PATCH net-next 06/15] net: dsa: mt7530: introduce mutex helpers
Message-ID: <db4fb5f173335cf76f51c255eee3102d060c19ae.1680180959.git.daniel@makrotopia.org>
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

As the MDIO bus lock only needs to be involved if actually operating
on an MDIO-connected switch we will need to skip locking for built-in
switches which are accessed via MMIO.
Create helper functions which simplify that upcoming change.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 72 ++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 803809b430c85..4fed18303673e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -143,31 +143,40 @@ core_write_mmd_indirect(struct mt7530_priv *priv, int prtad,
 }
 
 static void
-core_write(struct mt7530_priv *priv, u32 reg, u32 val)
+mt7530_mutex_lock(struct mt7530_priv *priv)
 {
-	struct mii_bus *bus = priv->bus;
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+}
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+static void
+mt7530_mutex_unlock(struct mt7530_priv *priv)
+{
+	mutex_unlock(&priv->bus->mdio_lock);
+}
+
+static void
+core_write(struct mt7530_priv *priv, u32 reg, u32 val)
+{
+	mt7530_mutex_lock(priv);
 
 	core_write_mmd_indirect(priv, reg, MDIO_MMD_VEND2, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 }
 
 static void
 core_rmw(struct mt7530_priv *priv, u32 reg, u32 mask, u32 set)
 {
-	struct mii_bus *bus = priv->bus;
 	u32 val;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	val = core_read_mmd_indirect(priv, reg, MDIO_MMD_VEND2);
 	val &= ~mask;
 	val |= set;
 	core_write_mmd_indirect(priv, reg, MDIO_MMD_VEND2, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 }
 
 static void
@@ -264,13 +273,11 @@ mt7530_mii_read(struct mt7530_priv *priv, u32 reg)
 static void
 mt7530_write(struct mt7530_priv *priv, u32 reg, u32 val)
 {
-	struct mii_bus *bus = priv->bus;
-
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	mt7530_mii_write(priv, reg, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 }
 
 static u32
@@ -282,14 +289,13 @@ _mt7530_unlocked_read(struct mt7530_dummy_poll *p)
 static u32
 _mt7530_read(struct mt7530_dummy_poll *p)
 {
-	struct mii_bus		*bus = p->priv->bus;
 	u32 val;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(p->priv);
 
 	val = mt7530_mii_read(p->priv, p->reg);
 
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(p->priv);
 
 	return val;
 }
@@ -307,17 +313,16 @@ static void
 mt7530_rmw(struct mt7530_priv *priv, u32 reg,
 	   u32 mask, u32 set)
 {
-	struct mii_bus *bus = priv->bus;
 	u32 val;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	val = mt7530_mii_read(priv, reg);
 	val &= ~mask;
 	val |= set;
 	mt7530_mii_write(priv, reg, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 }
 
 static void
@@ -661,14 +666,13 @@ static int
 mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 			int regnum)
 {
-	struct mii_bus *bus = priv->bus;
 	struct mt7530_dummy_poll p;
 	u32 reg, val;
 	int ret;
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -701,7 +705,7 @@ mt7531_ind_c45_phy_read(struct mt7530_priv *priv, int port, int devad,
 
 	ret = val & MT7531_MDIO_RW_DATA_MASK;
 out:
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 
 	return ret;
 }
@@ -710,14 +714,13 @@ static int
 mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 			 int regnum, u16 data)
 {
-	struct mii_bus *bus = priv->bus;
 	struct mt7530_dummy_poll p;
 	u32 val, reg;
 	int ret;
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -749,7 +752,7 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 	}
 
 out:
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 
 	return ret;
 }
@@ -757,14 +760,13 @@ mt7531_ind_c45_phy_write(struct mt7530_priv *priv, int port, int devad,
 static int
 mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 {
-	struct mii_bus *bus = priv->bus;
 	struct mt7530_dummy_poll p;
 	int ret;
 	u32 val;
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, val,
 				 !(val & MT7531_PHY_ACS_ST), 20, 100000);
@@ -787,7 +789,7 @@ mt7531_ind_c22_phy_read(struct mt7530_priv *priv, int port, int regnum)
 
 	ret = val & MT7531_MDIO_RW_DATA_MASK;
 out:
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 
 	return ret;
 }
@@ -796,14 +798,13 @@ static int
 mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 			 u16 data)
 {
-	struct mii_bus *bus = priv->bus;
 	struct mt7530_dummy_poll p;
 	int ret;
 	u32 reg;
 
 	INIT_MT7530_DUMMY_POLL(&p, priv, MT7531_PHY_IAC);
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	ret = readx_poll_timeout(_mt7530_unlocked_read, &p, reg,
 				 !(reg & MT7531_PHY_ACS_ST), 20, 100000);
@@ -825,7 +826,7 @@ mt7531_ind_c22_phy_write(struct mt7530_priv *priv, int port, int regnum,
 	}
 
 out:
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 
 	return ret;
 }
@@ -1106,7 +1107,6 @@ static int
 mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct mt7530_priv *priv = ds->priv;
-	struct mii_bus *bus = priv->bus;
 	int length;
 	u32 val;
 
@@ -1117,7 +1117,7 @@ mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	if (!dsa_is_cpu_port(ds, port))
 		return 0;
 
-	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 
 	val = mt7530_mii_read(priv, MT7530_GMACCR);
 	val &= ~MAX_RX_PKT_LEN_MASK;
@@ -1138,7 +1138,7 @@ mt7530_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 
 	mt7530_mii_write(priv, MT7530_GMACCR, val);
 
-	mutex_unlock(&bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 
 	return 0;
 }
@@ -1939,10 +1939,10 @@ mt7530_irq_thread_fn(int irq, void *dev_id)
 	u32 val;
 	int p;
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 	val = mt7530_mii_read(priv, MT7530_SYS_INT_STS);
 	mt7530_mii_write(priv, MT7530_SYS_INT_STS, val);
-	mutex_unlock(&priv->bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 
 	for (p = 0; p < MT7530_NUM_PHYS; p++) {
 		if (BIT(p) & val) {
@@ -1978,7 +1978,7 @@ mt7530_irq_bus_lock(struct irq_data *d)
 {
 	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
 
-	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
+	mt7530_mutex_lock(priv);
 }
 
 static void
@@ -1987,7 +1987,7 @@ mt7530_irq_bus_sync_unlock(struct irq_data *d)
 	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
 
 	mt7530_mii_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
-	mutex_unlock(&priv->bus->mdio_lock);
+	mt7530_mutex_unlock(priv);
 }
 
 static struct irq_chip mt7530_irq_chip = {
-- 
2.39.2

