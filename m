Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F891D089D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbgEMGcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729880AbgEMG2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:14 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4A2C061A0C;
        Tue, 12 May 2020 23:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eyAruZdqZ/GqReCoW2dlggnX7vcsXfgyfym1psK0Qy4=; b=a2OmO8ud3Y4vygBhHR40fF0YjS
        8mkgDk7og1F5E3P3drhZCOzPZHbda6MmDSPrJL5HeaQHGzLvVFo8+H35posIZtH+PT4iY03rHic03
        BFV7pe2lKPcgLCucmv4E9ZLHEG3Oid/a7VT/xh3Mj+YvtfEohgQhOPQamWFYhD7IV4bAnuyhvLgLr
        4c32T3A/Svju9rvMlZ6b+3Q/MW6UoYHnn/QCAw42J0zBr5U2+1txx9nUtNbUdu6Rf5pk4OFdIjQTa
        wvS+9lHzoQd8BgueBVfCa8V4V4fUQZOSi/VIyL0P0P4qOhc9SFNpWJkRmDDNeaboacwY7tCPSXzh9
        ZPgMG0ig==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkrg-0004QD-3a; Wed, 13 May 2020 06:27:36 +0000
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
Subject: [PATCH 15/33] tcp: add tcp_sock_set_keepidle
Date:   Wed, 13 May 2020 08:26:30 +0200
Message-Id: <20200513062649.2100053-16-hch@lst.de>
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

Add a helper to directly set the TCP_KEEP_IDLE sockopt from kernel
space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/tcp.h   |  1 +
 net/ipv4/tcp.c        | 49 ++++++++++++++++++++++++++++++-------------
 net/rds/tcp_listen.c  |  5 +----
 net/sunrpc/xprtsock.c |  3 +--
 4 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 69c988f84a184..4d3a3e959e45b 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -499,5 +499,6 @@ void tcp_sock_set_nodelay(struct sock *sk, bool on);
 void tcp_sock_set_quickack(struct sock *sk, int val);
 int tcp_sock_set_syncnt(struct sock *sk, int val);
 void tcp_sock_set_user_timeout(struct sock *sk, u32 val);
+int tcp_sock_set_keepidle(struct sock *sk, int val);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9a8d062b17a48..22eb9159c7d05 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2890,6 +2890,39 @@ void tcp_sock_set_user_timeout(struct sock *sk, u32 val)
 }
 EXPORT_SYMBOL(tcp_sock_set_user_timeout);
 
+static int __tcp_sock_set_keepidle(struct sock *sk, int val)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (val < 1 || val > MAX_TCP_KEEPIDLE)
+		return -EINVAL;
+
+	tp->keepalive_time = val * HZ;
+	if (sock_flag(sk, SOCK_KEEPOPEN) &&
+	    !((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN))) {
+		u32 elapsed = keepalive_time_elapsed(tp);
+
+		if (tp->keepalive_time > elapsed)
+			elapsed = tp->keepalive_time - elapsed;
+		else
+			elapsed = 0;
+		inet_csk_reset_keepalive_timer(sk, elapsed);
+	}
+
+	return 0;
+}
+
+int tcp_sock_set_keepidle(struct sock *sk, int val)
+{
+	int err;
+
+	lock_sock(sk);
+	err = __tcp_sock_set_keepidle(sk, val);
+	release_sock(sk);
+	return err;
+}
+EXPORT_SYMBOL(tcp_sock_set_keepidle);
+
 /*
  *	Socket option code for TCP.
  */
@@ -3059,21 +3092,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		break;
 
 	case TCP_KEEPIDLE:
-		if (val < 1 || val > MAX_TCP_KEEPIDLE)
-			err = -EINVAL;
-		else {
-			tp->keepalive_time = val * HZ;
-			if (sock_flag(sk, SOCK_KEEPOPEN) &&
-			    !((1 << sk->sk_state) &
-			      (TCPF_CLOSE | TCPF_LISTEN))) {
-				u32 elapsed = keepalive_time_elapsed(tp);
-				if (tp->keepalive_time > elapsed)
-					elapsed = tp->keepalive_time - elapsed;
-				else
-					elapsed = 0;
-				inet_csk_reset_keepalive_timer(sk, elapsed);
-			}
-		}
+		err = __tcp_sock_set_keepidle(sk, val);
 		break;
 	case TCP_KEEPINTVL:
 		if (val < 1 || val > MAX_TCP_KEEPINTVL)
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index e76ec64b43fe7..8c76969d8c878 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -52,10 +52,7 @@ int rds_tcp_keepalive(struct socket *sock)
 	if (ret < 0)
 		goto bail;
 
-	ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_KEEPIDLE,
-				(char *)&keepidle, sizeof(keepidle));
-	if (ret < 0)
-		goto bail;
+	tcp_sock_set_keepidle(sock->sk, keepidle);
 
 	/* KEEPINTVL is the interval between successive probes. We follow
 	 * the model in xs_tcp_finish_connecting() and re-use keepidle.
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 30d4c4fcd3e38..ea79446789c69 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2107,8 +2107,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 
 	/* TCP Keepalive options */
 	sock_set_keepalive(sock->sk, 1);
-	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPIDLE,
-			(char *)&keepidle, sizeof(keepidle));
+	tcp_sock_set_keepidle(sock->sk, keepidle);
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPINTVL,
 			(char *)&keepidle, sizeof(keepidle));
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT,
-- 
2.26.2

