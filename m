Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1099E637360
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiKXILB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiKXIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813EAD237D
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E67FB826FD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8673C433D7;
        Thu, 24 Nov 2022 08:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277456;
        bh=NrzOJxqgPp2K8ukyYMRD2zlF2cX5uNtKjBlHKePISmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8F7nHT0M+POrVVvHOtSu3H8GgrDAk9N/nwBGdp7QnLD8hHsqWxE7NqDUVUzKS8Os
         j6Ep8Z28riv5dZ9Ds+IBKwPqJI/JlztjUZI59ylU8MjJxKs2VzTYMcmU+szqvkurJU
         ZpY1OpJst0pZJywDom2YFwtzZqXb4pCKMknoncxOCmiTkxEMOZwZcqr3P+gFzPigxi
         YAzJbhWSd+CGgNyxRMn0CZlPyJ6/QFJ3imWBy5gPta70MFpsdzBmvk7CAJlzWu+MLk
         VGyjsJhlu3xHez+UR3Ah1Y+KVTHMLiKkUhOQHL6sFBMsj/REM6R2IrMEMQAk86QBA6
         KorB+TonOYkog==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [net 04/15] net/mlx5: Fix uninitialized variable bug in outlen_write()
Date:   Thu, 24 Nov 2022 00:10:29 -0800
Message-Id: <20221124081040.171790-5-saeed@kernel.org>
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

If sscanf() return 0, outlen is uninitialized and used in kzalloc(),
this is unexpected. We should return -EINVAL if the string is invalid.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 74bd05e5dda2..e7a894ba5c3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1497,8 +1497,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
-- 
2.38.1

