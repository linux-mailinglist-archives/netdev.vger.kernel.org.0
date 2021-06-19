Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46393AD78D
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhFSDw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbhFSDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:52:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796BDC0617AD
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:50:38 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luS0A-009qby-D0; Sat, 19 Jun 2021 03:50:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH 5/8] fold unix_mknod() into unix_bind_bsd()
Date:   Sat, 19 Jun 2021 03:50:30 +0000
Message-Id: <20210619035033.2347136-5-viro@zeniv.linux.org.uk>
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 04ec7be04909..d5ec0abd389d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -983,46 +983,38 @@ static struct sock *unix_find_other(struct net *net,
 	return NULL;
 }
 
-static int unix_mknod(const char *sun_path, umode_t mode, struct path *res)
+static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 {
+	struct unix_sock *u = unix_sk(sk);
+	umode_t mode = S_IFSOCK |
+	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
+	struct path parent, path;
+	struct user_namespace *ns; // barf...
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
+	ns = mnt_user_ns(parent.mnt);
 
 	/*
 	 * All right, let's create it.
 	 */
-	err = security_path_mknod(&path, dentry, mode, 0);
+	err = security_path_mknod(&parent, dentry, mode, 0);
 	if (!err) {
-		err = vfs_mknod(mnt_user_ns(path.mnt), d_inode(path.dentry),
-				dentry, mode, 0);
+		err = vfs_mknod(ns, d_inode(parent.dentry), dentry, mode, 0);
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

