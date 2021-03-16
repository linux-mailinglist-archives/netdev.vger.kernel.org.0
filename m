Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2412F33E25E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhCPXv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhCPXvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B627064F94;
        Tue, 16 Mar 2021 23:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938677;
        bh=S2u1V2BwRODcaFg9WhF9TZkrmpQsOzZRcbf8ezgerro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfj+Osu0wh5kLHks3OMyBG2ETXOatR0qbgLJhly7KX0cVPukNtqM9BksAfrn6VSqq
         1i3ZHt/BdsqfchKl32LhW4b0Ga+WAbwom6lVg/mEAN8GlQWs4FR8dn/YoY7OU34jNN
         /k2AV22CT4K4txRFtpiG1nhq8J7l/TwvOBe4tKZqkSct654BIM3JVTMtvMz5L85DIw
         tanuYm1+3nGv7duU+PW8moAT3UZ59BkUmlYWFXKVFZMXhxPbdGEk0e8VasB44nJ+d9
         URrtK/+Dt9bFKf6bKeLNYvBYD3FaCPjyupCtFFSX5bAl6Pa/VWL7mqliFUra+qjyy5
         g7NNZuPqHI7gQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Same max num channels for both nic and uplink profiles
Date:   Tue, 16 Mar 2021 16:50:59 -0700
Message-Id: <20210316235112.72626-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

In downstream patches NIC netdev can change profile dynamically from
NIC mode to uplink mode and vise-versa. It is required that both profiles
must advertise the same max amount of tx/rx queues.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index a132fff7a980..9156978c900d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1198,7 +1198,8 @@ static const struct mlx5e_profile mlx5e_uplink_rep_profile = {
 	.update_carrier	        = mlx5e_update_carrier,
 	.rx_handlers            = &mlx5e_rx_handlers_rep,
 	.max_tc			= MLX5E_MAX_NUM_TC,
-	.rq_groups		= MLX5E_NUM_RQ_GROUPS(REGULAR),
+	/* XSK is needed so we can replace profile with NIC netdev */
+	.rq_groups		= MLX5E_NUM_RQ_GROUPS(XSK),
 	.stats_grps		= mlx5e_ul_rep_stats_grps,
 	.stats_grps_num		= mlx5e_ul_rep_stats_grps_num,
 };
-- 
2.30.2

