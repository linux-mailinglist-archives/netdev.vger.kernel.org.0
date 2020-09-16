Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E7726BD45
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIPGgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:01 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56397 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbgIPGf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:35:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C75FB5E2;
        Wed, 16 Sep 2020 02:35:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:35:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DHog1YGGvPMuAm29ZiLbm5C2+Fun8b7tu2k+RGLP2+M=; b=ZXZPE1e2
        rmDqIMnl6+m6Be0Znv2ig8WOjS1DzrmY8zZ0KQgXtUjUqCdswGM3KaMOkhL03BIw
        /f1t9SIMazUC2+WyIYmT2EYdFQu+gnaudxUnY3N3vw1JeutFU3r8qZ6xLiTUQzFk
        jERd50WbG//C9L5lcFncFp/YA40xVoOipLdy6ZM4ZX5jnFhG6fVCmqtynp4DUokB
        3zCZ5tLB4qCv8ArZPep2pxPkpcs4j8K+yifAC7BQvVY1UytS/JkzPxaiQDnIWsx2
        QMKqBNsC4MDkqbGNbDy68aaLJ9yVMa25PqF0FtXiE5Wurz2DePxTIiwrJ744gCeL
        LRZdJhW5Haea8Q==
X-ME-Sender: <xms:S7JhX5jlQNnWiHzHGDV84aGSZlzDFH06unDGb-UCT8ZpAVGk0BPE8A>
    <xme:S7JhX-Bt_o4YqTVOpFg-HQeo7E_fyY831tCwseebLawTaHuazjpGna4X2k7xekjhi
    Zkyr8x_rpFCugU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:S7JhX5Fg7PqpgqEEZFaKNkcl0A4Ebn9p7Iu_JfPtHEXWY3VWNsUwZQ>
    <xmx:S7JhX-TP9j25CcQBnzrqMUGMumsaePlPp773WM4YhTmJBpYreedWKg>
    <xmx:S7JhX2wgUbteemeIHl61K_eQ9lhsKvhfm6sQsVq-dq33ZHEO6dFLzA>
    <xmx:S7JhX6-TXRfaoampUhFPLwR0TjY6RI_ZbFgK20WmQbGExhdP-PhZWw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id D5758306467D;
        Wed, 16 Sep 2020 02:35:53 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/15] mlxsw: spectrum: Unify delay handling between PFC and pause
Date:   Wed, 16 Sep 2020 09:35:15 +0300
Message-Id: <20200916063528.116624-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

When a priority is marked as lossless using DCB PFC, or when pause frames
are enabled on a port, mlxsw adds to port buffers an extra space to cover
the traffic that will arrive between the time that a pause or PFC frame is
emitted, and the time traffic actually stops. This is called the delay. The
concept is the same in PFC and pause, however the way the extra buffer
space is calculated differs.

In this patch, unify this handling. Delay is to be measured in bytes of
extra space, and will not include MTU. PFC handler sets the delay directly
from the parameter it gets through the DCB interface.

To convert pause handler, move MLXSW_SP_PAUSE_DELAY to ethtool module,
convert to bytes, and reduce it by maximum MTU, and divide by two. Then it
has the same meaning as the delay_bytes set by the PFC handler.

Keep the delay_bytes value in struct mlxsw_sp_hdroom introduced in the
previous patch. Change PFC and pause handlers to store the new delay value
there and have __mlxsw_sp_port_headroom_set() take it from there.

Instead of mlxsw_sp_pfc_delay_get() and mlxsw_sp_pg_buf_delay_get(),
introduce mlxsw_sp_hdroom_buf_delay_get() to calculate the delay provision.
Drop the unnecessary MLXSW_SP_CELL_FACTOR, and instead add an explanatory
comment describing the formula used.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 69 +++++++++----------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  8 ++-
 .../ethernet/mellanox/mlxsw/spectrum_dcb.c    | 16 ++++-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 19 ++++-
 4 files changed, 67 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ffb0e483d9cd..e436640abd4e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -616,33 +616,6 @@ static u16 mlxsw_sp_pg_buf_threshold_get(const struct mlxsw_sp *mlxsw_sp,
 	return 2 * mlxsw_sp_bytes_cells(mlxsw_sp, mtu);
 }
 
-#define MLXSW_SP_CELL_FACTOR 2	/* 2 * cell_size / (IPG + cell_size + 1) */
-
-static u16 mlxsw_sp_pfc_delay_get(const struct mlxsw_sp *mlxsw_sp, int mtu,
-				  u16 delay)
-{
-	delay = mlxsw_sp_bytes_cells(mlxsw_sp, DIV_ROUND_UP(delay,
-							    BITS_PER_BYTE));
-	return MLXSW_SP_CELL_FACTOR * delay + mlxsw_sp_bytes_cells(mlxsw_sp,
-								   mtu);
-}
-
-/* Maximum delay buffer needed in case of PAUSE frames, in bytes.
- * Assumes 100m cable and maximum MTU.
- */
-#define MLXSW_SP_PAUSE_DELAY 58752
-
-static u16 mlxsw_sp_pg_buf_delay_get(const struct mlxsw_sp *mlxsw_sp, int mtu,
-				     u16 delay, bool pfc, bool pause)
-{
-	if (pfc)
-		return mlxsw_sp_pfc_delay_get(mlxsw_sp, mtu, delay);
-	else if (pause)
-		return mlxsw_sp_bytes_cells(mlxsw_sp, MLXSW_SP_PAUSE_DELAY);
-	else
-		return 0;
-}
-
 static void mlxsw_sp_pg_buf_pack(char *pbmc_pl, int index, u16 size, u16 thres,
 				 bool lossy)
 {
@@ -653,13 +626,30 @@ static void mlxsw_sp_pg_buf_pack(char *pbmc_pl, int index, u16 size, u16 thres,
 						    thres);
 }
 
-int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
-				 u8 *prio_tc, bool pause_en,
-				 struct ieee_pfc *my_pfc)
+static u16 mlxsw_sp_hdroom_buf_delay_get(const struct mlxsw_sp *mlxsw_sp,
+					 const struct mlxsw_sp_hdroom *hdroom, int mtu)
+{
+	u16 delay_cells;
+
+	delay_cells = mlxsw_sp_bytes_cells(mlxsw_sp, hdroom->delay_bytes);
+
+	/* In the worst case scenario the delay will be made up of packets that
+	 * are all of size CELL_SIZE + 1, which means each packet will require
+	 * almost twice its true size when buffered in the switch. We therefore
+	 * multiply this value by the "cell factor", which is close to 2.
+	 *
+	 * Another MTU is added in case the transmitting host already started
+	 * transmitting a maximum length frame when the PFC packet was received.
+	 */
+	return 2 * delay_cells + mlxsw_sp_bytes_cells(mlxsw_sp, mtu);
+}
+
+int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct mlxsw_sp_hdroom *hdroom,
+				 int mtu, u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 pfc_en = !!my_pfc ? my_pfc->pfc_en : 0;
-	u16 delay = !!my_pfc ? my_pfc->delay : 0;
 	char pbmc_pl[MLXSW_REG_PBMC_LEN];
 	u32 taken_headroom_cells = 0;
 	u32 max_headroom_cells;
@@ -694,8 +684,7 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 		lossy = !(pfc || pause_en);
 		thres_cells = mlxsw_sp_pg_buf_threshold_get(mlxsw_sp, mtu);
 		thres_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, thres_cells);
-		delay_cells = mlxsw_sp_pg_buf_delay_get(mlxsw_sp, mtu, delay,
-							pfc, pause_en);
+		delay_cells = mlxsw_sp_hdroom_buf_delay_get(mlxsw_sp, hdroom, mtu);
 		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
 		total_cells = thres_cells + delay_cells;
 
@@ -707,10 +696,16 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 				     thres_cells, lossy);
 	}
 
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
+	if (err)
+		return err;
+
+	*mlxsw_sp_port->hdroom = *hdroom;
+	return 0;
 }
 
 int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct mlxsw_sp_hdroom *hdroom,
 			       int mtu, bool pause_en)
 {
 	u8 def_prio_tc[IEEE_8021QAZ_MAX_TCS] = {0};
@@ -721,7 +716,7 @@ int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	prio_tc = dcb_en ? mlxsw_sp_port->dcb.ets->prio_tc : def_prio_tc;
 	my_pfc = dcb_en ? mlxsw_sp_port->dcb.pfc : NULL;
 
-	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, mtu, prio_tc,
+	return __mlxsw_sp_port_headroom_set(mlxsw_sp_port, hdroom, mtu, prio_tc,
 					    pause_en, my_pfc);
 }
 
@@ -731,7 +726,7 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
 	int err;
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, mtu, pause_en);
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom, mtu, pause_en);
 	if (err)
 		return err;
 	err = mlxsw_sp_port_mtu_set(mlxsw_sp_port, mtu);
@@ -741,7 +736,7 @@ static int mlxsw_sp_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 
 err_port_mtu_set:
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom, dev->mtu, pause_en);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 7441f14101ff..6d69f191a3fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -431,6 +431,7 @@ enum mlxsw_sp_flood_type {
 };
 
 int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       struct mlxsw_sp_hdroom *hdroom,
 			       int mtu, bool pause_en);
 int mlxsw_sp_port_get_stats_raw(struct net_device *dev, int grp,
 				int prio, char *ppcnt_pl);
@@ -439,6 +440,7 @@ int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 /* spectrum_buffers.c */
 struct mlxsw_sp_hdroom {
+	int delay_bytes;
 };
 
 int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp);
@@ -522,9 +524,9 @@ int mlxsw_sp_port_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			  bool dwrr, u8 dwrr_weight);
 int mlxsw_sp_port_prio_tc_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			      u8 switch_prio, u8 tclass);
-int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
-				 u8 *prio_tc, bool pause_en,
-				 struct ieee_pfc *my_pfc);
+int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				 struct mlxsw_sp_hdroom *hdroom,
+				 int mtu, u8 *prio_tc, bool pause_en, struct ieee_pfc *my_pfc);
 int mlxsw_sp_port_ets_maxrate_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  enum mlxsw_reg_qeec_hr hr, u8 index,
 				  u8 next_index, u32 maxrate, u8 burst_size);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
index 0d3fb2e51ea5..65fcd043d96e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c
@@ -121,7 +121,7 @@ static int mlxsw_sp_port_headroom_ets_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	/* Create the required PGs, but don't destroy existing ones, as
 	 * traffic is still directed to them.
 	 */
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu,
+	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, mlxsw_sp_port->hdroom, dev->mtu,
 					   ets->prio_tc, pause_en,
 					   mlxsw_sp_port->dcb.pfc);
 	if (err) {
@@ -605,6 +605,8 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	bool pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
+	struct mlxsw_sp_hdroom orig_hdroom;
+	struct mlxsw_sp_hdroom hdroom;
 	int err;
 
 	if (pause_en && pfc->pfc_en) {
@@ -612,7 +614,15 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu,
+	orig_hdroom = *mlxsw_sp_port->hdroom;
+
+	hdroom = orig_hdroom;
+	if (pfc->pfc_en)
+		hdroom.delay_bytes = DIV_ROUND_UP(pfc->delay, BITS_PER_BYTE);
+	else
+		hdroom.delay_bytes = 0;
+
+	err = __mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, dev->mtu,
 					   mlxsw_sp_port->dcb.ets->prio_tc,
 					   pause_en, pfc);
 	if (err) {
@@ -632,7 +642,7 @@ static int mlxsw_sp_dcbnl_ieee_setpfc(struct net_device *dev,
 	return 0;
 
 err_port_pfc_set:
-	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu,
+	__mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, dev->mtu,
 				     mlxsw_sp_port->dcb.ets->prio_tc, pause_en,
 				     mlxsw_sp_port->dcb.pfc);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 6ee0479b189f..8048a8b82d02 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -192,11 +192,18 @@ static int mlxsw_sp_port_pause_set(struct mlxsw_sp_port *mlxsw_sp_port,
 			       pfcc_pl);
 }
 
+/* Maximum delay buffer needed in case of PAUSE frames. Similar to PFC delay, but is
+ * measured in bytes. Assumes 100m cable and does not take into account MTU.
+ */
+#define MLXSW_SP_PAUSE_DELAY_BYTES 19476
+
 static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 					struct ethtool_pauseparam *pause)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	bool pause_en = pause->tx_pause || pause->rx_pause;
+	struct mlxsw_sp_hdroom orig_hdroom;
+	struct mlxsw_sp_hdroom hdroom;
 	int err;
 
 	if (mlxsw_sp_port->dcb.pfc && mlxsw_sp_port->dcb.pfc->pfc_en) {
@@ -209,7 +216,15 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 		return -EINVAL;
 	}
 
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
+	orig_hdroom = *mlxsw_sp_port->hdroom;
+
+	hdroom = orig_hdroom;
+	if (pause_en)
+		hdroom.delay_bytes = MLXSW_SP_PAUSE_DELAY_BYTES;
+	else
+		hdroom.delay_bytes = 0;
+
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, &hdroom, dev->mtu, pause_en);
 	if (err) {
 		netdev_err(dev, "Failed to configure port's headroom\n");
 		return err;
@@ -228,7 +243,7 @@ static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
 
 err_port_pause_configure:
 	pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, &orig_hdroom, dev->mtu, pause_en);
 	return err;
 }
 
-- 
2.26.2

