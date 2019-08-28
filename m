Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D993A06B1
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 17:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfH1PzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 11:55:14 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35007 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726554AbfH1PzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 11:55:11 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5C36E22050;
        Wed, 28 Aug 2019 11:55:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 28 Aug 2019 11:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=flEH2j8gK3i1e+IOi+HRjVieBCo7PLCl+rCd1dWOXJs=; b=Ju5qzabr
        IsRdkc2N3JxwoQ/BsO9BzRZnibOAsDGRYurieGdNx09Vm1j0GyN83ScPL7x3l2uf
        ml9HyjbN5O4sFixCEs8/yKMJxRmDthLn9j782xj9dKJ0y/bAfPXtsBkhKgGAUwc8
        s84EQ+iof5xwcUrgBG/31rE12GjGs6JID7fODSD9yL04KPZv2sTC1mk0hlEAefcP
        TiOB06aJOqqHH5NyMzhwQ6Id6mT/JBS9evOuUXSrDQ4jidQk0+SMQ3OyhakQOKjm
        x1pB5ZXtlwU8W14KRA4+UuvpiQOjQ7tvDk6GzUHH0SpLwJ5lYTXOGoOl0IBKxaJm
        Z9TX3gPO16VfZw==
X-ME-Sender: <xms:3aNmXZ-ZdYsKDp3Op8ZfUGrzj7Nfs4l3PJAuFpIsT-1VyThv-NNAIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeitddgleegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:3aNmXUqgjp4CPdYgNnYuqIktxZ3VSbCHbKYBMIF8FmPjWJ8p38op2w>
    <xmx:3aNmXcEN5Ej_QhGfrnhpeQmcpbhZBFsdCDhm7_PwJ_qA9_q3DMpu2w>
    <xmx:3aNmXUl5Fx7HEo2QEYcvA5PDHMrx4YlAEz1uMS01JVtCGPuegV3zpg>
    <xmx:3aNmXfeI9ZQJHmYHiY_B_UQLs6f0cCsoe_ReX5XkmZPemZ1AIJ0Wfg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id D483AD60057;
        Wed, 28 Aug 2019 11:55:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Petr Machata <petrm@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/4] mlxsw: spectrum_ptp: Add counters for GC events
Date:   Wed, 28 Aug 2019 18:54:37 +0300
Message-Id: <20190828155437.9852-5-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828155437.9852-1-idosch@idosch.org>
References: <20190828155437.9852-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

On Spectrum-1, timestamped PTP packets and the corresponding timestamps need to
be kept in caches until both are available, at which point they are matched up
and packets forwarded as appropriate. However, not all packets will ever see
their timestamp, and not all timestamps will ever see their packet. It is
necessary to dispose of such abandoned entries, so a garbage collector was
introduced in commit 5d23e4159772 ("mlxsw: spectrum: PTP: Garbage-collect
unmatched entries").

If these GC events happen often, it is a sign of a problem. However because this
whole mechanism is taking place behind the scenes, there is no direct way to
determine whether garbage collection took place.

Therefore to fix this, on Spectrum-1 only, expose four artificial ethtool
counters for the GC events: GCd timestamps and packets, in TX and RX directions.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 23 ++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 11 +++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 67 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 32 +++++++++
 4 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dd3ae46e5eca..91e4792bb7e7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -175,6 +175,10 @@ struct mlxsw_sp_ptp_ops {
 	void (*shaper_work)(struct work_struct *work);
 	int (*get_ts_info)(struct mlxsw_sp *mlxsw_sp,
 			   struct ethtool_ts_info *info);
+	int (*get_stats_count)(void);
+	void (*get_stats_strings)(u8 **p);
+	void (*get_stats)(struct mlxsw_sp_port *mlxsw_sp_port,
+			  u64 *data, int data_index);
 };
 
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
@@ -2329,6 +2333,7 @@ static void mlxsw_sp_port_get_tc_strings(u8 **p, int tc)
 static void mlxsw_sp_port_get_strings(struct net_device *dev,
 				      u32 stringset, u8 *data)
 {
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	u8 *p = data;
 	int i;
 
@@ -2370,6 +2375,7 @@ static void mlxsw_sp_port_get_strings(struct net_device *dev,
 		for (i = 0; i < TC_MAX_QUEUE; i++)
 			mlxsw_sp_port_get_tc_strings(&p, i);
 
+		mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_strings(&p);
 		break;
 	}
 }
@@ -2464,6 +2470,7 @@ static void __mlxsw_sp_port_get_stats(struct net_device *dev,
 static void mlxsw_sp_port_get_stats(struct net_device *dev,
 				    struct ethtool_stats *stats, u64 *data)
 {
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	int i, data_index = 0;
 
 	/* IEEE 802.3 Counters */
@@ -2504,13 +2511,21 @@ static void mlxsw_sp_port_get_stats(struct net_device *dev,
 					  data, data_index);
 		data_index += MLXSW_SP_PORT_HW_TC_STATS_LEN;
 	}
+
+	/* PTP counters */
+	mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats(mlxsw_sp_port,
+						    data, data_index);
+	data_index += mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
 }
 
 static int mlxsw_sp_port_get_sset_count(struct net_device *dev, int sset)
 {
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return MLXSW_SP_PORT_ETHTOOL_STATS_LEN;
+		return MLXSW_SP_PORT_ETHTOOL_STATS_LEN +
+		       mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -4643,6 +4658,9 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.hwtstamp_set	= mlxsw_sp1_ptp_hwtstamp_set,
 	.shaper_work	= mlxsw_sp1_ptp_shaper_work,
 	.get_ts_info	= mlxsw_sp1_ptp_get_ts_info,
+	.get_stats_count = mlxsw_sp1_get_stats_count,
+	.get_stats_strings = mlxsw_sp1_get_stats_strings,
+	.get_stats	= mlxsw_sp1_get_stats,
 };
 
 static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
@@ -4656,6 +4674,9 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.hwtstamp_set	= mlxsw_sp2_ptp_hwtstamp_set,
 	.shaper_work	= mlxsw_sp2_ptp_shaper_work,
 	.get_ts_info	= mlxsw_sp2_ptp_get_ts_info,
+	.get_stats_count = mlxsw_sp2_get_stats_count,
+	.get_stats_strings = mlxsw_sp2_get_stats_strings,
+	.get_stats	= mlxsw_sp2_get_stats,
 };
 
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 12f14a42b43a..b2a0028b1694 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -225,6 +225,16 @@ struct mlxsw_sp_port_xstats {
 	u64 tx_packets[IEEE_8021QAZ_MAX_TCS];
 };
 
+struct mlxsw_sp_ptp_port_dir_stats {
+	u64 packets;
+	u64 timestamps;
+};
+
+struct mlxsw_sp_ptp_port_stats {
+	struct mlxsw_sp_ptp_port_dir_stats rx_gcd;
+	struct mlxsw_sp_ptp_port_dir_stats tx_gcd;
+};
+
 struct mlxsw_sp_port {
 	struct net_device *dev;
 	struct mlxsw_sp_port_pcpu_stats __percpu *pcpu_stats;
@@ -271,6 +281,7 @@ struct mlxsw_sp_port {
 		struct hwtstamp_config hwtstamp_config;
 		u16 ing_types;
 		u16 egr_types;
+		struct mlxsw_sp_ptp_port_stats stats;
 	} ptp;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 38bb1cfe4e8c..ec2ff3d7f41c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -630,6 +630,8 @@ static void
 mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
 			    struct mlxsw_sp1_ptp_unmatched *unmatched)
 {
+	struct mlxsw_sp_ptp_port_dir_stats *stats;
+	struct mlxsw_sp_port *mlxsw_sp_port;
 	int err;
 
 	/* If an unmatched entry has an SKB, it has to be handed over to the
@@ -650,6 +652,17 @@ mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
 		/* The packet was matched with timestamp during the walk. */
 		goto out;
 
+	mlxsw_sp_port = ptp_state->mlxsw_sp->ports[unmatched->key.local_port];
+	if (mlxsw_sp_port) {
+		stats = unmatched->key.ingress ?
+			&mlxsw_sp_port->ptp.stats.rx_gcd :
+			&mlxsw_sp_port->ptp.stats.tx_gcd;
+		if (unmatched->skb)
+			stats->packets++;
+		else
+			stats->timestamps++;
+	}
+
 	/* mlxsw_sp1_ptp_unmatched_finish() invokes netif_receive_skb(). While
 	 * the comment at that function states that it can only be called in
 	 * soft IRQ context, this pattern of local_bh_disable() +
@@ -1098,3 +1111,57 @@ int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 
 	return 0;
 }
+
+struct mlxsw_sp_ptp_port_stat {
+	char str[ETH_GSTRING_LEN];
+	ptrdiff_t offset;
+};
+
+#define MLXSW_SP_PTP_PORT_STAT(NAME, FIELD)				\
+	{								\
+		.str = NAME,						\
+		.offset = offsetof(struct mlxsw_sp_ptp_port_stats,	\
+				    FIELD),				\
+	}
+
+static const struct mlxsw_sp_ptp_port_stat mlxsw_sp_ptp_port_stats[] = {
+	MLXSW_SP_PTP_PORT_STAT("ptp_rx_gcd_packets",    rx_gcd.packets),
+	MLXSW_SP_PTP_PORT_STAT("ptp_rx_gcd_timestamps", rx_gcd.timestamps),
+	MLXSW_SP_PTP_PORT_STAT("ptp_tx_gcd_packets",    tx_gcd.packets),
+	MLXSW_SP_PTP_PORT_STAT("ptp_tx_gcd_timestamps", tx_gcd.timestamps),
+};
+
+#undef MLXSW_SP_PTP_PORT_STAT
+
+#define MLXSW_SP_PTP_PORT_STATS_LEN \
+	ARRAY_SIZE(mlxsw_sp_ptp_port_stats)
+
+int mlxsw_sp1_get_stats_count(void)
+{
+	return MLXSW_SP_PTP_PORT_STATS_LEN;
+}
+
+void mlxsw_sp1_get_stats_strings(u8 **p)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP_PTP_PORT_STATS_LEN; i++) {
+		memcpy(*p, mlxsw_sp_ptp_port_stats[i].str,
+		       ETH_GSTRING_LEN);
+		*p += ETH_GSTRING_LEN;
+	}
+}
+
+void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+			 u64 *data, int data_index)
+{
+	void *stats = &mlxsw_sp_port->ptp.stats;
+	ptrdiff_t offset;
+	int i;
+
+	data += data_index;
+	for (i = 0; i < MLXSW_SP_PTP_PORT_STATS_LEN; i++) {
+		offset = mlxsw_sp_ptp_port_stats[i].offset;
+		*data++ = *(u64 *)(stats + offset);
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index 72e55f6926b9..8c386571afce 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -59,6 +59,11 @@ void mlxsw_sp1_ptp_shaper_work(struct work_struct *work);
 int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 			      struct ethtool_ts_info *info);
 
+int mlxsw_sp1_get_stats_count(void);
+void mlxsw_sp1_get_stats_strings(u8 **p);
+void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+			 u64 *data, int data_index);
+
 #else
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -125,6 +130,19 @@ static inline int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_sp_ptp_get_ts_info_noptp(info);
 }
 
+static inline int mlxsw_sp1_get_stats_count(void)
+{
+	return 0;
+}
+
+static inline void mlxsw_sp1_get_stats_strings(u8 **p)
+{
+}
+
+static inline void mlxsw_sp1_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+				       u64 *data, int data_index)
+{
+}
 #endif
 
 static inline struct mlxsw_sp_ptp_clock *
@@ -183,4 +201,18 @@ static inline int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_sp_ptp_get_ts_info_noptp(info);
 }
 
+static inline int mlxsw_sp2_get_stats_count(void)
+{
+	return 0;
+}
+
+static inline void mlxsw_sp2_get_stats_strings(u8 **p)
+{
+}
+
+static inline void mlxsw_sp2_get_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+				       u64 *data, int data_index)
+{
+}
+
 #endif
-- 
2.21.0

