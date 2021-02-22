Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DAD321FE3
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhBVTQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbhBVTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:13:06 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8376CC061794;
        Mon, 22 Feb 2021 11:12:26 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEGd4-00HAzt-HJ; Mon, 22 Feb 2021 19:12:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 6/8] unix_bind_bsd(): move done_path_create() call after dealing with ->bindlock
Date:   Mon, 22 Feb 2021 19:12:20 +0000
Message-Id: <20210222191222.4093800-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210222191222.4093800-1-viro@zeniv.linux.org.uk>
References: <YDQAmH9zSsaqf+Dg@zeniv-ca.linux.org.uk>
 <20210222191222.4093800-1-viro@zeniv.linux.org.uk>
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
index 5e04e16e6b88..368376621111 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -988,7 +988,7 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	struct unix_sock *u = unix_sk(sk);
 	umode_t mode = S_IFSOCK |
 	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
-	struct path parent, path;
+	struct path parent;
 	struct dentry *dentry;
 	unsigned int hash;
 	int err;
@@ -1005,36 +1005,32 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	 * All right, let's create it.
 	 */
 	err = security_path_mknod(&parent, dentry, mode, 0);
-	if (!err) {
+	if (!err)
 		err = vfs_mknod(d_inode(parent.dentry), dentry, mode, 0);
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

