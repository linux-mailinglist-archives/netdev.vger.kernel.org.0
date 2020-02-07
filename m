Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCDC4155CC9
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgBGR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:27:14 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47073 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgBGR1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:27:13 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C5CFE21F83;
        Fri,  7 Feb 2020 12:27:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=A/1S5STyl4Zz/cs3cXUiPh7qONIDaUVFq5+J1XfVoio=; b=pVBcmpi1
        ILI518Z28kHPKMjOm+8fR3PHw4LumxxtAhUzOxs4P0jFwr8HHpQlF3+8B5wrDmcA
        Gw0yEkKvn+rRhAosHa1K04Nz+APVz5B1zsqSMm8TqmUxnkLeoxcQDwaYGFGMYXwu
        112BAATreRL0RpqDUMu2zu0cdZp54Kxe5DDpCziK/b+tfXbaTt+eZgrwa15zTISp
        ++tpM/c2f5mr4Pgm8Iruz/UGcbuJ8qh9e8Kl0lsRLwltMDzdB0hZGvv/MBsgkVtq
        aylHYrM9wABl0BIcoSD+pTtp5lwkboxQ7nLrF+TOM+f20KR4/Czl/K4K7U1kxEib
        PFEaYIGpKQYWuw==
X-ME-Sender: <xms:8J09XpA5sET9gJSQYR47_otolrGOIze1aVHuDVLir06o8pTPHdZ6KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudekfedruddtjedruddvtdenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:8J09Xos1o8DlBvVhj_xezy-cj1h7OIB6NDt7EBR7pvjhYCzHgRrZew>
    <xmx:8J09XlCYd3IjWsOXZmGotRQCAaBLUW_fBiGHdK_0di6RH6tC08y9iQ>
    <xmx:8J09XtI9z3XtJmxb5cSeLqpQpvQbrboUCNfZ8HWgiS5Q1-pNG_4XSQ>
    <xmx:8J09XvG0i4wH7Hxgzb_2KUcBZF5H7sVqe1E_mlCbLHdCKMhcFF-ntg>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6233A30606FB;
        Fri,  7 Feb 2020 12:27:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 1/5] mlxsw: spectrum_router: Prevent incorrect replacement of local table routes
Date:   Fri,  7 Feb 2020 19:26:24 +0200
Message-Id: <20200207172628.128763-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207172628.128763-1-idosch@idosch.org>
References: <20200207172628.128763-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The driver uses the same table to represent both the main and local
routing tables. Prevent routes in the main table from replacing routes
in the local table to reflect the fact that the local table is consulted
first during lookup.

Fixes: b6a1d871d37a ("mlxsw: spectrum_router: Start using new IPv4 route notifications")
Fixes: dacad7b34b59 ("mlxsw: spectrum_router: Start using new IPv6 route notifications")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 52 ++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ce707723f8cf..f8b3869672c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4844,6 +4844,23 @@ mlxsw_sp_fib_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 	fib_node->fib_entry = NULL;
 }
 
+static bool mlxsw_sp_fib4_allow_replace(struct mlxsw_sp_fib4_entry *fib4_entry)
+{
+	struct mlxsw_sp_fib_node *fib_node = fib4_entry->common.fib_node;
+	struct mlxsw_sp_fib4_entry *fib4_replaced;
+
+	if (!fib_node->fib_entry)
+		return true;
+
+	fib4_replaced = container_of(fib_node->fib_entry,
+				     struct mlxsw_sp_fib4_entry, common);
+	if (fib4_entry->tb_id == RT_TABLE_MAIN &&
+	    fib4_replaced->tb_id == RT_TABLE_LOCAL)
+		return false;
+
+	return true;
+}
+
 static int
 mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 			     const struct fib_entry_notifier_info *fen_info)
@@ -4872,6 +4889,12 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib4_entry_create;
 	}
 
+	if (!mlxsw_sp_fib4_allow_replace(fib4_entry)) {
+		mlxsw_sp_fib4_entry_destroy(mlxsw_sp, fib4_entry);
+		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+		return 0;
+	}
+
 	replaced = fib_node->fib_entry;
 	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib4_entry->common);
 	if (err) {
@@ -4908,7 +4931,7 @@ static void mlxsw_sp_router_fib4_del(struct mlxsw_sp *mlxsw_sp,
 		return;
 
 	fib4_entry = mlxsw_sp_fib4_entry_lookup(mlxsw_sp, fen_info);
-	if (WARN_ON(!fib4_entry))
+	if (!fib4_entry)
 		return;
 	fib_node = fib4_entry->common.fib_node;
 
@@ -5408,6 +5431,27 @@ mlxsw_sp_fib6_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	return NULL;
 }
 
+static bool mlxsw_sp_fib6_allow_replace(struct mlxsw_sp_fib6_entry *fib6_entry)
+{
+	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
+	struct mlxsw_sp_fib6_entry *fib6_replaced;
+	struct fib6_info *rt, *rt_replaced;
+
+	if (!fib_node->fib_entry)
+		return true;
+
+	fib6_replaced = container_of(fib_node->fib_entry,
+				     struct mlxsw_sp_fib6_entry,
+				     common);
+	rt = mlxsw_sp_fib6_entry_rt(fib6_entry);
+	rt_replaced = mlxsw_sp_fib6_entry_rt(fib6_replaced);
+	if (rt->fib6_table->tb6_id == RT_TABLE_MAIN &&
+	    rt_replaced->fib6_table->tb6_id == RT_TABLE_LOCAL)
+		return false;
+
+	return true;
+}
+
 static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 					struct fib6_info **rt_arr,
 					unsigned int nrt6)
@@ -5442,6 +5486,12 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 		goto err_fib6_entry_create;
 	}
 
+	if (!mlxsw_sp_fib6_allow_replace(fib6_entry)) {
+		mlxsw_sp_fib6_entry_destroy(mlxsw_sp, fib6_entry);
+		mlxsw_sp_fib_node_put(mlxsw_sp, fib_node);
+		return 0;
+	}
+
 	replaced = fib_node->fib_entry;
 	err = mlxsw_sp_fib_node_entry_link(mlxsw_sp, &fib6_entry->common);
 	if (err)
-- 
2.24.1

