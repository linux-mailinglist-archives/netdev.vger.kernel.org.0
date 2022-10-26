Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4665B60E2AB
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiJZNyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiJZNxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:53:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631CC109D40
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0006861EB1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947B7C433C1;
        Wed, 26 Oct 2022 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792372;
        bh=bwX3dE+l3xsZYEto6hXAFz362lOOdVcg/Uvu97+QNKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSwUV9lW9haC5m63tSojNYZX8pR3C9aIclC1GfOQMB/GCCUuBhPVZcdB72Y8xWEZh
         +TCflFMZN+yB0N+4YRLmYSuV0G+GyLbwJUm5X1nOsQP6RdqZyq7XWXzCHW0G7VOzOp
         LRG4WCZ5ajkh5AeNe0r1lTaRakrtiVu221na10jYnsP+CwRph+8UHSp9iMATXAQeTL
         U2J6HTgxmJxF0i4/9LOIocXm6Fj6jxeOfKBJn3FI34u7/ICqNOM2W9Ybu6rvWDYP3L
         CRju/CFg2P4kucNrI8tEogFamztpI4aP3j4PAJbZe3aNWp7ZtRd2JyVdv0fV+/dgeU
         tXxqGoBz+bpFQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>
Subject: [V4 net 12/15] net/mlx5e: Fix macsec coverity issue at rx sa update
Date:   Wed, 26 Oct 2022 14:51:50 +0100
Message-Id: <20221026135153.154807-13-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited commit at update rx sa operation passes object attributes
to MACsec object create function without initializing/setting all
attributes fields leaving some of them with garbage values, therefore
violating the implicit assumption at create object function, which
assumes that all input object attributes fields are set.

Fix by initializing the object attributes struct to zero, thus leaving
unset fields with the legal zero value.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 4331235b21ee..250c878ba2c9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -432,7 +432,7 @@ static int mlx5e_macsec_update_rx_sa(struct mlx5e_macsec *macsec,
 				     bool active)
 {
 	struct mlx5_core_dev *mdev = macsec->mdev;
-	struct mlx5_macsec_obj_attrs attrs;
+	struct mlx5_macsec_obj_attrs attrs = {};
 	int err = 0;
 
 	if (rx_sa->active != active)
-- 
2.37.3

