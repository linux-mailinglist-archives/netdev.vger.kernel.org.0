Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D940C375
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 12:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbhIOKPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 06:15:06 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57301 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237489AbhIOKO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 06:14:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id B41BA5C0192;
        Wed, 15 Sep 2021 06:13:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 15 Sep 2021 06:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=l3711131HSxcMf8peIhcaU7aAh7ZBQkDiybrlyerhgE=; b=kwwQuCOI
        FfNl2LVAyY/7wvg42qCZSwke2+vyCJC//rN4CrRCnvhp52d1s1KQamRKgKneZZ9s
        KgHW9Imk0bgRVlSGMMqRDaJkTI4OskMCRdyynT/q/SdJRm3Y2HL6KtFzALswazZG
        a353g33R9A8/xTpXRSvENwAM0gl2K1sb90LsHf26QewY5C+eEmzsSPwxa4XrBiOn
        YwZJeS6v6T1RrUR3QFB35ThtJvEAb3fdKHdaIimqj99GV7DXrknoKagH3h1lUV4S
        B5smRr39wZKmpqpgWnttXCBBWR4C9F31KlOiOW30hygD2C69VNJDwJkQd1OBY8Ye
        qME5rxT6cu7qKw==
X-ME-Sender: <xms:VMdBYY2NAaUlZmvhOMpVm_kaCacV-LcGyN_at7-x0Uq2rGDjni0j-A>
    <xme:VMdBYTEPyLIOmCkzKuuPpa6YuD07uO5mvO6OvsSNPXPSvYt71lyeFPBK2D1jl8fdP
    qpn9lf5TwldTRw>
X-ME-Received: <xmr:VMdBYQ7WYFPOAjJOsKu0kNdprbvZ-Dbu_4bqcBApEqcTFOt7iyuCz7YnZj6mZszV5I_JSb2fciTnooknYGpK9AW0JjFEYAlAYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehuddgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:VMdBYR0kVz4XpFsM1SUe2hlT69gK__AxXFstejkQ42K1NJDms1BhUw>
    <xmx:VMdBYbEyjIJ4yiFg5GMLQI23nGb0VkfmaaOd2TA7HnpNwR86lYUVUg>
    <xmx:VMdBYa83T0U2hVabe7xkKlwwwbHQQu5KoodquM2k40ma4HMVi3j0Wg>
    <xmx:VMdBYcPq9PPkTQXIEV-yhOG3yq9zFO1vmllu7Z6Px1KRkrewDXjvlQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Sep 2021 06:13:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: Track per-module port status
Date:   Wed, 15 Sep 2021 13:13:11 +0300
Message-Id: <20210915101314.407476-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915101314.407476-1-idosch@idosch.org>
References: <20210915101314.407476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In the common port module core, track the number of logical ports that
are mapped to the port module and the number of logical ports using it
that are administratively up.

This will be used by later patches to potentially veto and control
certain operations on the module, such as reset and setting its power
mode.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 56 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  9 +++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 20 ++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 37 ++++++++++--
 4 files changed, 113 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 543f401cb5c6..c7b7254061ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -15,6 +15,8 @@
 struct mlxsw_env_module_info {
 	u64 module_overheat_counter;
 	bool is_overheat;
+	int num_ports_mapped;
+	int num_ports_up;
 };
 
 struct mlxsw_env {
@@ -708,6 +710,60 @@ mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_module_overheat_counter_get);
 
+void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+	mlxsw_env->module_info[module].num_ports_mapped++;
+	mutex_unlock(&mlxsw_env->module_info_lock);
+}
+EXPORT_SYMBOL(mlxsw_env_module_port_map);
+
+void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+	mlxsw_env->module_info[module].num_ports_mapped--;
+	mutex_unlock(&mlxsw_env->module_info_lock);
+}
+EXPORT_SYMBOL(mlxsw_env_module_port_unmap);
+
+int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return -EINVAL;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+	mlxsw_env->module_info[module].num_ports_up++;
+	mutex_unlock(&mlxsw_env->module_info_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_env_module_port_up);
+
+void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+		return;
+
+	mutex_lock(&mlxsw_env->module_info_lock);
+	mlxsw_env->module_info[module].num_ports_up--;
+	mutex_unlock(&mlxsw_env->module_info_lock);
+}
+EXPORT_SYMBOL(mlxsw_env_module_port_down);
+
 int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 {
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index 0bf5bd0f8a7e..ba9269f12cb8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -27,6 +27,15 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 int
 mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 				      u64 *p_counter);
+
+void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 module);
+
+void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 module);
+
+int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module);
+
+void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module);
+
 int mlxsw_env_init(struct mlxsw_core *core, struct mlxsw_env **p_env);
 void mlxsw_env_fini(struct mlxsw_env *env);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index d9d56c44e994..a3eca0b56bbe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -54,8 +54,20 @@ static int mlxsw_m_base_mac_get(struct mlxsw_m *mlxsw_m)
 	return 0;
 }
 
-static int mlxsw_m_port_dummy_open_stop(struct net_device *dev)
+static int mlxsw_m_port_open(struct net_device *dev)
 {
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
+	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
+
+	return mlxsw_env_module_port_up(mlxsw_m->core, mlxsw_m_port->module);
+}
+
+static int mlxsw_m_port_stop(struct net_device *dev)
+{
+	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
+	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
+
+	mlxsw_env_module_port_down(mlxsw_m->core, mlxsw_m_port->module);
 	return 0;
 }
 
@@ -70,8 +82,8 @@ mlxsw_m_port_get_devlink_port(struct net_device *dev)
 }
 
 static const struct net_device_ops mlxsw_m_port_netdev_ops = {
-	.ndo_open		= mlxsw_m_port_dummy_open_stop,
-	.ndo_stop		= mlxsw_m_port_dummy_open_stop,
+	.ndo_open		= mlxsw_m_port_open,
+	.ndo_stop		= mlxsw_m_port_stop,
 	.ndo_get_devlink_port	= mlxsw_m_port_get_devlink_port,
 };
 
@@ -266,6 +278,7 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
 
 	if (WARN_ON_ONCE(module >= max_ports))
 		return -EINVAL;
+	mlxsw_env_module_port_map(mlxsw_m->core, module);
 	mlxsw_m->module_to_port[module] = ++mlxsw_m->max_ports;
 
 	return 0;
@@ -274,6 +287,7 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u8 local_port,
 static void mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 module)
 {
 	mlxsw_m->module_to_port[module] = -1;
+	mlxsw_env_module_port_unmap(mlxsw_m->core, module);
 }
 
 static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index cea411884b05..0e81ae723bc8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -539,7 +539,9 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 			 const struct mlxsw_sp_port_mapping *port_mapping)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
-	int i;
+	int i, err;
+
+	mlxsw_env_module_port_map(mlxsw_sp->core, port_mapping->module);
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, port_mapping->width);
@@ -548,36 +550,58 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		mlxsw_reg_pmlp_tx_lane_set(pmlp_pl, i, port_mapping->lane + i); /* Rx & Tx */
 	}
 
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
+	if (err)
+		goto err_pmlp_write;
+	return 0;
+
+err_pmlp_write:
+	mlxsw_env_module_port_unmap(mlxsw_sp->core, port_mapping->module);
+	return err;
 }
 
-static void mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u8 local_port)
+static void mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u8 local_port,
+				       u8 module)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, 0);
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
+	mlxsw_env_module_port_unmap(mlxsw_sp->core, module);
 }
 
 static int mlxsw_sp_port_open(struct net_device *dev)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	int err;
 
-	err = mlxsw_sp_port_admin_status_set(mlxsw_sp_port, true);
+	err = mlxsw_env_module_port_up(mlxsw_sp->core,
+				       mlxsw_sp_port->mapping.module);
 	if (err)
 		return err;
+	err = mlxsw_sp_port_admin_status_set(mlxsw_sp_port, true);
+	if (err)
+		goto err_port_admin_status_set;
 	netif_start_queue(dev);
 	return 0;
+
+err_port_admin_status_set:
+	mlxsw_env_module_port_down(mlxsw_sp->core,
+				   mlxsw_sp_port->mapping.module);
+	return err;
 }
 
 static int mlxsw_sp_port_stop(struct net_device *dev)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
 	netif_stop_queue(dev);
 	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
+	mlxsw_env_module_port_down(mlxsw_sp->core,
+				   mlxsw_sp_port->mapping.module);
 	return 0;
 }
 
@@ -1747,13 +1771,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
 err_port_swid_set:
-	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port);
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, port_mapping->module);
 	return err;
 }
 
 static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	u8 module = mlxsw_sp_port->mapping.module;
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
@@ -1775,7 +1800,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
-	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port);
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, module);
 }
 
 static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
-- 
2.31.1

