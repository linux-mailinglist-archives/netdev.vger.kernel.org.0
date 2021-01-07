Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C552EE6E5
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbhAGUaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbhAGUaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764E8235FD;
        Thu,  7 Jan 2021 20:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051359;
        bh=hYKT8tkty72MS2xvthtLHbiWc1iwnGpYn4TnBsn+c9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCtMWHHhbtrqcoeEto0xvRW9TPE1mwcIW9Hsk2a4cEIHnzs55Eof+XYdr8r/m0BHX
         kiJBQ3ArvyTdd1aJRtuwu2koyYe1thIoDBcNP8ZI1GdIWGpI+Rx9dY0pOf/iM2asA6
         Rg3iIGY9UzBQYejGmzLnZgqvdndiY5gwpdD0Nf87cehng8HAL9eTtWYTthJVdnQy/8
         +xu1hRz9crcVtk/QlSjOjSpMS6IxxGCU7yRG3SSEL9bhIXKN/VnSyzFsGUFbNkFqxD
         M/xAXe1AeAzwnxQ4ECBVcgVA7LHTukaH19f/3tS+KORkEXDCM0VooBpyoYVBkLRbo8
         y9ohIE6gdl9UQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/11] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
Date:   Thu,  7 Jan 2021 12:28:45 -0800
Message-Id: <20210107202845.470205-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

When mlx5_create_flow_group() fails, ft->g should be
freed just like when kvzalloc() fails. The caller of
mlx5e_create_l2_table_groups() does not catch this
issue on failure, which leads to memleak.

Fixes: 33cfaaa8f36f ("net/mlx5e: Split the main flow steering table")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 44a2dfbc3853..e02e5895703d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1392,6 +1392,7 @@ static int mlx5e_create_l2_table_groups(struct mlx5e_l2_table *l2_table)
 	ft->g[ft->num_groups] = NULL;
 	mlx5e_destroy_groups(ft);
 	kvfree(in);
+	kfree(ft->g);
 
 	return err;
 }
-- 
2.26.2

