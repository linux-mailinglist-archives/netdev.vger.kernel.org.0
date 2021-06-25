Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB743B49A4
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhFYUIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:08:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229853AbhFYUIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:08:00 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PK4uMI011723
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HGzIbjVF/3v01Ve9Zt6KGZ4clT0vLwLXgwY9JVsQDfA=;
 b=CIUPk5PAO9g0J2nA1XqlKyNMDTNBylFOY8F5QIcmO8xnIS8jcGUByqT6B17Qct//5XUo
 Sts1ewKRa9qR1UX00CXd/n3m+Zx0ZuUmpbb7qHx40S8vzMPH6RtANFgD+S1IAC6HIJmT
 H/jEEr36rGdfM/riEcbTGa+3qMY5NQRSNtg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d255pq1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:39 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:05:38 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CB27D29422B0; Fri, 25 Jun 2021 13:05:23 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 6/8] bpf: tcp: bpf iter batching and lock_sock
Date:   Fri, 25 Jun 2021 13:05:23 -0700
Message-ID: <20210625200523.726854-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
References: <20210625200446.723230-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: v7UxCGAHuyU1WE-kZPUovNz7n0UqKJIT
X-Proofpoint-GUID: v7UxCGAHuyU1WE-kZPUovNz7n0UqKJIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch does batching and lock_sock for the bpf tcp iter.
It does not affect the proc fs iteration.

With bpf-tcp-cc, new algo rollout happens more often.  Instead of
restarting the application to pick up the new tcp-cc, the next patch
will allow bpf iter with CAP_NET_ADMIN to do setsockopt(TCP_CONGESTION).
This requires locking the sock.

Also, unlike the proc iteration (cat /proc/net/tcp[6]), the bpf iter
can inspect all fields of a tcp_sock.  It will be useful to have a
consistent view on some of the fields (e.g. the ones reported in
tcp_get_info() that also acquires the sock lock).

Double lock: locking the bucket first and then locking the sock could
lead to deadlock.  This patch takes a batching approach similar to
inet_diag.  While holding the bucket lock, it batch a number of sockets
into an array first and then unlock the bucket.  Before doing show(),
it then calls lock_sock_fast().

In a machine with ~400k connections, the maximum number of
sk in a bucket of the established hashtable is 7.  0.02% of
the established connections fall into this bucket size.

For listen hash (port+addr lhash2), the bucket is usually very
small also except for the SO_REUSEPORT use case which the
userspace could have one SO_REUSEPORT socket per thread.

While batching is used, it can also minimize the chance of missing
sock in the setsockopt use case if the whole bucket is batched.
This patch will start with a batch array with INIT_BATCH_SZ (16)
which will be enough for the most common cases.  bpf_iter_tcp_batch()
will try to realloc to a larger array to handle exception case (e.g.
the SO_REUSEPORT case in the lhash2).

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_ipv4.c | 236 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0d851289a89e..856144d33f52 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2687,6 +2687,15 @@ static int tcp4_seq_show(struct seq_file *seq, voi=
d *v)
 }
=20
 #ifdef CONFIG_BPF_SYSCALL
+struct bpf_tcp_iter_state {
+	struct tcp_iter_state state;
+	unsigned int cur_sk;
+	unsigned int end_sk;
+	unsigned int max_sk;
+	struct sock **batch;
+	bool st_bucket_done;
+};
+
 struct bpf_iter__tcp {
 	__bpf_md_ptr(struct bpf_iter_meta *, meta);
 	__bpf_md_ptr(struct sock_common *, sk_common);
@@ -2705,16 +2714,203 @@ static int tcp_prog_seq_show(struct bpf_prog *pr=
og, struct bpf_iter_meta *meta,
 	return bpf_iter_run_prog(prog, &ctx);
 }
=20
+static void bpf_iter_tcp_put_batch(struct bpf_tcp_iter_state *iter)
+{
+	while (iter->cur_sk < iter->end_sk)
+		sock_put(iter->batch[iter->cur_sk++]);
+}
+
+static int bpf_iter_tcp_realloc_batch(struct bpf_tcp_iter_state *iter,
+				      unsigned int new_batch_sz)
+{
+	struct sock **new_batch;
+
+	new_batch =3D kvmalloc(sizeof(*new_batch) * new_batch_sz, GFP_USER);
+	if (!new_batch)
+		return -ENOMEM;
+
+	bpf_iter_tcp_put_batch(iter);
+	kvfree(iter->batch);
+	iter->batch =3D new_batch;
+	iter->max_sk =3D new_batch_sz;
+
+	return 0;
+}
+
+static unsigned int bpf_iter_tcp_listening_batch(struct seq_file *seq,
+						 struct sock *start_sk)
+{
+	struct bpf_tcp_iter_state *iter =3D seq->private;
+	struct tcp_iter_state *st =3D &iter->state;
+	struct inet_connection_sock *icsk;
+	unsigned int expected =3D 1;
+	struct sock *sk;
+
+	sock_hold(start_sk);
+	iter->batch[iter->end_sk++] =3D start_sk;
+
+	icsk =3D inet_csk(start_sk);
+	inet_lhash2_for_each_icsk_continue(icsk) {
+		sk =3D (struct sock *)icsk;
+		if (seq_sk_match(seq, sk)) {
+			if (iter->end_sk < iter->max_sk) {
+				sock_hold(sk);
+				iter->batch[iter->end_sk++] =3D sk;
+			}
+			expected++;
+		}
+	}
+	spin_unlock(&tcp_hashinfo.lhash2[st->bucket].lock);
+
+	return expected;
+}
+
+static unsigned int bpf_iter_tcp_established_batch(struct seq_file *seq,
+						   struct sock *start_sk)
+{
+	struct bpf_tcp_iter_state *iter =3D seq->private;
+	struct tcp_iter_state *st =3D &iter->state;
+	struct hlist_nulls_node *node;
+	unsigned int expected =3D 1;
+	struct sock *sk;
+
+	sock_hold(start_sk);
+	iter->batch[iter->end_sk++] =3D start_sk;
+
+	sk =3D sk_nulls_next(start_sk);
+	sk_nulls_for_each_from(sk, node) {
+		if (seq_sk_match(seq, sk)) {
+			if (iter->end_sk < iter->max_sk) {
+				sock_hold(sk);
+				iter->batch[iter->end_sk++] =3D sk;
+			}
+			expected++;
+		}
+	}
+	spin_unlock_bh(inet_ehash_lockp(&tcp_hashinfo, st->bucket));
+
+	return expected;
+}
+
+static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
+{
+	struct bpf_tcp_iter_state *iter =3D seq->private;
+	struct tcp_iter_state *st =3D &iter->state;
+	unsigned int expected;
+	bool resized =3D false;
+	struct sock *sk;
+
+	/* The st->bucket is done.  Directly advance to the next
+	 * bucket instead of having the tcp_seek_last_pos() to skip
+	 * one by one in the current bucket and eventually find out
+	 * it has to advance to the next bucket.
+	 */
+	if (iter->st_bucket_done) {
+		st->offset =3D 0;
+		st->bucket++;
+		if (st->state =3D=3D TCP_SEQ_STATE_LISTENING &&
+		    st->bucket > tcp_hashinfo.lhash2_mask) {
+			st->state =3D TCP_SEQ_STATE_ESTABLISHED;
+			st->bucket =3D 0;
+		}
+	}
+
+again:
+	/* Get a new batch */
+	iter->cur_sk =3D 0;
+	iter->end_sk =3D 0;
+	iter->st_bucket_done =3D false;
+
+	sk =3D tcp_seek_last_pos(seq);
+	if (!sk)
+		return NULL; /* Done */
+
+	if (st->state =3D=3D TCP_SEQ_STATE_LISTENING)
+		expected =3D bpf_iter_tcp_listening_batch(seq, sk);
+	else
+		expected =3D bpf_iter_tcp_established_batch(seq, sk);
+
+	if (iter->end_sk =3D=3D expected) {
+		iter->st_bucket_done =3D true;
+		return sk;
+	}
+
+	if (!resized && !bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2)) {
+		resized =3D true;
+		goto again;
+	}
+
+	return sk;
+}
+
+static void *bpf_iter_tcp_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	/* bpf iter does not support lseek, so it always
+	 * continue from where it was stop()-ped.
+	 */
+	if (*pos)
+		return bpf_iter_tcp_batch(seq);
+
+	return SEQ_START_TOKEN;
+}
+
+static void *bpf_iter_tcp_seq_next(struct seq_file *seq, void *v, loff_t=
 *pos)
+{
+	struct bpf_tcp_iter_state *iter =3D seq->private;
+	struct tcp_iter_state *st =3D &iter->state;
+	struct sock *sk;
+
+	/* Whenever seq_next() is called, the iter->cur_sk is
+	 * done with seq_show(), so advance to the next sk in
+	 * the batch.
+	 */
+	if (iter->cur_sk < iter->end_sk) {
+		/* Keeping st->num consistent in tcp_iter_state.
+		 * bpf_iter_tcp does not use st->num.
+		 * meta.seq_num is used instead.
+		 */
+		st->num++;
+		/* Move st->offset to the next sk in the bucket such that
+		 * the future start() will resume at st->offset in
+		 * st->bucket.  See tcp_seek_last_pos().
+		 */
+		st->offset++;
+		sock_put(iter->batch[iter->cur_sk++]);
+	}
+
+	if (iter->cur_sk < iter->end_sk)
+		sk =3D iter->batch[iter->cur_sk];
+	else
+		sk =3D bpf_iter_tcp_batch(seq);
+
+	++*pos;
+	/* Keeping st->last_pos consistent in tcp_iter_state.
+	 * bpf iter does not do lseek, so st->last_pos always equals to *pos.
+	 */
+	st->last_pos =3D *pos;
+	return sk;
+}
+
 static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
 {
 	struct bpf_iter_meta meta;
 	struct bpf_prog *prog;
 	struct sock *sk =3D v;
+	bool slow;
 	uid_t uid;
+	int ret;
=20
 	if (v =3D=3D SEQ_START_TOKEN)
 		return 0;
=20
+	if (sk_fullsock(sk))
+		slow =3D lock_sock_fast(sk);
+
+	if (unlikely(sk_unhashed(sk))) {
+		ret =3D SEQ_SKIP;
+		goto unlock;
+	}
+
 	if (sk->sk_state =3D=3D TCP_TIME_WAIT) {
 		uid =3D 0;
 	} else if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV) {
@@ -2728,11 +2924,18 @@ static int bpf_iter_tcp_seq_show(struct seq_file =
*seq, void *v)
=20
 	meta.seq =3D seq;
 	prog =3D bpf_iter_get_info(&meta, false);
-	return tcp_prog_seq_show(prog, &meta, v, uid);
+	ret =3D tcp_prog_seq_show(prog, &meta, v, uid);
+
+unlock:
+	if (sk_fullsock(sk))
+		unlock_sock_fast(sk, slow);
+	return ret;
+
 }
=20
 static void bpf_iter_tcp_seq_stop(struct seq_file *seq, void *v)
 {
+	struct bpf_tcp_iter_state *iter =3D seq->private;
 	struct bpf_iter_meta meta;
 	struct bpf_prog *prog;
=20
@@ -2743,13 +2946,16 @@ static void bpf_iter_tcp_seq_stop(struct seq_file=
 *seq, void *v)
 			(void)tcp_prog_seq_show(prog, &meta, v, 0);
 	}
=20
-	tcp_seq_stop(seq, v);
+	if (iter->cur_sk < iter->end_sk) {
+		bpf_iter_tcp_put_batch(iter);
+		iter->st_bucket_done =3D false;
+	}
 }
=20
 static const struct seq_operations bpf_iter_tcp_seq_ops =3D {
 	.show		=3D bpf_iter_tcp_seq_show,
-	.start		=3D tcp_seq_start,
-	.next		=3D tcp_seq_next,
+	.start		=3D bpf_iter_tcp_seq_start,
+	.next		=3D bpf_iter_tcp_seq_next,
 	.stop		=3D bpf_iter_tcp_seq_stop,
 };
 #endif
@@ -3017,21 +3223,39 @@ static struct pernet_operations __net_initdata tc=
p_sk_ops =3D {
 DEFINE_BPF_ITER_FUNC(tcp, struct bpf_iter_meta *meta,
 		     struct sock_common *sk_common, uid_t uid)
=20
+#define INIT_BATCH_SZ 16
+
 static int bpf_iter_init_tcp(void *priv_data, struct bpf_iter_aux_info *=
aux)
 {
-	return bpf_iter_init_seq_net(priv_data, aux);
+	struct bpf_tcp_iter_state *iter =3D priv_data;
+	int err;
+
+	err =3D bpf_iter_init_seq_net(priv_data, aux);
+	if (err)
+		return err;
+
+	err =3D bpf_iter_tcp_realloc_batch(iter, INIT_BATCH_SZ);
+	if (err) {
+		bpf_iter_fini_seq_net(priv_data);
+		return err;
+	}
+
+	return 0;
 }
=20
 static void bpf_iter_fini_tcp(void *priv_data)
 {
+	struct bpf_tcp_iter_state *iter =3D priv_data;
+
 	bpf_iter_fini_seq_net(priv_data);
+	kvfree(iter->batch);
 }
=20
 static const struct bpf_iter_seq_info tcp_seq_info =3D {
 	.seq_ops		=3D &bpf_iter_tcp_seq_ops,
 	.init_seq_private	=3D bpf_iter_init_tcp,
 	.fini_seq_private	=3D bpf_iter_fini_tcp,
-	.seq_priv_size		=3D sizeof(struct tcp_iter_state),
+	.seq_priv_size		=3D sizeof(struct bpf_tcp_iter_state),
 };
=20
 static struct bpf_iter_reg tcp_reg_info =3D {
--=20
2.30.2

