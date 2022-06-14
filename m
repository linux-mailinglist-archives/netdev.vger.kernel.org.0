Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EEE54AEBB
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356001AbiFNKr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353807AbiFNKr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:47:57 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5A327B01;
        Tue, 14 Jun 2022 03:47:49 -0700 (PDT)
Received: from SPMA-02.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id DB06238918_2A86753B;
        Tue, 14 Jun 2022 10:47:47 +0000 (GMT)
Received: from mail.tu-berlin.de (mail.tu-berlin.de [141.23.12.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-02.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 799188C12D_2A86753F;
        Tue, 14 Jun 2022 10:47:47 +0000 (GMT)
Received: from jt.fritz.box (89.12.240.121) by ex-01.svc.tu-berlin.de
 (10.150.18.5) with Microsoft SMTP Server id 15.2.986.22; Tue, 14 Jun 2022
 12:47:46 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next v3 3/5] selftests/bpf: Test a BPF CC writing sk_pacing_*
Date:   Tue, 14 Jun 2022 12:44:50 +0200
Message-ID: <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=YFvE76WojjD4JwDChlTxtpTt5kWDIt2mcGOb8HdH+yM=; b=Yvca9oK8ZNalr1NnQsNhda/ZmlXRGLxXao98IN4VNlt0SmOmE9NnOD4n4r2dBehBIoQrNuHZtQx+Wsvc7Z5uk/ThFy5+OIcquuyoSc0q/Xl9CF3FDK65Xy3t91jp59GvHYkMS9ZlzqAmMrt6p5YlBpIIQZLO10HOOY+vGB0Ocxw=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test whether a TCP CC implemented in BPF is allowed to write
sk_pacing_rate and sk_pacing_status in struct sock. This is needed when
cong_control() is implemented and used.

Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 21 +++++++
 .../bpf/progs/tcp_ca_write_sk_pacing.c        | 60 +++++++++++++++++++
 2 files changed, 81 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index e9a9a31b2ffe..a797497e2864 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -9,6 +9,7 @@
 #include "bpf_cubic.skel.h"
 #include "bpf_tcp_nogpl.skel.h"
 #include "bpf_dctcp_release.skel.h"
+#include "tcp_ca_write_sk_pacing.skel.h"
 
 #ifndef ENOTSUPP
 #define ENOTSUPP 524
@@ -322,6 +323,24 @@ static void test_rel_setsockopt(void)
 	bpf_dctcp_release__destroy(rel_skel);
 }
 
+static void test_write_sk_pacing(void)
+{
+	struct tcp_ca_write_sk_pacing *skel;
+	struct bpf_link *link;
+
+	skel = tcp_ca_write_sk_pacing__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load")) {
+		return;
+	}
+
+	link = bpf_map__attach_struct_ops(skel->maps.write_sk_pacing);
+	if (ASSERT_OK_PTR(link, "attach_struct_ops")) {
+		bpf_link__destroy(link);
+	}
+
+	tcp_ca_write_sk_pacing__destroy(skel);
+}
+
 void test_bpf_tcp_ca(void)
 {
 	if (test__start_subtest("dctcp"))
@@ -334,4 +353,6 @@ void test_bpf_tcp_ca(void)
 		test_dctcp_fallback();
 	if (test__start_subtest("rel_setsockopt"))
 		test_rel_setsockopt();
+	if (test__start_subtest("write_sk_pacing"))
+		test_write_sk_pacing();
 }
diff --git a/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
new file mode 100644
index 000000000000..43447704cf0e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#define USEC_PER_SEC 1000000UL
+
+#define min(a, b) ((a) < (b) ? (a) : (b))
+
+static inline struct tcp_sock *tcp_sk(const struct sock *sk)
+{
+	return (struct tcp_sock *)sk;
+}
+
+SEC("struct_ops/write_sk_pacing_init")
+void BPF_PROG(write_sk_pacing_init, struct sock *sk)
+{
+#ifdef ENABLE_ATOMICS_TESTS
+	__sync_bool_compare_and_swap(&sk->sk_pacing_status, SK_PACING_NONE,
+				     SK_PACING_NEEDED);
+#else
+	sk->sk_pacing_status = SK_PACING_NEEDED;
+#endif
+}
+
+SEC("struct_ops/write_sk_pacing_cong_control")
+void BPF_PROG(write_sk_pacing_cong_control, struct sock *sk,
+	      const struct rate_sample *rs)
+{
+	const struct tcp_sock *tp = tcp_sk(sk);
+	unsigned long rate =
+		((tp->snd_cwnd * tp->mss_cache * USEC_PER_SEC) << 3) /
+		(tp->srtt_us ?: 1U << 3);
+	sk->sk_pacing_rate = min(rate, sk->sk_max_pacing_rate);
+}
+
+SEC("struct_ops/write_sk_pacing_ssthresh")
+__u32 BPF_PROG(write_sk_pacing_ssthresh, struct sock *sk)
+{
+	return tcp_sk(sk)->snd_ssthresh;
+}
+
+SEC("struct_ops/write_sk_pacing_undo_cwnd")
+__u32 BPF_PROG(write_sk_pacing_undo_cwnd, struct sock *sk)
+{
+	return tcp_sk(sk)->snd_cwnd;
+}
+
+SEC(".struct_ops")
+struct tcp_congestion_ops write_sk_pacing = {
+	.init = (void *)write_sk_pacing_init,
+	.cong_control = (void *)write_sk_pacing_cong_control,
+	.ssthresh = (void *)write_sk_pacing_ssthresh,
+	.undo_cwnd = (void *)write_sk_pacing_undo_cwnd,
+	.name = "bpf_w_sk_pacing",
+};
-- 
2.30.2

