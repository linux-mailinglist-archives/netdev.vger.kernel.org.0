Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3225C4D3C34
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbiCIVj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbiCIVjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46708BF51E
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CECDAB823D6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D810C340F5;
        Wed,  9 Mar 2022 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861890;
        bh=RMEXqLoQ5UbSt6Mns80SHf7iy0YvGZVSzch9mMjbk0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUQXjh7GRVVPYTTtT94waNRq4MwmFIxZU+JH9TObKRFh07iE3dp9UGJ/X195NCfod
         vW8pj+lIln/FbBKCHYB0Nj37rMuq0yrUPJSj/BEvlr8a/+aP3dCib3qjgfQvckxf0x
         0gYZAbWFo+bdbMivE+j3KkwwxBr2dredgcdXbw4yGeyi97kL1qFHkddDrxuEhsRlYg
         ehN6/UkhVQsor8Csu3EZaaeqftIDICEUIuchLmLdUtgG9nZInpkcxUzyYfGWxK0Hg9
         c9rmy/Mi5cxGxZ6/NStsjz0nEjkBfQyh0G4aULbSseEYB0+jxTsw2gbySecUdJuAK7
         cyrmQFOJJLLXQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5: Add debugfs counters for page commands failures
Date:   Wed,  9 Mar 2022 13:37:48 -0800
Message-Id: <20220309213755.610202-10-saeed@kernel.org>
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

Add the following new debugfs counters for debug and verbosity:
fw_pages_alloc_failed - number of pages FW requested but driver failed
to allocate.
give_pages_dropped - number of pages given to FW, but command give pages
failed by FW.
reclaim_pages_discard - number of pages which were about to reclaim back
and FW failed the command.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 14 +++++++++++---
 include/linux/mlx5/driver.h                        |  3 +++
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 8673ba2df910..d69bac93a83b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -222,6 +222,10 @@ void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
 	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
 	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.vfs_pages);
 	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.host_pf_pages);
+	debugfs_create_u32("fw_pages_alloc_failed", 0400, pages, &dev->priv.fw_pages_alloc_failed);
+	debugfs_create_u32("fw_pages_give_dropped", 0400, pages, &dev->priv.give_pages_dropped);
+	debugfs_create_u32("fw_pages_reclaim_discard", 0400, pages,
+			   &dev->priv.reclaim_pages_discard);
 }
 
 void mlx5_pages_debugfs_cleanup(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 8855fe71d480..e0543b860144 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -352,8 +352,10 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		if (err) {
 			if (err == -ENOMEM)
 				err = alloc_system_page(dev, function);
-			if (err)
+			if (err) {
+				dev->priv.fw_pages_alloc_failed += (npages - i);
 				goto out_4k;
+			}
 
 			goto retry;
 		}
@@ -372,14 +374,14 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		/* if triggered by FW and failed by FW ignore */
 		if (event) {
 			err = 0;
-			goto out_4k;
+			goto out_dropped;
 		}
 	}
 	if (err) {
 		err = mlx5_cmd_check(dev, err, in, out);
 		mlx5_core_warn(dev, "func_id 0x%x, npages %d, err %d\n",
 			       func_id, npages, err);
-		goto out_4k;
+		goto out_dropped;
 	}
 
 	dev->priv.fw_pages += npages;
@@ -394,6 +396,8 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	kvfree(in);
 	return 0;
 
+out_dropped:
+	dev->priv.give_pages_dropped += npages;
 out_4k:
 	for (i--; i >= 0; i--)
 		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]), function);
@@ -516,6 +520,10 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	mlx5_core_dbg(dev, "func 0x%x, npages %d, outlen %d\n",
 		      func_id, npages, outlen);
 	err = reclaim_pages_cmd(dev, in, sizeof(in), out, outlen);
+	if (err) {
+		npages = MLX5_GET(manage_pages_in, in, input_num_entries);
+		dev->priv.reclaim_pages_discard += npages;
+	}
 	/* if triggered by FW event and failed by FW then ignore */
 	if (event && err == -EREMOTEIO)
 		err = 0;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c5f93b5910ed..00a914b0716e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -575,6 +575,9 @@ struct mlx5_priv {
 	struct list_head	free_list;
 	u32			vfs_pages;
 	u32			host_pf_pages;
+	u32			fw_pages_alloc_failed;
+	u32			give_pages_dropped;
+	u32			reclaim_pages_discard;
 
 	struct mlx5_core_health health;
 	struct list_head	traps;
-- 
2.35.1

