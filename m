Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA9220728
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 10:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgGOI2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 04:28:14 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55911 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730047AbgGOI2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 04:28:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B0F65C013E;
        Wed, 15 Jul 2020 04:28:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 15 Jul 2020 04:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dqRa5IzjOLAmalr3b6EARGESHCkXJYChxR2tWJPao20=; b=br0j7hTO
        PGpHm0FnS8wjcG8lCr847/mC/g0lXZpIih+ARXLZ9zlF4MpfY237qiKYsMEfEoTr
        1dU0sJAL8CSWS9k/K9zSBBd/UZB8jRq7Fp0D9KBFzRM1n719osxvS7st//3ryJIt
        dHRZShOXEEYjYI9u5YX1thgHUge8ggUqsQK50p+6diQDporql6xjdv60Gow6JHx3
        RgIbpiHV9YqRR6cfKw38td+fZ6kOo6J2GZp8g3NH/k2pzFtTlX3eAmR6vBDP91zp
        oXJynWZIgOHPPzWVLcb1SrekedeDN0dKWXfmjQcCHSzAIe8eLChz0ODyWh75v7AI
        oCesgJj4P6g0+g==
X-ME-Sender: <xms:Gr4OX1RO52wAGEc9Jm7iLrFk7Vf2WReGO6cwZ5zNmAFdgp97srxr3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedvgddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeelrddukedt
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Gr4OX-ztQYRDXlQVMbknCY5e0nYVAunCdqkBZYSaccgIs2MPZTwxFg>
    <xmx:Gr4OX62txICisKGkYgx5GqUpMp4kqshg7s6Ecm0h7qh0Y1FyCA43Hg>
    <xmx:Gr4OX9DMJu7slDWmvIb-Vmz4fztqIW6gFMYFweblkvDVoU6lw5-pTg>
    <xmx:Gr4OXxsbEorMew0Vz54dwkNf4hEgfs2UgFU_THp4822-Y1SBrYqVwg>
Received: from shredder.mtl.com (bzq-109-65-139-180.red.bezeqint.net [109.65.139.180])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82FE43280064;
        Wed, 15 Jul 2020 04:28:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/11] mlxsw: spectrum_policer: Add devlink resource support
Date:   Wed, 15 Jul 2020 11:27:26 +0300
Message-Id: <20200715082733.429610-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715082733.429610-1-idosch@idosch.org>
References: <20200715082733.429610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Expose via devlink-resource the maximum number of single-rate policers
and their current occupancy. Example:

$ devlink resource show pci/0000:01:00.0
...
  name global_policers size 1000 unit entry dpipe_tables none
    resources:
      name single_rate_policers size 968 occ 0 unit entry dpipe_tables none

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  8 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +
 .../mellanox/mlxsw/spectrum_policer.c         | 65 +++++++++++++++++++
 3 files changed, 76 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c6ab61818800..519eb44e4097 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3352,6 +3352,10 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_resources_counter_register;
 
+	err = mlxsw_sp_policer_resources_register(mlxsw_core);
+	if (err)
+		goto err_resources_counter_register;
+
 	return 0;
 
 err_resources_counter_register:
@@ -3376,6 +3380,10 @@ static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 	if (err)
 		goto err_resources_counter_register;
 
+	err = mlxsw_sp_policer_resources_register(mlxsw_core);
+	if (err)
+		goto err_resources_counter_register;
+
 	return 0;
 
 err_resources_counter_register:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 82227e87ef7c..defe1d82d83e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -62,6 +62,8 @@ enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_COUNTERS,
 	MLXSW_SP_RESOURCE_COUNTERS_FLOW,
 	MLXSW_SP_RESOURCE_COUNTERS_RIF,
+	MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
+	MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
 };
 
 struct mlxsw_sp_port;
@@ -1227,5 +1229,6 @@ int mlxsw_sp_policer_drops_counter_get(struct mlxsw_sp *mlxsw_sp,
 				       u16 policer_index, u64 *p_drops);
 int mlxsw_sp_policers_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_policers_fini(struct mlxsw_sp *mlxsw_sp);
+int mlxsw_sp_policer_resources_register(struct mlxsw_core *mlxsw_core);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
index 74766e936e0a..39052e5c12fd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
@@ -5,6 +5,7 @@
 #include <linux/log2.h>
 #include <linux/mutex.h>
 #include <linux/netlink.h>
+#include <net/devlink.h>
 
 #include "spectrum.h"
 
@@ -16,6 +17,7 @@ struct mlxsw_sp_policer_family {
 	u16 end_index; /* Exclusive */
 	struct idr policer_idr;
 	struct mutex lock; /* Protects policer_idr */
+	atomic_t policers_count;
 	const struct mlxsw_sp_policer_family_ops *ops;
 };
 
@@ -67,10 +69,18 @@ static u8 mlxsw_sp_policer_burst_bytes_hw_units(u64 burst_bytes)
 	return fls64(bs512) - 1;
 }
 
+static u64 mlxsw_sp_policer_single_rate_occ_get(void *priv)
+{
+	struct mlxsw_sp_policer_family *family = priv;
+
+	return atomic_read(&family->policers_count);
+}
+
 static int
 mlxsw_sp_policer_single_rate_family_init(struct mlxsw_sp_policer_family *family)
 {
 	struct mlxsw_core *core = family->mlxsw_sp->core;
+	struct devlink *devlink;
 
 	/* CPU policers are allocated from the first N policers in the global
 	 * range, so skip them.
@@ -82,12 +92,24 @@ mlxsw_sp_policer_single_rate_family_init(struct mlxsw_sp_policer_family *family)
 	family->start_index = MLXSW_CORE_RES_GET(core, MAX_CPU_POLICERS);
 	family->end_index = MLXSW_CORE_RES_GET(core, MAX_GLOBAL_POLICERS);
 
+	atomic_set(&family->policers_count, 0);
+	devlink = priv_to_devlink(core);
+	devlink_resource_occ_get_register(devlink,
+					  MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
+					  mlxsw_sp_policer_single_rate_occ_get,
+					  family);
+
 	return 0;
 }
 
 static void
 mlxsw_sp_policer_single_rate_family_fini(struct mlxsw_sp_policer_family *family)
 {
+	struct devlink *devlink = priv_to_devlink(family->mlxsw_sp->core);
+
+	devlink_resource_occ_get_unregister(devlink,
+					    MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS);
+	WARN_ON(atomic_read(&family->policers_count) != 0);
 }
 
 static int
@@ -104,6 +126,7 @@ mlxsw_sp_policer_single_rate_index_alloc(struct mlxsw_sp_policer_family *family,
 	if (id < 0)
 		return id;
 
+	atomic_inc(&family->policers_count);
 	policer->index = id;
 
 	return 0;
@@ -115,6 +138,8 @@ mlxsw_sp_policer_single_rate_index_free(struct mlxsw_sp_policer_family *family,
 {
 	struct mlxsw_sp_policer *policer;
 
+	atomic_dec(&family->policers_count);
+
 	mutex_lock(&family->lock);
 	policer = idr_remove(&family->policer_idr, policer_index);
 	mutex_unlock(&family->lock);
@@ -376,6 +401,46 @@ void mlxsw_sp_policers_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp->policer_core);
 }
 
+int mlxsw_sp_policer_resources_register(struct mlxsw_core *mlxsw_core)
+{
+	u64 global_policers, cpu_policers, single_rate_policers;
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_resource_size_params size_params;
+	int err;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, MAX_GLOBAL_POLICERS) ||
+	    !MLXSW_CORE_RES_VALID(mlxsw_core, MAX_CPU_POLICERS))
+		return -EIO;
+
+	global_policers = MLXSW_CORE_RES_GET(mlxsw_core, MAX_GLOBAL_POLICERS);
+	cpu_policers = MLXSW_CORE_RES_GET(mlxsw_core, MAX_CPU_POLICERS);
+	single_rate_policers = global_policers - cpu_policers;
+
+	devlink_resource_size_params_init(&size_params, global_policers,
+					  global_policers, 1,
+					  DEVLINK_RESOURCE_UNIT_ENTRY);
+	err = devlink_resource_register(devlink, "global_policers",
+					global_policers,
+					MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
+					DEVLINK_RESOURCE_ID_PARENT_TOP,
+					&size_params);
+	if (err)
+		return err;
+
+	devlink_resource_size_params_init(&size_params, single_rate_policers,
+					  single_rate_policers, 1,
+					  DEVLINK_RESOURCE_UNIT_ENTRY);
+	err = devlink_resource_register(devlink, "single_rate_policers",
+					single_rate_policers,
+					MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
+					MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
+					&size_params);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int
 mlxsw_sp1_policer_core_init(struct mlxsw_sp_policer_core *policer_core)
 {
-- 
2.26.2

