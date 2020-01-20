Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3D142486
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgATHxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:53:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49343 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726584AbgATHxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:53:46 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 01CB421ADD;
        Mon, 20 Jan 2020 02:53:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jan 2020 02:53:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=GfpPcmFm+xRr0jhVUQW5w+nFRPAzNss0xCzUTLbxtgU=; b=myBoLmCo
        ug8e1YrDDJw3pDj3Tzgoov/WrQkqkGCBwmYq60QuOI1zm8N74Yg1BL98aR5+XL+O
        xMfb0jPT78fpyUUbYCU04+vno72iBV1GiEa58XqThTLiAwwwCCJZp86xbPQ6ZcMh
        BUtZBFf6fXz2imMTbVPoy2NQw08qdOD0lgpaEmo4dL+upJMxCLv6VPFmSB//iZQV
        KuKuzP/g4+zzOB9OUA+hAGadXB/F+t+4YBB2ArmLWCiW/XZsffZXUtd5y3MAsMdj
        0eONSgq/k19xcJkbUdFcrFV7l44/skOZjdeN6QNac3qF2+BXK93/rU3/57658A54
        yugX6Zgr3PQu4Q==
X-ME-Sender: <xms:iVwlXubO7PZvwLD_DpNUsduTaiPrjJL9lGqGg-TlvJ6G0SWL5PQGLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:iVwlXtKlJi7llI85boHHG9qzlTpsaC_mVBros7Byamku3459zDy_tQ>
    <xmx:iVwlXsh7qOu9GO2OkbtdD9ITiFOhlAuuqT0R_aKFESRICKBufaolVg>
    <xmx:iVwlXsX5eXcvpsxaowrFnppm5iyLPpYwpMe0gERm3f8KmxkA04hLaw>
    <xmx:iVwlXhEum2yS-x04wZegGIyqseK09W_DC3lJIcCy8xn4s7PhzmnP_g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id BF8968005A;
        Mon, 20 Jan 2020 02:53:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/4] mlxsw: spectrum: Push code getting port speed into a helper
Date:   Mon, 20 Jan 2020 09:52:50 +0200
Message-Id: <20200120075253.3356176-2-idosch@idosch.org>
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

Currently PTP code queries directly PTYS register for port speed from
work scheduled upon PUDE event. Since the speed needs to be used for
SPAN buffer size computation as well, push the code into a separate
helper.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 21 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 14 ++-----------
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8639f32ec4d5..1bedf9bc0a57 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3535,6 +3535,27 @@ mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
 }
 
+int mlxsw_sp_port_speed_get(struct mlxsw_sp_port *mlxsw_sp_port, u32 *speed)
+{
+	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	u32 eth_proto_oper;
+	int err;
+
+	port_type_speed_ops = mlxsw_sp->port_type_speed_ops;
+	port_type_speed_ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl,
+					       mlxsw_sp_port->local_port, 0,
+					       false);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	if (err)
+		return err;
+	port_type_speed_ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, NULL, NULL,
+						 &eth_proto_oper);
+	*speed = port_type_speed_ops->from_ptys_speed(mlxsw_sp, eth_proto_oper);
+	return 0;
+}
+
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
 			  bool dwrr, u8 dwrr_weight)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 948ef4720d40..6477b473cad7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -471,6 +471,7 @@ extern struct notifier_block mlxsw_sp_switchdev_notifier;
 /* spectrum.c */
 void mlxsw_sp_rx_listener_no_mark_func(struct sk_buff *skb,
 				       u8 local_port, void *priv);
+int mlxsw_sp_port_speed_get(struct mlxsw_sp_port *mlxsw_sp_port, u32 *speed);
 int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  enum mlxsw_reg_qeec_hr hr, u8 index, u8 next_index,
 			  bool dwrr, u8 dwrr_weight);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 4aaaa4937b1a..34f7c3501b08 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -1016,27 +1016,17 @@ mlxsw_sp1_ptp_port_shaper_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable)
 
 static int mlxsw_sp1_ptp_port_shaper_check(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char ptys_pl[MLXSW_REG_PTYS_LEN];
-	u32 eth_proto_oper, speed;
 	bool ptps = false;
 	int err, i;
+	u32 speed;
 
 	if (!mlxsw_sp1_ptp_hwtstamp_enabled(mlxsw_sp_port))
 		return mlxsw_sp1_ptp_port_shaper_set(mlxsw_sp_port, false);
 
-	port_type_speed_ops = mlxsw_sp->port_type_speed_ops;
-	port_type_speed_ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl,
-					       mlxsw_sp_port->local_port, 0,
-					       false);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	err = mlxsw_sp_port_speed_get(mlxsw_sp_port, &speed);
 	if (err)
 		return err;
-	port_type_speed_ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, NULL, NULL,
-						 &eth_proto_oper);
 
-	speed = port_type_speed_ops->from_ptys_speed(mlxsw_sp, eth_proto_oper);
 	for (i = 0; i < MLXSW_SP1_PTP_SHAPER_PARAMS_LEN; i++) {
 		if (mlxsw_sp1_ptp_shaper_params[i].ethtool_speed == speed) {
 			ptps = true;
-- 
2.24.1

