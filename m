Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31626A9017
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 05:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCCEO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 23:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCCEOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 23:14:53 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20B31024A;
        Thu,  2 Mar 2023 20:14:50 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id bo22so1278130pjb.4;
        Thu, 02 Mar 2023 20:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VATeVheHroYF12crnC8VGIEk8uOK4OCgYVLD5dGfgzA=;
        b=U4mmEmmGDx6Oo2v59H+3ziCrkoXAmM5DtWMxkfr795TwPSWFWNseV0pXQWH1aGJkk4
         FbzQFRrr3vk9CYv1fHv5Yy2dF7rdFpZf1hQtLmaIcnyW5nVcK9NR7z15CiQXA3Hx/NjT
         9R6Dvu0oYFF3ML+ooM7XRlw2EVTY3QX4Ex7VllQH9vgs1px9dVGy26JDy9Djgj0tASN7
         zGNBRGhiSDv5o5JlH78Tk+jLHJOilyYDHiwUaofqNIssy4KXjRbzvEljlm3OAhTrFodO
         /w6Vb7M1RKMYmItVuAqEst3jqN3+5Opb9iVCkM1VXZ6EWqo4Sc1rqMFkeR0EIPxYgX/b
         qQDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VATeVheHroYF12crnC8VGIEk8uOK4OCgYVLD5dGfgzA=;
        b=4X7RHIJMBwXKd+nH/x/RaluZhZ/ONy3B3AOq8nNo9L62Xjypj9qsSW6Nknso7ajLwt
         krcSnRBfmRksdS0GRHf0Rz1B0TUovrDI/mVWITe3qA5FDBBz9lMaoEJwfdmttjI0GPc4
         ErONP9vOweZJ5x3Mhu8u3uHqbWDCQwn7+ucpQSb9qdQKKEkEjAb0tX5354anoLb8r/7s
         K/XFM0MYGnmdoZelZCoeAUyZJ+w7n/itMXYkPNgi74F8MY8Wk6MGrtgj6Q+7XLGRGUCl
         eyTveo18yBVx0mdF6dC9oZKBQLZZKFOdyzxHMg0agVxvKJ1jCBcRv4J5Du6bE5yVOgff
         +r3w==
X-Gm-Message-State: AO0yUKXTyr2uEDmLzL7tWUwc7/0wElqITnrXX3xpcN9oey5DNTcgnXN4
        SopZ+oN93rWHAwjXw3leVrw=
X-Google-Smtp-Source: AK7set9g0ozcBY81cLqOCow+CxQKkTpVFiZ0nCkVYKsrc8Aoykci3iLZNw43PyRUkFL2zdW5QD7wHA==
X-Received: by 2002:a17:90b:3a8d:b0:235:53e5:8597 with SMTP id om13-20020a17090b3a8d00b0023553e58597mr204588pjb.34.1677816890142;
        Thu, 02 Mar 2023 20:14:50 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:5ad7])
        by smtp.gmail.com with ESMTPSA id mi18-20020a17090b4b5200b002369a14d6b1sm2336113pjb.31.2023.03.02.20.14.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Mar 2023 20:14:49 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 bpf-next 0/6] bpf: Introduce kptr RCU.
Date:   Thu,  2 Mar 2023 20:14:40 -0800
Message-Id: <20230303041446.3630-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

v4->v5:
fix typos, add acks.

v3->v4:
- patch 3 got much cleaner after BPF_KPTR_RCU was removed as suggested by David. 

- make KF_RCU stronger and require that bpf program checks for NULL
before passing such pointers into kfunc. The prog has to do that anyway
to access fields and it aligns with BTF_TYPE_SAFE_RCU allowlist.

- New patch 6: refactor RCU enforcement in the verifier.
The patches 2,3,6 are part of one feature.
The 2 and 3 alone are incomplete, since RCU pointers are barely useful
without bpf_rcu_read_lock/unlock in GCC compiled kernel.
Even if GCC lands support for btf_type_tag today it will take time
to mandate that version for kernel builds. Hence go with allow list
approach. See patch 6 for details.
This allows to start strict enforcement of TRUSTED | UNTRUSTED
in one part of PTR_TO_BTF_ID accesses.
One step closer to KF_TRUSTED_ARGS by default.

v2->v3:
- Instead of requiring bpf progs to tag fields with __kptr_rcu
teach the verifier to infer RCU properties based on the type.
BPF_KPTR_RCU becomes kernel internal type of struct btf_field.
- Add patch 2 to tag cgroups and dfl_cgrp as trusted.
That bug was spotted by BPF CI on clang compiler kernels,
since patch 3 is doing:
static bool in_rcu_cs(struct bpf_verifier_env *env)
{
        return env->cur_state->active_rcu_lock || !env->prog->aux->sleepable;
}
which makes all non-sleepable programs behave like they have implicit
rcu_read_lock around them. Which is the case in practice.
It was fine on gcc compiled kernels where task->cgroup deference was producing
PTR_TO_BTF_ID, but on clang compiled kernels task->cgroup deference was
producing PTR_TO_BTF_ID | MEM_RCU | MAYBE_NULL, which is more correct,
but selftests were failing. Patch 2 fixes this discrepancy.
With few more patches like patch 2 we can make KF_TRUSTED_ARGS default
for kfuncs and helpers.
- Add comment in selftest patch 5 that it's verifier only check.

v1->v2:
Instead of agressively allow dereferenced kptr_rcu pointers into KF_TRUSTED_ARGS
kfuncs only allow them into KF_RCU funcs.
The KF_RCU flag is a weaker version of KF_TRUSTED_ARGS. The kfuncs marked with
KF_RCU expect either PTR_TRUSTED or MEM_RCU arguments. The verifier guarantees
that the objects are valid and there is no use-after-free, but the pointers
maybe NULL and pointee object's reference count could have reached zero, hence
kfuncs must do != NULL check and consider refcnt==0 case when accessing such
arguments.
No changes in patch 1.
Patches 2,3,4 adjusted with above behavior.

v1:
The __kptr_ref turned out to be too limited, since any "trusted" pointer access
requires bpf_kptr_xchg() which is impractical when the same pointer needs
to be dereferenced by multiple cpus.
The __kptr "untrusted" only access isn't very useful in practice.
Rename __kptr to __kptr_untrusted with eventual goal to deprecate it,
and rename __kptr_ref to __kptr, since that looks to be more common use of kptrs.
Introduce __kptr_rcu that can be directly dereferenced and used similar
to native kernel C code.
Once bpf_cpumask and task_struct kfuncs are converted to observe RCU GP
when refcnt goes to zero, both __kptr and __kptr_untrusted can be deprecated
and __kptr_rcu can become the only __kptr tag.

Alexei Starovoitov (6):
  bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
  bpf: Mark cgroups and dfl_cgrp fields as trusted.
  bpf: Introduce kptr_rcu.
  selftests/bpf: Add a test case for kptr_rcu.
  selftests/bpf: Tweak cgroup kfunc test.
  bpf: Refactor RCU enforcement in the verifier.

 Documentation/bpf/bpf_design_QA.rst           |   4 +-
 Documentation/bpf/cpumasks.rst                |   4 +-
 Documentation/bpf/kfuncs.rst                  |  14 +-
 include/linux/bpf.h                           |   2 +-
 include/linux/bpf_verifier.h                  |   1 -
 include/linux/btf.h                           |   2 +-
 kernel/bpf/btf.c                              |  20 +-
 kernel/bpf/cpumask.c                          |  40 ++--
 kernel/bpf/helpers.c                          |   6 +-
 kernel/bpf/verifier.c                         | 213 +++++++++++++-----
 net/bpf/test_run.c                            |   3 +-
 tools/lib/bpf/bpf_helpers.h                   |   2 +-
 .../bpf/prog_tests/cgrp_local_storage.c       |  14 +-
 .../selftests/bpf/prog_tests/rcu_read_lock.c  |  16 +-
 tools/testing/selftests/bpf/progs/cb_refs.c   |   2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h   |   2 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c  |   2 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c  |  12 +-
 .../selftests/bpf/progs/cgrp_ls_sleepable.c   |   4 +-
 .../selftests/bpf/progs/cpumask_common.h      |   2 +-
 .../selftests/bpf/progs/cpumask_failure.c     |   2 +-
 .../selftests/bpf/progs/jit_probe_mem.c       |   2 +-
 tools/testing/selftests/bpf/progs/lru_bug.c   |   2 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  |  16 +-
 .../selftests/bpf/progs/map_kptr_fail.c       |  10 +-
 .../bpf/progs/nested_trust_failure.c          |   2 +-
 .../selftests/bpf/progs/rcu_read_lock.c       |   6 +-
 .../selftests/bpf/progs/task_kfunc_common.h   |   2 +-
 tools/testing/selftests/bpf/test_verifier.c   |  22 +-
 tools/testing/selftests/bpf/verifier/calls.c  |   4 +-
 .../testing/selftests/bpf/verifier/map_kptr.c |   2 +-
 31 files changed, 284 insertions(+), 151 deletions(-)

-- 
2.30.2

