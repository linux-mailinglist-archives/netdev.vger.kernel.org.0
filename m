Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683DD2AD2C5
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbgKJJuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:24 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:32903 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:22 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4A864DC3;
        Tue, 10 Nov 2020 04:50:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EQHth6un5efC5qwZJi9VVNI4h01Eok8xyjyLy2ak478=; b=I/v/4JgK
        9GwXf+iBsjMEwyGAUeZEe1iE5cIkRTmml/5M4iG6MNzfA9teQmpGiE9JzTlazacT
        6wOqUiC0CbIKakBfL1aHg+6E2gClVZtl0ycemBlHGyXw/69h1YA/qSOP6PLRaB0t
        qoczweWyTbIeArR7TnO/Yxh5Jbzze5jNMxf6qx5v7UqPC/RRg5Zf7QQFZDwKhClV
        jvMdeEJnIJmBhFWZwJOQrzYghaBEwHkP+r7IqSPAYu2aCToaZtj9PfSgILrC/Uub
        jC5tEp4ZFp5BMXw9il7L4sN3hPZlH/wYGVp02hpld7xyHM1tKC+SewMviJ7S9ShS
        Ly1E/cPTzQROmw==
X-ME-Sender: <xms:XGKqXwj_fNmtvwF5_vHuduM8CQ9F4MbdR1_fqJ9uG8mUao6qrx2PqA>
    <xme:XGKqX5DirzrBR_cTTIrKNjJu0-QDbfz57YRr4qeYlqMeJIPUy_nsATuuyGTIeUtlX
    rDbtSTVgLkLiro>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XGKqX4EvkbZemIsZ0xG_7vWwjjLYUg9eS6X2FG7XU8bkHaZFqC87tw>
    <xmx:XGKqXxSMThoJatQ8oWpsXii4pC1HK_3k4gDjHgDRy2ZmNoGPBw8OWg>
    <xmx:XGKqX9xg_3vitdZi_z5viB-7FUkI7RVke2osPzYjA6jgth5YvJZs8g>
    <xmx:XGKqX48tq_moo2-U5CZuTcFJM_dY56EEZwpfDrl6Rep0jFYr3TKGBw>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id A27493280069;
        Tue, 10 Nov 2020 04:50:19 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/15] mlxsw: spectrum_router: Introduce FIB event queue instead of separate works
Date:   Tue, 10 Nov 2020 11:48:48 +0200
Message-Id: <20201110094900.1920158-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, every FIB event is queued-up as a separate work to be
processed. However, that allows to process only one FIB entry per work
callback.

In preparation of future XMDR register bulking of multiple FIB entries,
convert to FIB event queue. Implement this by a list_head, adding new
events to the end of the list in the FIB notify callback. That allows to
process multiple events from the list inside the work callback.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 207 ++++++++++--------
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   3 +
 2 files changed, 119 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d916f1045d97..99777d190e6d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5945,15 +5945,15 @@ static void mlxsw_sp_router_fib_abort(struct mlxsw_sp *mlxsw_sp)
 		dev_warn(mlxsw_sp->bus_info->dev, "Failed to set abort trap.\n");
 }
 
-struct mlxsw_sp_fib6_event_work {
+struct mlxsw_sp_fib6_event {
 	struct fib6_info **rt_arr;
 	unsigned int nrt6;
 };
 
-struct mlxsw_sp_fib_event_work {
-	struct work_struct work;
+struct mlxsw_sp_fib_event {
+	struct list_head list; /* node in fib queue */
 	union {
-		struct mlxsw_sp_fib6_event_work fib6_work;
+		struct mlxsw_sp_fib6_event fib6_event;
 		struct fib_entry_notifier_info fen_info;
 		struct fib_rule_notifier_info fr_info;
 		struct fib_nh_notifier_info fnh_info;
@@ -5962,11 +5962,12 @@ struct mlxsw_sp_fib_event_work {
 	};
 	struct mlxsw_sp *mlxsw_sp;
 	unsigned long event;
+	int family;
 };
 
 static int
-mlxsw_sp_router_fib6_work_init(struct mlxsw_sp_fib6_event_work *fib6_work,
-			       struct fib6_entry_notifier_info *fen6_info)
+mlxsw_sp_router_fib6_event_init(struct mlxsw_sp_fib6_event *fib6_event,
+				struct fib6_entry_notifier_info *fen6_info)
 {
 	struct fib6_info *rt = fen6_info->rt;
 	struct fib6_info **rt_arr;
@@ -5980,8 +5981,8 @@ mlxsw_sp_router_fib6_work_init(struct mlxsw_sp_fib6_event_work *fib6_work,
 	if (!rt_arr)
 		return -ENOMEM;
 
-	fib6_work->rt_arr = rt_arr;
-	fib6_work->nrt6 = nrt6;
+	fib6_event->rt_arr = rt_arr;
+	fib6_event->nrt6 = nrt6;
 
 	rt_arr[0] = rt;
 	fib6_info_hold(rt);
@@ -6003,170 +6004,186 @@ mlxsw_sp_router_fib6_work_init(struct mlxsw_sp_fib6_event_work *fib6_work,
 }
 
 static void
-mlxsw_sp_router_fib6_work_fini(struct mlxsw_sp_fib6_event_work *fib6_work)
+mlxsw_sp_router_fib6_event_fini(struct mlxsw_sp_fib6_event *fib6_event)
 {
 	int i;
 
-	for (i = 0; i < fib6_work->nrt6; i++)
-		mlxsw_sp_rt6_release(fib6_work->rt_arr[i]);
-	kfree(fib6_work->rt_arr);
+	for (i = 0; i < fib6_event->nrt6; i++)
+		mlxsw_sp_rt6_release(fib6_event->rt_arr[i]);
+	kfree(fib6_event->rt_arr);
 }
 
-static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
+static void mlxsw_sp_router_fib4_event_process(struct mlxsw_sp *mlxsw_sp,
+					       struct mlxsw_sp_fib_event *fib_event)
 {
-	struct mlxsw_sp_fib_event_work *fib_work =
-		container_of(work, struct mlxsw_sp_fib_event_work, work);
-	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
 	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
-	switch (fib_work->event) {
+	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = mlxsw_sp_router_fib4_replace(mlxsw_sp,
-						   &fib_work->fen_info);
+		err = mlxsw_sp_router_fib4_replace(mlxsw_sp, &fib_event->fen_info);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
-		fib_info_put(fib_work->fen_info.fi);
+		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_work->fen_info);
-		fib_info_put(fib_work->fen_info.fi);
+		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_event->fen_info);
+		fib_info_put(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
-		mlxsw_sp_nexthop4_event(mlxsw_sp, fib_work->event,
-					fib_work->fnh_info.fib_nh);
-		fib_info_put(fib_work->fnh_info.fib_nh->nh_parent);
+		mlxsw_sp_nexthop4_event(mlxsw_sp, fib_event->event, fib_event->fnh_info.fib_nh);
+		fib_info_put(fib_event->fnh_info.fib_nh->nh_parent);
 		break;
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	kfree(fib_work);
 }
 
-static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
+static void mlxsw_sp_router_fib6_event_process(struct mlxsw_sp *mlxsw_sp,
+					       struct mlxsw_sp_fib_event *fib_event)
 {
-	struct mlxsw_sp_fib_event_work *fib_work =
-		container_of(work, struct mlxsw_sp_fib_event_work, work);
-	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	int err;
 
 	mutex_lock(&mlxsw_sp->router->lock);
 	mlxsw_sp_span_respin(mlxsw_sp);
 
-	switch (fib_work->event) {
+	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
-		err = mlxsw_sp_router_fib6_replace(mlxsw_sp,
-						   fib_work->fib6_work.rt_arr,
-						   fib_work->fib6_work.nrt6);
+		err = mlxsw_sp_router_fib6_replace(mlxsw_sp, fib_event->fib6_event.rt_arr,
+						   fib_event->fib6_event.nrt6);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
-		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
+		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_APPEND:
-		err = mlxsw_sp_router_fib6_append(mlxsw_sp,
-						  fib_work->fib6_work.rt_arr,
-						  fib_work->fib6_work.nrt6);
+		err = mlxsw_sp_router_fib6_append(mlxsw_sp, fib_event->fib6_event.rt_arr,
+						  fib_event->fib6_event.nrt6);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
-		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
+		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fib6_del(mlxsw_sp,
-					 fib_work->fib6_work.rt_arr,
-					 fib_work->fib6_work.nrt6);
-		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
+		mlxsw_sp_router_fib6_del(mlxsw_sp, fib_event->fib6_event.rt_arr,
+					 fib_event->fib6_event.nrt6);
+		mlxsw_sp_router_fib6_event_fini(&fib_event->fib6_event);
 		break;
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
-	kfree(fib_work);
 }
 
-static void mlxsw_sp_router_fibmr_event_work(struct work_struct *work)
+static void mlxsw_sp_router_fibmr_event_process(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_fib_event *fib_event)
 {
-	struct mlxsw_sp_fib_event_work *fib_work =
-		container_of(work, struct mlxsw_sp_fib_event_work, work);
-	struct mlxsw_sp *mlxsw_sp = fib_work->mlxsw_sp;
 	bool replace;
 	int err;
 
 	rtnl_lock();
 	mutex_lock(&mlxsw_sp->router->lock);
-	switch (fib_work->event) {
+	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_ADD:
-		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
+		replace = fib_event->event == FIB_EVENT_ENTRY_REPLACE;
 
-		err = mlxsw_sp_router_fibmr_add(mlxsw_sp, &fib_work->men_info,
-						replace);
+		err = mlxsw_sp_router_fibmr_add(mlxsw_sp, &fib_event->men_info, replace);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
-		mr_cache_put(fib_work->men_info.mfc);
+		mr_cache_put(fib_event->men_info.mfc);
 		break;
 	case FIB_EVENT_ENTRY_DEL:
-		mlxsw_sp_router_fibmr_del(mlxsw_sp, &fib_work->men_info);
-		mr_cache_put(fib_work->men_info.mfc);
+		mlxsw_sp_router_fibmr_del(mlxsw_sp, &fib_event->men_info);
+		mr_cache_put(fib_event->men_info.mfc);
 		break;
 	case FIB_EVENT_VIF_ADD:
 		err = mlxsw_sp_router_fibmr_vif_add(mlxsw_sp,
-						    &fib_work->ven_info);
+						    &fib_event->ven_info);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
-		dev_put(fib_work->ven_info.dev);
+		dev_put(fib_event->ven_info.dev);
 		break;
 	case FIB_EVENT_VIF_DEL:
-		mlxsw_sp_router_fibmr_vif_del(mlxsw_sp,
-					      &fib_work->ven_info);
-		dev_put(fib_work->ven_info.dev);
+		mlxsw_sp_router_fibmr_vif_del(mlxsw_sp, &fib_event->ven_info);
+		dev_put(fib_event->ven_info.dev);
 		break;
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
 	rtnl_unlock();
-	kfree(fib_work);
 }
 
-static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event_work *fib_work,
+static void mlxsw_sp_router_fib_event_work(struct work_struct *work)
+{
+	struct mlxsw_sp_router *router = container_of(work, struct mlxsw_sp_router, fib_event_work);
+	struct mlxsw_sp *mlxsw_sp = router->mlxsw_sp;
+	struct mlxsw_sp_fib_event *fib_event, *tmp;
+	LIST_HEAD(fib_event_queue);
+
+	spin_lock_bh(&router->fib_event_queue_lock);
+	list_splice_init(&router->fib_event_queue, &fib_event_queue);
+	spin_unlock_bh(&router->fib_event_queue_lock);
+
+	list_for_each_entry_safe(fib_event, tmp, &fib_event_queue, list) {
+		switch (fib_event->family) {
+		case AF_INET:
+			mlxsw_sp_router_fib4_event_process(mlxsw_sp, fib_event);
+			break;
+		case AF_INET6:
+			mlxsw_sp_router_fib6_event_process(mlxsw_sp, fib_event);
+			break;
+		case RTNL_FAMILY_IP6MR:
+		case RTNL_FAMILY_IPMR:
+			mlxsw_sp_router_fibmr_event_process(mlxsw_sp,
+							    fib_event);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+		}
+		kfree(fib_event);
+		cond_resched();
+	}
+}
+
+static void mlxsw_sp_router_fib4_event(struct mlxsw_sp_fib_event *fib_event,
 				       struct fib_notifier_info *info)
 {
 	struct fib_entry_notifier_info *fen_info;
 	struct fib_nh_notifier_info *fnh_info;
 
-	switch (fib_work->event) {
+	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
-		fib_work->fen_info = *fen_info;
+		fib_event->fen_info = *fen_info;
 		/* Take reference on fib_info to prevent it from being
-		 * freed while work is queued. Release it afterwards.
+		 * freed while event is queued. Release it afterwards.
 		 */
-		fib_info_hold(fib_work->fen_info.fi);
+		fib_info_hold(fib_event->fen_info.fi);
 		break;
 	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fnh_info = container_of(info, struct fib_nh_notifier_info,
 					info);
-		fib_work->fnh_info = *fnh_info;
-		fib_info_hold(fib_work->fnh_info.fib_nh->nh_parent);
+		fib_event->fnh_info = *fnh_info;
+		fib_info_hold(fib_event->fnh_info.fib_nh->nh_parent);
 		break;
 	}
 }
 
-static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
+static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event *fib_event,
 				      struct fib_notifier_info *info)
 {
 	struct fib6_entry_notifier_info *fen6_info;
 	int err;
 
-	switch (fib_work->event) {
+	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_APPEND:
 	case FIB_EVENT_ENTRY_DEL:
 		fen6_info = container_of(info, struct fib6_entry_notifier_info,
 					 info);
-		err = mlxsw_sp_router_fib6_work_init(&fib_work->fib6_work,
-						     fen6_info);
+		err = mlxsw_sp_router_fib6_event_init(&fib_event->fib6_event,
+						      fen6_info);
 		if (err)
 			return err;
 		break;
@@ -6176,20 +6193,20 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 }
 
 static void
-mlxsw_sp_router_fibmr_event(struct mlxsw_sp_fib_event_work *fib_work,
+mlxsw_sp_router_fibmr_event(struct mlxsw_sp_fib_event *fib_event,
 			    struct fib_notifier_info *info)
 {
-	switch (fib_work->event) {
+	switch (fib_event->event) {
 	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_ADD:
 	case FIB_EVENT_ENTRY_DEL:
-		memcpy(&fib_work->men_info, info, sizeof(fib_work->men_info));
-		mr_cache_hold(fib_work->men_info.mfc);
+		memcpy(&fib_event->men_info, info, sizeof(fib_event->men_info));
+		mr_cache_hold(fib_event->men_info.mfc);
 		break;
 	case FIB_EVENT_VIF_ADD:
 	case FIB_EVENT_VIF_DEL:
-		memcpy(&fib_work->ven_info, info, sizeof(fib_work->ven_info));
-		dev_hold(fib_work->ven_info.dev);
+		memcpy(&fib_event->ven_info, info, sizeof(fib_event->ven_info));
+		dev_hold(fib_event->ven_info.dev);
 		break;
 	}
 }
@@ -6246,7 +6263,7 @@ static int mlxsw_sp_router_fib_rule_event(unsigned long event,
 static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
-	struct mlxsw_sp_fib_event_work *fib_work;
+	struct mlxsw_sp_fib_event *fib_event;
 	struct fib_notifier_info *info = ptr;
 	struct mlxsw_sp_router *router;
 	int err;
@@ -6296,37 +6313,39 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		break;
 	}
 
-	fib_work = kzalloc(sizeof(*fib_work), GFP_ATOMIC);
-	if (!fib_work)
+	fib_event = kzalloc(sizeof(*fib_event), GFP_ATOMIC);
+	if (!fib_event)
 		return NOTIFY_BAD;
 
-	fib_work->mlxsw_sp = router->mlxsw_sp;
-	fib_work->event = event;
+	fib_event->mlxsw_sp = router->mlxsw_sp;
+	fib_event->event = event;
+	fib_event->family = info->family;
 
 	switch (info->family) {
 	case AF_INET:
-		INIT_WORK(&fib_work->work, mlxsw_sp_router_fib4_event_work);
-		mlxsw_sp_router_fib4_event(fib_work, info);
+		mlxsw_sp_router_fib4_event(fib_event, info);
 		break;
 	case AF_INET6:
-		INIT_WORK(&fib_work->work, mlxsw_sp_router_fib6_event_work);
-		err = mlxsw_sp_router_fib6_event(fib_work, info);
+		err = mlxsw_sp_router_fib6_event(fib_event, info);
 		if (err)
 			goto err_fib_event;
 		break;
 	case RTNL_FAMILY_IP6MR:
 	case RTNL_FAMILY_IPMR:
-		INIT_WORK(&fib_work->work, mlxsw_sp_router_fibmr_event_work);
-		mlxsw_sp_router_fibmr_event(fib_work, info);
+		mlxsw_sp_router_fibmr_event(fib_event, info);
 		break;
 	}
 
-	mlxsw_core_schedule_work(&fib_work->work);
+	/* Enqueue the event and trigger the work */
+	spin_lock_bh(&router->fib_event_queue_lock);
+	list_add_tail(&fib_event->list, &router->fib_event_queue);
+	spin_unlock_bh(&router->fib_event_queue_lock);
+	mlxsw_core_schedule_work(&router->fib_event_work);
 
 	return NOTIFY_DONE;
 
 err_fib_event:
-	kfree(fib_work);
+	kfree(fib_event);
 	return NOTIFY_BAD;
 }
 
@@ -8171,6 +8190,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_dscp_init;
 
+	INIT_WORK(&router->fib_event_work, mlxsw_sp_router_fib_event_work);
+	INIT_LIST_HEAD(&router->fib_event_queue);
+	spin_lock_init(&router->fib_event_queue_lock);
+
 	router->inetaddr_nb.notifier_call = mlxsw_sp_inetaddr_event;
 	err = register_inetaddr_notifier(&router->inetaddr_nb);
 	if (err)
@@ -8204,6 +8227,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	mlxsw_core_flush_owq();
+	WARN_ON(!list_empty(&router->fib_event_queue));
 err_dscp_init:
 err_mp_hash_init:
 	mlxsw_sp_neigh_fini(mlxsw_sp);
@@ -8237,6 +8261,7 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
 	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
 	mlxsw_core_flush_owq();
+	WARN_ON(!list_empty(&mlxsw_sp->router->fib_event_queue));
 	mlxsw_sp_neigh_fini(mlxsw_sp);
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 68f5feabc02c..5683f20a325e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -48,6 +48,9 @@ struct mlxsw_sp_router {
 	bool adj_discard_index_valid;
 	struct mlxsw_sp_router_nve_decap nve_decap_config;
 	struct mutex lock; /* Protects shared router resources */
+	struct work_struct fib_event_work;
+	struct list_head fib_event_queue;
+	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
 	/* One set of ops for each protocol: IPv4 and IPv6 */
 	const struct mlxsw_sp_router_ll_ops *proto_ll_ops[MLXSW_SP_L3_PROTO_MAX];
 };
-- 
2.26.2

