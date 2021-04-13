Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAD335E70E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 21:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345972AbhDMTax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 15:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345330AbhDMTat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 15:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E3D613CD;
        Tue, 13 Apr 2021 19:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618342229;
        bh=QE5BjsecPS8smzIIeP1Gy3FWZzvWrJ7/XLdUReSmp4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nynHV+boBxwwfKnt2NS9P2Bunk1iQ+fLgGOkdTU+umgC8dyIZHtp/2KMVtc3X5hwS
         MhtyrcsbZY1ABA5F/WHK4mxAc/z4M0AEYNSYwfXmrlhpNy0r9+qN121hJCQAL/vCrj
         dqbZljsF7YGRGKMoZiFD9Oxc61jtaZpNYD2LjBzBe+oLLwTqOfJRWHiv42x2Lwlmd+
         MErrkQkkG/z/GEnTyehN3CEWDUa8WhMkIxH79VJERCQH1SItmRVNwKVSVD6j4T7XEa
         tLZ0MSQjQLWMDd7YMxAm3Qc526ehW4T3mMbi6OOpLye+gchzNnBBw024aIvWVCbSGW
         71fdp9KyC6y5A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5: E-Switch, Skip querying SF enabled bits
Date:   Tue, 13 Apr 2021 12:29:52 -0700
Message-Id: <20210413193006.21650-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413193006.21650-1-saeed@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

With vhca events, SF state is queried through the VHCA events. Device no
longer expects SF bitmap in the query eswitch functions command.

Hence, remove it to simplify the code.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6cf04a366f99..b3bc82e419b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1390,15 +1390,9 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_esw_functions_out);
 	u32 in[MLX5_ST_SZ_DW(query_esw_functions_in)] = {};
-	u16 max_sf_vports;
 	u32 *out;
 	int err;
 
-	max_sf_vports = mlx5_sf_max_functions(dev);
-	/* Device interface is array of 64-bits */
-	if (max_sf_vports)
-		outlen += DIV_ROUND_UP(max_sf_vports, BITS_PER_TYPE(__be64)) * sizeof(__be64);
-
 	out = kvzalloc(outlen, GFP_KERNEL);
 	if (!out)
 		return ERR_PTR(-ENOMEM);
-- 
2.30.2

