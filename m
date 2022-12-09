Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA8647A9F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiLIAP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLIAO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5091B8F711
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED631B826A7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEC1C433EF;
        Fri,  9 Dec 2022 00:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544885;
        bh=d4Lmn6EMzEWjxtz5yB7zSXwoiE5nIDuRkZyXwrlAJ5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FfU2mymLAeWnScJSxCU5m48gPIFb2+ValjZFN9CUtQbVpiFbbXen6MHajKbzTiP2k
         sYDx5NCPOiRAyUFg79/MsxEI5LNxCQJKFmbWrab7KVeQJ/PtE2aSPiYuPzRzql+/Jw
         mlD77vBzPE+mJEsjQbSDh57I+UpLkaRNkjrGIMkFfz+em6YgLU6xyifT1Lec4NBlgu
         7jLXcSv89nFLH6o2mWnixHVa8Z13helzWNaKrCYk1/I0x2C+MAhqro88PPqYnZJVR7
         S/RRBsYEX9qmCUR/W1Hr/GeeKtj2nDTPwpOpEuBKYsN+1BVJBDSgwBPaQYc2LGI+mK
         VCFEJVQwhHMFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: multipath, support routes with more than 2 nexthops
Date:   Thu,  8 Dec 2022 16:14:18 -0800
Message-Id: <20221209001420.142794-14-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Today multipath offload is only supported when the number of
nexthops is 2 which block the use of it in case of system with
2 NICs.

This patch solve it by enabling multipath offload per NIC if
2 nexthops of the route are its uplinks.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/mp.c  | 79 +++++++++++--------
 1 file changed, 48 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
index 0259a149a64c..d9fcb9ed726f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c
@@ -118,13 +118,41 @@ struct mlx5_fib_event_work {
 	};
 };
 
+static struct net_device*
+mlx5_lag_get_next_fib_dev(struct mlx5_lag *ldev,
+			  struct fib_info *fi,
+			  struct net_device *current_dev)
+{
+	struct net_device *fib_dev;
+	int i, ldev_idx, nhs;
+
+	nhs = fib_info_num_path(fi);
+	i = 0;
+	if (current_dev) {
+		for (; i < nhs; i++) {
+			fib_dev = fib_info_nh(fi, i)->fib_nh_dev;
+			if (fib_dev == current_dev) {
+				i++;
+				break;
+			}
+		}
+	}
+	for (; i < nhs; i++) {
+		fib_dev = fib_info_nh(fi, i)->fib_nh_dev;
+		ldev_idx = mlx5_lag_dev_get_netdev_idx(ldev, fib_dev);
+		if (ldev_idx >= 0)
+			return ldev->pf[ldev_idx].netdev;
+	}
+
+	return NULL;
+}
+
 static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 				     struct fib_entry_notifier_info *fen_info)
 {
+	struct net_device *nh_dev0, *nh_dev1;
 	struct fib_info *fi = fen_info->fi;
 	struct lag_mp *mp = &ldev->lag_mp;
-	struct fib_nh *fib_nh0, *fib_nh1;
-	unsigned int nhs;
 
 	/* Handle delete event */
 	if (event == FIB_EVENT_ENTRY_DEL) {
@@ -140,16 +168,25 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 	    fi->fib_priority >= mp->fib.priority)
 		return;
 
+	nh_dev0 = mlx5_lag_get_next_fib_dev(ldev, fi, NULL);
+	nh_dev1 = mlx5_lag_get_next_fib_dev(ldev, fi, nh_dev0);
+
 	/* Handle add/replace event */
-	nhs = fib_info_num_path(fi);
-	if (nhs == 1) {
-		if (__mlx5_lag_is_active(ldev)) {
-			struct fib_nh *nh = fib_info_nh(fi, 0);
-			struct net_device *nh_dev = nh->fib_nh_dev;
-			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev);
+	if (!nh_dev0) {
+		if (mp->fib.dst == fen_info->dst && mp->fib.dst_len == fen_info->dst_len)
+			mp->fib.mfi = NULL;
+		return;
+	}
 
-			if (i < 0)
-				return;
+	if (nh_dev0 == nh_dev1) {
+		mlx5_core_warn(ldev->pf[MLX5_LAG_P1].dev,
+			       "Multipath offload doesn't support routes with multiple nexthops of the same device");
+		return;
+	}
+
+	if (!nh_dev1) {
+		if (__mlx5_lag_is_active(ldev)) {
+			int i = mlx5_lag_dev_get_netdev_idx(ldev, nh_dev0);
 
 			i++;
 			mlx5_lag_set_port_affinity(ldev, i);
@@ -159,21 +196,6 @@ static void mlx5_lag_fib_route_event(struct mlx5_lag *ldev, unsigned long event,
 		return;
 	}
 
-	if (nhs != 2)
-		return;
-
-	/* Verify next hops are ports of the same hca */
-	fib_nh0 = fib_info_nh(fi, 0);
-	fib_nh1 = fib_info_nh(fi, 1);
-	if (!(fib_nh0->fib_nh_dev == ldev->pf[MLX5_LAG_P1].netdev &&
-	      fib_nh1->fib_nh_dev == ldev->pf[MLX5_LAG_P2].netdev) &&
-	    !(fib_nh0->fib_nh_dev == ldev->pf[MLX5_LAG_P2].netdev &&
-	      fib_nh1->fib_nh_dev == ldev->pf[MLX5_LAG_P1].netdev)) {
-		mlx5_core_warn(ldev->pf[MLX5_LAG_P1].dev,
-			       "Multipath offload require two ports of the same HCA\n");
-		return;
-	}
-
 	/* First time we see multipath route */
 	if (!mp->fib.mfi && !__mlx5_lag_is_active(ldev)) {
 		struct lag_tracker tracker;
@@ -268,7 +290,6 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	struct mlx5_fib_event_work *fib_work;
 	struct fib_entry_notifier_info *fen_info;
 	struct fib_nh_notifier_info *fnh_info;
-	struct net_device *fib_dev;
 	struct fib_info *fi;
 
 	if (info->family != AF_INET)
@@ -285,11 +306,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		fi = fen_info->fi;
 		if (fi->nh)
 			return NOTIFY_DONE;
-		fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
-		if (fib_dev != ldev->pf[MLX5_LAG_P1].netdev &&
-		    fib_dev != ldev->pf[MLX5_LAG_P2].netdev) {
-			return NOTIFY_DONE;
-		}
+
 		fib_work = mlx5_lag_init_fib_work(ldev, event);
 		if (!fib_work)
 			return NOTIFY_DONE;
-- 
2.38.1

