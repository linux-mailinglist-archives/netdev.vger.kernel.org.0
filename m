Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129D8C49CA
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfJBIlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:41:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49245 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727922AbfJBIlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:41:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0BBD920A34;
        Wed,  2 Oct 2019 04:41:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 02 Oct 2019 04:41:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=spqd64KzIktvkKdMDBMykEDSX+Wvjj5i/YYRyhPlN8k=; b=Cjze/NI0
        0B733nZqlSChNzFE+kQRO30lKnjo8JOI5BL/fXqB4p0h8MVz/UB/EtphJ5eefRXk
        aCz5kW13oqZvHigewlaH8aoxBHJKxHztzYrNB3Dcz7GKrbUq2vDXzoOiU+mYdmWL
        jxy1Zbdhu5YxthDgTukEJPde3LRlVdIXdYBuMUL8dkO5HuMS7FIundaezE7npkJk
        4pfXcjXABIDL75dbiEbhVfj+pP0Z2bhEQnsa3xil0+pVwHfUmqMQsHlgr2q+gMXl
        Adh05br6/Ak/3oKfpsv3SDMVkuyqvm8TlUWDm8hFd03HYtUvPW/memldOK9/Cz2E
        ZDhDxH+13o7kGA==
X-ME-Sender: <xms:x2KUXSdYF-iE0Y3gIEnR9S20hsVVkjQ_qSecGhFk32UFbIhM8w9rCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeigddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepje
X-ME-Proxy: <xmx:x2KUXfpunHE5CZ_-19ZVYPyX_wZ5s-lFk8dZAMz1NR3kLXc3oQKXzw>
    <xmx:x2KUXQT2YlGWFt7knP-yE_0_-uqR79uYbvpaxsswcTglW13kLzfTzA>
    <xmx:x2KUXTVFGEhuEA4dlT3RTdiw43gNizPnXmpMZ6-Bz-gFDXaF1_df9g>
    <xmx:yGKUXedQqnU5qvr2SEZhGqpsUgNMSCGjG5hbtQ8i5ox7cD7AkjeIdw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71176D60067;
        Wed,  2 Oct 2019 04:41:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 09/15] ipv4: Remove old route notifications and convert listeners
Date:   Wed,  2 Oct 2019 11:40:57 +0300
Message-Id: <20191002084103.12138-10-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002084103.12138-1-idosch@idosch.org>
References: <20191002084103.12138-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Unlike mlxsw, the other listeners to the FIB notification chain do not
require any special modifications as they never considered multiple
identical routes.

This patch removes the old route notifications and converts all the
listeners to use the new replace / delete notifications.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag_mp.c  |  4 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  7 ++--
 drivers/net/ethernet/rocker/rocker_main.c     |  4 +-
 drivers/net/netdevsim/fib.c                   |  4 +-
 include/net/fib_notifier.h                    |  2 -
 net/ipv4/fib_trie.c                           | 37 ++++---------------
 6 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index 13e2944b1274..58c2646051a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -197,8 +197,6 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	rtnl_lock();
 	switch (fib_work->event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
 					 fib_work->fen_info.fi);
@@ -256,8 +254,6 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 
 	switch (event) {
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND: /* fall through */
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f5514fbae39e..5a4e61f1feec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5910,14 +5910,14 @@ static void mlxsw_sp_router_fib4_event_work(struct work_struct *work)
 	mlxsw_sp_span_respin(mlxsw_sp);
 
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE_TMP:
+	case FIB_EVENT_ENTRY_REPLACE:
 		err = mlxsw_sp_router_fib4_replace(mlxsw_sp,
 						   &fib_work->fen_info);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_ENTRY_DEL_TMP:
+	case FIB_EVENT_ENTRY_DEL:
 		mlxsw_sp_router_fib4_del(mlxsw_sp, &fib_work->fen_info);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
@@ -6149,8 +6149,7 @@ static int mlxsw_sp_router_fib_event(struct notifier_block *nb,
 		return notifier_from_errno(err);
 	case FIB_EVENT_ENTRY_ADD: /* fall through */
 	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
-	case FIB_EVENT_ENTRY_APPEND:  /* fall through */
-	case FIB_EVENT_ENTRY_REPLACE_TMP:
+	case FIB_EVENT_ENTRY_APPEND:
 		if (router->aborted) {
 			NL_SET_ERR_MSG_MOD(info->extack, "FIB offload was aborted. Not configuring route");
 			return notifier_from_errno(-EINVAL);
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index bc4f951315da..7585cd2270ba 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2159,7 +2159,7 @@ static void rocker_router_fib_event_work(struct work_struct *work)
 	/* Protect internal structures from changes */
 	rtnl_lock();
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_ADD:
+	case FIB_EVENT_ENTRY_REPLACE:
 		err = rocker_world_fib4_add(rocker, &fib_work->fen_info);
 		if (err)
 			rocker_world_fib4_abort(rocker);
@@ -2201,7 +2201,7 @@ static int rocker_router_fib_event(struct notifier_block *nb,
 	fib_work->event = event;
 
 	switch (event) {
-	case FIB_EVENT_ENTRY_ADD: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
 		if (info->family == AF_INET) {
 			struct fib_entry_notifier_info *fen_info = ptr;
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 13540dee7364..4e02a4231fcb 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -177,10 +177,10 @@ static int nsim_fib_event_nb(struct notifier_block *nb, unsigned long event,
 					  event == FIB_EVENT_RULE_ADD);
 		break;
 
+	case FIB_EVENT_ENTRY_REPLACE:  /* fall through */
 	case FIB_EVENT_ENTRY_ADD:  /* fall through */
 	case FIB_EVENT_ENTRY_DEL:
-		err = nsim_fib_event(data, info,
-				     event == FIB_EVENT_ENTRY_ADD);
+		err = nsim_fib_event(data, info, event != FIB_EVENT_ENTRY_DEL);
 		break;
 	}
 
diff --git a/include/net/fib_notifier.h b/include/net/fib_notifier.h
index b3c54325caec..6d59221ff05a 100644
--- a/include/net/fib_notifier.h
+++ b/include/net/fib_notifier.h
@@ -23,8 +23,6 @@ enum fib_event_type {
 	FIB_EVENT_NH_DEL,
 	FIB_EVENT_VIF_ADD,
 	FIB_EVENT_VIF_DEL,
-	FIB_EVENT_ENTRY_REPLACE_TMP,
-	FIB_EVENT_ENTRY_DEL_TMP,
 };
 
 struct fib_notifier_ops {
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4937a3503f4f..cbb41eebb43b 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1143,7 +1143,6 @@ static void fib_remove_alias(struct trie *t, struct key_vector *tp,
 int fib_table_insert(struct net *net, struct fib_table *tb,
 		     struct fib_config *cfg, struct netlink_ext_ack *extack)
 {
-	enum fib_event_type event = FIB_EVENT_ENTRY_ADD;
 	struct trie *t = (struct trie *)tb->tb_data;
 	struct fib_alias *fa, *new_fa;
 	struct key_vector *l, *tp;
@@ -1242,19 +1241,13 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 						 tb->tb_id) == fa) {
 				enum fib_event_type fib_event;
 
-				fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+				fib_event = FIB_EVENT_ENTRY_REPLACE;
 				err = call_fib_entry_notifiers(net, fib_event,
 							       key, plen,
 							       new_fa, extack);
 				if (err)
 					goto out_free_new_fa;
 			}
-			err = call_fib_entry_notifiers(net,
-						       FIB_EVENT_ENTRY_REPLACE,
-						       key, plen, new_fa,
-						       extack);
-			if (err)
-				goto out_free_new_fa;
 
 			rtmsg_fib(RTM_NEWROUTE, htonl(key), new_fa, plen,
 				  tb->tb_id, &cfg->fc_nlinfo, nlflags);
@@ -1276,12 +1269,10 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 		if (fa_match)
 			goto out;
 
-		if (cfg->fc_nlflags & NLM_F_APPEND) {
-			event = FIB_EVENT_ENTRY_APPEND;
+		if (cfg->fc_nlflags & NLM_F_APPEND)
 			nlflags |= NLM_F_APPEND;
-		} else {
+		else
 			fa = fa_first;
-		}
 	}
 	err = -ENOENT;
 	if (!(cfg->fc_nlflags & NLM_F_CREATE))
@@ -1315,15 +1306,12 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 	    new_fa) {
 		enum fib_event_type fib_event;
 
-		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		fib_event = FIB_EVENT_ENTRY_REPLACE;
 		err = call_fib_entry_notifiers(net, fib_event, key, plen,
 					       new_fa, extack);
 		if (err)
 			goto out_remove_new_fa;
 	}
-	err = call_fib_entry_notifiers(net, event, key, plen, new_fa, extack);
-	if (err)
-		goto out_remove_new_fa;
 
 	if (!plen)
 		tb->tb_num_default++;
@@ -1606,10 +1594,10 @@ static void fib_notify_alias_delete(struct net *net, u32 key,
 	fa_next = hlist_entry_safe(fa_to_delete->fa_list.next,
 				   struct fib_alias, fa_list);
 	if (fa_next && fa_next->fa_slen == slen && fa_next->tb_id == tb_id) {
-		fib_event = FIB_EVENT_ENTRY_REPLACE_TMP;
+		fib_event = FIB_EVENT_ENTRY_REPLACE;
 		fa_to_notify = fa_next;
 	} else {
-		fib_event = FIB_EVENT_ENTRY_DEL_TMP;
+		fib_event = FIB_EVENT_ENTRY_DEL;
 		fa_to_notify = fa_to_delete;
 	}
 	call_fib_entry_notifiers(net, fib_event, key, KEYLENGTH - slen,
@@ -1670,8 +1658,6 @@ int fib_table_delete(struct net *net, struct fib_table *tb,
 		return -ESRCH;
 
 	fib_notify_alias_delete(net, key, &l->leaf, fa_to_delete, extack);
-	call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL, key, plen,
-				 fa_to_delete, extack);
 	rtmsg_fib(RTM_DELROUTE, htonl(key), fa_to_delete, plen, tb->tb_id,
 		  &cfg->fc_nlinfo, 0);
 
@@ -1997,10 +1983,6 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 
 			fib_notify_alias_delete(net, n->key, &n->leaf, fa,
 						NULL);
-			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_DEL,
-						 n->key,
-						 KEYLENGTH - fa->fa_slen, fa,
-						 NULL);
 			hlist_del_rcu(&fa->fa_list);
 			fib_release_info(fa->fa_info);
 			alias_free_mem_rcu(fa);
@@ -2115,16 +2097,11 @@ static int fib_leaf_notify(struct key_vector *l, struct fib_table *tb,
 			continue;
 
 		last_slen = fa->fa_slen;
-		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE_TMP,
+		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_REPLACE,
 					      l->key, KEYLENGTH - fa->fa_slen,
 					      fa, extack);
 		if (err)
 			return err;
-		err = call_fib_entry_notifier(nb, FIB_EVENT_ENTRY_ADD, l->key,
-					      KEYLENGTH - fa->fa_slen,
-					      fa, extack);
-		if (err)
-			return err;
 	}
 	return 0;
 }
-- 
2.21.0

