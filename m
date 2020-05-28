Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3801E561F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgE1FQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgE1FNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:13:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ED7C05BD1E;
        Wed, 27 May 2020 22:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lR78mSGloKOw4Rm59o11Y3p0CvdJlgBCc0uACk8cE6g=; b=QPEZGWIlFdzkmtrM0IoDKMLNol
        JPCziw5iBlWGCJFzMs05+0F/2knZ+OOeuVVlubew5fJjZrLiQw6rbNVwCGwhVaonbMlf5C6ZTNtA5
        Jcry3c4fMDaGzEItff+X1hiRfyBcSZGD++fz8gQJ48vx27+FzR9jxR4iA+zn2/YoCG89X9UUi39Ns
        oo46Q9sr2itZVGufaznYwVr+zPBGpvsH9TCKHw+uL6PJA7Romon6vVxccFocqonCRoJEkxXHRSEQP
        XJmyhgIjPB6AA2bOl/MsgFn3oMV4hsN6Y77l8tpQsU//z/S2L5aFq5HlTWsyfrZ/V0JmZyuCck8Qc
        oMiDenDQ==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeAqr-0001oS-Dz; Thu, 28 May 2020 05:13:10 +0000
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
Subject: [PATCH 09/28] net: add sock_set_reuseport
Date:   Thu, 28 May 2020 07:12:17 +0200
Message-Id: <20200528051236.620353-10-hch@lst.de>
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

Add a helper to directly set the SO_REUSEPORT sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sock.h    |  1 +
 net/core/sock.c       |  8 ++++++++
 net/sunrpc/xprtsock.c | 17 +----------------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c997289aabbf9..d994daa418ec2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2695,6 +2695,7 @@ void sock_set_keepalive(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_rcvbuf(struct sock *sk, int val);
 void sock_set_reuseaddr(struct sock *sk);
+void sock_set_reuseport(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 3c6ebf952e9ad..2ca3425b519c0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -729,6 +729,14 @@ void sock_set_reuseaddr(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_set_reuseaddr);
 
+void sock_set_reuseport(struct sock *sk)
+{
+	lock_sock(sk);
+	sk->sk_reuseport = true;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_reuseport);
+
 void sock_no_linger(struct sock *sk)
 {
 	lock_sock(sk);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 30082cd039960..399848c2bcb29 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1594,21 +1594,6 @@ static int xs_get_random_port(void)
 	return rand + min;
 }
 
-/**
- * xs_set_reuseaddr_port - set the socket's port and address reuse options
- * @sock: socket
- *
- * Note that this function has to be called on all sockets that share the
- * same port, and it must be called before binding.
- */
-static void xs_sock_set_reuseport(struct socket *sock)
-{
-	int opt = 1;
-
-	kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEPORT,
-			(char *)&opt, sizeof(opt));
-}
-
 static unsigned short xs_sock_getport(struct socket *sock)
 {
 	struct sockaddr_storage buf;
@@ -1801,7 +1786,7 @@ static struct socket *xs_create_sock(struct rpc_xprt *xprt,
 	xs_reclassify_socket(family, sock);
 
 	if (reuseport)
-		xs_sock_set_reuseport(sock);
+		sock_set_reuseport(sock->sk);
 
 	err = xs_bind(transport, sock);
 	if (err) {
-- 
2.26.2

