Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA68D142489
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgATHxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:53:52 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45965 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbgATHxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:53:50 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CBF0218BB;
        Mon, 20 Jan 2020 02:53:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jan 2020 02:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=URDWYDbQk5/VVFN649YYw04SlKZkStLWmnW31bdrx6c=; b=PeSlrPWP
        R3RF3gS7GBGB/4hNhPy9qUFns9d/Spp9VXkc1eGgk2thw7W455qE1mGQLc4rGgkv
        8Q9WvWFzL8DAJcTOWHIMNB/WT0rX6tIKM2pNslNQoqOC2OiLg4s2XV64FVVnQRz1
        UhTd2LpsftyL2cce2caNH0QN8D/o07qH7SlMDNTV0jPfgmCt4fVZT7CsdcHgO+wV
        m2OLpHIpiBW6UImmqwADH7zPCi6mhf0pA73MNOYy70aJEx158ZA0OAZA7XUdtTFf
        ELLQGCLITrU3S6OAX5K3yqjrteQEuKJU/QiKHqGgjLsXgWaQDm6fKTUvkJzMOACZ
        pBjabuJ4rYgMDA==
X-ME-Sender: <xms:jVwlXmC6VfZOnjmkQQ1AFBiIIo9MMSYV8rciEDoJTj5rvCOaJzgJBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jVwlXs2HHboxjrUkyxxoT2_dLxeKtTMSOXq62G5-u7pz2lc3ati0Rg>
    <xmx:jVwlXsUJkMziiTCp2jUKDL48ieJ0vci-hPSZMnGXlGiMnwySYo0fog>
    <xmx:jVwlXmnGSjJEuD-vyYxy1v28Q3CIgkSaQWJOYxJr2vQcLlyAdRhGCw>
    <xmx:jVwlXmSXmPa_V6S3pJWOe6jUvj9bBM_CHYzqD1ThyUUf9v7LBinNWA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B7EE80061;
        Mon, 20 Jan 2020 02:53:48 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 4/4] spectrum: Add a delayed work to update SPAN buffsize according to speed
Date:   Mon, 20 Jan 2020 09:52:53 +0200
Message-Id: <20200120075253.3356176-5-idosch@idosch.org>
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

When PUDE event is handled and the link is up, update the port SPAN
buffer size according to the current speed.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c   |  4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h   |  3 +++
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c  | 16 ++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h  |  1 +
 4 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f6d2c6f6889f..9eb3ac7669f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3908,6 +3908,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 
 	INIT_DELAYED_WORK(&mlxsw_sp_port->ptp.shaper_dw,
 			  mlxsw_sp->ptp_ops->shaper_work);
+	INIT_DELAYED_WORK(&mlxsw_sp_port->span.speed_update_dw,
+			  mlxsw_sp_span_speed_update_work);
 
 	mlxsw_sp->ports[local_port] = mlxsw_sp_port;
 	err = register_netdev(dev);
@@ -3964,6 +3966,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
+	cancel_delayed_work_sync(&mlxsw_sp_port->span.speed_update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
 	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
@@ -4371,6 +4374,7 @@ static void mlxsw_sp_pude_event_func(const struct mlxsw_reg_info *reg,
 		netdev_info(mlxsw_sp_port->dev, "link up\n");
 		netif_carrier_on(mlxsw_sp_port->dev);
 		mlxsw_core_schedule_dw(&mlxsw_sp_port->ptp.shaper_dw, 0);
+		mlxsw_core_schedule_dw(&mlxsw_sp_port->span.speed_update_dw, 0);
 	} else {
 		netdev_info(mlxsw_sp_port->dev, "link down\n");
 		netif_carrier_off(mlxsw_sp_port->dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 39c3d3ee79a6..5f3b74360dc8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -294,6 +294,9 @@ struct mlxsw_sp_port {
 		struct mlxsw_sp_ptp_port_stats stats;
 	} ptp;
 	u8 split_base_local_port;
+	struct {
+		struct delayed_work speed_update_dw;
+	} span;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 88b8edf14387..0cdd7954a085 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -778,6 +778,22 @@ int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
 	return 0;
 }
 
+void mlxsw_sp_span_speed_update_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct mlxsw_sp_port *mlxsw_sp_port;
+
+	mlxsw_sp_port = container_of(dwork, struct mlxsw_sp_port,
+				     span.speed_update_dw);
+
+	/* If port is egress mirrored, the shared buffer size should be
+	 * updated according to the speed value.
+	 */
+	if (mlxsw_sp_span_is_egress_mirror(mlxsw_sp_port))
+		mlxsw_sp_span_port_buffsize_update(mlxsw_sp_port,
+						   mlxsw_sp_port->dev->mtu);
+}
+
 static struct mlxsw_sp_span_inspected_port *
 mlxsw_sp_span_entry_bound_port_find(struct mlxsw_sp_span_entry *span_entry,
 				    enum mlxsw_sp_span_type type,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 5e04252f2a11..59724335525f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -74,5 +74,6 @@ void mlxsw_sp_span_entry_invalidate(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp_span_entry *span_entry);
 
 int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu);
+void mlxsw_sp_span_speed_update_work(struct work_struct *work);
 
 #endif
-- 
2.24.1

