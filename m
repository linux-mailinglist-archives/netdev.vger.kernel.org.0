Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491486EFF5B
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbjD0CbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242961AbjD0CbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:31:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABF43C03
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:30:40 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-24756a12ba0so5462703a91.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1682562640; x=1685154640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4couG4BvY3JielUUZmpwOAXPZt7eiYYa/cnyqJtYMcY=;
        b=iCeciy53FkncyTEa61u93EdyroUtj3yVBYxIfPJjrHwdMOMMw928rZGTxVJJVLkFkb
         7gIkVnBdyLdGoC1HiuFoGM7b2Mz3Af/SaGO/4XTlV6M2v3en8jkTUOyCHSrVYl+iXT3N
         dP6XRnOOEiEsm9WlR2pnQVrXK/3kETr8DtOYnQUw5B3B0UXNX4lTEUpbkx7Whln0c0YI
         O1x5gaZCKrdTt1OuwU8v8JrjmuUVJ967cKAUiagh3jIUjM4FtE/kQ85hHpC+6VSVxZMw
         hseVfj2scuw1HMzVb4LciHRbGZ3kNJkF2jo9N9F7InMZMQD93A/NOfvfS6IZ0eaJZESx
         8YoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682562640; x=1685154640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4couG4BvY3JielUUZmpwOAXPZt7eiYYa/cnyqJtYMcY=;
        b=emGhqnDNH6p2ptSsrY3gZVMXPDlhmkxcDf/ihIPyDf0HywZ28K3uMgg7i70JmszEU4
         lLCZhSD5Xi3l+3ad3LuKonAvwCIm4UKcWW0/bMhseAsfyoOWQkU/Qnvim5zkMAPiC+4c
         cC+eqGn7Yq19ybMNjsb7DMINW/4aB8g07YZpyAPOjgXYHYUL9KcinXKd7UnM1Dkfvr4c
         YEVUqk/GHag7P16u6KD6Szf2BJ3iCY7KdZ7TjF1VWfAhq7opjVtBMuYc2cwhB8xneL4j
         Xw7cFaQJ9OMyefFNdUCnmMv5J6BVwOdUtfaEcYXtNzDxlpzMtas6lfIwSGuePtqjjfuJ
         AQXQ==
X-Gm-Message-State: AC+VfDyzlNLSYQO2qPJSF7NxW7vBWc6nUwaXziZoHRsZcpm9Q5nKJWjn
        zHuggocdLKqDkEDFkWaRWsCZvQ==
X-Google-Smtp-Source: ACHHUZ6gccL1ZEpUmUDmifDB0DiS0469jZ/45YB8rECEfdb4SnsnHxXi1VpTC1ouLoKHsNE1+kTTjg==
X-Received: by 2002:a17:90b:4acf:b0:22c:59c3:8694 with SMTP id mh15-20020a17090b4acf00b0022c59c38694mr181241pjb.44.1682562640127;
        Wed, 26 Apr 2023 19:30:40 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id m8-20020a654388000000b0051303d3e3c5sm10291852pgp.42.2023.04.26.19.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 19:30:39 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        yangzhenze@bytedance.com, wangdongdong.6@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH bpf-next v3 1/2] bpf: Add bpf_task_under_cgroup() kfunc
Date:   Thu, 27 Apr 2023 10:30:18 +0800
Message-Id: <20230427023019.73576-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20230427023019.73576-1-zhoufeng.zf@bytedance.com>
References: <20230427023019.73576-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Add a kfunc that's similar to the bpf_current_task_under_cgroup.
The difference is that it is a designated task.

When hook sched related functions, sometimes it is necessary to
specify a task instead of the current task.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 kernel/bpf/helpers.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index bb6b4637ebf2..453cbd312366 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2149,6 +2149,25 @@ __bpf_kfunc struct cgroup *bpf_cgroup_from_id(u64 cgid)
 		return NULL;
 	return cgrp;
 }
+
+/**
+ * bpf_task_under_cgroup - wrap task_under_cgroup_hierarchy() as a kfunc, test
+ * task's membership of cgroup ancestry.
+ * @task: the task to be tested
+ * @ancestor: possible ancestor of @task's cgroup
+ *
+ * Tests whether @task's default cgroup hierarchy is a descendant of @ancestor.
+ * It follows all the same rules as cgroup_is_descendant, and only applies
+ * to the default hierarchy.
+ */
+__bpf_kfunc long bpf_task_under_cgroup(struct task_struct *task,
+				       struct cgroup *ancestor)
+{
+	if (unlikely(!ancestor || !task))
+		return -EINVAL;
+
+	return task_under_cgroup_hierarchy(task, ancestor);
+}
 #endif /* CONFIG_CGROUPS */
 
 /**
@@ -2400,6 +2419,7 @@ BTF_ID_FLAGS(func, bpf_cgroup_acquire, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_release, KF_RELEASE)
 BTF_ID_FLAGS(func, bpf_cgroup_ancestor, KF_ACQUIRE | KF_RCU | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_cgroup_from_id, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_task_under_cgroup, KF_RCU)
 #endif
 BTF_ID_FLAGS(func, bpf_task_from_pid, KF_ACQUIRE | KF_RET_NULL)
 BTF_SET8_END(generic_btf_ids)
-- 
2.20.1

