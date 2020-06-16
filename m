Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9171FA9D1
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgFPHPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:15:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50857 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726052AbgFPHPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:15:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 57AB45C015E;
        Tue, 16 Jun 2020 03:15:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 16 Jun 2020 03:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dLbh+kVi5+blXsWbo
        sWMudymeXDMH1mWpUrTyXEPh2c=; b=OO1A9azAFdLgzZ8XCIQi3n4CPtDDSfDN+
        KlE8Zwk9+SUhlCgtvHE9Y2nqmlz+5IwECQdND1ws2iYHLtr0Yn6ncgYGDr4SjQr+
        hy0GzFEWYSyV4jt4ek6AX1jJRGykakhsAyhfjpTMJ6V8dZMKHokTBppZW0q6ZQB5
        1QRfvTklAEvO6u6tnQlKltDdeEKqDZBc+2OJ3SwjIyaK2/L2njtOztNYQsV4keLy
        5ENUaBe3HkGPHjd8MNONA+p1o2W2CMSuM2ExUYexmG+Gg5iXIYT/1nDbLxYZUiS8
        9IOrlpHHIjUHbTVAoZ20SSYwIUAUhQUJMB0zol5mm9o+JQ1JWqvOg==
X-ME-Sender: <xms:kXHoXmJ_ON31_bXUlXvErtcHEmypSfNDU-UeGRaY3NqFALWPx53KgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeiledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepjeelrddujeelrdeltddrfedvnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:kXHoXuJkzqXrAWRU6K3K6W5y5xK1YhiZl2ysHeZOuzK3FQbpg38BxQ>
    <xmx:kXHoXmtYPPuP2ofNMnAc4NOfUlb7GLqa2G8LPIdcjy_O2nKO6IpKJA>
    <xmx:kXHoXrYzqcGl5faJRC14AU6pFjRNWBM0zmU1TW_5XCN4zmzk8VwmpA>
    <xmx:kXHoXsy_kqz0YV0QOyoA4Vd6Agy5K7ALxRM5Pbmjm8bW5TZaQ5J2Rw>
Received: from splinter.mtl.com (bzq-79-179-90-32.red.bezeqint.net [79.179.90.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF06A30618B7;
        Tue, 16 Jun 2020 03:15:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] mlxsw: spectrum: Adjust headroom buffers for 8x ports
Date:   Tue, 16 Jun 2020 10:14:58 +0300
Message-Id: <20200616071458.192798-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The port's headroom buffers are used to store packets while they
traverse the device's pipeline and also to store packets that are egress
mirrored.

On Spectrum-3, ports with eight lanes use two headroom buffers between
which the configured headroom size is split.

In order to prevent packet loss, multiply the calculated headroom size
by two for 8x ports.

Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h      | 13 +++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c  |  1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c |  1 +
 4 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5ffa32b75e5f..55af877763ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -978,8 +978,10 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 
 		lossy = !(pfc || pause_en);
 		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, mtu);
+		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &thres_cells);
 		delay_cells = mlxsw_sp_pg_buf_delay_get(mlxsw_sp, mtu, delay,
 							pfc, pause_en);
+		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &delay_cells);
 		total_cells = thres_cells + delay_cells;
 
 		taken_headroom_cells += total_cells;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6f96ca50c9ba..6e87457dd635 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -374,6 +374,19 @@ mlxsw_sp_port_vlan_find_by_vid(const struct mlxsw_sp_port *mlxsw_sp_port,
 	return NULL;
 }
 
+static inline void
+mlxsw_sp_port_headroom_8x_adjust(const struct mlxsw_sp_port *mlxsw_sp_port,
+				 u16 *p_size)
+{
+	/* Ports with eight lanes use two headroom buffers between which the
+	 * configured headroom size is split. Therefore, multiply the calculated
+	 * headroom size by two.
+	 */
+	if (mlxsw_sp_port->mapping.width != 8)
+		return;
+	*p_size *= 2;
+}
+
 enum mlxsw_sp_flood_type {
 	MLXSW_SP_FLOOD_TYPE_UC,
 	MLXSW_SP_FLOOD_TYPE_BC,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 21bfb2f6a6f0..f25a8b084b4b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -312,6 +312,7 @@ static int mlxsw_sp_port_pb_init(struct mlxsw_sp_port *mlxsw_sp_port)
 
 		if (i == MLXSW_SP_PB_UNUSED)
 			continue;
+		mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, &size);
 		mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl, i, size);
 	}
 	mlxsw_reg_pbmc_lossy_buffer_pack(pbmc_pl,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 304eb8c3d8bd..f843545d3478 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -782,6 +782,7 @@ mlxsw_sp_span_port_buffer_update(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
 		speed = 0;
 
 	buffsize = mlxsw_sp_span_buffsize_get(mlxsw_sp, speed, mtu);
+	mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, (u16 *) &buffsize);
 	mlxsw_reg_sbib_pack(sbib_pl, mlxsw_sp_port->local_port, buffsize);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbib), sbib_pl);
 }
-- 
2.26.2

