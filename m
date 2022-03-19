Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1324DE9A3
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243753AbiCSRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243686AbiCSRcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:21 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEFB46141;
        Sat, 19 Mar 2022 10:30:56 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id t22so9504713plo.0;
        Sat, 19 Mar 2022 10:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UnzpRSS/vLYZGmFXrB6nYaZPHuwQlW9x/vmkhMBVTEQ=;
        b=RsczAP8C3Ig4HKDvm6X86NOreFdEhMYHBpRBoeKF/94wlV9+u9Egr4V/TBqS1FX8Ue
         lFFPQpIMJS4G5lpfiEw4KvUr8o5fqRs/XJsZMcZPpxldyQLPMhxPur699k75MNBgyaQ5
         4dS5qDSS0tsiNXWZjsakb9ETsLt+JEePQaPATpMIr3Z/+Z86EFP3EGI9zrujz75CkY4V
         ahN24nCYzn1MoHhVLuq5xcKyvqaej5JUbg49KNmekfTtZuNF73XEQW4iYhSAIFbHtXCu
         LVoMb7GX+KBO8hWssyjZ8SSU8gCSwnDRoVlaBZRSYuVFbQtS176El/2RnVtm0bGcXaqC
         U0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UnzpRSS/vLYZGmFXrB6nYaZPHuwQlW9x/vmkhMBVTEQ=;
        b=xLhZ7OQ4E6dLm+gjHuIVZ2MS49DrlOAVmjIgXa1A96EXuTQMTvebZH4s0481xqTIZu
         Or9v6PerpPiTa4ZBYDutUrTG+zoflmqi9+KpILbleBtqfy52Q8cZrvAZHsfZvUn7x9ef
         MvIjltl/m2RaNV/Kcy33DtLgxe2UPR0D5FIW0Nol8OB5LmroNVITfNNaVu4jZQw/UnOe
         DJe4ng0XU3pSns8S3Bmy8EV3eFYKSaAm6YY0+xNvYuUSH7kqDazdTLP21gJ4EyOFYHTZ
         KSjUm+AJw2kCDqVldmT2MAL+djaViqmhuCeTVL/6meo94dHmTaWpWhqTGosOsdzb8HX/
         mhKA==
X-Gm-Message-State: AOAM532H6H9vW6Ab0EturzBedYh3O25Z0cr2tQpSE8ejF5BqcOciPdFI
        9+DBsIQiUBEc+xuMkoYpFVQ=
X-Google-Smtp-Source: ABdhPJzDsThUZW6p6KlCe6SKrOblLrhRM+o0ogBcfGoBqkKzlliLEkvGKbHYLlwwOKXRc+RIyMwfZw==
X-Received: by 2002:a17:903:246:b0:153:87f0:a93e with SMTP id j6-20020a170903024600b0015387f0a93emr5130014plh.171.1647711055893;
        Sat, 19 Mar 2022 10:30:55 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:55 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 12/14] bpf: Allow no charge for bpf prog
Date:   Sat, 19 Mar 2022 17:30:34 +0000
Message-Id: <20220319173036.23352-13-laoar.shao@gmail.com>
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

Allow not to charge memory used by bpf progs. This includes the memory
used by bpf progs itself, auxxiliary data, statistics and bpf line info.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/core.c    | 12 ++++++++++--
 kernel/bpf/syscall.c |  6 ++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0f68b8203c18..7aa750e8bd7d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -144,12 +144,17 @@ EXPORT_SYMBOL_GPL(bpf_prog_alloc);
 
 int bpf_prog_alloc_jited_linfo(struct bpf_prog *prog)
 {
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_NOWARN;
+
 	if (!prog->aux->nr_linfo || !prog->jit_requested)
 		return 0;
 
+	if (!prog->aux->no_charge)
+		gfp_flags |= __GFP_ACCOUNT;
+
 	prog->aux->jited_linfo = kvcalloc(prog->aux->nr_linfo,
 					  sizeof(*prog->aux->jited_linfo),
-					  GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
+					  gfp_flags);
 	if (!prog->aux->jited_linfo)
 		return -ENOMEM;
 
@@ -224,7 +229,7 @@ void bpf_prog_fill_jited_linfo(struct bpf_prog *prog,
 struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 				  gfp_t gfp_extra_flags)
 {
-	gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
+	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
 	struct bpf_prog *fp;
 	u32 pages;
 
@@ -233,6 +238,9 @@ struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
 	if (pages <= fp_old->pages)
 		return fp_old;
 
+	if (!fp_old->aux->no_charge)
+		gfp_flags |= __GFP_ACCOUNT;
+
 	fp = __vmalloc(size, gfp_flags);
 	if (fp) {
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index fdfbb4d0d5e0..e386b549fafc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2218,9 +2218,10 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	enum bpf_prog_type type = attr->prog_type;
 	struct bpf_prog *prog, *dst_prog = NULL;
 	struct btf *attach_btf = NULL;
-	int err;
+	gfp_t gfp_flags = GFP_USER;
 	char license[128];
 	bool is_gpl;
+	int err;
 
 	if (CHECK_ATTR(BPF_PROG_LOAD))
 		return -EINVAL;
@@ -2305,7 +2306,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	}
 
 	/* plain bpf_prog allocation */
-	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt), GFP_USER | __GFP_ACCOUNT);
+	prog = bpf_prog_alloc(bpf_prog_size(attr->insn_cnt),
+				prog_flags_no_charge(gfp_flags, attr));
 	if (!prog) {
 		if (dst_prog)
 			bpf_prog_put(dst_prog);
-- 
2.17.1

