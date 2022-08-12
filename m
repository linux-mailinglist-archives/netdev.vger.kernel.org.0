Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8C059163E
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiHLU2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 16:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiHLU21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 16:28:27 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0187A74CC
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:28:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 185-20020a6218c2000000b0052d4852d3f6so898620pfy.5
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=h0j1tmcryfszvpEO+TtDzb67ntXXnPtNryRzQx2IqTE=;
        b=MzUknYElmzrxfzYxkrf+jNcWgb84/EExUa+DMdz3KNODbK/pH9TGVY8ApMKHxf9PZ9
         20MhbO/K2t8F04TjtAvuSrJBCDpLDyGsf0IZkf1teTHoy7Yqq1J4q+otxM5dVI/mQYXv
         JoFx2TknRi3drwR4tXCdIUECBOhjpo8RMHNpBYTW3H3Zayab9mYysKBDf+6mXd+OoQIL
         Bw+dGjgNEXrsW/L6RJZWD0Ydv7AWBEnyCDzDv+ZoUbgRdhMJFNQiBGDuoQ6Gzdx8yERI
         GpVvWV/LkulDwuo7/7l2KNLjoUhc3k62bFO8L+a/b1sz4xQjEZ7jFgvXnRR2xxjTV3ik
         SUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=h0j1tmcryfszvpEO+TtDzb67ntXXnPtNryRzQx2IqTE=;
        b=3k4i5cyZ63EBOPw8NcSnIXp1KR3YL+MQ4r0qjaFimKvU68RJNmsNY/fqEZcJcOpog5
         GQUPc6em+OpSiSfDAdeQe0CKfQl+/2IRx2d16INbC+2xznIIDRZBZeeiYoVfFxOefW+5
         83b/pSyjV45WeJiFT0J3cNZKliad+8g0VunTvE4ibQcwbU1x3c95CCO4KV+zqTCg8zTx
         P1EUdHWdAgOIvVTRVN3anPKjwIe+Hl5E5X6evcY/fYjtGp4NGOWiqBMfbdd81XrPAbSR
         sMm4FhcNqllrSTCtF3HqkHaPujhqJhQbJjKx3T5gHafAExsRUyuj72/h3grVRMJV8dgL
         fO9w==
X-Gm-Message-State: ACgBeo3Z/Wt43I5HLgPPbbDhscynf5jgM67ZWw6FyxTqNGAPYgV5I+s3
        n62JaMZcrZP0aIq0TLpOVaTDVAn8Rmo=
X-Google-Smtp-Source: AA6agR5fnr/CfyN8/juwe1x/CjcF4OI5zx4bcOpqulQbYRS/GyJFG7vZVJ0r20SSXvNBuA8ORSEFTbI9BlY=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:da3d:b609:da67:694a])
 (user=haoluo job=sendgmr) by 2002:a05:6a00:999:b0:52e:cd5e:3453 with SMTP id
 u25-20020a056a00099900b0052ecd5e3453mr5138255pfg.76.1660336093994; Fri, 12
 Aug 2022 13:28:13 -0700 (PDT)
Date:   Fri, 12 Aug 2022 13:28:00 -0700
In-Reply-To: <20220812202802.3774257-1-haoluo@google.com>
Message-Id: <20220812202802.3774257-4-haoluo@google.com>
Mime-Version: 1.0
References: <20220812202802.3774257-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH bpf-next v8 3/5] cgroup: bpf: enable bpf programs to integrate
 with rstat
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Hao Luo <haoluo@google.com>
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

From: Yosry Ahmed <yosryahmed@google.com>

Enable bpf programs to make use of rstat to collect cgroup hierarchical
stats efficiently:
- Add cgroup_rstat_updated() kfunc, for bpf progs that collect stats.
- Add cgroup_rstat_flush() sleepable kfunc, for bpf progs that read stats.
- Add an empty bpf_rstat_flush() hook that is called during rstat
  flushing, for bpf progs that flush stats to attach to. Attaching a bpf
  prog to this hook effectively registers it as a flush callback.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 kernel/cgroup/rstat.c | 48 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index feb59380c896..793ecff29038 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -3,6 +3,10 @@
 
 #include <linux/sched/cputime.h>
 
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+
 static DEFINE_SPINLOCK(cgroup_rstat_lock);
 static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
 
@@ -141,6 +145,31 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
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
@@ -168,6 +197,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 			struct cgroup_subsys_state *css;
 
 			cgroup_base_stat_flush(pos, cpu);
+			bpf_rstat_flush(pos, cgroup_parent(pos), cpu);
 
 			rcu_read_lock();
 			list_for_each_entry_rcu(css, &pos->rstat_css_list,
@@ -501,3 +531,21 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
 	seq_printf(seq, "core_sched.force_idle_usec %llu\n", forceidle_time);
 #endif
 }
+
+/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
+BTF_SET8_START(bpf_rstat_kfunc_ids)
+BTF_ID_FLAGS(func, cgroup_rstat_updated)
+BTF_ID_FLAGS(func, cgroup_rstat_flush, KF_SLEEPABLE)
+BTF_SET8_END(bpf_rstat_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_rstat_kfunc_ids,
+};
+
+static int __init bpf_rstat_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
+					 &bpf_rstat_kfunc_set);
+}
+late_initcall(bpf_rstat_kfunc_init);
-- 
2.37.1.595.g718a3a8f04-goog

