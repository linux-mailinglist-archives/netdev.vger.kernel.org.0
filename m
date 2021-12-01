Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1631446473C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346972AbhLAGkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237026AbhLAGkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A581B81DDE
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42BFC53FD2;
        Wed,  1 Dec 2021 06:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340642;
        bh=NlHjzJgC+IgFmW2P0M4wM3Q40FPd902yn4nJK07Dh5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbQj10c4PqcIigi4z183xcfd0FxdFm9gXySsKvzxFCZjm37KVgg0OtzkGcdzDPFEq
         Gyaz0CbQ+huTJGMusnvjJySB8Hhw5PKNvqsEyktSNu22bg7mCCIu31+ouuoNh/IobA
         /q3u9CL0bMCKwi00CLFdHjdsFbpVh7WZbrZ0bY55T/pKI0VhOwYG0Ej3tAPl/bQnvS
         LmH5KA1PQH9GU0NIDmutr+z+wa081+lWFLMs3PQotD0BXAiPvOuRla3DmFbrpFUeMI
         kqWX/VbEwUH56iYjI1RuhG8Ve0iYo/IELKm30M9g90IDqHt5LYZVPzH/1bWQmbrvqQ
         JGy5pZSkzFQYA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/13] net/mlx5e: Fix missing IPsec statistics on uplink representor
Date:   Tue, 30 Nov 2021 22:36:58 -0800
Message-Id: <20211201063709.229103-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
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

