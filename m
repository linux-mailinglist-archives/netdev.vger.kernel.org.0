Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47BB29566
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390531AbfEXKGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:06:19 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:32943 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390503AbfEXKGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:06:17 -0400
X-Originating-IP: 90.88.147.134
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-27-134.w90-88.abo.wanadoo.fr [90.88.147.134])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 3427540018;
        Fri, 24 May 2019 10:06:13 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 5/5] net: mvpp2: cls: Support steering to RSS contexts
Date:   Fri, 24 May 2019 12:05:54 +0200
Message-Id: <20190524100554.8606-6-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When steering to an RXQ, we can perform an extra RSS step to assign a
queue from an RSS table.

This is done by setting the RSS_EN attribute in the C2 engine. In that
case, the RXQ that is assigned is the global RSS context id, that is
then translated to an RSS table using the RXQ2RSS table.

An example using ethtool to steer to RXQ 2 and 3 would be :

ethtool -X eth0 weight 0 0 1 1 context new

(This would print the allocated context id, let's say it's 1)

ethtool -N eth0 flow-type udp4 dst-port 1234 context 1 loc 0

The hash parameters are the ones that are globally configured for RSS :

ethtool -N eth0 rx-flow-hash udp4 sdfn

When an RSS context is removed while there are active classification
rules using this context, these rules are removed.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 58 +++++++++++++++++--
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index c1a83e9cb80a..cd0daad011ce 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1068,7 +1068,7 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 	struct flow_action_entry *act;
 	struct mvpp2_cls_c2_entry c2;
 	u8 qh, ql, pmap;
-	int index;
+	int index, ctx;
 
 	memset(&c2, 0, sizeof(c2));
 
@@ -1108,14 +1108,36 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 		 */
 		c2.act = MVPP22_CLS_C2_ACT_COLOR(MVPP22_C2_COL_NO_UPD_LOCK);
 
+		/* Update RSS status after matching this entry */
+		if (act->queue.ctx)
+			c2.attr[2] |= MVPP22_CLS_C2_ATTR2_RSS_EN;
+
+		/* Always lock the RSS_EN decision. We might have high prio
+		 * rules steering to an RXQ, and a lower one steering to RSS,
+		 * we don't want the low prio RSS rule overwriting this flag.
+		 */
+		c2.act = MVPP22_CLS_C2_ACT_RSS_EN(MVPP22_C2_UPD_LOCK);
+
 		/* Mark packet as "forwarded to software", needed for RSS */
 		c2.act |= MVPP22_CLS_C2_ACT_FWD(MVPP22_C2_FWD_SW_LOCK);
 
 		c2.act |= MVPP22_CLS_C2_ACT_QHIGH(MVPP22_C2_UPD_LOCK) |
 			   MVPP22_CLS_C2_ACT_QLOW(MVPP22_C2_UPD_LOCK);
 
-		qh = ((act->queue.index + port->first_rxq) >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
-		ql = (act->queue.index + port->first_rxq) & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+		if (act->queue.ctx) {
+			/* Get the global ctx number */
+			ctx = mvpp22_rss_ctx(port, act->queue.ctx);
+			if (ctx < 0)
+				return -EINVAL;
+
+			qh = (ctx >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
+			ql = ctx & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+		} else {
+			qh = ((act->queue.index + port->first_rxq) >> 3) &
+			      MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
+			ql = (act->queue.index + port->first_rxq) &
+			      MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+		}
 
 		c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
 			      MVPP22_CLS_C2_ATTR0_QLOW(ql);
@@ -1235,6 +1257,13 @@ static int mvpp2_cls_rfs_parse_rule(struct mvpp2_rfs_rule *rule)
 	if (act->id != FLOW_ACTION_QUEUE && act->id != FLOW_ACTION_DROP)
 		return -EOPNOTSUPP;
 
+	/* When both an RSS context and an queue index are set, the index
+	 * is considered as an offset to be added to the indirection table
+	 * entries. We don't support this, so reject this rule.
+	 */
+	if (act->queue.ctx && act->queue.index)
+		return -EOPNOTSUPP;
+
 	/* For now, only use the C2 engine which has a HEK size limited to 64
 	 * bits for TCAM matching.
 	 */
@@ -1455,11 +1484,32 @@ static struct mvpp2_rss_table *mvpp22_rss_table_get(struct mvpp2 *priv,
 int mvpp22_port_rss_ctx_delete(struct mvpp2_port *port, u32 port_ctx)
 {
 	struct mvpp2 *priv = port->priv;
-	int rss_ctx = mvpp22_rss_ctx(port, port_ctx);
+	struct ethtool_rxnfc *rxnfc;
+	int i, rss_ctx, ret;
+
+	rss_ctx = mvpp22_rss_ctx(port, port_ctx);
 
 	if (rss_ctx < 0 || rss_ctx >= MVPP22_N_RSS_TABLES)
 		return -EINVAL;
 
+	/* Invalidate any active classification rule that use this context */
+	for (i = 0; i < MVPP2_N_RFS_ENTRIES_PER_FLOW; i++) {
+		if (!port->rfs_rules[i])
+			continue;
+
+		rxnfc = &port->rfs_rules[i]->rxnfc;
+		if (!(rxnfc->fs.flow_type & FLOW_RSS) ||
+		    rxnfc->rss_context != port_ctx)
+			continue;
+
+		ret = mvpp2_ethtool_cls_rule_del(port, rxnfc);
+		if (ret) {
+			netdev_warn(port->dev,
+				    "couldn't remove classification rule %d associated to this context",
+				    rxnfc->fs.location);
+		}
+	}
+
 	kfree(priv->rss_tables[rss_ctx]);
 
 	priv->rss_tables[rss_ctx] = NULL;
-- 
2.20.1

