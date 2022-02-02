Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE594A6B32
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiBBFGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233011AbiBBFGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 00:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E219C061748
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 21:06:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1584DB83014
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 05:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D01BC340EB;
        Wed,  2 Feb 2022 05:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643778395;
        bh=b5fP7pSV1RBRPm2DQ9cYIiKepHH7PQofKQgqJubPDA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dX7fVHDG/MAemD0y2qM0Zbz3mdNy/LKgCOwuDzkAvXT5ymurLDKZnqrQ1F51RhXuZ
         aq8c8d9XlgosPZuGMNmIekjnhMdFLnucn4RTNg2y/DN5bbbXoP1A2nObeuAlEAA3mJ
         M+kCV50v9jUz4CXdET7JA7n/jKQwb4kL6R3MixJmJp/1sFGqc+il1UOw7LqBRGeci0
         eVnw40kOrqX8BIeD8y4ScwqheuIp5O8UiNkL7D8L5n0u3njlN13E83FLnlZzEL3pKt
         jE0aTqoBaklnEsKqB90pqMalw96BmxrrewXEgUrf19zoVlAaS9uZBdyEwaVOoc9AGs
         p14TBD5Km9uFg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/18] net/mlx5: Fix offloading with ESWITCH_IPV4_TTL_MODIFY_ENABLE
Date:   Tue,  1 Feb 2022 21:03:53 -0800
Message-Id: <20220202050404.100122-8-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220202050404.100122-1-saeed@kernel.org>
References: <20220202050404.100122-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Only prio 1 is supported for nic mode when there is no ignore flow level
support in firmware. But for switchdev mode, which supports fixed number
of statically pre-allocated prios, this restriction is not relevant so
it can be relaxed.

Fixes: d671e109bd85 ("net/mlx5: Fix tc max supported prio for nic mode")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index d5e47630e284..e94233a12a32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -121,12 +121,13 @@ u32 mlx5_chains_get_nf_ft_chain(struct mlx5_fs_chains *chains)
 
 u32 mlx5_chains_get_prio_range(struct mlx5_fs_chains *chains)
 {
-	if (!mlx5_chains_prios_supported(chains))
-		return 1;
-
 	if (mlx5_chains_ignore_flow_level_supported(chains))
 		return UINT_MAX;
 
+	if (!chains->dev->priv.eswitch ||
+	    chains->dev->priv.eswitch->mode != MLX5_ESWITCH_OFFLOADS)
+		return 1;
+
 	/* We should get here only for eswitch case */
 	return FDB_TC_MAX_PRIO;
 }
-- 
2.34.1

