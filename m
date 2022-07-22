Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E0857E5F7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiGVRtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbiGVRtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:49:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B5A97A2F
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:59 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y37-20020a056a001ca500b00528bbf82c1eso2164422pfw.10
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X6tKUBlbA8nN3xG2RPtSlzImscydSKylg1V9qleVuk0=;
        b=MyCABdF35wnlD4+fO3aE3NsmhVF7nMFpyfrKh2wyNwWxMPDWjPcwmylpuDApnSeFsb
         h9vbtZBrkVJiuLAipnN8Y8L3IOxkvaRGlnS82BJtESsPgvxQox//RXsO7JEET6i0ZpfV
         rRaZuj4PSu6gH4MviIP3etB2eou5gJn1o/3m1hlxGZfDaTXE+AW+WUJY3lnALCW+HoFa
         5KHYrEW+FoOfLz38LTn+ViG/j3hAk34YxenV2tLUGs1An1diG9uldVBqrv/NJ/1YuUKC
         gEX0j+10TdmxqCEOSsgjQWUvX5o7VEo6RNl508onrm8zp0fFTS7T9dkmHkZQ/tB2wnq9
         kWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X6tKUBlbA8nN3xG2RPtSlzImscydSKylg1V9qleVuk0=;
        b=cxqHosMNIgtZzDJPK67QnmI3Q0atJy6j1WXJ9kXJ2J+Dq4fZ3h1p7GaMeRdeWKoV/A
         o/7oidpjJUHobcAS/PCyYk6HWwm5FEk7eJ59OtqTNVenfU5t9WIyiESNJiC21vLlr6DM
         R8qvjtu32LIyIq/7BVeJWHD+rw+/lJgJPzfq+G717s30Xu1AULn4yjovJVoqMr3KXz3k
         NsU8PXRT9mHGwzSUMG3lHMMiFdw9woXaeXYPZDD4UMMeEmO0aH/HMpjIF/jc7lD6n3Qq
         8Zt1UI6h1c8NUz0a4B0Iq73KnBjVc6WrIBBHEEoG1QGYSDUSiS09R6sy69gr+LPW+z+s
         Zpkw==
X-Gm-Message-State: AJIora/hjXGqtr8hhiQqhOu7GlAuzQh8fkP53t1UWMl5od4YOdk6mUNN
        vte+EJ+HZ0qURVye0jporX40XXQs/D8wE1iq
X-Google-Smtp-Source: AGRyM1sa2I1JhiA3ANUFy0sAW/tCtKDN/pI064YmzkYWThl2TXJl5LBGAal/QjzuCQbnWjVpX1iwdJrmOwYB9/Qt
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90b:1c08:b0:1f2:19da:aa04 with SMTP
 id oc8-20020a17090b1c0800b001f219daaa04mr18169158pjb.90.1658512139198; Fri,
 22 Jul 2022 10:48:59 -0700 (PDT)
Date:   Fri, 22 Jul 2022 17:48:27 +0000
In-Reply-To: <20220722174829.3422466-1-yosryahmed@google.com>
Message-Id: <20220722174829.3422466-7-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v5 6/8] cgroup: bpf: enable bpf programs to integrate
 with rstat
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable bpf programs to make use of rstat to collect cgroup hierarchical
stats efficiently:
- Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
- Add cgroup_rstat_flush() sleepable kfunc, for bpf progs that read stats.
- Add an empty bpf_rstat_flush() hook that is called during rstat
  flushing, for bpf progs that flush stats to attach to. Attaching a bpf
  prog to this hook effectively registers it as a flush callback.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/rstat.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab5598..54c1ca86df72 100644
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
 
@@ -141,6 +146,31 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	return pos;
 }
 
+/*
+ * A hook for bpf stat collectors to attach to and flush their stats.
+ * Together with providing bpf kfuncs for cgroup_rstat_updated() and
+ * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
+ * collect cgroup stats can integrate with rstat for efficient flushing.
+ *
+ * A static noinline declaration here could cause the compiler to optimize away
+ * the function. A global noinline declaration will keep the definition, but may
+ * optimize away the callsite. Therefore, __weak is needed to ensure that the
+ * call is still emitted, by telling the compiler that we don't know what the
+ * function might eventually be.
+ *
+ * __diag_* below are needed to dismiss the missing prototype warning.
+ */
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "kfuncs which will be used in BPF programs");
+
+__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
+				     struct cgroup *parent, int cpu)
+{
+}
+
+__diag_pop();
+
 /* see cgroup_rstat_flush() */
 static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 	__releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
@@ -168,6 +198,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 			struct cgroup_subsys_state *css;
 
 			cgroup_base_stat_flush(pos, cpu);
+			bpf_rstat_flush(pos, cgroup_parent(pos), cpu);
 
 			rcu_read_lock();
 			list_for_each_entry_rcu(css, &pos->rstat_css_list,
@@ -469,3 +500,21 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 		   "system_usec %llu\n",
 		   usage, utime, stime);
 }
+
+/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
+BTF_SET8_START(bpf_rstat_kfunc_ids)
+BTF_ID_FLAGS(func, cgroup_rstat_updated)
+BTF_ID_FLAGS(func, cgroup_rstat_flush, KF_SLEEPABLE)
+BTF_SET8_END(bpf_rstat_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
+	.owner		= THIS_MODULE,
+	.set		= &bpf_rstat_kfunc_ids,
+};
+
+static int __init bpf_rstat_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
+					 &bpf_rstat_kfunc_set);
+}
+late_initcall(bpf_rstat_kfunc_init);
-- 
2.37.1.359.gd136c6c3e2-goog

