Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680EC20EA50
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgF3Aez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgF3Aew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:34:52 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75407C03E979;
        Mon, 29 Jun 2020 17:34:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id a14so4059272pfi.2;
        Mon, 29 Jun 2020 17:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y0yfUYX1LHC1cSeSPnzA7X7oxr0zSt80Xa4AUD6Ku4U=;
        b=cBSgPGxkERdTV2e+0plkVIaoe4IveAHgXoxDM0sYLHZZgMHz17Nw68/2htuoUb9Rme
         plRll9eHKnqj6PzNCO3K5WC8bjDcDE+HuWk6z1So6MiMW1XT2F5o7LfvRKnOhxGmYJKV
         +GI8g/7FoXnhvMoPTwsExjHmXOjJ2Xg20+4sbzFe9wHqqCBFxyEyBcjqw1uPk/AvUiY9
         GqnsKbrPlE8Kk2t21NrIHDpgiN4gxK8B0jGUVHEIF6kuPpq6IBCE7psPWhakZ+VPkgYw
         GK4h9IBsQis3j+LdYLyoqwDZxsF4v+74cQsUmGYq4a8vTUDqD8v3Tp3CU/3MAkWBKm8u
         vD2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y0yfUYX1LHC1cSeSPnzA7X7oxr0zSt80Xa4AUD6Ku4U=;
        b=hEW4L6I/6MVoOBLneMUeRQCNhtxHRWrQbHnP1AAbkqwSh6+0Dg6paymkF7aANmqEPT
         1igbVgURfdKMVZLbJzyWXk/YTR/jGE2w66C/FVMGKyOnfKWKfLP/kTZv9TvTxbGJGTML
         U6p8m3MGSquEQw3RoTic6DG5s43qEgT47z8npZbvS4/0pvlwc9KdpWv9neLVNpleMtI1
         drOvmnFb4i9wozgADepadUZY+YY5gOTK8E//XMvXsPIGxwP3ZNjmc/i+l/16r0YwggKq
         6r8cUw9uV1oXLmQp8n2cDt2XnpoAp043vr/IiROn6g5MXSHBTpCZtrAjPegPEDT1YXoC
         oZ5w==
X-Gm-Message-State: AOAM530bAsSx7dQmyKIYkR81OneIE6xo0dfOA8rFC3V1dMXZXvqWr97g
        3hODG58TMDhH2mr5sBhUgB0=
X-Google-Smtp-Source: ABdhPJw+FFbne61C9GlyHI+UFTJEB2r51GuZyd5OCrt3Nu0a6KvfIaXrjsnoxWnwWGIdL756Xgco8w==
X-Received: by 2002:a63:1104:: with SMTP id g4mr12370458pgl.369.1593477291846;
        Mon, 29 Jun 2020 17:34:51 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id b4sm700658pfo.137.2020.06.29.17.34.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 17:34:51 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 5/5] selftests/bpf: Add sleepable tests
Date:   Mon, 29 Jun 2020 17:34:41 -0700
Message-Id: <20200630003441.42616-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Modify few tests to sanity test sleepable bpf functionality.

Running 'bench trig-fentry-sleep' vs 'bench trig-fentry' and 'perf report':
sleepable with SRCU:
   3.86%  bench     [k] __srcu_read_unlock
   3.22%  bench     [k] __srcu_read_lock
   0.92%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
   0.50%  bench     [k] bpf_trampoline_10297
   0.26%  bench     [k] __bpf_prog_exit_sleepable
   0.21%  bench     [k] __bpf_prog_enter_sleepable

sleepable with RCU_TRACE:
   0.79%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
   0.72%  bench     [k] bpf_trampoline_10381
   0.31%  bench     [k] __bpf_prog_exit_sleepable
   0.29%  bench     [k] __bpf_prog_enter_sleepable

non-sleepable with RCU:
   0.88%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry
   0.84%  bench     [k] bpf_trampoline_10297
   0.13%  bench     [k] __bpf_prog_enter
   0.12%  bench     [k] __bpf_prog_exit

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: KP Singh <kpsingh@google.com>
---
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 +++++
 .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
 tools/testing/selftests/bpf/progs/lsm.c       | 64 ++++++++++++++++++-
 .../selftests/bpf/progs/trigger_bench.c       |  7 ++
 5 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 944ad4721c83..1a427685a8a8 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -317,6 +317,7 @@ extern const struct bench bench_trig_tp;
 extern const struct bench bench_trig_rawtp;
 extern const struct bench bench_trig_kprobe;
 extern const struct bench bench_trig_fentry;
+extern const struct bench bench_trig_fentry_sleep;
 extern const struct bench bench_trig_fmodret;
 extern const struct bench bench_rb_libbpf;
 extern const struct bench bench_rb_custom;
@@ -338,6 +339,7 @@ static const struct bench *benchs[] = {
 	&bench_trig_rawtp,
 	&bench_trig_kprobe,
 	&bench_trig_fentry,
+	&bench_trig_fentry_sleep,
 	&bench_trig_fmodret,
 	&bench_rb_libbpf,
 	&bench_rb_custom,
diff --git a/tools/testing/selftests/bpf/benchs/bench_trigger.c b/tools/testing/selftests/bpf/benchs/bench_trigger.c
index 49c22832f216..2a0b6c9885a4 100644
--- a/tools/testing/selftests/bpf/benchs/bench_trigger.c
+++ b/tools/testing/selftests/bpf/benchs/bench_trigger.c
@@ -90,6 +90,12 @@ static void trigger_fentry_setup()
 	attach_bpf(ctx.skel->progs.bench_trigger_fentry);
 }
 
+static void trigger_fentry_sleep_setup()
+{
+	setup_ctx();
+	attach_bpf(ctx.skel->progs.bench_trigger_fentry_sleep);
+}
+
 static void trigger_fmodret_setup()
 {
 	setup_ctx();
@@ -155,6 +161,17 @@ const struct bench bench_trig_fentry = {
 	.report_final = hits_drops_report_final,
 };
 
+const struct bench bench_trig_fentry_sleep = {
+	.name = "trig-fentry-sleep",
+	.validate = trigger_validate,
+	.setup = trigger_fentry_sleep_setup,
+	.producer_thread = trigger_producer,
+	.consumer_thread = trigger_consumer,
+	.measure = trigger_measure,
+	.report_progress = hits_drops_report_progress,
+	.report_final = hits_drops_report_final,
+};
+
 const struct bench bench_trig_fmodret = {
 	.name = "trig-fmodret",
 	.validate = trigger_validate,
diff --git a/tools/testing/selftests/bpf/prog_tests/test_lsm.c b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
index b17eb2045c1d..6ab29226c99b 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_lsm.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_lsm.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <malloc.h>
 #include <stdlib.h>
+#include <unistd.h>
 
 #include "lsm.skel.h"
 
@@ -55,6 +56,7 @@ void test_test_lsm(void)
 {
 	struct lsm *skel = NULL;
 	int err, duration = 0;
+	int buf = 1234;
 
 	skel = lsm__open_and_load();
 	if (CHECK(!skel, "skel_load", "lsm skeleton failed\n"))
@@ -81,6 +83,13 @@ void test_test_lsm(void)
 	CHECK(skel->bss->mprotect_count != 1, "mprotect_count",
 	      "mprotect_count = %d\n", skel->bss->mprotect_count);
 
+	syscall(__NR_setdomainname, &buf, -2L);
+	syscall(__NR_setdomainname, 0, -3L);
+	syscall(__NR_setdomainname, ~0L, -4L);
+
+	CHECK(skel->bss->copy_test != 3, "copy_test",
+	      "copy_test = %d\n", skel->bss->copy_test);
+
 close_prog:
 	lsm__destroy(skel);
 }
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index b4598d4bc4f7..efa586018f03 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -9,16 +9,41 @@
 #include <bpf/bpf_tracing.h>
 #include  <errno.h>
 
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} array SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} hash SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_LRU_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} lru_hash SEC(".maps");
+
 char _license[] SEC("license") = "GPL";
 
 int monitored_pid = 0;
 int mprotect_count = 0;
 int bprm_count = 0;
 
-SEC("lsm/file_mprotect")
+SEC("lsm.s/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
 {
+	char args[64];
+	__u32 key = 0;
+	__u64 *value;
+
 	if (ret != 0)
 		return ret;
 
@@ -28,6 +53,18 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
 		    vma->vm_end >= vma->vm_mm->start_stack);
 
+	bpf_copy_from_user(args, sizeof(args), (void *)vma->vm_mm->arg_start);
+
+	value = bpf_map_lookup_elem(&array, &key);
+	if (value)
+		*value = 0;
+	value = bpf_map_lookup_elem(&hash, &key);
+	if (value)
+		*value = 0;
+	value = bpf_map_lookup_elem(&lru_hash, &key);
+	if (value)
+		*value = 0;
+
 	if (is_stack && monitored_pid == pid) {
 		mprotect_count++;
 		ret = -EPERM;
@@ -36,7 +73,7 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	return ret;
 }
 
-SEC("lsm/bprm_committed_creds")
+SEC("lsm.s/bprm_committed_creds")
 int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
@@ -46,3 +83,26 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 
 	return 0;
 }
+SEC("lsm/task_free") /* lsm/ is ok, lsm.s/ fails */
+int BPF_PROG(test_task_free, struct task_struct *task)
+{
+	return 0;
+}
+
+int copy_test = 0;
+
+SEC("fentry.s/__x64_sys_setdomainname")
+int BPF_PROG(test_sys_setdomainname, struct pt_regs *regs)
+{
+	int buf = 0;
+	long ret;
+
+	ret = bpf_copy_from_user(&buf, sizeof(buf), (void *)regs->di);
+	if (regs->si == -2 && ret == 0 && buf == 1234)
+		copy_test++;
+	if (regs->si == -3 && ret == -EFAULT)
+		copy_test++;
+	if (regs->si == -4 && ret == -EFAULT)
+		copy_test++;
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/trigger_bench.c b/tools/testing/selftests/bpf/progs/trigger_bench.c
index 8b36b6640e7e..9a4d09590b3d 100644
--- a/tools/testing/selftests/bpf/progs/trigger_bench.c
+++ b/tools/testing/selftests/bpf/progs/trigger_bench.c
@@ -39,6 +39,13 @@ int bench_trigger_fentry(void *ctx)
 	return 0;
 }
 
+SEC("fentry.s/__x64_sys_getpgid")
+int bench_trigger_fentry_sleep(void *ctx)
+{
+	__sync_add_and_fetch(&hits, 1);
+	return 0;
+}
+
 SEC("fmod_ret/__x64_sys_getpgid")
 int bench_trigger_fmodret(void *ctx)
 {
-- 
2.23.0

