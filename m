Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5501D0740
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgEMG1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgEMG1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:27:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F3DC061A0C;
        Tue, 12 May 2020 23:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=BLpwCwIpYz3ikENt5wDyD2BUJ7smAfnMj0CZR6I2f/U=; b=nhuXoZu7GOpSo062Lc3aZPDhyR
        HFTUjOvLwB9j1fovydR6PFkBFNgkqZLxrIctB3s3+akBKFBC8mYeCUATXXX1znMSFD0vj/rENlrvk
        n1ksDwN+lfjyFcCa3qqjVJRzGNWuvmR/bdZnCNhKMVdkP3UqAYydceUXU8Ph4LKS+4WZUhtskXkdE
        u5tFSzPIgdm2zdStYsFk4WKRVE5k5gyAqT/bI8GVYDeS/icpcaOeTgm24Dj7rTsyHiA8nKvmK1ObG
        eih6TfucqTgwcURf3XK6OZkBa+LYmMXDoIVYU8QDCoYDeqHk5ZCkEFOJGKU7mp3VU3OJdX49X5yWO
        4ymnKDjg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkr2-0003mH-UE; Wed, 13 May 2020 06:26:57 +0000
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
Subject: [PATCH 02/33] net: add sock_set_linger
Date:   Wed, 13 May 2020 08:26:17 +0200
Message-Id: <20200513062649.2100053-3-hch@lst.de>
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

Add a helper to directly set the SO_LINGER sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/tcp.c   |  9 +--------
 drivers/nvme/target/tcp.c |  6 +-----
 include/net/sock.h        |  1 +
 net/core/sock.c           | 36 +++++++++++++++++++++++++-----------
 net/rds/tcp_listen.c      |  8 +-------
 net/sunrpc/svcsock.c      | 12 ++----------
 6 files changed, 31 insertions(+), 41 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index c15a92163c1f7..5cacb61c73229 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1313,7 +1313,6 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 {
 	struct nvme_tcp_ctrl *ctrl = to_tcp_ctrl(nctrl);
 	struct nvme_tcp_queue *queue = &ctrl->queues[qid];
-	struct linger sol = { .l_onoff = 1, .l_linger = 0 };
 	int ret, opt, rcv_pdu_size;
 
 	queue->ctrl = ctrl;
@@ -1361,13 +1360,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *nctrl,
 	 * close. This is done to prevent stale data from being sent should
 	 * the network connection be restored before TCP times out.
 	 */
-	ret = kernel_setsockopt(queue->sock, SOL_SOCKET, SO_LINGER,
-			(char *)&sol, sizeof(sol));
-	if (ret) {
-		dev_err(nctrl->device,
-			"failed to set SO_LINGER sock opt %d\n", ret);
-		goto err_sock;
-	}
+	sock_set_linger(queue->sock->sk, true, 0);
 
 	if (so_priority > 0) {
 		ret = kernel_setsockopt(queue->sock, SOL_SOCKET, SO_PRIORITY,
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 791aa32beeb98..87aba417189d2 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1429,7 +1429,6 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 {
 	struct socket *sock = queue->sock;
 	struct inet_sock *inet = inet_sk(sock->sk);
-	struct linger sol = { .l_onoff = 1, .l_linger = 0 };
 	int ret;
 
 	ret = kernel_getsockname(sock,
@@ -1447,10 +1446,7 @@ static int nvmet_tcp_set_queue_sock(struct nvmet_tcp_queue *queue)
 	 * close. This is done to prevent stale data from being sent should
 	 * the network connection be restored before TCP times out.
 	 */
-	ret = kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER,
-			(char *)&sol, sizeof(sol));
-	if (ret)
-		return ret;
+	sock_set_linger(sock->sk, true, 0);
 
 	if (so_priority > 0) {
 		ret = kernel_setsockopt(sock, SOL_SOCKET, SO_PRIORITY,
diff --git a/include/net/sock.h b/include/net/sock.h
index e801a147ad746..60890fb47fbc0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,5 +2688,6 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 
 void sock_def_readable(struct sock *sk);
 void sock_set_reuseaddr(struct sock *sk, unsigned char reuse);
+void sock_set_linger(struct sock *sk, bool onoff, unsigned int linger);
 
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index ff4faa3e68ac4..cbc5104ca3515 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -720,6 +720,30 @@ void sock_set_reuseaddr(struct sock *sk, unsigned char reuse)
 }
 EXPORT_SYMBOL(sock_set_reuseaddr);
 
+static void __sock_set_linger(struct sock *sk, bool onoff, unsigned int linger)
+{
+	if (!onoff) {
+		sock_reset_flag(sk, SOCK_LINGER);
+		return;
+	}
+
+#if (BITS_PER_LONG == 32)
+	if (linger >= MAX_SCHEDULE_TIMEOUT / HZ)
+		sk->sk_lingertime = MAX_SCHEDULE_TIMEOUT;
+	else
+#endif
+		sk->sk_lingertime = linger * HZ;
+	sock_set_flag(sk, SOCK_LINGER);
+}
+
+void sock_set_linger(struct sock *sk, bool onoff, unsigned int linger)
+{
+	lock_sock(sk);
+	__sock_set_linger(sk, onoff, linger);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_linger);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -886,17 +910,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			ret = -EFAULT;
 			break;
 		}
-		if (!ling.l_onoff)
-			sock_reset_flag(sk, SOCK_LINGER);
-		else {
-#if (BITS_PER_LONG == 32)
-			if ((unsigned int)ling.l_linger >= MAX_SCHEDULE_TIMEOUT/HZ)
-				sk->sk_lingertime = MAX_SCHEDULE_TIMEOUT;
-			else
-#endif
-				sk->sk_lingertime = (unsigned int)ling.l_linger * HZ;
-			sock_set_flag(sk, SOCK_LINGER);
-		}
+		__sock_set_linger(sk, ling.l_onoff, ling.l_linger);
 		break;
 
 	case SO_BSDCOMPAT:
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 810a3a49e9474..96f7538e5fa8d 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -113,13 +113,7 @@ struct rds_tcp_connection *rds_tcp_accept_one_path(struct rds_connection *conn)
 
 void rds_tcp_set_linger(struct socket *sock)
 {
-	struct linger no_linger = {
-		.l_onoff = 1,
-		.l_linger = 0,
-	};
-
-	kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER,
-			  (char *)&no_linger, sizeof(no_linger));
+	sock_set_linger(sock->sk, true, 0);
 }
 
 int rds_tcp_accept_one(struct socket *sock)
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 023514e392b31..0f6b78d0e6170 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -323,17 +323,9 @@ static int svc_tcp_has_wspace(struct svc_xprt *xprt)
 
 static void svc_tcp_kill_temp_xprt(struct svc_xprt *xprt)
 {
-	struct svc_sock *svsk;
-	struct socket *sock;
-	struct linger no_linger = {
-		.l_onoff = 1,
-		.l_linger = 0,
-	};
+	struct svc_sock *svsk = container_of(xprt, struct svc_sock, sk_xprt);
 
-	svsk = container_of(xprt, struct svc_sock, sk_xprt);
-	sock = svsk->sk_sock;
-	kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER,
-			  (char *)&no_linger, sizeof(no_linger));
+	sock_set_linger(svsk->sk_sock->sk, true, 0);
 }
 
 /*
-- 
2.26.2

