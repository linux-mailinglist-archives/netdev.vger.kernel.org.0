Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6572C0082
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 08:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgKWHON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 02:14:13 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:41991 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726051AbgKWHON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 02:14:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id DD747F5F;
        Mon, 23 Nov 2020 02:14:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 23 Nov 2020 02:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=c9Z33mj3XHnZsMMekRYcAyfQD0hkjxEmPI3G7K3oqQQ=; b=kbRWDaIS
        eC6t0zZnibgbUzIcpqyFnnSEQd7vkRM4nKBVdq0ShoEyyerEZ/ZzeG/U5IE69hcT
        bkEBQNZ1A1w55sYD0oOq1V0UPkFKZnaKXuqdiuN1bQ5Rp1YG3/0VcLS5MCGOWQI3
        SGPTFz9tlV2CJ4+whummoBlh5h/qdKj7Uwn5nWQ8YT5Sc+URLBkvc0Et3hQ+/f38
        qCDQX+pGaAPPWyZryMqkAGsPzdrOlnZj/fgvRyPdUCl9zsZeXzfKx6uenjs+n5ce
        JVP4RwaCzA1uXMzfMurWm2x24azAYslVCHh/jVZAEAOluXccBz7dR9laGwZT517y
        zjxPVTspBXVT6Q==
X-ME-Sender: <xms:Q2G7X-AqvAh3iGGz1A9I_0vpPxX5I_Z_hjhGDEMv8YiClJljnuJpIw>
    <xme:Q2G7X4idGdW84tqBlmL1F-kWMPinTM4CWEjd93I-CkXSlWx45SIifJ2M3wRv3An0x
    tB5h1yqT4QBkVs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Q2G7XxmbMODzRae9SD93P32fCeGDQL1DUGsDb4sw0w0iFW3nPpEkvA>
    <xmx:Q2G7X8zr-Q36q9NUgm8JBgD2Ro_3amKdhWiDZQgVO2oSRQtd40-jyQ>
    <xmx:Q2G7XzRylgHXnB9Gn7hoFWx5KMVQ5bYtl7EefYGY4R5-57rn0b6T0Q>
    <xmx:Q2G7X9cyCsbmp888lO9-2tvZneJq4N65LVV6pminBDmgfeGYwYnyKQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28B783280060;
        Mon, 23 Nov 2020 02:14:10 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum_router: Resolve RIF from nexthop struct instead of neighbour
Date:   Mon, 23 Nov 2020 09:12:24 +0200
Message-Id: <20201123071230.676469-5-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123071230.676469-1-idosch@idosch.org>
References: <20201123071230.676469-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The two are the same, but for blackhole nexthops we will not have an
associated neighbour struct, so resolve the RIF from the nexthop struct
itself instead.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 53d04e7993f6..ef0e4e452f47 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3284,7 +3284,7 @@ static int __mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY,
 			    true, MLXSW_REG_RATR_TYPE_ETHERNET,
-			    adj_index, neigh_entry->rif);
+			    adj_index, nh->rif->rif_index);
 	mlxsw_reg_ratr_eth_entry_pack(ratr_pl, neigh_entry->ha);
 	if (nh->counter_valid)
 		mlxsw_reg_ratr_counter_pack(ratr_pl, nh->counter_index, true);
-- 
2.28.0

