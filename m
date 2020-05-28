Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9032C1E5851
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgE1HQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:16:06 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:52410 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgE1HQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 03:16:06 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id E66DC418F9;
        Thu, 28 May 2020 15:15:55 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net/mlx5e: add ct_metadata.nat support in ct offload
Date:   Thu, 28 May 2020 15:15:55 +0800
Message-Id: <1590650155-4403-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
References: <1590650155-4403-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0NJS0tLS0pMSk1NSk9ZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdMjULOBw6IxkpEAkhGEIeTRgcCzocVlZVSUpOSEsoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRg6MTo6ODgrFTgxFj4RLwMh
        HhgKCixVSlVKTkJLTU5LSk5NS09MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9PSUw3Bg++
X-HM-Tid: 0a725a2333b72086kuqye66dc418f9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the ct offload all the conntrack entry offload  rules 
will be add to both ct ft and ct_nat ft twice. 
It is not makesense. The ct_metadat.nat will tell driver
the rule should add to ct or ct_nat flow table 

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 34 ++++++++--------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 995b2ef..02ecd24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -88,7 +88,7 @@ struct mlx5_ct_entry {
 	struct mlx5_fc *counter;
 	unsigned long cookie;
 	unsigned long restore_cookie;
-	struct mlx5_ct_zone_rule zone_rules[2];
+	struct mlx5_ct_zone_rule zone_rule;
 };
 
 static const struct rhashtable_params cts_ht_params = {
@@ -238,10 +238,9 @@ struct mlx5_ct_entry {
 
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
 
@@ -256,8 +255,7 @@ struct mlx5_ct_entry {
 mlx5_tc_ct_entry_del_rules(struct mlx5_tc_ct_priv *ct_priv,
 			   struct mlx5_ct_entry *entry)
 {
-	mlx5_tc_ct_entry_del_rule(ct_priv, entry, true);
-	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
+	mlx5_tc_ct_entry_del_rule(ct_priv, entry);
 
 	mlx5_fc_destroy(ct_priv->esw->dev, entry->counter);
 }
@@ -493,7 +491,7 @@ struct mlx5_ct_entry {
 			  struct mlx5_ct_entry *entry,
 			  bool nat)
 {
-	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rules[nat];
+	struct mlx5_ct_zone_rule *zone_rule = &entry->zone_rule;
 	struct mlx5_esw_flow_attr *attr = &zone_rule->attr;
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	struct mlx5_flow_spec *spec = NULL;
@@ -562,7 +560,8 @@ struct mlx5_ct_entry {
 static int
 mlx5_tc_ct_entry_add_rules(struct mlx5_tc_ct_priv *ct_priv,
 			   struct flow_rule *flow_rule,
-			   struct mlx5_ct_entry *entry)
+			   struct mlx5_ct_entry *entry,
+			   bool nat)
 {
 	struct mlx5_eswitch *esw = ct_priv->esw;
 	int err;
@@ -574,20 +573,10 @@ struct mlx5_ct_entry {
 		return err;
 	}
 
-	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, false);
+	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, nat);
 	if (err)
-		goto err_orig;
-
-	err = mlx5_tc_ct_entry_add_rule(ct_priv, flow_rule, entry, true);
-	if (err)
-		goto err_nat;
-
-	return 0;
+		mlx5_fc_destroy(esw->dev, entry->counter);
 
-err_nat:
-	mlx5_tc_ct_entry_del_rule(ct_priv, entry, false);
-err_orig:
-	mlx5_fc_destroy(esw->dev, entry->counter);
 	return err;
 }
 
@@ -619,7 +608,8 @@ struct mlx5_ct_entry {
 	entry->cookie = flow->cookie;
 	entry->restore_cookie = meta_action->ct_metadata.cookie;
 
-	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
+	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry,
+					 meta_action->ct_metadata.nat);
 	if (err)
 		goto err_rules;
 
@@ -1620,7 +1610,7 @@ struct mlx5_flow_handle *
 		return false;
 
 	entry = container_of(zone_rule, struct mlx5_ct_entry,
-			     zone_rules[zone_rule->nat]);
+			     zone_rule);
 	tcf_ct_flow_table_restore_skb(skb, entry->restore_cookie);
 
 	return true;
-- 
1.8.3.1

