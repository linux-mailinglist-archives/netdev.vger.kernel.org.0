Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45FA45941C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbhKVRp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:45:29 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:44302 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbhKVRp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:45:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637602942; x=1669138942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2XiOC7dnXjozva7lcInopavS1ZPdD+Ahq9Oa8s/qT9k=;
  b=tel2IeH6UIieXnFAmiDHRDlzNx5+4kCW7BwuAWrPFVoJ1bAsh/TyipgV
   QC0Xwgy0qYZkCEnAWx5+YdsMRTqVDND8JwGqATbcLGhaRVEIo1JjGTjwI
   QIsvuyskLZI9LRh/Gzkc76cRRLjjidGDOYSofcBiKpX/hJkxmDj6AEI/h
   U=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="43393461"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 22 Nov 2021 17:42:19 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-ca048aa0.us-east-1.amazon.com (Postfix) with ESMTPS id 029668197B;
        Mon, 22 Nov 2021 17:42:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:16 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:42:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 03/13] af_unix: Factorise unix_find_other() based on address types.
Date:   Tue, 23 Nov 2021 02:41:04 +0900
Message-ID: <20211122174114.84594-4-kuniyu@amazon.co.jp>
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

As done in the commit fa42d910a38e ("unix_bind(): take BSD and abstract
address cases into new helpers"), this patch moves BSD and abstract address
cases from unix_find_other() into unix_find_bsd() and unix_find_abstract().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 133 ++++++++++++++++++++++++++-------------------
 1 file changed, 78 insertions(+), 55 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5153832309b4..248bf85c1e56 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -948,6 +948,84 @@ static int unix_release(struct socket *sock)
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
+static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *sunaddr,
+				       int addr_len, int type, unsigned int hash,
+				       int *error)
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
+static struct sock *unix_find_other(struct net *net, struct sockaddr_un *sunaddr,
+				    int addr_len, int type, unsigned int hash,
+				    int *error)
+{
+	struct sock *sk;
+
+	if (sunaddr->sun_path[0])
+		sk = unix_find_bsd(net, sunaddr, type, error);
+	else
+		sk = unix_find_abstract(net, sunaddr, addr_len, type, hash, error);
+
+	return sk;
+}
+
 static int unix_autobind(struct sock *sk)
 {
 	struct unix_sock *u = unix_sk(sk);
@@ -1004,61 +1082,6 @@ out:	mutex_unlock(&u->bindlock);
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

