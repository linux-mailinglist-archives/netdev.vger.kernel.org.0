Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16123C4D0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404269AbfFKHUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:20:14 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56071 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404224AbfFKHUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:20:13 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4995F22494;
        Tue, 11 Jun 2019 03:20:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 03:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=nBuPvC/Vkse/1TLJRSz5VQnMI/ht8uZso9qP0dOqjkw=; b=a7mOX4E9
        Rk7e1Fb2yrevNsGfvYGpERJvVuCM2PPnnWFwlihFlEQOubmfbGQMHcc/EBYxL8ZN
        FrmEji0owQINA5oad7+QskNHFNrL1boKnpiaw9ymQMJi8cQ/ZzppK4GWxFywbwlz
        itu8tI2yXa20jt324MMdtwd3W3Y/6wkrvea5rW3jzTQyiCEkcabKuT7wPqcuVnDi
        DScJ2UWSH4q7vl77atp5PcrgootJPjpdbY1qsAPnsBvp8tPxElIT0OGkabtWO80c
        1SnrDfmncunsbkF/khXjC1xlzTIcV79R1A2/633LBG4EUe/ey9FhV7NcC3eZA7FA
        K4NuqmcK0q0ZWA==
X-ME-Sender: <xms:LFb_XLxYHZr00vllLIxgSsE2pa8bN30S6JdkB-vsN4hn-bRfsKO8Sw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehfedguddujecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:LFb_XDtGJhdTkwPF1W7hf60Kg9_rNgnb4e1SiiYG3smNljtX4JEvZw>
    <xmx:LFb_XMMrmwF5ru1Gsu9u-KPxWDQyvhGwPQdCf4AJn8xcrrTexdJfgA>
    <xmx:LFb_XLxDOuEZmBqQBy6GpypsltWaduxMp2a9HVsiYncQdupSQJkbEg>
    <xmx:LFb_XHvydikgEDSK4E3VDCqzMt8lduB5WGcgcMAK6Sc3B4ogoMfT1A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B9AED380086;
        Tue, 11 Jun 2019 03:20:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, petrm@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/7] mlxsw: spectrum: Use different seeds for ECMP and LAG hash
Date:   Tue, 11 Jun 2019 10:19:40 +0300
Message-Id: <20190611071946.11089-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611071946.11089-1-idosch@idosch.org>
References: <20190611071946.11089-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The same hash function and seed are used for both ECMP and LAG hash.
Therefore, when a LAG device is used as a nexthop device as part of an
ECMP group, hash polarization can occur and all the traffic will be
hashed to a single LAG slave.

Fix this by using a different seed for the LAG hash.

Fixes: fa73989f2697 ("mlxsw: spectrum: Use a stable ECMP/LAG seed")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reported-by: Alex Veber <alexve@mellanox.com>
Tested-by: Alex Veber <alexve@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dfe6b44baf63..23204356ad88 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4280,13 +4280,16 @@ static void mlxsw_sp_traps_fini(struct mlxsw_sp *mlxsw_sp)
 	}
 }
 
+#define MLXSW_SP_LAG_SEED_INIT 0xcafecafe
+
 static int mlxsw_sp_lag_init(struct mlxsw_sp *mlxsw_sp)
 {
 	char slcr_pl[MLXSW_REG_SLCR_LEN];
 	u32 seed;
 	int err;
 
-	seed = jhash(mlxsw_sp->base_mac, sizeof(mlxsw_sp->base_mac), 0);
+	seed = jhash(mlxsw_sp->base_mac, sizeof(mlxsw_sp->base_mac),
+		     MLXSW_SP_LAG_SEED_INIT);
 	mlxsw_reg_slcr_pack(slcr_pl, MLXSW_REG_SLCR_LAG_HASH_SMAC |
 				     MLXSW_REG_SLCR_LAG_HASH_DMAC |
 				     MLXSW_REG_SLCR_LAG_HASH_ETHERTYPE |
-- 
2.20.1

