Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5142D82C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfE2Irp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55315 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbfE2Iro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8D85D22405;
        Wed, 29 May 2019 04:47:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vop8i05Id7VLWRbhNzHrFADQyhLqjTRnDpcF4k/7Ptk=; b=NbzI7Cx0
        fHs3tAkAKvqMdXgkp4UAynrD6XTz64UQcBwOb5EH7Ru9RDT4n9Ml0oNMCMndKb+2
        u5kFOtvakBLDmTTipNILcfekW2QP0z+62b/2JbLIEnqZv6PiaqSljNbvR72uhop+
        bM4BTrB3I3WIjksAt4UoB6RXJQVmTLfRDDnJY1xxah8sSn5CUCpkI0/tRlIL2zNQ
        oTCtp7f+OeQlEd68UV1he79KN/0yM9jqTuxxZtTZDNatqxBOXiEYWmO1//cRQm+c
        SOwJAOI7/YtG4vodJrUusNDv3PeQbqTS+eLzAeNmgMpyc+za6nCkJgY1e3vlbF3m
        ffpPxSC00SJPpA==
X-ME-Sender: <xms:L0fuXPLRWSZs-3vaoeyvhH6vqA1gBp3DvCy4zyYrctWiprODuD5GTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:L0fuXAqAxZ1etVQ5EmoB-0ajq-BGKZHm_zdHKilmt-ViZzSdp9KuVg>
    <xmx:L0fuXDyWzV3OIb5-2AwpmI8QBvoiKS4J9UGNfWxOsDCnZYdPzmebGw>
    <xmx:L0fuXFrHQ8tIPm0hczOhjm3xWyzSKs8cqkmMbbdFQRcI7Vz2V3bi-Q>
    <xmx:L0fuXPUSkm67U1JwOhOVzUwYqAe_rKYB_PjyoVahS4RCKUEV6j93KQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A52080063;
        Wed, 29 May 2019 04:47:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/8] mlxsw: core: Re-order initialization sequence
Date:   Wed, 29 May 2019 11:47:17 +0300
Message-Id: <20190529084722.22719-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver core first registers with the hwmon and thermal subsystems
and only then proceeds to initialize the switch driver (e.g.,
mlxsw_spectrum). It is only during the last stage that the current
firmware version is validated and a newer one flashed, if necessary.

The above means that if a new firmware feature is utilized by the
hwmon/thermal code, the driver will not be able to load.

Solve this by re-ordering initializing the switch driver before
registering with the hwmon and thermal subsystems.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 6ee6de7f0160..182762898361 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1098,6 +1098,12 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_register_params;
 	}
 
+	if (mlxsw_driver->init) {
+		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info);
+		if (err)
+			goto err_driver_init;
+	}
+
 	err = mlxsw_hwmon_init(mlxsw_core, mlxsw_bus_info, &mlxsw_core->hwmon);
 	if (err)
 		goto err_hwmon_init;
@@ -1107,22 +1113,17 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 	if (err)
 		goto err_thermal_init;
 
-	if (mlxsw_driver->init) {
-		err = mlxsw_driver->init(mlxsw_core, mlxsw_bus_info);
-		if (err)
-			goto err_driver_init;
-	}
-
 	if (mlxsw_driver->params_register && !reload)
 		devlink_params_publish(devlink);
 
 	return 0;
 
-err_driver_init:
-	mlxsw_thermal_fini(mlxsw_core->thermal);
 err_thermal_init:
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
 err_hwmon_init:
+	if (mlxsw_core->driver->fini)
+		mlxsw_core->driver->fini(mlxsw_core);
+err_driver_init:
 	if (mlxsw_driver->params_unregister && !reload)
 		mlxsw_driver->params_unregister(mlxsw_core);
 err_register_params:
@@ -1187,10 +1188,10 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 
 	if (mlxsw_core->driver->params_unregister && !reload)
 		devlink_params_unpublish(devlink);
-	if (mlxsw_core->driver->fini)
-		mlxsw_core->driver->fini(mlxsw_core);
 	mlxsw_thermal_fini(mlxsw_core->thermal);
 	mlxsw_hwmon_fini(mlxsw_core->hwmon);
+	if (mlxsw_core->driver->fini)
+		mlxsw_core->driver->fini(mlxsw_core);
 	if (mlxsw_core->driver->params_unregister && !reload)
 		mlxsw_core->driver->params_unregister(mlxsw_core);
 	if (!reload)
-- 
2.20.1

