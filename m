Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E0544F5EA
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbhKNB3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:29:38 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:26433 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbhKNB3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853204; x=1668389204;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsIvw6xfJwKSOt9g7urUFeVunt9zmZwiZLj7JZuNUv0=;
  b=Eh5UinSR+m/XrsQS5Aw5hBQbUEgCF9QQlSjL6ae6sBJhQ+Xt5JseIH/U
   uYibslXZeFm4zvx9eCHK+DnEYaN0jTPFNWe7SQMZOLkyZfSrOdw2ZmPXZ
   5ElnPaVvT8Kf7ta9Gau+CHIqblq2x/XWM+k/S5s+FL8t9kgm7qzj0yjpl
   E=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="41275713"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-5a09360d.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 14 Nov 2021 01:26:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-5a09360d.us-west-2.amazon.com (Postfix) with ESMTPS id 554FA4156F;
        Sun, 14 Nov 2021 01:26:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:26:43 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:26:40 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 08/13] af_unix: Allocate unix_address in unix_bind_(bsd|abstract)().
Date:   Sun, 14 Nov 2021 10:24:23 +0900
Message-ID: <20211114012428.81743-9-kuniyu@amazon.co.jp>
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

To terminate address with '\0' in unix_bind_bsd(), we add
unix_create_addr() and call it in unix_bind_bsd() and unix_bind_abstract().

Also, unix_bind_abstract() does not return -EEXIST.  Only
kern_path_create() and vfs_mknod() in unix_bind_bsd() can return it,
so we move the last error check in unix_bind() to unix_bind_bsd().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 103 +++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 40 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 00f9b83e8966..75ba642dbcac 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -214,6 +214,21 @@ struct sock *unix_peer_get(struct sock *s)
 }
 EXPORT_SYMBOL_GPL(unix_peer_get);
 
+static struct unix_address *unix_create_addr(struct sockaddr_un *sunaddr, int addr_len)
+{
+	struct unix_address *addr;
+
+	addr = kmalloc(sizeof(*addr) + addr_len, GFP_KERNEL);
+	if (!addr)
+		return NULL;
+
+	refcount_set(&addr->refcnt, 1);
+	addr->len = addr_len;
+	memcpy(addr->name, sunaddr, addr_len);
+
+	return addr;
+}
+
 static inline void unix_release_addr(struct unix_address *addr)
 {
 	if (refcount_dec_and_test(&addr->refcnt))
@@ -1083,34 +1098,44 @@ out:	mutex_unlock(&u->bindlock);
 	return err;
 }
 
-static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
+static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_len)
 {
-	struct unix_sock *u = unix_sk(sk);
 	umode_t mode = S_IFSOCK |
 	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
+	struct unix_sock *u = unix_sk(sk);
 	struct user_namespace *ns; // barf...
-	struct path parent;
+	struct unix_address *addr;
 	struct dentry *dentry;
+	struct path parent;
 	unsigned int hash;
 	int err;
 
+	unix_mkname_bsd(sunaddr, addr_len);
+	addr_len = strlen(sunaddr->sun_path) + offsetof(struct sockaddr_un, sun_path) + 1;
+
+	addr = unix_create_addr(sunaddr, addr_len);
+	if (!addr)
+		return -ENOMEM;
+
 	/*
 	 * Get the parent directory, calculate the hash for last
 	 * component.
 	 */
 	dentry = kern_path_create(AT_FDCWD, addr->name->sun_path, &parent, 0);
-	if (IS_ERR(dentry))
-		return PTR_ERR(dentry);
-	ns = mnt_user_ns(parent.mnt);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
+		goto out;
+	}
 
 	/*
 	 * All right, let's create it.
 	 */
+	ns = mnt_user_ns(parent.mnt);
 	err = security_path_mknod(&parent, dentry, mode, 0);
 	if (!err)
 		err = vfs_mknod(ns, d_inode(parent.dentry), dentry, mode, 0);
 	if (err)
-		goto out;
+		goto out_path;
 	err = mutex_lock_interruptible(&u->bindlock);
 	if (err)
 		goto out_unlink;
@@ -1134,47 +1159,59 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 out_unlink:
 	/* failed after successful mknod?  unlink what we'd created... */
 	vfs_unlink(ns, d_inode(parent.dentry), dentry, NULL);
-out:
+out_path:
 	done_path_create(&parent, dentry);
-	return err;
+out:
+	unix_release_addr(addr);
+	return err == -EEXIST ? -EADDRINUSE : err;
 }
 
-static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
+static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int addr_len)
 {
 	struct unix_sock *u = unix_sk(sk);
+	struct unix_address *addr;
 	int err;
 
+	addr = unix_create_addr(sunaddr, addr_len);
+	if (!addr)
+		return -ENOMEM;
+
 	err = mutex_lock_interruptible(&u->bindlock);
 	if (err)
-		return err;
+		goto out;
 
 	if (u->addr) {
-		mutex_unlock(&u->bindlock);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_mutex;
 	}
 
 	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
 	addr->hash ^= sk->sk_type;
 
 	spin_lock(&unix_table_lock);
-	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-				      addr->hash)) {
-		spin_unlock(&unix_table_lock);
-		mutex_unlock(&u->bindlock);
-		return -EADDRINUSE;
-	}
+
+	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, addr->hash))
+		goto out_spin;
+
 	__unix_set_addr(sk, addr, addr->hash);
 	spin_unlock(&unix_table_lock);
 	mutex_unlock(&u->bindlock);
 	return 0;
+
+out_spin:
+	spin_unlock(&unix_table_lock);
+	err = -EADDRINUSE;
+out_mutex:
+	mutex_unlock(&u->bindlock);
+out:
+	unix_release_addr(addr);
+	return err;
 }
 
 static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)uaddr;
-	char *sun_path = sunaddr->sun_path;
 	struct sock *sk = sock->sk;
-	struct unix_address *addr;
 	int err;
 
 	if (addr_len == offsetof(struct sockaddr_un, sun_path) &&
@@ -1185,26 +1222,12 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err)
 		return err;
 
-	if (sun_path[0]) {
-		unix_mkname_bsd(sunaddr, addr_len);
-		addr_len = strlen(sunaddr->sun_path) + offsetof(struct sockaddr_un, sun_path) + 1;
-	}
-
-	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
-	if (!addr)
-		return -ENOMEM;
-
-	memcpy(addr->name, sunaddr, addr_len);
-	addr->len = addr_len;
-	refcount_set(&addr->refcnt, 1);
-
-	if (sun_path[0])
-		err = unix_bind_bsd(sk, addr);
+	if (sunaddr->sun_path[0])
+		err = unix_bind_bsd(sk, sunaddr, addr_len);
 	else
-		err = unix_bind_abstract(sk, addr);
-	if (err)
-		unix_release_addr(addr);
-	return err == -EEXIST ? -EADDRINUSE : err;
+		err = unix_bind_abstract(sk, sunaddr, addr_len);
+
+	return err;
 }
 
 static void unix_state_double_lock(struct sock *sk1, struct sock *sk2)
-- 
2.30.2

