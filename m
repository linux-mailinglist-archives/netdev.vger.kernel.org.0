Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B85F25BDEF
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgICIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:55:26 -0400
Received: from mail.katalix.com ([3.9.82.81]:42258 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgICIzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 04:55:10 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id B90D286C7C;
        Thu,  3 Sep 2020 09:55:07 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1599123307; bh=XOAADEzu4gEcYP8Ht0xMDjkompYPYPufhuL9UacO/sw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=20net-next=205/6]=20l2tp:=20make
         =20magic=20feather=20checks=20more=20useful|Date:=20Thu,=20=203=20
         Sep=202020=2009:54:51=20+0100|Message-Id:=20<20200903085452.9487-6
         -tparkin@katalix.com>|In-Reply-To:=20<20200903085452.9487-1-tparki
         n@katalix.com>|References:=20<20200903085452.9487-1-tparkin@katali
         x.com>;
        b=sf33xgqHSIRwtuB9v6UhiXSg2GGSlrslnOfc4ifoxexilJ6dH3OWLyfPrvR3IgBrL
         SBvfit2a+5MMvpG4CrN7bn4w0rOOAQW6+82zdF8M3WOc/TXAcivp8Nfmea4FFHcU7v
         d2pCjwATAXsQGrbGHkw5NMFLxw27nXi6W7gz1zB8O/6mKrGzHVqXgLTuMJg4In8XnA
         dGMTNSOPLBhSwGf7Kye6w2qC2LGcExV6Omurt+aOJXXsLZNyeXINQZLDsZartth08f
         HlXus9hlYD5gQ3+mRPf88iMPIV1P+aFgAlzGzeRi+1KuHzla0I/nwEOvJrqAtIKKEZ
         K0sv0Utec7/1Q==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH net-next 5/6] l2tp: make magic feather checks more useful
Date:   Thu,  3 Sep 2020 09:54:51 +0100
Message-Id: <20200903085452.9487-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200903085452.9487-1-tparkin@katalix.com>
References: <20200903085452.9487-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The l2tp tunnel and session structures contain a "magic feather" field
which was originally intended to help trace lifetime bugs in the code.

Since the introduction of the shared kernel refcount code in refcount.h,
and l2tp's porting to those APIs, we are covered by the refcount code's
checks and warnings.  Duplicating those checks in the l2tp code isn't
useful.

However, magic feather checks are still useful to help to detect bugs
stemming from misuse/trampling of the sk_user_data pointer in struct
sock.  The l2tp code makes extensive use of sk_user_data to stash
pointers to the tunnel and session structures, and if another subsystem
overwrites sk_user_data it's important to detect this.

As such, rework l2tp's magic feather checks to focus on validating the
tunnel and session data structures when they're extracted from
sk_user_data.

 * Add a new accessor function l2tp_sk_to_tunnel which contains a magic
   feather check, and is used by l2tp_core and l2tp_ip[6]
 * Comment l2tp_udp_encap_recv which doesn't use this new accessor function
   because of the specific nature of the codepath it is called in
 * Drop l2tp_session_queue_purge's check on the session magic feather:
   it is called from code which is walking the tunnel session list, and
   hence doesn't need validation
 * Drop l2tp_session_free's check on the tunnel magic feather: the
   intention of this check is covered by refcount.h's reference count
   sanity checking
 * Add session magic validation in pppol2tp_ioctl.  On failure return
   -EBADF, which mirrors the approach in pppol2tp_[sg]etsockopt.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 40 ++++++++++++++++++++++------------------
 net/l2tp/l2tp_core.h |  5 +++++
 net/l2tp/l2tp_ip.c   |  2 +-
 net/l2tp/l2tp_ip6.c  |  2 +-
 net/l2tp/l2tp_ppp.c  |  9 +++++++++
 5 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index d2672df7e65a..b02b3cc67df0 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -120,11 +120,6 @@ static bool l2tp_sk_is_v6(struct sock *sk)
 }
 #endif
 
-static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
-{
-	return sk->sk_user_data;
-}
-
 static inline struct l2tp_net *l2tp_pernet(const struct net *net)
 {
 	return net_generic(net, l2tp_net_id);
@@ -162,19 +157,23 @@ static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
 
 static void l2tp_session_free(struct l2tp_session *session)
 {
-	struct l2tp_tunnel *tunnel = session->tunnel;
-
 	trace_free_session(session);
+	if (session->tunnel)
+		l2tp_tunnel_dec_refcount(session->tunnel);
+	kfree(session);
+}
 
-	if (tunnel) {
+struct l2tp_tunnel *l2tp_sk_to_tunnel(struct sock *sk)
+{
+	struct l2tp_tunnel *tunnel = sk->sk_user_data;
+
+	if (tunnel)
 		if (WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC))
-			goto out;
-		l2tp_tunnel_dec_refcount(tunnel);
-	}
+			return NULL;
 
-out:
-	kfree(session);
+	return tunnel;
 }
+EXPORT_SYMBOL_GPL(l2tp_sk_to_tunnel);
 
 void l2tp_tunnel_inc_refcount(struct l2tp_tunnel *tunnel)
 {
@@ -782,9 +781,6 @@ static void l2tp_session_queue_purge(struct l2tp_session *session)
 {
 	struct sk_buff *skb = NULL;
 
-	if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
-		return;
-
 	while ((skb = skb_dequeue(&session->reorder_q))) {
 		atomic_long_inc(&session->stats.rx_errors);
 		kfree_skb(skb);
@@ -898,9 +894,17 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct l2tp_tunnel *tunnel;
 
+	/* Note that this is called from the encap_rcv hook inside an
+	 * RCU-protected region, but without the socket being locked.
+	 * Hence we use rcu_dereference_sk_user_data to access the
+	 * tunnel data structure rather the usual l2tp_sk_to_tunnel
+	 * accessor function.
+	 */
 	tunnel = rcu_dereference_sk_user_data(sk);
 	if (!tunnel)
 		goto pass_up;
+	if (WARN_ON(tunnel->magic != L2TP_TUNNEL_MAGIC))
+		goto pass_up;
 
 	if (l2tp_udp_recv_core(tunnel, skb))
 		goto pass_up;
@@ -1118,7 +1122,7 @@ EXPORT_SYMBOL_GPL(l2tp_xmit_skb);
  */
 static void l2tp_tunnel_destruct(struct sock *sk)
 {
-	struct l2tp_tunnel *tunnel = l2tp_tunnel(sk);
+	struct l2tp_tunnel *tunnel = l2tp_sk_to_tunnel(sk);
 
 	if (!tunnel)
 		goto end;
@@ -1219,7 +1223,7 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 /* Tunnel socket destroy hook for UDP encapsulation */
 static void l2tp_udp_encap_destroy(struct sock *sk)
 {
-	struct l2tp_tunnel *tunnel = l2tp_tunnel(sk);
+	struct l2tp_tunnel *tunnel = l2tp_sk_to_tunnel(sk);
 
 	if (tunnel)
 		l2tp_tunnel_delete(tunnel);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 3ce90c3f3491..cb21d906343e 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -273,6 +273,11 @@ void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
 /* IOCTL helper for IP encap modules. */
 int l2tp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 
+/* Extract the tunnel structure from a socket's sk_user_data pointer,
+ * validating the tunnel magic feather.
+ */
+struct l2tp_tunnel *l2tp_sk_to_tunnel(struct sock *sk);
+
 static inline int l2tp_get_l2specific_len(struct l2tp_session *session)
 {
 	switch (session->l2specific_type) {
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 7086d97f293c..97ae1255fcb6 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -233,8 +233,8 @@ static void l2tp_ip_close(struct sock *sk, long timeout)
 
 static void l2tp_ip_destroy_sock(struct sock *sk)
 {
+	struct l2tp_tunnel *tunnel = l2tp_sk_to_tunnel(sk);
 	struct sk_buff *skb;
-	struct l2tp_tunnel *tunnel = sk->sk_user_data;
 
 	while ((skb = __skb_dequeue_tail(&sk->sk_write_queue)) != NULL)
 		kfree_skb(skb);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 409ea8927f6c..e5e5036257b0 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -247,7 +247,7 @@ static void l2tp_ip6_close(struct sock *sk, long timeout)
 
 static void l2tp_ip6_destroy_sock(struct sock *sk)
 {
-	struct l2tp_tunnel *tunnel = sk->sk_user_data;
+	struct l2tp_tunnel *tunnel = l2tp_sk_to_tunnel(sk);
 
 	lock_sock(sk);
 	ip6_flush_pending_frames(sk);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 68d2489fc133..aea85f91f059 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1065,6 +1065,9 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
 		if (!session)
 			return -ENOTCONN;
 
+		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
+			return -EBADF;
+
 		/* Not defined for tunnels */
 		if (!session->session_id && !session->peer_session_id)
 			return -ENOSYS;
@@ -1079,6 +1082,9 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
 		if (!session)
 			return -ENOTCONN;
 
+		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
+			return -EBADF;
+
 		/* Not defined for tunnels */
 		if (!session->session_id && !session->peer_session_id)
 			return -ENOSYS;
@@ -1092,6 +1098,9 @@ static int pppol2tp_ioctl(struct socket *sock, unsigned int cmd,
 		if (!session)
 			return -ENOTCONN;
 
+		if (WARN_ON(session->magic != L2TP_SESSION_MAGIC))
+			return -EBADF;
+
 		/* Session 0 represents the parent tunnel */
 		if (!session->session_id && !session->peer_session_id) {
 			u32 session_id;
-- 
2.17.1

