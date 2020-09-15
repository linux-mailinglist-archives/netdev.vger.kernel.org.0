Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB71C26B03A
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgIOWFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgIOU0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:52 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 524CC21655;
        Tue, 15 Sep 2020 20:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201560;
        bh=89JICqsZB0T3uyP94O987jhlADuKCu2FuCy71ToRpMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCOrsN+gaxrhWjNvWcD1urY/Hq5nTUz7ymv0Yihm2nYvtVdxZVQMwcDT2v9BtN0qj
         wKg6uOUenQkOfcqqmAlafvd7mkPvccZ8CziUuq2YV/Fk9mDq2CoHTu/XCK+gIGXtZp
         cMEL98lneASDp0ucavldmPBLxaPtWBUM55d9nsrg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vu Pham <vuhuong@mellanox.com>,
        Bodong Wang <bodong@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5: E-Switch, Use vport metadata matching by default
Date:   Tue, 15 Sep 2020 13:25:30 -0700
Message-Id: <20200915202533.64389-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vu Pham <vuhuong@mellanox.com>

Multiple features use metadata matching such as bond vport
in live migration, multi-port RoCE mode, stacked devices;
hence, enable vport metadata matching by default.

Fixes: 1e62e222db2e ("net/mlx5: E-Switch, Use vport metadata matching only when mandatory")
Signed-off-by: Vu Pham <vuhuong@mellanox.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/eswitch_offloads.c        | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3321bb1f188d..b23d20e16495 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1864,18 +1864,6 @@ esw_check_vport_match_metadata_supported(const struct mlx5_eswitch *esw)
 	return true;
 }
 
-static bool
-esw_check_vport_match_metadata_mandatory(const struct mlx5_eswitch *esw)
-{
-	return mlx5_core_mp_enabled(esw->dev);
-}
-
-static bool esw_use_vport_metadata(const struct mlx5_eswitch *esw)
-{
-	return esw_check_vport_match_metadata_mandatory(esw) &&
-	       esw_check_vport_match_metadata_supported(esw);
-}
-
 u32 mlx5_esw_match_metadata_alloc(struct mlx5_eswitch *esw)
 {
 	u32 num_vports = GENMASK(ESW_VPORT_BITS - 1, 0) - 1;
@@ -2159,9 +2147,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 
 	err = mlx5_esw_host_number_init(esw);
 	if (err)
-		goto err_vport_metadata;
+		goto err_metadata;
 
-	if (esw_use_vport_metadata(esw))
+	if (esw_check_vport_match_metadata_supported(esw))
 		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
 	err = esw_offloads_metadata_init(esw);
-- 
2.26.2

