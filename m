Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB63459428
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240331AbhKVRrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:47:12 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:47317 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240279AbhKVRrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:47:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637603045; x=1669139045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PAYg6dqIXLLtd3TOZ3lMy0yioABltO+exRrSCkhCm28=;
  b=nPxRN7BRbKyuN/5pvB14G15QvEihEgZLR/HOgyPMB0CzxY+ofxxqUESO
   RShai4PJMj2uEd9NEAofjvUr1ELQcN0FEwQhlQ9fX/QQbxUyjtHFr8bl5
   g+x9ZYHJxbuzeamxinSVBZ93WU9L3BL6ljrP3vPVPzKQI3ZrNusmqBaJD
   g=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="43393969"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 22 Nov 2021 17:44:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-35b1f9a2.us-east-1.amazon.com (Postfix) with ESMTPS id 892452015B7;
        Mon, 22 Nov 2021 17:44:02 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:44:01 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:43:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 10/13] af_unix: Add helpers to calculate hashes.
Date:   Tue, 23 Nov 2021 02:41:11 +0900
Message-ID: <20211122174114.84594-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122174114.84594-1-kuniyu@amazon.co.jp>
References: <20211122174114.84594-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.57]
X-ClientProxiedBy: EX13D23UWA004.ant.amazon.com (10.43.160.72) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds three helper functions that calculate hashes for unbound
sockets and bound sockets with BSD/abstract addresses.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 63 +++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 16a41dc1ee3e..f1fb9b6fe009 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -123,15 +123,37 @@ DEFINE_SPINLOCK(unix_table_lock);
 EXPORT_SYMBOL_GPL(unix_table_lock);
 static atomic_long_t unix_nr_socks;
 
+/* SMP locking strategy:
+ *    hash table is protected with spinlock unix_table_lock
+ *    each socket state is protected by separate spin lock.
+ */
 
-static struct hlist_head *unix_sockets_unbound(void *addr)
+static unsigned int unix_unbound_hash(struct sock *sk)
 {
-	unsigned long hash = (unsigned long)addr;
+	unsigned long hash = (unsigned long)sk;
 
 	hash ^= hash >> 16;
 	hash ^= hash >> 8;
-	hash %= UNIX_HASH_SIZE;
-	return &unix_socket_table[UNIX_HASH_SIZE + hash];
+	hash ^= sk->sk_type;
+
+	return UNIX_HASH_SIZE + (hash & (UNIX_HASH_SIZE - 1));
+}
+
+static unsigned int unix_bsd_hash(struct inode *i)
+{
+	return i->i_ino & (UNIX_HASH_SIZE - 1);
+}
+
+static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
+				       int addr_len, int type)
+{
+	unsigned int hash;
+
+	hash = (__force unsigned int)csum_fold(csum_partial(sunaddr, addr_len, 0));
+	hash ^= hash >> 8;
+	hash ^= type;
+
+	return hash & (UNIX_HASH_SIZE - 1);
 }
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -162,20 +184,6 @@ static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
 }
 #endif /* CONFIG_SECURITY_NETWORK */
 
-/*
- *  SMP locking strategy:
- *    hash table is protected with spinlock unix_table_lock
- *    each socket state is protected by separate spin lock.
- */
-
-static inline unsigned int unix_hash_fold(__wsum n)
-{
-	unsigned int hash = (__force unsigned int)csum_fold(n);
-
-	hash ^= hash>>8;
-	return hash&(UNIX_HASH_SIZE-1);
-}
-
 #define unix_peer(sk) (unix_sk(sk)->peer)
 
 static inline int unix_our_peer(struct sock *sk, struct sock *osk)
@@ -333,11 +341,11 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 
 static struct sock *unix_find_socket_byinode(struct inode *i)
 {
+	unsigned int hash = unix_bsd_hash(i);
 	struct sock *s;
 
 	spin_lock(&unix_table_lock);
-	sk_for_each(s,
-		    &unix_socket_table[i->i_ino & (UNIX_HASH_SIZE - 1)]) {
+	sk_for_each(s, &unix_socket_table[hash]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
 
 		if (dentry && d_backing_inode(dentry) == i) {
@@ -898,7 +906,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
-	unix_insert_socket(unix_sockets_unbound(sk), sk);
+	unix_insert_socket(&unix_socket_table[unix_unbound_hash(sk)], sk);
 
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
@@ -1008,11 +1016,11 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 static struct sock *unix_find_abstract(struct net *net, struct sockaddr_un *sunaddr,
 				       int addr_len, int type)
 {
-	unsigned int hash = unix_hash_fold(csum_partial(sunaddr, addr_len, 0));
+	unsigned int hash = unix_abstract_hash(sunaddr, addr_len, type);
 	struct dentry *dentry;
 	struct sock *sk;
 
-	sk = unix_find_socket_byname(net, sunaddr, addr_len, type ^ hash);
+	sk = unix_find_socket_byname(net, sunaddr, addr_len, hash);
 	if (!sk)
 		return ERR_PTR(-ECONNREFUSED);
 
@@ -1062,8 +1070,7 @@ static int unix_autobind(struct sock *sk)
 retry:
 	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
 		offsetof(struct sockaddr_un, sun_path) + 1;
-	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
-	addr->hash ^= sk->sk_type;
+	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
@@ -1137,7 +1144,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 		goto out_unlock;
 
 	addr->hash = UNIX_HASH_SIZE;
-	hash = d_backing_inode(dentry)->i_ino & (UNIX_HASH_SIZE - 1);
+	hash = unix_bsd_hash(d_backing_inode(dentry));
 	spin_lock(&unix_table_lock);
 	u->path.mnt = mntget(parent.mnt);
 	u->path.dentry = dget(dentry);
@@ -1179,9 +1186,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int
 		goto out_mutex;
 	}
 
-	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
-	addr->hash ^= sk->sk_type;
-
+	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	spin_lock(&unix_table_lock);
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, addr->hash))
-- 
2.30.2

