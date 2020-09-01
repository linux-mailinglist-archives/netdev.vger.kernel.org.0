Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684EF25856E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgIABuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12608 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727024AbgIABuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0811jMtZ023327
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JzZs6Vkw9eq1xYGBSBFUPRLz3GjP5I0UazzIAYY75HU=;
 b=kYtRY3fLgdoLGLfwoY8ZPCRB2I21cCcJ8cMEvyEqZnuYN4mFl7V9nfRLEEiAXPAo/nsB
 JKGxv/+O8bDtIGJHUbS6YmA6+9tgHvI7etdYqTwrawhQelO9M006OR6v0h3Ue7PpJJ9c
 M/XSzyY1+/jWUg1/AObM/hxyHl/GdVB9LrM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 337mhntysh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:38 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0386F2EC663B; Mon, 31 Aug 2020 18:50:33 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 13/14] selftests/bpf: modernize xdp_noinline test w/ skeleton and __noinline
Date:   Mon, 31 Aug 2020 18:50:02 -0700
Message-ID: <20200901015003.2871861-14-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1015 suspectscore=8 mlxscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update xdp_noinline to use BPF skeleton and force __noinline on helper
sub-programs. Also, split existing logic into v4- and v6-only to complica=
te
sub-program calling patterns (partially overlapped sets of functions for
entry-level BPF programs).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/xdp_noinline.c   | 49 +++++++------------
 .../selftests/bpf/progs/test_xdp_noinline.c   | 36 ++++++++++----
 2 files changed, 43 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c b/tool=
s/testing/selftests/bpf/prog_tests/xdp_noinline.c
index f284f72158ef..a1f06424cf83 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_noinline.c
@@ -1,11 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <network_helpers.h>
+#include "test_xdp_noinline.skel.h"
=20
 void test_xdp_noinline(void)
 {
-	const char *file =3D "./test_xdp_noinline.o";
 	unsigned int nr_cpus =3D bpf_num_possible_cpus();
+	struct test_xdp_noinline *skel;
 	struct vip key =3D {.protocol =3D 6};
 	struct vip_meta {
 		__u32 flags;
@@ -25,58 +26,42 @@ void test_xdp_noinline(void)
 	} real_def =3D {.dst =3D MAGIC_VAL};
 	__u32 ch_key =3D 11, real_num =3D 3;
 	__u32 duration, retval, size;
-	int err, i, prog_fd, map_fd;
+	int err, i;
 	__u64 bytes =3D 0, pkts =3D 0;
-	struct bpf_object *obj;
 	char buf[128];
 	u32 *magic =3D (u32 *)buf;
=20
-	err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
-	if (CHECK_FAIL(err))
+	skel =3D test_xdp_noinline__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load", "failed\n"))
 		return;
=20
-	map_fd =3D bpf_find_map(__func__, obj, "vip_map");
-	if (map_fd < 0)
-		goto out;
-	bpf_map_update_elem(map_fd, &key, &value, 0);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.vip_map), &key, &value, 0);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.ch_rings), &ch_key, &real_nu=
m, 0);
+	bpf_map_update_elem(bpf_map__fd(skel->maps.reals), &real_num, &real_def=
, 0);
=20
-	map_fd =3D bpf_find_map(__func__, obj, "ch_rings");
-	if (map_fd < 0)
-		goto out;
-	bpf_map_update_elem(map_fd, &ch_key, &real_num, 0);
-
-	map_fd =3D bpf_find_map(__func__, obj, "reals");
-	if (map_fd < 0)
-		goto out;
-	bpf_map_update_elem(map_fd, &real_num, &real_def, 0);
-
-	err =3D bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v4, sizeof(pkt_v4),
+	err =3D bpf_prog_test_run(bpf_program__fd(skel->progs.balancer_ingress_=
v4),
+				NUM_ITER, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval !=3D 1 || size !=3D 54 ||
 	      *magic !=3D MAGIC_VAL, "ipv4",
 	      "err %d errno %d retval %d size %d magic %x\n",
 	      err, errno, retval, size, *magic);
=20
-	err =3D bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v6, sizeof(pkt_v6),
+	err =3D bpf_prog_test_run(bpf_program__fd(skel->progs.balancer_ingress_=
v6),
+				NUM_ITER, &pkt_v6, sizeof(pkt_v6),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval !=3D 1 || size !=3D 74 ||
 	      *magic !=3D MAGIC_VAL, "ipv6",
 	      "err %d errno %d retval %d size %d magic %x\n",
 	      err, errno, retval, size, *magic);
=20
-	map_fd =3D bpf_find_map(__func__, obj, "stats");
-	if (map_fd < 0)
-		goto out;
-	bpf_map_lookup_elem(map_fd, &stats_key, stats);
+	bpf_map_lookup_elem(bpf_map__fd(skel->maps.stats), &stats_key, stats);
 	for (i =3D 0; i < nr_cpus; i++) {
 		bytes +=3D stats[i].bytes;
 		pkts +=3D stats[i].pkts;
 	}
-	if (CHECK_FAIL(bytes !=3D MAGIC_BYTES * NUM_ITER * 2 ||
-		       pkts !=3D NUM_ITER * 2)) {
-		printf("test_xdp_noinline:FAIL:stats %lld %lld\n",
-		       bytes, pkts);
-	}
-out:
-	bpf_object__close(obj);
+	CHECK(bytes !=3D MAGIC_BYTES * NUM_ITER * 2 || pkts !=3D NUM_ITER * 2,
+	      "stats", "bytes %lld pkts %lld\n",
+	      (unsigned long long)bytes, (unsigned long long)pkts);
+	test_xdp_noinline__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tool=
s/testing/selftests/bpf/progs/test_xdp_noinline.c
index 8beecec166d9..3a67921f62b5 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -16,7 +16,7 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
=20
-static __u32 rol32(__u32 word, unsigned int shift)
+static __always_inline __u32 rol32(__u32 word, unsigned int shift)
 {
 	return (word << shift) | (word >> ((-shift) & 31));
 }
@@ -49,7 +49,7 @@ static __u32 rol32(__u32 word, unsigned int shift)
=20
 typedef unsigned int u32;
=20
-static __attribute__ ((noinline))
+static __noinline
 u32 jhash(const void *key, u32 length, u32 initval)
 {
 	u32 a, b, c;
@@ -86,7 +86,7 @@ u32 jhash(const void *key, u32 length, u32 initval)
 	return c;
 }
=20
-__attribute__ ((noinline))
+__noinline
 u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
 {
 	a +=3D initval;
@@ -96,7 +96,7 @@ u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
 	return c;
 }
=20
-__attribute__ ((noinline))
+__noinline
 u32 jhash_2words(u32 a, u32 b, u32 initval)
 {
 	return __jhash_nwords(a, b, 0, initval + JHASH_INITVAL + (2 << 2));
@@ -213,7 +213,7 @@ struct eth_hdr {
 	unsigned short eth_proto;
 };
=20
-static inline __u64 calc_offset(bool is_ipv6, bool is_icmp)
+static __noinline __u64 calc_offset(bool is_ipv6, bool is_icmp)
 {
 	__u64 off =3D sizeof(struct eth_hdr);
 	if (is_ipv6) {
@@ -797,8 +797,8 @@ static int process_packet(void *data, __u64 off, void=
 *data_end,
 	return XDP_DROP;
 }
=20
-__attribute__ ((section("xdp-test"), used))
-int balancer_ingress(struct xdp_md *ctx)
+SEC("xdp-test-v4")
+int balancer_ingress_v4(struct xdp_md *ctx)
 {
 	void *data =3D (void *)(long)ctx->data;
 	void *data_end =3D (void *)(long)ctx->data_end;
@@ -812,11 +812,27 @@ int balancer_ingress(struct xdp_md *ctx)
 	eth_proto =3D bpf_ntohs(eth->eth_proto);
 	if (eth_proto =3D=3D ETH_P_IP)
 		return process_packet(data, nh_off, data_end, 0, ctx);
-	else if (eth_proto =3D=3D ETH_P_IPV6)
+	else
+		return XDP_DROP;
+}
+
+SEC("xdp-test-v6")
+int balancer_ingress_v6(struct xdp_md *ctx)
+{
+	void *data =3D (void *)(long)ctx->data;
+	void *data_end =3D (void *)(long)ctx->data_end;
+	struct eth_hdr *eth =3D data;
+	__u32 eth_proto;
+	__u32 nh_off;
+
+	nh_off =3D sizeof(struct eth_hdr);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+	eth_proto =3D bpf_ntohs(eth->eth_proto);
+	if (eth_proto =3D=3D ETH_P_IPV6)
 		return process_packet(data, nh_off, data_end, 1, ctx);
 	else
 		return XDP_DROP;
 }
=20
-char _license[] __attribute__ ((section("license"), used)) =3D "GPL";
-int _version __attribute__ ((section("version"), used)) =3D 1;
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

