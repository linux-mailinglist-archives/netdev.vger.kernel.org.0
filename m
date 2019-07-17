Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE696C219
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 22:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfGQU37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 16:29:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33149 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727184AbfGQU36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 16:29:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C373522305;
        Wed, 17 Jul 2019 16:29:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Jul 2019 16:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=CAelEhhd5g6P0MgATOUM2cnz6Amq6PIMn1NhHdz4DGs=; b=wy/WMJeG
        /p3fx08aMYx1K/A5mWqztjc8v2W+HceJlDFb3waBEeMxmCaLkYePMmiQSRUDr0ao
        D3iv3r63SPpBQW5Gagllpt5AcARDcUD/TBO3QZv6Z6W20Zsr9GNw6GrH9AwwLiNB
        1U9hhz3tHaATqdWuNY+bJpaS6cAPBjDmwDAKXNUBhE8GgwrxBX3ahs9hir614ckH
        /o3oTWkKR2dCfzrUWDmVQM6C+Dqz2JD5NzsQVAWdNq9DwzeaxB2mfZIx37XLVUdw
        KYMibkrDj/A7ynhh0yibQs0nOXYY2eoHxbEFoZfmkrKT2X/tIgoLzqx4ylgGkNFS
        9gdYC4V/bW19Tw==
X-ME-Sender: <xms:Q4UvXYuZxKj6S6eZ8FkFqrNTS8iBPPVdlkvnoIjP-9yJouB0CZiU6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrieefgdduvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejjedrudefkedrvdegledrvddtleenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:Q4UvXRrucHbmUqevABJgRqDvqEcS-VwN53ycC89vhLq_ncx1nMGw6A>
    <xmx:Q4UvXa4jyfSsl4fFxELMImJlizm3WkqV3pNdaaJ6BqahXqjz5qC7sg>
    <xmx:Q4UvXWznpaZWQG28iXnQaqYgfDv3-f6zfbG78VXNZyLD4VLzLwVk3w>
    <xmx:Q4UvXcp4ALc-F0pA6NHPlmbZTWLwzZh3rC8HImLlhzVHn2tiLY684w>
Received: from localhost.localdomain (unknown [77.138.249.209])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E277380083;
        Wed, 17 Jul 2019 16:29:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/2] mlxsw: spectrum_dcb: Configure DSCP map as the last rule is removed
Date:   Wed, 17 Jul 2019 23:29:07 +0300
Message-Id: <20190717202908.1547-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717202908.1547-1-idosch@idosch.org>
References: <20190717202908.1547-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Spectrum systems use DSCP rewrite map to update DSCP field in egressing
packets to correspond to priority that the packet has. Whether rewriting
will take place is determined at the point when the packet ingresses the
switch: if the port is in Trust L3 mode, packet priority is determined from
the DSCP map at the port, and DSCP rewrite will happen. If the port is in
Trust L2 mode, 802.1p is used for packet prioritization, and no DSCP
rewrite will happen.

The driver determines the port trust mode based on whether any DSCP
prioritization rules are in effect at given port. If there are any, trust
level is L3, otherwise it's L2. When the last DSCP rule is removed, the
port is switched to trust L2. Under that scenario, if DSCP of a packet
should be rewritten, it should be rewritten to 0.

However, when switching to Trust L2, the driver neglects to also update the
DSCP rewrite map. The last DSCP rule thus remains in effect, and packets
egressing through this port, if they have the right priority, will have
their DSCP set according to this rule.

Fix by first configuring the rewrite map, and only then switching to trust
L2 and bailing out.

Fixes: b2b1dab6884e ("mlxsw: spectrum: Support ieee_setapp, ieee_delapp")
Signed-off-by: Petr Machata <petrm@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_dcb.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index b25048c6c761..21296fa7f7fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -408,14 +408,6 @@ static int mlxsw_sp_port_dcb_app_update(struct mlxsw_sp_port *mlxsw_sp_port)
 	have_dscp = mlxsw_sp_port_dcb_app_prio_dscp_map(mlxsw_sp_port,
 							&prio_map);
 
-	if (!have_dscp) {
-		err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
-					MLXSW_REG_QPTS_TRUST_STATE_PCP);
-		if (err)
-			netdev_err(mlxsw_sp_port->dev, "Couldn't switch to trust L2\n");
-		return err;
-	}
-
 	mlxsw_sp_port_dcb_app_dscp_prio_map(mlxsw_sp_port, default_prio,
 					    &dscp_map);
 	err = mlxsw_sp_port_dcb_app_update_qpdpm(mlxsw_sp_port,
@@ -432,6 +424,14 @@ static int mlxsw_sp_port_dcb_app_update(struct mlxsw_sp_port *mlxsw_sp_port)
 		return err;
 	}
 
+	if (!have_dscp) {
+		err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
+					MLXSW_REG_QPTS_TRUST_STATE_PCP);
+		if (err)
+			netdev_err(mlxsw_sp_port->dev, "Couldn't switch to trust L2\n");
+		return err;
+	}
+
 	err = mlxsw_sp_port_dcb_toggle_trust(mlxsw_sp_port,
 					     MLXSW_REG_QPTS_TRUST_STATE_DSCP);
 	if (err) {
-- 
2.21.0

