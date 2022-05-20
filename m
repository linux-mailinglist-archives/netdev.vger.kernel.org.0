Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4CD552E1D0
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344411AbiETBVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiETBVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:21:41 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B73629834
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:40 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id m21-20020aa78a15000000b005182fda1b15so2879637pfa.21
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 18:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=69cx6mPg1rWURoZo4NX3ijOmJtwQkSNn64F/hEHNYSU=;
        b=BCreR+XUKTegtpZpREe5xPvg68UCcKsrUAIVbGh5bI2zogHrCn+YHLq0FMySF7Z8+U
         3nTv8stgycmvTmhhg+YPkCLz4UYr3ZJz7474U4xhyJE3TKlT4rYlAp0vn5NBMmGoe2ov
         dgweabl3iJGlpFuwJTqJRwak1koJWau8g/NP85L4CjmiJUzSKn4LzPc2hkHvubatyBQP
         /96s5b/5xzfSh2L2JFvPZ2hVNpAhSiLyYoCG5VatpXZ/1CZSaKHDY0Xa+XvkgrFotW3c
         B1tX82bRy1h3iblza4rY3Q+jRM97bMVY3aW48bY0dTk7oUfdIoNGjySPHVcDY3xSepq3
         Yujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=69cx6mPg1rWURoZo4NX3ijOmJtwQkSNn64F/hEHNYSU=;
        b=YeuwuR6Kfbg5ig3AIj1AwaBAJrOCJoucYAwuiKd5rvxIcI2w0jsNsfW/1xlVSlnk5o
         LXzLUsjfRN168HS3/YOp/oKOHdybmOinwBxedqUfNEMefoVQ/CPebnWYl56WALG1+wEv
         EzVbaKLCXDuJJ4ykyV/WF9fr0wc1HzK5E6mnBww6LhwnGaeqfC1zMHfjDAVfxg0bEXLi
         KO3qt74WmzN5D8NMhoDIoRAqjKGXt56AzVHw9J8loWy2c7oKjnACVlGcZqaLuhFMbW1A
         FhgML8icgYJnEV6SW5WMId1GzHvXj8RlIX5kil2hqmpxpyLqqvr6dtnsjJ13072AqMdx
         Q5ng==
X-Gm-Message-State: AOAM531VEBG038Bjv6bpaZQ8292078vFqLFUNASDVT2vTd/L9u2mCXaq
        iX/ZwqfNPqoPkpxeAkC8x60Ykbsulpul+Zu3
X-Google-Smtp-Source: ABdhPJwhlm4uc6Arbp6IzP0EiWll+Bev9gm1/YHaZOBFW6aHkjOxNlzyA5wFDryaE/HeLy/GmQugBTe+SOD4g6uB
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6a00:724:b0:4fa:a35f:8e0f with SMTP
 id 4-20020a056a00072400b004faa35f8e0fmr7557670pfm.25.1653009699699; Thu, 19
 May 2022 18:21:39 -0700 (PDT)
Date:   Fri, 20 May 2022 01:21:29 +0000
In-Reply-To: <20220520012133.1217211-1-yosryahmed@google.com>
Message-Id: <20220520012133.1217211-2-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220520012133.1217211-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v1 1/5] cgroup: bpf: add a hook for bpf progs to
 attach to rstat flushing
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

Add an empty bpf_rstat_flush() hook that is called during rstat
flushing. bpf programs that make use of rstat and want to flush their
stats can attach to bpf_rstat_flush().

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/rstat.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index 24b5c2ab5598..e7a88d2600bd 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -141,6 +141,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	return pos;
 }
 
+/* A hook for bpf stat collectors to attach to and flush their stats */
+__weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
+				     struct cgroup *parent, int cpu)
+{
+}
+
 /* see cgroup_rstat_flush() */
 static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 	__releases(&cgroup_rstat_lock) __acquires(&cgroup_rstat_lock)
@@ -168,6 +174,7 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 			struct cgroup_subsys_state *css;
 
 			cgroup_base_stat_flush(pos, cpu);
+			bpf_rstat_flush(pos, cgroup_parent(pos), cpu);
 
 			rcu_read_lock();
 			list_for_each_entry_rcu(css, &pos->rstat_css_list,
-- 
2.36.1.124.g0e6072fb45-goog

