Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1732029A2
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgFUIaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:30:12 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53455 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729502AbgFUIaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:30:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DEC845C00DB;
        Sun, 21 Jun 2020 04:30:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OK4qkwUhMVHcRBgoN
        GhHCsrcgDv/zj1MK9VVieX8crs=; b=fbCwEckJYw0ICB/9jw628txiQvrk4n9mK
        GoC16sr0Bwcsb4hKKXQflCPUNKDDGxgIyyKB1lJnojBQF1mB6vv+eWmrTE/6SIzw
        Ivz22KTohSXn0Md6afzl38X8LVyhIxGnLxRAKCWdNGPNqYwyniBbaFwCZcnggcig
        EbQFH1uwQcxRQ6qSIY4oZFcCGRqSlqlMD4qSus+NJgANeenWqpTkFJVeWHyKldUe
        ETYDRHiQEOyd5kjtyZGivcEjgRPJWt22wH+ASYyoUEAya5uslwbJ5wj2BRLTcfAf
        5k0IwgP33CMA5cQnBD23p0sIjtswOQ8B2j3DlfGedRBSRxX042ULA==
X-ME-Sender: <xms:jxrvXr58UjlAxY9lssCD9i72IydyilVlNFnHiH3UlrB0JCSS5vFxyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppedutdelrdeijedrkedruddvleenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:jxrvXg7tT4_tq8a-FajbG1w4-BhiQpc5ao0d2uKQ4AHLv4iIzFliDw>
    <xmx:jxrvXifbSnjCpN28dc63BKGKQfWLbviwK6zVn1CxIrOwCH5iErIW8Q>
    <xmx:jxrvXsLFm5dI0eHVzcM84wgmAHE8WZfI4QDuuoWJYumZSYIwtJuj4A>
    <xmx:kBrvXmUdfBeRVZPsgjK2AEOEE41BKuCPM4dt8Z7ETzzegXYqQohjkA>
Received: from splinter.mtl.com (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D8CB3280065;
        Sun, 21 Jun 2020 04:30:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        colin.king@canonical.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum: Do not rely on machine endianness
Date:   Sun, 21 Jun 2020 11:29:17 +0300
Message-Id: <20200621082917.475558-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The second commit cited below performed a cast of 'u32 buffsize' to
'(u16 *)' when calling mlxsw_sp_port_headroom_8x_adjust():

mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);

Colin noted that this will behave differently on big endian
architectures compared to little endian architectures.

Fix this by following Colin's suggestion and have the function accept
and return 'u32' instead of passing the current size by reference.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Fixes: 60833d54d56c ("mlxsw: spectrum: Adjust headroom buffers for 8x ports")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Suggested-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c         | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         | 8 +++-----
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c    | 2 +-
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 55af877763ed..029ea344ad65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -978,10 +978,10 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 
 		lossy = !(pfc || pause_en);
 		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, mtu);
-		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &thres_cells);
+		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
 		delay_cells = mlxsw_sp_pg_buf_delay_get(mlxsw_sp, mtu, delay,
 							pfc, pause_en);
-		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &delay_cells);
+		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
 		total_cells = thres_cells + delay_cells;
 
 		taken_headroom_cells += total_cells;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6e87457dd635..3abe3e7d89bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -374,17 +374,15 @@ mlxsw_sp_port_vlan_find_by_vid(const struct mlxsw_sp_port *mlxsw_sp_port,
 	return NULL;
 }
 
-static inline void
+static inline u32
 mlxsw_sp_port_headroom_8x_adjust(const struct mlxsw_sp_port *mlxsw_sp_port,
-				 u16 *p_size)
+				 u32 size_cells)
 {
 	/* Ports with eight lanes use two headroom buffers between which the
 	 * configured headroom size is split. Therefore, multiply the calculated
 	 * headroom size by two.
 	 */
-	if (mlxsw_sp_port->mapping.width != 8)
-		return;
-	*p_size *= 2;
+	return mlxsw_sp_port->mapping.width == 8 ? 2 * size_cells : size_cells;
 }
 
 enum mlxsw_sp_flood_type {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index f25a8b084b4b..6f84557a5a6f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -312,7 +312,7 @@ static int mlxsw_sp_port_pb_init(struct mlxsw_sp_port *mlxsw_sp_port)
 
 		if (i == MLXSW_SP_PB_UNUSED)
 			continue;
-		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &size);
+		size = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, size);
 		mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, i, size);
 	}
 	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index f843545d3478..92351a79addc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -782,7 +782,7 @@ mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 		speed = 0;
 
 	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, speed, mtu);
-	mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);
+	buffsize = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, buffsize);
 	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
 }
-- 
2.26.2

