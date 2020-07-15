Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CD422072B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730066AbgGOI2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56967 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730047AbgGOI2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BFEAF5C013E;
        Wed, 15 Jul 2020 04:28:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=I+s0RCb46lSwunf8dsgVM7Vpjh4QPVSsswosleCJt4k=; b=rUvR8jRu
        qTTYugF33bl75AG/JQEzyitOqV5nBOnQs+spgyilWkwGXExnKsM2syDaGq29bk8V
        1dX5wnpZEErovVM4go98EshWCM9RPZ5UWJ9t++degntHl+2n7tYl1swdpOETHg62
        1iSDUd173iNs/8QxuuSOWAfSbcp3AMsqqKgaedT/Rbiqgux8gGtFX2xwJnFkDaR3
        J9L/5p2oK/4VpP8hycCaVowX7TEA/ahzHun5Q1zwpgZn3FA7gkSBrZtGsyCpib94
        n6OIB2Wv66XRRIxnX4lFWHGnHemcxx7NEPHVZ3PAkxrFE8+dwsVP85ejojBQfLlR
        /hvOvtVnLwXT3g==
X-ME-Sender: <xms:Hr4OXxF5Gl8S6PCI5CiospjXi0SonRo-jC6ZBcRxS8WDq8h2AXQLmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Hr4OX2XurOhdDV8GsxGqjCJDluoq0SlN6nm1FG7Q5lLlI-Z6Oiq31Q>
    <xmx:Hr4OXzKXTMJFgYVCn2c509o0odte8JFuB_jxTVSRNuCPOsmPVjMNoA>
    <xmx:Hr4OX3G4bo3vwDzFyFIkikHPamS2QtjqCpxi8YqwIDeEVguDiY4gXQ>
    <xmx:Hr4OX0jZ7ikPpAHCLF2ZL19w3Lapph47mxZHvSVs4RNqwRI-q1O_SA>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id B36F33280063;
        Wed, 15 Jul 2020 04:28:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/11] mlxsw: core_acl_flex_actions: Add police action
Date:   Wed, 15 Jul 2020 11:27:28 +0300
Message-Id: <20200715082733.429610-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Add core functionality required to support police action in the policy
engine.

The utilized hardware policers are stored in a hash table keyed by the
flow action index. This allows to support policer sharing between
multiple ACL rules.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 217 ++++++++++++++++++
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   8 +
 2 files changed, 225 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index 06a43913b9ce..4d699fe98cb6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -67,7 +67,9 @@ struct mlxsw_afa {
 	struct rhashtable set_ht;
 	struct rhashtable fwd_entry_ht;
 	struct rhashtable cookie_ht;
+	struct rhashtable policer_ht;
 	struct idr cookie_idr;
+	struct list_head policer_list;
 };
 
 #define MLXSW_AFA_SET_LEN 0xA8
@@ -177,6 +179,21 @@ static const struct rhashtable_params mlxsw_afa_cookie_ht_params = {
 	.automatic_shrinking = true,
 };
 
+struct mlxsw_afa_policer {
+	struct rhash_head ht_node;
+	struct list_head list; /* Member of policer_list */
+	refcount_t ref_count;
+	u32 fa_index;
+	u16 policer_index;
+};
+
+static const struct rhashtable_params mlxsw_afa_policer_ht_params = {
+	.key_len = sizeof(u32),
+	.key_offset = offsetof(struct mlxsw_afa_policer, fa_index),
+	.head_offset = offsetof(struct mlxsw_afa_policer, ht_node),
+	.automatic_shrinking = true,
+};
+
 struct mlxsw_afa *mlxsw_afa_create(unsigned int max_acts_per_set,
 				   const struct mlxsw_afa_ops *ops,
 				   void *ops_priv)
@@ -198,12 +215,19 @@ struct mlxsw_afa *mlxsw_afa_create(unsigned int max_acts_per_set,
 			      &mlxsw_afa_cookie_ht_params);
 	if (err)
 		goto err_cookie_rhashtable_init;
+	err = rhashtable_init(&mlxsw_afa->policer_ht,
+			      &mlxsw_afa_policer_ht_params);
+	if (err)
+		goto err_policer_rhashtable_init;
 	idr_init(&mlxsw_afa->cookie_idr);
+	INIT_LIST_HEAD(&mlxsw_afa->policer_list);
 	mlxsw_afa->max_acts_per_set = max_acts_per_set;
 	mlxsw_afa->ops = ops;
 	mlxsw_afa->ops_priv = ops_priv;
 	return mlxsw_afa;
 
+err_policer_rhashtable_init:
+	rhashtable_destroy(&mlxsw_afa->cookie_ht);
 err_cookie_rhashtable_init:
 	rhashtable_destroy(&mlxsw_afa->fwd_entry_ht);
 err_fwd_entry_rhashtable_init:
@@ -216,8 +240,10 @@ EXPORT_SYMBOL(mlxsw_afa_create);
 
 void mlxsw_afa_destroy(struct mlxsw_afa *mlxsw_afa)
 {
+	WARN_ON(!list_empty(&mlxsw_afa->policer_list));
 	WARN_ON(!idr_is_empty(&mlxsw_afa->cookie_idr));
 	idr_destroy(&mlxsw_afa->cookie_idr);
+	rhashtable_destroy(&mlxsw_afa->policer_ht);
 	rhashtable_destroy(&mlxsw_afa->cookie_ht);
 	rhashtable_destroy(&mlxsw_afa->fwd_entry_ht);
 	rhashtable_destroy(&mlxsw_afa->set_ht);
@@ -838,6 +864,137 @@ mlxsw_afa_cookie_ref_create(struct mlxsw_afa_block *block,
 	return ERR_PTR(err);
 }
 
+static struct mlxsw_afa_policer *
+mlxsw_afa_policer_create(struct mlxsw_afa *mlxsw_afa, u32 fa_index,
+			 u64 rate_bytes_ps, u32 burst,
+			 struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_policer *policer;
+	int err;
+
+	policer = kzalloc(sizeof(*policer), GFP_KERNEL);
+	if (!policer)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlxsw_afa->ops->policer_add(mlxsw_afa->ops_priv, rate_bytes_ps,
+					  burst, &policer->policer_index,
+					  extack);
+	if (err)
+		goto err_policer_add;
+
+	refcount_set(&policer->ref_count, 1);
+	policer->fa_index = fa_index;
+
+	err = rhashtable_insert_fast(&mlxsw_afa->policer_ht, &policer->ht_node,
+				     mlxsw_afa_policer_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	list_add_tail(&policer->list, &mlxsw_afa->policer_list);
+
+	return policer;
+
+err_rhashtable_insert:
+	mlxsw_afa->ops->policer_del(mlxsw_afa->ops_priv,
+				    policer->policer_index);
+err_policer_add:
+	kfree(policer);
+	return ERR_PTR(err);
+}
+
+static void mlxsw_afa_policer_destroy(struct mlxsw_afa *mlxsw_afa,
+				      struct mlxsw_afa_policer *policer)
+{
+	list_del(&policer->list);
+	rhashtable_remove_fast(&mlxsw_afa->policer_ht, &policer->ht_node,
+			       mlxsw_afa_policer_ht_params);
+	mlxsw_afa->ops->policer_del(mlxsw_afa->ops_priv,
+				    policer->policer_index);
+	kfree(policer);
+}
+
+static struct mlxsw_afa_policer *
+mlxsw_afa_policer_get(struct mlxsw_afa *mlxsw_afa, u32 fa_index,
+		      u64 rate_bytes_ps, u32 burst,
+		      struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_policer *policer;
+
+	policer = rhashtable_lookup_fast(&mlxsw_afa->policer_ht, &fa_index,
+					 mlxsw_afa_policer_ht_params);
+	if (policer) {
+		refcount_inc(&policer->ref_count);
+		return policer;
+	}
+
+	return mlxsw_afa_policer_create(mlxsw_afa, fa_index, rate_bytes_ps,
+					burst, extack);
+}
+
+static void mlxsw_afa_policer_put(struct mlxsw_afa *mlxsw_afa,
+				  struct mlxsw_afa_policer *policer)
+{
+	if (!refcount_dec_and_test(&policer->ref_count))
+		return;
+	mlxsw_afa_policer_destroy(mlxsw_afa, policer);
+}
+
+struct mlxsw_afa_policer_ref {
+	struct mlxsw_afa_resource resource;
+	struct mlxsw_afa_policer *policer;
+};
+
+static void
+mlxsw_afa_policer_ref_destroy(struct mlxsw_afa_block *block,
+			      struct mlxsw_afa_policer_ref *policer_ref)
+{
+	mlxsw_afa_resource_del(&policer_ref->resource);
+	mlxsw_afa_policer_put(block->afa, policer_ref->policer);
+	kfree(policer_ref);
+}
+
+static void
+mlxsw_afa_policer_ref_destructor(struct mlxsw_afa_block *block,
+				 struct mlxsw_afa_resource *resource)
+{
+	struct mlxsw_afa_policer_ref *policer_ref;
+
+	policer_ref = container_of(resource, struct mlxsw_afa_policer_ref,
+				   resource);
+	mlxsw_afa_policer_ref_destroy(block, policer_ref);
+}
+
+static struct mlxsw_afa_policer_ref *
+mlxsw_afa_policer_ref_create(struct mlxsw_afa_block *block, u32 fa_index,
+			     u64 rate_bytes_ps, u32 burst,
+			     struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_policer_ref *policer_ref;
+	struct mlxsw_afa_policer *policer;
+	int err;
+
+	policer_ref = kzalloc(sizeof(*policer_ref), GFP_KERNEL);
+	if (!policer_ref)
+		return ERR_PTR(-ENOMEM);
+
+	policer = mlxsw_afa_policer_get(block->afa, fa_index, rate_bytes_ps,
+					burst, extack);
+	if (IS_ERR(policer)) {
+		err = PTR_ERR(policer);
+		goto err_policer_get;
+	}
+
+	policer_ref->policer = policer;
+	policer_ref->resource.destructor = mlxsw_afa_policer_ref_destructor;
+	mlxsw_afa_resource_add(block, &policer_ref->resource);
+
+	return policer_ref;
+
+err_policer_get:
+	kfree(policer_ref);
+	return ERR_PTR(err);
+}
+
 #define MLXSW_AFA_ONE_ACTION_LEN 32
 #define MLXSW_AFA_PAYLOAD_OFFSET 4
 
@@ -1551,6 +1708,19 @@ EXPORT_SYMBOL(mlxsw_afa_block_append_fwd);
 #define MLXSW_AFA_POLCNT_CODE 0x08
 #define MLXSW_AFA_POLCNT_SIZE 1
 
+enum {
+	MLXSW_AFA_POLCNT_COUNTER,
+	MLXSW_AFA_POLCNT_POLICER,
+};
+
+/* afa_polcnt_c_p
+ * Counter or policer.
+ * Indicates whether the action binds a policer or a counter to the flow.
+ * 0: Counter
+ * 1: Policer
+ */
+MLXSW_ITEM32(afa, polcnt, c_p, 0x00, 31, 1);
+
 enum mlxsw_afa_polcnt_counter_set_type {
 	/* No count */
 	MLXSW_AFA_POLCNT_COUNTER_SET_TYPE_NO_COUNT = 0x00,
@@ -1570,15 +1740,28 @@ MLXSW_ITEM32(afa, polcnt, counter_set_type, 0x04, 24, 8);
  */
 MLXSW_ITEM32(afa, polcnt, counter_index, 0x04, 0, 24);
 
+/* afa_polcnt_pid
+ * Policer ID.
+ * Reserved when c_p = 0
+ */
+MLXSW_ITEM32(afa, polcnt, pid, 0x08, 0, 14);
+
 static inline void
 mlxsw_afa_polcnt_pack(char *payload,
 		      enum mlxsw_afa_polcnt_counter_set_type set_type,
 		      u32 counter_index)
 {
+	mlxsw_afa_polcnt_c_p_set(payload, MLXSW_AFA_POLCNT_COUNTER);
 	mlxsw_afa_polcnt_counter_set_type_set(payload, set_type);
 	mlxsw_afa_polcnt_counter_index_set(payload, counter_index);
 }
 
+static void mlxsw_afa_polcnt_policer_pack(char *payload, u16 policer_index)
+{
+	mlxsw_afa_polcnt_c_p_set(payload, MLXSW_AFA_POLCNT_POLICER);
+	mlxsw_afa_polcnt_pid_set(payload, policer_index);
+}
+
 int mlxsw_afa_block_append_allocated_counter(struct mlxsw_afa_block *block,
 					     u32 counter_index)
 {
@@ -1622,6 +1805,40 @@ int mlxsw_afa_block_append_counter(struct mlxsw_afa_block *block,
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_counter);
 
+int mlxsw_afa_block_append_police(struct mlxsw_afa_block *block,
+				  u32 fa_index, u64 rate_bytes_ps, u32 burst,
+				  u16 *p_policer_index,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_policer_ref *policer_ref;
+	char *act;
+	int err;
+
+	policer_ref = mlxsw_afa_policer_ref_create(block, fa_index,
+						   rate_bytes_ps,
+						   burst, extack);
+	if (IS_ERR(policer_ref))
+		return PTR_ERR(policer_ref);
+	*p_policer_index = policer_ref->policer->policer_index;
+
+	act = mlxsw_afa_block_append_action_ext(block, MLXSW_AFA_POLCNT_CODE,
+						MLXSW_AFA_POLCNT_SIZE,
+						MLXSW_AFA_ACTION_TYPE_POLICE);
+	if (IS_ERR(act)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append police action");
+		err = PTR_ERR(act);
+		goto err_append_action;
+	}
+	mlxsw_afa_polcnt_policer_pack(act, *p_policer_index);
+
+	return 0;
+
+err_append_action:
+	mlxsw_afa_policer_ref_destroy(block, policer_ref);
+	return err;
+}
+EXPORT_SYMBOL(mlxsw_afa_block_append_police);
+
 /* Virtual Router and Forwarding Domain Action
  * -------------------------------------------
  * Virtual Switch action is used for manipulate the Virtual Router (VR),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index a72350399bcf..b652497b1002 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -26,6 +26,10 @@ struct mlxsw_afa_ops {
 			  bool ingress, int *p_span_id);
 	void (*mirror_del)(void *priv, u8 local_in_port, int span_id,
 			   bool ingress);
+	int (*policer_add)(void *priv, u64 rate_bytes_ps, u32 burst,
+			   u16 *p_policer_index,
+			   struct netlink_ext_ack *extack);
+	void (*policer_del)(void *priv, u16 policer_index);
 	bool dummy_first_set;
 };
 
@@ -84,5 +88,9 @@ int mlxsw_afa_block_append_mcrouter(struct mlxsw_afa_block *block,
 				    bool rmid_valid, u32 kvdl_index);
 int mlxsw_afa_block_append_l4port(struct mlxsw_afa_block *block, bool is_dport, u16 l4_port,
 				  struct netlink_ext_ack *extack);
+int mlxsw_afa_block_append_police(struct mlxsw_afa_block *block,
+				  u32 fa_index, u64 rate_bytes_ps, u32 burst,
+				  u16 *p_policer_index,
+				  struct netlink_ext_ack *extack);
 
 #endif
-- 
2.26.2

