Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7108D1060A4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbfKVFuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727884AbfKVFuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C35EA20748;
        Fri, 22 Nov 2019 05:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401849;
        bh=uBfze1NgWAGObk+4YKV9h++cdjQx83W+ZcE+McTkqCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nFbS0Dm6N2xuRAK+BB9um9NfLa193lJU5WHhrl6txSq6vZStCRZ7hzicy1lCmoCbq
         A2ZzHOZGSI3bMEmipeHjKA6ssW/f2w434BGR443KT7SfbEMI5UEWLafVuGtAIOoP5b
         VfcY8DqKwHfaLGAnxeZzZiTXsgcskIAsyHoQJbsQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 087/219] net/mlx5: Continue driver initialization despite debugfs failure
Date:   Fri, 22 Nov 2019 00:46:59 -0500
Message-Id: <20191122054911.1750-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 199fa087dc6b503baad06712716fac645a983e8a ]

The failure to create debugfs entry is unpleasant event, but not enough
to abort drier initialization. Align the mlx5_core code to debugfs design
and continue execution whenever debugfs_create_dir() successes or not.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 231ed508c240a..5fac00ea62457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -859,11 +859,9 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct mlx5_priv *priv)
 
 	priv->numa_node = dev_to_node(&dev->pdev->dev);
 
-	priv->dbg_root = debugfs_create_dir(dev_name(&pdev->dev), mlx5_debugfs_root);
-	if (!priv->dbg_root) {
-		dev_err(&pdev->dev, "Cannot create debugfs dir, aborting\n");
-		return -ENOMEM;
-	}
+	if (mlx5_debugfs_root)
+		priv->dbg_root =
+			debugfs_create_dir(pci_name(pdev), mlx5_debugfs_root);
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
-- 
2.20.1

