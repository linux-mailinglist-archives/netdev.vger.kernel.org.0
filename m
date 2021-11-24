Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA445B1F0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhKXCTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:19:04 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:53381 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhKXCTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:19:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720156; x=1669256156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zip+dFbnoohrrNr76v1AmVt9OBFymPDhIqs5FVBStXM=;
  b=HR2HMYy8vW4hm/ZWRsNhAgKegDqEIf9kOoSN0skqkSzk88ak5sj8mk69
   WudMJgFalPldLBS1oGKHzFNXXxZlM3QVKsB8BiEcqbi18wNnRepeJMkP0
   Uh+vTERRBZPXo8/lhUZEtyQ9N+ZQL/hrd96kgrbSKiMHSL6zqicJWZ/m2
   U=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="176271917"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 24 Nov 2021 02:15:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com (Postfix) with ESMTPS id C488341DA0;
        Wed, 24 Nov 2021 02:15:54 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:51 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 04/13] af_unix: Return an error as a pointer in unix_find_other().
Date:   Wed, 24 Nov 2021 11:14:22 +0900
Message-ID: <20211124021431.48956-5-kuniyu@amazon.co.jp>
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

We can return an error as a pointer and need not pass an additional
argument to unix_find_other().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fe45df5e44d9..653d211420f1 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -951,7 +951,7 @@ static int unix_release(struct socket *sock)
 }
 
 static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
-				  int type, int *error)
+				  int type)
 {
 	struct inode *inode;
 	struct path path;
@@ -990,23 +990,20 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 path_put:
 	path_put(&path);
 fail:
-	*error = err;
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static struct sock *unix_find_abstract(struct net *net,
 				       struct sockaddr_un *sunaddr,
 				       int addr_len, int type,
-				       unsigned int hash, int *error)
+				       unsigned int hash)
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
@@ -1018,15 +1015,14 @@ static struct sock *unix_find_abstract(struct net *net,
 static struct sock *unix_find_other(struct net *net,
 				    struct sockaddr_un *sunaddr,
 				    int addr_len, int type,
-				    unsigned int hash, int *error)
+				    unsigned int hash)
 {
 	struct sock *sk;
 
 	if (sunaddr->sun_path[0])
-		sk = unix_find_bsd(net, sunaddr, type, error);
+		sk = unix_find_bsd(net, sunaddr, type);
 	else
-		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash,
-					error);
+		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash);
 
 	return sk;
 }
@@ -1263,9 +1259,11 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
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
 
@@ -1395,9 +1393,12 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
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
@@ -1866,9 +1867,12 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 			goto out_free;
 
 		other = unix_find_other(net, sunaddr, namelen, sk->sk_type,
-					hash, &err);
-		if (other == NULL)
+					hash);
+		if (IS_ERR(other)) {
+			err = PTR_ERR(other);
+			other = NULL;
 			goto out_free;
+		}
 	}
 
 	if (sk_filter(other, skb) < 0) {
-- 
2.30.2

