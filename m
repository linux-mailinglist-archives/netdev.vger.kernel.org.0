Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636E61E181B
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389067AbgEYXGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:45 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42693 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388915AbgEYXGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E7A7E5C0185;
        Mon, 25 May 2020 19:06:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=42nwNdhxxXP68YQA7v7B0NP4g/tpfAE+UngW1dwXyz4=; b=DNUyIZIo
        Fod9wmR+Ra3FhYQ8sH+ZPKk7jbGipEdk9NZDyw1aWazstqNqh7QgOB4KxRVRL4s3
        Tpb5aqrdy/vp2fDHxgX5lVVZg56+63hQWs2x4+KHyzhRUpUx53PNJriJK0802v54
        kR4bMPdgVzFyE5pEAGpXaVkHo/hs6xts+fSqArScT3Oq6vublKSobsZEsJ0CqEG7
        njV/J24hFmVIMW2V0DJ8/ymOadYmNmkGBAg5099hFI/ZQOG0vcZbdQuu6POgYD3h
        13Suz/h9Kgt2UTYJHfZlf2pToTQhn3Niv3+eFdlpblIKkN80ppuONejtp1WIvHSX
        mUHaCNvzxM9x7g==
X-ME-Sender: <xms:d0_MXjv_-U8r0R3F7qNuQspi2KnZJ0g09tOrnqD36YWcYAJGAcUFIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:d0_MXkfKGmWjEAqYXTEfZ0DbLgZT1oDB7fwd4rwqjRk-R_7EIumCCg>
    <xmx:d0_MXmxC-CDpBLaLvM1qlmJMHaTq-0LlIPFb2ofleh5cm27SHUITGA>
    <xmx:d0_MXiO81D0sh8Jx7F9bVxzaKKDPLqkXBhBiN9NnNdzUoBNrcv_zYA>
    <xmx:d0_MXtkIrCIiSyzJUROdDgzU_uea3GDD0igYR7F4Nkdc8ao2WsHbrg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1AB33280059;
        Mon, 25 May 2020 19:06:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/14] mlxsw: spectrum: Treat IPv6 link-local SIP as an exception
Date:   Tue, 26 May 2020 02:05:54 +0300
Message-Id: <20200525230556.1455927-13-idosch@idosch.org>
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

IPv6 packets that need to be forwarded and have a link-local source IP are
dropped by the kernel and an ICMPv6 "Destination unreachable" is sent to
the sending host.

As such, change the trap group of such packets so that they do not
interfere with IPv6 management packets. In the future this trap will be
exposed as an exception via devlink-trap.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 016df2c14f0e..5cb7fd650156 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4067,7 +4067,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IPV6_UNSPECIFIED_ADDRESS, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
 	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_DEST, TRAP_TO_CPU, IP2ME, false),
-	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_SRC, TRAP_TO_CPU, IPV6, false),
+	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_SRC, TRAP_TO_CPU, ROUTER_EXP, false),
 	MLXSW_SP_RXL_MARK(IPV6_ALL_NODES_LINK, TRAP_TO_CPU, IPV6, false),
 	MLXSW_SP_RXL_MARK(IPV6_ALL_ROUTERS_LINK, TRAP_TO_CPU, IPV6,
 			  false),
-- 
2.26.2

