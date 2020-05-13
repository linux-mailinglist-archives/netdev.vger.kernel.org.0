Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54A81D0879
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgEMGbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730396AbgEMG2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:28:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B6DC061A0C;
        Tue, 12 May 2020 23:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Q3f8maTF2WhcJdVNH6rzm87GRT50d4BxACqMxTxJ4BY=; b=cyzDx1uoh8IiQfgqAVcSotVmh6
        uYNpmIDX8eRx1zTp13fHCHimwYLgcArJiLCZgmhnVK9WDg8dXaW6SyzTThxwpKcA3K6fQDAdzMImx
        +3MykN3jaMNTPmD6tdS0//BJDxKVi8Hgtd0lXVPm5HMudbnLuBSnnLKeCf/gO9CHQiMif+stgJjDK
        p1HmNw+EHVn+8Enoh5JEafDugHKOb0+M4kJ/PfQMggv/wfXKkunOR7WL3g2z/Tfo8oIQ61TYVkjA5
        ouDak8sJvnYkyCZ8ATf7S7Dq7i/0BFEd0q/gcxvMbFNvKljzc+GOqukpMF9pp/HS5RB/fDtmU740T
        87t0LOEA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYkrO-0004A8-Gx; Wed, 13 May 2020 06:27:19 +0000
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
Subject: [PATCH 09/33] net: add sock_set_reuseport
Date:   Wed, 13 May 2020 08:26:24 +0200
Message-Id: <20200513062649.2100053-10-hch@lst.de>
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

Add a helper to directly set the SO_REUSEPORT sockopt from kernel space
without going through a fake uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sock.h    |  1 +
 net/core/sock.c       |  8 ++++++++
 net/sunrpc/xprtsock.c | 17 +----------------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index e1ed40ff01312..6b8e06947b243 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2688,6 +2688,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 
 void sock_def_readable(struct sock *sk);
 void sock_set_reuseaddr(struct sock *sk, unsigned char reuse);
+void sock_set_reuseport(struct sock *sk, bool reuseport);
 void sock_set_linger(struct sock *sk, bool onoff, unsigned int linger);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_sndtimeo(struct sock *sk, unsigned int secs);
diff --git a/net/core/sock.c b/net/core/sock.c
index 6af01b757cf24..7f0baf1ccde17 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -729,6 +729,14 @@ void sock_set_reuseaddr(struct sock *sk, unsigned char reuse)
 }
 EXPORT_SYMBOL(sock_set_reuseaddr);
 
+void sock_set_reuseport(struct sock *sk, bool reuseport)
+{
+	lock_sock(sk);
+	sk->sk_reuseport = reuseport;
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_set_reuseport);
+
 static void __sock_set_linger(struct sock *sk, bool onoff, unsigned int linger)
 {
 	if (!onoff) {
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index bb61d3758be2b..3dc2d52371a0e 100644
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
+		sock_set_reuseport(sock->sk, true);
 
 	err = xs_bind(transport, sock);
 	if (err) {
-- 
2.26.2

