Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E1A327795
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbhCAG1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:27:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhCAG0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 01:26:19 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78466C06121F
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:25:36 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c19so10380763pjq.3
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cilHKXrKoJZLqevMF5os7tc8I3h7Pgl0p1o36mO7uUg=;
        b=zssOM8W3NPBUtqhS102B5C1SbgE+Bno0K/TPpFBgYelvNPEhaNlsO+yd+VVxFNtaaK
         o5pFwnjOR4aO86xW3/lnvTINF6Iirdi/psRZIigw8T0h2n1QNlYJg/wxUwnXY9zMqEBZ
         lTh3rQTJtcd+uUKvKFBk0sJK13wJGcNmvDqCYFIp9VywEzeCUUALceII5oYAR8aoC7Zv
         3k30ytpmiItqUAZdHqYleUAlLuU0TbWtMh/DZXVKi8EfGvffWzK9kToWwTUlfXgLampg
         9OsLywpEh8Y34TOjPoOpb45nqB2oCuFssRLKkeoB9Bq7xuMXkTnpdadyJ4sufQmmEyUt
         GqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cilHKXrKoJZLqevMF5os7tc8I3h7Pgl0p1o36mO7uUg=;
        b=p/+ixmuyprbECsqPrmwS7+j22bewNUH45aJvJi3JJ7yA0hkputHX6u7ZwoyWB1vRAT
         dU5a535fjKgBgc2+jWD/XGDm+WETnfJae6jylA08QCrYT5KpGTAfaD1z1/lsM3C+D3F+
         aywPBRX7R6I6+bQnWaDdzyoiCEKyUk6jqjenNIGiFtHoLC7q6wwqIJ6C+N5L4JijZiIF
         aZHG0lE/q0PeqJiNqWdbPAcZRRKjZvFH1yPofRFLPsjoXgqYOnpXk7uZLIs9TaDTWIT5
         7qS6IfH7wkymEuaBkGL9wBPwNMv8QdC+Nh+K++XxiWUyq0166T1s8z2mIzu+Ehjd8FsV
         na7A==
X-Gm-Message-State: AOAM532B7FoUO/xGaQ4QNUaFdkyfjzhQmugmeYyXo2CW01ZN5rR8eKGT
        gE2uCI8uB+iidMCIKlUPMevu3A==
X-Google-Smtp-Source: ABdhPJwKcQq6Yrke/Tm5Uu3pCbA2fYBARwyQ1sJ8bIr8LOsrVilkNDd2hPKgZi+Qgq+FIgomMOS4GQ==
X-Received: by 2002:a17:90b:3890:: with SMTP id mu16mr16002179pjb.9.1614579936050;
        Sun, 28 Feb 2021 22:25:36 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id x6sm14304626pfd.12.2021.02.28.22.25.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2021 22:25:35 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com,
        alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz,
        mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, daniel.vetter@ffwll.ch, longman@redhat.com,
        walken@google.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, keescook@chromium.org,
        krisman@collabora.com, esyr@redhat.com, surenb@google.com,
        elver@google.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        duanxiongchun@bytedance.com
Subject: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to CONFIG_MEMCG_KMEM
Date:   Mon,  1 Mar 2021 14:22:26 +0800
Message-Id: <20210301062227.59292-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remote memcg charing APIs is a mechanism to charge kernel memory
to a given memcg. So we can move the infrastructure to the scope of
the CONFIG_MEMCG_KMEM.

As a bonus, on !CONFIG_MEMCG_KMEM build some functions and variables
can be compiled out.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/sched.h    | 2 ++
 include/linux/sched/mm.h | 2 +-
 kernel/fork.c            | 2 +-
 mm/memcontrol.c          | 4 ++++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ee46f5cab95b..c2d488eddf85 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1314,7 +1314,9 @@ struct task_struct {
 
 	/* Number of pages to reclaim on returning to userland: */
 	unsigned int			memcg_nr_pages_over_high;
+#endif
 
+#ifdef CONFIG_MEMCG_KMEM
 	/* Used by memcontrol for targeted memcg charge: */
 	struct mem_cgroup		*active_memcg;
 #endif
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 1ae08b8462a4..64a72975270e 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -294,7 +294,7 @@ static inline void memalloc_nocma_restore(unsigned int flags)
 }
 #endif
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_KMEM
 DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 /**
  * set_active_memcg - Starts the remote memcg charging scope.
diff --git a/kernel/fork.c b/kernel/fork.c
index d66cd1014211..d66718bc82d5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -942,7 +942,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	tsk->use_memdelay = 0;
 #endif
 
-#ifdef CONFIG_MEMCG
+#ifdef CONFIG_MEMCG_KMEM
 	tsk->active_memcg = NULL;
 #endif
 	return tsk;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 39cb8c5bf8b2..092dc4588b43 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -76,8 +76,10 @@ EXPORT_SYMBOL(memory_cgrp_subsys);
 
 struct mem_cgroup *root_mem_cgroup __read_mostly;
 
+#ifdef CONFIG_MEMCG_KMEM
 /* Active memory cgroup to use from an interrupt context */
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
+#endif
 
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket;
@@ -1054,6 +1056,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
+#ifdef CONFIG_MEMCG_KMEM
 static __always_inline struct mem_cgroup *active_memcg(void)
 {
 	if (in_interrupt())
@@ -1074,6 +1077,7 @@ static __always_inline bool memcg_kmem_bypass(void)
 
 	return false;
 }
+#endif
 
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
-- 
2.11.0

