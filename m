Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA72755D624
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbiF0KkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbiF0KkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:40:20 -0400
X-Greylist: delayed 2969 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Jun 2022 03:40:18 PDT
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2D56378;
        Mon, 27 Jun 2022 03:40:18 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1o5lO2-00005Z-Rf; Mon, 27 Jun 2022 12:50:31 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: acl: add support for 'egress' rules
Date:   Mon, 27 Jun 2022 12:50:18 +0300
Message-Id: <20220627095019.152746-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
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

The following is now supported:

  $ tc qdisc add PORT clsact
  $ tc filter add dev PORT egress ...

Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |  3 +-
 .../ethernet/marvell/prestera/prestera_acl.c  | 47 ++++++++++++-----
 .../ethernet/marvell/prestera/prestera_acl.h  |  4 +-
 .../ethernet/marvell/prestera/prestera_flow.c | 52 +++++++++++++------
 .../ethernet/marvell/prestera/prestera_flow.h |  1 +
 .../marvell/prestera/prestera_flower.c        |  2 +-
 .../ethernet/marvell/prestera/prestera_hw.h   |  7 +--
 7 files changed, 82 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 6f754ae2a584..0bb46eee46b4 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -107,7 +107,8 @@ struct prestera_port_phy_config {
 struct prestera_port {
 	struct net_device *dev;
 	struct prestera_switch *sw;
-	struct prestera_flow_block *flow_block;
+	struct prestera_flow_block *ingress_flow_block;
+	struct prestera_flow_block *egress_flow_block;
 	struct devlink_port dl_port;
 	struct list_head lag_member;
 	struct prestera_lag *lag;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index 3a141f2db812..3d4b85f2d541 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -61,6 +61,7 @@ struct prestera_acl_ruleset {
 	u32 index;
 	u16 pcl_id;
 	bool offload;
+	bool ingress;
 };
 
 struct prestera_acl_vtcam {
@@ -70,6 +71,7 @@ struct prestera_acl_vtcam {
 	u32 id;
 	bool is_keymask_set;
 	u8 lookup;
+	u8 direction;
 };
 
 static const struct rhashtable_params prestera_acl_ruleset_ht_params = {
@@ -93,23 +95,36 @@ static const struct rhashtable_params __prestera_acl_rule_entry_ht_params = {
 	.automatic_shrinking = true,
 };
 
-int prestera_acl_chain_to_client(u32 chain_index, u32 *client)
+int prestera_acl_chain_to_client(u32 chain_index, bool ingress, u32 *client)
 {
-	static const u32 client_map[] = {
-		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0,
-		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_1,
-		PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2
+	static const u32 ingress_client_map[] = {
+		PRESTERA_HW_COUNTER_CLIENT_INGRESS_LOOKUP_0,
+		PRESTERA_HW_COUNTER_CLIENT_INGRESS_LOOKUP_1,
+		PRESTERA_HW_COUNTER_CLIENT_INGRESS_LOOKUP_2
 	};
 
-	if (chain_index >= ARRAY_SIZE(client_map))
+	if (!ingress) {
+		/* prestera supports only one chain on egress */
+		if (chain_index > 0)
+			return -EINVAL;
+
+		*client = PRESTERA_HW_COUNTER_CLIENT_EGRESS_LOOKUP;
+		return 0;
+	}
+
+	if (chain_index >= ARRAY_SIZE(ingress_client_map))
 		return -EINVAL;
 
-	*client = client_map[chain_index];
+	*client = ingress_client_map[chain_index];
 	return 0;
 }
 
-static bool prestera_acl_chain_is_supported(u32 chain_index)
+static bool prestera_acl_chain_is_supported(u32 chain_index, bool ingress)
 {
+	if (!ingress)
+		/* prestera supports only one chain on egress */
+		return chain_index == 0;
+
 	return (chain_index & ~PRESTERA_ACL_CHAIN_MASK) == 0;
 }
 
@@ -122,7 +137,7 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 	u32 uid = 0;
 	int err;
 
-	if (!prestera_acl_chain_is_supported(chain_index))
+	if (!prestera_acl_chain_is_supported(chain_index, block->ingress))
 		return ERR_PTR(-EINVAL);
 
 	ruleset = kzalloc(sizeof(*ruleset), GFP_KERNEL);
@@ -130,6 +145,7 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 		return ERR_PTR(-ENOMEM);
 
 	ruleset->acl = acl;
+	ruleset->ingress = block->ingress;
 	ruleset->ht_key.block = block;
 	ruleset->ht_key.chain_index = chain_index;
 	refcount_set(&ruleset->refcount, 1);
@@ -172,13 +188,18 @@ int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
 {
 	struct prestera_acl_iface iface;
 	u32 vtcam_id;
+	int dir;
 	int err;
 
+	dir = ruleset->ingress ?
+		PRESTERA_HW_VTCAM_DIR_INGRESS : PRESTERA_HW_VTCAM_DIR_EGRESS;
+
 	if (ruleset->offload)
 		return -EEXIST;
 
 	err = prestera_acl_vtcam_id_get(ruleset->acl,
 					ruleset->ht_key.chain_index,
+					dir,
 					ruleset->keymask, &vtcam_id);
 	if (err)
 		goto err_vtcam_create;
@@ -719,7 +740,7 @@ static int __prestera_acl_vtcam_id_try_fit(struct prestera_acl *acl, u8 lookup,
 	return 0;
 }
 
-int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
+int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup, u8 dir,
 			      void *keymask, u32 *vtcam_id)
 {
 	struct prestera_acl_vtcam *vtcam;
@@ -731,7 +752,8 @@ int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
 	 * fine for now
 	 */
 	list_for_each_entry(vtcam, &acl->vtcam_list, list) {
-		if (lookup != vtcam->lookup)
+		if (lookup != vtcam->lookup ||
+		    dir != vtcam->direction)
 			continue;
 
 		if (!keymask && !vtcam->is_keymask_set) {
@@ -752,7 +774,7 @@ int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
 		return -ENOMEM;
 
 	err = prestera_hw_vtcam_create(acl->sw, lookup, keymask, &new_vtcam_id,
-				       PRESTERA_HW_VTCAM_DIR_INGRESS);
+				       dir);
 	if (err) {
 		kfree(vtcam);
 
@@ -765,6 +787,7 @@ int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
 		return 0;
 	}
 
+	vtcam->direction = dir;
 	vtcam->id = new_vtcam_id;
 	vtcam->lookup = lookup;
 	if (keymask) {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index f963e1e0c0f0..03fc5b9dc925 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -199,9 +199,9 @@ void
 prestera_acl_rule_keymask_pcl_id_set(struct prestera_acl_rule *rule,
 				     u16 pcl_id);
 
-int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
+int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup, u8 dir,
 			      void *keymask, u32 *vtcam_id);
 int prestera_acl_vtcam_id_put(struct prestera_acl *acl, u32 vtcam_id);
-int prestera_acl_chain_to_client(u32 chain_index, u32 *client);
+int prestera_acl_chain_to_client(u32 chain_index, bool ingress, u32 *client);
 
 #endif /* _PRESTERA_ACL_H_ */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index 05c3ad98eba9..2262693bd5cf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -75,7 +75,9 @@ static void prestera_flow_block_destroy(void *cb_priv)
 }
 
 static struct prestera_flow_block *
-prestera_flow_block_create(struct prestera_switch *sw, struct net *net)
+prestera_flow_block_create(struct prestera_switch *sw,
+			   struct net *net,
+			   bool ingress)
 {
 	struct prestera_flow_block *block;
 
@@ -87,6 +89,7 @@ prestera_flow_block_create(struct prestera_switch *sw, struct net *net)
 	INIT_LIST_HEAD(&block->template_list);
 	block->net = net;
 	block->sw = sw;
+	block->ingress = ingress;
 
 	return block;
 }
@@ -165,7 +168,8 @@ static int prestera_flow_block_unbind(struct prestera_flow_block *block,
 static struct prestera_flow_block *
 prestera_flow_block_get(struct prestera_switch *sw,
 			struct flow_block_offload *f,
-			bool *register_block)
+			bool *register_block,
+			bool ingress)
 {
 	struct prestera_flow_block *block;
 	struct flow_block_cb *block_cb;
@@ -173,7 +177,7 @@ prestera_flow_block_get(struct prestera_switch *sw,
 	block_cb = flow_block_cb_lookup(f->block,
 					prestera_flow_block_cb, sw);
 	if (!block_cb) {
-		block = prestera_flow_block_create(sw, f->net);
+		block = prestera_flow_block_create(sw, f->net, ingress);
 		if (!block)
 			return ERR_PTR(-ENOMEM);
 
@@ -209,7 +213,7 @@ static void prestera_flow_block_put(struct prestera_flow_block *block)
 }
 
 static int prestera_setup_flow_block_bind(struct prestera_port *port,
-					  struct flow_block_offload *f)
+					  struct flow_block_offload *f, bool ingress)
 {
 	struct prestera_switch *sw = port->sw;
 	struct prestera_flow_block *block;
@@ -217,7 +221,7 @@ static int prestera_setup_flow_block_bind(struct prestera_port *port,
 	bool register_block;
 	int err;
 
-	block = prestera_flow_block_get(sw, f, &register_block);
+	block = prestera_flow_block_get(sw, f, &register_block, ingress);
 	if (IS_ERR(block))
 		return PTR_ERR(block);
 
@@ -232,7 +236,11 @@ static int prestera_setup_flow_block_bind(struct prestera_port *port,
 		list_add_tail(&block_cb->driver_list, &prestera_block_cb_list);
 	}
 
-	port->flow_block = block;
+	if (ingress)
+		port->ingress_flow_block = block;
+	else
+		port->egress_flow_block = block;
+
 	return 0;
 
 err_block_bind:
@@ -242,7 +250,7 @@ static int prestera_setup_flow_block_bind(struct prestera_port *port,
 }
 
 static void prestera_setup_flow_block_unbind(struct prestera_port *port,
-					     struct flow_block_offload *f)
+					     struct flow_block_offload *f, bool ingress)
 {
 	struct prestera_switch *sw = port->sw;
 	struct prestera_flow_block *block;
@@ -266,24 +274,38 @@ static void prestera_setup_flow_block_unbind(struct prestera_port *port,
 		list_del(&block_cb->driver_list);
 	}
 error:
-	port->flow_block = NULL;
+	if (ingress)
+		port->ingress_flow_block = NULL;
+	else
+		port->egress_flow_block = NULL;
 }
 
-int prestera_flow_block_setup(struct prestera_port *port,
-			      struct flow_block_offload *f)
+static int prestera_setup_flow_block_clsact(struct prestera_port *port,
+					    struct flow_block_offload *f,
+					    bool ingress)
 {
-	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
 	f->driver_block_list = &prestera_block_cb_list;
 
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		return prestera_setup_flow_block_bind(port, f);
+		return prestera_setup_flow_block_bind(port, f, ingress);
 	case FLOW_BLOCK_UNBIND:
-		prestera_setup_flow_block_unbind(port, f);
+		prestera_setup_flow_block_unbind(port, f, ingress);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
 }
+
+int prestera_flow_block_setup(struct prestera_port *port,
+			      struct flow_block_offload *f)
+{
+	switch (f->binder_type) {
+	case FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS:
+		return prestera_setup_flow_block_clsact(port, f, true);
+	case FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS:
+		return prestera_setup_flow_block_clsact(port, f, false);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.h b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
index 6550278b166a..0c9e13263261 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
@@ -23,6 +23,7 @@ struct prestera_flow_block {
 	struct flow_block_cb *block_cb;
 	struct list_head template_list;
 	unsigned int rule_count;
+	bool ingress;
 };
 
 int prestera_flow_block_setup(struct prestera_port *port,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index d43e503c644f..a54748ac6541 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -79,7 +79,7 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 	} else if (act->hw_stats & FLOW_ACTION_HW_STATS_DELAYED) {
 		/* setup counter first */
 		rule->re_arg.count.valid = true;
-		err = prestera_acl_chain_to_client(chain_index,
+		err = prestera_acl_chain_to_client(chain_index, block->ingress,
 						   &rule->re_arg.count.client);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 579d9ba23ffc..aa74f668aa3c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -123,9 +123,10 @@ enum prestera_hw_vtcam_direction_t {
 };
 
 enum {
-	PRESTERA_HW_COUNTER_CLIENT_LOOKUP_0 = 0,
-	PRESTERA_HW_COUNTER_CLIENT_LOOKUP_1 = 1,
-	PRESTERA_HW_COUNTER_CLIENT_LOOKUP_2 = 2,
+	PRESTERA_HW_COUNTER_CLIENT_INGRESS_LOOKUP_0 = 0,
+	PRESTERA_HW_COUNTER_CLIENT_INGRESS_LOOKUP_1 = 1,
+	PRESTERA_HW_COUNTER_CLIENT_INGRESS_LOOKUP_2 = 2,
+	PRESTERA_HW_COUNTER_CLIENT_EGRESS_LOOKUP = 3,
 };
 
 struct prestera_switch;
-- 
2.25.1

