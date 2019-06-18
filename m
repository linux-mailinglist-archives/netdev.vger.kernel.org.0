Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F654A4E8
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfFRPNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34743 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729356AbfFRPNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 43D4A21FE5;
        Tue, 18 Jun 2019 11:13:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=iaTf9SzeK8+1O8trKFnON1Mt8b9IW1T8r37FBxOmXZU=; b=jUprLrC2
        rrC5JjgNsR9tnk7yA3TZ3vRCN7k64lPSSMJ9JlTNNgEzpLUoZXIxDdu4QxMjo6hl
        ajrLMyNY0aayP9BQ5UEpACWggSIRe7v7Luu4X1z1adjEIEvHOwHpWQ/uK67yga7J
        PtEoMlBYN1p+fL1SpRAT/8wz9WtNkvZ6DGHHVPuUfZpwlxYchvtwrJwPeYJZN3mV
        vYTwYaj8xHcjKu47NoXuwGfSVrGxceDW1uYcHqKv0v1pYt9oeybQIfyVcmVK5cZn
        nkTcvao/uhYMU4Z8rT5lSWb4Zv0YZ4KFecwGMnsZCDxFvDawNvbCd4QtzttCG9rV
        dI2aGpTcnk+LwQ==
X-ME-Sender: <xms:p_8IXSYDxNYDyyGP49hcgvljkz7AN7_-KlkZ1FjvD6jvG3GQyVPZYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepie
X-ME-Proxy: <xmx:p_8IXRPmgiSZOHgV_y0cHEdFaij_IG_-4KYeN7l9mx0puNj47K4Wdg>
    <xmx:p_8IXYVBRoL91fjol13lbwDrR8r3Oh1e9a-SY1In2VQ0Uo5Y6yNlag>
    <xmx:p_8IXeKgEYb-ae4YkA-v-9wM4qOfOgtVEWmwlxTVtRvN3iOsbC0xVg>
    <xmx:p_8IXSibtcRDOn-zxgHQIDRPBnd1_5Fy5KsfmW6kUPLvB_yVJWdM4A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7B952380087;
        Tue, 18 Jun 2019 11:13:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 10/16] mlxsw: spectrum_router: Pass multiple routes to work item
Date:   Tue, 18 Jun 2019 18:12:52 +0300
Message-Id: <20190618151258.23023-11-idosch@idosch.org>
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

Prepare the driver to process IPv6 multipath notifications by passing an
array of 'struct fib6_info' instead of just one route.

A reference is taken on each sibling route in order to prevent them from
being freed until they are processed by the workqueue.

v2:
* Remove 'multipath_rt' usage

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 72 +++++++++++++++++--
 1 file changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3e2e8be753a4..42e0e9677b91 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5893,10 +5893,15 @@ static void mlxsw_sp_router_fib_abort(struct mlxsw_sp *mlxsw_sp)
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to set abort trap.\n");
 }
 
+struct mlxsw_sp_fib6_event_work {
+	struct fib6_info **rt_arr;
+	unsigned int nrt6;
+};
+
 struct mlxsw_sp_fib_event_work {
 	struct work_struct work;
 	union {
-		struct fib6_entry_notifier_info fen6_info;
+		struct mlxsw_sp_fib6_event_work fib6_work;
 		struct fib_entry_notifier_info fen_info;
 		struct fib_rule_notifier_info fr_info;
 		struct fib_nh_notifier_info fnh_info;
@@ -5907,6 +5912,54 @@ struct mlxsw_sp_fib_event_work {
 	unsigned long event;
 };
 
+static int
+mlxsw_sp_router_fib6_work_init(struct mlxsw_sp_fib6_event_work *fib6_work,
+			       struct fib6_entry_notifier_info *fen6_info)
+{
+	struct fib6_info *rt = fen6_info->rt;
+	struct fib6_info **rt_arr;
+	struct fib6_info *iter;
+	unsigned int nrt6;
+	int i = 0;
+
+	nrt6 = fen6_info->nsiblings + 1;
+
+	rt_arr = kcalloc(nrt6, sizeof(struct fib6_info *), GFP_ATOMIC);
+	if (!rt_arr)
+		return -ENOMEM;
+
+	fib6_work->rt_arr = rt_arr;
+	fib6_work->nrt6 = nrt6;
+
+	rt_arr[0] = rt;
+	fib6_info_hold(rt);
+
+	if (!fen6_info->nsiblings)
+		return 0;
+
+	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
+		if (i == fen6_info->nsiblings)
+			break;
+
+		rt_arr[i + 1] = iter;
+		fib6_info_hold(iter);
+		i++;
+	}
+	WARN_ON_ONCE(i != fen6_info->nsiblings);
+
+	return 0;
+}
+
+static void
+mlxsw_sp_router_fib6_work_fini(struct mlxsw_sp_fib6_event_work *fib6_work)
+{
+	int i;
+
+	for (i = 0; i < fib6_work->nrt6; i++)
+		mlxsw_sp_rt6_release(fib6_work->rt_arr[i]);
+	kfree(fib6_work->rt_arr);
+}
+
 static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 {
 	struct mlxsw_sp_fib_event_work *fib_work =
@@ -5968,14 +6021,16 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	case FIB_EVENT_ENTRY_ADD:
 		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
 		err = mlxsw_sp_router_fib6_add(mlxsw_sp,
-					       fib_work->fen6_info.rt, replace);
+					       fib_work->fib6_work.rt_arr[0],
+					       replace);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
-		mlxsw_sp_rt6_release(fib_work->fen6_info.rt);
+		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib6_del(mlxsw_sp, fib_work->fen6_info.rt);
-		mlxsw_sp_rt6_release(fib_work->fen6_info.rt);
+		mlxsw_sp_router_fib6_del(mlxsw_sp,
+					 fib_work->fib6_work.rt_arr[0]);
+		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
 	case FIB_EVENT_RULE_ADD:
 		/* if we get here, a rule was added that we do not support.
@@ -6068,6 +6123,7 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 				      struct fib_notifier_info *info)
 {
 	struct fib6_entry_notifier_info *fen6_info;
+	int err;
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
@@ -6075,8 +6131,10 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 	case FIB_EVENT_ENTRY_DEL:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
 					 info);
-		fib_work->fen6_info = *fen6_info;
-		fib6_info_hold(fib_work->fen6_info.rt);
+		err = mlxsw_sp_router_fib6_work_init(&fib_work->fib6_work,
+						     fen6_info);
+		if (err)
+			return err;
 		break;
 	}
 
-- 
2.20.1

