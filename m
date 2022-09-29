Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FED5EEEE0
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbiI2HX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiI2HW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:22:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9071C118DE5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B863662062
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F77C433D7;
        Thu, 29 Sep 2022 07:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664436173;
        bh=Qvckc+zAeLwwFVpqblPRR/vLxKr6P0VeVZAZiM65WM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha2Wi351MMk9AQ6yM85TX/f1kUnB6e8NUne/cTrPm4n0Zj/Z5eKq2wlxtPO8wqtZE
         UL/kZMmn5lwVGiR7QD07M2ZUsYbBgkkoFhumz6MKu7fWlPrFRckyZOQP10rjnZUYvk
         sKZqHfMTf4ECcLxOPD3P4LmsOyv46cUpd0UEKYNwT+Q7HwahW4vBWrbMJsftrBjwqK
         yUcm4UCjwp8GvY9u3PvblOw6Xe4VKegWpcy+DmvE4FFG+sird2M6AzGXVtAYvHpUuL
         eLJ8dkTh3/vw5Lguesv4nMRGFvH6z7KXdxoj7pct974jSPPpRW4MxYb4mXX7Ozawx2
         JEU5p9yo6rHQg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 15/16] net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover
Date:   Thu, 29 Sep 2022 00:21:55 -0700
Message-Id: <20220929072156.93299-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220929072156.93299-1-saeed@kernel.org>
References: <20220929072156.93299-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

The same clear_bit is called in both error and success flows. Move the
call to do it only once and remove the out label.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index fc366e66d0b0..2b946ae1d97f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -162,10 +162,10 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	mlx5e_free_rx_descs(rq);
 
 	err = mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	if (err)
-		goto out;
+		return err;
 
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
 	if (rq->channel)
@@ -173,9 +173,6 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	else
 		mlx5e_trigger_napi_sched(rq->cq.napi);
 	return 0;
-out:
-	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
-	return err;
 }
 
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
-- 
2.37.3

