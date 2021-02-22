Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C597321FF0
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbhBVTSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbhBVTNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:13:06 -0500
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B953CC06178B;
        Mon, 22 Feb 2021 11:12:25 -0800 (PST)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEGd4-00HAzx-MA; Mon, 22 Feb 2021 19:12:22 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH 8/8] __unix_find_socket_byname(): don't pass hash and type separately
Date:   Mon, 22 Feb 2021 19:12:22 +0000
Message-Id: <20210222191222.4093800-8-viro@zeniv.linux.org.uk>
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

We only care about exclusive or of those, so pass that directly.
Makes life simpler for callers as well...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/unix/af_unix.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 8bbdcddbf598..3c1218be7165 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -286,11 +286,11 @@ static inline void unix_insert_socket(struct hlist_head *list, struct sock *sk)
 
 static struct sock *__unix_find_socket_byname(struct net *net,
 					      struct sockaddr_un *sunname,
-					      int len, int type, unsigned int hash)
+					      int len, unsigned int hash)
 {
 	struct sock *s;
 
-	sk_for_each(s, &unix_socket_table[hash ^ type]) {
+	sk_for_each(s, &unix_socket_table[hash]) {
 		struct unix_sock *u = unix_sk(s);
 
 		if (!net_eq(sock_net(s), net))
@@ -305,13 +305,12 @@ static struct sock *__unix_find_socket_byname(struct net *net,
 
 static inline struct sock *unix_find_socket_byname(struct net *net,
 						   struct sockaddr_un *sunname,
-						   int len, int type,
-						   unsigned int hash)
+						   int len, unsigned int hash)
 {
 	struct sock *s;
 
 	spin_lock(&unix_table_lock);
-	s = __unix_find_socket_byname(net, sunname, len, type, hash);
+	s = __unix_find_socket_byname(net, sunname, len, hash);
 	if (s)
 		sock_hold(s);
 	spin_unlock(&unix_table_lock);
@@ -898,12 +897,12 @@ static int unix_autobind(struct socket *sock)
 retry:
 	addr->len = sprintf(addr->name->sun_path+1, "%05x", ordernum) + 1 + sizeof(short);
 	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
+	addr->hash ^= sk->sk_type;
 
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
 
-	if (__unix_find_socket_byname(net, addr->name, addr->len, sock->type,
-				      addr->hash)) {
+	if (__unix_find_socket_byname(net, addr->name, addr->len, addr->hash)) {
 		spin_unlock(&unix_table_lock);
 		/*
 		 * __unix_find_socket_byname() may take long time if many names
@@ -918,7 +917,6 @@ static int unix_autobind(struct socket *sock)
 		}
 		goto retry;
 	}
-	addr->hash ^= sk->sk_type;
 
 	__unix_set_addr(sk, addr, addr->hash);
 	spin_unlock(&unix_table_lock);
@@ -965,7 +963,7 @@ static struct sock *unix_find_other(struct net *net,
 		}
 	} else {
 		err = -ECONNREFUSED;
-		u = unix_find_socket_byname(net, sunname, len, type, hash);
+		u = unix_find_socket_byname(net, sunname, len, type ^ hash);
 		if (u) {
 			struct dentry *dentry;
 			dentry = unix_sk(u)->path.dentry;
@@ -1036,8 +1034,7 @@ static int unix_bind_bsd(struct sock *sk, struct unix_address *addr)
 	return err;
 }
 
-static int unix_bind_abstract(struct sock *sk, unsigned hash,
-			      struct unix_address *addr)
+static int unix_bind_abstract(struct sock *sk, struct unix_address *addr)
 {
 	struct unix_sock *u = unix_sk(sk);
 	int err;
@@ -1053,7 +1050,7 @@ static int unix_bind_abstract(struct sock *sk, unsigned hash,
 
 	spin_lock(&unix_table_lock);
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-				      sk->sk_type, hash)) {
+				      addr->hash)) {
 		spin_unlock(&unix_table_lock);
 		mutex_unlock(&u->bindlock);
 		return -EADDRINUSE;
@@ -1096,7 +1093,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (sun_path[0])
 		err = unix_bind_bsd(sk, addr);
 	else
-		err = unix_bind_abstract(sk, hash, addr);
+		err = unix_bind_abstract(sk, addr);
 	if (err)
 		unix_release_addr(addr);
 	return err == -EEXIST ? -EADDRINUSE : err;
-- 
2.11.0

