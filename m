Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6DD336CEE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhCKHKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231987AbhCKHJm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 02:09:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2031165031;
        Thu, 11 Mar 2021 07:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615446581;
        bh=vFg284oUMrhytgd38KTM3YOTj9Nyp5ieaY2xD7KO6Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ugYuOdp4ONxYl3yNJDje2UGLMhVqgB98vw2Fj2UKC2zIDzBfi6qLXQk8Quwng+ZIF
         8ikl0eZbYwaxN8VfRw5GbrVbjQL2u8lTAJjDkm7HGmQUkbu246RPQEegor7Xmml2YZ
         LGbtdID80468tO2Y7wjQntuSb9SZc+VzVpT9cDN1CdJsm0VVKqI3zouE7kvc/EdmrL
         mv2HyeHvs6kht2ADIT0+UF3/lD9kNiSmMqJamAG9a0m+BnyYElfByvjaeecc/U1fhb
         fdkPe5j7RK1H4lz2bYKIJ9zrAUo32X0PvgfxdSYuQ7hTlHCPJFWTuDZvph0ahRZ+EZ
         KTHaLVsvLPVSQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 4/9] net/mlx5: E-Switch, Add match on vhca id to default send rules
Date:   Wed, 10 Mar 2021 23:09:10 -0800
Message-Id: <20210311070915.321814-5-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311070915.321814-1-saeed@kernel.org>
References: <20210311070915.321814-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Match on the vhca id of the E-Switch owner when creating the send-to-vport
representor rules.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 107b1f208b72..fd5f8b830584 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1055,10 +1055,16 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw, u16 vport,
 	MLX5_SET(fte_match_set_misc, misc, source_sqn, sqn);
 	/* source vport is the esw manager */
 	MLX5_SET(fte_match_set_misc, misc, source_port, esw->manager_vport);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		MLX5_SET(fte_match_set_misc, misc, source_eswitch_owner_vhca_id,
+			 MLX5_CAP_GEN(esw->dev, vhca_id));
 
 	misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_sqn);
 	MLX5_SET_TO_ONES(fte_match_set_misc, misc, source_port);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch))
+		MLX5_SET_TO_ONES(fte_match_set_misc, misc,
+				 source_eswitch_owner_vhca_id);
 
 	spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
@@ -1702,6 +1708,12 @@ static int esw_create_offloads_fdb_tables(struct mlx5_eswitch *esw)
 
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_sqn);
 	MLX5_SET_TO_ONES(fte_match_param, match_criteria, misc_parameters.source_port);
+	if (MLX5_CAP_ESW(esw->dev, merged_eswitch)) {
+		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
+				 misc_parameters.source_eswitch_owner_vhca_id);
+		MLX5_SET(create_flow_group_in, flow_group_in,
+			 source_eswitch_owner_vhca_id_valid, 1);
+	}
 
 	ix = esw->total_vports * MAX_SQ_NVPORTS + MAX_PF_SQ;
 	MLX5_SET(create_flow_group_in, flow_group_in, start_flow_index, 0);
-- 
2.29.2

