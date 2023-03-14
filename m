Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1536B9D6E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjCNRuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjCNRtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:49:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EE8AB893
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:49:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3807261877
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3610C433EF;
        Tue, 14 Mar 2023 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678816191;
        bh=ba2UoXyL9x0z24IIGlyl2qt8Jgeb9/iVQJL4foOtBYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnyRlt6JSlr6Z95hCrfLd7Mm8/k6aUqw1JZbejNHSd5FlbFYPy+mW/ysWSf2n/a3B
         LE9asQQXsvegPW0YMTzQKpTNmSlwTX2sQatG9NGiMFM8z890UAGbtkzW9y0ndjRaJ3
         r1weu+QnKOTGy32DutzvMNqSS1laJsm1BwowGPzJqEXTAjmakB1Jzv6eBz792SuGlo
         TFWpQkNCc8xoBm4N6BOOyJxDP8/YHPNefDWQjiMZs7pEKwXYWybsMO3uhTTNjVt6lW
         DsYhL8q+82kiqXiPM2xnJ1xeyURFUCDz+P13TyfXSOXBq4qY7vwUMDZjmSlmMrcYyJ
         rekOF4XREeBxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: [net 04/14] net/mlx5: Disable eswitch before waiting for VF pages
Date:   Tue, 14 Mar 2023 10:49:30 -0700
Message-Id: <20230314174940.62221-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314174940.62221-1-saeed@kernel.org>
References: <20230314174940.62221-1-saeed@kernel.org>
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

