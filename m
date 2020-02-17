Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25FE71614B9
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgBQObW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:31:22 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58133 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727898AbgBQObV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:31:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3AC4B21FF3;
        Mon, 17 Feb 2020 09:31:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 Feb 2020 09:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=o4IXwyqR8snP0GYftzIbg3xWjlsrTj3c9ncUm9uVu+8=; b=OrCZTNT4
        xUG/rcyVd45BNHD9W6RAX0WKGO1OwzWcGr++t0eTgqkAAn7nX6lqwvNWt5WYVY8g
        ZTFWttVg2I8W/95hluezdPiD5O9rA/P0jW3+zfmRz71kTxF5RayBpyutA2cQGMXL
        LCXCJB/5w3KTPgplQA4ioODNEHBaxtxREqlf05vtvU4okbBBJsRQHQNUC9LF+nEZ
        xxW4JT9RTs6UfVdljf8WKZsOFgv1OzXtXlORKceNKekR35g0jmtxzIswpNvmuNLF
        9fS+zVadC32TvFaE5qrkEq9HB0GMwkTv0A83d36S6UrIEtfk4tjOahwBiGb4+mZF
        vgLW6L+VJOUcyg==
X-ME-Sender: <xms:uKNKXgxnrdkA56kuc4qH5NSfE9kK9yH25NBXI52Ah9X6h39i22l2IQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsthgvrh
    fuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:uKNKXoidnoGwmtGiTmLKvzWHUjGQz4bRFDyDvzhWrng8OtUjgBUqaw>
    <xmx:uKNKXtUvHJ17JvOGtY2s-C0LNylLP2Cm2FesZqWTqPN_vcB2QGsHkA>
    <xmx:uKNKXi3FVBVXXwqUFy5aD815uT9pwRWY3pAIt4j67b3ligikxS3mdg>
    <xmx:uKNKXjCnyH4-b6aZxQsdK9Qi83UWlBh3jgDeEL_hB3Q1Z6KwqH6G7Q>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C9C33060C28;
        Mon, 17 Feb 2020 09:31:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_switchdev: Have VXLAN device take reference on FID
Date:   Mon, 17 Feb 2020 16:29:33 +0200
Message-Id: <20200217142940.307014-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217142940.307014-1-idosch@idosch.org>
References: <20200217142940.307014-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Up until now only local ports and the router port (which is also a local
port) took a reference on the corresponding FID (Filtering Identifier)
when joining a bridge. For example:

        192.0.2.1/24
            br0
             |
      +------+------+
      |             |
     swp1        vxlan0

In this case the reference count of the FID will be '2'. Since the VXLAN
device does not take a reference on the FID, whenever a local port joins
the bridge it needs to check if a VXLAN device is already enslaved. If
the VXLAN device should be mapped to the FID in question, then the VXLAN
device's VNI is set on the FID.

Beside the fact that this scheme special-cases the VXLAN device, it also
creates an unnecessary dependency between the routing and bridge code:

1. [R] IP address is added on 'br0', which prompts the creation of a RIF
   and a backing FID
2. [B] VNI is enabled on backing FID
3. [R] Host route corresponding to VXLAN device's source address is
   promoted to perform NVE decapsulation

[R] - Routing code
[B] - Bridge code

This back and forth dependency will become problematic when a lock is
added in the routing code instead of relying on RTNL, as it will result
in an AA deadlock.

Instead, have the VXLAN device take a reference on the FID just like all
the other netdev members of the bridge. In order to correctly handle the
case where VXLAN devices are already enslaved to the bridge when it is
offloaded, walk the bridge's slaves and replay the configuration.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 93 +++++++++++++++----
 1 file changed, 74 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 798aefd3e3b6..3ba07233d400 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -153,6 +153,51 @@ static void mlxsw_sp_bridge_device_rifs_destroy(struct mlxsw_sp *mlxsw_sp,
 				      mlxsw_sp);
 }
 
+static int mlxsw_sp_bridge_device_vxlan_init(struct mlxsw_sp_bridge *bridge,
+					     struct net_device *br_dev,
+					     struct netlink_ext_ack *extack)
+{
+	struct net_device *dev, *stop_dev;
+	struct list_head *iter;
+	int err;
+
+	netdev_for_each_lower_dev(br_dev, dev, iter) {
+		if (netif_is_vxlan(dev) && netif_running(dev)) {
+			err = mlxsw_sp_bridge_vxlan_join(bridge->mlxsw_sp,
+							 br_dev, dev, 0,
+							 extack);
+			if (err) {
+				stop_dev = dev;
+				goto err_vxlan_join;
+			}
+		}
+	}
+
+	return 0;
+
+err_vxlan_join:
+	netdev_for_each_lower_dev(br_dev, dev, iter) {
+		if (netif_is_vxlan(dev) && netif_running(dev)) {
+			if (stop_dev == dev)
+				break;
+			mlxsw_sp_bridge_vxlan_leave(bridge->mlxsw_sp, dev);
+		}
+	}
+	return err;
+}
+
+static void mlxsw_sp_bridge_device_vxlan_fini(struct mlxsw_sp_bridge *bridge,
+					      struct net_device *br_dev)
+{
+	struct net_device *dev;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(br_dev, dev, iter) {
+		if (netif_is_vxlan(dev) && netif_running(dev))
+			mlxsw_sp_bridge_vxlan_leave(bridge->mlxsw_sp, dev);
+	}
+}
+
 static struct mlxsw_sp_bridge_device *
 mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 			      struct net_device *br_dev,
@@ -161,6 +206,7 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 	struct device *dev = bridge->mlxsw_sp->bus_info->dev;
 	struct mlxsw_sp_bridge_device *bridge_device;
 	bool vlan_enabled = br_vlan_enabled(br_dev);
+	int err;
 
 	if (vlan_enabled && bridge->vlan_enabled_exists) {
 		dev_err(dev, "Only one VLAN-aware bridge is supported\n");
@@ -186,13 +232,29 @@ mlxsw_sp_bridge_device_create(struct mlxsw_sp_bridge *bridge,
 	INIT_LIST_HEAD(&bridge_device->mids_list);
 	list_add(&bridge_device->list, &bridge->bridges_list);
 
+	/* It is possible we already have VXLAN devices enslaved to the bridge.
+	 * In which case, we need to replay their configuration as if they were
+	 * just now enslaved to the bridge.
+	 */
+	err = mlxsw_sp_bridge_device_vxlan_init(bridge, br_dev, extack);
+	if (err)
+		goto err_vxlan_init;
+
 	return bridge_device;
+
+err_vxlan_init:
+	list_del(&bridge_device->list);
+	if (bridge_device->vlan_enabled)
+		bridge->vlan_enabled_exists = false;
+	kfree(bridge_device);
+	return ERR_PTR(err);
 }
 
 static void
 mlxsw_sp_bridge_device_destroy(struct mlxsw_sp_bridge *bridge,
 			       struct mlxsw_sp_bridge_device *bridge_device)
 {
+	mlxsw_sp_bridge_device_vxlan_fini(bridge, bridge_device->dev);
 	mlxsw_sp_bridge_device_rifs_destroy(bridge->mlxsw_sp,
 					    bridge_device->dev);
 	list_del(&bridge_device->list);
@@ -1994,12 +2056,11 @@ mlxsw_sp_bridge_8021q_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 			return err;
 	}
 
-	/* If no other port is member in the VLAN, then the FID does not exist.
-	 * NVE will be enabled on the FID once a port joins the VLAN
-	 */
-	fid = mlxsw_sp_fid_8021q_lookup(mlxsw_sp, vid);
-	if (!fid)
-		return 0;
+	fid = mlxsw_sp_fid_8021q_get(mlxsw_sp, vid);
+	if (IS_ERR(fid)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to create 802.1Q FID");
+		return PTR_ERR(fid);
+	}
 
 	if (mlxsw_sp_fid_vni_is_set(fid)) {
 		NL_SET_ERR_MSG_MOD(extack, "VNI is already set on FID");
@@ -2011,11 +2072,6 @@ mlxsw_sp_bridge_8021q_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 	if (err)
 		goto err_nve_fid_enable;
 
-	/* The tunnel port does not hold a reference on the FID. Only
-	 * local ports and the router port
-	 */
-	mlxsw_sp_fid_put(fid);
-
 	return 0;
 
 err_nve_fid_enable:
@@ -2188,9 +2244,9 @@ mlxsw_sp_bridge_8021d_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 	struct mlxsw_sp_fid *fid;
 	int err;
 
-	fid = mlxsw_sp_fid_8021d_lookup(mlxsw_sp, bridge_device->dev->ifindex);
-	if (!fid) {
-		NL_SET_ERR_MSG_MOD(extack, "Did not find a corresponding FID");
+	fid = mlxsw_sp_fid_8021d_get(mlxsw_sp, bridge_device->dev->ifindex);
+	if (IS_ERR(fid)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to create 802.1D FID");
 		return -EINVAL;
 	}
 
@@ -2204,11 +2260,6 @@ mlxsw_sp_bridge_8021d_vxlan_join(struct mlxsw_sp_bridge_device *bridge_device,
 	if (err)
 		goto err_nve_fid_enable;
 
-	/* The tunnel port does not hold a reference on the FID. Only
-	 * local ports and the router port
-	 */
-	mlxsw_sp_fid_put(fid);
-
 	return 0;
 
 err_nve_fid_enable:
@@ -2356,6 +2407,10 @@ void mlxsw_sp_bridge_vxlan_leave(struct mlxsw_sp *mlxsw_sp,
 		return;
 
 	mlxsw_sp_nve_fid_disable(mlxsw_sp, fid);
+	/* Drop both the reference we just took during lookup and the reference
+	 * the VXLAN device took.
+	 */
+	mlxsw_sp_fid_put(fid);
 	mlxsw_sp_fid_put(fid);
 }
 
-- 
2.24.1

