Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71483126FA9
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfLSVUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:20:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:59530 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfLSVUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:20:01 -0500
Received: from 31.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.31] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ii3DD-00058c-QQ; Thu, 19 Dec 2019 22:19:59 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 2/2] bpf: Add further test_verifier cases for record_func_key
Date:   Thu, 19 Dec 2019 22:19:51 +0100
Message-Id: <df7200b6021444fd369376d227de917357285b65.1576789878.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1576789878.git.daniel@iogearbox.net>
References: <cover.1576789878.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25668/Thu Dec 19 10:55:58 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand dummy prog generation such that we can easily check on return
codes and add few more test cases to make sure we keep on tracking
pruning behavior.

  # ./test_verifier
  [...]
  #1066/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
  #1067/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
  Summary: 1580 PASSED, 0 SKIPPED, 0 FAILED

Also verified that JIT dump of added test cases looks good.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/testing/selftests/bpf/test_verifier.c   |  43 ++---
 .../selftests/bpf/verifier/ref_tracking.c     |   6 +-
 .../selftests/bpf/verifier/runtime_jit.c      | 151 ++++++++++++++++++
 3 files changed, 176 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index d27fd929abb9..87eaa49609a0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -408,10 +408,10 @@ static void update_map(int fd, int index)
 	assert(!bpf_map_update_elem(fd, &index, &value, 0));
 }
 
-static int create_prog_dummy1(enum bpf_prog_type prog_type)
+static int create_prog_dummy_simple(enum bpf_prog_type prog_type, int ret)
 {
 	struct bpf_insn prog[] = {
-		BPF_MOV64_IMM(BPF_REG_0, 42),
+		BPF_MOV64_IMM(BPF_REG_0, ret),
 		BPF_EXIT_INSN(),
 	};
 
@@ -419,14 +419,15 @@ static int create_prog_dummy1(enum bpf_prog_type prog_type)
 				ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
 }
 
-static int create_prog_dummy2(enum bpf_prog_type prog_type, int mfd, int idx)
+static int create_prog_dummy_loop(enum bpf_prog_type prog_type, int mfd,
+				  int idx, int ret)
 {
 	struct bpf_insn prog[] = {
 		BPF_MOV64_IMM(BPF_REG_3, idx),
 		BPF_LD_MAP_FD(BPF_REG_2, mfd),
 		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0,
 			     BPF_FUNC_tail_call),
-		BPF_MOV64_IMM(BPF_REG_0, 41),
+		BPF_MOV64_IMM(BPF_REG_0, ret),
 		BPF_EXIT_INSN(),
 	};
 
@@ -435,10 +436,9 @@ static int create_prog_dummy2(enum bpf_prog_type prog_type, int mfd, int idx)
 }
 
 static int create_prog_array(enum bpf_prog_type prog_type, uint32_t max_elem,
-			     int p1key)
+			     int p1key, int p2key, int p3key)
 {
-	int p2key = 1;
-	int mfd, p1fd, p2fd;
+	int mfd, p1fd, p2fd, p3fd;
 
 	mfd = bpf_create_map(BPF_MAP_TYPE_PROG_ARRAY, sizeof(int),
 			     sizeof(int), max_elem, 0);
@@ -449,23 +449,24 @@ static int create_prog_array(enum bpf_prog_type prog_type, uint32_t max_elem,
 		return -1;
 	}
 
-	p1fd = create_prog_dummy1(prog_type);
-	p2fd = create_prog_dummy2(prog_type, mfd, p2key);
-	if (p1fd < 0 || p2fd < 0)
-		goto out;
+	p1fd = create_prog_dummy_simple(prog_type, 42);
+	p2fd = create_prog_dummy_loop(prog_type, mfd, p2key, 41);
+	p3fd = create_prog_dummy_simple(prog_type, 24);
+	if (p1fd < 0 || p2fd < 0 || p3fd < 0)
+		goto err;
 	if (bpf_map_update_elem(mfd, &p1key, &p1fd, BPF_ANY) < 0)
-		goto out;
+		goto err;
 	if (bpf_map_update_elem(mfd, &p2key, &p2fd, BPF_ANY) < 0)
-		goto out;
+		goto err;
+	if (bpf_map_update_elem(mfd, &p3key, &p3fd, BPF_ANY) < 0) {
+err:
+		close(mfd);
+		mfd = -1;
+	}
+	close(p3fd);
 	close(p2fd);
 	close(p1fd);
-
 	return mfd;
-out:
-	close(p2fd);
-	close(p1fd);
-	close(mfd);
-	return -1;
 }
 
 static int create_map_in_map(void)
@@ -684,7 +685,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 
 	if (*fixup_prog1) {
-		map_fds[4] = create_prog_array(prog_type, 4, 0);
+		map_fds[4] = create_prog_array(prog_type, 4, 0, 1, 2);
 		do {
 			prog[*fixup_prog1].imm = map_fds[4];
 			fixup_prog1++;
@@ -692,7 +693,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	}
 
 	if (*fixup_prog2) {
-		map_fds[5] = create_prog_array(prog_type, 8, 7);
+		map_fds[5] = create_prog_array(prog_type, 8, 7, 1, 2);
 		do {
 			prog[*fixup_prog2].imm = map_fds[5];
 			fixup_prog2++;
diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index ebcbf154c460..604b46151736 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -455,7 +455,7 @@
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_1, 0, 7),
 	/* bpf_tail_call() */
-	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_MOV64_IMM(BPF_REG_3, 3),
 	BPF_LD_MAP_FD(BPF_REG_2, 0),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
@@ -478,7 +478,7 @@
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 1),
 	BPF_EMIT_CALL(BPF_FUNC_sk_release),
 	/* bpf_tail_call() */
-	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_MOV64_IMM(BPF_REG_3, 3),
 	BPF_LD_MAP_FD(BPF_REG_2, 0),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
@@ -497,7 +497,7 @@
 	BPF_SK_LOOKUP(sk_lookup_tcp),
 	/* bpf_tail_call() */
 	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
-	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_MOV64_IMM(BPF_REG_3, 3),
 	BPF_LD_MAP_FD(BPF_REG_2, 0),
 	BPF_MOV64_REG(BPF_REG_1, BPF_REG_7),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
diff --git a/tools/testing/selftests/bpf/verifier/runtime_jit.c b/tools/testing/selftests/bpf/verifier/runtime_jit.c
index a9a8f620e71c..94c399d1faca 100644
--- a/tools/testing/selftests/bpf/verifier/runtime_jit.c
+++ b/tools/testing/selftests/bpf/verifier/runtime_jit.c
@@ -27,6 +27,19 @@
 {
 	"runtime/jit: tail_call within bounds, no prog",
 	.insns = {
+	BPF_MOV64_IMM(BPF_REG_3, 3),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 1 },
+	.result = ACCEPT,
+	.retval = 1,
+},
+{
+	"runtime/jit: tail_call within bounds, key 2",
+	.insns = {
 	BPF_MOV64_IMM(BPF_REG_3, 2),
 	BPF_LD_MAP_FD(BPF_REG_2, 0),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
@@ -35,8 +48,146 @@
 	},
 	.fixup_prog1 = { 1 },
 	.result = ACCEPT,
+	.retval = 24,
+},
+{
+	"runtime/jit: tail_call within bounds, key 2 / key 2, first branch",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 13),
+	BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 13, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 3),
+	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 5, 9 },
+	.result = ACCEPT,
+	.retval = 24,
+},
+{
+	"runtime/jit: tail_call within bounds, key 2 / key 2, second branch",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 14),
+	BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 13, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 3),
+	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 5, 9 },
+	.result = ACCEPT,
+	.retval = 24,
+},
+{
+	"runtime/jit: tail_call within bounds, key 0 / key 2, first branch",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 13),
+	BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 13, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 3),
+	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 5, 9 },
+	.result = ACCEPT,
+	.retval = 24,
+},
+{
+	"runtime/jit: tail_call within bounds, key 0 / key 2, second branch",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 14),
+	BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 13, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 3),
+	BPF_MOV64_IMM(BPF_REG_3, 2),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 5, 9 },
+	.result = ACCEPT,
+	.retval = 42,
+},
+{
+	"runtime/jit: tail_call within bounds, different maps, first branch",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 13),
+	BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 13, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 3),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 5 },
+	.fixup_prog2 = { 9 },
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "tail_call abusing map_ptr",
+	.result = ACCEPT,
 	.retval = 1,
 },
+{
+	"runtime/jit: tail_call within bounds, different maps, second branch",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 14),
+	BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+		    offsetof(struct __sk_buff, cb[0])),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 13, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_JMP_IMM(BPF_JA, 0, 0, 3),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_tail_call),
+	BPF_MOV64_IMM(BPF_REG_0, 1),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_prog1 = { 5 },
+	.fixup_prog2 = { 9 },
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "tail_call abusing map_ptr",
+	.result = ACCEPT,
+	.retval = 42,
+},
 {
 	"runtime/jit: tail_call out of bounds",
 	.insns = {
-- 
2.21.0

