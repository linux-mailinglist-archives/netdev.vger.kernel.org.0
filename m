Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C164158B15A
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 23:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241378AbiHEVt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 17:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241443AbiHEVtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 17:49:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B547C195
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 14:49:08 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-324966c28e5so31304397b3.3
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 14:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=C+Iy4ZCmB+ISavp/KSQWytbBtP5lX7pymE33Bes2CKQ=;
        b=eWABbD0wEBZOZlr5Zxc+y9xa0WYiJXB933g0IcK7klW7bckEWUQPNrAZdSP/zvSvLW
         /qqJwW4ApuiEKDYMyCizboSkhJO/G8E5H34PUto5S7x3QiRM7LeykuPS717hUiNMlw3F
         8r6tys6QW4axOrirrPb6gD9/hfGMIs8j71MmyXNV20cWpt0tECW0xZ1Mbuu0et56o4AT
         FCHHVTjnNtJv5MgzzJ19ooCuZ+gP/OCrTza6AOW27h+awBfK1IN/zpIEkHbGIasb9shA
         aJFaEGmjdqAUIFol8na6n0wGw8Hv+jJuYmOq4+c9qkUFUz4H9Z/Fsc55cr/6Gzk6peRQ
         V1fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=C+Iy4ZCmB+ISavp/KSQWytbBtP5lX7pymE33Bes2CKQ=;
        b=fN80hEr1TVh4a8GdHzoFl4db/UG/W+zFTwiAQDcToBegn1f1uek1rqzmnOZRkgaH7T
         5Qs3A3bysX3bSA/SrS8kbkoqGJIZGG/3EYZkb6SeCfuOaw42hBSCrbTCO0uE0WQJlVvX
         wko4WsQNGn6esgXBtrxMdrLVeyZ2K8yDnlqypG1xM7lXlv539NOqkvSg8jbQBkdt9q9B
         2HmH2FRXIjU4EabRGu55yZv9ho8HIx5K/YYnecfqalg606R2LBgDe1k94bgHKCsaG7KT
         Kfala/3ZxcGUl8UGxf+SGjOtcn8UdkcVSphmnJf+m2ApYzL/oOvBlZd4sn6u5sAuO/lP
         +fWg==
X-Gm-Message-State: ACgBeo36cCRD7m9g5yY0FH/WJxg4GTJpbhPeyTa3Ar7nMQNoJhpMm4Ht
        ZlsDcX3fMxRp+8zQLryv2qgzIg0nDu4=
X-Google-Smtp-Source: AA6agR6oApV2VR6d1hzkIVMBvq2n1ZAptIKvBvNi/0IvHg47EVLMEGCeBs8FdNtfREII8+b6YLAN3zRptFY=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:4f27:97db:8644:dc82])
 (user=haoluo job=sendgmr) by 2002:a25:b9d0:0:b0:67a:6b9a:ef84 with SMTP id
 y16-20020a25b9d0000000b0067a6b9aef84mr6860219ybj.282.1659736147449; Fri, 05
 Aug 2022 14:49:07 -0700 (PDT)
Date:   Fri,  5 Aug 2022 14:48:19 -0700
In-Reply-To: <20220805214821.1058337-1-haoluo@google.com>
Message-Id: <20220805214821.1058337-7-haoluo@google.com>
Mime-Version: 1.0
References: <20220805214821.1058337-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH bpf-next v7 6/8] cgroup: bpf: enable bpf programs to integrate
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
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
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
index 24b5c2ab5598..3289f6e0d306 100644
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
@@ -469,3 +499,21 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
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
2.37.1.559.g78731f0fdb-goog

