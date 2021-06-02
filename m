Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168D9397E1C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhFBBjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhFBBjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E7D613D1;
        Wed,  2 Jun 2021 01:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597852;
        bh=W/8YNK2VhjBRdkqWaxgPfciawxdXYoaMt6rKYqvz6AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=maX6Ux1j5eC40fNsr2ph6cjl5vgAxQ0DMU3PnPWD+lATME+Z3nClqQoAGX3tJX8Z5
         tVwTDRCyudonI2nH2ya035tqRzCDrTwK7Ro8JTYb8511f072M95QjTebl54ZUq8ae4
         Znzc/hKnXyp5oB3wD6eoQihYKps0xdbxx0LmMe45HmdAswCj7pKSTKXQpUpneMSb8+
         LzPcrll+CVlKJIi5gfNPRUz4eUd41lZ1Xmip/TXNHZlQATmJdXgvmlG2AsGLe9FTOJ
         f0xsVXq3Vf/3ee/D2CXjbtUJjGY43Px3FkQPVoqbvOUcCOZoq+mnEMTRv9W7bAMMl/
         JfKJl4ULojLRA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/8] net/mlx5e: Fix incompatible casting
Date:   Tue,  1 Jun 2021 18:37:16 -0700
Message-Id: <20210602013723.1142650-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Device supports setting of a single fec mode at a time, enforce this
by bitmap_weight == 1. Input from fec command is in u32, avoid cast to
unsigned long and use bitmap_from_arr32 to populate bitmap safely.

Fixes: 4bd9d5070b92 ("net/mlx5e: Enforce setting of a single FEC mode")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 8360289813f0..c4724742eef1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1624,12 +1624,13 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	unsigned long fec_bitmap;
 	u16 fec_policy = 0;
 	int mode;
 	int err;
 
-	if (bitmap_weight((unsigned long *)&fecparam->fec,
-			  ETHTOOL_FEC_LLRS_BIT + 1) > 1)
+	bitmap_from_arr32(&fec_bitmap, &fecparam->fec, sizeof(fecparam->fec) * BITS_PER_BYTE);
+	if (bitmap_weight(&fec_bitmap, ETHTOOL_FEC_LLRS_BIT + 1) > 1)
 		return -EOPNOTSUPP;
 
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
-- 
2.31.1

