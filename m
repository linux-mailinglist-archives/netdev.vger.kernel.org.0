Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE03E2045C3
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732116AbgFWAhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:37:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58310 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731967AbgFWAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:37:04 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N0akow029800
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:37:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=y6unUCc7oaozRSFNhcNylAAHdEoE8d8GZzeuQJp4dL8=;
 b=LyChJUh7/psgJacrADennPDbnRwh0mVx9AAwE66C5BZb/co9owVic5dqx7OVhUxrWVb8
 4LEzfYe1/gh08dcEoiKrL6KmQNBUEZFNvQ6CQB824OOB+QnNNL3fZJcTLC4G1Nv1vd12
 ZdHfQWD8/EjrNLq9H8wXbB6JDpUz8jxaV9s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31t2qq0bkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:37:04 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 17:36:31 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 92C1F3704FDA; Mon, 22 Jun 2020 17:36:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 02/15] net: bpf: implement bpf iterator for tcp
Date:   Mon, 22 Jun 2020 17:36:27 -0700
Message-ID: <20200623003627.3073022-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623003626.3072825-1-yhs@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 adultscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=952 suspectscore=8 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf iterator for tcp is implemented. Both tcp4 and tcp6
sockets will be traversed. It is up to bpf program to
filter for tcp4 or tcp6 only, or both families of sockets.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/ipv4/tcp_ipv4.c | 123 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 9cb65ee4ec63..ea0df9fd7618 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2613,6 +2613,74 @@ static int tcp4_seq_show(struct seq_file *seq, voi=
d *v)
 	return 0;
 }
=20
+#ifdef CONFIG_BPF_SYSCALL
+struct bpf_iter__tcp {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct sock_common *, sk_common);
+	uid_t uid __aligned(8);
+};
+
+static int tcp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta=
 *meta,
+			     struct sock_common *sk_common, uid_t uid)
+{
+	struct bpf_iter__tcp ctx;
+
+	meta->seq_num--;  /* skip SEQ_START_TOKEN */
+	ctx.meta =3D meta;
+	ctx.sk_common =3D sk_common;
+	ctx.uid =3D uid;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int bpf_iter_tcp_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	struct sock *sk =3D v;
+	uid_t uid;
+
+	if (v =3D=3D SEQ_START_TOKEN)
+		return 0;
+
+	if (sk->sk_state =3D=3D TCP_TIME_WAIT) {
+		uid =3D 0;
+	} else if (sk->sk_state =3D=3D TCP_NEW_SYN_RECV) {
+		const struct request_sock *req =3D v;
+
+		uid =3D from_kuid_munged(seq_user_ns(seq),
+				       sock_i_uid(req->rsk_listener));
+	} else {
+		uid =3D from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
+	}
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, false);
+	return tcp_prog_seq_show(prog, &meta, v, uid);
+}
+
+static void bpf_iter_tcp_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		meta.seq =3D seq;
+		prog =3D bpf_iter_get_info(&meta, true);
+		if (prog)
+			(void)tcp_prog_seq_show(prog, &meta, v, 0);
+	}
+
+	tcp_seq_stop(seq, v);
+}
+
+static const struct seq_operations bpf_iter_tcp_seq_ops =3D {
+	.show		=3D bpf_iter_tcp_seq_show,
+	.start		=3D tcp_seq_start,
+	.next		=3D tcp_seq_next,
+	.stop		=3D bpf_iter_tcp_seq_stop,
+};
+#endif
+
 static const struct seq_operations tcp4_seq_ops =3D {
 	.show		=3D tcp4_seq_show,
 	.start		=3D tcp_seq_start,
@@ -2844,8 +2912,63 @@ static struct pernet_operations __net_initdata tcp=
_sk_ops =3D {
        .exit_batch =3D tcp_sk_exit_batch,
 };
=20
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+DEFINE_BPF_ITER_FUNC(tcp, struct bpf_iter_meta *meta,
+		     struct sock_common *sk_common, uid_t uid)
+
+static int bpf_iter_init_tcp(void *priv_data)
+{
+	struct tcp_iter_state *st =3D priv_data;
+	struct tcp_seq_afinfo *afinfo;
+	int ret;
+
+	afinfo =3D kmalloc(sizeof(*afinfo), GFP_USER | __GFP_NOWARN);
+	if (!afinfo)
+		return -ENOMEM;
+
+	afinfo->family =3D AF_UNSPEC;
+	st->bpf_seq_afinfo =3D afinfo;
+	ret =3D bpf_iter_init_seq_net(priv_data);
+	if (ret)
+		kfree(afinfo);
+	return ret;
+}
+
+static void bpf_iter_fini_tcp(void *priv_data)
+{
+	struct tcp_iter_state *st =3D priv_data;
+
+	kfree(st->bpf_seq_afinfo);
+	bpf_iter_fini_seq_net(priv_data);
+}
+
+static const struct bpf_iter_reg tcp_reg_info =3D {
+	.target			=3D "tcp",
+	.seq_ops		=3D &bpf_iter_tcp_seq_ops,
+	.init_seq_private	=3D bpf_iter_init_tcp,
+	.fini_seq_private	=3D bpf_iter_fini_tcp,
+	.seq_priv_size		=3D sizeof(struct tcp_iter_state),
+	.ctx_arg_info_size	=3D 1,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__tcp, sk_common),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+};
+
+static void __init bpf_iter_register(void)
+{
+	if (bpf_iter_reg_target(&tcp_reg_info))
+		pr_warn("Warning: could not register bpf iterator tcp\n");
+}
+
+#endif
+
 void __init tcp_v4_init(void)
 {
 	if (register_pernet_subsys(&tcp_sk_ops))
 		panic("Failed to create the TCP control socket.\n");
+
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	bpf_iter_register();
+#endif
 }
--=20
2.24.1

