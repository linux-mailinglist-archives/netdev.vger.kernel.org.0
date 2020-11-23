Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5A2C007F
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgKWHOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:09 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37359 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 74745F51;
        Mon, 23 Nov 2020 02:14:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=OdsxC5vWQ+DGyAIgqM13yQHdPZR88Ui5ek2qEXxzPQ4=; b=Zp6j5xPy
        +Mct7ZoHtqe7wLM3uJwpUfRKJuYPyS4PWknRS1bWtkOV0PpjAvqvy8quIYyqNaVF
        Fn9xSUWo1fZkdvOh/iYN/7x15UE4eC8UYC6+ujTbmuvDtE3QG95nG4ZgDMDOGeeC
        XL8ZghFB8UxtYuays9CoDMeTrV436dDGSlT7fSPA6oWdgF+xihztbG+l6B7oYmbk
        aXKhUd/eWzHZ7nbPFclTS05fSPQ8Xt78xfR1llYUyuuXAf54BngTQjmyVV8+hzNA
        z+kHv9gaeSwauL1tR7hnVgk3f9xI7ciGiKKSbdbE0UJ1Jm1KJ4ohIzBdBpQQ1gS8
        OwdXfJMNLNA5rQ==
X-ME-Sender: <xms:PmG7X0-NhjqUM2IZ8PM0v-7m03DF_2rC_xIf5ws_4OZKraFWHojbxA>
    <xme:PmG7X8tACd16kdgXNZ56VG7SJs3VG7CpvzFdJPATCKZM6iHx8ZE95_syLfpu6kwoG
    zX2SJiixvpmeOc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:P2G7X6BQqyn1GbZbsXuj-stYFgow2kpia4F7T85KAjGTBVr4GTihcA>
    <xmx:P2G7X0eAxACERr-fqfr2Os_O-clEPfvp_sL4ppnWkgt6xi7mrwBAQg>
    <xmx:P2G7X5Msou4gp-dEmlcgHivtpBBTnRK8n0INYYFEwDGsh2mCzJ3DEw>
    <xmx:P2G7X6riNl5KX1kp0ElcBYhKbmClOwDfBFf-RM4D06s7-RK1VWNn4Q>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF398328005E;
        Mon, 23 Nov 2020 02:14:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_router: Create loopback RIF during initialization
Date:   Mon, 23 Nov 2020 09:12:21 +0200
Message-Id: <20201123071230.676469-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Up until now RIFs (router interfaces) were created on demand (e.g.,
when an IP address was added to a netdev). However, sometimes the device
needs to be provided with a RIF when one might not be available.

For example, adjacency entries that drop packets need to be programmed
with an egress RIF despite the RIF not being used to forward packets.

Create such a RIF during initialization so that it could be used later
on to support blackhole nexthops.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 31 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 42a7bec3fd88..c61751e67750 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8918,6 +8918,30 @@ static void mlxsw_sp_router_ll_op_ctx_fini(struct mlxsw_sp_router *router)
 	kfree(router->ll_op_ctx);
 }
 
+static int mlxsw_sp_lb_rif_init(struct mlxsw_sp *mlxsw_sp)
+{
+	u16 lb_rif_index;
+	int err;
+
+	/* Create a generic loopback RIF associated with the main table
+	 * (default VRF). Any table can be used, but the main table exists
+	 * anyway, so we do not waste resources.
+	 */
+	err = mlxsw_sp_router_ul_rif_get(mlxsw_sp, RT_TABLE_MAIN,
+					 &lb_rif_index);
+	if (err)
+		return err;
+
+	mlxsw_sp->router->lb_rif_index = lb_rif_index;
+
+	return 0;
+}
+
+static void mlxsw_sp_lb_rif_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp_router_ul_rif_put(mlxsw_sp, mlxsw_sp->router->lb_rif_index);
+}
+
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack)
 {
@@ -8974,6 +8998,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_vrs_init;
 
+	err = mlxsw_sp_lb_rif_init(mlxsw_sp);
+	if (err)
+		goto err_lb_rif_init;
+
 	err = mlxsw_sp_neigh_init(mlxsw_sp);
 	if (err)
 		goto err_neigh_init;
@@ -9039,6 +9067,8 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 err_neigh_init:
+	mlxsw_sp_lb_rif_fini(mlxsw_sp);
+err_lb_rif_init:
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 err_vrs_init:
 	mlxsw_sp_mr_fini(mlxsw_sp);
@@ -9074,6 +9104,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_core_flush_owq();
 	WARN_ON(!list_empty(&mlxsw_sp->router->fib_event_queue));
 	mlxsw_sp_neigh_fini(mlxsw_sp);
+	mlxsw_sp_lb_rif_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
 	mlxsw_sp_lpm_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 023f70827db0..f9a59d454e28 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -75,6 +75,7 @@ struct mlxsw_sp_router {
 	/* One set of ops for each protocol: IPv4 and IPv6 */
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 	struct mlxsw_sp_fib_entry_op_ctx *ll_op_ctx;
+	u16 lb_rif_index;
 };
 
 struct mlxsw_sp_fib_entry_priv {
-- 
2.28.0

