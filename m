Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA9B1E5612
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgE1FQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727896AbgE1FNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:13:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C6EC05BD1E;
        Wed, 27 May 2020 22:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=pmIaGwQIiRAMsAtZVsU6Qnz/2nddXz94iBei7pEAjtw=; b=Gzt5Z6nk2UiqIP3+CoDW3SMYQ1
        FaPTdUn/7Fj4AM6ZXLI59k+AfRpsN7mwaVa86ZVM2ubDteoFaVYosJzYyPTT1Xa+QFneOekALXmYR
        bZgf3MY41tPjOna5kcYZLW54NWQDGqxZtcBsOQ+a0AfTz6bQkKcD536NUQfeSXjNGbGA9f+orvxrc
        urq7NjeUp2w/X6Z6SSMm6z1Lgi+pzhE41li54wr+OUnc1qG6G/5Lmd4uwECDU3desU+5ZfG6L6tUI
        pcH1KqTwQRrRarFR2p9rimFZVU/txrlzbHOP5QFsbrzjnjyT6gKSS32vrgc3QuGg0sTW04CBpREci
        YbRqWfcw==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeAqz-0001uP-1u; Thu, 28 May 2020 05:13:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 11/28] tcp: add tcp_sock_set_nodelay
Date:   Thu, 28 May 2020 07:12:19 +0200
Message-Id: <20200528051236.620353-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
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
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Acked-by: Jason Gunthorpe <jgg@mellanox.com>
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
index c094c3c2c5d4d..45fbd526c453b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -660,7 +660,7 @@ static int __send_command(struct drbd_connection *connection, int vnr,
 	/* DRBD protocol "pings" are latency critical.
 	 * This is supposed to trigger tcp_push_pending_frames() */
 	if (!err && (cmd == P_PING || cmd == P_PING_ACK))
-		drbd_tcp_nodelay(sock->socket);
+		tcp_sock_set_nodelay(sock->socket->sk);
 
 	return err;
 }
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 55ea907ad33cb..20a5e94494acd 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1051,8 +1051,8 @@ static int conn_connect(struct drbd_connection *connection)
 
 	/* we don't want delays.
 	 * we use TCP_CORK where appropriate, though */
-	drbd_tcp_nodelay(sock.socket);
-	drbd_tcp_nodelay(msock.socket);
+	tcp_sock_set_nodelay(sock.socket->sk);
+	tcp_sock_set_nodelay(msock.socket->sk);
 
 	connection->data.socket = sock.socket;
 	connection->meta.socket = msock.socket;
diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index d1860f3e87401..1662216be66df 100644
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
+		tcp_sock_set_nodelay(new_s->sk);
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
+		tcp_sock_set_nodelay(s->sk);
 	cep = siw_cep_alloc(sdev);
 	if (!cep) {
 		rv = -ENOMEM;
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a307972d33a02..4e4a750ecdb97 100644
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
+	tcp_sock_set_nodelay(queue->sock->sk);
 
 	/*
 	 * Cleanup whatever is sitting in the TCP transmit queue on socket
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index f3088156d01da..55bc4c3c0a74a 100644
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
 	sock_set_reuseaddr(port->sock->sk);
-
-	opt = 1;
-	ret = kernel_setsockopt(port->sock, IPPROTO_TCP,
-			TCP_NODELAY, (char *)&opt, sizeof(opt));
-	if (ret) {
-		pr_err("failed to set TCP_NODELAY sock opt %d\n", ret);
-		goto err_sock;
-	}
-
+	tcp_sock_set_nodelay(port->sock->sk);
 	if (so_priority > 0)
 		sock_set_priority(port->sock->sk, so_priority);
 
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 91acb3f07b4cc..b561b07a869a0 100644
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
+		tcp_sock_set_nodelay(sock->sk);
 	sock_set_reuseaddr(sock->sk);
 
+	opt = 1;
 	ret = kernel_setsockopt(sock, IPPROTO_IP, IP_FREEBIND,
 			(char *)&opt, sizeof(opt));
 	if (ret < 0) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 28268ed461b82..ad8fb53b36827 100644
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
+		tcp_sock_set_nodelay(socket->sk);
 
 	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
 		 socket->sk->sk_sndbuf,
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 45c37f572c9d2..749f9bc548d2a 100644
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
+	tcp_sock_set_nodelay(sock->sk);
 
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
+	tcp_sock_set_nodelay(sock->sk);
 
 	sock_set_reuseaddr(sock->sk);
 
diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 2c512b40a940e..4c70fe9d19ab2 100644
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
+	tcp_sock_set_nodelay(sc->sc_sock->sk);
 
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
+	tcp_sock_set_nodelay(new_sock->sk);
 
 	ret = o2net_set_usertimeout(new_sock);
 	if (ret) {
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 889eeb2256c2d..9e42c7fe50a8b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -498,5 +498,6 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 		  int shiftlen);
 
 void tcp_sock_set_cork(struct sock *sk, bool on);
+void tcp_sock_set_nodelay(struct sock *sk);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index f8ca5edc5f2c9..27d6ab11f9ee8 100644
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
+		tcp_sock_set_nodelay(sock->sk);
 
 	con->sock = sock;
 	return 0;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e6cf702e16d66..a65f293a19fac 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2832,6 +2832,30 @@ void tcp_sock_set_cork(struct sock *sk, bool on)
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
+void tcp_sock_set_nodelay(struct sock *sk)
+{
+	lock_sock(sk);
+	__tcp_sock_set_nodelay(sk, true);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(tcp_sock_set_nodelay);
+
 /*
  *	Socket option code for TCP.
  */
@@ -2929,20 +2953,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
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
index 46782fac4c162..43db0eca911fa 100644
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
+	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index d640e210b97b6..f6d75d8cb167a 100644
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
index d8bd132769594..6f90ea077adcd 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -288,7 +288,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6)
 	}
 
 	sock->sk->sk_reuse = SK_CAN_REUSE;
-	rds_tcp_nonagle(sock);
+	tcp_sock_set_nodelay(sock->sk);
 
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	sock->sk->sk_user_data = sock->sk->sk_data_ready;
-- 
2.26.2

