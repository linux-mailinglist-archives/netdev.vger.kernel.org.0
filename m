Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F006C6A5229
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjB1ECE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjB1EBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:01:34 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187961D939;
        Mon, 27 Feb 2023 20:01:34 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d10so4843481pgt.12;
        Mon, 27 Feb 2023 20:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xfIRyGkmgsSIXqW49jVysIDhg/kNcphUShFloi/6CTE=;
        b=PrF3pC2f7aWFl3e/qwvdaJGi61TIsJdNrfLRrSknqWMpwLydCcvpSiw979KxFakipN
         uIRWTQlLaosv9z+i7pwpr6fBaoL/3do86lYa3hoAUihAT9mUkUhGVL/3jW5jVAGkvr3Z
         iRGesTIFKnd0J3MUuIL5HkpYm88pcUujWG33rBlSvWb7SEArR6af/amv0KY2W0VxnYET
         0EmrrGzCU0ye97MmplniNbwG7V8dmXO+wgOhtwfnmptNyxKJLXgQGEWTqd3mlbdJBKqf
         qiAE9Wnp+HVjLn4FKUes237jT0O+Sb1KZrpe6xi8IkQrDutfqo8cO8gm3j+ag5QbJDAk
         q4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xfIRyGkmgsSIXqW49jVysIDhg/kNcphUShFloi/6CTE=;
        b=wt1wBbaIvRoFj0v/5QWCPZVPlrTI8JM+Lx79n7SgJ0kwQvvQWS07QQxESEdkZ1nNxf
         mRuWZbFhpdwgpdGlNEIsOXb9/fhglTOBdwHU5WJ6bEDN2/eiJXngj8Rf96vvvQLh5yOT
         mhQ4RQuarrbGLS+xipEyePjVWobvb9FFKGEdeFd7lcKNY6n2QfsLSPK1qxqOT7QWBh1U
         CnDTy9Nj/rGWuO+uwz3zw0QdNNpj2OJKs+qrYTQTNGVMabC2bqPMbm25KEuzNXuaUA41
         rGknFMZF3Vhs32llUTieb/XKWS8kFc3PRSLnmbIbhIsCzZhX6Sn187fXRQxEb1mvdKF9
         yZfA==
X-Gm-Message-State: AO0yUKXsIUS9a7NHJFxAGX+okoG8wlE+yMFUuM/T0V2X/F8shMKa7Xhz
        rsCwcdN11Fz4sKnbE4ih78g=
X-Google-Smtp-Source: AK7set8Z0Fr9C3HxQzjh25uGBdYNkOsPCzSklJQ8MAniTqy0pe+uK6cOORk3eVm7tVgYEIO00ZEjRQ==
X-Received: by 2002:a62:5281:0:b0:5a8:4bfb:6bee with SMTP id g123-20020a625281000000b005a84bfb6beemr1135391pfb.9.1677556893515;
        Mon, 27 Feb 2023 20:01:33 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:6245])
        by smtp.gmail.com with ESMTPSA id t6-20020aa79386000000b005907716bf8bsm4974917pfe.60.2023.02.27.20.01.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Feb 2023 20:01:33 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v3 bpf-next 2/5] bpf: Mark cgroups and dfl_cgrp fields as trusted.
Date:   Mon, 27 Feb 2023 20:01:18 -0800
Message-Id: <20230228040121.94253-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
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
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5cb8b623f639..e4234266e76d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5011,6 +5011,10 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
 
 BTF_TYPE_SAFE_NESTED(struct task_struct) {
 	const cpumask_t *cpus_ptr;
+	struct css_set *cgroups;
+};
+BTF_TYPE_SAFE_NESTED(struct css_set) {
+	struct cgroup *dfl_cgrp;
 };
 
 static bool nested_ptr_is_trusted(struct bpf_verifier_env *env,
@@ -5022,6 +5026,7 @@ static bool nested_ptr_is_trusted(struct bpf_verifier_env *env,
 		return false;
 
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_NESTED(struct task_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_NESTED(struct css_set));
 
 	return btf_nested_type_is_trusted(&env->log, reg, off);
 }
-- 
2.30.2

