Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5331685A9
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgBURyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:54:54 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51847 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726955AbgBURyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:53 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 112DF21B2B;
        Fri, 21 Feb 2020 12:54:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=T5eCvlf4x7+CCsvQCUeh001YVeUxO1M4+N4Ic3qI92w=; b=RK7EAwZx
        aOoJ0WdBdRhLw7kqN7V7kw5lcRfmN/cWt0L1r34DymEAo+kaa18zNHh/OAvId3TD
        sAyjRhPwPsuhn8cY+uiBLJc4hn7R75yjfBehmLz2COMBta2jGVOSEyOoXXLFcp6L
        ZAn8VYJ/BzEJT/01VpITHyw+veFZskPbT28QZx+gIvnPBOEh/1JLITl/qs/B2fyq
        ugG9ANshU+ZP1Zz3te+AEF6N1oX+sV9+X5F2wuoxeW6h9jvDZf12xvEyOryMfgyn
        hJ26CLgCML6Pi6bGjXfa2/9tcDH3aeW73x3xto19Lhqd+bHJRQkFSWntWoyaJRi8
        TRtIvZakWX/oWg==
X-ME-Sender: <xms:axlQXqgOWVA-NloYAG5sApEF3Q2Oq-vU5NXepcnVozverra8laL7_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:axlQXnC36Jh7v0D8_5MaBCpersIbdFa33wiHStgePY61oy-uEFk6EQ>
    <xmx:axlQXkt-2Iv-nOnN67D4HCjA14oLZiMWH_Xm6jvryVrpCpZ5Emrd_g>
    <xmx:axlQXhfwCrVNFoLQ_W2JD-yMhHy6a_M9FxCcGyBe1bkEZjP1aeaLVw>
    <xmx:bBlQXnaBXIYaPx3NX0MD5Om3yKElkOnuP2_mTSb_3Or6r6CbF6dHMQ>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8AEF33060F09;
        Fri, 21 Feb 2020 12:54:50 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/12] mlxsw: spectrum_router: Introduce router lock
Date:   Fri, 21 Feb 2020 19:54:09 +0200
Message-Id: <20200221175415.390884-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221175415.390884-1-idosch@idosch.org>
References: <20200221175415.390884-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Introduce a mutex to protect the internal structure of the routing code.
A single lock is added instead of a more fine-grained and complicated
locking scheme because there is not a lot of concurrency in the routing
code.

The main motivation is remove the dependence on RTNL lock, which is
currently used by both the process pushing routes to the kernel and the
workqueue pushing the routes to the underlying device.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index fe8c1f386651..e2ddb6164f6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -17,6 +17,7 @@
 #include <linux/refcount.h>
 #include <linux/jhash.h>
 #include <linux/net_namespace.h>
+#include <linux/mutex.h>
 #include <net/netevent.h>
 #include <net/neighbour.h>
 #include <net/arp.h>
@@ -8065,6 +8066,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	router = kzalloc(sizeof(*mlxsw_sp->router), GFP_KERNEL);
 	if (!router)
 		return -ENOMEM;
+	mutex_init(&router->lock);
 	mlxsw_sp->router = router;
 	router->mlxsw_sp = mlxsw_sp;
 
@@ -8168,6 +8170,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_register_inet6addr_notifier:
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
+	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 	return err;
 }
@@ -8188,5 +8191,6 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	__mlxsw_sp_router_fini(mlxsw_sp);
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
+	mutex_destroy(&mlxsw_sp->router->lock);
 	kfree(mlxsw_sp->router);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 3c99db1f434b..8418dc3ae967 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -47,6 +47,7 @@ struct mlxsw_sp_router {
 	u32 adj_discard_index;
 	bool adj_discard_index_valid;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
+	struct mutex lock; /* Protects shared router resources */
 };
 
 struct mlxsw_sp_rif_ipip_lb;
-- 
2.24.1

