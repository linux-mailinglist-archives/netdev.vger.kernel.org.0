Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C4A321FE9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhBVTR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbhBVTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:13:06 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F7AC06178C;
        Mon, 22 Feb 2021 11:12:25 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEGd4-00HAzj-3X; Mon, 22 Feb 2021 19:12:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 1/8] af_unix: take address assignment/hash insertion into a new helper
Date:   Mon, 22 Feb 2021 19:12:15 +0000
Message-Id: <20210222191222.4093800-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <YDQAmH9zSsaqf+Dg@zeniv-ca.linux.org.uk>
References: <YDQAmH9zSsaqf+Dg@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duplicated logics in all bind variants (autobind, bind-to-path,
bind-to-abstract) gets taken into a common helper.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 41c3303c3357..45a40cf7b6af 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -262,6 +262,14 @@ static void __unix_insert_socket(struct hlist_head *list, struct sock *sk)
 	sk_add_node(sk, list);
 }
 
+static void __unix_set_addr(struct sock *sk, struct unix_address *addr,
+			    unsigned hash)
+{
+	__unix_remove_socket(sk);
+	smp_store_release(&unix_sk(sk)->addr, addr);
+	__unix_insert_socket(&unix_socket_table[hash], sk);
+}
+
 static inline void unix_remove_socket(struct sock *sk)
 {
 	spin_lock(&unix_table_lock);
@@ -912,9 +920,7 @@ static int unix_autobind(struct socket *sock)
 	}
 	addr->hash ^= sk->sk_type;
 
-	__unix_remove_socket(sk);
-	smp_store_release(&u->addr, addr);
-	__unix_insert_socket(&unix_socket_table[addr->hash], sk);
+	__unix_set_addr(sk, addr, addr->hash);
 	spin_unlock(&unix_table_lock);
 	err = 0;
 
@@ -1016,7 +1022,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	int err;
 	unsigned int hash;
 	struct unix_address *addr;
-	struct hlist_head *list;
 	struct path path = { };
 
 	err = -EINVAL;
@@ -1068,25 +1073,20 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		hash = d_backing_inode(path.dentry)->i_ino & (UNIX_HASH_SIZE - 1);
 		spin_lock(&unix_table_lock);
 		u->path = path;
-		list = &unix_socket_table[hash];
 	} else {
 		spin_lock(&unix_table_lock);
 		err = -EADDRINUSE;
 		if (__unix_find_socket_byname(net, sunaddr, addr_len,
 					      sk->sk_type, hash)) {
+			spin_unlock(&unix_table_lock);
 			unix_release_addr(addr);
-			goto out_unlock;
+			goto out_up;
 		}
-
-		list = &unix_socket_table[addr->hash];
+		hash = addr->hash;
 	}
 
 	err = 0;
-	__unix_remove_socket(sk);
-	smp_store_release(&u->addr, addr);
-	__unix_insert_socket(list, sk);
-
-out_unlock:
+	__unix_set_addr(sk, addr, hash);
 	spin_unlock(&unix_table_lock);
 out_up:
 	mutex_unlock(&u->bindlock);
-- 
2.11.0

