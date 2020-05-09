Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CBE1CC45E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 22:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgEIUGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 16:06:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58041 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728681AbgEIUGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 16:06:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D015C5C00D7;
        Sat,  9 May 2020 16:06:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 09 May 2020 16:06:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=g+4NoBN6AtALivwAWOmNWaXw9z66vrpYn4QyLoA0vNo=; b=ER9yXRu/
        q40CZlnFyml7D2yn/Df2mfaKwi8EBblll89hPtfo3j8xdnnBqJ+QAgOwJietdVHO
        6iowc+ps7GQ1NKOg3VxyQaRL5Fk7y5kvXWzqCikV7oMLXQKOkRUeza6d0m2nPoC0
        sCleHMu6sw5Pt6EBRxW7dS4j+jBkmDmz2WIAYqLsq7+pIuyKqAdGuhfzUcYPK+Ww
        TEs6hSwahcuUS9cfg9Bk5mQCiA8iDlb52NE1E82evZaM3xO+pi1lVnBRbifvt+6P
        3UBhQPT5oG515kFXhF7TzLtC5vDbnkxCA+WQTKnD2t6hSnasN8m6LiA3U324es7R
        2eesCis32o+ugw==
X-ME-Sender: <xms:Ug23XlmkUKyEJaPcGg7_PGqAeztTBkCc9_bPirJxuyg8aBrZGUE2Jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrkeehgddugeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ug23Xq6U0yjwqwNBa5gvGdyXjsad8LQzjrm0GucwApN2eMVHgQm_XA>
    <xmx:Ug23Xuj6j75bj00uxjN0wuFBJNVSkij-4OWpAorCgImoNm7VARHSJw>
    <xmx:Ug23Xtgv_8V1bheZQNJJsTVRJlgBUMDi0aefAC9gHaqMDFpGYzKUBA>
    <xmx:Ug23Xos_RY0UYQu8723DjblnRW8QTC7wqE_46wBEBom9PDkO4Rkikw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 876B2306622F;
        Sat,  9 May 2020 16:06:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_matchall: Expose a function to get min and max rule priority
Date:   Sat,  9 May 2020 23:06:05 +0300
Message-Id: <20200509200610.375719-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509200610.375719-1-idosch@idosch.org>
References: <20200509200610.375719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce an infrastructure that allows to get minimum and maximum
rule priority for specified chain. This is going to be used by
a subsequent patch to enforce ordering between flower and
matchall filters.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +++
 .../mellanox/mlxsw/spectrum_matchall.c        | 34 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 553693469805..456dbaa5ee26 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -638,6 +638,8 @@ struct mlxsw_sp_flow_block {
 	struct list_head binding_list;
 	struct {
 		struct list_head list;
+		unsigned int min_prio;
+		unsigned int max_prio;
 	} mall;
 	struct mlxsw_sp_acl_ruleset *ruleset_zero;
 	struct mlxsw_sp *mlxsw_sp;
@@ -900,6 +902,8 @@ int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
 			    struct mlxsw_sp_port *mlxsw_sp_port);
 void mlxsw_sp_mall_port_unbind(struct mlxsw_sp_flow_block *block,
 			       struct mlxsw_sp_port *mlxsw_sp_port);
+int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
+			   unsigned int *p_min_prio, unsigned int *p_max_prio);
 
 /* spectrum_flower.c */
 int mlxsw_sp_flower_replace(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index d64ee31a611c..b11bab76b2e1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -23,6 +23,7 @@ struct mlxsw_sp_mall_mirror_entry {
 struct mlxsw_sp_mall_entry {
 	struct list_head list;
 	unsigned long cookie;
+	unsigned int priority;
 	enum mlxsw_sp_mall_action_type type;
 	bool ingress;
 	union {
@@ -175,6 +176,22 @@ mlxsw_sp_mall_port_rule_del(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+static void mlxsw_sp_mall_prio_update(struct mlxsw_sp_flow_block *block)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	if (list_empty(&block->mall.list))
+		return;
+	block->mall.min_prio = UINT_MAX;
+	block->mall.max_prio = 0;
+	list_for_each_entry(mall_entry, &block->mall.list, list) {
+		if (mall_entry->priority < block->mall.min_prio)
+			block->mall.min_prio = mall_entry->priority;
+		if (mall_entry->priority > block->mall.max_prio)
+			block->mall.max_prio = mall_entry->priority;
+	}
+}
+
 int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 			  struct tc_cls_matchall_offload *f)
 {
@@ -203,6 +220,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 	if (!mall_entry)
 		return -ENOMEM;
 	mall_entry->cookie = f->cookie;
+	mall_entry->priority = f->common.prio;
 	mall_entry->ingress = mlxsw_sp_flow_block_is_ingress_bound(block);
 
 	act = &f->rule->action.entries[0];
@@ -245,6 +263,7 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_flow_block *block,
 	else
 		block->ingress_blocker_rule_count++;
 	list_add_tail(&mall_entry->list, &block->mall.list);
+	mlxsw_sp_mall_prio_update(block);
 	return 0;
 
 rollback:
@@ -277,6 +296,7 @@ void mlxsw_sp_mall_destroy(struct mlxsw_sp_flow_block *block,
 	list_for_each_entry(binding, &block->binding_list, list)
 		mlxsw_sp_mall_port_rule_del(binding->mlxsw_sp_port, mall_entry);
 	kfree_rcu(mall_entry, rcu); /* sample RX packets may be in-flight */
+	mlxsw_sp_mall_prio_update(block);
 }
 
 int mlxsw_sp_mall_port_bind(struct mlxsw_sp_flow_block *block,
@@ -307,3 +327,17 @@ void mlxsw_sp_mall_port_unbind(struct mlxsw_sp_flow_block *block,
 	list_for_each_entry(mall_entry, &block->mall.list, list)
 		mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
 }
+
+int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
+			   unsigned int *p_min_prio, unsigned int *p_max_prio)
+{
+	if (chain_index || list_empty(&block->mall.list))
+		/* In case there are no matchall rules, the caller
+		 * receives -ENOENT to indicate there is no need
+		 * to check the priorities.
+		 */
+		return -ENOENT;
+	*p_min_prio = block->mall.min_prio;
+	*p_max_prio = block->mall.max_prio;
+	return 0;
+}
-- 
2.26.2

