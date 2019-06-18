Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1846F4A4EF
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfFRPOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:14:00 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51685 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729594AbfFRPNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A5D0B22496;
        Tue, 18 Jun 2019 11:13:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=WuFieMoeV2l/uPTTTbRIWme54VbdJb6t8D3XkknKAxI=; b=c/OgNdVX
        WzZLF2dBRx7o3odamBrSXqGFz4N1CnYtDyAwkSNAxtibf8uFom0+nHejP8wkXGjF
        fUkGljVWwz5lcx6PWvnEPYy6hDdYnhdb2FdMSOipBmggCZwQpA6AMuq5FCj+Lj4V
        A63qr+hp3ehEKF8PJ93XZ/QDLs8c0BBd62s4FMSBkUmvkU0Gqw2uEA2P4PtmDJF9
        /xQPc5QbzcCENn34Q2z3c+bMLcqhufSMEdmUEtop6f5qqRk0GVTNiRMbtz/nSKEo
        rr4kp3/++NQud4oeXeI64fD+ep21IOzluNYkLPM0yhLg1qrBzGSx8I6gGt6k/Jq9
        nHjJGdgOTm9x5w==
X-ME-Sender: <xms:rP8IXex1f-I3pPhp1nEkf1RRU1lQWgL7m7OCBTkMbf_gaS18tcPbfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepuddt
X-ME-Proxy: <xmx:rP8IXegy7PIGkkmHJJh5YwD1JEboi6unvtARktQ1tKZNO0zMR9Bkjw>
    <xmx:rP8IXbUJ2YN9uQNeJpC_AuuLkK4bpQcnFqnGUnj6_0SxBC6MpzzrgA>
    <xmx:rP8IXY3J_Bn5xjvyBOvC27PxcjFm09W0D-3nqxaX14igiWYaZ1nfFw>
    <xmx:rP8IXWAG5uC-pfDoZYmLSfZCRJAz1-mGDmlmJxK4k9lbS926tui6gA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 967CB380089;
        Tue, 18 Jun 2019 11:13:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 13/16] mlxsw: spectrum_router: Add / delete multiple IPv6 nexthops
Date:   Tue, 18 Jun 2019 18:12:55 +0300
Message-Id: <20190618151258.23023-14-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, the functions that take care of populating IPv6 nexthop
groups only add / delete a single nexthop.

Prepare them to handle multiple routes in one notification by passing an
array of routes and adding / deleting all of them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 61 ++++++++++++-------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f0332d54aea1..98fd3c582a60 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5278,17 +5278,21 @@ mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 static int
 mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
-				struct fib6_info *rt)
+				struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
-	int err;
+	int err, i;
 
-	mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt);
-	if (IS_ERR(mlxsw_sp_rt6))
-		return PTR_ERR(mlxsw_sp_rt6);
+	for (i = 0; i < nrt6; i++) {
+		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
+		if (IS_ERR(mlxsw_sp_rt6)) {
+			err = PTR_ERR(mlxsw_sp_rt6);
+			goto err_rt6_create;
+		}
 
-	list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
-	fib6_entry->nrt6++;
+		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
+		fib6_entry->nrt6++;
+	}
 
 	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
 	if (err)
@@ -5297,27 +5301,38 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_nexthop6_group_update:
-	fib6_entry->nrt6--;
-	list_del(&mlxsw_sp_rt6->list);
-	mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	i = nrt6;
+err_rt6_create:
+	for (i--; i >= 0; i--) {
+		fib6_entry->nrt6--;
+		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
+					       struct mlxsw_sp_rt6, list);
+		list_del(&mlxsw_sp_rt6->list);
+		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	}
 	return err;
 }
 
 static void
 mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_fib6_entry *fib6_entry,
-				struct fib6_info *rt)
+				struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
+	int i;
 
-	mlxsw_sp_rt6 = mlxsw_sp_fib6_entry_rt_find(fib6_entry, rt);
-	if (WARN_ON(!mlxsw_sp_rt6))
-		return;
+	for (i = 0; i < nrt6; i++) {
+		mlxsw_sp_rt6 = mlxsw_sp_fib6_entry_rt_find(fib6_entry,
+							   rt_arr[i]);
+		if (WARN_ON_ONCE(!mlxsw_sp_rt6))
+			continue;
+
+		fib6_entry->nrt6--;
+		list_del(&mlxsw_sp_rt6->list);
+		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	}
 
-	fib6_entry->nrt6--;
-	list_del(&mlxsw_sp_rt6->list);
 	mlxsw_sp_nexthop6_group_update(mlxsw_sp, fib6_entry);
-	mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
 }
 
 static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
@@ -5586,7 +5601,8 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 	 */
 	fib6_entry = mlxsw_sp_fib6_node_mp_entry_find(fib_node, rt, replace);
 	if (fib6_entry) {
-		err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry, rt);
+		err = mlxsw_sp_fib6_entry_nexthop_add(mlxsw_sp, fib6_entry,
+						      rt_arr, nrt6);
 		if (err)
 			goto err_fib6_entry_nexthop_add;
 		return 0;
@@ -5632,11 +5648,12 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 	if (WARN_ON(!fib6_entry))
 		return;
 
-	/* If route is part of a multipath entry, but not the last one
-	 * removed, then only reduce its nexthop group.
+	/* If not all the nexthops are deleted, then only reduce the nexthop
+	 * group.
 	 */
-	if (!list_is_singular(&fib6_entry->rt6_list)) {
-		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, fib6_entry, rt);
+	if (nrt6 != fib6_entry->nrt6) {
+		mlxsw_sp_fib6_entry_nexthop_del(mlxsw_sp, fib6_entry, rt_arr,
+						nrt6);
 		return;
 	}
 
-- 
2.20.1

