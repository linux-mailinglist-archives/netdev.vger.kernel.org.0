Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F173AD789
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhFSDwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbhFSDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:52:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52816C061760
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:50:35 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luS0A-009qbu-8y; Sat, 19 Jun 2021 03:50:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH 4/8] unix_bind(): take BSD and abstract address cases into new helpers
Date:   Sat, 19 Jun 2021 03:50:29 +0000
Message-Id: <20210619035033.2347136-4-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210619035033.2347136-1-viro@zeniv.linux.org.uk>
References: <YM1pEoZxc2P17nlp@zeniv-ca.linux.org.uk>
 <20210619035033.2347136-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unix_bind_bsd() and unix_bind_abstract() respectively.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 147 +++++++++++++++++++++++++++--------------------------
 1 file changed, 74 insertions(+), 73 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 65a2545d969d..04ec7be04909 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1013,104 +1013,105 @@ static int unix_mknod(const char *sun_path, umode_t mode, struct path *res)
 	return err;
 }
 
+static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
+{
+	struct unix_sock *u = unix_sk(sk);
+	struct path path = { };
+	umode_t mode = S_IFSOCK |
+	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
+	unsigned int hash;
+	int err;
+
+	err = unix_mknod(addr->name->sun_path, mode, &path);
+	if (err)
+		return err;
+
+	err = mutex_lock_interruptible(&u->bindlock);
+	if (err) {
+		path_put(&path);
+		return err;
+	}
+
+	if (u->addr) {
+		mutex_unlock(&u->bindlock);
+		path_put(&path);
+		return -EINVAL;
+	}
+
+	addr->hash = UNIX_HASH_SIZE;
+	hash = d_backing_inode(path.dentry)->i_ino & (UNIX_HASH_SIZE - 1);
+	spin_lock(&unix_table_lock);
+	u->path = path;
+	__unix_set_addr(sk, addr, hash);
+	spin_unlock(&unix_table_lock);
+	mutex_unlock(&u->bindlock);
+	return 0;
+}
+
+static int unix_bind_abstract(struct sock *sk, unsigned hash,
+			      struct unix_address *addr)
+{
+	struct unix_sock *u = unix_sk(sk);
+	int err;
+
+	err = mutex_lock_interruptible(&u->bindlock);
+	if (err)
+		return err;
+
+	if (u->addr) {
+		mutex_unlock(&u->bindlock);
+		return -EINVAL;
+	}
+
+	spin_lock(&unix_table_lock);
+	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
+				      sk->sk_type, hash)) {
+		spin_unlock(&unix_table_lock);
+		mutex_unlock(&u->bindlock);
+		return -EADDRINUSE;
+	}
+	__unix_set_addr(sk, addr, addr->hash);
+	spin_unlock(&unix_table_lock);
+	mutex_unlock(&u->bindlock);
+	return 0;
+}
+
 static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 {
 	struct sock *sk = sock->sk;
-	struct net *net = sock_net(sk);
-	struct unix_sock *u = unix_sk(sk);
 	struct sockaddr_un *sunaddr = (struct sockaddr_un *)uaddr;
 	char *sun_path = sunaddr->sun_path;
 	int err;
 	unsigned int hash;
 	struct unix_address *addr;
 
-	err = -EINVAL;
 	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
 	    sunaddr->sun_family != AF_UNIX)
-		goto out;
+		return -EINVAL;
 
-	if (addr_len == sizeof(short)) {
-		err = unix_autobind(sock);
-		goto out;
-	}
+	if (addr_len == sizeof(short))
+		return unix_autobind(sock);
 
 	err = unix_mkname(sunaddr, addr_len, &hash);
 	if (err < 0)
-		goto out;
+		return err;
 	addr_len = err;
-	err = -ENOMEM;
 	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
 	if (!addr)
-		goto out;
+		return -ENOMEM;
 
 	memcpy(addr->name, sunaddr, addr_len);
 	addr->len = addr_len;
 	addr->hash = hash ^ sk->sk_type;
 	refcount_set(&addr->refcnt, 1);
 
-	if (sun_path[0]) {
-		struct path path = { };
-		umode_t mode = S_IFSOCK |
-		       (SOCK_INODE(sock)->i_mode & ~current_umask());
-		err = unix_mknod(sun_path, mode, &path);
-		if (err) {
-			if (err == -EEXIST)
-				err = -EADDRINUSE;
-			goto out_addr;
-		}
-
-		err = mutex_lock_interruptible(&u->bindlock);
-		if (err) {
-			path_put(&path);
-			goto out_addr;
-		}
-
-		err = -EINVAL;
-		if (u->addr) {
-			mutex_unlock(&u->bindlock);
-			path_put(&path);
-			goto out_addr;
-		}
-
-		addr->hash = UNIX_HASH_SIZE;
-		hash = d_backing_inode(path.dentry)->i_ino & (UNIX_HASH_SIZE - 1);
-		spin_lock(&unix_table_lock);
-		u->path = path;
-		__unix_set_addr(sk, addr, hash);
-		spin_unlock(&unix_table_lock);
-		mutex_unlock(&u->bindlock);
-		addr = NULL;
-		err = 0;
-	} else {
-		err = mutex_lock_interruptible(&u->bindlock);
-		if (err)
-			goto out_addr;
-
-		err = -EINVAL;
-		if (u->addr) {
-			mutex_unlock(&u->bindlock);
-			goto out_addr;
-		}
-
-		spin_lock(&unix_table_lock);
-		err = -EADDRINUSE;
-		if (__unix_find_socket_byname(net, sunaddr, addr_len,
-					      sk->sk_type, hash)) {
-			spin_unlock(&unix_table_lock);
-			mutex_unlock(&u->bindlock);
-			goto out_addr;
-		}
-		__unix_set_addr(sk, addr, addr->hash);
-		spin_unlock(&unix_table_lock);
-		mutex_unlock(&u->bindlock);
-		addr = NULL;
-		err = 0;
-	}
-out_addr:
-	if (addr)
+	if (sun_path[0])
+		err = unix_bind_bsd(sk, addr);
+	else
+		err = unix_bind_abstract(sk, hash, addr);
+	if (err)
 		unix_release_addr(addr);
-out:
-	return err;
+	return err == -EEXIST ? -EADDRINUSE : err;
 }
 
 static void unix_state_double_lock(struct sock *sk1, struct sock *sk2)
-- 
2.11.0

