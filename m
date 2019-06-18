Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474214A491
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfFROzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:55:37 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57713 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbfFROzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:55:36 -0400
X-Originating-IP: 90.88.23.150
Received: from mc-bl-xps13.lan (aaubervilliers-681-1-81-150.w90-88.abo.wanadoo.fr [90.88.23.150])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 5D05340008;
        Tue, 18 Jun 2019 14:55:31 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 3/4] net: mvpp2: cls: right-justify the C2 TCAM keys
Date:   Tue, 18 Jun 2019 16:55:18 +0200
Message-Id: <20190618145519.27705-4-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
References: <20190618145519.27705-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The C2 TCAM used for classification uses a key (Header Extracted Key)
built by concatenating several fields extracted from the packet header.

After a lot of trial-and-error and some guess work, it seems the HEK is
right justified, with the first fields being stored in the MSB, then
concatenated up until the LSB.

Until now, this doesn't cause any issue since all HEK fields we use are
full bytes. However this is an issue for the upcoming VLAN id and pri
extraction, which aren't full bytes.

Rework the way we built that TCAM key, by changing the order in which we
append the fields.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 7cd9d6da0319..c4c467f5f4f6 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1081,13 +1081,13 @@ static int mvpp2_port_c2_tcam_rule_add(struct mvpp2_port *port,
 
 	rule->c2_index = c2.index;
 
-	c2.tcam[0] = (rule->c2_tcam & 0xffff) |
+	c2.tcam[3] = (rule->c2_tcam & 0xffff) |
 		     ((rule->c2_tcam_mask & 0xffff) << 16);
-	c2.tcam[1] = ((rule->c2_tcam >> 16) & 0xffff) |
+	c2.tcam[2] = ((rule->c2_tcam >> 16) & 0xffff) |
 		     (((rule->c2_tcam_mask >> 16) & 0xffff) << 16);
-	c2.tcam[2] = ((rule->c2_tcam >> 32) & 0xffff) |
+	c2.tcam[1] = ((rule->c2_tcam >> 32) & 0xffff) |
 		     (((rule->c2_tcam_mask >> 32) & 0xffff) << 16);
-	c2.tcam[3] = ((rule->c2_tcam >> 48) & 0xffff) |
+	c2.tcam[0] = ((rule->c2_tcam >> 48) & 0xffff) |
 		     (((rule->c2_tcam_mask >> 48) & 0xffff) << 16);
 
 	pmap = BIT(port->id);
@@ -1222,7 +1222,7 @@ static int mvpp2_port_flt_rfs_rule_insert(struct mvpp2_port *port,
 static int mvpp2_cls_c2_build_match(struct mvpp2_rfs_rule *rule)
 {
 	struct flow_rule *flow = rule->flow;
-	int offs = 64;
+	int offs = 0;
 
 	if (flow_rule_match_key(flow, FLOW_DISSECTOR_KEY_PORTS)) {
 		struct flow_match_ports match;
@@ -1230,18 +1230,18 @@ static int mvpp2_cls_c2_build_match(struct mvpp2_rfs_rule *rule)
 		flow_rule_match_ports(flow, &match);
 		if (match.mask->src) {
 			rule->hek_fields |= MVPP22_CLS_HEK_OPT_L4SIP;
-			offs -= mvpp2_cls_hek_field_size(MVPP22_CLS_HEK_OPT_L4SIP);
 
 			rule->c2_tcam |= ((u64)ntohs(match.key->src)) << offs;
 			rule->c2_tcam_mask |= ((u64)ntohs(match.mask->src)) << offs;
+			offs += mvpp2_cls_hek_field_size(MVPP22_CLS_HEK_OPT_L4SIP);
 		}
 
 		if (match.mask->dst) {
 			rule->hek_fields |= MVPP22_CLS_HEK_OPT_L4DIP;
-			offs -= mvpp2_cls_hek_field_size(MVPP22_CLS_HEK_OPT_L4DIP);
 
 			rule->c2_tcam |= ((u64)ntohs(match.key->dst)) << offs;
 			rule->c2_tcam_mask |= ((u64)ntohs(match.mask->dst)) << offs;
+			offs += mvpp2_cls_hek_field_size(MVPP22_CLS_HEK_OPT_L4DIP);
 		}
 	}
 
-- 
2.20.1

