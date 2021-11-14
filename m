Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC344F5ED
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 02:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbhKNBaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 20:30:25 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:8240 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhKNBaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 20:30:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636853251; x=1668389251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rsIXV+Csmvx2oNKncgAOc2NU8t4VakB62QcKo4YIq+4=;
  b=gs0imkICUMvkVVr5I86hg4pTUHODbTPLVOYcFEl18QkAFowW1+xpoAQH
   8vUcj4jjCS28/+ar1JBixkJJ8c0ALHHCLe8uOO8zo3t6lamt42lEb8+TG
   Mj+8H5X2p20ZRltuc5Zsd40rc/LT7+U9MBO1vgznsbXozTmxm1D4T8ow7
   M=;
X-IronPort-AV: E=Sophos;i="5.87,233,1631577600"; 
   d="scan'208";a="151765595"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 14 Nov 2021 01:27:30 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-31df91b1.us-west-2.amazon.com (Postfix) with ESMTPS id 4145041881;
        Sun, 14 Nov 2021 01:27:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:27:28 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.241) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Sun, 14 Nov 2021 01:27:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 11/13] af_unix: Save hash in sk_hash.
Date:   Sun, 14 Nov 2021 10:24:26 +0900
Message-ID: <20211114012428.81743-12-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211114012428.81743-1-kuniyu@amazon.co.jp>
References: <20211114012428.81743-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.241]
X-ClientProxiedBy: EX13D40UWC003.ant.amazon.com (10.43.162.246) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To replace unix_table_lock with per-hash locks in the next patch, we need
to save a hash in each socket because /proc/net/unix or BPF prog iterate
sockets while holding a hash table lock and release it later in a different
function.

Currently, we store a real/pseudo hash in struct unix_address.  However, we
do not allocate it to unbound sockets, nor should we do just for that.  For
this purpose, we can use sk_hash.  Then, we no longer use the hash field in
struct unix_address and can remove it.

Also, this patch does
  - rename unix_insert_socket() to unix_insert_unbound_socket()
  - remove the redundant list argument from __unix_insert_socket() and
     unix_insert_unbound_socket()
  - use 'unsigned int' instead of 'unsigned' in __unix_set_addr_hash()
  - remove 'inline' from unix_remove_socket() and
     unix_insert_unbound_socket().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/af_unix.h |  1 -
 net/unix/af_unix.c    | 41 ++++++++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 7d142e8a0550..89049cc6c066 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -26,7 +26,6 @@ extern struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
 struct unix_address {
 	refcount_t	refcnt;
 	int		len;
-	unsigned int	hash;
 	struct sockaddr_un name[];
 };
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f95786e00723..db04dda07c39 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -278,31 +278,32 @@ static void __unix_remove_socket(struct sock *sk)
 	sk_del_node_init(sk);
 }
 
-static void __unix_insert_socket(struct hlist_head *list, struct sock *sk)
+static void __unix_insert_socket(struct sock *sk)
 {
 	WARN_ON(!sk_unhashed(sk));
-	sk_add_node(sk, list);
+	sk_add_node(sk, &unix_socket_table[sk->sk_hash]);
 }
 
-static void __unix_set_addr(struct sock *sk, struct unix_address *addr,
-			    unsigned hash)
+static void __unix_set_addr_hash(struct sock *sk, struct unix_address *addr,
+				 unsigned int hash)
 {
 	__unix_remove_socket(sk);
+	sk->sk_hash = hash;
 	smp_store_release(&unix_sk(sk)->addr, addr);
-	__unix_insert_socket(&unix_socket_table[hash], sk);
+	__unix_insert_socket(sk);
 }
 
-static inline void unix_remove_socket(struct sock *sk)
+static void unix_remove_socket(struct sock *sk)
 {
 	spin_lock(&unix_table_lock);
 	__unix_remove_socket(sk);
 	spin_unlock(&unix_table_lock);
 }
 
-static inline void unix_insert_socket(struct hlist_head *list, struct sock *sk)
+static void unix_insert_unbound_socket(struct sock *sk)
 {
 	spin_lock(&unix_table_lock);
-	__unix_insert_socket(list, sk);
+	__unix_insert_socket(sk);
 	spin_unlock(&unix_table_lock);
 }
 
@@ -893,6 +894,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 
 	sock_init_data(sock, sk);
 
+	sk->sk_hash		= unix_unbound_hash(sk);
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
 	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
@@ -908,7 +910,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
-	unix_insert_socket(&unix_socket_table[unix_unbound_hash(sk)], sk);
+	unix_insert_unbound_socket(sk);
 
 	local_bh_disable();
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -1054,6 +1056,7 @@ static int unix_autobind(struct sock *sk)
 	struct unix_address *addr;
 	unsigned int retries = 0;
 	static u32 ordernum = 1;
+	unsigned int new_hash;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1074,12 +1077,12 @@ static int unix_autobind(struct sock *sk)
 retry:
 	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
 		offsetof(struct sockaddr_un, sun_path) + 1;
-	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 
+	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
 
-	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, addr->hash)) {
+	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, new_hash)) {
 		spin_unlock(&unix_table_lock);
 		/*
 		 * __unix_find_socket_byname() may take long time if many names
@@ -1095,7 +1098,7 @@ static int unix_autobind(struct sock *sk)
 		goto retry;
 	}
 
-	__unix_set_addr(sk, addr, addr->hash);
+	__unix_set_addr_hash(sk, addr, new_hash);
 	spin_unlock(&unix_table_lock);
 	err = 0;
 
@@ -1110,9 +1113,9 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 	struct unix_sock *u = unix_sk(sk);
 	struct user_namespace *ns; // barf...
 	struct unix_address *addr;
+	unsigned int new_hash;
 	struct dentry *dentry;
 	struct path parent;
-	unsigned int hash;
 	int err;
 
 	unix_mkname_bsd(sunaddr, addr_len);
@@ -1147,12 +1150,11 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 	if (u->addr)
 		goto out_unlock;
 
-	addr->hash = UNIX_HASH_SIZE;
-	hash = unix_bsd_hash(d_backing_inode(dentry));
+	new_hash = unix_bsd_hash(d_backing_inode(dentry));
 	spin_lock(&unix_table_lock);
 	u->path.mnt = mntget(parent.mnt);
 	u->path.dentry = dget(dentry);
-	__unix_set_addr(sk, addr, hash);
+	__unix_set_addr_hash(sk, addr, new_hash);
 	spin_unlock(&unix_table_lock);
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
@@ -1175,6 +1177,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
+	unsigned int new_hash;
 	int err;
 
 	addr = unix_create_addr(sunaddr, addr_len);
@@ -1190,13 +1193,13 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int
 		goto out_mutex;
 	}
 
-	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
+	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	spin_lock(&unix_table_lock);
 
-	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, addr->hash))
+	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, new_hash))
 		goto out_spin;
 
-	__unix_set_addr(sk, addr, addr->hash);
+	__unix_set_addr_hash(sk, addr, new_hash);
 	spin_unlock(&unix_table_lock);
 	mutex_unlock(&u->bindlock);
 	return 0;
-- 
2.30.2

