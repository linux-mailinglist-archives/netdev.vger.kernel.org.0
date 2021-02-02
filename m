Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9863030B825
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhBBG5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:57:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232277AbhBBG4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC1264EEA;
        Tue,  2 Feb 2021 06:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248915;
        bh=0um0f/IKNvo62FNnc9D8KKcrsMJYKTQLbxBD6NJx+y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpj9TXks7M6zEXXKRwd715RU0tLqpxp7/lR1hmMUzZUb0i9Eju+bvlgESSbHShz98
         ajaDwe7ssDkYSl96XzqFOfwdY1vzoEbP7tv+t1CI1loHeCXRFAJvADRwscYTDRKiep
         8yeOle9m4mZH5oVbuK4YiLRqD6rFFM5MaLdBEnB4dXKqlB49tsj1ibUEOQmHF1BnbT
         yEDn0YxZZ23OOivK0jbYkh56Fn7YG08jk/n/GdI60znFyh9VFWkniAVAtTYwT9KAoB
         so5fH9T7b8S2mG98MoTmh1ijtFImWmuXCLAC9vKjDzC21F9eNvxxLUj2f6uli5oxZt
         nKSvoULR3iFgQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/14] net/mlx5e: Avoid false lock depenency warning on tc_ht
Date:   Mon,  1 Feb 2021 22:54:49 -0800
Message-Id: <20210202065457.613312-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

To avoid false lock dependency warning set the tc_ht lock
class different than the lock class of the ht being used when deleting
last flow from a group and then deleting a group, we get into del_sw_flow_group()
which call rhashtable_destroy on fg->ftes_hash which will take ht->mutex but
it's different than the ht->mutex here.

======================================================
WARNING: possible circular locking dependency detected
5.11.0-rc4_net_next_mlx5_949fdcc #1 Not tainted
------------------------------------------------------
modprobe/12950 is trying to acquire lock:
ffff88816510f910 (&node->lock){++++}-{3:3}, at: mlx5_del_flow_rules+0x2a/0x210 [mlx5_core]

but task is already holding lock:
ffff88815834e3e8 (&ht->mutex){+.+.}-{3:3}, at: rhashtable_free_and_destroy+0x37/0x340

which lock already depends on the new lock.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8fd38ad8113b..280ea1e1e039 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -190,6 +190,14 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	[NIC_ZONE_RESTORE_TO_REG] = nic_zone_restore_to_reg_ct,
 };
 
+/* To avoid false lock dependency warning set the tc_ht lock
+ * class different than the lock class of the ht being used when deleting
+ * last flow from a group and then deleting a group, we get into del_sw_flow_group()
+ * which call rhashtable_destroy on fg->ftes_hash which will take ht->mutex but
+ * it's different than the ht->mutex here.
+ */
+static struct lock_class_key tc_ht_lock_key;
+
 static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow);
 
 void
@@ -5215,6 +5223,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	if (err)
 		return err;
 
+	lockdep_set_class(&tc->ht.mutex, &tc_ht_lock_key);
+
 	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level)) {
 		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
 			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
@@ -5333,6 +5343,8 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	if (err)
 		goto err_ht_init;
 
+	lockdep_set_class(&tc_ht->mutex, &tc_ht_lock_key);
+
 	return err;
 
 err_ht_init:
-- 
2.29.2

