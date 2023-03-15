Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB256BC048
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbjCOW7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbjCOW6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:58:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4978A80923
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F26E2B81F99
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F87C433A7;
        Wed, 15 Mar 2023 22:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921132;
        bh=1FanTjRApBmxnQMaLKLL/xQZKnEOSDBAUo9nOaNMJeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jU51F80/9vUiOBn+RocHeBDASGgGsrFdcsULigvo/mxnZL7yS58KyePric9yuAWtZ
         mhTOISk4jiUeSE7ZOhK4g1lv150Iqfm8GikzPSbjwh73KlQv22rigDqnjtFCnbvO8/
         2Q2wGnlSd3/f8fkTQ8SsLNlq3uR7RM6/PK1HaWVXcIJ7LTyh6Jpr9yXbQbLGdARAGQ
         8N3AVxOT5LkpdOf89U1DI1wpuW8sFrj8bzWsjhwHfz2dI3OWfPosVC3boOVYtvQx9d
         U4z6EWCj+pYdWTg6ek/HTw7dWD9Bz3qna+mC6F6jcJ7LT8RjIANNVf1e5DEl2TucQe
         +h1DO85vrA1Gw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: [net V2 04/14] net/mlx5: Disable eswitch before waiting for VF pages
Date:   Wed, 15 Mar 2023 15:58:37 -0700
Message-Id: <20230315225847.360083-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
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

From: Daniel Jurgens <danielj@nvidia.com>

The offending commit changed the ordering of moving to legacy mode and
waiting for the VF pages. Moving to legacy mode is important in
bluefield, because it sends the host driver into error state, and frees
its pages. Without this transition we end up waiting 2 minutes for
pages that aren't coming before carrying on with the unload process.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 540840e80493..f36a3aa4b5c8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1364,8 +1364,8 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 {
 	mlx5_devlink_traps_unregister(priv_to_devlink(dev));
 	mlx5_sf_dev_table_destroy(dev);
-	mlx5_sriov_detach(dev);
 	mlx5_eswitch_disable(dev->priv.eswitch);
+	mlx5_sriov_detach(dev);
 	mlx5_lag_remove_mdev(dev);
 	mlx5_ec_cleanup(dev);
 	mlx5_sf_hw_table_destroy(dev);
-- 
2.39.2

