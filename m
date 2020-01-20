Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DE2142488
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgATHxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:53:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50989 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbgATHxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:53:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 610D821AB4;
        Mon, 20 Jan 2020 02:53:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jan 2020 02:53:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=wqG/FNc/cGl+0RvBGhc+eJGn4SVm5tadXBGH0EjZbfs=; b=pR4iLuAp
        NFCNXBWOTqtF/yTTtpk5Zud9/vqcSKvLD08wd/rq3o26WwuFdvV0avcg2ckkMkGs
        nzbSInLZ8rRRmJMVACwULQ2D1N5zkO6yfL4UDICU7m6Xj1LXuToolMWhOr9zJtoG
        IjcC4jEXnfe7LIY4W7wOGRjjoObG062ie9Q88t4OisQGgFEQB/FqKig+X5bq0TW5
        5M1fRiLK4nBVv4907f8ngHaIRZ6udcWsuAQDmAq78psfTrI+AJ/Af0KwsS840LQy
        XNnu6QFkpgAx6m4k4ee8uqhQuOI71TrZzwIEE4pB0R9CbYUq4EDxKeGo250ma5x5
        CFHX1wFRimKDhw==
X-ME-Sender: <xms:jFwlXoFjXIvrGXZx7yqn3MVezpNUNJpTL225nOQBDphwmhPUS3_HBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jFwlXiZlC-L5iJbDljvjxHU-W6Y2N-IallCO808Zy-xDUBuJazus3A>
    <xmx:jFwlXppShiCHD4tfVL6MiRnl7c65rkXaKSfRextc-fiL7tPW6A64hA>
    <xmx:jFwlXoVlTVBj7oPjYjrGIOd9dC9liCBRcBKJMaKQLmw-Hhov63jIQA>
    <xmx:jFwlXnLxFqxZdRRfz0VZUeTBPeOfv5pF7fW39qMurhr7SwhrqD0ueg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2BAAF80060;
        Mon, 20 Jan 2020 02:53:47 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/4] mlxsw: spectrum: Fix SPAN egress mirroring buffer size for Spectrum-2
Date:   Mon, 20 Jan 2020 09:52:52 +0200
Message-Id: <20200120075253.3356176-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200120075253.3356176-1-idosch@idosch.org>
References: <20200120075253.3356176-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

For SPAN egress mirroring buffer size, it is needed to use a different
formula for Spectrum and Spectrum-2. Move the buffer size computation to
ops and implement new formula for Spectrum-2.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 34 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 16 +++++----
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1bedf9bc0a57..f6d2c6f6889f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -195,6 +195,10 @@ struct mlxsw_sp_ptp_ops {
 			  u64 *data, int data_index);
 };
 
+struct mlxsw_sp_span_ops {
+	u32 (*buffsize_get)(int mtu, u32 speed);
+};
+
 static int mlxsw_sp_component_query(struct mlxfw_dev *mlxfw_dev,
 				    u16 component_index, u32 *p_max_size,
 				    u8 *p_align_bits, u16 *p_max_write_size)
@@ -4914,6 +4918,33 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.get_stats	= mlxsw_sp2_get_stats,
 };
 
+static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
+{
+	return mtu * 5 / 2;
+}
+
+static const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
+	.buffsize_get = mlxsw_sp1_span_buffsize_get,
+};
+
+#define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
+
+static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
+{
+	return 3 * mtu + MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR * speed / 1000;
+}
+
+static const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
+	.buffsize_get = mlxsw_sp2_span_buffsize_get,
+};
+
+u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed)
+{
+	u32 buffsize = mlxsw_sp->span_ops->buffsize_get(speed, mtu);
+
+	return mlxsw_sp_bytes_cells(mlxsw_sp, buffsize) + 1;
+}
+
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
@@ -5135,6 +5166,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->sb_vals = &mlxsw_sp1_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp1_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp1_ptp_ops;
+	mlxsw_sp->span_ops = &mlxsw_sp1_span_ops;
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 
@@ -5160,6 +5192,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
+	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
@@ -5181,6 +5214,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
+	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6477b473cad7..39c3d3ee79a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -140,6 +140,7 @@ struct mlxsw_sp_sb_vals;
 struct mlxsw_sp_port_type_speed_ops;
 struct mlxsw_sp_ptp_state;
 struct mlxsw_sp_ptp_ops;
+struct mlxsw_sp_span_ops;
 
 struct mlxsw_sp_port_mapping {
 	u8 module;
@@ -185,6 +186,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_sb_vals *sb_vals;
 	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
 	const struct mlxsw_sp_ptp_ops *ptp_ops;
+	const struct mlxsw_sp_span_ops *span_ops;
 	const struct mlxsw_listener *listeners;
 	size_t listeners_count;
 };
@@ -502,6 +504,7 @@ int mlxsw_sp_flow_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 				unsigned int *p_counter_index);
 void mlxsw_sp_flow_counter_free(struct mlxsw_sp *mlxsw_sp,
 				unsigned int counter_index);
+u32 mlxsw_sp_span_buffsize_get(struct mlxsw_sp *mlxsw_sp, int mtu, u32 speed);
 bool mlxsw_sp_port_dev_check(const struct net_device *dev);
 struct mlxsw_sp *mlxsw_sp_lower_get(struct net_device *dev);
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 7917c6ea262e..88b8edf14387 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -748,20 +748,22 @@ static bool mlxsw_sp_span_is_egress_mirror(struct mlxsw_sp_port *port)
 	return false;
 }
 
-static int mlxsw_sp_span_mtu_to_buffsize(const struct mlxsw_sp *mlxsw_sp,
-					 int mtu)
-{
-	return mlxsw_sp_bytes_cells(mlxsw_sp, mtu * 5 / 2) + 1;
-}
-
 static int
 mlxsw_sp_span_port_buffsize_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char sbib_pl[MLXSW_REG_SBIB_LEN];
 	u32 buffsize;
+	u32 speed;
+	int err;
+
+	err = mlxsw_sp_port_speed_get(mlxsw_sp_port, &speed);
+	if (err)
+		return err;
+	if (speed == SPEED_UNKNOWN)
+		speed = 0;
 
-	buffsize = mlxsw_sp_span_mtu_to_buffsize(mlxsw_sp, mtu);
+	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, speed, mtu);
 	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
 }
-- 
2.24.1

