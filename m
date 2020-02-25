Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB48616BF0E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgBYKpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:49 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42431 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730384AbgBYKpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:40 -0500
Received: by mail-wr1-f68.google.com with SMTP id p18so10475244wre.9
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xV/Wbla3nNgRAb+Jc51sd0Ib/rZAFU0ywyteSJt+8EM=;
        b=V5Hxh/inrngD8EvWE0RigDWhUgiPFXdttdiy9LgO3Feq2ql8cHm07nmTFLIm+iwwPX
         wfA0dzjmbyMbRSDZrQigc3sivCPws2Hfw0tyzgjilUGVGYwGI2+BkWtz1D74/sCGreyj
         T9d4h4V4sRJDqfiv0vziWTMB7rwj6K+aBM4dkZk6UmDpLSmdiK3FbfGWaSraBeaHQJD2
         vsc9kq1o52MHrXttzAkTPxQfY6Ai1/I9OLxjT5xTzf+NZ6m/qj0AHovwVCvAeXcq0OK7
         6Isnwo5/z5sesoxNQk1lxAtNz6CBflV11u3hwFmJ9dq8w5WX2n8aXAgxXkLcsE4/32oU
         8vWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xV/Wbla3nNgRAb+Jc51sd0Ib/rZAFU0ywyteSJt+8EM=;
        b=sodGJ/IeyHTp62LJ54RFtInxUnLu1Tjx6jGzOAoMU05iTXNkMEX79uSxPtbvYnmHrD
         wq6cQA81qvBKErW1VlnnTk0r8D7JhkMV18QTvoQOif88Ah11VIA5vSA8U6+xYK/uMGn9
         /zQsU9RjWQqsLh0Tspdfkstix7AHL2e2ti0Fix3RITSlaGrLNmAT7RAUKIbi2Fgu/5RC
         DC1gd/t0VhtxnRZjvzXuV9TQVZDOWkvCyOHZZJyPma94lxPk3A86r+MiDe5LkCMRfd0d
         pDNVuq24NvNkGLIbvd0KZaF69KmPE9IDmk2tr5/Ll3O0eD1oYdKWceJqx0TZfa2QOZn+
         ZFEA==
X-Gm-Message-State: APjAAAWpIaKA1la0wpSMsmmEMPrKAYODVEGLoSbOs9mNR1ycHN92njrO
        tfUl/L/68ZGixphb8HLh9rtaFZOrKtE=
X-Google-Smtp-Source: APXvYqy4cdif0TgsHWqD7KqhFZJXwCunXkLkGGHOWNJeqHfu7ruMrtwpMFY1XwBZvdTWdwLF1XsT2A==
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr69794181wro.231.1582627536265;
        Tue, 25 Feb 2020 02:45:36 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id p12sm23595775wrx.10.2020.02.25.02.45.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:35 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 06/10] mlxsw: core_acl_flex_actions: Implement flow_offload action cookie offload
Date:   Tue, 25 Feb 2020 11:45:23 +0100
Message-Id: <20200225104527.2849-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Track cookies coming down to driver by flow_offload.
Assign a cookie_index to each unique cookie binary. Use previously
defined "Trap with userdef" flex action to ask HW to pass cookie_index
alongside with the dropped packets.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 243 +++++++++++++++++-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   5 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |   7 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   3 +-
 5 files changed, 257 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index b7a846dd8f32..9fad56df8303 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -7,6 +7,9 @@
 #include <linux/errno.h>
 #include <linux/rhashtable.h>
 #include <linux/list.h>
+#include <linux/idr.h>
+#include <linux/refcount.h>
+#include <net/flow_offload.h>
 
 #include "item.h"
 #include "trap.h"
@@ -63,6 +66,8 @@ struct mlxsw_afa {
 	void *ops_priv;
 	struct rhashtable set_ht;
 	struct rhashtable fwd_entry_ht;
+	struct rhashtable cookie_ht;
+	struct idr cookie_idr;
 };
 
 #define MLXSW_AFA_SET_LEN 0xA8
@@ -121,6 +126,55 @@ static const struct rhashtable_params mlxsw_afa_fwd_entry_ht_params = {
 	.automatic_shrinking = true,
 };
 
+struct mlxsw_afa_cookie {
+	struct rhash_head ht_node;
+	refcount_t ref_count;
+	struct rcu_head rcu;
+	u32 cookie_index;
+	struct flow_action_cookie fa_cookie;
+};
+
+static u32 mlxsw_afa_cookie_hash(const struct flow_action_cookie *fa_cookie,
+				 u32 seed)
+{
+	return jhash2((u32 *) fa_cookie->cookie,
+		      fa_cookie->cookie_len / sizeof(u32), seed);
+}
+
+static u32 mlxsw_afa_cookie_key_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct flow_action_cookie *fa_cookie = data;
+
+	return mlxsw_afa_cookie_hash(fa_cookie, seed);
+}
+
+static u32 mlxsw_afa_cookie_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct mlxsw_afa_cookie *cookie = data;
+
+	return mlxsw_afa_cookie_hash(&cookie->fa_cookie, seed);
+}
+
+static int mlxsw_afa_cookie_obj_cmpfn(struct rhashtable_compare_arg *arg,
+				      const void *obj)
+{
+	const struct flow_action_cookie *fa_cookie = arg->key;
+	const struct mlxsw_afa_cookie *cookie = obj;
+
+	if (cookie->fa_cookie.cookie_len == fa_cookie->cookie_len)
+		return memcmp(cookie->fa_cookie.cookie, fa_cookie->cookie,
+			      fa_cookie->cookie_len);
+	return 1;
+}
+
+static const struct rhashtable_params mlxsw_afa_cookie_ht_params = {
+	.head_offset = offsetof(struct mlxsw_afa_cookie, ht_node),
+	.hashfn	= mlxsw_afa_cookie_key_hashfn,
+	.obj_hashfn = mlxsw_afa_cookie_obj_hashfn,
+	.obj_cmpfn = mlxsw_afa_cookie_obj_cmpfn,
+	.automatic_shrinking = true,
+};
+
 struct mlxsw_afa *mlxsw_afa_create(unsigned int max_acts_per_set,
 				   const struct mlxsw_afa_ops *ops,
 				   void *ops_priv)
@@ -138,11 +192,18 @@ struct mlxsw_afa *mlxsw_afa_create(unsigned int max_acts_per_set,
 			      &mlxsw_afa_fwd_entry_ht_params);
 	if (err)
 		goto err_fwd_entry_rhashtable_init;
+	err = rhashtable_init(&mlxsw_afa->cookie_ht,
+			      &mlxsw_afa_cookie_ht_params);
+	if (err)
+		goto err_cookie_rhashtable_init;
+	idr_init(&mlxsw_afa->cookie_idr);
 	mlxsw_afa->max_acts_per_set = max_acts_per_set;
 	mlxsw_afa->ops = ops;
 	mlxsw_afa->ops_priv = ops_priv;
 	return mlxsw_afa;
 
+err_cookie_rhashtable_init:
+	rhashtable_destroy(&mlxsw_afa->fwd_entry_ht);
 err_fwd_entry_rhashtable_init:
 	rhashtable_destroy(&mlxsw_afa->set_ht);
 err_set_rhashtable_init:
@@ -153,6 +214,9 @@ EXPORT_SYMBOL(mlxsw_afa_create);
 
 void mlxsw_afa_destroy(struct mlxsw_afa *mlxsw_afa)
 {
+	WARN_ON(!idr_is_empty(&mlxsw_afa->cookie_idr));
+	idr_destroy(&mlxsw_afa->cookie_idr);
+	rhashtable_destroy(&mlxsw_afa->cookie_ht);
 	rhashtable_destroy(&mlxsw_afa->fwd_entry_ht);
 	rhashtable_destroy(&mlxsw_afa->set_ht);
 	kfree(mlxsw_afa);
@@ -627,6 +691,135 @@ mlxsw_afa_counter_create(struct mlxsw_afa_block *block)
 	return ERR_PTR(err);
 }
 
+/* 20 bits is a maximum that hardware can handle in trap with userdef action
+ * and carry along with the trapped packet.
+ */
+#define MLXSW_AFA_COOKIE_INDEX_BITS 20
+#define MLXSW_AFA_COOKIE_INDEX_MAX ((1 << MLXSW_AFA_COOKIE_INDEX_BITS) - 1)
+
+static struct mlxsw_afa_cookie *
+mlxsw_afa_cookie_create(struct mlxsw_afa *mlxsw_afa,
+			const struct flow_action_cookie *fa_cookie)
+{
+	struct mlxsw_afa_cookie *cookie;
+	u32 cookie_index;
+	int err;
+
+	cookie = kzalloc(sizeof(*cookie) + fa_cookie->cookie_len, GFP_KERNEL);
+	if (!cookie)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&cookie->ref_count, 1);
+	memcpy(&cookie->fa_cookie, fa_cookie,
+	       sizeof(*fa_cookie) + fa_cookie->cookie_len);
+
+	err = rhashtable_insert_fast(&mlxsw_afa->cookie_ht, &cookie->ht_node,
+				     mlxsw_afa_cookie_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	/* Start cookie indexes with 1. Leave the 0 index unused. Packets
+	 * that come from the HW which are not dropped by drop-with-cookie
+	 * action are going to pass cookie_index 0 to lookup.
+	 */
+	cookie_index = 1;
+	err = idr_alloc_u32(&mlxsw_afa->cookie_idr, cookie, &cookie_index,
+			    MLXSW_AFA_COOKIE_INDEX_MAX, GFP_KERNEL);
+	if (err)
+		goto err_idr_alloc;
+	cookie->cookie_index = cookie_index;
+	return cookie;
+
+err_idr_alloc:
+	rhashtable_remove_fast(&mlxsw_afa->cookie_ht, &cookie->ht_node,
+			       mlxsw_afa_cookie_ht_params);
+err_rhashtable_insert:
+	kfree(cookie);
+	return ERR_PTR(err);
+}
+
+static void mlxsw_afa_cookie_destroy(struct mlxsw_afa *mlxsw_afa,
+				     struct mlxsw_afa_cookie *cookie)
+{
+	idr_remove(&mlxsw_afa->cookie_idr, cookie->cookie_index);
+	rhashtable_remove_fast(&mlxsw_afa->cookie_ht, &cookie->ht_node,
+			       mlxsw_afa_cookie_ht_params);
+	kfree_rcu(cookie, rcu);
+}
+
+static struct mlxsw_afa_cookie *
+mlxsw_afa_cookie_get(struct mlxsw_afa *mlxsw_afa,
+		     const struct flow_action_cookie *fa_cookie)
+{
+	struct mlxsw_afa_cookie *cookie;
+
+	cookie = rhashtable_lookup_fast(&mlxsw_afa->cookie_ht, fa_cookie,
+					mlxsw_afa_cookie_ht_params);
+	if (cookie) {
+		refcount_inc(&cookie->ref_count);
+		return cookie;
+	}
+	return mlxsw_afa_cookie_create(mlxsw_afa, fa_cookie);
+}
+
+static void mlxsw_afa_cookie_put(struct mlxsw_afa *mlxsw_afa,
+				 struct mlxsw_afa_cookie *cookie)
+{
+	if (!refcount_dec_and_test(&cookie->ref_count))
+		return;
+	mlxsw_afa_cookie_destroy(mlxsw_afa, cookie);
+}
+
+struct mlxsw_afa_cookie_ref {
+	struct mlxsw_afa_resource resource;
+	struct mlxsw_afa_cookie *cookie;
+};
+
+static void
+mlxsw_afa_cookie_ref_destroy(struct mlxsw_afa_block *block,
+			     struct mlxsw_afa_cookie_ref *cookie_ref)
+{
+	mlxsw_afa_resource_del(&cookie_ref->resource);
+	mlxsw_afa_cookie_put(block->afa, cookie_ref->cookie);
+	kfree(cookie_ref);
+}
+
+static void
+mlxsw_afa_cookie_ref_destructor(struct mlxsw_afa_block *block,
+				struct mlxsw_afa_resource *resource)
+{
+	struct mlxsw_afa_cookie_ref *cookie_ref;
+
+	cookie_ref = container_of(resource, struct mlxsw_afa_cookie_ref,
+				  resource);
+	mlxsw_afa_cookie_ref_destroy(block, cookie_ref);
+}
+
+static struct mlxsw_afa_cookie_ref *
+mlxsw_afa_cookie_ref_create(struct mlxsw_afa_block *block,
+			    const struct flow_action_cookie *fa_cookie)
+{
+	struct mlxsw_afa_cookie_ref *cookie_ref;
+	struct mlxsw_afa_cookie *cookie;
+	int err;
+
+	cookie_ref = kzalloc(sizeof(*cookie_ref), GFP_KERNEL);
+	if (!cookie_ref)
+		return ERR_PTR(-ENOMEM);
+	cookie = mlxsw_afa_cookie_get(block->afa, fa_cookie);
+	if (IS_ERR(cookie)) {
+		err = PTR_ERR(cookie);
+		goto err_cookie_get;
+	}
+	cookie_ref->cookie = cookie;
+	cookie_ref->resource.destructor = mlxsw_afa_cookie_ref_destructor;
+	mlxsw_afa_resource_add(block, &cookie_ref->resource);
+	return cookie_ref;
+
+err_cookie_get:
+	kfree(cookie_ref);
+	return ERR_PTR(err);
+}
+
 #define MLXSW_AFA_ONE_ACTION_LEN 32
 #define MLXSW_AFA_PAYLOAD_OFFSET 4
 
@@ -839,7 +1032,8 @@ mlxsw_afa_trap_mirror_pack(char *payload, bool mirror_enable,
 	mlxsw_afa_trap_mirror_agent_set(payload, mirror_agent);
 }
 
-int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress)
+static int mlxsw_afa_block_append_drop_plain(struct mlxsw_afa_block *block,
+					     bool ingress)
 {
 	char *act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAP_CODE,
 						  MLXSW_AFA_TRAP_SIZE);
@@ -852,6 +1046,53 @@ int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress)
 				      MLXSW_TRAP_ID_DISCARD_EGRESS_ACL);
 	return 0;
 }
+
+static int
+mlxsw_afa_block_append_drop_with_cookie(struct mlxsw_afa_block *block,
+					bool ingress,
+					const struct flow_action_cookie *fa_cookie,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_afa_cookie_ref *cookie_ref;
+	u32 cookie_index;
+	char *act;
+	int err;
+
+	cookie_ref = mlxsw_afa_cookie_ref_create(block, fa_cookie);
+	if (IS_ERR(cookie_ref)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot create cookie for drop action");
+		return PTR_ERR(cookie_ref);
+	}
+	cookie_index = cookie_ref->cookie->cookie_index;
+
+	act = mlxsw_afa_block_append_action(block, MLXSW_AFA_TRAPWU_CODE,
+					    MLXSW_AFA_TRAPWU_SIZE);
+	if (IS_ERR(act)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot append drop with cookie action");
+		err = PTR_ERR(act);
+		goto err_append_action;
+	}
+	mlxsw_afa_trapwu_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_TRAP,
+			      MLXSW_AFA_TRAP_FORWARD_ACTION_DISCARD,
+			      ingress ? MLXSW_TRAP_ID_DISCARD_INGRESS_ACL :
+					MLXSW_TRAP_ID_DISCARD_EGRESS_ACL,
+			      cookie_index);
+	return 0;
+
+err_append_action:
+	mlxsw_afa_cookie_ref_destroy(block, cookie_ref);
+	return err;
+}
+
+int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress,
+				const struct flow_action_cookie *fa_cookie,
+				struct netlink_ext_ack *extack)
+{
+	return fa_cookie ?
+	       mlxsw_afa_block_append_drop_with_cookie(block, ingress,
+						       fa_cookie, extack) :
+	       mlxsw_afa_block_append_drop_plain(block, ingress);
+}
 EXPORT_SYMBOL(mlxsw_afa_block_append_drop);
 
 int mlxsw_afa_block_append_trap(struct mlxsw_afa_block *block, u16 trap_id)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
index 28b2576ea272..67473f8bd12b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <net/flow_offload.h>
 
 struct mlxsw_afa;
 struct mlxsw_afa_block;
@@ -42,7 +43,9 @@ int mlxsw_afa_block_activity_get(struct mlxsw_afa_block *block, bool *activity);
 int mlxsw_afa_block_continue(struct mlxsw_afa_block *block);
 int mlxsw_afa_block_jump(struct mlxsw_afa_block *block, u16 group_id);
 int mlxsw_afa_block_terminate(struct mlxsw_afa_block *block);
-int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress);
+int mlxsw_afa_block_append_drop(struct mlxsw_afa_block *block, bool ingress,
+				const struct flow_action_cookie *fa_cookie,
+				struct netlink_ext_ack *extack);
 int mlxsw_afa_block_append_trap(struct mlxsw_afa_block *block, u16 trap_id);
 int mlxsw_afa_block_append_trap_and_forward(struct mlxsw_afa_block *block,
 					    u16 trap_id);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index cb3ff8d021a4..c88f00b293a1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -19,6 +19,7 @@
 #include <net/pkt_cls.h>
 #include <net/red.h>
 #include <net/vxlan.h>
+#include <net/flow_offload.h>
 
 #include "port.h"
 #include "core.h"
@@ -726,7 +727,9 @@ int mlxsw_sp_acl_rulei_act_jump(struct mlxsw_sp_acl_rule_info *rulei,
 				u16 group_id);
 int mlxsw_sp_acl_rulei_act_terminate(struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei,
-				bool ingress);
+				bool ingress,
+				const struct flow_action_cookie *fa_cookie,
+				struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_act_mirror(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_acl_rule_info *rulei,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index abd749adb0f5..36b264798f04 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -536,9 +536,12 @@ int mlxsw_sp_acl_rulei_act_terminate(struct mlxsw_sp_acl_rule_info *rulei)
 }
 
 int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei,
-				bool ingress)
+				bool ingress,
+				const struct flow_action_cookie *fa_cookie,
+				struct netlink_ext_ack *extack)
 {
-	return mlxsw_afa_block_append_drop(rulei->act_block, ingress);
+	return mlxsw_afa_block_append_drop(rulei->act_block, ingress,
+					   fa_cookie, extack);
 }
 
 int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 17368ef8cee0..0011a71114e3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -49,7 +49,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 			ingress = mlxsw_sp_acl_block_is_ingress_bound(block);
-			err = mlxsw_sp_acl_rulei_act_drop(rulei, ingress);
+			err = mlxsw_sp_acl_rulei_act_drop(rulei, ingress,
+							  act->cookie, extack);
 			if (err) {
 				NL_SET_ERR_MSG_MOD(extack, "Cannot append drop action");
 				return err;
-- 
2.21.1

