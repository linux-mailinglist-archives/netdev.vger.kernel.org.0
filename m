Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBC855244A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343691AbiFTSxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343673AbiFTSxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:53:33 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D196F14086
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 11:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655751212; x=1687287212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CrdqDH720+LmMt6lo7I7vj2WC0f4tKMNAXlmJFtvMVw=;
  b=cJ6X8eWG1C5OoCzQ48t9l5GMUoLnnpY0igBr7TS7KgIGLQYm7uegyqUI
   GFRHD5JonZI7vJISGdxvwDDbdvUOmHpcqf5+bJEtQ0OdbJyY5CRf9/n+f
   OkS2Xvv6JJPLyWLO8I1Zr7YGKlFH6+a1Fa9y3C5WE7viXxiTW6kS2TJMs
   A=;
X-IronPort-AV: E=Sophos;i="5.92,207,1650931200"; 
   d="scan'208";a="230008557"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 20 Jun 2022 18:53:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-b69ea591.us-east-1.amazon.com (Postfix) with ESMTPS id 13DD9C0A58;
        Mon, 20 Jun 2022 18:53:14 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 18:53:13 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.183) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 20 Jun 2022 18:53:10 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Amit Shah <aams@amazon.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 4/6] af_unix: Acquire/Release per-netns hash table's locks.
Date:   Mon, 20 Jun 2022 11:51:49 -0700
Message-ID: <20220620185151.65294-5-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620185151.65294-1-kuniyu@amazon.com>
References: <20220620185151.65294-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds extra spin_lock/spin_unlock() for a per-netns
hash table inside the existing ones for unix_table_locks.

As of this commit, sockets are still linked in the global hash
table.  After putting sockets in a per-netns hash table and
removing the old one in the next patch, we remove the global
locks in the last patch.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 75 +++++++++++++++++++++++++++++++---------------
 net/unix/diag.c    | 23 +++++++++-----
 2 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index cdd12881a39d..79f8fc5cdce8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -158,7 +158,8 @@ static unsigned int unix_abstract_hash(struct sockaddr_un *sunaddr,
 	return hash & UNIX_HASH_MOD;
 }
 
-static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
+static void unix_table_double_lock(struct net *net,
+				   unsigned int hash1, unsigned int hash2)
 {
 	/* hash1 and hash2 is never the same because
 	 * one is between 0 and UNIX_HASH_MOD, and
@@ -169,10 +170,17 @@ static void unix_table_double_lock(unsigned int hash1, unsigned int hash2)
 
 	spin_lock(&unix_table_locks[hash1]);
 	spin_lock_nested(&unix_table_locks[hash2], SINGLE_DEPTH_NESTING);
+
+	spin_lock(&net->unx.table.locks[hash1]);
+	spin_lock_nested(&net->unx.table.locks[hash2], SINGLE_DEPTH_NESTING);
 }
 
-static void unix_table_double_unlock(unsigned int hash1, unsigned int hash2)
+static void unix_table_double_unlock(struct net *net,
+				     unsigned int hash1, unsigned int hash2)
 {
+	spin_unlock(&net->unx.table.locks[hash1]);
+	spin_unlock(&net->unx.table.locks[hash2]);
+
 	spin_unlock(&unix_table_locks[hash1]);
 	spin_unlock(&unix_table_locks[hash2]);
 }
@@ -316,17 +324,21 @@ static void __unix_set_addr_hash(struct sock *sk, struct unix_address *addr,
 	__unix_insert_socket(sk);
 }
 
-static void unix_remove_socket(struct sock *sk)
+static void unix_remove_socket(struct net *net, struct sock *sk)
 {
 	spin_lock(&unix_table_locks[sk->sk_hash]);
+	spin_lock(&net->unx.table.locks[sk->sk_hash]);
 	__unix_remove_socket(sk);
+	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
 	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
-static void unix_insert_unbound_socket(struct sock *sk)
+static void unix_insert_unbound_socket(struct net *net, struct sock *sk)
 {
 	spin_lock(&unix_table_locks[sk->sk_hash]);
+	spin_lock(&net->unx.table.locks[sk->sk_hash]);
 	__unix_insert_socket(sk);
+	spin_unlock(&net->unx.table.locks[sk->sk_hash]);
 	spin_unlock(&unix_table_locks[sk->sk_hash]);
 }
 
@@ -356,28 +368,33 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 	struct sock *s;
 
 	spin_lock(&unix_table_locks[hash]);
+	spin_lock(&net->unx.table.locks[hash]);
 	s = __unix_find_socket_byname(net, sunname, len, hash);
 	if (s)
 		sock_hold(s);
+	spin_unlock(&net->unx.table.locks[hash]);
 	spin_unlock(&unix_table_locks[hash]);
 	return s;
 }
 
-static struct sock *unix_find_socket_byinode(struct inode *i)
+static struct sock *unix_find_socket_byinode(struct net *net, struct inode *i)
 {
 	unsigned int hash = unix_bsd_hash(i);
 	struct sock *s;
 
 	spin_lock(&unix_table_locks[hash]);
+	spin_lock(&net->unx.table.locks[hash]);
 	sk_for_each(s, &unix_socket_table[hash]) {
 		struct dentry *dentry = unix_sk(s)->path.dentry;
 
 		if (dentry && d_backing_inode(dentry) == i) {
 			sock_hold(s);
+			spin_unlock(&net->unx.table.locks[hash]);
 			spin_unlock(&unix_table_locks[hash]);
 			return s;
 		}
 	}
+	spin_unlock(&net->unx.table.locks[hash]);
 	spin_unlock(&unix_table_locks[hash]);
 	return NULL;
 }
@@ -576,12 +593,12 @@ static void unix_sock_destructor(struct sock *sk)
 static void unix_release_sock(struct sock *sk, int embrion)
 {
 	struct unix_sock *u = unix_sk(sk);
-	struct path path;
 	struct sock *skpair;
 	struct sk_buff *skb;
+	struct path path;
 	int state;
 
-	unix_remove_socket(sk);
+	unix_remove_socket(sock_net(sk), sk);
 
 	/* Clear state */
 	unix_state_lock(sk);
@@ -930,7 +947,7 @@ static struct sock *unix_create1(struct net *net, struct socket *sock, int kern,
 	init_waitqueue_head(&u->peer_wait);
 	init_waitqueue_func_entry(&u->peer_wake, unix_dgram_peer_wake_relay);
 	memset(&u->scm_stat, 0, sizeof(struct scm_stat));
-	unix_insert_unbound_socket(sk);
+	unix_insert_unbound_socket(net, sk);
 
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
@@ -1015,7 +1032,7 @@ static struct sock *unix_find_bsd(struct net *net, struct sockaddr_un *sunaddr,
 	if (!S_ISSOCK(inode->i_mode))
 		goto path_put;
 
-	sk = unix_find_socket_byinode(inode);
+	sk = unix_find_socket_byinode(net, inode);
 	if (!sk)
 		goto path_put;
 
@@ -1074,6 +1091,7 @@ static int unix_autobind(struct sock *sk)
 {
 	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
+	struct net *net = sock_net(sk);
 	struct unix_address *addr;
 	u32 lastnum, ordernum;
 	int err;
@@ -1102,11 +1120,10 @@ static int unix_autobind(struct sock *sk)
 	sprintf(addr->name->sun_path + 1, "%05x", ordernum);
 
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
-	unix_table_double_lock(old_hash, new_hash);
+	unix_table_double_lock(net, old_hash, new_hash);
 
-	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-				      new_hash)) {
-		unix_table_double_unlock(old_hash, new_hash);
+	if (__unix_find_socket_byname(net, addr->name, addr->len, new_hash)) {
+		unix_table_double_unlock(net, old_hash, new_hash);
 
 		/* __unix_find_socket_byname() may take long time if many names
 		 * are already in use.
@@ -1124,7 +1141,7 @@ static int unix_autobind(struct sock *sk)
 	}
 
 	__unix_set_addr_hash(sk, addr, new_hash);
-	unix_table_double_unlock(old_hash, new_hash);
+	unix_table_double_unlock(net, old_hash, new_hash);
 	err = 0;
 
 out:	mutex_unlock(&u->bindlock);
@@ -1138,6 +1155,7 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 	       (SOCK_INODE(sk->sk_socket)->i_mode & ~current_umask());
 	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
+	struct net *net = sock_net(sk);
 	struct user_namespace *ns; // barf...
 	struct unix_address *addr;
 	struct dentry *dentry;
@@ -1178,11 +1196,11 @@ static int unix_bind_bsd(struct sock *sk, struct sockaddr_un *sunaddr,
 		goto out_unlock;
 
 	new_hash = unix_bsd_hash(d_backing_inode(dentry));
-	unix_table_double_lock(old_hash, new_hash);
+	unix_table_double_lock(net, old_hash, new_hash);
 	u->path.mnt = mntget(parent.mnt);
 	u->path.dentry = dget(dentry);
 	__unix_set_addr_hash(sk, addr, new_hash);
-	unix_table_double_unlock(old_hash, new_hash);
+	unix_table_double_unlock(net, old_hash, new_hash);
 	mutex_unlock(&u->bindlock);
 	done_path_create(&parent, dentry);
 	return 0;
@@ -1205,6 +1223,7 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 {
 	unsigned int new_hash, old_hash = sk->sk_hash;
 	struct unix_sock *u = unix_sk(sk);
+	struct net *net = sock_net(sk);
 	struct unix_address *addr;
 	int err;
 
@@ -1222,19 +1241,18 @@ static int unix_bind_abstract(struct sock *sk, struct sockaddr_un *sunaddr,
 	}
 
 	new_hash = unix_abstract_hash(addr->name, addr->len, sk->sk_type);
-	unix_table_double_lock(old_hash, new_hash);
+	unix_table_double_lock(net, old_hash, new_hash);
 
-	if (__unix_find_socket_byname(sock_net(sk), addr->name, addr->len,
-				      new_hash))
+	if (__unix_find_socket_byname(net, addr->name, addr->len, new_hash))
 		goto out_spin;
 
 	__unix_set_addr_hash(sk, addr, new_hash);
-	unix_table_double_unlock(old_hash, new_hash);
+	unix_table_double_unlock(net, old_hash, new_hash);
 	mutex_unlock(&u->bindlock);
 	return 0;
 
 out_spin:
-	unix_table_double_unlock(old_hash, new_hash);
+	unix_table_double_unlock(net, old_hash, new_hash);
 	err = -EADDRINUSE;
 out_mutex:
 	mutex_unlock(&u->bindlock);
@@ -3237,15 +3255,18 @@ static struct sock *unix_from_bucket(struct seq_file *seq, loff_t *pos)
 static struct sock *unix_get_first(struct seq_file *seq, loff_t *pos)
 {
 	unsigned long bucket = get_bucket(*pos);
+	struct net *net = seq_file_net(seq);
 	struct sock *sk;
 
 	while (bucket < UNIX_HASH_SIZE) {
 		spin_lock(&unix_table_locks[bucket]);
+		spin_lock(&net->unx.table.locks[bucket]);
 
 		sk = unix_from_bucket(seq, pos);
 		if (sk)
 			return sk;
 
+		spin_unlock(&net->unx.table.locks[bucket]);
 		spin_unlock(&unix_table_locks[bucket]);
 
 		*pos = set_bucket_offset(++bucket, 1);
@@ -3258,11 +3279,13 @@ static struct sock *unix_get_next(struct seq_file *seq, struct sock *sk,
 				  loff_t *pos)
 {
 	unsigned long bucket = get_bucket(*pos);
+	struct net *net = seq_file_net(seq);
 
 	for (sk = sk_next(sk); sk; sk = sk_next(sk))
-		if (sock_net(sk) == seq_file_net(seq))
+		if (sock_net(sk) == net)
 			return sk;
 
+	spin_unlock(&net->unx.table.locks[bucket]);
 	spin_unlock(&unix_table_locks[bucket]);
 
 	*pos = set_bucket_offset(++bucket, 1);
@@ -3292,8 +3315,10 @@ static void unix_seq_stop(struct seq_file *seq, void *v)
 {
 	struct sock *sk = v;
 
-	if (sk)
+	if (sk) {
+		spin_unlock(&seq_file_net(seq)->unx.table.locks[sk->sk_hash]);
 		spin_unlock(&unix_table_locks[sk->sk_hash]);
+	}
 }
 
 static int unix_seq_show(struct seq_file *seq, void *v)
@@ -3381,6 +3406,7 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 
 {
 	struct bpf_unix_iter_state *iter = seq->private;
+	struct net *net = seq_file_net(seq);
 	unsigned int expected = 1;
 	struct sock *sk;
 
@@ -3388,7 +3414,7 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 	iter->batch[iter->end_sk++] = start_sk;
 
 	for (sk = sk_next(start_sk); sk; sk = sk_next(sk)) {
-		if (sock_net(sk) != seq_file_net(seq))
+		if (sock_net(sk) != net)
 			continue;
 
 		if (iter->end_sk < iter->max_sk) {
@@ -3399,6 +3425,7 @@ static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
 		expected++;
 	}
 
+	spin_unlock(&net->unx.table.locks[start_sk->sk_hash]);
 	spin_unlock(&unix_table_locks[start_sk->sk_hash]);
 
 	return expected;
diff --git a/net/unix/diag.c b/net/unix/diag.c
index c5d1cca72aa5..7fc377435114 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -195,9 +195,9 @@ static int sk_diag_dump(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 
 static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct unix_diag_req *req;
-	int num, s_num, slot, s_slot;
 	struct net *net = sock_net(skb->sk);
+	int num, s_num, slot, s_slot;
+	struct unix_diag_req *req;
 
 	req = nlmsg_data(cb->nlh);
 
@@ -209,6 +209,7 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 
 		num = 0;
 		spin_lock(&unix_table_locks[slot]);
+		spin_lock(&net->unx.table.locks[slot]);
 		sk_for_each(sk, &unix_socket_table[slot]) {
 			if (!net_eq(sock_net(sk), net))
 				continue;
@@ -220,12 +221,14 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 					 NETLINK_CB(cb->skb).portid,
 					 cb->nlh->nlmsg_seq,
 					 NLM_F_MULTI) < 0) {
+				spin_unlock(&net->unx.table.locks[slot]);
 				spin_unlock(&unix_table_locks[slot]);
 				goto done;
 			}
 next:
 			num++;
 		}
+		spin_unlock(&net->unx.table.locks[slot]);
 		spin_unlock(&unix_table_locks[slot]);
 	}
 done:
@@ -235,19 +238,22 @@ static int unix_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
-static struct sock *unix_lookup_by_ino(unsigned int ino)
+static struct sock *unix_lookup_by_ino(struct net *net, unsigned int ino)
 {
 	struct sock *sk;
 	int i;
 
 	for (i = 0; i < UNIX_HASH_SIZE; i++) {
 		spin_lock(&unix_table_locks[i]);
+		spin_lock(&net->unx.table.locks[i]);
 		sk_for_each(sk, &unix_socket_table[i])
 			if (ino == sock_i_ino(sk)) {
 				sock_hold(sk);
+				spin_unlock(&net->unx.table.locks[i]);
 				spin_unlock(&unix_table_locks[i]);
 				return sk;
 			}
+		spin_unlock(&net->unx.table.locks[i]);
 		spin_unlock(&unix_table_locks[i]);
 	}
 	return NULL;
@@ -257,16 +263,17 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 			       const struct nlmsghdr *nlh,
 			       struct unix_diag_req *req)
 {
-	int err = -EINVAL;
-	struct sock *sk;
-	struct sk_buff *rep;
-	unsigned int extra_len;
 	struct net *net = sock_net(in_skb->sk);
+	unsigned int extra_len;
+	struct sk_buff *rep;
+	struct sock *sk;
+	int err;
 
+	err = -EINVAL;
 	if (req->udiag_ino == 0)
 		goto out_nosk;
 
-	sk = unix_lookup_by_ino(req->udiag_ino);
+	sk = unix_lookup_by_ino(net, req->udiag_ino);
 	err = -ENOENT;
 	if (sk == NULL)
 		goto out_nosk;
-- 
2.30.2

