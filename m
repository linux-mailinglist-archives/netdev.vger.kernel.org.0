Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A07263735E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiKXILA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiKXIK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:10:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A852D33BA
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 00:10:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C924B82704
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DA3C433D7;
        Thu, 24 Nov 2022 08:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669277453;
        bh=khjJkojcNnCKvh1dzIKZUOkyUwHAA88apXyvnJZBxlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpA+N6PyPvqj94eJqmVI0HABur4QfQCYXTPtnysgm5QBcUsBWd8qMEvsHcww55esx
         Rz8W7lTHQJcUP7AnDv/BKu9Sd7LFCk1r/jDlH4Vs5b5RGn9kV8x25pvfL5XMN0tDsI
         EDDwrD//SwZFMDRXSkfOK3IZRak1bXKfnKzzrXYcg+G9c+VQfb16dNG19a7lPOSLrr
         yIA7SUbRUcF/Vs+bBY84HPvtF0+Go4dXKbpFPaqSHCN5RjeFrgdF/tx9Bso+BWvE48
         t9KXaD2AqLSUcvHsPEk9BaaJyrgqqPytUQ8wKdx4r5shOM63nMa2vi06MBT3xA4O5X
         KjMfgPu+If2lA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [net 02/15] net/mlx5: E-switch, Destroy legacy fdb table when needed
Date:   Thu, 24 Nov 2022 00:10:27 -0800
Message-Id: <20221124081040.171790-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221124081040.171790-1-saeed@kernel.org>
References: <20221124081040.171790-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

The cited commit removes eswitch mode none. But when disabling
sriov in legacy mode or changing from switchdev to legacy mode
without sriov enabled, the legacy fdb table is not destroyed.

It is not the right behavior. Destroy legacy fdb table in above
two caes.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 2169486c4bfb..374e3fbdc2cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1362,6 +1362,9 @@ void mlx5_eswitch_disable_sriov(struct mlx5_eswitch *esw, bool clear_vf)
 
 		devl_rate_nodes_destroy(devlink);
 	}
+	/* Destroy legacy fdb when disabling sriov in legacy mode. */
+	if (esw->mode == MLX5_ESWITCH_LEGACY)
+		mlx5_eswitch_disable_locked(esw);
 
 	esw->esw_funcs.num_vfs = 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3fda75fe168c..8c6c9bcb3dc3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3387,6 +3387,13 @@ static int esw_offloads_stop(struct mlx5_eswitch *esw,
 	int err;
 
 	esw->mode = MLX5_ESWITCH_LEGACY;
+
+	/* If changing from switchdev to legacy mode without sriov enabled,
+	 * no need to create legacy fdb.
+	 */
+	if (!mlx5_sriov_is_enabled(esw->dev))
+		return 0;
+
 	err = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_IGNORE_NUM_VFS);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "Failed setting eswitch to legacy");
-- 
2.38.1

