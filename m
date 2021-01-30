Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C5D3093B6
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhA3Jsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:48:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:33800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233362AbhA3DIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B6E64E04;
        Sat, 30 Jan 2021 02:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611973587;
        bh=4t68jPI4MtPQ6lD3S5arM2epLbffAhz/hxIN/rjfE4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WC+VVWgnd6aTUBU2trDwop3UxIZZCp3Ny53gGp1TqyicaJvpAndgs4roX2dSzoAec
         kah+xJkacjXgzuEz8nnA9aoUcFIwQzBqI8/1ummixQDs4jc5MAoBgrly8a4Y/x0azi
         RhfKYlWy7IQochu8YrA4lcEVmB5OPhYcZOMFQq7fh++Sh3lvsEXXJc0TIQo8/Z72HW
         ++UPQZTwGlsG8Cn1q7fw/xJsOeuMKnvMekd67r1k+pTXHpZwhp0IHBj0KtM1ug/s1W
         nYfHy8vURNjhtvw/FbkC0gWRJBaAYqDtojn1GSxK3IAJwoRO8t1KR6vD+ZNQ0CrRhH
         JT/XL7cSuNTaw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/11] net/mlx5: DR, Fix potential shift wrapping of 32-bit value
Date:   Fri, 29 Jan 2021 18:26:08 -0800
Message-Id: <20210130022618.317351-2-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210130022618.317351-1-saeed@kernel.org>
References: <20210130022618.317351-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Fix 32-bit variable shift wrapping in dr_ste_v0_get_miss_addr.

Fixes: 6b93b400aa88 ("net/mlx5: DR, Move STEv0 setters and getters")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index b76fdff08890..9ec079247c4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -248,8 +248,8 @@ static void dr_ste_v0_set_miss_addr(u8 *hw_ste_p, u64 miss_addr)
 static u64 dr_ste_v0_get_miss_addr(u8 *hw_ste_p)
 {
 	u64 index =
-		(MLX5_GET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6) |
-		 MLX5_GET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32) << 26);
+		((u64)MLX5_GET(ste_rx_steering_mult, hw_ste_p, miss_address_31_6) |
+		 ((u64)MLX5_GET(ste_rx_steering_mult, hw_ste_p, miss_address_39_32)) << 26);
 
 	return index << 6;
 }
-- 
2.29.2

