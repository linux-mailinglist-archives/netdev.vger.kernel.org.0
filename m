Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1426847CB96
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242095AbhLVDQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44954 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242086AbhLVDQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 218FB6185F
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0A1C36AEC;
        Wed, 22 Dec 2021 03:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142971;
        bh=TdGaHimoncM6PvSwWMQoAedLKlSL/wkzYBD/HICFiR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WehaZe42Qv9KqEeOWmD7rBnAUYBDU4Tj8wGSzk1hv/r4Sz6XwqBnuQxx3Vr70JQQS
         zS0WlJ2aL1AUChZWiqtJo/0Qu6vYHI9feo4a+Ief2LdDG+gq1KZubDfbLCX2xviQ7X
         O4+iCRrzb3S9+kwFMthOcOnBeI+Zux5Pb64uXJZCLPjtjrxkWAleVk68lR2QZlmejK
         pvJxAwCtfhf7+m/47HFznR3OyxlcW/ex1FimM7i9Um4jCgCWtRR+vfBeijr80ghf0u
         D8mzaHnM5OaVyVApvZsObkUFz2plTCbxQe0ezeZVupYbyOxQX8+TnP2vpIApMi+9c/
         GXmokqexTWXsA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 02/14] net/mlx5: Let user configure io_eq_size param
Date:   Tue, 21 Dec 2021 19:15:52 -0800
Message-Id: <20211222031604.14540-3-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211222031604.14540-1-saeed@kernel.org>
References: <20211222031604.14540-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Currently, each I/O EQ is taking 128KB of memory. This size
is not needed in all use cases, and is critical with large scale.
Hence, allow user to configure the size of I/O EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink dev param set pci/0000:00:0b.0 name io_eq_size value 64 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst      |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c  | 14 ++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c   | 18 +++++++++++++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 4e4b97f7971a..291e7f63af73 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -14,8 +14,12 @@ Parameters
 
    * - Name
      - Mode
+     - Validation
    * - ``enable_roce``
      - driverinit
+   * - ``io_eq_size``
+     - driverinit
+     - The range is between 64 and 4096.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c98652b244a..177c6e9159f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -546,6 +546,13 @@ static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32
 	return 0;
 }
 
+static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
+					  union devlink_param_value val,
+					  struct netlink_ext_ack *extack)
+{
+	return (val.vu16 >= 64 && val.vu16 <= 4096) ? 0 : -EINVAL;
+}
+
 static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_DRIVER(MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
 			     "flow_steering_mode", DEVLINK_PARAM_TYPE_STRING,
@@ -570,6 +577,8 @@ static const struct devlink_param mlx5_devlink_params[] = {
 	DEVLINK_PARAM_GENERIC(ENABLE_REMOTE_DEV_RESET, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
 			      mlx5_devlink_enable_remote_dev_reset_get,
 			      mlx5_devlink_enable_remote_dev_reset_set, NULL),
+	DEVLINK_PARAM_GENERIC(IO_EQ_SIZE, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_eq_depth_validate),
 };
 
 static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
@@ -608,6 +617,11 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 						   value);
 	}
 #endif
+
+	value.vu32 = MLX5_COMP_EQ_SIZE;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+					   value);
 }
 
 static const struct devlink_param enable_eth_param =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index 792e0d6aa861..7686d7c9c824 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -19,6 +19,7 @@
 #include "lib/clock.h"
 #include "diag/fw_tracer.h"
 #include "mlx5_irq.h"
+#include "devlink.h"
 
 enum {
 	MLX5_EQE_OWNER_INIT_VAL	= 0x1,
@@ -796,6 +797,21 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
 	}
 }
 
+static u16 comp_eq_depth_devlink_param_get(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+						 &val);
+	if (!err)
+		return val.vu32;
+	mlx5_core_dbg(dev, "Failed to get param. using default. err = %d\n", err);
+	return MLX5_COMP_EQ_SIZE;
+}
+
 static int create_comp_eqs(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eq_table *table = dev->priv.eq_table;
@@ -807,7 +823,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
 
 	INIT_LIST_HEAD(&table->comp_eqs_list);
 	ncomp_eqs = table->num_comp_eqs;
-	nent = MLX5_COMP_EQ_SIZE;
+	nent = comp_eq_depth_devlink_param_get(dev);
 	for (i = 0; i < ncomp_eqs; i++) {
 		struct mlx5_eq_param param = {};
 		int vecidx = i;
-- 
2.33.1

