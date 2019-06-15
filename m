Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34B747054
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfFOOJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36255 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:43 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 612B321EAF;
        Sat, 15 Jun 2019 10:09:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5IWYB0+DUdOb5TTYXMG5+KZklUqJy4gc2XG2Z9xQQis=; b=0fdHyiQK
        YA6lq/VP4gyp41e1iI17vFYZ/YoHnMwII+1vVmLck9XGO8ouGMZjDAnlOFIcup+c
        ERPjwtN7kS2jzFLt225TCOCc5hYK2kgYsO7Cm2+uO5kPlvOgp4zt5PkVlWIw0d9D
        mtBlmyGZZlTuZMzN/2KBy+Ojnrss6fT8d1qdz9FBkN9OcIGwy9HmJsPHrYpp05vt
        rtWeNZzv12nkoTbAlUb6ilGqMoK+dXwPcmeJsOSxDpoU51WUCoKu/mo4mGq5nfz0
        5iYuZ+gQ40meweAAuHuiP1kbc3Hcx9qJI6loYUEsBQAay5m2IJ3I6Q6YMaoHHNIa
        dbo4AgNLDOZvFw==
X-ME-Sender: <xms:JvwEXRV-mmHb8U33a1ppNDsmRykO1IpflB_CcDx52MaCa5tYsQTjaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeple
X-ME-Proxy: <xmx:JvwEXRsO_Ne_254wpbeU5GHvlzBcnaioGUeY-DaEM96Cb7CoVk6mKQ>
    <xmx:JvwEXVVNtUOk94GsDc9OlXtDtBHqrLS6w3H0fwrMZwkHyH4InpELWw>
    <xmx:JvwEXckLNxttRWnrz_F1agUmU8mUTiLRZXmG5aA7dPsmzUHgdx4Wqg>
    <xmx:JvwEXa9P2lCbsZUbAJj51-k338JjZD22AJ_Ed3gqQFyl3v1SwIajsg>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A1DB380085;
        Sat, 15 Jun 2019 10:09:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 11/17] mlxsw: spectrum_router: Pass multiple routes to work item
Date:   Sat, 15 Jun 2019 17:07:45 +0300
Message-Id: <20190615140751.17661-12-idosch@idosch.org>
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

Prepare the driver to process IPv6 multipath notifications by passing an
array of 'struct fib6_info' instead of just one route.

A reference is taken on each sibling route in order to prevent them from
being freed until they are processed by the workqueue.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 73 +++++++++++++++++--
 1 file changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0fdd516b027a..1f96621eb219 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5826,10 +5826,15 @@ static void mlxsw_sp_router_fib_abort(struct mlxsw_sp *mlxsw_sp)
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
@@ -5840,6 +5845,55 @@ struct mlxsw_sp_fib_event_work {
 	unsigned long event;
 };
 
+static int
+mlxsw_sp_router_fib6_work_init(struct mlxsw_sp_fib6_event_work *fib6_work,
+			       struct fib6_entry_notifier_info *fen6_info)
+{
+	struct fib6_info *rt = fen6_info->rt;
+	struct fib6_info **rt_arr;
+	struct fib6_info *iter;
+	unsigned int nrt6 = 1;
+	int i = 0;
+
+	if (fen6_info->multipath_rt)
+		nrt6 = fen6_info->nsiblings + 1;
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
+	if (!fen6_info->multipath_rt)
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
@@ -5901,14 +5955,16 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
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
@@ -6001,6 +6057,7 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
 				      struct fib_notifier_info *info)
 {
 	struct fib6_entry_notifier_info *fen6_info;
+	int err;
 
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
@@ -6008,8 +6065,10 @@ static int mlxsw_sp_router_fib6_event(struct mlxsw_sp_fib_event_work *fib_work,
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

