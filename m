Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B941B45F191
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238985AbhKZQUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:20:02 -0500
Received: from mail.katalix.com ([3.9.82.81]:52646 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378348AbhKZQSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:18:01 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 11:18:00 EST
Received: from jackdaw.fritz.box (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id A664A8E4E6;
        Fri, 26 Nov 2021 16:09:13 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1637942953; bh=//JSRabXqXh4fswB7BcP/BUepMWJ4huQbKVqAaHTFYg=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next]=20net/l2tp:=20conver
         t=20tunnel=20rwlock_t=20to=20rcu|Date:=20Fri,=2026=20Nov=202021=20
         16:09:03=20+0000|Message-Id:=20<20211126160903.14124-1-tparkin@kat
         alix.com>;
        b=KzSv0dLzetLrWVpJd6YGl0MUsGsc4SWCEIPHoPoSo+uDMXv2fGqxPXG1pYFeAyxqY
         lWzSkmWpIzdOjP6HXj4r9t9tawxnjdr7wzar/+IQIWk/pWwK5y1Hk1G9aNa7zY5o3Z
         npvUdFyXNsyhKIrYsuSpG2wm/nPGLR0JyqAAA+zq5Y70MhJp+y+NibBlfrhHhUe6J9
         MWw+vi5WU3fpEINUHua/tj9+q9nINXwShWyLPOMxq3VJlvGhYuQCottkiOAJj5/S9Q
         ny57LLz+ihWnQY+CnjHB3M8DAfRoqsOLF6yYbNnY6wr0+1BlDLutcCJw7eFZdt1ZpQ
         xDhm30Ql34jmA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next] net/l2tp: convert tunnel rwlock_t to rcu
Date:   Fri, 26 Nov 2021 16:09:03 +0000
Message-Id: <20211126160903.14124-1-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously commit e02d494d2c60 ("l2tp: Convert rwlock to RCU") converted
most, but not all, rwlock instances in the l2tp subsystem to RCU.

The remaining rwlock protects the per-tunnel hashlist of sessions which
is used for session lookups in the UDP-encap data path.

Convert the remaining rwlock to rcu to improve performance of UDP-encap
tunnels.

Note that the tunnel and session, which both live on RCU-protected
lists, use slightly different approaches to incrementing their refcounts
in the various getter functions.

The tunnel has to use refcount_inc_not_zero because the tunnel shutdown
process involves dropping the refcount to zero prior to synchronizing
RCU readers (via. kfree_rcu).

By contrast, the session shutdown removes the session from the list(s)
it is on, synchronizes with readers, and then decrements the session
refcount.  Since the getter functions increment the session refcount
with the RCU read lock held we prevent getters seeing a zero session
refcount, and therefore don't need to use refcount_inc_not_zero.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 52 ++++++++++++++++++++---------------------
 net/l2tp/l2tp_core.h    |  2 +-
 net/l2tp/l2tp_debugfs.c | 13 ++++-------
 3 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 93271a2632b8..7499c51b1850 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -250,15 +250,15 @@ struct l2tp_session *l2tp_tunnel_get_session(struct l2tp_tunnel *tunnel,
 
 	session_list = l2tp_session_id_hash(tunnel, session_id);
 
-	read_lock_bh(&tunnel->hlist_lock);
-	hlist_for_each_entry(session, session_list, hlist)
+	rcu_read_lock_bh();
+	hlist_for_each_entry_rcu(session, session_list, hlist)
 		if (session->session_id == session_id) {
 			l2tp_session_inc_refcount(session);
-			read_unlock_bh(&tunnel->hlist_lock);
+			rcu_read_unlock_bh();
 
 			return session;
 		}
-	read_unlock_bh(&tunnel->hlist_lock);
+	rcu_read_unlock_bh();
 
 	return NULL;
 }
@@ -291,18 +291,18 @@ struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth)
 	struct l2tp_session *session;
 	int count = 0;
 
-	read_lock_bh(&tunnel->hlist_lock);
+	rcu_read_lock_bh();
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
-		hlist_for_each_entry(session, &tunnel->session_hlist[hash], hlist) {
+		hlist_for_each_entry_rcu(session, &tunnel->session_hlist[hash], hlist) {
 			if (++count > nth) {
 				l2tp_session_inc_refcount(session);
-				read_unlock_bh(&tunnel->hlist_lock);
+				rcu_read_unlock_bh();
 				return session;
 			}
 		}
 	}
 
-	read_unlock_bh(&tunnel->hlist_lock);
+	rcu_read_unlock_bh();
 
 	return NULL;
 }
@@ -347,7 +347,7 @@ int l2tp_session_register(struct l2tp_session *session,
 
 	head = l2tp_session_id_hash(tunnel, session->session_id);
 
-	write_lock_bh(&tunnel->hlist_lock);
+	spin_lock_bh(&tunnel->hlist_lock);
 	if (!tunnel->acpt_newsess) {
 		err = -ENODEV;
 		goto err_tlock;
@@ -384,8 +384,8 @@ int l2tp_session_register(struct l2tp_session *session,
 		l2tp_tunnel_inc_refcount(tunnel);
 	}
 
-	hlist_add_head(&session->hlist, head);
-	write_unlock_bh(&tunnel->hlist_lock);
+	hlist_add_head_rcu(&session->hlist, head);
+	spin_unlock_bh(&tunnel->hlist_lock);
 
 	trace_register_session(session);
 
@@ -394,7 +394,7 @@ int l2tp_session_register(struct l2tp_session *session,
 err_tlock_pnlock:
 	spin_unlock_bh(&pn->l2tp_session_hlist_lock);
 err_tlock:
-	write_unlock_bh(&tunnel->hlist_lock);
+	spin_unlock_bh(&tunnel->hlist_lock);
 
 	return err;
 }
@@ -1170,9 +1170,9 @@ static void l2tp_session_unhash(struct l2tp_session *session)
 	/* Remove the session from core hashes */
 	if (tunnel) {
 		/* Remove from the per-tunnel hash */
-		write_lock_bh(&tunnel->hlist_lock);
-		hlist_del_init(&session->hlist);
-		write_unlock_bh(&tunnel->hlist_lock);
+		spin_lock_bh(&tunnel->hlist_lock);
+		hlist_del_init_rcu(&session->hlist);
+		spin_unlock_bh(&tunnel->hlist_lock);
 
 		/* For L2TPv3 we have a per-net hash: remove from there, too */
 		if (tunnel->version != L2TP_HDR_VER_2) {
@@ -1181,8 +1181,9 @@ static void l2tp_session_unhash(struct l2tp_session *session)
 			spin_lock_bh(&pn->l2tp_session_hlist_lock);
 			hlist_del_init_rcu(&session->global_hlist);
 			spin_unlock_bh(&pn->l2tp_session_hlist_lock);
-			synchronize_rcu();
 		}
+
+		synchronize_rcu();
 	}
 }
 
@@ -1190,22 +1191,19 @@ static void l2tp_session_unhash(struct l2tp_session *session)
  */
 static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 {
-	int hash;
-	struct hlist_node *walk;
-	struct hlist_node *tmp;
 	struct l2tp_session *session;
+	int hash;
 
-	write_lock_bh(&tunnel->hlist_lock);
+	spin_lock_bh(&tunnel->hlist_lock);
 	tunnel->acpt_newsess = false;
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
 again:
-		hlist_for_each_safe(walk, tmp, &tunnel->session_hlist[hash]) {
-			session = hlist_entry(walk, struct l2tp_session, hlist);
-			hlist_del_init(&session->hlist);
+		hlist_for_each_entry_rcu(session, &tunnel->session_hlist[hash], hlist) {
+			hlist_del_init_rcu(&session->hlist);
 
-			write_unlock_bh(&tunnel->hlist_lock);
+			spin_unlock_bh(&tunnel->hlist_lock);
 			l2tp_session_delete(session);
-			write_lock_bh(&tunnel->hlist_lock);
+			spin_lock_bh(&tunnel->hlist_lock);
 
 			/* Now restart from the beginning of this hash
 			 * chain.  We always remove a session from the
@@ -1215,7 +1213,7 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 			goto again;
 		}
 	}
-	write_unlock_bh(&tunnel->hlist_lock);
+	spin_unlock_bh(&tunnel->hlist_lock);
 }
 
 /* Tunnel socket destroy hook for UDP encapsulation */
@@ -1408,7 +1406,7 @@ int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 
 	tunnel->magic = L2TP_TUNNEL_MAGIC;
 	sprintf(&tunnel->name[0], "tunl %u", tunnel_id);
-	rwlock_init(&tunnel->hlist_lock);
+	spin_lock_init(&tunnel->hlist_lock);
 	tunnel->acpt_newsess = true;
 
 	tunnel->encap = encap;
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 98ea98eb9567..a88e070b431d 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -160,7 +160,7 @@ struct l2tp_tunnel {
 	unsigned long		dead;
 
 	struct rcu_head rcu;
-	rwlock_t		hlist_lock;	/* protect session_hlist */
+	spinlock_t		hlist_lock;	/* write-protection for session_hlist */
 	bool			acpt_newsess;	/* indicates whether this tunnel accepts
 						 * new sessions. Protected by hlist_lock.
 						 */
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index bca75bef8282..acf6e1343b88 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -120,24 +120,21 @@ static void l2tp_dfs_seq_stop(struct seq_file *p, void *v)
 static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 {
 	struct l2tp_tunnel *tunnel = v;
+	struct l2tp_session *session;
 	int session_count = 0;
 	int hash;
-	struct hlist_node *walk;
-	struct hlist_node *tmp;
 
-	read_lock_bh(&tunnel->hlist_lock);
+	rcu_read_lock_bh();
 	for (hash = 0; hash < L2TP_HASH_SIZE; hash++) {
-		hlist_for_each_safe(walk, tmp, &tunnel->session_hlist[hash]) {
-			struct l2tp_session *session;
-
-			session = hlist_entry(walk, struct l2tp_session, hlist);
+		hlist_for_each_entry_rcu(session, &tunnel->session_hlist[hash], hlist) {
+			/* Session ID of zero is a dummy/reserved value used by pppol2tp */
 			if (session->session_id == 0)
 				continue;
 
 			session_count++;
 		}
 	}
-	read_unlock_bh(&tunnel->hlist_lock);
+	rcu_read_unlock_bh();
 
 	seq_printf(m, "\nTUNNEL %u peer %u", tunnel->tunnel_id, tunnel->peer_tunnel_id);
 	if (tunnel->sock) {
-- 
2.17.1

