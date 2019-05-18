Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4060B223FF
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 17:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfERP7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 11:59:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57037 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728337AbfERP7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 11:59:17 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6508F2949F;
        Sat, 18 May 2019 11:59:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 18 May 2019 11:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8Y6LV4C138ByHp7mLTygrQ4DTPzA5FAAve5m3ws4y4A=; b=iays8hEZ
        C0jbWW8E6z9hPkWjHsWhdBFet6iTVQ1yft+TsXaqnHnv2/2IUxREEZsyzDQ+8OTO
        2rh4MHmFYDjhCkyfxY5c4IRLItUxqAWuMVSLVeVUseSKLs9V9yIjVNp6Nb9N9EOT
        3vpAG/kh1sgSNm/YyxV/WC1vnqFEszlrH+TsYhw2k1Qk9BmuRjVQVy4vXVcDCfA8
        KG1wqz2pC+XbtlSC4a08iX+qUP3Gwu9F6BgyHOPl3gH36V7fgjOC26OPMFxvuGla
        yNxftzv5S2dHsWiWw13h4wdImryrZYxHPqJk/5ewmBa28mVsV+Ix4OlRRo+SuUTi
        hlsFvUSjS0N1Lg==
X-ME-Sender: <xms:0yvgXL_gSSVObRKv4ZE6hIvqR0vg-WswE-ofLGDSSJdtqnC-z0rTMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtgedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeihedrfeefrddufedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:0yvgXFYyiBs2u20fnSCktImhOxYgTEDZZRQGREtVkKiidwr9oBTLWg>
    <xmx:0yvgXKyc8WSSDcTF-AS696TzRkWAg2VEuSkaIAvxKbDO_XqMK5gakw>
    <xmx:0yvgXD_2nR9xa2TJVcGarRwXX31tG1PxWvwwaGZamHAdCPB-Bm8DJA>
    <xmx:0yvgXPG4vOS_VUpfE3nw-kgF4AtqrTIkel45XLSUKITJDR75x3j03A>
Received: from splinter.mtl.com (bzq-109-65-33-130.red.bezeqint.net [109.65.33.130])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6264780062;
        Sat, 18 May 2019 11:59:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: core: Prevent QSFP module initialization for old hardware
Date:   Sat, 18 May 2019 18:58:28 +0300
Message-Id: <20190518155829.31055-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190518155829.31055-1-idosch@idosch.org>
References: <20190518155829.31055-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Old Mellanox silicons, like switchx-2, switch-ib do not support reading
QSFP modules temperature through MTMP register. Attempt to access this
register on systems equipped with the this kind of silicon will cause
initialization flow failure.
Test for hardware resource capability is added in order to distinct
between old and new silicon - old silicons do not have such capability.

Fixes: 6a79507cfe94 ("mlxsw: core: Extend thermal module with per QSFP module thermal zones")
Fixes: 5c42eaa07bd0 ("mlxsw: core: Extend hwmon interface with QSFP module temperature attributes")
Reported-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c         | 6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h         | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 6 ++++++
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index bcbe07ec22be..6ee6de7f0160 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -122,6 +122,12 @@ void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_driver_priv);
 
+bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->driver->res_query_enabled;
+}
+EXPORT_SYMBOL(mlxsw_core_res_query_enabled);
+
 struct mlxsw_rx_listener_item {
 	struct list_head list;
 	struct mlxsw_rx_listener rxl;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 917be621c904..e3832cb5bdda 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -28,6 +28,8 @@ unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core);
 
 void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
+bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core);
+
 int mlxsw_core_driver_register(struct mlxsw_driver *mlxsw_driver);
 void mlxsw_core_driver_unregister(struct mlxsw_driver *mlxsw_driver);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 6956bbebe2f1..496dc904c5ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -518,6 +518,9 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	u8 width;
 	int err;
 
+	if (!mlxsw_core_res_query_enabled(mlxsw_hwmon->core))
+		return 0;
+
 	/* Add extra attributes for module temperature. Sensor index is
 	 * assigned to sensor_count value, while all indexed before
 	 * sensor_count are already utilized by the sensors connected through
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 472f63f9fac5..d3e851e7ca72 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -740,6 +740,9 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	struct mlxsw_thermal_module *module_tz;
 	int i, err;
 
+	if (!mlxsw_core_res_query_enabled(core))
+		return 0;
+
 	thermal->tz_module_arr = kcalloc(module_count,
 					 sizeof(*thermal->tz_module_arr),
 					 GFP_KERNEL);
@@ -776,6 +779,9 @@ mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal)
 	unsigned int module_count = mlxsw_core_max_ports(thermal->core);
 	int i;
 
+	if (!mlxsw_core_res_query_enabled(thermal->core))
+		return;
+
 	for (i = module_count - 1; i >= 0; i--)
 		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
 	kfree(thermal->tz_module_arr);
-- 
2.20.1

