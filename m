Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED2B2310C5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgG1RUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731956AbgG1RUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:20:44 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 732C0C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:20:44 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 8DF948AD8E;
        Tue, 28 Jul 2020 18:20:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956843; bh=J9nnbV0YSKjatsE4RU9ncwV6iXeQJmGzQCTDc0/ssYA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=203/6]=20l2tp:=20return=20void=2
         0from=20l2tp_session_delete|Date:=20Tue,=2028=20Jul=202020=2018:20
         :30=20+0100|Message-Id:=20<20200728172033.19532-4-tparkin@katalix.
         com>|In-Reply-To:=20<20200728172033.19532-1-tparkin@katalix.com>|R
         eferences:=20<20200728172033.19532-1-tparkin@katalix.com>;
        b=dz87wIcz3m/0o+3/bbp9+9VPXj9riT+6gbvwqgkCtxp+0EVm17WkfcAKHLYb/qSAa
         i5NcizNI0S16ohF9xUbmWu89FSX7CYmpiF6/k9XhgwudPtQgAWcLxf9aUx2WIfrh2h
         1eXBNNuLT4ho2wNUK1/llYsnR54cuWfj68EWNKsH5a1svIGKt+sdSGcPpAr9Gs/JYk
         1SDQDl4NapGPzKXZ8ImfDjLrCfoE7GZj+qoC7iSNxhvyGjPmRhJZ1sbmG8ODLIYNmr
         NPVgh48/UV7QgdcJ7eIzGJVgJbC3JTmkHrTESu6nhePIkdaudZNkvfKGk23zCnvZqW
         hK7TIL70VxlnA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 3/6] l2tp: return void from l2tp_session_delete
Date:   Tue, 28 Jul 2020 18:20:30 +0100
Message-Id: <20200728172033.19532-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_delete is used to schedule a session instance for deletion.
The function itself always returns zero, and none of its direct callers
check its return value, so have the function return void.

This change de-facto changes the l2tp netlink session_delete callback
prototype since all pseudowires currently use l2tp_session_delete for
their implementation of that operation.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 9 ++-------
 net/l2tp/l2tp_core.h    | 4 ++--
 net/l2tp/l2tp_netlink.c | 2 +-
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f22fe34eb8fc..690dcbc30472 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1620,13 +1620,10 @@ void l2tp_tunnel_delete(struct l2tp_tunnel *tunnel)
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_delete);
 
-/* This function is used by the netlink SESSION_DELETE command and by
- * pseudowire modules.
- */
-int l2tp_session_delete(struct l2tp_session *session)
+void l2tp_session_delete(struct l2tp_session *session)
 {
 	if (test_and_set_bit(0, &session->dead))
-		return 0;
+		return;
 
 	l2tp_session_unhash(session);
 	l2tp_session_queue_purge(session);
@@ -1634,8 +1631,6 @@ int l2tp_session_delete(struct l2tp_session *session)
 		(*session->session_close)(session);
 
 	l2tp_session_dec_refcount(session);
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(l2tp_session_delete);
 
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 5c49e2762300..0c32981f0cd3 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -167,7 +167,7 @@ struct l2tp_nl_cmd_ops {
 	int (*session_create)(struct net *net, struct l2tp_tunnel *tunnel,
 			      u32 session_id, u32 peer_session_id,
 			      struct l2tp_session_cfg *cfg);
-	int (*session_delete)(struct l2tp_session *session);
+	void (*session_delete)(struct l2tp_session *session);
 };
 
 static inline void *l2tp_session_priv(struct l2tp_session *session)
@@ -204,7 +204,7 @@ struct l2tp_session *l2tp_session_create(int priv_size,
 int l2tp_session_register(struct l2tp_session *session,
 			  struct l2tp_tunnel *tunnel);
 
-int l2tp_session_delete(struct l2tp_session *session);
+void l2tp_session_delete(struct l2tp_session *session);
 void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      unsigned char *ptr, unsigned char *optr, u16 hdrflags,
 		      int length);
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 35716a6e1e2c..def78eebca4c 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -670,7 +670,7 @@ static int l2tp_nl_cmd_session_delete(struct sk_buff *skb, struct genl_info *inf
 	pw_type = session->pwtype;
 	if (pw_type < __L2TP_PWTYPE_MAX)
 		if (l2tp_nl_cmd_ops[pw_type] && l2tp_nl_cmd_ops[pw_type]->session_delete)
-			ret = (*l2tp_nl_cmd_ops[pw_type]->session_delete)(session);
+			l2tp_nl_cmd_ops[pw_type]->session_delete(session);
 
 	l2tp_session_dec_refcount(session);
 
-- 
2.17.1

