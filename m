Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EED59E742
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbiHWQ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244223AbiHWQ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:28:38 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A5F11C962;
        Tue, 23 Aug 2022 05:56:11 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oQSGV-000FXN-Gm; Tue, 23 Aug 2022 14:40:15 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: prestera: acl: extract matchall logic into a separate file
Date:   Tue, 23 Aug 2022 14:39:56 +0300
Message-Id: <20220823113958.2061401-2-maksym.glubokiy@plvision.eu>
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

This commit adds more clarity to handling of TC_CLSMATCHALL_REPLACE and
TC_CLSMATCHALL_DESTROY events by calling newly added *_mall_*() handlers
instead of directly calling SPAN API.

This also extracts matchall rules management out of SPAN API since SPAN
is a hardware module which is used to implement 'matchall egress mirred'
action only.

Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 .../net/ethernet/marvell/prestera/Makefile    |  2 +-
 .../ethernet/marvell/prestera/prestera_flow.c |  9 +--
 .../marvell/prestera/prestera_matchall.c      | 66 +++++++++++++++++++
 .../marvell/prestera/prestera_matchall.h      | 15 +++++
 .../ethernet/marvell/prestera/prestera_span.c | 60 +----------------
 .../ethernet/marvell/prestera/prestera_span.h | 10 +--
 6 files changed, 96 insertions(+), 66 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_matchall.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_matchall.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index d395f4131648..df14cee80153 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -4,6 +4,6 @@ prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
 			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
 			   prestera_flower.o prestera_span.o prestera_counter.o \
-			   prestera_router.o prestera_router_hw.o
+			   prestera_router.o prestera_router_hw.o prestera_matchall.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index 2262693bd5cf..3f81eef167fa 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -7,8 +7,9 @@
 #include "prestera.h"
 #include "prestera_acl.h"
 #include "prestera_flow.h"
-#include "prestera_span.h"
 #include "prestera_flower.h"
+#include "prestera_matchall.h"
+#include "prestera_span.h"
 
 static LIST_HEAD(prestera_block_cb_list);
 
@@ -17,9 +18,9 @@ static int prestera_flow_block_mall_cb(struct prestera_flow_block *block,
 {
 	switch (f->command) {
 	case TC_CLSMATCHALL_REPLACE:
-		return prestera_span_replace(block, f);
+		return prestera_mall_replace(block, f);
 	case TC_CLSMATCHALL_DESTROY:
-		prestera_span_destroy(block);
+		prestera_mall_destroy(block);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -263,7 +264,7 @@ static void prestera_setup_flow_block_unbind(struct prestera_port *port,
 
 	block = flow_block_cb_priv(block_cb);
 
-	prestera_span_destroy(block);
+	prestera_mall_destroy(block);
 
 	err = prestera_flow_block_unbind(block, port);
 	if (err)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
new file mode 100644
index 000000000000..54573c6a6fe2
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2022 Marvell International Ltd. All rights reserved */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_flow.h"
+#include "prestera_flower.h"
+#include "prestera_matchall.h"
+#include "prestera_span.h"
+
+int prestera_mall_replace(struct prestera_flow_block *block,
+			  struct tc_cls_matchall_offload *f)
+{
+	struct prestera_flow_block_binding *binding;
+	__be16 protocol = f->common.protocol;
+	struct flow_action_entry *act;
+	struct prestera_port *port;
+	int err;
+
+	if (!flow_offload_has_one_action(&f->rule->action)) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Only singular actions are supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &f->rule->action.entries[0];
+
+	if (!prestera_netdev_check(act->dev)) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Only Marvell Prestera port is supported");
+		return -EINVAL;
+	}
+	if (!tc_cls_can_offload_and_chain0(act->dev, &f->common))
+		return -EOPNOTSUPP;
+	if (act->id != FLOW_ACTION_MIRRED)
+		return -EOPNOTSUPP;
+	if (protocol != htons(ETH_P_ALL))
+		return -EOPNOTSUPP;
+
+	port = netdev_priv(act->dev);
+
+	list_for_each_entry(binding, &block->binding_list, list) {
+		err = prestera_span_rule_add(binding, port);
+		if (err)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(binding,
+					     &block->binding_list, list)
+		prestera_span_rule_del(binding);
+	return err;
+}
+
+void prestera_mall_destroy(struct prestera_flow_block *block)
+{
+	struct prestera_flow_block_binding *binding;
+
+	list_for_each_entry(binding, &block->binding_list, list)
+		prestera_span_rule_del(binding);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_matchall.h b/drivers/net/ethernet/marvell/prestera/prestera_matchall.h
new file mode 100644
index 000000000000..31ad4d02ecbb
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_matchall.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2022 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_MATCHALL_H_
+#define _PRESTERA_MATCHALL_H_
+
+#include <net/pkt_cls.h>
+
+struct prestera_flow_block;
+
+int prestera_mall_replace(struct prestera_flow_block *block,
+			  struct tc_cls_matchall_offload *f);
+void prestera_mall_destroy(struct prestera_flow_block *block);
+
+#endif /* _PRESTERA_MATCHALL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
index 845e9d8c8cc7..766413b9ba1b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_span.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
@@ -120,8 +120,8 @@ static int prestera_span_put(struct prestera_switch *sw, u8 span_id)
 	return 0;
 }
 
-static int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
-				  struct prestera_port *to_port)
+int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
+			   struct prestera_port *to_port)
 {
 	struct prestera_switch *sw = binding->port->sw;
 	u8 span_id;
@@ -145,7 +145,7 @@ static int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
 	return 0;
 }
 
-static int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
+int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
 {
 	int err;
 
@@ -161,60 +161,6 @@ static int prestera_span_rule_del(struct prestera_flow_block_binding *binding)
 	return 0;
 }
 
-int prestera_span_replace(struct prestera_flow_block *block,
-			  struct tc_cls_matchall_offload *f)
-{
-	struct prestera_flow_block_binding *binding;
-	__be16 protocol = f->common.protocol;
-	struct flow_action_entry *act;
-	struct prestera_port *port;
-	int err;
-
-	if (!flow_offload_has_one_action(&f->rule->action)) {
-		NL_SET_ERR_MSG(f->common.extack,
-			       "Only singular actions are supported");
-		return -EOPNOTSUPP;
-	}
-
-	act = &f->rule->action.entries[0];
-
-	if (!prestera_netdev_check(act->dev)) {
-		NL_SET_ERR_MSG(f->common.extack,
-			       "Only Marvell Prestera port is supported");
-		return -EINVAL;
-	}
-	if (!tc_cls_can_offload_and_chain0(act->dev, &f->common))
-		return -EOPNOTSUPP;
-	if (act->id != FLOW_ACTION_MIRRED)
-		return -EOPNOTSUPP;
-	if (protocol != htons(ETH_P_ALL))
-		return -EOPNOTSUPP;
-
-	port = netdev_priv(act->dev);
-
-	list_for_each_entry(binding, &block->binding_list, list) {
-		err = prestera_span_rule_add(binding, port);
-		if (err)
-			goto rollback;
-	}
-
-	return 0;
-
-rollback:
-	list_for_each_entry_continue_reverse(binding,
-					     &block->binding_list, list)
-		prestera_span_rule_del(binding);
-	return err;
-}
-
-void prestera_span_destroy(struct prestera_flow_block *block)
-{
-	struct prestera_flow_block_binding *binding;
-
-	list_for_each_entry(binding, &block->binding_list, list)
-		prestera_span_rule_del(binding);
-}
-
 int prestera_span_init(struct prestera_switch *sw)
 {
 	struct prestera_span *span;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.h b/drivers/net/ethernet/marvell/prestera/prestera_span.h
index f0644521f78a..4958ce820b52 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_span.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.h
@@ -8,13 +8,15 @@
 
 #define PRESTERA_SPAN_INVALID_ID -1
 
+struct prestera_port;
 struct prestera_switch;
-struct prestera_flow_block;
+struct prestera_flow_block_binding;
 
 int prestera_span_init(struct prestera_switch *sw);
 void prestera_span_fini(struct prestera_switch *sw);
-int prestera_span_replace(struct prestera_flow_block *block,
-			  struct tc_cls_matchall_offload *f);
-void prestera_span_destroy(struct prestera_flow_block *block);
+
+int prestera_span_rule_add(struct prestera_flow_block_binding *binding,
+			   struct prestera_port *to_port);
+int prestera_span_rule_del(struct prestera_flow_block_binding *binding);
 
 #endif /* _PRESTERA_SPAN_H_ */
-- 
2.25.1

