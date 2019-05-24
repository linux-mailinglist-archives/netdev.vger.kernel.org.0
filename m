Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00C829563
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390482AbfEXKGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:06:12 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:40455 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390464AbfEXKGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:06:11 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id BD45140005;
        Fri, 24 May 2019 10:06:07 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/5] net: mvpp2: cls: Use RSS contexts to handle RSS tables
Date:   Fri, 24 May 2019 12:05:52 +0200
Message-Id: <20190524100554.8606-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PPv2 controller has 8 RSS tables that are shared across all ports on
a given PPv2 instance. The previous implementation allocated one table
per port, leaving others unused.

By using RSS contexts, we can make use of multiple RSS tables per
port, one being the default table (always id 0), the other ones being
used as destinations for flow steering, in the same way as rx rings.

This commit introduces RSS contexts management in the PPv2 driver. We
always reserve one table per port, allocated when the port is probed.

The global table list is stored in the struct mvpp2, as it's a global
resource. Each port then maintains a list of indices in that global
table, that way each port can have it's own numbering scheme starting
from 0.

One limitation that seems unavoidable is that the hashing parameters are
shared across all RSS contexts for a given port. Hashing parameters for
ctx 0 will be applied to all contexts.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  16 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 200 +++++++++++++++---
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    |  15 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  65 +++++-
 4 files changed, 255 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index bb466af9434b..18ae8d06b692 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -626,6 +626,7 @@
 #define MVPP2_N_RFS_RULES		(MVPP2_N_RFS_ENTRIES_PER_FLOW * 7)
 
 /* RSS constants */
+#define MVPP22_N_RSS_TABLES		8
 #define MVPP22_RSS_TABLE_ENTRIES	32
 
 /* IPv6 max L3 address size */
@@ -727,6 +728,10 @@ enum mvpp2_prs_l3_cast {
 /* Definitions */
 struct mvpp2_dbgfs_entries;
 
+struct mvpp2_rss_table {
+	u32 indir[MVPP22_RSS_TABLE_ENTRIES];
+};
+
 /* Shared Packet Processor resources */
 struct mvpp2 {
 	/* Shared registers' base addresses */
@@ -790,6 +795,9 @@ struct mvpp2 {
 
 	/* Debugfs entries private data */
 	struct mvpp2_dbgfs_entries *dbgfs_entries;
+
+	/* RSS Indirection tables */
+	struct mvpp2_rss_table *rss_tables[MVPP22_N_RSS_TABLES];
 };
 
 struct mvpp2_pcpu_stats {
@@ -921,12 +929,14 @@ struct mvpp2_port {
 
 	u32 tx_time_coal;
 
-	/* RSS indirection table */
-	u32 indir[MVPP22_RSS_TABLE_ENTRIES];
-
 	/* List of steering rules active on that port */
 	struct mvpp2_ethtool_fs *rfs_rules[MVPP2_N_RFS_ENTRIES_PER_FLOW];
 	int n_rfs_rules;
+
+	/* Each port has its own view of the rss contexts, so that it can number
+	 * them from 0
+	 */
+	int rss_ctx[MVPP22_N_RSS_TABLES];
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index d549e9a29d9a..c16e343ccbbf 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -969,12 +969,22 @@ u32 mvpp2_cls_c2_hit_count(struct mvpp2 *priv, int c2_index)
 	return mvpp2_read(priv, MVPP22_CLS_C2_HIT_CTR);
 }
 
-static void mvpp2_rss_port_c2_enable(struct mvpp2_port *port)
+static void mvpp2_rss_port_c2_enable(struct mvpp2_port *port, u32 ctx)
 {
 	struct mvpp2_cls_c2_entry c2;
+	u8 qh, ql;
 
 	mvpp2_cls_c2_read(port->priv, MVPP22_CLS_C2_RSS_ENTRY(port->id), &c2);
 
+	/* The RxQ number is used to select the RSS table. It that case, we set
+	 * it to be the ctx number.
+	 */
+	qh = (ctx >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
+	ql = ctx & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+
+	c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
+		     MVPP22_CLS_C2_ATTR0_QLOW(ql);
+
 	c2.attr[2] |= MVPP22_CLS_C2_ATTR2_RSS_EN;
 
 	mvpp2_cls_c2_write(port->priv, &c2);
@@ -983,22 +993,45 @@ static void mvpp2_rss_port_c2_enable(struct mvpp2_port *port)
 static void mvpp2_rss_port_c2_disable(struct mvpp2_port *port)
 {
 	struct mvpp2_cls_c2_entry c2;
+	u8 qh, ql;
 
 	mvpp2_cls_c2_read(port->priv, MVPP22_CLS_C2_RSS_ENTRY(port->id), &c2);
 
+	/* Reset the default destination RxQ to the port's first rx queue. */
+	qh = (port->first_rxq >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
+	ql = port->first_rxq & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+
+	c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
+		      MVPP22_CLS_C2_ATTR0_QLOW(ql);
+
 	c2.attr[2] &= ~MVPP22_CLS_C2_ATTR2_RSS_EN;
 
 	mvpp2_cls_c2_write(port->priv, &c2);
 }
 
-void mvpp22_port_rss_enable(struct mvpp2_port *port)
+static inline int mvpp22_rss_ctx(struct mvpp2_port *port, int port_rss_ctx)
 {
-	mvpp2_rss_port_c2_enable(port);
+	return port->rss_ctx[port_rss_ctx];
 }
 
-void mvpp22_port_rss_disable(struct mvpp2_port *port)
+int mvpp22_port_rss_enable(struct mvpp2_port *port)
 {
+	if (mvpp22_rss_ctx(port, 0) < 0)
+		return -EINVAL;
+
+	mvpp2_rss_port_c2_enable(port, mvpp22_rss_ctx(port, 0));
+
+	return 0;
+}
+
+int mvpp22_port_rss_disable(struct mvpp2_port *port)
+{
+	if (mvpp22_rss_ctx(port, 0) < 0)
+		return -EINVAL;
+
 	mvpp2_rss_port_c2_disable(port);
+
+	return 0;
 }
 
 static void mvpp22_port_c2_lookup_disable(struct mvpp2_port *port, int entry)
@@ -1331,19 +1364,136 @@ static inline u32 mvpp22_rxfh_indir(struct mvpp2_port *port, u32 rxq)
 	return port->first_rxq + ((rxq * nrxqs + rxq / cpus) % port->nrxqs);
 }
 
-void mvpp22_rss_fill_table(struct mvpp2_port *port, u32 table)
+static void mvpp22_rss_fill_table(struct mvpp2_port *port,
+				  struct mvpp2_rss_table *table,
+				  u32 rss_ctx)
 {
 	struct mvpp2 *priv = port->priv;
 	int i;
 
 	for (i = 0; i < MVPP22_RSS_TABLE_ENTRIES; i++) {
-		u32 sel = MVPP22_RSS_INDEX_TABLE(table) |
+		u32 sel = MVPP22_RSS_INDEX_TABLE(rss_ctx) |
 			  MVPP22_RSS_INDEX_TABLE_ENTRY(i);
 		mvpp2_write(priv, MVPP22_RSS_INDEX, sel);
 
 		mvpp2_write(priv, MVPP22_RSS_TABLE_ENTRY,
-			    mvpp22_rxfh_indir(port, port->indir[i]));
+			    mvpp22_rxfh_indir(port, table->indir[i]));
+	}
+}
+
+static int mvpp22_rss_context_create(struct mvpp2_port *port, u32 *rss_ctx)
+{
+	struct mvpp2 *priv = port->priv;
+	u32 ctx;
+
+	/* Find the first free RSS table */
+	for (ctx = 0; ctx < MVPP22_N_RSS_TABLES; ctx++) {
+		if (!priv->rss_tables[ctx])
+			break;
+	}
+
+	if (ctx == MVPP22_N_RSS_TABLES)
+		return -EINVAL;
+
+	priv->rss_tables[ctx] = kzalloc(sizeof(*priv->rss_tables[ctx]),
+					GFP_KERNEL);
+	if (!priv->rss_tables[ctx])
+		return -ENOMEM;
+
+	*rss_ctx = ctx;
+
+	/* Set the table width: replace the whole classifier Rx queue number
+	 * with the ones configured in RSS table entries.
+	 */
+	mvpp2_write(priv, MVPP22_RSS_INDEX, MVPP22_RSS_INDEX_TABLE(ctx));
+	mvpp2_write(priv, MVPP22_RSS_WIDTH, 8);
+
+	mvpp2_write(priv, MVPP22_RSS_INDEX, MVPP22_RSS_INDEX_QUEUE(ctx));
+	mvpp2_write(priv, MVPP22_RXQ2RSS_TABLE, MVPP22_RSS_TABLE_POINTER(ctx));
+
+	return 0;
+}
+
+int mvpp22_port_rss_ctx_create(struct mvpp2_port *port, u32 *port_ctx)
+{
+	u32 rss_ctx;
+	int ret, i;
+
+	ret = mvpp22_rss_context_create(port, &rss_ctx);
+	if (ret)
+		return ret;
+
+	/* Find the first available context number in the port, starting from 1.
+	 * Context 0 on each port is reserved for the default context.
+	 */
+	for (i = 1; i < MVPP22_N_RSS_TABLES; i++) {
+		if (port->rss_ctx[i] < 0)
+			break;
 	}
+
+	port->rss_ctx[i] = rss_ctx;
+	*port_ctx = i;
+
+	return 0;
+}
+
+static struct mvpp2_rss_table *mvpp22_rss_table_get(struct mvpp2 *priv,
+						    int rss_ctx)
+{
+	if (rss_ctx < 0 || rss_ctx >= MVPP22_N_RSS_TABLES)
+		return NULL;
+
+	return priv->rss_tables[rss_ctx];
+}
+
+int mvpp22_port_rss_ctx_delete(struct mvpp2_port *port, u32 port_ctx)
+{
+	struct mvpp2 *priv = port->priv;
+	int rss_ctx = mvpp22_rss_ctx(port, port_ctx);
+
+	if (rss_ctx < 0 || rss_ctx >= MVPP22_N_RSS_TABLES)
+		return -EINVAL;
+
+	kfree(priv->rss_tables[rss_ctx]);
+
+	priv->rss_tables[rss_ctx] = NULL;
+	port->rss_ctx[port_ctx] = -1;
+
+	return 0;
+}
+
+int mvpp22_port_rss_ctx_indir_set(struct mvpp2_port *port, u32 port_ctx,
+				  const u32 *indir)
+{
+	int rss_ctx = mvpp22_rss_ctx(port, port_ctx);
+	struct mvpp2_rss_table *rss_table = mvpp22_rss_table_get(port->priv,
+								 rss_ctx);
+
+	if (!rss_table)
+		return -EINVAL;
+
+	memcpy(rss_table->indir, indir,
+	       MVPP22_RSS_TABLE_ENTRIES * sizeof(rss_table->indir[0]));
+
+	mvpp22_rss_fill_table(port, rss_table, rss_ctx);
+
+	return 0;
+}
+
+int mvpp22_port_rss_ctx_indir_get(struct mvpp2_port *port, u32 port_ctx,
+				  u32 *indir)
+{
+	int rss_ctx =  mvpp22_rss_ctx(port, port_ctx);
+	struct mvpp2_rss_table *rss_table = mvpp22_rss_table_get(port->priv,
+								 rss_ctx);
+
+	if (!rss_table)
+		return -EINVAL;
+
+	memcpy(indir, rss_table->indir,
+	       MVPP22_RSS_TABLE_ENTRIES * sizeof(rss_table->indir[0]));
+
+	return 0;
 }
 
 int mvpp2_ethtool_rxfh_set(struct mvpp2_port *port, struct ethtool_rxnfc *info)
@@ -1427,32 +1577,32 @@ int mvpp2_ethtool_rxfh_get(struct mvpp2_port *port, struct ethtool_rxnfc *info)
 	return 0;
 }
 
-void mvpp22_port_rss_init(struct mvpp2_port *port)
+int mvpp22_port_rss_init(struct mvpp2_port *port)
 {
-	struct mvpp2 *priv = port->priv;
-	int i;
+	struct mvpp2_rss_table *table;
+	u32 context = 0;
+	int i, ret;
 
-	/* Set the table width: replace the whole classifier Rx queue number
-	 * with the ones configured in RSS table entries.
-	 */
-	mvpp2_write(priv, MVPP22_RSS_INDEX, MVPP22_RSS_INDEX_TABLE(port->id));
-	mvpp2_write(priv, MVPP22_RSS_WIDTH, 8);
+	for (i = 0; i < MVPP22_N_RSS_TABLES; i++)
+		port->rss_ctx[i] = -1;
 
-	/* The default RxQ is used as a key to select the RSS table to use.
-	 * We use one RSS table per port.
-	 */
-	mvpp2_write(priv, MVPP22_RSS_INDEX,
-		    MVPP22_RSS_INDEX_QUEUE(port->first_rxq));
-	mvpp2_write(priv, MVPP22_RXQ2RSS_TABLE,
-		    MVPP22_RSS_TABLE_POINTER(port->id));
+	ret = mvpp22_rss_context_create(port, &context);
+	if (ret)
+		return ret;
+
+	table = mvpp22_rss_table_get(port->priv, context);
+	if (!table)
+		return -EINVAL;
+
+	port->rss_ctx[0] = context;
 
 	/* Configure the first table to evenly distribute the packets across
 	 * real Rx Queues. The table entries map a hash to a port Rx Queue.
 	 */
 	for (i = 0; i < MVPP22_RSS_TABLE_ENTRIES; i++)
-		port->indir[i] = ethtool_rxfh_indir_default(i, port->nrxqs);
+		table->indir[i] = ethtool_rxfh_indir_default(i, port->nrxqs);
 
-	mvpp22_rss_fill_table(port, port->id);
+	mvpp22_rss_fill_table(port, table, mvpp22_rss_ctx(port, 0));
 
 	/* Configure default flows */
 	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_IP4, MVPP22_CLS_HEK_IP4_2T);
@@ -1461,4 +1611,6 @@ void mvpp22_port_rss_init(struct mvpp2_port *port)
 	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_TCP6, MVPP22_CLS_HEK_IP6_5T);
 	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_UDP4, MVPP22_CLS_HEK_IP4_5T);
 	mvpp2_port_rss_hash_opts_set(port, MVPP22_FLOW_UDP6, MVPP22_CLS_HEK_IP6_5T);
+
+	return 0;
 }
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 56b617375a65..26cc1176e758 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -249,11 +249,18 @@ struct mvpp2_cls_lookup_entry {
 	u32 data;
 };
 
-void mvpp22_rss_fill_table(struct mvpp2_port *port, u32 table);
-void mvpp22_port_rss_init(struct mvpp2_port *port);
+int mvpp22_port_rss_init(struct mvpp2_port *port);
 
-void mvpp22_port_rss_enable(struct mvpp2_port *port);
-void mvpp22_port_rss_disable(struct mvpp2_port *port);
+int mvpp22_port_rss_enable(struct mvpp2_port *port);
+int mvpp22_port_rss_disable(struct mvpp2_port *port);
+
+int mvpp22_port_rss_ctx_create(struct mvpp2_port *port, u32 *rss_ctx);
+int mvpp22_port_rss_ctx_delete(struct mvpp2_port *port, u32 rss_ctx);
+
+int mvpp22_port_rss_ctx_indir_set(struct mvpp2_port *port, u32 rss_ctx,
+				  const u32 *indir);
+int mvpp22_port_rss_ctx_indir_get(struct mvpp2_port *port, u32 rss_ctx,
+				  u32 *indir);
 
 int mvpp2_ethtool_rxfh_get(struct mvpp2_port *port, struct ethtool_rxnfc *info);
 int mvpp2_ethtool_rxfh_set(struct mvpp2_port *port, struct ethtool_rxnfc *info);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8432315447dd..3ed713b8dea5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4002,24 +4002,25 @@ static int mvpp2_ethtool_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 				  u8 *hfunc)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	int ret = 0;
 
 	if (!mvpp22_rss_is_supported())
 		return -EOPNOTSUPP;
 
 	if (indir)
-		memcpy(indir, port->indir,
-		       ARRAY_SIZE(port->indir) * sizeof(port->indir[0]));
+		ret = mvpp22_port_rss_ctx_indir_get(port, 0, indir);
 
 	if (hfunc)
 		*hfunc = ETH_RSS_HASH_CRC32;
 
-	return 0;
+	return ret;
 }
 
 static int mvpp2_ethtool_set_rxfh(struct net_device *dev, const u32 *indir,
 				  const u8 *key, const u8 hfunc)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	int ret = 0;
 
 	if (!mvpp22_rss_is_supported())
 		return -EOPNOTSUPP;
@@ -4030,15 +4031,58 @@ static int mvpp2_ethtool_set_rxfh(struct net_device *dev, const u32 *indir,
 	if (key)
 		return -EOPNOTSUPP;
 
-	if (indir) {
-		memcpy(port->indir, indir,
-		       ARRAY_SIZE(port->indir) * sizeof(port->indir[0]));
-		mvpp22_rss_fill_table(port, port->id);
-	}
+	if (indir)
+		ret = mvpp22_port_rss_ctx_indir_set(port, 0, indir);
 
-	return 0;
+	return ret;
 }
 
+static int mvpp2_ethtool_get_rxfh_context(struct net_device *dev, u32 *indir,
+					  u8 *key, u8 *hfunc, u32 rss_context)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	int ret = 0;
+
+	if (!mvpp22_rss_is_supported())
+		return -EOPNOTSUPP;
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_CRC32;
+
+	if (indir)
+		ret = mvpp22_port_rss_ctx_indir_get(port, rss_context, indir);
+
+	return ret;
+}
+
+static int mvpp2_ethtool_set_rxfh_context(struct net_device *dev,
+					  const u32 *indir, const u8 *key,
+					  const u8 hfunc, u32 *rss_context,
+					  bool delete)
+{
+	struct mvpp2_port *port = netdev_priv(dev);
+	int ret;
+
+	if (!mvpp22_rss_is_supported())
+		return -EOPNOTSUPP;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_CRC32)
+		return -EOPNOTSUPP;
+
+	if (key)
+		return -EOPNOTSUPP;
+
+	if (delete)
+		return mvpp22_port_rss_ctx_delete(port, *rss_context);
+
+	if (*rss_context == ETH_RXFH_CONTEXT_ALLOC) {
+		ret = mvpp22_port_rss_ctx_create(port, rss_context);
+		if (ret)
+			return ret;
+	}
+
+	return mvpp22_port_rss_ctx_indir_set(port, *rss_context, indir);
+}
 /* Device ops */
 
 static const struct net_device_ops mvpp2_netdev_ops = {
@@ -4075,7 +4119,8 @@ static const struct ethtool_ops mvpp2_eth_tool_ops = {
 	.get_rxfh_indir_size	= mvpp2_ethtool_get_rxfh_indir_size,
 	.get_rxfh		= mvpp2_ethtool_get_rxfh,
 	.set_rxfh		= mvpp2_ethtool_set_rxfh,
-
+	.get_rxfh_context	= mvpp2_ethtool_get_rxfh_context,
+	.set_rxfh_context	= mvpp2_ethtool_set_rxfh_context,
 };
 
 /* Used for PPv2.1, or PPv2.2 with the old Device Tree binding that
-- 
2.20.1

