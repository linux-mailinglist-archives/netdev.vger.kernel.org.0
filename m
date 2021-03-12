Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802C43390BC
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhCLPFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231670AbhCLPF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 528A864F77;
        Fri, 12 Mar 2021 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561528;
        bh=9doiaF75Et92SQa+Sn+F7w3D+qlHs7O3DPoohGc9wf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGrKdL+yfH0HjCuvKgKQk74Ui+ioB802HXUizPjamyhzeAFq/kDi39K/dumX/vsJ3
         ZrMl3cYnwxB0wUmWlkhx7TuOAjX35DnOiMAZhT2g718sBBn2TFksR4wjR9d5kepZqz
         b6ELd0G3B3qD9JsIOGjhTFoqaBlvJ+5ZC6chBS836cK4Vae2Iequ61jKFxp/359PMi
         YALCZRmTilbstqDybfTBxhtXGDqTs4u2prTttQywhKd8gW+TGCapFSuD2vcic8yLJs
         9W0m1CMXiUmWjIvg6xCJlg01Cxk9ctHTREyaLmICB6j2amQQjSZ2yjnCSoklxOaJWM
         HFAynA6xsHDdQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        saeedm@nvidia.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 15/16] net/mlx5e: take the rtnl lock when calling netif_set_xps_queue
Date:   Fri, 12 Mar 2021 16:04:43 +0100
Message-Id: <20210312150444.355207-16-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netif_set_xps_queue must be called with the rtnl lock taken, and this is
now enforced using ASSERT_RTNL(). mlx5e_attach_netdev was taking the
lock conditionally, fix this by taking the rtnl lock all the time.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec2fcb2a2977..96cba86b9f0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5557,7 +5557,6 @@ static void mlx5e_update_features(struct net_device *netdev)
 
 int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 {
-	const bool take_rtnl = priv->netdev->reg_state == NETREG_REGISTERED;
 	const struct mlx5e_profile *profile = priv->profile;
 	int max_nch;
 	int err;
@@ -5578,15 +5577,11 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	 * 2. Set our default XPS cpumask.
 	 * 3. Build the RQT.
 	 *
-	 * rtnl_lock is required by netif_set_real_num_*_queues in case the
-	 * netdev has been registered by this point (if this function was called
-	 * in the reload or resume flow).
+	 * rtnl_lock is required by netif_set_xps_queue.
 	 */
-	if (take_rtnl)
-		rtnl_lock();
+	rtnl_lock();
 	err = mlx5e_num_channels_changed(priv);
-	if (take_rtnl)
-		rtnl_unlock();
+	rtnl_unlock();
 	if (err)
 		goto out;
 
-- 
2.29.2

