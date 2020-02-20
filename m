Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7E616582C
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgBTHIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:23 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37519 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726342AbgBTHIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:22 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 397D72108A;
        Thu, 20 Feb 2020 02:08:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=YfX8B2rf2zhmX7z0edbuH/XChtCG3zPsfej9E72fXuM=; b=II+98vSb
        BeTaRJzKXNzRe75G9WxQNfWIwPD61MN5tbCCq0z1ZZPgGqK9p4Yx9ammHFwvLUKh
        CINMeRnWD6d7jDPpxQ3nPKKksg2flnOqtJ4eMzN9xTcHwKDykWgTC94wyhFgmg6s
        k2xaMUux7nJF4/MiIyz9BSs2LhhPOswopku2KUYmDL8NpULJxtQDUjPlgQn1v6bC
        8yNYsj12fFvgL5u600oCMRwr4c6fCoFqk3GJbtX6cJSiPP0MnEO5swMShYmIkbDh
        rFMYdVWakN/pJAJ1WPk310jNpbyKEpCWGWaRdaFDGZ2LdJno5vIx5mYJP7OwnyiQ
        jRzr4BRAp7eD8A==
X-ME-Sender: <xms:ZTBOXmoXG7mraWkb3shwXIXqlqDhEv4JdefnHJnDoELF5ge_izw4HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:ZTBOXmNx-NtnG61xUVjVf9AwfAYn4gVKQAUPu_9BYpmiXcSnCjuCTA>
    <xmx:ZTBOXqfPdYaSG9of7tcNMwbnXQqIge8Tbaf1c0o52WZx1f5F-xcvOg>
    <xmx:ZTBOXsVFrIN5fkEBsAYcdqufKRFakh6vb-Wg9DTsIbXF_rAYjicPnQ>
    <xmx:ZTBOXrUYupPTnQFp2A4QgD8K6xNgOxInXgbdUiCU1iZYnBMRhnVkOQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E9953060C28;
        Thu, 20 Feb 2020 02:08:19 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/15] mlxsw: spectrum_kvdl: Protect allocations with a lock
Date:   Thu, 20 Feb 2020 09:07:46 +0200
Message-Id: <20200220070800.364235-2-idosch@idosch.org>
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

The KVDL is used to store objects allocated throughout various places
in the driver. For example, both nexthops (adjacency entries) and ACL
actions are stored in the KVDL.

Currently, all allocations are protected by RTNL, but this is going to
change with the removal of RTNL from the routing code.

Therefore, protect KVDL allocations with a lock. A mutex is used since
the free operation can block in Spectrum-2.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_kvdl.c  | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
index 715ec8ecacba..20d72f1c0cee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_kvdl.c
@@ -2,12 +2,14 @@
 /* Copyright (c) 2016-2018 Mellanox Technologies. All rights reserved */
 
 #include <linux/kernel.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #include "spectrum.h"
 
 struct mlxsw_sp_kvdl {
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
+	struct mutex kvdl_lock; /* Protects kvdl allocations */
 	unsigned long priv[];
 	/* priv has to be always the last item */
 };
@@ -22,6 +24,7 @@ int mlxsw_sp_kvdl_init(struct mlxsw_sp *mlxsw_sp)
 		       GFP_KERNEL);
 	if (!kvdl)
 		return -ENOMEM;
+	mutex_init(&kvdl->kvdl_lock);
 	kvdl->kvdl_ops = kvdl_ops;
 	mlxsw_sp->kvdl = kvdl;
 
@@ -31,6 +34,7 @@ int mlxsw_sp_kvdl_init(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 
 err_init:
+	mutex_destroy(&kvdl->kvdl_lock);
 	kfree(kvdl);
 	return err;
 }
@@ -40,6 +44,7 @@ void mlxsw_sp_kvdl_fini(struct mlxsw_sp *mlxsw_sp)
 	struct mlxsw_sp_kvdl *kvdl = mlxsw_sp->kvdl;
 
 	kvdl->kvdl_ops->fini(mlxsw_sp, kvdl->priv);
+	mutex_destroy(&kvdl->kvdl_lock);
 	kfree(kvdl);
 }
 
@@ -48,9 +53,14 @@ int mlxsw_sp_kvdl_alloc(struct mlxsw_sp *mlxsw_sp,
 			unsigned int entry_count, u32 *p_entry_index)
 {
 	struct mlxsw_sp_kvdl *kvdl = mlxsw_sp->kvdl;
+	int err;
+
+	mutex_lock(&kvdl->kvdl_lock);
+	err = kvdl->kvdl_ops->alloc(mlxsw_sp, kvdl->priv, type,
+				    entry_count, p_entry_index);
+	mutex_unlock(&kvdl->kvdl_lock);
 
-	return kvdl->kvdl_ops->alloc(mlxsw_sp, kvdl->priv, type,
-				     entry_count, p_entry_index);
+	return err;
 }
 
 void mlxsw_sp_kvdl_free(struct mlxsw_sp *mlxsw_sp,
@@ -59,8 +69,10 @@ void mlxsw_sp_kvdl_free(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_kvdl *kvdl = mlxsw_sp->kvdl;
 
+	mutex_lock(&kvdl->kvdl_lock);
 	kvdl->kvdl_ops->free(mlxsw_sp, kvdl->priv, type,
 			     entry_count, entry_index);
+	mutex_unlock(&kvdl->kvdl_lock);
 }
 
 int mlxsw_sp_kvdl_alloc_count_query(struct mlxsw_sp *mlxsw_sp,
-- 
2.24.1

