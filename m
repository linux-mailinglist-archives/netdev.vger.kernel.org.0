Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04A43D83D3
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbhG0XVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232827AbhG0XUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F017060FC0;
        Tue, 27 Jul 2021 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428055;
        bh=cEHbFQIEo9TOLeLGvcP+21vb4+K9jzhaY2TMs7Upg0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IYyxI1f26KMGiG783m8vUos9gyMZVs3+N23iWvngn4Ap16kA3A7MLNLgjaeQvZF3q
         ZyfUDeX/H36d2flBCtr2Wx6Sq61qUqeBAuheH0f9wjTSgBbMj6T4MFERUhtvNffkA9
         XNKDd5HvJMIKuI5FicYJoJpJTRCzeixzDBczFx5kNomo+Amw4bsADy/2fgH4JuuYBp
         2tDTgPpKLf3hz+eWZHpFZLvM4AvjcstFf+frVxzbCjl2oTXPD3Vac30ea4Ho9ifRY3
         sy3H0HgaaE0SFwtv/8HAUnStP7QbTnzsvZZ2ciBf3OxF/hvEipkC2UYXB25RGKrYOm
         vYGDFYq61l1MQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 05/12] net/mlx5e: RX, Avoid possible data corruption when relaxed ordering and LRO combined
Date:   Tue, 27 Jul 2021 16:20:43 -0700
Message-Id: <20210727232050.606896-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

When HW aggregates packets for an LRO session, it writes the payload
of two consecutive packets of a flow contiguously, so that they usually
share a cacheline.

The first byte of a packet's payload is written immediately after
the last byte of the preceding packet.
In this flow, there are two consecutive write requests to the shared
cacheline:
1. Regular write for the earlier packet.
2. Read-modify-write for the following packet.

In case of relaxed-ordering on, these two writes might be re-ordered.
Using the end padding optimization (to avoid partial write for the last
cacheline of a packet) becomes problematic if the two writes occur
out-of-order, as the padding would overwrite payload that belongs to
the following packet, causing data corruption.

Avoid this by disabling the end padding optimization when both
LRO and relaxed-ordering are enabled.

Fixes: 17347d5430c4 ("net/mlx5e: Add support for PCI relaxed ordering")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 150c8e82c738..2cbf18c967f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -471,6 +471,15 @@ static void mlx5e_build_rx_cq_param(struct mlx5_core_dev *mdev,
 	param->cq_period_mode = params->rx_cq_moderation.cq_period_mode;
 }
 
+static u8 rq_end_pad_mode(struct mlx5_core_dev *mdev, struct mlx5e_params *params)
+{
+	bool ro = pcie_relaxed_ordering_enabled(mdev->pdev) &&
+		MLX5_CAP_GEN(mdev, relaxed_ordering_write);
+
+	return ro && params->lro_en ?
+		MLX5_WQ_END_PAD_MODE_NONE : MLX5_WQ_END_PAD_MODE_ALIGN;
+}
+
 int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 			 struct mlx5e_params *params,
 			 struct mlx5e_xsk_param *xsk,
@@ -508,7 +517,7 @@ int mlx5e_build_rq_param(struct mlx5_core_dev *mdev,
 	}
 
 	MLX5_SET(wq, wq, wq_type,          params->rq_wq_type);
-	MLX5_SET(wq, wq, end_padding_mode, MLX5_WQ_END_PAD_MODE_ALIGN);
+	MLX5_SET(wq, wq, end_padding_mode, rq_end_pad_mode(mdev, params));
 	MLX5_SET(wq, wq, log_wq_stride,
 		 mlx5e_get_rqwq_log_stride(params->rq_wq_type, ndsegs));
 	MLX5_SET(wq, wq, pd,               mdev->mlx5e_res.hw_objs.pdn);
-- 
2.31.1

