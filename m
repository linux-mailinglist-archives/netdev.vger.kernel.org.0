Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4E34D3C35
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbiCIVjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiCIVjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24657087A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3083FCE212D
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FFFC340F4;
        Wed,  9 Mar 2022 21:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861887;
        bh=0DthVAwQJan3uxphtrFCA4/wUISSr4JM+1Oix5CKHHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrWeOJTbEBPneYmeNXPbaFxrSHytCovTu/PGl981nr2n/tXr1T97naUGATi60IRbv
         io63ewn/jLwg93e32hZBqVBmKVrROzKD5s7LLneAJrLeq8LuFHY94m2XC6BYBBMHza
         uwtkGkgfCXnfFD4FXtFwfESQje/LE8Twsm8zX6+bo7jI9or+DRsMQMapz68Iy1gVW0
         +i6XMsR1nB2ZsLCPNKIPPQNTLzyXw3JXFvPhctXsxOggjyzINSk6ijsadRPowOtJEm
         HoypcVEiM0aUdz2H0+J4/AjiOBcxFN+pZrMYOgb3vlD1WAP0hV6mJfGcOiAbIpx+/s
         BeThbqG6ekp5w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5: Remove redundant error on reclaim pages
Date:   Wed,  9 Mar 2022 13:37:44 -0800
Message-Id: <20220309213755.610202-6-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

If reclaim pages was triggered by FW event and FW failed the command,
the driver should ignore as FW is aware and will handle it.

The downstream patch will add a debugfs counter on this flow for
debuggability.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index cc4734da6171..d29a305858ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -465,7 +465,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	u32 i = 0;
 
 	if (!mlx5_cmd_is_down(dev))
-		return mlx5_cmd_exec(dev, in, in_size, out, out_size);
+		return mlx5_cmd_do(dev, in, in_size, out, out_size);
 
 	/* No hard feelings, we want our pages back! */
 	npages = MLX5_GET(manage_pages_in, in, input_num_entries);
@@ -489,7 +489,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 }
 
 static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
-			 int *nclaimed, bool ec_function)
+			 int *nclaimed, bool event, bool ec_function)
 {
 	u32 function = get_function(func_id, ec_function);
 	int outlen = MLX5_ST_SZ_BYTES(manage_pages_out);
@@ -516,7 +516,11 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	mlx5_core_dbg(dev, "func 0x%x, npages %d, outlen %d\n",
 		      func_id, npages, outlen);
 	err = reclaim_pages_cmd(dev, in, sizeof(in), out, outlen);
+	/* if triggered by FW event and failed by FW then ignore */
+	if (event && err == -EREMOTEIO)
+		err = 0;
 	if (err) {
+		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_err(dev, "failed reclaiming pages: err %d\n", err);
 		goto out_free;
 	}
@@ -556,7 +560,7 @@ static void pages_work_handler(struct work_struct *work)
 		release_all_pages(dev, req->func_id, req->ec_function);
 	else if (req->npages < 0)
 		err = reclaim_pages(dev, req->func_id, -1 * req->npages, NULL,
-				    req->ec_function);
+				    true, req->ec_function);
 	else if (req->npages > 0)
 		err = give_pages(dev, req->func_id, req->npages, 1, req->ec_function);
 
@@ -655,7 +659,7 @@ static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
 		int err;
 
 		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
-				    &nclaimed, mlx5_core_is_ecpf(dev));
+				    &nclaimed, false, mlx5_core_is_ecpf(dev));
 		if (err) {
 			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
 				       err, func_id);
-- 
2.35.1

