Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D61F9AD
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 15:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfD3NOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 09:14:51 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:51561 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfD3NOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 09:14:49 -0400
X-Originating-IP: 90.88.149.145
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-29-145.w90-88.abo.wanadoo.fr [90.88.149.145])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 94D311BF209;
        Tue, 30 Apr 2019 13:14:45 +0000 (UTC)
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
Subject: [PATCH net-next 4/4] net: mvpp2: cls: Allow dropping packets with classification offload
Date:   Tue, 30 Apr 2019 15:14:29 +0200
Message-Id: <20190430131429.19361-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
References: <20190430131429.19361-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces support for the "Drop" action in classification
offload. This corresponds to the "-1" action with ethtool -N.

This is achieved using the color marking actions available in the C2
engine, which associate a color to a packet. These colors can be either
Green, Yellow or Red, Red meaning that the packet should be dropped.

Green and Yellow colors are interpreted by the Policer, which isn't
supported yet.

This method of dropping using the Classifier is different than the
already existing early-drop features, such as VLAN filtering and MAC
UC/MC filtering, which are performed during the Parsing step, and
therefore take precedence over classification actions.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 29 +++++++++++++------
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    | 11 +++++++
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 9d2222ab60ae..6171270a016c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -136,6 +136,7 @@
 #define     MVPP22_CLS_C2_ACT_FWD(act)		(((act) & 0x7) << 13)
 #define     MVPP22_CLS_C2_ACT_QHIGH(act)	(((act) & 0x3) << 11)
 #define     MVPP22_CLS_C2_ACT_QLOW(act)		(((act) & 0x3) << 9)
+#define     MVPP22_CLS_C2_ACT_COLOR(act)	((act) & 0x7)
 #define MVPP22_CLS_C2_ATTR0			0x1b64
 #define     MVPP22_CLS_C2_ATTR0_QHIGH(qh)	(((qh) & 0x1f) << 24)
 #define     MVPP22_CLS_C2_ATTR0_QHIGH_MASK	0x1f
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index f4dd59c00d80..4989fb13244f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1057,17 +1057,28 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 	c2.tcam[4] |= MVPP22_CLS_C2_TCAM_EN(MVPP22_CLS_C2_LU_TYPE(MVPP2_CLS_LU_TYPE_MASK));
 	c2.tcam[4] |= MVPP22_CLS_C2_LU_TYPE(rule->loc);
 
-	/* Mark packet as "forwarded to software", needed for RSS */
-	c2.act |= MVPP22_CLS_C2_ACT_FWD(MVPP22_C2_FWD_SW_LOCK);
+	if (act->id == FLOW_ACTION_DROP) {
+		c2.act = MVPP22_CLS_C2_ACT_COLOR(MVPP22_C2_COL_RED_LOCK);
+	} else {
+		/* We want to keep the default color derived from the Header
+		 * Parser drop entries, for VLAN and MAC filtering. This will
+		 * assign a default color of Green or Red, and we want matches
+		 * with a non-drop action to keep that color.
+		 */
+		c2.act = MVPP22_CLS_C2_ACT_COLOR(MVPP22_C2_COL_NO_UPD_LOCK);
 
-	c2.act |= MVPP22_CLS_C2_ACT_QHIGH(MVPP22_C2_UPD_LOCK) |
-		   MVPP22_CLS_C2_ACT_QLOW(MVPP22_C2_UPD_LOCK);
+		/* Mark packet as "forwarded to software", needed for RSS */
+		c2.act |= MVPP22_CLS_C2_ACT_FWD(MVPP22_C2_FWD_SW_LOCK);
 
-	qh = ((act->queue.index + port->first_rxq) >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
-	ql = (act->queue.index + port->first_rxq) & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+		c2.act |= MVPP22_CLS_C2_ACT_QHIGH(MVPP22_C2_UPD_LOCK) |
+			   MVPP22_CLS_C2_ACT_QLOW(MVPP22_C2_UPD_LOCK);
 
-	c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
-		      MVPP22_CLS_C2_ATTR0_QLOW(ql);
+		qh = ((act->queue.index + port->first_rxq) >> 3) & MVPP22_CLS_C2_ATTR0_QHIGH_MASK;
+		ql = (act->queue.index + port->first_rxq) & MVPP22_CLS_C2_ATTR0_QLOW_MASK;
+
+		c2.attr[0] = MVPP22_CLS_C2_ATTR0_QHIGH(qh) |
+			      MVPP22_CLS_C2_ATTR0_QLOW(ql);
+	}
 
 	c2.valid = true;
 
@@ -1183,7 +1194,7 @@ static int mvpp2_cls_rfs_parse_rule(struct mvpp2_rfs_rule *rule)
 	struct flow_action_entry *act;
 
 	act = &flow->action.entries[0];
-	if (act->id != FLOW_ACTION_QUEUE)
+	if (act->id != FLOW_ACTION_QUEUE && act->id != FLOW_ACTION_DROP)
 		return -EOPNOTSUPP;
 
 	/* For now, only use the C2 engine which has a HEK size limited to 64
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 431563a13524..56b617375a65 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -92,6 +92,17 @@ enum mvpp22_cls_c2_fwd_action {
 	MVPP22_C2_FWD_HW_LOW_LAT_LOCK,
 };
 
+enum mvpp22_cls_c2_color_action {
+	MVPP22_C2_COL_NO_UPD = 0,
+	MVPP22_C2_COL_NO_UPD_LOCK,
+	MVPP22_C2_COL_GREEN,
+	MVPP22_C2_COL_GREEN_LOCK,
+	MVPP22_C2_COL_YELLOW,
+	MVPP22_C2_COL_YELLOW_LOCK,
+	MVPP22_C2_COL_RED,		/* Drop */
+	MVPP22_C2_COL_RED_LOCK,		/* Drop */
+};
+
 #define MVPP2_CLS_C2_TCAM_WORDS			5
 #define MVPP2_CLS_C2_ATTR_WORDS			5
 
-- 
2.20.1

