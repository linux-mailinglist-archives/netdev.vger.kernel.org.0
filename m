Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5238B4A48E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfFROzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:55:41 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:38461 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729665AbfFROzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:55:38 -0400
X-Originating-IP: 90.88.23.150
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id EBAFA4000F;
        Tue, 18 Jun 2019 14:55:33 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 4/4] net: mvpp2: cls: Add steering based on vlan Id and priority.
Date:   Tue, 18 Jun 2019 16:55:19 +0200
Message-Id: <20190618145519.27705-5-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
References: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows using the vlan Id and priority as parts of the key
for classification offload. These fields are extracted from the
outermost tag, if multiple tags are present.

Vlan Id and priority are considered as 2 different fields by the
classifier, however the fields are both appended in the Header Extracted
Key in the same layout as they are found in the tags. This means that
when steering only based on the prio, a 16-bit slot is still taken in
the HEK.

The classifier doesn't allow extracting the DEI bit from the tag, so we
explicitly prevent user from using this bit in the key.

This commit adds the vlan priotity as a compatible HEK field for
tagged traffic, meaning that we limit the possibility of extracting this
field only to the flows that contain tagged traffic.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    | 97 ++++++++++++++-----
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.h    | 23 +++--
 2 files changed, 86 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index c4c467f5f4f6..b195fb5d61f4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -44,17 +44,17 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv4 flows, Not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -79,17 +79,17 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP4, MVPP2_FL_IP4_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -114,17 +114,17 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv4 flows, Not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -149,17 +149,17 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv4 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OPT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP4, MVPP2_FL_IP4_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OTHER | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -178,12 +178,12 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv6 flows, not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -202,13 +202,13 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* TCP over IPv6 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_TCP6, MVPP2_FL_IP6_TCP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_TCP,
 		       MVPP2_PRS_IP_MASK),
@@ -228,12 +228,12 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv6 flows, not fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_NF_TAG,
-		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_5T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
@@ -252,13 +252,13 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* UDP over IPv6 flows, fragmented, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6 | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
 
 	MVPP2_DEF_FLOW(MVPP22_FLOW_UDP6, MVPP2_FL_IP6_UDP_FRAG_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6_EXT | MVPP2_PRS_RI_IP_FRAG_TRUE |
 		       MVPP2_PRS_RI_L4_UDP,
 		       MVPP2_PRS_IP_MASK),
@@ -279,15 +279,15 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* IPv4 flows, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OPT,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP4, MVPP2_FL_IP4_TAG,
-		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP4_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP4_OTHER,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 
@@ -303,11 +303,11 @@ static const struct mvpp2_cls_flow cls_flows[MVPP2_N_PRS_FLOWS] = {
 
 	/* IPv6 flows, with vlan tag */
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 	MVPP2_DEF_FLOW(MVPP22_FLOW_IP6, MVPP2_FL_IP6_TAG,
-		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_OPT_VLAN,
+		       MVPP22_CLS_HEK_IP6_2T | MVPP22_CLS_HEK_TAGGED,
 		       MVPP2_PRS_RI_L3_IP6,
 		       MVPP2_PRS_RI_L3_PROTO_MASK),
 
@@ -655,6 +655,9 @@ static int mvpp2_flow_set_hek_fields(struct mvpp2_cls_flow_entry *fe,
 		case MVPP22_CLS_HEK_OPT_VLAN:
 			field_id = MVPP22_CLS_FIELD_VLAN;
 			break;
+		case MVPP22_CLS_HEK_OPT_VLAN_PRI:
+			field_id = MVPP22_CLS_FIELD_VLAN_PRI;
+			break;
 		case MVPP22_CLS_HEK_OPT_IP4SA:
 			field_id = MVPP22_CLS_FIELD_IP4SA;
 			break;
@@ -689,6 +692,10 @@ static int mvpp2_cls_hek_field_size(u32 field)
 	switch (field) {
 	case MVPP22_CLS_HEK_OPT_MAC_DA:
 		return 48;
+	case MVPP22_CLS_HEK_OPT_VLAN:
+		return 12;
+	case MVPP22_CLS_HEK_OPT_VLAN_PRI:
+		return 3;
 	case MVPP22_CLS_HEK_OPT_IP4SA:
 	case MVPP22_CLS_HEK_OPT_IP4DA:
 		return 32;
@@ -777,6 +784,9 @@ u16 mvpp2_flow_get_hek_fields(struct mvpp2_cls_flow_entry *fe)
 		case MVPP22_CLS_FIELD_VLAN:
 			hash_opts |= MVPP22_CLS_HEK_OPT_VLAN;
 			break;
+		case MVPP22_CLS_FIELD_VLAN_PRI:
+			hash_opts |= MVPP22_CLS_HEK_OPT_VLAN_PRI;
+			break;
 		case MVPP22_CLS_FIELD_L3_PROTO:
 			hash_opts |= MVPP22_CLS_HEK_OPT_L3_PROTO;
 			break;
@@ -1224,6 +1234,43 @@ static int mvpp2_cls_c2_build_match(struct mvpp2_rfs_rule *rule)
 	struct flow_rule *flow = rule->flow;
 	int offs = 0;
 
+	/* The order of insertion in C2 tcam must match the order in which
+	 * the fields are found in the header
+	 */
+	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_VLAN)) {
+		struct flow_match_vlan match;
+
+		flow_rule_match_vlan(flow, &match);
+		if (match.mask->vlan_id) {
+			rule->hek_fields |= MVPP22_CLS_HEK_OPT_VLAN;
+
+			rule->c2_tcam |= ((u64)match.key->vlan_id) << offs;
+			rule->c2_tcam_mask |= ((u64)match.mask->vlan_id) << offs;
+
+			/* Don't update the offset yet */
+		}
+
+		if (match.mask->vlan_priority) {
+			rule->hek_fields |= MVPP22_CLS_HEK_OPT_VLAN_PRI;
+
+			/* VLAN pri is always at offset 13 relative to the
+			 * current offset
+			 */
+			rule->c2_tcam |= ((u64)match.key->vlan_priority) <<
+				(offs + 13);
+			rule->c2_tcam_mask |= ((u64)match.mask->vlan_priority) <<
+				(offs + 13);
+		}
+
+		if (match.mask->vlan_dei)
+			return -EOPNOTSUPP;
+
+		/* vlan id and prio always seem to take a full 16-bit slot in
+		 * the Header Extracted Key.
+		 */
+		offs += 16;
+	}
+
 	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
index 957f80b31743..8867f25afab4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.h
@@ -33,15 +33,16 @@ enum mvpp2_cls_engine {
 };
 
 #define MVPP22_CLS_HEK_OPT_MAC_DA	BIT(0)
-#define MVPP22_CLS_HEK_OPT_VLAN		BIT(1)
-#define MVPP22_CLS_HEK_OPT_L3_PROTO	BIT(2)
-#define MVPP22_CLS_HEK_OPT_IP4SA	BIT(3)
-#define MVPP22_CLS_HEK_OPT_IP4DA	BIT(4)
-#define MVPP22_CLS_HEK_OPT_IP6SA	BIT(5)
-#define MVPP22_CLS_HEK_OPT_IP6DA	BIT(6)
-#define MVPP22_CLS_HEK_OPT_L4SIP	BIT(7)
-#define MVPP22_CLS_HEK_OPT_L4DIP	BIT(8)
-#define MVPP22_CLS_HEK_N_FIELDS		9
+#define MVPP22_CLS_HEK_OPT_VLAN_PRI	BIT(1)
+#define MVPP22_CLS_HEK_OPT_VLAN		BIT(2)
+#define MVPP22_CLS_HEK_OPT_L3_PROTO	BIT(3)
+#define MVPP22_CLS_HEK_OPT_IP4SA	BIT(4)
+#define MVPP22_CLS_HEK_OPT_IP4DA	BIT(5)
+#define MVPP22_CLS_HEK_OPT_IP6SA	BIT(6)
+#define MVPP22_CLS_HEK_OPT_IP6DA	BIT(7)
+#define MVPP22_CLS_HEK_OPT_L4SIP	BIT(8)
+#define MVPP22_CLS_HEK_OPT_L4DIP	BIT(9)
+#define MVPP22_CLS_HEK_N_FIELDS		10
 
 #define MVPP22_CLS_HEK_L4_OPTS	(MVPP22_CLS_HEK_OPT_L4SIP | \
 				 MVPP22_CLS_HEK_OPT_L4DIP)
@@ -59,8 +60,12 @@ enum mvpp2_cls_engine {
 #define MVPP22_CLS_HEK_IP6_5T	(MVPP22_CLS_HEK_IP6_2T | \
 				 MVPP22_CLS_HEK_L4_OPTS)
 
+#define MVPP22_CLS_HEK_TAGGED	(MVPP22_CLS_HEK_OPT_VLAN | \
+				 MVPP22_CLS_HEK_OPT_VLAN_PRI)
+
 enum mvpp2_cls_field_id {
 	MVPP22_CLS_FIELD_MAC_DA = 0x03,
+	MVPP22_CLS_FIELD_VLAN_PRI = 0x05,
 	MVPP22_CLS_FIELD_VLAN = 0x06,
 	MVPP22_CLS_FIELD_L3_PROTO = 0x0f,
 	MVPP22_CLS_FIELD_IP4SA = 0x10,
-- 
2.20.1

