Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8623660FAEC
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiJ0O5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235785AbiJ0O5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:57:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2183BB5FC5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:57:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1A4A62367
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96393C433C1;
        Thu, 27 Oct 2022 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666882636;
        bh=6CaUmj3FhSpm8fEwvMsuN+OoSdxQ5Y9l4u26V4MyB2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIUZbJKyJC/cXVtIWivQ3ybgApDPfnhc9nwLvT/tCYbrCs690xs//2BwzHWCzQw8S
         IWP/AYDgDommzzEC0xwcDf3Be4g4Nb3TbfD2wbPAO74K+lrTSl1LzgjOZUf2/yrAYn
         cISFeOoejjJAtgMjWIbTjSBNTcfZ0gdeHt6ScJGs5MsA9slqRRjPPVmnVaruPicOBW
         Vb5MTvOpMeHmBVuLu0TeapSNTeNL/hNKfGUR+tlmxL03NmGPou9gVY9VvEDpgb1G4U
         PhvCyGVCF+YzgWBQSCt10bmvcW3OmE2xMGso0z9s6Y/vjkvHyfVWQgceFw6uICEtWN
         woBbum2PGpcnQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next V2 03/14] net/mlx5: DR, Check device state when polling CQ
Date:   Thu, 27 Oct 2022 15:56:32 +0100
Message-Id: <20221027145643.6618-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221027145643.6618-1-saeed@kernel.org>
References: <20221027145643.6618-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Calling fast teardown as part of the normal unloading caused
a problem with SW steering - SW steering still needs to clear
its tables, write to ICM and poll for completions.
When teardown has been done, SW steering keeps polling the CQ
forever, because nobody flushes it.

This patch fixes the issue by checking the device state in
cases where no CQE was returned.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index ef19a66f5233..6ad026123b16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -78,8 +78,15 @@ static int dr_cq_poll_one(struct mlx5dr_cq *dr_cq)
 	int err;
 
 	cqe64 = mlx5_cqwq_get_cqe(&dr_cq->wq);
-	if (!cqe64)
+	if (!cqe64) {
+		if (unlikely(dr_cq->mdev->state ==
+			     MLX5_DEVICE_STATE_INTERNAL_ERROR)) {
+			mlx5_core_dbg_once(dr_cq->mdev,
+					   "Polling CQ while device is shutting down\n");
+			return CQ_POLL_ERR;
+		}
 		return CQ_EMPTY;
+	}
 
 	mlx5_cqwq_pop(&dr_cq->wq);
 	err = dr_parse_cqe(dr_cq, cqe64);
@@ -833,6 +840,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 
 	cq->mcq.vector = 0;
 	cq->mcq.uar = uar;
+	cq->mdev = mdev;
 
 	return cq;
 
-- 
2.37.3

