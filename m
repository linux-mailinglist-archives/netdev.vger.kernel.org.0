Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B79B1E0372
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbgEXVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:28 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58989 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387970AbgEXVv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9D5D05C0097;
        Sun, 24 May 2020 17:51:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=CXKOHK1bl6xuVaaK4vV1WbBE/ATdv7W00RT3X3ZXZpM=; b=JEu9sxnj
        BhEi7osSHWVUq7KvYpsnRqYNDoH7DId7OlUzE5d3ldBQ4tc0HJNMWH2gkwQyLH8F
        yHKv8aqlEQVWRK9uyU+fPc+xiPSgTHAgeXWmKBdFnEzrOJUK/Xw3gjElZgBvglQe
        jUoaUIZnItO8QHL0r6tV57QlGTrbPJAQ/oslDjDzL4wIquB9kmCGxBWhgVUunyU9
        tpZK1r/hsapJwHyPpC3IC4iJODu71xcM9rbx2GMaOzfq1+h6PqgOXXjhXDTzPp1m
        lx74/lReFUNHZpkvF3WqUgmPvmIkrGKeYyo0AhRQJApxsuRd1nrs8caCd5uxVZgs
        OXQhfTvGG7FJJg==
X-ME-Sender: <xms:XuzKXjThLRbI0J-vWs3_eM-P0b-T4kR_zSr2WcHf0yvTuXXn0R-Puw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XuzKXky3w6VvevnFkHvcqC5wbjNZYsZwbAUoyqbH_8OdmLQ9tbfung>
    <xmx:XuzKXo2rc0QFFi-jkEPDk1gIfceMRgzrH5s3xt9D2lwlTpRd8e7V3g>
    <xmx:XuzKXjAlQMKKOW3dNLxV7Th5FDPSAQwmmg2N9VU_kKpmyKZ8Qm2fvQ>
    <xmx:XuzKXoampCz-cJESylKF_L4re7OwObt007Ksk5_Fzvq9rQ5d7jyQ-g>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 55553306651E;
        Sun, 24 May 2020 17:51:25 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 02/11] mlxsw: spectrum: Use same trap group for MLD and IGMP packets
Date:   Mon, 25 May 2020 00:50:58 +0300
Message-Id: <20200524215107.1315526-3-idosch@idosch.org>
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

Both packet types are needed for the same reason (multicast snooping),
so associate them with the same trap group.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      |  1 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 16 +++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 602f9fdfd7ea..d51a4c4665d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5542,7 +5542,6 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DHCP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_EVENT,
-	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_ND,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LBERROR,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PTP0,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 3457a3058eee..bab51dfb6e13 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4054,14 +4054,14 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(ARPBC, MIRROR_TO_CPU, ARP, false),
 	MLXSW_SP_RXL_MARK(ARPUC, MIRROR_TO_CPU, ARP, false),
 	MLXSW_SP_RXL_NO_MARK(FID_MISS, TRAP_TO_CPU, IP2ME, false),
-	MLXSW_SP_RXL_MARK(IPV6_MLDV12_LISTENER_QUERY, MIRROR_TO_CPU, IPV6_MLD,
-			  false),
-	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_REPORT, TRAP_TO_CPU, IPV6_MLD,
-			     false),
-	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_DONE, TRAP_TO_CPU, IPV6_MLD,
-			     false),
-	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV2_LISTENER_REPORT, TRAP_TO_CPU, IPV6_MLD,
+	MLXSW_SP_RXL_MARK(IPV6_MLDV12_LISTENER_QUERY, MIRROR_TO_CPU,
+			  MC_SNOOPING, false),
+	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_REPORT, TRAP_TO_CPU,
+			     MC_SNOOPING, false),
+	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV1_LISTENER_DONE, TRAP_TO_CPU, MC_SNOOPING,
 			     false),
+	MLXSW_SP_RXL_NO_MARK(IPV6_MLDV2_LISTENER_REPORT, TRAP_TO_CPU,
+			     MC_SNOOPING, false),
 	/* L3 traps */
 	MLXSW_SP_RXL_L3_MARK(LBERROR, MIRROR_TO_CPU, LBERROR, false),
 	MLXSW_SP_RXL_MARK(IP2ME, TRAP_TO_CPU, IP2ME, false),
@@ -4156,7 +4156,6 @@ static int mlxsw_sp_cpu_policers_set(struct mlxsw_core *mlxsw_core)
 			burst_size = 7;
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD:
 			rate = 16 * 1024;
 			burst_size = 10;
 			break;
@@ -4237,7 +4236,6 @@ static int mlxsw_sp_trap_groups_set(struct mlxsw_core *mlxsw_core)
 			break;
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_MC_SNOOPING:
 		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IP2ME:
-		case MLXSW_REG_HTGT_TRAP_GROUP_SP_IPV6_MLD:
 			priority = 3;
 			tc = 3;
 			break;
-- 
2.26.2

