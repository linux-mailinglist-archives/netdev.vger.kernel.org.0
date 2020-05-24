Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899831E0379
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388515AbgEXVvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:42 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58735 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388506AbgEXVvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C007F5C00A3;
        Sun, 24 May 2020 17:51:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=o/ouKJr6VVTxRl5x10r9eKvTcUbyPcF+NS9eOlgAc08=; b=Fiha7esh
        eCuY5IEZnYEVOwGKgpgF9U6s3IS5TyW3pyz9dR0LhWGaAtsOI727kgJ1NMGyjK8H
        g9Ib7LbpABSpKvjG4JZzGeH6ORvcLdV1uvSR7MleRcm3X75MgTy1EgaxQTb+Nxp0
        E6RYJrnwCsi5F+ufnUzl+rEyloFa5PAiQPfzdNH0FUYgXxVqZLZmcYPuWMu2Vgct
        rItUJVxpXJY1n006rOY4w0tuMeXEpkTiTFRtHIObbvSkpTdIV5Rpdov53QbPfbmr
        gIUeblHi6OwnD9NARs8Y98WPW83GeWXMVNrqCkHp0WDR31ZiLNty7Wft5AAlGMo3
        aQE0JouIlytBxA==
X-ME-Sender: <xms:aezKXlUacTwC2l2anFp2Af4KqwjTZzn91eMZ046F2Q_1FMmtRWeTYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aezKXlmwIp5VzXhHrhonS_0_OqAqfsFQ5qGhGOoG9-25gU0hGtpAhw>
    <xmx:aezKXhZkoTa6A-JRRYhQ6iRh8e1et5T7COMgIJb8JrIqhZQ5MsEeYA>
    <xmx:aezKXoXNzt9l03yPFHVW-6o4NXmJC6m7VCu5PE3LTmv9XANndbGbxQ>
    <xmx:aezKXnsk3rWKfvpodhupYWoFJ2_lAwR1GGwD-oBdK1x8wUxv_XSytA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 797AA306651E;
        Sun, 24 May 2020 17:51:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/11] mlxsw: spectrum: Use dedicated trap group for sampled packets
Date:   Mon, 25 May 2020 00:51:06 +0300
Message-Id: <20200524215107.1315526-11-idosch@idosch.org>
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

The rate with which packets are sampled is determined by user space, so
there is no need to associate such packets with a policer.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 4d61c414348f..9b27a129b0a6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5547,6 +5547,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c4fdfe8fd5a3..d275887bba28 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4103,7 +4103,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			     ROUTER_EXP, false),
 	/* PKT Sample trap */
 	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
-		  false, SP_IP2ME, DISCARD),
+		  false, SP_PKT_SAMPLE, DISCARD),
 	/* ACL trap */
 	MLXSW_SP_RXL_NO_MARK(ACL0, TRAP_TO_CPU, IP2ME, false),
 	/* Multicast Router Traps */
@@ -4252,6 +4252,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			priority = 1;
 			tc = 1;
 			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR:
 			priority = 0;
 			tc = 0;
-- 
2.26.2

