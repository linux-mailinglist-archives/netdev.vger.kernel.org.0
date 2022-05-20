Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE3852E1DA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344464AbiETBV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344395AbiETBVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:21:43 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C4227CC7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:41 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e18-20020a170902ef5200b0016153d857a6so3352423plx.5
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=18Er9O41CS051aXSe9usnmRbqjT27fNlHDiukFcMpPk=;
        b=igx0wUTdQcYupX1yAJkzuiW3tixL4/rG9QHDOE1OuemDauucgS0b4WPm/qNDTqc6tj
         dC8noNnsek02+MHALHDloPhHjY9PuAcO8cT0fqReQQSFMoKfhUaM0O2JYTV90eF5TW1T
         1ZpTQAHA+bZ5+sSSYuH0fi+CeElAYVF0uv+c3gA5rToEvxuK4V4z2uk297hwMXxNn/CK
         5nHug49g8iMgqh+7Bw17Kgzdbg90jtNx7QMIWVdBW/1UttBugbiKkD/nel+18aIOmhCW
         DnVdrCrB08b/fwlSt9/iJh7/Z32kjo9kzvfKYcbNc635DkaxYvbgHuDNWDgJOr4EWfTq
         +obQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=18Er9O41CS051aXSe9usnmRbqjT27fNlHDiukFcMpPk=;
        b=ANnMhkVjXsNYNasVpTkjmm6drklJJhe6+TPkMBQRDUyMUtog5zYvi74xsktOq8+bRK
         eSwnx1BJSi/4Sg0S+or4BIdl6nNpgyC1C8FO6KjquCI75wKBCz1Udj+vCNGMwRb3lkzX
         izuW3WCNB4xmaG5ew6oEgkxLoYdJ5vQV00ciOQzVaoQYJayVObVdL7DHgfErsnj+4E7V
         94PjNeRESutNFrtCXwTfBrW6HKBmTvRf5JK1Rae8V1SwNsrn82UwEcR1YjZKTlJkDOAz
         GQlBlYA3oHX3VFzIJ03mYTKxFOlzj6ux1vo1+Ys4B6gDLALEnNHCkUT79jCliz1txUty
         V8IA==
X-Gm-Message-State: AOAM532ETkgx0Fa3xXSSjzDxU3YPAFw2e3Q1kxExVMZWxY9tapiHVabR
        28r2qpmtIy5CfioFr5wk+liJmDvHMDzEy1VK
X-Google-Smtp-Source: ABdhPJz9ntngBIfCSaZOOirWq+VnWkQ9QbljpHNzGtI7ZAT0+hNeqeX9Vx2fzjW6MS3w55enQ0OqOdn0dJ+ys6A1
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a62:e518:0:b0:4fa:9333:ddbd with SMTP
 id n24-20020a62e518000000b004fa9333ddbdmr7319126pff.11.1653009701453; Thu, 19
 May 2022 18:21:41 -0700 (PDT)
Date:   Fri, 20 May 2022 01:21:30 +0000
In-Reply-To: <20220520012133.1217211-1-yosryahmed@google.com>
Message-Id: <20220520012133.1217211-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated() and
 cgroup_rstat_flush() kfuncs
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
tracing programs. bpf programs that make use of rstat can use these
functions to inform rstat when they update stats for a cgroup, and when
they need to flush the stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index e7a88d2600bd..a16a851bc0a1 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -3,6 +3,11 @@
 
 #include <linux/sched/cputime.h>
 
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+
+
 static DEFINE_SPINLOCK(cgroup_rstat_lock);
 static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
 
@@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	return pos;
 }
 
-/* A hook for bpf stat collectors to attach to and flush their stats */
+/*
+ * A hook for bpf stat collectors to attach to and flush their stats.
+ * Together with providing bpf kfuncs for cgroup_rstat_updated() and
+ * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
+ * collect cgroup stats can integrate with rstat for efficient flushing.
+ */
 __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
 				     struct cgroup *parent, int cpu)
 {
@@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 		   "system_usec %llu\n",
 		   usage, utime, stime);
 }
+
+/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
+BTF_SET_START(bpf_rstat_check_kfunc_ids)
+BTF_ID(func, cgroup_rstat_updated)
+BTF_ID(func, cgroup_rstat_flush)
+BTF_SET_END(bpf_rstat_check_kfunc_ids)
+
+BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
+BTF_ID(func, cgroup_rstat_flush)
+BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
+	.owner		= THIS_MODULE,
+	.check_set	= &bpf_rstat_check_kfunc_ids,
+	.sleepable_set	= &bpf_rstat_sleepable_kfunc_ids,
+};
+
+static int __init bpf_rstat_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
+					 &bpf_rstat_kfunc_set);
+}
+late_initcall(bpf_rstat_kfunc_init);
-- 
2.36.1.124.g0e6072fb45-goog

