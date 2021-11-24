Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF4B45B1F7
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240704AbhKXCUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:20:32 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:41343 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbhKXCUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720243; x=1669256243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SSnEkeIeynG1Z6d/O3xspf3GHevzfVScuHOsau6q8p8=;
  b=i21va1k80DbeL4cPT768gcgFSBIgEGWWMx7wHn/kTFSTcFjy8mBsAe0U
   7OnXZiSBP+CPNnMhrNu4gqrwJoqzTst3SIgev8DTCnNjnEYQtszSYJt79
   VuQzEMpuOATpnOyqH+pzaczcbVEujESbW+9FTLFYU9zij4G+4i14Fn6Qm
   Y=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="43810314"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 24 Nov 2021 02:17:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 6D7B9A2B55;
        Wed, 24 Nov 2021 02:17:21 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:17:20 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:17:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 10/13] af_unix: Add helpers to calculate hashes.
Date:   Wed, 24 Nov 2021 11:14:28 +0900
Message-ID: <20211124021431.48956-11-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211124021431.48956-1-kuniyu@amazon.co.jp>
References: <20211124021431.48956-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D03UWA004.ant.amazon.com (10.43.160.250) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds three helper functions that calculate hashes for unbound
sockets and bound sockets with BSD/abstract addresses.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 64 +++++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 884d69219297..a6956c68d032 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -123,15 +123,38 @@ DEFINE_SPINLOCK(unix_table_lock);
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
+	__wsum csum = csum_partial(sunaddr, addr_len, 0);
+	unsigned int hash;
+
+	hash = (__force unsigned int)csum_fold(csum);
+	hash ^= hash >> 8;
+	hash ^= type;
+
+	return hash & (UNIX_HASH_SIZE - 1);
 }
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -162,20 +185,6 @@ static inline bool unix_secdata_eq(struct scm_cookie *scm, struct sk_buff *skb)
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
@@ -334,11 +343,11 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 
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
@@ -899,7 +908,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
-	unix_insert_socket(unix_sockets_unbound(sk), sk);
+	unix_insert_socket(&unix_socket_table[unix_unbound_hash(sk)], sk);
 
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
@@ -1010,11 +1019,11 @@ static struct sock *unix_find_abstract(struct net *net,
 				       struct sockaddr_un *sunaddr,
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
 
@@ -1066,8 +1075,7 @@ static int unix_autobind(struct sock *sk)
 retry:
 	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
 		offsetof(struct sockaddr_un, sun_path) + 1;
-	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
-	addr->hash ^= sk->sk_type;
+	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
@@ -1144,7 +1152,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 		goto out_unlock;
 
 	addr->hash = UNIX_HASH_SIZE;
-	hash = d_backing_inode(dentry)->i_ino & (UNIX_HASH_SIZE - 1);
+	hash = unix_bsd_hash(d_backing_inode(dentry));
 	spin_lock(&unix_table_lock);
 	u->path.mnt = mntget(parent.mnt);
 	u->path.dentry = dget(dentry);
@@ -1187,9 +1195,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 		goto out_mutex;
 	}
 
-	addr->hash = unix_hash_fold(csum_partial(addr->name, addr->len, 0));
-	addr->hash ^= sk->sk_type;
-
+	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	spin_lock(&unix_table_lock);
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-- 
2.30.2

