Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7FA2B6C24
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgKQRrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:47:35 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56077 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729008AbgKQRrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 12:47:33 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D5395F3F;
        Tue, 17 Nov 2020 12:47:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 17 Nov 2020 12:47:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Rw+iMjCkI30TaA4SHluORRyAV6j71+jgGemXuMZdcTQ=; b=F6CXjTN/
        pMd994TjobC4gWXXUV6Oo/1pyLtDFP88XwsP5t3tyd4C9Fw4BdktupxYBGGOHWjB
        MtfJzXiK+rEqPCKCSpeqrgX4Rw+kXC/NYfMg8GgvS7jAD1hDALnXdTgdMV0TkmdY
        cN+051DT2dH0X1pt2PMA/bTGUY9jo2PlPovVU4+YN0TpcsE/TBnAebotX3LEalvL
        1ewj3zNsm9Fu1BpVipt/b+omLbzFHP/5aBbYfPIRuYbKsbAhRSZkJ9dVgC2Vtv+y
        sBLRuahuVOqUY/88eCSMvO/R8MRMdF11ulFEnzYAfAddU4RAgNuXu5WLKR5Ea0uH
        EfcEsom/9bpY+A==
X-ME-Sender: <xms:tAy0X995GrEEYu51xo0eU6KkszO8I8g85GWNwgw1Nq8bFeMJg7a3Uw>
    <xme:tAy0XxtaTjWcfac03gxUCPZ8Of897Nrc_BYTDPCIIdan7OKY9zSY3e0ffnuF2mvmo
    ikOhQbOAT1pAps>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheegrddu
    geejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tAy0X7D3lIli7Rje-eHAxTDhZ7nc-uP58liH2joCXuyzeV07_2y0qw>
    <xmx:tAy0XxcCGaYN9ML8On5ctJjGGdNzKn04h6ZlU_pPCpIjw9Sdl-00cQ>
    <xmx:tAy0XyNS_kvsQbf9NWwPMWYEcbvg8MGx7mAVgKBshQmiPbzNRA7GAQ>
    <xmx:tAy0X_q6gXGNabHkL2lGwACuzHm-8364kuYYA-I11cr4Ht9QxU3ASQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DD58328005E;
        Tue, 17 Nov 2020 12:47:30 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/9] mlxsw: spectrum_router: Fix wrong kfree() in error path
Date:   Tue, 17 Nov 2020 19:46:56 +0200
Message-Id: <20201117174704.291990-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201117174704.291990-1-idosch@idosch.org>
References: <20201117174704.291990-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The function allocates 'nhgi', not 'nh_grp', so it needs to free the
former in its error path.

Fixes: 7f7a417e6a11 ("mlxsw: spectrum_router: Split nexthop group configuration to a different struct")
Addresses-Coverity: ("Memory - corruptions  (USE_AFTER_FREE)")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index a2e81ad5790f..7dbf02f45913 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5423,7 +5423,7 @@ mlxsw_sp_nexthop6_group_info_init(struct mlxsw_sp *mlxsw_sp,
 		nh = &nhgi->nexthops[i];
 		mlxsw_sp_nexthop6_fini(mlxsw_sp, nh);
 	}
-	kfree(nh_grp);
+	kfree(nhgi);
 	return err;
 }
 
-- 
2.28.0

