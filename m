Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E1E1E1811
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388808AbgEYXGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55441 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388754AbgEYXGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 42F605C0114;
        Mon, 25 May 2020 19:06:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=vrkC8SFbFBkrC6u9GtEAK7BFodIoltk9nnpRoX9sN0I=; b=S2TdjzQm
        iC04I7YXjQLsn5jLN7Jc2+YNH8RD/agvCwTNcYBevtn1Y72CfGrat9ICodDyjwCI
        4TVikGh9uXgUVh8M12u5zjyYF/kqA7sTfCobMkuMsRbno375Hg/sGsSnU0LOPCwl
        asyx56X02wD++o94gmu3uKMYCGBpzWgQaTqQNy+t/f2OoIeOPILgTM2QOiJTULR0
        DXU/qi/naqvbGsZG2VUr/EwtGT5vaF8dNiCV/6QVOZqk4t5Mlv6eyRaZ7i4ngOIZ
        wGxDRRAD2xqYNn+9vp+m3EyRIfVvv2+tcyMViWqMIH0C7+wJIw0QNXnYs10D68N+
        i9paCdiB6rA7rA==
X-ME-Sender: <xms:bk_MXt4cLM4aYAaM4o_Bt7oCWJE0_rdHfbGpGe_f96OOb2f4513P2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bk_MXq7aVdNnvUwBYEcA-GBWK4OB7EC80GPD1IaDrPgjLVMUKjMgoA>
    <xmx:bk_MXkfIzpEvHEPPHW76a8_gg4_hESWWTVD9jhILKNbQEekBibwHNg>
    <xmx:bk_MXmJ8UlWwWbQFOcrP3xI53520s6hDmTw61A4tdj5TPSuAJuEQew>
    <xmx:bk_MXvjxYy6QMWcmDc2iZ9oGF3DoSJnGpoHrWiPaaDx7NnimGb9b3w>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F275A328005E;
        Mon, 25 May 2020 19:06:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/14] mlxsw: spectrum: Use separate trap group for FID miss
Date:   Tue, 26 May 2020 02:05:47 +0300
Message-Id: <20200525230556.1455927-6-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

When a packet enters the device it is classified to a filtering
identifier (FID) based on the ingress port and VLAN. The FID miss trap
is used to trap packets for which a FID could not be found.

In mlxsw this trap should only be triggered when a port is enslaved to
an OVS bridge and a matching ACL rule could not be found, so as to
trigger learning.

These packets are therefore completely unrelated to packets hitting
local routes and should be in a different group. Move them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6df7cc8a69f1..b55a833a5d17 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5549,6 +5549,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 141a605582c6..ac71d67457aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4052,7 +4052,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_NO_MARK(IGMP_V3_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
 	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, NEIGH_DISCOVERY, false),
-	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, IP2ME, false),
+	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, FID_MISS, false),
 	MLXSW_SP_RXL_MARK(IPV6_MLDV12_LISTENER_QUERY, MIRROR_TO_CPU,
 			  MC_SNOOPING, false),
 	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_REPORT, TRAP_TO_CPU,
@@ -4169,6 +4169,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS:
 			rate = 1024;
 			burst_size = 7;
 			break;
@@ -4248,6 +4249,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_ROUTER_EXP:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS:
 			priority = 1;
 			tc = 1;
 			break;
-- 
2.26.2

