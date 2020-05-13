Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82B51D086A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732347AbgEMGa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731775AbgEMG2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269F1C061A0E;
        Tue, 12 May 2020 23:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=cW3MEV/WwtWzunuIIhkoKW20oXwwRZpBvDGURWiq844=; b=gziW83p6duUvL0soJDNgiPSF/p
        sH/59QqWomThwnJAnXN25bczjjRb1S4Mk8DmzM7AdlM7kTbRuzqQ0/kIJZ+1eL9I2z/ttXwWA9hyR
        9il5dbOUfnGubcd0AQQHxZw8R3SAtRdl+e8mVPejSieXkS7Rn5wwdgrVi1FX0qNLDfO5tV2OeCLwC
        FwuIpblQiZp8mAcpvKaFH2pXasHe4j/G6RO8yajiFwk1QC6p6kRaSePezb8JUyQjR3PIqwYiMAjzD
        8p8RzWV3T5Z3UM7wVy4UHteCYYZdCa+SZeqLHnDobknz5kN4/0UYaOMIqfrxc+a1lnMM7Yy2JQaYs
        KeJOr5Ww==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYksO-00057L-NZ; Wed, 13 May 2020 06:28:21 +0000
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
Subject: [PATCH 29/33] rxrpc_sock_set_min_security_level
Date:   Wed, 13 May 2020 08:26:44 +0200
Message-Id: <20200513062649.2100053-30-hch@lst.de>
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

Add a helper to directly set the RXRPC_MIN_SECURITY_LEVEL sockopt from
kernel space without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/afs/rxrpc.c         |  6 ++----
 include/net/af_rxrpc.h |  2 ++
 net/rxrpc/af_rxrpc.c   | 13 +++++++++++++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 1ecc67da6c1a4..7dfcbd58da85c 100644
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
+			RXRPC_SECURITY_ENCRYPT);
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

