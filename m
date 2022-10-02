Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688445F215D
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJBFOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiJBFN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAD75072E
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE05760DB6
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E82AC433D7;
        Sun,  2 Oct 2022 05:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687637;
        bh=bkZ0MdXRs2ajD82qjFXhXOtdYThh8oLPrJlcL7NQBXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgxIa2lY5yG4MSra1O3MwT8FfVepVnSD0PSNdP8OO8BBtuXDr+wCdB0Kuy081PMwl
         04AkUC0RO4+MmkOQgk74PUaUIN4yLlfh+3Ksd3zq2zSvlMHloFKbDoPQxD7iyN12WE
         fVb+NRIvvECQOXZOkJAh8pDpfmGgz0xhPztAwbma7kQxqHXtLeV/CjFt6aytBI1SHl
         JdfOKLMI2XKpia8/DZ8H/t1Pugb1EZqG9UmU9aEF8zc7UfSbwOdHfEJRcqGGY6/Fm8
         QlzFECldfdjjYokqJnIgwDyj7ywZHIxPLIPUG6EQfMngtSA+jdIFOMzHo0KHdnIwNQ
         e7WM/3reh3r+w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next 02/15] net/mlx5e: xsk: Set napi_id to support busy polling
Date:   Sat,  1 Oct 2022 21:56:19 -0700
Message-Id: <20221002045632.291612-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
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

xdp_rxq_info_reg should get the actual napi_id, not 0, in order to
support socket busy polling properly.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 10428ade96c1..3ee8295c2115 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -539,7 +539,7 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	if (err)
 		return err;
 
-	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, 0);
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
 }
 
 static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
-- 
2.37.3

