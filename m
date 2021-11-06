Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F41446D29
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhKFJVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:21:16 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:14643 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbhKFJVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190314; x=1667726314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FkThqrnN8EgRRp8rAQKD9dm8yZeZICxiThJ4pC+BpzE=;
  b=sqtLNcCSvQlmkpbbHyYhQYNCa8KsEDzVwdLSPyyeb7y1sEGQLPLw68pK
   b1oo1GpsDtfl6wM7Fge+OEkk0W5OiLK1zEURE66WDHw0EnqxMEcGVj3mD
   im6BImfYhjFjahHO3ACJhSTh8E5LVWIQSGLAicNPP5q5Ni5RzVN+dnZyj
   U=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="969837695"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-d3b4d400.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 06 Nov 2021 09:18:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-d3b4d400.us-east-1.amazon.com (Postfix) with ESMTPS id 12197C032D;
        Sat,  6 Nov 2021 09:18:32 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:18:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:18:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 04/13] af_unix: Return an error as a pointer in unix_find_other().
Date:   Sat, 6 Nov 2021 18:17:03 +0900
Message-ID: <20211106091712.15206-5-kuniyu@amazon.co.jp>
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

