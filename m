Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE18554E6E2
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377736AbiFPQUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377556AbiFPQUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:20:43 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1513B3E0
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:20:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id fu3so3730485ejc.7
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=94i7gvXiMSDgTQuQdzpNYwdXGZQaEeCGYxGl+yxQ7o4=;
        b=MIcx56+NC/9QpnpK/klLHaEYMH5UGJ03GODNpN6R+BxslS8lSUF6ekfgPmIuWHppdN
         ODXZAjy3+03VB8Kd1Z3cleTG2z0k5fRFHnsQqsGnjL0QNYA4R/3XlCtQ+et0K2NAR64/
         CqVk4pkhqN+oGCMa0KmQRtQqMDQJMpHyq2kM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94i7gvXiMSDgTQuQdzpNYwdXGZQaEeCGYxGl+yxQ7o4=;
        b=8LAPGoUQnzAAXZ6aBSNYszwsH4adf2VtVNTB1a4Jjjvg5I5s8U1hQ+XlBr7zMsAd64
         QLLJU1g5CkM5NkUjCfTbI7F1eOndksIv09OcSxiiKlrW9u84KWMU2+SI/RdMvmCQU+en
         xas7CR5FwQPBNIFKVPwrn92cHGNjU25HIXLYUotKL6w40504dZjZhqb+XeemlQMJiZ4q
         GIElC0X+xIqfm8vPwB+33bnfcsS17aJJ0ft5vMFc066R7HeuoQel0R8kPotcddk9j4p1
         R4ikxhX8U+V5CzYmm24S7JELTYZxFLaw/Yqm7GiaUDFxSHYPA3/VR0O25/MORY2Hzf8J
         lpMQ==
X-Gm-Message-State: AJIora+OQqPK86RhmB5Qg4YAKyW/PJuGCW2/eYoUXKq721PTEVW76jIz
        QiZGIeyL1enq7BXFaSlPZP9Urw==
X-Google-Smtp-Source: AGRyM1uyT88ThyLGIktmGLKL13mTQa08vRDm4eg8CMt7IOuLiTU71Z1V5inupf4QamscUjXlUM3i8A==
X-Received: by 2002:a17:906:7308:b0:710:dabe:d651 with SMTP id di8-20020a170906730800b00710dabed651mr5276250ejc.75.1655396440871;
        Thu, 16 Jun 2022 09:20:40 -0700 (PDT)
Received: from cloudflare.com (79.184.138.130.ipv4.supernova.orange.pl. [79.184.138.130])
        by smtp.gmail.com with ESMTPSA id y4-20020aa7ccc4000000b004316f94ec4esm2022647edt.66.2022.06.16.09.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 09:20:40 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: Test tail call counting with bpf2bpf and data on stack
Date:   Thu, 16 Jun 2022 18:20:37 +0200
Message-Id: <20220616162037.535469-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220616162037.535469-1-jakub@cloudflare.com>
References: <20220616162037.535469-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cover the case when tail call count needs to be passed from BPF function to
BPF function, and the caller has data on stack. Specifically when the size
of data allocated on BPF stack is not a multiple on 8.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 55 +++++++++++++++++++
 .../selftests/bpf/progs/tailcall_bpf2bpf6.c   | 42 ++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index c4da87ec3ba4..19c70880cfb3 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -831,6 +831,59 @@ static void test_tailcall_bpf2bpf_4(bool noise)
 	bpf_object__close(obj);
 }
 
+#include "tailcall_bpf2bpf6.skel.h"
+
+/* Tail call counting works even when there is data on stack which is
+ * not aligned to 8 bytes.
+ */
+static void test_tailcall_bpf2bpf_6(void)
+{
+	struct tailcall_bpf2bpf6 *obj;
+	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.repeat = 1,
+	);
+
+	obj = tailcall_bpf2bpf6__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "open and load"))
+		return;
+
+	main_fd = bpf_program__fd(obj->progs.entry);
+	if (!ASSERT_GE(main_fd, 0, "entry prog fd"))
+		goto out;
+
+	map_fd = bpf_map__fd(obj->maps.jmp_table);
+	if (!ASSERT_GE(map_fd, 0, "jmp_table map fd"))
+		goto out;
+
+	prog_fd = bpf_program__fd(obj->progs.classifier_0);
+	if (!ASSERT_GE(prog_fd, 0, "classifier_0 prog fd"))
+		goto out;
+
+	i = 0;
+	err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
+	if (!ASSERT_OK(err, "jmp_table map update"))
+		goto out;
+
+	err = bpf_prog_test_run_opts(main_fd, &topts);
+	ASSERT_OK(err, "entry prog test run");
+	ASSERT_EQ(topts.retval, 0, "tailcall retval");
+
+	data_fd = bpf_map__fd(obj->maps.bss);
+	if (!ASSERT_GE(map_fd, 0, "bss map fd"))
+		goto out;
+
+	i = 0;
+	err = bpf_map_lookup_elem(data_fd, &i, &val);
+	ASSERT_OK(err, "bss map lookup");
+	ASSERT_EQ(val, 1, "done flag is set");
+
+out:
+	tailcall_bpf2bpf6__destroy(obj);
+}
+
 void test_tailcalls(void)
 {
 	if (test__start_subtest("tailcall_1"))
@@ -855,4 +908,6 @@ void test_tailcalls(void)
 		test_tailcall_bpf2bpf_4(false);
 	if (test__start_subtest("tailcall_bpf2bpf_5"))
 		test_tailcall_bpf2bpf_4(true);
+	if (test__start_subtest("tailcall_bpf2bpf_6"))
+		test_tailcall_bpf2bpf_6();
 }
diff --git a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
new file mode 100644
index 000000000000..41ce83da78e8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define __unused __attribute__((unused))
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
+int done = 0;
+
+SEC("tc")
+int classifier_0(struct __sk_buff *skb __unused)
+{
+	done = 1;
+	return 0;
+}
+
+static __noinline
+int subprog_tail(struct __sk_buff *skb)
+{
+	/* Don't propagate the constant to the caller */
+	volatile int ret = 1;
+
+	bpf_tail_call_static(skb, &jmp_table, 0);
+	return ret;
+}
+
+SEC("tc")
+int entry(struct __sk_buff *skb)
+{
+	/* Have data on stack which size is not a multiple of 8 */
+	volatile char arr[1] = {};
+
+	return subprog_tail(skb);
+}
+
+char __license[] SEC("license") = "GPL";
-- 
2.35.3

