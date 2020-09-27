Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82463279F64
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgI0Hu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:58 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50747 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730482AbgI0Hux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1F43048C;
        Sun, 27 Sep 2020 03:50:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dirBKxVGy6Ikug9LVHWixmi3U4PDHsrnLns+5H+t3/4=; b=lTp3cH2q
        99uxbm2FrpHcEVeMjwl9d4sGnA3wtycZ0A20+5Ai2xwujw/pvfG1Kjlv2LVdEGEc
        DI+yqZqbtB1Xcy+bxBRohovD2N3Fnu71r51SBYBu8M78WOHY6p0PpeJROjcEs8Bh
        MDfukLRSUFLS3PcUxNTvGR0I2hav80DOUqrXgGK/3nK0Au4avidFoC6+ew9+F+vo
        aja0JVE+s406CJ1gzQFvbtTmy23wroKuy9lZJF2U2hxmRfA+uwNODW0YNLLWxcJ2
        T/L96fH3/dW90t7TEso4YA1UpCTMMUKULdbCr4TmoE9DcDyinS6N/kGr3jYL4Geg
        w+WsH3z7Q5G5Xw==
X-ME-Sender: <xms:W0RwX5_EgIIOT8MsGVXzVNDy0mMrej-3vB_E_YiCN-aYzFfkHE30EQ>
    <xme:W0RwX9utBK5NeLekCP9Oa0n7L3irZ_-W9tRcAcv6ep30Zg3FTaNvEPbEWoTxcIjUt
    oHTNvU4izlARwc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W0RwX3AgdXNMxEC784lL_XMV2xYEQ5KtVukpQ6dTjseTtS9vg3ccYw>
    <xmx:W0RwX9fbJrB5KfljrVaW_Sx6LEifZtyaAk2rmhwARM1DY3tE8TyOxQ>
    <xmx:W0RwX-OIhkI2EKrj823Nmw8i9VLC5tkiNFCvk38pMLG5dfKEhPDCbg>
    <xmx:W0RwX7rCcwKc7GlcGCh5O50ShcAEvJS7-IJTNrdwpQWoBEQKcFbu8Q>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CC2E3280059;
        Sun, 27 Sep 2020 03:50:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: core: Add an infrastructure to track transceiver overheat counter
Date:   Sun, 27 Sep 2020 10:50:10 +0300
Message-Id: <20200927075015.1417714-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Initialize an array that stores per-module overheat state and a counter
indicating how many times the module was in overheat state.

Export a function to query the counter according to module number.
Will be used later on by the switch driver (i.e., mlxsw_spectrum) to expose
module's overheat counter as part of ethtool statistics.

Initialize mlxsw_env after driver initialization to be able to query
number of modules from MGPIR register.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 22 +++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  2 +
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 66 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  6 ++
 4 files changed, 96 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index f8dddcf461f5..916c641b02e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -26,6 +26,7 @@
 #include <trace/events/devlink.h>
 
 #include "core.h"
+#include "core_env.h"
 #include "item.h"
 #include "cmd.h"
 #include "port.h"
@@ -87,6 +88,8 @@ struct mlxsw_core {
 	struct {
 		struct devlink_health_reporter *fw_fatal;
 	} health;
+	struct mlxsw_env *env;
+	bool is_initialized; /* Denotes if core was already initialized. */
 	unsigned long driver_priv[];
 	/* driver_priv has to be always the last item */
 };
@@ -1943,6 +1946,11 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
+	err = mlxsw_env_init(mlxsw_core, &mlxsw_core->env);
+	if (err)
+		goto err_env_init;
+
+	mlxsw_core->is_initialized = true;
 	devlink_params_publish(devlink);
 
 	if (!reload)
@@ -1950,6 +1958,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 
 	return 0;
 
+err_env_init:
+	mlxsw_thermal_fini(mlxsw_core->thermal);
 err_thermal_init:
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 err_hwmon_init:
@@ -2026,6 +2036,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	}
 
 	devlink_params_unpublish(devlink);
+	mlxsw_core->is_initialized = false;
+	mlxsw_env_fini(mlxsw_core->env);
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 	if (mlxsw_core->driver->fini)
@@ -2829,6 +2841,16 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_port_devlink_port_get);
 
+struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->env;
+}
+
+bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->is_initialized;
+}
+
 int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module)
 {
 	enum mlxsw_reg_pmtm_module_type module_type;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 2ca085a44774..3948ad865aba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -221,6 +221,8 @@ enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u8 local_port);
+struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core);
+bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core);
 int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module);
 
 int mlxsw_core_schedule_dw(struct delayed_work *dwork, unsigned long delay);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 056eeb85be60..35ea4d519046 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -10,6 +10,18 @@
 #include "item.h"
 #include "reg.h"
 
+struct mlxsw_env_module_info {
+	u64 module_overheat_counter;
+	bool is_overheat;
+};
+
+struct mlxsw_env {
+	struct mlxsw_core *core;
+	u8 module_count;
+	spinlock_t module_info_lock; /* Protects 'module_info'. */
+	struct mlxsw_env_module_info module_info[];
+};
+
 static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
 					  bool *qsfp, bool *cmis)
 {
@@ -293,3 +305,57 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom);
+
+int
+mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
+				      u64 *p_counter)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	/* Prevent switch driver from accessing uninitialized data. */
+	if (!mlxsw_core_is_initialized(mlxsw_core)) {
+		*p_counter = 0;
+		return 0;
+	}
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return -EINVAL;
+
+	spin_lock_bh(&mlxsw_env->module_info_lock);
+	*p_counter = mlxsw_env->module_info[module].module_overheat_counter;
+	spin_unlock_bh(&mlxsw_env->module_info_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_env_module_overheat_counter_get);
+
+int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
+{
+	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
+	struct mlxsw_env *env;
+	u8 module_count;
+	int err;
+
+	mlxsw_reg_mgpir_pack(mgpir_pl);
+	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgpir), mgpir_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, &module_count);
+
+	env = kzalloc(struct_size(env, module_info, module_count), GFP_KERNEL);
+	if (!env)
+		return -ENOMEM;
+
+	spin_lock_init(&env->module_info_lock);
+	env->core = mlxsw_core;
+	env->module_count = module_count;
+	*p_env = env;
+
+	return 0;
+}
+
+void mlxsw_env_fini(struct mlxsw_env *env)
+{
+	kfree(env);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 064d0e770c01..8e36a2634ef5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -14,4 +14,10 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 				struct mlxsw_core *mlxsw_core, int module,
 				struct ethtool_eeprom *ee, u8 *data);
 
+int
+mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
+				      u64 *p_counter);
+int mlxsw_env_init(struct mlxsw_core *core, struct mlxsw_env **p_env);
+void mlxsw_env_fini(struct mlxsw_env *env);
+
 #endif
-- 
2.26.2

