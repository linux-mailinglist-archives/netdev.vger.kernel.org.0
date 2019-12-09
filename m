Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0EB116A7A
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 11:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfLIKER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 05:04:17 -0500
Received: from relay.sw.ru ([185.231.240.75]:57732 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727060AbfLIKEP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 05:04:15 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104] helo=localhost.localdomain)
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1ieFtK-0002QG-EL; Mon, 09 Dec 2019 13:03:46 +0300
Subject: [PATCH net-next v2 2/2] unix: Show number of pending scm files of
 receive queue in fdinfo
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, axboe@kernel.dk,
        pankaj.laxminarayan.bharadiya@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, hare@suse.com, tglx@linutronix.de,
        edumazet@google.com, arnd@arndb.de, ktkhai@virtuozzo.com
Date:   Mon, 09 Dec 2019 13:03:46 +0300
Message-ID: <157588582628.223723.6787992203555637280.stgit@localhost.localdomain>
In-Reply-To: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
References: <157588565669.223723.2766246342567340687.stgit@localhost.localdomain>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unix sockets like a block box. You never know what is stored there:
there may be a file descriptor holding a mount or a block device,
or there may be whole universes with namespaces, sockets with receive
queues full of sockets etc.

The patch adds a little debug and accounts number of files (not recursive),
which is in receive queue of a unix socket. Sometimes this is useful
to determine, that socket should be investigated or which task should
be killed to put reference counter on a resourse.

v2: Pass correct argument to lockdep

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 include/net/af_unix.h |    5 ++++
 net/unix/af_unix.c    |   56 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 5 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 3426d6dacc45..17e10fba2152 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -41,6 +41,10 @@ struct unix_skb_parms {
 	u32			consumed;
 } __randomize_layout;
 
+struct scm_stat {
+	u32 nr_fds;
+};
+
 #define UNIXCB(skb)	(*(struct unix_skb_parms *)&((skb)->cb))
 
 #define unix_state_lock(s)	spin_lock(&unix_sk(s)->lock)
@@ -65,6 +69,7 @@ struct unix_sock {
 #define UNIX_GC_MAYBE_CYCLE	1
 	struct socket_wq	peer_wq;
 	wait_queue_entry_t	peer_wake;
+	struct scm_stat		scm_stat;
 };
 
 static inline struct unix_sock *unix_sk(const struct sock *sk)
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f0a074356012..71d2aa83911a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -676,6 +676,16 @@ static int unix_set_peek_off(struct sock *sk, int val)
 	return 0;
 }
 
+static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	struct unix_sock *u;
+
+	if (sk) {
+		u = unix_sk(sock->sk);
+		seq_printf(m, "scm_fds: %u\n", READ_ONCE(u->scm_stat.nr_fds));
+	}
+}
 
 static const struct proto_ops unix_stream_ops = {
 	.family =	PF_UNIX,
@@ -701,6 +711,7 @@ static const struct proto_ops unix_stream_ops = {
 	.sendpage =	unix_stream_sendpage,
 	.splice_read =	unix_stream_splice_read,
 	.set_peek_off =	unix_set_peek_off,
+	.show_fdinfo =	unix_show_fdinfo,
 };
 
 static const struct proto_ops unix_dgram_ops = {
@@ -726,6 +737,7 @@ static const struct proto_ops unix_dgram_ops = {
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 	.set_peek_off =	unix_set_peek_off,
+	.show_fdinfo =	unix_show_fdinfo,
 };
 
 static const struct proto_ops unix_seqpacket_ops = {
@@ -751,6 +763,7 @@ static const struct proto_ops unix_seqpacket_ops = {
 	.mmap =		sock_no_mmap,
 	.sendpage =	sock_no_sendpage,
 	.set_peek_off =	unix_set_peek_off,
+	.show_fdinfo =	unix_show_fdinfo,
 };
 
 static struct proto unix_proto = {
@@ -788,6 +801,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
 	mutex_init(&u->bindlock); /* single task binding lock */
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
+	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
 	unix_insert_socket(unix_sockets_unbound(sk), sk);
 out:
 	if (sk == NULL)
@@ -1572,6 +1586,28 @@ static bool unix_skb_scm_eq(struct sk_buff *skb,
 	       unix_secdata_eq(scm, skb);
 }
 
+static void scm_stat_add(struct sock *sk, struct sk_buff *skb)
+{
+	struct scm_fp_list *fp = UNIXCB(skb).fp;
+	struct unix_sock *u = unix_sk(sk);
+
+	lockdep_assert_held(&sk->sk_receive_queue.lock);
+
+	if (unlikely(fp && fp->count))
+		u->scm_stat.nr_fds += fp->count;
+}
+
+static void scm_stat_del(struct sock *sk, struct sk_buff *skb)
+{
+	struct scm_fp_list *fp = UNIXCB(skb).fp;
+	struct unix_sock *u = unix_sk(sk);
+
+	lockdep_assert_held(&sk->sk_receive_queue.lock);
+
+	if (unlikely(fp && fp->count))
+		u->scm_stat.nr_fds -= fp->count;
+}
+
 /*
  *	Send AF_UNIX data.
  */
@@ -1757,7 +1793,10 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (sock_flag(other, SOCK_RCVTSTAMP))
 		__net_timestamp(skb);
 	maybe_add_creds(skb, sock, other);
-	skb_queue_tail(&other->sk_receive_queue, skb);
+	spin_lock(&other->sk_receive_queue.lock);
+	scm_stat_add(other, skb);
+	__skb_queue_tail(&other->sk_receive_queue, skb);
+	spin_unlock(&other->sk_receive_queue.lock);
 	unix_state_unlock(other);
 	other->sk_data_ready(other);
 	sock_put(other);
@@ -1859,7 +1898,10 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto pipe_err_free;
 
 		maybe_add_creds(skb, sock, other);
-		skb_queue_tail(&other->sk_receive_queue, skb);
+		spin_lock(&other->sk_receive_queue.lock);
+		scm_stat_add(other, skb);
+		__skb_queue_tail(&other->sk_receive_queue, skb);
+		spin_unlock(&other->sk_receive_queue.lock);
 		unix_state_unlock(other);
 		other->sk_data_ready(other);
 		sent += size;
@@ -2058,8 +2100,8 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 		mutex_lock(&u->iolock);
 
 		skip = sk_peek_offset(sk, flags);
-		skb = __skb_try_recv_datagram(sk, flags, NULL, &skip, &err,
-					      &last);
+		skb = __skb_try_recv_datagram(sk, flags, scm_stat_del,
+					      &skip, &err, &last);
 		if (skb)
 			break;
 
@@ -2353,8 +2395,12 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 
 			sk_peek_offset_bwd(sk, chunk);
 
-			if (UNIXCB(skb).fp)
+			if (UNIXCB(skb).fp) {
+				spin_lock(&sk->sk_receive_queue.lock);
+				scm_stat_del(sk, skb);
+				spin_unlock(&sk->sk_receive_queue.lock);
 				unix_detach_fds(&scm, skb);
+			}
 
 			if (unix_skb_len(skb))
 				break;


