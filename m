Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27EB6039DD
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJSGjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiJSGiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174396DF82
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4443AB8223F
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39EAC433C1;
        Wed, 19 Oct 2022 06:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161520;
        bh=0h94l9YOdj9P/2b8gUDf5pTe4YpWtfs4WGuTnJIs3xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODN6AktRqJjvSNRnpvtaFxbVUE4LbNxR7rNKez09SCN7BOA4Lh5Cj4V3OjeiM1Bjh
         cxmarSLyygVrN9g8KMN9yYaWJ74QAT21wDh4CdrZgJNB7PXztNSlYRmRdSgxZl97xg
         xZIfh3E6IIJFuH0+6NUW/iVt/En5Mz9gyVG6hcYbVyM8dP6houzfeRE5wsgV8nHxG+
         W6NTQ/WL2bJV+cgeQltpzwBsUmq/d+UHxM9m3o90nlMRIH9gn9f5Y5n8JKq9cTO8wA
         5TryApd0SsnZJQbht3OpuSD2m8K5wT0TDgwExo3Q+EEvttJPWNWOvlsASCb+wOdPXe
         7Hjz3voPVmIbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net 06/16] net/mlx5: ASO, Create the ASO SQ with the correct timestamp format
Date:   Tue, 18 Oct 2022 23:38:03 -0700
Message-Id: <20221019063813.802772-7-saeed@kernel.org>
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

From: Saeed Mahameed <saeedm@nvidia.com>

mlx5 SQs must select the timestamp format explicitly according to the
active clock mode, select the current active timestamp mode so ASO SQ create
will succeed.

This fixes the following error prints when trying to create ipsec ASO SQ
while the timestamp format is real time mode.

mlx5_cmd_out_err:778:(pid 34874): CREATE_SQ(0x904) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0xd61c0b), err(-22)
mlx5_aso_create_sq:285:(pid 34874): Failed to open aso wq sq, err=-22
mlx5e_ipsec_init:436:(pid 34874): IPSec initialization failed, -22

Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index baa8092f335e..c971ff04dd04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/transobj.h>
+#include "clock.h"
 #include "aso.h"
 #include "wq.h"
 
@@ -179,6 +180,7 @@ static int create_aso_sq(struct mlx5_core_dev *mdev, int pdn,
 {
 	void *in, *sqc, *wq;
 	int inlen, err;
+	u8 ts_format;
 
 	inlen = MLX5_ST_SZ_BYTES(create_sq_in) +
 		sizeof(u64) * sq->wq_ctrl.buf.npages;
@@ -195,6 +197,11 @@ static int create_aso_sq(struct mlx5_core_dev *mdev, int pdn,
 	MLX5_SET(sqc,  sqc, state, MLX5_SQC_STATE_RST);
 	MLX5_SET(sqc,  sqc, flush_in_error_en, 1);
 
+	ts_format = mlx5_is_real_time_sq(mdev) ?
+			MLX5_TIMESTAMP_FORMAT_REAL_TIME :
+			MLX5_TIMESTAMP_FORMAT_FREE_RUNNING;
+	MLX5_SET(sqc, sqc, ts_format, ts_format);
+
 	MLX5_SET(wq,   wq, wq_type,       MLX5_WQ_TYPE_CYCLIC);
 	MLX5_SET(wq,   wq, uar_page,      mdev->mlx5e_res.hw_objs.bfreg.index);
 	MLX5_SET(wq,   wq, log_wq_pg_sz,  sq->wq_ctrl.buf.page_shift -
-- 
2.37.3

