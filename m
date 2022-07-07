Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8FA56A6EA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiGGPaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbiGGP3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:29:54 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC12F18E36;
        Thu,  7 Jul 2022 08:29:51 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id ADC111886E78;
        Thu,  7 Jul 2022 15:29:50 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 9F9D225032B7;
        Thu,  7 Jul 2022 15:29:50 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 93A79A1E00B9; Thu,  7 Jul 2022 15:29:50 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.vestervang (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 1E19D9120FED;
        Thu,  7 Jul 2022 15:29:49 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry flag to drivers
Date:   Thu,  7 Jul 2022 17:29:27 +0200
Message-Id: <20220707152930.1789437-4-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220707152930.1789437-1-netdev@kapio-technology.com>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore locked fdb entries coming in on all drivers.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/b53/b53_common.c       | 5 +++++
 drivers/net/dsa/b53/b53_priv.h         | 1 +
 drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
 drivers/net/dsa/lan9303-core.c         | 5 +++++
 drivers/net/dsa/lantiq_gswip.c         | 5 +++++
 drivers/net/dsa/microchip/ksz9477.c    | 5 +++++
 drivers/net/dsa/mt7530.c               | 5 +++++
 drivers/net/dsa/mv88e6xxx/chip.c       | 5 +++++
 drivers/net/dsa/ocelot/felix.c         | 5 +++++
 drivers/net/dsa/qca8k.c                | 5 +++++
 drivers/net/dsa/sja1105/sja1105_main.c | 5 +++++
 include/net/dsa.h                      | 1 +
 net/dsa/switch.c                       | 4 ++--
 13 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index fbb32aa49b24..3567d4fcbaa7 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1688,11 +1688,16 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
+		bool is_locked,
 		struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
 	 */
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 795cbffd5c2b..19501b76b9df 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -362,6 +362,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
+		bool is_locked,
 		struct dsa_db db);
 int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index ac1f3b3a7040..0125d901c988 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -829,12 +829,17 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 
 static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 			     const unsigned char *addr, u16 vid,
+			     bool is_locked,
 			     struct dsa_db db)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
 	int ret;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	dev_dbg(hellcreek->dev, "Add FDB entry for MAC=%pM\n", addr);
 
 	mutex_lock(&hellcreek->reg_lock);
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..426b9ea668da 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1190,10 +1190,15 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 
 static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
+				bool is_locked,
 				struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
 	if (vid)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8af4def38a98..4da7186935f4 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1399,8 +1399,13 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 
 static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
 			      const unsigned char *addr, u16 vid,
+			      bool is_locked,
 			      struct dsa_db db)
 {
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	return gswip_port_fdb(ds, port, addr, vid, true);
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index ab40b700cf1a..c177eb97a072 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -481,6 +481,7 @@ static int ksz9477_port_vlan_del(struct dsa_switch *ds, int port,
 
 static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
+				bool is_locked,
 				struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
@@ -488,6 +489,10 @@ static int ksz9477_port_fdb_add(struct dsa_switch *ds, int port,
 	u32 data;
 	int ret = 0;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return ret;
+
 	mutex_lock(&dev->alu_mutex);
 
 	/* find any entry with mac & vid */
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 2b02d823d497..cbf922cf425e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1356,12 +1356,17 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 static int
 mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 		    const unsigned char *addr, u16 vid,
+		    bool is_locked,
 		    struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
 	u8 port_mask = BIT(port);
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	mutex_lock(&priv->reg_mutex);
 	mt7530_fdb_write(priv, vid, port_mask, addr, -1, STATIC_ENT);
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_WRITE, NULL);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5d2c57a7c708..d134153ef023 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2717,11 +2717,16 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
 
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
+				  bool is_locked,
 				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3e07dc39007a..00ba495a7ab5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -695,12 +695,17 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 
 static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
+			 bool is_locked,
 			 struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2727d3169c25..6267e94af485 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2369,11 +2369,16 @@ qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 static int
 qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 		   const unsigned char *addr, u16 vid,
+		   bool is_locked,
 		   struct dsa_db db)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 72b6fc1932b5..9b5c2b56d06d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1802,10 +1802,15 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid,
+			   bool is_locked,
 			   struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	if (!vid) {
 		switch (db.type) {
 		case DSA_DB_PORT:
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a5a843b2d67d..ebae403ce734 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1010,6 +1010,7 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
+				bool is_locked,
 				struct dsa_db db);
 	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 32b1e7ac6373..ea3b9c1acb8c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -243,7 +243,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
+		return ds->ops->port_fdb_add(ds, port, addr, vid, is_locked, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -259,7 +259,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		goto out;
 	}
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
+	err = ds->ops->port_fdb_add(ds, port, addr, vid, is_locked, db);
 	if (err) {
 		kfree(a);
 		goto out;
-- 
2.30.2

