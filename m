Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4636047058
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfFOOJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45261 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9769021EAF;
        Sat, 15 Jun 2019 10:09:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=NeMdZa/xk15wRCTrJX3O81TEvrB5fxUfnEGTh0ZNC3M=; b=mNH4sS7D
        IJAlGklNt5mlUavapp0v/d0+2fGUQ2ED0ictvcrzdiOF404jZ1+2KxgRNWBGvFyI
        K4WdJVxDRKd1Q+L9orPBRc7Tyre5N1yjbWuW4igRSV5HybhZ1KBPUAjt6zeQeqfi
        dazJR0bHV6c2jqUQFxIELlkzayF9xuBGpQxpZ3Q59VPYbJ9F5yz/rbEEDs1XH+qk
        OQ1rN80PZvCOlpP3eO64BXvlJ9nSr/vmDNvtysVf2E46+KlEk6sNgQalCDa9CNt6
        x5OfAiXihCTxfzTbIGjzrCdzlE3ezWVxlhcnQGYCnPKy+TroPJ0udV2dSrBEQAli
        MAw20U1pcXFTBg==
X-ME-Sender: <xms:M_wEXcIsZqTxHMkw2U0R8BlYQvc4-y9XlhXuf-T5LMoIVeBmww0Ifw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:M_wEXes6Q321yJgfnOchbKdbSY26R0mWFIcUwMwQitpai3HDuYIoSQ>
    <xmx:M_wEXQUNUV6sHwrVXYs6BdJD9H4RLKjYYqfytGX4Ku2mm7qcWr7ToA>
    <xmx:M_wEXZi-XV5bhGH5akaO5bteYuaQDhVpAhr2lerzcZU5HSule0RwWg>
    <xmx:M_wEXW94dDmSMEKZ1fBO6kd8lEWmy5N4e7iPINDEpVHBecew84FEjQ>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD57E380073;
        Sat, 15 Jun 2019 10:09:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 15/17] mlxsw: spectrum_router: Create IPv6 multipath routes in one go
Date:   Sat, 15 Jun 2019 17:07:49 +0300
Message-Id: <20190615140751.17661-16-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Allow the driver to create an IPv6 multipath route in one go by passing
an array of sibling routes and iterating over them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 36 ++++++++++++-------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b3077aceb884..2f5fa1fac825 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5306,29 +5306,32 @@ mlxsw_sp_fib6_entry_rt_destroy_all(struct mlxsw_sp_fib6_entry *fib6_entry)
 static struct mlxsw_sp_fib6_entry *
 mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_fib_node *fib_node,
-			   struct fib6_info *rt)
+			   struct fib6_info **rt_arr, unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_entry *fib_entry;
 	struct mlxsw_sp_rt6 *mlxsw_sp_rt6;
-	int err;
+	int err, i;
 
 	fib6_entry = kzalloc(sizeof(*fib6_entry), GFP_KERNEL);
 	if (!fib6_entry)
 		return ERR_PTR(-ENOMEM);
 	fib_entry = &fib6_entry->common;
 
-	mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt);
-	if (IS_ERR(mlxsw_sp_rt6)) {
-		err = PTR_ERR(mlxsw_sp_rt6);
-		goto err_rt6_create;
+	INIT_LIST_HEAD(&fib6_entry->rt6_list);
+
+	for (i = 0; i < nrt6; i++) {
+		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
+		if (IS_ERR(mlxsw_sp_rt6)) {
+			err = PTR_ERR(mlxsw_sp_rt6);
+			goto err_rt6_create;
+		}
+		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
+		fib6_entry->nrt6++;
 	}
 
-	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, mlxsw_sp_rt6->rt);
+	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
 
-	INIT_LIST_HEAD(&fib6_entry->rt6_list);
-	list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
-	fib6_entry->nrt6 = 1;
 	err = mlxsw_sp_nexthop6_group_get(mlxsw_sp, fib6_entry);
 	if (err)
 		goto err_nexthop6_group_get;
@@ -5338,9 +5341,15 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	return fib6_entry;
 
 err_nexthop6_group_get:
-	list_del(&mlxsw_sp_rt6->list);
-	mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	i = nrt6;
 err_rt6_create:
+	for (i--; i >= 0; i--) {
+		fib6_entry->nrt6--;
+		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
+					       struct mlxsw_sp_rt6, list);
+		list_del(&mlxsw_sp_rt6->list);
+		mlxsw_sp_rt6_destroy(mlxsw_sp_rt6);
+	}
 	kfree(fib6_entry);
 	return ERR_PTR(err);
 }
@@ -5541,7 +5550,8 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	}
 
-	fib6_entry = mlxsw_sp_fib6_entry_create(mlxsw_sp, fib_node, rt);
+	fib6_entry = mlxsw_sp_fib6_entry_create(mlxsw_sp, fib_node, rt_arr,
+						nrt6);
 	if (IS_ERR(fib6_entry)) {
 		err = PTR_ERR(fib6_entry);
 		goto err_fib6_entry_create;
-- 
2.20.1

