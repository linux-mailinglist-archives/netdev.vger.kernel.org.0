Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91DA54AEBE
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiFNKsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354715AbiFNKr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:47:57 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC56D27B1B;
        Tue, 14 Jun 2022 03:47:50 -0700 (PDT)
Received: from SPMA-03.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id BE1FA6E583_2A86754B;
        Tue, 14 Jun 2022 10:47:48 +0000 (GMT)
Received: from mail.tu-berlin.de (postcard.tu-berlin.de [141.23.12.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-03.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 6C0A37144D_2A86754F;
        Tue, 14 Jun 2022 10:47:48 +0000 (GMT)
Received: from jt.fritz.box (89.12.240.121) by ex-01.svc.tu-berlin.de
 (10.150.18.5) with Microsoft SMTP Server id 15.2.986.22; Tue, 14 Jun 2022
 12:47:47 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next v3 5/5] selftests/bpf: Test a BPF CC implementing the unsupported get_info()
Date:   Tue, 14 Jun 2022 12:44:52 +0200
Message-ID: <20220614104452.3370148-6-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=MKzGpz0JxNAa450UwKhlPrduGYvv0DJI8NoO5ET+8ZU=; b=LzUJj4Tc14nvR1RZ/9WWX9bOmx1mO10/eYtgWd7ZzHkmjbHXdUKS+lM8XEVLJ4QoJvoWzTdcqUeuH4fmN6Hn6DbSQWrd/TtWota88y0ImurADPVYHi/Wm6a79AW5TpCqYgO+d+zUDLtb3n32RLQXaWylwlpa2MGzR444GZ/cXqM=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test whether a TCP CC implemented in BPF providing get_info() is
rejected correctly. get_info() is unsupported in a BPF CC. The check for
required functions in a BPF CC has moved, this test ensures unsupported
functions are still rejected correctly.

Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 20 ++++++++++++++++++
 .../bpf/progs/tcp_ca_unsupp_cong_op.c         | 21 +++++++++++++++++++
 2 files changed, 41 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_unsupp_cong_op.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index cc2a8a12ca67..b15a4b6ea4ae 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -11,6 +11,7 @@
 #include "bpf_dctcp_release.skel.h"
 #include "tcp_ca_write_sk_pacing.skel.h"
 #include "tcp_ca_incompl_cong_ops.skel.h"
+#include "tcp_ca_unsupp_cong_op.skel.h"
 
 #ifndef ENOTSUPP
 #define ENOTSUPP 524
@@ -364,6 +365,23 @@ static void test_incompl_cong_ops(void)
 	tcp_ca_incompl_cong_ops__destroy(skel);
 }
 
+static void test_unsupp_cong_op(void)
+{
+	libbpf_print_fn_t old_print_fn;
+	struct tcp_ca_unsupp_cong_op *skel;
+
+	err_str = "attach to unsupported member get_info";
+	found = false;
+	old_print_fn = libbpf_set_print(libbpf_debug_print);
+
+	skel = tcp_ca_unsupp_cong_op__open_and_load();
+	ASSERT_NULL(skel, "open_and_load");
+	ASSERT_EQ(found, true, "expected_err_msg");
+
+	tcp_ca_unsupp_cong_op__destroy(skel);
+	libbpf_set_print(old_print_fn);
+}
+
 void test_bpf_tcp_ca(void)
 {
 	if (test__start_subtest("dctcp"))
@@ -380,4 +398,6 @@ void test_bpf_tcp_ca(void)
 		test_write_sk_pacing();
 	if (test__start_subtest("incompl_cong_ops"))
 		test_incompl_cong_ops();
+	if (test__start_subtest("unsupp_cong_op"))
+		test_unsupp_cong_op();
 }
diff --git a/tools/testing/selftests/bpf/progs/tcp_ca_unsupp_cong_op.c b/tools/testing/selftests/bpf/progs/tcp_ca_unsupp_cong_op.c
new file mode 100644
index 000000000000..c06f4a41c21a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tcp_ca_unsupp_cong_op.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("struct_ops/unsupp_cong_op_get_info")
+size_t BPF_PROG(unsupp_cong_op_get_info, struct sock *sk, u32 ext, int *attr,
+		union tcp_cc_info *info)
+{
+	return 0;
+}
+
+SEC(".struct_ops")
+struct tcp_congestion_ops unsupp_cong_op = {
+	.get_info = (void *)unsupp_cong_op_get_info,
+	.name = "bpf_unsupp_op",
+};
-- 
2.30.2

