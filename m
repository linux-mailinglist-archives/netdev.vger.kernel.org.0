Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844D21E8E2A
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 08:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgE3G2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 02:28:02 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:56858 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgE3G2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 02:28:01 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 6824E5C15EB;
        Sat, 30 May 2020 14:27:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, saeedm@mellanox.com, ecree@solarflare.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] net/mlx5e: add conntrack offload rules only in ct or ct_nat flow table
Date:   Sat, 30 May 2020 14:27:55 +0800
Message-Id: <1590820075-4005-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVMQkxCQkJDTkNDTk1JWVdZKFlBSU
        I3V1ktWUFJV1kPCRoVCBIfWUFZHSI1CzgcORUxUAEJJDU9Hg5KEEs6HFZWVUJITkIoSVlXWQkOFx
        4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pkk6Kxw6Tjg2HT8aTxU0PEpO
        CxoaFDlVSlVKTkJLQ0lLS0xOTklPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU5JSk83Bg++
X-HM-Tid: 0a726443f7b42087kuqy6824e5c15eb
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the ct offload all the conntrack entry offload rules
will be add to both ct ft and ct_nat ft twice. It is not
make sense.
The driver can distinguish NAT from non-NAT conntrack
through the FLOW_ACTION_MANGLE action.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 52 ++++++++++++----------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 995b2ef..2281549 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -59,7 +59,6 @@ struct mlx5_ct_zone_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_esw_flow_attr attr;
 	int tupleid;
-	bool nat;
 };
 
 struct mlx5_tc_ct_pre {
@@ -88,7 +87,7 @@ struct mlx5_ct_entry {
 	struct mlx5_fc *counter;
 	unsigned long cookie;
 	unsigned long restore_cookie;
-	struct mlx5_ct_zone_rule zone_rules[2];
+	struct mlx5_ct_zone_rule zone_rule;
 };
 
 static const struct rhashtable_params cts_ht_params = {
@@ -238,10 +237,9 @@ struct mlx5_ct_entry {
 
 static void
 mlx5_tc_ct_entry_del_rule(struct mlx5_tc_ct_priv *ct_priv,
-			  struct mlx5_ct_entry *entry,
-			  bool nat)
+			  struct mlx5_ct_entry *entry)
 {
-	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
+	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 
@@ -256,8 +254,7 @@ struct mlx5_ct_entry {
 mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
 			   struct mlx5_ct_entry *entry)
 {
-	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
-	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
+	mlx5_tc_ct_entry_del_rule(ct_priv, entry);
 
 	mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
 }
@@ -493,15 +490,13 @@ struct mlx5_ct_entry {
 			  struct mlx5_ct_entry *entry,
 			  bool nat)
 {
-	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
+	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_spec *spec = NULL;
 	u32 tupleid;
 	int err;
 
-	zone_rule->nat = nat;
-
 	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (!spec)
 		return -ENOMEM;
@@ -562,7 +557,8 @@ struct mlx5_ct_entry {
 static int
 mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 			   struct flow_rule *flow_rule,
-			   struct mlx5_ct_entry *entry)
+			   struct mlx5_ct_entry *entry,
+			   bool nat)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
@@ -574,21 +570,26 @@ struct mlx5_ct_entry {
 		return err;
 	}
 
-	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
+	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, nat);
 	if (err)
-		goto err_orig;
+		mlx5_fc_destroy(esw->dev, entry->counter);
 
-	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
-	if (err)
-		goto err_nat;
+	return err;
+}
 
-	return 0;
+static bool
+mlx5_tc_ct_has_mangle_action(struct flow_rule *flow_rule)
+{
+	struct flow_action *flow_action = &flow_rule->action;
+	struct flow_action_entry *act;
+	int i;
 
-err_nat:
-	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
-err_orig:
-	mlx5_fc_destroy(esw->dev, entry->counter);
-	return err;
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id == FLOW_ACTION_MANGLE)
+			return true;
+	}
+
+	return false;
 }
 
 static int
@@ -600,6 +601,7 @@ struct mlx5_ct_entry {
 	struct flow_action_entry *meta_action;
 	unsigned long cookie = flow->cookie;
 	struct mlx5_ct_entry *entry;
+	bool nat;
 	int err;
 
 	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
@@ -619,7 +621,9 @@ struct mlx5_ct_entry {
 	entry->cookie = flow->cookie;
 	entry->restore_cookie = meta_action->ct_metadata.cookie;
 
-	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
+	nat = mlx5_tc_ct_has_mangle_action(flow_rule);
+
+	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry, nat);
 	if (err)
 		goto err_rules;
 
@@ -1620,7 +1624,7 @@ struct mlx5_flow_handle *
 		return false;
 
 	entry = container_of(zone_rule, struct mlx5_ct_entry,
-			     zone_rules[zone_rule->nat]);
+			     zone_rule);
 	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
 
 	return true;
-- 
1.8.3.1

