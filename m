Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CF13A2150
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFJAYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhFJAYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C53A2613F0;
        Thu, 10 Jun 2021 00:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284537;
        bh=CvPK12ponxH+44eVUzo9pomOpbE8790TmC44srTQzs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSzkDR8Mv4Nc7XhN8+79SuDus5EwEAwIOo2vdN5kh98RcYHq/b7DEGbFb07j3I1t8
         FUEQ2JKTOKy46zPyZPPweS1i6ZJIQRq8SSpzKcUASZHn+3Ew+Pzyjhna2J+bNWXb46
         xCVvAjOEMS7K62jQh8GmHyNtQdXetxqTGzYGDpjkC7qmZkkm9UUKlbfbYRzDyr0GHA
         TlEbjLIKY/DhzMjoeY7E08wC0KOTvi/yRrT/S2ydecyfbEhGqvOYo+Vnj3BMO2slUh
         Wj536pBK29dwmh/EoXBP66WUf5Gnhvxed1P9MkasPaEVqrc8ZMxfhtj0tf3HCGzAZ9
         dOWcBDs17+W7w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/12] net/mlx5e: Fix an error code in mlx5e_arfs_create_tables()
Date:   Wed,  9 Jun 2021 17:21:44 -0700
Message-Id: <20210610002155.196735-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

When the code execute 'if (!priv->fs.arfs->wq)', the value of err is 0.
So, we use -ENOMEM to indicate that the function
create_singlethread_workqueue() return NULL.

Clean up smatch warning:
drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
mlx5e_arfs_create_tables() warn: missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: f6755b80d693 ("net/mlx5e: Dynamic alloc arfs table for netdev when needed")
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 5cd466ec6492..25403af32859 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -356,7 +356,7 @@ static int arfs_create_table(struct mlx5e_priv *priv,
 
 int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
 {
-	int err = 0;
+	int err = -ENOMEM;
 	int i;
 
 	if (!(priv->netdev->hw_features & NETIF_F_NTUPLE))
-- 
2.31.1

