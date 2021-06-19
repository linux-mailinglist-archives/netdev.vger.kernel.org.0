Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E63AD78C
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhFSDw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhFSDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:52:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B86C0617A6
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:50:36 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luS0A-009qc2-FQ; Sat, 19 Jun 2021 03:50:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH 6/8] unix_bind_bsd(): move done_path_create() call after dealing with ->bindlock
Date:   Sat, 19 Jun 2021 03:50:31 +0000
Message-Id: <20210619035033.2347136-6-viro@zeniv.linux.org.uk>
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

Final preparations for doing unlink on failure past the successful
mknod.  We can't hold ->bindlock over ->mknod() or ->unlink(), since
either might do sb_start_write() (e.g. on overlayfs).  However, we
can do it while holding filesystem and VFS locks - doing
	kern_path_create()
	vfs_mknod()
	grab ->bindlock
	if u->addr had been set
		drop ->bindlock
		done_path_create
		return -EINVAL
	else
		assign the address to socket
		drop ->bindlock
		done_path_create
		return 0
would be deadlock-free.  Here we massage unix_bind_bsd() to that
form.  We are still doing equivalent transformations.

Next commit will *not* be an equivalent transformation - it will
add a call of vfs_unlink() before done_path_create() in "alread bound"
case.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d5ec0abd389d..3c389a6bf670 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -988,8 +988,8 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	struct unix_sock *u = unix_sk(sk);
 	umode_t mode = S_IFSOCK |
 	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
-	struct path parent, path;
 	struct user_namespace *ns; // barf...
+	struct path parent;
 	struct dentry *dentry;
 	unsigned int hash;
 	int err;
@@ -1007,36 +1007,32 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	 * All right, let's create it.
 	 */
 	err = security_path_mknod(&parent, dentry, mode, 0);
-	if (!err) {
+	if (!err)
 		err = vfs_mknod(ns, d_inode(parent.dentry), dentry, mode, 0);
-		if (!err) {
-			path.mnt = mntget(parent.mnt);
-			path.dentry = dget(dentry);
-		}
-	}
-	done_path_create(&parent, dentry);
-	if (err)
+	if (err) {
+		done_path_create(&parent, dentry);
 		return err;
-
+	}
 	err = mutex_lock_interruptible(&u->bindlock);
 	if (err) {
-		path_put(&path);
+		done_path_create(&parent, dentry);
 		return err;
 	}
-
 	if (u->addr) {
 		mutex_unlock(&u->bindlock);
-		path_put(&path);
+		done_path_create(&parent, dentry);
 		return -EINVAL;
 	}
 
 	addr->hash = UNIX_HASH_SIZE;
-	hash = d_backing_inode(path.dentry)->i_ino & (UNIX_HASH_SIZE - 1);
+	hash = d_backing_inode(dentry)->i_ino & (UNIX_HASH_SIZE - 1);
 	spin_lock(&unix_table_lock);
-	u->path = path;
+	u->path.mnt = mntget(parent.mnt);
+	u->path.dentry = dget(dentry);
 	__unix_set_addr(sk, addr, hash);
 	spin_unlock(&unix_table_lock);
 	mutex_unlock(&u->bindlock);
+	done_path_create(&parent, dentry);
 	return 0;
 }
 
-- 
2.11.0

