Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3428E6B9D79
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjCNRuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjCNRuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:50:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EF89F214
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 312FDB81ACD
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDFCC4339E;
        Tue, 14 Mar 2023 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816196;
        bh=emD0XWY6TrgG/C8QLiwCv6+1PG8v7XgzUDp8yNRqPDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eg2d5OuvdqJSRwc+NRosYW+MNZ7tmcEhvRDm+8SUwLyfViQVecunzz8E6dpx4E518
         8DyeawTsT7LswyZPY0A5UZpns/24a/wtvSFfelod/oSx6srXjM+tJPBkdIo042Rtnz
         AnbFxSnMx+CGwmt3s/rodRUE5eWKbtiD1fhTjx2Bcu7hunnvktVFTczXapRoNZQGWr
         t8K6aU4zvLy6WfYijUIQln6GK+tBC9MmsGWhTy0iH7u/MkJOtvYMUWECi4PWPhGGWJ
         Lhx0vfY6kOOR/LqV5LMSCOFv5ixIDapXeH06A7wIWzhQ8DUAau6KZbpnxQbwLkkUSH
         eV5xT+c3LmQWw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Dan Carpenter <error27@gmail.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net 12/14] net/mlx5e: TC, fix missing error code
Date:   Tue, 14 Mar 2023 10:49:38 -0700
Message-Id: <20230314174940.62221-13-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

Missing error code when mlx5e_tc_act_stats_create fails

Fixes: d13674b1d14c ("net/mlx5e: TC, map tc action cookie to a hw counter")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index cc35cbc9934d..d2e191ee0704 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5305,8 +5305,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	mlx5e_tc_debugfs_init(tc, mlx5e_fs_get_debugfs_root(priv->fs));
 
 	tc->action_stats_handle = mlx5e_tc_act_stats_create();
-	if (IS_ERR(tc->action_stats_handle))
+	if (IS_ERR(tc->action_stats_handle)) {
+		err = PTR_ERR(tc->action_stats_handle);
 		goto err_act_stats;
+	}
 
 	return 0;
 
@@ -5441,8 +5443,10 @@ int mlx5e_tc_esw_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	}
 
 	uplink_priv->action_stats_handle = mlx5e_tc_act_stats_create();
-	if (IS_ERR(uplink_priv->action_stats_handle))
+	if (IS_ERR(uplink_priv->action_stats_handle)) {
+		err = PTR_ERR(uplink_priv->action_stats_handle);
 		goto err_action_counter;
+	}
 
 	return 0;
 
-- 
2.39.2

