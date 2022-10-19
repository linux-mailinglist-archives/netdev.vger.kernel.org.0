Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B4B6039E6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJSGje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiJSGjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:39:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBA56F54A
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA40361780
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381D0C43470;
        Wed, 19 Oct 2022 06:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161528;
        bh=IFNo5RdpG7AHcX8bFrPO0F7pMMmXawwb4r4LICt6uBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHGo3nvHuWsT5YR6GivLWhMgQLoto9EI7jyyAmcmEy3EyPgZ1mBuMTxqo1bZQcTdT
         AK/6FJ34GMzyby2ZOUdVW0OXzCquFasWDkX+P+ku1xJtQlNv89cXylgbYgC4ib9ppu
         YcqnYiADETCnEzQIw+SCBp9DzjsWoIIt04g13Kno8zw7GfLbnCE5Gd9fXxmuM6effL
         zY6dLA1t7g1g3yVb2NP5QsI/Omdoc1IkZ9XZGPkNH6hsW0NlaCMbiDdwXUHR9qDRzh
         Xdr6x9qBANCSuQLEzFx7J46DBBq4ABXz0IYlyFysxRtS7sVeuHxcJvY9u1+0BuDJ9W
         CW6H0GKguNQEg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [net 14/16] net/mlx5e: Fix macsec rx security association (SA) update/delete
Date:   Tue, 18 Oct 2022 23:38:11 -0700
Message-Id: <20221019063813.802772-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited commit adds the support for update/delete MACsec Rx SA,
naturally, these operations need to check if the SA in question exists
to update/delete the SA and return error code otherwise, however they
do just the opposite i.e. return with error if the SA exists

Fix by change the check to return error in case the SA in question does
not exist, adjust error message and code accordingly.

Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index d111e86afe72..975fedf6bfd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -999,11 +999,11 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 	}
 
 	rx_sa = rx_sc->rx_sa[assoc_num];
-	if (rx_sa) {
+	if (!rx_sa) {
 		netdev_err(ctx->netdev,
-			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   "MACsec offload rx_sc sci %lld rx_sa %d doesn't exist\n",
 			   sci, assoc_num);
-		err = -EEXIST;
+		err = -EINVAL;
 		goto out;
 	}
 
@@ -1055,11 +1055,11 @@ static int mlx5e_macsec_del_rxsa(struct macsec_context *ctx)
 	}
 
 	rx_sa = rx_sc->rx_sa[assoc_num];
-	if (rx_sa) {
+	if (!rx_sa) {
 		netdev_err(ctx->netdev,
-			   "MACsec offload rx_sc sci %lld rx_sa %d already exist\n",
+			   "MACsec offload rx_sc sci %lld rx_sa %d doesn't exist\n",
 			   sci, assoc_num);
-		err = -EEXIST;
+		err = -EINVAL;
 		goto out;
 	}
 
-- 
2.37.3

