Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64663637365
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKXILQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiKXILL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:11:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CF1D33BD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:11:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5B68B82703
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB09C433D7;
        Thu, 24 Nov 2022 08:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277459;
        bh=AVcv5VavsauzDl4U2sGOMND4/9AWn7IJtYk+3TuwGsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSdz27cWeCLMh1bHZoBNo1r0zpDrHOmJIDEf/Z1uiIfE+0ejaxgVw+P/INeX2aGS8
         q7t/l1OvPVJNyY7LztWoPvMfubl32VqwLTkkA2h5qaWed0p1+vwdGDw3+fVUToMNDo
         d4oQS4+d/Alh45s6uKnT/MMy5lhurTV/yzCAvHwHPxmT+MLuohj6wGl8Y3CXkfUAkm
         S3WF32zNnYyj8SIN4+USz7lTKv3hQAIaRJqdJGcowk8gXJAf2F+G2HTrNoBHt32zeC
         DVU0UkgYQA2CrH5OsAu8alj+UcrhDQqDIWdqSPYq6p0m7GbDTIa3lJ1ipeGkbu9zB1
         zfZ6uxiTsm13g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [net 07/15] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
Date:   Thu, 24 Nov 2022 00:10:32 -0800
Message-Id: <20221124081040.171790-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
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

From: YueHaibing <yuehaibing@huawei.com>

'accel_tcp' is allocated by kvzalloc(), which should freed by kvfree().

Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 285d32d2fd08..d7c020f72401 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
 	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
 		accel_fs_tcp_destroy_table(fs, i);
 
-	kfree(accel_tcp);
+	kvfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 }
 
@@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
 err_destroy_tables:
 	while (--i >= 0)
 		accel_fs_tcp_destroy_table(fs, i);
-	kfree(accel_tcp);
+	kvfree(accel_tcp);
 	mlx5e_fs_set_accel_tcp(fs, NULL);
 	return err;
 }
-- 
2.38.1

