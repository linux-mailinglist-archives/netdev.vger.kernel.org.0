Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F5F60A4AF
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 14:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiJXMPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 08:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiJXMNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5A732BA2
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:55:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 558EB612D6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1042FC433C1;
        Mon, 24 Oct 2022 11:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612473;
        bh=/okgLXYlIlsRXiRNU8LzAY/VaOJV5jmYf7YwTjuA4X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsLmM3eHsfN3VDTXOIUkV4Quj30dygevhG7BPF2iLILUZPnWyu42Z2udXvcadN20/
         h78juI+iyJ70qePMDFuTjNBOqCjl+bN84jKfoWNQVDa4bLaD6R2QmXN+rDkVHj49S3
         6Yby+TXdLQ5TQkl8osN8jKSKF70X0o/4G/SgN09focTtpp9lhb+bzhuZvm3xuQiZzj
         t9N6vP2yBR8Yjd8KC2wPLqBjolK5x+8xGauyng2ft5slBxGDhxTKy7uZfPn+kE490h
         Up2OwdTLdgXaK2DYmZ91qhQDRSRgPDBgRC4CdUPrUPGG5HKLQMa5pvJYr6IitIrhvt
         7wIr17XhSmdmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [V3 net 06/16] net/mlx5: ASO, Create the ASO SQ with the correct timestamp format
Date:   Mon, 24 Oct 2022 12:53:47 +0100
Message-Id: <20221024115357.37278-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024115357.37278-1-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
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
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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

