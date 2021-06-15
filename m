Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F14F3A758B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 06:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhFOED7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 00:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230038AbhFOEDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 00:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C49611CE;
        Tue, 15 Jun 2021 04:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623729694;
        bh=PwhOJwj6bsdX5gOz+61Gope61BVtX4eLabWC8qGTRlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqd7yIt8/d58ZdgCTH2AocEGZUo6FBvKTya+ZQlEGQ4Y0fTnbVRUJhX9fws1iTEFU
         sbXZMRKE9L2o7eVobPnVyNTVb02CbYJzp9tkPYdQkQKpvkZdzAgUYtYccq/lLVdQFe
         /pIsWHAlIldbNHgw5pY03TrIrdUwlRqB6d1wluzxBh2B9RTE1dU6sp25hw5dDspV/d
         PGPxHpFuvlI0OubY4z+EDXIBtIVokCeEJUJa+XUlSXniL8yHNJVDfq1O1kB+NTd/Jm
         5AYDEE6OPCWLREgB41GgLsUnoG8RXTWCpvAPmHc/5JUBhEavrSRIrqU8un1aRUbYN6
         C5ncH2yEBqo1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Separate between public and private API of sf.h
Date:   Mon, 14 Jun 2021 21:01:22 -0700
Message-Id: <20210615040123.287101-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210615040123.287101-1-saeed@kernel.org>
References: <20210615040123.287101-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Move mlx5_sf_max_functions() and friends from the privete sf/sf.h
to the public lib/sf.h. This is done in order to have one direction
include paths.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lib/sf.h  | 45 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   | 37 +--------------
 2 files changed, 46 insertions(+), 36 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h
new file mode 100644
index 000000000000..84e5683861be
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies Ltd */
+
+#ifndef __LIB_MLX5_SF_H__
+#define __LIB_MLX5_SF_H__
+
+#include <linux/mlx5/driver.h>
+
+static inline u16 mlx5_sf_start_function_id(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf_base_id);
+}
+
+#ifdef CONFIG_MLX5_SF
+
+static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return MLX5_CAP_GEN(dev, sf);
+}
+
+static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
+{
+	if (!mlx5_sf_supported(dev))
+		return 0;
+	if (MLX5_CAP_GEN(dev, max_num_sf))
+		return MLX5_CAP_GEN(dev, max_num_sf);
+	else
+		return 1 << MLX5_CAP_GEN(dev, log_max_sf);
+}
+
+#else
+
+static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
+{
+	return false;
+}
+
+static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
+{
+	return 0;
+}
+
+#endif
+
+#endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 0b6aea1e6a94..81ce13b19ee8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -5,42 +5,7 @@
 #define __MLX5_SF_H__
 
 #include <linux/mlx5/driver.h>
-
-static inline u16 mlx5_sf_start_function_id(const struct mlx5_core_dev *dev)
-{
-	return MLX5_CAP_GEN(dev, sf_base_id);
-}
-
-#ifdef CONFIG_MLX5_SF
-
-static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
-{
-	return MLX5_CAP_GEN(dev, sf);
-}
-
-static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
-{
-	if (!mlx5_sf_supported(dev))
-		return 0;
-	if (MLX5_CAP_GEN(dev, max_num_sf))
-		return MLX5_CAP_GEN(dev, max_num_sf);
-	else
-		return 1 << MLX5_CAP_GEN(dev, log_max_sf);
-}
-
-#else
-
-static inline bool mlx5_sf_supported(const struct mlx5_core_dev *dev)
-{
-	return false;
-}
-
-static inline u16 mlx5_sf_max_functions(const struct mlx5_core_dev *dev)
-{
-	return 0;
-}
-
-#endif
+#include "lib/sf.h"
 
 #ifdef CONFIG_MLX5_SF_MANAGER
 
-- 
2.31.1

