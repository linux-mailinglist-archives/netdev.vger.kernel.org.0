Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EECA4FAC30
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 08:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiDJGCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 02:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiDJGCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 02:02:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2872C40A10;
        Sat,  9 Apr 2022 23:00:28 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id j8so11324706pll.11;
        Sat, 09 Apr 2022 23:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lp811Xhpus0vpIQXccI+kJ+HvSPttYJotJ9EUMN/yrw=;
        b=WROxXnAewSuqPxyY89YNJd06KUprjfXmkGDNA0OPwz43LTKmYSzBpOunPqJ6WG8q85
         e3Wet3WJgbxdkr1ekVCxZBNRaJbAl5kK/dcAK4b5MPZ9ztITQ3UHsGQWF2IcyF8evP9U
         6ntq2Ty6nBmBBnGgAg0HW0r71MjoCEa1xfBR+3pGuRNOJKMcdvHyj4mz/AI2zzRX+ZF0
         /mWQNxwnVknGxmajwbb9m0miCCc6FzWvjrWWgjuFSse7yTXVJyfxbjO59Pl/5RNtZi4p
         K1R9dxkpdviNVqBAOf+SoqlxwYnfpx1NPeffNQ5QWTbxyTpNqeErAL41d6oDPuavzJg/
         1wWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lp811Xhpus0vpIQXccI+kJ+HvSPttYJotJ9EUMN/yrw=;
        b=a9GlMTXo1SuuSKde7yDjgOxk7RjHFs4BZcG6u7yXLDdLQd3Lv5zFlclFpef3y84lR2
         DQp7fOPZZFvWwD15s4OTEcf1s0p0hK1rhsQUlOUKPnJNYuEIFFj5LWYCRCcoMmcDBCSy
         4WCSFUV9LSoSAIPQ/TXdqhEvKp29E+g+Zbs/1AYt26lPcxcL9Hqhqwu0cC6k3z2gMrXG
         GgDpc+9a/Zpa2s78Sl3RAQBJPGc1QLqOuRmlW6zZm/hhjUBQc7nlptV9YAkrecOWifsB
         mM+AhO+ULtplXOnhJ0JcJSituec7ybd4E0vnZsAlvDxrgyXkBFqdRp9d0hKTnG+UNW+3
         G2tQ==
X-Gm-Message-State: AOAM5304GIz3bABt4LH5cH8IOcgzAgcWBYoPCkzUHV5piJEXkqw5SfYV
        tnVyQ8S885Mkzo1ClImWRv4=
X-Google-Smtp-Source: ABdhPJwZ9o/K1MH056I15ectFk9vli2S83mpwXNB2GDgVprMVMM4MMMMG+IRvpG23MiAvMviLaC78w==
X-Received: by 2002:a17:90b:4a02:b0:1c6:c1a1:d65c with SMTP id kk2-20020a17090b4a0200b001c6c1a1d65cmr30457448pjb.97.1649570427505;
        Sat, 09 Apr 2022 23:00:27 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id rm5-20020a17090b3ec500b001c7559762e9sm16328046pjb.20.2022.04.09.23.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 23:00:26 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Remove redundant assignment to meta.seq in __task_seq_show()
Date:   Sun, 10 Apr 2022 14:00:19 +0800
Message-Id: <20220410060020.307283-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The seq argument is assigned to meta.seq twice, the second one is
redundant, remove it.

This patch also removes a redundant space in bpf_iter_link_attach().

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/bpf_iter.c  | 2 +-
 kernel/bpf/task_iter.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index dea920b3b840..d5d96ceca105 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -545,7 +545,7 @@ int bpf_iter_link_attach(const union bpf_attr *attr, bpfptr_t uattr,
 	bpf_link_init(&link->link, BPF_LINK_TYPE_ITER, &bpf_iter_link_lops, prog);
 	link->tinfo = tinfo;
 
-	err  = bpf_link_prime(&link->link, &link_primer);
+	err = bpf_link_prime(&link->link, &link_primer);
 	if (err) {
 		kfree(link);
 		return err;
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index d94696198ef8..8c921799def4 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -99,7 +99,6 @@ static int __task_seq_show(struct seq_file *seq, struct task_struct *task,
 	if (!prog)
 		return 0;
 
-	meta.seq = seq;
 	ctx.meta = &meta;
 	ctx.task = task;
 	return bpf_iter_run_prog(prog, &ctx);
-- 
2.35.1

