Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F641AB1CD
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633261AbgDOTcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:32:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411813AbgDOT2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJOHfb010032
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=vtz+iEaxc6Fy1GjHixGqZQXO5dqMtsDsKmaPLoLivyE=;
 b=S/OC+M95htWHRVaKESqiffMerBL2paUQ5DXGdO9h+dC2k8ox6EN5izSRLD7bbXlppFhk
 BOKJ0zaFCcfNvWHauAOYd2aWo6MKvp7vXHSxSKkMfUBIvJ7KnFPG3ADuta/uzDxnvo9J
 cbkDZSDFkfxh9qx/d33MDAY/9D+OqGIbilY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7fys6q-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:19 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:28:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 1AE933700AF5; Wed, 15 Apr 2020 12:27:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 15/17] tools/bpf: selftests: add dumper programs for ipv6_route and netlink
Date:   Wed, 15 Apr 2020 12:27:58 -0700
Message-ID: <20200415192758.4084048-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two bpf programs are added in this patch for netlink and ipv6_route
target. On my VM, I am able to achieve identical
results compared to /proc/net/netlink and /proc/net/ipv6_route.

  $ cat /proc/net/netlink
  sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks =
   Drops    Inode
  000000002c42d58b 0   0          00000000 0        0        0     2     =
   0        7
  00000000a4e8b5e1 0   1          00000551 0        0        0     2     =
   0        18719
  00000000e1b1c195 4   0          00000000 0        0        0     2     =
   0        16422
  000000007e6b29f9 6   0          00000000 0        0        0     2     =
   0        16424
  ....
  00000000159a170d 15  1862       00000002 0        0        0     2     =
   0        1886
  000000009aca4bc9 15  3918224839 00000002 0        0        0     2     =
   0        19076
  00000000d0ab31d2 15  1          00000002 0        0        0     2     =
   0        18683
  000000008398fb08 16  0          00000000 0        0        0     2     =
   0        27
  $ cat /sys/kernel/bpfdump/netlink/my1
  sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks =
   Drops    Inode
  000000002c42d58b 0   0          00000000 0        0        0     2     =
   0        7
  00000000a4e8b5e1 0   1          00000551 0        0        0     2     =
   0        18719
  00000000e1b1c195 4   0          00000000 0        0        0     2     =
   0        16422
  000000007e6b29f9 6   0          00000000 0        0        0     2     =
   0        16424
  ....
  00000000159a170d 15  1862       00000002 0        0        0     2     =
   0        1886
  000000009aca4bc9 15  3918224839 00000002 0        0        0     2     =
   0        19076
  00000000d0ab31d2 15  1          00000002 0        0        0     2     =
   0        18683
  000000008398fb08 16  0          00000000 0        0        0     2     =
   0        27

  $ cat /proc/net/ipv6_route
  fe800000000000000000000000000000 40 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000100 00000001 00000000 00000001    =
 eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00=
 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200    =
   lo
  00000000000000000000000000000001 80 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000000 00000003 00000000 80200001    =
   lo
  fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000000 00000002 00000000 80200001    =
 eth0
  ff000000000000000000000000000000 08 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000100 00000003 00000000 00000001    =
 eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00=
 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200    =
   lo
  $ cat /sys/kernel/bpfdump/ipv6_route/my1
  fe800000000000000000000000000000 40 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000100 00000001 00000000 00000001    =
 eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00=
 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200    =
   lo
  00000000000000000000000000000001 80 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000000 00000003 00000000 80200001    =
   lo
  fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000000 00000002 00000000 80200001    =
 eth0
  ff000000000000000000000000000000 08 00000000000000000000000000000000 00=
 00000000000000000000000000000000 00000100 00000003 00000000 00000001    =
 eth0
  00000000000000000000000000000000 00 00000000000000000000000000000000 00=
 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200    =
   lo

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/bpfdump_ipv6_route.c  | 71 ++++++++++++++++
 .../selftests/bpf/progs/bpfdump_netlink.c     | 80 +++++++++++++++++++
 2 files changed, 151 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/bpfdump_netlink.c

diff --git a/tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.c b/too=
ls/testing/selftests/bpf/progs/bpfdump_ipv6_route.c
new file mode 100644
index 000000000000..ff187577e2b5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_ipv6_route.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+extern bool CONFIG_IPV6_SUBTREES __kconfig __weak;
+
+#define	RTF_GATEWAY		0x0002
+#define IFNAMSIZ		16
+#define fib_nh_gw_family        nh_common.nhc_gw_family
+#define fib_nh_gw6              nh_common.nhc_gw.ipv6
+#define fib_nh_dev              nh_common.nhc_dev
+
+SEC("dump//sys/kernel/bpfdump/ipv6_route")
+int dump_ipv6_route(struct bpfdump__ipv6_route *ctx)
+{
+	static const char fmt1[] =3D "%pi6 %02x ";
+	static const char fmt2[] =3D "%pi6 ";
+	static const char fmt3[] =3D "00000000000000000000000000000000 ";
+	static const char fmt4[] =3D "%08x %08x ";
+	static const char fmt5[] =3D "%8s\n";
+	static const char fmt6[] =3D "\n";
+	static const char fmt7[] =3D "00000000000000000000000000000000 00 ";
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct fib6_info *rt =3D ctx->rt;
+	const struct net_device *dev;
+	struct fib6_nh *fib6_nh;
+	unsigned int flags;
+	struct nexthop *nh;
+
+	if (rt =3D=3D (void *)0)
+		return 0;
+
+	fib6_nh =3D &rt->fib6_nh[0];
+	flags =3D rt->fib6_flags;
+
+	/* FIXME: nexthop_is_multipath is not handled here. */
+	nh =3D rt->nh;
+	if (rt->nh)
+		fib6_nh =3D &nh->nh_info->fib6_nh;
+
+	bpf_seq_printf(seq, fmt1, sizeof(fmt1), &rt->fib6_dst.addr,
+		       rt->fib6_dst.plen);
+
+	if (CONFIG_IPV6_SUBTREES)
+		bpf_seq_printf(seq, fmt1, sizeof(fmt1), &rt->fib6_src.addr,
+			       rt->fib6_src.plen);
+	else
+		bpf_seq_printf(seq, fmt7, sizeof(fmt7));
+
+	if (fib6_nh->fib_nh_gw_family) {
+		flags |=3D RTF_GATEWAY;
+		bpf_seq_printf(seq, fmt2, sizeof(fmt2), &fib6_nh->fib_nh_gw6);
+	} else {
+		bpf_seq_printf(seq, fmt3, sizeof(fmt3));
+	}
+
+	dev =3D fib6_nh->fib_nh_dev;
+	bpf_seq_printf(seq, fmt4, sizeof(fmt4), rt->fib6_metric, rt->fib6_ref.r=
efs.counter);
+	bpf_seq_printf(seq, fmt4, sizeof(fmt4), 0, flags);
+	if (dev)
+		bpf_seq_printf(seq, fmt5, sizeof(fmt5), dev->name);
+	else
+		bpf_seq_printf(seq, fmt6, sizeof(fmt6));
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpfdump_netlink.c b/tools/=
testing/selftests/bpf/progs/bpfdump_netlink.c
new file mode 100644
index 000000000000..8a1aec0ba7d0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpfdump_netlink.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+#define sk_rmem_alloc	sk_backlog.rmem_alloc
+#define sk_refcnt	__sk_common.skc_refcnt
+
+#define offsetof(TYPE, MEMBER)  ((size_t)&((TYPE *)0)->MEMBER)
+#define container_of(ptr, type, member) ({                              =
\
+        void *__mptr =3D (void *)(ptr);                                 =
  \
+        ((type *)(__mptr - offsetof(type, member))); })
+
+static inline struct inode *SOCK_INODE(struct socket *socket)
+{
+	return &container_of(socket, struct socket_alloc, socket)->vfs_inode;
+}
+
+SEC("dump//sys/kernel/bpfdump/netlink")
+int dump_netlink(struct bpfdump__netlink *ctx)
+{
+	static const char banner[] =3D
+		"sk               Eth Pid        Groups   "
+		"Rmem     Wmem     Dump  Locks    Drops    Inode\n";
+	static const char fmt1[] =3D "%pK %-3d ";
+	static const char fmt2[] =3D "%-10u %08x ";
+	static const char fmt3[] =3D "%-8d %-8d ";
+	static const char fmt4[] =3D "%-5d %-8d ";
+	static const char fmt5[] =3D "%-8u %-8lu\n";
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct netlink_sock *nlk =3D ctx->sk;
+	unsigned long group, ino;
+	struct inode *inode;
+	struct socket *sk;
+	struct sock *s;
+
+	if (nlk =3D=3D (void *)0)
+		return 0;
+
+	if (ctx->meta->seq_num =3D=3D 0)
+		bpf_seq_printf(seq, banner, sizeof(banner));
+
+	s =3D &nlk->sk;
+	bpf_seq_printf(seq, fmt1, sizeof(fmt1), s, s->sk_protocol);
+
+	if (!nlk->groups)  {
+		group =3D 0;
+	} else {
+		/* FIXME: temporary use bpf_probe_read here, needs
+		 * verifier support to do direct access.
+		 */
+		bpf_probe_read(&group, sizeof(group), &nlk->groups[0]);
+	}
+	bpf_seq_printf(seq, fmt2, sizeof(fmt2), nlk->portid, (u32)group);
+
+
+	bpf_seq_printf(seq, fmt3, sizeof(fmt3), s->sk_rmem_alloc.counter,
+		       s->sk_wmem_alloc.refs.counter - 1);
+	bpf_seq_printf(seq, fmt4, sizeof(fmt4), nlk->cb_running,
+		       s->sk_refcnt.refs.counter);
+
+	sk =3D s->sk_socket;
+	if (!sk) {
+		ino =3D 0;
+	} else {
+		/* FIXME: container_of inside SOCK_INODE has a forced
+		 * type conversion, and direct access cannot be used
+		 * with current verifier.
+		 */
+		inode =3D SOCK_INODE(sk);
+		bpf_probe_read(&ino, sizeof(ino), &inode->i_ino);
+	}
+	bpf_seq_printf(seq, fmt5, sizeof(fmt5), s->sk_drops.counter, ino);
+
+	return 0;
+}
--=20
2.24.1

