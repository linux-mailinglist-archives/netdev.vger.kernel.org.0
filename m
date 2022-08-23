Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0545D59E64A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbiHWPoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 11:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242123AbiHWPnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 11:43:31 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D3D29A700;
        Tue, 23 Aug 2022 04:41:23 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oQSGZ-000FXN-QU; Tue, 23 Aug 2022 14:40:19 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: prestera: manage matchall and flower priorities
Date:   Tue, 23 Aug 2022 14:39:58 +0300
Message-Id: <20220823113958.2061401-4-maksym.glubokiy@plvision.eu>
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

matchall rules can be added only to chain 0 and their priorities have
limitations:
 - new matchall ingress rule's priority must be higher (lower value)
   than any existing flower rule;
 - new matchall egress rule's priority must be lower (higher value)
   than any existing flower rule.

The opposite works for flower rule adding:
 - new flower ingress rule's priority must be lower (higher value)
   than any existing matchall rule;
 - new flower egress rule's priority must be higher (lower value)
   than any existing matchall rule.

This is a hardware limitation and thus must be properly handled in
driver by reporting errors to the user when newly added rule has such a
priority that cannot be installed into the hardware.

To achieve this, the driver must maintain both min/max matchall
priorities for every flower block when user adds/deletes a matchall
rule, as well as both min/max flower priorities for chain 0 for every
adding/deletion of flower rules for chain 0.

Cc: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_acl.c  | 43 ++++++++++++++
 .../ethernet/marvell/prestera/prestera_acl.h  |  2 +
 .../ethernet/marvell/prestera/prestera_flow.c |  3 +
 .../ethernet/marvell/prestera/prestera_flow.h |  5 ++
 .../marvell/prestera/prestera_flower.c        | 48 +++++++++++++++
 .../marvell/prestera/prestera_flower.h        |  2 +
 .../marvell/prestera/prestera_matchall.c      | 58 +++++++++++++++++++
 .../marvell/prestera/prestera_matchall.h      |  2 +
 8 files changed, 163 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 3d4b85f2d541..0fa7541f0d7e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -54,6 +54,10 @@ struct prestera_acl_ruleset {
 	struct prestera_acl_ruleset_ht_key ht_key;
 	struct rhashtable rule_ht;
 	struct prestera_acl *acl;
+	struct {
+		u32 min;
+		u32 max;
+	} prio;
 	unsigned long rule_count;
 	refcount_t refcount;
 	void *keymask;
@@ -162,6 +166,9 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 	ruleset->pcl_id = PRESTERA_ACL_PCL_ID_MAKE((u8)uid, chain_index);
 	ruleset->index = uid;
 
+	ruleset->prio.min = UINT_MAX;
+	ruleset->prio.max = 0;
+
 	err = rhashtable_insert_fast(&acl->ruleset_ht, &ruleset->ht_node,
 				     prestera_acl_ruleset_ht_params);
 	if (err)
@@ -365,6 +372,26 @@ prestera_acl_ruleset_block_unbind(struct prestera_acl_ruleset *ruleset,
 	block->ruleset_zero = NULL;
 }
 
+static void
+prestera_acl_ruleset_prio_refresh(struct prestera_acl *acl,
+				  struct prestera_acl_ruleset *ruleset)
+{
+	struct prestera_acl_rule *rule;
+
+	ruleset->prio.min = UINT_MAX;
+	ruleset->prio.max = 0;
+
+	list_for_each_entry(rule, &acl->rules, list) {
+		if (ruleset->ingress != rule->ruleset->ingress)
+			continue;
+		if (ruleset->ht_key.chain_index != rule->chain_index)
+			continue;
+
+		ruleset->prio.min = min(ruleset->prio.min, rule->priority);
+		ruleset->prio.max = max(ruleset->prio.max, rule->priority);
+	}
+}
+
 void
 prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule, u16 pcl_id)
 {
@@ -389,6 +416,13 @@ u32 prestera_acl_ruleset_index_get(const struct prestera_acl_ruleset *ruleset)
 	return ruleset->index;
 }
 
+void prestera_acl_ruleset_prio_get(struct prestera_acl_ruleset *ruleset,
+				   u32 *prio_min, u32 *prio_max)
+{
+	*prio_min = ruleset->prio.min;
+	*prio_max = ruleset->prio.max;
+}
+
 bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset)
 {
 	return ruleset->offload;
@@ -429,6 +463,13 @@ void prestera_acl_rule_destroy(struct prestera_acl_rule *rule)
 	kfree(rule);
 }
 
+static void prestera_acl_ruleset_prio_update(struct prestera_acl_ruleset *ruleset,
+					     u32 prio)
+{
+	ruleset->prio.min = min(ruleset->prio.min, prio);
+	ruleset->prio.max = max(ruleset->prio.max, prio);
+}
+
 int prestera_acl_rule_add(struct prestera_switch *sw,
 			  struct prestera_acl_rule *rule)
 {
@@ -468,6 +509,7 @@ int prestera_acl_rule_add(struct prestera_switch *sw,
 
 	list_add_tail(&rule->list, &sw->acl->rules);
 	ruleset->rule_count++;
+	prestera_acl_ruleset_prio_update(ruleset, rule->priority);
 	return 0;
 
 err_acl_block_bind:
@@ -492,6 +534,7 @@ void prestera_acl_rule_del(struct prestera_switch *sw,
 	list_del(&rule->list);
 
 	prestera_acl_rule_entry_destroy(sw->acl, rule->re);
+	prestera_acl_ruleset_prio_refresh(sw->acl, ruleset);
 
 	/* unbind block (all ports) */
 	if (!ruleset->ht_key.chain_index && !ruleset->rule_count)
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 03fc5b9dc925..d45ee88e8287 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -195,6 +195,8 @@ int prestera_acl_ruleset_bind(struct prestera_acl_ruleset *ruleset,
 int prestera_acl_ruleset_unbind(struct prestera_acl_ruleset *ruleset,
 				struct prestera_port *port);
 u32 prestera_acl_ruleset_index_get(const struct prestera_acl_ruleset *ruleset);
+void prestera_acl_ruleset_prio_get(struct prestera_acl_ruleset *ruleset,
+				   u32 *prio_min, u32 *prio_max);
 void
 prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule,
 				     u16 pcl_id);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index 3f81eef167fa..9f4267f326b0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -90,6 +90,9 @@ prestera_flow_block_create(struct prestera_switch *sw,
 	INIT_LIST_HEAD(&block->template_list);
 	block->net = net;
 	block->sw = sw;
+	block->mall.prio_min = UINT_MAX;
+	block->mall.prio_max = 0;
+	block->mall.bound = false;
 	block->ingress = ingress;
 
 	return block;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.h b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
index 0c9e13263261..a85a3eb40279 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
@@ -22,6 +22,11 @@ struct prestera_flow_block {
 	struct prestera_acl_ruleset *ruleset_zero;
 	struct flow_block_cb *block_cb;
 	struct list_head template_list;
+	struct {
+		u32 prio_min;
+		u32 prio_max;
+		bool bound;
+	} mall;
 	unsigned int rule_count;
 	bool ingress;
 };
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 19d3b55c578e..f38e8b3a543e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -5,6 +5,7 @@
 #include "prestera_acl.h"
 #include "prestera_flow.h"
 #include "prestera_flower.h"
+#include "prestera_matchall.h"
 
 struct prestera_flower_template {
 	struct prestera_acl_ruleset *ruleset;
@@ -360,6 +361,49 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
 					     f->common.extack);
 }
 
+static int prestera_flower_prio_check(struct prestera_flow_block *block,
+				      struct flow_cls_offload *f)
+{
+	u32 mall_prio_min;
+	u32 mall_prio_max;
+	int err;
+
+	err = prestera_mall_prio_get(block, &mall_prio_min, &mall_prio_max);
+	if (err == -ENOENT)
+		/* No matchall filters installed on this chain. */
+		return 0;
+
+	if (err) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to get matchall priorities");
+		return err;
+	}
+
+	if (f->common.prio <= mall_prio_max && block->ingress) {
+		NL_SET_ERR_MSG(f->common.extack,
+			       "Failed to add in front of existing matchall rules");
+		return -EOPNOTSUPP;
+	}
+	if (f->common.prio >= mall_prio_min && !block->ingress) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add behind of existing matchall rules");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int prestera_flower_prio_get(struct prestera_flow_block *block, u32 chain_index,
+			     u32 *prio_min, u32 *prio_max)
+{
+	struct prestera_acl_ruleset *ruleset;
+
+	ruleset = prestera_acl_ruleset_lookup(block->sw->acl, block, chain_index);
+	if (IS_ERR(ruleset))
+		return PTR_ERR(ruleset);
+
+	prestera_acl_ruleset_prio_get(ruleset, prio_min, prio_max);
+	return 0;
+}
+
 int prestera_flower_replace(struct prestera_flow_block *block,
 			    struct flow_cls_offload *f)
 {
@@ -368,6 +412,10 @@ int prestera_flower_replace(struct prestera_flow_block *block,
 	struct prestera_acl_rule *rule;
 	int err;
 
+	err = prestera_flower_prio_check(block, f);
+	if (err)
+		return err;
+
 	ruleset = prestera_acl_ruleset_get(acl, block, f->common.chain_index);
 	if (IS_ERR(ruleset))
 		return PTR_ERR(ruleset);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.h b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
index 495f151e6fa9..1181115fe6fa 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
@@ -19,5 +19,7 @@ int prestera_flower_tmplt_create(struct prestera_flow_block *block,
 void prestera_flower_tmplt_destroy(struct prestera_flow_block *block,
 				   struct flow_cls_offload *f);
 void prestera_flower_template_cleanup(struct prestera_flow_block *block);
+int prestera_flower_prio_get(struct prestera_flow_block *block, u32 chain_index,
+			     u32 *prio_min, u32 *prio_max);
 
 #endif /* _PRESTERA_FLOWER_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
index 3fc13176e046..6f2b95a5263e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
@@ -11,6 +11,54 @@
 #include "prestera_matchall.h"
 #include "prestera_span.h"
 
+static int prestera_mall_prio_check(struct prestera_flow_block *block,
+				    struct tc_cls_matchall_offload *f)
+{
+	u32 flower_prio_min;
+	u32 flower_prio_max;
+	int err;
+
+	err = prestera_flower_prio_get(block, f->common.chain_index,
+				       &flower_prio_min, &flower_prio_max);
+	if (err == -ENOENT)
+		/* No flower filters installed on this chain. */
+		return 0;
+
+	if (err) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to get flower priorities");
+		return err;
+	}
+
+	if (f->common.prio <= flower_prio_max && !block->ingress) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add in front of existing flower rules");
+		return -EOPNOTSUPP;
+	}
+	if (f->common.prio >= flower_prio_min && block->ingress) {
+		NL_SET_ERR_MSG(f->common.extack, "Failed to add behind of existing flower rules");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+int prestera_mall_prio_get(struct prestera_flow_block *block,
+			   u32 *prio_min, u32 *prio_max)
+{
+	if (!block->mall.bound)
+		return -ENOENT;
+
+	*prio_min = block->mall.prio_min;
+	*prio_max = block->mall.prio_max;
+	return 0;
+}
+
+static void prestera_mall_prio_update(struct prestera_flow_block *block,
+				      struct tc_cls_matchall_offload *f)
+{
+	block->mall.prio_min = min(block->mall.prio_min, f->common.prio);
+	block->mall.prio_max = max(block->mall.prio_max, f->common.prio);
+}
+
 int prestera_mall_replace(struct prestera_flow_block *block,
 			  struct tc_cls_matchall_offload *f)
 {
@@ -40,6 +88,10 @@ int prestera_mall_replace(struct prestera_flow_block *block,
 	if (protocol != htons(ETH_P_ALL))
 		return -EOPNOTSUPP;
 
+	err = prestera_mall_prio_check(block, f);
+	if (err)
+		return err;
+
 	port = netdev_priv(act->dev);
 
 	list_for_each_entry(binding, &block->binding_list, list) {
@@ -48,6 +100,9 @@ int prestera_mall_replace(struct prestera_flow_block *block,
 			goto rollback;
 	}
 
+	prestera_mall_prio_update(block, f);
+
+	block->mall.bound = true;
 	return 0;
 
 rollback:
@@ -64,4 +119,7 @@ void prestera_mall_destroy(struct prestera_flow_block *block)
 	list_for_each_entry(binding, &block->binding_list, list)
 		prestera_span_rule_del(binding, block->ingress);
 
+	block->mall.prio_min = UINT_MAX;
+	block->mall.prio_max = 0;
+	block->mall.bound = false;
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_matchall.h b/drivers/net/ethernet/marvell/prestera/prestera_matchall.h
index 31ad4d02ecbb..fed08be80257 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_matchall.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_matchall.h
@@ -11,5 +11,7 @@ struct prestera_flow_block;
 int prestera_mall_replace(struct prestera_flow_block *block,
 			  struct tc_cls_matchall_offload *f);
 void prestera_mall_destroy(struct prestera_flow_block *block);
+int prestera_mall_prio_get(struct prestera_flow_block *block,
+			   u32 *prio_min, u32 *prio_max);
 
 #endif /* _PRESTERA_MATCHALL_H_ */
-- 
2.25.1

