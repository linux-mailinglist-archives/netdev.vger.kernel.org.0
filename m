Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F1F1BAF15
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgD0UMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25842 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbgD0UMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:50 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKAjdt025701
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=v5rDzfVwyX/wHdACp0TUPo4JIpTt3i9uf8jqBRhyrYE=;
 b=XsViMWywFNMP0q3xK4QSaeYjIxFJiVrl/UCTd5g6kHGYXJleLc1taUoRCBIjvflk33tT
 KhTb4yVzie5Zg1LFHHQueL3mkNSLD+nBoIxn9CXYIawrXDKbyWCgE83xNWtXmfOL1xTb
 fuq+kOkrt0FmdvoxAwyBnxVgPgh/9BGOFAE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n515t6y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:49 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:48 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 9157E3700871; Mon, 27 Apr 2020 13:12:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 10/19] bpf: add netlink and ipv6_route targets
Date:   Mon, 27 Apr 2020 13:12:46 -0700
Message-ID: <20200427201246.2995471-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added netlink and ipv6_route targets, using
the same seq_ops (except show() and minor changes for stop())
for /proc/net/{netlink,ipv6_route}.

Note that both ipv6_route and netlink have target_feature
set as BPF_DUMP_SEQ_NET_PRIVATE. This is to notify
bpf_iter infrastructure to set net namespace properly
in seq_file private data area.

Since module is not supported for now, ipv6_route is
supported only if the IPV6 is built-in, i.e., not compiled
as a module. The restriction can be lifted once module
is properly supported for bpf_iter.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 net/ipv6/ip6_fib.c       | 71 +++++++++++++++++++++++++++-
 net/ipv6/route.c         | 30 ++++++++++++
 net/netlink/af_netlink.c | 99 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 196 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 46ed56719476..588b5f508b18 100644
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
+struct bpf_iter__ipv6_route {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct fib6_info *, rt);
+};
+
+static int ipv6_route_prog_seq_show(struct bpf_prog *prog, struct seq_fi=
le *seq,
+				    u64 session_id, u64 seq_num, void *v)
+{
+	struct bpf_iter__ipv6_route ctx;
+	struct bpf_iter_meta meta;
+	int ret;
+
+	meta.seq =3D seq;
+	meta.session_id =3D session_id;
+	meta.seq_num =3D seq_num;
+	ctx.meta =3D &meta;
+	ctx.rt =3D v;
+	ret =3D bpf_iter_run_prog(prog, &ctx);
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
+	prog =3D bpf_iter_get_prog(seq, sizeof(struct ipv6_route_iter),
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
+		prog =3D bpf_iter_get_prog(seq, sizeof(struct ipv6_route_iter),
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
index 310cbddaa533..f275a13e2aea 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6390,6 +6390,28 @@ void __init ip6_route_init_special_entries(void)
   #endif
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+int __init __bpf_iter__ipv6_route(struct bpf_iter_meta *meta, struct fib=
6_info *rt)
+{
+	return 0;
+}
+
+static int __init bpf_iter_register(void)
+{
+	struct bpf_iter_reg reg_info =3D {
+		.target			=3D "ipv6_route",
+		.target_func_name	=3D "__bpf_iter__ipv6_route",
+		.seq_ops		=3D &ipv6_route_seq_ops,
+		.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
+		.target_feature		=3D BPF_DUMP_SEQ_NET_PRIVATE,
+	};
+
+	return bpf_iter_reg_target(&reg_info);
+}
+#endif
+#endif
+
 int __init ip6_route_init(void)
 {
 	int ret;
@@ -6452,6 +6474,14 @@ int __init ip6_route_init(void)
 	if (ret)
 		goto out_register_late_subsys;
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	ret =3D bpf_iter_register();
+	if (ret)
+		goto out_register_late_subsys;
+#endif
+#endif
+
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul =3D per_cpu_ptr(&rt6_uncached_list, cpu);
=20
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5ded01ca8b20..b6192cd66801 100644
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
+struct bpf_iter__netlink {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct netlink_sock *, sk);
+};
+
+int __init __bpf_iter__netlink(struct bpf_iter_meta *meta, struct netlin=
k_sock *sk)
+{
+	return 0;
+}
+
+static int netlink_prog_seq_show(struct bpf_prog *prog, struct seq_file =
*seq,
+				 u64 session_id, u64 seq_num, void *v)
+{
+	struct bpf_iter__netlink ctx;
+	struct bpf_iter_meta meta;
+	int ret =3D 0;
+
+	meta.seq =3D seq;
+	meta.session_id =3D session_id;
+	meta.seq_num =3D seq_num;
+	ctx.meta =3D &meta;
+	ctx.sk =3D nlk_sk((struct sock *)v);
+	ret =3D bpf_iter_run_prog(prog, &ctx);
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static int netlink_seq_show(struct seq_file *seq, void *v)
+{
+	u64 session_id, seq_num;
+	struct bpf_prog *prog;
+
+	prog =3D bpf_iter_get_prog(seq, sizeof(struct nl_seq_iter),
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
+		prog =3D bpf_iter_get_prog(seq, sizeof(struct nl_seq_iter),
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
+
+static void netlink_seq_stop(struct seq_file *seq, void *v)
+{
+	netlink_native_seq_stop(seq, v);
+}
+#endif
+
 static const struct seq_operations netlink_seq_ops =3D {
 	.start  =3D netlink_seq_start,
 	.next   =3D netlink_seq_next,
@@ -2740,6 +2814,21 @@ static const struct rhashtable_params netlink_rhas=
htable_params =3D {
 	.automatic_shrinking =3D true,
 };
=20
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+static int __init bpf_iter_register(void)
+{
+	struct bpf_iter_reg reg_info =3D {
+		.target			=3D "netlink",
+		.target_func_name	=3D "__bpf_iter__netlink",
+		.seq_ops		=3D &netlink_seq_ops,
+		.seq_priv_size		=3D sizeof(struct nl_seq_iter),
+		.target_feature		=3D BPF_DUMP_SEQ_NET_PRIVATE,
+	};
+
+	return bpf_iter_reg_target(&reg_info);
+}
+#endif
+
 static int __init netlink_proto_init(void)
 {
 	int i;
@@ -2748,6 +2837,12 @@ static int __init netlink_proto_init(void)
 	if (err !=3D 0)
 		goto out;
=20
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	err =3D bpf_iter_register();
+	if (err)
+		goto out;
+#endif
+
 	BUILD_BUG_ON(sizeof(struct netlink_skb_parms) > sizeof_field(struct sk_=
buff, cb));
=20
 	nl_table =3D kcalloc(MAX_LINKS, sizeof(*nl_table), GFP_KERNEL);
--=20
2.24.1

