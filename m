Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4529626D402
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIQG4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:56:31 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48427 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgIQG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:56:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id B5AC97A3;
        Thu, 17 Sep 2020 02:50:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 17 Sep 2020 02:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=lNZomN65RHVfLFwBlWn5rhdasdtS4GX5mz9DGj0+xEo=; b=ZmkyLwHQ
        RWy2BWbJ26JJhX5B/BXShh/yGg1CU9OFAuhd7GvyFTJqCUDCEjF6ynLqEMmBE72/
        JgnLC8XBAeQ9/C0L+Dvm2XEA0apKIRPhhLPFnxHWPMxPQ3geoRZHu9YoC0P8jVBJ
        CyFECyHMKxTXy7B3i6O/JrFv0T2wn67v4IyfZhoCUgayZV1KhjQVs88MCmskslpQ
        8/AWLke0dzMAikoOGx3EQxo2dKmZH1/kaEJnWwGrftAccMAUJj8ftiu4uq/P5Lfe
        IS7wfhGHtlXGDSSZaiMpVvQDFEjFwpA0DHG6vrNlL+gGuMmXJ+O4y0EZGETJZorp
        Fk64Zjip7LjDMQ==
X-ME-Sender: <xms:IQdjX7-2iMWuJujE71vBiS8SNJylIhnbDcKOc5ZTnbT8dawL2InUPQ>
    <xme:IQdjX3uFb1FJ9KIzhbpX691qxJ1a2Ve1bAETsIPmO4GwDT1I5klacx0FZDcV-BeaF
    DulJsjkD5QrxIM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdefgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IQdjX5CvLI1bOQVnzcn2qAvSoRKCj9Ec7suNf62yY13NNEBhFMtNOg>
    <xmx:IQdjX3eMZT-xaE2z5g2mduoGhZmm75EQM1KErI1MGuJVtVfrA25LsA>
    <xmx:IQdjXwN9ZyaPI_H1IoZ6Ob6ccNkn7Ujs_N1WQ_wwy9VDhxCPnX6R8Q>
    <xmx:IQdjX1oIGUQ5tbEFC37jyM3hUXrgH7dl0ZCLhraSXhuCoTOmeV7v0A>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8317F306468A;
        Thu, 17 Sep 2020 02:50:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: spectrum_buffers: Support two headroom modes
Date:   Thu, 17 Sep 2020 09:49:01 +0300
Message-Id: <20200917064903.260700-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917064903.260700-1-idosch@idosch.org>
References: <20200917064903.260700-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

There are two interfaces to configure ETS: qdiscs and DCB. Historically,
DCB ETS configuration was projected to ingress as well, and configured port
buffers. Qdisc was not.

So as not to break clients that today use DCB ETS and PFC and rely on
getting a reasonable ingress buffer priomap, keep the ETS mirroring in
effect.

Since qdiscs have not done this mirroring historically, it is reasonable
not to introduce it, but rather permit manual ingress configuration through
dcbnl_setbuffer only in the qdisc mode.

This will require a toggle to indicate whether buffer sizes should be
autocomputed or taken from dcbnl_setbuffer, and likewise for priomaps.
Introduce such and initialize it, and guard port buffer size configuration
as appropriate. The toggle is currently left in the DCB position. In a
following patch, qdisc code will switch it.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 11 ++++++++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 22 ++++++++++++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 247a6aebd402..f0a4347acd25 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -434,18 +434,29 @@ struct mlxsw_sp_hdroom_prio {
 	u8 buf_idx;
 	/* Value of buf_idx deduced from the DCB ETS configuration. */
 	u8 ets_buf_idx;
+	/* Value of buf_idx taken from the dcbnl_setbuffer configuration. */
+	u8 set_buf_idx;
 	bool lossy;
 };
 
 struct mlxsw_sp_hdroom_buf {
 	u32 thres_cells;
 	u32 size_cells;
+	/* Size requirement form dcbnl_setbuffer. */
+	u32 set_size_cells;
 	bool lossy;
 };
 
+enum mlxsw_sp_hdroom_mode {
+	MLXSW_SP_HDROOM_MODE_DCB,
+	MLXSW_SP_HDROOM_MODE_TC,
+};
+
 #define MLXSW_SP_PB_COUNT 10
 
 struct mlxsw_sp_hdroom {
+	enum mlxsw_sp_hdroom_mode mode;
+
 	struct {
 		struct mlxsw_sp_hdroom_prio prio[IEEE_8021Q_MAX_PRIORITIES];
 	} prios;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 68286cd70c33..37ff29a1686e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -304,8 +304,16 @@ void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom)
 {
 	int prio;
 
-	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
-		hdroom->prios.prio[prio].buf_idx = hdroom->prios.prio[prio].ets_buf_idx;
+	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++) {
+		switch (hdroom->mode) {
+		case MLXSW_SP_HDROOM_MODE_DCB:
+			hdroom->prios.prio[prio].buf_idx = hdroom->prios.prio[prio].ets_buf_idx;
+			break;
+		case MLXSW_SP_HDROOM_MODE_TC:
+			hdroom->prios.prio[prio].buf_idx = hdroom->prios.prio[prio].set_buf_idx;
+			break;
+		}
+	}
 }
 
 void mlxsw_sp_hdroom_bufs_reset_lossiness(struct mlxsw_sp_hdroom *hdroom)
@@ -411,7 +419,14 @@ void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
 		delay_cells = mlxsw_sp_port_headroom_8x_adjust(mlxsw_sp_port, delay_cells);
 
 		buf->thres_cells = thres_cells;
-		buf->size_cells = thres_cells + delay_cells;
+		if (hdroom->mode == MLXSW_SP_HDROOM_MODE_DCB) {
+			buf->size_cells = thres_cells + delay_cells;
+		} else {
+			/* Do not allow going below the minimum size, even if
+			 * the user requested it.
+			 */
+			buf->size_cells = max(buf->set_size_cells, buf->thres_cells);
+		}
 	}
 }
 
@@ -575,6 +590,7 @@ static int mlxsw_sp_port_headroom_init(struct mlxsw_sp_port *mlxsw_sp_port)
 	int prio;
 
 	hdroom.mtu = mlxsw_sp_port->dev->mtu;
+	hdroom.mode = MLXSW_SP_HDROOM_MODE_DCB;
 	for (prio = 0; prio < IEEE_8021QAZ_MAX_TCS; prio++)
 		hdroom.prios.prio[prio].lossy = true;
 
-- 
2.26.2

