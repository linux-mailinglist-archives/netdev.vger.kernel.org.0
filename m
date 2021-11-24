Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6845B1ED
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbhKXCSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:18:18 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:19620 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbhKXCSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720108; x=1669256108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EqucDFPyc9mIcEo9jR7KPPeyftAB90WDdEFlqpHePLc=;
  b=TkFY5yUYn2E3yh7gGFUPQ9MkVl728CTr63j9Bodgfs1Plpummn9m+ukq
   wPwDNgQrX9nwTsiL2+5FFuIGOK7fDGB28+a508q3Y5dQ/Hg3HDSwOmHRD
   6HBOusegdauIZXcS35Af9r1HqO+Nsd3SceKqw1B/HQYoU02UQCVDcOwkQ
   A=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="157432669"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 24 Nov 2021 02:15:07 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-5c4a15b1.us-west-2.amazon.com (Postfix) with ESMTPS id E4F5D41FAF;
        Wed, 24 Nov 2021 02:15:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 01/13] af_unix: Use offsetof() instead of sizeof().
Date:   Wed, 24 Nov 2021 11:14:19 +0900
Message-ID: <20211124021431.48956-2-kuniyu@amazon.co.jp>
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

The length of the AF_UNIX socket address contains an offset to the member
sun_path of struct sockaddr_un.

Currently, the preceding member is just sun_family, and its type is
sa_family_t and resolved to short.  Therefore, the offset is represented by
sizeof(short).  However, it is not clear and fragile to changes in struct
sockaddr_storage or sockaddr_un.

This commit makes it clear and robust by rewriting sizeof() with
offsetof().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 19 ++++++++++++-------
 net/unix/diag.c    |  3 ++-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 54e5553a150e..19b3edac8712 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -231,7 +231,8 @@ static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp
 {
 	*hashp = 0;
 
-	if (len <= sizeof(short) || len > sizeof(*sunaddr))
+	if (len <= offsetof(struct sockaddr_un, sun_path) ||
+	    len > sizeof(*sunaddr))
 		return -EINVAL;
 	if (!sunaddr || sunaddr->sun_family != AF_UNIX)
 		return -EINVAL;
@@ -244,7 +245,8 @@ static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp
 		 * kernel address buffer.
 		 */
 		((char *)sunaddr)[len] = 0;
-		len = strlen(sunaddr->sun_path)+1+sizeof(short);
+		len = strlen(sunaddr->sun_path) +
+			offsetof(struct sockaddr_un, sun_path) + 1;
 		return len;
 	}
 
@@ -966,7 +968,8 @@ static int unix_autobind(struct socket *sock)
 		goto out;
 
 	err = -ENOMEM;
-	addr = kzalloc(sizeof(*addr) + sizeof(short) + 16, GFP_KERNEL);
+	addr = kzalloc(sizeof(*addr) +
+		       offsetof(struct sockaddr_un, sun_path) + 16, GFP_KERNEL);
 	if (!addr)
 		goto out;
 
@@ -974,7 +977,8 @@ static int unix_autobind(struct socket *sock)
 	refcount_set(&addr->refcnt, 1);
 
 retry:
-	addr->len = sprintf(addr->name->sun_path+1, "%05x", ordernum) + 1 + sizeof(short);
+	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
+		offsetof(struct sockaddr_un, sun_path) + 1;
 	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
 	addr->hash ^= sk->sk_type;
 
@@ -1156,7 +1160,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	    sunaddr->sun_family != AF_UNIX)
 		return -EINVAL;
 
-	if (addr_len == sizeof(short))
+	if (addr_len == offsetof(struct sockaddr_un, sun_path))
 		return unix_autobind(sock);
 
 	err = unix_mkname(sunaddr, addr_len, &hash);
@@ -1600,7 +1604,7 @@ static int unix_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	if (!addr) {
 		sunaddr->sun_family = AF_UNIX;
 		sunaddr->sun_path[0] = 0;
-		err = sizeof(short);
+		err = offsetof(struct sockaddr_un, sun_path);
 	} else {
 		err = addr->len;
 		memcpy(sunaddr, addr->name, addr->len);
@@ -3231,7 +3235,8 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 			seq_putc(seq, ' ');
 
 			i = 0;
-			len = u->addr->len - sizeof(short);
+			len = u->addr->len -
+				offsetof(struct sockaddr_un, sun_path);
 			if (!UNIX_ABSTRACT(s))
 				len--;
 			else {
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 7e7d7f45685a..db555f267407 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -19,7 +19,8 @@ static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
 	if (!addr)
 		return 0;
 
-	return nla_put(nlskb, UNIX_DIAG_NAME, addr->len - sizeof(short),
+	return nla_put(nlskb, UNIX_DIAG_NAME,
+		       addr->len - offsetof(struct sockaddr_un, sun_path),
 		       addr->name->sun_path);
 }
 
-- 
2.30.2

