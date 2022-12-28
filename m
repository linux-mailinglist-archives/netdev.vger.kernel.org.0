Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBCE658680
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 20:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiL1Tnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 14:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiL1Tnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 14:43:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C4910B5F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 11:43:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ABEC6CE11A1
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 19:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2894C433F1;
        Wed, 28 Dec 2022 19:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672256622;
        bh=SDGzMjbc2qKeirhcW7cr+b2DVqmZ3Y04vOm6Zu0WkEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJenbTvvOV+gOM32nQCCWEji0dqnsosPIHYiNQ7Mp5DZAQ/6lT8yYX0OcNzTAxXtD
         iHEtWWO8ZQIUOGlFbLCCeCtwUkQyng2scPR1Ojlbu0bZWi24uqV0hWbMl6AGNJdGmD
         zEQrzvkGdvtZLY3TrPgtzzP7sVS3tA7Q7lBvhYzbmhdNuwjdSVhtRBRgXudxv+e5Zi
         g4UKIXRaPFzi6dzGL5dXSDwGy6lyJC+ec8QtIZeYIT+ftVhFtOXAmjfX0Tr87wAjer
         9g1XsqDee2zvaMPY9B2gimwHmp5rnzG6NVrvAGi5TAZfJW2iNe/13YqHtrYRH267Ay
         wC1K0HKVEfDoQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net 04/12] net/mlx5: Avoid recovery in probe flows
Date:   Wed, 28 Dec 2022 11:43:23 -0800
Message-Id: <20221228194331.70419-5-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221228194331.70419-1-saeed@kernel.org>
References: <20221228194331.70419-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

Currently, recovery is done without considering whether the device is
still in probe flow.
This may lead to recovery before device have finished probed
successfully. e.g.: while mlx5_init_one() is running. Recovery flow is
using functionality that is loaded only by mlx5_init_one(), and there
is no point in running recovery without mlx5_init_one() finished
successfully.

Fix it by waiting for probe flow to finish and checking whether the
device is probed before trying to perform recovery.

Fixes: 51d138c2610a ("net/mlx5: Fix health error state handling")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 86ed87d704f7..96417c5feed7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -674,6 +674,12 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 	devlink = priv_to_devlink(dev);
 
+	mutex_lock(&dev->intf_state_mutex);
+	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
+		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		return;
+	}
+	mutex_unlock(&dev->intf_state_mutex);
 	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		devl_lock(devlink);
-- 
2.38.1

