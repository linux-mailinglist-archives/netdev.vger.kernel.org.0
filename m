Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52D46BBFE3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCOWg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjCOWgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:36:22 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337041ACFC;
        Wed, 15 Mar 2023 15:36:21 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id ja10so12030677plb.5;
        Wed, 15 Mar 2023 15:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678919780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMJOIKge1TNhWbJLbClPoucTcHqzq/T/IvQd51ijcoU=;
        b=J1JEvl4Y5znFBEkdgVQu+oLdwBCIK6uyLbt4IR4qnV9DbidY8uWSx+lpRdnWTto05V
         ZGvuKtY6pvmulkSWJJ1Yc2NBEhzDTmenB3gEXuUlX0WWrD9D6FBqHKWBUoP75Hyn/Dd0
         jYx9C9ld7aYKB+BclWjPQYZc6uCCDD/77R62giMFnUcQOcmMcCyUpBceEdgcDr1yNLY3
         qooFW3EFc8WUZu2LXYMwmHT2jffFFhGixzLySXABDsNYtqw6ejNvkeTRBvjrgT+yygyG
         bZEASVWbHJ5brDmeLSPhXW1IRWfkAbjxg65eyR2/KXnXbQ182s9ZeatQ7xXved/QpWWc
         NuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678919780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zMJOIKge1TNhWbJLbClPoucTcHqzq/T/IvQd51ijcoU=;
        b=MW+U70MM2Ed45WEExjarUIJj6CK7zjlTFVwf8UefMv+cbwU3eN0ErnYrryoQz/0NRw
         4mJiaN7tRNpag6ek7bU2K1uuzaTy4Kyuya9mPtEEFgFvYV/hsNGQogCEIa4Ohc/b4jzI
         vxdWYeLow6mtxLlLqq+S5BMMA0B6lzSbeMbr/8yRvPR5h++kgpeUjyaT6eGhmdfkvvKo
         hwFmqieoFBI2f/lt1ybjP3ejxG9TRWTq+Yi18o4h1H+nUR4FrSmunA7JCGWD4H1llWkT
         i+6xiXfWLh+PHiHflKzmKjhe/De+ImuwR2LEd2KQ8AxU/tGVzKh4AjFHA4PoPP1kWDLB
         r7kA==
X-Gm-Message-State: AO0yUKU1cRnzLDH/GqrMcKZRXOtXSLTDAewXhVHhawcJOrwwygIv3E95
        PpCtyen5VYU8H5NBgCNipJU=
X-Google-Smtp-Source: AK7set+rlBr5yqQVnIIOS7FHB9vkF6sZoe/yJJd0Gzdqw4rzuIkSzw3SIA7ubTKdbx1X6oK5DoJ2QQ==
X-Received: by 2002:a05:6a20:8e06:b0:d6:8c70:85ce with SMTP id y6-20020a056a208e0600b000d68c7085cemr1481621pzj.54.1678919780425;
        Wed, 15 Mar 2023 15:36:20 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:2bcf])
        by smtp.gmail.com with ESMTPSA id s5-20020aa78285000000b005d296facfa3sm4008964pfm.36.2023.03.15.15.36.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Mar 2023 15:36:20 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add test for bpf_kfunc_exists().
Date:   Wed, 15 Mar 2023 15:36:07 -0700
Message-Id: <20230315223607.50803-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
References: <20230315223607.50803-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add load and run time test for bpf_kfunc_exists() and check that the verifier
performs dead code elimination for non-existing kfunc.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/progs/task_kfunc_success.c       | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/task_kfunc_success.c b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
index 4f61596b0242..c0a7774e0c79 100644
--- a/tools/testing/selftests/bpf/progs/task_kfunc_success.c
+++ b/tools/testing/selftests/bpf/progs/task_kfunc_success.c
@@ -17,6 +17,8 @@ int err, pid;
  *         TP_PROTO(struct task_struct *p, u64 clone_flags)
  */
 
+void invalid_kfunc(void) __ksym __weak;
+
 static bool is_test_kfunc_task(void)
 {
 	int cur_pid = bpf_get_current_pid_tgid() >> 32;
@@ -26,7 +28,17 @@ static bool is_test_kfunc_task(void)
 
 static int test_acquire_release(struct task_struct *task)
 {
-	struct task_struct *acquired;
+	struct task_struct *acquired = NULL;
+
+	if (!bpf_kfunc_exists(bpf_task_acquire)) {
+		err = 3;
+		return 0;
+	}
+	if (bpf_kfunc_exists(invalid_kfunc)) {
+		/* the verifier's dead code elimination should remove this */
+		err = 4;
+		asm volatile ("goto -1"); /* for (;;); */
+	}
 
 	acquired = bpf_task_acquire(task);
 	bpf_task_release(acquired);
-- 
2.34.1

