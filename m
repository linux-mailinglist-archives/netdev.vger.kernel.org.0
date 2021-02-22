Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE105321FDE
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhBVTQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbhBVTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:13:06 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8235EC061793;
        Mon, 22 Feb 2021 11:12:26 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEGd4-00HAzl-7o; Mon, 22 Feb 2021 19:12:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 2/8] unix_bind(): allocate addr earlier
Date:   Mon, 22 Feb 2021 19:12:16 +0000
Message-Id: <20210222191222.4093800-2-viro@zeniv.linux.org.uk>
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

makes it easier to massage; we do pay for that by extra work
(kmalloc+memcpy+kfree) in some error cases, but those are not
on the hot paths anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 45a40cf7b6af..54f1bfe14191 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1038,6 +1038,15 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (err < 0)
 		goto out;
 	addr_len = err;
+	err = -ENOMEM;
+	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
+	if (!addr)
+		goto out;
+
+	memcpy(addr->name, sunaddr, addr_len);
+	addr->len = addr_len;
+	addr->hash = hash ^ sk->sk_type;
+	refcount_set(&addr->refcnt, 1);
 
 	if (sun_path[0]) {
 		umode_t mode = S_IFSOCK |
@@ -1046,7 +1055,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		if (err) {
 			if (err == -EEXIST)
 				err = -EADDRINUSE;
-			goto out;
+			goto out_addr;
 		}
 	}
 
@@ -1058,16 +1067,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (u->addr)
 		goto out_up;
 
-	err = -ENOMEM;
-	addr = kmalloc(sizeof(*addr)+addr_len, GFP_KERNEL);
-	if (!addr)
-		goto out_up;
-
-	memcpy(addr->name, sunaddr, addr_len);
-	addr->len = addr_len;
-	addr->hash = hash ^ sk->sk_type;
-	refcount_set(&addr->refcnt, 1);
-
 	if (sun_path[0]) {
 		addr->hash = UNIX_HASH_SIZE;
 		hash = d_backing_inode(path.dentry)->i_ino & (UNIX_HASH_SIZE - 1);
@@ -1079,20 +1078,23 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		if (__unix_find_socket_byname(net, sunaddr, addr_len,
 					      sk->sk_type, hash)) {
 			spin_unlock(&unix_table_lock);
-			unix_release_addr(addr);
 			goto out_up;
 		}
 		hash = addr->hash;
 	}
 
-	err = 0;
 	__unix_set_addr(sk, addr, hash);
 	spin_unlock(&unix_table_lock);
+	addr = NULL;
+	err = 0;
 out_up:
 	mutex_unlock(&u->bindlock);
 out_put:
 	if (err)
 		path_put(&path);
+out_addr:
+	if (addr)
+		unix_release_addr(addr);
 out:
 	return err;
 }
-- 
2.11.0

