Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3268E66A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 04:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjBHDDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 22:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjBHDDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 22:03:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BE7233CC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 19:03:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77950B81BA4
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE72C4339B;
        Wed,  8 Feb 2023 03:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675825398;
        bh=k1Ja34eniH/YqXa8th8JW9pIz9ALF2lHD0POYEGClfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVviCCCHyQH4KHgJ0XH9ZVc5amzLWyryHY+VThY1Kj6PcPCZzrQHYcX8AMuJBXLpY
         kAFJVMjRpeGFZ9fnTOM1BO3aI0Lj37fQAJkrgbQ1D0CUolkw3ux8H9suC9YG/nxqBh
         8CBSJ/+XRCqWH554CRSTkIUn+btkvu5JOF0buF6+BJoypX+ihd8jt7KN9NyEzKOqst
         Bpnk+kXiB4BKbunx1co7ayDL6MrPXVWuLTsTIH6j8paBdA1M+0cHvYDlVcgTdaFGM+
         znv1s0XPJ87AcvPirVpXTP4MsOiHjR3LAbmh87zFeeZjDJp3W5NK3ygjFmcfz9CXIs
         q3zqLnZ4C0D+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: [net 09/10] net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
Date:   Tue,  7 Feb 2023 19:03:01 -0800
Message-Id: <20230208030302.95378-10-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208030302.95378-1-saeed@kernel.org>
References: <20230208030302.95378-1-saeed@kernel.org>
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

From: Shay Drory <shayd@nvidia.com>

When tracer is reloaded, the device will log the traces at the
beginning of the log buffer. Also, driver is reading the log buffer in
chunks in accordance to the consumer index.
Hence, zero consumer index when reloading the tracer.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index d82e98a0cdfa..5b05b884b5fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -757,6 +757,7 @@ static int mlx5_fw_tracer_set_mtrc_conf(struct mlx5_fw_tracer *tracer)
 	if (err)
 		mlx5_core_warn(dev, "FWTracer: Failed to set tracer configurations %d\n", err);
 
+	tracer->buff.consumer_index = 0;
 	return err;
 }
 
@@ -821,7 +822,6 @@ static void mlx5_fw_tracer_ownership_change(struct work_struct *work)
 	mlx5_core_dbg(tracer->dev, "FWTracer: ownership changed, current=(%d)\n", tracer->owner);
 	if (tracer->owner) {
 		tracer->owner = false;
-		tracer->buff.consumer_index = 0;
 		return;
 	}
 
-- 
2.39.1

