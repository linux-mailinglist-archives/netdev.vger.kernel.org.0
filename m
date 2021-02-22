Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CD2321FE0
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhBVTQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhBVTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:13:06 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D26EC061797;
        Mon, 22 Feb 2021 11:12:26 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEGd4-00HAzv-Jj; Mon, 22 Feb 2021 19:12:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 7/8] unix_bind_bsd(): unlink if we fail after successful mknod
Date:   Mon, 22 Feb 2021 19:12:21 +0000
Message-Id: <20210222191222.4093800-7-viro@zeniv.linux.org.uk>
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

We can do that more or less safely, since the parent is
held locked all along.  Yes, somebody might observe the
object via dcache, only to have it disappear afterwards,
but there's really no good way to prevent that.  It won't
race with other bind(2) or attempts to move the sucker
elsewhere, or put something else in its place - locked
parent prevents that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 368376621111..8bbdcddbf598 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1000,27 +1000,19 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	dentry = kern_path_create(AT_FDCWD, addr->name->sun_path, &parent, 0);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-
 	/*
 	 * All right, let's create it.
 	 */
 	err = security_path_mknod(&parent, dentry, mode, 0);
 	if (!err)
 		err = vfs_mknod(d_inode(parent.dentry), dentry, mode, 0);
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
@@ -1032,6 +1024,16 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
 	return 0;
+
+out_unlock:
+	mutex_unlock(&u->bindlock);
+	err = -EINVAL;
+out_unlink:
+	/* failed after successful mknod?  unlink what we'd created... */
+	vfs_unlink(d_inode(parent.dentry), dentry, NULL);
+out:
+	done_path_create(&parent, dentry);
+	return err;
 }
 
 static int unix_bind_abstract(struct sock *sk, unsigned hash,
-- 
2.11.0

