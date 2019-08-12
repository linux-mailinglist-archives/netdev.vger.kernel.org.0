Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFE289BCF
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfHLKpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:45:51 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36710 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbfHLKpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 06:45:50 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 25BCC200215;
        Mon, 12 Aug 2019 12:45:48 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3C6A4200084;
        Mon, 12 Aug 2019 12:45:45 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 02389402F0;
        Mon, 12 Aug 2019 18:45:41 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     Yangbo Lu <yangbo.lu@nxp.com>
Subject: [PATCH 1/3] ocelot_ace: drop member port from ocelot_ace_rule structure
Date:   Mon, 12 Aug 2019 18:48:25 +0800
Message-Id: <20190812104827.5935-2-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190812104827.5935-1-yangbo.lu@nxp.com>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_ace_rule is not port specific. We don't need a member port
in ocelot_ace_rule structure. Drop it and use member ocelot instead.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 12 ++++++------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |  6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 39aca1a..5580a58 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -576,7 +576,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 
 static void is2_entry_get(struct ocelot_ace_rule *rule, int ix)
 {
-	struct ocelot *op = rule->port->ocelot;
+	struct ocelot *op = rule->ocelot;
 	struct vcap_data data;
 	int row = (ix / 2);
 	u32 cnt;
@@ -655,11 +655,11 @@ int ocelot_ace_rule_offload_add(struct ocelot_ace_rule *rule)
 	/* Move down the rules to make place for the new rule */
 	for (i = acl_block->count - 1; i > index; i--) {
 		ace = ocelot_ace_rule_get_rule_index(acl_block, i);
-		is2_entry_set(rule->port->ocelot, i, ace);
+		is2_entry_set(rule->ocelot, i, ace);
 	}
 
 	/* Now insert the new rule */
-	is2_entry_set(rule->port->ocelot, index, rule);
+	is2_entry_set(rule->ocelot, index, rule);
 	return 0;
 }
 
@@ -697,11 +697,11 @@ int ocelot_ace_rule_offload_del(struct ocelot_ace_rule *rule)
 	/* Move up all the blocks over the deleted rule */
 	for (i = index; i < acl_block->count; i++) {
 		ace = ocelot_ace_rule_get_rule_index(acl_block, i);
-		is2_entry_set(rule->port->ocelot, i, ace);
+		is2_entry_set(rule->ocelot, i, ace);
 	}
 
 	/* Now delete the last rule, because it is duplicated */
-	is2_entry_set(rule->port->ocelot, acl_block->count, &del_ace);
+	is2_entry_set(rule->ocelot, acl_block->count, &del_ace);
 
 	return 0;
 }
@@ -717,7 +717,7 @@ int ocelot_ace_rule_stats_update(struct ocelot_ace_rule *rule)
 	/* After we get the result we need to clear the counters */
 	tmp = ocelot_ace_rule_get_rule_index(acl_block, index);
 	tmp->stats.pkts = 0;
-	is2_entry_set(rule->port->ocelot, index, tmp);
+	is2_entry_set(rule->ocelot, index, tmp);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index e98944c..ce72f02 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -186,7 +186,7 @@ struct ocelot_ace_stats {
 
 struct ocelot_ace_rule {
 	struct list_head list;
-	struct ocelot_port *port;
+	struct ocelot *ocelot;
 
 	u16 prio;
 	u32 id;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 59487d4..7c60e8c 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -183,7 +183,7 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct flow_cls_offload *f,
 	if (!rule)
 		return NULL;
 
-	rule->port = block->port;
+	rule->ocelot = block->port->ocelot;
 	rule->chip_port = block->port->chip_port;
 	return rule;
 }
@@ -219,7 +219,7 @@ static int ocelot_flower_destroy(struct flow_cls_offload *f,
 	int ret;
 
 	rule.prio = get_prio(f->common.prio);
-	rule.port = port_block->port;
+	rule.ocelot = port_block->port->ocelot;
 	rule.id = f->cookie;
 
 	ret = ocelot_ace_rule_offload_del(&rule);
@@ -237,7 +237,7 @@ static int ocelot_flower_stats_update(struct flow_cls_offload *f,
 	int ret;
 
 	rule.prio = get_prio(f->common.prio);
-	rule.port = port_block->port;
+	rule.ocelot = port_block->port->ocelot;
 	rule.id = f->cookie;
 	ret = ocelot_ace_rule_stats_update(&rule);
 	if (ret)
-- 
2.7.4

