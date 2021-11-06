Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD8446D32
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 10:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhKFJXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 05:23:09 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:52807 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhKFJXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 05:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1636190428; x=1667726428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SdELHoy/yjErjeXtlPBqZs/Z45TLeuKf7pCCTU99rWg=;
  b=TtLmG0LlbjmCqxylbXry/SEp3c90qGJ85k6XJt0GJRbQGMIjGXbvvGCe
   IzrlmZ93Pkm1AMBGL7haNCqfd7vRjpcZdVR4X1VaAc9BDUn2050LsdKZO
   JUn4Q1VYU/41zuO4wMJ80w/05+uqZC5sUmoSf0AawBjKLAwfPJhzozbmq
   g=;
X-IronPort-AV: E=Sophos;i="5.87,213,1631577600"; 
   d="scan'208";a="39563459"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 06 Nov 2021 09:20:27 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 831BB2629D9;
        Sat,  6 Nov 2021 09:20:26 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:20:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.153) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Sat, 6 Nov 2021 09:20:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 12/13] af_unix: Replace the big lock with small locks.
Date:   Sat, 6 Nov 2021 18:17:11 +0900
Message-ID: <20211106091712.15206-13-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211106091712.15206-1-kuniyu@amazon.co.jp>
References: <20211106091712.15206-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.153]
X-ClientProxiedBy: EX13D03UWA001.ant.amazon.com (10.43.160.141) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hash table of AF_UNIX sockets is protected by the single lock.  This
patch replaces it with per-hash locks.

The effect is noticeable when we handle multiple sockets simultaneously.
Here is a test result on an EC2 c5.24xlarge instance.  It shows latency
(under 10us only) in unix_insert_unbound_socket() while 64 CPUs creating
1024 sockets for each in parallel.

  Without this patch:

     nsec          : count     distribution
        0          : 179      |                                        |
        500        : 3021     |*********                               |
        1000       : 6271     |*******************                     |
        1500       : 6318     |*******************                     |
        2000       : 5828     |*****************                       |
        2500       : 5124     |***************                         |
        3000       : 4426     |*************                           |
        3500       : 3672     |***********                             |
        4000       : 3138     |*********                               |
        4500       : 2811     |********                                |
        5000       : 2384     |*******                                 |
        5500       : 2023     |******                                  |
        6000       : 1954     |*****                                   |
        6500       : 1737     |*****                                   |
        7000       : 1749     |*****                                   |
        7500       : 1520     |****                                    |
        8000       : 1469     |****                                    |
        8500       : 1394     |****                                    |
        9000       : 1232     |***                                     |
        9500       : 1138     |***                                     |
        10000      : 994      |***                                     |

  With this patch:

     nsec          : count     distribution
        0          : 1634     |****                                    |
        500        : 13170    |****************************************|
        1000       : 13156    |*************************************** |
        1500       : 9010     |***************************             |
        2000       : 6363     |*******************                     |
        2500       : 4443     |*************                           |
        3000       : 3240     |*********                               |
        3500       : 2549     |*******                                 |
        4000       : 1872     |*****                                   |
        4500       : 1504     |****                                    |
        5000       : 1247     |***                                     |
        5500       : 1035     |***                                     |
        6000       : 889      |**                                      |
        6500       : 744      |**                                      |
        7000       : 634      |*                                       |
        7500       : 498      |*                                       |
        8000       : 433      |*                                       |
        8500       : 355      |*                                       |
        9000       : 336      |*                                       |
        9500       : 284      |                                        |
        10000      : 243      |                                        |

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 include/net/af_unix.h |   2 +-
 net/unix/af_unix.c    | 100 ++++++++++++++++++++++++++----------------
 net/unix/diag.c       |  20 ++++-----
 3 files changed, 73 insertions(+), 49 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 89049cc6c066..a7ef624ed726 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -20,7 +20,7 @@ struct sock *unix_peer_get(struct sock *sk);
 #define UNIX_HASH_BITS	8
 
 extern unsigned int unix_tot_inflight;
-extern spinlock_t unix_table_lock;
+extern spinlock_t unix_table_locks[2 * UNIX_HASH_SIZE];
 extern struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
 
 struct unix_address {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index db04dda07c39..643f0358bf7a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -117,14 +117,14 @@
 
 #include "scm.h"
 
+spinlock_t unix_table_locks[2 * UNIX_HASH_SIZE];
+EXPORT_SYMBOL_GPL(unix_table_locks);
 struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
 EXPORT_SYMBOL_GPL(unix_socket_table);
-DEFINE_SPINLOCK(unix_table_lock);
-EXPORT_SYMBOL_GPL(unix_table_lock);
 static atomic_long_t unix_nr_socks;
 
 /* SMP locking strategy:
- *    hash table is protected with spinlock unix_table_lock
+ *    hash table is protected with spinlock unix_table_locks
  *    each socket state is protected by separate spin lock.
  */
 
@@ -156,6 +156,27 @@ static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
 	return hash & (UNIX_HASH_SIZE - 1);
 }
 
+static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
+{
+	/* hash1 and hash2 is never the same because
+	 * one is between 0 and UNIX_HASH_SIZE - 1, and
+	 * another is between UNIX_HASH_SIZE and UNIX_HASH_SIZE * 2.
+	 */
+	if (hash1 < hash2) {
+		spin_lock(&unix_table_locks[hash1]);
+		spin_lock(&unix_table_locks[hash2]);
+	} else {
+		spin_lock(&unix_table_locks[hash2]);
+		spin_lock(&unix_table_locks[hash1]);
+	}
+}
+
+static void unix_table_double_unlock(unsigned int hash1, unsigned int hash2)
+{
+	spin_unlock(&unix_table_locks[hash1]);
+	spin_unlock(&unix_table_locks[hash2]);
+}
+
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
@@ -295,16 +316,16 @@ static void __unix_set_addr_hash(struct sock *sk, struct unix_address *addr,
 
 static void unix_remove_socket(struct sock *sk)
 {
-	spin_lock(&unix_table_lock);
+	spin_lock(&unix_table_locks[sk->sk_hash]);
 	__unix_remove_socket(sk);
-	spin_unlock(&unix_table_lock);
+	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static void unix_insert_unbound_socket(struct sock *sk)
 {
-	spin_lock(&unix_table_lock);
+	spin_lock(&unix_table_locks[sk->sk_hash]);
 	__unix_insert_socket(sk);
-	spin_unlock(&unix_table_lock);
+	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static struct sock *__unix_find_socket_byname(struct net *net,
@@ -332,11 +353,11 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 {
 	struct sock *s;
 
-	spin_lock(&unix_table_lock);
+	spin_lock(&unix_table_locks[hash]);
 	s = __unix_find_socket_byname(net, sunname, len, hash);
 	if (s)
 		sock_hold(s);
-	spin_unlock(&unix_table_lock);
+	spin_unlock(&unix_table_locks[hash]);
 	return s;
 }
 
@@ -345,19 +366,18 @@ static struct sock *unix_find_socket_byinode(struct inode *i)
 	unsigned int hash = unix_bsd_hash(i);
 	struct sock *s;
 
-	spin_lock(&unix_table_lock);
+	spin_lock(&unix_table_locks[hash]);
 	sk_for_each(s, &unix_socket_table[hash]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
 
 		if (dentry && d_backing_inode(dentry) == i) {
 			sock_hold(s);
-			goto found;
+			spin_unlock(&unix_table_locks[hash]);
+			return s;
 		}
 	}
-	s = NULL;
-found:
-	spin_unlock(&unix_table_lock);
-	return s;
+	spin_unlock(&unix_table_locks[hash]);
+	return NULL;
 }
 
 /* Support code for asymmetrically connected dgram sockets
@@ -1052,11 +1072,11 @@ static struct sock *unix_find_other(struct net *net, struct sockaddr_un *sunaddr
 
 static int unix_autobind(struct sock *sk)
 {
+	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
 	unsigned int retries = 0;
 	static u32 ordernum = 1;
-	unsigned int new_hash;
 	int err;
 
 	err = mutex_lock_interruptible(&u->bindlock);
@@ -1079,11 +1099,12 @@ static int unix_autobind(struct sock *sk)
 		offsetof(struct sockaddr_un, sun_path) + 1;
 
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
-	spin_lock(&unix_table_lock);
+	unix_table_double_lock(old_hash, new_hash);
 	ordernum = (ordernum+1)&0xFFFFF;
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, new_hash)) {
-		spin_unlock(&unix_table_lock);
+		unix_table_double_unlock(old_hash, new_hash);
+
 		/*
 		 * __unix_find_socket_byname() may take long time if many names
 		 * are already in use.
@@ -1099,7 +1120,7 @@ static int unix_autobind(struct sock *sk)
 	}
 
 	__unix_set_addr_hash(sk, addr, new_hash);
-	spin_unlock(&unix_table_lock);
+	unix_table_double_unlock(old_hash, new_hash);
 	err = 0;
 
 out:	mutex_unlock(&u->bindlock);
@@ -1110,10 +1131,10 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 {
 	umode_t mode = S_IFSOCK |
 	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
+	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
 	struct user_namespace *ns; // barf...
 	struct unix_address *addr;
-	unsigned int new_hash;
 	struct dentry *dentry;
 	struct path parent;
 	int err;
@@ -1151,11 +1172,11 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 		goto out_unlock;
 
 	new_hash = unix_bsd_hash(d_backing_inode(dentry));
-	spin_lock(&unix_table_lock);
+	unix_table_double_lock(old_hash, new_hash);
 	u->path.mnt = mntget(parent.mnt);
 	u->path.dentry = dget(dentry);
 	__unix_set_addr_hash(sk, addr, new_hash);
-	spin_unlock(&unix_table_lock);
+	unix_table_double_unlock(old_hash, new_hash);
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
 	return 0;
@@ -1175,9 +1196,9 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr, int addr_
 
 static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int addr_len)
 {
+	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
 	struct unix_address *addr;
-	unsigned int new_hash;
 	int err;
 
 	addr = unix_create_addr(sunaddr, addr_len);
@@ -1194,18 +1215,18 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr, int
 	}
 
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
-	spin_lock(&unix_table_lock);
+	unix_table_double_lock(old_hash, new_hash);
 
 	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len, new_hash))
 		goto out_spin;
 
 	__unix_set_addr_hash(sk, addr, new_hash);
-	spin_unlock(&unix_table_lock);
+	unix_table_double_unlock(old_hash, new_hash);
 	mutex_unlock(&u->bindlock);
 	return 0;
 
 out_spin:
-	spin_unlock(&unix_table_lock);
+	unix_table_double_unlock(old_hash, new_hash);
 	err = -EADDRINUSE;
 out_mutex:
 	mutex_unlock(&u->bindlock);
@@ -1511,9 +1532,9 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	 *
 	 * The contents of *(otheru->addr) and otheru->path
 	 * are seen fully set up here, since we have found
-	 * otheru in hash under unix_table_lock.  Insertion
+	 * otheru in hash under unix_table_locks.  Insertion
 	 * into the hash chain we'd found it in had been done
-	 * in an earlier critical area protected by unix_table_lock,
+	 * in an earlier critical area protected by unix_table_locks,
 	 * the same one where we'd set *(otheru->addr) contents,
 	 * as well as otheru->path and otheru->addr itself.
 	 *
@@ -3192,7 +3213,7 @@ static __poll_t unix_dgram_poll(struct file *file, struct socket *sock,
 #define BUCKET_SPACE (BITS_PER_LONG - (UNIX_HASH_BITS + 1) - 1)
 
 #define get_bucket(x) ((x) >> BUCKET_SPACE)
-#define get_offset(x) ((x) & ((1L << BUCKET_SPACE) - 1))
+#define get_offset(x) ((x) & ((1UL << BUCKET_SPACE) - 1))
 #define set_bucket_offset(b, o) ((b) << BUCKET_SPACE | (o))
 
 static struct sock *unix_from_bucket(struct seq_file *seq, loff_t *pos)
@@ -3216,7 +3237,7 @@ static struct sock *unix_next_socket(struct seq_file *seq,
 				     struct sock *sk,
 				     loff_t *pos)
 {
-	unsigned long bucket;
+	unsigned long bucket = get_bucket(*pos);
 
 	while (sk > (struct sock *)SEQ_START_TOKEN) {
 		sk = sk_next(sk);
@@ -3227,12 +3248,13 @@ static struct sock *unix_next_socket(struct seq_file *seq,
 	}
 
 	do {
+		spin_lock(&unix_table_locks[bucket]);
 		sk = unix_from_bucket(seq, pos);
 		if (sk)
 			return sk;
 
 next_bucket:
-		bucket = get_bucket(*pos) + 1;
+		spin_unlock(&unix_table_locks[bucket++]);
 		*pos = set_bucket_offset(bucket, 1);
 	} while (bucket < ARRAY_SIZE(unix_socket_table));
 
@@ -3240,10 +3262,7 @@ static struct sock *unix_next_socket(struct seq_file *seq,
 }
 
 static void *unix_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(unix_table_lock)
 {
-	spin_lock(&unix_table_lock);
-
 	if (!*pos)
 		return SEQ_START_TOKEN;
 
@@ -3260,9 +3279,11 @@ static void *unix_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void unix_seq_stop(struct seq_file *seq, void *v)
-	__releases(unix_table_lock)
 {
-	spin_unlock(&unix_table_lock);
+	struct sock *sk = v;
+
+	if (sk)
+		spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static int unix_seq_show(struct seq_file *seq, void *v)
@@ -3287,7 +3308,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 			(s->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
 			sock_i_ino(s));
 
-		if (u->addr) {	// under unix_table_lock here
+		if (u->addr) {	// under unix_table_locks here
 			int i, len;
 			seq_putc(seq, ' ');
 
@@ -3445,10 +3466,13 @@ static void __init bpf_iter_register(void)
 
 static int __init af_unix_init(void)
 {
-	int rc = -1;
+	int i, rc = -1;
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
+	for (i = 0; i < 2 * UNIX_HASH_SIZE; i++)
+		spin_lock_init(&unix_table_locks[i]);
+
 	rc = proto_register(&unix_dgram_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index db555f267407..bb0b5ea1655f 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -13,7 +13,7 @@
 
 static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
 {
-	/* might or might not have unix_table_lock */
+	/* might or might not have unix_table_locks */
 	struct unix_address *addr = smp_load_acquire(&unix_sk(sk)->addr);
 
 	if (!addr)
@@ -204,13 +204,13 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	s_slot = cb->args[0];
 	num = s_num = cb->args[1];
 
-	spin_lock(&unix_table_lock);
 	for (slot = s_slot;
 	     slot < ARRAY_SIZE(unix_socket_table);
 	     s_num = 0, slot++) {
 		struct sock *sk;
 
 		num = 0;
+		spin_lock(&unix_table_locks[slot]);
 		sk_for_each(sk, &unix_socket_table[slot]) {
 			if (!net_eq(sock_net(sk), net))
 				continue;
@@ -221,14 +221,16 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			if (sk_diag_dump(sk, skb, req,
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq,
-					 NLM_F_MULTI) < 0)
+					 NLM_F_MULTI) < 0) {
+				spin_unlock(&unix_table_locks[slot]);
 				goto done;
+			}
 next:
 			num++;
 		}
+		spin_unlock(&unix_table_locks[slot]);
 	}
 done:
-	spin_unlock(&unix_table_lock);
 	cb->args[0] = slot;
 	cb->args[1] = num;
 
@@ -237,21 +239,19 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 static struct sock *unix_lookup_by_ino(unsigned int ino)
 {
-	int i;
 	struct sock *sk;
+	int i;
 
-	spin_lock(&unix_table_lock);
 	for (i = 0; i < ARRAY_SIZE(unix_socket_table); i++) {
+		spin_lock(&unix_table_locks[i]);
 		sk_for_each(sk, &unix_socket_table[i])
 			if (ino == sock_i_ino(sk)) {
 				sock_hold(sk);
-				spin_unlock(&unix_table_lock);
-
+				spin_unlock(&unix_table_locks[i]);
 				return sk;
 			}
+		spin_unlock(&unix_table_locks[i]);
 	}
-
-	spin_unlock(&unix_table_lock);
 	return NULL;
 }
 
-- 
2.30.2

