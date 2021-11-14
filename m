Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575AA44F5E6
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhKNB2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:28:38 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:59774 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbhKNB2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:28:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853144; x=1668389144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FkThqrnN8EgRRp8rAQKD9dm8yZeZICxiThJ4pC+BpzE=;
  b=swKdNMUH7hB53ouB4agq9O6D724R3qLiaU8E/66xjV4E1VVa7ZjM1qLs
   EMxKIerM17uNRf/4KhpT5xKxX+Xf73ArF33NZ5wcowhjUSrdAUe2ffRnW
   UR8h9pRpXjO6j1TZtsyCG8O/t7vM1IBiznUps29HPe1zBxywV8MUnffGe
   w=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="971465831"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 14 Nov 2021 01:25:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id 8EB9F418F8;
        Sun, 14 Nov 2021 01:25:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:25:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:25:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 04/13] af_unix: Return an error as a pointer in unix_find_other().
Date:   Sun, 14 Nov 2021 10:24:19 +0900
Message-ID: <20211114012428.81743-5-kuniyu@amazon.co.jp>
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

We can return an error as a pointer and need not pass an additional
argument to unix_find_other().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 076d6a2db965..cb4e8cfa3958 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -953,7 +953,7 @@ static int unix_release(struct socket *sock)
 }
 
 static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
-				  int type, int *error)
+				  int type)
 {
 	struct inode *inode;
 	struct path path;
@@ -992,22 +992,18 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
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
@@ -1017,15 +1013,14 @@ static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *suna
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
@@ -1259,9 +1254,11 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
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
 
@@ -1391,9 +1388,12 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
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
@@ -1861,10 +1861,12 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
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

