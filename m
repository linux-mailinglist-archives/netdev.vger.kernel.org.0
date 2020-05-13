Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666531D088F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732388AbgEMGb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730184AbgEMG2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C74C061A0C;
        Tue, 12 May 2020 23:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Wqpz/YHVys+3+V4n922rnWjqskUSr7rVHwKz6MtQm0M=; b=gWswBV4Z9Jo1BtuAMeZSEBAtd0
        eT2BsU0VBu7Dd9o9XUJMc4mlAZlAkgN87W1LvZwQgduNR96RTi5KAMZqvQsguW2VHslIl1w0V7syR
        SFHFx/baUH/UoG9lhAEE2yyoE/bNtqAhBAyNJisJTZoDivlm4xY2fklh6hVRq29xRb3DazB6PP5BJ
        tsPlcjDij8l/gSccoaGoXr6mW38KJRFWIP0muoU9pVc2Fgt2E2iNb1Az/hbDYkAELbG+IryLcRKKH
        SHn3N/V0v4Ee+0r7gusOCi9yKXU4LOuwXnHDmkxI/wWajk3giJI/49m2FEGuuXVG5Jb/Z1eEysTuP
        QLazpX2Q==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkrU-0004Fl-Eq; Wed, 13 May 2020 06:27:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: [PATCH 11/33] tcp: tcp_sock_set_nodelay
Date:   Wed, 13 May 2020 08:26:26 +0200
Message-Id: <20200513062649.2100053-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
References: <20200513062649.2100053-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly set the TCP_NODELAY sockopt from kernel space
without going through a fake uaccess.  Cleanup the callers to avoid
pointless wrappers now that this is a simple function call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_int.h             |  7 ----
 drivers/block/drbd/drbd_main.c            |  2 +-
 drivers/block/drbd/drbd_receiver.c        |  4 +--
 drivers/infiniband/sw/siw/siw_cm.c        | 24 +++-----------
 drivers/nvme/host/tcp.c                   |  9 +-----
 drivers/nvme/target/tcp.c                 | 12 ++-----
 drivers/target/iscsi/iscsi_target_login.c | 15 ++-------
 fs/cifs/connect.c                         | 10 ++----
 fs/dlm/lowcomms.c                         |  8 ++---
 fs/ocfs2/cluster/tcp.c                    | 20 ++----------
 include/linux/tcp.h                       |  1 +
 net/ceph/messenger.c                      | 11 ++-----
 net/ipv4/tcp.c                            | 39 +++++++++++++++--------
 net/rds/tcp.c                             | 11 +------
 net/rds/tcp.h                             |  1 -
 net/rds/tcp_listen.c                      |  2 +-
 16 files changed, 49 insertions(+), 127 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 3550adc93c68b..e24bba87c8e02 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1570,13 +1570,6 @@ extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
 extern int drbd_connected(struct drbd_peer_device *);
 
-static inline void drbd_tcp_nodelay(struct socket *sock)
-{
-	int val = 1;
-	(void) kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY,
-			(char*)&val, sizeof(val));
-}
-
 static inline void drbd_tcp_quickack(struct socket *sock)
 {
 	int val = 2;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c094c3c2c5d4d..4c876c7d7067f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -660,7 +660,7 @@ static int __send_command(struct drbd_connection *connection, int vnr,
 	/* DRBD protocol "pings" are latency critical.
 	 * This is supposed to trigger tcp_push_pending_frames() */
 	if (!err && (cmd == P_PING || cmd == P_PING_ACK))
-		drbd_tcp_nodelay(sock->socket);
+		tcp_sock_set_nodelay(sock->socket->sk, true);
 
 	return err;
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 55ea907ad33cb..da5a9ee896a43 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1051,8 +1051,8 @@ static int conn_connect(struct drbd_connection *connection)
 
 	/* we don't want delays.
 	 * we use TCP_CORK where appropriate, though */
-	drbd_tcp_nodelay(sock.socket);
-	drbd_tcp_nodelay(msock.socket);
+	tcp_sock_set_nodelay(sock.socket->sk, true);
+	tcp_sock_set_nodelay(msock.socket->sk, true);
 
 	connection->data.socket = sock.socket;
 	connection->meta.socket = msock.socket;
diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 6d7c8c933736c..7781bcddf7e23 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -947,16 +947,8 @@ static void siw_accept_newconn(struct siw_cep *cep)
 	siw_cep_get(new_cep);
 	new_s->sk->sk_user_data = new_cep;
 
-	if (siw_tcp_nagle == false) {
-		int val = 1;
-
-		rv = kernel_setsockopt(new_s, SOL_TCP, TCP_NODELAY,
-				       (char *)&val, sizeof(val));
-		if (rv) {
-			siw_dbg_cep(cep, "setsockopt NODELAY error: %d\n", rv);
-			goto error;
-		}
-	}
+	if (siw_tcp_nagle == false)
+		tcp_sock_set_nodelay(new_s->sk, true);
 	new_cep->state = SIW_EPSTATE_AWAIT_MPAREQ;
 
 	rv = siw_cm_queue_work(new_cep, SIW_CM_WORK_MPATIMEOUT);
@@ -1386,16 +1378,8 @@ int siw_connect(struct iw_cm_id *id, struct iw_cm_conn_param *params)
 		siw_dbg_qp(qp, "kernel_bindconnect: error %d\n", rv);
 		goto error;
 	}
-	if (siw_tcp_nagle == false) {
-		int val = 1;
-
-		rv = kernel_setsockopt(s, SOL_TCP, TCP_NODELAY, (char *)&val,
-				       sizeof(val));
-		if (rv) {
-			siw_dbg_qp(qp, "setsockopt NODELAY error: %d\n", rv);
-			goto error;
-		}
-	}
+	if (siw_tcp_nagle == false)
+		tcp_sock_set_nodelay(s->sk, true);
 	cep = siw_cep_alloc(sdev);
 	if (!cep) {
 		rv = -ENOMEM;
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index cd6a8fc14a139..a8070f93fd0a0 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1346,14 +1346,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	}
 
 	/* Set TCP no delay */
-	opt = 1;
-	ret = kernel_setsockopt(queue->sock, IPPROTO_TCP,
-			TCP_NODELAY, (char *)&opt, sizeof(opt));
-	if (ret) {
-		dev_err(nctrl->device,
-			"failed to set TCP_NODELAY sock opt %d\n", ret);
-		goto err_sock;
-	}
+	tcp_sock_set_nodelay(queue->sock->sk, true);
 
 	/*
 	 * Cleanup whatever is sitting in the TCP transmit queue on socket
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 778c1ce3137b7..b2bfa791c5cb2 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1580,7 +1580,7 @@ static int nvmet_tcp_add_port(struct nvmet_port *nport)
 {
 	struct nvmet_tcp_port *port;
 	__kernel_sa_family_t af;
-	int opt, ret;
+	int ret;
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
@@ -1625,15 +1625,7 @@ static int nvmet_tcp_add_port(struct nvmet_port *nport)
 	port->data_ready = port->sock->sk->sk_data_ready;
 	port->sock->sk->sk_data_ready = nvmet_tcp_listen_data_ready;
 	sock_set_reuseaddr(port->sock->sk, SK_CAN_REUSE);
-
-	opt = 1;
-	ret = kernel_setsockopt(port->sock, IPPROTO_TCP,
-			TCP_NODELAY, (char *)&opt, sizeof(opt));
-	if (ret) {
-		pr_err("failed to set TCP_NODELAY sock opt %d\n", ret);
-		goto err_sock;
-	}
-
+	tcp_sock_set_nodelay(port->sock->sk, true);
 	if (so_priority > 0)
 		sock_set_priority(port->sock->sk, so_priority);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 7da59ece3eb99..165fa573bcb29 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -897,20 +897,11 @@ int iscsit_setup_np(
 	/*
 	 * Set SO_REUSEADDR, and disable Nagel Algorithm with TCP_NODELAY.
 	 */
-	/* FIXME: Someone please explain why this is endian-safe */
-	opt = 1;
-	if (np->np_network_transport == ISCSI_TCP) {
-		ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
-				(char *)&opt, sizeof(opt));
-		if (ret < 0) {
-			pr_err("kernel_setsockopt() for TCP_NODELAY"
-				" failed: %d\n", ret);
-			goto fail;
-		}
-	}
-
+	if (np->np_network_transport == ISCSI_TCP)
+		tcp_sock_set_nodelay(sock->sk, true);
 	sock_set_reuseaddr(sock->sk, SK_CAN_REUSE);
 
+	opt = 1;
 	ret = kernel_setsockopt(sock, IPPROTO_IP, IP_FREEBIND,
 			(char *)&opt, sizeof(opt));
 	if (ret < 0) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 28268ed461b82..b0422ed617832 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3929,14 +3929,8 @@ generic_ip_connect(struct TCP_Server_Info *server)
 			socket->sk->sk_rcvbuf = 140 * 1024;
 	}
 
-	if (server->tcp_nodelay) {
-		int val = 1;
-		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
-				(char *)&val, sizeof(val));
-		if (rc)
-			cifs_dbg(FYI, "set TCP_NODELAY socket option error %d\n",
-				 rc);
-	}
+	if (server->tcp_nodelay)
+		tcp_sock_set_nodelay(socket->sk, true);
 
 	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
 		 socket->sk->sk_sndbuf,
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 223c185ecd0c7..b722a09a7ca05 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1128,7 +1128,6 @@ static void tcp_connect_to_sock(struct connection *con)
 	struct sockaddr_storage saddr, src_addr;
 	int addr_len;
 	struct socket *sock = NULL;
-	int one = 1;
 	int result;
 
 	if (con->nodeid == 0) {
@@ -1177,8 +1176,7 @@ static void tcp_connect_to_sock(struct connection *con)
 	log_print("connecting to %d", con->nodeid);
 
 	/* Turn off Nagle's algorithm */
-	kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY, (char *)&one,
-			  sizeof(one));
+	tcp_sock_set_nodelay(sock->sk, true);
 
 	result = sock->ops->connect(sock, (struct sockaddr *)&saddr, addr_len,
 				   O_NONBLOCK);
@@ -1220,7 +1218,6 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 {
 	struct socket *sock = NULL;
 	int result = 0;
-	int one = 1;
 	int addr_len;
 
 	if (dlm_local_addr[0]->ss_family == AF_INET)
@@ -1237,8 +1234,7 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 	}
 
 	/* Turn off Nagle's algorithm */
-	kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY, (char *)&one,
-			  sizeof(one));
+	tcp_sock_set_nodelay(sock->sk, true);
 
 	sock_set_reuseaddr(sock->sk, SK_CAN_REUSE);
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2c512b40a940e..7936e22e39f34 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -1441,14 +1441,6 @@ static void o2net_rx_until_empty(struct work_struct *work)
 	sc_put(sc);
 }
 
-static int o2net_set_nodelay(struct socket *sock)
-{
-	int val = 1;
-
-	return kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY,
-				    (void *)&val, sizeof(val));
-}
-
 static int o2net_set_usertimeout(struct socket *sock)
 {
 	int user_timeout = O2NET_TCP_USER_TIMEOUT;
@@ -1636,11 +1628,7 @@ static void o2net_start_connect(struct work_struct *work)
 		goto out;
 	}
 
-	ret = o2net_set_nodelay(sc->sc_sock);
-	if (ret) {
-		mlog(ML_ERROR, "setting TCP_NODELAY failed with %d\n", ret);
-		goto out;
-	}
+	tcp_sock_set_nodelay(sc->sc_sock->sk, true);
 
 	ret = o2net_set_usertimeout(sock);
 	if (ret) {
@@ -1832,11 +1820,7 @@ static int o2net_accept_one(struct socket *sock, int *more)
 	*more = 1;
 	new_sock->sk->sk_allocation = GFP_ATOMIC;
 
-	ret = o2net_set_nodelay(new_sock);
-	if (ret) {
-		mlog(ML_ERROR, "setting TCP_NODELAY failed with %d\n", ret);
-		goto out;
-	}
+	tcp_sock_set_nodelay(new_sock->sk, true);
 
 	ret = o2net_set_usertimeout(new_sock);
 	if (ret) {
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 7ef0f975a7658..533610b6ae420 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -495,5 +495,6 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 		  int shiftlen);
 
 void tcp_sock_set_cork(struct sock *sk, bool on);
+void tcp_sock_set_nodelay(struct sock *sk, bool on);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f8ca5edc5f2c9..67d5cb2ddc9cb 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -490,15 +490,8 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 		return ret;
 	}
 
-	if (ceph_test_opt(from_msgr(con->msgr), TCP_NODELAY)) {
-		int optval = 1;
-
-		ret = kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY,
-					(char *)&optval, sizeof(optval));
-		if (ret)
-			pr_err("kernel_setsockopt(TCP_NODELAY) failed: %d",
-			       ret);
-	}
+	if (ceph_test_opt(from_msgr(con->msgr), TCP_NODELAY))
+		tcp_sock_set_nodelay(sock->sk, true);
 
 	con->sock = sock;
 	return 0;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e11ba10b90d4c..300ce622607d8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2821,6 +2821,30 @@ void tcp_sock_set_cork(struct sock *sk, bool on)
 }
 EXPORT_SYMBOL(tcp_sock_set_cork);
 
+/* TCP_NODELAY is weaker than TCP_CORK, so that this option on corked socket is
+ * remembered, but it is not activated until cork is cleared.
+ *
+ * However, when TCP_NODELAY is set we make an explicit push, which overrides
+ * even TCP_CORK for currently queued segments.
+ */
+static void __tcp_sock_set_nodelay(struct sock *sk, bool on)
+{
+	if (on) {
+		tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF|TCP_NAGLE_PUSH;
+		tcp_push_pending_frames(sk);
+	} else {
+		tcp_sk(sk)->nonagle &= ~TCP_NAGLE_OFF;
+	}
+}
+
+void tcp_sock_set_nodelay(struct sock *sk, bool on)
+{
+	lock_sock(sk);
+	__tcp_sock_set_nodelay(sk, on);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(tcp_sock_set_nodelay);
+
 /*
  *	Socket option code for TCP.
  */
@@ -2918,20 +2942,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_NODELAY:
-		if (val) {
-			/* TCP_NODELAY is weaker than TCP_CORK, so that
-			 * this option on corked socket is remembered, but
-			 * it is not activated until cork is cleared.
-			 *
-			 * However, when TCP_NODELAY is set we make
-			 * an explicit push, which overrides even TCP_CORK
-			 * for currently queued segments.
-			 */
-			tp->nonagle |= TCP_NAGLE_OFF|TCP_NAGLE_PUSH;
-			tcp_push_pending_frames(sk);
-		} else {
-			tp->nonagle &= ~TCP_NAGLE_OFF;
-		}
+		__tcp_sock_set_nodelay(sk, val);
 		break;
 
 	case TCP_THIN_LINEAR_TIMEOUTS:
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 46782fac4c162..8721803958f6b 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -89,15 +89,6 @@ static struct ctl_table rds_tcp_sysctl_table[] = {
 	{ }
 };
 
-/* doing it this way avoids calling tcp_sk() */
-void rds_tcp_nonagle(struct socket *sock)
-{
-	int val = 1;
-
-	kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY, (void *)&val,
-			      sizeof(val));
-}
-
 u32 rds_tcp_write_seq(struct rds_tcp_connection *tc)
 {
 	/* seq# of the last byte of data in tcp send buffer */
@@ -502,7 +493,7 @@ void rds_tcp_tune(struct socket *sock)
 	struct net *net = sock_net(sk);
 	struct rds_tcp_net *rtn = net_generic(net, rds_tcp_netid);
 
-	rds_tcp_nonagle(sock);
+	tcp_sock_set_nodelay(sock->sk, true);
 	lock_sock(sk);
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index 3c69361d21c73..39ac666d09c6c 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -50,7 +50,6 @@ struct rds_tcp_statistics {
 
 /* tcp.c */
 void rds_tcp_tune(struct socket *sock);
-void rds_tcp_nonagle(struct socket *sock);
 void rds_tcp_set_callbacks(struct socket *sock, struct rds_conn_path *cp);
 void rds_tcp_reset_callbacks(struct socket *sock, struct rds_conn_path *cp);
 void rds_tcp_restore_callbacks(struct socket *sock,
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index a55b39cd45a6c..e76ec64b43fe7 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -293,7 +293,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6)
 	}
 
 	sock->sk->sk_reuse = SK_CAN_REUSE;
-	rds_tcp_nonagle(sock);
+	tcp_sock_set_nodelay(sock->sk, true);
 
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	sock->sk->sk_user_data = sock->sk->sk_data_ready;
-- 
2.26.2

