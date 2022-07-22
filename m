Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B5557E5DB
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiGVRtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbiGVRtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:49:01 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4959DEE8
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:53 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id e21-20020aa78c55000000b00528c6cca624so2139819pfd.3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wbl69skgO/KCoHNYhblp1Sm0LyLquoPWEcXNs9wNbPo=;
        b=AmUgsvum8Imcrw7TkDzaGbus+Rb4RvrczWCp5I5by2yqHRT10dP5RNXchlZWMy0XCa
         RxBTwZWpW61iQlaiiYafIDEh6C7ufsrZYHCDvW49uYthANuemdP3MIfHhUS9X0zzXWjt
         M43GzdejCLYF5izJthcOjdmrlVixZf4xTtal42R4qcJxO3KkQmSQFP4Sdo/moRIJfpCo
         7sCj8zlKVY/yi72ECe+6WEUiF3b3phpz2DL3aAvl+IpJ1IQCSQt+iQStmFwLE5pFeTrh
         n+gwJP81y3rWRTnB1SMGupv71Ovs/WSWrxoGIg4XRTqJcG0S6WGumNLNRRNXnnvIX7hi
         qbrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wbl69skgO/KCoHNYhblp1Sm0LyLquoPWEcXNs9wNbPo=;
        b=oQF/sJyEQZtfAWYIt2G248Nc+jO2z1yFxVrL5bJR6rm7g9ChSQpLNQnjlGEP9/Rd7P
         Zy9kkET9P3qhJ4w0aFeTCqUcQcUBu68sLajAo4Qr512NtjBnGLDkM0b/6Say8/8GCWco
         gwWtQBuSk9n+f+77exSngsZZwGR23PgUNmaK23sgd+dlJdhx2+RBA++VBeUYBqhkMPQ2
         JvDG9Eg/nMfh8Kqy34TUKbAo0V0JJmLBNHF1SuWjJpX6yf2ffrc3oqWhQLbYAVQJzZdT
         sIaZuT2YywCqqLuHD+I7uGBNJ8/eLVnualJtuD+oaSMOCnTVymnYsv+Ch7H91PxMKU5a
         05Rw==
X-Gm-Message-State: AJIora8hmMU91HPhdCe3tCL6bSatSg6vBbZTsYUmNMcl2p/ncpaQble+
        ScXsm1290B3yMfr1N55MOhrRDi+ZF4SBZwK6
X-Google-Smtp-Source: AGRyM1tTWZqgJstxad4aJ/olu/cwPgtph6W5MU4NplL/bFH47OLxRw7UTpWSI49Yun/ZgK449GSC0hp2qZ+8WXG5
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:903:228d:b0:16d:4549:1078 with SMTP
 id b13-20020a170903228d00b0016d45491078mr958471plh.78.1658512132836; Fri, 22
 Jul 2022 10:48:52 -0700 (PDT)
Date:   Fri, 22 Jul 2022 17:48:24 +0000
In-Reply-To: <20220722174829.3422466-1-yosryahmed@google.com>
Message-Id: <20220722174829.3422466-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220722174829.3422466-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v5 3/8] bpf, iter: Fix the condition on p when
 calling stop.
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Luo <haoluo@google.com>

In bpf_seq_read, seq->op->next() could return an ERR and jump to
the label stop. However, the existing code in stop does not handle
the case when p (returned from next()) is an ERR. Adds the handling
of ERR of p by converting p into an error and jumping to done.

Because all the current implementations do not have a case that
returns ERR from next(), so this patch doesn't have behavior changes
right now.

Signed-off-by: Hao Luo <haoluo@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
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
2.37.1.359.gd136c6c3e2-goog

