Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC21AB1B2
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437565AbgDOT3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:29:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30016 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411824AbgDOT23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJSNVA024724
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gnrWsuQzGwdz6NH/Zp1T0ov1gMBeNN41luPHdjqNYYo=;
 b=I59Yp5urd+dUUkHs7QAYP8ZKspkrXSIttcpQMVlWMMNIO7V06TBmb+fin2cBQUwzPplw
 TvK3E7uAwC/Bd9DBb7SKwJVRtJXg2lsT8uQoqlCwmXwXxgRtnI79mqhjDP+l+iacXo08
 LD8oOZjNdwpvzOCLMipRkkZye0Fs6S29utY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7gqkrj-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:27 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:01 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 351353700AF5; Wed, 15 Apr 2020 12:27:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 07/17] bpf: add netlink and ipv6_route targets
Date:   Wed, 15 Apr 2020 12:27:48 -0700
Message-ID: <20200415192748.4083243-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 phishscore=0 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=937 lowpriorityscore=0 suspectscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added netlink and ipv6_route targets, using
the same seq_ops (except show()) for /proc/net/{netlink,ipv6_route}.

Since module is not supported for now, ipv6_route is
supported only if the IPV6 is built-in, i.e., not compiled
as a module. The restriction can be lifted once module
is properly supported for bpfdump.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/linux/bpf.h      |  8 +++-
 kernel/bpf/dump.c        | 13 ++++++
 net/ipv6/ip6_fib.c       | 71 +++++++++++++++++++++++++++++-
 net/ipv6/route.c         | 29 +++++++++++++
 net/netlink/af_netlink.c | 94 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 210 insertions(+), 5 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 1179ca3d0230..401e5bf921a2 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1124,6 +1124,12 @@ struct bpf_dump_reg {
 	u32 target_feature;
 };
=20
+struct bpf_dump_meta {
+	struct seq_file *seq;
+	u64 session_id;
+	u64 seq_num;
+};
+
 int bpf_dump_reg_target(struct bpf_dump_reg *reg_info);
 int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog);
 int bpf_fd_dump_create(u32 prog_fd, const char __user *dumper_name,
@@ -1131,7 +1137,7 @@ int bpf_fd_dump_create(u32 prog_fd, const char __us=
er *dumper_name,
 int bpf_prog_dump_create(struct bpf_prog *prog);
 struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
 				   u64 *session_id, u64 *seq_num, bool is_last);
-
+int bpf_dump_run_prog(struct bpf_prog *prog, void *ctx);
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_hash_update(struct bpf_map *map, void *key, void *value,
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index c6d4d64aaa8e..789b35772a81 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -487,6 +487,19 @@ struct bpf_prog *bpf_dump_get_prog(struct seq_file *=
seq, u32 priv_data_size,
 	return extra_data->prog;
 }
=20
+int bpf_dump_run_prog(struct bpf_prog *prog, void *ctx)
+{
+	int ret;
+
+	migrate_disable();
+	rcu_read_lock();
+	ret =3D BPF_PROG_RUN(prog, ctx);
+	rcu_read_unlock();
+	migrate_enable();
+
+	return ret;
+}
+
 int bpf_dump_reg_target(struct bpf_dump_reg *reg_info)
 {
 	struct bpfdump_target_info *tinfo, *ptinfo;
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 46ed56719476..f5a48511d233 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2467,7 +2467,7 @@ void fib6_gc_cleanup(void)
 }
=20
 #ifdef CONFIG_PROC_FS
-static int ipv6_route_seq_show(struct seq_file *seq, void *v)
+static int ipv6_route_native_seq_show(struct seq_file *seq, void *v)
 {
 	struct fib6_info *rt =3D v;
 	struct ipv6_route_iter *iter =3D seq->private;
@@ -2625,7 +2625,7 @@ static bool ipv6_route_iter_active(struct ipv6_rout=
e_iter *iter)
 	return w->node && !(w->state =3D=3D FWS_U && w->node =3D=3D w->root);
 }
=20
-static void ipv6_route_seq_stop(struct seq_file *seq, void *v)
+static void ipv6_route_native_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU_BH)
 {
 	struct net *net =3D seq_file_net(seq);
@@ -2637,6 +2637,73 @@ static void ipv6_route_seq_stop(struct seq_file *s=
eq, void *v)
 	rcu_read_unlock_bh();
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6) && defined(CONFIG_BPF_SYSCALL)
+struct bpfdump__ipv6_route {
+	struct bpf_dump_meta *meta;
+	struct fib6_info *rt;
+};
+
+static int ipv6_route_prog_seq_show(struct bpf_prog *prog, struct seq_fi=
le *seq,
+				    u64 session_id, u64 seq_num, void *v)
+{
+	struct bpfdump__ipv6_route ctx;
+	struct bpf_dump_meta meta;
+	int ret;
+
+	meta.seq =3D seq;
+	meta.session_id =3D session_id;
+	meta.seq_num =3D seq_num;
+	ctx.meta =3D &meta;
+	ctx.rt =3D v;
+	ret =3D bpf_dump_run_prog(prog, &ctx);
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static int ipv6_route_seq_show(struct seq_file *seq, void *v)
+{
+	struct ipv6_route_iter *iter =3D seq->private;
+	u64 session_id, seq_num;
+	struct bpf_prog *prog;
+	int ret;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct ipv6_route_iter),
+				 &session_id, &seq_num, false);
+	if (!prog)
+		return ipv6_route_native_seq_show(seq, v);
+
+	ret =3D ipv6_route_prog_seq_show(prog, seq, session_id, seq_num, v);
+	iter->w.leaf =3D NULL;
+
+	return ret;
+}
+
+static void ipv6_route_seq_stop(struct seq_file *seq, void *v)
+{
+	u64 session_id, seq_num;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		prog =3D bpf_dump_get_prog(seq, sizeof(struct ipv6_route_iter),
+					 &session_id, &seq_num, true);
+		if (prog)
+			ipv6_route_prog_seq_show(prog, seq, session_id,
+						 seq_num, v);
+	}
+
+	ipv6_route_native_seq_stop(seq, v);
+}
+#else
+static int ipv6_route_seq_show(struct seq_file *seq, void *v)
+{
+	return ipv6_route_native_seq_show(seq, v);
+}
+
+static void ipv6_route_seq_stop(struct seq_file *seq, void *v)
+{
+	ipv6_route_native_seq_stop(seq, v);
+}
+#endif
+
 const struct seq_operations ipv6_route_seq_ops =3D {
 	.start	=3D ipv6_route_seq_start,
 	.next	=3D ipv6_route_seq_next,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 310cbddaa533..ea87d3f2c363 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6390,10 +6390,31 @@ void __init ip6_route_init_special_entries(void)
   #endif
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+int __init __bpfdump__ipv6_route(struct bpf_dump_meta *meta, struct fib6=
_info *rt)
+{
+	return 0;
+}
+#endif
+#endif
+
 int __init ip6_route_init(void)
 {
 	int ret;
 	int cpu;
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	struct bpf_dump_reg reg_info =3D {
+		.target			=3D "ipv6_route",
+		.target_proto		=3D "__bpfdump__ipv6_route",
+		.prog_ctx_type_name	=3D "bpfdump__ipv6_route",
+		.seq_ops		=3D &ipv6_route_seq_ops,
+		.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
+		.target_feature		=3D BPF_DUMP_SEQ_NET_PRIVATE,
+	};
+#endif
+#endif
=20
 	ret =3D -ENOMEM;
 	ip6_dst_ops_template.kmem_cachep =3D
@@ -6452,6 +6473,14 @@ int __init ip6_route_init(void)
 	if (ret)
 		goto out_register_late_subsys;
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	ret =3D bpf_dump_reg_target(&reg_info);
+	if (ret)
+		goto out_register_late_subsys;
+#endif
+#endif
+
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul =3D per_cpu_ptr(&rt6_uncached_list, cpu);
=20
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5ded01ca8b20..fe9a10642c39 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2596,7 +2596,7 @@ static void *netlink_seq_next(struct seq_file *seq,=
 void *v, loff_t *pos)
 	return __netlink_seq_next(seq);
 }
=20
-static void netlink_seq_stop(struct seq_file *seq, void *v)
+static void netlink_native_seq_stop(struct seq_file *seq, void *v)
 {
 	struct nl_seq_iter *iter =3D seq->private;
=20
@@ -2607,7 +2607,7 @@ static void netlink_seq_stop(struct seq_file *seq, =
void *v)
 }
=20
=20
-static int netlink_seq_show(struct seq_file *seq, void *v)
+static int netlink_native_seq_show(struct seq_file *seq, void *v)
 {
 	if (v =3D=3D SEQ_START_TOKEN) {
 		seq_puts(seq,
@@ -2634,6 +2634,80 @@ static int netlink_seq_show(struct seq_file *seq, =
void *v)
 	return 0;
 }
=20
+#ifdef CONFIG_BPF_SYSCALL
+struct bpfdump__netlink {
+	struct bpf_dump_meta *meta;
+	struct netlink_sock *sk;
+};
+
+int __init __bpfdump__netlink(struct bpf_dump_meta *meta, struct netlink=
_sock *sk)
+{
+	return 0;
+}
+
+static int netlink_prog_seq_show(struct bpf_prog *prog, struct seq_file =
*seq,
+				 u64 session_id, u64 seq_num, void *v)
+{
+	struct bpfdump__netlink ctx;
+	struct bpf_dump_meta meta;
+	int ret =3D 0;
+
+	meta.seq =3D seq;
+	meta.session_id =3D session_id;
+	meta.seq_num =3D seq_num;
+	ctx.meta =3D &meta;
+	ctx.sk =3D nlk_sk((struct sock *)v);
+	ret =3D bpf_dump_run_prog(prog, &ctx);
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static int netlink_seq_show(struct seq_file *seq, void *v)
+{
+	u64 session_id, seq_num;
+	struct bpf_prog *prog;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct nl_seq_iter),
+				 &session_id, &seq_num, false);
+	if (!prog)
+		return netlink_native_seq_show(seq, v);
+
+	if (v =3D=3D SEQ_START_TOKEN)
+		return 0;
+
+	return netlink_prog_seq_show(prog, seq, session_id,
+				     seq_num - 1, v);
+}
+
+static void netlink_seq_stop(struct seq_file *seq, void *v)
+{
+	u64 session_id, seq_num;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		prog =3D bpf_dump_get_prog(seq, sizeof(struct nl_seq_iter),
+					 &session_id, &seq_num, true);
+		if (prog) {
+			if (seq_num)
+				seq_num =3D seq_num - 1;
+			netlink_prog_seq_show(prog, seq, session_id,
+					      seq_num, v);
+		}
+	}
+
+	netlink_native_seq_stop(seq, v);
+}
+#else
+static int netlink_seq_show(struct seq_file *seq, void *v)
+{
+	return netlink_native_seq_show(seq, v);
+}
+static void netlink_seq_stop(struct seq_file *seq, void *v)
+{
+	netlink_native_seq_stop(seq, v);
+}
+#endif
+
 static const struct seq_operations netlink_seq_ops =3D {
 	.start  =3D netlink_seq_start,
 	.next   =3D netlink_seq_next,
@@ -2744,6 +2818,16 @@ static int __init netlink_proto_init(void)
 {
 	int i;
 	int err =3D proto_register(&netlink_proto, 0);
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	struct bpf_dump_reg reg_info =3D {
+		.target			=3D "netlink",
+		.target_proto		=3D "__bpfdump__netlink",
+		.prog_ctx_type_name	=3D "bpfdump_netlink",
+		.seq_ops		=3D &netlink_seq_ops,
+		.seq_priv_size		=3D sizeof(struct nl_seq_iter),
+		.target_feature		=3D BPF_DUMP_SEQ_NET_PRIVATE,
+	};
+#endif
=20
 	if (err !=3D 0)
 		goto out;
@@ -2764,6 +2848,12 @@ static int __init netlink_proto_init(void)
 		}
 	}
=20
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	err =3D bpf_dump_reg_target(&reg_info);
+	if (err)
+		goto out;
+#endif
+
 	netlink_add_usersock_entry();
=20
 	sock_register(&netlink_family_ops);
--=20
2.24.1

