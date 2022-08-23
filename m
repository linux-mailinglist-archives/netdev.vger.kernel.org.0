Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A8B59D0D3
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240317AbiHWF4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240429AbiHWF4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB635F22C
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:56:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFA4661380
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D71DC433B5;
        Tue, 23 Aug 2022 05:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234159;
        bh=XonA59xbsFCmHaUXdH1r3RZkxlW8Zp/3zucbCbkXb8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrJgFtYAsgGmx9eV/hD4BjuHEgguC9RdQN50o0kTL0nDhb0n9dDV518Cb8LabWXmU
         jcCrzA6mjSddQHLmfx7VCB1hzXyAiICeba7HkNRggSjJvUJ2F1yWJBXpDU9TGOzV4h
         G16PapEawPYJX4QwU1DnRglwCXEQ6RysuGDjZpsKcTsfKiwkwbBFBdsIw071pYLFFV
         4rU2N1mOqFa6+Itm08qXADPmV2EHKNXzVt9o70Bhp5iB9xb8jcHU1znDlvV1YQibI8
         X8AFyPJWbCNyW5dTE/cG0tGLJFHWAVJqZKIN51R9XcbJvaQWiRTsPtMqvo5yZECbas
         Giaqi18By6ZUw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: [net-next 15/15] net/mlx5: TC, Add support for SF tunnel offload
Date:   Mon, 22 Aug 2022 22:55:33 -0700
Message-Id: <20220823055533.334471-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

VF tunnel flow already exists and SF tunnel is the
same flow.  Support offloading of tunneling over SF device
by allow to attach an encap route over SF and set to use
indirect flow table on SF.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           | 7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c | 6 +++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0b98e117cc0a..0872a214d2a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1505,8 +1505,11 @@ bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_
 	route_priv = netdev_priv(route_dev);
 	route_mdev = route_priv->mdev;
 
-	if (out_mdev->coredev_type != MLX5_COREDEV_PF ||
-	    route_mdev->coredev_type != MLX5_COREDEV_VF)
+	if (out_mdev->coredev_type != MLX5_COREDEV_PF)
+		return false;
+
+	if (route_mdev->coredev_type != MLX5_COREDEV_VF &&
+	    route_mdev->coredev_type != MLX5_COREDEV_SF)
 		return false;
 
 	return mlx5e_same_hw_devs(out_priv, route_priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
index 0abef71cb839..c9a91158e99c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/indir_table.c
@@ -78,12 +78,16 @@ mlx5_esw_indir_table_needed(struct mlx5_eswitch *esw,
 			    struct mlx5_core_dev *dest_mdev)
 {
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	bool vf_sf_vport;
+
+	vf_sf_vport = mlx5_eswitch_is_vf_vport(esw, vport_num) ||
+		      mlx5_esw_is_sf_vport(esw, vport_num);
 
 	/* Use indirect table for all IP traffic from UL to VF with vport
 	 * destination when source rewrite flag is set.
 	 */
 	return esw_attr->in_rep->vport == MLX5_VPORT_UPLINK &&
-		mlx5_eswitch_is_vf_vport(esw, vport_num) &&
+		vf_sf_vport &&
 		esw->dev == dest_mdev &&
 		attr->ip_version &&
 		attr->flags & MLX5_ATTR_FLAG_SRC_REWRITE;
-- 
2.37.1

