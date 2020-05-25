Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA421E180F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbgEYXGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45617 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388724AbgEYXGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D78615C0182;
        Mon, 25 May 2020 19:06:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=WvMQhLIFl2DHOd3UgUOAM6dkr/Zzjc0ZH4E1lPQt4qs=; b=ajz9kkzZ
        ICKDsWuT733eiwYj8gkqFAItMID2L7Y4ub2ph4uWf73lah0/inVPv+lCrXSUcbNR
        GRzHaDRRjSeDpuItZj22Al5nRKBOKkuJ8pe4HBw/MxMg6CGN8k8ljs3krFUD7v4o
        ctq2pHjR80ihROokIYzflabp03HOOPXRV/HkZl7YFmlAHzYxvw4HpXAhjYoZ2smU
        SV/pfi21alL/3EQBHBWuy/qFXGlf1X4onazHrCdau9jShCCs4yKEFvshEHejDgyd
        Mi5ynrPDoozp9AorDoFpiyJf21TGInHOLf1MPp9gw30IzbXtHRp0UlrimZkIRW7J
        I22jwhhWH8eXUA==
X-ME-Sender: <xms:bE_MXj8f0AW7qmuL7FhjDwQdELtV4uPEUWu1qmChKvEa2uia591awA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bE_MXvsDui039U9THOkJEfwSzga4DKlLIq4P17BJS2d_PcZtQmVv8A>
    <xmx:bE_MXhCMi-RZk1pvdCJbrXJBbZhjJMeCnzPBz7VRcX5HsDI6tK0Edg>
    <xmx:bE_MXvdu5PKT64-3NvSZAGVRTjfTpgTubaob3U6x_ENlbWvIrGjO1w>
    <xmx:bE_MXi3CZ75eoKwT7oVeIaA8BNVs816abK9pICFbyWLrE67n14d04w>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 964123280064;
        Mon, 25 May 2020 19:06:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/14] mlxsw: spectrum: Use same trap group for various IPv6 packets
Date:   Tue, 26 May 2020 02:05:46 +0300
Message-Id: <20200525230556.1455927-5-idosch@idosch.org>
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

Group these various IPv6 packets (e.g., router solicitations, router
advertisement) together and subject them to the same policer.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b420aa292d7c..141a605582c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4067,9 +4067,9 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IPV6_UNSPECIFIED_ADDRESS, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
 	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_SRC, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPV6_ALL_NODES_LINK, TRAP_TO_CPU, ROUTER_EXP, false),
-	MLXSW_SP_RXL_MARK(IPV6_ALL_ROUTERS_LINK, TRAP_TO_CPU, ROUTER_EXP,
+	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_SRC, TRAP_TO_CPU, IPV6, false),
+	MLXSW_SP_RXL_MARK(IPV6_ALL_NODES_LINK, TRAP_TO_CPU, IPV6, false),
+	MLXSW_SP_RXL_MARK(IPV6_ALL_ROUTERS_LINK, TRAP_TO_CPU, IPV6,
 			  false),
 	MLXSW_SP_RXL_MARK(IPV4_OSPF, TRAP_TO_CPU, OSPF, false),
 	MLXSW_SP_RXL_MARK(IPV6_OSPF, TRAP_TO_CPU, OSPF, false),
-- 
2.26.2

