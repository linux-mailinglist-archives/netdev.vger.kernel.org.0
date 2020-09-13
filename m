Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E90268003
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 17:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgIMPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 11:47:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38177 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbgIMPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 11:46:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2A6545C0109;
        Sun, 13 Sep 2020 11:46:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 13 Sep 2020 11:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=De3B3uFRQmkGzePeQ/yt34uA/Q5d0I4RN6VgvBdSxH8=; b=ts7HjJZa
        /amCpq2UnCbqmDkrhutlj8CcQ800i2omGFAq208GkQWATMXumTtvwiXT9RqNEL2y
        advbjoRw12/zy4fqVSqx1cN0t2tQdWq2qPvefHiY+7o97IWvRrQ7Oz3Y6G5iaAcq
        RFOK8cFUcC4dViT7FGyub/pxpWK92+OwHIf/zkKlfWFf+MDi8v1h1kjKe4g7Tpi9
        W8MQ6ft5jBa18pS/ELXpNZvMl0L0oOEOaMlD5z4fy0b5E09t0L2UMSKbg41LYA1u
        1klWWdzRLcdIGaLQ13YxQJYd12ygT7ZFpi0NqpSLYTrYgR7pPF5lwih3cI2+hD+r
        fxWqmuAV3nwqhQ==
X-ME-Sender: <xms:6T5eXxo0wmiYm42r2Ad1Qh0dHGLDbVWSvzb-CoCYJl1oSY0vF-UWBg>
    <xme:6T5eXzqnbfFuCnUl75Sio68BWpHgtIqEdPMxLO6YK5xGWJtEq_ve8-cc0pns86vJx
    xE8egAtYc-DnLo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeigedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:6T5eX-Onxrz4KJug35VAP8ge2ej1dQPvXcp33E-_llAvzVo-DBhKhg>
    <xmx:6T5eX87Zkr-PlivAi19UY2zTC0slFhEc1OHp4eFNIcqDgrGekKJ9sw>
    <xmx:6T5eXw6VYSvXFSE9D9JguuHLAHnlfoSaQlhEiZNVuWbuiAv0OowBnw>
    <xmx:6T5eX-mt8IhKpTOqefa-dqbSVNyLSrJ1v16PWvz3srJTbrMfSv47VA>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 56691328005A;
        Sun, 13 Sep 2020 11:46:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] mlxsw: spectrum: Keep maximum MTU around
Date:   Sun, 13 Sep 2020 18:46:07 +0300
Message-Id: <20200913154609.14870-4-idosch@idosch.org>
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

The maximum port MTU depends on port type. On Spectrum, mlxsw configures
all ports as Ethernet ports, and the maximum MTU therefore never changes.
Besides checking MTU configuration, maximum MTU will also be handy when
setting SBIB, the internal buffer used for traffic mirroring. Therefore,
keep it in struct mlxsw_sp_port for easy access.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 25 +++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4186e29119c2..a68e62256bee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -590,21 +590,28 @@ static int mlxsw_sp_port_dev_addr_init(struct mlxsw_sp_port *mlxsw_sp_port)
 	return mlxsw_sp_port_dev_addr_set(mlxsw_sp_port, addr);
 }
 
-static int mlxsw_sp_port_mtu_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
+static int mlxsw_sp_port_max_mtu_get(struct mlxsw_sp_port *mlxsw_sp_port, int *p_max_mtu)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char pmtu_pl[MLXSW_REG_PMTU_LEN];
-	int max_mtu;
 	int err;
 
-	mtu += MLXSW_TXHDR_LEN + ETH_HLEN;
 	mlxsw_reg_pmtu_pack(pmtu_pl, mlxsw_sp_port->local_port, 0);
 	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pmtu), pmtu_pl);
 	if (err)
 		return err;
-	max_mtu = mlxsw_reg_pmtu_max_mtu_get(pmtu_pl);
 
-	if (mtu > max_mtu)
+	*p_max_mtu = mlxsw_reg_pmtu_max_mtu_get(pmtu_pl);
+	return 0;
+}
+
+static int mlxsw_sp_port_mtu_set(struct mlxsw_sp_port *mlxsw_sp_port, u16 mtu)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char pmtu_pl[MLXSW_REG_PMTU_LEN];
+
+	mtu += MLXSW_TXHDR_LEN + ETH_HLEN;
+	if (mtu > mlxsw_sp_port->max_mtu)
 		return -EINVAL;
 
 	mlxsw_reg_pmtu_pack(pmtu_pl, mlxsw_sp_port->local_port, mtu);
@@ -1842,6 +1849,13 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 		goto err_port_speed_by_width_set;
 	}
 
+	err = mlxsw_sp_port_max_mtu_get(mlxsw_sp_port, &mlxsw_sp_port->max_mtu);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to get maximum MTU\n",
+			mlxsw_sp_port->local_port);
+		goto err_port_max_mtu_get;
+	}
+
 	err = mlxsw_sp_port_mtu_set(mlxsw_sp_port, ETH_DATA_LEN);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Failed to set MTU\n",
@@ -1966,6 +1980,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 err_port_buffers_init:
 err_port_admin_status_set:
 err_port_mtu_set:
+err_port_max_mtu_get:
 err_port_speed_by_width_set:
 err_port_system_port_mapping_set:
 err_dev_addr_init:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 007e97e99ec8..69e59cf7812f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -319,6 +319,7 @@ struct mlxsw_sp_port {
 	struct {
 		struct delayed_work speed_update_dw;
 	} span;
+	int max_mtu;
 };
 
 struct mlxsw_sp_port_type_speed_ops {
-- 
2.26.2

