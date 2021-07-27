Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7358D3D83DA
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhG0XVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232745AbhG0XU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21E9060234;
        Tue, 27 Jul 2021 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428058;
        bh=Q8FzgYKWOfQFoWOAEx83VIS+OnhbSvtXIs02e9DNYbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iuzSILDl39YVPllm0o0KWm9WslNqBeaukb+0EfhzsqGXkoPXze9QNk7myQ/M2m7j/
         ZgJjcDQj7PBnPIoDqW/ATY0/yI/0hkA3Bk2OdGTAa7HYMke7IqdP5PfZNDF67c4eFs
         f7+ohK4uTnmv6h3dKbohXdjIdzuORdMs1EbYdHFjtibq0FSqHsnB8+Ore3P0lE1kDy
         V43VT7KMoZDLy6XR1JVMOdUDCEaL68fH4TfjHqTSTq8AyHgeuw7bLFlIPp9zkRaxNE
         096AqunTkRIJoBCQHz8MZ76FZkLrSuZFHws8siXQAQFAafG4bKZr/BiV6+dK06GXRI
         7NS123YPwT6tQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/12] net/mlx5e: Fix nullptr in mlx5e_hairpin_get_mdev()
Date:   Tue, 27 Jul 2021 16:20:49 -0700
Message-Id: <20210727232050.606896-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

The result of __dev_get_by_index() is not checked for NULL and then gets
dereferenced immediately.

Also, __dev_get_by_index() must be called while holding either RTNL lock
or @dev_base_lock, which isn't satisfied by mlx5e_hairpin_get_mdev() or
its callers. This makes the underlying hlist_for_each_entry() loop not
safe, and can have adverse effects in itself.

Fix by using dev_get_by_index() and handling nullptr return value when
ifindex device is not found. Update mlx5e_hairpin_get_mdev() callers to
check for possible PTR_ERR() result.

Fixes: 77ab67b7f0f9 ("net/mlx5e: Basic setup of hairpin object")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 33 +++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 629a61e8022f..d273758255c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -452,12 +452,32 @@ static void mlx5e_detach_mod_hdr(struct mlx5e_priv *priv,
 static
 struct mlx5_core_dev *mlx5e_hairpin_get_mdev(struct net *net, int ifindex)
 {
+	struct mlx5_core_dev *mdev;
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
 
-	netdev = __dev_get_by_index(net, ifindex);
+	netdev = dev_get_by_index(net, ifindex);
+	if (!netdev)
+		return ERR_PTR(-ENODEV);
+
 	priv = netdev_priv(netdev);
-	return priv->mdev;
+	mdev = priv->mdev;
+	dev_put(netdev);
+
+	/* Mirred tc action holds a refcount on the ifindex net_device (see
+	 * net/sched/act_mirred.c:tcf_mirred_get_dev). So, it's okay to continue using mdev
+	 * after dev_put(netdev), while we're in the context of adding a tc flow.
+	 *
+	 * The mdev pointer corresponds to the peer/out net_device of a hairpin. It is then
+	 * stored in a hairpin object, which exists until all flows, that refer to it, get
+	 * removed.
+	 *
+	 * On the other hand, after a hairpin object has been created, the peer net_device may
+	 * be removed/unbound while there are still some hairpin flows that are using it. This
+	 * case is handled by mlx5e_tc_hairpin_update_dead_peer, which is hooked to
+	 * NETDEV_UNREGISTER event of the peer net_device.
+	 */
+	return mdev;
 }
 
 static int mlx5e_hairpin_create_transport(struct mlx5e_hairpin *hp)
@@ -666,6 +686,10 @@ mlx5e_hairpin_create(struct mlx5e_priv *priv, struct mlx5_hairpin_params *params
 
 	func_mdev = priv->mdev;
 	peer_mdev = mlx5e_hairpin_get_mdev(dev_net(priv->netdev), peer_ifindex);
+	if (IS_ERR(peer_mdev)) {
+		err = PTR_ERR(peer_mdev);
+		goto create_pair_err;
+	}
 
 	pair = mlx5_core_hairpin_create(func_mdev, peer_mdev, params);
 	if (IS_ERR(pair)) {
@@ -804,6 +828,11 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 	int err;
 
 	peer_mdev = mlx5e_hairpin_get_mdev(dev_net(priv->netdev), peer_ifindex);
+	if (IS_ERR(peer_mdev)) {
+		NL_SET_ERR_MSG_MOD(extack, "invalid ifindex of mirred device");
+		return PTR_ERR(peer_mdev);
+	}
+
 	if (!MLX5_CAP_GEN(priv->mdev, hairpin) || !MLX5_CAP_GEN(peer_mdev, hairpin)) {
 		NL_SET_ERR_MSG_MOD(extack, "hairpin is not supported");
 		return -EOPNOTSUPP;
-- 
2.31.1

