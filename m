Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3931685AC
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 18:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgBURzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 12:55:00 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58039 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729270AbgBURyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 12:54:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C97272208A;
        Fri, 21 Feb 2020 12:54:53 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 21 Feb 2020 12:54:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Tp0IXEyaWOCM/y6Sn6yddzROg+bePF8U7+i0/3GV7hw=; b=kIkOs6hn
        ziGi2YcKIoQ8QbXXDqOncvDQwlLdbEJyVlrocg/wsYwI09NRQQMH5BFHIFg1VRS5
        bpBZH1uKojEWG+UdJp3/XqMV127YOOxFMTdeQJKEiFnksMvzR48rzGamCaFp82Oy
        yPVxvGYEB/j41AVs8FdLOk+c1Ab5Vav/DtvU0/1DlVxCGud8ZyPqE4sGZ8+E5FRQ
        XTCy9G6bBVJB8pVA0VwFpGQto+cJBzVI9mK2D4HoJRXBvNE0DUD/K2Srt0icn4Pj
        0Kh1p7Bva348WhmoRUfDQI6xZs4ERMap+ghHN7B+ip0p616k8yLGgMGQUqaFxNdU
        4/SmlweN0pKtlw==
X-ME-Sender: <xms:bRlQXvZLpir8EcBj3bsfeGSn8mcBD89elGS3PB-_EAAj8fcUpMh6HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedruddvrdehvdenucevlhhushhtvghruf
    hiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:bRlQXqtIgK0pQoduxR4ntSx54tuKnd707J_eXJoFNHCjmI_HdiccMw>
    <xmx:bRlQXkuci3euNc3rFEdWZK_6M_Zyo0PaV8IZWO-idIMFzrny5sj9MA>
    <xmx:bRlQXneNlEwmd6nDqfYrMxr79Kca3XoxrbNqLhcUysJ2K0G6kP5WMw>
    <xmx:bRlQXqq0Zai7V7YepGZLPExoa6YIcGHxrpaeKpCGpsSSOfc5MymRJg>
Received: from localhost.localdomain (bzq-109-66-12-52.red.bezeqint.net [109.66.12.52])
        by mail.messagingengine.com (Postfix) with ESMTPA id 499613060F09;
        Fri, 21 Feb 2020 12:54:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/12] mlxsw: spectrum_router: Take router lock from inside routing code
Date:   Fri, 21 Feb 2020 19:54:10 +0200
Message-Id: <20200221175415.390884-8-idosch@idosch.org>
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

There are several work items in the routing code that currently rely on
RTNL lock to guard against concurrent changes. Have these work items
acquire the router lock in preparation for the removal for RTNL lock
from the routing code.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e2ddb6164f6c..601fa4a1abbb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2278,10 +2278,9 @@ __mlxsw_sp_router_neighs_update_rauhtd(struct mlxsw_sp *mlxsw_sp,
 	int i, num_rec;
 	int err;
 
-	/* Make sure the neighbour's netdev isn't removed in the
-	 * process.
-	 */
 	rtnl_lock();
+	/* Ensure the RIF we read from the device does not change mid-dump. */
+	mutex_lock(&mlxsw_sp->router->lock);
 	do {
 		mlxsw_reg_rauhtd_pack(rauhtd_pl, type);
 		err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(rauhtd),
@@ -2295,6 +2294,7 @@ __mlxsw_sp_router_neighs_update_rauhtd(struct mlxsw_sp *mlxsw_sp,
 			mlxsw_sp_router_neigh_rec_process(mlxsw_sp, rauhtd_pl,
 							  i);
 	} while (mlxsw_sp_router_rauhtd_is_full(rauhtd_pl));
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 
 	return err;
@@ -2326,14 +2326,15 @@ static void mlxsw_sp_router_neighs_update_nh(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_neigh_entry *neigh_entry;
 
-	/* Take RTNL mutex here to prevent lists from changes */
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	list_for_each_entry(neigh_entry, &mlxsw_sp->router->nexthop_neighs_list,
 			    nexthop_neighs_list_node)
 		/* If this neigh have nexthops, make the kernel think this neigh
 		 * is active regardless of the traffic.
 		 */
 		neigh_event_send(neigh_entry->key.n, NULL);
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 }
 
@@ -2374,14 +2375,14 @@ static void mlxsw_sp_router_probe_unresolved_nexthops(struct work_struct *work)
 	 * the nexthop wouldn't get offloaded until the neighbor is resolved
 	 * but it wouldn't get resolved ever in case traffic is flowing in HW
 	 * using different nexthop.
-	 *
-	 * Take RTNL mutex here to prevent lists from changes.
 	 */
 	rtnl_lock();
+	mutex_lock(&router->lock);
 	list_for_each_entry(neigh_entry, &router->nexthop_neighs_list,
 			    nexthop_neighs_list_node)
 		if (!neigh_entry->connected)
 			neigh_event_send(neigh_entry->key.n, NULL);
+	mutex_unlock(&router->lock);
 	rtnl_unlock();
 
 	mlxsw_core_schedule_dw(&router->nexthop_probe_dw,
@@ -2521,6 +2522,7 @@ static void mlxsw_sp_router_neigh_event_work(struct work_struct *work)
 	read_unlock_bh(&n->lock);
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	entry_connected = nud_state & NUD_VALID && !dead;
@@ -2542,6 +2544,7 @@ static void mlxsw_sp_router_neigh_event_work(struct work_struct *work)
 		mlxsw_sp_neigh_entry_destroy(mlxsw_sp, neigh_entry);
 
 out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	neigh_release(n);
 	kfree(net_work);
@@ -5949,8 +5952,8 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
-	/* Protect internal structures from changes */
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
@@ -5972,6 +5975,7 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 		fib_info_put(fib_work->fnh_info.fib_nh->nh_parent);
 		break;
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	kfree(fib_work);
 }
@@ -5984,6 +5988,7 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	int err;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
@@ -6010,6 +6015,7 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	kfree(fib_work);
 }
@@ -6023,6 +6029,7 @@ static void mlxsw_sp_router_fibmr_event_work(struct work_struct *work)
 	int err;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
 	case FIB_EVENT_ENTRY_ADD:
@@ -6051,6 +6058,7 @@ static void mlxsw_sp_router_fibmr_event_work(struct work_struct *work)
 		dev_put(fib_work->ven_info.dev);
 		break;
 	}
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	kfree(fib_work);
 }
@@ -7063,6 +7071,7 @@ static void mlxsw_sp_inet6addr_event_work(struct work_struct *work)
 	struct mlxsw_sp_rif *rif;
 
 	rtnl_lock();
+	mutex_lock(&mlxsw_sp->router->lock);
 
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!mlxsw_sp_rif_should_config(rif, dev, event))
@@ -7070,6 +7079,7 @@ static void mlxsw_sp_inet6addr_event_work(struct work_struct *work)
 
 	__mlxsw_sp_inetaddr_event(mlxsw_sp, dev, event, NULL);
 out:
+	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
 	dev_put(dev);
 	kfree(inet6addr_work);
-- 
2.24.1

