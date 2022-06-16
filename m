Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCF254EE03
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 01:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378747AbiFPXsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 19:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348137AbiFPXsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 19:48:36 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7097260DA6
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655423316; x=1686959316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tmVf/UlSWzphyug5cwKhsJdjodVKLjdnhhEbC9h0V2M=;
  b=v1udXTgx4XFCo84zDF+9AeGG5sajiW+3yIsqoif6IiyFxuto5UaYpryM
   MhTGBH7DqxthBZqD7LeIR7MNnFsMVMQJfEmEKcvUC08H+QiKinxuV8bBL
   qRmr5e0FHh3J8jedYDQE6oenWMmWmko6vmzA/a9agd51XTAE5Fzt1A1NU
   w=;
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 16 Jun 2022 23:48:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-a31e1d63.us-east-1.amazon.com (Postfix) with ESMTPS id 0B79CA2AA7;
        Thu, 16 Jun 2022 23:48:22 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:48:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.26) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 16 Jun 2022 23:48:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 2/6] af_unix: Include the whole hash table size in UNIX_HASH_SIZE.
Date:   Thu, 16 Jun 2022 16:47:10 -0700
Message-ID: <20220616234714.4291-3-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the size of AF_UNIX hash table is UNIX_HASH_SIZE * 2,
the first half for bind()ed sockets and the second half for unbound
ones.  UNIX_HASH_SIZE * 2 is used to define the table and iterate
over it.

In some places, we use ARRAY_SIZE(unix_socket_table) instead of
UNIX_HASH_SIZE * 2.  However, we cannot use it anymore because we
will allocate the hash table dynamically.  Then, we would have to
add UNIX_HASH_SIZE * 2 in many places, which would be troublesome.

This patch adapts the UNIX_HASH_SIZE definition to include bound
and unbound sockets and defines a new UNIX_HASH_MOD macro to ease
calculations.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/af_unix.h |  7 ++++---
 net/unix/af_unix.c    | 18 +++++++++---------
 net/unix/diag.c       |  6 ++----
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index a7ef624ed726..acb56e463db1 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -16,12 +16,13 @@ void wait_for_unix_gc(void);
 struct sock *unix_get_socket(struct file *filp);
 struct sock *unix_peer_get(struct sock *sk);
 
-#define UNIX_HASH_SIZE	256
+#define UNIX_HASH_MOD	(256 - 1)
+#define UNIX_HASH_SIZE	(256 * 2)
 #define UNIX_HASH_BITS	8
 
 extern unsigned int unix_tot_inflight;
-extern spinlock_t unix_table_locks[2 * UNIX_HASH_SIZE];
-extern struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
+extern spinlock_t unix_table_locks[UNIX_HASH_SIZE];
+extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
 
 struct unix_address {
 	refcount_t	refcnt;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 990257f02e7c..c0804ae9c96a 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -118,9 +118,9 @@
 
 #include "scm.h"
 
-spinlock_t unix_table_locks[2 * UNIX_HASH_SIZE];
+spinlock_t unix_table_locks[UNIX_HASH_SIZE];
 EXPORT_SYMBOL_GPL(unix_table_locks);
-struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
+struct hlist_head unix_socket_table[UNIX_HASH_SIZE];
 EXPORT_SYMBOL_GPL(unix_socket_table);
 static atomic_long_t unix_nr_socks;
 
@@ -137,12 +137,12 @@ static unsigned int unix_unbound_hash(struct sock *sk)
 	hash ^= hash >> 8;
 	hash ^= sk->sk_type;
 
-	return UNIX_HASH_SIZE + (hash & (UNIX_HASH_SIZE - 1));
+	return UNIX_HASH_MOD + 1 + (hash & UNIX_HASH_MOD);
 }
 
 static unsigned int unix_bsd_hash(struct inode *i)
 {
-	return i->i_ino & (UNIX_HASH_SIZE - 1);
+	return i->i_ino & UNIX_HASH_MOD;
 }
 
 static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
@@ -155,14 +155,14 @@ static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
 	hash ^= hash >> 8;
 	hash ^= type;
 
-	return hash & (UNIX_HASH_SIZE - 1);
+	return hash & UNIX_HASH_MOD;
 }
 
 static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
 {
 	/* hash1 and hash2 is never the same because
-	 * one is between 0 and UNIX_HASH_SIZE - 1, and
-	 * another is between UNIX_HASH_SIZE and UNIX_HASH_SIZE * 2.
+	 * one is between 0 and UNIX_HASH_MOD, and
+	 * another is between UNIX_HASH_MOD + 1 and UNIX_HASH_SIZE - 1.
 	 */
 	if (hash1 > hash2)
 		swap(hash1, hash2);
@@ -3239,7 +3239,7 @@ static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 	unsigned long bucket = get_bucket(*pos);
 	struct sock *sk;
 
-	while (bucket < ARRAY_SIZE(unix_socket_table)) {
+	while (bucket < UNIX_HASH_SIZE) {
 		spin_lock(&unix_table_locks[bucket]);
 
 		sk = unix_from_bucket(seq, pos);
@@ -3666,7 +3666,7 @@ static int __init af_unix_init(void)
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
-	for (i = 0; i < 2 * UNIX_HASH_SIZE; i++)
+	for (i = 0; i < UNIX_HASH_SIZE; i++)
 		spin_lock_init(&unix_table_locks[i]);
 
 	rc = proto_register(&unix_dgram_proto, 1);
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 4e3dc8179fa4..c5d1cca72aa5 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -204,9 +204,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	s_slot = cb->args[0];
 	num = s_num = cb->args[1];
 
-	for (slot = s_slot;
-	     slot < ARRAY_SIZE(unix_socket_table);
-	     s_num = 0, slot++) {
+	for (slot = s_slot; slot < UNIX_HASH_SIZE; s_num = 0, slot++) {
 		struct sock *sk;
 
 		num = 0;
@@ -242,7 +240,7 @@ static struct sock *unix_lookup_by_ino(unsigned int ino)
 	struct sock *sk;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(unix_socket_table); i++) {
+	for (i = 0; i < UNIX_HASH_SIZE; i++) {
 		spin_lock(&unix_table_locks[i]);
 		sk_for_each(sk, &unix_socket_table[i])
 			if (ino == sock_i_ino(sk)) {
-- 
2.30.2

