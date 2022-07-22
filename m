Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2808557D850
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiGVCNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiGVCNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:13:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26435974A6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:13:22 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r64-20020a254443000000b006707b7c2baeso2639324yba.16
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wbl69skgO/KCoHNYhblp1Sm0LyLquoPWEcXNs9wNbPo=;
        b=rJw9XC43mi44QB1+Zv+0EGo3oMTnE3xe40wMfxakx81g1cnLeUw8Cqv3TXRAwkq5Nm
         KWWt0RRBq515La0wxMhp4lujt3SNAU2uOhbdpvKiidxcIh2PL33Oj5r+vvAOsnCaz+4z
         712oAh2ADlaHBRVXKonzX4NgiiG+h9/t7W24Ix8ZpvCxIABdoaeeRTNXfF3VZzZFqLvd
         VgrZ32yrVT8iBTQe5diAh22lTuse6Ccpw5IXSvL8IaLDafmbtLex5gYU+QieMMEM5Q/Y
         glTTnu3V3OgdhFpOkdcrWxlrWCiC46vn1hvEItSHzRB2+ARpJ7Z1TnP91zok+hwYxRiT
         Fvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wbl69skgO/KCoHNYhblp1Sm0LyLquoPWEcXNs9wNbPo=;
        b=X6R5W8gmhN4rwdL4ihG2qEIMxVl/SAK6/fet9HuC8O5rP10G8S8NaFxoE18BDfBh/a
         0Sgp7Wulm8azvimH7/nDjONEBzFOGJO0FRsch2tbc6t97l/it/vhBbiuvQw5GTPWlWG0
         rINm1mEdfyhNmT8ZhvCDL4MGVXAFlVFM9z3ymmBJGUREJfbCwKqtmL3+AOQnYW2BPVlu
         46Czp9bXSQyVR/ZqPV1ceh69g4Q8njTp2nowcwKrNRyA5x1lPf1jKku5O1Q1E+7nArgE
         rqsKpUBNPwMOoiY3RNh4Z9xulmsRih5KjhaMj/25X5Y9/JQI0h2ZvVEPeF3YA7WHBPWY
         Amkg==
X-Gm-Message-State: AJIora/dgAjC9zIYGqG40bUcI/xc6QxhiNWyh4rxk6ZrOfNP3Bx7BYdl
        gkcbeY7lL04e9kF1Uwx04Vu4STWfdB9+vcTH
X-Google-Smtp-Source: AGRyM1u1pgebccH4JOJx8RvDnApJJlB/bWLrM4dNttWXKsxXRFc6nHj6RzR/7COXpyyusIvV/1ZjGqw4zd+WGeSU
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a05:6902:352:b0:669:4175:d1af with SMTP
 id e18-20020a056902035200b006694175d1afmr1243340ybs.395.1658456001361; Thu,
 21 Jul 2022 19:13:21 -0700 (PDT)
Date:   Fri, 22 Jul 2022 02:13:08 +0000
In-Reply-To: <20220722021313.3150035-1-yosryahmed@google.com>
Message-Id: <20220722021313.3150035-4-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220722021313.3150035-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH bpf-next v4 3/8] bpf, iter: Fix the condition on p when
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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

