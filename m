Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89D310827B
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 08:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKXHtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 02:49:10 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37255 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbfKXHtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 02:49:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D1B3227F4;
        Sun, 24 Nov 2019 02:49:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 24 Nov 2019 02:49:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=TYvuA0SqoLenRqRHww+Hkwhi5AzkQIkYlLClpF6GqEA=; b=N/3cHQH9
        /UQDFxpfpyDPcigr6auvh7ETU3mZuB2egsoDxHeFVOFFvlgEr9DOtwm6CYShIi35
        SOjLiphvF0JuCe6vOw0FXN4yzBt+tmVX7wf5liEj9B/Ac9b9JosT4JoaG4XnLzHG
        W+0Fic8GNPOxnNE3o7bO9/B1/NcjZkdTB642dmnuQ/9opTvbzle+wt9IFyClX6Db
        oiAD1yZDUhlxfkofU50Oo3BNXHTkMtdB7ZCwNWcrazBnFWfd/dfuotPeHvSQ6x4H
        UoR4kVTeA54OZrAEDzAfmjcxcUaYOtRToLC2HrDrapt7PlsefMXDt50j/O30wti3
        GjNXwPNgVg87nQ==
X-ME-Sender: <xms:9DXaXZCyvw5idKif4CmfPskEh82uO3UeSLGhMXmq2NjGdFyclBBv_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudehjedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:9DXaXQ2CVinl_xxShr9mOaQBnWS6wJhy7g5tlhbgw-LotVG6cCCAMw>
    <xmx:9DXaXQ_N7nyoN3wHUzRyKbG1L0sucjta3OYiJ5LLGG6lRVcEiMFJ5A>
    <xmx:9DXaXbXphGXRKo_J6WO0w91xxns0PhVryfLxJUKk8ESBwighzoZ2iQ>
    <xmx:9TXaXSRhSsNm0SWLPd_Bgg53ZNEWAd6XFuHuBKLSbdpzNuM2pSrhIA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 72CC9306005B;
        Sun, 24 Nov 2019 02:49:07 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, petrm@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: spectrum_router: Fix use of uninitialized adjacency index
Date:   Sun, 24 Nov 2019 09:48:03 +0200
Message-Id: <20191124074803.19166-3-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191124074803.19166-1-idosch@idosch.org>
References: <20191124074803.19166-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

When mlxsw_sp_adj_discard_write() is called for the first time, the
value stored in 'mlxsw_sp->router->adj_discard_index' is invalid, as
indicated by 'mlxsw_sp->router->adj_discard_index_valid' being set to
'false'.

In this case, we should not use the value initially stored in
'mlxsw_sp->router->adj_discard_index' (0) and instead use the value
allocated later in the function.

Fixes: 983db6198f0d ("mlxsw: spectrum_router: Allocate discard adjacency entry when needed")
Signed-off-by: Amit Cohen <amitc@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4c4d99ab15a0..30bfe3880faf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4221,7 +4221,6 @@ mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl,
 
 static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 {
-	u32 adj_discard_index = mlxsw_sp->router->adj_discard_index;
 	enum mlxsw_reg_ratr_trap_action trap_action;
 	char ratr_pl[MLXSW_REG_RATR_LEN];
 	int err;
@@ -4236,8 +4235,8 @@ static int mlxsw_sp_adj_discard_write(struct mlxsw_sp *mlxsw_sp, u16 rif_index)
 
 	trap_action = MLXSW_REG_RATR_TRAP_ACTION_DISCARD_ERRORS;
 	mlxsw_reg_ratr_pack(ratr_pl, MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY, true,
-			    MLXSW_REG_RATR_TYPE_ETHERNET, adj_discard_index,
-			    rif_index);
+			    MLXSW_REG_RATR_TYPE_ETHERNET,
+			    mlxsw_sp->router->adj_discard_index, rif_index);
 	mlxsw_reg_ratr_trap_action_set(ratr_pl, trap_action);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
 	if (err)
-- 
2.21.0

