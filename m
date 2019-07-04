Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5775F343
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfGDHJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58737 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfGDHJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A1DF221FE5;
        Thu,  4 Jul 2019 03:09:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=24yD5I5qFmDe0Y7Aeiw6aFHfaCQH65+LrjubVFVbayg=; b=Qi//Y2hN
        Il2OAA8DsSZzyKteU91xNdzsHB2OD29ZG7yLgeb178xjWeway/KHoa9srx3cpm6G
        GKBKUo1YE7w0//V44YcNV8iVrrTKxQwMitaJyznhNA2IQmyPlfYv9oGYqzS34L66
        5S4MFDnhzdKWB1zTtjV0/6+W+x3NdEzNo3hZoJqkcsXAhGqpe9uozQ5bPRuytjRB
        CP54Q/Xu/Mcrey50o1g353vt4wz5QeYP/0q20Nh1YvIZeht6s72+rFmdQEzfy0rg
        mwZBhhUx2dVMQgOFntxNAW9RDXZOWyxX7zsa6sHUHsEktXeBr8/pBy/XK7qk4vgC
        9diJVAYwFTe4yw==
X-ME-Sender: <xms:E6YdXaF0fsC5rdKKaSOVKEw0__xRGam97sZ8W6MNNKmP9h4joNOO9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:E6YdXQqEf38CUT2WWqDSDHMuDLjOiMEObvJ_JVvtnJg6tAY6yE757A>
    <xmx:E6YdXQMs8pvUOdqZe_cxJ2uye5vfRqKjdtwQYOA24PaKkz9LlrjeOg>
    <xmx:E6YdXQpS-AP8B1PcNOQSTvP3ZrXokTqYA6FjKwUsxUJI1064TwFodw>
    <xmx:E6YdXcekcoFj-Fx0mPfjX9HI4NmElQ7fjKgSpu--Lwhjv3gFb5624A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id F261B380083;
        Thu,  4 Jul 2019 03:09:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 6/8] mlxsw: spectrum_ptp: Enable/disable PTP shaper on a port when getting HWTSTAMP on/off
Date:   Thu,  4 Jul 2019 10:07:38 +0300
Message-Id: <20190704070740.302-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190704070740.302-1-idosch@idosch.org>
References: <20190704070740.302-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

In order to get more accurate hardware time stamping, the driver needs to
enable PTP shaper on the port, for speeds lower than 40 Gbps.

Enable the PTP shaper on the port when the user turns on the hardware
time stamping, and disable it when the user turns off the hardware time
stamping.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 08e62cb3d7f2..49aba0ce896b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -952,6 +952,54 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_sp_port *mlxsw_sp_port,
 				       ing_types, egr_types);
 }
 
+static bool mlxsw_sp1_ptp_hwtstamp_enabled(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	return mlxsw_sp_port->ptp.ing_types || mlxsw_sp_port->ptp.egr_types;
+}
+
+static int
+mlxsw_sp1_ptp_port_shaper_set(struct mlxsw_sp_port *mlxsw_sp_port, bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char qeec_pl[MLXSW_REG_QEEC_LEN];
+
+	mlxsw_reg_qeec_ptps_pack(qeec_pl, mlxsw_sp_port->local_port, enable);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qeec), qeec_pl);
+}
+
+static int mlxsw_sp1_ptp_port_shaper_check(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	u32 eth_proto_oper, speed;
+	bool ptps = false;
+	int err, i;
+
+	if (!mlxsw_sp1_ptp_hwtstamp_enabled(mlxsw_sp_port))
+		return mlxsw_sp1_ptp_port_shaper_set(mlxsw_sp_port, false);
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
+
+	speed = port_type_speed_ops->from_ptys_speed(mlxsw_sp, eth_proto_oper);
+	for (i = 0; i < MLXSW_SP1_PTP_SHAPER_PARAMS_LEN; i++) {
+		if (mlxsw_sp1_ptp_shaper_params[i].ethtool_speed == speed) {
+			ptps = true;
+			break;
+		}
+	}
+
+	return mlxsw_sp1_ptp_port_shaper_set(mlxsw_sp_port, ptps);
+}
+
 int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct hwtstamp_config *config)
 {
@@ -973,6 +1021,10 @@ int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	mlxsw_sp_port->ptp.ing_types = ing_types;
 	mlxsw_sp_port->ptp.egr_types = egr_types;
 
+	err = mlxsw_sp1_ptp_port_shaper_check(mlxsw_sp_port);
+	if (err)
+		return err;
+
 	/* Notify the ioctl caller what we are actually timestamping. */
 	config->rx_filter = rx_filter;
 
-- 
2.20.1

