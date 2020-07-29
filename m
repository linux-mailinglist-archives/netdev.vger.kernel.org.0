Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C70231C0F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgG2J1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:27:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44697 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgG2J1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:27:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 500CF5C014B;
        Wed, 29 Jul 2020 05:27:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 29 Jul 2020 05:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=LF/9TYIkaowQsnxHb/+soUWtuwrFj9CMWn6A2u7AffM=; b=qkd3c5HE
        1T7WP5018oujhjS19C3kpqgPpWbmWZn9Nm6nbbQ6Qtz1SmIbNd/67WrmfhYo8WI2
        biHSVHq7IN0Cmq64n9/Vb42oCWMX9ecNQS7LztL7G7CIvZBpojH1hoTB0Mg/jb5n
        EbToeGqxdyAMffuVuse0UHH9+T93LIJJf/qsRSUYlahnvC1jsjBqaE35XLf6fy6p
        2Wc7tP2Qce0AT7x91R+xX2j54W84uGh8/coaAdQUGFrUyMBxIB/Nz/q/LsWM8XHD
        xJHTR00ITHBtkSc8AGrpKKt+ClCflKA0TVTswRF6xsQp3X0TS0c7oSWXHO2wwI7+
        /FuJ+PoYvUh8Og==
X-ME-Sender: <xms:-UAhXxpkcrQHRV3PzYWIb88cRmAeYZPshdpGE5nAjNv4HWWs_xBUxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrieeggdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieehrddufeejrddvhedt
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-UAhXzoXkra2C9oBTIiHji-7HGYUE-uN__xfVzJ1Ld1qjIGUlmGILQ>
    <xmx:-UAhX-NX6qlTy4pBsNi0G1P0pv-DctTEtcYMSjJNs_pczkJkPYvVzQ>
    <xmx:-UAhX87J5AfuL4dCij1x9Q0OxmKTm25fJu3r5c8AAnmZkNXoIPfzwg>
    <xmx:-UAhX-kd6l_6xseaVuaHNiOxNbKRWhdwMSTc-Y5uMY2JqMDtgHBiLQ>
Received: from shredder.mtl.com (bzq-109-65-137-250.red.bezeqint.net [109.65.137.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 54EAE3280063;
        Wed, 29 Jul 2020 05:27:19 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        amitc@mellanox.com, alexve@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/6] mlxsw: spectrum_router: Allow programming link-local host routes
Date:   Wed, 29 Jul 2020 12:26:43 +0300
Message-Id: <20200729092648.2055488-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729092648.2055488-1-idosch@idosch.org>
References: <20200729092648.2055488-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Cited commit added the ability to program link-local prefix routes to
the ASIC so that relevant packets are routed and trapped correctly.

However, host routes were not included in the change and thus not
programmed to the ASIC. This can result in packets being trapped via an
external route trap instead of a local route trap as in IPv4.

Fix this by programming all the link-local routes to the ASIC.

Fixes: 10d3757fcb07 ("mlxsw: spectrum_router: Allow programming link-local prefix routes")
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 019ed503aadf..bd4803074776 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5001,15 +5001,6 @@ static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
 
 static bool mlxsw_sp_fib6_rt_should_ignore(const struct fib6_info *rt)
 {
-	/* Packets with link-local destination IP arriving to the router
-	 * are trapped to the CPU, so no need to program specific routes
-	 * for them. Only allow prefix routes (usually one fe80::/64) so
-	 * that packets are trapped for the right reason.
-	 */
-	if ((ipv6_addr_type(&rt->fib6_dst.addr) & IPV6_ADDR_LINKLOCAL) &&
-	    (rt->fib6_flags & (RTF_LOCAL | RTF_ANYCAST)))
-		return true;
-
 	/* Multicast routes aren't supported, so ignore them. Neighbour
 	 * Discovery packets are specifically trapped.
 	 */
-- 
2.26.2

