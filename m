Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B249445B1EE
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbhKXCSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:18:32 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:52751 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbhKXCSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720124; x=1669256124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iETNS8M6kWAWJEPeXq+k9Rx0Ryp/aIbKnHavlKZbz1o=;
  b=hK4fG7nCDZwFzgTxLj8NEki0QMnEBYbjdgdWayrC0Y/hPLJVoFbmFVpS
   I0ot/0oPgcPV/jWGeInSf4NQ2SDhwD7tJT4CfSSLTy60EM8/pujzN4EiI
   a9qWMxuYbP2kqa9qVP5O6g0v1jL3GgiOJSy+fba2KtKINwpJuTbacBmwk
   o=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="176271850"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 24 Nov 2021 02:15:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com (Postfix) with ESMTPS id 3F29A41E5F;
        Wed, 24 Nov 2021 02:15:22 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 02/13] af_unix: Pass struct sock to unix_autobind().
Date:   Wed, 24 Nov 2021 11:14:20 +0900
Message-ID: <20211124021431.48956-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211124021431.48956-1-kuniyu@amazon.co.jp>
References: <20211124021431.48956-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D03UWA004.ant.amazon.com (10.43.160.250) To
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
 net/unix/af_unix.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 19b3edac8712..f654fc5882bc 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -950,15 +950,13 @@ static int unix_release(struct socket *sock)
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
@@ -985,7 +983,8 @@ static int unix_autobind(struct socket *sock)
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
 
-	if (__unix_find_socket_byname(net, addr->name, addr->len, addr->hash)) {
+	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
+				      addr->hash)) {
 		spin_unlock(&unix_table_lock);
 		/*
 		 * __unix_find_socket_byname() may take long time if many names
@@ -1161,7 +1160,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		return -EINVAL;
 
 	if (addr_len == offsetof(struct sockaddr_un, sun_path))
-		return unix_autobind(sock);
+		return unix_autobind(sk);
 
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
@@ -1231,8 +1230,11 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		alen = err;
 
 		if (test_bit(SOCK_PASSCRED, &sock->flags) &&
-		    !unix_sk(sk)->addr && (err = unix_autobind(sock)) != 0)
-			goto out;
+		    !unix_sk(sk)->addr) {
+			err = unix_autobind(sk);
+			if (err)
+				goto out;
+		}
 
 restart:
 		other = unix_find_other(net, sunaddr, alen, sock->type, hash, &err);
@@ -1337,9 +1339,11 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
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
 
@@ -1791,9 +1795,11 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
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

