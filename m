Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918F31F7005
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgFKWXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgFKWXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:23:54 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0489C08C5C1;
        Thu, 11 Jun 2020 15:23:52 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 23so3288681pfw.10;
        Thu, 11 Jun 2020 15:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JNCxmDzmVYsk6wcDH4yZUbJ3WFoeGK9AK2MQb1oCzvg=;
        b=PgMgm2QPCniOWM6J9A0SV14HvrdTCNu129GUkJZEBBqsHqPlE9GsOIn897zCcl0wkW
         87D/S9L/hF0laj7x6qfX0qtMdmizB8bzLkHRWGJZV34LuE/UHgdlEyzQWTg/XrtQvDiC
         OVj3ChrOX4cD8X6KbvCSOttYojWtc3ZR0TNVL3PrexVKw0FbgYmLnyorV2M5OO6T3SX/
         1t2cAAFLSmRApYzF6zKUWCwL2JDSzB6Y9AeSFxXo0skqdo8f1dPvnUpG50T+jU0kro5G
         eEu2z7S7g4g5cf3tyXKZIwZ5c+OMbj1/LLkfJXR48ra7GxAGrBdAIzq5WshwlBGRZW5l
         avvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JNCxmDzmVYsk6wcDH4yZUbJ3WFoeGK9AK2MQb1oCzvg=;
        b=rIZbjeT361t1qd+XMT4htJ1ddA+qgcF5wRP8lUZhl6AtC1v0XpR5UUxL46GOarWhNI
         YQ9DyacOSlFOSv/8Mflz2+qUjW5GLURTUo62OqXW6adxLkpobPal43CaJF88jE07Ryvv
         i8ksr8+SqO2prYAWfT3kd4RIsGBufeZQWMhx1eMgBoKAlOi5FbXhLNbKMokjIOxSsuBZ
         Me8PD+S1fQhVQpF85QM2lSSaxI2HoQAQGOYUl2OfreIzgegTKHu2Y4aVQQXuiv8VVTg3
         ewDutALsOQpmLilKr6icWXzDOvcnvJh2229jzSu2njL0WGaMzwzWGV4r6hd4UFycrlo5
         OwZA==
X-Gm-Message-State: AOAM530CB/4my4rmfXOm0nnpEu+TRyHWvtGv6BJnjcCTkGZyTnB78VFU
        5ABZMzmcl5m3z2z2wppNryXeTlYG
X-Google-Smtp-Source: ABdhPJwuaV6oHPZ4INkKHIZpgdWkBCs9Twh8bU+dtHaSKCmMjpt6PMv6/VWrluPyfs0NYgBIWAOLBw==
X-Received: by 2002:a63:ea4a:: with SMTP id l10mr3015824pgk.222.1591914232436;
        Thu, 11 Jun 2020 15:23:52 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id nl11sm8660651pjb.0.2020.06.11.15.23.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 15:23:51 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH RFC v3 bpf-next 4/4] selftests/bpf: basic sleepable tests
Date:   Thu, 11 Jun 2020 15:23:40 -0700
Message-Id: <20200611222340.24081-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
References: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Modify few tests to sanity test sleepable bpf functionality.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: KP Singh <kpsingh@google.com>
---
 tools/testing/selftests/bpf/bench.c             |  2 ++
 .../selftests/bpf/benchs/bench_trigger.c        | 17 +++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c         | 14 ++++++++++++--
 .../testing/selftests/bpf/progs/trigger_bench.c |  7 +++++++
 4 files changed, 38 insertions(+), 2 deletions(-)

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
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index b4598d4bc4f7..895445aa2b77 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -15,10 +15,12 @@ int monitored_pid = 0;
 int mprotect_count = 0;
 int bprm_count = 0;
 
-SEC("lsm/file_mprotect")
+SEC("lsm.s/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
 {
+	char args[64];
+
 	if (ret != 0)
 		return ret;
 
@@ -28,6 +30,9 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
 		    vma->vm_end >= vma->vm_mm->start_stack);
 
+	bpf_copy_from_user(args, sizeof(args), (void *)vma->vm_mm->arg_start);
+	/*bpf_printk("args=%s\n", args);*/
+
 	if (is_stack && monitored_pid == pid) {
 		mprotect_count++;
 		ret = -EPERM;
@@ -36,7 +41,7 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	return ret;
 }
 
-SEC("lsm/bprm_committed_creds")
+SEC("lsm.s/bprm_committed_creds")
 int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
@@ -46,3 +51,8 @@ int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 
 	return 0;
 }
+SEC("lsm/task_free") /* lsm/ is ok, lsm.s/ fails */
+int BPF_PROG(test_task_free, struct task_struct *task)
+{
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

