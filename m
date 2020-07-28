Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330F52310C4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbgG1RUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731779AbgG1RUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:20:43 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FFC1C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:20:43 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 065487D370;
        Tue, 28 Jul 2020 18:20:41 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956842; bh=q9aEMnMou1IRGNu9SugX10lM7bcimeeNPfB+tWzTGWk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=201/6]=20l2tp:=20don't=20export=
         20__l2tp_session_unhash|Date:=20Tue,=2028=20Jul=202020=2018:20:28=
         20+0100|Message-Id:=20<20200728172033.19532-2-tparkin@katalix.com>
         |In-Reply-To:=20<20200728172033.19532-1-tparkin@katalix.com>|Refer
         ences:=20<20200728172033.19532-1-tparkin@katalix.com>;
        b=aeYne14/3ulPm9ZUcLipcRghQFH1JKVcdjRw+c1xLBx+ExB0/zbcPRERKDbNXbXij
         F/a7U55Ll4IPIBg2TN3OX7wON9x02ks6lxXmL424W7AFZN7EGo8qG7uFZA+4HuT8GI
         0ZtTzvmfQea0nJ8y9fiTzqfdktXv993ptrnmaYDbpBjkAg1os5ooNiiPNSgBjwG8Xc
         lD/vh4gB3HGxDfr1ymPEPjzsXDJqYO9OPusJGtb9dQ6byvYvAV6Ep5ecV419AF80O+
         K0OGhPWzedq8pIU1ZGmW0eU+ZxrxDaLLQ1PfXLGiPuTIGy54DbPpFBx3UCdUiNu+OK
         Tkp6+raeBLePg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 1/6] l2tp: don't export __l2tp_session_unhash
Date:   Tue, 28 Jul 2020 18:20:28 +0100
Message-Id: <20200728172033.19532-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When __l2tp_session_unhash was first added it was used outside of
l2tp_core.c, but that's no longer the case.

As such, there's no longer a need to export the function.  Make it
private inside l2tp_core.c, and relocate it to avoid having to declare
the function prototype in l2tp_core.h.

Since the function is no longer used outside l2tp_core.c, remove the
"__" prefix since we don't need to indicate anything special about its
expected use to callers.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 57 ++++++++++++++++++++------------------------
 net/l2tp/l2tp_core.h |  1 -
 2 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index e723828e458b..7f4aef5a58ba 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1180,6 +1180,30 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 	return;
 }
 
+/* Remove an l2tp session from l2tp_core's hash lists. */
+static void l2tp_session_unhash(struct l2tp_session *session)
+{
+	struct l2tp_tunnel *tunnel = session->tunnel;
+
+	/* Remove the session from core hashes */
+	if (tunnel) {
+		/* Remove from the per-tunnel hash */
+		write_lock_bh(&tunnel->hlist_lock);
+		hlist_del_init(&session->hlist);
+		write_unlock_bh(&tunnel->hlist_lock);
+
+		/* For L2TPv3 we have a per-net hash: remove from there, too */
+		if (tunnel->version != L2TP_HDR_VER_2) {
+			struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
+
+			spin_lock_bh(&pn->l2tp_session_hlist_lock);
+			hlist_del_init_rcu(&session->global_hlist);
+			spin_unlock_bh(&pn->l2tp_session_hlist_lock);
+			synchronize_rcu();
+		}
+	}
+}
+
 /* When the tunnel is closed, all the attached sessions need to go too.
  */
 static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
@@ -1209,7 +1233,7 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 
 			write_unlock_bh(&tunnel->hlist_lock);
 
-			__l2tp_session_unhash(session);
+			l2tp_session_unhash(session);
 			l2tp_session_queue_purge(session);
 
 			if (session->session_close)
@@ -1574,35 +1598,6 @@ void l2tp_session_free(struct l2tp_session *session)
 }
 EXPORT_SYMBOL_GPL(l2tp_session_free);
 
-/* Remove an l2tp session from l2tp_core's hash lists.
- * Provides a tidyup interface for pseudowire code which can't just route all
- * shutdown via. l2tp_session_delete and a pseudowire-specific session_close
- * callback.
- */
-void __l2tp_session_unhash(struct l2tp_session *session)
-{
-	struct l2tp_tunnel *tunnel = session->tunnel;
-
-	/* Remove the session from core hashes */
-	if (tunnel) {
-		/* Remove from the per-tunnel hash */
-		write_lock_bh(&tunnel->hlist_lock);
-		hlist_del_init(&session->hlist);
-		write_unlock_bh(&tunnel->hlist_lock);
-
-		/* For L2TPv3 we have a per-net hash: remove from there, too */
-		if (tunnel->version != L2TP_HDR_VER_2) {
-			struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
-
-			spin_lock_bh(&pn->l2tp_session_hlist_lock);
-			hlist_del_init_rcu(&session->global_hlist);
-			spin_unlock_bh(&pn->l2tp_session_hlist_lock);
-			synchronize_rcu();
-		}
-	}
-}
-EXPORT_SYMBOL_GPL(__l2tp_session_unhash);
-
 /* This function is used by the netlink SESSION_DELETE command and by
  * pseudowire modules.
  */
@@ -1611,7 +1606,7 @@ int l2tp_session_delete(struct l2tp_session *session)
 	if (test_and_set_bit(0, &session->dead))
 		return 0;
 
-	__l2tp_session_unhash(session);
+	l2tp_session_unhash(session);
 	l2tp_session_queue_purge(session);
 	if (session->session_close)
 		(*session->session_close)(session);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 2d2dd219a176..f6dd74476d13 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -201,7 +201,6 @@ struct l2tp_session *l2tp_session_create(int priv_size,
 int l2tp_session_register(struct l2tp_session *session,
 			  struct l2tp_tunnel *tunnel);
 
-void __l2tp_session_unhash(struct l2tp_session *session);
 int l2tp_session_delete(struct l2tp_session *session);
 void l2tp_session_free(struct l2tp_session *session);
 void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
-- 
2.17.1

