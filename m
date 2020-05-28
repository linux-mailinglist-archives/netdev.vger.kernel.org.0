Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C4C1E5686
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgE1Fdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgE1Fdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:33:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DECEC05BD1E;
        Wed, 27 May 2020 22:33:43 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n15so12940679pfd.0;
        Wed, 27 May 2020 22:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7hFJuPMNtudThI0czwAIJAAON6LfgRQdn+lraE8LviE=;
        b=r17lm26ywgN+gn70OxuAXrIKWwuwYgokfcgdE4rmi1NTnXH61iHMIFsZCrNmltsI3x
         Lsk2fmn1oqws7ihby+86SS0IJva08dKvM4ZisNGTAIbkFtWn70jYJq/WqzGnlK5DAlaN
         s44RD1Prwy8KE029cPB3ZEBFvlvKps/OE+DVykTgzWLHWOq6sryF4CNVTkUrIt45ykx+
         Vx8AIg9bng0C7FAQ0yAShNctv9HZ4sZzvbrk9XHw+9QkBmVIgF5z+TKg/DLbJ2PbA5lH
         Ixr2QzMEYkRRGVjw87XulCBgdqc8A/CYaRGtYltc3lXCY0Ny3gSiyTQijpwlxNTi9x0V
         57uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7hFJuPMNtudThI0czwAIJAAON6LfgRQdn+lraE8LviE=;
        b=skA1ck5qBYBOCswHQY4u7DTjD9e3OhOeXIMzdfPHZJIpLFYgDv8cSXnDpIuCKLNTGv
         3rR66Vv9VXznBx9oQV4sdGyqvrt365SKlvu5rYuOuKdBQeuLk7LZ/FIMm90uxJ03z1zv
         TTTIs8vSz8sFi8GLv3LTYNzwizfbhkggXIyc9y8umO60pFcw4klqRlAomeabkhd64ylP
         8YnQdZpGsza0vB89kNeP1Xv6/Ul8V/Q4OU6J8Dgx+nRV5dcNev5daKSDmBUXwXMRkT97
         WwUd1KKL2dbkt8ozQJLuN/a6d2/DjQ+9zlRuV6dG2jvAbfai3gr/bXNcAKtcDm7thZhm
         pIUg==
X-Gm-Message-State: AOAM530AS+yXYTfkYIItt2ObJ35uJktr+Jtkckz5F5Ddl5AX3KerCvbx
        2OQG2gBB8JPruRaCwlZFIRc=
X-Google-Smtp-Source: ABdhPJyEeDLqQzsKrFb8TNXexsQsstNjgCeScX8/nhxUaoTnHWSKKS3RmwGOMposTRKMY0Y9dLWMng==
X-Received: by 2002:a63:1d02:: with SMTP id d2mr1320231pgd.206.1590644022853;
        Wed, 27 May 2020 22:33:42 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o27sm3502461pgd.18.2020.05.27.22.33.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2020 22:33:42 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 3/3] selftests/bpf: basic sleepable tests
Date:   Wed, 27 May 2020 22:33:34 -0700
Message-Id: <20200528053334.89293-4-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
References: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Modify few tests to sanity test sleepable bpf functionality.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/bench.c             |  2 ++
 .../selftests/bpf/benchs/bench_trigger.c        | 17 +++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c         |  4 ++--
 .../testing/selftests/bpf/progs/trigger_bench.c |  7 +++++++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftests/bpf/bench.c
index 14390689ef90..f6a75cd47f01 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -309,6 +309,7 @@ extern const struct bench bench_trig_tp;
 extern const struct bench bench_trig_rawtp;
 extern const struct bench bench_trig_kprobe;
 extern const struct bench bench_trig_fentry;
+extern const struct bench bench_trig_fentry_sleep;
 extern const struct bench bench_trig_fmodret;
 
 static const struct bench *benchs[] = {
@@ -326,6 +327,7 @@ static const struct bench *benchs[] = {
 	&bench_trig_rawtp,
 	&bench_trig_kprobe,
 	&bench_trig_fentry,
+	&bench_trig_fentry_sleep,
 	&bench_trig_fmodret,
 };
 
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
index b4598d4bc4f7..55815d0cc5fb 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -15,7 +15,7 @@ int monitored_pid = 0;
 int mprotect_count = 0;
 int bprm_count = 0;
 
-SEC("lsm/file_mprotect")
+SEC("lsm.s/file_mprotect")
 int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	     unsigned long reqprot, unsigned long prot, int ret)
 {
@@ -36,7 +36,7 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
 	return ret;
 }
 
-SEC("lsm/bprm_committed_creds")
+SEC("lsm.s/bprm_committed_creds")
 int BPF_PROG(test_void_hook, struct linux_binprm *bprm)
 {
 	__u32 pid = bpf_get_current_pid_tgid() >> 32;
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

