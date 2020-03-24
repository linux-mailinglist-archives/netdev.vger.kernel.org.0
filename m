Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25064190F19
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbgCXNRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:17:33 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47538 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728575AbgCXNRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:17:32 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Mar 2020 15:17:29 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02ODHSYs030372;
        Tue, 24 Mar 2020 15:17:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 3/3] net/mlx5: CT: Use rhashtable's ct entries instead of a seperate list
Date:   Tue, 24 Mar 2020 15:17:21 +0200
Message-Id: <1585055841-14256-4-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
References: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CT entries list is only used while freeing a ct zone flow table to
go over all the ct entries offloaded on that zone/table, and flush
the table.

Rhashtable already provides an api to go over all the inserted entries.
Use it instead, and remove the list.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a22ad6b..afc8ac3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -67,11 +67,9 @@ struct mlx5_ct_ft {
 	struct nf_flowtable *nf_ft;
 	struct mlx5_tc_ct_priv *ct_priv;
 	struct rhashtable ct_entries_ht;
-	struct list_head ct_entries_list;
 };
 
 struct mlx5_ct_entry {
-	struct list_head list;
 	u16 zone;
 	struct rhash_head node;
 	struct flow_rule *flow_rule;
@@ -617,8 +615,6 @@ struct mlx5_ct_entry {
 	if (err)
 		goto err_insert;
 
-	list_add(&entry->list, &ft->ct_entries_list);
-
 	return 0;
 
 err_insert:
@@ -646,7 +642,6 @@ struct mlx5_ct_entry {
 	WARN_ON(rhashtable_remove_fast(&ft->ct_entries_ht,
 				       &entry->node,
 				       cts_ht_params));
-	list_del(&entry->list);
 	kfree(entry);
 
 	return 0;
@@ -817,7 +812,6 @@ struct mlx5_ct_entry {
 	ft->zone = zone;
 	ft->nf_ft = nf_ft;
 	ft->ct_priv = ct_priv;
-	INIT_LIST_HEAD(&ft->ct_entries_list);
 	refcount_set(&ft->refcount, 1);
 
 	err = rhashtable_init(&ft->ct_entries_ht, &cts_ht_params);
@@ -846,12 +840,12 @@ struct mlx5_ct_entry {
 }
 
 static void
-mlx5_tc_ct_flush_ft(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
+mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 {
-	struct mlx5_ct_entry *entry;
+	struct mlx5_tc_ct_priv *ct_priv = arg;
+	struct mlx5_ct_entry *entry = ptr;
 
-	list_for_each_entry(entry, &ft->ct_entries_list, list)
-		mlx5_tc_ct_entry_del_rules(ft->ct_priv, entry);
+	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 }
 
 static void
@@ -862,9 +856,10 @@ struct mlx5_ct_entry {
 
 	nf_flow_table_offload_del_cb(ft->nf_ft,
 				     mlx5_tc_ct_block_flow_offload, ft);
-	mlx5_tc_ct_flush_ft(ct_priv, ft);
 	rhashtable_remove_fast(&ct_priv->zone_ht, &ft->node, zone_params);
-	rhashtable_destroy(&ft->ct_entries_ht);
+	rhashtable_free_and_destroy(&ft->ct_entries_ht,
+				    mlx5_tc_ct_flush_ft_entry,
+				    ct_priv);
 	kfree(ft);
 }
 
-- 
1.8.3.1

