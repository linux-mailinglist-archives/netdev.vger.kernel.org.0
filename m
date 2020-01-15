Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425B813BEE8
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgAOLyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:54:15 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59877 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730090AbgAOLyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:54:14 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AD42D22056;
        Wed, 15 Jan 2020 06:54:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 15 Jan 2020 06:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4ygeAYpl8IiEHgWr1BP4ICLJNz754hM6AlR/4grek8g=; b=Qh8Q8T1o
        N9Q4bgG3/NF//DEFsoEFtP3kEWVUeHOURRfIY/C2MDBj+ExxWlrW/h7tJPZNi2r2
        NxbZT/xRQYFiY1iL4yWJ5B2ZGrlFzdoiRFCTeWdB5QhZYHNd8+jnjm0dKkaMoVc9
        28JeiLLtmSqIwq/JbFLA6L589YQnI0jVPF5ZTb2kOPZ0NXSlael60fG2o0AfBhh6
        QRBco/ClHiUNVVKKtLDV0NYbZWfsv6aaNj8Cu3AM0ys+7roBOhHP8w4kesjvPIRt
        4iAK22sq1qz32ArVqzGN0Rb8nOP8PmDNlTpQ3Ef7fcPG2S8YGZ6lecxgN9Cd3KIH
        gpKUdS5USqLfvA==
X-ME-Sender: <xms:Zf0eXql1xTXfuxOhE9XPiZb9b9AEuyTzZQWGe6HqbrKio78QRg5k8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrtdefgdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:Zf0eXt9TbWyXaRl-rW5GYNtwpu0gV44YqSqNRnJip75O23sT79FGBQ>
    <xmx:Zf0eXkyDMIUUJy7T9aAryTmMMihdOgF_8F9W02zReYKWF1h3D4pPpA>
    <xmx:Zf0eXjMjXIeY0okYqCVqc1UWT7Zuc5ac6f_Qv2g8yDkuERJZQyhskg>
    <xmx:Zf0eXoB6WoRlf9oQdgbb6g91M-aSZyXQwSDw0z1DPZlxRFbTGduLHw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5D6088005A;
        Wed, 15 Jan 2020 06:54:12 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net v2 1/6] mlxsw: spectrum: Do not enforce same firmware version for multiple ASICs
Date:   Wed, 15 Jan 2020 13:53:44 +0200
Message-Id: <20200115115349.1273610-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115115349.1273610-1-idosch@idosch.org>
References: <20200115115349.1273610-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In commit a72afb6879bb ("mlxsw: Enforce firmware version for
Spectrum-2") I added a required firmware version for Spectrum-2, but
missed the fact that mlxsw_sp2_init() is used by both Spectrum-2 and
Spectrum-3. This means that the same firmware version will be used for
both, which is wrong.

Fix this by creating a new init() callback for Spectrum-3.

Fixes: a72afb6879bb ("mlxsw: Enforce firmware version for Spectrum-2")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Tested-by: Shalom Toledo <shalomt@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f7fd5e8fbf96..5408a964bd10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5132,6 +5132,27 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
 
+static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
+			  const struct mlxsw_bus_info *mlxsw_bus_info,
+			  struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+
+	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
+	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
+	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
+	mlxsw_sp->mr_tcam_ops = &mlxsw_sp2_mr_tcam_ops;
+	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
+	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
+	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
+	mlxsw_sp->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
+	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
+	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
+	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
+
+	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
+}
+
 static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
@@ -5634,7 +5655,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 static struct mlxsw_driver mlxsw_sp3_driver = {
 	.kind				= mlxsw_sp3_driver_name,
 	.priv_size			= sizeof(struct mlxsw_sp),
-	.init				= mlxsw_sp2_init,
+	.init				= mlxsw_sp3_init,
 	.fini				= mlxsw_sp_fini,
 	.basic_trap_groups_set		= mlxsw_sp_basic_trap_groups_set,
 	.port_split			= mlxsw_sp_port_split,
-- 
2.24.1

