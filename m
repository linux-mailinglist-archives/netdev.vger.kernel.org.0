Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935B4446D2A
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhKFJVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:21:23 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:47986 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhKFJVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:21:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190323; x=1667726323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vx/NeQq/vzfHfGtrJ3QvbFPFDv8TXourg5JX+ZZ0mv4=;
  b=is6d0fB7gwHEJMBxDEcmITCWWzDyRhPssukRdulT5JRxQxKO6BC6e6f2
   TZBAk4S7KWRDMTqOT6gYDAMxi1anuo7vM8C6S4xybjyTg1Lm8t8NLt1Vz
   3mA5swrHDJ7hVqlyyCvqMWZtAGe0XNMyZmS1nl47O1fanbxjxl9qSncng
   4=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="153173191"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 06 Nov 2021 09:18:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com (Postfix) with ESMTPS id 98AE9C0932;
        Sat,  6 Nov 2021 09:18:41 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:18:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:18:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 05/13] af_unix: Cut unix_validate_addr() out of unix_mkname().
Date:   Sat, 6 Nov 2021 18:17:04 +0900
Message-ID: <20211106091712.15206-6-kuniyu@amazon.co.jp>
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

