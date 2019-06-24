Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912D751D86
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbfFXV6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:58:35 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:50613 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730509AbfFXV6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:58:34 -0400
Received: by mail-vk1-f202.google.com with SMTP id 184so6935055vku.17
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WM1PwngXUHJVIZUY5Hi5Z7Be1J3rGjgGma6FcVVihds=;
        b=lfCtQpZiCWc34g55JVvkNmafcP54TtfNE7Aa723Yk8wUHsCdO79NjiGcp0iPWCwn70
         VI32DsOOFVcfmfBbiYot5JSYi7HJj1FADNl5DJ+3939LV3HrjknvedVGSJDSjXseybkW
         1lGURD5reNzCc0b4p1FvRPw/zVV76CXTCP2cJoOLZ9yk1DqaZGiTBs4Y1WMC3wUHupim
         CGjHCQcG0cKG+rKAv5cfalhgYfpTPcQTTyHnZFufAAXJgXY21XOPdp7chLG7pOkj4meJ
         DeM91K253Du+oinN5PeFn0gah1KqtZvaZToXtLid1K8UAuVAHRnI34kITSg4LdWKHZ53
         1jSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WM1PwngXUHJVIZUY5Hi5Z7Be1J3rGjgGma6FcVVihds=;
        b=HihRLYm+uN0PHEibaNDnuLvKwytdHYJFm+Tl7G1Y5JeOhHvf3qOfDQVAIlZakMTCSX
         u1vAitTqERa5oiqIu/2jixfrVl9tgoad9y1DeQem3VoVMooXBpWjOKnybfx7BuatoEAE
         Q0eWNkiM+4gCTNpH6PjNTMsKNq2m9StRcher7hkR2t8wHZB3YGMim4IAi/1+ZoSsKSXl
         MGvqjN1+g+nshf1QCNHLGh2SrJicwYUQoKQeD3PC65ZWRSqGbj81j8mZPBlYsJm1tdNr
         Y78wGPx/9JeSmb68jRwplG0YegUtbiBYwl5hH7nngTXhpfe8wOMymzpZqU8nkHP/dlmQ
         0WSQ==
X-Gm-Message-State: APjAAAWj9bw0zNKt2osjT9VFpeoYGnXnamSfddvq74qzu18a8xbC43At
        bZKy6DyPYu1hEcujjFrWwInOxwP/uD0ja+kp
X-Google-Smtp-Source: APXvYqwEcwr/WJqBDzuWwtow63hwiIMrTBymwUcYrl7r4AhEaZiC+5aXjD7Oa0vMdvVkkJoCPzI4qdmvHjtaCbQi
X-Received: by 2002:ac5:c2d2:: with SMTP id i18mr3069909vkk.36.1561413513053;
 Mon, 24 Jun 2019 14:58:33 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:58:24 -0700
In-Reply-To: <20190624215824.118783-1-allanzhang@google.com>
Message-Id: <20190624215824.118783-3-allanzhang@google.com>
Mime-Version: 1.0
References: <20190624215824.118783-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH]     bpf: Allow bpf_skb_event_output for a few prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

    Software event output is only enabled by a few prog types right now (TC,
    LWT out, XDP, sockops). Many other skb based prog types need
    bpf_skb_event_output to produce software event.

    Added socket_filter, cg_skb, sk_skb prog types to generate sw event.

    Test bpf code is generated from code snippet:

    struct TMP {
        uint64_t tmp;
    } tt;
    tt.tmp = 5;
    bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
                          &tt, sizeof(tt));
    return 1;

    the bpf assembly from llvm is:
           0:       b7 02 00 00 05 00 00 00         r2 = 5
           1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
           2:       bf a4 00 00 00 00 00 00         r4 = r10
           3:       07 04 00 00 f8 ff ff ff         r4 += -8
           4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
           6:       b7 03 00 00 00 00 00 00         r3 = 0
           7:       b7 05 00 00 08 00 00 00         r5 = 8
           8:       85 00 00 00 19 00 00 00         call 25
           9:       b7 00 00 00 01 00 00 00         r0 = 1
          10:       95 00 00 00 00 00 00 00         exit

    Patch 1 is enabling code.
    Patch 2 is fullly covered selftest code.

Signed-off-by: allanzhang <allanzhang@google.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 38 +++++++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 2 files changed, 130 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c5514daf8865..45ce9dd4323f 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1,10 +1,13 @@
-// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Testsuite for eBPF verifier
  *
  * Copyright (c) 2014 PLUMgrid, http://plumgrid.com
  * Copyright (c) 2017 Facebook
  * Copyright (c) 2018 Covalent IO, Inc. http://covalent.io
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
  */
 
 #include <endian.h>
@@ -50,7 +53,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	18
+#define MAX_NR_MAPS	19
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -84,6 +87,7 @@ struct bpf_test {
 	int fixup_map_array_wo[MAX_FIXUPS];
 	int fixup_map_array_small[MAX_FIXUPS];
 	int fixup_sk_storage_map[MAX_FIXUPS];
+	int fixup_map_event_output[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t retval, retval_unpriv, insn_processed;
@@ -604,6 +608,28 @@ static int create_sk_storage_map(void)
 	return fd;
 }
 
+static int create_event_output_map(void)
+{
+	struct bpf_create_map_attr attr = {
+		.name = "test_map",
+		.map_type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+		.key_size = 4,
+		.value_size = 4,
+		.max_entries = 1,
+	};
+	int fd, btf_fd;
+
+	btf_fd = load_btf();
+	if (btf_fd < 0)
+		return -1;
+	attr.btf_fd = btf_fd;
+	fd = bpf_create_map_xattr(&attr);
+	close(attr.btf_fd);
+	if (fd < 0)
+		printf("Failed to create event_output\n");
+	return fd;
+}
+
 static char bpf_vlog[UINT_MAX >> 8];
 
 static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
@@ -627,6 +653,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_array_wo = test->fixup_map_array_wo;
 	int *fixup_map_array_small = test->fixup_map_array_small;
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
+	int *fixup_map_event_output = test->fixup_map_event_output;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -788,6 +815,13 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_sk_storage_map++;
 		} while (*fixup_sk_storage_map);
 	}
+	if (*fixup_map_event_output) {
+		map_fds[18] = create_event_output_map();
+		do {
+			prog[*fixup_map_event_output].imm = map_fds[18];
+			fixup_map_event_output++;
+		} while (*fixup_map_event_output);
+	}
 }
 
 static int set_admin(bool admin)
diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
new file mode 100644
index 000000000000..b25eabcfaa56
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/event_output.c
@@ -0,0 +1,94 @@
+/* instructions used to output a skb based software event, produced
+ * from code snippet:
+struct TMP {
+  uint64_t tmp;
+} tt;
+tt.tmp = 5;
+bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
+		      &tt, sizeof(tt));
+return 1;
+
+the bpf assembly from llvm is:
+       0:       b7 02 00 00 05 00 00 00         r2 = 5
+       1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
+       2:       bf a4 00 00 00 00 00 00         r4 = r10
+       3:       07 04 00 00 f8 ff ff ff         r4 += -8
+       4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
+       6:       b7 03 00 00 00 00 00 00         r3 = 0
+       7:       b7 05 00 00 08 00 00 00         r5 = 8
+       8:       85 00 00 00 19 00 00 00         call 25
+       9:       b7 00 00 00 01 00 00 00         r0 = 1
+      10:       95 00 00 00 00 00 00 00         exit
+
+    The reason I put the code here instead of fill_helpers is that map fixup is
+    against the insns, instead of filled prog.
+*/
+
+#define __PERF_EVENT_INSNS__					\
+	BPF_MOV64_IMM(BPF_REG_2, 5),				\
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_2, -8),		\
+	BPF_MOV64_REG(BPF_REG_4, BPF_REG_10),			\
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_4, -8),			\
+	BPF_LD_MAP_FD(BPF_REG_2, 0),				\
+	BPF_MOV64_IMM(BPF_REG_3, 0),				\
+	BPF_MOV64_IMM(BPF_REG_5, 8),				\
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,		\
+		     BPF_FUNC_perf_event_output),		\
+	BPF_MOV64_IMM(BPF_REG_0, 1),				\
+	BPF_EXIT_INSN(),
+{
+	"perfevent for sockops",
+	.insns = { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SOCK_OPS,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for tc",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for lwt out",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_LWT_OUT,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for xdp",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for socket filter",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for sk_skb",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_SK_SKB,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"perfevent for cgroup skb",
+	.insns =  { __PERF_EVENT_INSNS__ },
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+	.fixup_map_event_output = { 4 },
+	.result = ACCEPT,
+	.retval = 1,
+},
-- 
2.22.0.410.gd8fdbe21b5-goog

