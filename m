Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039455538C9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 19:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352055AbiFURVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 13:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbiFURVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 13:21:13 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD842CCB3
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 10:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655832072; x=1687368072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oa49YFCUxp/94f843wfevOLB664MOQ7HZKtvwlQwpko=;
  b=qqHqSEQMFm9cfIGAxJRpQl8BWIUwZUSY/Y5EmEmKI5jdAgbDoPWPsIOu
   kbfEnfH7kSDcMTS5CH5IxD0BJqg4Cu/NN6OMr5lqL5i5T9TEjdudQ/AC0
   1h5ABU52WA0mXqWQjw93UK91OKZD7mhphil0FeCnv+mzun0rP3zqUu/1g
   E=;
X-IronPort-AV: E=Sophos;i="5.92,209,1650931200"; 
   d="scan'208";a="1026763947"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 21 Jun 2022 17:20:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-fc41acad.us-east-1.amazon.com (Postfix) with ESMTPS id 392A0C0948;
        Tue, 21 Jun 2022 17:20:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:20:51 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.29) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 21 Jun 2022 17:20:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 net-next 5/6] af_unix: Put a socket into a per-netns hash table.
Date:   Tue, 21 Jun 2022 10:19:12 -0700
Message-ID: <20220621171913.73401-6-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaces the global hash table with a per-netns one and removes
the global one.

We now link a socket in each netns's hash table so we can save some netns
comparisons when iterating through a hash bucket.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/af_unix.h |  1 -
 net/unix/af_unix.c    | 50 +++++++++++++++++--------------------------
 net/unix/diag.c       |  9 +++-----
 3 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index acb56e463db1..b1748c9b6db2 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -22,7 +22,6 @@ struct sock *unix_peer_get(struct sock *sk);
 
 extern unsigned int unix_tot_inflight;
 extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
-extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
 
 struct unix_address {
 	refcount_t	refcnt;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 79f8fc5cdce8..9d0b07235dbc 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -120,8 +120,6 @@
 
 spinlock_t unix_table_locks[UNIX_HASH_SIZE];
 EXPORT_SYMBOL_GPL(unix_table_locks);
-struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
-EXPORT_SYMBOL_GPL(unix_socket_table);
 static atomic_long_t unix_nr_socks;
 
 /* SMP locking strategy:
@@ -308,20 +306,20 @@ static void __unix_remove_socket(struct sock *sk)
 	sk_del_node_init(sk);
 }
 
-static void __unix_insert_socket(struct sock *sk)
+static void __unix_insert_socket(struct net *net, struct sock *sk)
 {
 	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
-	sk_add_node(sk, &unix_socket_table[sk->sk_hash]);
+	sk_add_node(sk, &net->unx.table.buckets[sk->sk_hash]);
 }
 
-static void __unix_set_addr_hash(struct sock *sk, struct unix_address *addr,
-				 unsigned int hash)
+static void __unix_set_addr_hash(struct net *net, struct sock *sk,
+				 struct unix_address *addr, unsigned int hash)
 {
 	__unix_remove_socket(sk);
 	smp_store_release(&unix_sk(sk)->addr, addr);
 
 	sk->sk_hash = hash;
-	__unix_insert_socket(sk);
+	__unix_insert_socket(net, sk);
 }
 
 static void unix_remove_socket(struct net *net, struct sock *sk)
@@ -337,7 +335,7 @@ static void unix_insert_unbound_socket(struct net *net, struct sock *sk)
 {
 	spin_lock(&unix_table_locks[sk->sk_hash]);
 	spin_lock(&net->unx.table.locks[sk->sk_hash]);
-	__unix_insert_socket(sk);
+	__unix_insert_socket(net, sk);
 	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
 	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
@@ -348,12 +346,9 @@ static struct sock *__unix_find_socket_byname(struct net *net,
 {
 	struct sock *s;
 
-	sk_for_each(s, &unix_socket_table[hash]) {
+	sk_for_each(s, &net->unx.table.buckets[hash]) {
 		struct unix_sock *u = unix_sk(s);
 
-		if (!net_eq(sock_net(s), net))
-			continue;
-
 		if (u->addr->len == len &&
 		    !memcmp(u->addr->name, sunname, len))
 			return s;
@@ -384,7 +379,7 @@ static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
 
 	spin_lock(&unix_table_locks[hash]);
 	spin_lock(&net->unx.table.locks[hash]);
-	sk_for_each(s, &unix_socket_table[hash]) {
+	sk_for_each(s, &net->unx.table.buckets[hash]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
 
 		if (dentry && d_backing_inode(dentry) == i) {
@@ -1140,7 +1135,7 @@ static int unix_autobind(struct sock *sk)
 		goto retry;
 	}
 
-	__unix_set_addr_hash(sk, addr, new_hash);
+	__unix_set_addr_hash(net, sk, addr, new_hash);
 	unix_table_double_unlock(net, old_hash, new_hash);
 	err = 0;
 
@@ -1199,7 +1194,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 	unix_table_double_lock(net, old_hash, new_hash);
 	u->path.mnt = mntget(parent.mnt);
 	u->path.dentry = dget(dentry);
-	__unix_set_addr_hash(sk, addr, new_hash);
+	__unix_set_addr_hash(net, sk, addr, new_hash);
 	unix_table_double_unlock(net, old_hash, new_hash);
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
@@ -1246,7 +1241,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 	if (__unix_find_socket_byname(net, addr->name, addr->len, new_hash))
 		goto out_spin;
 
-	__unix_set_addr_hash(sk, addr, new_hash);
+	__unix_set_addr_hash(net, sk, addr, new_hash);
 	unix_table_double_unlock(net, old_hash, new_hash);
 	mutex_unlock(&u->bindlock);
 	return 0;
@@ -3239,12 +3234,11 @@ static struct sock *unix_from_bucket(struct seq_file *seq, loff_t *pos)
 {
 	unsigned long offset = get_offset(*pos);
 	unsigned long bucket = get_bucket(*pos);
-	struct sock *sk;
 	unsigned long count = 0;
+	struct sock *sk;
 
-	for (sk = sk_head(&unix_socket_table[bucket]); sk; sk = sk_next(sk)) {
-		if (sock_net(sk) != seq_file_net(seq))
-			continue;
+	for (sk = sk_head(&seq_file_net(seq)->unx.table.buckets[bucket]);
+	     sk; sk = sk_next(sk)) {
 		if (++count == offset)
 			break;
 	}
@@ -3279,13 +3273,13 @@ static struct sock *unix_get_next(struct seq_file *seq, struct sock *sk,
 				  loff_t *pos)
 {
 	unsigned long bucket = get_bucket(*pos);
-	struct net *net = seq_file_net(seq);
 
-	for (sk = sk_next(sk); sk; sk = sk_next(sk))
-		if (sock_net(sk) == net)
-			return sk;
+	sk = sk_next(sk);
+	if (sk)
+		return sk;
+
 
-	spin_unlock(&net->unx.table.locks[bucket]);
+	spin_unlock(&seq_file_net(seq)->unx.table.locks[bucket]);
 	spin_unlock(&unix_table_locks[bucket]);
 
 	*pos = set_bucket_offset(++bucket, 1);
@@ -3406,7 +3400,6 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 
 {
 	struct bpf_unix_iter_state *iter = seq->private;
-	struct net *net = seq_file_net(seq);
 	unsigned int expected = 1;
 	struct sock *sk;
 
@@ -3414,9 +3407,6 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 	iter->batch[iter->end_sk++] = start_sk;
 
 	for (sk = sk_next(start_sk); sk; sk = sk_next(sk)) {
-		if (sock_net(sk) != net)
-			continue;
-
 		if (iter->end_sk < iter->max_sk) {
 			sock_hold(sk);
 			iter->batch[iter->end_sk++] = sk;
@@ -3425,7 +3415,7 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 		expected++;
 	}
 
-	spin_unlock(&net->unx.table.locks[start_sk->sk_hash]);
+	spin_unlock(&seq_file_net(seq)->unx.table.locks[start_sk->sk_hash]);
 	spin_unlock(&unix_table_locks[start_sk->sk_hash]);
 
 	return expected;
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 7fc377435114..4d0f0ca6a1eb 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -210,9 +210,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		num = 0;
 		spin_lock(&unix_table_locks[slot]);
 		spin_lock(&net->unx.table.locks[slot]);
-		sk_for_each(sk, &unix_socket_table[slot]) {
-			if (!net_eq(sock_net(sk), net))
-				continue;
+		sk_for_each(sk, &net->unx.table.buckets[slot]) {
 			if (num < s_num)
 				goto next;
 			if (!(req->udiag_states & (1 << sk->sk_state)))
@@ -246,13 +244,14 @@ static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
 	for (i = 0; i < UNIX_HASH_SIZE; i++) {
 		spin_lock(&unix_table_locks[i]);
 		spin_lock(&net->unx.table.locks[i]);
-		sk_for_each(sk, &unix_socket_table[i])
+		sk_for_each(sk, &net->unx.table.buckets[i]) {
 			if (ino == sock_i_ino(sk)) {
 				sock_hold(sk);
 				spin_unlock(&net->unx.table.locks[i]);
 				spin_unlock(&unix_table_locks[i]);
 				return sk;
 			}
+		}
 		spin_unlock(&net->unx.table.locks[i]);
 		spin_unlock(&unix_table_locks[i]);
 	}
@@ -277,8 +276,6 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 	err = -ENOENT;
 	if (sk == NULL)
 		goto out_nosk;
-	if (!net_eq(sock_net(sk), net))
-		goto out;
 
 	err = sock_diag_check_cookie(sk, req->udiag_cookie);
 	if (err)
-- 
2.30.2

