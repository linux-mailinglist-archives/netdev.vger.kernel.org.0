Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F50F16582E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBTHI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:26 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39337 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgBTHIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:25 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CCA4D213BD;
        Thu, 20 Feb 2020 02:08:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ielsfByD6vsB2AeB7g0KPmXXuU1tEAncFGtj2c2vL2k=; b=zt7/p1KO
        d2fMKYvc5GWTUb4uSKeZiuja6W9yU0Y9OR4q6b8aXfdS2pRqC5Dsz2nBepHIFnQ6
        XXlK+lwf6oB1PzbKpF2ddF0pLY4Nlzs1KVehKwLk6DOvu9YFqhh8RqF3RKVKr34w
        x6MpAQIOvpglhCZd1ZVAVa+7nqixR6BtN8e+HHfFs5m/7FQ5bAqXOeuqYkd5UJOD
        hldHffqtkn9BuW6pCnHynL895sYqd2GK0FS3twi1uFp5GDY05Xu/ekXXRGQmNkQx
        I3fljLHhz/ReYy+bDkquIF7zW0kJW6k39jXXK7uOPO4CGESOWiJLug3iJnv0BPVp
        AM6GsBMdQ8GHHw==
X-ME-Sender: <xms:aDBOXgnuHUmh7sCiKqw3tl68SGpLpY3S0pFlDBvRSkvEWqWlmDdpqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:aDBOXjyZT-loQqEuzi1jwZgy_rRxNvtOzROIzsgKJSC5oC-B3kDoxw>
    <xmx:aDBOXnslE2XE8O1Rw1XZEuxZ9CA08I7FbNIQMBvdxoEuhJuY69UpbQ>
    <xmx:aDBOXlH_3SygAtUHymnBWz0691AXPrVjvZ7LZOgY1sbrLNj1XDvnQQ>
    <xmx:aDBOXlCN8DQOByNWk-BqAcMvSefwScDs2XL2_zffFnzC78AkmlGTKA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B2A673060C28;
        Thu, 20 Feb 2020 02:08:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 04/15] mlxsw: spectrum_span: Use struct_size() to simplify allocation
Date:   Thu, 20 Feb 2020 09:07:49 +0200
Message-Id: <20200220070800.364235-5-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220070800.364235-1-idosch@idosch.org>
References: <20200220070800.364235-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Allocate the main mirroring struct and the individual structs for the
different mirroring agents in a single allocation.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 23 ++++---------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 4b76f01634c1..aeb28486635c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -15,8 +15,8 @@
 #include "spectrum_switchdev.h"
 
 struct mlxsw_sp_span {
-	struct mlxsw_sp_span_entry *entries;
 	int entries_count;
+	struct mlxsw_sp_span_entry entries[0];
 };
 
 static u64 mlxsw_sp_span_occ_get(void *priv)
@@ -37,26 +37,18 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_span *span;
-	int i, err;
+	int i, entries_count;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_SPAN))
 		return -EIO;
 
-	span = kzalloc(sizeof(*span), GFP_KERNEL);
+	entries_count = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_SPAN);
+	span = kzalloc(struct_size(span, entries, entries_count), GFP_KERNEL);
 	if (!span)
 		return -ENOMEM;
+	span->entries_count = entries_count;
 	mlxsw_sp->span = span;
 
-	mlxsw_sp->span->entries_count = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-							   MAX_SPAN);
-	mlxsw_sp->span->entries = kcalloc(mlxsw_sp->span->entries_count,
-					  sizeof(struct mlxsw_sp_span_entry),
-					  GFP_KERNEL);
-	if (!mlxsw_sp->span->entries) {
-		err = -ENOMEM;
-		goto err_alloc_span_entries;
-	}
-
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
 		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
 
@@ -68,10 +60,6 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 					  mlxsw_sp_span_occ_get, mlxsw_sp);
 
 	return 0;
-
-err_alloc_span_entries:
-	kfree(span);
-	return err;
 }
 
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
@@ -86,7 +74,6 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 
 		WARN_ON_ONCE(!list_empty(&curr->bound_ports_list));
 	}
-	kfree(mlxsw_sp->span->entries);
 	kfree(mlxsw_sp->span);
 }
 
-- 
2.24.1

