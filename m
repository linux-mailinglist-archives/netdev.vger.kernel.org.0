Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7676F1A2C34
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgDHXZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726523AbgDHXZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:33 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 038NO40q001616
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UHdU9NMHMIiQcedlbYCFnHTYqevHA10itfXZRzC+TbU=;
 b=VNYNAmoJUJpiWq4Mo/B9IkxOTodFiNw+MkG0ZbdlGRUAB1D+j1/+KBBpQgprKuOnbVQJ
 RCYgJUv2vV0Ou9je0ZKS1oOOPVx56HurGF33pNnxwvM94zO/Mwx/BqcdrX4vAqrBXFIC
 VW19wJfa4CSmvLLCH7KAkN+aC8JttliiV3w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3091mvy6xf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:32 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:30 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7A66E3700D98; Wed,  8 Apr 2020 16:25:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 06/16] bpf: add netlink and ipv6_route targets
Date:   Wed, 8 Apr 2020 16:25:27 -0700
Message-ID: <20200408232527.2675717-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 phishscore=0 adultscore=0 mlxlogscore=813 lowpriorityscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004080163
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
 include/linux/bpf.h      |  1 +
 kernel/bpf/dump.c        | 13 ++++++++++
 net/ipv6/ip6_fib.c       | 41 +++++++++++++++++++++++++++++-
 net/ipv6/route.c         | 22 ++++++++++++++++
 net/netlink/af_netlink.c | 54 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8171e01ff4be..f7d4269d77b8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1119,6 +1119,7 @@ int bpf_dump_set_target_info(u32 target_fd, struct =
bpf_prog *prog);
 int bpf_dump_create(u32 prog_fd, const char __user *dumper_name);
 struct bpf_prog *bpf_dump_get_prog(struct seq_file *seq, u32 priv_data_s=
ize,
 				   u64 *seq_num);
+int bpf_dump_run_prog(struct bpf_prog *prog, void *ctx);
=20
 int bpf_percpu_hash_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_array_copy(struct bpf_map *map, void *key, void *value);
diff --git a/kernel/bpf/dump.c b/kernel/bpf/dump.c
index ac6856abb711..4e009b2612c2 100644
--- a/kernel/bpf/dump.c
+++ b/kernel/bpf/dump.c
@@ -412,6 +412,19 @@ struct bpf_prog *bpf_dump_get_prog(struct seq_file *=
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
 int bpf_dump_reg_target(const char *target,
 			const char *target_proto,
 			const struct seq_operations *seq_ops,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 46ed56719476..0a8dbdcf5f12 100644
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
@@ -2637,6 +2637,45 @@ static void ipv6_route_seq_stop(struct seq_file *s=
eq, void *v)
 	rcu_read_unlock_bh();
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+static int ipv6_route_prog_seq_show(struct bpf_prog *prog, struct seq_fi=
le *seq,
+				    u64 seq_num, void *v)
+{
+	struct ipv6_route_iter *iter =3D seq->private;
+	struct {
+		struct fib6_info *rt;
+		struct seq_file *seq;
+		u64 seq_num;
+	} ctx =3D {
+		.rt =3D v,
+		.seq =3D seq,
+		.seq_num =3D seq_num,
+	};
+	int ret;
+
+	ret =3D bpf_dump_run_prog(prog, &ctx);
+	iter->w.leaf =3D NULL;
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static int ipv6_route_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_prog *prog;
+	u64 seq_num;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct ipv6_route_iter), &seq_nu=
m);
+	if (!prog)
+		return ipv6_route_native_seq_show(seq, v);
+
+	return ipv6_route_prog_seq_show(prog, seq, seq_num, v);
+}
+#else
+static int ipv6_route_seq_show(struct seq_file *seq, void *v)
+{
+	return ipv6_route_native_seq_show(seq, v);
+}
+#endif
+
 const struct seq_operations ipv6_route_seq_ops =3D {
 	.start	=3D ipv6_route_seq_start,
 	.next	=3D ipv6_route_seq_next,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 310cbddaa533..f3457d9d5a8b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6390,6 +6390,16 @@ void __init ip6_route_init_special_entries(void)
   #endif
 }
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#ifdef CONFIG_PROC_FS
+int __init bpfdump__ipv6_route(struct fib6_info *rt, struct seq_file *se=
q,
+			       u64 seq_num)
+{
+	return 0;
+}
+#endif
+#endif
+
 int __init ip6_route_init(void)
 {
 	int ret;
@@ -6452,6 +6462,18 @@ int __init ip6_route_init(void)
 	if (ret)
 		goto out_register_late_subsys;
=20
+#if IS_BUILTIN(CONFIG_IPV6)
+#ifdef CONFIG_PROC_FS
+	ret =3D bpf_dump_reg_target("ipv6_route",
+				  "bpfdump__ipv6_route",
+				  &ipv6_route_seq_ops,
+				  sizeof(struct ipv6_route_iter),
+				  BPF_DUMP_SEQ_NET_PRIVATE);
+	if (ret)
+		goto out_register_late_subsys;
+#endif
+#endif
+
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul =3D per_cpu_ptr(&rt6_uncached_list, cpu);
=20
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5ded01ca8b20..b6ab827e8d47 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
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
@@ -2634,6 +2634,40 @@ static int netlink_seq_show(struct seq_file *seq, =
void *v)
 	return 0;
 }
=20
+static int netlink_prog_seq_show(struct bpf_prog *prog, struct seq_file =
*seq,
+				 u64 seq_num, void *v)
+{
+	struct {
+		struct netlink_sock *sk;
+		struct seq_file *seq;
+		u64 seq_num;
+	} ctx =3D {
+		.seq =3D seq,
+		.seq_num =3D seq_num - 1,
+	};
+	int ret =3D 0;
+
+	if (v =3D=3D SEQ_START_TOKEN)
+		return 0;
+
+	ctx.sk =3D nlk_sk((struct sock *)v);
+	ret =3D bpf_dump_run_prog(prog, &ctx);
+
+	return ret =3D=3D 0 ? 0 : -EINVAL;
+}
+
+static int netlink_seq_show(struct seq_file *seq, void *v)
+{
+	struct bpf_prog *prog;
+	u64 seq_num;
+
+	prog =3D bpf_dump_get_prog(seq, sizeof(struct nl_seq_iter), &seq_num);
+	if (!prog)
+		return netlink_native_seq_show(seq, v);
+
+	return netlink_prog_seq_show(prog, seq, seq_num, v);
+}
+
 static const struct seq_operations netlink_seq_ops =3D {
 	.start  =3D netlink_seq_start,
 	.next   =3D netlink_seq_next,
@@ -2740,6 +2774,14 @@ static const struct rhashtable_params netlink_rhas=
htable_params =3D {
 	.automatic_shrinking =3D true,
 };
=20
+#ifdef CONFIG_PROC_FS
+int __init bpfdump__netlink(struct netlink_sock *sk, struct seq_file *se=
q,
+			    u64 seq_num)
+{
+	return 0;
+}
+#endif
+
 static int __init netlink_proto_init(void)
 {
 	int i;
@@ -2764,6 +2806,16 @@ static int __init netlink_proto_init(void)
 		}
 	}
=20
+#ifdef CONFIG_PROC_FS
+	err =3D bpf_dump_reg_target("netlink",
+				  "bpfdump__netlink",
+				  &netlink_seq_ops,
+				  sizeof(struct nl_seq_iter),
+				  BPF_DUMP_SEQ_NET_PRIVATE);
+	if (err)
+		goto out;
+#endif
+
 	netlink_add_usersock_entry();
=20
 	sock_register(&netlink_family_ops);
--=20
2.24.1

