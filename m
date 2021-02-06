Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408B7311B58
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhBFFJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:09:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231287AbhBFFGF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:06:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA4ED64FD6;
        Sat,  6 Feb 2021 05:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587766;
        bh=R32dLjTSp4nInLiZj4Sqx2WqromI3mnh7EGtkcv+Bn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpLtvd4QraEF7CbXLQXaoM1P6IfWcCuq7pLmJN/qNCRgohh0vFEziXHbkpmylxmiG
         yPpZqkRtbyFNxhUxYyY//fFHeHyonQJY0qPXaV+FTs8xeU6697pErUioO5Hvzasqid
         5nM/muv0XtIT4qo9qB1TAPopE7e1BVbuOdLEUH0zoZYKLKps3nXlMJiHBjkGppPctP
         7LwtUcrFzuVHwGT33V4qjL6voTbpIjEAdH8gIA5y5BUugQspSk5wfZFRQH927LmyfZ
         rVFESz0ZvhyQrVyM0kPWYyVTzYVJUflUji0SMhGaKgIppapDYNTpyK6wHobp3imyCB
         08xcth9Z77pzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/17] net/mlx5e: VF tunnel RX traffic offloading
Date:   Fri,  5 Feb 2021 21:02:32 -0800
Message-Id: <20210206050240.48410-10-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

When tunnel endpoint is on VF the encapsulated RX traffic is exposed on the
representor of the VF without any further processing of rules installed on
the VF. Detect such case by checking if the device returned by route lookup
in decap rule handling code is a mlx5 VF and handle it with new redirection
tables API.

Example TC rules for VF tunnel traffic:

1. Rule that encapsulates the tunneled flow and redirects packets from
source VF rep to tunnel device:

$ tc -s filter show dev enp8s0f0_1 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac 0a:40:bd:30:89:99
  src_mac ca:2e:a7:3f:f5:0f
  eth_type ipv4
  ip_tos 0/0x3
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  set
        src_ip 7.7.7.5
        dst_ip 7.7.7.1
        key_id 98
        dst_port 4789
        nocsum
        ttl 64 pipe
         index 1 ref 1 bind 1 installed 411 sec used 411 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        no_percpu
        used_hw_stats delayed

        action order 2: mirred (Egress Redirect to device vxlan_sys_4789) stolen
        index 1 ref 1 bind 1 installed 411 sec used 0 sec
        Action statistics:
        Sent 5615833 bytes 4028 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 5615833 bytes 4028 pkt
        backlog 0b 0p requeues 0
        cookie bb406d45d343bf7ade9690ae80c7cba4
        no_percpu
        used_hw_stats delayed

2. Rule that redirects from tunnel device to UL rep:

$ tc -s filter show dev vxlan_sys_4789 ingress
filter protocol ip pref 4 flower chain 0
filter protocol ip pref 4 flower chain 0 handle 0x1
  dst_mac ca:2e:a7:3f:f5:0f
  src_mac 0a:40:bd:30:89:99
  eth_type ipv4
  enc_dst_ip 7.7.7.5
  enc_src_ip 7.7.7.1
  enc_key_id 98
  enc_dst_port 4789
  enc_tos 0
  ip_flags nofrag
  in_hw in_hw_count 1
        action order 1: tunnel_key  unset pipe
         index 2 ref 1 bind 1 installed 434 sec used 434 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats delayed

        action order 2: mirred (Egress Redirect to device enp8s0f0_1) stolen
        index 4 ref 1 bind 1 installed 434 sec used 0 sec
        Action statistics:
        Sent 129936 bytes 1082 pkt (dropped 0, overlimits 0 requeues 0)
        Sent software 0 bytes 0 pkt
        Sent hardware 129936 bytes 1082 pkt
        backlog 0b 0p requeues 0
        cookie ac17cf398c4c69e4a5b2f7aabd1b88ff
        no_percpu
        used_hw_stats delayed

Co-developed-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  51 ++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 102 ++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |   4 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 119 +++++++++++++++++-
 5 files changed, 271 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 13aa98b82576..73deafe4e693 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -483,6 +483,57 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 }
 #endif
 
+int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
+			      struct mlx5_flow_spec *spec,
+			      struct mlx5_flow_attr *flow_attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = flow_attr->esw_attr;
+	TC_TUN_ROUTE_ATTR_INIT(attr);
+	u16 vport_num;
+	int err = 0;
+
+	if (flow_attr->ip_version == 4) {
+		/* Addresses are swapped for decap */
+		attr.fl.fl4.saddr = esw_attr->rx_tun_attr->dst_ip.v4;
+		attr.fl.fl4.daddr = esw_attr->rx_tun_attr->src_ip.v4;
+		err = mlx5e_route_lookup_ipv4_get(priv, priv->netdev, &attr);
+	}
+#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
+	else if (flow_attr->ip_version == 6) {
+		/* Addresses are swapped for decap */
+		attr.fl.fl6.saddr = esw_attr->rx_tun_attr->dst_ip.v6;
+		attr.fl.fl6.daddr = esw_attr->rx_tun_attr->src_ip.v6;
+		err = mlx5e_route_lookup_ipv6_get(priv, priv->netdev, &attr);
+	}
+#endif
+	else
+		return 0;
+
+	if (err)
+		return err;
+
+	if (attr.route_dev->netdev_ops != &mlx5e_netdev_ops ||
+	    !mlx5e_tc_is_vf_tunnel(attr.out_dev, attr.route_dev))
+		goto out;
+
+	err = mlx5e_tc_query_route_vport(attr.out_dev, attr.route_dev, &vport_num);
+	if (err)
+		goto out;
+
+	esw_attr->rx_tun_attr->vni = MLX5_GET(fte_match_param, spec->match_value,
+					      misc_parameters.vxlan_vni);
+	esw_attr->rx_tun_attr->decap_vport = vport_num;
+
+out:
+	if (flow_attr->ip_version == 4)
+		mlx5e_route_lookup_ipv4_put(&attr);
+#if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
+	else if (flow_attr->ip_version == 6)
+		mlx5e_route_lookup_ipv6_put(&attr);
+#endif
+	return err;
+}
+
 bool mlx5e_tc_tun_device_to_offload(struct mlx5e_priv *priv,
 				    struct net_device *netdev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 704359df6095..9d6ee9405eaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -70,6 +70,9 @@ mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 				struct net_device *mirred_dev,
 				struct mlx5e_encap_entry *e) { return -EOPNOTSUPP; }
 #endif
+int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
+			      struct mlx5_flow_spec *spec,
+			      struct mlx5_flow_attr *attr);
 
 bool mlx5e_tc_tun_device_to_offload(struct mlx5e_priv *priv,
 				    struct net_device *netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 43f1508a05b5..098f3efa5d4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1322,7 +1322,7 @@ static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 
 static bool same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv);
 
-static bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_dev)
+bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_dev)
 {
 	struct mlx5_core_dev *out_mdev, *route_mdev;
 	struct mlx5e_priv *out_priv, *route_priv;
@@ -1339,8 +1339,7 @@ static bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device
 	return same_hw_devs(out_priv, route_priv);
 }
 
-static int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev,
-				      u16 *vport)
+int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev, u16 *vport)
 {
 	struct mlx5e_priv *out_priv, *route_priv;
 	struct mlx5_core_dev *route_mdev;
@@ -1504,6 +1503,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 			kfree(attr->parse_attr->tun_info[out_index]);
 		}
 	kvfree(attr->parse_attr);
+	kvfree(attr->esw_attr->rx_tun_attr);
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
@@ -2134,6 +2134,67 @@ void mlx5e_tc_set_ethertype(struct mlx5_core_dev *mdev,
 	}
 }
 
+static u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer)
+{
+	void *headers_v;
+	u16 ethertype;
+	u8 ip_version;
+
+	if (outer)
+		headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, outer_headers);
+	else
+		headers_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, inner_headers);
+
+	ip_version = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_version);
+	/* Return ip_version converted from ethertype anyway */
+	if (!ip_version) {
+		ethertype = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ethertype);
+		if (ethertype == ETH_P_IP || ethertype == ETH_P_ARP)
+			ip_version = 4;
+		else if (ethertype == ETH_P_IPV6)
+			ip_version = 6;
+	}
+	return ip_version;
+}
+
+static int mlx5e_tc_set_attr_rx_tun(struct mlx5e_tc_flow *flow,
+				    struct mlx5_flow_spec *spec)
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
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
@@ -2142,6 +2203,7 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     u8 *match_level,
 			     bool *match_inner)
 {
+	struct mlx5e_tc_tunnel *tunnel = mlx5e_get_tc_tun(filter_dev);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct netlink_ext_ack *extack = f->common.extack;
 	bool needs_mapping, sets_mapping;
@@ -2179,6 +2241,31 @@ static int parse_tunnel_attr(struct mlx5e_priv *priv,
 		 */
 		if (!netif_is_bareudp(filter_dev))
 			flow->attr->action |= MLX5_FLOW_CONTEXT_ACTION_DECAP;
+		err = mlx5e_tc_set_attr_rx_tun(flow, spec);
+		if (err)
+			return err;
+	} else if (tunnel && tunnel->tunnel_type == MLX5E_TC_TUNNEL_TYPE_VXLAN) {
+		struct mlx5_flow_spec *tmp_spec;
+
+		tmp_spec = kvzalloc(sizeof(*tmp_spec), GFP_KERNEL);
+		if (!tmp_spec) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to allocate memory for vxlan tmp spec");
+			netdev_warn(priv->netdev, "Failed to allocate memory for vxlan tmp spec");
+			return -ENOMEM;
+		}
+		memcpy(tmp_spec, spec, sizeof(*tmp_spec));
+
+		err = mlx5e_tc_tun_parse(filter_dev, priv, tmp_spec, f, match_level);
+		if (err) {
+			kvfree(tmp_spec);
+			NL_SET_ERR_MSG_MOD(extack, "Failed to parse tunnel attributes");
+			netdev_warn(priv->netdev, "Failed to parse tunnel attributes");
+			return err;
+		}
+		err = mlx5e_tc_set_attr_rx_tun(flow, tmp_spec);
+		kvfree(tmp_spec);
+		if (err)
+			return err;
 	}
 
 	if (!needs_mapping && !sets_mapping)
@@ -4473,6 +4560,15 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		}
 	}
 
+	if (decap && esw_attr->rx_tun_attr) {
+		err = mlx5e_tc_tun_route_lookup(priv, &parse_attr->spec, attr);
+		if (err)
+			return err;
+	}
+
+	/* always set IP version for indirect table handling */
+	attr->ip_version = mlx5e_tc_get_ip_version(&parse_attr->spec, true);
+
 	if (MLX5_CAP_GEN(esw->dev, prio_tag_required) &&
 	    action & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) {
 		/* For prio tag mode, replace vlan pop with rewrite vlan prio
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 852e0981343d..ee0029192504 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -257,6 +257,10 @@ mlx5_tc_rule_delete(struct mlx5e_priv *priv,
 		    struct mlx5_flow_handle *rule,
 		    struct mlx5_flow_attr *attr);
 
+bool mlx5e_tc_is_vf_tunnel(struct net_device *out_dev, struct net_device *route_dev);
+int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *route_dev,
+			       u16 *vport);
+
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index da843eab5c07..a44728595420 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -40,6 +40,7 @@
 #include "eswitch.h"
 #include "esw/indir_table.h"
 #include "esw/acl/ofld.h"
+#include "esw/indir_table.h"
 #include "rdma.h"
 #include "en.h"
 #include "fs_core.h"
@@ -258,6 +259,7 @@ mlx5_eswitch_set_rule_flow_source(struct mlx5_eswitch *esw,
 static void
 mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 				  struct mlx5_flow_spec *spec,
+				  struct mlx5_flow_attr *attr,
 				  struct mlx5_eswitch *src_esw,
 				  u16 vport)
 {
@@ -268,6 +270,8 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 	 * VHCA in dual-port RoCE mode, and matching on source vport may fail.
 	 */
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
+		if (mlx5_esw_indir_table_decap_vport(attr))
+			vport = mlx5_esw_indir_table_decap_vport(attr);
 		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_2);
 		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
 			 mlx5_eswitch_get_vport_metadata_for_match(src_esw,
@@ -297,15 +301,46 @@ mlx5_eswitch_set_rule_source_port(struct mlx5_eswitch *esw,
 	}
 }
 
+static int
+esw_setup_decap_indir(struct mlx5_eswitch *esw,
+		      struct mlx5_flow_attr *attr,
+		      struct mlx5_flow_spec *spec)
+{
+	struct mlx5_flow_table *ft;
+
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
+		return -EOPNOTSUPP;
+
+	ft = mlx5_esw_indir_table_get(esw, attr, spec,
+				      mlx5_esw_indir_table_decap_vport(attr), true);
+	return PTR_ERR_OR_ZERO(ft);
+}
+
 static void
+esw_cleanup_decap_indir(struct mlx5_eswitch *esw,
+			struct mlx5_flow_attr *attr)
+{
+	if (mlx5_esw_indir_table_decap_vport(attr))
+		mlx5_esw_indir_table_put(esw, attr,
+					 mlx5_esw_indir_table_decap_vport(attr),
+					 true);
+}
+
+static int
 esw_setup_ft_dest(struct mlx5_flow_destination *dest,
 		  struct mlx5_flow_act *flow_act,
+		  struct mlx5_eswitch *esw,
 		  struct mlx5_flow_attr *attr,
+		  struct mlx5_flow_spec *spec,
 		  int i)
 {
 	flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
 	dest[i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest[i].ft = attr->dest_ft;
+
+	if (mlx5_esw_indir_table_decap_vport(attr))
+		return esw_setup_decap_indir(esw, attr, spec);
+	return 0;
 }
 
 static void
@@ -348,6 +383,10 @@ static void esw_put_dest_tables_loop(struct mlx5_eswitch *esw, struct mlx5_flow_
 	for (i = from; i < to; i++)
 		if (esw_attr->dests[i].flags & MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE)
 			mlx5_chains_put_table(chains, 0, 1, 0);
+		else if (mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
+						     esw_attr->dests[i].mdev))
+			mlx5_esw_indir_table_put(esw, attr, esw_attr->dests[i].rep->vport,
+						 false);
 }
 
 static bool
@@ -397,6 +436,68 @@ static void esw_cleanup_chain_src_port_rewrite(struct mlx5_eswitch *esw,
 	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, esw_attr->out_count);
 }
 
+static bool
+esw_is_indir_table(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	int i;
+
+	for (i = esw_attr->split_count; i < esw_attr->out_count; i++)
+		if (mlx5_esw_indir_table_needed(esw, attr, esw_attr->dests[i].rep->vport,
+						esw_attr->dests[i].mdev))
+			return true;
+	return false;
+}
+
+static int
+esw_setup_indir_table(struct mlx5_flow_destination *dest,
+		      struct mlx5_flow_act *flow_act,
+		      struct mlx5_eswitch *esw,
+		      struct mlx5_flow_attr *attr,
+		      struct mlx5_flow_spec *spec,
+		      bool ignore_flow_lvl,
+		      int *i)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+	int j, err;
+
+	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SRC_REWRITE))
+		return -EOPNOTSUPP;
+
+	for (j = esw_attr->split_count; j < esw_attr->out_count; j++, (*i)++) {
+		if (ignore_flow_lvl)
+			flow_act->flags |= FLOW_ACT_IGNORE_FLOW_LEVEL;
+		dest[*i].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+
+		dest[*i].ft = mlx5_esw_indir_table_get(esw, attr, spec,
+						       esw_attr->dests[j].rep->vport, false);
+		if (IS_ERR(dest[*i].ft)) {
+			err = PTR_ERR(dest[*i].ft);
+			goto err_indir_tbl_get;
+		}
+	}
+
+	if (mlx5_esw_indir_table_decap_vport(attr)) {
+		err = esw_setup_decap_indir(esw, attr, spec);
+		if (err)
+			goto err_indir_tbl_get;
+	}
+
+	return 0;
+
+err_indir_tbl_get:
+	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, j);
+	return err;
+}
+
+static void esw_cleanup_indir_table(struct mlx5_eswitch *esw, struct mlx5_flow_attr *attr)
+{
+	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
+
+	esw_put_dest_tables_loop(esw, attr, esw_attr->split_count, esw_attr->out_count);
+	esw_cleanup_decap_indir(esw, attr);
+}
+
 static void
 esw_cleanup_chain_dest(struct mlx5_fs_chains *chains, u32 chain, u32 prio, u32 level)
 {
@@ -454,7 +555,7 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		attr->flags |= MLX5_ESW_ATTR_FLAG_SRC_REWRITE;
 
 	if (attr->dest_ft) {
-		esw_setup_ft_dest(dest, flow_act, attr, *i);
+		esw_setup_ft_dest(dest, flow_act, esw, attr, spec, *i);
 		(*i)++;
 	} else if (attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH) {
 		esw_setup_slow_path_dest(dest, flow_act, chains, *i);
@@ -463,6 +564,8 @@ esw_setup_dests(struct mlx5_flow_destination *dest,
 		err = esw_setup_chain_dest(dest, flow_act, chains, attr->dest_chain,
 					   1, 0, *i);
 		(*i)++;
+	} else if (esw_is_indir_table(esw, attr)) {
+		err = esw_setup_indir_table(dest, flow_act, esw, attr, spec, true, i);
 	} else if (esw_is_chain_src_port_rewrite(esw, esw_attr)) {
 		err = esw_setup_chain_src_port_rewrite(dest, flow_act, esw, chains, attr, i);
 	} else {
@@ -479,9 +582,13 @@ esw_cleanup_dests(struct mlx5_eswitch *esw,
 	struct mlx5_esw_flow_attr *esw_attr = attr->esw_attr;
 	struct mlx5_fs_chains *chains = esw_chains(esw);
 
-	if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
+	if (attr->dest_ft) {
+		esw_cleanup_decap_indir(esw, attr);
+	} else if (!(attr->flags & MLX5_ESW_ATTR_FLAG_SLOW_PATH)) {
 		if (attr->dest_chain)
 			esw_cleanup_chain_dest(chains, attr->dest_chain, 1, 0);
+		else if (esw_is_indir_table(esw, attr))
+			esw_cleanup_indir_table(esw, attr);
 		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
 			esw_cleanup_chain_src_port_rewrite(esw, attr);
 	}
@@ -564,7 +671,7 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 			fdb = attr->ft;
 
 		if (!(attr->flags & MLX5_ESW_ATTR_FLAG_NO_IN_PORT))
-			mlx5_eswitch_set_rule_source_port(esw, spec,
+			mlx5_eswitch_set_rule_source_port(esw, spec, attr,
 							  esw_attr->in_mdev->priv.eswitch,
 							  esw_attr->in_rep->vport);
 	}
@@ -628,7 +735,9 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	for (i = 0; i < esw_attr->split_count; i++) {
-		if (esw_is_chain_src_port_rewrite(esw, esw_attr))
+		if (esw_is_indir_table(esw, attr))
+			err = esw_setup_indir_table(dest, &flow_act, esw, attr, spec, false, &i);
+		else if (esw_is_chain_src_port_rewrite(esw, esw_attr))
 			err = esw_setup_chain_src_port_rewrite(dest, &flow_act, esw, chains, attr,
 							       &i);
 		else
@@ -643,7 +752,7 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
 	dest[i].ft = fwd_fdb;
 	i++;
 
-	mlx5_eswitch_set_rule_source_port(esw, spec,
+	mlx5_eswitch_set_rule_source_port(esw, spec, attr,
 					  esw_attr->in_mdev->priv.eswitch,
 					  esw_attr->in_rep->vport);
 
-- 
2.29.2

