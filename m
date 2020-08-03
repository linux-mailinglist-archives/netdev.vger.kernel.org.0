Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41A523B0BC
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgHCXKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:10:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbgHCXKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:10:49 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 073MrPUK006067
        for <netdev@vger.kernel.org>; Mon, 3 Aug 2020 16:10:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qq70gJyeGBzaA0k1feKqTdNm9xRHpPrW4JAFYqw/jlQ=;
 b=X0vk0psIhdBu/JkQOawh8IXRamjRza82nLh1n0FhMNiKVvfX5DIekJQ7OtaR42Q/yk3W
 t3hlSlW9yy5XLfTsfoYxN/AzJlceR3mCyrTfY101iSH7vy4EVM3WeOZjpiSkduogCrLN
 Q51g1RQlEk1xgnrRbAR2uWLuUAkZkZvrjwk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32nrcs7592-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:10:49 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 16:10:48 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id AD9C72943872; Mon,  3 Aug 2020 16:10:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH v4 bpf-next 05/12] bpf: tcp: Add bpf_skops_established()
Date:   Mon, 3 Aug 2020 16:10:45 -0700
Message-ID: <20200803231045.2683198-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200803231013.2681560-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=15 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008030158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tcp_init_transfer(), it currently calls the bpf prog to give it a
chance to handle the just "ESTABLISHED" event (e.g. do setsockopt
on the newly established sk).  Right now, it is done by calling the
general purpose tcp_call_bpf().

In the later patch, it also needs to pass the just-received skb which
concludes the 3 way handshake. E.g. the SYNACK received at the active sid=
e.
The bpf prog can then learn some specific header options written by the
peer's bpf-prog and potentially do setsockopt on the newly established sk=
.
Thus, instead of reusing the general purpose tcp_call_bpf(), a new functi=
on
bpf_skops_established() is added to allow passing the "skb" to the bpf pr=
og.
The actual skb passing from bpf_skops_established() to the bpf prog
will happen together in a later patch which has the necessary bpf pieces.

A "skb" arg is also added to tcp_init_transfer() such that
it can then be passed to bpf_skops_established().

Calling the new bpf_skops_established() instead of tcp_call_bpf()
should be a noop in this patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/tcp.h       |  2 +-
 net/ipv4/tcp_fastopen.c |  2 +-
 net/ipv4/tcp_input.c    | 32 ++++++++++++++++++++++++++++----
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 895e7aabf136..ae18c2b222a3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -394,7 +394,7 @@ void tcp_metrics_init(void);
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst)=
;
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
-void tcp_init_transfer(struct sock *sk, int bpf_op);
+void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)=
;
 __poll_t tcp_poll(struct file *file, struct socket *sock,
 		      struct poll_table_struct *wait);
 int tcp_getsockopt(struct sock *sk, int level, int optname,
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 19ad9586c720..d53190302087 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -272,7 +272,7 @@ static struct sock *tcp_fastopen_create_child(struct =
sock *sk,
 	refcount_set(&req->rsk_refcnt, 2);
=20
 	/* Now finish processing the fastopen child socket. */
-	tcp_init_transfer(child, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
+	tcp_init_transfer(child, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB, skb);
=20
 	tp->rcv_nxt =3D TCP_SKB_CB(skb)->seq + 1;
=20
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c1d2fb507701..9a8fb41676bc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -138,6 +138,29 @@ void clean_acked_data_flush(void)
 EXPORT_SYMBOL_GPL(clean_acked_data_flush);
 #endif
=20
+#ifdef CONFIG_CGROUP_BPF
+static void bpf_skops_established(struct sock *sk, int bpf_op,
+				  struct sk_buff *skb)
+{
+	struct bpf_sock_ops_kern sock_ops;
+
+	sock_owned_by_me(sk);
+
+	memset(&sock_ops, 0, offsetof(struct bpf_sock_ops_kern, temp));
+	sock_ops.op =3D bpf_op;
+	sock_ops.is_fullsock =3D 1;
+	sock_ops.sk =3D sk;
+	/* skb will be passed to the bpf prog in a later patch. */
+
+	BPF_CGROUP_RUN_PROG_SOCK_OPS(&sock_ops);
+}
+#else
+static void bpf_skops_established(struct sock *sk, int bpf_op,
+				  struct sk_buff *skb)
+{
+}
+#endif
+
 static void tcp_gro_dev_warn(struct sock *sk, const struct sk_buff *skb,
 			     unsigned int len)
 {
@@ -5806,7 +5829,7 @@ void tcp_rcv_established(struct sock *sk, struct sk=
_buff *skb)
 }
 EXPORT_SYMBOL(tcp_rcv_established);
=20
-void tcp_init_transfer(struct sock *sk, int bpf_op)
+void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 {
 	struct inet_connection_sock *icsk =3D inet_csk(sk);
 	struct tcp_sock *tp =3D tcp_sk(sk);
@@ -5827,7 +5850,7 @@ void tcp_init_transfer(struct sock *sk, int bpf_op)
 		tp->snd_cwnd =3D tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp =3D tcp_jiffies32;
=20
-	tcp_call_bpf(sk, bpf_op, 0, NULL);
+	bpf_skops_established(sk, bpf_op, skb);
 	tcp_init_congestion_control(sk);
 	tcp_init_buffer_space(sk);
 }
@@ -5846,7 +5869,7 @@ void tcp_finish_connect(struct sock *sk, struct sk_=
buff *skb)
 		sk_mark_napi_id(sk, skb);
 	}
=20
-	tcp_init_transfer(sk, BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB);
+	tcp_init_transfer(sk, BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB, skb);
=20
 	/* Prevent spurious tcp_cwnd_restart() on first data
 	 * packet.
@@ -6318,7 +6341,8 @@ int tcp_rcv_state_process(struct sock *sk, struct s=
k_buff *skb)
 		} else {
 			tcp_try_undo_spurious_syn(sk);
 			tp->retrans_stamp =3D 0;
-			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
+			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB,
+					  skb);
 			WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		}
 		smp_mb();
--=20
2.24.1

