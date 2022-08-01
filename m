Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439EB586FD2
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiHARy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiHARym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:54:42 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CDB12770
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 10:54:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31f4e870a17so96615447b3.9
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 10:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1MQEHp+uPveOmZBO2w8/VdQxe4yWB13dK4o7EbmOrFM=;
        b=OASAc39jaSNasFVK5EN0ERbBf1LiiHWKnKgjnRjmVVzdPHUdsjvY4hF6IPlZEQmdUe
         tz+SIRqq3C7joulADC7AJO5sE8zqqlTAVdwjipZq0W0rD9iLqcq2n7QB8BkPqp7j/Pj/
         IRaUav0mIyHpo+Nv8I8Y7zy0aTpBHtWda2SEpthbHgfqsj8iISZNG0U9Eb/aPoIAJpsB
         g9ecwAKTh0zl6PMFWv+UOy2cOCXs8IBqyrFi2HNRfaQoAGIA6Qkii384wrNMJEi0Ehxa
         cHdlOYkyeVGn3UVAbCr7OjubrPTzPlT2iVsmzcBIw/8JIFdN/+9hhrTZvgX929w0qFDq
         Du9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1MQEHp+uPveOmZBO2w8/VdQxe4yWB13dK4o7EbmOrFM=;
        b=pgp+BB6MvN9VzjR/TCFROPtbmAB2TZnoj+Q2PvSdt+EVkO49aw3P4ht66xc9eAVlbA
         lAI3qvY8Vad4aI2O/goX2mnvJJyIYnTOxwuzvCZya9xEy+iRttW1GsZfIM614H7xY8NI
         yxpt6SCde0KllVlhg3Bxhw+4UhwLBSTh607T/RcLQS3msIJzQOhWoC2vdV8S6SfXBCaw
         jb6UNV1jSFvla/tgku028VzR9OoILLvf6LuuG5LU9SMBFJu8nqpnu4vuwCDXxWkFkcTo
         DBew2FgK6A7vIRvPcFZsz+N+ZAicRsRR05LFy5fh6fPvU6xyFkXPYBYy69/ms9ORYW/T
         BtzA==
X-Gm-Message-State: ACgBeo1qIH2nTQ81TNwzodyFxmgFxhkJ2dnfzVue+kIJzuUHyDoFjrsS
        Q/S0hVUkMr0BspAypRYngAqXAml8aLQ=
X-Google-Smtp-Source: AA6agR4fyH19hzDaq8AHc4igKnH+awdkL2zP+7Q+B8mbbub5P8/WRBsU6hiDMXSigkuA+sAIf3i8yhCLXzA=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:7c9:7b32:e73f:6716])
 (user=haoluo job=sendgmr) by 2002:a81:8351:0:b0:324:5ffb:5d1a with SMTP id
 t78-20020a818351000000b003245ffb5d1amr11742086ywf.337.1659376479536; Mon, 01
 Aug 2022 10:54:39 -0700 (PDT)
Date:   Mon,  1 Aug 2022 10:54:01 -0700
In-Reply-To: <20220801175407.2647869-1-haoluo@google.com>
Message-Id: <20220801175407.2647869-3-haoluo@google.com>
Mime-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH bpf-next v6 2/8] cgroup: enable cgroup_get_from_file() on cgroup1
From:   Hao Luo <haoluo@google.com>
To:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yosry Ahmed <yosryahmed@google.com>

From: Yosry Ahmed <yosryahmed@google.com>

cgroup_get_from_file() currently fails with -EBADF if called on cgroup
v1. However, the current implementation works on cgroup v1 as well, so
the restriction is unnecessary.

This enabled cgroup_get_from_fd() to work on cgroup v1, which would be
the only thing stopping bpf cgroup_iter from supporting cgroup v1.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 kernel/cgroup/cgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 13c8e91d7862..49803849a289 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6099,11 +6099,6 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
 		return ERR_CAST(css);
 
 	cgrp = css->cgroup;
-	if (!cgroup_on_dfl(cgrp)) {
-		cgroup_put(cgrp);
-		return ERR_PTR(-EBADF);
-	}
-
 	return cgrp;
 }
 
-- 
2.37.1.455.g008518b4e5-goog

