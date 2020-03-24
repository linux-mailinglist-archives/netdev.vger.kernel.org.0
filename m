Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9AE191A13
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgCXTfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:35:06 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:48805 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727976AbgCXTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:35:06 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id E98295800D2;
        Tue, 24 Mar 2020 15:35:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=xEjTkTA97xTyPWyk78epnRxY0NLPGFhpbCU7D1DaZGk=; b=tCXROPux
        bdhfdxU40UCUvWUHPkMZJ5b3WFaCgbam062PsmfeY/fAadUAob+JWsfQ+rixfcdD
        buN+qGAGj2yWU8ULdpeFU4Jxwsw5pNUtujLjq85C9qH/cUQvU+fs+7nE6P7l3qMB
        X0OjwRugUTxgIwDKFk8p3XUfyXQbXjWvUsgR5c1I2OPoW8QS2MMoHiIcIe116ZKg
        GTAbnuL+NqO/k9w2fuFWau9rcGqaeQ7D6uQx6pGn9nlIXpcghlvJj4GgC9mLoIVy
        u5yrMcZtS/Iv3lek7smmY7/vIlvXes+2Hli7o+TFe54Ak21A6/meQR4AoV6Ex8qX
        y7pyi6tBxTlwTA==
X-ME-Sender: <xms:6GB6XmQAl80UlWNKtq6a50Lo2yYCK4tW_KRCVvZA9Y8PAAxs89K72Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:6GB6XrdwjelgOU6jtTboIggQDXz1l5f22n4DdhFJs1l4OMAl-XrFhQ>
    <xmx:6GB6Xpwazw1cOwQJ7nNMWWJmrIV74aY9_I90YNp3k2AXvUof6rYXWQ>
    <xmx:6GB6XsQ4jvqgWa2D7o6SZhvF0kPUUOXA8WGBcfxoblR65VmoXPVJ5A>
    <xmx:6GB6Xk_069cZhd0E6QfYBCUsOjuXEPooYv6Qe8wZGXYR9Kijgy6UqA>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 153D83065DB4;
        Tue, 24 Mar 2020 15:35:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 14/15] mlxsw: spectrum_trap: Add support for setting of packet trap group parameters
Date:   Tue, 24 Mar 2020 21:32:49 +0200
Message-Id: <20200324193250.1322038-15-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
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
index 9858edf7d2e8..060eba9f908c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1017,6 +1017,9 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
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
index c1eac328607a..a73cd3db03ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -526,8 +526,10 @@ int mlxsw_sp_trap_action_set(struct mlxsw_core *mlxsw_core,
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
@@ -559,11 +561,11 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
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
@@ -573,6 +575,22 @@ int mlxsw_sp_trap_group_init(struct mlxsw_core *mlxsw_core,
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

