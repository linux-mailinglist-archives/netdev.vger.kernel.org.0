Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF84DE9AE
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiCSRcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243685AbiCSRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3237945AC7;
        Sat, 19 Mar 2022 10:30:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m22so9903224pja.0;
        Sat, 19 Mar 2022 10:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIBKd9AzBGUka0TmRgPVm4pjAnkawvLN160pSTlVjSE=;
        b=H7xrz3r2dp+CX42pfgNSHej70Eh5wyqJphEaiZENqivoqpjc79U2gclxAcbGZjAIuv
         5Y8O43UrciWrCCUOt9KdHlNRyc7rN93C35SjixmxJkeZTjQSuk37xYncjmBD8p5AonVb
         W0iC2+dkxSjHqTAz/6HcOLTUKErUS5ywoGoGpwT22lpNjCsG2hGxXE8kFtyvbPTaKBcd
         SRhUek8dmnMSH7uDxqj7bxvX9gQzD/xnzZUPZ3K+XxOE9tpG6YSujT3IzuSFX2uLlf1D
         vPfkW8wFitJHolvspFnk7phCrR7Viy+p3PF3JfEdeU8XP4AVlet8rQ7/Y4GOrOdJm0Iq
         QMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIBKd9AzBGUka0TmRgPVm4pjAnkawvLN160pSTlVjSE=;
        b=PvBrBkPeeq6JkF+RiCZekGVP5s3fMmro2cqJZl8F0oF19Av3UfgX29qxsfLwvE4LHs
         nNZyzR/tl/dMk/UYz0fWh0WmYNGg9pqreJdac5TDJAQ6ABUv9stWknYmbBCaj8ZkqD+9
         XX8BDgPCt5fBwxkyodcvcRYDFyXvVzyOrEAcQXyeao982bDKPKL6IXoo81uxb+bvySBC
         6XcJGeJeL3VaBeeMSqder2IRzrbv/NK4ejjPt0VlJ/jUlbzSV/K4opvIHxlVh+DchAxc
         fmbCq+/wYUqDBh2NkuhJ9A3bx02+/HADszL/uT7IH859EdAG11m6tmDp4TT6TfJ+wICk
         CAUg==
X-Gm-Message-State: AOAM532sddZ0M4A6CFZb7eYx8M8ITY/Ckf7fQJ65EDsh4WNXMANN8VqO
        70z52UHQqo4/0sWN4zy7jsQ=
X-Google-Smtp-Source: ABdhPJy073V4vKdfGyENPJElILxuQy13uwmc0gTYcOqVJ0M4/j1gSgN4unBpWn9RRK1DossTTufgnA==
X-Received: by 2002:a17:903:32c4:b0:151:c6ae:e24b with SMTP id i4-20020a17090332c400b00151c6aee24bmr5195960plr.85.1647711054660;
        Sat, 19 Mar 2022 10:30:54 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:54 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 11/14] bpf: Set __GFP_ACCOUNT at the callsite of bpf_prog_alloc
Date:   Sat, 19 Mar 2022 17:30:33 +0000
Message-Id: <20220319173036.23352-12-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
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

Instead of setting __GFP_ACCOUNT inside bpf_prog_alloc(), let's set it
at the callsite. No functional change.

It is a preparation for followup patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/core.c     | 8 ++++----
 kernel/bpf/syscall.c  | 2 +-
 kernel/bpf/verifier.c | 2 +-
 net/core/filter.c     | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 1324f9523e7c..0f68b8203c18 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -80,7 +80,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
 
 struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags = __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog_aux *aux;
 	struct bpf_prog *fp;
 
@@ -89,12 +89,12 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	if (fp == NULL)
 		return NULL;
 
-	aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
+	aux = kzalloc(sizeof(*aux), gfp_extra_flags);
 	if (aux == NULL) {
 		vfree(fp);
 		return NULL;
 	}
-	fp->active = alloc_percpu_gfp(int, GFP_KERNEL_ACCOUNT | gfp_extra_flags);
+	fp->active = alloc_percpu_gfp(int, gfp_flags);
 	if (!fp->active) {
 		vfree(fp);
 		kfree(aux);
@@ -116,7 +116,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 
 struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags = __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *prog;
 	int cpu;
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ecc5de216f50..fdfbb4d0d5e0 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2305,7 +2305,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	}
 
 	/* plain bpf_prog allocation */
-	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER);
+	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER | __GFP_ACCOUNT);
 	if (!prog) {
 		if (dst_prog)
 			bpf_prog_put(dst_prog);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0287176bfe9a..fe989cc08391 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12991,7 +12991,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		 * subprogs don't have IDs and not reachable via prog_get_next_id
 		 * func[i]->stats will never be accessed and stays NULL
 		 */
-		func[i] = bpf_prog_alloc_no_stats(bpf_prog_size(len), GFP_USER);
+		func[i] = bpf_prog_alloc_no_stats(bpf_prog_size(len), GFP_USER | __GFP_ACCOUNT);
 		if (!func[i])
 			goto out_free;
 		memcpy(func[i]->insnsi, &prog->insnsi[subprog_start],
diff --git a/net/core/filter.c b/net/core/filter.c
index 03655f2074ae..6466a1e0ed4d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1363,7 +1363,7 @@ int bpf_prog_create(struct bpf_prog **pfp, struct sock_fprog_kern *fprog)
 	if (!bpf_check_basics_ok(fprog->filter, fprog->len))
 		return -EINVAL;
 
-	fp = bpf_prog_alloc(bpf_prog_size(fprog->len), 0);
+	fp = bpf_prog_alloc(bpf_prog_size(fprog->len), __GFP_ACCOUNT);
 	if (!fp)
 		return -ENOMEM;
 
@@ -1410,7 +1410,7 @@ int bpf_prog_create_from_user(struct bpf_prog **pfp, struct sock_fprog *fprog,
 	if (!bpf_check_basics_ok(fprog->filter, fprog->len))
 		return -EINVAL;
 
-	fp = bpf_prog_alloc(bpf_prog_size(fprog->len), 0);
+	fp = bpf_prog_alloc(bpf_prog_size(fprog->len), __GFP_ACCOUNT);
 	if (!fp)
 		return -ENOMEM;
 
@@ -1488,7 +1488,7 @@ struct bpf_prog *__get_filter(struct sock_fprog *fprog, struct sock *sk)
 	if (!bpf_check_basics_ok(fprog->filter, fprog->len))
 		return ERR_PTR(-EINVAL);
 
-	prog = bpf_prog_alloc(bpf_prog_size(fprog->len), 0);
+	prog = bpf_prog_alloc(bpf_prog_size(fprog->len), __GFP_ACCOUNT);
 	if (!prog)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.17.1

