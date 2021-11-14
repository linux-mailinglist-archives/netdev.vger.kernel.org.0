Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFD44F5E4
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhKNB2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:28:07 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:26084 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKNB2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853113; x=1668389113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8pgTkI/dcpfRL3ICipt+9mUS2f8qrVgObFiPJ4phffk=;
  b=k7CtoI1qNWqMOonUDyb4dYccEbMz9F7go4XBK+kk2PQSjXW8NszxMuPD
   /iqCLqMuom2CKqBsW/zcdMJO1Tgdsk/3E3tKQG3LSPlC1OWRzKR18ePqO
   H+T+gbOUJk3N6VtJFCJbDcl4CjF7KWIv46DbfnYDnojKyo54pXa9Mdhkc
   c=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="41264180"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-39fdda15.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 14 Nov 2021 01:25:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-39fdda15.us-west-2.amazon.com (Postfix) with ESMTPS id 23ADF41B08;
        Sun, 14 Nov 2021 01:25:14 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:25:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:25:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 02/13] af_unix: Pass struct sock to unix_autobind().
Date:   Sun, 14 Nov 2021 10:24:17 +0900
Message-ID: <20211114012428.81743-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211114012428.81743-1-kuniyu@amazon.co.jp>
References: <20211114012428.81743-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.241]
X-ClientProxiedBy: EX13D40UWC003.ant.amazon.com (10.43.162.246) To
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

