Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5A021A0AE
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGINTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:19:53 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:46265 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726932AbgGINTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:19:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 068035804D0;
        Thu,  9 Jul 2020 09:19:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 09 Jul 2020 09:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gUQ7jdMbKaqcB2ReGEgkQhD++7g5es0xzA0gxEbq30M=; b=uooIvIwk
        c5fGkYdJRl1/M85KwGtoTjr905+XgFz+rPjZAzOHKxlfZugfLGgUzfo7E66aCKEb
        j0kT39wW2fblMAYSeeKXX6rWWdFWLFR3u6ts6PDAUj3U7uxVzB8LK+OfykmIoCZe
        QIpwFJQUScPTpwKORgU5E9/L0vYdZ7jliiWoqBnkvvYq43wQw5ojJVYe89kou0iE
        4jb7eC/TxujF4o3sAoxmcGAq2Lvp1z99H5IUeMpcYyWqoIHhl+LIrm7Jdn9Wm8Wj
        riRdMG5LQbzfiHC0Ih8duRj1qt3mWB49iyEinBPx+uUH7ItO/gazM10LsAQ2lEJL
        RRiwcasMm+gY5A==
X-ME-Sender: <xms:XxkHX7XMeNpErBJZ_coZYZx0WDw6awFThGmHVYHF2sdkuHBLM7osOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudelgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XxkHXznjK4JUQr3XWyVvmqheUX7VOMxiwyhQDoWNppBUgCuqXY6_VA>
    <xmx:XxkHX3ZNwbj0T2Imhl01UZEOBvgaqoWV1v4-NjntpakxxQ4OBqgb0g>
    <xmx:XxkHX2VrkVc6pWYj_5BuCAPiKdZJUhCRzFBdqFydTnJugS_53aY3Vw>
    <xmx:YBkHX-eWyUtJ95FBKDWb47xyGaEdBseb9DQVMr-Z-OevgwvH0Nii_g>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1FC33280060;
        Thu,  9 Jul 2020 09:19:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, snelson@pensando.io, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 8/9] devlink: Move input checks from driver to devlink
Date:   Thu,  9 Jul 2020 16:18:21 +0300
Message-Id: <20200709131822.542252-9-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709131822.542252-1-idosch@idosch.org>
References: <20200709131822.542252-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Currently, all the input checks are done in driver.

After adding the split capability to devlink port, move the checks to
devlink.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 17 ++--------------
 .../net/ethernet/netronome/nfp/nfp_devlink.c  |  5 +----
 net/core/devlink.c                            | 20 +++++++++++++++++++
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9cd2dc3afb13..eeeafd1d82ce 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2236,13 +2236,6 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	/* Split ports cannot be split. */
-	if (mlxsw_sp_port->split) {
-		netdev_err(mlxsw_sp_port->dev, "Port cannot be split further\n");
-		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split further");
-		return -EINVAL;
-	}
-
 	max_width = mlxsw_core_module_max_width(mlxsw_core,
 						mlxsw_sp_port->mapping.module);
 	if (max_width < 0) {
@@ -2251,19 +2244,13 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return max_width;
 	}
 
-	/* Split port with non-max and 1 module width cannot be split. */
-	if (mlxsw_sp_port->mapping.width != max_width || max_width == 1) {
+	/* Split port with non-max cannot be split. */
+	if (mlxsw_sp_port->mapping.width != max_width) {
 		netdev_err(mlxsw_sp_port->dev, "Port cannot be split\n");
 		NL_SET_ERR_MSG_MOD(extack, "Port cannot be split");
 		return -EINVAL;
 	}
 
-	if (count == 1 || !is_power_of_2(count) || count > max_width) {
-		netdev_err(mlxsw_sp_port->dev, "Invalid split count\n");
-		NL_SET_ERR_MSG_MOD(extack, "Invalid split count");
-		return -EINVAL;
-	}
-
 	offset = mlxsw_sp_local_ports_offset(mlxsw_core, count, max_width);
 	if (offset < 0) {
 		netdev_err(mlxsw_sp_port->dev, "Cannot obtain local port offset\n");
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index b6a10565309a..be52510d446b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -70,9 +70,6 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 	unsigned int lanes;
 	int ret;
 
-	if (count < 2)
-		return -EINVAL;
-
 	mutex_lock(&pf->lock);
 
 	rtnl_lock();
@@ -81,7 +78,7 @@ nfp_devlink_port_split(struct devlink *devlink, unsigned int port_index,
 	if (ret)
 		goto out;
 
-	if (eth_port.is_split || eth_port.port_lanes % count) {
+	if (eth_port.port_lanes % count) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 94c797b74378..346d385ba09f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -940,6 +940,7 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 					  struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_port *devlink_port;
 	u32 port_index;
 	u32 count;
 
@@ -947,8 +948,27 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 	    !info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT])
 		return -EINVAL;
 
+	devlink_port = devlink_port_get_from_info(devlink, info);
 	port_index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
 	count = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT]);
+
+	if (IS_ERR(devlink_port))
+		return -EINVAL;
+
+	if (!devlink_port->attrs.splittable) {
+		/* Split ports cannot be split. */
+		if (devlink_port->attrs.split)
+			NL_SET_ERR_MSG_MOD(info->extack, "Port cannot be split further");
+		else
+			NL_SET_ERR_MSG_MOD(info->extack, "Port cannot be split");
+		return -EINVAL;
+	}
+
+	if (count < 2 || !is_power_of_2(count) || count > devlink_port->attrs.lanes) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Invalid split count");
+		return -EINVAL;
+	}
+
 	return devlink_port_split(devlink, port_index, count, info->extack);
 }
 
-- 
2.26.2

