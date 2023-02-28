Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E166A5224
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjB1EB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1EB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:01:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342711CF4D;
        Mon, 27 Feb 2023 20:01:26 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x34so8452263pjj.0;
        Mon, 27 Feb 2023 20:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6e5HsptmrnoG9IUBrV+HccdiQmP2DOEZf9qM8mRMgi0=;
        b=Dd3lsSmc19P1JY0QZzUjobeWsj0dbTC9YCOqpXoTzN4rj5mFAlOI+HkohmwCad6UuJ
         fHgpLba78HDZbgfWbUXGpaJit/EyCKBqvulhVpemzxrA2/8aE51Hn1GkhtZ8SABGeeN+
         NrQQ4rO4XdVIu/lDRiEIZF56/SZaBFvKbFyelJZ84jPSeZzs4wLg/6BU/pG+gfnt6LCt
         NXrH3cAJGaaD8CYsgPNqUZ7mJtOK6hTQdpNS2eTaphj+jIQhd2qeYBSw8LsJDAmU2+Pw
         DO6wBAaGG5ZTp0dUtyvBbvpLjAMHscGbW0y3gN0vyjLZmURAe6CZo7LeeU56guTdR88P
         MtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6e5HsptmrnoG9IUBrV+HccdiQmP2DOEZf9qM8mRMgi0=;
        b=Qm7o15pfa8OyMMMmOyrLCK2KZ4Jxq6Hu5T6bqFeilNq6bpL1G2blNHYGrv7p79KaL8
         0DEyJ02eXFHPgp0yIXt6LnsCLe546JNgaDF+I90hMOlbWltTpQuCSaSCr73DX8GtIKMa
         pXyYxv5t680DBBw/NB7iazNXsFZnRx9bDbpfThwypPuh97KTZkbX1aC/+fu/GTqBF+sx
         GAlBJid3zsmf+SLEc2DQkYntpOkDVmI90OR9QxsAsv4VlzGvbc7T0ggjgSop0bCI1+Yk
         LVRngpHuq+AIZ5mNwL8h2Jl99ILGEoYYRc0FJQRxw6TdPds/g7/spMCDw3gcGCbE/pI9
         bRpg==
X-Gm-Message-State: AO0yUKV3sxHSvEJqYdBGPCvuo0rV3oh11WbkrOQohwbjg3m1l7sV9UWg
        CS98LGJmgBrpogIIf/Bs0YM=
X-Google-Smtp-Source: AK7set9xlpL613MRouIm+BtJnWyP5n/aywXWbveeLSTKlrvnFFWWzkpjW5PUXip1/ETyCE5KjZnmnA==
X-Received: by 2002:a17:902:dac8:b0:19c:13d2:44c1 with SMTP id q8-20020a170902dac800b0019c13d244c1mr1607479plx.15.1677556885383;
        Mon, 27 Feb 2023 20:01:25 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:6245])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902fe0c00b001994fc55998sm5319875plj.217.2023.02.27.20.01.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 27 Feb 2023 20:01:24 -0800 (PST)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v3 bpf-next 0/5] bpf: Introduce kptr_rcu.
Date:   Mon, 27 Feb 2023 20:01:16 -0800
Message-Id: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
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

Alexei Starovoitov (5):
  bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
  bpf: Mark cgroups and dfl_cgrp fields as trusted.
  bpf: Introduce kptr_rcu.
  selftests/bpf: Add a test case for kptr_rcu.
  selftests/bpf: Tweak cgroup kfunc test.

 Documentation/bpf/bpf_design_QA.rst           |  4 +-
 Documentation/bpf/cpumasks.rst                |  4 +-
 Documentation/bpf/kfuncs.rst                  | 13 ++++---
 include/linux/bpf.h                           | 15 +++++---
 include/linux/btf.h                           |  2 +-
 kernel/bpf/btf.c                              | 20 +++++++++-
 kernel/bpf/helpers.c                          |  7 ++--
 kernel/bpf/syscall.c                          |  4 ++
 kernel/bpf/verifier.c                         | 38 +++++++++++++------
 net/bpf/test_run.c                            |  3 +-
 tools/lib/bpf/bpf_helpers.h                   |  2 +-
 tools/testing/selftests/bpf/progs/cb_refs.c   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h   |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c  |  2 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c  |  7 +++-
 .../selftests/bpf/progs/cpumask_common.h      |  2 +-
 .../selftests/bpf/progs/jit_probe_mem.c       |  2 +-
 tools/testing/selftests/bpf/progs/lru_bug.c   |  2 +-
 tools/testing/selftests/bpf/progs/map_kptr.c  | 18 ++++++++-
 .../selftests/bpf/progs/map_kptr_fail.c       | 10 ++---
 .../selftests/bpf/progs/task_kfunc_common.h   |  2 +-
 tools/testing/selftests/bpf/test_verifier.c   | 22 +++++------
 tools/testing/selftests/bpf/verifier/calls.c  |  2 +-
 .../testing/selftests/bpf/verifier/map_kptr.c |  2 +-
 24 files changed, 125 insertions(+), 62 deletions(-)

-- 
2.30.2

