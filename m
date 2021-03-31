Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD2B350802
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbhCaURG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236464AbhCaUQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD951610A6;
        Wed, 31 Mar 2021 20:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221798;
        bh=b4fK2LjdWuNL55TyfMv3zNPRbipzIVSxwDVOWa5hzIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAVwWzyIpltAdVG5lY5NgIzU+wUVQAEWMdaVk5OkakzLHqTt5x+rn5YMrVOJCGvtm
         TMiD32FaV6kWUNK/iZQVz8WIPafidzExiRf2rUbLVtzLK9Bh1A8ePzd8bqpsY5Bjxw
         DOMsn0NO9ANqhaU6m1Kp6q8jAA89lJImYKk+GGoN6+Ci8Vg5SYfxTTlJvb8QRAqi+v
         ctoMtp+4kWSC0VC+J0a6MVTl9TkoYxdZN7jfezOegIA0jxMNv8nVobG7lHTcOUDhT/
         cuyrsErNfjYxqzzkEhBiRyZaD2DT6RRo0FA7KNm4JY9fyrOwhhy+w+CyhG/YUpmxNE
         ov026ZDFvqw+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/9] net/mlx5: Delete auxiliary bus driver eth-rep first
Date:   Wed, 31 Mar 2021 13:14:17 -0700
Message-Id: <20210331201424.331095-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Delete auxiliary bus drivers flow deletes the eth driver
first and then the eth-reps driver but eth-reps devices resources
are depend on eth device.

Fixed by changing the delete order of auxiliary bus drivers to delete
the eth-rep driver first and after it the eth driver.

Fixes: 601c10c89cbb ("net/mlx5: Delete custom device management logic")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index b051417ede67..9153c9bda96f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -191,12 +191,12 @@ static bool is_ib_supported(struct mlx5_core_dev *dev)
 }
 
 enum {
-	MLX5_INTERFACE_PROTOCOL_ETH_REP,
 	MLX5_INTERFACE_PROTOCOL_ETH,
+	MLX5_INTERFACE_PROTOCOL_ETH_REP,
 
+	MLX5_INTERFACE_PROTOCOL_IB,
 	MLX5_INTERFACE_PROTOCOL_IB_REP,
 	MLX5_INTERFACE_PROTOCOL_MPIB,
-	MLX5_INTERFACE_PROTOCOL_IB,
 
 	MLX5_INTERFACE_PROTOCOL_VNET,
 };
-- 
2.30.2

