Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56E8417B44
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242384AbhIXStx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236288AbhIXStv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D1661265;
        Fri, 24 Sep 2021 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509298;
        bh=20xrDWBOWXmliyRnwAk0JvDBIwt5j+U5UhKjXiFVbO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Go2SnkmhPcmtATZEEaD/h9mrs8oB4RvAjOZV0wSfNmkdjCu47GuZHU4xm5XuzlLcs
         61v9o9pxg2QeD3OUc0l2tx2Spy3Qd0J1gxHFIkE/v3Yp/2xZiqAeGX4pZ1fb2wZKDR
         rd9Ha33warC4Wj9RnOFpgPusPVPjxM4KWVlXgUc75oSx2k/hG+8elUc15hnXs7xdZc
         Uq/Y/hpY/mYIKshEyHWrVVkwI6ruxL5jmtnLTlNd1fDC6SBbSgQBk3UI3o7HkXVibJ
         u3dlzm2mKIiUSOJ11WtPPZzpaCU6sQcsLmWSaEV7v6DvlOjt19mJE2n1QEZnBYIRus
         sZxCa09A66ysg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/12] net/mlx5e: Add error flow for ethtool -X command
Date:   Fri, 24 Sep 2021 11:47:58 -0700
Message-Id: <20210924184808.796968-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Prior to this patch, ethtool -X fail but the user receives a success
status. Try to roll-back when failing and return success status
accordingly.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rss.c  | 27 +++++++++++++++----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
index 625cd49ef96c..b8b481b335cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rss.c
@@ -391,7 +391,7 @@ int mlx5e_rss_obtain_tirn(struct mlx5e_rss *rss,
 	return 0;
 }
 
-static void mlx5e_rss_apply(struct mlx5e_rss *rss, u32 *rqns, unsigned int num_rqns)
+static int mlx5e_rss_apply(struct mlx5e_rss *rss, u32 *rqns, unsigned int num_rqns)
 {
 	int err;
 
@@ -399,6 +399,7 @@ static void mlx5e_rss_apply(struct mlx5e_rss *rss, u32 *rqns, unsigned int num_r
 	if (err)
 		mlx5e_rss_warn(rss->mdev, "Failed to redirect RQT %#x to channels: err = %d\n",
 			       mlx5e_rqt_get_rqtn(&rss->rqt), err);
+	return err;
 }
 
 void mlx5e_rss_enable(struct mlx5e_rss *rss, u32 *rqns, unsigned int num_rqns)
@@ -490,6 +491,14 @@ int mlx5e_rss_set_rxfh(struct mlx5e_rss *rss, const u32 *indir,
 {
 	bool changed_indir = false;
 	bool changed_hash = false;
+	struct mlx5e_rss *old_rss;
+	int err = 0;
+
+	old_rss = mlx5e_rss_alloc();
+	if (!old_rss)
+		return -ENOMEM;
+
+	*old_rss = *rss;
 
 	if (hfunc && *hfunc != rss->hash.hfunc) {
 		switch (*hfunc) {
@@ -497,7 +506,8 @@ int mlx5e_rss_set_rxfh(struct mlx5e_rss *rss, const u32 *indir,
 		case ETH_RSS_HASH_TOP:
 			break;
 		default:
-			return -EINVAL;
+			err = -EINVAL;
+			goto out;
 		}
 		changed_hash = true;
 		changed_indir = true;
@@ -520,13 +530,20 @@ int mlx5e_rss_set_rxfh(struct mlx5e_rss *rss, const u32 *indir,
 			rss->indir.table[i] = indir[i];
 	}
 
-	if (changed_indir && rss->enabled)
-		mlx5e_rss_apply(rss, rqns, num_rqns);
+	if (changed_indir && rss->enabled) {
+		err = mlx5e_rss_apply(rss, rqns, num_rqns);
+		if (err) {
+			*rss = *old_rss;
+			goto out;
+		}
+	}
 
 	if (changed_hash)
 		mlx5e_rss_update_tirs(rss);
 
-	return 0;
+out:
+	mlx5e_rss_free(old_rss);
+	return err;
 }
 
 struct mlx5e_rss_params_hash mlx5e_rss_get_hash(struct mlx5e_rss *rss)
-- 
2.31.1

