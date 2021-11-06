Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0903446D27
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhKFJUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:20:39 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:44022 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhKFJUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:20:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190279; x=1667726279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8pgTkI/dcpfRL3ICipt+9mUS2f8qrVgObFiPJ4phffk=;
  b=c/A6NClDEMrg7FYvsPsUszBCYkvOf1pc9Z8QLlsA0XIvF+ruKYVdFBZ7
   xagqjjCLoVKsh12V/jhJNJM1ZjV62IGGXcbLXHQhXTX8PIj9soYaGRBWe
   4mVTueEAOoEO5VwzJyiDdeoloP/kNubFqMrZr/mdZxbCebWA+xiKqpr2G
   Q=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="157685450"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-5a6d5c37.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Nov 2021 09:17:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-5a6d5c37.us-east-1.amazon.com (Postfix) with ESMTPS id CEC02C1D44;
        Sat,  6 Nov 2021 09:17:56 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:17:55 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:17:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 02/13] af_unix: Pass struct sock to unix_autobind().
Date:   Sat, 6 Nov 2021 18:17:01 +0900
Message-ID: <20211106091712.15206-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106091712.15206-1-kuniyu@amazon.co.jp>
References: <20211106091712.15206-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not use struct socket in unix_autobind() and pass struct sock to
unix_bind_bsd() and unix_bind_abstract().  Let's pass it to unix_autobind()
as well.

Also, this patch fixes these errors by checkpatch.pl.

  ERROR: do not use assignment in if condition
  #1795: FILE: net/unix/af_unix.c:1795:
  +	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr

  CHECK: Logical continuations should be on the previous line
  #1796: FILE: net/unix/af_unix.c:1796:
  +	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr
  +	    && (err = unix_autobind(sock)) != 0)

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index b0ef27062489..e6056275f488 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -952,15 +952,13 @@ static int unix_release(struct socket *sock)
 	return 0;
 }
 
-static int unix_autobind(struct socket *sock)
+static int unix_autobind(struct sock *sk)
 {
-	struct sock *sk = sock->sk;
-	struct net *net = sock_net(sk);
 	struct unix_sock *u = unix_sk(sk);
-	static u32 ordernum = 1;
 	struct unix_address *addr;
-	int err;
 	unsigned int retries = 0;
+	static u32 ordernum = 1;
+	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
 	if (err)
@@ -986,7 +984,7 @@ static int unix_autobind(struct socket *sock)
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
 
-	if (__unix_find_socket_byname(net, addr->name, addr->len, addr->hash)) {
+	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, addr->hash)) {
 		spin_unlock(&unix_table_lock);
 		/*
 		 * __unix_find_socket_byname() may take long time if many names
@@ -1162,7 +1160,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		return -EINVAL;
 
 	if (addr_len == offsetof(struct sockaddr_un, sun_path))
-		return unix_autobind(sock);
+		return unix_autobind(sk);
 
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
@@ -1231,9 +1229,11 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 			goto out;
 		alen = err;
 
-		if (test_bit(SOCK_PASSCRED, &sock->flags) &&
-		    !unix_sk(sk)->addr && (err = unix_autobind(sock)) != 0)
-			goto out;
+		if (test_bit(SOCK_PASSCRED, &sock->flags) && !unix_sk(sk)->addr) {
+			err = unix_autobind(sk);
+			if (err)
+				goto out;
+		}
 
 restart:
 		other = unix_find_other(net, sunaddr, alen, sock->type, hash, &err);
@@ -1338,9 +1338,11 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		goto out;
 	addr_len = err;
 
-	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr &&
-	    (err = unix_autobind(sock)) != 0)
-		goto out;
+	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
+		err = unix_autobind(sk);
+		if (err)
+			goto out;
+	}
 
 	timeo = sock_sndtimeo(sk, flags & O_NONBLOCK);
 
@@ -1792,9 +1794,11 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out;
 	}
 
-	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr
-	    && (err = unix_autobind(sock)) != 0)
-		goto out;
+	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
+		err = unix_autobind(sk);
+		if (err)
+			goto out;
+	}
 
 	err = -EMSGSIZE;
 	if (len > sk->sk_sndbuf - 32)
-- 
2.30.2

