Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76A3446D2C
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhKFJWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:22:00 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19851 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhKFJWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190360; x=1667726360;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vD6xtrmUq8lQfQrQgGSokdyQzLQ1hPMD1Wb7Ebs20hA=;
  b=BjSLznnGpEGobBw5BVOvb8vJAgQuEOpC7P0Uu0DYZ7DjbZWy+a1FtFgB
   NgRYNfjFZAhv07+p1TDb+zSTynqBzSuHg6K96co5jg+1c6KfLv/oowvbI
   sxU58tQObG8j+H59RwSleE5hJtT2sxfzsKJdHh9k/SM8S3ioUT4BQRS7D
   M=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="172183347"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 06 Nov 2021 09:19:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id 85EC8E0204;
        Sat,  6 Nov 2021 09:19:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:19:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:19:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 07/13] af_unix: Remove unix_mkname().
Date:   Sat, 6 Nov 2021 18:17:06 +0900
Message-ID: <20211106091712.15206-8-kuniyu@amazon.co.jp>
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

This patch removes unix_mkname() and postpones calculating a hash to
unix_bind_abstract().  Some BSD stuffs still remain in unix_bind()
though, the next patch packs them into unix_bind_bsd().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d0172d5d208f..00f9b83e8966 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -252,20 +252,6 @@ static void unix_mkname_bsd(struct sockaddr_un *sunaddr, int addr_len)
 	((char *)sunaddr)[addr_len] = 0;
 }
 
-static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
-{
-	*hashp = 0;
-
-	if (sunaddr->sun_path[0]) {
-		unix_mkname_bsd(sunaddr, len);
-		len = strlen(sunaddr->sun_path) + offsetof(struct sockaddr_un, sun_path) + 1;
-		return len;
-	}
-
-	*hashp = unix_hash_fold(csum_partial(sunaddr, len, 0));
-	return len;
-}
-
 static void __unix_remove_socket(struct sock *sk)
 {
 	sk_del_node_init(sk);
@@ -1167,6 +1153,9 @@ static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 		return -EINVAL;
 	}
 
+	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
+	addr->hash ^= sk->sk_type;
+
 	spin_lock(&unix_table_lock);
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
 				      addr->hash)) {
@@ -1182,12 +1171,11 @@ static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 
 static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
-	struct sock *sk = sock->sk;
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)uaddr;
 	char *sun_path = sunaddr->sun_path;
-	int err;
-	unsigned int hash;
+	struct sock *sk = sock->sk;
 	struct unix_address *addr;
+	int err;
 
 	if (addr_len == offsetof(struct sockaddr_un, sun_path) &&
 	    sunaddr->sun_family == AF_UNIX)
@@ -1197,17 +1185,17 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err)
 		return err;
 
-	err = unix_mkname(sunaddr, addr_len, &hash);
-	if (err < 0)
-		return err;
-	addr_len = err;
+	if (sun_path[0]) {
+		unix_mkname_bsd(sunaddr, addr_len);
+		addr_len = strlen(sunaddr->sun_path) + offsetof(struct sockaddr_un, sun_path) + 1;
+	}
+
 	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
 	if (!addr)
 		return -ENOMEM;
 
 	memcpy(addr->name, sunaddr, addr_len);
 	addr->len = addr_len;
-	addr->hash = hash ^ sk->sk_type;
 	refcount_set(&addr->refcnt, 1);
 
 	if (sun_path[0])
-- 
2.30.2

