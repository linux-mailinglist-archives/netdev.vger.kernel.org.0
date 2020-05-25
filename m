Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F541E180E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388586AbgEYXGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:19 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38943 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388337AbgEYXGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AA4505C017E;
        Mon, 25 May 2020 19:06:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ut+bHBrvIGLjEGEbemBTIZQLa1gU06728HqvtkncA0Y=; b=yTRDzt3p
        j5hTrMWu3JRydmN7RWbkI7/xegOcZ0IfADyeSPOqdTforpzRm4mEWk63oeQLFB23
        ExOVw6Gn8RQrDvPm6E5989n1WsaJo1xJFLAXt822UczW50P1WnMdiPp5hPMLFvnZ
        bMWfJJP1kr3NynJO3A1oYQe75rg/vkdsElc151U7LBjGxpdpy7XqjVlo61j9C5e6
        Yu9s99t69nBruqkBVvvpi9YPs9ZOB66mnmLGkRPNqsh16ImvQJ4KhzFiqjSY1KQA
        3PMlhT/nLhP1ArkyGsILHGj42h0T9BBA3Ovh3P6vT9yDU7766qCaYCVHrcwXVsj6
        E9RojPtYCXpK3Q==
X-ME-Sender: <xms:aE_MXvKxxw5DRhDxI5vHKDMUUjqDCyNgcVZG3fzEqWjwciq6qbb_aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aE_MXjJM9ONkrL4Ro7j6KqwxtaCVorxRmHjTGsKqG48LiosjK74S4A>
    <xmx:aE_MXnu18RwA41msEpbzSAsYQZDlbSeCHpw-melJmJA0m0QoMpeAgg>
    <xmx:aE_MXoYzPrjRCjphMnG8flr-rJfZ6JWzDemMIHJXteXesi_X9bwpFA>
    <xmx:aE_MXpzpuSmkfyRfqJx-XKlF5Jp6b90He_SBKAuPE9-VkOlKx1mJEQ>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74B163280064;
        Mon, 25 May 2020 19:06:15 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/14] mlxsw: spectrum: Use dedicated trap group for ACL trap
Date:   Tue, 26 May 2020 02:05:43 +0300
Message-Id: <20200525230556.1455927-2-idosch@idosch.org>
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

Packets that are trapped via tc's trap action are currently subject to
the same policer as packets hitting local routes. The latter are
critical to the correct functioning of the control plane, while the
former are mainly used for traffic inspection.

Split the ACL trap to a separate group with its own policer. Use a
higher priority for these traps than for traps using mirror action
(e.g., ARP, IGMP). Otherwise, packets matching both traps will not be
forwarded in hardware (because of trap action) and also not forwarded in
software because they will be marked with 'offload_fwd_mark'.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 9b27a129b0a6..5b5b96a82a34 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5548,6 +5548,7 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP1,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_VRRP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
+	MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
 
 	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 943a24975799..e0811a7e13b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4105,7 +4105,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_RXL(mlxsw_sp_rx_listener_sample_func, PKT_SAMPLE, MIRROR_TO_CPU,
 		  false, SP_PKT_SAMPLE, DISCARD),
 	/* ACL trap */
-	MLXSW_SP_RXL_NO_MARK(ACL0, TRAP_TO_CPU, IP2ME, false),
+	MLXSW_SP_RXL_NO_MARK(ACL0, TRAP_TO_CPU, FLOW_LOGGING, false),
 	/* Multicast Router Traps */
 	MLXSW_SP_RXL_MARK(IPV4_PIM, TRAP_TO_CPU, PIM, false),
 	MLXSW_SP_RXL_MARK(IPV6_PIM, TRAP_TO_CPU, PIM, false),
@@ -4167,6 +4167,7 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_REMOTE_ROUTE:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MULTICAST:
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
 			rate = 1024;
 			burst_size = 7;
 			break;
@@ -4230,6 +4231,7 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			priority = 5;
 			tc = 5;
 			break;
+		case MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_BGP:
 			priority = 4;
 			tc = 4;
-- 
2.26.2

