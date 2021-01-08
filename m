Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6D32EED15
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbhAHFc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbhAHFcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9CC236F9;
        Fri,  8 Jan 2021 05:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083861;
        bh=pqjYbU6uIaglQnOunWZ/J1/q10k+vBChOjvynqIvulE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rriGkouvKvIXoBJwynZHdq8Tl2QmuxM1tftDLgIITtoE+uGRzdl0S6uY7Qrx1XsxG
         6JyoDfVYujOUbC22M67pyapEY30XH/cX8VUjJqP6VQaP0tV4lizv4Ux4Ku66gHEi3D
         bYKXqN7h7rElkHbozEC+1zjwiHsXID2ol61MOp4Ex3TNDTZd8Ddvwielkbt03rUk0B
         4fvHC/gZ5cK6QlvxrJgsFiALoZXl+dy+uTohZSBcHhcvMuyC3W6oYgJ8aB+mzqNow0
         eGqMahuTd4cuf9u71HxL/YOVYTu/j7PBZiOyY7lxzMC+fDHhnvjxmfDIUAwUPr1YOb
         5u5e0FjATSnVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: CT, Avoid false lock depenency warning
Date:   Thu,  7 Jan 2021 21:30:50 -0800
Message-Id: <20210108053054.660499-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
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

Fixes: 9808dd0a2aee ("net/mlx5e: CT: Use rhashtable's ct entries instead of a separate list")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 9a189c06ab56..510eab3204d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1555,6 +1555,14 @@ tc_ct_cleanup_trk_new_rules(struct mlx5_ct_ft *ft)
 	mlx5_modify_header_dealloc(priv->mdev, ft->trk_new_rules.modify_hdr);
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
@@ -1595,6 +1603,8 @@ mlx5_tc_ct_add_ft_cb(struct mlx5_tc_ct_priv *ct_priv, u16 zone,
 	if (err)
 		goto err_init;
 
+	lockdep_set_class(&ft->ct_entries_ht.mutex, &ct_entries_ht_lock_key);
+
 	err = rhashtable_insert_fast(&ct_priv->zone_ht, &ft->node,
 				     zone_params);
 	if (err)
-- 
2.26.2

