Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7865165833
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgBTHIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:37 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36587 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbgBTHIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 731D62108A;
        Thu, 20 Feb 2020 02:08:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3g1163+pM9j3m2WhWq2tV1uy+QzPKysqXSryo7xeq1Y=; b=qEiri9HA
        sQcBiPuaxQDoR2S7w2gVaf5x9wl8aaPlR8xwBsIDHojzMHWBeodE8FPNSVWFmKvU
        5M2h/jXGMpv83V7LVMPDtLSjXPWwxwiEwXu1ITdtCzf3+TnbSf33DEadgSNcK13r
        8GOgWKyYSfDHbdpDx47MZqHzTORoZh0uXLtwDTnVZDgu31W48oAaiKk9S1UuZ91B
        xkDLYhTx3WiAfjjDkrGpY3mA6dSZqHHlIdBy1bVHo+DYm9RK5I0rTB5ELiA5Hok4
        JH1PUfXatu7mWKrvuMRUWv72D08tFj/Zq6ulU62kbDDX8BMmT6gbNeOuhLvzlVdv
        pbqqdAMeHqlL1Q==
X-ME-Sender: <xms:cjBOXh2vKq0QI76L6hmKDEMr-9XgYNdyrLBoOVF-BzqS9tEYNx7Yxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:cjBOXkvp2OWcS_UnImh_Sd2JjT_PSExj3RuOygrTJToPxB8Scdrd3A>
    <xmx:cjBOXoQcOX6LahIDg-gfbBA7xqc39qmlaMSQFkUPexGRbderzta0JQ>
    <xmx:cjBOXotSLa35ZgHxQV5ZWw54S2polQV6qIToc3gDZ_1jKu1bWX44bg>
    <xmx:cjBOXueJMqEB3DBb4qYYK1CMHITVgoA_ZREOfdkMBiLWULTqilByhA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 58D603060C28;
        Thu, 20 Feb 2020 02:08:33 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/15] mlxsw: spectrum_router: Prepare function for router lock introduction
Date:   Thu, 20 Feb 2020 09:07:57 +0200
Message-Id: <20200220070800.364235-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The function de-associates the port-vlan from its router interface
(RIF). It is called both from the netdev notifier block and the inetaddr
notifier block that will soon hold the router lock.

Make sure that router code calls the internal version, as it will
already have the router lock held when the function is called.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e18d54ad6d87..5c4b28a81b07 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -6656,8 +6656,8 @@ mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 	return err;
 }
 
-void
-mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
+static void
+__mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp_port_vlan->mlxsw_sp_port;
 	struct mlxsw_sp_fid *fid = mlxsw_sp_port_vlan->fid;
@@ -6675,6 +6675,12 @@ mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
 	mlxsw_sp_rif_subport_put(rif);
 }
 
+void
+mlxsw_sp_port_vlan_router_leave(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan)
+{
+	__mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port_vlan);
+}
+
 static int mlxsw_sp_inetaddr_port_vlan_event(struct net_device *l3_dev,
 					     struct net_device *port_dev,
 					     unsigned long event, u16 vid,
@@ -6692,7 +6698,7 @@ static int mlxsw_sp_inetaddr_port_vlan_event(struct net_device *l3_dev,
 		return mlxsw_sp_port_vlan_router_join(mlxsw_sp_port_vlan,
 						      l3_dev, extack);
 	case NETDEV_DOWN:
-		mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port_vlan);
+		__mlxsw_sp_port_vlan_router_leave(mlxsw_sp_port_vlan);
 		break;
 	}
 
-- 
2.24.1

