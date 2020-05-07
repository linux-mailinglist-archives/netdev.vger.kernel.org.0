Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0941E1C81B8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgEGFju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:39:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726860AbgEGFjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0475aYkt004112
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UL9pPmxvQSQnGK4qze3xgwcoPV2INB5WNr5tIDwGFM0=;
 b=VqyovhXR2Le7bF2lIuNgm3/T2/bACmUNlX9gAxjr4AmpNGGuS9i/wW0V2J0jANtGZfMs
 FfiitruITEcBijdyk0GNLw1fOHC3NWwJjTGTedCRmS3gGuJqKdyYNrE72bsZs0Lspo42
 hWmLivU5q8pzQd46YKtDreea09eXD7IHsB8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30up69eddc-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:38 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:30 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C0C1B3701BB3; Wed,  6 May 2020 22:39:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 10/21] net: bpf: add netlink and ipv6_route bpf_iter targets
Date:   Wed, 6 May 2020 22:39:26 -0700
Message-ID: <20200507053926.1543403-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added netlink and ipv6_route targets, using
the same seq_ops (except show() and minor changes for stop())
for /proc/net/{netlink,ipv6_route}.

The net namespace for these targets are the current net
namespace at file open stage, similar to
/proc/net/{netlink,ipv6_route} reference counting
the net namespace at seq_file open stage.

Since module is not supported for now, ipv6_route is
supported only if the IPV6 is built-in, i.e., not compiled
as a module. The restriction can be lifted once module
is properly supported for bpf_iter.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 fs/proc/proc_net.c       | 19 +++++++++
 include/linux/proc_fs.h  |  3 ++
 net/ipv6/ip6_fib.c       | 65 +++++++++++++++++++++++++++++-
 net/ipv6/route.c         | 37 +++++++++++++++++
 net/netlink/af_netlink.c | 87 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 207 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 4888c5224442..dba63b2429f0 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -98,6 +98,25 @@ static const struct proc_ops proc_net_seq_ops =3D {
 	.proc_release	=3D seq_release_net,
 };
=20
+int bpf_iter_init_seq_net(void *priv_data)
+{
+#ifdef CONFIG_NET_NS
+	struct seq_net_private *p =3D priv_data;
+
+	p->net =3D get_net(current->nsproxy->net_ns);
+#endif
+	return 0;
+}
+
+void bpf_iter_fini_seq_net(void *priv_data)
+{
+#ifdef CONFIG_NET_NS
+	struct seq_net_private *p =3D priv_data;
+
+	put_net(p->net);
+#endif
+}
+
 struct proc_dir_entry *proc_create_net_data(const char *name, umode_t mo=
de,
 		struct proc_dir_entry *parent, const struct seq_operations *ops,
 		unsigned int state_size, void *data)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 45c05fd9c99d..03953c59807d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -105,6 +105,9 @@ struct proc_dir_entry *proc_create_net_single_write(c=
onst char *name, umode_t mo
 						    void *data);
 extern struct pid *tgid_pidfd_to_pid(const struct file *file);
=20
+extern int bpf_iter_init_seq_net(void *priv_data);
+extern void bpf_iter_fini_seq_net(void *priv_data);
+
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 /*
  * The architecture which selects CONFIG_PROC_PID_ARCH_STATUS must
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 46ed56719476..a1fcc0ca21af 100644
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
@@ -2637,6 +2637,67 @@ static void ipv6_route_seq_stop(struct seq_file *s=
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
+static int ipv6_route_prog_seq_show(struct bpf_prog *prog,
+				    struct bpf_iter_meta *meta,
+				    void *v)
+{
+	struct bpf_iter__ipv6_route ctx;
+
+	ctx.meta =3D meta;
+	ctx.rt =3D v;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int ipv6_route_seq_show(struct seq_file *seq, void *v)
+{
+	struct ipv6_route_iter *iter =3D seq->private;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+	int ret;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, false);
+	if (!prog)
+		return ipv6_route_native_seq_show(seq, v);
+
+	ret =3D ipv6_route_prog_seq_show(prog, &meta, v);
+	iter->w.leaf =3D NULL;
+
+	return ret;
+}
+
+static void ipv6_route_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		meta.seq =3D seq;
+		prog =3D bpf_iter_get_info(&meta, true);
+		if (prog)
+			(void)ipv6_route_prog_seq_show(prog, &meta, v);
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
index 3912aac7854d..25f6d3e619d0 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6393,6 +6393,30 @@ void __init ip6_route_init_special_entries(void)
   #endif
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+DEFINE_BPF_ITER_FUNC(ipv6_route, struct bpf_iter_meta *meta, struct fib6=
_info *rt)
+
+static int __init bpf_iter_register(void)
+{
+	struct bpf_iter_reg reg_info =3D {
+		.target			=3D "ipv6_route",
+		.seq_ops		=3D &ipv6_route_seq_ops,
+		.init_seq_private	=3D bpf_iter_init_seq_net,
+		.fini_seq_private	=3D bpf_iter_fini_seq_net,
+		.seq_priv_size		=3D sizeof(struct ipv6_route_iter),
+	};
+
+	return bpf_iter_reg_target(&reg_info);
+}
+
+static void bpf_iter_unregister(void)
+{
+	bpf_iter_unreg_target("ipv6_route");
+}
+#endif
+#endif
+
 int __init ip6_route_init(void)
 {
 	int ret;
@@ -6455,6 +6479,14 @@ int __init ip6_route_init(void)
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
@@ -6487,6 +6519,11 @@ int __init ip6_route_init(void)
=20
 void ip6_route_cleanup(void)
 {
+#if IS_BUILTIN(CONFIG_IPV6)
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	bpf_iter_unregister();
+#endif
+#endif
 	unregister_netdevice_notifier(&ip6_route_dev_notifier);
 	unregister_pernet_subsys(&ip6_route_net_late_ops);
 	fib6_rules_cleanup();
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5ded01ca8b20..33cda9baa979 100644
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
@@ -2634,6 +2634,68 @@ static int netlink_seq_show(struct seq_file *seq, =
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
+DEFINE_BPF_ITER_FUNC(netlink, struct bpf_iter_meta *meta, struct netlink=
_sock *sk)
+
+static int netlink_prog_seq_show(struct bpf_prog *prog,
+				  struct bpf_iter_meta *meta,
+				  void *v)
+{
+	struct bpf_iter__netlink ctx;
+
+	meta->seq_num--;  /* skip SEQ_START_TOKEN */
+	ctx.meta =3D meta;
+	ctx.sk =3D nlk_sk((struct sock *)v);
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int netlink_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq =3D seq;
+	prog =3D bpf_iter_get_info(&meta, false);
+	if (!prog)
+		return netlink_native_seq_show(seq, v);
+
+	if (v !=3D SEQ_START_TOKEN)
+		return netlink_prog_seq_show(prog, &meta, v);
+
+	return 0;
+}
+
+static void netlink_seq_stop(struct seq_file *seq, void *v)
+{
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	if (!v) {
+		meta.seq =3D seq;
+		prog =3D bpf_iter_get_info(&meta, true);
+		if (prog)
+			(void)netlink_prog_seq_show(prog, &meta, v);
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
@@ -2740,6 +2802,21 @@ static const struct rhashtable_params netlink_rhas=
htable_params =3D {
 	.automatic_shrinking =3D true,
 };
=20
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+static int __init bpf_iter_register(void)
+{
+	struct bpf_iter_reg reg_info =3D {
+		.target			=3D "netlink",
+		.seq_ops		=3D &netlink_seq_ops,
+		.init_seq_private	=3D bpf_iter_init_seq_net,
+		.fini_seq_private	=3D bpf_iter_fini_seq_net,
+		.seq_priv_size		=3D sizeof(struct nl_seq_iter),
+	};
+
+	return bpf_iter_reg_target(&reg_info);
+}
+#endif
+
 static int __init netlink_proto_init(void)
 {
 	int i;
@@ -2748,6 +2825,12 @@ static int __init netlink_proto_init(void)
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

