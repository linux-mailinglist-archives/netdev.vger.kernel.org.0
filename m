Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A01957E5E3
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbiGVRtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236032AbiGVRtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:49:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FEE9D535
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id p21-20020aa78615000000b00528d84505b5so2163473pfn.13
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DhjjSNuficgbRYAqqQ0W8XZGDABdrTHUp2H4nxtLaug=;
        b=UaSyoQoWOe59gEz2lV5iSdd4Xui68GIh6hAoQ3sXlaZ9lYziZzxJvwsR7TEv6NAokv
         Sn59n3tVFUsogki/DpXQSjv45PjR7KBr7ti3sKFj1mFcc7P6nFgVEtcK6iSm0RYItD6M
         rDjG5b/S24r7Uez1UAh6PRJcsZONVBjq4Gqs362SjaKNhEZNudJPq3/eXj7QKbR5LkZa
         dFSN25KbgRHCAKTyHak9TQqwz5SXaXPbjI+aF0Ku+oV+SZGpP0Zu08rHWA3mU1Vh8iiI
         LWaXOnJ0ieD04JU6IrzvzlTHGnWgdgsstD8/qkRiB06i1TI2MT3MGUYWvlai/fc9u6IS
         2MWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DhjjSNuficgbRYAqqQ0W8XZGDABdrTHUp2H4nxtLaug=;
        b=Pj2Gr/6av6WOHxVs1N7gwDuLDNRTdTl+SRxDH2IQ2ll2NOc1A9ys4UPNvKStbIhrGI
         Z9SnOj7b9wVhs/89UzTL4dR7wNDISP4K4WWh0rio3mcDm8fnDcZuirNxQN/hQjfIpEuQ
         AwIGeWyl2kUnFAOeLsiX018w1UDgGIG8vNlXkNHh7E8juVi9QuAYvbgBxE5ESr7rqlJG
         0lnMQHsvGWUPjhVpNLPT+I4l4lqlparxVyx0aJgtjFhLlm2z3tgOFPaVbojXdBmur4e2
         EgSH0NZwv/IcqpV6mqWCJR0PRYnvEv8IrlI0c02SRbfmlSuuRz2MoXiQPSUe42HDQXgY
         65BA==
X-Gm-Message-State: AJIora/jk7w8VdYPGaYR704fHYWOzRJyRRamy4qln8Ny0+5iusdVAYKl
        yC34gRHj1Iwh5jX4GWfNqnhw+9aQEFx/Sqoc
X-Google-Smtp-Source: AGRyM1vfG4k83dD4ZmpzMaHGOmUCxNQqE4VrQcU1BJMMbLD5EP1RXFYs48/aOKdOMxJ39iP8pTDTa9o06EiBppcZ
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP
 id t9-20020a17090a024900b001e0a8a33c6cmr1072620pje.0.1658512130666; Fri, 22
 Jul 2022 10:48:50 -0700 (PDT)
Date:   Fri, 22 Jul 2022 17:48:23 +0000
In-Reply-To: <20220722174829.3422466-1-yosryahmed@google.com>
Message-Id: <20220722174829.3422466-3-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v5 2/8] cgroup: enable cgroup_get_from_file() on cgroup1
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

cgroup_get_from_file() currently fails with -EBADF if called on cgroup
v1. However, the current implementation works on cgroup v1 as well, so
the restriction is unnecessary.

This enabled cgroup_get_from_fd() to work on cgroup v1, which would be
the only thing stopping bpf cgroup_iter from supporting cgroup v1.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 kernel/cgroup/cgroup.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734..9943fcb1e574 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6090,11 +6090,6 @@ static struct cgroup *cgroup_get_from_file(struct file *f)
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
2.37.1.359.gd136c6c3e2-goog

