Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0754EE0D
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 01:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379454AbiFPXtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 19:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379468AbiFPXti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 19:49:38 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D84762CD0
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655423376; x=1686959376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pGYUm8n/Oo201e7QE/TBtSMH3sBIH7QeS8u05Gl0RzQ=;
  b=XMdE2nCu2Gexw75wFpg+Sh1WDjbTzQ53h5gFhRD4pANaqFjtxF/WFcLF
   liHULgGn8ZRfr9kxF4XiB3YI8lQIUEOR2HDYCcdx04M3rGMAHAzhk3Qm0
   cm3t2Kp6pTwQXHEJG8WUccdoFC9WKuBnCyJfuPiZAWF/LplMuIP7gZ7DI
   o=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="211925959"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 16 Jun 2022 23:49:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com (Postfix) with ESMTPS id 6A547CB8A5;
        Thu, 16 Jun 2022 23:49:23 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:49:22 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.26) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:49:20 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 6/6] af_unix: Remove unix_table_locks.
Date:   Thu, 16 Jun 2022 16:47:14 -0700
Message-ID: <20220616234714.4291-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616234714.4291-1-kuniyu@amazon.com>
References: <20220616234714.4291-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.26]
X-ClientProxiedBy: EX13d09UWC004.ant.amazon.com (10.43.162.114) To
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
 net/unix/af_unix.c    | 28 +---------------------------
 net/unix/diag.c       |  6 ------
 3 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index cee4f2fca444..9cb84d9bde4c 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -21,7 +21,6 @@ struct sock *unix_peer_get(struct sock *sk);
 #define UNIX_HASH_BITS	8
 
 extern unsigned int unix_tot_inflight;
-extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
 
 struct unix_hashbucket {
 	spinlock_t		lock;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a93915066cb6..469ff9c947a9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -118,8 +118,6 @@
 
 #include "scm.h"
 
-spinlock_t unix_table_locks[UNIX_HASH_SIZE];
-EXPORT_SYMBOL_GPL(unix_table_locks);
 static atomic_long_t unix_nr_socks;
 
 /* SMP locking strategy:
@@ -166,9 +164,6 @@ static void unix_table_double_lock(struct net *net,
 	if (hash1 > hash2)
 		swap(hash1, hash2);
 
-	spin_lock(&unix_table_locks[hash1]);
-	spin_lock_nested(&unix_table_locks[hash2], SINGLE_DEPTH_NESTING);
-
 	spin_lock(&net->unx.hash[hash1].lock);
 	spin_lock(&net->unx.hash[hash2].lock);
 }
@@ -178,9 +173,6 @@ static void unix_table_double_unlock(struct net *net,
 {
 	spin_unlock(&net->unx.hash[hash1].lock);
 	spin_unlock(&net->unx.hash[hash2].lock);
-
-	spin_unlock(&unix_table_locks[hash1]);
-	spin_unlock(&unix_table_locks[hash2]);
 }
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -324,20 +316,16 @@ static void __unix_set_addr_hash(struct net *net, struct sock *sk,
 
 static void unix_remove_socket(struct net *net, struct sock *sk)
 {
-	spin_lock(&unix_table_locks[sk->sk_hash]);
 	spin_lock(&net->unx.hash[sk->sk_hash].lock);
 	__unix_remove_socket(sk);
 	spin_unlock(&net->unx.hash[sk->sk_hash].lock);
-	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static void unix_insert_unbound_socket(struct net *net, struct sock *sk)
 {
-	spin_lock(&unix_table_locks[sk->sk_hash]);
 	spin_lock(&net->unx.hash[sk->sk_hash].lock);
 	__unix_insert_socket(net, sk);
 	spin_unlock(&net->unx.hash[sk->sk_hash].lock);
-	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
 static struct sock *__unix_find_socket_byname(struct net *net,
@@ -362,13 +350,11 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 {
 	struct sock *s;
 
-	spin_lock(&unix_table_locks[hash]);
 	spin_lock(&net->unx.hash[hash].lock);
 	s = __unix_find_socket_byname(net, sunname, len, hash);
 	if (s)
 		sock_hold(s);
 	spin_unlock(&net->unx.hash[hash].lock);
-	spin_unlock(&unix_table_locks[hash]);
 	return s;
 }
 
@@ -377,7 +363,6 @@ static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
 	unsigned int hash = unix_bsd_hash(i);
 	struct sock *s;
 
-	spin_lock(&unix_table_locks[hash]);
 	spin_lock(&net->unx.hash[hash].lock);
 	sk_for_each(s, &net->unx.hash[hash].head) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
@@ -385,12 +370,10 @@ static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
 		if (dentry && d_backing_inode(dentry) == i) {
 			sock_hold(s);
 			spin_unlock(&net->unx.hash[hash].lock);
-			spin_unlock(&unix_table_locks[hash]);
 			return s;
 		}
 	}
 	spin_unlock(&net->unx.hash[hash].lock);
-	spin_unlock(&unix_table_locks[hash]);
 	return NULL;
 }
 
@@ -3253,7 +3236,6 @@ static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 	struct sock *sk;
 
 	while (bucket < UNIX_HASH_SIZE) {
-		spin_lock(&unix_table_locks[bucket]);
 		spin_lock(&net->unx.hash[bucket].lock);
 
 		sk = unix_from_bucket(seq, pos);
@@ -3261,7 +3243,6 @@ static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 			return sk;
 
 		spin_unlock(&net->unx.hash[bucket].lock);
-		spin_unlock(&unix_table_locks[bucket]);
 
 		*pos = set_bucket_offset(++bucket, 1);
 	}
@@ -3279,7 +3260,6 @@ static struct sock *unix_get_next(struct seq_file *seq, struct sock *sk,
 		return sk;
 
 	spin_unlock(&seq_file_net(seq)->unx.hash[bucket].lock);
-	spin_unlock(&unix_table_locks[bucket]);
 
 	*pos = set_bucket_offset(++bucket, 1);
 
@@ -3308,10 +3288,8 @@ static void unix_seq_stop(struct seq_file *seq, void *v)
 {
 	struct sock *sk = v;
 
-	if (sk) {
+	if (sk)
 		spin_unlock(&seq_file_net(seq)->unx.hash[sk->sk_hash].lock);
-		spin_unlock(&unix_table_locks[sk->sk_hash]);
-	}
 }
 
 static int unix_seq_show(struct seq_file *seq, void *v)
@@ -3415,7 +3393,6 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 	}
 
 	spin_unlock(&seq_file_net(seq)->unx.hash[start_sk->sk_hash].lock);
-	spin_unlock(&unix_table_locks[start_sk->sk_hash]);
 
 	return expected;
 }
@@ -3709,9 +3686,6 @@ static int __init af_unix_init(void)
 		spin_lock_init(&init_net.unx.hash[i].lock);
 	}
 
-	for (i = 0; i < UNIX_HASH_SIZE; i++)
-		spin_lock_init(&unix_table_locks[i]);
-
 	rc = proto_register(&unix_dgram_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 5774172a3ea5..370eb268ec63 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -208,7 +208,6 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		struct sock *sk;
 
 		num = 0;
-		spin_lock(&unix_table_locks[slot]);
 		spin_lock(&net->unx.hash[slot].lock);
 		sk_for_each(sk, &net->unx.hash[slot].head) {
 			if (num < s_num)
@@ -220,14 +219,12 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 					 cb->nlh->nlmsg_seq,
 					 NLM_F_MULTI) < 0) {
 				spin_unlock(&net->unx.hash[slot].lock);
-				spin_unlock(&unix_table_locks[slot]);
 				goto done;
 			}
 next:
 			num++;
 		}
 		spin_unlock(&net->unx.hash[slot].lock);
-		spin_unlock(&unix_table_locks[slot]);
 	}
 done:
 	cb->args[0] = slot;
@@ -242,18 +239,15 @@ static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
 	int i;
 
 	for (i = 0; i < UNIX_HASH_SIZE; i++) {
-		spin_lock(&unix_table_locks[i]);
 		spin_lock(&net->unx.hash[i].lock);
 		sk_for_each(sk, &net->unx.hash[i].head) {
 			if (ino == sock_i_ino(sk)) {
 				sock_hold(sk);
 				spin_unlock(&net->unx.hash[i].lock);
-				spin_unlock(&unix_table_locks[i]);
 				return sk;
 			}
 		}
 		spin_unlock(&net->unx.hash[i].lock);
-		spin_unlock(&unix_table_locks[i]);
 	}
 	return NULL;
 }
-- 
2.30.2

