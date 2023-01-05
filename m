Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D865E495
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjAEESz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjAEESf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882CF3F132;
        Wed,  4 Jan 2023 20:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16BAF61802;
        Thu,  5 Jan 2023 04:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D48C433D2;
        Thu,  5 Jan 2023 04:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672892300;
        bh=8NJ9jXHylmSpcNXSk6eo1ZaUf86NF4MpoN2b/+GVX5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Efz4VcjZjbI/HF80jgt2kS5SeNhN+Innfm4nnirUZXldtsvi1n4/Tcs13bxry/w4o
         nymbp4aITSWreyoXedGuF2pRidfiXySlB8zfA2AeinLFRpHYxL8xWIw/nG4zND9slY
         lUWjFs/LXgaveT4VZgPxxWqNLUyB1VD3cPWC7AaDJa/AAb41XwRvf8rinRvmVBtDDz
         cfHD3ThXqOCk/X5K7KfYWyTORLu+xw6sAGH/G5kz3ZPrh2oe4X6ZUCiOEJy+VSylpx
         cIIYGnIEv1X6zdRevq8xXQ0Swq/DmQ9KjF65PVr85UnwDVxuT7EGVzSROG4L9b4u8n
         TrCkCGrEkFiUw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 7/8] net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
Date:   Wed,  4 Jan 2023 20:17:55 -0800
Message-Id: <20230105041756.677120-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
References: <20230105041756.677120-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

Add steering tables/rules to check if the decrypted traffic is RoCEv2,
if so then forward it to RDMA_RX domain.

Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  37 ++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   6 +-
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.c    | 253 ++++++++++++++++++
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.h    |  17 ++
 7 files changed, 309 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index cd4a1ab0ea78..8415a44fb965 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -97,7 +97,7 @@ mlx5_core-$(CONFIG_MLX5_EN_MACSEC) += en_accel/macsec.o en_accel/macsec_fs.o \
 
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) += en_accel/ipsec.o en_accel/ipsec_rxtx.o \
 				     en_accel/ipsec_stats.o en_accel/ipsec_fs.o \
-				     en_accel/ipsec_offload.o
+				     en_accel/ipsec_offload.o lib/ipsec_fs_roce.o
 
 mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 379c6dc9a3be..d2149f0138d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -87,6 +87,7 @@ enum {
 	MLX5E_ACCEL_FS_POL_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 	MLX5E_ACCEL_FS_ESP_FT_LEVEL,
 	MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
+	MLX5E_ACCEL_FS_ESP_FT_ROCE_LEVEL,
 #endif
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index a92e19c4c499..a72261ce7598 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -141,6 +141,7 @@ struct mlx5e_ipsec {
 	struct mlx5e_ipsec_tx *tx;
 	struct mlx5e_ipsec_aso *aso;
 	struct notifier_block nb;
+	struct mlx5_ipsec_fs *roce_ipsec;
 };
 
 struct mlx5e_ipsec_esn_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9f19f4b59a70..512d4f6e69bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -6,6 +6,7 @@
 #include "en/fs.h"
 #include "ipsec.h"
 #include "fs_core.h"
+#include "lib/ipsec_fs_roce.h"
 
 #define NUM_IPSEC_FTE BIT(15)
 
@@ -166,7 +167,8 @@ static int ipsec_miss_create(struct mlx5_core_dev *mdev,
 	return err;
 }
 
-static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
+static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx, u32 family,
+		       struct mlx5_ipsec_fs *roce_ipsec)
 {
 	mlx5_del_flow_rules(rx->pol.rule);
 	mlx5_destroy_flow_group(rx->pol.group);
@@ -179,6 +181,8 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 	mlx5_del_flow_rules(rx->status.rule);
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 	mlx5_destroy_flow_table(rx->ft.status);
+
+	mlx5_ipsec_fs_roce_rx_destroy(roce_ipsec, family);
 }
 
 static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
@@ -186,18 +190,35 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 {
 	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(ipsec->fs, false);
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
+	struct mlx5_flow_destination default_dest;
 	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_table *ft;
 	int err;
 
+	default_dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
+	err = mlx5_ipsec_fs_roce_rx_create(ipsec->roce_ipsec, ns, &default_dest, family,
+					   MLX5E_ACCEL_FS_ESP_FT_ROCE_LEVEL, MLX5E_NIC_PRIO,
+					   ipsec->mdev);
+	if (err)
+		return err;
+
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 			     MLX5E_NIC_PRIO, 1);
-	if (IS_ERR(ft))
-		return PTR_ERR(ft);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		goto err_fs_ft_status;
+	}
 
 	rx->ft.status = ft;
 
-	dest[0] = mlx5_ttc_get_default_dest(ttc, family2tt(family));
+	ft = mlx5_ipsec_fs_roce_ft_get(ipsec->roce_ipsec, family);
+	if (ft) {
+		dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+		dest[0].ft = ft;
+	} else {
+		dest[0] = default_dest;
+	}
+
 	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 	dest[1].counter_id = mlx5_fc_id(rx->fc->cnt);
 	err = ipsec_status_rule(mdev, rx, dest);
@@ -245,6 +266,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 err_add:
 	mlx5_destroy_flow_table(rx->ft.status);
+err_fs_ft_status:
+	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce_ipsec, family);
 	return err;
 }
 
@@ -304,7 +327,7 @@ static void rx_ft_put(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	mlx5_ttc_fwd_default_dest(ttc, family2tt(family));
 
 	/* remove FT */
-	rx_destroy(mdev, rx);
+	rx_destroy(mdev, rx, family, ipsec->roce_ipsec);
 
 out:
 	mutex_unlock(&rx->ft.mutex);
@@ -1008,6 +1031,8 @@ void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 	if (!ipsec->tx)
 		return;
 
+	mlx5_ipsec_fs_roce_cleanup(ipsec->roce_ipsec);
+
 	ipsec_fs_destroy_counters(ipsec);
 	mutex_destroy(&ipsec->tx->ft.mutex);
 	WARN_ON(ipsec->tx->ft.refcnt);
@@ -1053,6 +1078,8 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 	mutex_init(&ipsec->rx_ipv6->ft.mutex);
 	ipsec->tx->ns = ns;
 
+	ipsec->roce_ipsec = mlx5_ipsec_fs_roce_init(ipsec->mdev);
+
 	return 0;
 
 err_counters:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index eac9fd35129d..cb28cdb59c17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -111,8 +111,10 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 8
+/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy,
+ * IPsec RoCE policy
+ */
+#define KERNEL_NIC_PRIO_NUM_LEVELS 9
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
new file mode 100644
index 000000000000..efc67084f29a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "fs_core.h"
+#include "lib/ipsec_fs_roce.h"
+#include "mlx5_core.h"
+
+struct mlx5_ipsec_miss {
+	struct mlx5_flow_group *group;
+	struct mlx5_flow_handle *rule;
+};
+
+struct mlx5_ipsec_rx_roce {
+	struct mlx5_flow_group *g;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_ipsec_miss roce_miss;
+
+	struct mlx5_flow_table *ft_rdma;
+	struct mlx5_flow_namespace *ns_rdma;
+};
+
+struct mlx5_ipsec_fs {
+	struct mlx5_ipsec_rx_roce ipv4_rx;
+	struct mlx5_ipsec_rx_roce ipv6_rx;
+};
+
+static void ipsec_fs_roce_setup_udp_dport(struct mlx5_flow_spec *spec, u16 dport)
+{
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_UDP);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.udp_dport);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.udp_dport, dport);
+}
+
+static int ipsec_fs_roce_rx_rule_setup(struct mlx5_flow_destination *default_dst,
+				       struct mlx5_ipsec_rx_roce *roce, struct mlx5_core_dev *mdev)
+{
+	struct mlx5_flow_destination dst = {};
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_spec *spec;
+	int err = 0;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	ipsec_fs_roce_setup_udp_dport(spec, ROCE_V2_UDP_DPORT);
+
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_TABLE_TYPE;
+	dst.ft = roce->ft_rdma;
+	rule = mlx5_add_flow_rules(roce->ft, spec, &flow_act, &dst, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add RX roce ipsec rule err=%d\n",
+			      err);
+		goto fail_add_rule;
+	}
+
+	roce->rule = rule;
+
+	memset(spec, 0, sizeof(*spec));
+	rule = mlx5_add_flow_rules(roce->ft, spec, &flow_act, default_dst, 1);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		mlx5_core_err(mdev, "Fail to add RX roce ipsec miss rule err=%d\n",
+			      err);
+		goto fail_add_default_rule;
+	}
+
+	roce->roce_miss.rule = rule;
+
+	kvfree(spec);
+	return 0;
+
+fail_add_default_rule:
+	mlx5_del_flow_rules(roce->rule);
+fail_add_rule:
+	kvfree(spec);
+	return err;
+}
+
+struct mlx5_flow_table *mlx5_ipsec_fs_roce_ft_get(struct mlx5_ipsec_fs *ipsec_roce, u32 family)
+{
+	struct mlx5_ipsec_rx_roce *rx_roce;
+
+	if (!ipsec_roce)
+		return NULL;
+
+	rx_roce = (family == AF_INET) ? &ipsec_roce->ipv4_rx :
+					&ipsec_roce->ipv6_rx;
+
+	return rx_roce->ft;
+}
+
+void mlx5_ipsec_fs_roce_rx_destroy(struct mlx5_ipsec_fs *ipsec_roce, u32 family)
+{
+	struct mlx5_ipsec_rx_roce *rx_roce;
+
+	if (!ipsec_roce)
+		return;
+
+	rx_roce = (family == AF_INET) ? &ipsec_roce->ipv4_rx :
+					&ipsec_roce->ipv6_rx;
+
+	mlx5_del_flow_rules(rx_roce->roce_miss.rule);
+	mlx5_del_flow_rules(rx_roce->rule);
+	mlx5_destroy_flow_table(rx_roce->ft_rdma);
+	mlx5_destroy_flow_group(rx_roce->roce_miss.group);
+	mlx5_destroy_flow_group(rx_roce->g);
+	mlx5_destroy_flow_table(rx_roce->ft);
+}
+
+#define MLX5_RX_ROCE_GROUP_SIZE BIT(0)
+
+int mlx5_ipsec_fs_roce_rx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_namespace *ns,
+				 struct mlx5_flow_destination *default_dst, u32 family, u32 level,
+				 u32 prio, struct mlx5_core_dev *mdev)
+{
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_ipsec_rx_roce *roce;
+	struct mlx5_flow_table *ft;
+	struct mlx5_flow_group *g;
+	void *outer_headers_c;
+	int ix = 0;
+	u32 *in;
+	int err;
+	u8 *mc;
+
+	if (!ipsec_roce)
+		return 0;
+
+	roce = (family == AF_INET) ? &ipsec_roce->ipv4_rx :
+				     &ipsec_roce->ipv6_rx;
+
+	ft_attr.max_fte = 2;
+	ft_attr.level = level;
+	ft_attr.prio = prio;
+	ft = mlx5_create_flow_table(ns, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce ft at nic err=%d\n", err);
+		return err;
+	}
+
+	roce->ft = ft;
+
+	in = kvzalloc(MLX5_ST_SZ_BYTES(create_flow_group_in), GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto fail_nomem;
+	}
+
+	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+	outer_headers_c = MLX5_ADDR_OF(fte_match_param, mc, outer_headers);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, ip_protocol);
+	MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, outer_headers_c, udp_dport);
+
+	MLX5_SET_CFG(in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5_RX_ROCE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	g = mlx5_create_flow_group(ft, in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce group at nic err=%d\n", err);
+		goto fail_group;
+	}
+	roce->g = g;
+
+	memset(in, 0, MLX5_ST_SZ_BYTES(create_flow_group_in));
+	MLX5_SET_CFG(in, start_flow_index, ix);
+	ix += MLX5_RX_ROCE_GROUP_SIZE;
+	MLX5_SET_CFG(in, end_flow_index, ix - 1);
+	g = mlx5_create_flow_group(ft, in);
+	if (IS_ERR(g)) {
+		err = PTR_ERR(g);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce miss group at nic err=%d\n", err);
+		goto fail_mgroup;
+	}
+	roce->roce_miss.group = g;
+
+	memset(&ft_attr, 0, sizeof(ft_attr));
+	if (family == AF_INET)
+		ft_attr.level = 1;
+	ft = mlx5_create_flow_table(roce->ns_rdma, &ft_attr);
+	if (IS_ERR(ft)) {
+		err = PTR_ERR(ft);
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce ft at rdma err=%d\n", err);
+		goto fail_rdma_table;
+	}
+
+	roce->ft_rdma = ft;
+
+	err = ipsec_fs_roce_rx_rule_setup(default_dst, roce, mdev);
+	if (err) {
+		mlx5_core_err(mdev, "Fail to create ipsec rx roce rules err=%d\n", err);
+		goto fail_setup_rule;
+	}
+
+	kvfree(in);
+	return 0;
+
+fail_setup_rule:
+	mlx5_destroy_flow_table(roce->ft_rdma);
+fail_rdma_table:
+	mlx5_destroy_flow_group(roce->roce_miss.group);
+fail_mgroup:
+	mlx5_destroy_flow_group(roce->g);
+fail_group:
+	kvfree(in);
+fail_nomem:
+	mlx5_destroy_flow_table(roce->ft);
+	return err;
+}
+
+void mlx5_ipsec_fs_roce_cleanup(struct mlx5_ipsec_fs *ipsec_roce)
+{
+	kfree(ipsec_roce);
+}
+
+struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_ipsec_fs *roce_ipsec;
+	struct mlx5_flow_namespace *ns;
+
+	if (!mlx5_get_roce_state(mdev))
+		return NULL;
+
+	if (!(MLX5_CAP_GEN_2(mdev, flow_table_type_2_type) &
+	      MLX5_FT_NIC_RX_2_NIC_RX_RDMA)) {
+		mlx5_core_dbg(mdev, "Failed to init roce ipsec flow steering, capabilities not supported\n");
+		return NULL;
+	}
+
+	ns = mlx5_get_flow_namespace(mdev, MLX5_FLOW_NAMESPACE_RDMA_RX_IPSEC);
+	if (!ns) {
+		mlx5_core_err(mdev, "Failed to get roce rx ns\n");
+		return NULL;
+	}
+
+	roce_ipsec = kzalloc(sizeof(*roce_ipsec), GFP_KERNEL);
+	if (!roce_ipsec)
+		return NULL;
+
+	roce_ipsec->ipv4_rx.ns_rdma = ns;
+	roce_ipsec->ipv6_rx.ns_rdma = ns;
+
+	return roce_ipsec;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
new file mode 100644
index 000000000000..75ca8f3df4f5
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_LIB_IPSEC_H__
+#define __MLX5_LIB_IPSEC_H__
+
+struct mlx5_ipsec_fs;
+
+struct mlx5_flow_table *mlx5_ipsec_fs_roce_ft_get(struct mlx5_ipsec_fs *ipsec_roce, u32 family);
+void mlx5_ipsec_fs_roce_rx_destroy(struct mlx5_ipsec_fs *ipsec_roce, u32 family);
+int mlx5_ipsec_fs_roce_rx_create(struct mlx5_ipsec_fs *ipsec_roce, struct mlx5_flow_namespace *ns,
+				 struct mlx5_flow_destination *default_dst, u32 family, u32 level,
+				 u32 prio, struct mlx5_core_dev *mdev);
+void mlx5_ipsec_fs_roce_cleanup(struct mlx5_ipsec_fs *ipsec_roce);
+struct mlx5_ipsec_fs *mlx5_ipsec_fs_roce_init(struct mlx5_core_dev *mdev);
+
+#endif /* __MLX5_LIB_IPSEC_H__ */
-- 
2.38.1

