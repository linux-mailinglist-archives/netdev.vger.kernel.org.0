Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B246044F5E3
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKNB1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:27:54 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:58813 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhKNB1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853100; x=1668389100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0F7mhTkggN4Aci28q7G1AHhOrM1/oe9uGG6Si3UbprI=;
  b=YVcPHB6OlE47WL9LzkxUj+rSBQokRpsvz5HgOXEZR/yDSdESacyqxNBN
   PnsoY0YYxmNEIRzEbFFJ0XNfIoUWlZqOLmomByeU1uPEshN43apiIKCxV
   pNdDwsWxr3tX0ZojpmUFKKMlN/uhBQAnAJIMGKqDixtGnnouqFAs6IyTk
   M=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="971465804"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 14 Nov 2021 01:25:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-7d0c7241.us-west-2.amazon.com (Postfix) with ESMTPS id 1620E41295;
        Sun, 14 Nov 2021 01:25:00 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:24:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:24:56 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 01/13] af_unix: Use offsetof() instead of sizeof().
Date:   Sun, 14 Nov 2021 10:24:16 +0900
Message-ID: <20211114012428.81743-2-kuniyu@amazon.co.jp>
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
 net/unix/af_unix.c | 15 ++++++++-------
 net/unix/diag.c    |  3 ++-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 78e08e82c08c..b0ef27062489 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -231,7 +231,7 @@ static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp
 {
 	*hashp = 0;
 
-	if (len <= sizeof(short) || len > sizeof(*sunaddr))
+	if (len <= offsetof(struct sockaddr_un, sun_path) || len > sizeof(*sunaddr))
 		return -EINVAL;
 	if (!sunaddr || sunaddr->sun_family != AF_UNIX)
 		return -EINVAL;
@@ -244,7 +244,7 @@ static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp
 		 * kernel address buffer.
 		 */
 		((char *)sunaddr)[len] = 0;
-		len = strlen(sunaddr->sun_path)+1+sizeof(short);
+		len = strlen(sunaddr->sun_path) + offsetof(struct sockaddr_un, sun_path) + 1;
 		return len;
 	}
 
@@ -970,7 +970,7 @@ static int unix_autobind(struct socket *sock)
 		goto out;
 
 	err = -ENOMEM;
-	addr = kzalloc(sizeof(*addr) + sizeof(short) + 16, GFP_KERNEL);
+	addr = kzalloc(sizeof(*addr) + offsetof(struct sockaddr_un, sun_path) + 16, GFP_KERNEL);
 	if (!addr)
 		goto out;
 
@@ -978,7 +978,8 @@ static int unix_autobind(struct socket *sock)
 	refcount_set(&addr->refcnt, 1);
 
 retry:
-	addr->len = sprintf(addr->name->sun_path+1, "%05x", ordernum) + 1 + sizeof(short);
+	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
+		offsetof(struct sockaddr_un, sun_path) + 1;
 	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
 	addr->hash ^= sk->sk_type;
 
@@ -1160,7 +1161,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	    sunaddr->sun_family != AF_UNIX)
 		return -EINVAL;
 
-	if (addr_len == sizeof(short))
+	if (addr_len == offsetof(struct sockaddr_un, sun_path))
 		return unix_autobind(sock);
 
 	err = unix_mkname(sunaddr, addr_len, &hash);
@@ -1604,7 +1605,7 @@ static int unix_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	if (!addr) {
 		sunaddr->sun_family = AF_UNIX;
 		sunaddr->sun_path[0] = 0;
-		err = sizeof(short);
+		err = offsetof(struct sockaddr_un, sun_path);
 	} else {
 		err = addr->len;
 		memcpy(sunaddr, addr->name, addr->len);
@@ -3235,7 +3236,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 			seq_putc(seq, ' ');
 
 			i = 0;
-			len = u->addr->len - sizeof(short);
+			len = u->addr->len - offsetof(struct sockaddr_un, sun_path);
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

