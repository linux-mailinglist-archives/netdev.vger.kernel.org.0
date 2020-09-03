Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBBF25CB0C
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgICUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:37:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4514 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729367AbgICUgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:36:39 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083KXwpU024408
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 13:36:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=MiczCUjJP+mDErPRkrKiAo6ygEJxf8lU83YjhVfkdU8=;
 b=QID1IJZVc3sg4PGWEb5KxIfEiSaxD9UdCN0nPKldBdKcOv9tn/N1nQV5EbsUlrWhTixd
 yUBmeHwMS5ORZG8H+HhnQLzMr7D65281e8sjfy96mC1mU6Y/h1xWUuk5gpNDoWxUdPmY
 C7WosZQQpE5c7hFQkO6hyDvSv+FNuBWix24= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33879p1thf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:36:38 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 13:36:11 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 79A652EC6814; Thu,  3 Sep 2020 13:36:09 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v3 bpf-next 12/14] selftests/bpf: add subprogs to pyperf, strobemeta, and l4lb_noinline tests
Date:   Thu, 3 Sep 2020 13:35:40 -0700
Message-ID: <20200903203542.15944-13-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200903203542.15944-1-andriin@fb.com>
References: <20200903203542.15944-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add use of non-inlined subprogs to few bigger selftests to excercise libb=
pf's
bpf2bpf handling logic. Also split l4lb_all selftest into two sub-tests.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/bpf_verif_scale.c          |  4 ++
 .../selftests/bpf/prog_tests/l4lb_all.c       |  9 ++--
 tools/testing/selftests/bpf/progs/pyperf.h    | 11 ++++-
 .../selftests/bpf/progs/pyperf_subprogs.c     |  5 +++
 .../testing/selftests/bpf/progs/strobemeta.h  | 30 ++++++++++----
 .../selftests/bpf/progs/strobemeta_subprogs.c | 10 +++++
 .../selftests/bpf/progs/test_l4lb_noinline.c  | 41 +++++++++----------
 7 files changed, 73 insertions(+), 37 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_subprogs=
.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c b/t=
ools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
index e9f2f12ba06b..e698ee6bb6c2 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_verif_scale.c
@@ -49,6 +49,7 @@ void test_bpf_verif_scale(void)
 		{ "test_verif_scale3.o", BPF_PROG_TYPE_SCHED_CLS },
=20
 		{ "pyperf_global.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+		{ "pyperf_subprogs.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
=20
 		/* full unroll by llvm */
 		{ "pyperf50.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
@@ -86,6 +87,9 @@ void test_bpf_verif_scale(void)
 		{ "strobemeta_nounroll1.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
 		{ "strobemeta_nounroll2.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
=20
+		/* non-inlined subprogs */
+		{ "strobemeta_subprogs.o", BPF_PROG_TYPE_RAW_TRACEPOINT },
+
 		{ "test_sysctl_loop1.o", BPF_PROG_TYPE_CGROUP_SYSCTL },
 		{ "test_sysctl_loop2.o", BPF_PROG_TYPE_CGROUP_SYSCTL },
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/te=
sting/selftests/bpf/prog_tests/l4lb_all.c
index c2d373e294bb..8073105548ff 100644
--- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
+++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
@@ -80,9 +80,8 @@ static void test_l4lb(const char *file)
=20
 void test_l4lb_all(void)
 {
-	const char *file1 =3D "./test_l4lb.o";
-	const char *file2 =3D "./test_l4lb_noinline.o";
-
-	test_l4lb(file1);
-	test_l4lb(file2);
+	if (test__start_subtest("l4lb_inline"))
+		test_l4lb("test_l4lb.o");
+	if (test__start_subtest("l4lb_noinline"))
+		test_l4lb("test_l4lb_noinline.o");
 }
diff --git a/tools/testing/selftests/bpf/progs/pyperf.h b/tools/testing/s=
elftests/bpf/progs/pyperf.h
index cc615b82b56e..2fb7adafb6b6 100644
--- a/tools/testing/selftests/bpf/progs/pyperf.h
+++ b/tools/testing/selftests/bpf/progs/pyperf.h
@@ -67,7 +67,12 @@ typedef struct {
 	void* co_name; // PyCodeObject.co_name
 } FrameData;
=20
-static __always_inline void *get_thread_state(void *tls_base, PidData *p=
idData)
+#ifdef SUBPROGS
+__noinline
+#else
+__always_inline
+#endif
+static void *get_thread_state(void *tls_base, PidData *pidData)
 {
 	void* thread_state;
 	int key;
@@ -155,7 +160,9 @@ struct {
 } stackmap SEC(".maps");
=20
 #ifdef GLOBAL_FUNC
-__attribute__((noinline))
+__noinline
+#elif defined(SUBPROGS)
+static __noinline
 #else
 static __always_inline
 #endif
diff --git a/tools/testing/selftests/bpf/progs/pyperf_subprogs.c b/tools/=
testing/selftests/bpf/progs/pyperf_subprogs.c
new file mode 100644
index 000000000000..60e27a7f0cca
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/pyperf_subprogs.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define STACK_MAX_LEN 50
+#define SUBPROGS
+#include "pyperf.h"
diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testi=
ng/selftests/bpf/progs/strobemeta.h
index ad61b722a9de..7de534f38c3f 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -266,8 +266,12 @@ struct tls_index {
 	uint64_t offset;
 };
=20
-static __always_inline void *calc_location(struct strobe_value_loc *loc,
-					   void *tls_base)
+#ifdef SUBPROGS
+__noinline
+#else
+__always_inline
+#endif
+static void *calc_location(struct strobe_value_loc *loc, void *tls_base)
 {
 	/*
 	 * tls_mode value is:
@@ -327,10 +331,15 @@ static __always_inline void *calc_location(struct s=
trobe_value_loc *loc,
 		: NULL;
 }
=20
-static __always_inline void read_int_var(struct strobemeta_cfg *cfg,
-					 size_t idx, void *tls_base,
-					 struct strobe_value_generic *value,
-					 struct strobemeta_payload *data)
+#ifdef SUBPROGS
+__noinline
+#else
+__always_inline
+#endif
+static void read_int_var(struct strobemeta_cfg *cfg,
+			 size_t idx, void *tls_base,
+			 struct strobe_value_generic *value,
+			 struct strobemeta_payload *data)
 {
 	void *location =3D calc_location(&cfg->int_locs[idx], tls_base);
 	if (!location)
@@ -440,8 +449,13 @@ static __always_inline void *read_map_var(struct str=
obemeta_cfg *cfg,
  * read_strobe_meta returns NULL, if no metadata was read; otherwise ret=
urns
  * pointer to *right after* payload ends
  */
-static __always_inline void *read_strobe_meta(struct task_struct *task,
-					      struct strobemeta_payload *data)
+#ifdef SUBPROGS
+__noinline
+#else
+__always_inline
+#endif
+static void *read_strobe_meta(struct task_struct *task,
+			      struct strobemeta_payload *data)
 {
 	pid_t pid =3D bpf_get_current_pid_tgid() >> 32;
 	struct strobe_value_generic value =3D {0};
diff --git a/tools/testing/selftests/bpf/progs/strobemeta_subprogs.c b/to=
ols/testing/selftests/bpf/progs/strobemeta_subprogs.c
new file mode 100644
index 000000000000..b6c01f8fc559
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/strobemeta_subprogs.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+// Copyright (c) 2019 Facebook
+
+#define STROBE_MAX_INTS 2
+#define STROBE_MAX_STRS 25
+#define STROBE_MAX_MAPS 13
+#define STROBE_MAX_MAP_ENTRIES 20
+#define NO_UNROLL
+#define SUBPROGS
+#include "strobemeta.h"
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c b/too=
ls/testing/selftests/bpf/progs/test_l4lb_noinline.c
index 28351936a438..b9e2753f4f91 100644
--- a/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline.c
@@ -17,9 +17,7 @@
 #include "test_iptunnel_common.h"
 #include <bpf/bpf_endian.h>
=20
-int _version SEC("version") =3D 1;
-
-static __u32 rol32(__u32 word, unsigned int shift)
+static __always_inline __u32 rol32(__u32 word, unsigned int shift)
 {
 	return (word << shift) | (word >> ((-shift) & 31));
 }
@@ -52,7 +50,7 @@ static __u32 rol32(__u32 word, unsigned int shift)
=20
 typedef unsigned int u32;
=20
-static u32 jhash(const void *key, u32 length, u32 initval)
+static __noinline u32 jhash(const void *key, u32 length, u32 initval)
 {
 	u32 a, b, c;
 	const unsigned char *k =3D key;
@@ -88,7 +86,7 @@ static u32 jhash(const void *key, u32 length, u32 initv=
al)
 	return c;
 }
=20
-static u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
+static __noinline u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
 {
 	a +=3D initval;
 	b +=3D initval;
@@ -97,7 +95,7 @@ static u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 init=
val)
 	return c;
 }
=20
-static u32 jhash_2words(u32 a, u32 b, u32 initval)
+static __noinline u32 jhash_2words(u32 a, u32 b, u32 initval)
 {
 	return __jhash_nwords(a, b, 0, initval + JHASH_INITVAL + (2 << 2));
 }
@@ -200,8 +198,7 @@ struct {
 	__type(value, struct ctl_value);
 } ctl_array SEC(".maps");
=20
-static __u32 get_packet_hash(struct packet_description *pckt,
-			     bool ipv6)
+static __noinline __u32 get_packet_hash(struct packet_description *pckt,=
 bool ipv6)
 {
 	if (ipv6)
 		return jhash_2words(jhash(pckt->srcv6, 16, MAX_VIPS),
@@ -210,10 +207,10 @@ static __u32 get_packet_hash(struct packet_descript=
ion *pckt,
 		return jhash_2words(pckt->src, pckt->ports, CH_RINGS_SIZE);
 }
=20
-static bool get_packet_dst(struct real_definition **real,
-			   struct packet_description *pckt,
-			   struct vip_meta *vip_info,
-			   bool is_ipv6)
+static __noinline bool get_packet_dst(struct real_definition **real,
+				      struct packet_description *pckt,
+				      struct vip_meta *vip_info,
+				      bool is_ipv6)
 {
 	__u32 hash =3D get_packet_hash(pckt, is_ipv6);
 	__u32 key =3D RING_SIZE * vip_info->vip_num + hash % RING_SIZE;
@@ -233,8 +230,8 @@ static bool get_packet_dst(struct real_definition **r=
eal,
 	return true;
 }
=20
-static int parse_icmpv6(void *data, void *data_end, __u64 off,
-			struct packet_description *pckt)
+static __noinline int parse_icmpv6(void *data, void *data_end, __u64 off=
,
+				   struct packet_description *pckt)
 {
 	struct icmp6hdr *icmp_hdr;
 	struct ipv6hdr *ip6h;
@@ -255,8 +252,8 @@ static int parse_icmpv6(void *data, void *data_end, _=
_u64 off,
 	return TC_ACT_UNSPEC;
 }
=20
-static int parse_icmp(void *data, void *data_end, __u64 off,
-		      struct packet_description *pckt)
+static __noinline int parse_icmp(void *data, void *data_end, __u64 off,
+				 struct packet_description *pckt)
 {
 	struct icmphdr *icmp_hdr;
 	struct iphdr *iph;
@@ -280,8 +277,8 @@ static int parse_icmp(void *data, void *data_end, __u=
64 off,
 	return TC_ACT_UNSPEC;
 }
=20
-static bool parse_udp(void *data, __u64 off, void *data_end,
-		      struct packet_description *pckt)
+static __noinline bool parse_udp(void *data, __u64 off, void *data_end,
+				 struct packet_description *pckt)
 {
 	struct udphdr *udp;
 	udp =3D data + off;
@@ -299,8 +296,8 @@ static bool parse_udp(void *data, __u64 off, void *da=
ta_end,
 	return true;
 }
=20
-static bool parse_tcp(void *data, __u64 off, void *data_end,
-		      struct packet_description *pckt)
+static __noinline bool parse_tcp(void *data, __u64 off, void *data_end,
+				 struct packet_description *pckt)
 {
 	struct tcphdr *tcp;
=20
@@ -321,8 +318,8 @@ static bool parse_tcp(void *data, __u64 off, void *da=
ta_end,
 	return true;
 }
=20
-static int process_packet(void *data, __u64 off, void *data_end,
-			  bool is_ipv6, struct __sk_buff *skb)
+static __noinline int process_packet(void *data, __u64 off, void *data_e=
nd,
+				     bool is_ipv6, struct __sk_buff *skb)
 {
 	void *pkt_start =3D (void *)(long)skb->data;
 	struct packet_description pckt =3D {};
--=20
2.24.1

