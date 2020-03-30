Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DFC1984B1
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgC3Tjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:39 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43137 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727996AbgC3Tjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0581958070A;
        Mon, 30 Mar 2020 15:39:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=YzOQ4F/FEeHly30zJCUDmNxum/TJ5bLwf4STPfBpyEw=; b=1Hhwvm77
        jSvcn9GqWhTnCmqyWxl+Ww6kgySnVykBimAMdY6OxF2k/KQOKzjr9I/Sc7Jd3TEN
        kU0wKL7Ytq1EJA/HzFxnjEUGFxuda+1IggxEb8gN7W2N50bTxmyQyiyNUK0DWNqm
        Gu/EXH1nIvKem5aRkTYDzCR+43Ai0psR1bQFUBqaK4vOQcQIyzv4quS8eLoCAMoZ
        JW2z9meudnyb1Vt1z/zXLvkmMQSiVmxLb5M64FW4RkXljMw1XxojT5ho6n0Ba7qE
        AsYX1zwPqb7orTtImvX4UnhjtzX+AsTEzJTduPWhe94yxX8gPSBgtO+kcaY70rsx
        CGQERj2zFrq/5w==
X-ME-Sender: <xms:-EqCXvYv9aeKJ2LRTFarQjaPmDR1nRB8jBuguygSTPFLPCF50ZESMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihgu
    ohhstghhrdhorhhg
X-ME-Proxy: <xmx:-EqCXnlFAYn647KOXgBuiOfdeImjyFtwWuDkx3Ti2J_KKbeD8vLavw>
    <xmx:-EqCXmN9bhBf8XqRDFxFe6QIHPZE0O_rRaFgqo2hQaOJhA2kPU6sZQ>
    <xmx:-EqCXrZXXsS-ZqWNsujMaz64KDLNpuvsJF_W6ycCvGBW3iuMuNg0eA>
    <xmx:-UqCXtcsj_fdJU1p0wHftVb3fInSf9B7Wx5pUo9rJwz5igUCU8tFHw>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id D85F6306CA45;
        Mon, 30 Mar 2020 15:39:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 14/15] mlxsw: spectrum_trap: Add support for setting of packet trap group parameters
Date:   Mon, 30 Mar 2020 22:38:31 +0300
Message-Id: <20200330193832.2359876-15-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
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
index e8cbbadbcb06..ca56e72cb4b7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1023,6 +1023,9 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
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

