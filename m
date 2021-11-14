Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61E44F5E7
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235884AbhKNB2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:28:53 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:2255 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235756AbhKNB2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:28:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853160; x=1668389160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vx/NeQq/vzfHfGtrJ3QvbFPFDv8TXourg5JX+ZZ0mv4=;
  b=Tpe9Y6+l5axPhdDU0h6QhwxTBhuNoGtjb5e/Nyj3C8d9db0r/36T/Sck
   ylTUuPjYe3+P1BlSNoJL2i9+WNaDMpF54XJHdvwSGvlhOm8BCzMJ6EhgO
   /iXgyUq7fVqpOQEZAdSGjQ5rkO1lMDhUXB2lbc9vtbXckvBtPb6cw2Hqf
   g=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="156316724"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 14 Nov 2021 01:25:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-6435a935.us-west-2.amazon.com (Postfix) with ESMTPS id C560641976;
        Sun, 14 Nov 2021 01:25:58 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:25:57 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:25:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 05/13] af_unix: Cut unix_validate_addr() out of unix_mkname().
Date:   Sun, 14 Nov 2021 10:24:20 +0900
Message-ID: <20211114012428.81743-6-kuniyu@amazon.co.jp>
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

unix_mkname() tests socket address length and family and does some
processing based on the address type.  It is called in the early stage,
and therefore some instructions are redundant and can end up in vain.

The address length/family tests are done twice in unix_bind().  Also, the
address type is rechecked later in unix_bind() and unix_find_other(), where
we can do the same processing.  Moreover, in the BSD address case, the hash
is set to 0 but never used and confusing.

This patch moves the address tests out of unix_mkname(), and the following
patches move the other part into appropriate places and remove
unix_mkname() finally.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cb4e8cfa3958..32164a5d8c40 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -227,14 +227,22 @@ static inline void unix_release_addr(struct unix_address *addr)
  *		- if started by zero, it is abstract name.
  */
 
+static int unix_validate_addr(struct sockaddr_un *sunaddr, int addr_len)
+{
+	if (addr_len <= offsetof(struct sockaddr_un, sun_path) ||
+	    addr_len > sizeof(*sunaddr))
+		return -EINVAL;
+
+	if (sunaddr->sun_family != AF_UNIX)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int unix_mkname(struct sockaddr_un *sunaddr, int len, unsigned int *hashp)
 {
 	*hashp = 0;
 
-	if (len <= offsetof(struct sockaddr_un, sun_path) || len > sizeof(*sunaddr))
-		return -EINVAL;
-	if (!sunaddr || sunaddr->sun_family != AF_UNIX)
-		return -EINVAL;
 	if (sunaddr->sun_path[0]) {
 		/*
 		 * This may look like an off by one error but it is a bit more
@@ -1173,13 +1181,14 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	unsigned int hash;
 	struct unix_address *addr;
 
-	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
-	    sunaddr->sun_family != AF_UNIX)
-		return -EINVAL;
-
-	if (addr_len == offsetof(struct sockaddr_un, sun_path))
+	if (addr_len == offsetof(struct sockaddr_un, sun_path) &&
+	    sunaddr->sun_family == AF_UNIX)
 		return unix_autobind(sk);
 
+	err = unix_validate_addr(sunaddr, addr_len);
+	if (err)
+		return err;
+
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
 		return err;
@@ -1242,6 +1251,10 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		goto out;
 
 	if (addr->sa_family != AF_UNSPEC) {
+		err = unix_validate_addr(sunaddr, alen);
+		if (err)
+			goto out;
+
 		err = unix_mkname(sunaddr, alen, &hash);
 		if (err < 0)
 			goto out;
@@ -1353,6 +1366,10 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	int err;
 	long timeo;
 
+	err = unix_validate_addr(sunaddr, addr_len);
+	if (err)
+		goto out;
+
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
 		goto out;
@@ -1805,6 +1822,10 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 
 	if (msg->msg_namelen) {
+		err = unix_validate_addr(sunaddr, msg->msg_namelen);
+		if (err)
+			goto out;
+
 		err = unix_mkname(sunaddr, msg->msg_namelen, &hash);
 		if (err < 0)
 			goto out;
-- 
2.30.2

