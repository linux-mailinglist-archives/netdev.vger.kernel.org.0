Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D01D07ED
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgEMG2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730530AbgEMG2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D66C061A0C;
        Tue, 12 May 2020 23:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lMcK9CNUbL+jju+sk+Za5xMNx7m0mtw5FFKEm8NMVMg=; b=K/jg5G3eSawPK0UgXqlgiKpniO
        iQGminHfpsZ0iAQm5G2xvHE6Ts2uFMeueVjStcfcc6mPDGVam7oYNQ5fEdQjya7SUoWTVv+vq+1Av
        5dyDRT7peBilThhJ541YhcelQiUZw3QUdNPVhiBg9Sm6DJyIbitzrjQ5GQR4ji0cN/BRm4+KMm0ve
        NaTz4eZNC4YIHuybjoe0Wd4aYxLDNjeqB89uRkKqPLfZmsONQh4VhN2pkjvJbvCcsn+/MGYeqB1pO
        Ud1BoyUghJ52iAtNvvkZ/HL/8DEkGLSApB9bLnUv/vRUHnGY+E7iDuFilz7K3AqjwPEnrts5UZOx9
        YsmiuAXQ==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkri-0004T2-Vl; Wed, 13 May 2020 06:27:39 +0000
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
Subject: [PATCH 16/33] tcp: add tcp_sock_set_keepintvl
Date:   Wed, 13 May 2020 08:26:31 +0200
Message-Id: <20200513062649.2100053-17-hch@lst.de>
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

Add a helper to directly set the TCP_KEEPINTVL sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/tcp.h   |  1 +
 net/ipv4/tcp.c        | 12 ++++++++++++
 net/rds/tcp_listen.c  |  4 +---
 net/sunrpc/xprtsock.c |  3 +--
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 4d3a3e959e45b..dad18ca361c01 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -500,5 +500,6 @@ void tcp_sock_set_quickack(struct sock *sk, int val);
 int tcp_sock_set_syncnt(struct sock *sk, int val);
 void tcp_sock_set_user_timeout(struct sock *sk, u32 val);
 int tcp_sock_set_keepidle(struct sock *sk, int val);
+int tcp_sock_set_keepintvl(struct sock *sk, int val);
 
 #endif	/* _LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 22eb9159c7d05..b714f2b2fa54e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2923,6 +2923,18 @@ int tcp_sock_set_keepidle(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_sock_set_keepidle);
 
+int tcp_sock_set_keepintvl(struct sock *sk, int val)
+{
+	if (val < 1 || val > MAX_TCP_KEEPINTVL)
+		return -EINVAL;
+
+	lock_sock(sk);
+	tcp_sk(sk)->keepalive_intvl = val * HZ;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(tcp_sock_set_keepintvl);
+
 /*
  *	Socket option code for TCP.
  */
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 8c76969d8c878..a5db2f8bb7339 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -53,12 +53,10 @@ int rds_tcp_keepalive(struct socket *sock)
 		goto bail;
 
 	tcp_sock_set_keepidle(sock->sk, keepidle);
-
 	/* KEEPINTVL is the interval between successive probes. We follow
 	 * the model in xs_tcp_finish_connecting() and re-use keepidle.
 	 */
-	ret = kernel_setsockopt(sock, IPPROTO_TCP, TCP_KEEPINTVL,
-				(char *)&keepidle, sizeof(keepidle));
+	tcp_sock_set_keepintvl(sock->sk, keepidle);
 bail:
 	return ret;
 }
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index ea79446789c69..e20de4a52edb7 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2108,8 +2108,7 @@ static void xs_tcp_set_socket_timeouts(struct rpc_xprt *xprt,
 	/* TCP Keepalive options */
 	sock_set_keepalive(sock->sk, 1);
 	tcp_sock_set_keepidle(sock->sk, keepidle);
-	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPINTVL,
-			(char *)&keepidle, sizeof(keepidle));
+	tcp_sock_set_keepintvl(sock->sk, keepidle);
 	kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT,
 			(char *)&keepcnt, sizeof(keepcnt));
 
-- 
2.26.2

