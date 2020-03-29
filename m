Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF03196F3E
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgC2SWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:38 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:52129 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgC2SWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 51C32580907;
        Sun, 29 Mar 2020 14:22:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=JVx9qNvxHRh4FgN0KPugpo0cLHKbmZaAz/VmbLiUfDM=; b=wwpa5xV6
        nthSkQiCQue/TMLqxaIgQJzVqvKnCZSPaAC9sLPcbdG8VTQ4TwMvfE4kUSK00iKH
        FxyliLQcViHsqVhixTAUfPcN9mDQX52CbiIBM/ojLhX+jYFSOoakT+hPAFqZizJ6
        u1pIy66i1+COhvVXIJlTxyqGr3ERxQ8FDvBEtNNb7wVRQzGj7K7LL7AiNCHUljaK
        uN2vxpBs1wSuVdSKzGWeScJoxz5j0ccUDj3emgt8qVFo7R2p1OWtgJxvn4MaqFBg
        pTXDgYn0AH824Aj52gW+TdEFwt35u5/G2hKKgH0OQaEJ+Y61PuzRcxHpyzrCIKqS
        2FaRl9tRlnYQKw==
X-ME-Sender: <xms:bOeAXs5_khTKTeHBNtGrcb7LUHJIPEpr3zwkDlnOily2iX4DJgQZrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:bOeAXnoWZnbBILiRzgvtv07NvJitFds4-zbV6iwULYQDgWnESB30EA>
    <xmx:bOeAXoYh8zuGZHGCATGXUDyg8-rTD2Ekcz1RajvvnPOVyC3e_QV8Vg>
    <xmx:bOeAXiGnWyzkdO91XNXiavss5haBRimpxgaZyRBtWI7uWgxBxCctpA>
    <xmx:bOeAXvRsiqjeomdnimsJdkde4diGxS563tDPfL6_TJqAvH-XBc9e3A>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 999663280059;
        Sun, 29 Mar 2020 14:22:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 14/15] mlxsw: spectrum_trap: Add support for setting of packet trap group parameters
Date:   Sun, 29 Mar 2020 21:21:18 +0300
Message-Id: <20200329182119.2207630-15-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Implement support for setting of packet trap group parameters by
invoking the trap_group_init() callback with the new parameters.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 14 ++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  3 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 28 +++++++++++++++----
 5 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 6d0590375976..e9ccd333f61d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1198,6 +1198,19 @@ mlxsw_devlink_trap_group_init(struct devlink *devlink,
 	return mlxsw_driver->trap_group_init(mlxsw_core, group);
 }
 
+static int
+mlxsw_devlink_trap_group_set(struct devlink *devlink,
+			     const struct devlink_trap_group *group,
+			     const struct devlink_trap_policer *policer)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
+
+	if (!mlxsw_driver->trap_group_set)
+		return -EOPNOTSUPP;
+	return mlxsw_driver->trap_group_set(mlxsw_core, group, policer);
+}
+
 static int
 mlxsw_devlink_trap_policer_init(struct devlink *devlink,
 				const struct devlink_trap_policer *policer)
@@ -1273,6 +1286,7 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 	.trap_fini			= mlxsw_devlink_trap_fini,
 	.trap_action_set		= mlxsw_devlink_trap_action_set,
 	.trap_group_init		= mlxsw_devlink_trap_group_init,
+	.trap_group_set			= mlxsw_devlink_trap_group_set,
 	.trap_policer_init		= mlxsw_devlink_trap_policer_init,
 	.trap_policer_fini		= mlxsw_devlink_trap_policer_fini,
 	.trap_policer_set		= mlxsw_devlink_trap_policer_set,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 035629bc035d..22b0dfa7cfae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -327,6 +327,9 @@ struct mlxsw_driver {
 			       enum devlink_trap_action action);
 	int (*trap_group_init)(struct mlxsw_core *mlxsw_core,
 			       const struct devlink_trap_group *group);
+	int (*trap_group_set)(struct mlxsw_core *mlxsw_core,
+			      const struct devlink_trap_group *group,
+			      const struct devlink_trap_policer *policer);
 	int (*trap_policer_init)(struct mlxsw_core *mlxsw_core,
 				 const struct devlink_trap_policer *policer);
 	void (*trap_policer_fini)(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8e4f334695c0..24ca8d5bc564 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5674,6 +5674,7 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
 	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_group_set			= mlxsw_sp_trap_group_set,
 	.trap_policer_init		= mlxsw_sp_trap_policer_init,
 	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
 	.trap_policer_set		= mlxsw_sp_trap_policer_set,
@@ -5712,6 +5713,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
 	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_group_set			= mlxsw_sp_trap_group_set,
 	.trap_policer_init		= mlxsw_sp_trap_policer_init,
 	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
 	.trap_policer_set		= mlxsw_sp_trap_policer_set,
@@ -5749,6 +5751,7 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.trap_fini			= mlxsw_sp_trap_fini,
 	.trap_action_set		= mlxsw_sp_trap_action_set,
 	.trap_group_init		= mlxsw_sp_trap_group_init,
+	.trap_group_set			= mlxsw_sp_trap_group_set,
 	.trap_policer_init		= mlxsw_sp_trap_policer_init,
 	.trap_policer_fini		= mlxsw_sp_trap_policer_fini,
 	.trap_policer_set		= mlxsw_sp_trap_policer_set,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 268d1e04db2f..ee7d3a6bcc38 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1022,6 +1022,9 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 			     enum devlink_trap_action action);
 int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 			     const struct devlink_trap_group *group);
+int mlxsw_sp_trap_group_set(struct mlxsw_core *mlxsw_core,
+			    const struct devlink_trap_group *group,
+			    const struct devlink_trap_policer *policer);
 int
 mlxsw_sp_trap_policer_init(struct mlxsw_core *mlxsw_core,
 			   const struct devlink_trap_policer *policer);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 4a919121191f..9096ffd89e50 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -537,8 +537,10 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
-int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
-			     const struct devlink_trap_group *group)
+static int
+__mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
+			   const struct devlink_trap_group *group,
+			   u32 policer_id)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	u16 hw_policer_id = MLXSW_REG_HTGT_INVALID_POLICER;
@@ -570,11 +572,11 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 		return -EINVAL;
 	}
 
-	if (group->init_policer_id) {
+	if (policer_id) {
 		struct mlxsw_sp_trap_policer_item *policer_item;
-		u32 id = group->init_policer_id;
 
-		policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp, id);
+		policer_item = mlxsw_sp_trap_policer_item_lookup(mlxsw_sp,
+								 policer_id);
 		if (WARN_ON(!policer_item))
 			return -EINVAL;
 		hw_policer_id = policer_item->hw_id;
@@ -584,6 +586,22 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(htgt), htgt_pl);
 }
 
+int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
+			     const struct devlink_trap_group *group)
+{
+	return __mlxsw_sp_trap_group_init(mlxsw_core, group,
+					  group->init_policer_id);
+}
+
+int mlxsw_sp_trap_group_set(struct mlxsw_core *mlxsw_core,
+			    const struct devlink_trap_group *group,
+			    const struct devlink_trap_policer *policer)
+{
+	u32 policer_id = policer ? policer->id : 0;
+
+	return __mlxsw_sp_trap_group_init(mlxsw_core, group, policer_id);
+}
+
 static struct mlxsw_sp_trap_policer_item *
 mlxsw_sp_trap_policer_item_init(struct mlxsw_sp *mlxsw_sp, u32 id)
 {
-- 
2.24.1

