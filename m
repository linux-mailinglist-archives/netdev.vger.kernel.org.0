Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D3242F6F2
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 17:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhJOPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 11:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:32990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232267AbhJOPXI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 11:23:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C747A60E0C;
        Fri, 15 Oct 2021 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634311261;
        bh=CG/9/aX/UXAFY8vz2mkwopf7IgGPkJ6BVBlhZp8bxPc=;
        h=From:To:Cc:Subject:Date:From;
        b=gSKDa8hbc7yOywBMCHX2toABg5IUJY89Bj5WPNwk2nvmwNyvtboqakO13M6lveH8f
         49SO/3+btyQsPMbdMwMXqO0p3TBG+jrHNFi44kUMjvqIe8+/A0EX5VR9EiQ6fvw39x
         8pXnYw0K9TUG5KdFUwwa+AZa5fuj1zAY5fV58M5BhLygV/FNeLzjW/Aq6p4nA3376D
         iWJlOF9cbbf2xYEMCRB8X2k0+BZHqbExBtm07Ez+508aaohg0t2mJ2Cgbwd1tQ4kVU
         vdxdvXJrBTXDScYorJBwBLTZqdH4hZPCr2GiIZ3MLXUpxIaIbCSMzrHONFW3b3KE+b
         RSSlIoGzgvBuw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH] [v2] mlx5: stop warning for 64KB pages
Date:   Fri, 15 Oct 2021 17:20:33 +0200
Message-Id: <20211015152056.2434853-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

When building with 64KB pages, clang points out that xsk->chunk_size
can never be PAGE_SIZE:

drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c:19:22: error: result of comparison of constant 65536 with expression of type 'u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (xsk->chunk_size > PAGE_SIZE ||
            ~~~~~~~~~~~~~~~ ^ ~~~~~~~~~

In older versions of this code, using PAGE_SIZE was the only
possibility, so this would have never worked on 64KB page kernels,
but the patch apparently did not address this case completely.

As Maxim Mikityanskiy suggested, 64KB chunks are really not all that
useful, so just shut up the warning by adding a cast.

Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
Link: https://lore.kernel.org/netdev/20211013150232.2942146-1-arnd@kernel.org/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 538bc2419bd8..228257010f32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -15,8 +15,10 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5e_xsk_param *xsk,
 			      struct mlx5_core_dev *mdev)
 {
-	/* AF_XDP doesn't support frames larger than PAGE_SIZE. */
-	if (xsk->chunk_size > PAGE_SIZE ||
+	/* AF_XDP doesn't support frames larger than PAGE_SIZE,
+	 * and xsk->chunk_size is limited to 65535 bytes.
+	 */
+	if ((size_t)xsk->chunk_size > PAGE_SIZE ||
 			xsk->chunk_size < MLX5E_MIN_XSK_CHUNK_SIZE)
 		return false;
 
-- 
2.29.2

