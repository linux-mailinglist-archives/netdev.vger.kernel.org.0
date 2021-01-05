Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3652EB5DD
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbhAEXGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbhAEXG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B42230FE;
        Tue,  5 Jan 2021 23:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887910;
        bh=/Eaxy0e78MeJceupv+Tq6Gbr88AqRdyBDkqCMbg12rI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okvzPsVGGdF68dj7mOXbJVibocglTKg728Udo0dwpgM1rLWRBltv88oupMsK2mH+l
         O8M6QDTa7FXDmQRibhCNL/fNh0wLWrIKE2ZYkXJ5Hzl5KbSMDca1k4NFMUUOfzt5w7
         x3ZDGYjescY79ozIx0u/VmtL2CJ+fyty69IV6eXbep9yVeLhi32s/OG2WUDjrkemsi
         VBYDIiTlIdIkxp9eSKBSB/2G54nRu3ChmNAMc0Jz2mPCdkt/zKpQcyUFdD6Pvz+aca
         JH5bGS5JG9v5kcjdJQPtEHOlSHXqm+GaL+vAUcoxAg3OjkExRPCOypTwKlWZhGu1+4
         XUA7dvZyOzzcA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5: DR, Fix STEv0 source_eswitch_owner_vhca_id support
Date:   Tue,  5 Jan 2021 15:03:23 -0800
Message-Id: <20210105230333.239456-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Check vport_cap only if match on source gvmi is required.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 97ba875999eb..3ce3197aaf90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1227,23 +1227,26 @@ dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 			caps = &dmn->peer_dmn->info.caps;
 		else
 			return -EINVAL;
+
+		misc->source_eswitch_owner_vhca_id = 0;
 	} else {
 		caps = &dmn->info.caps;
 	}
 
-	vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
-	if (!vport_cap) {
-		mlx5dr_err(dmn, "Vport 0x%x is invalid\n",
-			   misc->source_port);
-		return -EINVAL;
-	}
-
 	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
-	if (vport_cap->vport_gvmi && source_gvmi_set)
-		MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
+	if (source_gvmi_set) {
+		vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
+		if (!vport_cap) {
+			mlx5dr_err(dmn, "Vport 0x%x is invalid\n",
+				   misc->source_port);
+			return -EINVAL;
+		}
 
-	misc->source_eswitch_owner_vhca_id = 0;
-	misc->source_port = 0;
+		if (vport_cap->vport_gvmi)
+			MLX5_SET(ste_src_gvmi_qp, tag, source_gvmi, vport_cap->vport_gvmi);
+
+		misc->source_port = 0;
+	}
 
 	return 0;
 }
-- 
2.26.2

