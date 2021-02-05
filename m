Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5FF310517
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhBEGpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhBEGp3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:45:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6256D64FBF;
        Fri,  5 Feb 2021 06:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507452;
        bh=r1Llu03Lov+LtJ2ei10+zqTfoCnw/qK/e9YHy/uI3J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0cvOo9ACgdJIF48g7v27r+oEOBKcxQ3D7Pn8wA9GC95YBlP4esunjLcKPuahKs5E
         JD/fjfm0Wgh9M8TN21yEOkrP5Iu3xOa8Ar/dzSOUge4ImlwsiqoXuirK2N3PAvL2vF
         YSy4vZlNIgu1aez+rLGWoSr07yNX33APyXvpPC5axxORdWLOFNs4x/9S6vLRbGlG66
         jGeCKGiFOro3C2oI+pL5NlB8nYq1+dLBcgFjoPVutcfHxJHD/7VTZ0iGbC8FHSimti
         FrivFvI3rqmTQ0QhUcvan/eLzWLsu0jvWWgh3lPg4tIiGLMOjMfu6WQyiCTimKrk5V
         nBWN9AbBefXdA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/17] net/mlx5e: Remove redundant match on tunnel destination mac
Date:   Thu,  4 Feb 2021 22:40:42 -0800
Message-Id: <20210205064051.89592-9-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210205064051.89592-1-saeed@kernel.org>
References: <20210205064051.89592-1-saeed@kernel.org>
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

