Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978CA165837
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgBTHIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:32 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50027 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726735AbgBTHI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id ED86B21E62;
        Thu, 20 Feb 2020 02:08:25 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5rNvXG1ZCyKlGHwL5Gk8LpJit5fcbTj6wTeYH7EsuH4=; b=k9c1ON2g
        U3OH7BmYLf0hO9dnj7Yq43RNCMKqT2VM0ALNG2E+wssiWph/t6/0ykEPI2G/qSVW
        sRZ/ZiO5X3f5lfereY2yXJnGIDJzUyEt5iBUaSSbafy1ETDITPySbP1Vrldx8FUD
        KygiAda16sPJztVnHp4Uz4Bu91siatHn7aPb7WNRBGfB8RHtmf9sGYsubnz/stqx
        n9i6bH6oDWRkdn6aqJnBu1gPDaoFpR8c8xNwfdY5oZFyiuCmQ4KGOig16q3QvTF0
        7W+OUej+ovMyxyn7kfvJIutlYtnmlddYE1OSPErw3H13JyVcKCJgs5p1hg5N266q
        vFulTUm0SbPJ4w==
X-ME-Sender: <xms:aTBOXlacc_jtMlmRBWWTaPaAhmcuv__znMUqeBG-12BIRyE-QLwEXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:aTBOXgwOSCODYxQWsd2f2PQY-8_5U_ERmoev76TLtI4X6fzgDM3Hrw>
    <xmx:aTBOXl0AC1Ai1-Xaw4HdoaaRObDbNVuu5GeW4u1IJTa8di7arwojXA>
    <xmx:aTBOXhlMSTl8PPQzxZ-pjLsXyuE0NxImy2SQDwrjqSzKgp6AUiOfGg>
    <xmx:aTBOXqNTaLA7f-12iucrDWlTdsE-JOqAkBrQ7gRTOyIgi86gh15Zow>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E43BE3060C21;
        Thu, 20 Feb 2020 02:08:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/15] mlxsw: spectrum_span: Prepare work item to update mirroring agents
Date:   Thu, 20 Feb 2020 09:07:50 +0200
Message-Id: <20200220070800.364235-6-idosch@idosch.org>
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

The driver updates its mirroring agents whenever it receives a
notification about an event that can affect these. For example, the
addition of a route might require the driver to change the egress port
of an ERSPAN session.

Currently, RTNL needs to be held when these agents are updates, so the
driver either:

1. Calls directly into the mirroring code, in case RTNL is held

2. Schedules a work item that will take RTNL and call into the mirroring
code

Simplify this by having the mirroring code schedule the work item for
the update instead of requiring callers to schedule a work item
themselves.

The conversion of the callers will be done in the next patch to make
review easier.

This will later allow us to remove RTNL from different parts of the
driver. It will also allow us to only schedule the work item in case
there are active mirroring agents, which is information private to the
mirroring code.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index aeb28486635c..24fd42d79607 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -3,6 +3,8 @@
 
 #include <linux/if_bridge.h>
 #include <linux/list.h>
+#include <linux/rtnetlink.h>
+#include <linux/workqueue.h>
 #include <net/arp.h>
 #include <net/gre.h>
 #include <net/lag.h>
@@ -15,10 +17,14 @@
 #include "spectrum_switchdev.h"
 
 struct mlxsw_sp_span {
+	struct work_struct work;
+	struct mlxsw_sp *mlxsw_sp;
 	int entries_count;
 	struct mlxsw_sp_span_entry entries[0];
 };
 
+static void mlxsw_sp_span_respin_work(struct work_struct *work);
+
 static u64 mlxsw_sp_span_occ_get(void *priv)
 {
 	const struct mlxsw_sp *mlxsw_sp = priv;
@@ -47,6 +53,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	if (!span)
 		return -ENOMEM;
 	span->entries_count = entries_count;
+	span->mlxsw_sp = mlxsw_sp;
 	mlxsw_sp->span = span;
 
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
@@ -58,6 +65,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 
 	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
 					  mlxsw_sp_span_occ_get, mlxsw_sp);
+	INIT_WORK(&span->work, mlxsw_sp_span_respin_work);
 
 	return 0;
 }
@@ -67,6 +75,7 @@ void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
+	cancel_work_sync(&mlxsw_sp->span->work);
 	devlink_resource_occ_get_unregister(devlink, MLXSW_SP_RESOURCE_SPAN);
 
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
@@ -1016,3 +1025,32 @@ void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
 		}
 	}
 }
+
+static void mlxsw_sp_span_respin_work(struct work_struct *work)
+{
+	struct mlxsw_sp_span *span;
+	struct mlxsw_sp *mlxsw_sp;
+	int i, err;
+
+	span = container_of(work, struct mlxsw_sp_span, work);
+	mlxsw_sp = span->mlxsw_sp;
+
+	rtnl_lock();
+	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
+		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
+		struct mlxsw_sp_span_parms sparms = {NULL};
+
+		if (!curr->ref_count)
+			continue;
+
+		err = curr->ops->parms(curr->to_dev, &sparms);
+		if (err)
+			continue;
+
+		if (memcmp(&sparms, &curr->parms, sizeof(sparms))) {
+			mlxsw_sp_span_entry_deconfigure(curr);
+			mlxsw_sp_span_entry_configure(mlxsw_sp, curr, sparms);
+		}
+	}
+	rtnl_unlock();
+}
-- 
2.24.1

