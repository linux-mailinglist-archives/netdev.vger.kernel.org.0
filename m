Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59C348CFB0
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiAMA3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:29:42 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:16904 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiAMA3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:29:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1642033778; x=1673569778;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K7MkisJVBiDUaiAf2EEmBDAI3EzW+pc2moDk2I1EeyY=;
  b=hr10NaXtEVLxAzGn964EH7pcb1e/R4q42Yfyaywy1tMbKa72GMpf4Eaq
   0tbAOa74d/svRtVU3xzkdBP7PM/oQYtJUBwR3+mgYe7pgke/M8J+DTBSK
   iggipjB/wqWZ/omimlFipA9u7Y61iC7pQfp/RRlB0KB/yDfgaL9UinkRb
   w=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208";a="54965278"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 13 Jan 2022 00:29:36 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id B087A14111E;
        Thu, 13 Jan 2022 00:29:34 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 13 Jan 2022 00:29:33 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.142) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 13 Jan 2022 00:29:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 2/5] bpf: af_unix: Use batching algorithm in bpf unix iter.
Date:   Thu, 13 Jan 2022 09:28:46 +0900
Message-ID: <20220113002849.4384-3-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220113002849.4384-1-kuniyu@amazon.co.jp>
References: <20220113002849.4384-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.142]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
introduces the batching algorithm to iterate TCP sockets with more
consistency.

This patch uses the same algorithm to iterate AF_UNIX sockets.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 net/unix/af_unix.c | 184 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 177 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e1c4082accdb..d383d5f63b6b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3356,6 +3356,15 @@ static const struct seq_operations unix_seq_ops = {
 };
 
 #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
+struct bpf_unix_iter_state {
+	struct seq_net_private p;
+	unsigned int cur_sk;
+	unsigned int end_sk;
+	unsigned int max_sk;
+	struct sock **batch;
+	bool st_bucket_done;
+};
+
 struct bpf_iter__unix {
 	__bpf_md_ptr(struct bpf_iter_meta *, meta);
 	__bpf_md_ptr(struct unix_sock *, unix_sk);
@@ -3374,24 +3383,156 @@ static int unix_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
 	return bpf_iter_run_prog(prog, &ctx);
 }
 
+static int bpf_iter_unix_hold_batch(struct seq_file *seq, struct sock *start_sk)
+
+{
+	struct bpf_unix_iter_state *iter = seq->private;
+	unsigned int expected = 1;
+	struct sock *sk;
+
+	sock_hold(start_sk);
+	iter->batch[iter->end_sk++] = start_sk;
+
+	for (sk = sk_next(start_sk); sk; sk = sk_next(sk)) {
+		if (sock_net(sk) != seq_file_net(seq))
+			continue;
+
+		if (iter->end_sk < iter->max_sk) {
+			sock_hold(sk);
+			iter->batch[iter->end_sk++] = sk;
+		}
+
+		expected++;
+	}
+
+	spin_unlock(&unix_table_locks[start_sk->sk_hash]);
+
+	return expected;
+}
+
+static void bpf_iter_unix_put_batch(struct bpf_unix_iter_state *iter)
+{
+	while (iter->cur_sk < iter->end_sk)
+		sock_put(iter->batch[iter->cur_sk++]);
+}
+
+static int bpf_iter_unix_realloc_batch(struct bpf_unix_iter_state *iter,
+				       unsigned int new_batch_sz)
+{
+	struct sock **new_batch;
+
+	new_batch = kvmalloc(sizeof(*new_batch) * new_batch_sz,
+			     GFP_USER | __GFP_NOWARN);
+	if (!new_batch)
+		return -ENOMEM;
+
+	bpf_iter_unix_put_batch(iter);
+	kvfree(iter->batch);
+	iter->batch = new_batch;
+	iter->max_sk = new_batch_sz;
+
+	return 0;
+}
+
+static struct sock *bpf_iter_unix_batch(struct seq_file *seq,
+					loff_t *pos)
+{
+	struct bpf_unix_iter_state *iter = seq->private;
+	unsigned int expected;
+	bool resized = false;
+	struct sock *sk;
+
+	if (iter->st_bucket_done)
+		*pos = set_bucket_offset(get_bucket(*pos) + 1, 1);
+
+again:
+	/* Get a new batch */
+	iter->cur_sk = 0;
+	iter->end_sk = 0;
+
+	sk = unix_get_first(seq, pos);
+	if (!sk)
+		return NULL; /* Done */
+
+	expected = bpf_iter_unix_hold_batch(seq, sk);
+
+	if (iter->end_sk == expected) {
+		iter->st_bucket_done = true;
+		return sk;
+	}
+
+	if (!resized && !bpf_iter_unix_realloc_batch(iter, expected * 3 / 2)) {
+		resized = true;
+		goto again;
+	}
+
+	return sk;
+}
+
+static void *bpf_iter_unix_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (!*pos)
+		return SEQ_START_TOKEN;
+
+	/* bpf iter does not support lseek, so it always
+	 * continue from where it was stop()-ped.
+	 */
+	return bpf_iter_unix_batch(seq, pos);
+}
+
+static void *bpf_iter_unix_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct bpf_unix_iter_state *iter = seq->private;
+	struct sock *sk;
+
+	/* Whenever seq_next() is called, the iter->cur_sk is
+	 * done with seq_show(), so advance to the next sk in
+	 * the batch.
+	 */
+	if (iter->cur_sk < iter->end_sk)
+		sock_put(iter->batch[iter->cur_sk++]);
+
+	++*pos;
+
+	if (iter->cur_sk < iter->end_sk)
+		sk = iter->batch[iter->cur_sk];
+	else
+		sk = bpf_iter_unix_batch(seq, pos);
+
+	return sk;
+}
+
 static int bpf_iter_unix_seq_show(struct seq_file *seq, void *v)
 {
 	struct bpf_iter_meta meta;
 	struct bpf_prog *prog;
 	struct sock *sk = v;
 	uid_t uid;
+	bool slow;
+	int ret;
 
 	if (v == SEQ_START_TOKEN)
 		return 0;
 
+	slow = lock_sock_fast(sk);
+
+	if (unlikely(sk_unhashed(sk))) {
+		ret = SEQ_SKIP;
+		goto unlock;
+	}
+
 	uid = from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
 	meta.seq = seq;
 	prog = bpf_iter_get_info(&meta, false);
-	return unix_prog_seq_show(prog, &meta, v, uid);
+	ret = unix_prog_seq_show(prog, &meta, v, uid);
+unlock:
+	unlock_sock_fast(sk, slow);
+	return ret;
 }
 
 static void bpf_iter_unix_seq_stop(struct seq_file *seq, void *v)
 {
+	struct bpf_unix_iter_state *iter = seq->private;
 	struct bpf_iter_meta meta;
 	struct bpf_prog *prog;
 
@@ -3402,12 +3543,13 @@ static void bpf_iter_unix_seq_stop(struct seq_file *seq, void *v)
 			(void)unix_prog_seq_show(prog, &meta, v, 0);
 	}
 
-	unix_seq_stop(seq, v);
+	if (iter->cur_sk < iter->end_sk)
+		bpf_iter_unix_put_batch(iter);
 }
 
 static const struct seq_operations bpf_iter_unix_seq_ops = {
-	.start	= unix_seq_start,
-	.next	= unix_seq_next,
+	.start	= bpf_iter_unix_seq_start,
+	.next	= bpf_iter_unix_seq_next,
 	.stop	= bpf_iter_unix_seq_stop,
 	.show	= bpf_iter_unix_seq_show,
 };
@@ -3456,11 +3598,39 @@ static struct pernet_operations unix_net_ops = {
 DEFINE_BPF_ITER_FUNC(unix, struct bpf_iter_meta *meta,
 		     struct unix_sock *unix_sk, uid_t uid)
 
+#define INIT_BATCH_SZ 16
+
+static int bpf_iter_init_unix(void *priv_data, struct bpf_iter_aux_info *aux)
+{
+	struct bpf_unix_iter_state *iter = priv_data;
+	int err;
+
+	err = bpf_iter_init_seq_net(priv_data, aux);
+	if (err)
+		return err;
+
+	err = bpf_iter_unix_realloc_batch(iter, INIT_BATCH_SZ);
+	if (err) {
+		bpf_iter_fini_seq_net(priv_data);
+		return err;
+	}
+
+	return 0;
+}
+
+static void bpf_iter_fini_unix(void *priv_data)
+{
+	struct bpf_unix_iter_state *iter = priv_data;
+
+	bpf_iter_fini_seq_net(priv_data);
+	kvfree(iter->batch);
+}
+
 static const struct bpf_iter_seq_info unix_seq_info = {
 	.seq_ops		= &bpf_iter_unix_seq_ops,
-	.init_seq_private	= bpf_iter_init_seq_net,
-	.fini_seq_private	= bpf_iter_fini_seq_net,
-	.seq_priv_size		= sizeof(struct seq_net_private),
+	.init_seq_private	= bpf_iter_init_unix,
+	.fini_seq_private	= bpf_iter_fini_unix,
+	.seq_priv_size		= sizeof(struct bpf_unix_iter_state),
 };
 
 static struct bpf_iter_reg unix_reg_info = {
-- 
2.30.2

