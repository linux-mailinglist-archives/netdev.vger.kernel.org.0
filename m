Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FCA45B1EF
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhKXCSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:18:47 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:24183 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhKXCSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720138; x=1669256138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TGQVVzBcAx8b96z4Jk9anp6+NlBbxB1ZdJfDKZdnkas=;
  b=QKvRIp5pDcnJRIhJLT7DXlge1wMEeXCsBR0Y/fGwcuXRHsL8CGhxvRT+
   V8is3wtg5QyEbPXjHx+p2k4MEwPPjmlUa15ez+kU9MaTiJ7pXk0ahJ7Z7
   vbduO5BwtqAgviisUfxlNnVOfWleot5I8kHB09Hvosnz+xWy/Mh8VAvGw
   o=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="154295576"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 24 Nov 2021 02:15:37 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-34cb9e7b.us-west-2.amazon.com (Postfix) with ESMTPS id C270241F48;
        Wed, 24 Nov 2021 02:15:36 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:36 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:15:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 03/13] af_unix: Factorise unix_find_other() based on address types.
Date:   Wed, 24 Nov 2021 11:14:21 +0900
Message-ID: <20211124021431.48956-4-kuniyu@amazon.co.jp>
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

As done in the commit fa42d910a38e ("unix_bind(): take BSD and abstract
address cases into new helpers"), this patch moves BSD and abstract address
cases from unix_find_other() into unix_find_bsd() and unix_find_abstract().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 136 +++++++++++++++++++++++++++------------------
 1 file changed, 81 insertions(+), 55 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f654fc5882bc..fe45df5e44d9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -950,6 +950,87 @@ static int unix_release(struct socket *sock)
 	return 0;
 }
 
+static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
+				  int type, int *error)
+{
+	struct inode *inode;
+	struct path path;
+	struct sock *sk;
+	int err;
+
+	err = kern_path(sunaddr->sun_path, LOOKUP_FOLLOW, &path);
+	if (err)
+		goto fail;
+
+	err = path_permission(&path, MAY_WRITE);
+	if (err)
+		goto path_put;
+
+	err = -ECONNREFUSED;
+	inode = d_backing_inode(path.dentry);
+	if (!S_ISSOCK(inode->i_mode))
+		goto path_put;
+
+	sk = unix_find_socket_byinode(inode);
+	if (!sk)
+		goto path_put;
+
+	err = -EPROTOTYPE;
+	if (sk->sk_type == type)
+		touch_atime(&path);
+	else
+		goto sock_put;
+
+	path_put(&path);
+
+	return sk;
+
+sock_put:
+	sock_put(sk);
+path_put:
+	path_put(&path);
+fail:
+	*error = err;
+	return NULL;
+}
+
+static struct sock *unix_find_abstract(struct net *net,
+				       struct sockaddr_un *sunaddr,
+				       int addr_len, int type,
+				       unsigned int hash, int *error)
+{
+	struct dentry *dentry;
+	struct sock *sk;
+
+	sk = unix_find_socket_byname(net, sunaddr, addr_len, type ^ hash);
+	if (!sk) {
+		*error = -ECONNREFUSED;
+		return NULL;
+	}
+
+	dentry = unix_sk(sk)->path.dentry;
+	if (dentry)
+		touch_atime(&unix_sk(sk)->path);
+
+	return sk;
+}
+
+static struct sock *unix_find_other(struct net *net,
+				    struct sockaddr_un *sunaddr,
+				    int addr_len, int type,
+				    unsigned int hash, int *error)
+{
+	struct sock *sk;
+
+	if (sunaddr->sun_path[0])
+		sk = unix_find_bsd(net, sunaddr, type, error);
+	else
+		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash,
+					error);
+
+	return sk;
+}
+
 static int unix_autobind(struct sock *sk)
 {
 	struct unix_sock *u = unix_sk(sk);
@@ -1008,61 +1089,6 @@ out:	mutex_unlock(&u->bindlock);
 	return err;
 }
 
-static struct sock *unix_find_other(struct net *net,
-				    struct sockaddr_un *sunname, int len,
-				    int type, unsigned int hash, int *error)
-{
-	struct sock *u;
-	struct path path;
-	int err = 0;
-
-	if (sunname->sun_path[0]) {
-		struct inode *inode;
-		err = kern_path(sunname->sun_path, LOOKUP_FOLLOW, &path);
-		if (err)
-			goto fail;
-		inode = d_backing_inode(path.dentry);
-		err = path_permission(&path, MAY_WRITE);
-		if (err)
-			goto put_fail;
-
-		err = -ECONNREFUSED;
-		if (!S_ISSOCK(inode->i_mode))
-			goto put_fail;
-		u = unix_find_socket_byinode(inode);
-		if (!u)
-			goto put_fail;
-
-		if (u->sk_type == type)
-			touch_atime(&path);
-
-		path_put(&path);
-
-		err = -EPROTOTYPE;
-		if (u->sk_type != type) {
-			sock_put(u);
-			goto fail;
-		}
-	} else {
-		err = -ECONNREFUSED;
-		u = unix_find_socket_byname(net, sunname, len, type ^ hash);
-		if (u) {
-			struct dentry *dentry;
-			dentry = unix_sk(u)->path.dentry;
-			if (dentry)
-				touch_atime(&unix_sk(u)->path);
-		} else
-			goto fail;
-	}
-	return u;
-
-put_fail:
-	path_put(&path);
-fail:
-	*error = err;
-	return NULL;
-}
-
 static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 {
 	struct unix_sock *u = unix_sk(sk);
-- 
2.30.2

