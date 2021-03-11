Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F185C3380AC
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhCKWhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhCKWhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0792064F99;
        Thu, 11 Mar 2021 22:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502257;
        bh=bttFJcleeOc2zRLOyN/ayO8uNH1mX1D8Pdn0uhpQ01w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgeavllgMLPNwocDP2NuKu3I6hW94R/NkxJZvZfwjI1jw+Vai2Spcg0zDAqEZ5HJ9
         j/YsbM8XFYCnZfBFJKKoioj8E/D8TsfGX9fq4M9prE95gAc4INDtQAPFyk0v1Lwi4A
         fUbRi2N6UN8MjAOf600XLoTSA9xQNcb7OaIil8NSxxEC+X8OrasGD2kycoOgratT5H
         fMigqntpEYASnj6uuyMiLhifrzYYcmoR7UUPqWeQPe+kpEKlmouw7EIQH0WVwTxzGT
         88QM0s4doyN/m3x6IN1b8lrOkJviDbohpYWQUUPQD32avdH77Il/qGlgjGNEG6L4Db
         fAXzXx48VEo8g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: CT, Avoid false lock dependency warning
Date:   Thu, 11 Mar 2021 14:37:15 -0800
Message-Id: <20210311223723.361301-8-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

To avoid false lock dependency warning set the ct_entries_ht lock
class different than the lock class of the ht being used when deleting
last flow from a group and then deleting a group, we get into del_sw_flow_group()
which call rhashtable_destroy on fg->ftes_hash which will take ht->mutex but
it's different than the ht->mutex here.

======================================================
WARNING: possible circular locking dependency detected
5.10.0-rc2+ #8 Tainted: G           O
------------------------------------------------------
revalidator23/24009 is trying to acquire lock:
ffff888128d83828 (&node->lock){++++}-{3:3}, at: mlx5_del_flow_rules+0x83/0x7a0 [mlx5_core]

but task is already holding lock:
ffff8881081ef518 (&ht->mutex){+.+.}-{3:3}, at: rhashtable_free_and_destroy+0x37/0x720

which lock already depends on the new lock.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index f3f6eb081948..f81da2dc6af1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1539,6 +1539,14 @@ mlx5_tc_ct_free_pre_ct_tables(struct mlx5_ct_ft *ft)
 	mlx5_tc_ct_free_pre_ct(ft, &ft->pre_ct);
 }
 
+/* To avoid false lock dependency warning set the ct_entries_ht lock
+ * class different than the lock class of the ht being used when deleting
+ * last flow from a group and then deleting a group, we get into del_sw_flow_group()
+ * which call rhashtable_destroy on fg->ftes_hash which will take ht->mutex but
+ * it's different than the ht->mutex here.
+ */
+static struct lock_class_key ct_entries_ht_lock_key;
+
 static struct mlx5_ct_ft *
 mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 		     struct nf_flowtable *nf_ft)
@@ -1573,6 +1581,8 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	if (err)
 		goto err_init;
 
+	lockdep_set_class(&ft->ct_entries_ht.mutex, &ct_entries_ht_lock_key);
+
 	err = rhashtable_insert_fast(&ct_priv->zone_ht, &ft->node,
 				     zone_params);
 	if (err)
-- 
2.29.2

