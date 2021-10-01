Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6AB41F73D
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355884AbhJAWFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:05:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50906 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355852AbhJAWFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:05:16 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191LsUvX027614
        for <netdev@vger.kernel.org>; Fri, 1 Oct 2021 15:03:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8ilL2Sp1Sy3MgZLUpbHqtSDa+22yjEC+ytfeIw7aaLo=;
 b=K+DY/W71xqmR2irzZnpmVbJLKYt3ATb/FsPrggXVnxR/Fnm+86tUDXlcNaqnxzl1ZcR5
 qYARBUyXlvwa6eiOm3DpXmV0NyuRFPZVTxOd0ByH4QAXXUFVVQWYV0UPxlsVYYi+FQvp
 yMZjYTMdZJW/1E9QC21thYIe+LOqQjcAEEI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3be871h2ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 15:03:31 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 15:03:29 -0700
Received: by devbig612.frc2.facebook.com (Postfix, from userid 115148)
        id 11BC5312DE5E; Fri,  1 Oct 2021 15:03:25 -0700 (PDT)
From:   Joanne Koong <joannekoong@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kafai@fb.com>, <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH bpf-next v1 3/3] bpf/selftests: Add xdp bpf_load_tcp_hdr_options tests
Date:   Fri, 1 Oct 2021 14:58:58 -0700
Message-ID: <20211001215858.1132715-4-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001215858.1132715-1-joannekoong@fb.com>
References: <20211001215858.1132715-1-joannekoong@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: iCtdySKQzJiO8J_Tk_3MsPAG621R5hqv
X-Proofpoint-ORIG-GUID: iCtdySKQzJiO8J_Tk_3MsPAG621R5hqv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_05,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 impostorscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests for bpf_load_tcp_hdr_options used by xdp
programs.

test_xdp_tcp_hdr_options.c:
- Tests ipv4 and ipv6 packets with TCPOPT_EXP and non-TCPOPT_EXP
tcp options set. Verify that options can be parsed and loaded
successfully.
- Tests error paths: TCPOPT_EXP with invalid magic, option with
invalid kind_len, non-existent option, invalid flags, option size
smaller than kind_len, invalid packet

Signed-off-by: Joanne Koong <joannekoong@fb.com>
---
 .../bpf/prog_tests/xdp_tcp_hdr_options.c      | 158 ++++++++++++++
 .../bpf/progs/test_xdp_tcp_hdr_options.c      | 198 ++++++++++++++++++
 2 files changed, 356 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_op=
tions.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_op=
tions.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c=
 b/tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c
new file mode 100644
index 000000000000..bd77593fb2dd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_options.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "test_tcp_hdr_options.h"
+#include "test_xdp_tcp_hdr_options.skel.h"
+
+struct xdp_exprm_opt {
+	__u8 kind;
+	__u8 len;
+	__u16 magic;
+	struct bpf_test_option data;
+} __packed;
+
+struct xdp_regular_opt {
+	__u8 kind;
+	__u8 len;
+	struct bpf_test_option data;
+} __packed;
+
+struct xdp_test_opt {
+	struct xdp_exprm_opt exprm_opt;
+	struct xdp_regular_opt regular_opt;
+} __packed;
+
+struct xdp_ipv4_packet {
+	struct ipv4_packet pkt_v4;
+	struct xdp_test_opt test_opt;
+} __packed;
+
+struct xdp_ipv6_packet {
+	struct ipv6_packet pkt_v6;
+	struct xdp_test_opt test_opt;
+} __packed;
+
+static __u8 opt_flags =3D OPTION_MAX_DELACK_MS | OPTION_RAND;
+static __u8 exprm_max_delack_ms =3D 12;
+static __u8 regular_max_delack_ms =3D 21;
+static __u8 exprm_rand =3D 0xfa;
+static __u8 regular_rand =3D 0xce;
+
+static void init_test_opt(struct xdp_test_opt *test_opt,
+			  struct test_xdp_tcp_hdr_options *skel)
+{
+	test_opt->exprm_opt.kind =3D TCPOPT_EXP;
+	/* +1 for kind, +1 for kind-len, +2 for magic, +1 for flags, +1 for
+	 * OPTION_MAX_DELACK_MAX, +1 FOR OPTION_RAND
+	 */
+	test_opt->exprm_opt.len =3D 3 + TCP_BPF_EXPOPT_BASE_LEN;
+	test_opt->exprm_opt.magic =3D __bpf_htons(skel->rodata->test_magic);
+	test_opt->exprm_opt.data.flags =3D opt_flags;
+	test_opt->exprm_opt.data.max_delack_ms =3D exprm_max_delack_ms;
+	test_opt->exprm_opt.data.rand =3D exprm_rand;
+
+	test_opt->regular_opt.kind =3D skel->rodata->test_kind;
+	/* +1 for kind, +1 for kind-len, +1 for flags, +1 FOR
+	 * OPTION_MAX_DELACK_MS, +1 FOR OPTION_RAND
+	 */
+	test_opt->regular_opt.len =3D 5;
+	test_opt->regular_opt.data.flags =3D opt_flags;
+	test_opt->regular_opt.data.max_delack_ms =3D regular_max_delack_ms;
+	test_opt->regular_opt.data.rand =3D regular_rand;
+}
+
+static void check_opt_out(struct test_xdp_tcp_hdr_options *skel)
+{
+	struct bpf_test_option *opt_out;
+	__u32 duration =3D 0;
+
+	opt_out =3D &skel->bss->exprm_opt_out;
+	CHECK(opt_out->flags !=3D opt_flags, "exprm flags",
+	      "flags =3D 0x%x", opt_out->flags);
+	CHECK(opt_out->max_delack_ms !=3D exprm_max_delack_ms, "exprm max_delac=
k_ms",
+	      "max_delack_ms =3D 0x%x", opt_out->max_delack_ms);
+	CHECK(opt_out->rand !=3D exprm_rand, "exprm rand",
+	      "rand =3D 0x%x", opt_out->rand);
+
+	opt_out =3D &skel->bss->regular_opt_out;
+	CHECK(opt_out->flags !=3D opt_flags, "regular flags",
+	      "flags =3D 0x%x", opt_out->flags);
+	CHECK(opt_out->max_delack_ms !=3D regular_max_delack_ms, "regular max_d=
elack_ms",
+	      "max_delack_ms =3D 0x%x", opt_out->max_delack_ms);
+	CHECK(opt_out->rand !=3D regular_rand, "regular rand",
+	      "rand =3D 0x%x", opt_out->rand);
+}
+
+void test_xdp_tcp_hdr_options(void)
+{
+	int err, prog_fd, prog_err_path_fd, prog_invalid_pkt_fd;
+	struct xdp_ipv6_packet ipv6_pkt, invalid_pkt;
+	struct test_xdp_tcp_hdr_options *skel;
+	struct xdp_ipv4_packet ipv4_pkt;
+	struct xdp_test_opt test_opt;
+	__u32 duration, retval, size;
+	char buf[128];
+
+	/* Load XDP program to introspect */
+	skel =3D test_xdp_tcp_hdr_options__open_and_load();
+	if (CHECK(!skel, "skel open and load",
+		  "%s skeleton failed\n", __func__))
+		return;
+
+	prog_fd =3D bpf_program__fd(skel->progs._xdp_load_hdr_opt);
+
+	init_test_opt(&test_opt, skel);
+
+	/* Init the packets */
+	ipv4_pkt.pkt_v4 =3D pkt_v4;
+	ipv4_pkt.pkt_v4.tcp.doff +=3D 3;
+	ipv4_pkt.test_opt =3D test_opt;
+
+	ipv6_pkt.pkt_v6 =3D pkt_v6;
+	ipv6_pkt.pkt_v6.tcp.doff +=3D 3;
+	ipv6_pkt.test_opt =3D test_opt;
+
+	invalid_pkt.pkt_v6 =3D pkt_v6;
+	/* Set to an offset that will exceed the xdp data_end */
+	invalid_pkt.pkt_v6.tcp.doff +=3D 4;
+	invalid_pkt.test_opt =3D test_opt;
+
+	/* Test on ipv4 packet */
+	err =3D bpf_prog_test_run(prog_fd, 1, &ipv4_pkt, sizeof(ipv4_pkt),
+				buf, &size, &retval, &duration);
+	CHECK(err || retval !=3D XDP_PASS,
+	      "xdp_tcp_hdr_options ipv4", "err val %d, retval %d\n",
+	      skel->bss->err_val, retval);
+	check_opt_out(skel);
+
+	/* Test on ipv6 packet */
+	err =3D bpf_prog_test_run(prog_fd, 1, &ipv6_pkt, sizeof(ipv6_pkt),
+				buf, &size, &retval, &duration);
+	CHECK(err || retval !=3D XDP_PASS,
+	      "xdp_tcp_hdr_options ipv6", "err val %d, retval %d\n",
+	      skel->bss->err_val, retval);
+	check_opt_out(skel);
+
+	/* Test error paths */
+	prog_err_path_fd =3D
+		bpf_program__fd(skel->progs._xdp_load_hdr_opt_err_paths);
+	err =3D bpf_prog_test_run(prog_err_path_fd, 1, &ipv6_pkt, sizeof(ipv6_p=
kt),
+				buf, &size, &retval, &duration);
+	CHECK(err || retval !=3D XDP_PASS,
+	      "xdp_tcp_hdr_options err_path", "err val %d, retval %d\n",
+	      skel->bss->err_val, retval);
+
+	/* Test invalid packet */
+	prog_invalid_pkt_fd =3D
+		bpf_program__fd(skel->progs._xdp_load_hdr_opt_invalid_pkt);
+	err =3D bpf_prog_test_run(prog_invalid_pkt_fd, 1, &invalid_pkt,
+				sizeof(invalid_pkt), buf, &size, &retval,
+				&duration);
+	CHECK(err || retval !=3D XDP_PASS,
+	      "xdp_tcp_hdr_options invalid_pkt", "err val %d, retval %d\n",
+	      skel->bss->err_val, retval);
+
+	test_xdp_tcp_hdr_options__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_options.c=
 b/tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_options.c
new file mode 100644
index 000000000000..3fe6e1ebd78a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_options.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <errno.h>
+#include <stdbool.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#define BPF_PROG_TEST_TCP_HDR_OPTIONS
+#include "test_tcp_hdr_options.h"
+
+struct bpf_test_option regular_opt_out;
+struct bpf_test_option exprm_opt_out;
+
+const __u16 test_magic =3D 0xeB9F;
+const __u8 test_kind =3D 0xB9;
+
+int err_val =3D 0;
+
+static void copy_opt_to_out(struct bpf_test_option *test_option, __u8 *d=
ata)
+{
+	test_option->flags =3D data[0];
+	test_option->max_delack_ms =3D data[1];
+	test_option->rand =3D data[2];
+}
+
+static int parse_xdp(struct xdp_md *xdp, __u64 *out_flags)
+{
+	void *data_end =3D (void *)(long)xdp->data_end;
+	__u64 tcphdr_offset =3D 0, nh_off;
+	void *data =3D (void *)(long)xdp->data;
+	struct ethhdr *eth =3D data;
+	int ret;
+
+	nh_off =3D sizeof(*eth);
+	if (data + nh_off > data_end) {
+		err_val =3D 1;
+		return XDP_DROP;
+	}
+
+	/* Calculate the offset to the tcp hdr */
+	if (eth->h_proto =3D=3D __bpf_constant_htons(ETH_P_IPV6)) {
+		tcphdr_offset =3D sizeof(struct ethhdr) +
+			sizeof(struct ipv6hdr);
+	} else if (eth->h_proto =3D=3D bpf_htons(ETH_P_IP)) {
+		tcphdr_offset =3D sizeof(struct ethhdr) +
+			sizeof(struct iphdr);
+	} else {
+		err_val =3D 2;
+		return XDP_DROP;
+	}
+
+	*out_flags =3D tcphdr_offset << BPF_LOAD_HDR_OPT_TCP_OFFSET_SHIFT;
+
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int _xdp_load_hdr_opt(struct xdp_md *xdp)
+{
+	struct tcp_exprm_opt exprm_opt =3D { 0 };
+	struct tcp_opt regular_opt =3D { 0 };
+	__u64 flags =3D 0;
+	int ret;
+
+	ret =3D parse_xdp(xdp, &flags);
+	if (ret !=3D XDP_PASS)
+		return ret;
+
+	/* Test TCPOPT_EXP */
+	exprm_opt.kind =3D TCPOPT_EXP;
+	exprm_opt.len =3D 4;
+	exprm_opt.magic =3D __bpf_htons(test_magic);
+	ret =3D bpf_load_hdr_opt(xdp, &exprm_opt,
+			       sizeof(exprm_opt), flags);
+	if (ret < 0) {
+		err_val =3D 3;
+		return XDP_DROP;
+	}
+
+	copy_opt_to_out(&exprm_opt_out, exprm_opt.data);
+
+	/* Test non-TCP_OPT_EXP */
+	regular_opt.kind =3D test_kind;
+	ret =3D bpf_load_hdr_opt(xdp, &regular_opt,
+			       sizeof(regular_opt), flags);
+	if (ret < 0) {
+		err_val =3D 4;
+		return XDP_DROP;
+	}
+
+	copy_opt_to_out(&regular_opt_out, regular_opt.data);
+
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int _xdp_load_hdr_opt_err_paths(struct xdp_md *xdp)
+{
+	struct tcp_exprm_opt exprm_opt =3D { 0 };
+	struct tcp_opt regular_opt =3D { 0 };
+	__u64 flags =3D 0;
+	int ret;
+
+	ret =3D parse_xdp(xdp, &flags);
+	if (ret !=3D XDP_PASS)
+		return ret;
+
+	/* Test TCPOPT_EXP with invalid magic */
+	exprm_opt.kind =3D TCPOPT_EXP;
+	exprm_opt.len =3D 4;
+	exprm_opt.magic =3D __bpf_htons(test_magic + 1);
+	ret =3D bpf_load_hdr_opt(xdp, &exprm_opt,
+			       sizeof(exprm_opt), flags);
+	if (ret !=3D -ENOMSG) {
+		err_val =3D 3;
+		return XDP_DROP;
+	}
+
+	/* Test TCPOPT_EXP with 0 magic */
+	exprm_opt.magic =3D 0;
+	ret =3D bpf_load_hdr_opt(xdp, &exprm_opt,
+			       sizeof(exprm_opt), flags);
+	if (ret !=3D -ENOMSG) {
+		err_val =3D 4;
+		return XDP_DROP;
+	}
+
+	exprm_opt.magic =3D __bpf_htons(test_magic);
+
+	/* Test TCPOPT_EXP with invalid kind length */
+	exprm_opt.len =3D 5;
+	ret =3D bpf_load_hdr_opt(xdp, &exprm_opt,
+			       sizeof(exprm_opt), flags);
+	if (ret !=3D -EINVAL) {
+		err_val =3D 5;
+		return XDP_DROP;
+	}
+
+	/* Test that non-existent option is not found */
+	regular_opt.kind =3D test_kind + 1;
+	ret =3D bpf_load_hdr_opt(xdp, &regular_opt,
+			       sizeof(regular_opt), flags);
+	if (ret !=3D -ENOMSG) {
+		err_val =3D 6;
+		return XDP_DROP;
+	}
+
+	/* Test invalid flags */
+	regular_opt.kind =3D test_kind;
+	ret =3D bpf_load_hdr_opt(xdp, &regular_opt, sizeof(regular_opt),
+			       flags | BPF_LOAD_HDR_OPT_TCP_SYN);
+	if (ret !=3D -EINVAL) {
+		err_val =3D 7;
+		return XDP_DROP;
+	}
+
+	/* Test non-TCP_OPT_EXP with option size smaller than kind len */
+	ret =3D bpf_load_hdr_opt(xdp, &regular_opt,
+			       sizeof(regular_opt) - 2, flags);
+	if (ret !=3D -ENOSPC) {
+		err_val =3D 8;
+		return XDP_DROP;
+	}
+
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int _xdp_load_hdr_opt_invalid_pkt(struct xdp_md *xdp)
+{
+	struct tcp_exprm_opt exprm_opt =3D { 0 };
+	__u64 flags =3D 0;
+	int ret;
+
+	ret =3D parse_xdp(xdp, &flags);
+	if (ret !=3D XDP_PASS)
+		return ret;
+
+	exprm_opt.kind =3D TCPOPT_EXP;
+	exprm_opt.len =3D 4;
+	exprm_opt.magic =3D __bpf_htons(test_magic);
+	ret =3D bpf_load_hdr_opt(xdp, &exprm_opt,
+			       sizeof(exprm_opt), flags);
+	if (ret !=3D -EINVAL) {
+		err_val =3D 3;
+		return XDP_DROP;
+	}
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.30.2

