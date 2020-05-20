Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638221DBED1
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgETT5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgETT5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:57:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CDEC061A0F;
        Wed, 20 May 2020 12:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SoJc1/taCxcgg46E3sLXJ5D5ViTmiGYbfa508lCrHhc=; b=AlaMSmKNBl9B3h77xS5EiL/hIh
        qmaKy56Aklm4VLghXIci6rqsKi6hMSwFjBNIhmFkfG0CbJps0saMeOApZ+prdcU/RP6Vcq46ZUlrS
        wzEVnCkfyrCiJXfuSfjrkBuJRj6ejyssc0/H+Tol3dR6M+UozFLSBMO7ODlD4hgnx/pBBLyAv8xqF
        g7lcRGV8yI6Fj5l1EHKKXlohTDDByTr7JXbKVEIDNnjcPFqlG8m/ubYaD2yuoE3A8WhjwDk+VhUc6
        3iBW0NQUaiHXon+6MPNYbbyPUVe5ISzsY3UpHxhhIYPl16gM1zglD82vs5+OKCN5cfqWq2MmXnh97
        LtxjadaA==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbUpN-0003Qz-8p; Wed, 20 May 2020 19:56:33 +0000
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
Subject: [PATCH 29/33] rxrpc: add rxrpc_sock_set_min_security_level
Date:   Wed, 20 May 2020 21:55:05 +0200
Message-Id: <20200520195509.2215098-30-hch@lst.de>
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

Add a helper to directly set the RXRPC_MIN_SECURITY_LEVEL sockopt from
kernel space without going through a fake uaccess.

Thanks to David Howells for the documentation updates.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/networking/rxrpc.rst | 13 +++++++++++--
 fs/afs/rxrpc.c                     |  6 ++----
 include/net/af_rxrpc.h             |  2 ++
 net/rxrpc/af_rxrpc.c               | 13 +++++++++++++
 4 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/rxrpc.rst b/Documentation/networking/rxrpc.rst
index 5ad35113d0f46..68552b92dc442 100644
--- a/Documentation/networking/rxrpc.rst
+++ b/Documentation/networking/rxrpc.rst
@@ -477,7 +477,7 @@ AF_RXRPC sockets support a few socket options at the SOL_RXRPC level:
 	 Encrypted checksum plus packet padded and first eight bytes of packet
 	 encrypted - which includes the actual packet length.
 
-     (c) RXRPC_SECURITY_ENCRYPTED
+     (c) RXRPC_SECURITY_ENCRYPT
 
 	 Encrypted checksum plus entire packet padded and encrypted, including
 	 actual packet length.
@@ -578,7 +578,7 @@ A client would issue an operation by:
      This issues a request_key() to get the key representing the security
      context.  The minimum security level can be set::
 
-	unsigned int sec = RXRPC_SECURITY_ENCRYPTED;
+	unsigned int sec = RXRPC_SECURITY_ENCRYPT;
 	setsockopt(client, SOL_RXRPC, RXRPC_MIN_SECURITY_LEVEL,
 		   &sec, sizeof(sec));
 
@@ -1090,6 +1090,15 @@ The kernel interface functions are as follows:
      jiffies).  In the event of the timeout occurring, the call will be
      aborted and -ETIME or -ETIMEDOUT will be returned.
 
+ (#) Apply the RXRPC_MIN_SECURITY_LEVEL sockopt to a socket from within in the
+     kernel::
+
+       int rxrpc_sock_set_min_security_level(struct sock *sk,
+					     unsigned int val);
+
+     This specifies the minimum security level required for calls on this
+     socket.
+
 
 Configurable Parameters
 =======================
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 1ecc67da6c1a4..e313dae01674f 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -37,7 +37,6 @@ int afs_open_socket(struct afs_net *net)
 {
 	struct sockaddr_rxrpc srx;
 	struct socket *socket;
-	unsigned int min_level;
 	int ret;
 
 	_enter("");
@@ -57,9 +56,8 @@ int afs_open_socket(struct afs_net *net)
 	srx.transport.sin6.sin6_family	= AF_INET6;
 	srx.transport.sin6.sin6_port	= htons(AFS_CM_PORT);
 
-	min_level = RXRPC_SECURITY_ENCRYPT;
-	ret = kernel_setsockopt(socket, SOL_RXRPC, RXRPC_MIN_SECURITY_LEVEL,
-				(void *)&min_level, sizeof(min_level));
+	ret = rxrpc_sock_set_min_security_level(socket->sk,
+						RXRPC_SECURITY_ENCRYPT);
 	if (ret < 0)
 		goto error_2;
 
diff --git a/include/net/af_rxrpc.h b/include/net/af_rxrpc.h
index 04e97bab6f28b..8d7b469453bda 100644
--- a/include/net/af_rxrpc.h
+++ b/include/net/af_rxrpc.h
@@ -72,4 +72,6 @@ bool rxrpc_kernel_call_is_complete(struct rxrpc_call *);
 void rxrpc_kernel_set_max_life(struct socket *, struct rxrpc_call *,
 			       unsigned long);
 
+int rxrpc_sock_set_min_security_level(struct sock *sk, unsigned int val);
+
 #endif /* _NET_RXRPC_H */
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 15ee92d795815..394189b81849f 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -571,6 +571,19 @@ static int rxrpc_sendmsg(struct socket *sock, struct msghdr *m, size_t len)
 	return ret;
 }
 
+int rxrpc_sock_set_min_security_level(struct sock *sk, unsigned int val)
+{
+	if (sk->sk_state != RXRPC_UNBOUND)
+		return -EISCONN;
+	if (val > RXRPC_SECURITY_MAX)
+		return -EINVAL;
+	lock_sock(sk);
+	rxrpc_sk(sk)->min_sec_level = val;
+	release_sock(sk);
+	return 0;
+}
+EXPORT_SYMBOL(rxrpc_sock_set_min_security_level);
+
 /*
  * set RxRPC socket options
  */
-- 
2.26.2

