Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3A36A76D1
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjCAWgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCAWgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:36:01 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1FD521FE;
        Wed,  1 Mar 2023 14:36:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso874261pjb.2;
        Wed, 01 Mar 2023 14:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x5nSvN/7pKUlC9+9bAdQKKovuUcJ/9iDGyKpLdAWf7g=;
        b=ap76Gq0awCsdkonDjQmG37KM3mjurJKiPx3NHC54QRZe66zPKfU+MSEv60px0EdEz4
         YCzzGPf13xgdDNjWs7Khf8U9MouP5wuSs4F8D3vkEPOwYE9zQHPKjPWZ+5T2ChImhFSI
         XZ3WWrI/z71nOYLn34gliisapQPxVs9VQRatkOziu65eNdr7FpQTB29m3/6etNmjB4w+
         aLT2dsQEkQ7nbAjYbFUzNgYJ2aPfWhyrxladRcfqtmulb5k/0RQittA3IIGEoupkAcHy
         0D5FEYDYthhg7GpDUmRUbpxlvIwK+x/clUseaXfQX0PvCVeoqFFN4BVYgGLz8fFLilUh
         +tbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5nSvN/7pKUlC9+9bAdQKKovuUcJ/9iDGyKpLdAWf7g=;
        b=2TWpwhTmevFC4/p3SArgCK/EQmhP7qj+IMGwwbsoP/pQOvgPxRR5tpHPPWSGO0cQbM
         WgKZM7bqE68s6XVlVrPfOmpoM6U/2JJB/SuKbIvQ2OwLubk0PwEOyaYbrpbpkdl7d4TR
         9r5LhYyZqJiRMuYP9+sAXxEI2u35AJtgUQTGAyYosZzrRalpZxcyV6jrb2urgmXX/LOq
         BDThgSF5WMUjgyL2iKsUKS2TzFuJFnQgYMasJm5DwC2pcOKgOVtjHgxBSdfPtBpZ9TGP
         PXVb9n8Y3HR69B9tvDiRxjRJr8oRcoGgjpzumEFY/46nQi6GFEQtmorzaYz/emWSWqVh
         pBQQ==
X-Gm-Message-State: AO0yUKWHexjY7N+rsayQPUQUPUjFwhnrU6EFz4NH1duHqNxvgD24hxII
        KeVXdrvuuHsZU7y9Xqlx3RI=
X-Google-Smtp-Source: AK7set/A9//kRm+ec0RYtRx3qPyvD+SC6RTb+BQmoVTxVMETKocP8BLZPopJFEZ1u71UlUHY6jE2QA==
X-Received: by 2002:a17:902:f70f:b0:19c:f8c9:4dff with SMTP id h15-20020a170902f70f00b0019cf8c94dffmr7438356plo.38.1677710159254;
        Wed, 01 Mar 2023 14:35:59 -0800 (PST)
Received: from localhost.localdomain ([2620:10d:c090:400::5:2f7d])
        by smtp.gmail.com with ESMTPSA id i19-20020a170902eb5300b0019ab151eb90sm8916192pli.139.2023.03.01.14.35.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Mar 2023 14:35:58 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 bpf-next 0/6] bpf: Introduce kptr RCU.
Date:   Wed,  1 Mar 2023 14:35:49 -0800
Message-Id: <20230301223555.84824-1-alexei.starovoitov@gmail.com>
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
 kernel/bpf/btf.c                              |  19 +-
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
 31 files changed, 283 insertions(+), 151 deletions(-)

-- 
2.39.2

