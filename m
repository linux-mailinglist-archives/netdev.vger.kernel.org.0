Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37F6311B57
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhBFFIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231293AbhBFFGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6215F64FCE;
        Sat,  6 Feb 2021 05:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587765;
        bh=r1Llu03Lov+LtJ2ei10+zqTfoCnw/qK/e9YHy/uI3J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gIT+W6tQKpqMUMyANHrDJaq3SbLpwO3L7aMMFYmKvN1zzdC21BG2yIHc0HfsFos/h
         OWo/yU4wZ/UAm2yW8rYZoavKr7FGOHZyDSoPgfhsBmyQv9EBuZRkRrhQygz7uBY8Bl
         +1/azWEFOhFPrpJQ6GgYtj0S+5/PEs1t1Ws1HXWATdUmVKyuiMtMJerCpA3+jiK+Cq
         3otOp7zqOTE8GVuB+MQ/0lshSPqW3jrcpnVv7ITyX+MHok/E5jiZGVpvXUD7YqnnzR
         Te29UvXAyoxXA3tsgt7VoSlOwePb2HBENVJXaYEhm6XWgUAMAZFLKNYYXFpe4pziNq
         P1W8+VeTzb9jQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 08/17] net/mlx5e: Remove redundant match on tunnel destination mac
Date:   Fri,  5 Feb 2021 21:02:31 -0800
Message-Id: <20210206050240.48410-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Remove hardcoded match on tunnel destination MAC address. Such match is no
longer required and would be wrong for stacked devices topology where
encapsulation destination MAC address will be the address of tunnel VF that
can change dynamically on route change (implemented in following patches in
the series).

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 3e18ca200c86..13aa98b82576 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -642,14 +642,6 @@ int mlx5e_tc_tun_parse(struct net_device *filter_dev,
 		}
 	}
 
-	/* Enforce DMAC when offloading incoming tunneled flows.
-	 * Flow counters require a match on the DMAC.
-	 */
-	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, dmac_47_16);
-	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, dmac_15_0);
-	ether_addr_copy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				     dmac_47_16), priv->netdev->dev_addr);
-
 	/* let software handle IP fragments */
 	MLX5_SET(fte_match_set_lyr_2_4, headers_c, frag, 1);
 	MLX5_SET(fte_match_set_lyr_2_4, headers_v, frag, 0);
-- 
2.29.2

