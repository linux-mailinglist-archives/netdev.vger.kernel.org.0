Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BDA311B61
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhBFFLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:11:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhBFFGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25F1564FCF;
        Sat,  6 Feb 2021 05:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587767;
        bh=5JiBN74w4+EaImUaKI/eLKl7fzmSuEKY2FMgRcnjaEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6eSE/Wjab+ClQT9XWTFqAPXn/A3IQGSgDnfuLaiLbGUczuf4B3BpBe/EDQq7KiL6
         rv1fgKJsYiUawQiVDbeKkC77jNfWEXQgxuTO4I5C4soLHiAt/d0iTqeF39t9tDIKeg
         0+/Bzd01oPCDdBRtcVZQ0cjfJZHKU/sLw1SZgs2xb+2bR/ea8XOFOtiySAMDKoHPne
         w0o62IBgtc7T5BKZxqk0+E2TC/gBzoLfooGB9TKh1G+rsJ9lywvVnwHnMG1SvHPtxd
         ejz4zB4SxVig7pLT3q+ge4+CODVbk0ZYuFEpqGXNsWd+7AbV8hfoj2fY8WA5h+WKkr
         4vd0mwpuzK0SA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 12/17] net/mlx5e: Extract tc tunnel encap/decap code to dedicated file
Date:   Fri,  5 Feb 2021 21:02:35 -0800
Message-Id: <20210206050240.48410-13-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Following patches in series extend the extracted code with routing
infrastructure. To improve code modularity created a dedicated
tc_tun_encap.c source file and move encap/decap related code to the new
file. Export code that is used by both regular TC code and encap/decap code
into tc_priv.h (new header intended to be used only by TC module). Rename
some exported functions by adding "mlx5e_" prefix to their names.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  | 163 ++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |   1 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 734 ++++++++++++++
 .../mellanox/mlx5/core/en/tc_tun_encap.h      |  30 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 900 +-----------------
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   2 +
 7 files changed, 947 insertions(+), 885 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index f1ccfba60068..8cb2625472c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -40,7 +40,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)     += lag_mp.o lib/geneve.o lib/port_tun.o \
 					en_rep.o en/rep/bond.o en/mod_hdr.o
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/mapping.o lib/fs_chains.o en/tc_tun.o \
-					esw/indir_table.o \
+					esw/indir_table.o en/tc_tun_encap.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
 					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
new file mode 100644
index 000000000000..e0ae24d9a740
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_TC_PRIV_H__
+#define __MLX5_EN_TC_PRIV_H__
+
+#include "en_tc.h"
+
+#define MLX5E_TC_FLOW_BASE (MLX5E_TC_FLAG_LAST_EXPORTED_BIT + 1)
+
+#define MLX5E_TC_MAX_SPLITS 1
+
+enum {
+	MLX5E_TC_FLOW_FLAG_INGRESS               = MLX5E_TC_FLAG_INGRESS_BIT,
+	MLX5E_TC_FLOW_FLAG_EGRESS                = MLX5E_TC_FLAG_EGRESS_BIT,
+	MLX5E_TC_FLOW_FLAG_ESWITCH               = MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_FT                    = MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_NIC                   = MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
+	MLX5E_TC_FLOW_FLAG_OFFLOADED             = MLX5E_TC_FLOW_BASE,
+	MLX5E_TC_FLOW_FLAG_HAIRPIN               = MLX5E_TC_FLOW_BASE + 1,
+	MLX5E_TC_FLOW_FLAG_HAIRPIN_RSS           = MLX5E_TC_FLOW_BASE + 2,
+	MLX5E_TC_FLOW_FLAG_SLOW                  = MLX5E_TC_FLOW_BASE + 3,
+	MLX5E_TC_FLOW_FLAG_DUP                   = MLX5E_TC_FLOW_BASE + 4,
+	MLX5E_TC_FLOW_FLAG_NOT_READY             = MLX5E_TC_FLOW_BASE + 5,
+	MLX5E_TC_FLOW_FLAG_DELETED               = MLX5E_TC_FLOW_BASE + 6,
+	MLX5E_TC_FLOW_FLAG_CT                    = MLX5E_TC_FLOW_BASE + 7,
+	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP        = MLX5E_TC_FLOW_BASE + 8,
+};
+
+struct mlx5e_tc_flow_parse_attr {
+	const struct ip_tunnel_info *tun_info[MLX5_MAX_FLOW_FWD_VPORTS];
+	struct net_device *filter_dev;
+	struct mlx5_flow_spec spec;
+	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
+	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
+	struct ethhdr eth;
+};
+
+/* Helper struct for accessing a struct containing list_head array.
+ * Containing struct
+ *   |- Helper array
+ *      [0] Helper item 0
+ *          |- list_head item 0
+ *          |- index (0)
+ *      [1] Helper item 1
+ *          |- list_head item 1
+ *          |- index (1)
+ * To access the containing struct from one of the list_head items:
+ * 1. Get the helper item from the list_head item using
+ *    helper item =
+ *        container_of(list_head item, helper struct type, list_head field)
+ * 2. Get the contining struct from the helper item and its index in the array:
+ *    containing struct =
+ *        container_of(helper item, containing struct type, helper field[index])
+ */
+struct encap_flow_item {
+	struct mlx5e_encap_entry *e; /* attached encap instance */
+	struct list_head list;
+	int index;
+};
+
+struct mlx5e_tc_flow {
+	struct rhash_head node;
+	struct mlx5e_priv *priv;
+	u64 cookie;
+	unsigned long flags;
+	struct mlx5_flow_handle *rule[MLX5E_TC_MAX_SPLITS + 1];
+
+	/* flows sharing the same reformat object - currently mpls decap */
+	struct list_head l3_to_l2_reformat;
+	struct mlx5e_decap_entry *decap_reformat;
+
+	/* Flow can be associated with multiple encap IDs.
+	 * The number of encaps is bounded by the number of supported
+	 * destinations.
+	 */
+	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
+	struct mlx5e_tc_flow *peer_flow;
+	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
+	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
+	struct list_head hairpin; /* flows sharing the same hairpin */
+	struct list_head peer;    /* flows with peer flow */
+	struct list_head unready; /* flows not ready to be offloaded (e.g
+				   * due to missing route)
+				   */
+	struct net_device *orig_dev; /* netdev adding flow first */
+	int tmp_efi_index;
+	struct list_head tmp_list; /* temporary flow list used by neigh update */
+	refcount_t refcnt;
+	struct rcu_head rcu_head;
+	struct completion init_done;
+	int tunnel_id; /* the mapped tunnel id of this flow */
+	struct mlx5_flow_attr *attr;
+};
+
+u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer);
+
+struct mlx5_flow_handle *
+mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
+			   struct mlx5e_tc_flow *flow,
+			   struct mlx5_flow_spec *spec,
+			   struct mlx5_flow_attr *attr);
+
+bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow);
+
+static inline void __flow_flag_set(struct mlx5e_tc_flow *flow, unsigned long flag)
+{
+	/* Complete all memory stores before setting bit. */
+	smp_mb__before_atomic();
+	set_bit(flag, &flow->flags);
+}
+
+#define flow_flag_set(flow, flag) __flow_flag_set(flow, MLX5E_TC_FLOW_FLAG_##flag)
+
+static inline bool __flow_flag_test_and_set(struct mlx5e_tc_flow *flow,
+					    unsigned long flag)
+{
+	/* test_and_set_bit() provides all necessary barriers */
+	return test_and_set_bit(flag, &flow->flags);
+}
+
+#define flow_flag_test_and_set(flow, flag)			\
+	__flow_flag_test_and_set(flow,				\
+				 MLX5E_TC_FLOW_FLAG_##flag)
+
+static inline void __flow_flag_clear(struct mlx5e_tc_flow *flow, unsigned long flag)
+{
+	/* Complete all memory stores before clearing bit. */
+	smp_mb__before_atomic();
+	clear_bit(flag, &flow->flags);
+}
+
+#define flow_flag_clear(flow, flag) __flow_flag_clear(flow,		\
+						      MLX5E_TC_FLOW_FLAG_##flag)
+
+static inline bool __flow_flag_test(struct mlx5e_tc_flow *flow, unsigned long flag)
+{
+	bool ret = test_bit(flag, &flow->flags);
+
+	/* Read fields of flow structure only after checking flags. */
+	smp_mb__after_atomic();
+	return ret;
+}
+
+#define flow_flag_test(flow, flag) __flow_flag_test(flow,		\
+						    MLX5E_TC_FLOW_FLAG_##flag)
+
+void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
+				       struct mlx5e_tc_flow *flow);
+struct mlx5_flow_handle *
+mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_spec *spec);
+void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
+				  struct mlx5e_tc_flow *flow,
+				  struct mlx5_flow_attr *attr);
+
+struct mlx5e_tc_flow *mlx5e_flow_get(struct mlx5e_tc_flow *flow);
+void mlx5e_flow_put(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow);
+
+struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow);
+
+#endif /* __MLX5_EN_TC_PRIV_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 73deafe4e693..def2335c39e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -6,6 +6,7 @@
 #include <net/geneve.h>
 #include <net/bareudp.h>
 #include "en/tc_tun.h"
+#include "en/tc_priv.h"
 #include "en_tc.h"
 #include "rep/tc.h"
 #include "rep/neigh.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
new file mode 100644
index 000000000000..63652911d56e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -0,0 +1,734 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include "tc_tun_encap.h"
+#include "en_tc.h"
+#include "tc_tun.h"
+#include "rep/tc.h"
+#include "diag/en_tc_tracepoint.h"
+
+int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
+			     struct mlx5_flow_spec *spec)
+{
+	struct mlx5_esw_flow_attr *esw_attr = flow->attr->esw_attr;
+	struct mlx5_rx_tun_attr *tun_attr;
+	void *daddr, *saddr;
+	u8 ip_version;
+
+	tun_attr = kvzalloc(sizeof(*tun_attr), GFP_KERNEL);
+	if (!tun_attr)
+		return -ENOMEM;
+
+	esw_attr->rx_tun_attr = tun_attr;
+	ip_version = mlx5e_tc_get_ip_version(spec, true);
+
+	if (ip_version == 4) {
+		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				     outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+		saddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				     outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
+		tun_attr->dst_ip.v4 = *(__be32 *)daddr;
+		tun_attr->src_ip.v4 = *(__be32 *)saddr;
+	}
+#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
+	else if (ip_version == 6) {
+		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
+
+		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
+		saddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
+		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
+		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
+	}
+#endif
+	return 0;
+}
+
+void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
+			      struct mlx5e_encap_entry *e,
+			      struct list_head *flow_list)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *esw_attr;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *attr;
+	struct mlx5_flow_spec *spec;
+	struct mlx5e_tc_flow *flow;
+	int err;
+
+	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
+						     e->reformat_type,
+						     e->encap_size, e->encap_header,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(e->pkt_reformat)) {
+		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %lu\n",
+			       PTR_ERR(e->pkt_reformat));
+		return;
+	}
+	e->flags |= MLX5_ENCAP_ENTRY_VALID;
+	mlx5e_rep_queue_neigh_stats_work(priv);
+
+	list_for_each_entry(flow, flow_list, tmp_list) {
+		bool all_flow_encaps_valid = true;
+		int i;
+
+		if (!mlx5e_is_offloaded_flow(flow))
+			continue;
+		attr = flow->attr;
+		esw_attr = attr->esw_attr;
+		spec = &attr->parse_attr->spec;
+
+		esw_attr->dests[flow->tmp_efi_index].pkt_reformat = e->pkt_reformat;
+		esw_attr->dests[flow->tmp_efi_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
+		/* Flow can be associated with multiple encap entries.
+		 * Before offloading the flow verify that all of them have
+		 * a valid neighbour.
+		 */
+		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
+			if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP))
+				continue;
+			if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP_VALID)) {
+				all_flow_encaps_valid = false;
+				break;
+			}
+		}
+		/* Do not offload flows with unresolved neighbors */
+		if (!all_flow_encaps_valid)
+			continue;
+		/* update from slow path rule to encap rule */
+		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, attr);
+		if (IS_ERR(rule)) {
+			err = PTR_ERR(rule);
+			mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow, %d\n",
+				       err);
+			continue;
+		}
+
+		mlx5e_tc_unoffload_from_slow_path(esw, flow);
+		flow->rule[0] = rule;
+		/* was unset when slow path rule removed */
+		flow_flag_set(flow, OFFLOADED);
+	}
+}
+
+void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
+			      struct mlx5e_encap_entry *e,
+			      struct list_head *flow_list)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *esw_attr;
+	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_attr *attr;
+	struct mlx5_flow_spec *spec;
+	struct mlx5e_tc_flow *flow;
+	int err;
+
+	list_for_each_entry(flow, flow_list, tmp_list) {
+		if (!mlx5e_is_offloaded_flow(flow))
+			continue;
+		attr = flow->attr;
+		esw_attr = attr->esw_attr;
+		spec = &attr->parse_attr->spec;
+
+		/* update from encap rule to slow path rule */
+		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
+		/* mark the flow's encap dest as non-valid */
+		esw_attr->dests[flow->tmp_efi_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
+
+		if (IS_ERR(rule)) {
+			err = PTR_ERR(rule);
+			mlx5_core_warn(priv->mdev, "Failed to update slow path (encap) flow, %d\n",
+				       err);
+			continue;
+		}
+
+		mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
+		flow->rule[0] = rule;
+		/* was unset when fast path rule removed */
+		flow_flag_set(flow, OFFLOADED);
+	}
+
+	/* we know that the encap is valid */
+	e->flags &= ~MLX5_ENCAP_ENTRY_VALID;
+	mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
+}
+
+/* Takes reference to all flows attached to encap and adds the flows to
+ * flow_list using 'tmp_list' list_head in mlx5e_tc_flow.
+ */
+void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_head *flow_list)
+{
+	struct encap_flow_item *efi;
+	struct mlx5e_tc_flow *flow;
+
+	list_for_each_entry(efi, &e->flows, list) {
+		flow = container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
+		if (IS_ERR(mlx5e_flow_get(flow)))
+			continue;
+		wait_for_completion(&flow->init_done);
+
+		flow->tmp_efi_index = efi->index;
+		list_add(&flow->tmp_list, flow_list);
+	}
+}
+
+static struct mlx5e_encap_entry *
+mlx5e_get_next_valid_encap(struct mlx5e_neigh_hash_entry *nhe,
+			   struct mlx5e_encap_entry *e)
+{
+	struct mlx5e_encap_entry *next = NULL;
+
+retry:
+	rcu_read_lock();
+
+	/* find encap with non-zero reference counter value */
+	for (next = e ?
+		     list_next_or_null_rcu(&nhe->encap_list,
+					   &e->encap_list,
+					   struct mlx5e_encap_entry,
+					   encap_list) :
+		     list_first_or_null_rcu(&nhe->encap_list,
+					    struct mlx5e_encap_entry,
+					    encap_list);
+	     next;
+	     next = list_next_or_null_rcu(&nhe->encap_list,
+					  &next->encap_list,
+					  struct mlx5e_encap_entry,
+					  encap_list))
+		if (mlx5e_encap_take(next))
+			break;
+
+	rcu_read_unlock();
+
+	/* release starting encap */
+	if (e)
+		mlx5e_encap_put(netdev_priv(e->out_dev), e);
+	if (!next)
+		return next;
+
+	/* wait for encap to be fully initialized */
+	wait_for_completion(&next->res_ready);
+	/* continue searching if encap entry is not in valid state after completion */
+	if (!(next->flags & MLX5_ENCAP_ENTRY_VALID)) {
+		e = next;
+		goto retry;
+	}
+
+	return next;
+}
+
+void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
+{
+	struct mlx5e_neigh *m_neigh = &nhe->m_neigh;
+	struct mlx5e_encap_entry *e = NULL;
+	struct mlx5e_tc_flow *flow;
+	struct mlx5_fc *counter;
+	struct neigh_table *tbl;
+	bool neigh_used = false;
+	struct neighbour *n;
+	u64 lastuse;
+
+	if (m_neigh->family == AF_INET)
+		tbl = &arp_tbl;
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (m_neigh->family == AF_INET6)
+		tbl = ipv6_stub->nd_tbl;
+#endif
+	else
+		return;
+
+	/* mlx5e_get_next_valid_encap() releases previous encap before returning
+	 * next one.
+	 */
+	while ((e = mlx5e_get_next_valid_encap(nhe, e)) != NULL) {
+		struct mlx5e_priv *priv = netdev_priv(e->out_dev);
+		struct encap_flow_item *efi, *tmp;
+		struct mlx5_eswitch *esw;
+		LIST_HEAD(flow_list);
+
+		esw = priv->mdev->priv.eswitch;
+		mutex_lock(&esw->offloads.encap_tbl_lock);
+		list_for_each_entry_safe(efi, tmp, &e->flows, list) {
+			flow = container_of(efi, struct mlx5e_tc_flow,
+					    encaps[efi->index]);
+			if (IS_ERR(mlx5e_flow_get(flow)))
+				continue;
+			list_add(&flow->tmp_list, &flow_list);
+
+			if (mlx5e_is_offloaded_flow(flow)) {
+				counter = mlx5e_tc_get_counter(flow);
+				lastuse = mlx5_fc_query_lastuse(counter);
+				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
+					neigh_used = true;
+					break;
+				}
+			}
+		}
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+		mlx5e_put_encap_flow_list(priv, &flow_list);
+		if (neigh_used) {
+			/* release current encap before breaking the loop */
+			mlx5e_encap_put(priv, e);
+			break;
+		}
+	}
+
+	trace_mlx5e_tc_update_neigh_used_value(nhe, neigh_used);
+
+	if (neigh_used) {
+		nhe->reported_lastuse = jiffies;
+
+		/* find the relevant neigh according to the cached device and
+		 * dst ip pair
+		 */
+		n = neigh_lookup(tbl, &m_neigh->dst_ip, m_neigh->dev);
+		if (!n)
+			return;
+
+		neigh_event_send(n, NULL);
+		neigh_release(n);
+	}
+}
+
+static void mlx5e_encap_dealloc(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
+{
+	WARN_ON(!list_empty(&e->flows));
+
+	if (e->compl_result > 0) {
+		mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
+
+		if (e->flags & MLX5_ENCAP_ENTRY_VALID)
+			mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
+	}
+
+	kfree(e->tun_info);
+	kfree(e->encap_header);
+	kfree_rcu(e, rcu);
+}
+
+static void mlx5e_decap_dealloc(struct mlx5e_priv *priv,
+				struct mlx5e_decap_entry *d)
+{
+	WARN_ON(!list_empty(&d->flows));
+
+	if (!d->compl_result)
+		mlx5_packet_reformat_dealloc(priv->mdev, d->pkt_reformat);
+
+	kfree_rcu(d, rcu);
+}
+
+void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	if (!refcount_dec_and_mutex_lock(&e->refcnt, &esw->offloads.encap_tbl_lock))
+		return;
+	hash_del_rcu(&e->encap_hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_encap_dealloc(priv, e);
+}
+
+static void mlx5e_decap_put(struct mlx5e_priv *priv, struct mlx5e_decap_entry *d)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	if (!refcount_dec_and_mutex_lock(&d->refcnt, &esw->offloads.decap_tbl_lock))
+		return;
+	hash_del_rcu(&d->hlist);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+
+	mlx5e_decap_dealloc(priv, d);
+}
+
+void mlx5e_detach_encap(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow, int out_index)
+{
+	struct mlx5e_encap_entry *e = flow->encaps[out_index].e;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+
+	/* flow wasn't fully initialized */
+	if (!e)
+		return;
+
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	list_del(&flow->encaps[out_index].list);
+	flow->encaps[out_index].e = NULL;
+	if (!refcount_dec_and_test(&e->refcnt)) {
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+		return;
+	}
+	hash_del_rcu(&e->encap_hlist);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	mlx5e_encap_dealloc(priv, e);
+}
+
+void mlx5e_detach_decap(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_decap_entry *d = flow->decap_reformat;
+
+	if (!d)
+		return;
+
+	mutex_lock(&esw->offloads.decap_tbl_lock);
+	list_del(&flow->l3_to_l2_reformat);
+	flow->decap_reformat = NULL;
+
+	if (!refcount_dec_and_test(&d->refcnt)) {
+		mutex_unlock(&esw->offloads.decap_tbl_lock);
+		return;
+	}
+	hash_del_rcu(&d->hlist);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+
+	mlx5e_decap_dealloc(priv, d);
+}
+
+struct encap_key {
+	const struct ip_tunnel_key *ip_tun_key;
+	struct mlx5e_tc_tunnel *tc_tunnel;
+};
+
+static int cmp_encap_info(struct encap_key *a,
+			  struct encap_key *b)
+{
+	return memcmp(a->ip_tun_key, b->ip_tun_key, sizeof(*a->ip_tun_key)) ||
+		a->tc_tunnel->tunnel_type != b->tc_tunnel->tunnel_type;
+}
+
+static int cmp_decap_info(struct mlx5e_decap_key *a,
+			  struct mlx5e_decap_key *b)
+{
+	return memcmp(&a->key, &b->key, sizeof(b->key));
+}
+
+static int hash_encap_info(struct encap_key *key)
+{
+	return jhash(key->ip_tun_key, sizeof(*key->ip_tun_key),
+		     key->tc_tunnel->tunnel_type);
+}
+
+static int hash_decap_info(struct mlx5e_decap_key *key)
+{
+	return jhash(&key->key, sizeof(key->key), 0);
+}
+
+bool mlx5e_encap_take(struct mlx5e_encap_entry *e)
+{
+	return refcount_inc_not_zero(&e->refcnt);
+}
+
+static bool mlx5e_decap_take(struct mlx5e_decap_entry *e)
+{
+	return refcount_inc_not_zero(&e->refcnt);
+}
+
+static struct mlx5e_encap_entry *
+mlx5e_encap_get(struct mlx5e_priv *priv, struct encap_key *key,
+		uintptr_t hash_key)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_encap_entry *e;
+	struct encap_key e_key;
+
+	hash_for_each_possible_rcu(esw->offloads.encap_tbl, e,
+				   encap_hlist, hash_key) {
+		e_key.ip_tun_key = &e->tun_info->key;
+		e_key.tc_tunnel = e->tunnel;
+		if (!cmp_encap_info(&e_key, key) &&
+		    mlx5e_encap_take(e))
+			return e;
+	}
+
+	return NULL;
+}
+
+static struct mlx5e_decap_entry *
+mlx5e_decap_get(struct mlx5e_priv *priv, struct mlx5e_decap_key *key,
+		uintptr_t hash_key)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_decap_key r_key;
+	struct mlx5e_decap_entry *e;
+
+	hash_for_each_possible_rcu(esw->offloads.decap_tbl, e,
+				   hlist, hash_key) {
+		r_key = e->key;
+		if (!cmp_decap_info(&r_key, key) &&
+		    mlx5e_decap_take(e))
+			return e;
+	}
+	return NULL;
+}
+
+struct ip_tunnel_info *mlx5e_dup_tun_info(const struct ip_tunnel_info *tun_info)
+{
+	size_t tun_size = sizeof(*tun_info) + tun_info->options_len;
+
+	return kmemdup(tun_info, tun_size, GFP_KERNEL);
+}
+
+static bool is_duplicated_encap_entry(struct mlx5e_priv *priv,
+				      struct mlx5e_tc_flow *flow,
+				      int out_index,
+				      struct mlx5e_encap_entry *e,
+				      struct netlink_ext_ack *extack)
+{
+	int i;
+
+	for (i = 0; i < out_index; i++) {
+		if (flow->encaps[i].e != e)
+			continue;
+		NL_SET_ERR_MSG_MOD(extack, "can't duplicate encap action");
+		netdev_err(priv->netdev, "can't duplicate encap action\n");
+		return true;
+	}
+
+	return false;
+}
+
+static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
+			       struct mlx5_flow_attr *attr,
+			       struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
+			       struct net_device *out_dev,
+			       int route_dev_ifindex,
+			       int out_index)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	struct net_device *route_dev;
+	u16 vport_num;
+	int err = 0;
+	u32 data;
+
+	route_dev = dev_get_by_index(dev_net(out_dev), route_dev_ifindex);
+
+	if (!route_dev || route_dev->netdev_ops != &mlx5e_netdev_ops ||
+	    !mlx5e_tc_is_vf_tunnel(out_dev, route_dev))
+		goto out;
+
+	err = mlx5e_tc_query_route_vport(out_dev, route_dev, &vport_num);
+	if (err)
+		goto out;
+
+	attr->dest_chain = 0;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+	data = mlx5_eswitch_get_vport_metadata_for_set(esw_attr->in_mdev->priv.eswitch,
+						       vport_num);
+	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_hdr_acts,
+					MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG, data);
+	if (err)
+		goto out;
+
+out:
+	if (route_dev)
+		dev_put(route_dev);
+	return err;
+}
+
+int mlx5e_attach_encap(struct mlx5e_priv *priv,
+		       struct mlx5e_tc_flow *flow,
+		       struct net_device *mirred_dev,
+		       int out_index,
+		       struct netlink_ext_ack *extack,
+		       struct net_device **encap_dev,
+		       bool *encap_valid)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5_flow_attr *attr = flow->attr;
+	const struct ip_tunnel_info *tun_info;
+	struct encap_key key;
+	struct mlx5e_encap_entry *e;
+	unsigned short family;
+	uintptr_t hash_key;
+	int err = 0;
+
+	parse_attr = attr->parse_attr;
+	tun_info = parse_attr->tun_info[out_index];
+	family = ip_tunnel_info_af(tun_info);
+	key.ip_tun_key = &tun_info->key;
+	key.tc_tunnel = mlx5e_get_tc_tun(mirred_dev);
+	if (!key.tc_tunnel) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported tunnel");
+		return -EOPNOTSUPP;
+	}
+
+	hash_key = hash_encap_info(&key);
+
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	e = mlx5e_encap_get(priv, &key, hash_key);
+
+	/* must verify if encap is valid or not */
+	if (e) {
+		/* Check that entry was not already attached to this flow */
+		if (is_duplicated_encap_entry(priv, flow, out_index, e, extack)) {
+			err = -EOPNOTSUPP;
+			goto out_err;
+		}
+
+		mutex_unlock(&esw->offloads.encap_tbl_lock);
+		wait_for_completion(&e->res_ready);
+
+		/* Protect against concurrent neigh update. */
+		mutex_lock(&esw->offloads.encap_tbl_lock);
+		if (e->compl_result < 0) {
+			err = -EREMOTEIO;
+			goto out_err;
+		}
+		goto attach_flow;
+	}
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	refcount_set(&e->refcnt, 1);
+	init_completion(&e->res_ready);
+
+	tun_info = mlx5e_dup_tun_info(tun_info);
+	if (!tun_info) {
+		err = -ENOMEM;
+		goto out_err_init;
+	}
+	e->tun_info = tun_info;
+	err = mlx5e_tc_tun_init_encap_attr(mirred_dev, priv, e, extack);
+	if (err)
+		goto out_err_init;
+
+	INIT_LIST_HEAD(&e->flows);
+	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	if (family == AF_INET)
+		err = mlx5e_tc_tun_create_header_ipv4(priv, mirred_dev, e);
+	else if (family == AF_INET6)
+		err = mlx5e_tc_tun_create_header_ipv6(priv, mirred_dev, e);
+
+	/* Protect against concurrent neigh update. */
+	mutex_lock(&esw->offloads.encap_tbl_lock);
+	complete_all(&e->res_ready);
+	if (err) {
+		e->compl_result = err;
+		goto out_err;
+	}
+	e->compl_result = 1;
+
+attach_flow:
+	err = mlx5e_set_vf_tunnel(esw, attr, &parse_attr->mod_hdr_acts, e->out_dev,
+				  e->route_dev_ifindex, out_index);
+	if (err)
+		goto out_err;
+
+	flow->encaps[out_index].e = e;
+	list_add(&flow->encaps[out_index].list, &e->flows);
+	flow->encaps[out_index].index = out_index;
+	*encap_dev = e->out_dev;
+	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
+		attr->esw_attr->dests[out_index].pkt_reformat = e->pkt_reformat;
+		attr->esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
+		*encap_valid = true;
+	} else {
+		*encap_valid = false;
+	}
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+
+	return err;
+
+out_err:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	if (e)
+		mlx5e_encap_put(priv, e);
+	return err;
+
+out_err_init:
+	mutex_unlock(&esw->offloads.encap_tbl_lock);
+	kfree(tun_info);
+	kfree(e);
+	return err;
+}
+
+int mlx5e_attach_decap(struct mlx5e_priv *priv,
+		       struct mlx5e_tc_flow *flow,
+		       struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
+	struct mlx5e_tc_flow_parse_attr *parse_attr;
+	struct mlx5e_decap_entry *d;
+	struct mlx5e_decap_key key;
+	uintptr_t hash_key;
+	int err = 0;
+
+	parse_attr = flow->attr->parse_attr;
+	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "encap header larger than max supported");
+		return -EOPNOTSUPP;
+	}
+
+	key.key = parse_attr->eth;
+	hash_key = hash_decap_info(&key);
+	mutex_lock(&esw->offloads.decap_tbl_lock);
+	d = mlx5e_decap_get(priv, &key, hash_key);
+	if (d) {
+		mutex_unlock(&esw->offloads.decap_tbl_lock);
+		wait_for_completion(&d->res_ready);
+		mutex_lock(&esw->offloads.decap_tbl_lock);
+		if (d->compl_result) {
+			err = -EREMOTEIO;
+			goto out_free;
+		}
+		goto found;
+	}
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	d->key = key;
+	refcount_set(&d->refcnt, 1);
+	init_completion(&d->res_ready);
+	INIT_LIST_HEAD(&d->flows);
+	hash_add_rcu(esw->offloads.decap_tbl, &d->hlist, hash_key);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+
+	d->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
+						     MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2,
+						     sizeof(parse_attr->eth),
+						     &parse_attr->eth,
+						     MLX5_FLOW_NAMESPACE_FDB);
+	if (IS_ERR(d->pkt_reformat)) {
+		err = PTR_ERR(d->pkt_reformat);
+		d->compl_result = err;
+	}
+	mutex_lock(&esw->offloads.decap_tbl_lock);
+	complete_all(&d->res_ready);
+	if (err)
+		goto out_free;
+
+found:
+	flow->decap_reformat = d;
+	attr->decap_pkt_reformat = d->pkt_reformat;
+	list_add(&flow->l3_to_l2_reformat, &d->flows);
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+	return 0;
+
+out_free:
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+	mlx5e_decap_put(priv, d);
+	return err;
+
+out_err:
+	mutex_unlock(&esw->offloads.decap_tbl_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
new file mode 100644
index 000000000000..81b9fef1cf2a
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_TC_TUN_ENCAP_H__
+#define __MLX5_EN_TC_TUN_ENCAP_H__
+
+#include "tc_priv.h"
+
+void mlx5e_detach_encap(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow, int out_index);
+
+int mlx5e_attach_encap(struct mlx5e_priv *priv,
+		       struct mlx5e_tc_flow *flow,
+		       struct net_device *mirred_dev,
+		       int out_index,
+		       struct netlink_ext_ack *extack,
+		       struct net_device **encap_dev,
+		       bool *encap_valid);
+int mlx5e_attach_decap(struct mlx5e_priv *priv,
+		       struct mlx5e_tc_flow *flow,
+		       struct netlink_ext_ack *extack);
+void mlx5e_detach_decap(struct mlx5e_priv *priv,
+			struct mlx5e_tc_flow *flow);
+
+struct ip_tunnel_info *mlx5e_dup_tun_info(const struct ip_tunnel_info *tun_info);
+
+int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
+			     struct mlx5_flow_spec *spec);
+
+#endif /* __MLX5_EN_TC_TUN_ENCAP_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 21568d1fc00f..cfe340e23dfc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -63,6 +63,8 @@
 #include "en/mapping.h"
 #include "en/tc_ct.h"
 #include "en/mod_hdr.h"
+#include "en/tc_priv.h"
+#include "en/tc_tun_encap.h"
 #include "lib/devcom.h"
 #include "lib/geneve.h"
 #include "lib/fs_chains.h"
@@ -71,90 +73,6 @@
 
 #define nic_chains(priv) ((priv)->fs.tc.chains)
 #define MLX5_MH_ACT_SZ MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)
-#define MLX5E_TC_FLOW_BASE (MLX5E_TC_FLAG_LAST_EXPORTED_BIT + 1)
-
-enum {
-	MLX5E_TC_FLOW_FLAG_INGRESS	= MLX5E_TC_FLAG_INGRESS_BIT,
-	MLX5E_TC_FLOW_FLAG_EGRESS	= MLX5E_TC_FLAG_EGRESS_BIT,
-	MLX5E_TC_FLOW_FLAG_ESWITCH	= MLX5E_TC_FLAG_ESW_OFFLOAD_BIT,
-	MLX5E_TC_FLOW_FLAG_FT		= MLX5E_TC_FLAG_FT_OFFLOAD_BIT,
-	MLX5E_TC_FLOW_FLAG_NIC		= MLX5E_TC_FLAG_NIC_OFFLOAD_BIT,
-	MLX5E_TC_FLOW_FLAG_OFFLOADED	= MLX5E_TC_FLOW_BASE,
-	MLX5E_TC_FLOW_FLAG_HAIRPIN	= MLX5E_TC_FLOW_BASE + 1,
-	MLX5E_TC_FLOW_FLAG_HAIRPIN_RSS	= MLX5E_TC_FLOW_BASE + 2,
-	MLX5E_TC_FLOW_FLAG_SLOW		= MLX5E_TC_FLOW_BASE + 3,
-	MLX5E_TC_FLOW_FLAG_DUP		= MLX5E_TC_FLOW_BASE + 4,
-	MLX5E_TC_FLOW_FLAG_NOT_READY	= MLX5E_TC_FLOW_BASE + 5,
-	MLX5E_TC_FLOW_FLAG_DELETED	= MLX5E_TC_FLOW_BASE + 6,
-	MLX5E_TC_FLOW_FLAG_CT		= MLX5E_TC_FLOW_BASE + 7,
-	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP = MLX5E_TC_FLOW_BASE + 8,
-};
-
-#define MLX5E_TC_MAX_SPLITS 1
-
-/* Helper struct for accessing a struct containing list_head array.
- * Containing struct
- *   |- Helper array
- *      [0] Helper item 0
- *          |- list_head item 0
- *          |- index (0)
- *      [1] Helper item 1
- *          |- list_head item 1
- *          |- index (1)
- * To access the containing struct from one of the list_head items:
- * 1. Get the helper item from the list_head item using
- *    helper item =
- *        container_of(list_head item, helper struct type, list_head field)
- * 2. Get the contining struct from the helper item and its index in the array:
- *    containing struct =
- *        container_of(helper item, containing struct type, helper field[index])
- */
-struct encap_flow_item {
-	struct mlx5e_encap_entry *e; /* attached encap instance */
-	struct list_head list;
-	int index;
-};
-
-struct mlx5e_tc_flow {
-	struct rhash_head	node;
-	struct mlx5e_priv	*priv;
-	u64			cookie;
-	unsigned long		flags;
-	struct mlx5_flow_handle *rule[MLX5E_TC_MAX_SPLITS + 1];
-
-	/* flows sharing the same reformat object - currently mpls decap */
-	struct list_head l3_to_l2_reformat;
-	struct mlx5e_decap_entry *decap_reformat;
-
-	/* Flow can be associated with multiple encap IDs.
-	 * The number of encaps is bounded by the number of supported
-	 * destinations.
-	 */
-	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
-	struct mlx5e_tc_flow    *peer_flow;
-	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
-	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
-	struct list_head	hairpin; /* flows sharing the same hairpin */
-	struct list_head	peer;    /* flows with peer flow */
-	struct list_head	unready; /* flows not ready to be offloaded (e.g due to missing route) */
-	struct net_device	*orig_dev; /* netdev adding flow first */
-	int			tmp_efi_index;
-	struct list_head	tmp_list; /* temporary flow list used by neigh update */
-	refcount_t		refcnt;
-	struct rcu_head		rcu_head;
-	struct completion	init_done;
-	int tunnel_id; /* the mapped tunnel id of this flow */
-	struct mlx5_flow_attr *attr;
-};
-
-struct mlx5e_tc_flow_parse_attr {
-	const struct ip_tunnel_info *tun_info[MLX5_MAX_FLOW_FWD_VPORTS];
-	struct net_device *filter_dev;
-	struct mlx5_flow_spec spec;
-	struct mlx5e_tc_mod_hdr_acts mod_hdr_acts;
-	int mirred_ifindex[MLX5_MAX_FLOW_FWD_VPORTS];
-	struct ethhdr eth;
-};
 
 #define MLX5E_TC_TABLE_NUM_GROUPS 4
 #define MLX5E_TC_TABLE_MAX_GROUP_SIZE BIT(18)
@@ -368,15 +286,14 @@ struct mlx5e_hairpin_entry {
 static void mlx5e_tc_del_flow(struct mlx5e_priv *priv,
 			      struct mlx5e_tc_flow *flow);
 
-static struct mlx5e_tc_flow *mlx5e_flow_get(struct mlx5e_tc_flow *flow)
+struct mlx5e_tc_flow *mlx5e_flow_get(struct mlx5e_tc_flow *flow)
 {
 	if (!flow || !refcount_inc_not_zero(&flow->refcnt))
 		return ERR_PTR(-EINVAL);
 	return flow;
 }
 
-static void mlx5e_flow_put(struct mlx5e_priv *priv,
-			   struct mlx5e_tc_flow *flow)
+void mlx5e_flow_put(struct mlx5e_priv *priv, struct mlx5e_tc_flow *flow)
 {
 	if (refcount_dec_and_test(&flow->refcnt)) {
 		mlx5e_tc_del_flow(priv, flow);
@@ -384,48 +301,6 @@ static void mlx5e_flow_put(struct mlx5e_priv *priv,
 	}
 }
 
-static void __flow_flag_set(struct mlx5e_tc_flow *flow, unsigned long flag)
-{
-	/* Complete all memory stores before setting bit. */
-	smp_mb__before_atomic();
-	set_bit(flag, &flow->flags);
-}
-
-#define flow_flag_set(flow, flag) __flow_flag_set(flow, MLX5E_TC_FLOW_FLAG_##flag)
-
-static bool __flow_flag_test_and_set(struct mlx5e_tc_flow *flow,
-				     unsigned long flag)
-{
-	/* test_and_set_bit() provides all necessary barriers */
-	return test_and_set_bit(flag, &flow->flags);
-}
-
-#define flow_flag_test_and_set(flow, flag)			\
-	__flow_flag_test_and_set(flow,				\
-				 MLX5E_TC_FLOW_FLAG_##flag)
-
-static void __flow_flag_clear(struct mlx5e_tc_flow *flow, unsigned long flag)
-{
-	/* Complete all memory stores before clearing bit. */
-	smp_mb__before_atomic();
-	clear_bit(flag, &flow->flags);
-}
-
-#define flow_flag_clear(flow, flag) __flow_flag_clear(flow, \
-						      MLX5E_TC_FLOW_FLAG_##flag)
-
-static bool __flow_flag_test(struct mlx5e_tc_flow *flow, unsigned long flag)
-{
-	bool ret = test_bit(flag, &flow->flags);
-
-	/* Read fields of flow structure only after checking flags. */
-	smp_mb__after_atomic();
-	return ret;
-}
-
-#define flow_flag_test(flow, flag) __flow_flag_test(flow, \
-						    MLX5E_TC_FLOW_FLAG_##flag)
-
 bool mlx5e_is_eswitch_flow(struct mlx5e_tc_flow *flow)
 {
 	return flow_flag_test(flow, ESWITCH);
@@ -436,7 +311,7 @@ static bool mlx5e_is_ft_flow(struct mlx5e_tc_flow *flow)
 	return flow_flag_test(flow, FT);
 }
 
-static bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
+bool mlx5e_is_offloaded_flow(struct mlx5e_tc_flow *flow)
 {
 	return flow_flag_test(flow, OFFLOADED);
 }
@@ -1151,23 +1026,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	kfree(flow->attr);
 }
 
-static void mlx5e_detach_encap(struct mlx5e_priv *priv,
-			       struct mlx5e_tc_flow *flow, int out_index);
-
-static int mlx5e_attach_encap(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow *flow,
-			      struct net_device *mirred_dev,
-			      int out_index,
-			      struct netlink_ext_ack *extack,
-			      struct net_device **encap_dev,
-			      bool *encap_valid);
-static int mlx5e_attach_decap(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow *flow,
-			      struct netlink_ext_ack *extack);
-static void mlx5e_detach_decap(struct mlx5e_priv *priv,
-			       struct mlx5e_tc_flow *flow);
-
-static struct mlx5_flow_handle *
+struct mlx5_flow_handle *
 mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 			   struct mlx5e_tc_flow *flow,
 			   struct mlx5_flow_spec *spec,
@@ -1202,10 +1061,9 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	return rule;
 }
 
-static void
-mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
-			     struct mlx5e_tc_flow *flow,
-			     struct mlx5_flow_attr *attr)
+void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
+				  struct mlx5e_tc_flow *flow,
+				  struct mlx5_flow_attr *attr)
 {
 	flow_flag_clear(flow, OFFLOADED);
 
@@ -1224,7 +1082,7 @@ mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	mlx5_eswitch_del_offloaded_rule(esw, flow->rule[0], attr);
 }
 
-static struct mlx5_flow_handle *
+struct mlx5_flow_handle *
 mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec)
@@ -1250,9 +1108,8 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 	return rule;
 }
 
-static void
-mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
-				  struct mlx5e_tc_flow *flow)
+void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
+				       struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_flow_attr *slow_attr;
 
@@ -1519,139 +1376,11 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	kfree(flow->attr);
 }
 
-void mlx5e_tc_encap_flows_add(struct mlx5e_priv *priv,
-			      struct mlx5e_encap_entry *e,
-			      struct list_head *flow_list)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *esw_attr;
-	struct mlx5_flow_handle *rule;
-	struct mlx5_flow_attr *attr;
-	struct mlx5_flow_spec *spec;
-	struct mlx5e_tc_flow *flow;
-	int err;
-
-	e->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     e->reformat_type,
-						     e->encap_size, e->encap_header,
-						     MLX5_FLOW_NAMESPACE_FDB);
-	if (IS_ERR(e->pkt_reformat)) {
-		mlx5_core_warn(priv->mdev, "Failed to offload cached encapsulation header, %lu\n",
-			       PTR_ERR(e->pkt_reformat));
-		return;
-	}
-	e->flags |= MLX5_ENCAP_ENTRY_VALID;
-	mlx5e_rep_queue_neigh_stats_work(priv);
-
-	list_for_each_entry(flow, flow_list, tmp_list) {
-		bool all_flow_encaps_valid = true;
-		int i;
-
-		if (!mlx5e_is_offloaded_flow(flow))
-			continue;
-		attr = flow->attr;
-		esw_attr = attr->esw_attr;
-		spec = &attr->parse_attr->spec;
-
-		esw_attr->dests[flow->tmp_efi_index].pkt_reformat = e->pkt_reformat;
-		esw_attr->dests[flow->tmp_efi_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
-		/* Flow can be associated with multiple encap entries.
-		 * Before offloading the flow verify that all of them have
-		 * a valid neighbour.
-		 */
-		for (i = 0; i < MLX5_MAX_FLOW_FWD_VPORTS; i++) {
-			if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP))
-				continue;
-			if (!(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP_VALID)) {
-				all_flow_encaps_valid = false;
-				break;
-			}
-		}
-		/* Do not offload flows with unresolved neighbors */
-		if (!all_flow_encaps_valid)
-			continue;
-		/* update from slow path rule to encap rule */
-		rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, attr);
-		if (IS_ERR(rule)) {
-			err = PTR_ERR(rule);
-			mlx5_core_warn(priv->mdev, "Failed to update cached encapsulation flow, %d\n",
-				       err);
-			continue;
-		}
-
-		mlx5e_tc_unoffload_from_slow_path(esw, flow);
-		flow->rule[0] = rule;
-		/* was unset when slow path rule removed */
-		flow_flag_set(flow, OFFLOADED);
-	}
-}
-
-void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
-			      struct mlx5e_encap_entry *e,
-			      struct list_head *flow_list)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *esw_attr;
-	struct mlx5_flow_handle *rule;
-	struct mlx5_flow_attr *attr;
-	struct mlx5_flow_spec *spec;
-	struct mlx5e_tc_flow *flow;
-	int err;
-
-	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow))
-			continue;
-		attr = flow->attr;
-		esw_attr = attr->esw_attr;
-		spec = &attr->parse_attr->spec;
-
-		/* update from encap rule to slow path rule */
-		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
-		/* mark the flow's encap dest as non-valid */
-		esw_attr->dests[flow->tmp_efi_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
-
-		if (IS_ERR(rule)) {
-			err = PTR_ERR(rule);
-			mlx5_core_warn(priv->mdev, "Failed to update slow path (encap) flow, %d\n",
-				       err);
-			continue;
-		}
-
-		mlx5e_tc_unoffload_fdb_rules(esw, flow, attr);
-		flow->rule[0] = rule;
-		/* was unset when fast path rule removed */
-		flow_flag_set(flow, OFFLOADED);
-	}
-
-	/* we know that the encap is valid */
-	e->flags &= ~MLX5_ENCAP_ENTRY_VALID;
-	mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
-}
-
-static struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow)
+struct mlx5_fc *mlx5e_tc_get_counter(struct mlx5e_tc_flow *flow)
 {
 	return flow->attr->counter;
 }
 
-/* Takes reference to all flows attached to encap and adds the flows to
- * flow_list using 'tmp_list' list_head in mlx5e_tc_flow.
- */
-void mlx5e_take_all_encap_flows(struct mlx5e_encap_entry *e, struct list_head *flow_list)
-{
-	struct encap_flow_item *efi;
-	struct mlx5e_tc_flow *flow;
-
-	list_for_each_entry(efi, &e->flows, list) {
-		flow = container_of(efi, struct mlx5e_tc_flow, encaps[efi->index]);
-		if (IS_ERR(mlx5e_flow_get(flow)))
-			continue;
-		wait_for_completion(&flow->init_done);
-
-		flow->tmp_efi_index = efi->index;
-		list_add(&flow->tmp_list, flow_list);
-	}
-}
-
 /* Iterate over tmp_list of flows attached to flow_list head. */
 void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_list)
 {
@@ -1661,222 +1390,6 @@ void mlx5e_put_encap_flow_list(struct mlx5e_priv *priv, struct list_head *flow_l
 		mlx5e_flow_put(priv, flow);
 }
 
-static struct mlx5e_encap_entry *
-mlx5e_get_next_valid_encap(struct mlx5e_neigh_hash_entry *nhe,
-			   struct mlx5e_encap_entry *e)
-{
-	struct mlx5e_encap_entry *next = NULL;
-
-retry:
-	rcu_read_lock();
-
-	/* find encap with non-zero reference counter value */
-	for (next = e ?
-		     list_next_or_null_rcu(&nhe->encap_list,
-					   &e->encap_list,
-					   struct mlx5e_encap_entry,
-					   encap_list) :
-		     list_first_or_null_rcu(&nhe->encap_list,
-					    struct mlx5e_encap_entry,
-					    encap_list);
-	     next;
-	     next = list_next_or_null_rcu(&nhe->encap_list,
-					  &next->encap_list,
-					  struct mlx5e_encap_entry,
-					  encap_list))
-		if (mlx5e_encap_take(next))
-			break;
-
-	rcu_read_unlock();
-
-	/* release starting encap */
-	if (e)
-		mlx5e_encap_put(netdev_priv(e->out_dev), e);
-	if (!next)
-		return next;
-
-	/* wait for encap to be fully initialized */
-	wait_for_completion(&next->res_ready);
-	/* continue searching if encap entry is not in valid state after completion */
-	if (!(next->flags & MLX5_ENCAP_ENTRY_VALID)) {
-		e = next;
-		goto retry;
-	}
-
-	return next;
-}
-
-void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
-{
-	struct mlx5e_neigh *m_neigh = &nhe->m_neigh;
-	struct mlx5e_encap_entry *e = NULL;
-	struct mlx5e_tc_flow *flow;
-	struct mlx5_fc *counter;
-	struct neigh_table *tbl;
-	bool neigh_used = false;
-	struct neighbour *n;
-	u64 lastuse;
-
-	if (m_neigh->family == AF_INET)
-		tbl = &arp_tbl;
-#if IS_ENABLED(CONFIG_IPV6)
-	else if (m_neigh->family == AF_INET6)
-		tbl = ipv6_stub->nd_tbl;
-#endif
-	else
-		return;
-
-	/* mlx5e_get_next_valid_encap() releases previous encap before returning
-	 * next one.
-	 */
-	while ((e = mlx5e_get_next_valid_encap(nhe, e)) != NULL) {
-		struct mlx5e_priv *priv = netdev_priv(e->out_dev);
-		struct encap_flow_item *efi, *tmp;
-		struct mlx5_eswitch *esw;
-		LIST_HEAD(flow_list);
-
-		esw = priv->mdev->priv.eswitch;
-		mutex_lock(&esw->offloads.encap_tbl_lock);
-		list_for_each_entry_safe(efi, tmp, &e->flows, list) {
-			flow = container_of(efi, struct mlx5e_tc_flow,
-					    encaps[efi->index]);
-			if (IS_ERR(mlx5e_flow_get(flow)))
-				continue;
-			list_add(&flow->tmp_list, &flow_list);
-
-			if (mlx5e_is_offloaded_flow(flow)) {
-				counter = mlx5e_tc_get_counter(flow);
-				lastuse = mlx5_fc_query_lastuse(counter);
-				if (time_after((unsigned long)lastuse, nhe->reported_lastuse)) {
-					neigh_used = true;
-					break;
-				}
-			}
-		}
-		mutex_unlock(&esw->offloads.encap_tbl_lock);
-
-		mlx5e_put_encap_flow_list(priv, &flow_list);
-		if (neigh_used) {
-			/* release current encap before breaking the loop */
-			mlx5e_encap_put(priv, e);
-			break;
-		}
-	}
-
-	trace_mlx5e_tc_update_neigh_used_value(nhe, neigh_used);
-
-	if (neigh_used) {
-		nhe->reported_lastuse = jiffies;
-
-		/* find the relevant neigh according to the cached device and
-		 * dst ip pair
-		 */
-		n = neigh_lookup(tbl, &m_neigh->dst_ip, m_neigh->dev);
-		if (!n)
-			return;
-
-		neigh_event_send(n, NULL);
-		neigh_release(n);
-	}
-}
-
-static void mlx5e_encap_dealloc(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
-{
-	WARN_ON(!list_empty(&e->flows));
-
-	if (e->compl_result > 0) {
-		mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
-
-		if (e->flags & MLX5_ENCAP_ENTRY_VALID)
-			mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
-	}
-
-	kfree(e->tun_info);
-	kfree(e->encap_header);
-	kfree_rcu(e, rcu);
-}
-
-static void mlx5e_decap_dealloc(struct mlx5e_priv *priv,
-				struct mlx5e_decap_entry *d)
-{
-	WARN_ON(!list_empty(&d->flows));
-
-	if (!d->compl_result)
-		mlx5_packet_reformat_dealloc(priv->mdev, d->pkt_reformat);
-
-	kfree_rcu(d, rcu);
-}
-
-void mlx5e_encap_put(struct mlx5e_priv *priv, struct mlx5e_encap_entry *e)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-
-	if (!refcount_dec_and_mutex_lock(&e->refcnt, &esw->offloads.encap_tbl_lock))
-		return;
-	hash_del_rcu(&e->encap_hlist);
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-
-	mlx5e_encap_dealloc(priv, e);
-}
-
-static void mlx5e_decap_put(struct mlx5e_priv *priv, struct mlx5e_decap_entry *d)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-
-	if (!refcount_dec_and_mutex_lock(&d->refcnt, &esw->offloads.decap_tbl_lock))
-		return;
-	hash_del_rcu(&d->hlist);
-	mutex_unlock(&esw->offloads.decap_tbl_lock);
-
-	mlx5e_decap_dealloc(priv, d);
-}
-
-static void mlx5e_detach_encap(struct mlx5e_priv *priv,
-			       struct mlx5e_tc_flow *flow, int out_index)
-{
-	struct mlx5e_encap_entry *e = flow->encaps[out_index].e;
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-
-	/* flow wasn't fully initialized */
-	if (!e)
-		return;
-
-	mutex_lock(&esw->offloads.encap_tbl_lock);
-	list_del(&flow->encaps[out_index].list);
-	flow->encaps[out_index].e = NULL;
-	if (!refcount_dec_and_test(&e->refcnt)) {
-		mutex_unlock(&esw->offloads.encap_tbl_lock);
-		return;
-	}
-	hash_del_rcu(&e->encap_hlist);
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-
-	mlx5e_encap_dealloc(priv, e);
-}
-
-static void mlx5e_detach_decap(struct mlx5e_priv *priv,
-			       struct mlx5e_tc_flow *flow)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5e_decap_entry *d = flow->decap_reformat;
-
-	if (!d)
-		return;
-
-	mutex_lock(&esw->offloads.decap_tbl_lock);
-	list_del(&flow->l3_to_l2_reformat);
-	flow->decap_reformat = NULL;
-
-	if (!refcount_dec_and_test(&d->refcnt)) {
-		mutex_unlock(&esw->offloads.decap_tbl_lock);
-		return;
-	}
-	hash_del_rcu(&d->hlist);
-	mutex_unlock(&esw->offloads.decap_tbl_lock);
-
-	mlx5e_decap_dealloc(priv, d);
-}
-
 static void __mlx5e_tc_del_fdb_peer_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_eswitch *esw = flow->priv->mdev->priv.eswitch;
@@ -2134,7 +1647,7 @@ void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 	}
 }
 
-static u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer)
+u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer)
 {
 	void *headers_v;
 	u16 ethertype;
@@ -2157,44 +1670,6 @@ static u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer)
 	return ip_version;
 }
 
-static int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
-				    struct mlx5_flow_spec *spec)
-{
-	struct mlx5_esw_flow_attr *esw_attr = flow->attr->esw_attr;
-	struct mlx5_rx_tun_attr *tun_attr;
-	void *daddr, *saddr;
-	u8 ip_version;
-
-	tun_attr = kvzalloc(sizeof(*tun_attr), GFP_KERNEL);
-	if (!tun_attr)
-		return -ENOMEM;
-
-	esw_attr->rx_tun_attr = tun_attr;
-	ip_version = mlx5e_tc_get_ip_version(spec, true);
-
-	if (ip_version == 4) {
-		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				     outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
-		saddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				     outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
-		tun_attr->dst_ip.v4 = *(__be32 *)daddr;
-		tun_attr->src_ip.v4 = *(__be32 *)saddr;
-	}
-#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
-	else if (ip_version == 6) {
-		int ipv6_size = MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6);
-
-		daddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				     outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6);
-		saddr = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				     outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6);
-		memcpy(&tun_attr->dst_ip.v6, daddr, ipv6_size);
-		memcpy(&tun_attr->src_ip.v6, saddr, ipv6_size);
-	}
-#endif
-	return 0;
-}
-
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
@@ -3714,35 +3189,6 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 	return 0;
 }
 
-struct encap_key {
-	const struct ip_tunnel_key *ip_tun_key;
-	struct mlx5e_tc_tunnel *tc_tunnel;
-};
-
-static inline int cmp_encap_info(struct encap_key *a,
-				 struct encap_key *b)
-{
-	return memcmp(a->ip_tun_key, b->ip_tun_key, sizeof(*a->ip_tun_key)) ||
-	       a->tc_tunnel->tunnel_type != b->tc_tunnel->tunnel_type;
-}
-
-static inline int cmp_decap_info(struct mlx5e_decap_key *a,
-				 struct mlx5e_decap_key *b)
-{
-	return memcmp(&a->key, &b->key, sizeof(b->key));
-}
-
-static inline int hash_encap_info(struct encap_key *key)
-{
-	return jhash(key->ip_tun_key, sizeof(*key->ip_tun_key),
-		     key->tc_tunnel->tunnel_type);
-}
-
-static inline int hash_decap_info(struct mlx5e_decap_key *key)
-{
-	return jhash(&key->key, sizeof(key->key), 0);
-}
-
 static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
 				  struct net_device *peer_netdev)
 {
@@ -3756,321 +3202,6 @@ static bool is_merged_eswitch_vfs(struct mlx5e_priv *priv,
 		same_hw_devs(priv, peer_priv));
 }
 
-bool mlx5e_encap_take(struct mlx5e_encap_entry *e)
-{
-	return refcount_inc_not_zero(&e->refcnt);
-}
-
-static bool mlx5e_decap_take(struct mlx5e_decap_entry *e)
-{
-	return refcount_inc_not_zero(&e->refcnt);
-}
-
-static struct mlx5e_encap_entry *
-mlx5e_encap_get(struct mlx5e_priv *priv, struct encap_key *key,
-		uintptr_t hash_key)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5e_encap_entry *e;
-	struct encap_key e_key;
-
-	hash_for_each_possible_rcu(esw->offloads.encap_tbl, e,
-				   encap_hlist, hash_key) {
-		e_key.ip_tun_key = &e->tun_info->key;
-		e_key.tc_tunnel = e->tunnel;
-		if (!cmp_encap_info(&e_key, key) &&
-		    mlx5e_encap_take(e))
-			return e;
-	}
-
-	return NULL;
-}
-
-static struct mlx5e_decap_entry *
-mlx5e_decap_get(struct mlx5e_priv *priv, struct mlx5e_decap_key *key,
-		uintptr_t hash_key)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5e_decap_key r_key;
-	struct mlx5e_decap_entry *e;
-
-	hash_for_each_possible_rcu(esw->offloads.decap_tbl, e,
-				   hlist, hash_key) {
-		r_key = e->key;
-		if (!cmp_decap_info(&r_key, key) &&
-		    mlx5e_decap_take(e))
-			return e;
-	}
-	return NULL;
-}
-
-static struct ip_tunnel_info *dup_tun_info(const struct ip_tunnel_info *tun_info)
-{
-	size_t tun_size = sizeof(*tun_info) + tun_info->options_len;
-
-	return kmemdup(tun_info, tun_size, GFP_KERNEL);
-}
-
-static bool is_duplicated_encap_entry(struct mlx5e_priv *priv,
-				      struct mlx5e_tc_flow *flow,
-				      int out_index,
-				      struct mlx5e_encap_entry *e,
-				      struct netlink_ext_ack *extack)
-{
-	int i;
-
-	for (i = 0; i < out_index; i++) {
-		if (flow->encaps[i].e != e)
-			continue;
-		NL_SET_ERR_MSG_MOD(extack, "can't duplicate encap action");
-		netdev_err(priv->netdev, "can't duplicate encap action\n");
-		return true;
-	}
-
-	return false;
-}
-
-static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
-			       struct mlx5_flow_attr *attr,
-			       struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts,
-			       struct net_device *out_dev,
-			       int route_dev_ifindex,
-			       int out_index)
-{
-	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
-	struct net_device *route_dev;
-	u16 vport_num;
-	int err = 0;
-	u32 data;
-
-	route_dev = dev_get_by_index(dev_net(out_dev), route_dev_ifindex);
-
-	if (!route_dev || route_dev->netdev_ops != &mlx5e_netdev_ops ||
-	    !mlx5e_tc_is_vf_tunnel(out_dev, route_dev))
-		goto out;
-
-	err = mlx5e_tc_query_route_vport(out_dev, route_dev, &vport_num);
-	if (err)
-		goto out;
-
-	attr->dest_chain = 0;
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
-	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
-	data = mlx5_eswitch_get_vport_metadata_for_set(esw_attr->in_mdev->priv.eswitch,
-						       vport_num);
-	err = mlx5e_tc_match_to_reg_set(esw->dev, mod_hdr_acts,
-					MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG, data);
-	if (err)
-		goto out;
-
-out:
-	if (route_dev)
-		dev_put(route_dev);
-	return err;
-}
-
-static int mlx5e_attach_encap(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow *flow,
-			      struct net_device *mirred_dev,
-			      int out_index,
-			      struct netlink_ext_ack *extack,
-			      struct net_device **encap_dev,
-			      bool *encap_valid)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5_flow_attr *attr = flow->attr;
-	const struct ip_tunnel_info *tun_info;
-	struct encap_key key;
-	struct mlx5e_encap_entry *e;
-	unsigned short family;
-	uintptr_t hash_key;
-	int err = 0;
-
-	parse_attr = attr->parse_attr;
-	tun_info = parse_attr->tun_info[out_index];
-	family = ip_tunnel_info_af(tun_info);
-	key.ip_tun_key = &tun_info->key;
-	key.tc_tunnel = mlx5e_get_tc_tun(mirred_dev);
-	if (!key.tc_tunnel) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported tunnel");
-		return -EOPNOTSUPP;
-	}
-
-	hash_key = hash_encap_info(&key);
-
-	mutex_lock(&esw->offloads.encap_tbl_lock);
-	e = mlx5e_encap_get(priv, &key, hash_key);
-
-	/* must verify if encap is valid or not */
-	if (e) {
-		/* Check that entry was not already attached to this flow */
-		if (is_duplicated_encap_entry(priv, flow, out_index, e, extack)) {
-			err = -EOPNOTSUPP;
-			goto out_err;
-		}
-
-		mutex_unlock(&esw->offloads.encap_tbl_lock);
-		wait_for_completion(&e->res_ready);
-
-		/* Protect against concurrent neigh update. */
-		mutex_lock(&esw->offloads.encap_tbl_lock);
-		if (e->compl_result < 0) {
-			err = -EREMOTEIO;
-			goto out_err;
-		}
-		goto attach_flow;
-	}
-
-	e = kzalloc(sizeof(*e), GFP_KERNEL);
-	if (!e) {
-		err = -ENOMEM;
-		goto out_err;
-	}
-
-	refcount_set(&e->refcnt, 1);
-	init_completion(&e->res_ready);
-
-	tun_info = dup_tun_info(tun_info);
-	if (!tun_info) {
-		err = -ENOMEM;
-		goto out_err_init;
-	}
-	e->tun_info = tun_info;
-	err = mlx5e_tc_tun_init_encap_attr(mirred_dev, priv, e, extack);
-	if (err)
-		goto out_err_init;
-
-	INIT_LIST_HEAD(&e->flows);
-	hash_add_rcu(esw->offloads.encap_tbl, &e->encap_hlist, hash_key);
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-
-	if (family == AF_INET)
-		err = mlx5e_tc_tun_create_header_ipv4(priv, mirred_dev, e);
-	else if (family == AF_INET6)
-		err = mlx5e_tc_tun_create_header_ipv6(priv, mirred_dev, e);
-
-	/* Protect against concurrent neigh update. */
-	mutex_lock(&esw->offloads.encap_tbl_lock);
-	complete_all(&e->res_ready);
-	if (err) {
-		e->compl_result = err;
-		goto out_err;
-	}
-	e->compl_result = 1;
-
-attach_flow:
-	err = mlx5e_set_vf_tunnel(esw, attr, &parse_attr->mod_hdr_acts, e->out_dev,
-				  e->route_dev_ifindex, out_index);
-	if (err)
-		goto out_err;
-
-	flow->encaps[out_index].e = e;
-	list_add(&flow->encaps[out_index].list, &e->flows);
-	flow->encaps[out_index].index = out_index;
-	*encap_dev = e->out_dev;
-	if (e->flags & MLX5_ENCAP_ENTRY_VALID) {
-		attr->esw_attr->dests[out_index].pkt_reformat = e->pkt_reformat;
-		attr->esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_ENCAP_VALID;
-		*encap_valid = true;
-	} else {
-		*encap_valid = false;
-	}
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-
-	return err;
-
-out_err:
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-	if (e)
-		mlx5e_encap_put(priv, e);
-	return err;
-
-out_err_init:
-	mutex_unlock(&esw->offloads.encap_tbl_lock);
-	kfree(tun_info);
-	kfree(e);
-	return err;
-}
-
-static int mlx5e_attach_decap(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow *flow,
-			      struct netlink_ext_ack *extack)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_esw_flow_attr *attr = flow->attr->esw_attr;
-	struct mlx5e_tc_flow_parse_attr *parse_attr;
-	struct mlx5e_decap_entry *d;
-	struct mlx5e_decap_key key;
-	uintptr_t hash_key;
-	int err = 0;
-
-	parse_attr = flow->attr->parse_attr;
-	if (sizeof(parse_attr->eth) > MLX5_CAP_ESW(priv->mdev, max_encap_header_size)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "encap header larger than max supported");
-		return -EOPNOTSUPP;
-	}
-
-	key.key = parse_attr->eth;
-	hash_key = hash_decap_info(&key);
-	mutex_lock(&esw->offloads.decap_tbl_lock);
-	d = mlx5e_decap_get(priv, &key, hash_key);
-	if (d) {
-		mutex_unlock(&esw->offloads.decap_tbl_lock);
-		wait_for_completion(&d->res_ready);
-		mutex_lock(&esw->offloads.decap_tbl_lock);
-		if (d->compl_result) {
-			err = -EREMOTEIO;
-			goto out_free;
-		}
-		goto found;
-	}
-
-	d = kzalloc(sizeof(*d), GFP_KERNEL);
-	if (!d) {
-		err = -ENOMEM;
-		goto out_err;
-	}
-
-	d->key = key;
-	refcount_set(&d->refcnt, 1);
-	init_completion(&d->res_ready);
-	INIT_LIST_HEAD(&d->flows);
-	hash_add_rcu(esw->offloads.decap_tbl, &d->hlist, hash_key);
-	mutex_unlock(&esw->offloads.decap_tbl_lock);
-
-	d->pkt_reformat = mlx5_packet_reformat_alloc(priv->mdev,
-						     MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2,
-						     sizeof(parse_attr->eth),
-						     &parse_attr->eth,
-						     MLX5_FLOW_NAMESPACE_FDB);
-	if (IS_ERR(d->pkt_reformat)) {
-		err = PTR_ERR(d->pkt_reformat);
-		d->compl_result = err;
-	}
-	mutex_lock(&esw->offloads.decap_tbl_lock);
-	complete_all(&d->res_ready);
-	if (err)
-		goto out_free;
-
-found:
-	flow->decap_reformat = d;
-	attr->decap_pkt_reformat = d->pkt_reformat;
-	list_add(&flow->l3_to_l2_reformat, &d->flows);
-	mutex_unlock(&esw->offloads.decap_tbl_lock);
-	return 0;
-
-out_free:
-	mutex_unlock(&esw->offloads.decap_tbl_lock);
-	mlx5e_decap_put(priv, d);
-	return err;
-
-out_err:
-	mutex_unlock(&esw->offloads.decap_tbl_lock);
-	return err;
-}
-
 static int parse_tc_vlan_action(struct mlx5e_priv *priv,
 				const struct flow_action_entry *act,
 				struct mlx5_esw_flow_attr *attr,
@@ -4423,7 +3554,8 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			if (encap) {
 				parse_attr->mirred_ifindex[esw_attr->out_count] =
 					out_dev->ifindex;
-				parse_attr->tun_info[esw_attr->out_count] = dup_tun_info(info);
+				parse_attr->tun_info[esw_attr->out_count] =
+					mlx5e_dup_tun_info(info);
 				if (!parse_attr->tun_info[esw_attr->out_count])
 					return -ENOMEM;
 				encap = false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1e4ee02bfb1c..5434bbb9a217 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -37,6 +37,8 @@
 #include "en.h"
 #include "eswitch.h"
 #include "en/tc_ct.h"
+#include "en/tc_tun.h"
+#include "en_rep.h"
 
 #define MLX5E_TC_FLOW_ID_MASK 0x0000ffff
 
-- 
2.29.2

