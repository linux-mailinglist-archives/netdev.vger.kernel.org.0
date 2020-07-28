Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A492310C0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731963AbgG1RUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbgG1RUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:20:44 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1F8DC0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 10:20:43 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id A2AB48AD62;
        Tue, 28 Jul 2020 18:20:42 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595956843; bh=M5LA4vzTYvxM3N6AOV1L6m2eeWMbICcA/usVJLSr46w=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=202/6]=20l2tp:=20don't=20export=
         20tunnel=20and=20session=20free=20functions|Date:=20Tue,=2028=20Ju
         l=202020=2018:20:29=20+0100|Message-Id:=20<20200728172033.19532-3-
         tparkin@katalix.com>|In-Reply-To:=20<20200728172033.19532-1-tparki
         n@katalix.com>|References:=20<20200728172033.19532-1-tparkin@katal
         ix.com>;
        b=OQfbLM9PMfZZMb+xOIShYolE23UBAsmf2gfXKg2pdO/a9Xo+AfnssjsvbdNkkqz1C
         j5kKZV3c1sJM0n1b2MpqHgwrluEH6zPX9bGW4TRYN/CDMCugp61wd32h7NPtceRx3g
         99/dEdokQBRD+e5nioKSi6Gi+viqq5FPXfdbjNwdi2VlV8Xnq+d8BdKQtCo2LU2rHw
         nuSs1TRSkoq2i99gRV2If6lEb7O8KuCPn4/SOrIueSUiEnk0U1Ebkik5sMgwAw4X6o
         27XCycWjukC7y5RrQ02V9UpiQpzNe6lnu69xj4E8Cb8t0zsohjWtR5dq7/1887GTZv
         5iu9QNP22BbNA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 2/6] l2tp: don't export tunnel and session free functions
Date:   Tue, 28 Jul 2020 18:20:29 +0100
Message-Id: <20200728172033.19532-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200728172033.19532-1-tparkin@katalix.com>
References: <20200728172033.19532-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tunnel and session instances are reference counted, and shouldn't be
directly freed by pseudowire code.

Rather than exporting l2tp_tunnel_free and l2tp_session_free, make them
private to l2tp_core.c, and export the refcount functions instead.

In order to do this, the refcount functions cannot be declared as
inline.  Since the codepaths which take and drop tunnel and session
references are not directly in the datapath this shouldn't cause
performance issues.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 60 ++++++++++++++++++++++++++++++--------------
 net/l2tp/l2tp_core.h | 33 ++++--------------------
 2 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7f4aef5a58ba..f22fe34eb8fc 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -149,12 +149,51 @@ l2tp_session_id_hash(struct l2tp_tunnel *tunnel, u32 session_id)
 	return &tunnel->session_hlist[hash_32(session_id, L2TP_HASH_BITS)];
 }
 
-void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
+static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
 {
 	sock_put(tunnel->sock);
 	/* the tunnel is freed in the socket destructor */
 }
-EXPORT_SYMBOL(l2tp_tunnel_free);
+
+static void l2tp_session_free(struct l2tp_session *session)
+{
+	struct l2tp_tunnel *tunnel = session->tunnel;
+
+	if (tunnel) {
+		if (WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC))
+			goto out;
+		l2tp_tunnel_dec_refcount(tunnel);
+	}
+
+out:
+	kfree(session);
+}
+
+void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
+{
+	refcount_inc(&tunnel->ref_count);
+}
+EXPORT_SYMBOL_GPL(l2tp_tunnel_inc_refcount);
+
+void l2tp_tunnel_dec_refcount(struct l2tp_tunnel *tunnel)
+{
+	if (refcount_dec_and_test(&tunnel->ref_count))
+		l2tp_tunnel_free(tunnel);
+}
+EXPORT_SYMBOL_GPL(l2tp_tunnel_dec_refcount);
+
+void l2tp_session_inc_refcount(struct l2tp_session *session)
+{
+	refcount_inc(&session->ref_count);
+}
+EXPORT_SYMBOL_GPL(l2tp_session_inc_refcount);
+
+void l2tp_session_dec_refcount(struct l2tp_session *session)
+{
+	if (refcount_dec_and_test(&session->ref_count))
+		l2tp_session_free(session);
+}
+EXPORT_SYMBOL_GPL(l2tp_session_dec_refcount);
 
 /* Lookup a tunnel. A new reference is held on the returned tunnel. */
 struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
@@ -1581,23 +1620,6 @@ void l2tp_tunnel_delete(struct l2tp_tunnel *tunnel)
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_delete);
 
-/* Really kill the session.
- */
-void l2tp_session_free(struct l2tp_session *session)
-{
-	struct l2tp_tunnel *tunnel = session->tunnel;
-
-	if (tunnel) {
-		if (WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC))
-			goto out;
-		l2tp_tunnel_dec_refcount(tunnel);
-	}
-
-out:
-	kfree(session);
-}
-EXPORT_SYMBOL_GPL(l2tp_session_free);
-
 /* This function is used by the netlink SESSION_DELETE command and by
  * pseudowire modules.
  */
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index f6dd74476d13..5c49e2762300 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -175,13 +175,16 @@ static inline void *l2tp_session_priv(struct l2tp_session *session)
 	return &session->priv[0];
 }
 
+void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel);
+void l2tp_tunnel_dec_refcount(struct l2tp_tunnel *tunnel);
+void l2tp_session_inc_refcount(struct l2tp_session *session);
+void l2tp_session_dec_refcount(struct l2tp_session *session);
+
 struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id);
 struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth);
 struct l2tp_session *l2tp_tunnel_get_session(struct l2tp_tunnel *tunnel,
 					     u32 session_id);
 
-void l2tp_tunnel_free(struct l2tp_tunnel *tunnel);
-
 struct l2tp_session *l2tp_session_get(const struct net *net, u32 session_id);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth);
 struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
@@ -202,7 +205,6 @@ int l2tp_session_register(struct l2tp_session *session,
 			  struct l2tp_tunnel *tunnel);
 
 int l2tp_session_delete(struct l2tp_session *session);
-void l2tp_session_free(struct l2tp_session *session);
 void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
 		      unsigned char *ptr, unsigned char *optr, u16 hdrflags,
 		      int length);
@@ -217,31 +219,6 @@ int l2tp_nl_register_ops(enum l2tp_pwtype pw_type,
 void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
 int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 
-static inline void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
-{
-	refcount_inc(&tunnel->ref_count);
-}
-
-static inline void l2tp_tunnel_dec_refcount(struct l2tp_tunnel *tunnel)
-{
-	if (refcount_dec_and_test(&tunnel->ref_count))
-		l2tp_tunnel_free(tunnel);
-}
-
-/* Session reference counts. Incremented when code obtains a reference
- * to a session.
- */
-static inline void l2tp_session_inc_refcount(struct l2tp_session *session)
-{
-	refcount_inc(&session->ref_count);
-}
-
-static inline void l2tp_session_dec_refcount(struct l2tp_session *session)
-{
-	if (refcount_dec_and_test(&session->ref_count))
-		l2tp_session_free(session);
-}
-
 static inline int l2tp_get_l2specific_len(struct l2tp_session *session)
 {
 	switch (session->l2specific_type) {
-- 
2.17.1

