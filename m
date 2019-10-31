Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA44AEACBB
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfJaJnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:43:01 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53229 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727258AbfJaJnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:43:00 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 042CA21321;
        Thu, 31 Oct 2019 05:42:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=JDLPXhmIC01lOy8Dci+7/9Sw6gvShG9ssRX2N+gjGqU=; b=vp/fu06V
        e2rCzkJo8dHMqhQ+n4f+UnidOuFh+0niA51gzPq0B/vHu2vKJKkzU8vWr6zqReig
        YqR/mTO7CVrQmI5sEXpM7faXd9Gqfsz/GrUEK4gcGcl0WsSy5uED3aCT+ZyPH+oo
        eiOmAqiWXEl3KW/I+nglK+znWImlyAiJ6IBt6N7raF0ZFRGP2Vt59Y2LWjhGMRwC
        leY2qo3fxCygmO5sCGq4tKvk1y7ZGTJQSDGjgOyZa4wwapz09hC8yph9GkaiQDh9
        nJ0tIrVjtTMaabyEgFYTexwf7ykV6E8t6eYxZHimcK+OYluE1CqOLDejDYJnsA3y
        8NojYgf/7PQC1A==
X-ME-Sender: <xms:oqy6Xctz4W90hb_YjhsW9Nk_jwCnK5RL85kG1CaSphXrg8xCWcA5bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeej
X-ME-Proxy: <xmx:oqy6XTG8inqwNtaYFhmoYkAUmBWBDutXzhO_N3rdVRp8Fze3zwL2eA>
    <xmx:oqy6XUZU0zAMXaXR7-5-tL2J2K1ZF6RZ06ffOH0veABy_reFlsdKtQ>
    <xmx:oqy6Xf09TCtUWeZHPYDf4kijbAR3ADVI_-5Xk4dnFsAbJxooJ3njOg>
    <xmx:oqy6XcVSN-SmIiL77KjIDHHLlHGi74mqIuAIz15rnN1x-iUM67TJtg>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 220058005A;
        Thu, 31 Oct 2019 05:42:56 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/16] mlxsw: spectrum: Push getting offsets of split ports into a helper
Date:   Thu, 31 Oct 2019 11:42:15 +0200
Message-Id: <20191031094221.17526-11-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Get local port offsets of split port in a separate helper function and
use it in both split and unsplit function.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 58 +++++++++++--------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 938803cd29ca..39ea408deec1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4154,26 +4154,38 @@ static void mlxsw_sp_port_unsplit_create(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static int mlxsw_sp_local_ports_offset(struct mlxsw_core *mlxsw_core,
+				       unsigned int count,
+				       unsigned int max_width)
+{
+	enum mlxsw_res_id local_ports_in_x_res_id;
+	int split_width = max_width / count;
+
+	if (split_width == 1)
+		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_1X;
+	else if (split_width == 2)
+		local_ports_in_x_res_id = MLXSW_RES_ID_LOCAL_PORTS_IN_2X;
+	else
+		return -EINVAL;
+
+	if (!mlxsw_core_res_valid(mlxsw_core, local_ports_in_x_res_id))
+		return -EINVAL;
+	return mlxsw_core_res_get(mlxsw_core, local_ports_in_x_res_id);
+}
+
 static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 			       unsigned int count,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	u8 local_ports_in_1x, local_ports_in_2x, offset;
 	struct mlxsw_sp_port_mapping port_mapping;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	int max_width;
 	u8 base_port;
+	int offset;
 	int i;
 	int err;
 
-	if (!MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_1X) ||
-	    !MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_2X))
-		return -EIO;
-
-	local_ports_in_1x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_1X);
-	local_ports_in_2x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_2X);
-
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
@@ -4210,17 +4222,22 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
+	offset = mlxsw_sp_local_ports_offset(mlxsw_core, count, max_width);
+	if (offset < 0) {
+		netdev_err(mlxsw_sp_port->dev, "Cannot obtain local port offset\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot obtain local port offset");
+		return -EINVAL;
+	}
+
 	/* Make sure we have enough slave (even) ports for the split. */
 	if (count == 2) {
-		offset = local_ports_in_2x;
 		base_port = local_port;
-		if (mlxsw_sp->ports[base_port + local_ports_in_2x]) {
+		if (mlxsw_sp->ports[base_port + offset]) {
 			netdev_err(mlxsw_sp_port->dev, "Invalid split configuration\n");
 			NL_SET_ERR_MSG_MOD(extack, "Invalid split configuration");
 			return -EINVAL;
 		}
 	} else {
-		offset = local_ports_in_1x;
 		base_port = mlxsw_sp_cluster_base_port_get(local_port,
 							   max_width);
 		if (mlxsw_sp->ports[base_port + 1] ||
@@ -4255,20 +4272,13 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 				 struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-	u8 local_ports_in_1x, local_ports_in_2x, offset;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	unsigned int count;
 	int max_width;
 	u8 base_port;
+	int offset;
 	int i;
 
-	if (!MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_1X) ||
-	    !MLXSW_CORE_RES_VALID(mlxsw_core, LOCAL_PORTS_IN_2X))
-		return -EIO;
-
-	local_ports_in_1x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_1X);
-	local_ports_in_2x = MLXSW_CORE_RES_GET(mlxsw_core, LOCAL_PORTS_IN_2X);
-
 	mlxsw_sp_port = mlxsw_sp->ports[local_port];
 	if (!mlxsw_sp_port) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port number \"%d\" does not exist\n",
@@ -4293,10 +4303,12 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u8 local_port,
 
 	count = max_width / mlxsw_sp_port->mapping.width;
 
-	if (count == 2)
-		offset = local_ports_in_2x;
-	else
-		offset = local_ports_in_1x;
+	offset = mlxsw_sp_local_ports_offset(mlxsw_core, count, max_width);
+	if (WARN_ON(offset < 0)) {
+		netdev_err(mlxsw_sp_port->dev, "Cannot obtain local port offset\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot obtain local port offset");
+		return -EINVAL;
+	}
 
 	base_port = mlxsw_sp_cluster_base_port_get(local_port, max_width);
 
-- 
2.21.0

