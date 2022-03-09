Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2B14D3C2D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238205AbiCIVjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiCIVjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BC0606FF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C997CB823D6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C609C340F5;
        Wed,  9 Mar 2022 21:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861886;
        bh=dI8n3VbZKxcIk4qT3mX+YHzHMgfgeuyz+MTuF3Mx1jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/5eTAc8+pk1noSwFWcX1f0gFNyOW3GCMNoz9T2o9F53dQn2pqw30Ct/30aplxVv6
         I2R/DHk3YcTUUs/COZa20r6W1yqI0LTGHHFbMBfC+MON4da6vVCnIZH7enz2SWp3k9
         YtofsDFWZ/r558124kt2sTsYAEacKpB9Wb2wVNex5m8/XS/lEp0iyZw25JWl9QKsd6
         pFtjngCb00aJ1gkRq2L4V7x48jT5KgW+2Diqs3AO7qZQVBzdOd33jCoyyMxsAYATIa
         JQR7FpqtHayUi7K5WxuXUw2E2XRK2gqz4/xcpm79rbenXG+ceq/vfHw2lLDPEm8zRl
         sYNlc6VgcQV9g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: Remove redundant notify fail on give pages
Date:   Wed,  9 Mar 2022 13:37:42 -0800
Message-Id: <20220309213755.610202-4-saeed@kernel.org>
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

If give pages command failed by FW, there is no need to notify the FW on
the failure. FW is aware and will handle it.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index f6b5451328fc..de150643ef83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -365,8 +365,12 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	MLX5_SET(manage_pages_in, in, input_num_entries, npages);
 	MLX5_SET(manage_pages_in, in, embedded_cpu_function, ec_function);
 
-	err = mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
+	err = mlx5_cmd_do(dev, in, inlen, out, sizeof(out));
 	if (err) {
+		if (err == -EREMOTEIO)
+			notify_fail = 0;
+
+		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_warn(dev, "func_id 0x%x, npages %d, err %d\n",
 			       func_id, npages, err);
 		goto out_4k;
-- 
2.35.1

