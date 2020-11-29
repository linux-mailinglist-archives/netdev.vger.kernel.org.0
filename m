Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCE62C792C
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 13:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbgK2M4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 07:56:21 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44567 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387444AbgK2M4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 07:56:20 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C3F475806E8;
        Sun, 29 Nov 2020 07:54:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 29 Nov 2020 07:54:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ESOaBNnNxJNHPiBFMVKbv2S1rT/H+17nOXR1Q+mGQf4=; b=lHZSU6WU
        lJvURKFPuD1rtzoN3qsSgFNb9yqHeWllAbDDw87hmYHO5CLSaPZ2wEy+VIz+SxC7
        SMXuLfVL65/fkcNBAZYlzoMscYo6B8/izcC8I9hE6lYAMNhOAoUgb/mnm5tw0PIp
        bPiPyna9a/f7uEOwsOBeECpCRmQ9HCpsFeidqfv2zU7qYJLlIhOUD+gjroRlyqyh
        RLUIJZ7RPKQmv017Q2YlN4Smuo3GrCgQLXR+VEarAGKq1SFX/dDvL/6/nkepaelg
        y1urEcd+MLwdagxXh+HwwTCG0BPIFW8sEdpqJWRs3L0hpT84t/KVJuOtsb5vYfZ9
        joBF1Vw8n3+SGA==
X-ME-Sender: <xms:IZrDX1OihMZl5AW8yrh-frcPLnVS440Ha4eH-uxy3B-N94BBnaWcvA>
    <xme:IZrDX3_LyZb1QwRCIN6eTKFHKK3NwaCkFWgZs4GUylLgBFC3t6sfXT9jLopJCw4lZ
    k5CPMVp0ORYmrE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IZrDX0QXNDMcUUZETOLPnnYJX9J44wk6zvcSszrTtWqz509fSzY8Lg>
    <xmx:IZrDXxtsqEnFQvXBlSfOGal3crd2R_PuZ8JZ7Ogajly1va5_XLYUKQ>
    <xmx:IZrDX9cN_vz5BWgjbyMtsRlCjzNi-KU0MMnyjUTOXNsMOSWIzJgfmQ>
    <xmx:IZrDX57J7D0myF6ocLitnSEYgaQ5omwbaZDYH-Pd-uB2Hm1F-r6X3A>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id A36203064AAA;
        Sun, 29 Nov 2020 07:54:55 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, nikolay@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, petrm@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 8/9] mlxsw: Add QinQ configuration vetoes
Date:   Sun, 29 Nov 2020 14:54:06 +0200
Message-Id: <20201129125407.1391557-9-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201129125407.1391557-1-idosch@idosch.org>
References: <20201129125407.1391557-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

After adding support for QinQ, a.k.a 802.1ad protocol, there are a few
scenarios that should be vetoed.

The vetoes are motivated by various ASIC limitations.
For example, a port that is member in a 802.1ad bridge cannot have 802.1q
uppers as the port needs to be configured to treat 802.1q packets as
untagged packets.

Veto all those unsupported scenarios and return suitable messages.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 44 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  9 ++++
 .../mellanox/mlxsw/spectrum_switchdev.c       | 24 ++++++++++
 3 files changed, 77 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index fe954e87c5a7..385eb3c3b362 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3893,6 +3893,7 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 	struct net_device *upper_dev;
 	struct mlxsw_sp *mlxsw_sp;
 	int err = 0;
+	u16 proto;
 
 	mlxsw_sp_port = netdev_priv(dev);
 	mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -3950,6 +3951,36 @@ static int mlxsw_sp_netdevice_port_upper_event(struct net_device *lower_dev,
 			NL_SET_ERR_MSG_MOD(extack, "Can not put a VLAN on an OVS port");
 			return -EINVAL;
 		}
+		if (netif_is_bridge_master(upper_dev)) {
+			br_vlan_get_proto(upper_dev, &proto);
+			if (br_vlan_enabled(upper_dev) &&
+			    proto != ETH_P_8021Q && proto != ETH_P_8021AD) {
+				NL_SET_ERR_MSG_MOD(extack, "Enslaving a port to a bridge with unknown VLAN protocol is not supported");
+				return -EOPNOTSUPP;
+			}
+			if (vlan_uses_dev(lower_dev) &&
+			    br_vlan_enabled(upper_dev) &&
+			    proto == ETH_P_8021AD) {
+				NL_SET_ERR_MSG_MOD(extack, "Enslaving a port that already has a VLAN upper to an 802.1ad bridge is not supported");
+				return -EOPNOTSUPP;
+			}
+		}
+		if (netif_is_bridge_port(lower_dev) && is_vlan_dev(upper_dev)) {
+			struct net_device *br_dev = netdev_master_upper_dev_get(lower_dev);
+
+			if (br_vlan_enabled(br_dev)) {
+				br_vlan_get_proto(br_dev, &proto);
+				if (proto == ETH_P_8021AD) {
+					NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are not supported on a port enslaved to an 802.1ad bridge");
+					return -EOPNOTSUPP;
+				}
+			}
+		}
+		if (is_vlan_dev(upper_dev) &&
+		    ntohs(vlan_dev_vlan_proto(upper_dev)) != ETH_P_8021Q) {
+			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are only supported with 802.1q VLAN protocol");
+			return -EOPNOTSUPP;
+		}
 		break;
 	case NETDEV_CHANGEUPPER:
 		upper_dev = info->upper_dev;
@@ -4215,6 +4246,7 @@ static int mlxsw_sp_netdevice_bridge_event(struct net_device *br_dev,
 	struct netdev_notifier_changeupper_info *info = ptr;
 	struct netlink_ext_ack *extack;
 	struct net_device *upper_dev;
+	u16 proto;
 
 	if (!mlxsw_sp)
 		return 0;
@@ -4230,6 +4262,18 @@ static int mlxsw_sp_netdevice_bridge_event(struct net_device *br_dev,
 		}
 		if (!info->linking)
 			break;
+		if (br_vlan_enabled(br_dev)) {
+			br_vlan_get_proto(br_dev, &proto);
+			if (proto == ETH_P_8021AD) {
+				NL_SET_ERR_MSG_MOD(extack, "Uppers are not supported on top of an 802.1ad bridge");
+				return -EOPNOTSUPP;
+			}
+		}
+		if (is_vlan_dev(upper_dev) &&
+		    ntohs(vlan_dev_vlan_proto(upper_dev)) != ETH_P_8021Q) {
+			NL_SET_ERR_MSG_MOD(extack, "VLAN uppers are only supported with 802.1q VLAN protocol");
+			return -EOPNOTSUPP;
+		}
 		if (netif_is_macvlan(upper_dev) &&
 		    !mlxsw_sp_rif_exists(mlxsw_sp, br_dev)) {
 			NL_SET_ERR_MSG_MOD(extack, "macvlan is only supported on top of router interfaces");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 12b5d7fbe1e2..85223647fdb6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7857,6 +7857,15 @@ static int mlxsw_sp_inetaddr_bridge_event(struct mlxsw_sp *mlxsw_sp,
 
 	switch (event) {
 	case NETDEV_UP:
+		if (netif_is_bridge_master(l3_dev) && br_vlan_enabled(l3_dev)) {
+			u16 proto;
+
+			br_vlan_get_proto(l3_dev, &proto);
+			if (proto == ETH_P_8021AD) {
+				NL_SET_ERR_MSG_MOD(extack, "Adding an IP address to 802.1ad bridge is not supported");
+				return -EOPNOTSUPP;
+			}
+		}
 		rif = mlxsw_sp_rif_create(mlxsw_sp, &params, extack);
 		if (IS_ERR(rif))
 			return PTR_ERR(rif);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index d8ee8801331c..9c4e17607e6a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -764,6 +764,25 @@ static int mlxsw_sp_port_attr_br_vlan_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EINVAL;
 }
 
+static int mlxsw_sp_port_attr_br_vlan_proto_set(struct mlxsw_sp_port *mlxsw_sp_port,
+						struct switchdev_trans *trans,
+						struct net_device *orig_dev,
+						u16 vlan_proto)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_bridge_device *bridge_device;
+
+	if (!switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, orig_dev);
+	if (WARN_ON(!bridge_device))
+		return -EINVAL;
+
+	netdev_err(bridge_device->dev, "VLAN protocol can't be changed on existing bridge\n");
+	return -EINVAL;
+}
+
 static int mlxsw_sp_port_attr_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
 					  struct switchdev_trans *trans,
 					  struct net_device *orig_dev,
@@ -933,6 +952,11 @@ static int mlxsw_sp_port_attr_set(struct net_device *dev,
 						     attr->orig_dev,
 						     attr->u.vlan_filtering);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL:
+		err = mlxsw_sp_port_attr_br_vlan_proto_set(mlxsw_sp_port, trans,
+							   attr->orig_dev,
+							   attr->u.vlan_protocol);
+		break;
 	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
 		err = mlxsw_sp_port_attr_mrouter_set(mlxsw_sp_port, trans,
 						     attr->orig_dev,
-- 
2.28.0

