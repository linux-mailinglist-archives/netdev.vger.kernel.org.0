Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18072583F0
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfF0NyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:54:10 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46359 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbfF0NyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:54:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D1072206E;
        Thu, 27 Jun 2019 09:54:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Jun 2019 09:54:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=sokbrYxR2HFyG0No8AZbKxsocBaEU9CvRY2YyVy0Tgg=; b=HS8Cu7NI
        wfGl5kRH3t2Iw2+nKW2GFej1WP4Yf3xWvSp4w9oSag5UxQ4CF7hY35zgGT85zKfN
        uhkxu6U/O6xRuUNDHcl9/++qy08mMd0MarFNQYWudGi3p8Qic5ZVjKlubfZwYGjb
        nWB0uRxXIe+3J6tfKvMIP44rsxEDooGd6oBHQ18HfISMERThRJXdGO8pdtkf+JJ3
        sauSUZaLdCsUI0LgDMy6oboRjXIpZvEjPxSDKlylqxnJeqik/HTwe5RBjm15b+hz
        JRWtopO45zOJnJ1cD+I3ZJBQE+6nokha+2OkZKCH5olTlP9HtyXJsitFP1gOOFzW
        nRKtTSxgANd+Yg==
X-ME-Sender: <xms:fcoUXdCsjxvxlVahNArlfzpzx9ZePxYdb-pVa_xDxp_bKUaNmDc_Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepudeg
X-ME-Proxy: <xmx:fcoUXfxpVCKQz9-rrgrfcIJ98fp0swSzpTPC3Rxde3hAbmM_4wGrpg>
    <xmx:fcoUXTl1JHOiPImCUcZMc-M_GaHD_X4U1nxbWABaQESTlbN46qqIDA>
    <xmx:fcoUXcEoYlUxoLretwfLV_aw4JQZdRuLRgMmx5a97C-aWcpbtAvQ8Q>
    <xmx:fsoUXeAZWRk0AawTm-GbICuJCxFhkPgw5e2nngNAjpRaik_OZmPO1g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2756B8005B;
        Thu, 27 Jun 2019 09:54:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 15/16] mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls
Date:   Thu, 27 Jun 2019 16:52:58 +0300
Message-Id: <20190627135259.7292-16-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627135259.7292-1-idosch@idosch.org>
References: <20190627135259.7292-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The SIOCSHWTSTAMP ioctl configures HW timestamping on a given port.
Dispatch the ioctls to per-chip handler (which add to ptp_ops). Find
which PTP messages need to be timestamped and configure MTPPPC
accordingly.

The SIOCGHWTSTAMP ioctl is getter for the current configuration.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  70 ++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 123 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    |  34 +++++
 3 files changed, 227 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 87e7964ba496..f1df3c63af3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -166,6 +166,11 @@ struct mlxsw_sp_ptp_ops {
 	 */
 	void (*transmitted)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
 			    u8 local_port);
+
+	int (*hwtstamp_get)(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct hwtstamp_config *config);
+	int (*hwtstamp_set)(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct hwtstamp_config *config);
 };
 
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
@@ -1808,6 +1813,65 @@ mlxsw_sp_port_get_devlink_port(struct net_device *dev)
 						mlxsw_sp_port->local_port);
 }
 
+static int mlxsw_sp_port_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	int err;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	err = mlxsw_sp_port->mlxsw_sp->ptp_ops->hwtstamp_set(mlxsw_sp_port,
+							     &config);
+	if (err)
+		return err;
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int mlxsw_sp_port_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	int err;
+
+	err = mlxsw_sp_port->mlxsw_sp->ptp_ops->hwtstamp_get(mlxsw_sp_port,
+							     &config);
+	if (err)
+		return err;
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static inline void mlxsw_sp_port_ptp_clear(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct hwtstamp_config config = {0};
+
+	mlxsw_sp_port->mlxsw_sp->ptp_ops->hwtstamp_set(mlxsw_sp_port, &config);
+}
+
+static int
+mlxsw_sp_port_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return mlxsw_sp_port_hwtstamp_set(mlxsw_sp_port, ifr);
+	case SIOCGHWTSTAMP:
+		return mlxsw_sp_port_hwtstamp_get(mlxsw_sp_port, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_open		= mlxsw_sp_port_open,
 	.ndo_stop		= mlxsw_sp_port_stop,
@@ -1823,6 +1887,7 @@ static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_vlan_rx_kill_vid	= mlxsw_sp_port_kill_vid,
 	.ndo_set_features	= mlxsw_sp_set_features,
 	.ndo_get_devlink_port	= mlxsw_sp_port_get_devlink_port,
+	.ndo_do_ioctl		= mlxsw_sp_port_ioctl,
 };
 
 static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
@@ -3680,6 +3745,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
+	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
 	mlxsw_sp->ports[local_port] = NULL;
@@ -4479,6 +4545,8 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.fini		= mlxsw_sp1_ptp_fini,
 	.receive	= mlxsw_sp1_ptp_receive,
 	.transmitted	= mlxsw_sp1_ptp_transmitted,
+	.hwtstamp_get	= mlxsw_sp1_ptp_hwtstamp_get,
+	.hwtstamp_set	= mlxsw_sp1_ptp_hwtstamp_set,
 };
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
@@ -4488,6 +4556,8 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.fini		= mlxsw_sp2_ptp_fini,
 	.receive	= mlxsw_sp2_ptp_receive,
 	.transmitted	= mlxsw_sp2_ptp_transmitted,
+	.hwtstamp_get	= mlxsw_sp2_ptp_hwtstamp_get,
+	.hwtstamp_set	= mlxsw_sp2_ptp_hwtstamp_set,
 };
 
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 4d6dbac18049..e8df674cd514 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -10,6 +10,7 @@
 #include <linux/ptp_classify.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <linux/net_tstamp.h>
 
 #include "spectrum.h"
 #include "spectrum_ptp.h"
@@ -743,6 +744,15 @@ static int mlxsw_sp1_ptp_set_fifo_clr_on_trap(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mogcr), mogcr_pl);
 }
 
+static int mlxsw_sp1_ptp_mtpppc_set(struct mlxsw_sp *mlxsw_sp,
+				    u16 ing_types, u16 egr_types)
+{
+	char mtpppc_pl[MLXSW_REG_MTPPPC_LEN];
+
+	mlxsw_reg_mtpppc_pack(mtpppc_pl, ing_types, egr_types);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mtpppc), mtpppc_pl);
+}
+
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_ptp_state *ptp_state;
@@ -803,6 +813,7 @@ void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 	struct mlxsw_sp *mlxsw_sp = ptp_state->mlxsw_sp;
 
 	cancel_delayed_work_sync(&ptp_state->ht_gc_dw);
+	mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp, 0, 0);
 	mlxsw_sp1_ptp_set_fifo_clr_on_trap(mlxsw_sp, false);
 	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
 	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP0, 0);
@@ -810,3 +821,115 @@ void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
 				    &mlxsw_sp1_ptp_unmatched_free_fn, NULL);
 	kfree(ptp_state);
 }
+
+int mlxsw_sp1_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config)
+{
+	*config = mlxsw_sp_port->ptp.hwtstamp_config;
+	return 0;
+}
+
+static int mlxsw_sp_ptp_get_message_types(const struct hwtstamp_config *config,
+					  u16 *p_ing_types, u16 *p_egr_types,
+					  enum hwtstamp_rx_filters *p_rx_filter)
+{
+	enum hwtstamp_rx_filters rx_filter = config->rx_filter;
+	enum hwtstamp_tx_types tx_type = config->tx_type;
+	u16 ing_types = 0x00;
+	u16 egr_types = 0x00;
+
+	switch (tx_type) {
+	case HWTSTAMP_TX_OFF:
+		egr_types = 0x00;
+		break;
+	case HWTSTAMP_TX_ON:
+		egr_types = 0xff;
+		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		return -ERANGE;
+	}
+
+	switch (rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ing_types = 0x00;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+		ing_types = 0x01;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		ing_types = 0x02;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+		ing_types = 0x0f;
+		break;
+	case HWTSTAMP_FILTER_ALL:
+		ing_types = 0xff;
+		break;
+	case HWTSTAMP_FILTER_SOME:
+	case HWTSTAMP_FILTER_NTP_ALL:
+		return -ERANGE;
+	}
+
+	*p_ing_types = ing_types;
+	*p_egr_types = egr_types;
+	*p_rx_filter = rx_filter;
+	return 0;
+}
+
+static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_sp_port *mlxsw_sp_port,
+				       u16 ing_types, u16 egr_types)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_port *tmp;
+	int i;
+
+	/* MTPPPC configures timestamping globally, not per port. Find the
+	 * configuration that contains all configured timestamping requests.
+	 */
+	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
+		tmp = mlxsw_sp->ports[i];
+		if (tmp && tmp != mlxsw_sp_port) {
+			ing_types |= tmp->ptp.ing_types;
+			egr_types |= tmp->ptp.egr_types;
+		}
+	}
+
+	return mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp_port->mlxsw_sp,
+				       ing_types, egr_types);
+}
+
+int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config)
+{
+	enum hwtstamp_rx_filters rx_filter;
+	u16 ing_types;
+	u16 egr_types;
+	int err;
+
+	err = mlxsw_sp_ptp_get_message_types(config, &ing_types, &egr_types,
+					     &rx_filter);
+	if (err)
+		return err;
+
+	err = mlxsw_sp1_ptp_mtpppc_update(mlxsw_sp_port, ing_types, egr_types);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->ptp.hwtstamp_config = *config;
+	mlxsw_sp_port->ptp.ing_types = ing_types;
+	mlxsw_sp_port->ptp.egr_types = egr_types;
+
+	/* Notify the ioctl caller what we are actually timestamping. */
+	config->rx_filter = rx_filter;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index a135c6a0a051..14505bcceeb7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -40,6 +40,12 @@ void mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
 				 u8 domain_number, u16 sequence_id,
 				 u64 timestamp);
 
+int mlxsw_sp1_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config);
+
+int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct hwtstamp_config *config);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -82,6 +88,20 @@ mlxsw_sp1_ptp_got_timestamp(struct mlxsw_sp *mlxsw_sp, bool ingress,
 {
 }
 
+static inline int
+mlxsw_sp1_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct hwtstamp_config *config)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct hwtstamp_config *config)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -116,4 +136,18 @@ static inline void mlxsw_sp2_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 	dev_kfree_skb_any(skb);
 }
 
+static inline int
+mlxsw_sp2_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct hwtstamp_config *config)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct hwtstamp_config *config)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif
-- 
2.20.1

