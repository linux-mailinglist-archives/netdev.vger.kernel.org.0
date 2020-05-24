Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12C11E0373
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388407AbgEXVva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:51:30 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47717 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388371AbgEXVv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:51:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 09A5D5C00A9;
        Sun, 24 May 2020 17:51:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 May 2020 17:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3xmhz6lT3txm9qOrMW7U2ocQBhiaI3xpgcH963yi/4Q=; b=B3kD03G2
        pqfwCj7IQfx+vOANZhG7dDu6BbWzQW36sZz6GEUeLdBi7XPloGQcTA9uUzBoq9Bm
        6BrfMA4ldtLG69gTWGReuw9xpNUqIaOlV0uH9n68dIZy0L2XZ10cmqUtNVO1pvXc
        RZFAeRtWgZ+/vqZwBDRTxNGPDNC9S1Dudb/QfLMbZR9gloPBWDL4V4XDTl/rEeC0
        awFb0ydIoNPZvarTqjm4K9TQ5phU1Uk1qB0ZmfTLoKSxRnCE241atztU7Ut/3W9u
        2yS3kjnCcsq5LLX19oNv5ZM4Y1vYNcnqDj7KsFOuS53PDEXb8eenrhNNQHtSl9LU
        i8pBCSM5W67wKA==
X-ME-Sender: <xms:X-zKXg92h85hvPBQqWUU8Iib9OULZez9UiSXExwrXGgrsozl_w3I0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:X-zKXovaiMNw1FSGVv9etoJoWyrshrwQnJGZ8o6iLJnbEwAdtdmMbw>
    <xmx:X-zKXmBHIi-xrteQQEV69rf6qAGU3MrG485Hy8NCoXUplY1Ayaui7A>
    <xmx:X-zKXgcQHC8mSWhgUo5nOoMlfsLHXRFRL9tizl5SCNsuRmvHDrNWOQ>
    <xmx:YOzKXj117EUeIbpf89JVH0Rg8pM8dq_yDjSn2tzB5XMnw4-fEeNoXg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6189306651E;
        Sun, 24 May 2020 17:51:26 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 03/11] mlxsw: spectrum: Trap IPv4 DHCP packets in router
Date:   Mon, 25 May 2020 00:50:59 +0300
Message-Id: <20200524215107.1315526-4-idosch@idosch.org>
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

Currently, IPv4 DHCP packets are trapped during L2 forwarding, which
means that packets might be trapped unnecessarily. Instead, only trap
the DHCP packets that reach the router. Either because they were flooded
to the router port or forwarded to it by the FDB. This is consistent
with the corresponding IPv6 trap.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h     | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index bab51dfb6e13..fa6e630abb6e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4045,7 +4045,6 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_NO_MARK(LACP, TRAP_TO_CPU, LACP, true),
 	MLXSW_RXL(mlxsw_sp_rx_listener_ptp, LLDP, TRAP_TO_CPU,
 		  false, SP_LLDP, DISCARD),
-	MLXSW_SP_RXL_MARK(DHCP, MIRROR_TO_CPU, DHCP, false),
 	MLXSW_SP_RXL_MARK(IGMP_QUERY, MIRROR_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_NO_MARK(IGMP_V1_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
 	MLXSW_SP_RXL_NO_MARK(IGMP_V2_REPORT, TRAP_TO_CPU, MC_SNOOPING, false),
@@ -4074,6 +4073,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			  false),
 	MLXSW_SP_RXL_MARK(IPV4_OSPF, TRAP_TO_CPU, OSPF, false),
 	MLXSW_SP_RXL_MARK(IPV6_OSPF, TRAP_TO_CPU, OSPF, false),
+	MLXSW_SP_RXL_MARK(IPV4_DHCP, TRAP_TO_CPU, DHCP, false),
 	MLXSW_SP_RXL_MARK(IPV6_DHCP, TRAP_TO_CPU, DHCP, false),
 	MLXSW_SP_RXL_MARK(RTR_INGRESS0, TRAP_TO_CPU, REMOTE_ROUTE, false),
 	MLXSW_SP_RXL_MARK(IPV4_BGP, TRAP_TO_CPU, BGP, false),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index eaa521b7561b..fac05433c488 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -59,6 +59,7 @@ enum {
 	MLXSW_TRAP_ID_L3_IPV6_NEIGHBOR_SOLICITATION = 0x8C,
 	MLXSW_TRAP_ID_L3_IPV6_NEIGHBOR_ADVERTISMENT = 0x8D,
 	MLXSW_TRAP_ID_L3_IPV6_REDIRECTION = 0x8E,
+	MLXSW_TRAP_ID_IPV4_DHCP = 0x8F,
 	MLXSW_TRAP_ID_HOST_MISS_IPV4 = 0x90,
 	MLXSW_TRAP_ID_IPV6_MC_LINK_LOCAL_DEST = 0x91,
 	MLXSW_TRAP_ID_HOST_MISS_IPV6 = 0x92,
-- 
2.26.2

