Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143CC1180C
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 13:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfEBLNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 07:13:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49565 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbfEBLNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 07:13:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F22762588E;
        Thu,  2 May 2019 07:13:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 02 May 2019 07:13:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=EtmWeyUCZO83MjcL5SMaCfXh5UDf3PK4rLXyrBNdGsg=; b=UQq5Gr1b
        nosecmlhb8myqj1mOWBnSyVZ11iQ0qW7bH+wmMCZgRxMdqsUcXsZx34F+6l86tQE
        TrVjBGf/lYhSynJyTwkZdWbbCGDb8FeKsuWhQ0/czx89Q/yUhfDRz2TGeWChT4r5
        kydV6E9e7HK0GWPFYqOavKYLD3c5JGtjrFCP1ZeDa8Of5sV+UOc300hLBqKR5KzL
        yh/kQX+nrxj+deZh5AusZenUc9ySVIVn509KOToDTLWI7et1R6JRDnCrCt1g7E5e
        PSvtgyxVPKBR4w3eYkBcpBb+Z6mUWSJZfxn7hGVyS2QHtAuhVIGGrq5C4IprBEQh
        TipHcW599xC7SQ==
X-ME-Sender: <xms:79DKXAjJFkkYJoYtxfaNdDc27q4iIPJ1fv2vWLSNvBY-Zh6zARvPug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieelgdeflecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppeduleefrd
    egjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehi
    ughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:79DKXFfH4xmpzZ_cA-qGqMc0NlYXlWpSDBSHHUenAOBWyYbNkoX3MQ>
    <xmx:79DKXP2R7pkc7_SwFm-w7A7jx6d7LZXjsNcAfp3A5S1teBcSk7XxzQ>
    <xmx:79DKXCLRPilXVECHbHHJLp8x861UV3GyeYL0QZhfloMgUoVV4it0AQ>
    <xmx:79DKXJJ-XgzhpNZlLPTCZw8LtozRNoMLil1pbNh0lzFzF9Gh-8AJUA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C730E4544;
        Thu,  2 May 2019 07:13:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/3] mlxsw: spectrum: split base on local_ports_in_{1x, 2x} resources
Date:   Thu,  2 May 2019 14:13:09 +0300
Message-Id: <20190502111309.6590-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502111309.6590-1-idosch@idosch.org>
References: <20190502111309.6590-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

When splitting a port, different local ports need to be mapped on different
systems. For example:

SN3700 (local_ports_in_2x=2):
  * Without split:
      front panel 1   --> local port 1
      front panel 2   --> local port 5
  * Split to 2:
      front panel 1s0 --> local port 1
      front panel 1s1 --> local port 3
      front panel 2   --> local port 5

SN3800 (local_ports_in_2x=1):
  * Without split:
      front panel 1 --> local port 1
      front panel 2 --> local port 3
  * Split to 2:
      front panel 1s0 --> local port 1
      front panel 1s1 --> local port 2
      front panel 2   --> local port 3

The local_ports_in_{1x, 2x} resources provide the offsets from the base
local ports according to which the new local ports can be calculated.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 46 ++++++++++++++-----
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d3c9f8ce945e..a6c6d5ee9ead 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3699,14 +3699,14 @@ static u8 mlxsw_sp_cluster_base_port_get(u8 local_port)
 }
 
 static int mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
-				      u8 module, unsigned int count)
+				      u8 module, unsigned int count, u8 offset)
 {
 	u8 width = MLXSW_PORT_MODULE_MAX_WIDTH / count;
 	int err, i;
 
 	for (i = 0; i < count; i++) {
-		err = mlxsw_sp_port_create(mlxsw_sp, base_port + i, true,
-					   module, width, i * width);
+		err = mlxsw_sp_port_create(mlxsw_sp, base_port + i * offset,
+					   true, module, width, i * width);
 		if (err)
 			goto err_port_create;
 	}
@@ -3715,8 +3715,8 @@ static int mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
 
 err_port_create:
 	for (i--; i >= 0; i--)
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i))
-			mlxsw_sp_port_remove(mlxsw_sp, base_port + i);
+		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
+			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 	return err;
 }
 
@@ -3747,11 +3747,19 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	u8 local_ports_in_1x, local_ports_in_2x, offset;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	u8 module, cur_width, base_port;
 	int i;
 	int err;
 
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_1X) ||
+	    !MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_2X))
+		return -EIO;
+
+	local_ports_in_1x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_1X);
+	local_ports_in_2x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_2X);
+
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
@@ -3777,13 +3785,15 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 
 	/* Make sure we have enough slave (even) ports for the split. */
 	if (count == 2) {
+		offset = local_ports_in_2x;
 		base_port = local_port;
-		if (mlxsw_sp->ports[base_port + 1]) {
+		if (mlxsw_sp->ports[base_port + local_ports_in_2x]) {
 			netdev_err(mlxsw_sp_port->dev, "Invalid split configuration\n");
 			NL_SET_ERR_MSG_MOD(extack, "Invalid split configuration");
 			return -EINVAL;
 		}
 	} else {
+		offset = local_ports_in_1x;
 		base_port = mlxsw_sp_cluster_base_port_get(local_port);
 		if (mlxsw_sp->ports[base_port + 1] ||
 		    mlxsw_sp->ports[base_port + 3]) {
@@ -3794,10 +3804,11 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 	}
 
 	for (i = 0; i < count; i++)
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i))
-			mlxsw_sp_port_remove(mlxsw_sp, base_port + i);
+		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
+			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
-	err = mlxsw_sp_port_split_create(mlxsw_sp, base_port, module, count);
+	err = mlxsw_sp_port_split_create(mlxsw_sp, base_port, module, count,
+					 offset);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create split ports\n");
 		goto err_port_split_create;
@@ -3814,11 +3825,19 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	u8 local_ports_in_1x, local_ports_in_2x, offset;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	u8 cur_width, base_port;
 	unsigned int count;
 	int i;
 
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_1X) ||
+	    !MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_2X))
+		return -EIO;
+
+	local_ports_in_1x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_1X);
+	local_ports_in_2x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_2X);
+
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
@@ -3836,6 +3855,11 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 	cur_width = mlxsw_sp_port->mapping.width;
 	count = cur_width == 1 ? 4 : 2;
 
+	if (count == 2)
+		offset = local_ports_in_2x;
+	else
+		offset = local_ports_in_1x;
+
 	base_port = mlxsw_sp_cluster_base_port_get(local_port);
 
 	/* Determine which ports to remove. */
@@ -3843,8 +3867,8 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 		base_port = base_port + 2;
 
 	for (i = 0; i < count; i++)
-		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i))
-			mlxsw_sp_port_remove(mlxsw_sp, base_port + i);
+		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
+			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
 	mlxsw_sp_port_unsplit_create(mlxsw_sp, base_port, count);
 
-- 
2.20.1

