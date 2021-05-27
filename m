Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6256A39267B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhE0EiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230078AbhE0EiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C7C61157;
        Thu, 27 May 2021 04:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090196;
        bh=bGrsAR00DlkRGdPQ/20+MbjRiFr0rTUQNSIMxqIP37g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrfATOcfl/Ld3/IFHydjsA2avrWcoOG+RZHklHAREwfn4q36qSv3GZMiry4TpcCG6
         plFEm9l7oLqRfp5CTWWu/PNnXo/v+Kk8PCFKOoknk/fAV77RdFsT1aScxj7FT4gF5D
         4uV6gEPc+8IOAeGrGhZFW1cW5ZXPmOr3AJ2TuFTjsi/srgh7qdSkY7PwR5AG0CHqaB
         hBZFuEF+giobEZ1UGxr06EHuGv/o81Qdwt+FxX4ay9gXJFzwwIDTDViMpTUYXerjxL
         TFmsfCeT9ieis+lMkBIsDsDblCza7jp38mu8I98vhX0rph++37PPSTEoi1zG6G8fm7
         oDRsWrY+OF0lA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/17] net/mlx5: Add case for FS_FT_NIC_TX FT in MLX5_CAP_FLOWTABLE_TYPE
Date:   Wed, 26 May 2021 21:36:00 -0700
Message-Id: <20210527043609.654854-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Commit 16f1c5bb3ed7 ("net/mlx5: Check device capability for maximum flow
counters") added MLX5_CAP_FLOWTABLE_TYPE but forgot to account
for FS_FT_NIC_TX case in the expression.

Although the expression will return 1 for this case instead of the
actual cap, there isn't currently no known side affects of
missing this case.

Add the FS_FT_NIC_TX case.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index e577a2c424af..7317cdeab661 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -331,6 +331,7 @@ void mlx5_fs_ingress_acls_cleanup(struct mlx5_core_dev *dev);
 
 #define MLX5_CAP_FLOWTABLE_TYPE(mdev, cap, type) (		\
 	(type == FS_FT_NIC_RX) ? MLX5_CAP_FLOWTABLE_NIC_RX(mdev, cap) :		\
+	(type == FS_FT_NIC_TX) ? MLX5_CAP_FLOWTABLE_NIC_TX(mdev, cap) :		\
 	(type == FS_FT_ESW_EGRESS_ACL) ? MLX5_CAP_ESW_EGRESS_ACL(mdev, cap) :		\
 	(type == FS_FT_ESW_INGRESS_ACL) ? MLX5_CAP_ESW_INGRESS_ACL(mdev, cap) :		\
 	(type == FS_FT_FDB) ? MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, cap) :		\
-- 
2.31.1

