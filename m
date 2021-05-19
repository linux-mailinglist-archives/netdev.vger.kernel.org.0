Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBD2388744
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhESGHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236973AbhESGHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0F53613AD;
        Wed, 19 May 2021 06:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404366;
        bh=obzuLFR2aFgEoxCAuKHqAPaDVlVIDoK/xSaVj5RW/8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRn0UhCkXRYaPR0GMTwPmmspLMXpfzvyngk/Y351OK7sqvormEafx8dtDN8fxzLQl
         eU0Vih+8ph4SbQimtie4AiZh/2TO+tduGOM+VGjWFeYy152A5ali6iF+8dz/cviimF
         bG1usgn+TcUUrMHUqIz+6+t2CpI87wgW+PjuqqaFA2c7mBhX8ewb0xC1e8nIWTHU7u
         BIcPbcXJHAUGNxJpG3HZ6cHU5Or3HkCbIqvYeV7m8vQFr07QPryPuNKu+EQ7/iPT+4
         ypYVAB9VIW5waEY5gVcnV8ccFBDYOz0EPk/mniHT9s+Z5X6KPuiD35JVQNLIEXwyn3
         wDRcL9+U561mg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/16] net/mlx5e: Fix nullptr in add_vlan_push_action()
Date:   Tue, 18 May 2021 23:05:09 -0700
Message-Id: <20210519060523.17875-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

The result of dev_get_by_index_rcu() is not checked for NULL and then
gets dereferenced immediately.

Also, the RCU lock must be held by the caller of dev_get_by_index_rcu(),
which isn't satisfied by the call stack.

Fix by handling nullptr return value when iflink device is not found.
Add RCU locking around dev_get_by_index_rcu() to avoid possible adverse
effects while iterating over the net_device's hlist.

It is safe not to increment reference count of the net_device pointer in
case of a successful lookup, because it's already handled by VLAN code
during VLAN device registration (see register_vlan_dev and
netdev_upper_dev_link).

Fixes: 278748a95aa3 ("net/mlx5e: Offload TC e-switch rules with egress VLAN device")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 47a9c49b25fd..46945d04b5b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3526,8 +3526,12 @@ static int add_vlan_push_action(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	*out_dev = dev_get_by_index_rcu(dev_net(vlan_dev),
-					dev_get_iflink(vlan_dev));
+	rcu_read_lock();
+	*out_dev = dev_get_by_index_rcu(dev_net(vlan_dev), dev_get_iflink(vlan_dev));
+	rcu_read_unlock();
+	if (!*out_dev)
+		return -ENODEV;
+
 	if (is_vlan_dev(*out_dev))
 		err = add_vlan_push_action(priv, attr, out_dev, action);
 
-- 
2.31.1

