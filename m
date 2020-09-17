Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC07F26D403
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgIQG4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:56:35 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:50841 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbgIQG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:56:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3BCB777B;
        Thu, 17 Sep 2020 02:50:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 17 Sep 2020 02:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QiYAGUn33p2izElOMqkqYk5B2f5wa840MMlY46h4VGY=; b=RwnaynU+
        Yth+R1ycr6bMBGHBVcsG4TldaNaEJBs8lmvTppcTk5kzvSiof188EnZMuAWuXnN0
        G1+XOoF09NjKZxtAbqnrvc1bouR7j5CAOCDlvGxvpaJSMNjK5bTlMrFFNtrD+eci
        0rl8B1i3fV301CYp0ytk3DuyfEd5DxFTtKn/l9YhNm1xq3SwGJov1yAzaj778h6p
        pAFoBfYbHKqFGf1OSKfao67q0NLS4xLzXYoSGwWF4Dm2nfGt2HkKHGMKeQoKOc2z
        DGcOiGsxwKxbhBgMTJ7Wc2AZEZJEBIqzUXh5NrrOA9kiCwEjScyM2StsHm/owxBi
        VCktFYB/Zrhfmw==
X-ME-Sender: <xms:JQdjXzbk-2f1PvL4NTvVj0ziCPiTz9zsfA0mb84Ab5JW-USx1oDOKQ>
    <xme:JQdjXybLBhOrtA8z-tSNY5AM2jwE1FbbONGBffUiL5aTYp0mMIDx63xPeWgSuQyLu
    rarL9FlPJo5b1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtdefgdduudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JQdjX1_70GbiiqbsuPKpJJG9snDNITwr6XQe1xGXhcZBSr9pjr2tnA>
    <xmx:JQdjX5rNSetMrJ2rokQq5JgolVcUL03UARcA5i8OPxUAEmtIP4VRog>
    <xmx:JQdjX-qqYM9jYzES9NsCZZinJtf4Q94kzgKI091VPl1mYjedtdsiGw>
    <xmx:JQdjXxVOEOCG5XePHnLsmV1V8TOdKo9qXIr_QFzQL2StrXrqBVaEig>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCAD73064680;
        Thu, 17 Sep 2020 02:50:11 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/3] mlxsw: spectrum_qdisc: Disable port buffer autoresize with qdiscs
Date:   Thu, 17 Sep 2020 09:49:03 +0300
Message-Id: <20200917064903.260700-4-idosch@idosch.org>
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

Keep qdiscs behaving this way, and if an offloaded qdisc is configured on a
port, move this port's headroom to a manual mode, thus allowing
configuration of port buffers through dcbnl_setbuffer.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 34 ++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 964fd444bb10..fd672c6c9133 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -140,18 +140,31 @@ static int
 mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
+	struct mlxsw_sp_qdisc *root_qdisc = &mlxsw_sp_port->qdisc->root_qdisc;
+	int err_hdroom = 0;
 	int err = 0;
 
 	if (!mlxsw_sp_qdisc)
 		return 0;
 
+	if (root_qdisc == mlxsw_sp_qdisc) {
+		struct mlxsw_sp_hdroom hdroom = *mlxsw_sp_port->hdroom;
+
+		hdroom.mode = MLXSW_SP_HDROOM_MODE_DCB;
+		mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
+		mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+		mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
+		err_hdroom = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
+	}
+
 	if (mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->ops->destroy)
 		err = mlxsw_sp_qdisc->ops->destroy(mlxsw_sp_port,
 						   mlxsw_sp_qdisc);
 
 	mlxsw_sp_qdisc->handle = TC_H_UNSPEC;
 	mlxsw_sp_qdisc->ops = NULL;
-	return err;
+
+	return err_hdroom ?: err;
 }
 
 static int
@@ -159,6 +172,8 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 		       struct mlxsw_sp_qdisc_ops *ops, void *params)
 {
+	struct mlxsw_sp_qdisc *root_qdisc = &mlxsw_sp_port->qdisc->root_qdisc;
+	struct mlxsw_sp_hdroom orig_hdroom;
 	int err;
 
 	if (mlxsw_sp_qdisc->ops && mlxsw_sp_qdisc->ops->type != ops->type)
@@ -168,6 +183,21 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 		 * new one.
 		 */
 		mlxsw_sp_qdisc_destroy(mlxsw_sp_port, mlxsw_sp_qdisc);
+
+	orig_hdroom = *mlxsw_sp_port->hdroom;
+	if (root_qdisc == mlxsw_sp_qdisc) {
+		struct mlxsw_sp_hdroom hdroom = orig_hdroom;
+
+		hdroom.mode = MLXSW_SP_HDROOM_MODE_TC;
+		mlxsw_sp_hdroom_prios_reset_buf_idx(&hdroom);
+		mlxsw_sp_hdroom_bufs_reset_lossiness(&hdroom);
+		mlxsw_sp_hdroom_bufs_reset_sizes(mlxsw_sp_port, &hdroom);
+
+		err = mlxsw_sp_hdroom_configure(mlxsw_sp_port, &hdroom);
+		if (err)
+			goto err_hdroom_configure;
+	}
+
 	err = ops->check_params(mlxsw_sp_port, mlxsw_sp_qdisc, params);
 	if (err)
 		goto err_bad_param;
@@ -191,6 +221,8 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 
 err_bad_param:
 err_config:
+	mlxsw_sp_hdroom_configure(mlxsw_sp_port, &orig_hdroom);
+err_hdroom_configure:
 	if (mlxsw_sp_qdisc->handle == handle && ops->unoffload)
 		ops->unoffload(mlxsw_sp_port, mlxsw_sp_qdisc, params);
 
-- 
2.26.2

