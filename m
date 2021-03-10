Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBB633477D
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhCJTEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233747AbhCJTD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:03:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F1E64FD3;
        Wed, 10 Mar 2021 19:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403038;
        bh=Qvqevhn9kI9HjQVN5NPV3LLNlAClju92nhxZYdNi2qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=En5+iijF8bi311FTmhSdLXFeYUbT3KR+pBO+Dzu5uLRp3TU4pEP7hZsAWAEbcB6MK
         kay0ADZZH5w8hIXAwWGz+mEwUPhNvBDhtmX441AxQm6jak6PdgOSU7KhH+NXAAZo72
         XhH98klAW50opS3izf2yvxPOGA/n9WWz1n8WD78hYLDfSwipIUFOk4J7zpLRmzFVv7
         hhlNZhoiwj6rb/OQ0faSjj6Hfz1vA11YsJrmtc692xdzx1rlY+Pju6qD9PqldCbXB1
         UKCEvynAryuNx82GmVQvQl/UDGA4VyTr6J1eVlhVyJzIAlvFFVCDH77pgKCpw37Uj/
         Q4l7UXKE9Qvdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/18] net/mlx5: Disable VF tunnel TX offload if ignore_flow_level isn't supported
Date:   Wed, 10 Mar 2021 11:03:34 -0800
Message-Id: <20210310190342.238957-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

VF tunnel TX traffic offload is adding flow which forward to flow
tables with lower level, which isn't support on all FW versions
and may cause firmware to fail with syndrome.

Fixed by enabling VF tunnel TX offload only if flow table capability
ignore_flow_level is enabled.

Fixes: 10742efc20a4 ("net/mlx5e: VF tunnel TX traffic offloading")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 94cb0217b4f3..8694b83968b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -551,7 +551,8 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 
 	if (!mlx5_eswitch_termtbl_required(esw, attr, flow_act, spec) &&
 	    MLX5_CAP_GEN(esw_attr->in_mdev, reg_c_preserve) &&
-	    mlx5_eswitch_vport_match_metadata_enabled(esw))
+	    mlx5_eswitch_vport_match_metadata_enabled(esw) &&
+	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, ignore_flow_level))
 		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
 
 	if (attr->dest_ft) {
-- 
2.29.2

