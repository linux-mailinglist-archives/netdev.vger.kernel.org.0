Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9631DBE86
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgETT4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgETT4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:56:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB12C05BD43;
        Wed, 20 May 2020 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vfMrG7nDokj8+aO1KhUXxIxXtVkzpK8p71ITxY3IU/o=; b=h33jNwXNmVn1qecYR9x2B8AEWY
        feLD5o8G+vodmZ9uHeQ/S8YyXMuVO2JrOKF1b1Sbf2DbK5PnJhdK/OwwyknswoDEmE2GPRVvapVWM
        ypF3nELNpvxFkHKtY2e5fBPjjbc/T3hRZC5dVkcUD/tGKgK1wAnTxIB/LYsEe5gY/tSwSB50T8pH/
        GOuREmArMng8+BXHsmIaTR4eXgG6J1vtsdskjRVVDXfp5sE3+HVo9i3OsNZ3bykI/B79KRyhFJF9l
        lf5nApqMomZPp3MVdafaeiDI/dypLhecBl/vNK1uWkU0/uaYSQ0Ej8aqOnFgTt4hztkUKFm3xHpes
        8spt5law==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUoA-0001u5-W8; Wed, 20 May 2020 19:55:19 +0000
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
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH 03/33] net: add sock_set_reuseaddr
Date:   Wed, 20 May 2020 21:54:39 +0200
Message-Id: <20200520195509.2215098-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520195509.2215098-1-hch@lst.de>
References: <20200520195509.2215098-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly set the SO_REUSEADDR sockopt from kernel space
without going through a fake uaccess.

For this the iscsi target now has to formally depend on inet to avoid
a mostly theoretical compile failure.  For actual operation it already
did depend on having ipv4 or ipv6 support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/infiniband/sw/siw/siw_cm.c        | 18 +++++-------------
 drivers/nvme/target/tcp.c                 |  8 +-------
 drivers/target/iscsi/Kconfig              |  2 +-
 drivers/target/iscsi/iscsi_target_login.c |  9 +--------
 fs/dlm/lowcomms.c                         |  6 +-----
 include/net/sock.h                        |  2 ++
 net/core/sock.c                           |  8 ++++++++
 7 files changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 559e5fd3bad8b..d1860f3e87401 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1312,17 +1312,14 @@ static void siw_cm_llp_state_change(struct sock *sk)
 static int kernel_bindconnect(struct socket *s, struct sockaddr *laddr,
 			      struct sockaddr *raddr)
 {
-	int rv, flags = 0, s_val = 1;
+	int rv, flags = 0;
 	size_t size = laddr->sa_family == AF_INET ?
 		sizeof(struct sockaddr_in) : sizeof(struct sockaddr_in6);
 
 	/*
 	 * Make address available again asap.
 	 */
-	rv = kernel_setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&s_val,
-			       sizeof(s_val));
-	if (rv < 0)
-		return rv;
+	sock_set_reuseaddr(s->sk);
 
 	rv = s->ops->bind(s, laddr, size);
 	if (rv < 0)
@@ -1781,7 +1778,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 	struct siw_cep *cep = NULL;
 	struct siw_device *sdev = to_siw_dev(id->device);
 	int addr_family = id->local_addr.ss_family;
-	int rv = 0, s_val;
+	int rv = 0;
 
 	if (addr_family != AF_INET && addr_family != AF_INET6)
 		return -EAFNOSUPPORT;
@@ -1793,13 +1790,8 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
 	/*
 	 * Allow binding local port when still in TIME_WAIT from last close.
 	 */
-	s_val = 1;
-	rv = kernel_setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&s_val,
-			       sizeof(s_val));
-	if (rv) {
-		siw_dbg(id->device, "setsockopt error: %d\n", rv);
-		goto error;
-	}
+	sock_set_reuseaddr(s->sk);
+
 	if (addr_family == AF_INET) {
 		struct sockaddr_in *laddr = &to_sockaddr_in(id->local_addr);
 
diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index f0da04e960f40..40757a63f4553 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1632,6 +1632,7 @@ static int nvmet_tcp_add_port(struct nvmet_port *nport)
 	port->sock->sk->sk_user_data = port;
 	port->data_ready = port->sock->sk->sk_data_ready;
 	port->sock->sk->sk_data_ready = nvmet_tcp_listen_data_ready;
+	sock_set_reuseaddr(port->sock->sk);
 
 	opt = 1;
 	ret = kernel_setsockopt(port->sock, IPPROTO_TCP,
@@ -1641,13 +1642,6 @@ static int nvmet_tcp_add_port(struct nvmet_port *nport)
 		goto err_sock;
 	}
 
-	ret = kernel_setsockopt(port->sock, SOL_SOCKET, SO_REUSEADDR,
-			(char *)&opt, sizeof(opt));
-	if (ret) {
-		pr_err("failed to set SO_REUSEADDR sock opt %d\n", ret);
-		goto err_sock;
-	}
-
 	if (so_priority > 0) {
 		ret = kernel_setsockopt(port->sock, SOL_SOCKET, SO_PRIORITY,
 				(char *)&so_priority, sizeof(so_priority));
diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
index 1f93ea3813536..922484ea4e304 100644
--- a/drivers/target/iscsi/Kconfig
+++ b/drivers/target/iscsi/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config ISCSI_TARGET
 	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
-	depends on NET
+	depends on INET
 	select CRYPTO
 	select CRYPTO_CRC32C
 	select CRYPTO_CRC32C_INTEL if X86
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 731ee67fe914b..91acb3f07b4cc 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -909,14 +909,7 @@ int iscsit_setup_np(
 		}
 	}
 
-	/* FIXME: Someone please explain why this is endian-safe */
-	ret = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,
-			(char *)&opt, sizeof(opt));
-	if (ret < 0) {
-		pr_err("kernel_setsockopt() for SO_REUSEADDR"
-			" failed\n");
-		goto fail;
-	}
+	sock_set_reuseaddr(sock->sk);
 
 	ret = kernel_setsockopt(sock, IPPROTO_IP, IP_FREEBIND,
 			(char *)&opt, sizeof(opt));
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index f13dad0fd9ef3..88f2574ca63ad 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1127,12 +1127,8 @@ static struct socket *tcp_create_listen_sock(struct connection *con,
 	kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY, (char *)&one,
 			  sizeof(one));
 
-	result = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,
-				   (char *)&one, sizeof(one));
+	sock_set_reuseaddr(sock->sk);
 
-	if (result < 0) {
-		log_print("Failed to set SO_REUSEADDR on socket: %d", result);
-	}
 	write_lock_bh(&sock->sk->sk_callback_lock);
 	sock->sk->sk_user_data = con;
 	save_listen_callbacks(sock);
diff --git a/include/net/sock.h b/include/net/sock.h
index 3e8c6d4b4b59f..2ec085044790c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,4 +2688,6 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 
 void sock_def_readable(struct sock *sk);
 
+void sock_set_reuseaddr(struct sock *sk);
+
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index fd85e651ce284..18eb84fdf5fbe 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -712,6 +712,14 @@ bool sk_mc_loop(struct sock *sk)
 }
 EXPORT_SYMBOL(sk_mc_loop);
 
+void sock_set_reuseaddr(struct sock *sk)
+{
+	lock_sock(sk);
+	sk->sk_reuse = SK_CAN_REUSE;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_reuseaddr);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
-- 
2.26.2

