Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AB820ECAC
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgF3EeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbgF3Ed6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:33:58 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E202BC061755;
        Mon, 29 Jun 2020 21:33:57 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc9so2456067pjb.2;
        Mon, 29 Jun 2020 21:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QBWDCvnfCJExGmeOLlbW5Nt3Rbrxkmj53WU3WmpliwY=;
        b=J4AFeZiTus5fLrTGYzRRyOl6pOOO16Zvq4BvbHRG5ycS+P9lr6uow6JRbWsd9auqxQ
         u8bmZlsWxYXdD/BQujhnOO2jk4DtbquXsPoYM1T/A2ZTyTpvUNUIB+1DQkLJFZvgvbLc
         aYrnI/tdpElnEpvzJCvWrN6aqBqtkyG793w2Lvu2fyDAJJrLS/7XdP1O/dWvfSl9921p
         JtzOxz/Yd6xHIfmQhK/KI1/NeNxWUGXN5p/jq4nS9l73dd0u9Eyk8C5HCyoKgjIEKM6t
         vmzCXidlUpeDK/kbBdK5trnqmUVVqgbdGlC1+/BTW53NZU2X+i9aHd+4sy27QRtG3cZQ
         G1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QBWDCvnfCJExGmeOLlbW5Nt3Rbrxkmj53WU3WmpliwY=;
        b=PegJTRUmY+LfYhp8Ay4ACmTinrXI4aUczatozpYDwwoRLxv6JZaR1/9ITP+iBsMe1P
         KeyVx+IfGVUulyNuCUumszslarZzMKbXrB7NU1jyGlR2SUcEWxEa5NIESSDCBMurAOsz
         qBICaNt8FhawPK1tQHKEfI1gcgJeZ4TAzh9ZpIaPzJinIadpzDk3py3fAh4tk7oaJOLU
         Tj4vqaJtSGdqOOZeJiTPQ/r9pfIWHgryqSvHQjQlYowhvwPunfmruRVENhgJPgHWWICQ
         JbYcy8XW5ejNGHBzlBP+X2QIK9KW1wROaLqxZZjKgmHicMChx5W+Ps7fG7arKYNJQ370
         5jow==
X-Gm-Message-State: AOAM532YG43AiZV1pWzQUXxnp/E6rUhZqD8/FSaG+k31mTTlgUbeXGTp
        7XWi4+ZLwMEPp0hY80vexyU=
X-Google-Smtp-Source: ABdhPJw2p1xbahKKLkyFJhk4gXeDfk/z0AroP/xwlbxroTQtCF22SSwI0nZBQ5E+K+QUdLyi+DErYg==
X-Received: by 2002:a17:90a:cc0f:: with SMTP id b15mr16056761pju.83.1593491637401;
        Mon, 29 Jun 2020 21:33:57 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 21sm1111234pfv.43.2020.06.29.21.33.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 21:33:56 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 5/5] selftests/bpf: Add sleepable tests
Date:   Mon, 29 Jun 2020 21:33:43 -0700
Message-Id: <20200630043343.53195-6-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
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
 tools/testing/selftests/bpf/progs/lsm.c       | 66 ++++++++++++++++++-
 .../selftests/bpf/progs/trigger_bench.c       |  7 ++
 5 files changed, 99 insertions(+), 2 deletions(-)

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
index b4598d4bc4f7..49fa6ca99755 100644
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
@@ -46,3 +83,28 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 
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
+	void *ptr = (void *)PT_REGS_PARM1(regs);
+	int len = PT_REGS_PARM2(regs);
+	int buf = 0;
+	long ret;
+
+	ret = bpf_copy_from_user(&buf, sizeof(buf), ptr);
+	if (len == -2 && ret == 0 && buf == 1234)
+		copy_test++;
+	if (len == -3 && ret == -EFAULT)
+		copy_test++;
+	if (len == -4 && ret == -EFAULT)
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

