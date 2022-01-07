Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53210486ED8
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344307AbiAGAai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbiAGAaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98F8C034004
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAD4961E58
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B0CC36AE5;
        Fri,  7 Jan 2022 00:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515417;
        bh=w4UKxDSYkMatP3++oV28OmnmA1HGllYm09xOxtcXDHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVa35IqlBTdmxIxmh2HUWD9hIdlLbF2H4aetB3B78L3Q/gG5zq9QUplVqYet7jMoa
         CNLU6glwgUaFJJSUwOHMB4rrJrzyw7ax33iQD0v0JVeBkRsYu9tDvFK8HFrz+4Sa1E
         1EoBmzOexQq0TwgzvqDs3N5oJcSQUBLhCKeGGrTfcUOisNH5TqTW92tcolyA0sy3vL
         /Ud5xJOpmE5Wx/tFLmXPdA0EQd3BxXiUxFOSkzucQ6rTh/wWG4ADQBV56amAGgstCH
         nPuwdLItQ+rKYGEdr2t08OJp+3LbHk/Gl4WdT3oQQHXrhGdbxaQyB1mpDszgZRJ7Ij
         uBUOE6P3oFRkQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 14/15] net/mlx5e: Add recovery flow in case of error CQE
Date:   Thu,  6 Jan 2022 16:29:55 -0800
Message-Id: <20220107002956.74849-15-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The rep legacy RQ completion handling was missing the appropriate
handling of error CQEs (dump the CQE and queue a recover work), fix it
by calling trigger_report() when needed.

Since all CQE handling flows do the exact same error CQE handling,
extract it to a common helper function.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f09b57c31ed7..96e260fd7987 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1603,6 +1603,12 @@ static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	}
 }
 
+static void mlx5e_handle_rx_err_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	trigger_report(rq, cqe);
+	rq->stats->wqe_err++;
+}
+
 static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
@@ -1616,8 +1622,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
-		trigger_report(rq, cqe);
-		rq->stats->wqe_err++;
+		mlx5e_handle_rx_err_cqe(rq, cqe);
 		goto free_wqe;
 	}
 
@@ -1670,7 +1675,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	cqe_bcnt = be32_to_cpu(cqe->byte_cnt);
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
-		rq->stats->wqe_err++;
+		mlx5e_handle_rx_err_cqe(rq, cqe);
 		goto free_wqe;
 	}
 
@@ -1719,8 +1724,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	wi->consumed_strides += cstrides;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
-		trigger_report(rq, cqe);
-		rq->stats->wqe_err++;
+		mlx5e_handle_rx_err_cqe(rq, cqe);
 		goto mpwrq_cqe_out;
 	}
 
@@ -1988,8 +1992,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 	wi->consumed_strides += cstrides;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
-		trigger_report(rq, cqe);
-		stats->wqe_err++;
+		mlx5e_handle_rx_err_cqe(rq, cqe);
 		goto mpwrq_cqe_out;
 	}
 
@@ -2058,8 +2061,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	wi->consumed_strides += cstrides;
 
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
-		trigger_report(rq, cqe);
-		rq->stats->wqe_err++;
+		mlx5e_handle_rx_err_cqe(rq, cqe);
 		goto mpwrq_cqe_out;
 	}
 
-- 
2.33.1

