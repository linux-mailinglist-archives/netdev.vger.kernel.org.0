Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7641E1813
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388874AbgEYXG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37847 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388211AbgEYXGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 925345C0182;
        Mon, 25 May 2020 19:06:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=BQBJI+egxY/bTc525Ak4NPHjkYlRyrzruuXBWHSLR9k=; b=Cn1aFNID
        27nftujKBsgN42vn5VpYZ9h17GEHLSuXEwdS0DgC68kWX7W3Vye81QFIh/DcT2L7
        +It9EZ+N4GKRTYOQtPxT0kC3ESFC4SQ+0onmYvK4BVglDOa0VcbfeafSQFUYSPzn
        MdPTY7zKIvosXzD7HKe7HOgsLpm+bKkvg2ob8XF3z+rVBCQLNTUeEAJWx1/mdyc6
        n+qP4IZgxlpz3DNi2glXxWSmtoxYr3zp0KJVQ7WPXRamT/7LPaNnws6RRVZkcd1x
        YIIg28/MNtBSDmF6YJPotFA2qSMuED0lrzzyKK3F7nQZ3kpjANKGSV/e4xBDMiW2
        Zwl6v4AP/UiIbg==
X-ME-Sender: <xms:b0_MXsl8JMpRIMoscmGpQujMRcxyCxxFyTnkRfQmIJq6ivVUO00aow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:b0_MXr3T53g4OJVw9LnDnDnPgYxfcNy5UllhGUd22rqxM8eKEwxevA>
    <xmx:b0_MXqpNjdJxaKafM0fwqbR1Anc0gHgF86He9pnXbAjM1cI8kFhv4Q>
    <xmx:b0_MXok5jOOkCZ0OPxrNXUXGMw_0tkuwaLeKnkxhXoPg78OYnw09bQ>
    <xmx:b0_MXv-M8--MER5YQnkJM_sMS96UdkEwqOWR5JVgEq0ScQus47oUcA>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C6013280059;
        Mon, 25 May 2020 19:06:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/14] mlxsw: spectrum: Use same trap group for local routes and link-local destination
Date:   Tue, 26 May 2020 02:05:48 +0300
Message-Id: <20200525230556.1455927-7-idosch@idosch.org>
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

Packets with an IPv6 link-local destination (i.e., fe80::/10) should not
be forwarded and are therefore trapped to the CPU for local delivery.
Since these packets are trapped for the same logical reason as packets
hitting local routes, associate both traps with the same group.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ac71d67457aa..5fe51ee8a206 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4066,7 +4066,7 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 	MLXSW_SP_RXL_MARK(IP2ME, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_UNSPECIFIED_ADDRESS, TRAP_TO_CPU, ROUTER_EXP,
 			  false),
-	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_DEST, TRAP_TO_CPU, ROUTER_EXP, false),
+	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_DEST, TRAP_TO_CPU, IP2ME, false),
 	MLXSW_SP_RXL_MARK(IPV6_LINK_LOCAL_SRC, TRAP_TO_CPU, IPV6, false),
 	MLXSW_SP_RXL_MARK(IPV6_ALL_NODES_LINK, TRAP_TO_CPU, IPV6, false),
 	MLXSW_SP_RXL_MARK(IPV6_ALL_ROUTERS_LINK, TRAP_TO_CPU, IPV6,
-- 
2.26.2

