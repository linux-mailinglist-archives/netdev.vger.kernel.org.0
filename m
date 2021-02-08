Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F47312FB6
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 11:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhBHKyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 05:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhBHKuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 05:50:04 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B242C061797;
        Mon,  8 Feb 2021 02:48:34 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id g15so9941753pgu.9;
        Mon, 08 Feb 2021 02:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r3brtnq+PNKE/grJyOzhs6QEmBg42KjXW9y/gHQmtYg=;
        b=fVY5vGcbhFaptVEatDtLWYmWsV8KQwSMjNTuX6fjV8g59ItHE0lMrKxDCz6zicjNC2
         wPwg++7NqcMe24rGGNGqrm5xYyNPoeDx4aRINxUgGcxmAc9nqg/XcCMsa8uah7e/r/ce
         UlYWj37FPatR7MYeh/4tqmjLsXiOJ/ST4S0th291A0Py7mMAbUPH0vBGYzhc0sd4zeC7
         dQz/GBymJz3HOSznf8sceECyIGmOY8IVdfjw2LVylg8IvL35lGth8d22Y4Yx2BNsvleO
         HyMkvEh+JWT8YuUCzKZsLegM5rUGbQyHyf9D1KEHxT7IRyXV0TENeIxlqSsuopwL2WlM
         mGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r3brtnq+PNKE/grJyOzhs6QEmBg42KjXW9y/gHQmtYg=;
        b=FbxppABKqpyW3vkSh5PFGYM0vQboeZsmdvV8zs7aPwa4sWsBE8Re7Gns6Re2vJF+XJ
         buwrG3WtjRdAVWYSxlbFdqpJ/x1pYGJ2OMVNByvl8Vm+qX9/q2+JGwgK4LpX29B/R13P
         jLda5fwnPeRuHC2f+pTp+Lvd1elcUek89Vt7p8aCCUl8k18O+9eo+vKCf6NKqwkJkbFW
         Jtt8OUD3koRxPIIlTh29Kp9E7pKZs294Jb5JsG70d5q8cskqxwKwjpgGDmkI2Qv6fpbR
         bxpQGi0VKk4pPNjgk2wt0IzoXkIs2BcINcAu9gG+4ibFCaekuTZbs16S33zEfx+AwBbz
         OIuQ==
X-Gm-Message-State: AOAM532q/pU0a2NamrflRGvoeuHIrWqY91mdOk+/Be2NuZOoBTP8Oo97
        pgMNNlxXn/hD10mz39ReKZCNittgjXBkhoJw
X-Google-Smtp-Source: ABdhPJyDB4GhFgBck0u7rAtEvbhTYkjbvFfO9DK63dRzzTWJTWB8AVIy4A/ZgKkvK1Hatax4+lg/8g==
X-Received: by 2002:a63:e511:: with SMTP id r17mr8345925pgh.163.1612781313611;
        Mon, 08 Feb 2021 02:48:33 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v19sm15371024pjh.37.2021.02.08.02.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 02:48:33 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv19 bpf-next 5/6] selftests/bpf: Add verifier tests for bpf arg ARG_CONST_MAP_PTR_OR_NULL
Date:   Mon,  8 Feb 2021 18:47:46 +0800
Message-Id: <20210208104747.573461-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210208104747.573461-1-liuhangbin@gmail.com>
References: <20210208104747.573461-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use helper bpf_redirect_map() and bpf_redirect_map_multi() to test bpf
arg ARG_CONST_MAP_PTR and ARG_CONST_MAP_PTR_OR_NULL. Make sure the
map arg could be verified correctly when it is NULL or valid map
pointer.

Add devmap and devmap_hash in struct bpf_test due to bpf_redirect_{map,
map_multi} limit.

Test result:
 ]# ./test_verifier 713 716
 #713/p ARG_CONST_MAP_PTR: null pointer OK
 #714/p ARG_CONST_MAP_PTR: valid map pointer OK
 #715/p ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map OK
 #716/p ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map OK
 Summary: 4 PASSED, 0 SKIPPED, 0 FAILED

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/test_verifier.c   | 22 +++++-
 .../testing/selftests/bpf/verifier/map_ptr.c  | 70 +++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index 58b5a349d3ba..8b474177dab0 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	21
+#define MAX_NR_MAPS	23
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -88,6 +88,8 @@ struct bpf_test {
 	int fixup_map_event_output[MAX_FIXUPS];
 	int fixup_map_reuseport_array[MAX_FIXUPS];
 	int fixup_map_ringbuf[MAX_FIXUPS];
+	int fixup_map_devmap[MAX_FIXUPS];
+	int fixup_map_devmap_hash[MAX_FIXUPS];
 	/* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
 	 * Can be a tab-separated sequence of expected strings. An empty string
 	 * means no log verification.
@@ -718,6 +720,8 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_event_output = test->fixup_map_event_output;
 	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 	int *fixup_map_ringbuf = test->fixup_map_ringbuf;
+	int *fixup_map_devmap = test->fixup_map_devmap;
+	int *fixup_map_devmap_hash = test->fixup_map_devmap_hash;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -903,6 +907,22 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_ringbuf++;
 		} while (*fixup_map_ringbuf);
 	}
+	if (*fixup_map_devmap) {
+		map_fds[20] = __create_map(BPF_MAP_TYPE_DEVMAP,
+					   sizeof(u32), sizeof(u32), 1, 0);
+		do {
+			prog[*fixup_map_devmap].imm = map_fds[20];
+			fixup_map_devmap++;
+		} while (*fixup_map_devmap);
+	}
+	if (*fixup_map_devmap_hash) {
+		map_fds[21] = __create_map(BPF_MAP_TYPE_DEVMAP_HASH,
+					   sizeof(u32), sizeof(u32), 1, 0);
+		do {
+			prog[*fixup_map_devmap_hash].imm = map_fds[21];
+			fixup_map_devmap_hash++;
+		} while (*fixup_map_devmap_hash);
+	}
 }
 
 struct libcap {
diff --git a/tools/testing/selftests/bpf/verifier/map_ptr.c b/tools/testing/selftests/bpf/verifier/map_ptr.c
index b117bdd3806d..1a532198c9c1 100644
--- a/tools/testing/selftests/bpf/verifier/map_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/map_ptr.c
@@ -93,3 +93,73 @@
 	.fixup_map_hash_16b = { 4 },
 	.result = ACCEPT,
 },
+{
+	"ARG_CONST_MAP_PTR: null pointer",
+	.insns = {
+		/* bpf_redirect_map arg1 (map) */
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map arg2 (ifindex) */
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		/* bpf_redirect_map arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		BPF_EXIT_INSN(),
+	},
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.errstr = "R1 type=inv expected=map_ptr",
+},
+{
+	"ARG_CONST_MAP_PTR: valid map pointer",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map arg1 (map) */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		/* bpf_redirect_map arg2 (ifindex) */
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		/* bpf_redirect_map arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_devmap = { 1 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+},
+{
+	"ARG_CONST_MAP_PTR_OR_NULL: null pointer for ex_map",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg1 (in_map) */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg2 (ex_map) */
+		BPF_MOV64_IMM(BPF_REG_2, 0),
+		/* bpf_redirect_map_multi arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_devmap = { 1 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.retval = 4,
+},
+{
+	"ARG_CONST_MAP_PTR_OR_NULL: valid map pointer for ex_map",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg1 (in_map) */
+		BPF_LD_MAP_FD(BPF_REG_1, 0),
+		/* bpf_redirect_map_multi arg2 (ex_map) */
+		BPF_LD_MAP_FD(BPF_REG_2, 1),
+		/* bpf_redirect_map_multi arg3 (flags) */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map_multi),
+		BPF_EXIT_INSN(),
+	},
+	.fixup_map_devmap = { 1 },
+	.fixup_map_devmap_hash = { 3 },
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_XDP,
+	.retval = 4,
+},
-- 
2.26.2

