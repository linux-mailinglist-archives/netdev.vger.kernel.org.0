Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE532045BF
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731970AbgFWAhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:37:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54180 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731748AbgFWAgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:36:48 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N0aK0K029149
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:36:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3WJmBObGj969FT9Qa7gmTEdu/9pK3YV6Io3HAzJZ4zc=;
 b=KJhpkeSxKL2yFxzc2URg921lab/mZfnjdjM6O0Q16PPECwFofkIbd2p5bZjcN3428A4t
 6oc7aMJuTUppw2zHqujPazxuc+dS7Sj+IwTLoCM7Jm81TLTdqd+VnG7cCMx4tRwIfl9n
 a8P4+c9nsH4H8FDfgwva2sMVVSXOfVubZjA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31sfyku4bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:36:47 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 17:36:45 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 91D7F3705002; Mon, 22 Jun 2020 17:36:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 14/15] tools/bpf: add udp4/udp6 bpf iterator
Date:   Mon, 22 Jun 2020 17:36:42 -0700
Message-ID: <20200623003642.3075027-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623003626.3072825-1-yhs@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 adultscore=0 cotscore=-2147483648 impostorscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On my VM, I got identical results between /proc/net/udp[6] and
the udp{4,6} bpf iterator.

For udp6:
  $ cat /sys/fs/bpf/p1
    sl  local_address                         remote_address             =
           st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode=
 ref pointer drops
   1405: 000080FE00000000FF7CC4D0D9EFE4FE:0222 00000000000000000000000000=
000000:0000 07 00000000:00000000 00:00000000 00000000   193        0 1918=
3 2 0000000029eab111 0
  $ cat /proc/net/udp6
    sl  local_address                         remote_address             =
           st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode=
 ref pointer drops
   1405: 000080FE00000000FF7CC4D0D9EFE4FE:0222 00000000000000000000000000=
000000:0000 07 00000000:00000000 00:00000000 00000000   193        0 1918=
3 2 0000000029eab111 0

For udp4:
  $ cat /sys/fs/bpf/p4
    sl  local_address rem_address   st tx_queue rx_queue tr tm->when retr=
nsmt   uid  timeout inode ref pointer drops
   2007: 00000000:1F90 00000000:0000 07 00000000:00000000 00:00000000 000=
00000     0        0 72540 2 000000004ede477a 0
  $ cat /proc/net/udp
    sl  local_address rem_address   st tx_queue rx_queue tr tm->when retr=
nsmt   uid  timeout inode ref pointer drops
   2007: 00000000:1F90 00000000:0000 07 00000000:00000000 00:00000000 000=
00000     0        0 72540 2 000000004ede477a 0
---
 tools/testing/selftests/bpf/progs/bpf_iter.h  | 16 ++++
 .../selftests/bpf/progs/bpf_iter_udp4.c       | 71 +++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_udp6.c       | 79 +++++++++++++++++++
 3 files changed, 166 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter.h b/tools/testing=
/selftests/bpf/progs/bpf_iter.h
index ab3ed904d391..d2b9e26efbe0 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter.h
+++ b/tools/testing/selftests/bpf/progs/bpf_iter.h
@@ -9,6 +9,8 @@
 #define bpf_iter__task_file bpf_iter__task_file___not_used
 #define bpf_iter__tcp bpf_iter__tcp___not_used
 #define tcp6_sock tcp6_sock___not_used
+#define bpf_iter__udp bpf_iter__udp___not_used
+#define udp6_sock udp6_sock___not_used
 #include "vmlinux.h"
 #undef bpf_iter_meta
 #undef bpf_iter__bpf_map
@@ -18,6 +20,8 @@
 #undef bpf_iter__task_file
 #undef bpf_iter__tcp
 #undef tcp6_sock
+#undef bpf_iter__udp
+#undef udp6_sock
=20
 struct bpf_iter_meta {
 	struct seq_file *seq;
@@ -62,3 +66,15 @@ struct tcp6_sock {
 	struct tcp_sock	tcp;
 	struct ipv6_pinfo inet6;
 } __attribute__((preserve_access_index));
+
+struct bpf_iter__udp {
+	struct bpf_iter_meta *meta;
+	struct udp_sock *udp_sk;
+	uid_t uid __attribute__((aligned(8)));
+	int bucket __attribute__((aligned(8)));
+} __attribute__((preserve_access_index));
+
+struct udp6_sock {
+	struct udp_sock	udp;
+	struct ipv6_pinfo inet6;
+} __attribute__((preserve_access_index));
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_udp4.c b/tools/te=
sting/selftests/bpf/progs/bpf_iter_udp4.c
new file mode 100644
index 000000000000..8a06b7f4a05d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_udp4.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_tracing_net.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+static long sock_i_ino(const struct sock *sk)
+{
+	const struct socket *sk_socket =3D sk->sk_socket;
+	const struct inode *inode;
+	unsigned long ino;
+
+	if (!sk_socket)
+		return 0;
+
+	inode =3D &container_of(sk_socket, struct socket_alloc, socket)->vfs_in=
ode;
+	bpf_probe_read(&ino, sizeof(ino), &inode->i_ino);
+	return ino;
+}
+
+SEC("iter/udp")
+int dump_udp4(struct bpf_iter__udp *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct udp_sock *udp_sk =3D ctx->udp_sk;
+	struct inet_sock *inet;
+	__u16 srcp, destp;
+	__be32 dest, src;
+	__u32 seq_num;
+	int rqueue;
+
+	if (udp_sk =3D=3D (void *)0)
+		return 0;
+
+	seq_num =3D ctx->meta->seq_num;
+	if (seq_num =3D=3D 0)
+		BPF_SEQ_PRINTF(seq,
+			       "  sl  local_address rem_address   st tx_queue "
+			       "rx_queue tr tm->when retrnsmt   uid  timeout "
+			       "inode ref pointer drops\n");
+
+	/* filter out udp6 sockets */
+	inet =3D &udp_sk->inet;
+	if (inet->sk.sk_family =3D=3D AF_INET6)
+		return 0;
+
+	inet =3D &udp_sk->inet;
+	dest =3D inet->inet_daddr;
+	src =3D inet->inet_rcv_saddr;
+	srcp =3D bpf_ntohs(inet->inet_sport);
+	destp =3D bpf_ntohs(inet->inet_dport);
+	rqueue =3D inet->sk.sk_rmem_alloc.counter - udp_sk->forward_deficit;
+
+	BPF_SEQ_PRINTF(seq, "%5d: %08X:%04X %08X:%04X ",
+		       ctx->bucket, src, srcp, dest, destp);
+
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK =
%u\n",
+		       inet->sk.sk_state,
+		       inet->sk.sk_wmem_alloc.refs.counter - 1,
+		       rqueue,
+		       0, 0L, 0, ctx->uid, 0,
+		       sock_i_ino(&inet->sk),
+		       inet->sk.sk_refcnt.refs.counter, udp_sk,
+		       inet->sk.sk_drops.counter);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_udp6.c b/tools/te=
sting/selftests/bpf/progs/bpf_iter_udp6.c
new file mode 100644
index 000000000000..f5735baf45aa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_udp6.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_tracing_net.h>
+#include <bpf/bpf_endian.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+#define IPV6_SEQ_DGRAM_HEADER				\
+	"  sl  "					\
+	"local_address                         "	\
+	"remote_address                        "	\
+	"st tx_queue rx_queue tr tm->when retrnsmt"	\
+	"   uid  timeout inode ref pointer drops\n"
+
+static long sock_i_ino(const struct sock *sk)
+{
+	const struct socket *sk_socket =3D sk->sk_socket;
+	const struct inode *inode;
+	unsigned long ino;
+
+	if (!sk_socket)
+		return 0;
+
+	inode =3D &container_of(sk_socket, struct socket_alloc, socket)->vfs_in=
ode;
+	bpf_probe_read(&ino, sizeof(ino), &inode->i_ino);
+	return ino;
+}
+
+SEC("iter/udp")
+int dump_udp6(struct bpf_iter__udp *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct udp_sock *udp_sk =3D ctx->udp_sk;
+	const struct in6_addr *dest, *src;
+	struct udp6_sock *udp6_sk;
+	struct inet_sock *inet;
+	__u16 srcp, destp;
+	__u32 seq_num;
+	int rqueue;
+
+	if (udp_sk =3D=3D (void *)0)
+		return 0;
+
+	seq_num =3D ctx->meta->seq_num;
+	if (seq_num =3D=3D 0)
+		BPF_SEQ_PRINTF(seq, IPV6_SEQ_DGRAM_HEADER);
+
+	udp6_sk =3D bpf_skc_to_udp6_sock(udp_sk);
+	if (udp6_sk =3D=3D (void *)0)
+		return 0;
+
+	inet =3D &udp_sk->inet;
+	srcp =3D bpf_ntohs(inet->inet_sport);
+	destp =3D bpf_ntohs(inet->inet_dport);
+	rqueue =3D inet->sk.sk_rmem_alloc.counter - udp_sk->forward_deficit;
+	dest  =3D &inet->sk.sk_v6_daddr;
+	src   =3D &inet->sk.sk_v6_rcv_saddr;
+
+	BPF_SEQ_PRINTF(seq, "%5d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "=
,
+		       ctx->bucket,
+		       src->s6_addr32[0], src->s6_addr32[1],
+		       src->s6_addr32[2], src->s6_addr32[3], srcp,
+		       dest->s6_addr32[0], dest->s6_addr32[1],
+		       dest->s6_addr32[2], dest->s6_addr32[3], destp);
+
+	BPF_SEQ_PRINTF(seq, "%02X %08X:%08X %02X:%08lX %08X %5u %8d %lu %d %pK =
%u\n",
+		       inet->sk.sk_state,
+		       inet->sk.sk_wmem_alloc.refs.counter - 1,
+		       rqueue,
+		       0, 0L, 0, ctx->uid, 0,
+		       sock_i_ino(&inet->sk),
+		       inet->sk.sk_refcnt.refs.counter, udp_sk,
+		       inet->sk.sk_drops.counter);
+
+	return 0;
+}
--=20
2.24.1

