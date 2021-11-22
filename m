Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB2A459420
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhKVRqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:46:12 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:30132 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbhKVRqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:46:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637602984; x=1669138984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aiiizi6e9Dqc3woMibXJ+HHg7RmB4YdZ+9eK9AgrVYE=;
  b=axAJoS0Na6rdYie4hC5geViJ1FaB+Ego5c+x2dIp15u9SNXbBtRe7+zB
   r8C+73WMtPhslEPI4FmOrEzyLmjsIpmjFzvqePBIgTHG1sLNJeLkxBq4N
   RpASk67OwLmYYg+Q1+9gvI3cedvMvhKHhnU39OWopT8xcMAUk9HVxtZ56
   g=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="43405099"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 22 Nov 2021 17:43:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com (Postfix) with ESMTPS id 37CD780A8A;
        Mon, 22 Nov 2021 17:43:01 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:43:01 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 06/13] af_unix: Copy unix_mkname() into unix_find_(bsd|abstract)().
Date:   Tue, 23 Nov 2021 02:41:07 +0900
Message-ID: <20211122174114.84594-7-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122174114.84594-1-kuniyu@amazon.co.jp>
References: <20211122174114.84594-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.57]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
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
 net/unix/af_unix.c | 59 +++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 103f126df90d..c39bcb41f490 100644
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
 		len = strlen(sunaddr->sun_path) + offsetof(struct sockaddr_un, sun_path) + 1;
 		return len;
 	}
@@ -957,13 +963,14 @@ static int unix_release(struct socket *sock)
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
@@ -1000,8 +1007,9 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 }
 
 static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *sunaddr,
-				       int addr_len, int type, unsigned int hash)
+				       int addr_len, int type)
 {
+	unsigned int hash = unix_hash_fold(csum_partial(sunaddr, addr_len, 0));
 	struct dentry *dentry;
 	struct sock *sk;
 
@@ -1017,14 +1025,14 @@ static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *suna
 }
 
 static struct sock *unix_find_other(struct net *net, struct sockaddr_un *sunaddr,
-				    int addr_len, int type, unsigned int hash)
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
@@ -1239,7 +1247,6 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 	struct net *net = sock_net(sk);
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)addr;
 	struct sock *other;
-	unsigned int hash;
 	int err;
 
 	err = -EINVAL;
@@ -1251,11 +1258,6 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		if (err)
 			goto out;
 
-		err = unix_mkname(sunaddr, alen, &hash);
-		if (err < 0)
-			goto out;
-		alen = err;
-
 		if (test_bit(SOCK_PASSCRED, &sock->flags) && !unix_sk(sk)->addr) {
 			err = unix_autobind(sk);
 			if (err)
@@ -1263,7 +1265,7 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		}
 
 restart:
-		other = unix_find_other(net, sunaddr, alen, sock->type, hash);
+		other = unix_find_other(net, sunaddr, alen, sock->type);
 		if (IS_ERR(other)) {
 			err = PTR_ERR(other);
 			goto out;
@@ -1357,7 +1359,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct sock *newsk = NULL;
 	struct sock *other = NULL;
 	struct sk_buff *skb = NULL;
-	unsigned int hash;
 	int st;
 	int err;
 	long timeo;
@@ -1366,11 +1367,6 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
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
@@ -1401,7 +1397,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 restart:
 	/*  Find listening sock. */
-	other = unix_find_other(net, sunaddr, addr_len, sk->sk_type, hash);
+	other = unix_find_other(net, sunaddr, addr_len, sk->sk_type);
 	if (IS_ERR(other)) {
 		err = PTR_ERR(other);
 		other = NULL;
@@ -1799,9 +1795,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct unix_sock *u = unix_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_un *, sunaddr, msg->msg_name);
 	struct sock *other = NULL;
-	int namelen = 0; /* fake GCC */
 	int err;
-	unsigned int hash;
 	struct sk_buff *skb;
 	long timeo;
 	struct scm_cookie scm;
@@ -1821,11 +1815,6 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
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
@@ -1878,7 +1867,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (sunaddr == NULL)
 			goto out_free;
 
-		other = unix_find_other(net, sunaddr, namelen, sk->sk_type, hash);
+		other = unix_find_other(net, sunaddr, msg->msg_namelen, sk->sk_type);
 		if (IS_ERR(other)) {
 			err = PTR_ERR(other);
 			other = NULL;
-- 
2.30.2

