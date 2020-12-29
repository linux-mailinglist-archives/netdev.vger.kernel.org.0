Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089762E6FE9
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 12:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgL2LSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 06:18:43 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:41772 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgL2LSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 06:18:41 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 7D8C9521073;
        Tue, 29 Dec 2020 14:07:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1609240051;
        bh=OlCfpBQWWs9k+AFighkRDc552vhkswuQIALcBAHNf3c=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=DzJkxkWB2uuIBhnV6+upkow3BEo0EDAXGoFXPN9umYB7rK2CxXvOxKdE3WY6uos35
         aGW9DuFHZ5lxEncR7k3hFHKBVmGfhRSsGpRVUv2MnaHSt/7T5VODO44DBXgnPJJ/Wb
         Y6fdtYECnPX/QaPB3keHC2daNlWh1qGLFEo7YWsA=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 3348C52106C;
        Tue, 29 Dec 2020 14:07:31 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Tue, 29
 Dec 2020 14:07:30 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <arseny.krasnov@kaspersky.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] vsock: support for SOCK_SEQPACKET socket.
Date:   Tue, 29 Dec 2020 14:07:17 +0300
Message-ID: <20201229110718.275247-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 12/29/2020 10:50:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 160932 [Dec 29 2020]
X-KSE-AntiSpam-Info: LuaCore: 419 419 70b0c720f8ddd656e5f4eb4a4449cf8ce400df94
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/29/2020 10:54:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 29.12.2020 9:12:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2020/12/29 10:34:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2020/12/29 09:12:00 #15977073
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	1) Add socket ops for SOCK_SEQPACKET type.
	2) For receive, create another loop. It looks like
	   stream receive loop, but it doesn't call notify
	   callbacks, it doesn't care about 'SO_SNDLOWAT' and
	   'SO_RCVLOWAT' values, it waits until whole record is
	   received or error in found during receiving and it takes
	   care about 'MSG_TRUNC' flag.
	3) Update some comments('stream' -> 'connect oriented').

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 460 +++++++++++++++++++++++++++++++--------
 1 file changed, 366 insertions(+), 94 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b12d3a322242..be488d1a1fc7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -415,8 +415,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
 
 /* Assign a transport to a socket and call the .init transport callback.
  *
- * Note: for stream socket this must be called when vsk->remote_addr is set
- * (e.g. during the connect() or when a connection request on a listener
+ * Note: for connect oriented socket this must be called when vsk->remote_addr
+ * is set (e.g. during the connect() or when a connection request on a listener
  * socket is received).
  * The vsk->remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
@@ -452,6 +452,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		new_transport = transport_dgram;
 		break;
 	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
@@ -459,6 +460,12 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
+
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			if (!new_transport->seqpacket_seq_send_len ||
+			    !new_transport->seqpacket_seq_get_len)
+				return -ENODEV;
+		}
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;
@@ -469,10 +476,10 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 			return 0;
 
 		/* transport->release() must be called with sock lock acquired.
-		 * This path can only be taken during vsock_stream_connect(),
-		 * where we have already held the sock lock.
-		 * In the other cases, this function is called on a new socket
-		 * which is not assigned to any transport.
+		 * This path can only be taken during vsock_connect(), where we
+		 * have already held the sock lock. In the other cases, this
+		 * function is called on a new socket which is not assigned to
+		 * any transport.
 		 */
 		vsk->transport->release(vsk);
 		vsock_deassign_transport(vsk);
@@ -604,8 +611,8 @@ static void vsock_pending_work(struct work_struct *work)
 
 /**** SOCKET OPERATIONS ****/
 
-static int __vsock_bind_stream(struct vsock_sock *vsk,
-			       struct sockaddr_vm *addr)
+static int __vsock_bind_connectible(struct vsock_sock *vsk,
+				    struct sockaddr_vm *addr)
 {
 	static u32 port;
 	struct sockaddr_vm new_addr;
@@ -649,9 +656,10 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,
 
 	vsock_addr_init(&vsk->local_addr, new_addr.svm_cid, new_addr.svm_port);
 
-	/* Remove stream sockets from the unbound list and add them to the hash
-	 * table for easy lookup by its address.  The unbound list is simply an
-	 * extra entry at the end of the hash table, a trick used by AF_UNIX.
+	/* Remove connect oriented sockets from the unbound list and add them
+	 * to the hash table for easy lookup by its address.  The unbound list
+	 * is simply an extra entry at the end of the hash table, a trick used
+	 * by AF_UNIX.
 	 */
 	__vsock_remove_bound(vsk);
 	__vsock_insert_bound(vsock_bound_sockets(&vsk->local_addr), vsk);
@@ -684,8 +692,9 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 
 	switch (sk->sk_socket->type) {
 	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
 		spin_lock_bh(&vsock_table_lock);
-		retval = __vsock_bind_stream(vsk, addr);
+		retval = __vsock_bind_connectible(vsk, addr);
 		spin_unlock_bh(&vsock_table_lock);
 		break;
 
@@ -767,6 +776,11 @@ static struct sock *__vsock_create(struct net *net,
 	return sk;
 }
 
+static bool sock_type_connectible(u16 type)
+{
+	return (type == SOCK_STREAM || type == SOCK_SEQPACKET);
+}
+
 static void __vsock_release(struct sock *sk, int level)
 {
 	if (sk) {
@@ -785,7 +799,7 @@ static void __vsock_release(struct sock *sk, int level)
 
 		if (vsk->transport)
 			vsk->transport->release(vsk);
-		else if (sk->sk_type == SOCK_STREAM)
+		else if (sock_type_connectible(sk->sk_type))
 			vsock_remove_sock(vsk);
 
 		sock_orphan(sk);
@@ -936,16 +950,16 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	if ((mode & ~SHUTDOWN_MASK) || !mode)
 		return -EINVAL;
 
-	/* If this is a STREAM socket and it is not connected then bail out
-	 * immediately.  If it is a DGRAM socket then we must first kick the
-	 * socket so that it wakes up from any sleeping calls, for example
-	 * recv(), and then afterwards return the error.
+	/* If this is a connect oriented socket and it is not connected then
+	 * bail out immediately.  If it is a DGRAM socket then we must first
+	 * kick the socket so that it wakes up from any sleeping calls, for
+	 * example recv(), and then afterwards return the error.
 	 */
 
 	sk = sock->sk;
 	if (sock->state == SS_UNCONNECTED) {
 		err = -ENOTCONN;
-		if (sk->sk_type == SOCK_STREAM)
+		if (sock_type_connectible(sk->sk_type))
 			return err;
 	} else {
 		sock->state = SS_DISCONNECTING;
@@ -960,7 +974,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
 		sk->sk_state_change(sk);
 		release_sock(sk);
 
-		if (sk->sk_type == SOCK_STREAM) {
+		if (sock_type_connectible(sk->sk_type)) {
 			sock_reset_flag(sk, SOCK_DONE);
 			vsock_send_shutdown(sk, mode);
 		}
@@ -1013,7 +1027,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
 
-	} else if (sock->type == SOCK_STREAM) {
+	} else if (sock_type_connectible(sk->sk_type)) {
 		const struct vsock_transport *transport = vsk->transport;
 		lock_sock(sk);
 
@@ -1259,8 +1273,8 @@ static void vsock_connect_timeout(struct work_struct *work)
 	sock_put(sk);
 }
 
-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
-				int addr_len, int flags)
+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
+			 int addr_len, int flags)
 {
 	int err;
 	struct sock *sk;
@@ -1410,7 +1424,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	lock_sock(listener);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sock->type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1477,6 +1491,18 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	return err;
 }
 
+static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
+				int addr_len, int flags)
+{
+	return vsock_connect(sock, addr, addr_len, flags);
+}
+
+static int vsock_seqpacket_connect(struct socket *sock, struct sockaddr *addr,
+				   int addr_len, int flags)
+{
+	return vsock_connect(sock, addr, addr_len, flags);
+}
+
 static int vsock_listen(struct socket *sock, int backlog)
 {
 	int err;
@@ -1487,7 +1513,7 @@ static int vsock_listen(struct socket *sock, int backlog)
 
 	lock_sock(sk);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sk->sk_type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1531,11 +1557,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
 	vsk->buffer_size = val;
 }
 
-static int vsock_stream_setsockopt(struct socket *sock,
-				   int level,
-				   int optname,
-				   sockptr_t optval,
-				   unsigned int optlen)
+static int vsock_setsockopt(struct socket *sock,
+			    int level,
+			    int optname,
+			    sockptr_t optval,
+			    unsigned int optlen)
 {
 	int err;
 	struct sock *sk;
@@ -1612,6 +1638,24 @@ static int vsock_stream_setsockopt(struct socket *sock,
 	return err;
 }
 
+static int vsock_seqpacket_setsockopt(struct socket *sock,
+				      int level,
+				      int optname,
+				      sockptr_t optval,
+				      unsigned int optlen)
+{
+	return vsock_setsockopt(sock, level, optname, optval, optlen);
+}
+
+static int vsock_stream_setsockopt(struct socket *sock,
+				   int level,
+				   int optname,
+				   sockptr_t optval,
+				   unsigned int optlen)
+{
+	return vsock_setsockopt(sock, level, optname, optval, optlen);
+}
+
 static int vsock_stream_getsockopt(struct socket *sock,
 				   int level, int optname,
 				   char __user *optval,
@@ -1683,8 +1727,16 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	return 0;
 }
 
-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
-				size_t len)
+static int vsock_seqpacket_getsockopt(struct socket *sock,
+				      int level, int optname,
+				      char __user *optval,
+				      int __user *optlen)
+{
+	return vsock_stream_getsockopt(sock, level, optname, optval, optlen);
+}
+
+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
+				     size_t len)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -1706,7 +1758,9 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 
-	/* Callers should not provide a destination with stream sockets. */
+	/* Callers should not provide a destination with connect oriented
+	 * sockets.
+	 */
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
 		goto out;
@@ -1737,6 +1791,12 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err < 0)
 		goto out;
 
+	if (sk->sk_type == SOCK_SEQPACKET) {
+		err = transport->seqpacket_seq_send_len(vsk, len);
+		if (err < 0)
+			goto out;
+	}
+
 	while (total_written < len) {
 		ssize_t written;
 
@@ -1796,10 +1856,8 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		 * smaller than the queue size.  It is the caller's
 		 * responsibility to check how many bytes we were able to send.
 		 */
-
-		written = transport->stream_enqueue(
-				vsk, msg,
-				len - total_written);
+		written = transport->stream_enqueue(vsk, msg,
+						    len - total_written);
 		if (written < 0) {
 			err = -ENOMEM;
 			goto out_err;
@@ -1815,36 +1873,96 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out_err:
-	if (total_written > 0)
-		err = total_written;
+	if (total_written > 0) {
+		/* Return number of written bytes only if:
+		 * 1) SOCK_STREAM socket.
+		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
+		 */
+		if (sk->sk_type == SOCK_STREAM || total_written == len)
+			err = total_written;
+	}
 out:
 	release_sock(sk);
 	return err;
 }
 
+static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
+				size_t len)
+{
+	return vsock_connectible_sendmsg(sock, msg, len);
+}
 
-static int
-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-		     int flags)
+static int vsock_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
+				   size_t len)
 {
-	struct sock *sk;
+	return vsock_connectible_sendmsg(sock, msg, len);
+}
+
+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
+			   long timeout,
+			   struct vsock_transport_recv_notify_data *recv_data,
+			   size_t target)
+{
+	int err = 0;
 	struct vsock_sock *vsk;
 	const struct vsock_transport *transport;
-	int err;
-	size_t target;
-	ssize_t copied;
-	long timeout;
-	struct vsock_transport_recv_notify_data recv_data;
 
-	DEFINE_WAIT(wait);
-
-	sk = sock->sk;
 	vsk = vsock_sk(sk);
 	transport = vsk->transport;
-	err = 0;
 
+	if (sk->sk_err != 0 ||
+	    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+	    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
+		finish_wait(sk_sleep(sk), wait);
+		return -1;
+	}
+	/* Don't wait for non-blocking sockets. */
+	if (timeout == 0) {
+		err = -EAGAIN;
+		finish_wait(sk_sleep(sk), wait);
+		return err;
+	}
+
+	if (sk->sk_type == SOCK_STREAM) {
+		err = transport->notify_recv_pre_block(vsk, target, recv_data);
+		if (err < 0) {
+			finish_wait(sk_sleep(sk), wait);
+			return err;
+		}
+	}
+
+	release_sock(sk);
+	timeout = schedule_timeout(timeout);
 	lock_sock(sk);
 
+	if (signal_pending(current)) {
+		err = sock_intr_errno(timeout);
+		finish_wait(sk_sleep(sk), wait);
+	} else if (timeout == 0) {
+		err = -EAGAIN;
+		finish_wait(sk_sleep(sk), wait);
+	}
+
+	return err;
+}
+
+static int vsock_wait_data_seqpacket(struct sock *sk, struct wait_queue_entry *wait,
+				     long timeout)
+{
+	return vsock_wait_data(sk, wait, timeout, NULL, 0);
+}
+
+static int vsock_pre_recv_check(struct socket *sock,
+				int flags, size_t len, int *err)
+{
+	struct sock *sk;
+	struct vsock_sock *vsk;
+	const struct vsock_transport *transport;
+
+	sk = sock->sk;
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
 		 * orderly shutdown. Differentiate between that case and when a
@@ -1852,16 +1970,16 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		 * SOCK_DONE flag.
 		 */
 		if (sock_flag(sk, SOCK_DONE))
-			err = 0;
+			*err = 0;
 		else
-			err = -ENOTCONN;
+			*err = -ENOTCONN;
 
-		goto out;
+		return false;
 	}
 
 	if (flags & MSG_OOB) {
-		err = -EOPNOTSUPP;
-		goto out;
+		*err = -EOPNOTSUPP;
+		return false;
 	}
 
 	/* We don't check peer_shutdown flag here since peer may actually shut
@@ -1869,17 +1987,143 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	 * receive.
 	 */
 	if (sk->sk_shutdown & RCV_SHUTDOWN) {
-		err = 0;
-		goto out;
+		*err = 0;
+		return false;
 	}
 
 	/* It is valid on Linux to pass in a zero-length receive buffer.  This
 	 * is not an error.  We may as well bail out now.
 	 */
 	if (!len) {
+		*err = 0;
+		return false;
+	}
+
+	return true;
+}
+
+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	int err = 0;
+	size_t record_len;
+	struct vsock_sock *vsk;
+	const struct vsock_transport *transport;
+	long timeout;
+	ssize_t dequeued_total = 0;
+	unsigned long orig_nr_segs;
+	const struct iovec *orig_iov;
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	msg->msg_flags &= ~MSG_EOR;
+	orig_nr_segs = msg->msg_iter.nr_segs;
+	orig_iov = msg->msg_iter.iov;
+
+	while (1) {
+		s64 ready;
+
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		ready = vsock_stream_has_data(vsk);
+
+		if (ready == 0) {
+			if (vsock_wait_data_seqpacket(sk, &wait, timeout)) {
+				/* In case of any loop break(timeout, signal
+				 * interrupt or shutdown), we report user that
+				 * nothing was copied.
+				 */
+				dequeued_total = 0;
+				break;
+			}
+		} else {
+			ssize_t dequeued;
+
+			finish_wait(sk_sleep(sk), &wait);
+
+			if (ready < 0) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			if (dequeued_total == 0) {
+				record_len =
+					transport->seqpacket_seq_get_len(vsk);
+
+				if (record_len == 0)
+					continue;
+			}
+
+			/* 'msg_iter.count' is number of unused bytes in iov.
+			 * On every copy to iov iterator it is decremented at
+			 * size of data.
+			 */
+			dequeued = transport->stream_dequeue(vsk, msg,
+						msg->msg_iter.count, flags);
+
+			if (dequeued < 0) {
+				dequeued_total = 0;
+
+				if (dequeued == -EAGAIN) {
+					iov_iter_init(&msg->msg_iter, READ,
+						      orig_iov, orig_nr_segs,
+						      len);
+					msg->msg_flags &= ~MSG_EOR;
+					continue;
+				}
+
+				err = -ENOMEM;
+				break;
+			}
+
+			dequeued_total += dequeued;
+
+			if (dequeued_total >= record_len)
+				break;
+		}
+	}
+
+	if (sk->sk_err)
+		err = -sk->sk_err;
+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
 		err = 0;
-		goto out;
+
+	if (dequeued_total > 0) {
+		/* User sets MSG_TRUNC, so return real length of
+		 * packet.
+		 */
+		if (flags & MSG_TRUNC)
+			err = record_len;
+		else
+			err = len - msg->msg_iter.count;
+
+		/* Always set MSG_TRUNC if real length of packet is
+		 * bigger that user buffer.
+		 */
+		if (record_len > len)
+			msg->msg_flags |= MSG_TRUNC;
 	}
+out:
+	return err;
+}
+
+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int flags)
+{
+	int err;
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	size_t target;
+	struct vsock_transport_recv_notify_data recv_data;
+	long timeout;
+	ssize_t copied;
+
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
 
 	/* We must not copy less than target bytes into the user's buffer
 	 * before returning successfully, so we wait for the consume queue to
@@ -1888,10 +2132,12 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	 * queue size.
 	 */
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+
 	if (target >= transport->stream_rcvhiwat(vsk)) {
 		err = -ENOMEM;
 		goto out;
 	}
+
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	copied = 0;
 
@@ -1899,7 +2145,6 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (err < 0)
 		goto out;
 
-
 	while (1) {
 		s64 ready;
 
@@ -1907,38 +2152,8 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		ready = vsock_stream_has_data(vsk);
 
 		if (ready == 0) {
-			if (sk->sk_err != 0 ||
-			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
-			    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
-				finish_wait(sk_sleep(sk), &wait);
+			if (vsock_wait_data(sk, &wait, timeout, &recv_data, target))
 				break;
-			}
-			/* Don't wait for non-blocking sockets. */
-			if (timeout == 0) {
-				err = -EAGAIN;
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			}
-
-			err = transport->notify_recv_pre_block(
-					vsk, target, &recv_data);
-			if (err < 0) {
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			}
-			release_sock(sk);
-			timeout = schedule_timeout(timeout);
-			lock_sock(sk);
-
-			if (signal_pending(current)) {
-				err = sock_intr_errno(timeout);
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			} else if (timeout == 0) {
-				err = -EAGAIN;
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			}
 		} else {
 			ssize_t read;
 
@@ -1959,9 +2174,8 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			if (err < 0)
 				break;
 
-			read = transport->stream_dequeue(
-					vsk, msg,
-					len - copied, flags);
+			read = transport->stream_dequeue(vsk, msg, len - copied, flags);
+
 			if (read < 0) {
 				err = -ENOMEM;
 				break;
@@ -1990,11 +2204,45 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (copied > 0)
 		err = copied;
 
+out:
+	return err;
+}
+
+static int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	struct sock *sk;
+	int err;
+
+	sk = sock->sk;
+
+	lock_sock(sk);
+
+	if (!vsock_pre_recv_check(sock, flags,  len, &err))
+		goto out;
+
+	if (sk->sk_type == SOCK_STREAM)
+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	else
+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
+
 out:
 	release_sock(sk);
 	return err;
 }
 
+static int vsock_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
+				   size_t len, int flags)
+{
+	return vsock_connectible_recvmsg(sock, msg, len, flags);
+}
+
+static int vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg,
+				size_t len, int flags)
+{
+	return vsock_connectible_recvmsg(sock, msg, len, flags);
+}
+
 static const struct proto_ops vsock_stream_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
@@ -2016,6 +2264,27 @@ static const struct proto_ops vsock_stream_ops = {
 	.sendpage = sock_no_sendpage,
 };
 
+static const struct proto_ops vsock_seqpacket_ops = {
+	.family = PF_VSOCK,
+	.owner = THIS_MODULE,
+	.release = vsock_release,
+	.bind = vsock_bind,
+	.connect = vsock_seqpacket_connect,
+	.socketpair = sock_no_socketpair,
+	.accept = vsock_accept,
+	.getname = vsock_getname,
+	.poll = vsock_poll,
+	.ioctl = sock_no_ioctl,
+	.listen = vsock_listen,
+	.shutdown = vsock_shutdown,
+	.setsockopt = vsock_seqpacket_setsockopt,
+	.getsockopt = vsock_seqpacket_getsockopt,
+	.sendmsg = vsock_seqpacket_sendmsg,
+	.recvmsg = vsock_seqpacket_recvmsg,
+	.mmap = sock_no_mmap,
+	.sendpage = sock_no_sendpage,
+};
+
 static int vsock_create(struct net *net, struct socket *sock,
 			int protocol, int kern)
 {
@@ -2036,6 +2305,9 @@ static int vsock_create(struct net *net, struct socket *sock,
 	case SOCK_STREAM:
 		sock->ops = &vsock_stream_ops;
 		break;
+	case SOCK_SEQPACKET:
+		sock->ops = &vsock_seqpacket_ops;
+		break;
 	default:
 		return -ESOCKTNOSUPPORT;
 	}
-- 
2.25.1

