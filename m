Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8EA56C4C6
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 02:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiGIAFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 20:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiGIAFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 20:05:14 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE418655B5
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 17:04:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id gg8-20020a17090b0a0800b001efa2036d5fso158594pjb.4
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 17:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EG2qDk6ByEkDCcy5/lw/yCnEWyvySiTGhQusvRwrAJE=;
        b=lWgS751HTTYDjBF+pIzuFk0P4A3vjMcjk7i1GAcBGk33AGu1d0gXlHwiy6GYN9iZ3G
         Kxv4NfmJRwC8chzp8QXPx0TzwCck41k1cObGq66QIA9IaTCK3rwDFb/1e8KTHKqm6hLc
         4+LeFQhyIc2J6WdFDUAivcYhKdcmINY85REZvsxDHtsXImJcJukws5K+IBSrRGeQ+8Wg
         cr+D95okvC5iWohCCU9YlMdKk7avTNNee2t31mylWwieDsDPtWnywd7NQ8tJEWZ5vGSe
         PKOAQC7nPbPdMV7+aq0RlZlYTHusWgb7uNFslJ8KSx0dzAuhI8Iq65D6B1/hGCFDnZEz
         3dCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EG2qDk6ByEkDCcy5/lw/yCnEWyvySiTGhQusvRwrAJE=;
        b=hUpPNttUKW1V9yAXAcocCTWxdnXpzFOk+/GLsdUjsREPBtgQxAEXxdDgTYKOl+wMR7
         0DLJd7Lu3BBwCfhirZN5wmAECeZ2XYSx1JhxhEVEkn13OaGSdYxK4kQuqFf/87Rl5c2b
         kdaksRRa5BHQhLss/Kx858YuIjF2NOvqgX+bvN2IgSX8tthkRi+V4jn6ausuGrSp/nOo
         Vd5JghnlZQge/jAKHQdaHOXAsoiDj7dAZo7xgrqqV2Nri+LWGdS1bcwBHrO4OyGEcmAE
         5Xq9SLe7u3gUUdOzZOKd9G6mDgk4R4UZ46H/98eNLAi33PEq0McSY2bHsGzaufa/s0Jo
         Fc1Q==
X-Gm-Message-State: AJIora9DHivv36EdCdUu0bxvaQuQabLE0hDcphkSPi/imKGJyHQ/We/d
        ETZtMOOn9zAJAA77lMGk6IpqySXAkGrpAQEY
X-Google-Smtp-Source: AGRyM1vBZLtKVSKbIeuK37mDA+OZDWY3/SdblVKjPwbsfS/MZjmzprqrMWqoyJcMIYBSYzPSZbm8yeeqfZ76qplj
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:124f:b0:52a:b37e:d6f1 with
 SMTP id u15-20020a056a00124f00b0052ab37ed6f1mr4391676pfi.5.1657325097668;
 Fri, 08 Jul 2022 17:04:57 -0700 (PDT)
Date:   Sat,  9 Jul 2022 00:04:37 +0000
In-Reply-To: <20220709000439.243271-1-yosryahmed@google.com>
Message-Id: <20220709000439.243271-7-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220709000439.243271-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH bpf-next v3 6/8] cgroup: bpf: enable bpf programs to integrate
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable bpf programs to make use of rstat to collect cgroup hierarchical
stats efficiently:
- Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
- Add cgroup_rstat_flush() kfunc, for bpf progs that read stats.
- Add an empty bpf_rstat_flush() hook that is called during rstat
  flushing, for bpf progs that flush stats to attach to. Attaching a bpf
  prog to this hook effectively registers it as a flush callback.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/rstat.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab55983..0f87c31eecc27 100644
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
@@ -469,3 +500,26 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
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
2.37.0.rc0.161.g10f37bed90-goog

