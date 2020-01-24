Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC73C1485EF
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 14:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbgAXNY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 08:24:29 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34875 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389661AbgAXNY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 08:24:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D9BEA21B74;
        Fri, 24 Jan 2020 08:24:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 24 Jan 2020 08:24:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ehk3n/G4YgwsAssBoYMnIpOO+MyeZZm2SMouJBjpikI=; b=kVmMEBIW
        pNk6tPgXj1QJXIWe/RBlPFSFGTyswylS3G612Pvt6bkOjCX8/rjkA1N7JtLpDGMV
        Y9Unj1RJopJPWG694I8+rrp0j45L8cbhzQG40FF7WunOWylwUej1JsC4RcAaU6fL
        b3S4PxowQrqQyhffy0hvx7hWPYvufm9HFSSaxksA/Lgt2kCHpgNY0x+mXuRbvlZP
        9KDc/cwMtpneUPGaXOE8IzJCFa4iXittHHAle6KJhS/8eV+fbZkg77DGvTzDcb+7
        dZnE8UJIvGsGhsv2b+dU0tGkXzA4UKosnfuOnsPM23ckY0wjDe0rcT0qx/kb00Fo
        icyVEniWcCAveA==
X-ME-Sender: <xms:CfAqXqbv0s5qtTfTZjNZmPcTOcxAdLbhKAJ2TYJp1HzB4wUOffT3-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrvdeggdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukeefrddutdejrdduvddtnecuvehluhhsthgvrh
    fuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:CfAqXhhUyUY20n6QBJSOO8ZKvVOF9-pmvTItcfvk_Yj11BnPyDfZAw>
    <xmx:CfAqXpe8R5C3CWriFsz93oTnG7V8Y_c3tp945j9_4lKCpnBRYmgQHw>
    <xmx:CfAqXtXSAU39wFrZF8UwgY3itJ5AyVm0UUaUxbkz319HmG7uvp8dXg>
    <xmx:CfAqXllSNYlO7GjgCmXVAEk9zyJHp2sUqv9XuX79V9MYfvuBTylthw>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D5753061106;
        Fri, 24 Jan 2020 08:24:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/14] mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc
Date:   Fri, 24 Jan 2020 15:23:14 +0200
Message-Id: <20200124132318.712354-11-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200124132318.712354-1-idosch@idosch.org>
References: <20200124132318.712354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

React to the TC messages that were introduced in a preceding patch and
configure egress maximum shaper as appropriate. TBF can be used as a root
qdisc or under one of PRIO or strict ETS bands.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 199 ++++++++++++++++++
 3 files changed, 203 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 021664c62bba..7358b5bc7eb6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1796,6 +1796,8 @@ static int mlxsw_sp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		return mlxsw_sp_setup_tc_prio(mlxsw_sp_port, type_data);
 	case TC_SETUP_QDISC_ETS:
 		return mlxsw_sp_setup_tc_ets(mlxsw_sp_port, type_data);
+	case TC_SETUP_QDISC_TBF:
+		return mlxsw_sp_setup_tc_tbf(mlxsw_sp_port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a2393c02a5e5..a0f1f9dceec5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -862,6 +862,8 @@ int mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_prio_qopt_offload *p);
 int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 			  struct tc_ets_qopt_offload *p);
+int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_tbf_qopt_offload *p);
 
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 57b014a95bc8..79a2801d59f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -19,6 +19,7 @@ enum mlxsw_sp_qdisc_type {
 	MLXSW_SP_QDISC_RED,
 	MLXSW_SP_QDISC_PRIO,
 	MLXSW_SP_QDISC_ETS,
+	MLXSW_SP_QDISC_TBF,
 };
 
 struct mlxsw_sp_qdisc_ops {
@@ -540,6 +541,204 @@ int mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+static void
+mlxsw_sp_setup_tc_qdisc_leaf_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+					 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	u64 backlog_cells = 0;
+	u64 tx_packets = 0;
+	u64 tx_bytes = 0;
+	u64 drops = 0;
+
+	mlxsw_sp_qdisc_collect_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+					&tx_bytes, &tx_packets,
+					&drops, &backlog_cells);
+
+	mlxsw_sp_qdisc->stats_base.tx_packets = tx_packets;
+	mlxsw_sp_qdisc->stats_base.tx_bytes = tx_bytes;
+	mlxsw_sp_qdisc->stats_base.drops = drops;
+	mlxsw_sp_qdisc->stats_base.backlog = 0;
+}
+
+static int
+mlxsw_sp_qdisc_tbf_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	struct mlxsw_sp_qdisc *root_qdisc = mlxsw_sp_port->root_qdisc;
+
+	if (root_qdisc != mlxsw_sp_qdisc)
+		root_qdisc->stats_base.backlog -=
+					mlxsw_sp_qdisc->stats_base.backlog;
+
+	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
+					     MLXSW_REG_QEEC_HR_SUBGROUP,
+					     mlxsw_sp_qdisc->tclass_num, 0,
+					     MLXSW_REG_QEEC_MAS_DIS, 0);
+}
+
+static int
+mlxsw_sp_qdisc_tbf_bs(struct mlxsw_sp_port *mlxsw_sp_port,
+		      u32 max_size, u8 *p_burst_size)
+{
+	/* TBF burst size is configured in bytes. The ASIC burst size value is
+	 * ((2 ^ bs) * 512 bits. Convert the TBF bytes to 512-bit units.
+	 */
+	u32 bs512 = max_size / 64;
+	u8 bs = fls(bs512);
+
+	if (!bs)
+		return -EINVAL;
+	--bs;
+
+	/* Demand a power of two. */
+	if ((1 << bs) != bs512)
+		return -EINVAL;
+
+	if (bs < mlxsw_sp_port->mlxsw_sp->lowest_shaper_bs ||
+	    bs > MLXSW_REG_QEEC_HIGHEST_SHAPER_BS)
+		return -EINVAL;
+
+	*p_burst_size = bs;
+	return 0;
+}
+
+static u32
+mlxsw_sp_qdisc_tbf_max_size(u8 bs)
+{
+	return (1U << bs) * 64;
+}
+
+static u64
+mlxsw_sp_qdisc_tbf_rate_kbps(struct tc_tbf_qopt_offload_replace_params *p)
+{
+	/* TBF interface is in bytes/s, whereas Spectrum ASIC is configured in
+	 * Kbits/s.
+	 */
+	return p->rate.rate_bytes_ps / 1000 * 8;
+}
+
+static int
+mlxsw_sp_qdisc_tbf_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
+				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				void *params)
+{
+	struct tc_tbf_qopt_offload_replace_params *p = params;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u64 rate_kbps = mlxsw_sp_qdisc_tbf_rate_kbps(p);
+	u8 burst_size;
+	int err;
+
+	if (rate_kbps >= MLXSW_REG_QEEC_MAS_DIS) {
+		dev_err(mlxsw_sp_port->mlxsw_sp->bus_info->dev,
+			"spectrum: TBF: rate of %lluKbps must be below %u\n",
+			rate_kbps, MLXSW_REG_QEEC_MAS_DIS);
+		return -EINVAL;
+	}
+
+	err = mlxsw_sp_qdisc_tbf_bs(mlxsw_sp_port, p->max_size, &burst_size);
+	if (err) {
+		u8 highest_shaper_bs = MLXSW_REG_QEEC_HIGHEST_SHAPER_BS;
+
+		dev_err(mlxsw_sp->bus_info->dev,
+			"spectrum: TBF: invalid burst size of %u, must be a power of two between %u and %u",
+			p->max_size,
+			mlxsw_sp_qdisc_tbf_max_size(mlxsw_sp->lowest_shaper_bs),
+			mlxsw_sp_qdisc_tbf_max_size(highest_shaper_bs));
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			   void *params)
+{
+	struct tc_tbf_qopt_offload_replace_params *p = params;
+	u64 rate_kbps = mlxsw_sp_qdisc_tbf_rate_kbps(p);
+	u8 burst_size;
+	int err;
+
+	err = mlxsw_sp_qdisc_tbf_bs(mlxsw_sp_port, p->max_size, &burst_size);
+	if (WARN_ON_ONCE(err))
+		/* check_params above was supposed to reject this value. */
+		return -EINVAL;
+
+	/* Configure subgroup shaper, so that both UC and MC traffic is subject
+	 * to shaping. That is unlike RED, however UC queue lengths are going to
+	 * be different than MC ones due to different pool and quota
+	 * configurations, so the configuration is not applicable. For shaper on
+	 * the other hand, subjecting the overall stream to the configured
+	 * shaper makes sense. Also note that that is what we do for
+	 * ieee_setmaxrate().
+	 */
+	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
+					     MLXSW_REG_QEEC_HR_SUBGROUP,
+					     mlxsw_sp_qdisc->tclass_num, 0,
+					     rate_kbps, burst_size);
+}
+
+static void
+mlxsw_sp_qdisc_tbf_unoffload(struct mlxsw_sp_port *mlxsw_sp_port,
+			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			     void *params)
+{
+	struct tc_tbf_qopt_offload_replace_params *p = params;
+
+	mlxsw_sp_qdisc_leaf_unoffload(mlxsw_sp_port, mlxsw_sp_qdisc, p->qstats);
+}
+
+static int
+mlxsw_sp_qdisc_get_tbf_stats(struct mlxsw_sp_port *mlxsw_sp_port,
+			     struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			     struct tc_qopt_offload_stats *stats_ptr)
+{
+	mlxsw_sp_qdisc_get_tc_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+				    stats_ptr);
+	return 0;
+}
+
+static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_tbf = {
+	.type = MLXSW_SP_QDISC_TBF,
+	.check_params = mlxsw_sp_qdisc_tbf_check_params,
+	.replace = mlxsw_sp_qdisc_tbf_replace,
+	.unoffload = mlxsw_sp_qdisc_tbf_unoffload,
+	.destroy = mlxsw_sp_qdisc_tbf_destroy,
+	.get_stats = mlxsw_sp_qdisc_get_tbf_stats,
+	.clean_stats = mlxsw_sp_setup_tc_qdisc_leaf_clean_stats,
+};
+
+int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct tc_tbf_qopt_offload *p)
+{
+	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
+
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
+	if (!mlxsw_sp_qdisc)
+		return -EOPNOTSUPP;
+
+	if (p->command == TC_TBF_REPLACE)
+		return mlxsw_sp_qdisc_replace(mlxsw_sp_port, p->handle,
+					      mlxsw_sp_qdisc,
+					      &mlxsw_sp_qdisc_ops_tbf,
+					      &p->replace_params);
+
+	if (!mlxsw_sp_qdisc_compare(mlxsw_sp_qdisc, p->handle,
+				    MLXSW_SP_QDISC_TBF))
+		return -EOPNOTSUPP;
+
+	switch (p->command) {
+	case TC_TBF_DESTROY:
+		return mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
+	case TC_TBF_STATS:
+		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
+						&p->stats);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int
 __mlxsw_sp_qdisc_ets_destroy(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-- 
2.24.1

