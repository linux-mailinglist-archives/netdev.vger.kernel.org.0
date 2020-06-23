Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FEC205712
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 18:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733095AbgFWQSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 12:18:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733091AbgFWQSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 12:18:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NG4tq0009315
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PcyQGBjNrFqB9bKQ08gCMUupG2FQcpbylHG85Vr+Dl8=;
 b=qKjOsMSO4qZZsrHdqGZ0HvFOKHdZUnMocML6l4KVsiejPIHHmaC4RryA72wmDXQtwXMv
 7b1nJ2dTohmWxPtAcgtjllADe8D8kWdo8J+vEw62C7t2wFhUBKRAB29UVRfZHhP2DaLs
 BPsFNa/GONFhSmLbxL5EnPLOK830myHg1Mo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk26gq2q-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 09:18:51 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 09:18:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E9309370330A; Tue, 23 Jun 2020 09:17:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 08/15] net: bpf: implement bpf iterator for udp
Date:   Tue, 23 Jun 2020 09:17:59 -0700
Message-ID: <20200623161759.2500935-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
References: <20200623161749.2500196-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_10:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=8 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=935 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf iterator for udp is implemented. Both udp4 and udp6
sockets will be traversed. It is up to bpf program to
filter for udp4 or udp6 only, or both families of sockets.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/ipv4/udp.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 90355301b266..31530129f137 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2968,6 +2968,67 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
=20
+#ifdef CONFIG_BPF_SYSCALL
+struct bpf_iter__udp {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct udp_sock *, udp_sk);
+	uid_t uid __aligned(8);
+	int bucket __aligned(8);
+};
+
+static int udp_prog_seq_show(struct bpf_prog *prog, struct bpf_iter_meta=
 *meta,
+			     struct udp_sock *udp_sk, uid_t uid, int bucket)
+{
+	struct bpf_iter__udp ctx;
+
+	meta->seq_num--;  /* skip SEQ_START_TOKEN */
+	ctx.meta =3D meta;
+	ctx.udp_sk =3D udp_sk;
+	ctx.uid =3D uid;
+	ctx.bucket =3D bucket;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int bpf_iter_udp_seq_show(struct seq_file *seq, void *v)
+{
+	struct udp_iter_state *state =3D seq->private;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	struct sock *sk =3D v;
+	uid_t uid;
+
+	if (v =3D=3D SEQ_START_TOKEN)
+		return 0;
+
+	uid =3D from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk));
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, false);
+	return udp_prog_seq_show(prog, &meta, v, uid, state->bucket);
+}
+
+static void bpf_iter_udp_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		meta.seq =3D seq;
+		prog =3D bpf_iter_get_info(&meta, true);
+		if (prog)
+			(void)udp_prog_seq_show(prog, &meta, v, 0, 0);
+	}
+
+	udp_seq_stop(seq, v);
+}
+
+static const struct seq_operations bpf_iter_udp_seq_ops =3D {
+	.start		=3D udp_seq_start,
+	.next		=3D udp_seq_next,
+	.stop		=3D bpf_iter_udp_seq_stop,
+	.show		=3D bpf_iter_udp_seq_show,
+};
+#endif
+
 const struct seq_operations udp_seq_ops =3D {
 	.start		=3D udp_seq_start,
 	.next		=3D udp_seq_next,
@@ -3085,6 +3146,57 @@ static struct pernet_operations __net_initdata udp=
_sysctl_ops =3D {
 	.init	=3D udp_sysctl_init,
 };
=20
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+DEFINE_BPF_ITER_FUNC(udp, struct bpf_iter_meta *meta,
+		     struct udp_sock *udp_sk, uid_t uid, int bucket)
+
+static int bpf_iter_init_udp(void *priv_data)
+{
+	struct udp_iter_state *st =3D priv_data;
+	struct udp_seq_afinfo *afinfo;
+	int ret;
+
+	afinfo =3D kmalloc(sizeof(*afinfo), GFP_USER | __GFP_NOWARN);
+	if (!afinfo)
+		return -ENOMEM;
+
+	afinfo->family =3D AF_UNSPEC;
+	afinfo->udp_table =3D &udp_table;
+	st->bpf_seq_afinfo =3D afinfo;
+	ret =3D bpf_iter_init_seq_net(priv_data);
+	if (ret)
+		kfree(afinfo);
+	return ret;
+}
+
+static void bpf_iter_fini_udp(void *priv_data)
+{
+	struct udp_iter_state *st =3D priv_data;
+
+	kfree(st->bpf_seq_afinfo);
+	bpf_iter_fini_seq_net(priv_data);
+}
+
+static const struct bpf_iter_reg udp_reg_info =3D {
+	.target			=3D "udp",
+	.seq_ops		=3D &bpf_iter_udp_seq_ops,
+	.init_seq_private	=3D bpf_iter_init_udp,
+	.fini_seq_private	=3D bpf_iter_fini_udp,
+	.seq_priv_size		=3D sizeof(struct udp_iter_state),
+	.ctx_arg_info_size	=3D 1,
+	.ctx_arg_info		=3D {
+		{ offsetof(struct bpf_iter__udp, udp_sk),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+};
+
+static void __init bpf_iter_register(void)
+{
+	if (bpf_iter_reg_target(&udp_reg_info))
+		pr_warn("Warning: could not register bpf iterator udp\n");
+}
+#endif
+
 void __init udp_init(void)
 {
 	unsigned long limit;
@@ -3110,4 +3222,8 @@ void __init udp_init(void)
=20
 	if (register_pernet_subsys(&udp_sysctl_ops))
 		panic("UDP: failed to init sysctl parameters.\n");
+
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	bpf_iter_register();
+#endif
 }
--=20
2.24.1

