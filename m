Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C7B5538CA
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbiFURV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiFURV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:21:28 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D25A28E35
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655832087; x=1687368087;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X5Zn+oLHKWXDOWK3e7QXD6lVC5FOgx2F3ic6L0fWEqA=;
  b=p6IgCZ9wo/NQJlFXEjIB/eytjG2IZBAACw/lTUWYqQ8BZ2tSo6LsvN3R
   Zfe66TL8nRTRQZ1/4xQrRM7+5zzOa6mZaqt7n4lb0HbaTnZd7fVHvglDi
   sp8DbJKK6W57kyddoEEoBnwcnlIr1zgzRorxIJyXdKTWZLz+ZaW686Y+t
   8=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 21 Jun 2022 17:21:16 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-54c9d11f.us-east-1.amazon.com (Postfix) with ESMTPS id 3EAD3C099A;
        Tue, 21 Jun 2022 17:21:14 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:21:11 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.29) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:21:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 6/6] af_unix: Remove unix_table_locks.
Date:   Tue, 21 Jun 2022 10:19:13 -0700
Message-ID: <20220621171913.73401-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621171913.73401-1-kuniyu@amazon.com>
References: <20220621171913.73401-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.29]
X-ClientProxiedBy: EX13D12UWC002.ant.amazon.com (10.43.162.253) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unix_table_locks are to protect the global hash table, unix_socket_table.
The previous commit removed it, so let's clean up the unnecessary locks.

Here is a test result on EC2 c5.9xlarge where 10 processes run concurrently
in different netns and bind 100,000 sockets for each.

  without this series : 1m 38s
  with this series    :    11s

It is ~10x faster because the global hash table is split into 10 netns in
this case.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/af_unix.h |  1 -
 net/unix/af_unix.c    | 42 ++++++++----------------------------------
 net/unix/diag.c       |  8 +-------
 3 files changed, 9 insertions(+), 42 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index b1748c9b6db2..480fa579787e 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -21,7 +21,6 @@ struct sock *unix_peer_get(struct sock *sk);
 #define UNIX_HASH_BITS	8
 
 extern unsigned int unix_tot_inflight;
-extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
 
 struct unix_address {
 	refcount_t	refcnt;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 9d0b07235dbc..49f6626330c3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -118,13 +118,11 @@
 
 #include "scm.h"
 
-spinlock_t unix_table_locks[UNIX_HASH_SIZE];
-EXPORT_SYMBOL_GPL(unix_table_locks);
 static atomic_long_t unix_nr_socks;
 
 /* SMP locking strategy:
- *    hash table is protected with spinlock unix_table_locks
- *    each socket state is protected by separate spin lock.
+ *    hash table is protected with spinlock.
+ *    each socket state is protected by separate spinlock.
  */
 
 static unsigned int unix_unbound_hash(struct sock *sk)
@@ -166,9 +164,6 @@ static void unix_table_double_lock(struct net *net,
 	if (hash1 > hash2)
 		swap(hash1, hash2);
 
-	spin_lock(&unix_table_locks[hash1]);
-	spin_lock_nested(&unix_table_locks[hash2], SINGLE_DEPTH_NESTING);
-
 	spin_lock(&net->unx.table.locks[hash1]);
 	spin_lock_nested(&net->unx.table.locks[hash2], SINGLE_DEPTH_NESTING);
 }
@@ -178,9 +173,6 @@ static void unix_table_double_unlock(struct net *net,
 {
 	spin_unlock(&net->unx.table.locks[hash1]);
 	spin_unlock(&net->unx.table.locks[hash2]);
-
-	spin_unlock(&unix_table_locks[hash1]);
-	spin_unlock(&unix_table_locks[hash2]);
 }
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -324,20 +316,16 @@ static void __unix_set_addr_hash(struct net *net, struct sock *sk,
 
 static void unix_remove_socket(struct net *net, struct sock *sk)
 {
-	spin_lock(&unix_table_locks[sk->sk_hash]);
 	spin_lock(&net->unx.table.locks[sk->sk_hash]);
 	__unix_remove_socket(sk);
 	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
-	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static void unix_insert_unbound_socket(struct net *net, struct sock *sk)
 {
-	spin_lock(&unix_table_locks[sk->sk_hash]);
 	spin_lock(&net->unx.table.locks[sk->sk_hash]);
 	__unix_insert_socket(net, sk);
 	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
-	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static struct sock *__unix_find_socket_byname(struct net *net,
@@ -362,13 +350,11 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 {
 	struct sock *s;
 
-	spin_lock(&unix_table_locks[hash]);
 	spin_lock(&net->unx.table.locks[hash]);
 	s = __unix_find_socket_byname(net, sunname, len, hash);
 	if (s)
 		sock_hold(s);
 	spin_unlock(&net->unx.table.locks[hash]);
-	spin_unlock(&unix_table_locks[hash]);
 	return s;
 }
 
@@ -377,7 +363,6 @@ static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
 	unsigned int hash = unix_bsd_hash(i);
 	struct sock *s;
 
-	spin_lock(&unix_table_locks[hash]);
 	spin_lock(&net->unx.table.locks[hash]);
 	sk_for_each(s, &net->unx.table.buckets[hash]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
@@ -385,12 +370,10 @@ static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
 		if (dentry && d_backing_inode(dentry) == i) {
 			sock_hold(s);
 			spin_unlock(&net->unx.table.locks[hash]);
-			spin_unlock(&unix_table_locks[hash]);
 			return s;
 		}
 	}
 	spin_unlock(&net->unx.table.locks[hash]);
-	spin_unlock(&unix_table_locks[hash]);
 	return NULL;
 }
 
@@ -1551,9 +1534,9 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	 *
 	 * The contents of *(otheru->addr) and otheru->path
 	 * are seen fully set up here, since we have found
-	 * otheru in hash under unix_table_locks.  Insertion
-	 * into the hash chain we'd found it in had been done
-	 * in an earlier critical area protected by unix_table_locks,
+	 * otheru in hash under its lock.  Insertion into the
+	 * hash chain we'd found it in had been done in an
+	 * earlier critical area protected by the chain's lock,
 	 * the same one where we'd set *(otheru->addr) contents,
 	 * as well as otheru->path and otheru->addr itself.
 	 *
@@ -3253,7 +3236,6 @@ static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 	struct sock *sk;
 
 	while (bucket < UNIX_HASH_SIZE) {
-		spin_lock(&unix_table_locks[bucket]);
 		spin_lock(&net->unx.table.locks[bucket]);
 
 		sk = unix_from_bucket(seq, pos);
@@ -3261,7 +3243,6 @@ static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 			return sk;
 
 		spin_unlock(&net->unx.table.locks[bucket]);
-		spin_unlock(&unix_table_locks[bucket]);
 
 		*pos = set_bucket_offset(++bucket, 1);
 	}
@@ -3280,7 +3261,6 @@ static struct sock *unix_get_next(struct seq_file *seq, struct sock *sk,
 
 
 	spin_unlock(&seq_file_net(seq)->unx.table.locks[bucket]);
-	spin_unlock(&unix_table_locks[bucket]);
 
 	*pos = set_bucket_offset(++bucket, 1);
 
@@ -3309,10 +3289,8 @@ static void unix_seq_stop(struct seq_file *seq, void *v)
 {
 	struct sock *sk = v;
 
-	if (sk) {
+	if (sk)
 		spin_unlock(&seq_file_net(seq)->unx.table.locks[sk->sk_hash]);
-		spin_unlock(&unix_table_locks[sk->sk_hash]);
-	}
 }
 
 static int unix_seq_show(struct seq_file *seq, void *v)
@@ -3337,7 +3315,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 			(s->sk_state == TCP_ESTABLISHED ? SS_CONNECTING : SS_DISCONNECTING),
 			sock_i_ino(s));
 
-		if (u->addr) {	// under unix_table_locks here
+		if (u->addr) {	// under a hash table lock here
 			int i, len;
 			seq_putc(seq, ' ');
 
@@ -3416,7 +3394,6 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 	}
 
 	spin_unlock(&seq_file_net(seq)->unx.table.locks[start_sk->sk_hash]);
-	spin_unlock(&unix_table_locks[start_sk->sk_hash]);
 
 	return expected;
 }
@@ -3705,13 +3682,10 @@ static void __init bpf_iter_register(void)
 
 static int __init af_unix_init(void)
 {
-	int i, rc = -1;
+	int rc = -1;
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
-	for (i = 0; i < UNIX_HASH_SIZE; i++)
-		spin_lock_init(&unix_table_locks[i]);
-
 	rc = proto_register(&unix_dgram_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 4d0f0ca6a1eb..105f522a89fe 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -13,7 +13,7 @@
 
 static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
 {
-	/* might or might not have unix_table_locks */
+	/* might or might not have a hash table lock */
 	struct unix_address *addr = smp_load_acquire(&unix_sk(sk)->addr);
 
 	if (!addr)
@@ -208,7 +208,6 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		struct sock *sk;
 
 		num = 0;
-		spin_lock(&unix_table_locks[slot]);
 		spin_lock(&net->unx.table.locks[slot]);
 		sk_for_each(sk, &net->unx.table.buckets[slot]) {
 			if (num < s_num)
@@ -220,14 +219,12 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 					 cb->nlh->nlmsg_seq,
 					 NLM_F_MULTI) < 0) {
 				spin_unlock(&net->unx.table.locks[slot]);
-				spin_unlock(&unix_table_locks[slot]);
 				goto done;
 			}
 next:
 			num++;
 		}
 		spin_unlock(&net->unx.table.locks[slot]);
-		spin_unlock(&unix_table_locks[slot]);
 	}
 done:
 	cb->args[0] = slot;
@@ -242,18 +239,15 @@ static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
 	int i;
 
 	for (i = 0; i < UNIX_HASH_SIZE; i++) {
-		spin_lock(&unix_table_locks[i]);
 		spin_lock(&net->unx.table.locks[i]);
 		sk_for_each(sk, &net->unx.table.buckets[i]) {
 			if (ino == sock_i_ino(sk)) {
 				sock_hold(sk);
 				spin_unlock(&net->unx.table.locks[i]);
-				spin_unlock(&unix_table_locks[i]);
 				return sk;
 			}
 		}
 		spin_unlock(&net->unx.table.locks[i]);
-		spin_unlock(&unix_table_locks[i]);
 	}
 	return NULL;
 }
-- 
2.30.2

