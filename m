Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981C1586FE1
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbiHARzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiHARy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:54:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547191EED5
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 10:54:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m5-20020a2598c5000000b0066faab590c5so9060925ybo.7
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 10:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cxTBeNDE2Vos2amVx0IFxaTBG3CN0O03w1708CxS3o8=;
        b=LD0tmXtaxZIUTmWgxb2yYUv+ugYjOBYoAhpT0qn1mRMoeh/za9CtDmbENwz/QcVd21
         Wfi7jNdvjtvP3y9bFeXo7p0tAE7vjU1+ha+Iung12c4X0AeofP92ASLi8YrusWVUf8F+
         6B38if1U0WT6tXZpsmVPk8BOSDwLOMhRgenRnLN68eIgbioxHG/4bvUeVyGvDLBM/6Pw
         MOsSIo8FfPtmyMQqVssLpTYz6gFa8FKipYo/At4Qi9d2XWN2+xSnIOAf44kA/brabdaM
         cQNZuC+rhLzPb6085SzHi7w4QqOdQ5BrAHOojo0Q/AlghSXxYu6zLIUgEw5ZCdS5lE4V
         NXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cxTBeNDE2Vos2amVx0IFxaTBG3CN0O03w1708CxS3o8=;
        b=zNYy+wJ4TsxgJg0ebw2v5n/TsYpLAYC0JGBVFZ0/IScXWVEeNHmwLDaUcjZyWYPyxp
         8PqvPxgXEt8uXD9DlkUq3o/nu3LVaKIk00qKGadvJA9oJmVKUUcxuy1P9eXP8jeTMVPn
         dk5Nhj3D4OFD1u+XerDm1FiOKYYHJCg2vE1HAbvtVroqqVp0oVA7ccgE9yVHHhd8A+5N
         pRh6SiZtf74slXcwte1jFstnr2WP+wxWiuLOX0bAmfup16gxM9Zx8cilPgO7nQcZqx+y
         hmY6RIyb39IDbsx5k3SacT5chYF4amiqIuxsydYpm4fUI3w9DwOskH60YzstT0+YCjbb
         Asbw==
X-Gm-Message-State: ACgBeo3pGOL2xBfcN3bMPufc7xE6YRF+aE28XamZYvJf6wyc9siveUm+
        DcZCfTJhv/KXi2Rqrp5bF+Ob6aVarC0=
X-Google-Smtp-Source: AA6agR5ZDhPslrM56YGY7QhzssWog/JF08icdlHjp9Q4/N23vQ1TYo1yBl4EoRAeZrVlJz2BYb2G6TaukYY=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2d4:203:7c9:7b32:e73f:6716])
 (user=haoluo job=sendgmr) by 2002:a5b:144:0:b0:66e:a56a:4011 with SMTP id
 c4-20020a5b0144000000b0066ea56a4011mr13049409ybp.133.1659376482040; Mon, 01
 Aug 2022 10:54:42 -0700 (PDT)
Date:   Mon,  1 Aug 2022 10:54:02 -0700
In-Reply-To: <20220801175407.2647869-1-haoluo@google.com>
Message-Id: <20220801175407.2647869-4-haoluo@google.com>
Mime-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH bpf-next v6 3/8] bpf, iter: Fix the condition on p when
 calling stop.
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

In bpf_seq_read, seq->op->next() could return an ERR and jump to
the label stop. However, the existing code in stop does not handle
the case when p (returned from next()) is an ERR. Adds the handling
of ERR of p by converting p into an error and jumping to done.

Because all the current implementations do not have a case that
returns ERR from next(), so this patch doesn't have behavior changes
right now.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Hao Luo <haoluo@google.com>
---
 kernel/bpf/bpf_iter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 7e8fd49406f6..4688ba39ef25 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -198,6 +198,11 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
 	}
 stop:
 	offs = seq->count;
+	if (IS_ERR(p)) {
+		seq->op->stop(seq, NULL);
+		err = PTR_ERR(p);
+		goto done;
+	}
 	/* bpf program called if !p */
 	seq->op->stop(seq, p);
 	if (!p) {
-- 
2.37.1.455.g008518b4e5-goog

