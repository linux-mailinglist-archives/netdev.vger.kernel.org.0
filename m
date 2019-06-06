Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CBC3726D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 13:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfFFLGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 07:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfFFLGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 07:06:25 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3917206E0;
        Thu,  6 Jun 2019 11:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559819184;
        bh=MggCww4Nr90s9KcsmgOFeKOEH5YQAz9EHIrC4YOrP80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlNFXI2JRGUyWmQUEMMPi1uhTKv1TNV0DV2sLfdorrtsLoRq5pzk/9jCDZSMfqZiw
         84bT0rsLr2Wie/BqzyKk4PatLboohWu6SXQUc3O72yvRHkT/gd6P5/Ci6RpYPdEy70
         9qS8nod7xCP0NL9K+XNxMmQuFSarkZo+l2g/ssL8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Date:   Thu,  6 Jun 2019 14:06:07 +0300
Message-Id: <20190606110609.11588-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606110609.11588-1-leon@kernel.org>
References: <20190606110609.11588-1-leon@kernel.org>
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
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 10 ++++++++++
 include/linux/mlx5/eswitch.h                      | 10 ++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9ea0ccfe5ef5..1da7f9569ee8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2452,6 +2452,16 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
 
+u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev)
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
index 0ca77dd1429c..7be43c0fcdc5 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -7,6 +7,7 @@
 #define _MLX5_ESWITCH_
 
 #include <linux/mlx5/driver.h>
+#include <net/devlink.h>
 
 #define MLX5_ESWITCH_MANAGER(mdev) MLX5_CAP_GEN(mdev, eswitch_manager)
 
@@ -60,4 +61,13 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
 struct mlx5_flow_handle *
 mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *esw,
 				    int vport, u32 sqn);
+
+#ifdef CONFIG_MLX5_ESWITCH
+u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev);
+#else  /* CONFIG_MLX5_ESWITCH */
+static inline u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev)
+{
+	return DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+}
+#endif /* CONFIG_MLX5_ESWITCH */
 #endif
-- 
2.20.1

