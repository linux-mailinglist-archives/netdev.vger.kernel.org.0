Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAA6562C8C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiGAHZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiGAHZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:25:50 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF626B826
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 00:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656660348; x=1688196348;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=szx0AmLfo/rUPo6X3ZIw8170BFM+H9tnr0bzzTSOhxI=;
  b=LtDtgKiVcevmn+eJq4usouuMFFmHPG4vjSlcSkvqyA2RgcF0dkpDS/99
   JpTsHTuCQXwgb+2INRp7LzsHN9onneEOtkt9EnLi5WR7qTHmocZCQXwmL
   weWAs11Yqss7YuymBW+nL9blhCxcvWJQfuWtpT6/CjaX7ilYUqDVseLdK
   w=;
X-IronPort-AV: E=Sophos;i="5.92,236,1650931200"; 
   d="scan'208";a="103897939"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 01 Jul 2022 07:25:33 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id D1B254C0072;
        Fri,  1 Jul 2022 07:25:32 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 1 Jul 2022 07:25:32 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.50) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 1 Jul 2022 07:25:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Sachin Sant <sachinp@linux.ibm.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next] af_unix: Put a named socket in the global hash table.
Date:   Fri, 1 Jul 2022 00:25:19 -0700
Message-ID: <20220701072519.96097-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit cf2f225e2653 ("af_unix: Put a socket into a per-netns hash
table.") accidentally broke user API for named sockets.  A named
socket was able to connect() to a peer in the same mount namespace
even if they were in different network namespaces.

The commit put all sockets into each per-netns hash table.  As a
result, connect() to a socket in a different netns failed to find
the peer and returned -ECONNREFUSED even when they had the same
mount namespace.

We can reproduce this issue by

  Console A:

    # python3
    >>> from socket import *
    >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
    >>> s.bind('test')
    >>> s.listen(32)

  Console B:

    # ip netns add test
    # ip netns exec test sh
    # python3
    >>> from socket import *
    >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
    >>> s.connect('test')

Note when dumping sockets by sock_diag, procfs, and bpf_iter, they are
filtered only by netns.  In other words, sockets with different netns
and the same mount ns are skipped while iterating sockets.  Thus, we
need a fix only for finding a peer socket.

This patch adds a global hash table for named sockets, links them with
sk_bind_node, and uses it in unix_find_socket_byinode().  By doing so,
we can keep all sockets in per-netns hash tables and dump them easily.

Thank Sachin Sant and Leonard Crestez for reports, logs and a reproducer.

Fixes: cf2f225e2653 ("af_unix: Put a socket into a per-netns hash table.")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Reported-by: Leonard Crestez <cdleonard@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 47 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 49f6626330c3..526b872cc710 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -119,6 +119,8 @@
 #include "scm.h"
 
 static atomic_long_t unix_nr_socks;
+static struct hlist_head bsd_socket_buckets[UNIX_HASH_SIZE / 2];
+static spinlock_t bsd_socket_locks[UNIX_HASH_SIZE / 2];
 
 /* SMP locking strategy:
  *    hash table is protected with spinlock.
@@ -328,6 +330,24 @@ static void unix_insert_unbound_socket(struct net *net, struct sock *sk)
 	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
 }
 
+static void unix_insert_bsd_socket(struct sock *sk)
+{
+	spin_lock(&bsd_socket_locks[sk->sk_hash]);
+	sk_add_bind_node(sk, &bsd_socket_buckets[sk->sk_hash]);
+	spin_unlock(&bsd_socket_locks[sk->sk_hash]);
+}
+
+static void unix_remove_bsd_socket(struct sock *sk)
+{
+	if (!hlist_unhashed(&sk->sk_bind_node)) {
+		spin_lock(&bsd_socket_locks[sk->sk_hash]);
+		__sk_del_bind_node(sk);
+		spin_unlock(&bsd_socket_locks[sk->sk_hash]);
+
+		sk_node_init(&sk->sk_bind_node);
+	}
+}
+
 static struct sock *__unix_find_socket_byname(struct net *net,
 					      struct sockaddr_un *sunname,
 					      int len, unsigned int hash)
@@ -358,22 +378,22 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 	return s;
 }
 
-static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
+static struct sock *unix_find_socket_byinode(struct inode *i)
 {
 	unsigned int hash = unix_bsd_hash(i);
 	struct sock *s;
 
-	spin_lock(&net->unx.table.locks[hash]);
-	sk_for_each(s, &net->unx.table.buckets[hash]) {
+	spin_lock(&bsd_socket_locks[hash]);
+	sk_for_each_bound(s, &bsd_socket_buckets[hash]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
 
 		if (dentry && d_backing_inode(dentry) == i) {
 			sock_hold(s);
-			spin_unlock(&net->unx.table.locks[hash]);
+			spin_unlock(&bsd_socket_locks[hash]);
 			return s;
 		}
 	}
-	spin_unlock(&net->unx.table.locks[hash]);
+	spin_unlock(&bsd_socket_locks[hash]);
 	return NULL;
 }
 
@@ -577,6 +597,7 @@ static void unix_release_sock(struct sock *sk, int embrion)
 	int state;
 
 	unix_remove_socket(sock_net(sk), sk);
+	unix_remove_bsd_socket(sk);
 
 	/* Clear state */
 	unix_state_lock(sk);
@@ -988,8 +1009,8 @@ static int unix_release(struct socket *sock)
 	return 0;
 }
 
-static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
-				  int addr_len, int type)
+static struct sock *unix_find_bsd(struct sockaddr_un *sunaddr, int addr_len,
+				  int type)
 {
 	struct inode *inode;
 	struct path path;
@@ -1010,7 +1031,7 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 	if (!S_ISSOCK(inode->i_mode))
 		goto path_put;
 
-	sk = unix_find_socket_byinode(net, inode);
+	sk = unix_find_socket_byinode(inode);
 	if (!sk)
 		goto path_put;
 
@@ -1058,7 +1079,7 @@ static struct sock *unix_find_other(struct net *net,
 	struct sock *sk;
 
 	if (sunaddr->sun_path[0])
-		sk = unix_find_bsd(net, sunaddr, addr_len, type);
+		sk = unix_find_bsd(sunaddr, addr_len, type);
 	else
 		sk = unix_find_abstract(net, sunaddr, addr_len, type);
 
@@ -1179,6 +1200,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 	u->path.dentry = dget(dentry);
 	__unix_set_addr_hash(net, sk, addr, new_hash);
 	unix_table_double_unlock(net, old_hash, new_hash);
+	unix_insert_bsd_socket(sk);
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
 	return 0;
@@ -3682,10 +3704,15 @@ static void __init bpf_iter_register(void)
 
 static int __init af_unix_init(void)
 {
-	int rc = -1;
+	int i, rc = -1;
 
 	BUILD_BUG_ON(sizeof(struct unix_skb_parms) > sizeof_field(struct sk_buff, cb));
 
+	for (i = 0; i < UNIX_HASH_SIZE / 2; i++) {
+		spin_lock_init(&bsd_socket_locks[i]);
+		INIT_HLIST_HEAD(&bsd_socket_buckets[i]);
+	}
+
 	rc = proto_register(&unix_dgram_proto, 1);
 	if (rc != 0) {
 		pr_crit("%s: Cannot create unix_sock SLAB cache!\n", __func__);
-- 
2.30.2

