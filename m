Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC306196F3A
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgC2SW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:26 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:52939 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgC2SWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:25 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B601A58090B;
        Sun, 29 Mar 2020 14:22:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=/AWrx524wUIvFJXIerdhb/gA9huqWoh0Eei9COsCN9A=; b=zLD4iG9Z
        2ZM6wQqSNBjpQOgKtK8NJoF9a+ytWA/sEiaY9SQMIXzAIV7BCYOWTj4+Il/YlykO
        vpXOpsj8wt9DcWxdaSYAgh1Tg7uoMNnIk7R4F98BOosjxQp9jOcDwch43Wy4FwM0
        0y0JPZnl1xMU5x5T8JmkJxICePMtlWa6LX/2RQcDIj4ep9gOyqqBFHM+A08IZHMT
        OGi6bhFlOH0vMgtAhEVgbQluefmnj4PlopNAUpFHgmoWzXn06rsQq+LG0Fu/Lzwk
        lXbaboA4IBPOTAFwR5GuVW2aDlnjyN8z1ZYHAomIMFZwKYvJ4mWlmCEkeF4kb3YR
        8r8cTAFDJ5U8mg==
X-ME-Sender: <xms:YOeAXrwIwSpV3QERzNuGabx1ZgizOm6lP-m0PLfgVwmV45YGzs7wYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:YOeAXnBlupqqe0eoMxwQ6qtbryrpqM6_wGXBcRuT99duPLL76m3OrA>
    <xmx:YOeAXuPcB-HMVORsUeeODeZO2FWAWICw_A3_e-1QifcBd9FE7tENlA>
    <xmx:YOeAXtplCItQGxq8xH15OF-vXcsCrTXIfz0CmfNaGWhIqwuAC3YvQQ>
    <xmx:YOeAXm6ReQH3eBtnQ6xIly-FOUv8WMFjL99WYJXID0ToQ-c_0emIBA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07BF33280059;
        Sun, 29 Mar 2020 14:22:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/15] mlxsw: spectrum_trap: Prepare policers for registration with devlink
Date:   Sun, 29 Mar 2020 21:21:14 +0300
Message-Id: <20200329182119.2207630-11-idosch@idosch.org>
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

Prepare an array of policer IDs to register with devlink and their
associated parameters.

The array is composed from both policers that are currently bound to
exposed trap groups and policers that are not bound to any trap group.

v2:
* Provide max/min rate/burst size when registering policers

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 74 ++++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  4 +
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 6a77bf236c22..7f10e9cd7870 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
 /* Copyright (c) 2019 Mellanox Technologies. All rights reserved */
 
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <net/devlink.h>
 #include <uapi/linux/devlink.h>
@@ -166,6 +167,18 @@ static void mlxsw_sp_rx_exception_listener(struct sk_buff *skb, u8 local_port,
 	MLXSW_RXL(mlxsw_sp_rx_exception_listener, _id,			      \
 		   _action, false, SP_##_group_id, SET_FW_DEFAULT)
 
+#define MLXSW_SP_TRAP_POLICER(_id, _rate, _burst)			      \
+	DEVLINK_TRAP_POLICER(_id, _rate, _burst,			      \
+			     MLXSW_REG_QPCR_HIGHEST_CIR,		      \
+			     MLXSW_REG_QPCR_LOWEST_CIR,			      \
+			     1 << MLXSW_REG_QPCR_HIGHEST_CBS,		      \
+			     1 << MLXSW_REG_QPCR_LOWEST_CBS)
+
+/* Ordered by policer identifier */
+static const struct devlink_trap_policer mlxsw_sp_trap_policers_arr[] = {
+	MLXSW_SP_TRAP_POLICER(1, 10 * 1024, 128),
+};
+
 static const struct devlink_trap_group mlxsw_sp_trap_groups_arr[] = {
 	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
 	DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 0),
@@ -325,6 +338,58 @@ static int mlxsw_sp_trap_dummy_group_init(struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(htgt), htgt_pl);
 }
 
+static int mlxsw_sp_trap_policers_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+	u64 free_policers = 0;
+	u32 last_id = 0;
+	int i;
+
+	for_each_clear_bit(i, trap->policers_usage, trap->max_policers)
+		free_policers++;
+
+	if (ARRAY_SIZE(mlxsw_sp_trap_policers_arr) > free_policers) {
+		dev_err(mlxsw_sp->bus_info->dev, "Exceeded number of supported packet trap policers\n");
+		return -ENOBUFS;
+	}
+
+	trap->policers_arr = kcalloc(free_policers,
+				     sizeof(struct devlink_trap_policer),
+				     GFP_KERNEL);
+	if (!trap->policers_arr)
+		return -ENOMEM;
+
+	trap->policers_count = free_policers;
+
+	for (i = 0; i < free_policers; i++) {
+		const struct devlink_trap_policer *policer;
+
+		if (i < ARRAY_SIZE(mlxsw_sp_trap_policers_arr)) {
+			policer = &mlxsw_sp_trap_policers_arr[i];
+			trap->policers_arr[i] = *policer;
+			last_id = policer->id;
+		} else {
+			/* Use parameters set for first policer and override
+			 * relevant ones.
+			 */
+			policer = &mlxsw_sp_trap_policers_arr[0];
+			trap->policers_arr[i] = *policer;
+			trap->policers_arr[i].id = ++last_id;
+			trap->policers_arr[i].init_rate = 1;
+			trap->policers_arr[i].init_burst = 16;
+		}
+	}
+
+	return 0;
+}
+
+static void mlxsw_sp_trap_policers_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_trap *trap = mlxsw_sp->trap;
+
+	kfree(trap->policers_arr);
+}
+
 int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 {
 	size_t groups_count = ARRAY_SIZE(mlxsw_sp_trap_groups_arr);
@@ -343,10 +408,14 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 		    ARRAY_SIZE(mlxsw_sp_listeners_arr)))
 		return -EINVAL;
 
+	err = mlxsw_sp_trap_policers_init(mlxsw_sp);
+	if (err)
+		return err;
+
 	err = devlink_trap_groups_register(devlink, mlxsw_sp_trap_groups_arr,
 					   groups_count);
 	if (err)
-		return err;
+		goto err_trap_groups_register;
 
 	err = devlink_traps_register(devlink, mlxsw_sp_traps_arr,
 				     ARRAY_SIZE(mlxsw_sp_traps_arr), mlxsw_sp);
@@ -358,6 +427,8 @@ int mlxsw_sp_devlink_traps_init(struct mlxsw_sp *mlxsw_sp)
 err_traps_register:
 	devlink_trap_groups_unregister(devlink, mlxsw_sp_trap_groups_arr,
 				       groups_count);
+err_trap_groups_register:
+	mlxsw_sp_trap_policers_fini(mlxsw_sp);
 	return err;
 }
 
@@ -370,6 +441,7 @@ void mlxsw_sp_devlink_traps_fini(struct mlxsw_sp *mlxsw_sp)
 				 ARRAY_SIZE(mlxsw_sp_traps_arr));
 	devlink_trap_groups_unregister(devlink, mlxsw_sp_trap_groups_arr,
 				       groups_count);
+	mlxsw_sp_trap_policers_fini(mlxsw_sp);
 }
 
 int mlxsw_sp_trap_init(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
index 12c5641b2165..05bb652b1a76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.h
@@ -4,7 +4,11 @@
 #ifndef _MLXSW_SPECTRUM_TRAP_H
 #define _MLXSW_SPECTRUM_TRAP_H
 
+#include <net/devlink.h>
+
 struct mlxsw_sp_trap {
+	struct devlink_trap_policer *policers_arr; /* Registered policers */
+	u64 policers_count; /* Number of registered policers */
 	u64 max_policers;
 	unsigned long policers_usage[]; /* Usage bitmap */
 };
-- 
2.24.1

