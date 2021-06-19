Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8CA3AD78A
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhFSDwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhFSDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:52:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D233C061768
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:50:36 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luS0A-009qc6-Hp; Sat, 19 Jun 2021 03:50:34 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH 7/8] unix_bind_bsd(): unlink if we fail after successful mknod
Date:   Sat, 19 Jun 2021 03:50:32 +0000
Message-Id: <20210619035033.2347136-7-viro@zeniv.linux.org.uk>
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

We can do that more or less safely, since the parent is
held locked all along.  Yes, somebody might observe the
object via dcache, only to have it disappear afterwards,
but there's really no good way to prevent that.  It won't
race with other bind(2) or attempts to move the sucker
elsewhere, or put something else in its place - locked
parent prevents that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3c389a6bf670..fde3175aa3d3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1009,20 +1009,13 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	err = security_path_mknod(&parent, dentry, mode, 0);
 	if (!err)
 		err = vfs_mknod(ns, d_inode(parent.dentry), dentry, mode, 0);
-	if (err) {
-		done_path_create(&parent, dentry);
-		return err;
-	}
+	if (err)
+		goto out;
 	err = mutex_lock_interruptible(&u->bindlock);
-	if (err) {
-		done_path_create(&parent, dentry);
-		return err;
-	}
-	if (u->addr) {
-		mutex_unlock(&u->bindlock);
-		done_path_create(&parent, dentry);
-		return -EINVAL;
-	}
+	if (err)
+		goto out_unlink;
+	if (u->addr)
+		goto out_unlock;
 
 	addr->hash = UNIX_HASH_SIZE;
 	hash = d_backing_inode(dentry)->i_ino & (UNIX_HASH_SIZE - 1);
@@ -1034,6 +1027,16 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
 	return 0;
+
+out_unlock:
+	mutex_unlock(&u->bindlock);
+	err = -EINVAL;
+out_unlink:
+	/* failed after successful mknod?  unlink what we'd created... */
+	vfs_unlink(ns, d_inode(parent.dentry), dentry, NULL);
+out:
+	done_path_create(&parent, dentry);
+	return err;
 }
 
 static int unix_bind_abstract(struct sock *sk, unsigned hash,
-- 
2.11.0

