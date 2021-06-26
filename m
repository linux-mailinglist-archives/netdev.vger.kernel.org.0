Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8553B4D7C
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhFZHrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhFZHrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:47:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7766461919;
        Sat, 26 Jun 2021 07:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693489;
        bh=rxyOoZjPhf6qqvbiWrGIgNatMAtcAutUXc8B55ji+2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQmc5DwOmjGeJhxhnsuWoefNi1qkKvo3aK6FwCuUKL1YYhPAEPNJSKOqdS3zJWqnA
         8NufDKmGT5cFbMhsa9uCsV8Ux4Wx4zhmPPwjxx3c4Q0sjFivIsfUtgECcGV1gxMK+6
         9ZTuLBtMmBZXRqUGN1xfRerqUJpawcExnoj8tNp9ovnw0X8fKcCMS1OscI1VX7zO7m
         Madt340nug9ywtbEDghqv33belgmMu864OOZbEcIaa7Z6/RHThfpYCrYCHcYeR1iNr
         CyH5j0kBjk8/u1ZzLx0MBOrMjMJRsjk/dRdY8uKz9Z97v761c8l8T4BzCBMGy36cBi
         qYTY/D5cbDvmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 3/6] net/mlx5: Increase hairpin buffer size
Date:   Sat, 26 Jun 2021 00:44:14 -0700
Message-Id: <20210626074417.714833-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210626074417.714833-1-saeed@kernel.org>
References: <20210626074417.714833-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

The max packet size a hairpin queue is able to handle
is determined by the total hairpin buffer size divided
by 4.

Currently the buffer size is set to 32KB which makes
the max packet size to be 8KB and doesn't support
jumbo frames of size 9KB.

This change increases the buffer size to 64KB to increase
the max frame size and support 9KB frames.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8d84d0712c20..629a61e8022f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -846,7 +846,7 @@ static int mlx5e_hairpin_flow_add(struct mlx5e_priv *priv,
 		 hash_hairpin_info(peer_id, match_prio));
 	mutex_unlock(&priv->fs.tc.hairpin_tbl_lock);
 
-	params.log_data_size = 15;
+	params.log_data_size = 16;
 	params.log_data_size = min_t(u8, params.log_data_size,
 				     MLX5_CAP_GEN(priv->mdev, log_max_hairpin_wq_data_sz));
 	params.log_data_size = max_t(u8, params.log_data_size,
-- 
2.31.1

