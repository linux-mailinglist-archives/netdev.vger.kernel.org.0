Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F22145941D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240124AbhKVRpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:45:41 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:54152 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbhKVRpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637602954; x=1669138954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IsQJLIlTnyPyfGco2cPa0jYCQkp6y0eHkDKMtTlY0uo=;
  b=Q0PeZXH5/HpCHaMoQ2RFFcRAELoucx1Jl6YZiHa3FgGbuI83jAmJw1E2
   8Hnvht+F0ZhXEck1XkRCQwaTCq9FbtFW++jKOu22e21IOaYAxom0zLREw
   9IqA+ef4p6ckgHNadf2EOtlCH55HBSiQ80UgJVho1rxLPyZ0DxNpSPNU6
   o=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="175883075"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 22 Nov 2021 17:42:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 0D15AC08EF;
        Mon, 22 Nov 2021 17:42:31 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:30 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 04/13] af_unix: Return an error as a pointer in unix_find_other().
Date:   Tue, 23 Nov 2021 02:41:05 +0900
Message-ID: <20211122174114.84594-5-kuniyu@amazon.co.jp>
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

We can return an error as a pointer and need not pass an additional
argument to unix_find_other().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 248bf85c1e56..98fb8074fe19 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -949,7 +949,7 @@ static int unix_release(struct socket *sock)
 }
 
 static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
-				  int type, int *error)
+				  int type)
 {
 	struct inode *inode;
 	struct path path;
@@ -988,22 +988,18 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 path_put:
 	path_put(&path);
 fail:
-	*error = err;
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *sunaddr,
-				       int addr_len, int type, unsigned int hash,
-				       int *error)
+				       int addr_len, int type, unsigned int hash)
 {
 	struct dentry *dentry;
 	struct sock *sk;
 
 	sk = unix_find_socket_byname(net, sunaddr, addr_len, type ^ hash);
-	if (!sk) {
-		*error = -ECONNREFUSED;
-		return NULL;
-	}
+	if (!sk)
+		return ERR_PTR(-ECONNREFUSED);
 
 	dentry = unix_sk(sk)->path.dentry;
 	if (dentry)
@@ -1013,15 +1009,14 @@ static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *suna
 }
 
 static struct sock *unix_find_other(struct net *net, struct sockaddr_un *sunaddr,
-				    int addr_len, int type, unsigned int hash,
-				    int *error)
+				    int addr_len, int type, unsigned int hash)
 {
 	struct sock *sk;
 
 	if (sunaddr->sun_path[0])
-		sk = unix_find_bsd(net, sunaddr, type, error);
+		sk = unix_find_bsd(net, sunaddr, type);
 	else
-		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash, error);
+		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash);
 
 	return sk;
 }
@@ -1255,9 +1250,11 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		}
 
 restart:
-		other = unix_find_other(net, sunaddr, alen, sock->type, hash, &err);
-		if (!other)
+		other = unix_find_other(net, sunaddr, alen, sock->type, hash);
+		if (IS_ERR(other)) {
+			err = PTR_ERR(other);
 			goto out;
+		}
 
 		unix_state_double_lock(sk, other);
 
@@ -1387,9 +1384,12 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 restart:
 	/*  Find listening sock. */
-	other = unix_find_other(net, sunaddr, addr_len, sk->sk_type, hash, &err);
-	if (!other)
+	other = unix_find_other(net, sunaddr, addr_len, sk->sk_type, hash);
+	if (IS_ERR(other)) {
+		err = PTR_ERR(other);
+		other = NULL;
 		goto out;
+	}
 
 	/* Latch state of peer */
 	unix_state_lock(other);
@@ -1857,10 +1857,12 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		if (sunaddr == NULL)
 			goto out_free;
 
-		other = unix_find_other(net, sunaddr, namelen, sk->sk_type,
-					hash, &err);
-		if (other == NULL)
+		other = unix_find_other(net, sunaddr, namelen, sk->sk_type, hash);
+		if (IS_ERR(other)) {
+			err = PTR_ERR(other);
+			other = NULL;
 			goto out_free;
+		}
 	}
 
 	if (sk_filter(other, skb) < 0) {
-- 
2.30.2

