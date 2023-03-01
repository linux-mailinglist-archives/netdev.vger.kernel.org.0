Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D898E6A76D5
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCAWgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCAWgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:36:09 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EB453296;
        Wed,  1 Mar 2023 14:36:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y2so14912770pjg.3;
        Wed, 01 Mar 2023 14:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4UC1GDqtkqBRrI9hPPA1EWEkH/ZzM1z65eECezB0fnQ=;
        b=f5Y/5+DZE9k3uZBcpBhn2qYLa7jcGDw4rEmzEKhTP0MYA66PJky7DCpRtPskqJd0li
         BDytu7dNy10UGxJRoQ2ESVmKAegGvBiyq2X9FH0fIEY3da3NT6+SBAxk+Fk6qXfQTgk7
         AxWkiRyuu4UKMzjSYN/rGanAlph0Y/VR35wEZnBONyAaZGh522lXLUbWejrxSnq8uuqB
         LVAamvfSAgSOwCEhg19UKje/M5Z2/u81ahz5ANizg0yCXZxWrCC4NQpEvMWrlCTQv5u4
         9IOWW1MlY8RRFuXu236rHxNwGHAfCLsYk/rA8WZ6QGkGJ3rFd3d2XpXwT6H24xCgP9UU
         QZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4UC1GDqtkqBRrI9hPPA1EWEkH/ZzM1z65eECezB0fnQ=;
        b=AdWWYghx35VPlV0CM9AAmVWZknRhPoE7IiIhiuYlle06SyOiiWPHOXJ3h0QtJPqLWK
         7cl12WNquqSxDUM2b4A42unV0OnIgXQ50ktyHMx/OACtk11US60HXUl0bbI42eWXXO1X
         vYl/bYMr05Eza5nDFuzgil2vYA+rHivPZ1SM2vEsavMPkSAa3WdV0CK9fUOyzbAiLBVb
         TdhH7xB62rLNlHpXcQbXifdiTAhT6gbXUc2145ZyW5vCUTf23sB6CV1nJuMbz8clwvLi
         +8i81+tD6GkBDZH9WLAvTNZJz8E5DcC/sqlscl8W06JKR8zxHA8nRNKcN/Dv4BiVh9Y5
         Ffxg==
X-Gm-Message-State: AO0yUKUt0IMjgJMmxRP4EOWpzM9XleI2+HcKAGQ5cHUtMbnn2A+WVmeG
        IhZtwXGt7E+OrmTJUkIFIi4=
X-Google-Smtp-Source: AK7set+KNtQ/EFfwKQtj+R63rMS1IKi46lH6diYMz6SONIl9V+jFfCTkgekprPHmYEiSV6XNqZkDaQ==
X-Received: by 2002:a17:902:c948:b0:19c:dd49:9bf8 with SMTP id i8-20020a170902c94800b0019cdd499bf8mr19659913pla.28.1677710167532;
        Wed, 01 Mar 2023 14:36:07 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:2f7d])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ee8200b0019926c7757asm8877352pld.289.2023.03.01.14.36.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Mar 2023 14:36:07 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 bpf-next 2/6] bpf: Mark cgroups and dfl_cgrp fields as trusted.
Date:   Wed,  1 Mar 2023 14:35:51 -0800
Message-Id: <20230301223555.84824-3-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
References: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
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
2.39.2

