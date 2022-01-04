Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963244839DF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiADBdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:33:55 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:37230 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641260034; x=1672796034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SumEcLoZ8AxY99qrtno87QMN3qRZTPK29OEBgYdWBRs=;
  b=UUHF5Q7RXNp9d9mmpFU7Pa2MP2RgF6pDJOlzwvwjRlgvmRe63Wvnrl0q
   pNrxlmKTcq1+uf/MsBsmbIfogHLkhZmCoRABORd3ryU7v9IEvopGQ66VD
   3qzvbwXsU7OKGhBhhvkz/yL7ewDelhkYdXDgZjQWgGKdn3kpnbRMkVxCl
   k=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="982038654"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 04 Jan 2022 01:33:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id DD23F42E97;
        Tue,  4 Jan 2022 01:33:53 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:53 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:33:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 3/6] bpf: af_unix: Use batching algorithm in bpf unix iter.
Date:   Tue, 4 Jan 2022 10:31:50 +0900
Message-ID: <20220104013153.97906-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104013153.97906-1-kuniyu@amazon.co.jp>
References: <20220104013153.97906-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
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
 net/unix/af_unix.c | 182 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 175 insertions(+), 7 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index c19569819866..dd6804086372 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3347,6 +3347,14 @@ static const struct seq_operations unix_seq_ops = {
 };
 
 #if IS_BUILTIN(CONFIG_UNIX) && defined(CONFIG_BPF_SYSCALL)
+struct bpf_unix_iter_state {
+	struct seq_net_private p;
+	unsigned int cur_sk;
+	unsigned int end_sk;
+	unsigned int max_sk;
+	struct sock **batch;
+};
+
 struct bpf_iter__unix {
 	__bpf_md_ptr(struct bpf_iter_meta *, meta);
 	__bpf_md_ptr(struct unix_sock *, unix_sk);
@@ -3365,24 +3373,155 @@ static int unix_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta *meta,
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
+					struct sock *start_sk,
+					loff_t *pos)
+{
+	struct bpf_unix_iter_state *iter = seq->private;
+	unsigned int expected;
+	bool resized = false;
+	struct sock *sk;
+
+again:
+	/* Get a new batch */
+	iter->cur_sk = 0;
+	iter->end_sk = 0;
+
+	sk = unix_next_socket(seq, start_sk, pos);
+	if (!sk)
+		return NULL; /* Done */
+
+	expected = bpf_iter_unix_hold_batch(seq, sk);
+
+	if (iter->end_sk == expected)
+		return sk;
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
+	if (get_bucket(*pos) >= ARRAY_SIZE(unix_socket_table))
+		return NULL;
+
+	/* bpf iter does not support lseek, so it always
+	 * continue from where it was stop()-ped.
+	 */
+	return bpf_iter_unix_batch(seq, NULL, pos);
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
+		sk = bpf_iter_unix_batch(seq, v, pos);
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
 
@@ -3393,12 +3532,13 @@ static void bpf_iter_unix_seq_stop(struct seq_file *seq, void *v)
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
@@ -3447,11 +3587,39 @@ static struct pernet_operations unix_net_ops = {
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

