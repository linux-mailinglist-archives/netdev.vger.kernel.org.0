Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F723AD78B
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhFSDwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhFSDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:52:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A3CC0617A8
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:50:37 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luS0A-009qbq-6W; Sat, 19 Jun 2021 03:50:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH 3/8] unix_bind(): separate BSD and abstract cases
Date:   Sat, 19 Jun 2021 03:50:28 +0000
Message-Id: <20210619035033.2347136-3-viro@zeniv.linux.org.uk>
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

We do get some duplication that way, but it's minor compared to
parts that are different.  What we get is an ability to change
locking in BSD case without making failure exits very hard to
follow.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 55 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 185f868db998..65a2545d969d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1023,7 +1023,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	int err;
 	unsigned int hash;
 	struct unix_address *addr;
-	struct path path = { };
 
 	err = -EINVAL;
 	if (addr_len < offsetofend(struct sockaddr_un, sun_family) ||
@@ -1050,6 +1049,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	refcount_set(&addr->refcnt, 1);
 
 	if (sun_path[0]) {
+		struct path path = { };
 		umode_t mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current_umask());
 		err = unix_mknod(sun_path, mode, &path);
@@ -1058,41 +1058,54 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 				err = -EADDRINUSE;
 			goto out_addr;
 		}
-	}
 
-	err = mutex_lock_interruptible(&u->bindlock);
-	if (err)
-		goto out_put;
+		err = mutex_lock_interruptible(&u->bindlock);
+		if (err) {
+			path_put(&path);
+			goto out_addr;
+		}
 
-	err = -EINVAL;
-	if (u->addr)
-		goto out_up;
+		err = -EINVAL;
+		if (u->addr) {
+			mutex_unlock(&u->bindlock);
+			path_put(&path);
+			goto out_addr;
+		}
 
-	if (sun_path[0]) {
 		addr->hash = UNIX_HASH_SIZE;
 		hash = d_backing_inode(path.dentry)->i_ino & (UNIX_HASH_SIZE - 1);
 		spin_lock(&unix_table_lock);
 		u->path = path;
+		__unix_set_addr(sk, addr, hash);
+		spin_unlock(&unix_table_lock);
+		mutex_unlock(&u->bindlock);
+		addr = NULL;
+		err = 0;
 	} else {
+		err = mutex_lock_interruptible(&u->bindlock);
+		if (err)
+			goto out_addr;
+
+		err = -EINVAL;
+		if (u->addr) {
+			mutex_unlock(&u->bindlock);
+			goto out_addr;
+		}
+
 		spin_lock(&unix_table_lock);
 		err = -EADDRINUSE;
 		if (__unix_find_socket_byname(net, sunaddr, addr_len,
 					      sk->sk_type, hash)) {
 			spin_unlock(&unix_table_lock);
-			goto out_up;
+			mutex_unlock(&u->bindlock);
+			goto out_addr;
 		}
-		hash = addr->hash;
+		__unix_set_addr(sk, addr, addr->hash);
+		spin_unlock(&unix_table_lock);
+		mutex_unlock(&u->bindlock);
+		addr = NULL;
+		err = 0;
 	}
-
-	__unix_set_addr(sk, addr, hash);
-	spin_unlock(&unix_table_lock);
-	addr = NULL;
-	err = 0;
-out_up:
-	mutex_unlock(&u->bindlock);
-out_put:
-	if (err)
-		path_put(&path);
 out_addr:
 	if (addr)
 		unix_release_addr(addr);
-- 
2.11.0

