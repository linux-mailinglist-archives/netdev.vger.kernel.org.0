Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F98F4256B
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438804AbfFLMU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438793AbfFLMUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:20:24 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADEB208C2;
        Wed, 12 Jun 2019 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560342023;
        bh=q0dYd3C+I7EulnzZY6ybOVE7bqT/pd9j69lygTJmth4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkH44y8wRBmsLQ4xiN1eMlDGu8zT/psAeGfwLdpOFfSpACfF89KT4AbOhb5a0k0GA
         D+q9gx23h6eQhx2oHlk/1ie+9ByA6jf26T6USnjmHP1J5X3xhLxC5xUM/mZl+AiUt1
         kgGIZt9pMGRl9au/k5ROfgojW5xn2m4Tyuiw1Kqg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH mlx5-next v1 2/4] net/mlx5: Expose eswitch encap mode
Date:   Wed, 12 Jun 2019 15:20:12 +0300
Message-Id: <20190612122014.22359-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612122014.22359-1-leon@kernel.org>
References: <20190612122014.22359-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add API to get the current Eswitch encap mode.
It will be used in downstream patches to check if
flow table can be created with encap support or not.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++++++++++
 include/linux/mlx5/eswitch.h                      | 12 ++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9ea0ccfe5ef5..0c68d93bea79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2452,6 +2452,17 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);

+enum devlink_eswitch_encap_mode
+mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
+{
+	struct mlx5_eswitch *esw;
+
+	esw = dev->priv.eswitch;
+	return ESW_ALLOWED(esw) ? esw->offloads.encap :
+		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+}
+EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
+
 bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1)
 {
 	if ((dev0->priv.eswitch->mode == SRIOV_NONE &&
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 0ca77dd1429c..f57c73e81267 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -7,6 +7,7 @@
 #define _MLX5_ESWITCH_

 #include <linux/mlx5/driver.h>
+#include <net/devlink.h>

 #define MLX5_ESWITCH_MANAGER(mdev) MLX5_CAP_GEN(mdev, eswitch_manager)

@@ -60,4 +61,15 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw,
 				    int vport, u32 sqn);
+
+#ifdef CONFIG_MLX5_ESWITCH
+enum devlink_eswitch_encap_mode
+mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev);
+#else  /* CONFIG_MLX5_ESWITCH */
+static inline enum devlink_eswitch_encap_mode
+mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
+{
+	return DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+}
+#endif /* CONFIG_MLX5_ESWITCH */
 #endif
--
2.20.1

