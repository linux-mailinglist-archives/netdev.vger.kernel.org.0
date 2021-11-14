Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB6344F5E9
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235896AbhKNB3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:29:25 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:56204 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235893AbhKNB3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853192; x=1668389192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vD6xtrmUq8lQfQrQgGSokdyQzLQ1hPMD1Wb7Ebs20hA=;
  b=YqSKn+ILDT3hr3Gq3kjTd7afM71/Ag3A4OPTmlwC/+cLfMuDRRw/dB6L
   7HhrguJLG1iEXpdiGWjLP8J7QDIga2J8isH4QxR8gmAijwUTh42pgAieq
   TWQOaFCKaP2FVZoZSaJb7a/9KkksQB5z/E5zw/NbbRJxGn0K7YCWS/xm6
   M=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="154894548"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 14 Nov 2021 01:26:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com (Postfix) with ESMTPS id D490A41B73;
        Sun, 14 Nov 2021 01:26:29 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:26:28 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:26:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 07/13] af_unix: Remove unix_mkname().
Date:   Sun, 14 Nov 2021 10:24:22 +0900
Message-ID: <20211114012428.81743-8-kuniyu@amazon.co.jp>
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

