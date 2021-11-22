Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726C845941F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbhKVRp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:45:57 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:43270 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240108AbhKVRp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637602970; x=1669138970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YAlEKmFwbhPEfKC3RLbty3bYVtkqMI0rKeDxSwDB8UI=;
  b=YfkiUbU7Uh9IvyggmDEG2GPRQ6zT88cAaHCq2sephXKHXPGSl0qT1knH
   Qe4b8habT8asO9P7GKL0QXohr728ltBLu9J3VS7IKIv8JQXZVI1/G1S2A
   ooefuWeaXSpx/Wu1FsH/WCfY9dx+xc1L7xM6N5SDdoQmHUZcLgIKny8qN
   E=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="973483008"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 22 Nov 2021 17:42:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 1EB2AC158F;
        Mon, 22 Nov 2021 17:42:46 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:45 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:43 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 05/13] af_unix: Cut unix_validate_addr() out of unix_mkname().
Date:   Tue, 23 Nov 2021 02:41:06 +0900
Message-ID: <20211122174114.84594-6-kuniyu@amazon.co.jp>
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
index 98fb8074fe19..103f126df90d 100644
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
@@ -1169,13 +1177,14 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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
@@ -1238,6 +1247,10 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
 		goto out;
 
 	if (addr->sa_family != AF_UNSPEC) {
+		err = unix_validate_addr(sunaddr, alen);
+		if (err)
+			goto out;
+
 		err = unix_mkname(sunaddr, alen, &hash);
 		if (err < 0)
 			goto out;
@@ -1349,6 +1362,10 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	int err;
 	long timeo;
 
+	err = unix_validate_addr(sunaddr, addr_len);
+	if (err)
+		goto out;
+
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
 		goto out;
@@ -1801,6 +1818,10 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
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

