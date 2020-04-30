Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0EB1BF5D7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgD3Krm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgD3Krl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:47:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA6DC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 03:47:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c12so1149495wrp.0
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 03:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8gtc0UpjGsrwUU6aZ0Xy17C02ixQ8/wPD+rf9cxxeEs=;
        b=tXY9es4aHvkEeleiOWOBEq5a423Dt1od4uZTrCmq8btGQD/Yn24ylbZHPWVjXQOVGn
         eTk5I/OfLWdU8OY7l29ST33l2JZxh3NkzAkwLcwVT3HGAmespkqwqL3WecyVXyv4hYq3
         vVv9sobo7ZmS9p2kQQULZE1HQvSlysLC6E7iU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8gtc0UpjGsrwUU6aZ0Xy17C02ixQ8/wPD+rf9cxxeEs=;
        b=Vu6dour/21aTEwtlBWSPdCbeRxx61qKla3iRnQx3tdubjPb2JY4GQEi4XceAG0anj/
         4s0G+uh1EQl51E0Lmf7bMlyORewaVR6+Y+DPwKOs1rdtJewkXseL+AQHvkezbtevy8qP
         vt2YX6X8nG/PL2hPIIcoIUEpOgcvXuwUzp/5XKMdCFtxuxdvLpRyaajS2P1nN1Qe6hwW
         4XNeYCFvHbFsEjxKk2jJCxvn05YSc6Ig6AQ3mPHXbi1vKNo49a4tooFaON1+VID/pAY7
         tAaD99D2KcdxhqOdD7z7ZojoHH5SJixMqJD0+QBrLomn46CgF8agLsWqhtZH5nWpuMcz
         uYaQ==
X-Gm-Message-State: AGi0PuZI0BkXa57YiAmllPWC9ZpyhiAD/uSP0QVoBVIgpBjOXZxiKSOW
        aFHiwkqyhS1ko++L3zL2vhzb/Q==
X-Google-Smtp-Source: APiQypJBB3bzmWYgM3KtupS3InePrHlailiXSrpS4Ge37n+t9sR/p2WSpFdGJi0uIzSRH70KyaaYCw==
X-Received: by 2002:adf:df01:: with SMTP id y1mr3143849wrl.401.1588243660232;
        Thu, 30 Apr 2020 03:47:40 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t16sm3449531wrb.8.2020.04.30.03.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 03:47:39 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: Test allowed maps for bpf_sk_select_reuseport
Date:   Thu, 30 Apr 2020 12:47:38 +0200
Message-Id: <20200430104738.494180-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that verifier allows passing a map of type:

 BPF_MAP_TYPE_REUSEPORT_SOCKARRARY, or
 BPF_MAP_TYPE_SOCKMAP, or
 BPF_MAP_TYPE_SOCKHASH

... to bpf_sk_select_reuseport helper.

Suggested-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 12 +++++-
 tools/testing/selftests/bpf/verifier/sock.c | 45 +++++++++++++++++++++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index ad6939c67c5e..21a1ce219c1c 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -50,7 +50,7 @@
 #define MAX_INSNS	BPF_MAXINSNS
 #define MAX_TEST_INSNS	1000000
 #define MAX_FIXUPS	8
-#define MAX_NR_MAPS	19
+#define MAX_NR_MAPS	20
 #define MAX_TEST_RUNS	8
 #define POINTER_VALUE	0xcafe4all
 #define TEST_DATA_LEN	64
@@ -86,6 +86,7 @@ struct bpf_test {
 	int fixup_map_array_small[MAX_FIXUPS];
 	int fixup_sk_storage_map[MAX_FIXUPS];
 	int fixup_map_event_output[MAX_FIXUPS];
+	int fixup_map_reuseport_array[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
 	uint32_t insn_processed;
@@ -637,6 +638,7 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 	int *fixup_map_array_small = test->fixup_map_array_small;
 	int *fixup_sk_storage_map = test->fixup_sk_storage_map;
 	int *fixup_map_event_output = test->fixup_map_event_output;
+	int *fixup_map_reuseport_array = test->fixup_map_reuseport_array;
 
 	if (test->fill_helper) {
 		test->fill_insns = calloc(MAX_TEST_INSNS, sizeof(struct bpf_insn));
@@ -806,6 +808,14 @@ static void do_test_fixup(struct bpf_test *test, enum bpf_prog_type prog_type,
 			fixup_map_event_output++;
 		} while (*fixup_map_event_output);
 	}
+	if (*fixup_map_reuseport_array) {
+		map_fds[19] = __create_map(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY,
+					   sizeof(u32), sizeof(u64), 1, 0);
+		do {
+			prog[*fixup_map_reuseport_array].imm = map_fds[19];
+			fixup_map_reuseport_array++;
+		} while (*fixup_map_reuseport_array);
+	}
 }
 
 static int set_admin(bool admin)
diff --git a/tools/testing/selftests/bpf/verifier/sock.c b/tools/testing/selftests/bpf/verifier/sock.c
index f87ad69dbc62..0bc51ad9e0fb 100644
--- a/tools/testing/selftests/bpf/verifier/sock.c
+++ b/tools/testing/selftests/bpf/verifier/sock.c
@@ -586,3 +586,48 @@
 	.prog_type = BPF_PROG_TYPE_SK_SKB,
 	.result = ACCEPT,
 },
+{
+	"bpf_sk_select_reuseport(ctx, reuseport_array, &key, flags)",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_4, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -4),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_EMIT_CALL(BPF_FUNC_sk_select_reuseport),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_reuseport_array = { 4 },
+	.prog_type = BPF_PROG_TYPE_SK_REUSEPORT,
+	.result = ACCEPT,
+},
+{
+	"bpf_sk_select_reuseport(ctx, sockmap, &key, flags)",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_4, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -4),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_EMIT_CALL(BPF_FUNC_sk_select_reuseport),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_sockmap = { 4 },
+	.prog_type = BPF_PROG_TYPE_SK_REUSEPORT,
+	.result = ACCEPT,
+},
+{
+	"bpf_sk_select_reuseport(ctx, sockhash, &key, flags)",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_4, 0),
+	BPF_ST_MEM(BPF_W, BPF_REG_10, -4, 0),
+	BPF_MOV64_REG(BPF_REG_3, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -4),
+	BPF_LD_MAP_FD(BPF_REG_2, 0),
+	BPF_EMIT_CALL(BPF_FUNC_sk_select_reuseport),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_sockmap = { 4 },
+	.prog_type = BPF_PROG_TYPE_SK_REUSEPORT,
+	.result = ACCEPT,
+},
-- 
2.25.3

