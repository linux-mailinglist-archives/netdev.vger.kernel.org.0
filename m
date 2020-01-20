Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF045142487
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 08:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgATHxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 02:53:49 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45237 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726590AbgATHxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 02:53:48 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E65A218BB;
        Mon, 20 Jan 2020 02:53:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 20 Jan 2020 02:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=dIWe6zldrKCbYyI8SJaPvhGrrDAntn1U3WuMhjEX0to=; b=uJ7D1z+5
        mruDpB1Lu+8lJUrZ06LPf4uZaxfItAkMH4rmXe6tA3INW/hlJcow6QOY1+fVjKeU
        O1kHAIZNxw98JotjezawIR3o69i6x6MsA8SVRFVTYZwr1HCalWoB4cQ+GMvqKhjH
        MCKEc4s8tUCueDCZK3H1ainDXl8iN7ddr9kLG0V32rPkptRBXmZc+jvZGa7PuFU0
        Gr2q6hGzzgeE3XmRHs7r27JI7NGF1Y/ZAvt32OpsWgEO8arRmMYLMCoSxC7XZcrG
        tIMMY2KJ4p3pVl9sKPxfRsaC0S/caLRUtJNnWLkyY4iI4a3hMssOqmpkYzpDRPZM
        FjEBL0Owy4To7g==
X-ME-Sender: <xms:i1wlXpD9XsFzAxxuhcbjw2BrpHO0iyqOWUpwJzXLixDqXpsLrdmmjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeggdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:i1wlXlzJbAO22kWIh7n7N9DoM-rx6lSRd6nPP2Wk56MkcsjaEPU20A>
    <xmx:i1wlXuvn9qFV39lUstcQ-loRmUKJ59T9toUNuyYY93W6yEsdGzP0vg>
    <xmx:i1wlXgI8BDEOGyWZRrITsrelkx3suq398BcD-ps7vOnbaBsZqlBpYw>
    <xmx:i1wlXhnlgqWx_sEro6QuZv4HZjVzhnFwtGAYM1ZUOQQcKbjaPZ5_xA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id F11258005C;
        Mon, 20 Jan 2020 02:53:45 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/4] mlxsw: spectrum_span: Put buffsize update code into helper function
Date:   Mon, 20 Jan 2020 09:52:51 +0200
Message-Id: <20200120075253.3356176-3-idosch@idosch.org>
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

Avoid duplication of code that is doing buffsize update and put it into
a separate helper function.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 37 ++++++++-----------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 200d324e6d99..7917c6ea262e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -754,26 +754,25 @@ static int mlxsw_sp_span_mtu_to_buffsize(const struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_sp_bytes_cells(mlxsw_sp, mtu * 5 / 2) + 1;
 }
 
-int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
+static int
+mlxsw_sp_span_port_buffsize_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 {
-	struct mlxsw_sp *mlxsw_sp = port->mlxsw_sp;
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char sbib_pl[MLXSW_REG_SBIB_LEN];
-	int err;
+	u32 buffsize;
 
+	buffsize = mlxsw_sp_span_mtu_to_buffsize(mlxsw_sp, mtu);
+	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
+}
+
+int mlxsw_sp_span_port_mtu_update(struct mlxsw_sp_port *port, u16 mtu)
+{
 	/* If port is egress mirrored, the shared buffer size should be
 	 * updated according to the mtu value
 	 */
-	if (mlxsw_sp_span_is_egress_mirror(port)) {
-		u32 buffsize = mlxsw_sp_span_mtu_to_buffsize(mlxsw_sp, mtu);
-
-		mlxsw_reg_sbib_pack(sbib_pl, port->local_port, buffsize);
-		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
-		if (err) {
-			netdev_err(port->dev, "Could not update shared buffer for mirroring\n");
-			return err;
-		}
-	}
-
+	if (mlxsw_sp_span_is_egress_mirror(port))
+		return mlxsw_sp_span_port_buffsize_update(port, mtu);
 	return 0;
 }
 
@@ -836,15 +835,9 @@ mlxsw_sp_span_inspected_port_add(struct mlxsw_sp_port *port,
 
 	/* if it is an egress SPAN, bind a shared buffer to it */
 	if (type == MLXSW_SP_SPAN_EGRESS) {
-		u32 buffsize = mlxsw_sp_span_mtu_to_buffsize(mlxsw_sp,
-							     port->dev->mtu);
-
-		mlxsw_reg_sbib_pack(sbib_pl, port->local_port, buffsize);
-		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
-		if (err) {
-			netdev_err(port->dev, "Could not create shared buffer for mirroring\n");
+		err = mlxsw_sp_span_port_buffsize_update(port, port->dev->mtu);
+		if (err)
 			return err;
-		}
 	}
 
 	if (bind) {
-- 
2.24.1

