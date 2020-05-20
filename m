Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8AA1DBE8B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgETT4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgETT4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:56:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7140CC061A0E;
        Wed, 20 May 2020 12:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=i5gzlZfmXUuIBw3Csz0XurxqeATQQuTIPLX7NZ3IHJc=; b=Yf8Ka3KY10PsFQLSQ0S7PJwbz9
        /nh5S639e1X1O5QwFd3tu0u+AyQ4K3+hlTVIKPTnIIw/vDZO1lg6HKQhxT+kaECLnHIKZmCZ70jig
        /azcg0Gyk6j/PFKUf1YC7jwW8/bRbEifwsOY10bTlg2nI2PIC8UL8QZG0hOV7187M8HcogWW31O5E
        1j6S/k6P5anvVQnxYi4ald6MEHrDvZF36fB+sJVvQOkismQQ5U12aDGuTrQKspD6rUGBGp1+f5RlC
        XNL96I/2JQo0Jr/+CFB+42e38fw49FLT0lfB7gdTl0B6WEUcC57e1Xr4/f1F3frhNwNuNtUplCQnV
        KpFdtCnw==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUoV-0002Rc-8B; Wed, 20 May 2020 19:55:39 +0000
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
        linux-nfs@vger.kernel.org
Subject: [PATCH 10/33] net: add sock_set_rcvbuf
Date:   Wed, 20 May 2020 21:54:46 +0200
Message-Id: <20200520195509.2215098-11-hch@lst.de>
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

Add a helper to directly set the SO_RCVBUFFORCE sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c  |  7 +-----
 include/net/sock.h |  1 +
 net/core/sock.c    | 59 +++++++++++++++++++++++++---------------------
 3 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index b6e6dba281547..2822a430a2b49 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1180,7 +1180,6 @@ static int sctp_listen_for_all(void)
 	struct socket *sock = NULL;
 	int result = -EINVAL;
 	struct connection *con = nodeid2con(0, GFP_NOFS);
-	int bufsize = NEEDED_RMEM;
 	int one = 1;
 
 	if (!con)
@@ -1195,11 +1194,7 @@ static int sctp_listen_for_all(void)
 		goto out;
 	}
 
-	result = kernel_setsockopt(sock, SOL_SOCKET, SO_RCVBUFFORCE,
-				 (char *)&bufsize, sizeof(bufsize));
-	if (result)
-		log_print("Error increasing buffer space on socket %d", result);
-
+	sock_set_rcvbuf(sock->sk, NEEDED_RMEM);
 	result = kernel_setsockopt(sock, SOL_SCTP, SCTP_NODELAY, (char *)&one,
 				   sizeof(one));
 	if (result < 0)
diff --git a/include/net/sock.h b/include/net/sock.h
index dc08c176238fd..c997289aabbf9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2693,6 +2693,7 @@ void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
 void sock_set_keepalive(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
+void sock_set_rcvbuf(struct sock *sk, int val);
 void sock_set_reuseaddr(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 728f5fb156a0c..3c6ebf952e9ad 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -789,6 +789,35 @@ void sock_set_keepalive(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_set_keepalive);
 
+static void __sock_set_rcvbuf(struct sock *sk, int val)
+{
+	/* Ensure val * 2 fits into an int, to prevent max_t() from treating it
+	 * as a negative value.
+	 */
+	val = min_t(int, val, INT_MAX / 2);
+	sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
+
+	/* We double it on the way in to account for "struct sk_buff" etc.
+	 * overhead.   Applications assume that the SO_RCVBUF setting they make
+	 * will allow that much actual data to be received on that socket.
+	 *
+	 * Applications are unaware that "struct sk_buff" and other overheads
+	 * allocate from the receive buffer during socket buffer allocation.
+	 *
+	 * And after considering the possible alternatives, returning the value
+	 * we actually used in getsockopt is the most desirable behavior.
+	 */
+	WRITE_ONCE(sk->sk_rcvbuf, max_t(int, val * 2, SOCK_MIN_RCVBUF));
+}
+
+void sock_set_rcvbuf(struct sock *sk, int val)
+{
+	lock_sock(sk);
+	__sock_set_rcvbuf(sk, val);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_rcvbuf);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -885,30 +914,7 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
 		 * are treated in BSD as hints
 		 */
-		val = min_t(u32, val, sysctl_rmem_max);
-set_rcvbuf:
-		/* Ensure val * 2 fits into an int, to prevent max_t()
-		 * from treating it as a negative value.
-		 */
-		val = min_t(int, val, INT_MAX / 2);
-		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
-		/*
-		 * We double it on the way in to account for
-		 * "struct sk_buff" etc. overhead.   Applications
-		 * assume that the SO_RCVBUF setting they make will
-		 * allow that much actual data to be received on that
-		 * socket.
-		 *
-		 * Applications are unaware that "struct sk_buff" and
-		 * other overheads allocate from the receive buffer
-		 * during socket buffer allocation.
-		 *
-		 * And after considering the possible alternatives,
-		 * returning the value we actually used in getsockopt
-		 * is the most desirable behavior.
-		 */
-		WRITE_ONCE(sk->sk_rcvbuf,
-			   max_t(int, val * 2, SOCK_MIN_RCVBUF));
+		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
 		break;
 
 	case SO_RCVBUFFORCE:
@@ -920,9 +926,8 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		/* No negative values (to prevent underflow, as val will be
 		 * multiplied by 2).
 		 */
-		if (val < 0)
-			val = 0;
-		goto set_rcvbuf;
+		__sock_set_rcvbuf(sk, max(val, 0));
+		break;
 
 	case SO_KEEPALIVE:
 		if (sk->sk_prot->keepalive)
-- 
2.26.2

