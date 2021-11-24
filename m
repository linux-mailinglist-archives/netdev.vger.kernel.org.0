Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1F45B1FA
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 03:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbhKXCUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 21:20:46 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:59877 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240711AbhKXCUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 21:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1637720257; x=1669256257;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qNud6mR7iSvVN/tQmE49WsFEIV+kt4nc/YIGDQX7jiU=;
  b=nPAD4ElvaWcQCwaJCB4Oqih7fUQYTYVWHVoX3zCOGuXif1HUZVhHG9KW
   kqhdwXiAy2S2Tp05+knOgk6S9DMOFwrSCTgIM7gVD8NonsPpEcrvusxbC
   xCZvn7k4QZFJC8MA+FeIS5zaACtdQosFu+uwEPPoE7YdqOlvNS8AHvaHg
   A=;
X-IronPort-AV: E=Sophos;i="5.87,258,1631577600"; 
   d="scan'208";a="43798662"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 24 Nov 2021 02:17:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-1f9d5b26.us-west-2.amazon.com (Postfix) with ESMTPS id D4AA041EA9;
        Wed, 24 Nov 2021 02:17:36 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:17:36 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.102) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Wed, 24 Nov 2021 02:17:32 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 11/13] af_unix: Save hash in sk_hash.
Date:   Wed, 24 Nov 2021 11:14:29 +0900
Message-ID: <20211124021431.48956-12-kuniyu@amazon.co.jp>
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
 net/unix/af_unix.c    | 42 +++++++++++++++++++++++-------------------
 2 files changed, 23 insertions(+), 20 deletions(-)

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
index a6956c68d032..b82e01f39f77 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -280,31 +280,33 @@ static void __unix_remove_socket(struct sock *sk)
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
 	smp_store_release(&unix_sk(sk)->addr, addr);
-	__unix_insert_socket(&unix_socket_table[hash], sk);
+
+	sk->sk_hash = hash;
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
 
@@ -893,6 +895,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 
 	sock_init_data(sock, sk);
 
+	sk->sk_hash		= unix_unbound_hash(sk);
 	sk->sk_allocation	= GFP_KERNEL_ACCOUNT;
 	sk->sk_write_space	= unix_write_space;
 	sk->sk_max_ack_backlog	= net->unx.sysctl_max_dgram_qlen;
@@ -908,7 +911,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
-	unix_insert_socket(&unix_socket_table[unix_unbound_hash(sk)], sk);
+	unix_insert_unbound_socket(sk);
 
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
@@ -1054,6 +1057,7 @@ static int unix_autobind(struct sock *sk)
 	struct unix_address *addr;
 	unsigned int retries = 0;
 	static u32 ordernum = 1;
+	unsigned int new_hash;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1075,13 +1079,13 @@ static int unix_autobind(struct sock *sk)
 retry:
 	addr->len = sprintf(addr->name->sun_path + 1, "%05x", ordernum) +
 		offsetof(struct sockaddr_un, sun_path) + 1;
-	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 
+	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	spin_lock(&unix_table_lock);
 	ordernum = (ordernum+1)&0xFFFFF;
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-				      addr->hash)) {
+				      new_hash)) {
 		spin_unlock(&unix_table_lock);
 		/*
 		 * __unix_find_socket_byname() may take long time if many names
@@ -1097,7 +1101,7 @@ static int unix_autobind(struct sock *sk)
 		goto retry;
 	}
 
-	__unix_set_addr(sk, addr, addr->hash);
+	__unix_set_addr_hash(sk, addr, new_hash);
 	spin_unlock(&unix_table_lock);
 	err = 0;
 
@@ -1113,9 +1117,9 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 	struct unix_sock *u = unix_sk(sk);
 	struct user_namespace *ns; // barf...
 	struct unix_address *addr;
+	unsigned int new_hash;
 	struct dentry *dentry;
 	struct path parent;
-	unsigned int hash;
 	int err;
 
 	unix_mkname_bsd(sunaddr, addr_len);
@@ -1151,12 +1155,11 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
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
@@ -1180,6 +1183,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
+	unsigned int new_hash;
 	int err;
 
 	addr = unix_create_addr(sunaddr, addr_len);
@@ -1195,14 +1199,14 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 		goto out_mutex;
 	}
 
-	addr->hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
+	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
 	spin_lock(&unix_table_lock);
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-				      addr->hash))
+				      new_hash))
 		goto out_spin;
 
-	__unix_set_addr(sk, addr, addr->hash);
+	__unix_set_addr_hash(sk, addr, new_hash);
 	spin_unlock(&unix_table_lock);
 	mutex_unlock(&u->bindlock);
 	return 0;
-- 
2.30.2

