Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE6259E743
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243336AbiHWQ3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244584AbiHWQ24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:28:56 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FBB11D50C;
        Tue, 23 Aug 2022 05:56:17 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oQSGX-000FXN-SF; Tue, 23 Aug 2022 14:40:18 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: prestera: add support for egress traffic mirroring
Date:   Tue, 23 Aug 2022 14:39:57 +0300
Message-Id: <20220823113958.2061401-3-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823113958.2061401-1-maksym.glubokiy@plvision.eu>
References: <20220823113958.2061401-1-maksym.glubokiy@plvision.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

This enables adding matchall rules for egress:

  tc filter add .. egress .. matchall skip_sw \
    action mirred egress mirror dev ..

Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_hw.c   | 30 ++++++++++++++-----
 .../ethernet/marvell/prestera/prestera_hw.h   |  5 ++--
 .../marvell/prestera/prestera_matchall.c      |  7 +++--
 .../ethernet/marvell/prestera/prestera_span.c | 10 ++++---
 .../ethernet/marvell/prestera/prestera_span.h |  6 ++--
 5 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index e0e9ae34ceea..8430db3384f9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -78,9 +78,11 @@ enum prestera_cmd_type_t {
 	PRESTERA_CMD_TYPE_STP_PORT_SET = 0x1000,
 
 	PRESTERA_CMD_TYPE_SPAN_GET = 0x1100,
-	PRESTERA_CMD_TYPE_SPAN_BIND = 0x1101,
-	PRESTERA_CMD_TYPE_SPAN_UNBIND = 0x1102,
+	PRESTERA_CMD_TYPE_SPAN_INGRESS_BIND = 0x1101,
+	PRESTERA_CMD_TYPE_SPAN_INGRESS_UNBIND = 0x1102,
 	PRESTERA_CMD_TYPE_SPAN_RELEASE = 0x1103,
+	PRESTERA_CMD_TYPE_SPAN_EGRESS_BIND = 0x1104,
+	PRESTERA_CMD_TYPE_SPAN_EGRESS_UNBIND = 0x1105,
 
 	PRESTERA_CMD_TYPE_POLICER_CREATE = 0x1500,
 	PRESTERA_CMD_TYPE_POLICER_RELEASE = 0x1501,
@@ -1432,27 +1434,39 @@ int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id)
 	return 0;
 }
 
-int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id)
+int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id,
+			  bool ingress)
 {
 	struct prestera_msg_span_req req = {
 		.port = __cpu_to_le32(port->hw_id),
 		.dev = __cpu_to_le32(port->dev_id),
 		.id = span_id,
 	};
+	enum prestera_cmd_type_t cmd_type;
+
+	if (ingress)
+		cmd_type = PRESTERA_CMD_TYPE_SPAN_INGRESS_BIND;
+	else
+		cmd_type = PRESTERA_CMD_TYPE_SPAN_EGRESS_BIND;
+
+	return prestera_cmd(port->sw, cmd_type, &req.cmd, sizeof(req));
 
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_BIND,
-			    &req.cmd, sizeof(req));
 }
 
-int prestera_hw_span_unbind(const struct prestera_port *port)
+int prestera_hw_span_unbind(const struct prestera_port *port, bool ingress)
 {
 	struct prestera_msg_span_req req = {
 		.port = __cpu_to_le32(port->hw_id),
 		.dev = __cpu_to_le32(port->dev_id),
 	};
+	enum prestera_cmd_type_t cmd_type;
 
-	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_SPAN_UNBIND,
-			    &req.cmd, sizeof(req));
+	if (ingress)
+		cmd_type = PRESTERA_CMD_TYPE_SPAN_INGRESS_UNBIND;
+	else
+		cmd_type = PRESTERA_CMD_TYPE_SPAN_EGRESS_UNBIND;
+
+	return prestera_cmd(port->sw, cmd_type, &req.cmd, sizeof(req));
 }
 
 int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 56e043146dd2..a589450e9f27 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -243,8 +243,9 @@ int prestera_hw_counter_clear(struct prestera_switch *sw, u32 block_id,
 
 /* SPAN API */
 int prestera_hw_span_get(const struct prestera_port *port, u8 *span_id);
-int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id);
-int prestera_hw_span_unbind(const struct prestera_port *port);
+int prestera_hw_span_bind(const struct prestera_port *port, u8 span_id,
+			  bool ingress);
+int prestera_hw_span_unbind(const struct prestera_port *port, bool ingress);
 int prestera_hw_span_release(struct prestera_switch *sw, u8 span_id);
 
 /* Router API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
index 54573c6a6fe2..3fc13176e046 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
@@ -43,7 +43,7 @@ int prestera_mall_replace(struct prestera_flow_block *block,
 	port = netdev_priv(act->dev);
 
 	list_for_each_entry(binding, &block->binding_list, list) {
-		err = prestera_span_rule_add(binding, port);
+		err = prestera_span_rule_add(binding, port, block->ingress);
 		if (err)
 			goto rollback;
 	}
@@ -53,7 +53,7 @@ int prestera_mall_replace(struct prestera_flow_block *block,
 rollback:
 	list_for_each_entry_continue_reverse(binding,
 					     &block->binding_list, list)
-		prestera_span_rule_del(binding);
+		prestera_span_rule_del(binding, block->ingress);
 	return err;
 }
 
@@ -62,5 +62,6 @@ void prestera_mall_destroy(struct prestera_flow_block *block)
 	struct prestera_flow_block_binding *binding;
 
 	list_for_each_entry(binding, &block->binding_list, list)
-		prestera_span_rule_del(binding);
+		prestera_span_rule_del(binding, block->ingress);
+
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
index 766413b9ba1b..f0e9d6ea88c5 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_span.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
@@ -121,7 +121,8 @@ static int prestera_span_put(struct prestera_switch *sw, u8 span_id)
 }
 
 int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
-			   struct prestera_port *to_port)
+			   struct prestera_port *to_port,
+			   bool ingress)
 {
 	struct prestera_switch *sw = binding->port->sw;
 	u8 span_id;
@@ -135,7 +136,7 @@ int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
 	if (err)
 		return err;
 
-	err = prestera_hw_span_bind(binding->port, span_id);
+	err = prestera_hw_span_bind(binding->port, span_id, ingress);
 	if (err) {
 		prestera_span_put(sw, span_id);
 		return err;
@@ -145,11 +146,12 @@ int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
 	return 0;
 }
 
-int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
+int prestera_span_rule_del(struct prestera_flow_block_binding *binding,
+			   bool ingress)
 {
 	int err;
 
-	err = prestera_hw_span_unbind(binding->port);
+	err = prestera_hw_span_unbind(binding->port, ingress);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.h b/drivers/net/ethernet/marvell/prestera/prestera_span.h
index 4958ce820b52..493b68524bcb 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_span.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.h
@@ -16,7 +16,9 @@ int prestera_span_init(struct prestera_switch *sw);
 void prestera_span_fini(struct prestera_switch *sw);
 
 int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
-			   struct prestera_port *to_port);
-int prestera_span_rule_del(struct prestera_flow_block_binding *binding);
+			   struct prestera_port *to_port,
+			   bool ingress);
+int prestera_span_rule_del(struct prestera_flow_block_binding *binding,
+			   bool ingress);
 
 #endif /* _PRESTERA_SPAN_H_ */
-- 
2.25.1

