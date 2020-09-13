Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6449F268005
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgIMPrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:47:48 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57183 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgIMPqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:46:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1FACD5C00F0;
        Sun, 13 Sep 2020 11:46:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 11:46:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TCz6EKE1p1k9ofve7HDwe2nVCL+kHgQdk+QzDdtx1vc=; b=QshB4F4z
        hcRfTHBLYEFiwH3ovHThKlIHe/5xxsB16RHYZiofYSw7vgZ8oBHOgskMr072tX8Q
        /Dd3ik60R6lhub2IGxasbRdl83UgfxAIDaC3kWgXmb/7orQtDGO/3396AUCNuilH
        ruwXlwHhPJcQplB9DeY2zSKTj67H5VZ5D66i5a3SWFlKm6rjwtJp/wsaxsQoXi4t
        MtLnYZmmukwt63QW+x0F8njCDBHitQajG+NxoaoqjR7f9dAf5KZ8na6chMEuvCCR
        u2PXiuvKOEy75iXO8y+EWah5EvWEkQ3rZ+ln0Nvpm+IefaDcZyLRw908B43mc6Yp
        5xbxmepufxQOXw==
X-ME-Sender: <xms:6z5eXwO2CE32MzbtC15e4UensjeJUigtIZgVPE6oaLDwBAXNpeiN7g>
    <xme:6z5eX29N9kzmBmWtVu6RZqc7B_uWfH7VN5vW5wtRWSgcMO47_R7wantvlo2V9DO5U
    tTbWdhqsQb7QIM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeigedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6z5eX3QKJarE5RlvNvVTIgqL9Zz6tPweMz1zkdfhvoisqBnziECQwA>
    <xmx:6z5eX4sX_ThjAFAFkHTbrBCGEXf5LciOBYGuZt8U-5Fw3ePfZB1xbA>
    <xmx:6z5eX4esUSH-4-nk0jMj4lKyhhE2r97GJbrF_uSaFOyVnmYofKcirQ>
    <xmx:6z5eXw6OuwjL2gsbP0gYsxi3xD5Btq26veCJQJ4afR8wnEOeXmhmNA>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 621CE328005A;
        Sun, 13 Sep 2020 11:46:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/5] mlxsw: spectrum: Keep maximum speed around
Date:   Sun, 13 Sep 2020 18:46:08 +0300
Message-Id: <20200913154609.14870-5-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200913154609.14870-1-idosch@idosch.org>
References: <20200913154609.14870-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The maximum port speed depends on link modes supported by the port, and for
Ethernet ports is constant. The maximum speed will be handy when setting
SBIB, the internal buffer used for traffic mirroring. Therefore, keep it in
struct mlxsw_sp_port for easy access.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 9 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a68e62256bee..439f3302c4ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1849,6 +1849,14 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_port_speed_by_width_set;
 	}
 
+	err = mlxsw_sp->port_type_speed_ops->ptys_max_speed(mlxsw_sp_port,
+							    &mlxsw_sp_port->max_speed);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to get maximum speed\n",
+			mlxsw_sp_port->local_port);
+		goto err_max_speed_get;
+	}
+
 	err = mlxsw_sp_port_max_mtu_get(mlxsw_sp_port, &mlxsw_sp_port->max_mtu);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to get maximum MTU\n",
@@ -1981,6 +1989,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_port_admin_status_set:
 err_port_mtu_set:
 err_port_max_mtu_get:
+err_max_speed_get:
 err_port_speed_by_width_set:
 err_port_system_port_mapping_set:
 err_dev_addr_init:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 69e59cf7812f..824ca4507c7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -320,6 +320,7 @@ struct mlxsw_sp_port {
 		struct delayed_work speed_update_dw;
 	} span;
 	int max_mtu;
+	u32 max_speed;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
-- 
2.26.2

