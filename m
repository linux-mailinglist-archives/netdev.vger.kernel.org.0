Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C742760B0AD
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbiJXQHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiJXQF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:05:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBC611DAA0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 07:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D9EEB81A94
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 14:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70215C433D6;
        Mon, 24 Oct 2022 14:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666620020;
        bh=6CaUmj3FhSpm8fEwvMsuN+OoSdxQ5Y9l4u26V4MyB2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDQSH/1f0SGKTufmS75mHx6a9RG5eQbAYSKbw7HMmGCV41+TbLq/0l4Ut8WM+uLCZ
         NmhMiwejdX+QBHk25QGoZLeN9NyuIgyuS8h5VmSPr+nZUegZWqKJuZu9Av/Yj5l3eB
         NVRJZD5nLbpQaLhQZ0+AQ6zx44m5pd0p7wPVGwzNaO1IOCBVFzwQSCGy0tM8VAtcL9
         23lYp3OHll53eSQEF06qE07DsMidSb18ITjhMLC5gdmdmQ1xr+EwABL7qwvWJAhP9f
         hZhmnebx1hdoJ50qTJhes3hgV4yBybA4jxhDe/+QTeKznOYPrL5vxvLXtuqbvCtjBp
         3D+2doas8WXGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 03/14] net/mlx5: DR, Check device state when polling CQ
Date:   Mon, 24 Oct 2022 14:57:23 +0100
Message-Id: <20221024135734.69673-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024135734.69673-1-saeed@kernel.org>
References: <20221024135734.69673-1-saeed@kernel.org>
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

