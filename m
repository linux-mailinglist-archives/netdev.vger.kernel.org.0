Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0242C9394
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgLAAEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:04:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730969AbgLAAEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:04:24 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0B101Map013174
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:03:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=PfYV/v+uwNAdHgWlfUS6CxlpQgD2LLrJxGYYZg5n2O8=;
 b=POSOvlfTtWFS1OcUHOVVRu+iAHmDMqAiP4XOycFH8oGePocNy2fSpCl9GBKwkpPC8VXZ
 CeNkg9RreGeNHZSmkhCAaYqSdt/yp1Aalrw8SDibM+3FNUqKR/TayAjMKHBYWu0X2/p1
 9nVbVEZL0b8aSGgwbHWxpVthbASQ4kSx7xY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 3542bngvyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:03:42 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 16:03:41 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 19FF14752A009; Mon, 30 Nov 2020 16:03:41 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP
Date:   Mon, 30 Nov 2020 16:03:39 -0800
Message-ID: <20201201000339.3310760-3-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201000339.3310760-1-prankgup@fb.com>
References: <20201201000339.3310760-1-prankgup@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 suspectscore=13
 clxscore=1011 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300150
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftests for new added functionality to set TCP_WINDOW_CLAMP
from bpf setsockopt.

Signed-off-by: Prankur gupta <prankgup@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  1 +
 .../selftests/bpf/prog_tests/tcpbpf_user.c    |  4 +++
 .../selftests/bpf/progs/test_tcpbpf_kern.c    | 33 +++++++++++++++++++
 tools/testing/selftests/bpf/test_tcpbpf.h     |  2 ++
 4 files changed, 40 insertions(+)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
index 2915664c335d..6a9053162cf2 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -56,6 +56,7 @@ struct tcp_sock {
 	__u32	rcv_nxt;
 	__u32	snd_nxt;
 	__u32	snd_una;
+	__u32	window_clamp;
 	__u8	ecn_flags;
 	__u32	delivered;
 	__u32	delivered_ce;
diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools=
/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index ab5281475f44..87923d2865b7 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -42,6 +42,10 @@ static void verify_result(struct tcpbpf_globals *resul=
t)
=20
 	/* check getsockopt for SAVED_SYN */
 	ASSERT_EQ(result->tcp_saved_syn, 1, "tcp_saved_syn");
+
+	/* check getsockopt for window_clamp */
+	ASSERT_EQ(result->window_clamp_client, 9216, "window_clamp_client");
+	ASSERT_EQ(result->window_clamp_server, 9216, "window_clamp_server");
 }
=20
 static void run_test(struct tcpbpf_globals *result)
diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools=
/testing/selftests/bpf/progs/test_tcpbpf_kern.c
index e85e49deba70..94f50f7e94d6 100644
--- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
@@ -12,17 +12,41 @@
 #include <linux/tcp.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
+#include "bpf_tcp_helpers.h"
 #include "test_tcpbpf.h"
=20
 struct tcpbpf_globals global =3D {};
 int _version SEC("version") =3D 1;
=20
+/**
+ * SOL_TCP is defined in <netinet/tcp.h> while
+ * TCP_SAVED_SYN is defined in already included <linux/tcp.h>
+ */
+#ifndef SOL_TCP
+#define SOL_TCP 6
+#endif
+
+static __always_inline int get_tp_window_clamp(struct bpf_sock_ops *skop=
s)
+{
+	struct bpf_sock *sk;
+	struct tcp_sock *tp;
+
+	sk =3D skops->sk;
+	if (!sk)
+		return -1;
+	tp =3D bpf_skc_to_tcp_sock(sk);
+	if (!tp)
+		return -1;
+	return tp->window_clamp;
+}
+
 SEC("sockops")
 int bpf_testcb(struct bpf_sock_ops *skops)
 {
 	char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
 	struct bpf_sock_ops *reuse =3D skops;
 	struct tcphdr *thdr;
+	int window_clamp =3D 9216;
 	int good_call_rv =3D 0;
 	int bad_call_rv =3D 0;
 	int save_syn =3D 1;
@@ -75,6 +99,11 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 	global.event_map |=3D (1 << op);
=20
 	switch (op) {
+	case BPF_SOCK_OPS_TCP_CONNECT_CB:
+		rv =3D bpf_setsockopt(skops, SOL_TCP, TCP_WINDOW_CLAMP,
+				    &window_clamp, sizeof(window_clamp));
+		global.window_clamp_client =3D get_tp_window_clamp(skops);
+		break;
 	case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
 		/* Test failure to set largest cb flag (assumes not defined) */
 		global.bad_cb_test_rv =3D bpf_sock_ops_cb_flags_set(skops, 0x80);
@@ -100,6 +129,10 @@ int bpf_testcb(struct bpf_sock_ops *skops)
 				global.tcp_saved_syn =3D v;
 			}
 		}
+		rv =3D bpf_setsockopt(skops, SOL_TCP, TCP_WINDOW_CLAMP,
+				    &window_clamp, sizeof(window_clamp));
+
+		global.window_clamp_server =3D get_tp_window_clamp(skops);
 		break;
 	case BPF_SOCK_OPS_RTO_CB:
 		break;
diff --git a/tools/testing/selftests/bpf/test_tcpbpf.h b/tools/testing/se=
lftests/bpf/test_tcpbpf.h
index 0ed33521cbbb..9dd9b5590f9d 100644
--- a/tools/testing/selftests/bpf/test_tcpbpf.h
+++ b/tools/testing/selftests/bpf/test_tcpbpf.h
@@ -16,5 +16,7 @@ struct tcpbpf_globals {
 	__u32 num_close_events;
 	__u32 tcp_save_syn;
 	__u32 tcp_saved_syn;
+	__u32 window_clamp_client;
+	__u32 window_clamp_server;
 };
 #endif
--=20
2.24.1

