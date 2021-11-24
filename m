Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B7B45B1F3
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240697AbhKXCTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:19:49 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:20115 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhKXCTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:19:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720200; x=1669256200;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D4jBb+tpy6/xS/+kO3QxiIlSgpbrrINQbsdN+1RHb0A=;
  b=jYYF6rX5XlKILoWOlpqTnFKCMeAzS1e7VsICPyju2CrHRGB4GwpDeCGD
   l28A4sYlw3LwnqFAyAXJeltQypDtIC80Ym6xzd6Y+TnZxVaOrurLuAQ+Q
   OATmpVKM3m9BhzJxuB1+fRLTEIEQ+cI1lAekPArfL90REALrtnPSKJsy5
   k=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="157432857"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 24 Nov 2021 02:16:38 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 7237B41EF4;
        Wed, 24 Nov 2021 02:16:38 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:16:36 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:16:33 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 07/13] af_unix: Remove unix_mkname().
Date:   Wed, 24 Nov 2021 11:14:25 +0900
Message-ID: <20211124021431.48956-8-kuniyu@amazon.co.jp>
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

This patch removes unix_mkname() and postpones calculating a hash to
unix_bind_abstract().  Some BSD stuffs still remain in unix_bind()
though, the next patch packs them into unix_bind_bsd().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 46dfc8eb9c33..64dc698b6519 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -252,21 +252,6 @@ static void unix_mkname_bsd(struct sockaddr_un *sunaddr, int addr_len)
 	((char *)sunaddr)[addr_len] = 0;
 }
 
-static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
-{
-	*hashp = 0;
-
-	if (sunaddr->sun_path[0]) {
-		unix_mkname_bsd(sunaddr, len);
-		len = strlen(sunaddr->sun_path) +
-			offsetof(struct sockaddr_un, sun_path) + 1;
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
@@ -1168,6 +1153,9 @@ static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 		return -EINVAL;
 	}
 
+	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
+	addr->hash ^= sk->sk_type;
+
 	spin_lock(&unix_table_lock);
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
 				      addr->hash)) {
@@ -1183,12 +1171,11 @@ static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 
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
@@ -1198,17 +1185,18 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err)
 		return err;
 
-	err = unix_mkname(sunaddr, addr_len, &hash);
-	if (err < 0)
-		return err;
-	addr_len = err;
+	if (sun_path[0]) {
+		unix_mkname_bsd(sunaddr, addr_len);
+		addr_len = strlen(sunaddr->sun_path) +
+			offsetof(struct sockaddr_un, sun_path) + 1;
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

