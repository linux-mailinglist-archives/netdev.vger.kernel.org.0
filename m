Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D11D1B340B
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 02:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgDVAh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 20:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgDVAh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 20:37:58 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC74C0610D6
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 17:37:57 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id r129so858039qkd.19
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 17:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1BrRYo+96Cv/JrFZbPvJV2ENqhE9dtp0nSEuMgbSQkQ=;
        b=dfTf8cY1rflgEMK+6VegOrQLECkYzWyPJgQo8Cr/jLkKJ7Edly28gwqUP4WPaIOKH6
         HgURW/boPMJzzBZDoA9ZYKilb17dcMLSdv/OowopVy1WS97hTDqLaEn09GOOvSrr97iV
         b0r/E+uJovR8ZNrC+GZeotliH7c/dvwHD5ONa+NwYbqsbvpR+PKdnMpm/rJrbzWpt0Ut
         BO0Hnc6/Xs67TKQBiXA8Bk3c/nLZsx0jcoXTUyBFOIZKek/6Q2VRF0A3P3TxWlXStxUd
         +c7wBfEQbHVcm4tUuLnpIV7qTHdR6/lpKyNTpn3N6OSYu7AWgjzoDepWr3rlnoR2lDSt
         3kIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1BrRYo+96Cv/JrFZbPvJV2ENqhE9dtp0nSEuMgbSQkQ=;
        b=mz6BZOYH/AQaT7dwmWaLUnr5CrqXOv80UHXdZIP0x54697uesEGSgzx0vplWf2z1j9
         73wPzeRvGDgWeULlDShiju/3kfjIJLlGLsLGYOCrLlVQ2ZJXGeGVP7PGPLYZ+t6rtYgX
         MkfwiU9kCsJd9Wlz9OCEubXZah1WgTegNQQ8+b9De+vB7jAWnK3r5uud+u9HNQCifLI2
         SrvmqwI9I8mOqidOeL+R21NpMNVQsjg1Bxl0aC0EntPr7soz/n8jgtP/9kv3XXBVotzq
         VbwD8k/L3yEf3r7rBGrkcuYLzYNIBbgsRCelIi9mS4dQ/8zucQcz0tOPtZaI70AsIY8G
         BjHA==
X-Gm-Message-State: AGi0PuboSPZwualtScgHMk/lb/+vnQpJXFRBB0Vp/d469hFyUHLv26AN
        x8pIGaPVG5Nc8kpCeBa8lde47dUbM3DDEHG64kH++Zqp6ywDYtTvH8TLU/GaHGIZonangtNvluB
        jO5xxMQgMCc3WscuED99XrEBAsILSrL2boUXcq3x9QK/zDBlErMqnMQ==
X-Google-Smtp-Source: APiQypJcpVWz/74werdqSCEawvRSVe7Vio1SPu9EF2xlsLpHHbZ7b1/Vlmn9uTRrsVNuc9b/19qfyGI=
X-Received: by 2002:ac8:6f6c:: with SMTP id u12mr23727526qtv.103.1587515875944;
 Tue, 21 Apr 2020 17:37:55 -0700 (PDT)
Date:   Tue, 21 Apr 2020 17:37:53 -0700
Message-Id: <20200422003753.124921-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH bpf-next] selftests/bpf: fix a couple of broken test_btf cases
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
introduced function linkage flag and changed the error message from
"vlen != 0" to "Invalid func linkage" and broke some fake BPF programs.

Adjust the test accordingly.

AFACT, the programs don't really need any arguments and only look
at BTF for maps, so let's drop the args altogether.

Before:
BTF raw test[103] (func (Non zero vlen)): do_test_raw:3703:FAIL expected
err_str:vlen != 0
magic: 0xeb9f
version: 1
flags: 0x0
hdr_len: 24
type_off: 0
type_len: 72
str_off: 72
str_len: 10
btf_total_size: 106
[1] INT (anon) size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
[2] INT (anon) size=4 bits_offset=0 nr_bits=32 encoding=(none)
[3] FUNC_PROTO (anon) return=0 args=(1 a, 2 b)
[4] FUNC func type_id=3 Invalid func linkage

BTF libbpf test[1] (test_btf_haskv.o): libbpf: load bpf program failed:
Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
Validating test_long_fname_2() func#1...
Arg#0 type PTR in test_long_fname_2() is not supported yet.
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'dummy_tracepoint'
libbpf: failed to load object 'test_btf_haskv.o'
do_test_file:4201:FAIL bpf_object__load: -4007
BTF libbpf test[2] (test_btf_newkv.o): libbpf: load bpf program failed:
Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
Validating test_long_fname_2() func#1...
Arg#0 type PTR in test_long_fname_2() is not supported yet.
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'dummy_tracepoint'
libbpf: failed to load object 'test_btf_newkv.o'
do_test_file:4201:FAIL bpf_object__load: -4007
BTF libbpf test[3] (test_btf_nokv.o): libbpf: load bpf program failed:
Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
Validating test_long_fname_2() func#1...
Arg#0 type PTR in test_long_fname_2() is not supported yet.
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'dummy_tracepoint'
libbpf: failed to load object 'test_btf_nokv.o'
do_test_file:4201:FAIL bpf_object__load: -4007

Fixes: 51c39bb1d5d1 ("bpf: Introduce function-by-function verification")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/progs/test_btf_haskv.c       | 18 +++++-------------
 .../selftests/bpf/progs/test_btf_newkv.c       | 18 +++++-------------
 .../selftests/bpf/progs/test_btf_nokv.c        | 18 +++++-------------
 tools/testing/selftests/bpf/test_btf.c         |  2 +-
 4 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_btf_haskv.c b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
index 88b0566da13d..31538c9ed193 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_haskv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_haskv.c
@@ -20,20 +20,12 @@ struct bpf_map_def SEC("maps") btf_map = {
 
 BPF_ANNOTATE_KV_PAIR(btf_map, int, struct ipv_counts);
 
-struct dummy_tracepoint_args {
-	unsigned long long pad;
-	struct sock *sock;
-};
-
 __attribute__((noinline))
-int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(void)
 {
 	struct ipv_counts *counts;
 	int key = 0;
 
-	if (!arg->sock)
-		return 0;
-
 	counts = bpf_map_lookup_elem(&btf_map, &key);
 	if (!counts)
 		return 0;
@@ -44,15 +36,15 @@ int test_long_fname_2(struct dummy_tracepoint_args *arg)
 }
 
 __attribute__((noinline))
-int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(void)
 {
-	return test_long_fname_2(arg);
+	return test_long_fname_2();
 }
 
 SEC("dummy_tracepoint")
-int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+int _dummy_tracepoint(void *arg)
 {
-	return test_long_fname_1(arg);
+	return test_long_fname_1();
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_btf_newkv.c b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
index a924e53c8e9d..6c5560162746 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_newkv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
@@ -28,20 +28,12 @@ struct {
 	__type(value, struct ipv_counts);
 } btf_map SEC(".maps");
 
-struct dummy_tracepoint_args {
-	unsigned long long pad;
-	struct sock *sock;
-};
-
 __attribute__((noinline))
-int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(void)
 {
 	struct ipv_counts *counts;
 	int key = 0;
 
-	if (!arg->sock)
-		return 0;
-
 	counts = bpf_map_lookup_elem(&btf_map, &key);
 	if (!counts)
 		return 0;
@@ -57,15 +49,15 @@ int test_long_fname_2(struct dummy_tracepoint_args *arg)
 }
 
 __attribute__((noinline))
-int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(void)
 {
-	return test_long_fname_2(arg);
+	return test_long_fname_2();
 }
 
 SEC("dummy_tracepoint")
-int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+int _dummy_tracepoint(void *arg)
 {
-	return test_long_fname_1(arg);
+	return test_long_fname_1();
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_btf_nokv.c b/tools/testing/selftests/bpf/progs/test_btf_nokv.c
index 983aedd1c072..506da7fd2da2 100644
--- a/tools/testing/selftests/bpf/progs/test_btf_nokv.c
+++ b/tools/testing/selftests/bpf/progs/test_btf_nokv.c
@@ -17,20 +17,12 @@ struct bpf_map_def SEC("maps") btf_map = {
 	.max_entries = 4,
 };
 
-struct dummy_tracepoint_args {
-	unsigned long long pad;
-	struct sock *sock;
-};
-
 __attribute__((noinline))
-int test_long_fname_2(struct dummy_tracepoint_args *arg)
+int test_long_fname_2(void)
 {
 	struct ipv_counts *counts;
 	int key = 0;
 
-	if (!arg->sock)
-		return 0;
-
 	counts = bpf_map_lookup_elem(&btf_map, &key);
 	if (!counts)
 		return 0;
@@ -41,15 +33,15 @@ int test_long_fname_2(struct dummy_tracepoint_args *arg)
 }
 
 __attribute__((noinline))
-int test_long_fname_1(struct dummy_tracepoint_args *arg)
+int test_long_fname_1(void)
 {
-	return test_long_fname_2(arg);
+	return test_long_fname_2();
 }
 
 SEC("dummy_tracepoint")
-int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
+int _dummy_tracepoint(void *arg)
 {
-	return test_long_fname_1(arg);
+	return test_long_fname_1();
 }
 
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 8da77cda5f4a..305fae8f80a9 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -2854,7 +2854,7 @@ static struct btf_raw_test raw_tests[] = {
 	.value_type_id = 1,
 	.max_entries = 4,
 	.btf_load_err = true,
-	.err_str = "vlen != 0",
+	.err_str = "Invalid func linkage",
 },
 
 {
-- 
2.26.2.303.gf8c07b1a785-goog

