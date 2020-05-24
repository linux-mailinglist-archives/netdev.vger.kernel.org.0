Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFBC1E0376
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388497AbgEXVvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:35 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52755 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387970AbgEXVvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 334645C009F;
        Sun, 24 May 2020 17:51:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Ysjzs6bYQkuBTgbY1Q+EMRX94Kr2Tt7Gg6XIxoFtK9Q=; b=aLNGqXJ8
        Ak7ld8BI48BP1aA7IC+/HGSqfS49L+Ii3RkpwTkvUxBdTXBFCJVkyod7sys5xZBl
        sw5tzpQPiYHgbmUu/iDMiAEG67pj7WlCKJYPKaLZR/eFoJmYXFDPEwhfoP9gRzyf
        AXBSpOqDdxd3pFbXYuuudF0yOxh4bxx+ifs2OYpwcv1EzeTWnhjR36/LdO2kO1Ng
        U6C8kE3BrczOdxTyUoRZ9+pGz81UULxryIvxHKiXB104dVaT/TOxu9YsAOR2RdHh
        JgzC7DOp25Cj2iWbSwGYoNeQ9KUHpziCgHiHeSTEVQxwJY1RoBtnvONuRrN/vHUa
        ingXOcoWOFkLnQ==
X-ME-Sender: <xms:ZOzKXtD8opH8bj3npUy3bSIuqmN5d5bujZv9QCcYuiJype0kpun_BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZOzKXrigPimVTWehY-HFViHZK-V9zfa_xTZX2WX2wCr3eLVyNYhR4Q>
    <xmx:ZOzKXokWEIU2P8cyJgdeXHz3XyEtb098mOg7sa7GDhxdsxGdNmISoA>
    <xmx:ZOzKXnwaSPU2zCVyL9M0JFO7b9PoJ958scjBd_4oIyA8SWdau5PmNQ>
    <xmx:ZOzKXlJ5AVoS7ReOOdfBe7pet8DOizgDo4JPwKl5Gt21OrsTy_iqFQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E13CC306651E;
        Sun, 24 May 2020 17:51:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/11] mlxsw: spectrum: Align TC and trap priority
Date:   Mon, 25 May 2020 00:51:02 +0300
Message-Id: <20200524215107.1315526-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524215107.1315526-1-idosch@idosch.org>
References: <20200524215107.1315526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The traffic class (TC) attribute of packet traps determines through which
TC a packet trap will be scheduled through the CPU port.

The priority attribute determines which trap will be triggered in case
several packet traps match a packet.

We try to configure these attributes to the same value for all packet
traps as there is little reason not to.

Some packet traps did not use the same value, so rectify that now.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c2d6890803da..978f6d98e8c4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4253,7 +4253,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
 			priority = 0;
-			tc = 1;
+			tc = 0;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT:
 			priority = MLXSW_REG_HTGT_DEFAULT_PRIORITY;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 3a13b17cd1b8..1d414d0e5431 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -207,25 +207,25 @@ static const struct mlxsw_sp_trap_group_item mlxsw_sp_trap_group_items_arr[] = {
 		.group = DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 		.priority = 0,
-		.tc = 1,
+		.tc = 0,
 	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(L3_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 		.priority = 0,
-		.tc = 1,
+		.tc = 0,
 	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(TUNNEL_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 		.priority = 0,
-		.tc = 1,
+		.tc = 0,
 	},
 	{
 		.group = DEVLINK_TRAP_GROUP_GENERIC(ACL_DROPS, 1),
 		.hw_group_id = MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
 		.priority = 0,
-		.tc = 1,
+		.tc = 0,
 	},
 };
 
-- 
2.26.2

