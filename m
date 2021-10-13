Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1A742C45D
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 17:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhJMPEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 11:04:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232587AbhJMPEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 11:04:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F91860EBB;
        Wed, 13 Oct 2021 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634137357;
        bh=y1Rpvv6y+NitR+8qwldmLDOxqBM7XyQANkxTD9N2zAo=;
        h=From:To:Cc:Subject:Date:From;
        b=Cibb7xA4JDTHogDnzQPZya8mgpOhMbe8JwTMUDzdrhPvKYcVZ16ruxdFIl63XRTt3
         QW8H+U9u29K6LGMvIcEuHl2zJeMEOWomnQ9rXiACdq6rIj4LpIEvowxcz762DkO6uL
         Gk97jNwxOmh4Ok9R9z1sdw5xRMp6bO3LzxO+gfxHgbHFDGfAgoG3j5EIhmrlZ8x95q
         3iXU4/VQ9XFzVvKAtpVSbj3pEB/9q0FVyDLrjGizAgXIPul2g1unwe94PsUR57m2LN
         k6+0q3Hsa84GrRsebIW9qTzjxOAn9++41KgE1QVcRd1ZGwggp6UPqVhugrt9K3C4FQ
         CAuQ0D7YTf2gA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH] mlx5: allow larger xsk chunk_size
Date:   Wed, 13 Oct 2021 17:02:13 +0200
Message-Id: <20211013150232.2942146-1-arnd@kernel.org>
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

I'm not familiar with the details of this code, but from a quick look
I found that it gets assigned from a 32-bit variable that can be
PAGE_SIZE, and that the layout of 'xsk' is not part of an ABI or
a hardware structure, so extending the members to 32 bits as well
should address both the behavior on 64KB page kernels, and the
warning I saw.

In older versions of this code, using PAGE_SIZE was the only
possibility, so this would have never worked on 64KB page kernels,
but the patch apparently did not address this case completely.

Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
index 879ad46d754e..b4167350b6df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -7,8 +7,8 @@
 #include "en.h"
 
 struct mlx5e_xsk_param {
-	u16 headroom;
-	u16 chunk_size;
+	u32 headroom;
+	u32 chunk_size;
 };
 
 struct mlx5e_lro_param {
-- 
2.29.2

