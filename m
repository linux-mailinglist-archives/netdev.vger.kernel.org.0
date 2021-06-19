Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3426B3AD788
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhFSDww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhFSDws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:52:48 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0233FC061574
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 20:50:34 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1luS09-009qbk-S8; Sat, 19 Jun 2021 03:50:33 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH 1/8] af_unix: take address assignment/hash insertion into a new helper
Date:   Sat, 19 Jun 2021 03:50:26 +0000
Message-Id: <20210619035033.2347136-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YM1pEoZxc2P17nlp@zeniv-ca.linux.org.uk>
References: <YM1pEoZxc2P17nlp@zeniv-ca.linux.org.uk>
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
index 4d4f24cbd86b..464473a78b05 100644
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
 
@@ -1017,7 +1023,6 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	int err;
 	unsigned int hash;
 	struct unix_address *addr;
-	struct hlist_head *list;
 	struct path path = { };
 
 	err = -EINVAL;
@@ -1069,25 +1074,20 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
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

