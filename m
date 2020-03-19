Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FEE18C3F0
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgCSXuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:50:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727259AbgCSXuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:50:16 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02JNiQcH016103
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:50:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=yrWJRi38W9oupJjIde8sUqOlzGDR3r3tZUbZvAg6zWk=;
 b=beS7aLM4sd74/gXH9cRag51VIVLNecJsI+pgUry7ppfP3riGkHKyp5S5EPpml7SWu3lK
 xwy+Rp+5kN9gVlFASHhraw5MFtmjaLvZQfOCx9pvFZg6X6ockpi/x0QE5vzgJYEOcj9B
 RYEht5L1IHO/FWQ54HH99LU03A69E7P1AE0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvf4hs28r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 16:50:15 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 16:50:14 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6EAF32942DAE; Thu, 19 Mar 2020 16:50:08 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/2] bpf: Add tests for bpf_sk_storage to bpf_tcp_ca
Date:   Thu, 19 Mar 2020 16:50:08 -0700
Message-ID: <20200319235008.2940124-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319234955.2933540-1-kafai@fb.com>
References: <20200319234955.2933540-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 clxscore=1015 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=13 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003190095
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds test to exercise the bpf_sk_storage_get()
and bpf_sk_storage_delete() helper from the bpf_dctcp.c.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 28 +++++++++++++++++--
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 16 +++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index 8482bbc67eec..9aaecce0bc3c 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -11,6 +11,7 @@
 static const unsigned int total_bytes = 10 * 1024 * 1024;
 static const struct timeval timeo_sec = { .tv_sec = 10 };
 static const size_t timeo_optlen = sizeof(timeo_sec);
+static int expected_stg = 0xeB9F;
 static int stop, duration;
 
 static int settimeo(int fd)
@@ -88,7 +89,7 @@ static void *server(void *arg)
 	return NULL;
 }
 
-static void do_test(const char *tcp_ca)
+static void do_test(const char *tcp_ca, const struct bpf_map *sk_stg_map)
 {
 	struct sockaddr_in6 sa6 = {};
 	ssize_t nr_recv = 0, bytes = 0;
@@ -110,6 +111,14 @@ static void do_test(const char *tcp_ca)
 		return;
 	}
 
+	if (sk_stg_map) {
+		err = bpf_map_update_elem(bpf_map__fd(sk_stg_map), &fd,
+					  &expected_stg, BPF_NOEXIST);
+		if (CHECK(err, "bpf_map_update_elem(sk_stg_map)",
+			  "err:%d errno:%d\n", err, errno))
+			goto done;
+	}
+
 	if (settcpca(lfd, tcp_ca) || settcpca(fd, tcp_ca) ||
 	    settimeo(lfd) || settimeo(fd))
 		goto done;
@@ -149,6 +158,16 @@ static void do_test(const char *tcp_ca)
 	CHECK(bytes != total_bytes, "recv", "%zd != %u nr_recv:%zd errno:%d\n",
 	      bytes, total_bytes, nr_recv, errno);
 
+	if (sk_stg_map) {
+		int tmp_stg;
+
+		err = bpf_map_lookup_elem(bpf_map__fd(sk_stg_map), &fd,
+					  &tmp_stg);
+		CHECK(!err || errno != ENOENT,
+		      "bpf_map_lookup_elem(sk_stg_map)",
+		      "err:%d errno:%d\n", err, errno);
+	}
+
 wait_thread:
 	WRITE_ONCE(stop, 1);
 	pthread_join(srv_thread, &thread_ret);
@@ -175,7 +194,7 @@ static void test_cubic(void)
 		return;
 	}
 
-	do_test("bpf_cubic");
+	do_test("bpf_cubic", NULL);
 
 	bpf_link__destroy(link);
 	bpf_cubic__destroy(cubic_skel);
@@ -197,7 +216,10 @@ static void test_dctcp(void)
 		return;
 	}
 
-	do_test("bpf_dctcp");
+	do_test("bpf_dctcp", dctcp_skel->maps.sk_stg_map);
+	CHECK(dctcp_skel->bss->stg_result != expected_stg,
+	      "Unexpected stg_result", "stg_result (%x) != expected_stg (%x)\n",
+	      dctcp_skel->bss->stg_result, expected_stg);
 
 	bpf_link__destroy(link);
 	bpf_dctcp__destroy(dctcp_skel);
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
index 127ea762a062..5c1fc584f3ae 100644
--- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -6,6 +6,7 @@
  * the kernel BPF logic.
  */
 
+#include <stddef.h>
 #include <linux/bpf.h>
 #include <linux/types.h>
 #include <bpf/bpf_helpers.h>
@@ -14,6 +15,15 @@
 
 char _license[] SEC("license") = "GPL";
 
+static volatile int stg_result;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} sk_stg_map SEC(".maps");
+
 #define DCTCP_MAX_ALPHA	1024U
 
 struct dctcp {
@@ -43,12 +53,18 @@ void BPF_PROG(dctcp_init, struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct dctcp *ca = inet_csk_ca(sk);
+	int *stg;
 
 	ca->prior_rcv_nxt = tp->rcv_nxt;
 	ca->dctcp_alpha = min(dctcp_alpha_on_init, DCTCP_MAX_ALPHA);
 	ca->loss_cwnd = 0;
 	ca->ce_state = 0;
 
+	stg = bpf_sk_storage_get(&sk_stg_map, (void *)tp, NULL, 0);
+	if (stg) {
+		stg_result = *stg;
+		bpf_sk_storage_delete(&sk_stg_map, (void *)tp);
+	}
 	dctcp_reset(tp, ca);
 }
 
-- 
2.17.1

