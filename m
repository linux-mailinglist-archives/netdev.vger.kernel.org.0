Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF3E459429
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240279AbhKVRrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:47:31 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:18695 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240155AbhKVRra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:47:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637603064; x=1669139064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HT3tS8gRqVTO8OoEVX/LE2OMOU13Gsxiy7YaGiL2Rb4=;
  b=KgKvCEDRS7sLWAjOXi1cwvxMdGsHKLF8cVUGEBbtyup75EmMWsdf2S7Z
   VYG25ncHl7F0nslbeleufSxqWcgGMVFHdK9vgMCzLCA/frDcsI1U5ah/S
   HaKYt9z9pM071ge5W3FzIS1GNeu7fxd/NcvO8vB3giVG3g1rvKyKOBuVH
   I=;
X-IronPort-AV: E=Sophos;i="5.87,255,1631577600"; 
   d="scan'208";a="157030638"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 22 Nov 2021 17:44:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id 7BA18816E2;
        Mon, 22 Nov 2021 17:44:22 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:44:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.57) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 22 Nov 2021 17:44:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        "Benjamin Herrenschmidt" <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RESEND v2 net-next 11/13] af_unix: Save hash in sk_hash.
Date:   Tue, 23 Nov 2021 02:41:12 +0900
Message-ID: <20211122174114.84594-12-kuniyu@amazon.co.jp>
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
index f1fb9b6fe009..7d28d0018727 100644
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
 
@@ -891,6 +892,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 
 	sock_init_data(sock, sk);
 
+	sk->sk_hash		= unix_unbound_hash(sk);
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
 	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
@@ -906,7 +908,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
-	unix_insert_socket(&unix_socket_table[unix_unbound_hash(sk)], sk);
+	unix_insert_unbound_socket(sk);
 
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
@@ -1050,6 +1052,7 @@ static int unix_autobind(struct sock *sk)
 	struct unix_address *addr;
 	unsigned int retries = 0;
 	static u32 ordernum = 1;
+	unsigned int new_hash;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1070,12 +1073,12 @@ static int unix_autobind(struct sock *sk)
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
@@ -1091,7 +1094,7 @@ static int unix_autobind(struct sock *sk)
 		goto retry;
 	}
 
-	__unix_set_addr(sk, addr, addr->hash);
+	__unix_set_addr_hash(sk, addr, new_hash);
 	spin_unlock(&unix_table_lock);
 	err = 0;
 
@@ -1106,9 +1109,9 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 	struct unix_sock *u = unix_sk(sk);
 	struct user_namespace *ns; // barf...
 	struct unix_address *addr;
+	unsigned int new_hash;
 	struct dentry *dentry;
 	struct path parent;
-	unsigned int hash;
 	int err;
 
 	unix_mkname_bsd(sunaddr, addr_len);
@@ -1143,12 +1146,11 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
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
@@ -1171,6 +1173,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
+	unsigned int new_hash;
 	int err;
 
 	addr = unix_create_addr(sunaddr, addr_len);
@@ -1186,13 +1189,13 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int
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

