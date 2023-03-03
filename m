Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1A06A901B
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 05:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCCEPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 23:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCCEPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 23:15:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0087418B19;
        Thu,  2 Mar 2023 20:14:58 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l1so1304003pjt.2;
        Thu, 02 Mar 2023 20:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxemTZI1aXgNMHCLf9j7EyPk5tzpuqXbbK2hvTwb8zc=;
        b=Jan0y+B6+awY+xBIoHW1BT7PevAfFik9rvHWTPNuV6fkuA5LrILKGnojM4tBkvDsFo
         6d852b22JrTnqhwRJ74Nnz9oI+wonYYRI3jjGB965InGLjXvrC+iC4OosO9ySD78KVzk
         OsjkD4NDWNVu4adsaN/ci/HouPBUOlrHqr9pGGHPyfEtV6uMKJIf+rhL9nDgpT0+6zbK
         SUwvN9IXRClKdkGNSossW+UdT46y/7jrTeSj1CpEfFGk2XboiUdj/PMdn4v1bhadtNkh
         OFTZHQn8VcWx/kILe2ow33jsSxe0HnvSYVrrSJgVewL/rOyv6B6m1L4L1Qs19y5ZvFR7
         mMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mxemTZI1aXgNMHCLf9j7EyPk5tzpuqXbbK2hvTwb8zc=;
        b=eTMxRRoocSwEDzqgVVHLoZT0S2OcQwseRC9XGJ9EbKFZFXDumhDsOOuPQqGtGN3Yii
         VcG22cwuPce5fUQ0fLj5b971O/Ccj6aLVJFZPGfhEElgfUbbTDlaP0295dCw+2VvU+ir
         rus1ZBJ9P2Cmkq3yUC05znzGdCWb9UgMpr8ajmfxuiPawXGJhGcni3/+e419LHh7tsiO
         syJ0zMHtk97FKTxFUPZjeM0frtXWBTOJ32A3e3RkWsVZXnmSoSHdbKsax16MNgJ/m2lw
         10HnHb6Hises84tSDsbqrFdCcZczriAJDosW4pr1ziItDoKe0dOD3BKgH1vfsUjo26iv
         kG2A==
X-Gm-Message-State: AO0yUKWDHI4CCK+Hr4B0RjXEa+HbWecbfz/a8JpRN5njMh9ALpfgw7po
        WQw9GFfUj1a4Inyo15zt590=
X-Google-Smtp-Source: AK7set/s3YWcAVip3CgqGIMn6CQ8E67Y/IXclT362FhhMSgDzgFmwxJzlsxKMfsnZrYoqjmThBDJDg==
X-Received: by 2002:a05:6a20:5483:b0:cd:47dc:82b5 with SMTP id i3-20020a056a20548300b000cd47dc82b5mr1257504pzk.21.1677816898406;
        Thu, 02 Mar 2023 20:14:58 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:5ad7])
        by smtp.gmail.com with ESMTPSA id c10-20020aa7880a000000b0058d91fb2239sm485486pfo.63.2023.03.02.20.14.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Mar 2023 20:14:57 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 bpf-next 2/6] bpf: Mark cgroups and dfl_cgrp fields as trusted.
Date:   Thu,  2 Mar 2023 20:14:42 -0800
Message-Id: <20230303041446.3630-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
References: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
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

bpf programs sometimes do:
bpf_cgrp_storage_get(&map, task->cgroups->dfl_cgrp, ...);
It is safe to do, because cgroups->dfl_cgrp pointer is set diring init and
never changes. The task->cgroups is also never NULL. It is also set during init
and will change when task switches cgroups. For any trusted task pointer
dereference of cgroups and dfl_cgrp should yield trusted pointers. The verifier
wasn't aware of this. Hence in gcc compiled kernels task->cgroups dereference
was producing PTR_TO_BTF_ID without modifiers while in clang compiled kernels
the verifier recognizes __rcu tag in cgroups field and produces
PTR_TO_BTF_ID | MEM_RCU | MAYBE_NULL.
Tag cgroups and dfl_cgrp as trusted to equalize clang and gcc behavior.
When GCC supports btf_type_tag such tagging will done directly in the type.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: David Vernet <void@manifault.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bf580f246a01..b834f3d2d81a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5046,6 +5046,11 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
 
 BTF_TYPE_SAFE_NESTED(struct task_struct) {
 	const cpumask_t *cpus_ptr;
+	struct css_set __rcu *cgroups;
+};
+
+BTF_TYPE_SAFE_NESTED(struct css_set) {
+	struct cgroup *dfl_cgrp;
 };
 
 static bool nested_ptr_is_trusted(struct bpf_verifier_env *env,
@@ -5057,6 +5062,7 @@ static bool nested_ptr_is_trusted(struct bpf_verifier_env *env,
 		return false;
 
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_NESTED(struct task_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_NESTED(struct css_set));
 
 	return btf_nested_type_is_trusted(&env->log, reg, off);
 }
-- 
2.30.2

