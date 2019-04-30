Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818C6F9AE
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfD3NOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:14:52 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:54977 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfD3NOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:14:49 -0400
X-Originating-IP: 90.88.149.145
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2E18A1BF21F;
        Tue, 30 Apr 2019 13:14:42 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 3/4] net: mvpp2: cls: Add Classification offload support
Date:   Tue, 30 Apr 2019 15:14:28 +0200
Message-Id: <20190430131429.19361-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces basic classification offloading support for the
PPv2 controller.

The PPv2 classifier has many classification engines, for now we only use
the C2 TCAM match engine.

This engine allows to perform ternary lookups on 64 bits keys (called
Header Extracted Key), that are built by extracting fields from the packet
header and concatenating them. At most 4 fields can be extracted for a
single lookup.

This basic implementation allows to build the HEK from the following
fields :
 - L4 source and destination ports (for UDP and TCP)

More fields are to be added in the future.

Classification flows are added through the ethtool interface, using the
newly introduced flow_rule infrastructure as an internal rule
representation, allowing to more easily implement tc flower rules if
need be.

The internal design for now allocates one range of 4 rules per port
due to the internal design of the flow table, which uses 22 sub-flows.

When inserting a classification rule, the rule is created in every
relevant sub-flow.

This low rule-count is a very simple design which reaches quickly the
limitations of the flow table ordering, but guarantees that the rule
ordering will always be respected.

This commit only introduces support for the "steer to rxq" action.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  41 +++
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 316 ++++++++++++++++++
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    |  45 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  20 +-
 4 files changed, 410 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 67cce2736806..9d2222ab60ae 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
+#include <net/flow_offload.h>
 
 /* Fifo Registers */
 #define MVPP2_RX_DATA_FIFO_SIZE_REG(port)	(0x00 + 4 * (port))
@@ -126,6 +127,7 @@
 #define MVPP22_CLS_C2_TCAM_DATA4		0x1b20
 #define     MVPP22_CLS_C2_LU_TYPE(lu)		((lu) & 0x3f)
 #define     MVPP22_CLS_C2_PORT_ID(port)		((port) << 8)
+#define     MVPP22_CLS_C2_PORT_MASK		(0xff << 8)
 #define MVPP22_CLS_C2_TCAM_INV			0x1b24
 #define     MVPP22_CLS_C2_TCAM_INV_BIT		BIT(31)
 #define MVPP22_CLS_C2_HIT_CTR			0x1b50
@@ -615,6 +617,10 @@
 #define MVPP2_BIT_IN_WORD(bit)		((bit) % 32)
 
 #define MVPP2_N_PRS_FLOWS		52
+#define MVPP2_N_RFS_ENTRIES_PER_FLOW	4
+
+/* There are 7 supported high-level flows */
+#define MVPP2_N_RFS_RULES		(MVPP2_N_RFS_ENTRIES_PER_FLOW * 7)
 
 /* RSS constants */
 #define MVPP22_RSS_TABLE_ENTRIES	32
@@ -812,6 +818,37 @@ struct mvpp2_queue_vector {
 	struct cpumask *mask;
 };
 
+/* Internal represention of a Flow Steering rule */
+struct mvpp2_rfs_rule {
+	/* Rule location inside the flow*/
+	int loc;
+
+	/* Flow type, such as TCP_V4_FLOW, IP6_FLOW, etc. */
+	int flow_type;
+
+	/* Index of the C2 TCAM entry handling this rule */
+	int c2_index;
+
+	/* Header fields that needs to be extracted to match this flow */
+	u16 hek_fields;
+
+	/* CLS engine : only c2 is supported for now. */
+	u8 engine;
+
+	/* TCAM key and mask for C2-based steering. These fields should be
+	 * encapsulated in a union should we add more engines.
+	 */
+	u64 c2_tcam;
+	u64 c2_tcam_mask;
+
+	struct flow_rule *flow;
+};
+
+struct mvpp2_ethtool_fs {
+	struct mvpp2_rfs_rule rule;
+	struct ethtool_rxnfc rxnfc;
+};
+
 struct mvpp2_port {
 	u8 id;
 
@@ -883,6 +920,10 @@ struct mvpp2_port {
 
 	/* RSS indirection table */
 	u32 indir[MVPP22_RSS_TABLE_ENTRIES];
+
+	/* List of steering rules active on that port */
+	struct mvpp2_ethtool_fs *rfs_rules[MVPP2_N_RFS_RULES];
+	int n_rfs_rules;
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 2bbd4c294fc9..f4dd59c00d80 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -448,6 +448,12 @@ static void mvpp2_cls_flow_port_add(struct mvpp2_cls_flow_entry *fe,
 	fe->data[0] |= MVPP2_CLS_FLOW_TBL0_PORT_ID(port);
 }
 
+static void mvpp2_cls_flow_port_remove(struct mvpp2_cls_flow_entry *fe,
+				       u32 port)
+{
+	fe->data[0] &= ~MVPP2_CLS_FLOW_TBL0_PORT_ID(port);
+}
+
 static void mvpp2_cls_flow_lu_type_set(struct mvpp2_cls_flow_entry *fe,
 				       u8 lu_type)
 {
@@ -559,6 +565,11 @@ static int mvpp2_cls_ethtool_flow_to_type(int flow_type)
 	}
 }
 
+static int mvpp2_cls_c2_port_flow_index(struct mvpp2_port *port, int loc)
+{
+	return MVPP22_CLS_C2_RFS_LOC(port->id, loc);
+}
+
 /* Initialize the flow table entries for the given flow */
 static void mvpp2_cls_flow_init(struct mvpp2 *priv,
 				const struct mvpp2_cls_flow *flow)
@@ -672,6 +683,26 @@ static int mvpp2_flow_set_hek_fields(struct mvpp2_cls_flow_entry *fe,
 	return 0;
 }
 
+/* Returns the size, in bits, of the corresponding HEK field */
+static int mvpp2_cls_hek_field_size(u32 field)
+{
+	switch (field) {
+	case MVPP22_CLS_HEK_OPT_MAC_DA:
+		return 48;
+	case MVPP22_CLS_HEK_OPT_IP4SA:
+	case MVPP22_CLS_HEK_OPT_IP4DA:
+		return 32;
+	case MVPP22_CLS_HEK_OPT_IP6SA:
+	case MVPP22_CLS_HEK_OPT_IP6DA:
+		return 128;
+	case MVPP22_CLS_HEK_OPT_L4SIP:
+	case MVPP22_CLS_HEK_OPT_L4DIP:
+		return 16;
+	default:
+		return -1;
+	}
+}
+
 const struct mvpp2_cls_flow *mvpp2_cls_flow_get(int flow)
 {
 	if (flow >= MVPP2_N_PRS_FLOWS)
@@ -964,6 +995,18 @@ void mvpp22_port_rss_disable(struct mvpp2_port *port)
 	mvpp2_rss_port_c2_disable(port);
 }
 
+static void mvpp22_port_c2_lookup_disable(struct mvpp2_port *port, int entry)
+{
+	struct mvpp2_cls_c2_entry c2;
+
+	mvpp2_cls_c2_read(port->priv, entry, &c2);
+
+	/* Clear the port map so that the entry doesn't match anymore */
+	c2.tcam[4] &= ~(MVPP22_CLS_C2_PORT_ID(BIT(port->id)));
+
+	mvpp2_cls_c2_write(port->priv, &c2);
+}
+
 /* Set CPU queue number for oversize packets */
 void mvpp2_cls_oversize_rxq_set(struct mvpp2_port *port)
 {
@@ -980,6 +1023,279 @@ void mvpp2_cls_oversize_rxq_set(struct mvpp2_port *port)
 	mvpp2_write(port->priv, MVPP2_CLS_SWFWD_PCTRL_REG, val);
 }
 
+static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
+				       struct mvpp2_rfs_rule *rule)
+{
+	struct flow_action_entry *act;
+	struct mvpp2_cls_c2_entry c2;
+	u8 qh, ql, pmap;
+
+	memset(&c2, 0, sizeof(c2));
+
+	c2.index = mvpp2_cls_c2_port_flow_index(port, rule->loc);
+	if (c2.index < 0)
+		return -EINVAL;
+
+	act = &rule->flow->action.entries[0];
+
+	rule->c2_index = c2.index;
+
+	c2.tcam[0] = (rule->c2_tcam & 0xffff) |
+		     ((rule->c2_tcam_mask & 0xffff) << 16);
+	c2.tcam[1] = ((rule->c2_tcam >> 16) & 0xffff) |
+		     (((rule->c2_tcam_mask >> 16) & 0xffff) << 16);
+	c2.tcam[2] = ((rule->c2_tcam >> 32) & 0xffff) |
+		     (((rule->c2_tcam_mask >> 32) & 0xffff) << 16);
+	c2.tcam[3] = ((rule->c2_tcam >> 48) & 0xffff) |
+		     (((rule->c2_tcam_mask >> 48) & 0xffff) << 16);
+
+	pmap = BIT(port->id);
+	c2.tcam[4] = MVPP22_CLS_C2_PORT_ID(pmap);
+	c2.tcam[4] |= MVPP22_CLS_C2_TCAM_EN(MVPP22_CLS_C2_PORT_ID(pmap));
+
+	/* Match on Lookup Type */
+	c2.tcam[4] |= MVPP22_CLS_C2_TCAM_EN(MVPP22_CLS_C2_LU_TYPE(MVPP2_CLS_LU_TYPE_MASK));
+	c2.tcam[4] |= MVPP22_CLS_C2_LU_TYPE(rule->loc);
+
+	/* Mark packet as "forwarded to software", needed for RSS */
+	c2.act |= MVPP22_CLS_C2_ACT_FWD(MVPP22_C2_FWD_SW_LOCK);
+
+	c2.act |= MVPP22_CLS_C2_ACT_QHIGH(MVPP22_C2_UPD_LOCK) |
+		   MVPP22_CLS_C2_ACT_QLOW(MVPP22_C2_UPD_LOCK);
+
+	qh = ((act->queue.index + port->first_rxq) >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
+	ql = (act->queue.index + port->first_rxq) & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+
+	c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
+		      MVPP22_CLS_C2_ATTR0_QLOW(ql);
+
+	c2.valid = true;
+
+	mvpp2_cls_c2_write(port->priv, &c2);
+
+	return 0;
+}
+
+static int mvpp2_port_c2_rfs_rule_insert(struct mvpp2_port *port,
+					 struct mvpp2_rfs_rule *rule)
+{
+	return mvpp2_port_c2_tcam_rule_add(port, rule);
+}
+
+static int mvpp2_port_cls_rfs_rule_remove(struct mvpp2_port *port,
+					  struct mvpp2_rfs_rule *rule)
+{
+	const struct mvpp2_cls_flow *flow;
+	struct mvpp2_cls_flow_entry fe;
+	int index, i;
+
+	for_each_cls_flow_id_containing_type(i, rule->flow_type) {
+		flow = mvpp2_cls_flow_get(i);
+		if (!flow)
+			return 0;
+
+		index = MVPP2_CLS_FLT_C2_RFS(port->id, flow->flow_id, rule->loc);
+
+		mvpp2_cls_flow_read(port->priv, index, &fe);
+		mvpp2_cls_flow_port_remove(&fe, BIT(port->id));
+		mvpp2_cls_flow_write(port->priv, &fe);
+	}
+
+	if (rule->c2_index >= 0)
+		mvpp22_port_c2_lookup_disable(port, rule->c2_index);
+
+	return 0;
+}
+
+static int mvpp2_port_flt_rfs_rule_insert(struct mvpp2_port *port,
+					  struct mvpp2_rfs_rule *rule)
+{
+	const struct mvpp2_cls_flow *flow;
+	struct mvpp2 *priv = port->priv;
+	struct mvpp2_cls_flow_entry fe;
+	int index, ret, i;
+
+	if (rule->engine != MVPP22_CLS_ENGINE_C2)
+		return -EOPNOTSUPP;
+
+	ret = mvpp2_port_c2_rfs_rule_insert(port, rule);
+	if (ret)
+		return ret;
+
+	for_each_cls_flow_id_containing_type(i, rule->flow_type) {
+		flow = mvpp2_cls_flow_get(i);
+		if (!flow)
+			return 0;
+
+		index = MVPP2_CLS_FLT_C2_RFS(port->id, flow->flow_id, rule->loc);
+
+		mvpp2_cls_flow_read(priv, index, &fe);
+		mvpp2_cls_flow_eng_set(&fe, rule->engine);
+		mvpp2_cls_flow_port_id_sel(&fe, true);
+		mvpp2_flow_set_hek_fields(&fe, rule->hek_fields);
+		mvpp2_cls_flow_lu_type_set(&fe, rule->loc);
+		mvpp2_cls_flow_port_add(&fe, 0xf);
+
+		mvpp2_cls_flow_write(priv, &fe);
+	}
+
+	return 0;
+}
+
+static int mvpp2_cls_c2_build_match(struct mvpp2_rfs_rule *rule)
+{
+	struct flow_rule *flow = rule->flow;
+	struct flow_action_entry *act;
+	int offs = 64;
+
+	act = &flow->action.entries[0];
+
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(flow, &match);
+		if (match.mask->src) {
+			rule->hek_fields |= MVPP22_CLS_HEK_OPT_L4SIP;
+			offs -= mvpp2_cls_hek_field_size(MVPP22_CLS_HEK_OPT_L4SIP);
+
+			rule->c2_tcam |= ((u64)ntohs(match.key->src)) << offs;
+			rule->c2_tcam_mask |= ((u64)ntohs(match.mask->src)) << offs;
+		}
+
+		if (match.mask->dst) {
+			rule->hek_fields |= MVPP22_CLS_HEK_OPT_L4DIP;
+			offs -= mvpp2_cls_hek_field_size(MVPP22_CLS_HEK_OPT_L4DIP);
+
+			rule->c2_tcam |= ((u64)ntohs(match.key->dst)) << offs;
+			rule->c2_tcam_mask |= ((u64)ntohs(match.mask->dst)) << offs;
+		}
+	}
+
+	if (hweight16(rule->hek_fields) > MVPP2_FLOW_N_FIELDS)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int mvpp2_cls_rfs_parse_rule(struct mvpp2_rfs_rule *rule)
+{
+	struct flow_rule *flow = rule->flow;
+	struct flow_action_entry *act;
+
+	act = &flow->action.entries[0];
+	if (act->id != FLOW_ACTION_QUEUE)
+		return -EOPNOTSUPP;
+
+	/* For now, only use the C2 engine which has a HEK size limited to 64
+	 * bits for TCAM matching.
+	 */
+	rule->engine = MVPP22_CLS_ENGINE_C2;
+
+	if (mvpp2_cls_c2_build_match(rule))
+		return -EINVAL;
+
+	return 0;
+}
+
+int mvpp2_ethtool_cls_rule_get(struct mvpp2_port *port,
+			       struct ethtool_rxnfc *rxnfc)
+{
+	struct mvpp2_ethtool_fs *efs;
+
+	if (rxnfc->fs.location >= MVPP2_N_RFS_RULES)
+		return -EINVAL;
+
+	efs = port->rfs_rules[rxnfc->fs.location];
+	if (!efs)
+		return -ENOENT;
+
+	memcpy(rxnfc, &efs->rxnfc, sizeof(efs->rxnfc));
+
+	return 0;
+}
+
+int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
+			       struct ethtool_rxnfc *info)
+{
+	struct ethtool_rx_flow_spec_input input = {};
+	struct ethtool_rx_flow_rule *ethtool_rule;
+	struct mvpp2_ethtool_fs *efs, *old_efs;
+	int ret = 0;
+
+	if (info->fs.location >= 4 ||
+	    info->fs.location < 0)
+		return -EINVAL;
+
+	efs = kzalloc(sizeof(*efs), GFP_KERNEL);
+	if (!efs)
+		return -ENOMEM;
+
+	input.fs = &info->fs;
+
+	ethtool_rule = ethtool_rx_flow_rule_create(&input);
+	if (IS_ERR(ethtool_rule)) {
+		ret = PTR_ERR(ethtool_rule);
+		goto clean_rule;
+	}
+
+	efs->rule.flow = ethtool_rule->rule;
+	efs->rule.flow_type = mvpp2_cls_ethtool_flow_to_type(info->fs.flow_type);
+
+	ret = mvpp2_cls_rfs_parse_rule(&efs->rule);
+	if (ret)
+		goto clean_eth_rule;
+
+	efs->rule.loc = info->fs.location;
+
+	/* Replace an already existing rule */
+	if (port->rfs_rules[efs->rule.loc]) {
+		old_efs = port->rfs_rules[efs->rule.loc];
+		ret = mvpp2_port_cls_rfs_rule_remove(port, &old_efs->rule);
+		if (ret)
+			goto clean_eth_rule;
+		kfree(old_efs);
+		port->n_rfs_rules--;
+	}
+
+	ret = mvpp2_port_flt_rfs_rule_insert(port, &efs->rule);
+	if (ret)
+		goto clean_eth_rule;
+
+	memcpy(&efs->rxnfc, info, sizeof(*info));
+	port->rfs_rules[efs->rule.loc] = efs;
+	port->n_rfs_rules++;
+
+	return ret;
+
+clean_eth_rule:
+	ethtool_rx_flow_rule_destroy(ethtool_rule);
+clean_rule:
+	kfree(efs);
+	return ret;
+}
+
+int mvpp2_ethtool_cls_rule_del(struct mvpp2_port *port,
+			       struct ethtool_rxnfc *info)
+{
+	struct mvpp2_ethtool_fs *efs;
+	int ret;
+
+	efs = port->rfs_rules[info->fs.location];
+	if (!efs)
+		return -EINVAL;
+
+	/* Remove the rule from the engines. */
+	ret = mvpp2_port_cls_rfs_rule_remove(port, &efs->rule);
+	if (ret)
+		return ret;
+
+	port->n_rfs_rules--;
+	port->rfs_rules[info->fs.location] = NULL;
+	kfree(efs);
+
+	return 0;
+}
+
 static inline u32 mvpp22_rxfh_indir(struct mvpp2_port *port, u32 rxq)
 {
 	int nrxqs, cpu, cpus = num_possible_cpus();
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 284a16225370..431563a13524 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -125,11 +125,18 @@ struct mvpp2_cls_c2_entry {
 #define MVPP22_CLS_C2_N_ENTRIES		256
 
 /* Number of per-port dedicated entries in the C2 TCAM */
-#define MVPP22_CLS_C2_PORT_RANGE	8
+#define MVPP22_CLS_C2_PORT_N_FLOWS	MVPP2_N_RFS_ENTRIES_PER_FLOW
 
-#define MVPP22_CLS_C2_PORT_FIRST(p)	(MVPP22_CLS_C2_N_ENTRIES - \
-					((p) * MVPP22_CLS_C2_PORT_RANGE))
-#define MVPP22_CLS_C2_RSS_ENTRY(p)	(MVPP22_CLS_C2_PORT_FIRST(p) - 1)
+/* Each port has oen range per flow type + one entry controling the global RSS
+ * setting and the default rx queue
+ */
+#define MVPP22_CLS_C2_PORT_RANGE	(MVPP22_CLS_C2_PORT_N_FLOWS + 1)
+#define MVPP22_CLS_C2_PORT_FIRST(p)	((p) * MVPP22_CLS_C2_PORT_RANGE)
+#define MVPP22_CLS_C2_RSS_ENTRY(p)	(MVPP22_CLS_C2_PORT_FIRST((p) + 1) - 1)
+
+#define MVPP22_CLS_C2_PORT_FLOW_FIRST(p)	(MVPP22_CLS_C2_PORT_FIRST(p))
+
+#define MVPP22_CLS_C2_RFS_LOC(p, loc)	(MVPP22_CLS_C2_PORT_FLOW_FIRST(p) + (loc))
 
 /* Packet flow ID */
 enum mvpp2_prs_flow {
@@ -159,10 +166,6 @@ enum mvpp2_prs_flow {
 	MVPP2_FL_LAST,
 };
 
-enum mvpp2_cls_lu_type {
-	MVPP2_CLS_LU_ALL = 0,
-};
-
 /* LU Type defined for all engines, and specified in the flow table */
 #define MVPP2_CLS_LU_TYPE_MASK			0x3f
 
@@ -182,11 +185,16 @@ struct mvpp2_cls_flow {
 	struct mvpp2_prs_result_info prs_ri;
 };
 
-#define MVPP2_CLS_FLT_ENTRIES_PER_FLOW		(MVPP2_MAX_PORTS + 1)
+#define MVPP2_CLS_FLT_ENTRIES_PER_FLOW		(MVPP2_MAX_PORTS + 1 + 16)
 #define MVPP2_CLS_FLT_FIRST(id)			(((id) - MVPP2_FL_START) * \
 						 MVPP2_CLS_FLT_ENTRIES_PER_FLOW)
-#define MVPP2_CLS_FLT_C2_RSS_ENTRY(id)		(MVPP2_CLS_FLT_FIRST(id))
-#define MVPP2_CLS_FLT_HASH_ENTRY(port, id)	(MVPP2_CLS_FLT_C2_RSS_ENTRY(id) + (port) + 1)
+
+#define MVPP2_CLS_FLT_C2_RFS(port, id, rfs_n)	(MVPP2_CLS_FLT_FIRST(id) + \
+						 ((port) * MVPP2_MAX_PORTS) + \
+						 (rfs_n))
+
+#define MVPP2_CLS_FLT_C2_RSS_ENTRY(id)		(MVPP2_CLS_FLT_C2_RFS(MVPP2_MAX_PORTS, id, 0))
+#define MVPP2_CLS_FLT_HASH_ENTRY(port, id)	(MVPP2_CLS_FLT_C2_RSS_ENTRY(id) + 1 + (port))
 #define MVPP2_CLS_FLT_LAST(id)			(MVPP2_CLS_FLT_FIRST(id) + \
 						 MVPP2_CLS_FLT_ENTRIES_PER_FLOW - 1)
 
@@ -213,6 +221,12 @@ struct mvpp2_cls_flow {
 			continue;					      \
 		else
 
+#define for_each_cls_flow_id_containing_type(i, type)			      \
+	for_each_cls_flow_id((i))					      \
+		if ((cls_flows[(i)].flow_type & (type)) != (type))	      \
+			continue;					      \
+		else
+
 struct mvpp2_cls_flow_entry {
 	u32 index;
 	u32 data[MVPP2_CLS_FLOWS_TBL_DATA_WORDS];
@@ -260,4 +274,13 @@ u32 mvpp2_cls_c2_hit_count(struct mvpp2 *priv, int c2_index);
 void mvpp2_cls_c2_read(struct mvpp2 *priv, int index,
 		       struct mvpp2_cls_c2_entry *c2);
 
+int mvpp2_ethtool_cls_rule_get(struct mvpp2_port *port,
+			       struct ethtool_rxnfc *rxnfc);
+
+int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
+			       struct ethtool_rxnfc *info);
+
+int mvpp2_ethtool_cls_rule_del(struct mvpp2_port *port,
+			       struct ethtool_rxnfc *info);
+
 #endif
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index f128ea22b339..56d43d9b43ef 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3937,7 +3937,7 @@ static int mvpp2_ethtool_get_rxnfc(struct net_device *dev,
 				   struct ethtool_rxnfc *info, u32 *rules)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
-	int ret = 0;
+	int ret = 0, i, loc = 0;
 
 	if (!mvpp22_rss_is_supported())
 		return -EOPNOTSUPP;
@@ -3949,6 +3949,18 @@ static int mvpp2_ethtool_get_rxnfc(struct net_device *dev,
 	case ETHTOOL_GRXRINGS:
 		info->data = port->nrxqs;
 		break;
+	case ETHTOOL_GRXCLSRLCNT:
+		info->rule_cnt = port->n_rfs_rules;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		ret = mvpp2_ethtool_cls_rule_get(port, info);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		for (i = 0; i < MVPP2_N_RFS_RULES; i++) {
+			if (port->rfs_rules[i])
+				rules[loc++] = i;
+		}
+		break;
 	default:
 		return -ENOTSUPP;
 	}
@@ -3969,6 +3981,12 @@ static int mvpp2_ethtool_set_rxnfc(struct net_device *dev,
 	case ETHTOOL_SRXFH:
 		ret = mvpp2_ethtool_rxfh_set(port, info);
 		break;
+	case ETHTOOL_SRXCLSRLINS:
+		ret = mvpp2_ethtool_cls_rule_ins(port, info);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		ret = mvpp2_ethtool_cls_rule_del(port, info);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

