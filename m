Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BE15649D2
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 22:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiGCUy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 16:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGCUy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 16:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C355581;
        Sun,  3 Jul 2022 13:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 235B3611B8;
        Sun,  3 Jul 2022 20:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FE7C341CB;
        Sun,  3 Jul 2022 20:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656881665;
        bh=YKK1KNzCTUm1o7hPTaB/4GkwUF8LldvKteTLBJp9ags=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lO3seAJkfmjE9pB71qGmwCcR72k6ctgQeYqI0ptYkPYQDPrYBlQzsjK3Xc63WjuLf
         RpJupDau4Es+uUP55Sn/Q8d4fpGRVILhwG2pA1m+9BYCfMGAP/TImF5kVj6OSa1MxY
         gK3t8PQhqwO32C717acik3drSSY6Lun3tRbU+CJM0qD5Htemk6Q6eqQ5Yly4C3QI/u
         mn2oLoz6YKQeAMjV9vx5kLhYa2JVy5Nsnxu8UpHk5FWaSN7755CnIbsBqveg4AOxG7
         a7125dvVUiWC3vOtLwHWgt7tFiMJdwl1xZZ5io3qqohq2CixbRMdUueO7NyR06thMB
         hwIkO5FwNFZEQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [PATCH rdma-next 4/5] RDMA/mlx5: Refactor get flow table function
Date:   Sun,  3 Jul 2022 13:54:06 -0700
Message-Id: <20220703205407.110890-5-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220703205407.110890-1-saeed@kernel.org>
References: <20220703205407.110890-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

_get_flow_table() requires the entire matcher being passed
while all it needs is the priority and namespace type.
Pass the priority and namespace type directly instead.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 39ffb363ba0c..b1402aea29c1 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -1407,8 +1407,8 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
 }
 
 static struct mlx5_ib_flow_prio *
-_get_flow_table(struct mlx5_ib_dev *dev,
-		struct mlx5_ib_flow_matcher *fs_matcher,
+_get_flow_table(struct mlx5_ib_dev *dev, u16 user_priority,
+		enum mlx5_flow_namespace_type ns_type,
 		bool mcast)
 {
 	struct mlx5_flow_namespace *ns = NULL;
@@ -1421,11 +1421,11 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 	if (mcast)
 		priority = MLX5_IB_FLOW_MCAST_PRIO;
 	else
-		priority = ib_prio_to_core_prio(fs_matcher->priority, false);
+		priority = ib_prio_to_core_prio(user_priority, false);
 
 	esw_encap = mlx5_eswitch_get_encap_mode(dev->mdev) !=
 		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
-	switch (fs_matcher->ns_type) {
+	switch (ns_type) {
 	case MLX5_FLOW_NAMESPACE_BYPASS:
 		max_table_size = BIT(
 			MLX5_CAP_FLOWTABLE_NIC_RX(dev->mdev, log_max_ft_size));
@@ -1452,17 +1452,17 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 					       reformat_l3_tunnel_to_l2) &&
 		    esw_encap)
 			flags |= MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
-		priority = fs_matcher->priority;
+		priority = user_priority;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX:
 		max_table_size = BIT(
 			MLX5_CAP_FLOWTABLE_RDMA_RX(dev->mdev, log_max_ft_size));
-		priority = fs_matcher->priority;
+		priority = user_priority;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		max_table_size = BIT(
 			MLX5_CAP_FLOWTABLE_RDMA_TX(dev->mdev, log_max_ft_size));
-		priority = fs_matcher->priority;
+		priority = user_priority;
 		break;
 	default:
 		break;
@@ -1470,11 +1470,11 @@ _get_flow_table(struct mlx5_ib_dev *dev,
 
 	max_table_size = min_t(int, max_table_size, MLX5_FS_MAX_ENTRIES);
 
-	ns = mlx5_get_flow_namespace(dev->mdev, fs_matcher->ns_type);
+	ns = mlx5_get_flow_namespace(dev->mdev, ns_type);
 	if (!ns)
 		return ERR_PTR(-EOPNOTSUPP);
 
-	switch (fs_matcher->ns_type) {
+	switch (ns_type) {
 	case MLX5_FLOW_NAMESPACE_BYPASS:
 		prio = &dev->flow_db->prios[priority];
 		break;
@@ -1618,7 +1618,8 @@ static struct mlx5_ib_flow_handler *raw_fs_rule_add(
 	mcast = raw_fs_is_multicast(fs_matcher, cmd_in);
 	mutex_lock(&dev->flow_db->lock);
 
-	ft_prio = _get_flow_table(dev, fs_matcher, mcast);
+	ft_prio = _get_flow_table(dev, fs_matcher->priority,
+				  fs_matcher->ns_type, mcast);
 	if (IS_ERR(ft_prio)) {
 		err = PTR_ERR(ft_prio);
 		goto unlock;
-- 
2.36.1

