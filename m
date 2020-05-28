Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29EF11E559E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbgE1FOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgE1FOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:14:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAA2C05BD1E;
        Wed, 27 May 2020 22:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=El21RsQvoe4su07D1xd5LvSJKGBTGSQ1DZmCIUEZHFs=; b=F4Mm/E2SA3U5Mluz2d/lWlc4fy
        WpF86GeJU3CsLvaYB17KWWIHI9E1bXwygh2i2wsItB+Ooge6mt1v40cwKqy57p7up3jcA8DHq0HF2
        s58W/jg2OyfktgeNlJJhjm2QCVLpuwXva9UhyYOr87CjUscKFmZS8VQyDOlaGpY0WlXRSkenLCUzb
        fOWIU48dPb9snOpRtYIBKdmbOAyuzxl1ARgL9sSMGHTiAXd9Px60yC7KLT9zmbK4v5QFdZ2PsKbpQ
        O9uunWgOqY4wZFoQ0ZKwBRYuI6cE3rN4GfNZlGgONbVwdOynm/NQizTUqGcjojTJkUmTa5uJV+tUt
        kQ9xg7dQ==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeArI-0002Bd-68; Thu, 28 May 2020 05:13:36 +0000
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
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 17/28] tcp: add tcp_sock_set_keepcnt
Date:   Thu, 28 May 2020 07:12:25 +0200
Message-Id: <20200528051236.620353-18-hch@lst.de>
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

Add a helper to directly set the TCP_KEEPCNT sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/tcp.h   |  1 +
 net/ipv4/tcp.c        | 12 ++++++++++++
 net/rds/tcp.h         |  2 +-
 net/rds/tcp_listen.c  | 17 +++--------------
 net/sunrpc/xprtsock.c |  3 +--
 5 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 1f9bada00faab..9aac824c523cf 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -498,6 +498,7 @@ int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
 		  int shiftlen);
 
 void tcp_sock_set_cork(struct sock *sk, bool on);
+int tcp_sock_set_keepcnt(struct sock *sk, int val);
 int tcp_sock_set_keepidle(struct sock *sk, int val);
 int tcp_sock_set_keepintvl(struct sock *sk, int val);
 void tcp_sock_set_nodelay(struct sock *sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7eb083e09786a..15d47d5e79510 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2946,6 +2946,18 @@ int tcp_sock_set_keepintvl(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_sock_set_keepintvl);
 
+int tcp_sock_set_keepcnt(struct sock *sk, int val)
+{
+	if (val < 1 || val > MAX_TCP_KEEPCNT)
+		return -EINVAL;
+
+	lock_sock(sk);
+	tcp_sk(sk)->keepalive_probes = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(tcp_sock_set_keepcnt);
+
 /*
  *	Socket option code for TCP.
  */
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index f6d75d8cb167a..bad9cf49d5657 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -70,7 +70,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6);
 void rds_tcp_listen_stop(struct socket *sock, struct work_struct *acceptor);
 void rds_tcp_listen_data_ready(struct sock *sk);
 int rds_tcp_accept_one(struct socket *sock);
-int rds_tcp_keepalive(struct socket *sock);
+void rds_tcp_keepalive(struct socket *sock);
 void *rds_tcp_listen_sock_def_readable(struct net *net);
 
 /* tcp_recv.c */
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 9ad555c48d15d..101cf14215a0b 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -38,27 +38,19 @@
 #include "rds.h"
 #include "tcp.h"
 
-int rds_tcp_keepalive(struct socket *sock)
+void rds_tcp_keepalive(struct socket *sock)
 {
 	/* values below based on xs_udp_default_timeout */
 	int keepidle = 5; /* send a probe 'keepidle' secs after last data */
 	int keepcnt = 5; /* number of unack'ed probes before declaring dead */
-	int ret = 0;
 
 	sock_set_keepalive(sock->sk);
-
-	ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_KEEPCNT,
-				(char *)&keepcnt, sizeof(keepcnt));
-	if (ret < 0)
-		goto bail;
-
+	tcp_sock_set_keepcnt(sock->sk, keepcnt);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
 	/* KEEPINTVL is the interval between successive probes. We follow
 	 * the model in xs_tcp_finish_connecting() and re-use keepidle.
 	 */
 	tcp_sock_set_keepintvl(sock->sk, keepidle);
-bail:
-	return ret;
 }
 
 /* rds_tcp_accept_one_path(): if accepting on cp_index > 0, make sure the
@@ -140,10 +132,7 @@ int rds_tcp_accept_one(struct socket *sock)
 	new_sock->ops = sock->ops;
 	__module_get(new_sock->ops->owner);
 
-	ret = rds_tcp_keepalive(new_sock);
-	if (ret < 0)
-		goto out;
-
+	rds_tcp_keepalive(new_sock);
 	rds_tcp_tune(new_sock);
 
 	inet = inet_sk(new_sock->sk);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 5ca64e12af0c5..0d3ec055bc12f 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2109,8 +2109,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 	sock_set_keepalive(sock->sk);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
 	tcp_sock_set_keepintvl(sock->sk, keepidle);
-	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT,
-			(char *)&keepcnt, sizeof(keepcnt));
+	tcp_sock_set_keepcnt(sock->sk, keepcnt);
 
 	/* TCP user timeout (see RFC5482) */
 	tcp_sock_set_user_timeout(sock->sk, timeo);
-- 
2.26.2

