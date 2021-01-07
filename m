Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616412EE6E0
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbhAGUaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbhAGUaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10CDF2343F;
        Thu,  7 Jan 2021 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051348;
        bh=SmI+QERz+duPWFe/vpfv9Fb7pCG5rt36FhOAP1uIgus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+srJFPyF2IKb9TkkIwYTCrvbpNCm7Be+KfNEZUO7ONMGMZt0/7lvUecY0Ift0qrj
         r7k0T+4Ip1GmSxyXxXiQkIeNuO2NWYaxGtq4+atnjGyYnvKYRAYtXAEebi9Gxo5zCv
         nYMGHU8vphRN3aSiNv9tFiV0a9T7IYMAC1vVQ6kBom35ZmbEdpxyufNpV6NaXiCW8N
         TVazkDO9wV6Eq08Q6hnBNQNoEk/wqhpNRnc+CAE3hP+3YRvQ4yFzQfOcSEJD2ars3h
         kf2TPClhn799lDJd5/3d6CzUXytHsH6UEDHvx5fBp6REH8G3bbFajZqSlPpm18WduF
         6sorvN+TydF3w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 06/11] net/mlx5: E-Switch, fix changing vf VLANID
Date:   Thu,  7 Jan 2021 12:28:40 -0800
Message-Id: <20210107202845.470205-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

Adding vf VLANID for the first time, or after having cleared previously
defined VLANID works fine, however, attempting to change an existing vf
VLANID clears the rules on the firmware, but does not add new rules for
the new vf VLANID.

Fix this by changing the logic in function esw_acl_egress_lgcy_setup()
so that it will always configure egress rules.

Fixes: ea651a86d468 ("net/mlx5: E-Switch, Refactor eswitch egress acl codes")
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c  | 27 +++++++++----------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 2b85d4777303..3e19b1721303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -95,22 +95,21 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 		return 0;
 	}
 
-	if (!IS_ERR_OR_NULL(vport->egress.acl))
-		return 0;
-
-	vport->egress.acl = esw_acl_table_create(esw, vport->vport,
-						 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
-						 table_size);
-	if (IS_ERR(vport->egress.acl)) {
-		err = PTR_ERR(vport->egress.acl);
-		vport->egress.acl = NULL;
-		goto out;
+	if (!vport->egress.acl) {
+		vport->egress.acl = esw_acl_table_create(esw, vport->vport,
+							 MLX5_FLOW_NAMESPACE_ESW_EGRESS,
+							 table_size);
+		if (IS_ERR(vport->egress.acl)) {
+			err = PTR_ERR(vport->egress.acl);
+			vport->egress.acl = NULL;
+			goto out;
+		}
+
+		err = esw_acl_egress_lgcy_groups_create(esw, vport);
+		if (err)
+			goto out;
 	}
 
-	err = esw_acl_egress_lgcy_groups_create(esw, vport);
-	if (err)
-		goto out;
-
 	esw_debug(esw->dev,
 		  "vport[%d] configure egress rules, vlan(%d) qos(%d)\n",
 		  vport->vport, vport->info.vlan, vport->info.qos);
-- 
2.26.2

