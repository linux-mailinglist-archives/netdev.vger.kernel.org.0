Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7F345B1F2
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240688AbhKXCTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:19:34 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:47558 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhKXCTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:19:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720185; x=1669256185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pIGafz79/rBxBJGTMYyjfHrsQyvIvJPiJW7CDIm6lNk=;
  b=WAQPOuoZU3esCeM4DbgxisOu4hkIUUcDPzlcz/jQ1CWm0HX9DBoBBjpd
   g7keGQavgGXVrloyuN2uUJrEftbKIH7Jl+Fs+6pEPK4WufJq/5kNBrpaO
   calO+RunazoMzz+26ngOGCDOMti826D17XHcLHFHjfbTJC7xWNRTuDMwR
   c=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="158852346"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 24 Nov 2021 02:16:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id 3F07E41DB1;
        Wed, 24 Nov 2021 02:16:22 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:16:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:16:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 06/13] af_unix: Copy unix_mkname() into unix_find_(bsd|abstract)().
Date:   Wed, 24 Nov 2021 11:14:24 +0900
Message-ID: <20211124021431.48956-7-kuniyu@amazon.co.jp>
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

We should not call unix_mkname() before unix_find_other() and instead do
the same thing where necessary based on the address type:

  - terminating the address with '\0' in unix_find_bsd()
  - calculating the hash in unix_find_abstract().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 63 ++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 172be2c88345..46dfc8eb9c33 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -239,19 +239,25 @@ static int unix_validate_addr(struct sockaddr_un *sunaddr, int addr_len)
 	return 0;
 }
 
+static void unix_mkname_bsd(struct sockaddr_un *sunaddr, int addr_len)
+{
+	/* This may look like an off by one error but it is a bit more
+	 * subtle.  108 is the longest valid AF_UNIX path for a binding.
+	 * sun_path[108] doesn't as such exist.  However in kernel space
+	 * we are guaranteed that it is a valid memory location in our
+	 * kernel address buffer because syscall functions always pass
+	 * a pointer of struct sockaddr_storage which has a bigger buffer
+	 * than 108.
+	 */
+	((char *)sunaddr)[addr_len] = 0;
+}
+
 static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
 {
 	*hashp = 0;
 
 	if (sunaddr->sun_path[0]) {
-		/*
-		 * This may look like an off by one error but it is a bit more
-		 * subtle. 108 is the longest valid AF_UNIX path for a binding.
-		 * sun_path[108] doesn't as such exist.  However in kernel space
-		 * we are guaranteed that it is a valid memory location in our
-		 * kernel address buffer.
-		 */
-		((char *)sunaddr)[len] = 0;
+		unix_mkname_bsd(sunaddr, len);
 		len = strlen(sunaddr->sun_path) +
 			offsetof(struct sockaddr_un, sun_path) + 1;
 		return len;
@@ -958,13 +964,14 @@ static int unix_release(struct socket *sock)
 }
 
 static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
-				  int type)
+				  int addr_len, int type)
 {
 	struct inode *inode;
 	struct path path;
 	struct sock *sk;
 	int err;
 
+	unix_mkname_bsd(sunaddr, addr_len);
 	err = kern_path(sunaddr->sun_path, LOOKUP_FOLLOW, &path);
 	if (err)
 		goto fail;
@@ -1002,9 +1009,9 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 
 static struct sock *unix_find_abstract(struct net *net,
 				       struct sockaddr_un *sunaddr,
-				       int addr_len, int type,
-				       unsigned int hash)
+				       int addr_len, int type)
 {
+	unsigned int hash = unix_hash_fold(csum_partial(sunaddr, addr_len, 0));
 	struct dentry *dentry;
 	struct sock *sk;
 
@@ -1021,15 +1028,14 @@ static struct sock *unix_find_abstract(struct net *net,
 
 static struct sock *unix_find_other(struct net *net,
 				    struct sockaddr_un *sunaddr,
-				    int addr_len, int type,
-				    unsigned int hash)
+				    int addr_len, int type)
 {
 	struct sock *sk;
 
 	if (sunaddr->sun_path[0])
-		sk = unix_find_bsd(net, sunaddr, type);
+		sk = unix_find_bsd(net, sunaddr, addr_len, type);
 	else
-		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash);
+		sk = unix_find_abstract(net, sunaddr, addr_len, type);
 
 	return sk;
 }
@@ -1246,7 +1252,6 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 	struct net *net = sock_net(sk);
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)addr;
 	struct sock *other;
-	unsigned int hash;
 	int err;
 
 	err = -EINVAL;
@@ -1258,11 +1263,6 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		if (err)
 			goto out;
 
-		err = unix_mkname(sunaddr, alen, &hash);
-		if (err < 0)
-			goto out;
-		alen = err;
-
 		if (test_bit(SOCK_PASSCRED, &sock->flags) &&
 		    !unix_sk(sk)->addr) {
 			err = unix_autobind(sk);
@@ -1271,7 +1271,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		}
 
 restart:
-		other = unix_find_other(net, sunaddr, alen, sock->type, hash);
+		other = unix_find_other(net, sunaddr, alen, sock->type);
 		if (IS_ERR(other)) {
 			err = PTR_ERR(other);
 			goto out;
@@ -1365,7 +1365,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct sock *newsk = NULL;
 	struct sock *other = NULL;
 	struct sk_buff *skb = NULL;
-	unsigned int hash;
 	int st;
 	int err;
 	long timeo;
@@ -1374,11 +1373,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	if (err)
 		goto out;
 
-	err = unix_mkname(sunaddr, addr_len, &hash);
-	if (err < 0)
-		goto out;
-	addr_len = err;
-
 	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
 		err = unix_autobind(sk);
 		if (err)
@@ -1409,7 +1403,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 restart:
 	/*  Find listening sock. */
-	other = unix_find_other(net, sunaddr, addr_len, sk->sk_type, hash);
+	other = unix_find_other(net, sunaddr, addr_len, sk->sk_type);
 	if (IS_ERR(other)) {
 		err = PTR_ERR(other);
 		other = NULL;
@@ -1807,9 +1801,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct unix_sock *u = unix_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr, msg->msg_name);
 	struct sock *other = NULL;
-	int namelen = 0; /* fake GCC */
 	int err;
-	unsigned int hash;
 	struct sk_buff *skb;
 	long timeo;
 	struct scm_cookie scm;
@@ -1829,11 +1821,6 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		err = unix_validate_addr(sunaddr, msg->msg_namelen);
 		if (err)
 			goto out;
-
-		err = unix_mkname(sunaddr, msg->msg_namelen, &hash);
-		if (err < 0)
-			goto out;
-		namelen = err;
 	} else {
 		sunaddr = NULL;
 		err = -ENOTCONN;
@@ -1886,8 +1873,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (sunaddr == NULL)
 			goto out_free;
 
-		other = unix_find_other(net, sunaddr, namelen, sk->sk_type,
-					hash);
+		other = unix_find_other(net, sunaddr, msg->msg_namelen,
+					sk->sk_type);
 		if (IS_ERR(other)) {
 			err = PTR_ERR(other);
 			other = NULL;
-- 
2.30.2

