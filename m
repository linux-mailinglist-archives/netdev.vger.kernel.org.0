Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73E822ADC5
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgGWLaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:30:07 -0400
Received: from mail.katalix.com ([3.9.82.81]:44038 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgGWLaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 07:30:05 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 639868AD7F;
        Thu, 23 Jul 2020 12:30:03 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595503803; bh=SH4ZCZ/Kfb88uMC9zgmdRF/Jij9YCFNthS/e6TBRCGw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=201/6]=20l2tp:=20cleanup=20compa
         risons=20to=20NULL|Date:=20Thu,=2023=20Jul=202020=2012:29:50=20+01
         00|Message-Id:=20<20200723112955.19808-2-tparkin@katalix.com>|In-R
         eply-To:=20<20200723112955.19808-1-tparkin@katalix.com>|References
         :=20<20200723112955.19808-1-tparkin@katalix.com>;
        b=T91k8vJyaS+s1cnMbfDDM30kKq14eEpz/k16YiiDsizDbfETJtvCWP0WTRJNDoIQ2
         kPm7eWG0ja47H02Pm4ZmsOsSK0+yIoGagkikrtUkvs45d6jlIXgMDhGyxAxUnX08T/
         7h+xdkhOpCjHSgiexD716ufW44z1Y31I+lvHXg7ElzjGAl2SOYKIUAAEo0IQfr+VQ7
         bv0jDdorBFjYZ8wXGNBnIGaokDLjAINUH0Wr2u5vfKAWbI4ZPt4SFh4X6jjHtzsvl/
         LjfTe1U4AoV48dVa1IhIUBwBB/fhsY7kvoO41Mzj0a+KxGZCxntmNyV19EdrDv6IKe
         hLvUW2iuY9eKQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 1/6] l2tp: cleanup comparisons to NULL
Date:   Thu, 23 Jul 2020 12:29:50 +0100
Message-Id: <20200723112955.19808-2-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723112955.19808-1-tparkin@katalix.com>
References: <20200723112955.19808-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warns about comparisons to NULL, e.g.

        CHECK: Comparison to NULL could be written "!rt"
        #474: FILE: net/l2tp/l2tp_ip.c:474:
        +       if (rt == NULL) {

These sort of comparisons are generally clearer and more readable
the way checkpatch suggests, so update l2tp accordingly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 20 ++++++++++----------
 net/l2tp/l2tp_debugfs.c | 12 ++++++------
 net/l2tp/l2tp_ip.c      |  2 +-
 net/l2tp/l2tp_ip6.c     |  2 +-
 net/l2tp/l2tp_netlink.c | 23 +++++++++++------------
 net/l2tp/l2tp_ppp.c     | 36 ++++++++++++++++++------------------
 6 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 6871611d99f2..2f3e6b3a7d8e 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -412,7 +412,7 @@ static void l2tp_recv_dequeue_skb(struct l2tp_session *session, struct sk_buff *
 	}
 
 	/* call private receive handler */
-	if (session->recv_skb != NULL)
+	if (session->recv_skb)
 		(*session->recv_skb)(session, skb, L2TP_SKB_CB(skb)->length);
 	else
 		kfree_skb(skb);
@@ -911,7 +911,7 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	struct l2tp_tunnel *tunnel;
 
 	tunnel = rcu_dereference_sk_user_data(sk);
-	if (tunnel == NULL)
+	if (!tunnel)
 		goto pass_up;
 
 	l2tp_dbg(tunnel, L2TP_MSG_DATA, "%s: received %d bytes\n",
@@ -1150,7 +1150,7 @@ static void l2tp_tunnel_destruct(struct sock *sk)
 {
 	struct l2tp_tunnel *tunnel = l2tp_tunnel(sk);
 
-	if (tunnel == NULL)
+	if (!tunnel)
 		goto end;
 
 	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing...\n", tunnel->name);
@@ -1189,7 +1189,7 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 	struct hlist_node *tmp;
 	struct l2tp_session *session;
 
-	BUG_ON(tunnel == NULL);
+	BUG_ON(!tunnel);
 
 	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: closing all sessions...\n",
 		  tunnel->name);
@@ -1214,7 +1214,7 @@ static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel)
 			__l2tp_session_unhash(session);
 			l2tp_session_queue_purge(session);
 
-			if (session->session_close != NULL)
+			if (session->session_close)
 				(*session->session_close)(session);
 
 			l2tp_session_dec_refcount(session);
@@ -1407,11 +1407,11 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	int err;
 	enum l2tp_encap_type encap = L2TP_ENCAPTYPE_UDP;
 
-	if (cfg != NULL)
+	if (cfg)
 		encap = cfg->encap;
 
 	tunnel = kzalloc(sizeof(struct l2tp_tunnel), GFP_KERNEL);
-	if (tunnel == NULL) {
+	if (!tunnel) {
 		err = -ENOMEM;
 		goto err;
 	}
@@ -1426,7 +1426,7 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	rwlock_init(&tunnel->hlist_lock);
 	tunnel->acpt_newsess = true;
 
-	if (cfg != NULL)
+	if (cfg)
 		tunnel->debug = cfg->debug;
 
 	tunnel->encap = encap;
@@ -1615,7 +1615,7 @@ int l2tp_session_delete(struct l2tp_session *session)
 
 	__l2tp_session_unhash(session);
 	l2tp_session_queue_purge(session);
-	if (session->session_close != NULL)
+	if (session->session_close)
 		(*session->session_close)(session);
 
 	l2tp_session_dec_refcount(session);
@@ -1648,7 +1648,7 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 	struct l2tp_session *session;
 
 	session = kzalloc(sizeof(struct l2tp_session) + priv_size, GFP_KERNEL);
-	if (session != NULL) {
+	if (session) {
 		session->magic = L2TP_SESSION_MAGIC;
 		session->tunnel = tunnel;
 
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index ebe03bbb5948..117a6697da72 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -58,7 +58,7 @@ static void l2tp_dfs_next_session(struct l2tp_dfs_seq_data *pd)
 	pd->session = l2tp_session_get_nth(pd->tunnel, pd->session_idx);
 	pd->session_idx++;
 
-	if (pd->session == NULL) {
+	if (!pd->session) {
 		pd->session_idx = 0;
 		l2tp_dfs_next_tunnel(pd);
 	}
@@ -72,16 +72,16 @@ static void *l2tp_dfs_seq_start(struct seq_file *m, loff_t *offs)
 	if (!pos)
 		goto out;
 
-	BUG_ON(m->private == NULL);
+	BUG_ON(!m->private);
 	pd = m->private;
 
-	if (pd->tunnel == NULL)
+	if (!pd->tunnel)
 		l2tp_dfs_next_tunnel(pd);
 	else
 		l2tp_dfs_next_session(pd);
 
 	/* NULL tunnel and session indicates end of list */
-	if ((pd->tunnel == NULL) && (pd->session == NULL))
+	if (!pd->tunnel && !pd->session)
 		pd = NULL;
 
 out:
@@ -221,7 +221,7 @@ static void l2tp_dfs_seq_session_show(struct seq_file *m, void *v)
 		   atomic_long_read(&session->stats.rx_bytes),
 		   atomic_long_read(&session->stats.rx_errors));
 
-	if (session->show != NULL)
+	if (session->show)
 		session->show(m, session);
 }
 
@@ -268,7 +268,7 @@ static int l2tp_dfs_seq_open(struct inode *inode, struct file *file)
 	int rc = -ENOMEM;
 
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-	if (pd == NULL)
+	if (!pd)
 		goto out;
 
 	/* Derive the network namespace from the pid opening the
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 70f9fdaf6c86..d81564cf1e7f 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -471,7 +471,7 @@ static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		rt = (struct rtable *)__sk_dst_check(sk, 0);
 
 	rcu_read_lock();
-	if (rt == NULL) {
+	if (!rt) {
 		const struct ip_options_rcu *inet_opt;
 
 		inet_opt = rcu_dereference(inet->inet_opt);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index ca7696147c7e..614febf8dd0d 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -486,7 +486,7 @@ static int l2tp_ip6_push_pending_frames(struct sock *sk)
 	int err = 0;
 
 	skb = skb_peek(&sk->sk_write_queue);
-	if (skb == NULL)
+	if (!skb)
 		goto out;
 
 	transhdr = (__be32 *)skb_transport_header(skb);
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 42b409bc0de7..fc26ebad2f4f 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -333,7 +333,7 @@ static int l2tp_nl_tunnel_send(struct sk_buff *skb, u32 portid, u32 seq, int fla
 		goto nla_put_failure;
 
 	nest = nla_nest_start_noflag(skb, L2TP_ATTR_STATS);
-	if (nest == NULL)
+	if (!nest)
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(skb, L2TP_ATTR_TX_PACKETS,
@@ -475,7 +475,7 @@ static int l2tp_nl_cmd_tunnel_dump(struct sk_buff *skb, struct netlink_callback
 
 	for (;;) {
 		tunnel = l2tp_tunnel_get_nth(net, ti);
-		if (tunnel == NULL)
+		if (!tunnel)
 			goto out;
 
 		if (l2tp_nl_tunnel_send(skb, NETLINK_CB(cb->skb).portid,
@@ -598,14 +598,13 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		cfg.reorder_timeout = nla_get_msecs(info->attrs[L2TP_ATTR_RECV_TIMEOUT]);
 
 #ifdef CONFIG_MODULES
-	if (l2tp_nl_cmd_ops[cfg.pw_type] == NULL) {
+	if (!l2tp_nl_cmd_ops[cfg.pw_type]) {
 		genl_unlock();
 		request_module("net-l2tp-type-%u", cfg.pw_type);
 		genl_lock();
 	}
 #endif
-	if ((l2tp_nl_cmd_ops[cfg.pw_type] == NULL) ||
-	    (l2tp_nl_cmd_ops[cfg.pw_type]->session_create == NULL)) {
+	if (!l2tp_nl_cmd_ops[cfg.pw_type] || !l2tp_nl_cmd_ops[cfg.pw_type]->session_create) {
 		ret = -EPROTONOSUPPORT;
 		goto out_tunnel;
 	}
@@ -637,7 +636,7 @@ static int l2tp_nl_cmd_session_delete(struct sk_buff *skb, struct genl_info *inf
 	u16 pw_type;
 
 	session = l2tp_nl_session_get(info);
-	if (session == NULL) {
+	if (!session) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -662,7 +661,7 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 	struct l2tp_session *session;
 
 	session = l2tp_nl_session_get(info);
-	if (session == NULL) {
+	if (!session) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -729,7 +728,7 @@ static int l2tp_nl_session_send(struct sk_buff *skb, u32 portid, u32 seq, int fl
 		goto nla_put_failure;
 
 	nest = nla_nest_start_noflag(skb, L2TP_ATTR_STATS);
-	if (nest == NULL)
+	if (!nest)
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(skb, L2TP_ATTR_TX_PACKETS,
@@ -774,7 +773,7 @@ static int l2tp_nl_cmd_session_get(struct sk_buff *skb, struct genl_info *info)
 	int ret;
 
 	session = l2tp_nl_session_get(info);
-	if (session == NULL) {
+	if (!session) {
 		ret = -ENODEV;
 		goto err;
 	}
@@ -813,14 +812,14 @@ static int l2tp_nl_cmd_session_dump(struct sk_buff *skb, struct netlink_callback
 	int si = cb->args[1];
 
 	for (;;) {
-		if (tunnel == NULL) {
+		if (!tunnel) {
 			tunnel = l2tp_tunnel_get_nth(net, ti);
-			if (tunnel == NULL)
+			if (!tunnel)
 				goto out;
 		}
 
 		session = l2tp_session_get_nth(tunnel, si);
-		if (session == NULL) {
+		if (!session) {
 			ti++;
 			l2tp_tunnel_dec_refcount(tunnel);
 			tunnel = NULL;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index f894dc275393..7404661d4117 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -154,12 +154,12 @@ static inline struct l2tp_session *pppol2tp_sock_to_session(struct sock *sk)
 {
 	struct l2tp_session *session;
 
-	if (sk == NULL)
+	if (!sk)
 		return NULL;
 
 	sock_hold(sk);
 	session = (struct l2tp_session *)(sk->sk_user_data);
-	if (session == NULL) {
+	if (!session) {
 		sock_put(sk);
 		goto out;
 	}
@@ -217,7 +217,7 @@ static void pppol2tp_recv(struct l2tp_session *session, struct sk_buff *skb, int
 	 */
 	rcu_read_lock();
 	sk = rcu_dereference(ps->sk);
-	if (sk == NULL)
+	if (!sk)
 		goto no_sock;
 
 	/* If the first two bytes are 0xFF03, consider that it is the PPP's
@@ -285,7 +285,7 @@ static int pppol2tp_sendmsg(struct socket *sock, struct msghdr *m,
 	/* Get session and tunnel contexts */
 	error = -EBADF;
 	session = pppol2tp_sock_to_session(sk);
-	if (session == NULL)
+	if (!session)
 		goto error;
 
 	tunnel = session->tunnel;
@@ -360,7 +360,7 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 
 	/* Get session and tunnel contexts from the socket */
 	session = pppol2tp_sock_to_session(sk);
-	if (session == NULL)
+	if (!session)
 		goto abort;
 
 	tunnel = session->tunnel;
@@ -703,7 +703,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	 * tunnel id.
 	 */
 	if (!info.session_id && !info.peer_session_id) {
-		if (tunnel == NULL) {
+		if (!tunnel) {
 			struct l2tp_tunnel_cfg tcfg = {
 				.encap = L2TP_ENCAPTYPE_UDP,
 				.debug = 0,
@@ -738,11 +738,11 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	} else {
 		/* Error if we can't find the tunnel */
 		error = -ENOENT;
-		if (tunnel == NULL)
+		if (!tunnel)
 			goto end;
 
 		/* Error if socket is not prepped */
-		if (tunnel->sock == NULL)
+		if (!tunnel->sock)
 			goto end;
 	}
 
@@ -911,14 +911,14 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 	struct pppol2tp_session *pls;
 
 	error = -ENOTCONN;
-	if (sk == NULL)
+	if (!sk)
 		goto end;
 	if (!(sk->sk_state & PPPOX_CONNECTED))
 		goto end;
 
 	error = -EBADF;
 	session = pppol2tp_sock_to_session(sk);
-	if (session == NULL)
+	if (!session)
 		goto end;
 
 	pls = l2tp_session_priv(session);
@@ -1263,13 +1263,13 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 		return -EFAULT;
 
 	err = -ENOTCONN;
-	if (sk->sk_user_data == NULL)
+	if (!sk->sk_user_data)
 		goto end;
 
 	/* Get session context from the socket */
 	err = -EBADF;
 	session = pppol2tp_sock_to_session(sk);
-	if (session == NULL)
+	if (!session)
 		goto end;
 
 	/* Special case: if session_id == 0x0000, treat as operation on tunnel
@@ -1382,13 +1382,13 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 		return -EINVAL;
 
 	err = -ENOTCONN;
-	if (sk->sk_user_data == NULL)
+	if (!sk->sk_user_data)
 		goto end;
 
 	/* Get the session context */
 	err = -EBADF;
 	session = pppol2tp_sock_to_session(sk);
-	if (session == NULL)
+	if (!session)
 		goto end;
 
 	/* Special case: if session_id == 0x0000, treat as operation on tunnel */
@@ -1464,7 +1464,7 @@ static void pppol2tp_next_session(struct net *net, struct pppol2tp_seq_data *pd)
 	pd->session = l2tp_session_get_nth(pd->tunnel, pd->session_idx);
 	pd->session_idx++;
 
-	if (pd->session == NULL) {
+	if (!pd->session) {
 		pd->session_idx = 0;
 		pppol2tp_next_tunnel(net, pd);
 	}
@@ -1479,17 +1479,17 @@ static void *pppol2tp_seq_start(struct seq_file *m, loff_t *offs)
 	if (!pos)
 		goto out;
 
-	BUG_ON(m->private == NULL);
+	BUG_ON(!m->private);
 	pd = m->private;
 	net = seq_file_net(m);
 
-	if (pd->tunnel == NULL)
+	if (!pd->tunnel)
 		pppol2tp_next_tunnel(net, pd);
 	else
 		pppol2tp_next_session(net, pd);
 
 	/* NULL tunnel and session indicates end of list */
-	if ((pd->tunnel == NULL) && (pd->session == NULL))
+	if (!pd->tunnel && !pd->session)
 		pd = NULL;
 
 out:
-- 
2.17.1

