Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BCB321FF9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhBVTUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhBVTNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:13:05 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA617C06178A;
        Mon, 22 Feb 2021 11:12:25 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEGd4-00HAzr-Ex; Mon, 22 Feb 2021 19:12:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 5/8] fold unix_mknod() into unix_bind_bsd()
Date:   Mon, 22 Feb 2021 19:12:19 +0000
Message-Id: <20210222191222.4093800-5-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 56443f05ed9d..5e04e16e6b88 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -983,45 +983,36 @@ static struct sock *unix_find_other(struct net *net,
 	return NULL;
 }
 
-static int unix_mknod(const char *sun_path, umode_t mode, struct path *res)
+static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 {
+	struct unix_sock *u = unix_sk(sk);
+	umode_t mode = S_IFSOCK |
+	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
+	struct path parent, path;
 	struct dentry *dentry;
-	struct path path;
-	int err = 0;
+	unsigned int hash;
+	int err;
+
 	/*
 	 * Get the parent directory, calculate the hash for last
 	 * component.
 	 */
-	dentry = kern_path_create(AT_FDCWD, sun_path, &path, 0);
-	err = PTR_ERR(dentry);
+	dentry = kern_path_create(AT_FDCWD, addr->name->sun_path, &parent, 0);
 	if (IS_ERR(dentry))
-		return err;
+		return PTR_ERR(dentry);
 
 	/*
 	 * All right, let's create it.
 	 */
-	err = security_path_mknod(&path, dentry, mode, 0);
+	err = security_path_mknod(&parent, dentry, mode, 0);
 	if (!err) {
-		err = vfs_mknod(d_inode(path.dentry), dentry, mode, 0);
+		err = vfs_mknod(d_inode(parent.dentry), dentry, mode, 0);
 		if (!err) {
-			res->mnt = mntget(path.mnt);
-			res->dentry = dget(dentry);
+			path.mnt = mntget(parent.mnt);
+			path.dentry = dget(dentry);
 		}
 	}
-	done_path_create(&path, dentry);
-	return err;
-}
-
-static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
-{
-	struct unix_sock *u = unix_sk(sk);
-	struct path path = { };
-	umode_t mode = S_IFSOCK |
-	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
-	unsigned int hash;
-	int err;
-
-	err = unix_mknod(addr->name->sun_path, mode, &path);
+	done_path_create(&parent, dentry);
 	if (err)
 		return err;
 
-- 
2.11.0

