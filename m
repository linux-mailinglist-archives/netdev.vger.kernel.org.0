Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7CE459421
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbhKVRqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:46:25 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:28072 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240155AbhKVRqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637602997; x=1669138997;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vgHpn1WwLPKBnYv/MkgHq1HZktSCjpukwvZ2uKGPZrQ=;
  b=K40URS1Vq2q5Wj8P/pficVwkb7V4EESSm2Vz/qR1kkFcBcKxsa2xSUgv
   EW9iD/KWuJgxRYF8ndtj11ujapSEldN90s18/1j7L0J9qsV8CjOJAVvUb
   MVZ/Dzd4IfNwoCcua0SLFMBNnKf43eE6WXCjKC0pFJBUPVbQIpj9P3d4V
   o=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="153893954"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 22 Nov 2021 17:43:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id DC771813DE;
        Mon, 22 Nov 2021 17:43:16 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:43:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:43:12 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 07/13] af_unix: Remove unix_mkname().
Date:   Tue, 23 Nov 2021 02:41:08 +0900
Message-ID: <20211122174114.84594-8-kuniyu@amazon.co.jp>
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

This patch removes unix_mkname() and postpones calculating a hash to
unix_bind_abstract().  Some BSD stuffs still remain in unix_bind()
though, the next patch packs them into unix_bind_bsd().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c39bcb41f490..4b56979870dd 100644
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
@@ -1163,6 +1149,9 @@ static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 		return -EINVAL;
 	}
 
+	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
+	addr->hash ^= sk->sk_type;
+
 	spin_lock(&unix_table_lock);
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
 				      addr->hash)) {
@@ -1178,12 +1167,11 @@ static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 
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
@@ -1193,17 +1181,17 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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

