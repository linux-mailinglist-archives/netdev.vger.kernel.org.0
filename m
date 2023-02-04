Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95BEF68A94E
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbjBDKJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjBDKJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02321D913
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24E4C60BF9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC9C433D2;
        Sat,  4 Feb 2023 10:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505356;
        bh=AZsreZ3Z4NhGOogM7czUGIGvRVZkUytFJyIUqOGHa/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKp1TcytcOlsaT2AfPd0NaCxqa1bIvmrkn9unKO35b7ftPaSI42mx0XjCQZWhJntM
         w1Dpfj37T6TtzmhUthQVLgo3n8wDUg5ij53nzRCHhXt1xuIC8mMkDREd0cXkpNa/+9
         d+Phzwn33c83Sa/+BU++lmOlqiDS/mfD2BGHVn03CHrDxgQgPMEvQUpv9fKH3GJXHl
         LyckY+kyFjbj2U9kl4y6OfEMGF1vXW4WCJ033ZOI2RITUsDy3q1uxVjXMPadClzm6r
         Xvr+c42d9yURRUHCah2aSZMdM7sUVC9D7BYKDPraoHH/j2+c0OxpxPaKmWgKlYs1W+
         SxBi+sdVhHecQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Lag, Use mlx5_lag_dev() instead of derefering pointers
Date:   Sat,  4 Feb 2023 02:08:41 -0800
Message-Id: <20230204100854.388126-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Use the existing wrapper mlx5_lag_dev() to access the lag object from
dev for better maintainability and consistent code.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c    | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c  |  7 ++++---
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
index b8feaf0f5c4c..f4b777d4e108 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/debugfs.c
@@ -22,7 +22,7 @@ static int type_show(struct seq_file *file, void *priv)
 	struct mlx5_lag *ldev;
 	char *mode = NULL;
 
-	ldev = dev->priv.lag;
+	ldev = mlx5_lag_dev(dev);
 	mutex_lock(&ldev->lock);
 	if (__mlx5_lag_is_active(ldev))
 		mode = get_str_mode_type(ldev);
@@ -41,7 +41,7 @@ static int port_sel_mode_show(struct seq_file *file, void *priv)
 	int ret = 0;
 	char *mode;
 
-	ldev = dev->priv.lag;
+	ldev = mlx5_lag_dev(dev);
 	mutex_lock(&ldev->lock);
 	if (__mlx5_lag_is_active(ldev))
 		mode = mlx5_get_str_port_sel_mode(ldev->mode, ldev->mode_flags);
@@ -61,7 +61,7 @@ static int state_show(struct seq_file *file, void *priv)
 	struct mlx5_lag *ldev;
 	bool active;
 
-	ldev = dev->priv.lag;
+	ldev = mlx5_lag_dev(dev);
 	mutex_lock(&ldev->lock);
 	active = __mlx5_lag_is_active(ldev);
 	mutex_unlock(&ldev->lock);
@@ -77,7 +77,7 @@ static int flags_show(struct seq_file *file, void *priv)
 	bool shared_fdb;
 	bool lag_active;
 
-	ldev = dev->priv.lag;
+	ldev = mlx5_lag_dev(dev);
 	mutex_lock(&ldev->lock);
 	lag_active = __mlx5_lag_is_active(ldev);
 	if (!lag_active)
@@ -108,7 +108,7 @@ static int mapping_show(struct seq_file *file, void *priv)
 	int num_ports;
 	int i;
 
-	ldev = dev->priv.lag;
+	ldev = mlx5_lag_dev(dev);
 	mutex_lock(&ldev->lock);
 	lag_active = __mlx5_lag_is_active(ldev);
 	if (lag_active) {
@@ -142,7 +142,7 @@ static int members_show(struct seq_file *file, void *priv)
 	struct mlx5_lag *ldev;
 	int i;
 
-	ldev = dev->priv.lag;
+	ldev = mlx5_lag_dev(dev);
 	mutex_lock(&ldev->lock);
 	for (i = 0; i < ldev->ports; i++) {
 		if (!ldev->pf[i].dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index ad32b80e8501..b64c63e67a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1187,7 +1187,7 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 
 	tmp_dev = mlx5_get_next_phys_dev_lag(dev);
 	if (tmp_dev)
-		ldev = tmp_dev->priv.lag;
+		ldev = mlx5_lag_dev(tmp_dev);
 
 	if (!ldev) {
 		ldev = mlx5_lag_dev_alloc(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
index d2f840812942..d2fec7233df9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
@@ -58,7 +58,7 @@ static void mlx5_mpesw_work(struct work_struct *work)
 static int mlx5_lag_mpesw_queue_work(struct mlx5_core_dev *dev,
 				     enum mpesw_op op)
 {
-	struct mlx5_lag *ldev = dev->priv.lag;
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 	struct mlx5_mpesw_work_st *work;
 	int err = 0;
 
@@ -100,7 +100,7 @@ int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 			     struct net_device *out_dev,
 			     struct netlink_ext_ack *extack)
 {
-	struct mlx5_lag *ldev = mdev->priv.lag;
+	struct mlx5_lag *ldev = mlx5_lag_dev(mdev);
 
 	if (!netif_is_bond_master(out_dev) || !ldev)
 		return 0;
@@ -114,9 +114,10 @@ int mlx5_lag_mpesw_do_mirred(struct mlx5_core_dev *mdev,
 
 bool mlx5_lag_mpesw_is_activated(struct mlx5_core_dev *dev)
 {
+	struct mlx5_lag *ldev = mlx5_lag_dev(dev);
 	bool ret;
 
-	ret = dev->priv.lag && dev->priv.lag->mode == MLX5_LAG_MODE_MPESW;
+	ret = ldev && ldev->mode == MLX5_LAG_MODE_MPESW;
 	return ret;
 }
 
-- 
2.39.1

