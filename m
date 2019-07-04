Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8138B5F344
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfGDHJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:09:11 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60013 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727382AbfGDHJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:09:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3756C21F14;
        Thu,  4 Jul 2019 03:09:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 03:09:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nALZAK8/Z0HsT6Qh2Ptzz+1pB4KdpUYBhCzNl94tb/Q=; b=H+HSFaxq
        hli60W0qEM7nO3ycg51sxdr9UXoHNZ/9Hc9MD5v98l4y8tjnLsCYVwaX3Jc8tzV2
        bGVQyMKxSKjSFrQkkAiLZ0sCI0C/2GLUcc64isem2lHUaYkCAVSRIuilcmMo6UOY
        WKVAThEWr3xxS/0v48Zpi7J8hKMf8LP0P+XQNS5Z2MqT5VcsLwBu4tt5DU9Xkeau
        eBt36KdoiVADpWkzrJkMbf2e/QdOFBOLLrzt7B12QTn70BpW75bk5YipEo9UTMoW
        6LmVjXZ/QkBkGW8pa6Qoh0f4SwgitWfTtjzUxY6OYmllRUZxmWzUuDbKK9X/8JpY
        ooHP1jyCqUMFjw==
X-ME-Sender: <xms:FaYdXambvGjhK00q_EWILECQYN8wC5WO3VUSV2slcljMnpG3EBR17w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedugdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:FaYdXSeN13qafOw_elRHKuxSHPC74rsabsgi38QHp6kEcxQrA3cObA>
    <xmx:FaYdXTzzHT_fk2gRlqTFtvQ3VrJuGGBkzpWpwvvTbu9VPPtSIKWKVw>
    <xmx:FaYdXTKDQyapfN_BpJ2GqwS26l2F4svezeiSJOFJ_q9ALdbmnLIOZg>
    <xmx:FaYdXdx2-QeX1zCMGB4xxoNUc-62hhxeZn9RX3Rg_g83mbizufN40Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8BF53380075;
        Thu,  4 Jul 2019 03:09:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 7/8] mlxsw: spectrum: Set up PTP shaper when port status has changed
Date:   Thu,  4 Jul 2019 10:07:39 +0300
Message-Id: <20190704070740.302-8-idosch@idosch.org>
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

When getting port up down event (PUDE), change the PTP shaper
configuration based on hardware time stamping on/off and the port's
speed.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c  |  8 ++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h  |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_ptp.c  | 17 +++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_ptp.h  | 10 ++++++++++
 4 files changed, 36 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 7cfca2be09fc..ce285fbeebd3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -171,6 +171,7 @@ struct mlxsw_sp_ptp_ops {
 			    struct hwtstamp_config *config);
 	int (*hwtstamp_set)(struct mlxsw_sp_port *mlxsw_sp_port,
 			    struct hwtstamp_config *config);
+	void (*shaper_work)(struct work_struct *work);
 	int (*get_ts_info)(struct mlxsw_sp *mlxsw_sp,
 			   struct ethtool_ts_info *info);
 };
@@ -3716,6 +3717,9 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	}
 	mlxsw_sp_port->default_vlan = mlxsw_sp_port_vlan;
 
+	INIT_DELAYED_WORK(&mlxsw_sp_port->ptp.shaper_dw,
+			  mlxsw_sp->ptp_ops->shaper_work);
+
 	mlxsw_sp->ports[local_port] = mlxsw_sp_port;
 	err = register_netdev(dev);
 	if (err) {
@@ -3770,6 +3774,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
+	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
 	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
@@ -4055,6 +4060,7 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 	if (status == MLXSW_PORT_OPER_STATUS_UP) {
 		netdev_info(mlxsw_sp_port->dev, "link up\n");
 		netif_carrier_on(mlxsw_sp_port->dev);
+		mlxsw_core_schedule_dw(&mlxsw_sp_port->ptp.shaper_dw, 0);
 	} else {
 		netdev_info(mlxsw_sp_port->dev, "link down\n");
 		netif_carrier_off(mlxsw_sp_port->dev);
@@ -4572,6 +4578,7 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp1_ptp_ops = {
 	.transmitted	= mlxsw_sp1_ptp_transmitted,
 	.hwtstamp_get	= mlxsw_sp1_ptp_hwtstamp_get,
 	.hwtstamp_set	= mlxsw_sp1_ptp_hwtstamp_set,
+	.shaper_work	= mlxsw_sp1_ptp_shaper_work,
 	.get_ts_info	= mlxsw_sp1_ptp_get_ts_info,
 };
 
@@ -4584,6 +4591,7 @@ static const struct mlxsw_sp_ptp_ops mlxsw_sp2_ptp_ops = {
 	.transmitted	= mlxsw_sp2_ptp_transmitted,
 	.hwtstamp_get	= mlxsw_sp2_ptp_hwtstamp_get,
 	.hwtstamp_set	= mlxsw_sp2_ptp_hwtstamp_set,
+	.shaper_work	= mlxsw_sp2_ptp_shaper_work,
 	.get_ts_info	= mlxsw_sp2_ptp_get_ts_info,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c21cd1a425c7..abbb563db440 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -267,6 +267,7 @@ struct mlxsw_sp_port {
 	struct mlxsw_sp_acl_block *ing_acl_block;
 	struct mlxsw_sp_acl_block *eg_acl_block;
 	struct {
+		struct delayed_work shaper_dw;
 		struct hwtstamp_config hwtstamp_config;
 		u16 ing_types;
 		u16 egr_types;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 49aba0ce896b..0f7c4bd22a45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -1000,6 +1000,23 @@ static int mlxsw_sp1_ptp_port_shaper_check(struct mlxsw_sp_port *mlxsw_sp_port)
 	return mlxsw_sp1_ptp_port_shaper_set(mlxsw_sp_port, ptps);
 }
 
+void mlxsw_sp1_ptp_shaper_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	int err;
+
+	mlxsw_sp_port = container_of(dwork, struct mlxsw_sp_port,
+				     ptp.shaper_dw);
+
+	if (!mlxsw_sp1_ptp_hwtstamp_enabled(mlxsw_sp_port))
+		return;
+
+	err = mlxsw_sp1_ptp_port_shaper_check(mlxsw_sp_port);
+	if (err)
+		netdev_err(mlxsw_sp_port->dev, "Failed to set up PTP shaper\n");
+}
+
 int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct hwtstamp_config *config)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
index b23abfc0bd76..72e55f6926b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h
@@ -54,6 +54,8 @@ int mlxsw_sp1_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       struct hwtstamp_config *config);
 
+void mlxsw_sp1_ptp_shaper_work(struct work_struct *work);
+
 int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 			      struct ethtool_ts_info *info);
 
@@ -113,6 +115,10 @@ mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+static inline void mlxsw_sp1_ptp_shaper_work(struct work_struct *work)
+{
+}
+
 static inline int mlxsw_sp1_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 					    struct ethtool_ts_info *info)
 {
@@ -167,6 +173,10 @@ mlxsw_sp2_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
+static inline void mlxsw_sp2_ptp_shaper_work(struct work_struct *work)
+{
+}
+
 static inline int mlxsw_sp2_ptp_get_ts_info(struct mlxsw_sp *mlxsw_sp,
 					    struct ethtool_ts_info *info)
 {
-- 
2.20.1

