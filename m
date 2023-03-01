Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04946A704A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCAPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjCAPvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:51:52 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DDD474D0;
        Wed,  1 Mar 2023 07:51:17 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i5so12755325pla.2;
        Wed, 01 Mar 2023 07:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kk4i2Zww/kLL1evWdIC4LHF5xaqOzjJGrEI90rS36LQ=;
        b=khjlVpCV/GuhAqdJ84mvHv56DPeuMfF2BE2/mHb6KEq6eHQMbKkGgOYq91bg4Xgn6L
         SKZZulCFuRgSzzU9CPs+MTQIpfVKjz2kHbqNcpSbtSeqMMIQYuZP0Y72i/uuhPN2Htww
         k35LdKffec6TS3hCuxlQA5HeDX50I8Or0rrhpad374afK/aD3pqBVhG2b7Dni9h5Pun4
         GOmy4OpB+urAqc7Xh2G53wHz9I4uQ1XgJ6ttBcr0yusMrN60AxNGrqdRN69G/eG8b/hC
         amQuyS5XLgt9tCiLAKlVuGUeIriBsT/ph4HPeYI6WPcklzKPfR4ho9Doxv/D54AWUN4l
         1Luw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kk4i2Zww/kLL1evWdIC4LHF5xaqOzjJGrEI90rS36LQ=;
        b=5MWivxZlhpH4Rxj7lFQY1F5ucE7nejm9vBI8MigcxGGRneqc6Yl1Lky2ENiWj+5kfV
         kZ6J7LfBGTHCwsSvOvzO80zXKu/kHM6aSCBt2H6vSBMcmMpOgdV8sQTmm7wxp3VhBH2Z
         RuWYcd6ViXzcmmBoilU6WkCqgyXOR3M/j5Qc1pIsEYuq2uuoRAnWZtle2nTGxQ8gLRRf
         QY5bffk284wP9ITT2B4lz5HX3obHA4N0kup7ZDB/DM8ZjqKg9r5n2RqdaEIEVswZVR6I
         BtG27Uxl+TCcEj15Q6wdnu1gvC3T/ejUDirYhfCgHHCfbZ055IjJmdFcQ5It5bPyXTG0
         T2hQ==
X-Gm-Message-State: AO0yUKX+Pg6y75o7zCedV38TXSabcvsc+ptSUTF76sX2xPLRr9NAc63N
        +0gE86dnJUDEvI2rGUA2bxmt5+/Q7ls=
X-Google-Smtp-Source: AK7set8VOu/9/s5ADSumRnRIcWoVfHAdDwbb9DD9RKi45f5dx2YolyJrLFrwNOl3w/yvTnPtM6uang==
X-Received: by 2002:a17:90b:17c3:b0:237:72e5:61bd with SMTP id me3-20020a17090b17c300b0023772e561bdmr7778280pjb.49.1677685874784;
        Wed, 01 Mar 2023 07:51:14 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:51:14 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 10/10] selftests/bpf: tests for using dynptrs to parse skb and xdp buffers
Date:   Wed,  1 Mar 2023 07:49:53 -0800
Message-Id: <20230301154953.641654-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154953.641654-1-joannelkoong@gmail.com>
References: <20230301154953.641654-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test skb and xdp dynptr functionality in the following ways:

1) progs/test_cls_redirect_dynptr.c
   * Rewrite "progs/test_cls_redirect.c" test to use dynptrs to parse
     skb data

   * This is a great example of how dynptrs can be used to simplify a
     lot of the parsing logic for non-statically known values.

     When measuring the user + system time between the original version
     vs. using dynptrs, and averaging the time for 10 runs (using
     "time ./test_progs -t cls_redirect"):
         original version: 0.092 sec
         with dynptrs: 0.078 sec

2) progs/test_xdp_dynptr.c
   * Rewrite "progs/test_xdp.c" test to use dynptrs to parse xdp data

     When measuring the user + system time between the original version
     vs. using dynptrs, and averaging the time for 10 runs (using
     "time ./test_progs -t xdp_attach"):
         original version: 0.118 sec
         with dynptrs: 0.094 sec

3) progs/test_l4lb_noinline_dynptr.c
   * Rewrite "progs/test_l4lb_noinline.c" test to use dynptrs to parse
     skb data

     When measuring the user + system time between the original version
     vs. using dynptrs, and averaging the time for 10 runs (using
     "time ./test_progs -t l4lb_all"):
         original version: 0.062 sec
         with dynptrs: 0.081 sec

     For number of processed verifier instructions:
         original version: 6268 insns
         with dynptrs: 2588 insns

4) progs/test_parse_tcp_hdr_opt_dynptr.c
   * Add sample code for parsing tcp hdr opt lookup using dynptrs.
     This logic is lifted from a real-world use case of packet parsing
     in katran [0], a layer 4 load balancer. The original version
     "progs/test_parse_tcp_hdr_opt.c" (not using dynptrs) is included
     here as well, for comparison.

     When measuring the user + system time between the original version
     vs. using dynptrs, and averaging the time for 10 runs (using
     "time ./test_progs -t parse_tcp_hdr_opt"):
         original version: 0.031 sec
         with dynptrs: 0.045 sec

5) progs/dynptr_success.c
   * Add test case "test_skb_readonly" for testing attempts at writes
     on a prog type with read-only skb ctx.
   * Add "test_dynptr_skb_data" for testing that bpf_dynptr_data isn't
     supported for skb progs.

6) progs/dynptr_fail.c
   * Add test cases "skb_invalid_data_slice{1,2,3,4}" and
     "xdp_invalid_data_slice{1,2}" for testing that helpers that modify the
     underlying packet buffer automatically invalidate the associated
     data slice.
   * Add test cases "skb_invalid_ctx" and "xdp_invalid_ctx" for testing
     that prog types that do not support bpf_dynptr_from_skb/xdp don't
     have access to the API.
   * Add test case "dynptr_slice_var_len{1,2}" for testing that
     variable-sized len can't be passed in to bpf_dynptr_slice
   * Add test case "skb_invalid_slice_write" for testing that writes to a
     read-only data slice are rejected by the verifier.
   * Add test case "data_slice_out_of_bounds_skb" for testing that
     writes to an area outside the slice are rejected.
   * Add test case "invalid_slice_rdwr_rdonly" for testing that prog
     types that don't allow writes to packet data don't accept any calls
     to bpf_dynptr_slice_rdwr.

[0] https://github.com/facebookincubator/katran/blob/main/katran/lib/bpf/pckt_parsing.h

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/bpf_kfuncs.h      |  38 +
 .../selftests/bpf/prog_tests/cls_redirect.c   |  25 +
 .../testing/selftests/bpf/prog_tests/dynptr.c |  74 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +
 .../bpf/prog_tests/parse_tcp_hdr_opt.c        |  93 ++
 .../selftests/bpf/prog_tests/xdp_attach.c     |  11 +-
 .../testing/selftests/bpf/progs/dynptr_fail.c | 287 ++++-
 .../selftests/bpf/progs/dynptr_success.c      |  55 +-
 .../bpf/progs/test_cls_redirect_dynptr.c      | 980 ++++++++++++++++++
 .../bpf/progs/test_l4lb_noinline_dynptr.c     | 487 +++++++++
 .../bpf/progs/test_parse_tcp_hdr_opt.c        | 119 +++
 .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c | 114 ++
 .../selftests/bpf/progs/test_xdp_dynptr.c     | 257 +++++
 .../selftests/bpf/test_tcp_hdr_options.h      |   1 +
 14 files changed, 2520 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_kfuncs.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c

diff --git a/tools/testing/selftests/bpf/bpf_kfuncs.h b/tools/testing/selftests/bpf/bpf_kfuncs.h
new file mode 100644
index 000000000000..8c993ec8ceea
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_kfuncs.h
@@ -0,0 +1,38 @@
+#ifndef __BPF_KFUNCS__
+#define __BPF_KFUNCS__
+
+/* Description
+ *  Initializes an skb-type dynptr
+ * Returns
+ *  Error code
+ */
+extern int bpf_dynptr_from_skb(struct __sk_buff *skb, __u64 flags,
+    struct bpf_dynptr *ptr__uninit) __ksym;
+
+/* Description
+ *  Initializes an xdp-type dynptr
+ * Returns
+ *  Error code
+ */
+extern int bpf_dynptr_from_xdp(struct xdp_md *xdp, __u64 flags,
+			       struct bpf_dynptr *ptr__uninit) __ksym;
+
+/* Description
+ *  Obtain a read-only pointer to the dynptr's data
+ * Returns
+ *  Either a direct pointer to the dynptr data or a pointer to the user-provided
+ *  buffer if unable to obtain a direct pointer
+ */
+extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, __u32 offset,
+			      void *buffer, __u32 buffer__szk) __ksym;
+
+/* Description
+ *  Obtain a read-write pointer to the dynptr's data
+ * Returns
+ *  Either a direct pointer to the dynptr data or a pointer to the user-provided
+ *  buffer if unable to obtain a direct pointer
+ */
+extern void *bpf_dynptr_slice_rdwr(const struct bpf_dynptr *ptr, __u32 offset,
+			      void *buffer, __u32 buffer__szk) __ksym;
+
+#endif
diff --git a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
index 224f016b0a53..2a55f717fc07 100644
--- a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
@@ -13,6 +13,7 @@
 
 #include "progs/test_cls_redirect.h"
 #include "test_cls_redirect.skel.h"
+#include "test_cls_redirect_dynptr.skel.h"
 #include "test_cls_redirect_subprogs.skel.h"
 
 #define ENCAP_IP INADDR_LOOPBACK
@@ -446,6 +447,28 @@ static void test_cls_redirect_common(struct bpf_program *prog)
 	close_fds((int *)conns, sizeof(conns) / sizeof(conns[0][0]));
 }
 
+static void test_cls_redirect_dynptr(void)
+{
+	struct test_cls_redirect_dynptr *skel;
+	int err;
+
+	skel = test_cls_redirect_dynptr__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	skel->rodata->ENCAPSULATION_IP = htonl(ENCAP_IP);
+	skel->rodata->ENCAPSULATION_PORT = htons(ENCAP_PORT);
+
+	err = test_cls_redirect_dynptr__load(skel);
+	if (!ASSERT_OK(err, "skel_load"))
+		goto cleanup;
+
+	test_cls_redirect_common(skel->progs.cls_redirect);
+
+cleanup:
+	test_cls_redirect_dynptr__destroy(skel);
+}
+
 static void test_cls_redirect_inlined(void)
 {
 	struct test_cls_redirect *skel;
@@ -496,4 +519,6 @@ void test_cls_redirect(void)
 		test_cls_redirect_inlined();
 	if (test__start_subtest("cls_redirect_subprogs"))
 		test_cls_redirect_subprogs();
+	if (test__start_subtest("cls_redirect_dynptr"))
+		test_cls_redirect_dynptr();
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/dynptr.c b/tools/testing/selftests/bpf/prog_tests/dynptr.c
index b99264ec0d9c..d176c34a7d2e 100644
--- a/tools/testing/selftests/bpf/prog_tests/dynptr.c
+++ b/tools/testing/selftests/bpf/prog_tests/dynptr.c
@@ -2,20 +2,32 @@
 /* Copyright (c) 2022 Facebook */
 
 #include <test_progs.h>
+#include <network_helpers.h>
 #include "dynptr_fail.skel.h"
 #include "dynptr_success.skel.h"
 
-static const char * const success_tests[] = {
-	"test_read_write",
-	"test_data_slice",
-	"test_ringbuf",
+enum test_setup_type {
+	SETUP_SYSCALL_SLEEP,
+	SETUP_SKB_PROG,
 };
 
-static void verify_success(const char *prog_name)
+static struct {
+	const char *prog_name;
+	enum test_setup_type type;
+} success_tests[] = {
+	{"test_read_write", SETUP_SYSCALL_SLEEP},
+	{"test_dynptr_data", SETUP_SYSCALL_SLEEP},
+	{"test_ringbuf", SETUP_SYSCALL_SLEEP},
+	{"test_skb_readonly", SETUP_SKB_PROG},
+	{"test_dynptr_skb_data", SETUP_SKB_PROG},
+};
+
+static void verify_success(const char *prog_name, enum test_setup_type setup_type)
 {
 	struct dynptr_success *skel;
 	struct bpf_program *prog;
 	struct bpf_link *link;
+       int err;
 
 	skel = dynptr_success__open();
 	if (!ASSERT_OK_PTR(skel, "dynptr_success__open"))
@@ -23,23 +35,53 @@ static void verify_success(const char *prog_name)
 
 	skel->bss->pid = getpid();
 
-	dynptr_success__load(skel);
-	if (!ASSERT_OK_PTR(skel, "dynptr_success__load"))
-		goto cleanup;
-
 	prog = bpf_object__find_program_by_name(skel->obj, prog_name);
 	if (!ASSERT_OK_PTR(prog, "bpf_object__find_program_by_name"))
 		goto cleanup;
 
-	link = bpf_program__attach(prog);
-	if (!ASSERT_OK_PTR(link, "bpf_program__attach"))
+       bpf_program__set_autoload(prog, true);
+
+	err = dynptr_success__load(skel);
+	if (!ASSERT_OK(err, "dynptr_success__load"))
 		goto cleanup;
 
-	usleep(1);
+	switch (setup_type) {
+	case SETUP_SYSCALL_SLEEP:
+		link = bpf_program__attach(prog);
+		if (!ASSERT_OK_PTR(link, "bpf_program__attach"))
+			goto cleanup;
 
-	ASSERT_EQ(skel->bss->err, 0, "err");
+		usleep(1);
+
+		bpf_link__destroy(link);
+		break;
+	case SETUP_SKB_PROG:
+	{
+		int prog_fd;
+		char buf[64];
+
+		LIBBPF_OPTS(bpf_test_run_opts, topts,
+			    .data_in = &pkt_v4,
+			    .data_size_in = sizeof(pkt_v4),
+			    .data_out = buf,
+			    .data_size_out = sizeof(buf),
+			    .repeat = 1,
+		);
 
-	bpf_link__destroy(link);
+		prog_fd = bpf_program__fd(prog);
+		if (!ASSERT_GE(prog_fd, 0, "prog_fd"))
+			goto cleanup;
+
+		err = bpf_prog_test_run_opts(prog_fd, &topts);
+
+		if (!ASSERT_OK(err, "test_run"))
+			goto cleanup;
+
+		break;
+	}
+	}
+
+	ASSERT_EQ(skel->bss->err, 0, "err");
 
 cleanup:
 	dynptr_success__destroy(skel);
@@ -50,10 +92,10 @@ void test_dynptr(void)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(success_tests); i++) {
-		if (!test__start_subtest(success_tests[i]))
+		if (!test__start_subtest(success_tests[i].prog_name))
 			continue;
 
-		verify_success(success_tests[i]);
+		verify_success(success_tests[i].prog_name, success_tests[i].type);
 	}
 
 	RUN_TESTS(dynptr_fail);
diff --git a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
index 9c1a18573ffd..1eab286b14fe 100644
--- a/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
+++ b/tools/testing/selftests/bpf/prog_tests/l4lb_all.c
@@ -93,4 +93,6 @@ void test_l4lb_all(void)
 		test_l4lb("test_l4lb.bpf.o");
 	if (test__start_subtest("l4lb_noinline"))
 		test_l4lb("test_l4lb_noinline.bpf.o");
+	if (test__start_subtest("l4lb_noinline_dynptr"))
+		test_l4lb("test_l4lb_noinline_dynptr.bpf.o");
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c b/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
new file mode 100644
index 000000000000..daa952711d8f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_parse_tcp_hdr_opt.skel.h"
+#include "test_parse_tcp_hdr_opt_dynptr.skel.h"
+#include "test_tcp_hdr_options.h"
+
+struct test_pkt {
+	struct ipv6_packet pk6_v6;
+	u8 options[16];
+} __packed;
+
+struct test_pkt pkt = {
+	.pk6_v6.eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
+	.pk6_v6.iph.nexthdr = IPPROTO_TCP,
+	.pk6_v6.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
+	.pk6_v6.tcp.urg_ptr = 123,
+	.pk6_v6.tcp.doff = 9, /* 16 bytes of options */
+
+	.options = {
+		TCPOPT_MSS, 4, 0x05, 0xB4, TCPOPT_NOP, TCPOPT_NOP,
+		0, 6, 0xBB, 0xBB, 0xBB, 0xBB, TCPOPT_EOL
+	},
+};
+
+static void test_parse_opt(void)
+{
+	struct test_parse_tcp_hdr_opt *skel;
+	struct bpf_program *prog;
+	char buf[128];
+	int err;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		    .data_in = &pkt,
+		    .data_size_in = sizeof(pkt),
+		    .data_out = buf,
+		    .data_size_out = sizeof(buf),
+		    .repeat = 3,
+	);
+
+	skel = test_parse_tcp_hdr_opt__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	pkt.options[6] = skel->rodata->tcp_hdr_opt_kind_tpr;
+	prog = skel->progs.xdp_ingress_v6;
+
+	err = bpf_prog_test_run_opts(bpf_program__fd(prog), &topts);
+	ASSERT_OK(err, "ipv6 test_run");
+	ASSERT_EQ(topts.retval, XDP_PASS, "ipv6 test_run retval");
+	ASSERT_EQ(skel->bss->server_id, 0xBBBBBBBB, "server id");
+
+	test_parse_tcp_hdr_opt__destroy(skel);
+}
+
+static void test_parse_opt_dynptr(void)
+{
+	struct test_parse_tcp_hdr_opt_dynptr *skel;
+	struct bpf_program *prog;
+	char buf[128];
+	int err;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		    .data_in = &pkt,
+		    .data_size_in = sizeof(pkt),
+		    .data_out = buf,
+		    .data_size_out = sizeof(buf),
+		    .repeat = 3,
+	);
+
+	skel = test_parse_tcp_hdr_opt_dynptr__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	pkt.options[6] = skel->rodata->tcp_hdr_opt_kind_tpr;
+	prog = skel->progs.xdp_ingress_v6;
+
+	err = bpf_prog_test_run_opts(bpf_program__fd(prog), &topts);
+	ASSERT_OK(err, "ipv6 test_run");
+	ASSERT_EQ(topts.retval, XDP_PASS, "ipv6 test_run retval");
+	ASSERT_EQ(skel->bss->server_id, 0xBBBBBBBB, "server id");
+
+	test_parse_tcp_hdr_opt_dynptr__destroy(skel);
+}
+
+void test_parse_tcp_hdr_opt(void)
+{
+	if (test__start_subtest("parse_tcp_hdr_opt"))
+		test_parse_opt();
+	if (test__start_subtest("parse_tcp_hdr_opt_dynptr"))
+		test_parse_opt_dynptr();
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
index d4cd9f873c14..fa3cac5488f5 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
@@ -4,11 +4,10 @@
 #define IFINDEX_LO 1
 #define XDP_FLAGS_REPLACE		(1U << 4)
 
-void serial_test_xdp_attach(void)
+static void test_xdp_attach(const char *file)
 {
 	__u32 duration = 0, id1, id2, id0 = 0, len;
 	struct bpf_object *obj1, *obj2, *obj3;
-	const char *file = "./test_xdp.bpf.o";
 	struct bpf_prog_info info = {};
 	int err, fd1, fd2, fd3;
 	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
@@ -85,3 +84,11 @@ void serial_test_xdp_attach(void)
 out_1:
 	bpf_object__close(obj1);
 }
+
+void serial_test_xdp_attach(void)
+{
+	if (test__start_subtest("xdp_attach"))
+		test_xdp_attach("./test_xdp.bpf.o");
+	if (test__start_subtest("xdp_attach_dynptr"))
+		test_xdp_attach("./test_xdp_dynptr.bpf.o");
+}
diff --git a/tools/testing/selftests/bpf/progs/dynptr_fail.c b/tools/testing/selftests/bpf/progs/dynptr_fail.c
index aa5b69354b91..20ce920d891d 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_fail.c
@@ -5,7 +5,9 @@
 #include <string.h>
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
+#include <linux/if_ether.h>
 #include "bpf_misc.h"
+#include "bpf_kfuncs.h"
 
 char _license[] SEC("license") = "GPL";
 
@@ -244,6 +246,27 @@ int data_slice_out_of_bounds_ringbuf(void *ctx)
 	return 0;
 }
 
+/* A data slice can't be accessed out of bounds */
+SEC("?tc")
+__failure __msg("value is outside of the allowed memory range")
+int data_slice_out_of_bounds_skb(struct __sk_buff *skb)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	hdr = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	/* this should fail */
+	*(__u8*)(hdr + 1) = 1;
+
+	return SK_PASS;
+}
+
 SEC("?raw_tp")
 __failure __msg("value is outside of the allowed memory range")
 int data_slice_out_of_bounds_map_value(void *ctx)
@@ -399,7 +422,6 @@ int invalid_helper2(void *ctx)
 
 	/* this should fail */
 	bpf_dynptr_read(read_data, sizeof(read_data), (void *)&ptr + 8, 0, 0);
-
 	return 0;
 }
 
@@ -1044,6 +1066,193 @@ int dynptr_read_into_slot(void *ctx)
 	return 0;
 }
 
+/* bpf_dynptr_slice()s are read-only and cannot be written to */
+SEC("?tc")
+__failure __msg("R0 cannot write into rdonly_mem")
+int skb_invalid_slice_write(struct __sk_buff *skb)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	hdr = bpf_dynptr_slice(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	/* this should fail */
+	hdr->h_proto = 1;
+
+	return SK_PASS;
+}
+
+/* The read-only data slice is invalidated whenever a helper changes packet data */
+SEC("?tc")
+__failure __msg("invalid mem access 'scalar'")
+int skb_invalid_data_slice1(struct __sk_buff *skb)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	hdr = bpf_dynptr_slice(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	val = hdr->h_proto;
+
+	if (bpf_skb_pull_data(skb, skb->len))
+		return SK_DROP;
+
+	/* this should fail */
+	val = hdr->h_proto;
+
+	return SK_PASS;
+}
+
+/* The read-write data slice is invalidated whenever a helper changes packet data */
+SEC("?tc")
+__failure __msg("invalid mem access 'scalar'")
+int skb_invalid_data_slice2(struct __sk_buff *skb)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	hdr = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	hdr->h_proto = 123;
+
+	if (bpf_skb_pull_data(skb, skb->len))
+		return SK_DROP;
+
+	/* this should fail */
+	hdr->h_proto = 1;
+
+	return SK_PASS;
+}
+
+/* The read-only data slice is invalidated whenever bpf_dynptr_write() is called */
+SEC("?tc")
+__failure __msg("invalid mem access 'scalar'")
+int skb_invalid_data_slice3(struct __sk_buff *skb)
+{
+	char write_data[64] = "hello there, world!!";
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	hdr = bpf_dynptr_slice(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	val = hdr->h_proto;
+
+	bpf_dynptr_write(&ptr, 0, write_data, sizeof(write_data), 0);
+
+	/* this should fail */
+	val = hdr->h_proto;
+
+	return SK_PASS;
+}
+
+/* The read-write data slice is invalidated whenever bpf_dynptr_write() is called */
+SEC("?tc")
+__failure __msg("invalid mem access 'scalar'")
+int skb_invalid_data_slice4(struct __sk_buff *skb)
+{
+	char write_data[64] = "hello there, world!!";
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+	hdr = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	hdr->h_proto = 123;
+
+	bpf_dynptr_write(&ptr, 0, write_data, sizeof(write_data), 0);
+
+	/* this should fail */
+	hdr->h_proto = 1;
+
+	return SK_PASS;
+}
+
+/* The read-only data slice is invalidated whenever a helper changes packet data */
+SEC("?xdp")
+__failure __msg("invalid mem access 'scalar'")
+int xdp_invalid_data_slice1(struct xdp_md *xdp)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_xdp(xdp, 0, &ptr);
+	hdr = bpf_dynptr_slice(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	val = hdr->h_proto;
+
+	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(*hdr)))
+		return XDP_DROP;
+
+	/* this should fail */
+	val = hdr->h_proto;
+
+	return XDP_PASS;
+}
+
+/* The read-write data slice is invalidated whenever a helper changes packet data */
+SEC("?xdp")
+__failure __msg("invalid mem access 'scalar'")
+int xdp_invalid_data_slice2(struct xdp_md *xdp)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_xdp(xdp, 0, &ptr);
+	hdr = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
+	if (!hdr)
+		return SK_DROP;
+
+	hdr->h_proto = 9;
+
+	if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(*hdr)))
+		return XDP_DROP;
+
+	/* this should fail */
+	hdr->h_proto = 1;
+
+	return XDP_PASS;
+}
+
+/* Only supported prog type can create skb-type dynptrs */
+SEC("?raw_tp")
+__failure __msg("calling kernel function bpf_dynptr_from_skb is not allowed")
+int skb_invalid_ctx(void *ctx)
+{
+	struct bpf_dynptr ptr;
+
+	/* this should fail */
+	bpf_dynptr_from_skb(ctx, 0, &ptr);
+
+	return 0;
+}
+
 /* Reject writes to dynptr slot for uninit arg */
 SEC("?raw_tp")
 __failure __msg("potential write to dynptr at off=-16")
@@ -1061,6 +1270,61 @@ int uninit_write_into_slot(void *ctx)
 	return 0;
 }
 
+/* Only supported prog type can create xdp-type dynptrs */
+SEC("?raw_tp")
+__failure __msg("calling kernel function bpf_dynptr_from_xdp is not allowed")
+int xdp_invalid_ctx(void *ctx)
+{
+	struct bpf_dynptr ptr;
+
+	/* this should fail */
+	bpf_dynptr_from_xdp(ctx, 0, &ptr);
+
+	return 0;
+}
+
+__u32 hdr_size = sizeof(struct ethhdr);
+/* Can't pass in variable-sized len to bpf_dynptr_slice */
+SEC("?tc")
+__failure __msg("unbounded memory access")
+int dynptr_slice_var_len1(struct __sk_buff *skb)
+{
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+	char buffer[sizeof(*hdr)] = {};
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	/* this should fail */
+	hdr = bpf_dynptr_slice(&ptr, 0, buffer, hdr_size);
+	if (!hdr)
+		return SK_DROP;
+
+	return SK_PASS;
+}
+
+/* Can't pass in variable-sized len to bpf_dynptr_slice */
+SEC("?tc")
+__failure __msg("must be a known constant")
+int dynptr_slice_var_len2(struct __sk_buff *skb)
+{
+	char buffer[sizeof(struct ethhdr)] = {};
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	if (hdr_size <= sizeof(buffer)) {
+		/* this should fail */
+		hdr = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, hdr_size);
+		if (!hdr)
+			return SK_DROP;
+		hdr->h_proto = 12;
+	}
+
+	return SK_PASS;
+}
+
 static int callback(__u32 index, void *data)
 {
         *(__u32 *)data = 123;
@@ -1092,3 +1356,24 @@ int invalid_data_slices(void *ctx)
 
 	return 0;
 }
+
+/* Program types that don't allow writes to packet data should fail if
+ * bpf_dynptr_slice_rdwr is called
+ */
+SEC("cgroup_skb/ingress")
+__failure __msg("the prog does not allow writes to packet data")
+int invalid_slice_rdwr_rdonly(struct __sk_buff *skb)
+{
+	char buffer[sizeof(struct ethhdr)] = {};
+	struct bpf_dynptr ptr;
+	struct ethhdr *hdr;
+
+	bpf_dynptr_from_skb(skb, 0, &ptr);
+
+	/* this should fail since cgroup_skb doesn't allow
+	 * changing packet data
+	 */
+	hdr = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/dynptr_success.c b/tools/testing/selftests/bpf/progs/dynptr_success.c
index 35db7c6c1fc7..c8358a7c7924 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_success.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_success.c
@@ -5,6 +5,7 @@
 #include <linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 #include "bpf_misc.h"
+#include "bpf_kfuncs.h"
 #include "errno.h"
 
 char _license[] SEC("license") = "GPL";
@@ -30,7 +31,7 @@ struct {
 	__type(value, __u32);
 } array_map SEC(".maps");
 
-SEC("tp/syscalls/sys_enter_nanosleep")
+SEC("?tp/syscalls/sys_enter_nanosleep")
 int test_read_write(void *ctx)
 {
 	char write_data[64] = "hello there, world!!";
@@ -61,8 +62,8 @@ int test_read_write(void *ctx)
 	return 0;
 }
 
-SEC("tp/syscalls/sys_enter_nanosleep")
-int test_data_slice(void *ctx)
+SEC("?tp/syscalls/sys_enter_nanosleep")
+int test_dynptr_data(void *ctx)
 {
 	__u32 key = 0, val = 235, *map_val;
 	struct bpf_dynptr ptr;
@@ -131,7 +132,7 @@ static int ringbuf_callback(__u32 index, void *data)
 	return 0;
 }
 
-SEC("tp/syscalls/sys_enter_nanosleep")
+SEC("?tp/syscalls/sys_enter_nanosleep")
 int test_ringbuf(void *ctx)
 {
 	struct bpf_dynptr ptr;
@@ -163,3 +164,49 @@ int test_ringbuf(void *ctx)
 	bpf_ringbuf_discard_dynptr(&ptr, 0);
 	return 0;
 }
+
+SEC("?cgroup_skb/egress")
+int test_skb_readonly(struct __sk_buff *skb)
+{
+	__u8 write_data[2] = {1, 2};
+	struct bpf_dynptr ptr;
+	__u64 *data;
+	int ret;
+
+	if (bpf_dynptr_from_skb(skb, 0, &ptr)) {
+		err = 1;
+		return 1;
+	}
+
+	/* since cgroup skbs are read only, writes should fail */
+	ret = bpf_dynptr_write(&ptr, 0, write_data, sizeof(write_data), 0);
+	if (ret != -EINVAL) {
+		err = 2;
+		return 1;
+	}
+
+	return 1;
+}
+
+SEC("?cgroup_skb/egress")
+int test_dynptr_skb_data(struct __sk_buff *skb)
+{
+	__u8 write_data[2] = {1, 2};
+	struct bpf_dynptr ptr;
+	__u64 *data;
+	int ret;
+
+	if (bpf_dynptr_from_skb(skb, 0, &ptr)) {
+		err = 1;
+		return 1;
+	}
+
+	/* This should return NULL. Must use bpf_dynptr_slice API */
+	data = bpf_dynptr_data(&ptr, 0, 1);
+	if (data) {
+		err = 2;
+		return 1;
+	}
+
+	return 1;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c b/tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
new file mode 100644
index 000000000000..f45a7095de7a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
@@ -0,0 +1,980 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2019, 2020 Cloudflare
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <string.h>
+
+#include <linux/bpf.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#include "test_cls_redirect.h"
+#include "bpf_kfuncs.h"
+
+#define offsetofend(TYPE, MEMBER) \
+	(offsetof(TYPE, MEMBER) + sizeof((((TYPE *)0)->MEMBER)))
+
+#define IP_OFFSET_MASK (0x1FFF)
+#define IP_MF (0x2000)
+
+char _license[] SEC("license") = "Dual BSD/GPL";
+
+/**
+ * Destination port and IP used for UDP encapsulation.
+ */
+volatile const __be16 ENCAPSULATION_PORT;
+volatile const __be32 ENCAPSULATION_IP;
+
+typedef struct {
+	uint64_t processed_packets_total;
+	uint64_t l3_protocol_packets_total_ipv4;
+	uint64_t l3_protocol_packets_total_ipv6;
+	uint64_t l4_protocol_packets_total_tcp;
+	uint64_t l4_protocol_packets_total_udp;
+	uint64_t accepted_packets_total_syn;
+	uint64_t accepted_packets_total_syn_cookies;
+	uint64_t accepted_packets_total_last_hop;
+	uint64_t accepted_packets_total_icmp_echo_request;
+	uint64_t accepted_packets_total_established;
+	uint64_t forwarded_packets_total_gue;
+	uint64_t forwarded_packets_total_gre;
+
+	uint64_t errors_total_unknown_l3_proto;
+	uint64_t errors_total_unknown_l4_proto;
+	uint64_t errors_total_malformed_ip;
+	uint64_t errors_total_fragmented_ip;
+	uint64_t errors_total_malformed_icmp;
+	uint64_t errors_total_unwanted_icmp;
+	uint64_t errors_total_malformed_icmp_pkt_too_big;
+	uint64_t errors_total_malformed_tcp;
+	uint64_t errors_total_malformed_udp;
+	uint64_t errors_total_icmp_echo_replies;
+	uint64_t errors_total_malformed_encapsulation;
+	uint64_t errors_total_encap_adjust_failed;
+	uint64_t errors_total_encap_buffer_too_small;
+	uint64_t errors_total_redirect_loop;
+	uint64_t errors_total_encap_mtu_violate;
+} metrics_t;
+
+typedef enum {
+	INVALID = 0,
+	UNKNOWN,
+	ECHO_REQUEST,
+	SYN,
+	SYN_COOKIE,
+	ESTABLISHED,
+} verdict_t;
+
+typedef struct {
+	uint16_t src, dst;
+} flow_ports_t;
+
+_Static_assert(
+	sizeof(flow_ports_t) !=
+		offsetofend(struct bpf_sock_tuple, ipv4.dport) -
+			offsetof(struct bpf_sock_tuple, ipv4.sport) - 1,
+	"flow_ports_t must match sport and dport in struct bpf_sock_tuple");
+_Static_assert(
+	sizeof(flow_ports_t) !=
+		offsetofend(struct bpf_sock_tuple, ipv6.dport) -
+			offsetof(struct bpf_sock_tuple, ipv6.sport) - 1,
+	"flow_ports_t must match sport and dport in struct bpf_sock_tuple");
+
+struct iphdr_info {
+	void *hdr;
+	__u64 len;
+};
+
+typedef int ret_t;
+
+/* This is a bit of a hack. We need a return value which allows us to
+ * indicate that the regular flow of the program should continue,
+ * while allowing functions to use XDP_PASS and XDP_DROP, etc.
+ */
+static const ret_t CONTINUE_PROCESSING = -1;
+
+/* Convenience macro to call functions which return ret_t.
+ */
+#define MAYBE_RETURN(x)                           \
+	do {                                      \
+		ret_t __ret = x;                  \
+		if (__ret != CONTINUE_PROCESSING) \
+			return __ret;             \
+	} while (0)
+
+static bool ipv4_is_fragment(const struct iphdr *ip)
+{
+	uint16_t frag_off = ip->frag_off & bpf_htons(IP_OFFSET_MASK);
+	return (ip->frag_off & bpf_htons(IP_MF)) != 0 || frag_off > 0;
+}
+
+static int pkt_parse_ipv4(struct bpf_dynptr *dynptr, __u64 *offset, struct iphdr *iphdr)
+{
+	if (bpf_dynptr_read(iphdr, sizeof(*iphdr), dynptr, *offset, 0))
+		return -1;
+
+	*offset += sizeof(*iphdr);
+
+	if (iphdr->ihl < 5)
+		return -1;
+
+	/* skip ipv4 options */
+	*offset += (iphdr->ihl - 5) * 4;
+
+	return 0;
+}
+
+/* Parse the L4 ports from a packet, assuming a layout like TCP or UDP. */
+static bool pkt_parse_icmp_l4_ports(struct bpf_dynptr *dynptr, __u64 *offset, flow_ports_t *ports)
+{
+	if (bpf_dynptr_read(ports, sizeof(*ports), dynptr, *offset, 0))
+		return false;
+
+	*offset += sizeof(*ports);
+
+	/* Ports in the L4 headers are reversed, since we are parsing an ICMP
+	 * payload which is going towards the eyeball.
+	 */
+	uint16_t dst = ports->src;
+	ports->src = ports->dst;
+	ports->dst = dst;
+	return true;
+}
+
+static uint16_t pkt_checksum_fold(uint32_t csum)
+{
+	/* The highest reasonable value for an IPv4 header
+	 * checksum requires two folds, so we just do that always.
+	 */
+	csum = (csum & 0xffff) + (csum >> 16);
+	csum = (csum & 0xffff) + (csum >> 16);
+	return (uint16_t)~csum;
+}
+
+static void pkt_ipv4_checksum(struct iphdr *iph)
+{
+	iph->check = 0;
+
+	/* An IP header without options is 20 bytes. Two of those
+	 * are the checksum, which we always set to zero. Hence,
+	 * the maximum accumulated value is 18 / 2 * 0xffff = 0x8fff7,
+	 * which fits in 32 bit.
+	 */
+	_Static_assert(sizeof(struct iphdr) == 20, "iphdr must be 20 bytes");
+	uint32_t acc = 0;
+	uint16_t *ipw = (uint16_t *)iph;
+
+	for (size_t i = 0; i < sizeof(struct iphdr) / 2; i++)
+		acc += ipw[i];
+
+	iph->check = pkt_checksum_fold(acc);
+}
+
+static bool pkt_skip_ipv6_extension_headers(struct bpf_dynptr *dynptr, __u64 *offset,
+					    const struct ipv6hdr *ipv6, uint8_t *upper_proto,
+					    bool *is_fragment)
+{
+	/* We understand five extension headers.
+	 * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
+	 * headers should occur once, except Destination Options, which may
+	 * occur twice. Hence we give up after 6 headers.
+	 */
+	struct {
+		uint8_t next;
+		uint8_t len;
+	} exthdr = {
+		.next = ipv6->nexthdr,
+	};
+	*is_fragment = false;
+
+	for (int i = 0; i < 6; i++) {
+		switch (exthdr.next) {
+		case IPPROTO_FRAGMENT:
+			*is_fragment = true;
+			/* NB: We don't check that hdrlen == 0 as per spec. */
+			/* fallthrough; */
+
+		case IPPROTO_HOPOPTS:
+		case IPPROTO_ROUTING:
+		case IPPROTO_DSTOPTS:
+		case IPPROTO_MH:
+			if (bpf_dynptr_read(&exthdr, sizeof(exthdr), dynptr, *offset, 0))
+				return false;
+
+			/* hdrlen is in 8-octet units, and excludes the first 8 octets. */
+			*offset += (exthdr.len + 1) * 8;
+
+			/* Decode next header */
+			break;
+
+		default:
+			/* The next header is not one of the known extension
+			 * headers, treat it as the upper layer header.
+			 *
+			 * This handles IPPROTO_NONE.
+			 *
+			 * Encapsulating Security Payload (50) and Authentication
+			 * Header (51) also end up here (and will trigger an
+			 * unknown proto error later). They have a custom header
+			 * format and seem too esoteric to care about.
+			 */
+			*upper_proto = exthdr.next;
+			return true;
+		}
+	}
+
+	/* We never found an upper layer header. */
+	return false;
+}
+
+static int pkt_parse_ipv6(struct bpf_dynptr *dynptr, __u64 *offset, struct ipv6hdr *ipv6,
+			  uint8_t *proto, bool *is_fragment)
+{
+	if (bpf_dynptr_read(ipv6, sizeof(*ipv6), dynptr, *offset, 0))
+		return -1;
+
+	*offset += sizeof(*ipv6);
+
+	if (!pkt_skip_ipv6_extension_headers(dynptr, offset, ipv6, proto, is_fragment))
+		return -1;
+
+	return 0;
+}
+
+/* Global metrics, per CPU
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, unsigned int);
+	__type(value, metrics_t);
+} metrics_map SEC(".maps");
+
+static metrics_t *get_global_metrics(void)
+{
+	uint64_t key = 0;
+	return bpf_map_lookup_elem(&metrics_map, &key);
+}
+
+static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
+{
+	const int payload_off =
+		sizeof(*encap) +
+		sizeof(struct in_addr) * encap->unigue.hop_count;
+	int32_t encap_overhead = payload_off - sizeof(struct ethhdr);
+
+	/* Changing the ethertype if the encapsulated packet is ipv6 */
+	if (encap->gue.proto_ctype == IPPROTO_IPV6)
+		encap->eth.h_proto = bpf_htons(ETH_P_IPV6);
+
+	if (bpf_skb_adjust_room(skb, -encap_overhead, BPF_ADJ_ROOM_MAC,
+				BPF_F_ADJ_ROOM_FIXED_GSO |
+				BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
+	    bpf_csum_level(skb, BPF_CSUM_LEVEL_DEC))
+		return TC_ACT_SHOT;
+
+	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
+}
+
+static ret_t forward_with_gre(struct __sk_buff *skb, struct bpf_dynptr *dynptr,
+			      encap_headers_t *encap, struct in_addr *next_hop,
+			      metrics_t *metrics)
+{
+	const int payload_off =
+		sizeof(*encap) +
+		sizeof(struct in_addr) * encap->unigue.hop_count;
+	int32_t encap_overhead =
+		payload_off - sizeof(struct ethhdr) - sizeof(struct iphdr);
+	int32_t delta = sizeof(struct gre_base_hdr) - encap_overhead;
+	__u8 encap_buffer[sizeof(encap_gre_t)] = {};
+	uint16_t proto = ETH_P_IP;
+	uint32_t mtu_len = 0;
+	encap_gre_t *encap_gre;
+
+	metrics->forwarded_packets_total_gre++;
+
+	/* Loop protection: the inner packet's TTL is decremented as a safeguard
+	 * against any forwarding loop. As the only interesting field is the TTL
+	 * hop limit for IPv6, it is easier to use bpf_skb_load_bytes/bpf_skb_store_bytes
+	 * as they handle the split packets if needed (no need for the data to be
+	 * in the linear section).
+	 */
+	if (encap->gue.proto_ctype == IPPROTO_IPV6) {
+		proto = ETH_P_IPV6;
+		uint8_t ttl;
+		int rc;
+
+		rc = bpf_skb_load_bytes(
+			skb, payload_off + offsetof(struct ipv6hdr, hop_limit),
+			&ttl, 1);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+
+		if (ttl == 0) {
+			metrics->errors_total_redirect_loop++;
+			return TC_ACT_SHOT;
+		}
+
+		ttl--;
+		rc = bpf_skb_store_bytes(
+			skb, payload_off + offsetof(struct ipv6hdr, hop_limit),
+			&ttl, 1, 0);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+	} else {
+		uint8_t ttl;
+		int rc;
+
+		rc = bpf_skb_load_bytes(
+			skb, payload_off + offsetof(struct iphdr, ttl), &ttl,
+			1);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+
+		if (ttl == 0) {
+			metrics->errors_total_redirect_loop++;
+			return TC_ACT_SHOT;
+		}
+
+		/* IPv4 also has a checksum to patch. While the TTL is only one byte,
+		 * this function only works for 2 and 4 bytes arguments (the result is
+		 * the same).
+		 */
+		rc = bpf_l3_csum_replace(
+			skb, payload_off + offsetof(struct iphdr, check), ttl,
+			ttl - 1, 2);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+
+		ttl--;
+		rc = bpf_skb_store_bytes(
+			skb, payload_off + offsetof(struct iphdr, ttl), &ttl, 1,
+			0);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+	}
+
+	if (bpf_check_mtu(skb, skb->ifindex, &mtu_len, delta, 0)) {
+		metrics->errors_total_encap_mtu_violate++;
+		return TC_ACT_SHOT;
+	}
+
+	if (bpf_skb_adjust_room(skb, delta, BPF_ADJ_ROOM_NET,
+				BPF_F_ADJ_ROOM_FIXED_GSO |
+				BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
+	    bpf_csum_level(skb, BPF_CSUM_LEVEL_INC)) {
+		metrics->errors_total_encap_adjust_failed++;
+		return TC_ACT_SHOT;
+	}
+
+	if (bpf_skb_pull_data(skb, sizeof(encap_gre_t))) {
+		metrics->errors_total_encap_buffer_too_small++;
+		return TC_ACT_SHOT;
+	}
+
+	encap_gre = bpf_dynptr_slice_rdwr(dynptr, 0, encap_buffer, sizeof(encap_buffer));
+	if (!encap_gre) {
+		metrics->errors_total_encap_buffer_too_small++;
+		return TC_ACT_SHOT;
+	}
+
+	encap_gre->ip.protocol = IPPROTO_GRE;
+	encap_gre->ip.daddr = next_hop->s_addr;
+	encap_gre->ip.saddr = ENCAPSULATION_IP;
+	encap_gre->ip.tot_len =
+		bpf_htons(bpf_ntohs(encap_gre->ip.tot_len) + delta);
+	encap_gre->gre.flags = 0;
+	encap_gre->gre.protocol = bpf_htons(proto);
+	pkt_ipv4_checksum((void *)&encap_gre->ip);
+
+	if (encap_gre == encap_buffer)
+		bpf_dynptr_write(dynptr, 0, encap_buffer, sizeof(encap_buffer), 0);
+
+	return bpf_redirect(skb->ifindex, 0);
+}
+
+static ret_t forward_to_next_hop(struct __sk_buff *skb, struct bpf_dynptr *dynptr,
+				 encap_headers_t *encap, struct in_addr *next_hop,
+				 metrics_t *metrics)
+{
+	/* swap L2 addresses */
+	/* This assumes that packets are received from a router.
+	 * So just swapping the MAC addresses here will make the packet go back to
+	 * the router, which will send it to the appropriate machine.
+	 */
+	unsigned char temp[ETH_ALEN];
+	memcpy(temp, encap->eth.h_dest, sizeof(temp));
+	memcpy(encap->eth.h_dest, encap->eth.h_source,
+	       sizeof(encap->eth.h_dest));
+	memcpy(encap->eth.h_source, temp, sizeof(encap->eth.h_source));
+
+	if (encap->unigue.next_hop == encap->unigue.hop_count - 1 &&
+	    encap->unigue.last_hop_gre) {
+		return forward_with_gre(skb, dynptr, encap, next_hop, metrics);
+	}
+
+	metrics->forwarded_packets_total_gue++;
+	uint32_t old_saddr = encap->ip.saddr;
+	encap->ip.saddr = encap->ip.daddr;
+	encap->ip.daddr = next_hop->s_addr;
+	if (encap->unigue.next_hop < encap->unigue.hop_count) {
+		encap->unigue.next_hop++;
+	}
+
+	/* Remove ip->saddr, add next_hop->s_addr */
+	const uint64_t off = offsetof(typeof(*encap), ip.check);
+	int ret = bpf_l3_csum_replace(skb, off, old_saddr, next_hop->s_addr, 4);
+	if (ret < 0) {
+		return TC_ACT_SHOT;
+	}
+
+	return bpf_redirect(skb->ifindex, 0);
+}
+
+static ret_t skip_next_hops(__u64 *offset, int n)
+{
+	__u32 res;
+	switch (n) {
+	case 1:
+		*offset += sizeof(struct in_addr);
+	case 0:
+		return CONTINUE_PROCESSING;
+
+	default:
+		return TC_ACT_SHOT;
+	}
+}
+
+/* Get the next hop from the GLB header.
+ *
+ * Sets next_hop->s_addr to 0 if there are no more hops left.
+ * pkt is positioned just after the variable length GLB header
+ * iff the call is successful.
+ */
+static ret_t get_next_hop(struct bpf_dynptr *dynptr, __u64 *offset, encap_headers_t *encap,
+			  struct in_addr *next_hop)
+{
+	if (encap->unigue.next_hop > encap->unigue.hop_count)
+		return TC_ACT_SHOT;
+
+	/* Skip "used" next hops. */
+	MAYBE_RETURN(skip_next_hops(offset, encap->unigue.next_hop));
+
+	if (encap->unigue.next_hop == encap->unigue.hop_count) {
+		/* No more next hops, we are at the end of the GLB header. */
+		next_hop->s_addr = 0;
+		return CONTINUE_PROCESSING;
+	}
+
+	if (bpf_dynptr_read(next_hop, sizeof(*next_hop), dynptr, *offset, 0))
+		return TC_ACT_SHOT;
+
+	*offset += sizeof(*next_hop);
+
+	/* Skip the remainig next hops (may be zero). */
+	return skip_next_hops(offset, encap->unigue.hop_count - encap->unigue.next_hop - 1);
+}
+
+/* Fill a bpf_sock_tuple to be used with the socket lookup functions.
+ * This is a kludge that let's us work around verifier limitations:
+ *
+ *    fill_tuple(&t, foo, sizeof(struct iphdr), 123, 321)
+ *
+ * clang will substitue a costant for sizeof, which allows the verifier
+ * to track it's value. Based on this, it can figure out the constant
+ * return value, and calling code works while still being "generic" to
+ * IPv4 and IPv6.
+ */
+static uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
+				    uint64_t iphlen, uint16_t sport, uint16_t dport)
+{
+	switch (iphlen) {
+	case sizeof(struct iphdr): {
+		struct iphdr *ipv4 = (struct iphdr *)iph;
+		tuple->ipv4.daddr = ipv4->daddr;
+		tuple->ipv4.saddr = ipv4->saddr;
+		tuple->ipv4.sport = sport;
+		tuple->ipv4.dport = dport;
+		return sizeof(tuple->ipv4);
+	}
+
+	case sizeof(struct ipv6hdr): {
+		struct ipv6hdr *ipv6 = (struct ipv6hdr *)iph;
+		memcpy(&tuple->ipv6.daddr, &ipv6->daddr,
+		       sizeof(tuple->ipv6.daddr));
+		memcpy(&tuple->ipv6.saddr, &ipv6->saddr,
+		       sizeof(tuple->ipv6.saddr));
+		tuple->ipv6.sport = sport;
+		tuple->ipv6.dport = dport;
+		return sizeof(tuple->ipv6);
+	}
+
+	default:
+		return 0;
+	}
+}
+
+static verdict_t classify_tcp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple,
+			      uint64_t tuplen, void *iph, struct tcphdr *tcp)
+{
+	struct bpf_sock *sk =
+		bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
+
+	if (sk == NULL)
+		return UNKNOWN;
+
+	if (sk->state != BPF_TCP_LISTEN) {
+		bpf_sk_release(sk);
+		return ESTABLISHED;
+	}
+
+	if (iph != NULL && tcp != NULL) {
+		/* Kludge: we've run out of arguments, but need the length of the ip header. */
+		uint64_t iphlen = sizeof(struct iphdr);
+
+		if (tuplen == sizeof(tuple->ipv6))
+			iphlen = sizeof(struct ipv6hdr);
+
+		if (bpf_tcp_check_syncookie(sk, iph, iphlen, tcp,
+					    sizeof(*tcp)) == 0) {
+			bpf_sk_release(sk);
+			return SYN_COOKIE;
+		}
+	}
+
+	bpf_sk_release(sk);
+	return UNKNOWN;
+}
+
+static verdict_t classify_udp(struct __sk_buff *skb, struct bpf_sock_tuple *tuple, uint64_t tuplen)
+{
+	struct bpf_sock *sk =
+		bpf_sk_lookup_udp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
+
+	if (sk == NULL)
+		return UNKNOWN;
+
+	if (sk->state == BPF_TCP_ESTABLISHED) {
+		bpf_sk_release(sk);
+		return ESTABLISHED;
+	}
+
+	bpf_sk_release(sk);
+	return UNKNOWN;
+}
+
+static verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto, struct bpf_sock_tuple *tuple,
+			       uint64_t tuplen, metrics_t *metrics)
+{
+	switch (proto) {
+	case IPPROTO_TCP:
+		return classify_tcp(skb, tuple, tuplen, NULL, NULL);
+
+	case IPPROTO_UDP:
+		return classify_udp(skb, tuple, tuplen);
+
+	default:
+		metrics->errors_total_malformed_icmp++;
+		return INVALID;
+	}
+}
+
+static verdict_t process_icmpv4(struct __sk_buff *skb, struct bpf_dynptr *dynptr, __u64 *offset,
+				metrics_t *metrics)
+{
+	struct icmphdr icmp;
+	struct iphdr ipv4;
+
+	if (bpf_dynptr_read(&icmp, sizeof(icmp), dynptr, *offset, 0)) {
+		metrics->errors_total_malformed_icmp++;
+		return INVALID;
+	}
+
+	*offset += sizeof(icmp);
+
+	/* We should never receive encapsulated echo replies. */
+	if (icmp.type == ICMP_ECHOREPLY) {
+		metrics->errors_total_icmp_echo_replies++;
+		return INVALID;
+	}
+
+	if (icmp.type == ICMP_ECHO)
+		return ECHO_REQUEST;
+
+	if (icmp.type != ICMP_DEST_UNREACH || icmp.code != ICMP_FRAG_NEEDED) {
+		metrics->errors_total_unwanted_icmp++;
+		return INVALID;
+	}
+
+	if (pkt_parse_ipv4(dynptr, offset, &ipv4)) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	/* The source address in the outer IP header is from the entity that
+	 * originated the ICMP message. Use the original IP header to restore
+	 * the correct flow tuple.
+	 */
+	struct bpf_sock_tuple tuple;
+	tuple.ipv4.saddr = ipv4.daddr;
+	tuple.ipv4.daddr = ipv4.saddr;
+
+	if (!pkt_parse_icmp_l4_ports(dynptr, offset, (flow_ports_t *)&tuple.ipv4.sport)) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	return classify_icmp(skb, ipv4.protocol, &tuple,
+			     sizeof(tuple.ipv4), metrics);
+}
+
+static verdict_t process_icmpv6(struct bpf_dynptr *dynptr, __u64 *offset, struct __sk_buff *skb,
+				metrics_t *metrics)
+{
+	struct bpf_sock_tuple tuple;
+	struct ipv6hdr ipv6;
+	struct icmp6hdr icmp6;
+	bool is_fragment;
+	uint8_t l4_proto;
+
+	if (bpf_dynptr_read(&icmp6, sizeof(icmp6), dynptr, *offset, 0)) {
+		metrics->errors_total_malformed_icmp++;
+		return INVALID;
+	}
+
+	/* We should never receive encapsulated echo replies. */
+	if (icmp6.icmp6_type == ICMPV6_ECHO_REPLY) {
+		metrics->errors_total_icmp_echo_replies++;
+		return INVALID;
+	}
+
+	if (icmp6.icmp6_type == ICMPV6_ECHO_REQUEST) {
+		return ECHO_REQUEST;
+	}
+
+	if (icmp6.icmp6_type != ICMPV6_PKT_TOOBIG) {
+		metrics->errors_total_unwanted_icmp++;
+		return INVALID;
+	}
+
+	if (pkt_parse_ipv6(dynptr, offset, &ipv6, &l4_proto, &is_fragment)) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	if (is_fragment) {
+		metrics->errors_total_fragmented_ip++;
+		return INVALID;
+	}
+
+	/* Swap source and dest addresses. */
+	memcpy(&tuple.ipv6.saddr, &ipv6.daddr, sizeof(tuple.ipv6.saddr));
+	memcpy(&tuple.ipv6.daddr, &ipv6.saddr, sizeof(tuple.ipv6.daddr));
+
+	if (!pkt_parse_icmp_l4_ports(dynptr, offset, (flow_ports_t *)&tuple.ipv6.sport)) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	return classify_icmp(skb, l4_proto, &tuple, sizeof(tuple.ipv6),
+			     metrics);
+}
+
+static verdict_t process_tcp(struct bpf_dynptr *dynptr, __u64 *offset, struct __sk_buff *skb,
+			     struct iphdr_info *info, metrics_t *metrics)
+{
+	struct bpf_sock_tuple tuple;
+	struct tcphdr tcp;
+	uint64_t tuplen;
+
+	metrics->l4_protocol_packets_total_tcp++;
+
+	if (bpf_dynptr_read(&tcp, sizeof(tcp), dynptr, *offset, 0)) {
+		metrics->errors_total_malformed_tcp++;
+		return INVALID;
+	}
+
+	*offset += sizeof(tcp);
+
+	if (tcp.syn)
+		return SYN;
+
+	tuplen = fill_tuple(&tuple, info->hdr, info->len, tcp.source, tcp.dest);
+	return classify_tcp(skb, &tuple, tuplen, info->hdr, &tcp);
+}
+
+static verdict_t process_udp(struct bpf_dynptr *dynptr, __u64 *offset, struct __sk_buff *skb,
+			     struct iphdr_info *info, metrics_t *metrics)
+{
+	struct bpf_sock_tuple tuple;
+	struct udphdr udph;
+	uint64_t tuplen;
+
+	metrics->l4_protocol_packets_total_udp++;
+
+	if (bpf_dynptr_read(&udph, sizeof(udph), dynptr, *offset, 0)) {
+		metrics->errors_total_malformed_udp++;
+		return INVALID;
+	}
+	*offset += sizeof(udph);
+
+	tuplen = fill_tuple(&tuple, info->hdr, info->len, udph.source, udph.dest);
+	return classify_udp(skb, &tuple, tuplen);
+}
+
+static verdict_t process_ipv4(struct __sk_buff *skb, struct bpf_dynptr *dynptr,
+			      __u64 *offset, metrics_t *metrics)
+{
+	struct iphdr ipv4;
+	struct iphdr_info info = {
+		.hdr = &ipv4,
+		.len = sizeof(ipv4),
+	};
+
+	metrics->l3_protocol_packets_total_ipv4++;
+
+	if (pkt_parse_ipv4(dynptr, offset, &ipv4)) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (ipv4.version != 4) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (ipv4_is_fragment(&ipv4)) {
+		metrics->errors_total_fragmented_ip++;
+		return INVALID;
+	}
+
+	switch (ipv4.protocol) {
+	case IPPROTO_ICMP:
+		return process_icmpv4(skb, dynptr, offset, metrics);
+
+	case IPPROTO_TCP:
+		return process_tcp(dynptr, offset, skb, &info, metrics);
+
+	case IPPROTO_UDP:
+		return process_udp(dynptr, offset, skb, &info, metrics);
+
+	default:
+		metrics->errors_total_unknown_l4_proto++;
+		return INVALID;
+	}
+}
+
+static verdict_t process_ipv6(struct __sk_buff *skb, struct bpf_dynptr *dynptr,
+			      __u64 *offset, metrics_t *metrics)
+{
+	struct ipv6hdr ipv6;
+	struct iphdr_info info = {
+		.hdr = &ipv6,
+		.len = sizeof(ipv6),
+	};
+	uint8_t l4_proto;
+	bool is_fragment;
+
+	metrics->l3_protocol_packets_total_ipv6++;
+
+	if (pkt_parse_ipv6(dynptr, offset, &ipv6, &l4_proto, &is_fragment)) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (ipv6.version != 6) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (is_fragment) {
+		metrics->errors_total_fragmented_ip++;
+		return INVALID;
+	}
+
+	switch (l4_proto) {
+	case IPPROTO_ICMPV6:
+		return process_icmpv6(dynptr, offset, skb, metrics);
+
+	case IPPROTO_TCP:
+		return process_tcp(dynptr, offset, skb, &info, metrics);
+
+	case IPPROTO_UDP:
+		return process_udp(dynptr, offset, skb, &info, metrics);
+
+	default:
+		metrics->errors_total_unknown_l4_proto++;
+		return INVALID;
+	}
+}
+
+SEC("tc")
+int cls_redirect(struct __sk_buff *skb)
+{
+	__u8 encap_buffer[sizeof(encap_headers_t)] = {};
+	struct bpf_dynptr dynptr;
+	struct in_addr next_hop;
+	/* Tracks offset of the dynptr. This will be unnecessary once
+	 * bpf_dynptr_advance() is available.
+	 */
+	__u64 off = 0;
+	ret_t ret;
+
+	bpf_dynptr_from_skb(skb, 0, &dynptr);
+
+	metrics_t *metrics = get_global_metrics();
+	if (metrics == NULL)
+		return TC_ACT_SHOT;
+
+	metrics->processed_packets_total++;
+
+	/* Pass bogus packets as long as we're not sure they're
+	 * destined for us.
+	 */
+	if (skb->protocol != bpf_htons(ETH_P_IP))
+		return TC_ACT_OK;
+
+	encap_headers_t *encap;
+
+	/* Make sure that all encapsulation headers are available in
+	 * the linear portion of the skb. This makes it easy to manipulate them.
+	 */
+	if (bpf_skb_pull_data(skb, sizeof(*encap)))
+		return TC_ACT_OK;
+
+	encap = bpf_dynptr_slice_rdwr(&dynptr, 0, encap_buffer, sizeof(encap_buffer));
+	if (!encap)
+		return TC_ACT_OK;
+
+	off += sizeof(*encap);
+
+	if (encap->ip.ihl != 5)
+		/* We never have any options. */
+		return TC_ACT_OK;
+
+	if (encap->ip.daddr != ENCAPSULATION_IP ||
+	    encap->ip.protocol != IPPROTO_UDP)
+		return TC_ACT_OK;
+
+	/* TODO Check UDP length? */
+	if (encap->udp.dest != ENCAPSULATION_PORT)
+		return TC_ACT_OK;
+
+	/* We now know that the packet is destined to us, we can
+	 * drop bogus ones.
+	 */
+	if (ipv4_is_fragment((void *)&encap->ip)) {
+		metrics->errors_total_fragmented_ip++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.variant != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.control != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.flags != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.hlen !=
+	    sizeof(encap->unigue) / 4 + encap->unigue.hop_count) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->unigue.version != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->unigue.reserved != 0)
+		return TC_ACT_SHOT;
+
+	MAYBE_RETURN(get_next_hop(&dynptr, &off, encap, &next_hop));
+
+	if (next_hop.s_addr == 0) {
+		metrics->accepted_packets_total_last_hop++;
+		return accept_locally(skb, encap);
+	}
+
+	verdict_t verdict;
+	switch (encap->gue.proto_ctype) {
+	case IPPROTO_IPIP:
+		verdict = process_ipv4(skb, &dynptr, &off, metrics);
+		break;
+
+	case IPPROTO_IPV6:
+		verdict = process_ipv6(skb, &dynptr, &off, metrics);
+		break;
+
+	default:
+		metrics->errors_total_unknown_l3_proto++;
+		return TC_ACT_SHOT;
+	}
+
+	switch (verdict) {
+	case INVALID:
+		/* metrics have already been bumped */
+		return TC_ACT_SHOT;
+
+	case UNKNOWN:
+		return forward_to_next_hop(skb, &dynptr, encap, &next_hop, metrics);
+
+	case ECHO_REQUEST:
+		metrics->accepted_packets_total_icmp_echo_request++;
+		break;
+
+	case SYN:
+		if (encap->unigue.forward_syn) {
+			return forward_to_next_hop(skb, &dynptr, encap, &next_hop,
+						   metrics);
+		}
+
+		metrics->accepted_packets_total_syn++;
+		break;
+
+	case SYN_COOKIE:
+		metrics->accepted_packets_total_syn_cookies++;
+		break;
+
+	case ESTABLISHED:
+		metrics->accepted_packets_total_established++;
+		break;
+	}
+
+	ret = accept_locally(skb, encap);
+
+	if (encap == encap_buffer)
+		bpf_dynptr_write(&dynptr, 0, encap_buffer, sizeof(encap_buffer), 0);
+
+	return ret;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
new file mode 100644
index 000000000000..f997f5080748
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
@@ -0,0 +1,487 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2017 Facebook
+#include <stddef.h>
+#include <stdbool.h>
+#include <string.h>
+#include <linux/pkt_cls.h>
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <bpf/bpf_helpers.h>
+#include "test_iptunnel_common.h"
+#include <bpf/bpf_endian.h>
+
+#include "bpf_kfuncs.h"
+
+static __always_inline __u32 rol32(__u32 word, unsigned int shift)
+{
+	return (word << shift) | (word >> ((-shift) & 31));
+}
+
+/* copy paste of jhash from kernel sources to make sure llvm
+ * can compile it into valid sequence of bpf instructions
+ */
+#define __jhash_mix(a, b, c)			\
+{						\
+	a -= c;  a ^= rol32(c, 4);  c += b;	\
+	b -= a;  b ^= rol32(a, 6);  a += c;	\
+	c -= b;  c ^= rol32(b, 8);  b += a;	\
+	a -= c;  a ^= rol32(c, 16); c += b;	\
+	b -= a;  b ^= rol32(a, 19); a += c;	\
+	c -= b;  c ^= rol32(b, 4);  b += a;	\
+}
+
+#define __jhash_final(a, b, c)			\
+{						\
+	c ^= b; c -= rol32(b, 14);		\
+	a ^= c; a -= rol32(c, 11);		\
+	b ^= a; b -= rol32(a, 25);		\
+	c ^= b; c -= rol32(b, 16);		\
+	a ^= c; a -= rol32(c, 4);		\
+	b ^= a; b -= rol32(a, 14);		\
+	c ^= b; c -= rol32(b, 24);		\
+}
+
+#define JHASH_INITVAL		0xdeadbeef
+
+typedef unsigned int u32;
+
+static __noinline u32 jhash(const void *key, u32 length, u32 initval)
+{
+	u32 a, b, c;
+	const unsigned char *k = key;
+
+	a = b = c = JHASH_INITVAL + length + initval;
+
+	while (length > 12) {
+		a += *(u32 *)(k);
+		b += *(u32 *)(k + 4);
+		c += *(u32 *)(k + 8);
+		__jhash_mix(a, b, c);
+		length -= 12;
+		k += 12;
+	}
+	switch (length) {
+	case 12: c += (u32)k[11]<<24;
+	case 11: c += (u32)k[10]<<16;
+	case 10: c += (u32)k[9]<<8;
+	case 9:  c += k[8];
+	case 8:  b += (u32)k[7]<<24;
+	case 7:  b += (u32)k[6]<<16;
+	case 6:  b += (u32)k[5]<<8;
+	case 5:  b += k[4];
+	case 4:  a += (u32)k[3]<<24;
+	case 3:  a += (u32)k[2]<<16;
+	case 2:  a += (u32)k[1]<<8;
+	case 1:  a += k[0];
+		 __jhash_final(a, b, c);
+	case 0: /* Nothing left to add */
+		break;
+	}
+
+	return c;
+}
+
+static __noinline u32 __jhash_nwords(u32 a, u32 b, u32 c, u32 initval)
+{
+	a += initval;
+	b += initval;
+	c += initval;
+	__jhash_final(a, b, c);
+	return c;
+}
+
+static __noinline u32 jhash_2words(u32 a, u32 b, u32 initval)
+{
+	return __jhash_nwords(a, b, 0, initval + JHASH_INITVAL + (2 << 2));
+}
+
+#define PCKT_FRAGMENTED 65343
+#define IPV4_HDR_LEN_NO_OPT 20
+#define IPV4_PLUS_ICMP_HDR 28
+#define IPV6_PLUS_ICMP_HDR 48
+#define RING_SIZE 2
+#define MAX_VIPS 12
+#define MAX_REALS 5
+#define CTL_MAP_SIZE 16
+#define CH_RINGS_SIZE (MAX_VIPS * RING_SIZE)
+#define F_IPV6 (1 << 0)
+#define F_HASH_NO_SRC_PORT (1 << 0)
+#define F_ICMP (1 << 0)
+#define F_SYN_SET (1 << 1)
+
+struct packet_description {
+	union {
+		__be32 src;
+		__be32 srcv6[4];
+	};
+	union {
+		__be32 dst;
+		__be32 dstv6[4];
+	};
+	union {
+		__u32 ports;
+		__u16 port16[2];
+	};
+	__u8 proto;
+	__u8 flags;
+};
+
+struct ctl_value {
+	union {
+		__u64 value;
+		__u32 ifindex;
+		__u8 mac[6];
+	};
+};
+
+struct vip_meta {
+	__u32 flags;
+	__u32 vip_num;
+};
+
+struct real_definition {
+	union {
+		__be32 dst;
+		__be32 dstv6[4];
+	};
+	__u8 flags;
+};
+
+struct vip_stats {
+	__u64 bytes;
+	__u64 pkts;
+};
+
+struct eth_hdr {
+	unsigned char eth_dest[ETH_ALEN];
+	unsigned char eth_source[ETH_ALEN];
+	unsigned short eth_proto;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, MAX_VIPS);
+	__type(key, struct vip);
+	__type(value, struct vip_meta);
+} vip_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, CH_RINGS_SIZE);
+	__type(key, __u32);
+	__type(value, __u32);
+} ch_rings SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, MAX_REALS);
+	__type(key, __u32);
+	__type(value, struct real_definition);
+} reals SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, MAX_VIPS);
+	__type(key, __u32);
+	__type(value, struct vip_stats);
+} stats SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, CTL_MAP_SIZE);
+	__type(key, __u32);
+	__type(value, struct ctl_value);
+} ctl_array SEC(".maps");
+
+static __noinline __u32 get_packet_hash(struct packet_description *pckt, bool ipv6)
+{
+	if (ipv6)
+		return jhash_2words(jhash(pckt->srcv6, 16, MAX_VIPS),
+				    pckt->ports, CH_RINGS_SIZE);
+	else
+		return jhash_2words(pckt->src, pckt->ports, CH_RINGS_SIZE);
+}
+
+static __noinline bool get_packet_dst(struct real_definition **real,
+				      struct packet_description *pckt,
+				      struct vip_meta *vip_info,
+				      bool is_ipv6)
+{
+	__u32 hash = get_packet_hash(pckt, is_ipv6);
+	__u32 key = RING_SIZE * vip_info->vip_num + hash % RING_SIZE;
+	__u32 *real_pos;
+
+	if (hash != 0x358459b7 /* jhash of ipv4 packet */  &&
+	    hash != 0x2f4bc6bb /* jhash of ipv6 packet */)
+		return false;
+
+	real_pos = bpf_map_lookup_elem(&ch_rings, &key);
+	if (!real_pos)
+		return false;
+	key = *real_pos;
+	*real = bpf_map_lookup_elem(&reals, &key);
+	if (!(*real))
+		return false;
+	return true;
+}
+
+static __noinline int parse_icmpv6(struct bpf_dynptr *skb_ptr, __u64 off,
+				   struct packet_description *pckt)
+{
+	__u8 buffer[sizeof(struct ipv6hdr)] = {};
+	struct icmp6hdr *icmp_hdr;
+	struct ipv6hdr *ip6h;
+
+	icmp_hdr = bpf_dynptr_slice(skb_ptr, off, buffer, sizeof(buffer));
+	if (!icmp_hdr)
+		return TC_ACT_SHOT;
+
+	if (icmp_hdr->icmp6_type != ICMPV6_PKT_TOOBIG)
+		return TC_ACT_OK;
+	off += sizeof(struct icmp6hdr);
+	ip6h = bpf_dynptr_slice(skb_ptr, off, buffer, sizeof(buffer));
+	if (!ip6h)
+		return TC_ACT_SHOT;
+	pckt->proto = ip6h->nexthdr;
+	pckt->flags |= F_ICMP;
+	memcpy(pckt->srcv6, ip6h->daddr.s6_addr32, 16);
+	memcpy(pckt->dstv6, ip6h->saddr.s6_addr32, 16);
+	return TC_ACT_UNSPEC;
+}
+
+static __noinline int parse_icmp(struct bpf_dynptr *skb_ptr, __u64 off,
+				 struct packet_description *pckt)
+{
+	__u8 buffer_icmp[sizeof(struct iphdr)] = {};
+	__u8 buffer_ip[sizeof(struct iphdr)] = {};
+	struct icmphdr *icmp_hdr;
+	struct iphdr *iph;
+
+	icmp_hdr = bpf_dynptr_slice(skb_ptr, off, buffer_icmp, sizeof(buffer_icmp));
+	if (!icmp_hdr)
+		return TC_ACT_SHOT;
+	if (icmp_hdr->type != ICMP_DEST_UNREACH ||
+	    icmp_hdr->code != ICMP_FRAG_NEEDED)
+		return TC_ACT_OK;
+	off += sizeof(struct icmphdr);
+	iph = bpf_dynptr_slice(skb_ptr, off, buffer_ip, sizeof(buffer_ip));
+	if (!iph || iph->ihl != 5)
+		return TC_ACT_SHOT;
+	pckt->proto = iph->protocol;
+	pckt->flags |= F_ICMP;
+	pckt->src = iph->daddr;
+	pckt->dst = iph->saddr;
+	return TC_ACT_UNSPEC;
+}
+
+static __noinline bool parse_udp(struct bpf_dynptr *skb_ptr, __u64 off,
+				 struct packet_description *pckt)
+{
+	__u8 buffer[sizeof(struct udphdr)] = {};
+	struct udphdr *udp;
+
+	udp = bpf_dynptr_slice(skb_ptr, off, buffer, sizeof(buffer));
+	if (!udp)
+		return false;
+
+	if (!(pckt->flags & F_ICMP)) {
+		pckt->port16[0] = udp->source;
+		pckt->port16[1] = udp->dest;
+	} else {
+		pckt->port16[0] = udp->dest;
+		pckt->port16[1] = udp->source;
+	}
+	return true;
+}
+
+static __noinline bool parse_tcp(struct bpf_dynptr *skb_ptr, __u64 off,
+				 struct packet_description *pckt)
+{
+	__u8 buffer[sizeof(struct tcphdr)] = {};
+	struct tcphdr *tcp;
+
+	tcp = bpf_dynptr_slice(skb_ptr, off, buffer, sizeof(buffer));
+	if (!tcp)
+		return false;
+
+	if (tcp->syn)
+		pckt->flags |= F_SYN_SET;
+
+	if (!(pckt->flags & F_ICMP)) {
+		pckt->port16[0] = tcp->source;
+		pckt->port16[1] = tcp->dest;
+	} else {
+		pckt->port16[0] = tcp->dest;
+		pckt->port16[1] = tcp->source;
+	}
+	return true;
+}
+
+static __noinline int process_packet(struct bpf_dynptr *skb_ptr,
+				     struct eth_hdr *eth, __u64 off,
+				     bool is_ipv6, struct __sk_buff *skb)
+{
+	struct packet_description pckt = {};
+	struct bpf_tunnel_key tkey = {};
+	struct vip_stats *data_stats;
+	struct real_definition *dst;
+	struct vip_meta *vip_info;
+	struct ctl_value *cval;
+	__u32 v4_intf_pos = 1;
+	__u32 v6_intf_pos = 2;
+	struct ipv6hdr *ip6h;
+	struct vip vip = {};
+	struct iphdr *iph;
+	int tun_flag = 0;
+	__u16 pkt_bytes;
+	__u64 iph_len;
+	__u32 ifindex;
+	__u8 protocol;
+	__u32 vip_num;
+	int action;
+
+	tkey.tunnel_ttl = 64;
+	if (is_ipv6) {
+		__u8 buffer[sizeof(struct ipv6hdr)] = {};
+
+		ip6h = bpf_dynptr_slice(skb_ptr, off, buffer, sizeof(buffer));
+		if (!ip6h)
+			return TC_ACT_SHOT;
+
+		iph_len = sizeof(struct ipv6hdr);
+		protocol = ip6h->nexthdr;
+		pckt.proto = protocol;
+		pkt_bytes = bpf_ntohs(ip6h->payload_len);
+		off += iph_len;
+		if (protocol == IPPROTO_FRAGMENT) {
+			return TC_ACT_SHOT;
+		} else if (protocol == IPPROTO_ICMPV6) {
+			action = parse_icmpv6(skb_ptr, off, &pckt);
+			if (action >= 0)
+				return action;
+			off += IPV6_PLUS_ICMP_HDR;
+		} else {
+			memcpy(pckt.srcv6, ip6h->saddr.s6_addr32, 16);
+			memcpy(pckt.dstv6, ip6h->daddr.s6_addr32, 16);
+		}
+	} else {
+		__u8 buffer[sizeof(struct iphdr)] = {};
+
+		iph = bpf_dynptr_slice(skb_ptr, off, buffer, sizeof(buffer));
+		if (!iph || iph->ihl != 5)
+			return TC_ACT_SHOT;
+
+		protocol = iph->protocol;
+		pckt.proto = protocol;
+		pkt_bytes = bpf_ntohs(iph->tot_len);
+		off += IPV4_HDR_LEN_NO_OPT;
+
+		if (iph->frag_off & PCKT_FRAGMENTED)
+			return TC_ACT_SHOT;
+		if (protocol == IPPROTO_ICMP) {
+			action = parse_icmp(skb_ptr, off, &pckt);
+			if (action >= 0)
+				return action;
+			off += IPV4_PLUS_ICMP_HDR;
+		} else {
+			pckt.src = iph->saddr;
+			pckt.dst = iph->daddr;
+		}
+	}
+	protocol = pckt.proto;
+
+	if (protocol == IPPROTO_TCP) {
+		if (!parse_tcp(skb_ptr, off, &pckt))
+			return TC_ACT_SHOT;
+	} else if (protocol == IPPROTO_UDP) {
+		if (!parse_udp(skb_ptr, off, &pckt))
+			return TC_ACT_SHOT;
+	} else {
+		return TC_ACT_SHOT;
+	}
+
+	if (is_ipv6)
+		memcpy(vip.daddr.v6, pckt.dstv6, 16);
+	else
+		vip.daddr.v4 = pckt.dst;
+
+	vip.dport = pckt.port16[1];
+	vip.protocol = pckt.proto;
+	vip_info = bpf_map_lookup_elem(&vip_map, &vip);
+	if (!vip_info) {
+		vip.dport = 0;
+		vip_info = bpf_map_lookup_elem(&vip_map, &vip);
+		if (!vip_info)
+			return TC_ACT_SHOT;
+		pckt.port16[1] = 0;
+	}
+
+	if (vip_info->flags & F_HASH_NO_SRC_PORT)
+		pckt.port16[0] = 0;
+
+	if (!get_packet_dst(&dst, &pckt, vip_info, is_ipv6))
+		return TC_ACT_SHOT;
+
+	if (dst->flags & F_IPV6) {
+		cval = bpf_map_lookup_elem(&ctl_array, &v6_intf_pos);
+		if (!cval)
+			return TC_ACT_SHOT;
+		ifindex = cval->ifindex;
+		memcpy(tkey.remote_ipv6, dst->dstv6, 16);
+		tun_flag = BPF_F_TUNINFO_IPV6;
+	} else {
+		cval = bpf_map_lookup_elem(&ctl_array, &v4_intf_pos);
+		if (!cval)
+			return TC_ACT_SHOT;
+		ifindex = cval->ifindex;
+		tkey.remote_ipv4 = dst->dst;
+	}
+	vip_num = vip_info->vip_num;
+	data_stats = bpf_map_lookup_elem(&stats, &vip_num);
+	if (!data_stats)
+		return TC_ACT_SHOT;
+	data_stats->pkts++;
+	data_stats->bytes += pkt_bytes;
+	bpf_skb_set_tunnel_key(skb, &tkey, sizeof(tkey), tun_flag);
+	*(u32 *)eth->eth_dest = tkey.remote_ipv4;
+	return bpf_redirect(ifindex, 0);
+}
+
+SEC("tc")
+int balancer_ingress(struct __sk_buff *ctx)
+{
+	__u8 buffer[sizeof(struct eth_hdr)] = {};
+	struct bpf_dynptr ptr;
+	struct eth_hdr *eth;
+	__u32 eth_proto;
+	__u32 nh_off;
+	int err;
+
+	nh_off = sizeof(struct eth_hdr);
+
+	bpf_dynptr_from_skb(ctx, 0, &ptr);
+	eth = bpf_dynptr_slice_rdwr(&ptr, 0, buffer, sizeof(buffer));
+	if (!eth)
+		return TC_ACT_SHOT;
+	eth_proto = eth->eth_proto;
+	if (eth_proto == bpf_htons(ETH_P_IP))
+		err = process_packet(&ptr, eth, nh_off, false, ctx);
+	else if (eth_proto == bpf_htons(ETH_P_IPV6))
+		err = process_packet(&ptr, eth, nh_off, true, ctx);
+	else
+		return TC_ACT_SHOT;
+
+	if (eth == buffer)
+		bpf_dynptr_write(&ptr, 0, buffer, sizeof(buffer), 0);
+
+	return err;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c b/tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
new file mode 100644
index 000000000000..79bab9b50e9e
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* This parsing logic is taken from the open source library katran, a layer 4
+ * load balancer.
+ *
+ * This code logic using dynptrs can be found in test_parse_tcp_hdr_opt_dynptr.c
+ *
+ * https://github.com/facebookincubator/katran/blob/main/katran/lib/bpf/pckt_parsing.h
+ */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/tcp.h>
+#include <stdbool.h>
+#include <linux/ipv6.h>
+#include <linux/if_ether.h>
+#include "test_tcp_hdr_options.h"
+
+char _license[] SEC("license") = "GPL";
+
+/* Kind number used for experiments */
+const __u32 tcp_hdr_opt_kind_tpr = 0xFD;
+/* Length of the tcp header option */
+const __u32 tcp_hdr_opt_len_tpr = 6;
+/* maximum number of header options to check to lookup server_id */
+const __u32 tcp_hdr_opt_max_opt_checks = 15;
+
+__u32 server_id;
+
+struct hdr_opt_state {
+	__u32 server_id;
+	__u8 byte_offset;
+	__u8 hdr_bytes_remaining;
+};
+
+static int parse_hdr_opt(const struct xdp_md *xdp, struct hdr_opt_state *state)
+{
+	const void *data = (void *)(long)xdp->data;
+	const void *data_end = (void *)(long)xdp->data_end;
+	__u8 *tcp_opt, kind, hdr_len;
+
+	tcp_opt = (__u8 *)(data + state->byte_offset);
+	if (tcp_opt + 1 > data_end)
+		return -1;
+
+	kind = tcp_opt[0];
+
+	if (kind == TCPOPT_EOL)
+		return -1;
+
+	if (kind == TCPOPT_NOP) {
+		state->hdr_bytes_remaining--;
+		state->byte_offset++;
+		return 0;
+	}
+
+	if (state->hdr_bytes_remaining < 2 ||
+	    tcp_opt + sizeof(__u8) + sizeof(__u8) > data_end)
+		return -1;
+
+	hdr_len = tcp_opt[1];
+	if (hdr_len > state->hdr_bytes_remaining)
+		return -1;
+
+	if (kind == tcp_hdr_opt_kind_tpr) {
+		if (hdr_len != tcp_hdr_opt_len_tpr)
+			return -1;
+
+		if (tcp_opt + tcp_hdr_opt_len_tpr > data_end)
+			return -1;
+
+		state->server_id = *(__u32 *)&tcp_opt[2];
+		return 1;
+	}
+
+	state->hdr_bytes_remaining -= hdr_len;
+	state->byte_offset += hdr_len;
+	return 0;
+}
+
+SEC("xdp")
+int xdp_ingress_v6(struct xdp_md *xdp)
+{
+	const void *data = (void *)(long)xdp->data;
+	const void *data_end = (void *)(long)xdp->data_end;
+	struct hdr_opt_state opt_state = {};
+	__u8 tcp_hdr_opt_len = 0;
+	struct tcphdr *tcp_hdr;
+	__u64 tcp_offset = 0;
+	__u32 off;
+	int err;
+
+	tcp_offset = sizeof(struct ethhdr) + sizeof(struct ipv6hdr);
+	tcp_hdr = (struct tcphdr *)(data + tcp_offset);
+	if (tcp_hdr + 1 > data_end)
+		return XDP_DROP;
+
+	tcp_hdr_opt_len = (tcp_hdr->doff * 4) - sizeof(struct tcphdr);
+	if (tcp_hdr_opt_len < tcp_hdr_opt_len_tpr)
+		return XDP_DROP;
+
+	opt_state.hdr_bytes_remaining = tcp_hdr_opt_len;
+	opt_state.byte_offset = sizeof(struct tcphdr) + tcp_offset;
+
+	/* max number of bytes of options in tcp header is 40 bytes */
+	for (int i = 0; i < tcp_hdr_opt_max_opt_checks; i++) {
+		err = parse_hdr_opt(xdp, &opt_state);
+
+		if (err || !opt_state.hdr_bytes_remaining)
+			break;
+	}
+
+	if (!opt_state.server_id)
+		return XDP_DROP;
+
+	server_id = opt_state.server_id;
+
+	return XDP_PASS;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c b/tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
new file mode 100644
index 000000000000..d3b319722e30
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* This logic is lifted from a real-world use case of packet parsing, used in
+ * the open source library katran, a layer 4 load balancer.
+ *
+ * This test demonstrates how to parse packet contents using dynptrs. The
+ * original code (parsing without dynptrs) can be found in test_parse_tcp_hdr_opt.c
+ */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/tcp.h>
+#include <stdbool.h>
+#include <linux/ipv6.h>
+#include <linux/if_ether.h>
+#include "test_tcp_hdr_options.h"
+#include "bpf_kfuncs.h"
+
+char _license[] SEC("license") = "GPL";
+
+/* Kind number used for experiments */
+const __u32 tcp_hdr_opt_kind_tpr = 0xFD;
+/* Length of the tcp header option */
+const __u32 tcp_hdr_opt_len_tpr = 6;
+/* maximum number of header options to check to lookup server_id */
+const __u32 tcp_hdr_opt_max_opt_checks = 15;
+
+__u32 server_id;
+
+static int parse_hdr_opt(struct bpf_dynptr *ptr, __u32 *off, __u8 *hdr_bytes_remaining,
+			 __u32 *server_id)
+{
+	__u8 *tcp_opt, kind, hdr_len;
+	__u8 buffer[sizeof(kind) + sizeof(hdr_len) + sizeof(*server_id)];
+	__u8 *data;
+
+	__builtin_memset(buffer, 0, sizeof(buffer));
+
+	data = bpf_dynptr_slice(ptr, *off, buffer, sizeof(buffer));
+	if (!data)
+		return -1;
+
+	kind = data[0];
+
+	if (kind == TCPOPT_EOL)
+		return -1;
+
+	if (kind == TCPOPT_NOP) {
+		*off += 1;
+		*hdr_bytes_remaining -= 1;
+		return 0;
+	}
+
+	if (*hdr_bytes_remaining < 2)
+		return -1;
+
+	hdr_len = data[1];
+	if (hdr_len > *hdr_bytes_remaining)
+		return -1;
+
+	if (kind == tcp_hdr_opt_kind_tpr) {
+		if (hdr_len != tcp_hdr_opt_len_tpr)
+			return -1;
+
+		__builtin_memcpy(server_id, (__u32 *)(data + 2), sizeof(*server_id));
+		return 1;
+	}
+
+	*off += hdr_len;
+	*hdr_bytes_remaining -= hdr_len;
+	return 0;
+}
+
+SEC("xdp")
+int xdp_ingress_v6(struct xdp_md *xdp)
+{
+	__u8 buffer[sizeof(struct tcphdr)] = {};
+	__u8 hdr_bytes_remaining;
+	struct tcphdr *tcp_hdr;
+	__u8 tcp_hdr_opt_len;
+	int err = 0;
+	__u32 off;
+
+	struct bpf_dynptr ptr;
+
+	bpf_dynptr_from_xdp(xdp, 0, &ptr);
+
+	off = sizeof(struct ethhdr) + sizeof(struct ipv6hdr);
+
+	tcp_hdr = bpf_dynptr_slice(&ptr, off, buffer, sizeof(buffer));
+	if (!tcp_hdr)
+		return XDP_DROP;
+
+	tcp_hdr_opt_len = (tcp_hdr->doff * 4) - sizeof(struct tcphdr);
+	if (tcp_hdr_opt_len < tcp_hdr_opt_len_tpr)
+		return XDP_DROP;
+
+	hdr_bytes_remaining = tcp_hdr_opt_len;
+
+	off += sizeof(struct tcphdr);
+
+	/* max number of bytes of options in tcp header is 40 bytes */
+	for (int i = 0; i < tcp_hdr_opt_max_opt_checks; i++) {
+		err = parse_hdr_opt(&ptr, &off, &hdr_bytes_remaining, &server_id);
+
+		if (err || !hdr_bytes_remaining)
+			break;
+	}
+
+	if (!server_id)
+		return XDP_DROP;
+
+	return XDP_PASS;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c b/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
new file mode 100644
index 000000000000..7521a805b506
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Meta */
+#include <stddef.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/in.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <linux/pkt_cls.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include "test_iptunnel_common.h"
+#include "bpf_kfuncs.h"
+
+const size_t tcphdr_sz = sizeof(struct tcphdr);
+const size_t udphdr_sz = sizeof(struct udphdr);
+const size_t ethhdr_sz = sizeof(struct ethhdr);
+const size_t iphdr_sz = sizeof(struct iphdr);
+const size_t ipv6hdr_sz = sizeof(struct ipv6hdr);
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 256);
+	__type(key, __u32);
+	__type(value, __u64);
+} rxcnt SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, MAX_IPTNL_ENTRIES);
+	__type(key, struct vip);
+	__type(value, struct iptnl_info);
+} vip2tnl SEC(".maps");
+
+static __always_inline void count_tx(__u32 protocol)
+{
+	__u64 *rxcnt_count;
+
+	rxcnt_count = bpf_map_lookup_elem(&rxcnt, &protocol);
+	if (rxcnt_count)
+		*rxcnt_count += 1;
+}
+
+static __always_inline int get_dport(void *trans_data, __u8 protocol)
+{
+	struct tcphdr *th;
+	struct udphdr *uh;
+
+	switch (protocol) {
+	case IPPROTO_TCP:
+		th = (struct tcphdr *)trans_data;
+		return th->dest;
+	case IPPROTO_UDP:
+		uh = (struct udphdr *)trans_data;
+		return uh->dest;
+	default:
+		return 0;
+	}
+}
+
+static __always_inline void set_ethhdr(struct ethhdr *new_eth,
+				       const struct ethhdr *old_eth,
+				       const struct iptnl_info *tnl,
+				       __be16 h_proto)
+{
+	memcpy(new_eth->h_source, old_eth->h_dest, sizeof(new_eth->h_source));
+	memcpy(new_eth->h_dest, tnl->dmac, sizeof(new_eth->h_dest));
+	new_eth->h_proto = h_proto;
+}
+
+static __always_inline int handle_ipv4(struct xdp_md *xdp, struct bpf_dynptr *xdp_ptr)
+{
+	__u8 eth_buffer[ethhdr_sz + iphdr_sz + ethhdr_sz];
+	__u8 iph_buffer_tcp[iphdr_sz + tcphdr_sz];
+	__u8 iph_buffer_udp[iphdr_sz + udphdr_sz];
+	struct bpf_dynptr new_xdp_ptr;
+	struct iptnl_info *tnl;
+	struct ethhdr *new_eth;
+	struct ethhdr *old_eth;
+	__u32 transport_hdr_sz;
+	struct iphdr *iph;
+	__u16 *next_iph;
+	__u16 payload_len;
+	struct vip vip = {};
+	int dport;
+	__u32 csum = 0;
+	int i;
+
+	__builtin_memset(eth_buffer, 0, sizeof(eth_buffer));
+	__builtin_memset(iph_buffer_tcp, 0, sizeof(iph_buffer_tcp));
+	__builtin_memset(iph_buffer_udp, 0, sizeof(iph_buffer_udp));
+
+	if (ethhdr_sz + iphdr_sz + tcphdr_sz > xdp->data_end - xdp->data)
+		iph = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, iph_buffer_udp, sizeof(iph_buffer_udp));
+	else
+		iph = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, iph_buffer_tcp, sizeof(iph_buffer_tcp));
+
+	if (!iph)
+		return XDP_DROP;
+
+	dport = get_dport(iph + 1, iph->protocol);
+	if (dport == -1)
+		return XDP_DROP;
+
+	vip.protocol = iph->protocol;
+	vip.family = AF_INET;
+	vip.daddr.v4 = iph->daddr;
+	vip.dport = dport;
+	payload_len = bpf_ntohs(iph->tot_len);
+
+	tnl = bpf_map_lookup_elem(&vip2tnl, &vip);
+	/* It only does v4-in-v4 */
+	if (!tnl || tnl->family != AF_INET)
+		return XDP_PASS;
+
+	if (bpf_xdp_adjust_head(xdp, 0 - (int)iphdr_sz))
+		return XDP_DROP;
+
+	bpf_dynptr_from_xdp(xdp, 0, &new_xdp_ptr);
+	new_eth = bpf_dynptr_slice_rdwr(&new_xdp_ptr, 0, eth_buffer, sizeof(eth_buffer));
+	if (!new_eth)
+		return XDP_DROP;
+
+	iph = (struct iphdr *)(new_eth + 1);
+	old_eth = (struct ethhdr *)(iph + 1);
+
+	set_ethhdr(new_eth, old_eth, tnl, bpf_htons(ETH_P_IP));
+
+	if (new_eth == eth_buffer)
+		bpf_dynptr_write(&new_xdp_ptr, 0, eth_buffer, sizeof(eth_buffer), 0);
+
+	iph->version = 4;
+	iph->ihl = iphdr_sz >> 2;
+	iph->frag_off =	0;
+	iph->protocol = IPPROTO_IPIP;
+	iph->check = 0;
+	iph->tos = 0;
+	iph->tot_len = bpf_htons(payload_len + iphdr_sz);
+	iph->daddr = tnl->daddr.v4;
+	iph->saddr = tnl->saddr.v4;
+	iph->ttl = 8;
+
+	next_iph = (__u16 *)iph;
+	for (i = 0; i < iphdr_sz >> 1; i++)
+		csum += *next_iph++;
+
+	iph->check = ~((csum & 0xffff) + (csum >> 16));
+
+	count_tx(vip.protocol);
+
+	return XDP_TX;
+}
+
+static __always_inline int handle_ipv6(struct xdp_md *xdp, struct bpf_dynptr *xdp_ptr)
+{
+	__u8 eth_buffer[ethhdr_sz + ipv6hdr_sz + ethhdr_sz];
+	__u8 ip6h_buffer_tcp[ipv6hdr_sz + tcphdr_sz];
+	__u8 ip6h_buffer_udp[ipv6hdr_sz + udphdr_sz];
+	struct bpf_dynptr new_xdp_ptr;
+	struct iptnl_info *tnl;
+	struct ethhdr *new_eth;
+	struct ethhdr *old_eth;
+	__u32 transport_hdr_sz;
+	struct ipv6hdr *ip6h;
+	__u16 payload_len;
+	struct vip vip = {};
+	int dport;
+
+	__builtin_memset(eth_buffer, 0, sizeof(eth_buffer));
+	__builtin_memset(ip6h_buffer_tcp, 0, sizeof(ip6h_buffer_tcp));
+	__builtin_memset(ip6h_buffer_udp, 0, sizeof(ip6h_buffer_udp));
+
+	if (ethhdr_sz + iphdr_sz + tcphdr_sz > xdp->data_end - xdp->data)
+		ip6h = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, ip6h_buffer_udp, sizeof(ip6h_buffer_udp));
+	else
+		ip6h = bpf_dynptr_slice(xdp_ptr, ethhdr_sz, ip6h_buffer_tcp, sizeof(ip6h_buffer_tcp));
+
+	if (!ip6h)
+		return XDP_DROP;
+
+	dport = get_dport(ip6h + 1, ip6h->nexthdr);
+	if (dport == -1)
+		return XDP_DROP;
+
+	vip.protocol = ip6h->nexthdr;
+	vip.family = AF_INET6;
+	memcpy(vip.daddr.v6, ip6h->daddr.s6_addr32, sizeof(vip.daddr));
+	vip.dport = dport;
+	payload_len = ip6h->payload_len;
+
+	tnl = bpf_map_lookup_elem(&vip2tnl, &vip);
+	/* It only does v6-in-v6 */
+	if (!tnl || tnl->family != AF_INET6)
+		return XDP_PASS;
+
+	if (bpf_xdp_adjust_head(xdp, 0 - (int)ipv6hdr_sz))
+		return XDP_DROP;
+
+	bpf_dynptr_from_xdp(xdp, 0, &new_xdp_ptr);
+	new_eth = bpf_dynptr_slice_rdwr(&new_xdp_ptr, 0, eth_buffer, sizeof(eth_buffer));
+	if (!new_eth)
+		return XDP_DROP;
+
+	ip6h = (struct ipv6hdr *)(new_eth + 1);
+	old_eth = (struct ethhdr *)(ip6h + 1);
+
+	set_ethhdr(new_eth, old_eth, tnl, bpf_htons(ETH_P_IPV6));
+
+	if (new_eth == eth_buffer)
+		bpf_dynptr_write(&new_xdp_ptr, 0, eth_buffer, sizeof(eth_buffer), 0);
+
+	ip6h->version = 6;
+	ip6h->priority = 0;
+	memset(ip6h->flow_lbl, 0, sizeof(ip6h->flow_lbl));
+	ip6h->payload_len = bpf_htons(bpf_ntohs(payload_len) + ipv6hdr_sz);
+	ip6h->nexthdr = IPPROTO_IPV6;
+	ip6h->hop_limit = 8;
+	memcpy(ip6h->saddr.s6_addr32, tnl->saddr.v6, sizeof(tnl->saddr.v6));
+	memcpy(ip6h->daddr.s6_addr32, tnl->daddr.v6, sizeof(tnl->daddr.v6));
+
+	count_tx(vip.protocol);
+
+	return XDP_TX;
+}
+
+SEC("xdp")
+int _xdp_tx_iptunnel(struct xdp_md *xdp)
+{
+	__u8 buffer[ethhdr_sz];
+	struct bpf_dynptr ptr;
+	struct ethhdr *eth;
+	__u16 h_proto;
+
+	__builtin_memset(buffer, 0, sizeof(buffer));
+
+	bpf_dynptr_from_xdp(xdp, 0, &ptr);
+	eth = bpf_dynptr_slice(&ptr, 0, buffer, sizeof(buffer));
+	if (!eth)
+		return XDP_DROP;
+
+	h_proto = eth->h_proto;
+
+	if (h_proto == bpf_htons(ETH_P_IP))
+		return handle_ipv4(xdp, &ptr);
+	else if (h_proto == bpf_htons(ETH_P_IPV6))
+
+		return handle_ipv6(xdp, &ptr);
+	else
+		return XDP_DROP;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_tcp_hdr_options.h b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
index 6118e3ab61fc..56c9f8a3ad3d 100644
--- a/tools/testing/selftests/bpf/test_tcp_hdr_options.h
+++ b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
@@ -50,6 +50,7 @@ struct linum_err {
 
 #define TCPOPT_EOL		0
 #define TCPOPT_NOP		1
+#define TCPOPT_MSS		2
 #define TCPOPT_WINDOW		3
 #define TCPOPT_EXP		254
 
-- 
2.34.1

