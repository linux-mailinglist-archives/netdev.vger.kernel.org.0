Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3015059F19D
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 05:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbiHXDCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 23:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiHXDBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 23:01:45 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BF97DF57
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 20:01:11 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3345ad926f2so270724717b3.12
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 20:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=h0j1tmcryfszvpEO+TtDzb67ntXXnPtNryRzQx2IqTE=;
        b=nZpScWeBj5Y7oVtwP7UXuKRE97XwsaQ9gMJ3OYVHSEjml+RkUW7kdC2BC03LA1Pr10
         UT0m2RfXsKATgs7cqw7BawdfyYXbN3iPevPeTNGjop9F7VN3VsPFOhQLNHgoyH88028a
         5vMyWQqjcS9QIAanZMKJBNJXfy3kNYnjO+nepaMAPwPSafWQQKX49b6KG3lG7mcjlq0d
         emOJOlYctXQRTcCwqJaZNCDryE0EMINQsbMYiajZFy36myU9wznhEAzVZcuX+8N64o2y
         bYuZYWPXYeX9SlsWcKauGRyibb5E3L+GcAdb0T/0QcafLuVPZiK5tdDQz2Iqpx1Jvmbx
         g1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=h0j1tmcryfszvpEO+TtDzb67ntXXnPtNryRzQx2IqTE=;
        b=Ac2OsdS4alK/fszzJGnc0hZo7KhxOuDpsBTMBfLyS7bPTaDXp4eRZC4h36xyD4DaH2
         tH1oIEWxCRtcktVYBctQGPQvj75pyex9KTbAZGC6wzNHnvczOzypmYOIdgdDsvVwuCjC
         350ChO1mMsJTIzFVJoS2LCLcrD8AMf4llPBK3CBjR0Vmc9aDrUmdAwVqpo07pX3rfbMu
         VZydgJfYUUov87aM2IVsQJ9G3g5t6fOe6t42eiXGo+ntjiZnCV7xTnnE8z2hV8SqZWIu
         tj+hYaylCNz9VfEH9+4pHonU5TbluJv4J7PHoxPZwIoWgyhz/vcSinAGo6FtOBaTvaXt
         b8/g==
X-Gm-Message-State: ACgBeo1gcC6opfigcf50AJe4rQznj+QGfBvHq00DyCnUQP6uDOTddMVH
        PMOVY2mYjLxqqZiBpkElMs7OYnMYdyU=
X-Google-Smtp-Source: AA6agR7zgldne2tNFlhsEM6QotYQ2tHO2UAz1ZObX9tjKXxB9wVHuiA9GRBUc9ukFxKJtz0JHNWkgS6zoGQ=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:87e3:473b:a297:1247])
 (user=haoluo job=sendgmr) by 2002:a0d:f282:0:b0:329:7da1:90e8 with SMTP id
 b124-20020a0df282000000b003297da190e8mr29139161ywf.519.1661310070509; Tue, 23
 Aug 2022 20:01:10 -0700 (PDT)
Date:   Tue, 23 Aug 2022 20:00:29 -0700
In-Reply-To: <20220824030031.1013441-1-haoluo@google.com>
Message-Id: <20220824030031.1013441-4-haoluo@google.com>
Mime-Version: 1.0
References: <20220824030031.1013441-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH bpf-next v9 3/5] cgroup: bpf: enable bpf programs to integrate
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
        Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>,
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

