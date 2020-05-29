Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1165D1E7CC5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgE2MKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE2MKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 08:10:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3E9C03E969;
        Fri, 29 May 2020 05:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=5bplfpDkTDB05QrNb8zjQf4sfek7e4dOxEN5aP08Md4=; b=oJP96s+3hGZ4jk/lzpGdjblPlS
        GL150XK/3siFFKL2/8P9THQCH1lm5z2W7kH6OG36aAGIBOUw4GvbmTY+BiWsRWRKvZ5l8A0sQ04MN
        cr9k9YHffVg+fjFJ6517L3OTCJY/jpqZirlw74b3VG90L4OEyvby4HkCV4DgRIZQ/9eOLHidTmdAU
        nxgOqd5UgNb5HZX2YuVbn+6172USAtfICDJMO+8Nool/pDETcHoDEBbhfGgS0WAEZJShbbH97XxTi
        etCInrc8VNdhVcp8mGrl7sM9YSaYsllJsiU/s385Zs9lopo/UqfKHB8Bv7FJg9TbgZhcrwxomPjlW
        WDOoS8VA==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jedpn-0006LE-5m; Fri, 29 May 2020 12:09:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     David Laight <David.Laight@ACULAB.COM>, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH 3/4] net: add a new bind_add method
Date:   Fri, 29 May 2020 14:09:42 +0200
Message-Id: <20200529120943.101454-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529120943.101454-1-hch@lst.de>
References: <20200529120943.101454-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SCTP protocol allows to bind multiple address to a socket.  That
feature is currently only exposed as a socket option.  Add a bind_add
method struct proto that allows to bind additional addresses, and
switch the dlm code to use the method instead of going through the
socket option from kernel space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dlm/lowcomms.c  |  9 +++------
 include/net/sock.h |  6 +++++-
 net/core/sock.c    |  8 ++++++++
 net/sctp/socket.c  | 14 ++++++++++++++
 4 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 9f1c3cdc9d653..3543a8fec9075 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -882,6 +882,7 @@ static void writequeue_entry_complete(struct writequeue_entry *e, int completed)
 static int sctp_bind_addrs(struct connection *con, uint16_t port)
 {
 	struct sockaddr_storage localaddr;
+	struct sockaddr *addr = (struct sockaddr *)&localaddr;
 	int i, addr_len, result = 0;
 
 	for (i = 0; i < dlm_local_count; i++) {
@@ -889,13 +890,9 @@ static int sctp_bind_addrs(struct connection *con, uint16_t port)
 		make_sockaddr(&localaddr, port, &addr_len);
 
 		if (!i)
-			result = kernel_bind(con->sock,
-					     (struct sockaddr *)&localaddr,
-					     addr_len);
+			result = kernel_bind(con->sock, addr, addr_len);
 		else
-			result = kernel_setsockopt(con->sock, SOL_SCTP,
-						   SCTP_SOCKOPT_BINDX_ADD,
-						   (char *)&localaddr, addr_len);
+			result = sock_bind_add(con->sock->sk, addr, addr_len);
 
 		if (result < 0) {
 			log_print("Can't bind to %d addr number %d, %d.\n",
diff --git a/include/net/sock.h b/include/net/sock.h
index d994daa418ec2..6e9f713a78607 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1156,7 +1156,9 @@ struct proto {
 	int			(*sendpage)(struct sock *sk, struct page *page,
 					int offset, size_t size, int flags);
 	int			(*bind)(struct sock *sk,
-					struct sockaddr *uaddr, int addr_len);
+					struct sockaddr *addr, int addr_len);
+	int			(*bind_add)(struct sock *sk,
+					struct sockaddr *addr, int addr_len);
 
 	int			(*backlog_rcv) (struct sock *sk,
 						struct sk_buff *skb);
@@ -2698,4 +2700,6 @@ void sock_set_reuseaddr(struct sock *sk);
 void sock_set_reuseport(struct sock *sk);
 void sock_set_sndtimeo(struct sock *sk, s64 secs);
 
+int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
+
 #endif	/* _SOCK_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 2ca3425b519c0..61ec573221a60 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3712,3 +3712,11 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
 #endif /* CONFIG_NET_RX_BUSY_POLL */
+
+int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len)
+{
+	if (!sk->sk_prot->bind_add)
+		return -EOPNOTSUPP;
+	return sk->sk_prot->bind_add(sk, addr, addr_len);
+}
+EXPORT_SYMBOL(sock_bind_add);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6e745ac3c4a59..d57e1a002ffc8 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1052,6 +1052,18 @@ static int sctp_setsockopt_bindx(struct sock *sk,
 	return err;
 }
 
+static int sctp_bind_add(struct sock *sk, struct sockaddr *addrs,
+		int addrlen)
+{
+	int err;
+
+	lock_sock(sk);
+	err = sctp_setsockopt_bindx_kernel(sk, addrs, addrlen,
+					   SCTP_BINDX_ADD_ADDR);
+	release_sock(sk);
+	return err;
+}
+
 static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 				 const union sctp_addr *daddr,
 				 const struct sctp_initmsg *init,
@@ -9620,6 +9632,7 @@ struct proto sctp_prot = {
 	.sendmsg     =	sctp_sendmsg,
 	.recvmsg     =	sctp_recvmsg,
 	.bind        =	sctp_bind,
+	.bind_add    =  sctp_bind_add,
 	.backlog_rcv =	sctp_backlog_rcv,
 	.hash        =	sctp_hash,
 	.unhash      =	sctp_unhash,
@@ -9662,6 +9675,7 @@ struct proto sctpv6_prot = {
 	.sendmsg	= sctp_sendmsg,
 	.recvmsg	= sctp_recvmsg,
 	.bind		= sctp_bind,
+	.bind_add	= sctp_bind_add,
 	.backlog_rcv	= sctp_backlog_rcv,
 	.hash		= sctp_hash,
 	.unhash		= sctp_unhash,
-- 
2.26.2

