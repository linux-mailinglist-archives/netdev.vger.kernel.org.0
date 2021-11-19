Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E172457781
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 20:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236145AbhKSUB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234831AbhKSUB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:01:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8107961B64;
        Fri, 19 Nov 2021 19:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637351901;
        bh=NlHjzJgC+IgFmW2P0M4wM3Q40FPd902yn4nJK07Dh5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b++iiRXZvsQJZlsPiwxNEdggkNjhhYumq4ZgifOMRbLiVhpisE3mORAb4Y+RR+rNC
         RJjQ7imNxaVZzwkR1ULj44WQdvTJVgCuAVkUP5QkTOo0Tc8TMbMc0cKOyGbuPq9/UZ
         uiMZjpeSrt4atraZSngQJr1gjrhaRGTs79u905CW+Ve8srGkHGlIrGlgOBd2Eymhad
         93NMAR10TH0P/1srgqmIRNzhUwApe/Tr2x6upqrdOLTmuhRj3qgmUT1l3Zv5wmoRGZ
         657BOHh131uqUI9zGgCbhKdRYQGoSoX7x5NXam3hGX/k0ewWF+gJQL0jeXgIn/6qU4
         DBDzMZlAfeclw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/10] net/mlx5e: Fix missing IPsec statistics on uplink representor
Date:   Fri, 19 Nov 2021 11:58:10 -0800
Message-Id: <20211119195813.739586-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119195813.739586-1-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited patch added the IPsec support to uplink representor, however
as uplink representors have his private statistics where IPsec stats
is not part of it, that effectively makes IPsec stats hidden when uplink
representor stats queried.

Resolve by adding IPsec stats to uplink representor private statistics.

Fixes: 5589b8f1a2c7 ("net/mlx5e: Add IPsec support to uplink representor")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index e58a9ec42553..48895d79796a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1080,6 +1080,10 @@ static mlx5e_stats_grp_t mlx5e_ul_rep_stats_grps[] = {
 	&MLX5E_STATS_GRP(pme),
 	&MLX5E_STATS_GRP(channels),
 	&MLX5E_STATS_GRP(per_port_buff_congest),
+#ifdef CONFIG_MLX5_EN_IPSEC
+	&MLX5E_STATS_GRP(ipsec_sw),
+	&MLX5E_STATS_GRP(ipsec_hw),
+#endif
 };
 
 static unsigned int mlx5e_ul_rep_stats_grps_num(struct mlx5e_priv *priv)
-- 
2.31.1

