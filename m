Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACF165830
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgBTHIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:08:31 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45883 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726777AbgBTHI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:08:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3FB0B2108A;
        Thu, 20 Feb 2020 02:08:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 20 Feb 2020 02:08:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=TXCvhTXLjw9tflMYri/JVhca5r4tdCo+smc6mSelpds=; b=jxr+JLOB
        6hihD9wjZ/mpEILLVkN3IpAs66xkqKDihEiWWZlw16ezjTSCpAYt4laApD24PExL
        Zg+ri51iHvmZSY/1UNYYam5IxKGDqJoTTNothlKBWJmZbYCsPzQs0MjSWGHe/izc
        VPUPMhja4xomW38wrVATZsvaghSbM8uMevoDgtp30eQPNeVROdomf4u2p9WfQPir
        pPA/NKK9ZjtuQ/Wr831L4fsaclzzNBVObaWgpD6xLlupfj4FtcGjo2bBFFu56akD
        8Y1GQZ43DaBeb0K58g+A9UZTnBK+3qtA4ae3mOvAH3BuJGWygh3ZLLNWtSvYe9tT
        2Y5ihSgGsvEEQQ==
X-ME-Sender: <xms:azBOXjlIC9j6kUvIKv85SsBWE9jeFkI2d4R7sz7M1KlzCEe4cSg4gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkedugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucevlhhushhtvg
    hrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:azBOXrHrYcPByhOZq3c_u1WxCEPlEjcmJdk4UqQ4svU5NvWTuiozmQ>
    <xmx:azBOXkpNSbGTQyyF0h4YRPNuBRc5_5D-jHSAix_UMmAm5EXSNfprNA>
    <xmx:azBOXv5t3dIJRcPw5dOh3rtgyEtuiCevzeL-lAub6l0RU6st1xbN-A>
    <xmx:azBOXkUezgqwaP3qL14VSWEvo1ICtpQPxxVsBRZeMEVQrbYYHN8b_w>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22E5A3060C21;
        Thu, 20 Feb 2020 02:08:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/15] mlxsw: spectrum: Convert callers to use new mirroring API
Date:   Thu, 20 Feb 2020 09:07:51 +0200
Message-Id: <20200220070800.364235-7-idosch@idosch.org>
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

Previous patch added a work item in the mirroring code that will take
care of updating the active mirroring agents in response to different
events.

Change the mirroring agents update function - mlxsw_sp_span_respin() -
to invoke this work item when called.

Therefore there is no need for callers to schedule a work item
themselves.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 29 +++-------------
 .../mellanox/mlxsw/spectrum_switchdev.c       | 34 ++-----------------
 2 files changed, 7 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 24fd42d79607..f7079f9e8d19 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1002,30 +1002,6 @@ void mlxsw_sp_span_mirror_del(struct mlxsw_sp_port *from, int span_id,
 	mlxsw_sp_span_inspected_port_del(from, span_entry, type, bind);
 }
 
-void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
-{
-	int i;
-	int err;
-
-	ASSERT_RTNL();
-	for (i = 0; i < mlxsw_sp->span->entries_count; i++) {
-		struct mlxsw_sp_span_entry *curr = &mlxsw_sp->span->entries[i];
-		struct mlxsw_sp_span_parms sparms = {NULL};
-
-		if (!curr->ref_count)
-			continue;
-
-		err = curr->ops->parms(curr->to_dev, &sparms);
-		if (err)
-			continue;
-
-		if (memcmp(&sparms, &curr->parms, sizeof(sparms))) {
-			mlxsw_sp_span_entry_deconfigure(curr);
-			mlxsw_sp_span_entry_configure(mlxsw_sp, curr, sparms);
-		}
-	}
-}
-
 static void mlxsw_sp_span_respin_work(struct work_struct *work)
 {
 	struct mlxsw_sp_span *span;
@@ -1054,3 +1030,8 @@ static void mlxsw_sp_span_respin_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 }
+
+void mlxsw_sp_span_respin(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_core_schedule_work(&mlxsw_sp->span->work);
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 6213fa43aa7b..d70865f29105 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1778,36 +1778,6 @@ mlxsw_sp_port_mrouter_update_mdb(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
-struct mlxsw_sp_span_respin_work {
-	struct work_struct work;
-	struct mlxsw_sp *mlxsw_sp;
-};
-
-static void mlxsw_sp_span_respin_work(struct work_struct *work)
-{
-	struct mlxsw_sp_span_respin_work *respin_work =
-		container_of(work, struct mlxsw_sp_span_respin_work, work);
-
-	rtnl_lock();
-	mlxsw_sp_span_respin(respin_work->mlxsw_sp);
-	rtnl_unlock();
-	kfree(respin_work);
-}
-
-static void mlxsw_sp_span_respin_schedule(struct mlxsw_sp *mlxsw_sp)
-{
-	struct mlxsw_sp_span_respin_work *respin_work;
-
-	respin_work = kzalloc(sizeof(*respin_work), GFP_ATOMIC);
-	if (!respin_work)
-		return;
-
-	INIT_WORK(&respin_work->work, mlxsw_sp_span_respin_work);
-	respin_work->mlxsw_sp = mlxsw_sp;
-
-	mlxsw_core_schedule_work(&respin_work->work);
-}
-
 static int mlxsw_sp_port_obj_add(struct net_device *dev,
 				 const struct switchdev_obj *obj,
 				 struct switchdev_trans *trans,
@@ -1829,7 +1799,7 @@ static int mlxsw_sp_port_obj_add(struct net_device *dev,
 			 * call for later, so that the respin logic sees the
 			 * updated bridge state.
 			 */
-			mlxsw_sp_span_respin_schedule(mlxsw_sp_port->mlxsw_sp);
+			mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
 		}
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_MDB:
@@ -1982,7 +1952,7 @@ static int mlxsw_sp_port_obj_del(struct net_device *dev,
 		break;
 	}
 
-	mlxsw_sp_span_respin_schedule(mlxsw_sp_port->mlxsw_sp);
+	mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
 
 	return err;
 }
-- 
2.24.1

