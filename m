Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D67763A5F
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfGISAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:00:15 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:40687 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGISAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:00:15 -0400
Received: by mail-pg1-f202.google.com with SMTP id d187so13125073pga.7
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0WL/jljCGlROBH86CmnLzOjHAwL3bkQ6tSEEkvmazWc=;
        b=h5tSM8nL07/m+8Av0K7HlxDZ3vU1SmdxK+j9hWkrNS/L0b9wuBb8gJ0MrVeO/TUp+j
         tujMTanN7QcZiPfIBV3QI5oHpGgs9wDTxeW3VRJbVbSP0np0wA33HH3n6muszebXpR4B
         SHfIxWBt7k2mDPVupVFrAnsnYs5Ty9MTQfmvGQaJl6mSe998ZOFgtunj3QSEqbedAYJX
         rtV9wFadPm4G7fmjH3zCY/SzZdiS+dCJGci8SpXxFYHIS7RCSZL307CszMDI6PIv0Bz1
         OorX9uNS8hV/7JT0GKd1SGYbVoy9c099JzJmXj0LsEoxIM0SjL5BM2OVbC70nu45PKE/
         FfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0WL/jljCGlROBH86CmnLzOjHAwL3bkQ6tSEEkvmazWc=;
        b=ok9UPVDZ5Zk+o3msskv94mAdWVbg932KBJkmatOCjQzs/eUfrENGKF1U3zWBWGsh5U
         j7Q2Sx04Kxxb9Cj1SX1dyofhuc1Paq4oCWozFoxBfZaZXW0xWyHOrUH19gHJqhy/CIBG
         Vx0lpq4RYxEWfUKGB+Nyxx1A0qRxzTrDZD4+Dqp8dIfIl4+jmFLHNFgrYbxaeYiw5z3F
         iT6h5oHHZREgCCrmFFU0wxnzFwlFLDVmjVdn88mq62WPhxhNoi1+kFjraUHbChUvrNeZ
         bsIHXZoOPez6Kgm3otgK+dZpmfuybSu1fslxVh5LcWJU8jnpXZftEMI74Vf3oVHvIuFj
         GMAA==
X-Gm-Message-State: APjAAAWyhlrCPKNv/V3HWeuIzmOBhBx6I08cx/mMYJ4oH0HG2BM27/Ta
        HqGbJ9JnPSSZAcWgX6tg2julP5LKX5LtkVbJGVjw5Ie/ASEyTb9FsMrt8TO5Ut9O8+kUHSXnoAp
        vvJlDICuDm5YyPQl83cK1cbUmjmR0oLzI8FprIB5/VEN3jDwh2yJBwq7bHJmnQ70catXfzMeD
X-Google-Smtp-Source: APXvYqzTKBHDHJickLCvhCjyQyjGLCWPU0Weip/aL5lpslEXqXtUcR2uHGltd4kZIikR5TSGAmtYFdG1xT5IYP/E
X-Received: by 2002:a65:44c8:: with SMTP id g8mr31761212pgs.443.1562695214069;
 Tue, 09 Jul 2019 11:00:14 -0700 (PDT)
Date:   Tue,  9 Jul 2019 11:00:05 -0700
In-Reply-To: <20190709180005.33406-1-allanzhang@google.com>
Message-Id: <20190709180005.33406-3-allanzhang@google.com>
Mime-Version: 1.0
References: <20190709180005.33406-1-allanzhang@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 2/2] selftests/bpf: Add selftests for bpf_perf_event_output
From:   Allan Zhang <allanzhang@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net
Cc:     ast@kernel.org, allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: allanzhang <allanzhang@google.com>

Software event output is only enabled by a few prog types.
This test is to ensure that all supported types are enabled for
bpf_perf_event_output successfully.

Signed-off-by: Allan Zhang <allanzhang@google.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 12 ++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index c5514daf8865..5e98d7c37eb7 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	18
+#define MAX_NR_MAPS	19
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -84,6 +84,7 @@ struct bpf_test {
 	int fixup_map_array_wo[MAX_FIXUPS];
 	int fixup_map_array_small[MAX_FIXUPS];
 	int fixup_sk_storage_map[MAX_FIXUPS];
+	int fixup_map_event_output[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t retval, retval_unpriv, insn_processed;
@@ -627,6 +628,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_array_wo = test->fixup_map_array_wo;
 	int *fixup_map_array_small = test->fixup_map_array_small;
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
+	int *fixup_map_event_output = test->fixup_map_event_output;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -788,6 +790,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_sk_storage_map++;
 		} while (*fixup_sk_storage_map);
 	}
+	if (*fixup_map_event_output) {
+		map_fds[18] = __create_map(BPF_MAP_TYPE_PERF_EVENT_ARRAY,
+					   sizeof(int), sizeof(int), 1, 0);
+		do {
+			prog[*fixup_map_event_output].imm = map_fds[18];
+			fixup_map_event_output++;
+		} while (*fixup_map_event_output);
+	}
 }
 
 static int set_admin(bool admin)
diff --git a/tools/testing/selftests/bpf/verifier/event_output.c b/tools/testing/selftests/bpf/verifier/event_output.c
new file mode 100644
index 000000000000..130553e19eca
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/event_output.c
@@ -0,0 +1,94 @@
+/* instructions used to output a skb based software event, produced
+ * from code snippet:
+ * struct TMP {
+ *  uint64_t tmp;
+ * } tt;
+ * tt.tmp = 5;
+ * bpf_perf_event_output(skb, &connection_tracking_event_map, 0,
+ *			 &tt, sizeof(tt));
+ * return 1;
+ *
+ * the bpf assembly from llvm is:
+ *        0:       b7 02 00 00 05 00 00 00         r2 = 5
+ *        1:       7b 2a f8 ff 00 00 00 00         *(u64 *)(r10 - 8) = r2
+ *        2:       bf a4 00 00 00 00 00 00         r4 = r10
+ *        3:       07 04 00 00 f8 ff ff ff         r4 += -8
+ *        4:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00    r2 = 0ll
+ *        6:       b7 03 00 00 00 00 00 00         r3 = 0
+ *        7:       b7 05 00 00 08 00 00 00         r5 = 8
+ *        8:       85 00 00 00 19 00 00 00         call 25
+ *        9:       b7 00 00 00 01 00 00 00         r0 = 1
+ *       10:       95 00 00 00 00 00 00 00         exit
+ *
+ *     The reason I put the code here instead of fill_helpers is that map fixup
+ *     is against the insns, instead of filled prog.
+ */
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

