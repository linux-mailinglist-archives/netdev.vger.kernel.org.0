Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A120812AD8D
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfLZQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:42:03 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35979 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbfLZQmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 11:42:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 23F1D21BBA;
        Thu, 26 Dec 2019 11:41:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 11:41:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=OZfBNKFn7/Du2cai+kHIkVgxSI5gmV9BuJtjiz1qQVU=; b=C8CiqMhf
        dH7YjkFq/oAWIzEW0YoRvPVi44FJkmIlLe6FVKFhxArthlaokRfvblfBSPkTp2t4
        vUF3JRquH8FW30v8ZQOpCmH99oHjzeoLw4LdR8v+bsg/KgSTjblXHLZVoVZkXyDz
        QKWU5Qo/W8BVhfqfaGMZeGfH0A92X6BwJXX4h+Q6SKHSXLRvGimUYCJUE5PYFLop
        KUn/SLZnbL9RacC7Ut+opU9WsohdZ0J4JRZh45IfU7FekPJ2Ad7rsW6KJLPcFAXj
        tKnQJZZ8MuN4wLYTQZtlbYxSYLUrHZhJeegrYl2uwEX11i1PmPPc9t8D8mtbpg54
        D8ug9hzU33zBgg==
X-ME-Sender: <xms:1-IEXhPjtYtE4g6WMMRX3IywpnKHcr6tXpR8vP0vNTF3QmwC_vE2aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:1-IEXldd2njAf9yjcsaOhrkvhGeRLBK8fNERl-EBTsIfEXPn0bNiKA>
    <xmx:1-IEXt7Ar0W-fKXnFBS5PpLmfwyqfloVBI7VQGXpiGbRraa7_mDx3Q>
    <xmx:1-IEXlJFhPAqQDmldj4H7ExRZamJi0pq3bwynUaRoQj-mKsZf3kGTw>
    <xmx:1-IEXvIDY4hqWFe2V_1lo3ZVJVygCNMv_k9rIy3JOpKGekBVGpn9cw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13CFF306080E;
        Thu, 26 Dec 2019 11:41:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] mlxsw: spectrum_router: Make route creation and destruction symmetric
Date:   Thu, 26 Dec 2019 18:41:15 +0200
Message-Id: <20191226164117.53794-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191226164117.53794-1-idosch@idosch.org>
References: <20191226164117.53794-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Host routes that perform decapsulation of IP in IP tunnels have a
special adjacency entry linked to them. This entry stores information
such as the expected underlay source IP. When the route is deleted this
entry needs to be freed.

The allocation of the adjacency entry happens in
mlxsw_sp_fib4_entry_type_set(), but it is freed in
mlxsw_sp_fib4_node_entry_unlink().

Create a new function - mlxsw_sp_fib4_entry_type_unset() - and free the
adjacency entry there.

This will allow us to consolidate mlxsw_sp_fib{4,6}_node_entry_unlink()
in the next patch.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0439b2399a53..940832761d1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4480,6 +4480,19 @@ mlxsw_sp_fib4_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
+static void
+mlxsw_sp_fib4_entry_type_unset(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib_entry *fib_entry)
+{
+	switch (fib_entry->type) {
+	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
+		mlxsw_sp_fib_entry_decap_fini(mlxsw_sp, fib_entry);
+		break;
+	default:
+		break;
+	}
+}
+
 static struct mlxsw_sp_fib4_entry *
 mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_fib_node *fib_node,
@@ -4512,6 +4525,7 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 	return fib4_entry;
 
 err_nexthop4_group_get:
+	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, fib_entry);
 err_fib4_entry_type_set:
 	kfree(fib4_entry);
 	return ERR_PTR(err);
@@ -4521,6 +4535,7 @@ static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib4_entry *fib4_entry)
 {
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
+	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, &fib4_entry->common);
 	kfree(fib4_entry);
 }
 
@@ -4823,9 +4838,6 @@ mlxsw_sp_fib4_node_entry_unlink(struct mlxsw_sp *mlxsw_sp,
 {
 	mlxsw_sp_fib_node_entry_del(mlxsw_sp, &fib4_entry->common);
 	list_del(&fib4_entry->common.list);
-
-	if (fib4_entry->common.type == MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP)
-		mlxsw_sp_fib_entry_decap_fini(mlxsw_sp, &fib4_entry->common);
 }
 
 static void mlxsw_sp_fib4_entry_replace(struct mlxsw_sp *mlxsw_sp,
-- 
2.24.1

