Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5807727DD10
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbgI2Xvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729575AbgI2XvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:51:18 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550F5C0613DE
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:51:07 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b39so66768qta.0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zvnzQvx2tXXZBdgueyGsTaQNAxkavRjTVWo13oIK/7o=;
        b=ANsWXjuanw+7RycQMHcAX1SSg3Jav2ihSbpLFER+8zbhxRvHypZTVJrAgi6ozEURSy
         4PRZYdbGtG+3YUdYavIinmUZ1+q9ZErONhPrvdGQldsl5ETGdViBwzYvVLvl7+knidph
         1xj7hFNDMJn0cIm/LnU+breY//GrScXFpdDxQJ9AP694TpgKHoSFRmBoJ8by7PTQaonJ
         Ypzi71G40FBSMnHxgZx8846VY4Qgfyw1LVHaRtPq4+D6vBmlbC6OYF+a1ViM8JhqsTJc
         bzVm3H8Bd9/0XzhEic27jzzBv4luK3R4E0PasKkEaStn2nJn5KGupERM4WtW3jikQLjS
         VIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zvnzQvx2tXXZBdgueyGsTaQNAxkavRjTVWo13oIK/7o=;
        b=ilDhamF5L2tW7L+YV9uUaoer8u/o1GIYFqNPBADe2sPJmsKW7pjas7FmRSnS0J8wOG
         GY1zphCIgT4yMg1vkrrjOr5j6B5RvvUd9jxck4K6l8n2cf+UGAaLnIBr9E5K5ZLfiTsX
         X9ZrFUOdfmWI8UeQbgflKsXnbAdZwrxEpdaq+KAAHlRKfK48sBcvkZZW4LG4za23+zyX
         1uIe7Xl8LVSqc4CoRGdqOiUpshocsCj4Q2b+7nkPJIwbbB9yc2d1aKdp2jeuFcvc2xXa
         HGWKgyDLA33CT3++BLPr4t+R+JelLT4xdhliOJqAj6ozCjhopRI1BhQJ0pQAVyiGqfU0
         X+Nw==
X-Gm-Message-State: AOAM533LmnQEEkhWGGV0xuuPUue7o/N8MtlWLQbcFZn9s9W0cCNAk79L
        So1QW9E2Sr60e52BHknXHsLOIPubf3DxBLe9B/I6KvDScL1M7hHTsV2tSR47dJzj5DunchkmPFN
        sYBLVwEr6gT29q6tr0j0hes/pQ8304I2hrlT6G6mNTRYx6kkdorjuC4LKHm2bcA==
X-Google-Smtp-Source: ABdhPJxy546sezhTIdh2Ag7n927FuIIuxumQ0DfvnkLfjsCgWSesghJOf39wgejiueVKONJWtkc7F7GyKzc=
Sender: "haoluo via sendgmr" <haoluo@haoluo.svl.corp.google.com>
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a05:6214:601:: with SMTP id
 z1mr7093292qvw.0.1601423466359; Tue, 29 Sep 2020 16:51:06 -0700 (PDT)
Date:   Tue, 29 Sep 2020 16:50:49 -0700
In-Reply-To: <20200929235049.2533242-1-haoluo@google.com>
Message-Id: <20200929235049.2533242-7-haoluo@google.com>
Mime-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH bpf-next v4 6/6] bpf/selftests: Test for bpf_per_cpu_ptr() and bpf_this_cpu_ptr()
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test bpf_per_cpu_ptr() and bpf_this_cpu_ptr(). Test two paths in the
kernel. If the base pointer points to a struct, the returned reg is
of type PTR_TO_BTF_ID. Direct pointer dereference can be applied on
the returned variable. If the base pointer isn't a struct, the
returned reg is of type PTR_TO_MEM, which also supports direct pointer
dereference.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 18 +++++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      | 32 +++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
index c6ef06c0629a..28e26bd3e0ca 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -11,6 +11,8 @@ static int duration;
 void test_ksyms_btf(void)
 {
 	__u64 runqueues_addr, bpf_prog_active_addr;
+	__u32 this_rq_cpu;
+	int this_bpf_prog_active;
 	struct test_ksyms_btf *skel = NULL;
 	struct test_ksyms_btf__data *data;
 	struct btf *btf;
@@ -64,6 +66,22 @@ void test_ksyms_btf(void)
 	      (unsigned long long)data->out__bpf_prog_active_addr,
 	      (unsigned long long)bpf_prog_active_addr);
 
+	CHECK(data->out__rq_cpu == -1, "rq_cpu",
+	      "got %u, exp != -1\n", data->out__rq_cpu);
+	CHECK(data->out__bpf_prog_active < 0, "bpf_prog_active",
+	      "got %d, exp >= 0\n", data->out__bpf_prog_active);
+	CHECK(data->out__cpu_0_rq_cpu != 0, "cpu_rq(0)->cpu",
+	      "got %u, exp 0\n", data->out__cpu_0_rq_cpu);
+
+	this_rq_cpu = data->out__this_rq_cpu;
+	CHECK(this_rq_cpu != data->out__rq_cpu, "this_rq_cpu",
+	      "got %u, exp %u\n", this_rq_cpu, data->out__rq_cpu);
+
+	this_bpf_prog_active = data->out__this_bpf_prog_active;
+	CHECK(this_bpf_prog_active != data->out__bpf_prog_active, "this_bpf_prog_active",
+	      "got %d, exp %d\n", this_bpf_prog_active,
+	      data->out__bpf_prog_active);
+
 cleanup:
 	btf__free(btf);
 	test_ksyms_btf__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
index 7dde2082131d..bb8ea9270f29 100644
--- a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
@@ -8,15 +8,47 @@
 __u64 out__runqueues_addr = -1;
 __u64 out__bpf_prog_active_addr = -1;
 
+__u32 out__rq_cpu = -1; /* percpu struct fields */
+int out__bpf_prog_active = -1; /* percpu int */
+
+__u32 out__this_rq_cpu = -1;
+int out__this_bpf_prog_active = -1;
+
+__u32 out__cpu_0_rq_cpu = -1; /* cpu_rq(0)->cpu */
+
 extern const struct rq runqueues __ksym; /* struct type global var. */
 extern const int bpf_prog_active __ksym; /* int type global var. */
 
 SEC("raw_tp/sys_enter")
 int handler(const void *ctx)
 {
+	struct rq *rq;
+	int *active;
+	__u32 cpu;
+
 	out__runqueues_addr = (__u64)&runqueues;
 	out__bpf_prog_active_addr = (__u64)&bpf_prog_active;
 
+	cpu = bpf_get_smp_processor_id();
+
+	/* test bpf_per_cpu_ptr() */
+	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, cpu);
+	if (rq)
+		out__rq_cpu = rq->cpu;
+	active = (int *)bpf_per_cpu_ptr(&bpf_prog_active, cpu);
+	if (active)
+		out__bpf_prog_active = *active;
+
+	rq = (struct rq *)bpf_per_cpu_ptr(&runqueues, 0);
+	if (rq) /* should always be valid, but we can't spare the check. */
+		out__cpu_0_rq_cpu = rq->cpu;
+
+	/* test bpf_this_cpu_ptr */
+	rq = (struct rq *)bpf_this_cpu_ptr(&runqueues);
+	out__this_rq_cpu = rq->cpu;
+	active = (int *)bpf_this_cpu_ptr(&bpf_prog_active);
+	out__this_bpf_prog_active = *active;
+
 	return 0;
 }
 
-- 
2.28.0.709.gb0816b6eb0-goog

