Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D560920EA46
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgF3Aep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgF3Aeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:34:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474F1C061755;
        Mon, 29 Jun 2020 17:34:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h22so8734352pjf.1;
        Mon, 29 Jun 2020 17:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eA4QmThlJ/mGIfQJ5rVkpjl5d9oxQHhbZFBdVCgYc6c=;
        b=ZCqfp7m+wUg3wE57OtZMQmyxGEKOmn5e8RsfRz+w3HUMgKWOdmx6CoEaoVtBgza4rt
         LGksiuRw1NYebIFg7B/qhTP2TocSG6WJBKJ6fDeIZLqUPbEb8mDPQehEp0FBCO4IEq9c
         ajRIb+sPkLAUJIw6S4HTXyjfewdm//vJ3AdedEAUOMOkHGol7GjbsZQTmi9bJyMEysAs
         vQ47soYJocdYG4mNfcPY0c2+o0E9niSW6Wue5S4qUM5/VRAfHwDz0f++G2MsGEwCv+/a
         Qstbw1T6lmd+z4X0Z7HeokXhNFD2GAlRedsBa/w7goWTsPa2Fmf6/nJqWUUmRE92lryh
         j8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eA4QmThlJ/mGIfQJ5rVkpjl5d9oxQHhbZFBdVCgYc6c=;
        b=QaGpVZfMIKeXscc/CWjuS6Rj0K+ubGyZCk86HwyWtn6trSo1sO2YpTebDU3E3wpOc+
         Mj0PwBPg7k6WtLwXgZI3L8tDSBXt2C3cHSaW0sHqXWtxrZaXVwWc8WZAS6vGRpv/LOYN
         pF/MKfoV40eKgaxXmhg+GupjZdqUmwLL7EBpKpjELvzl4n2Hj9BKFI/IZ9uFEGvQH//i
         d7Zefnb3TaKoC3gmpwu5jElW+3L2XU9BEjHNyBHSAoCP8D1WaHI5h5ShJhuOacvPiF5Q
         ysZSG6jCd9R1EbyCZExXbPX20tKSrom5BYVgUoCPad805Foy3zo0BkbdhJkXVu2DeakJ
         cJNg==
X-Gm-Message-State: AOAM5309pQZYGHVY+HGfEmZZ28mzAukWjtiumOfsaLQiK0JR2KWBNOX2
        MD0QU3SY0RYeFaIHYtNlwus=
X-Google-Smtp-Source: ABdhPJztQZEWHGRDN4TSD+CkQcbUSyTZMb8UbE77A3QAFBzAEsyUTMv/PS9sNp20QF1inyftw7N/jA==
X-Received: by 2002:a17:90a:1b28:: with SMTP id q37mr3764936pjq.45.1593477283784;
        Mon, 29 Jun 2020 17:34:43 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id b4sm700658pfo.137.2020.06.29.17.34.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 17:34:43 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 0/5] bpf: Introduce minimal support for sleepable progs
Date:   Mon, 29 Jun 2020 17:34:36 -0700
Message-Id: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v3->v4:
- fixed synchronize_rcu_tasks_trace() usage and accelerated with synchronize_rcu_mult().
- removed redundant synchronize_rcu(). Otherwise it won't be clear why
  synchronize_rcu_tasks_trace() is not needed in free_map callbacks.
- improved test coverage.

v2->v3:
- switched to rcu_trace
- added bpf_copy_from_user

Here is 'perf report' differences:
sleepable with SRCU:
   3.86%  bench     [k] __srcu_read_unlock
   3.22%  bench     [k] __srcu_read_lock
   0.92%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
   0.50%  bench     [k] bpf_trampoline_10297
   0.26%  bench     [k] __bpf_prog_exit_sleepable
   0.21%  bench     [k] __bpf_prog_enter_sleepable

sleepable with RCU_TRACE:
   0.79%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
   0.72%  bench     [k] bpf_trampoline_10381
   0.31%  bench     [k] __bpf_prog_exit_sleepable
   0.29%  bench     [k] __bpf_prog_enter_sleepable

non-sleepable with RCU:
   0.88%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry
   0.84%  bench     [k] bpf_trampoline_10297
   0.13%  bench     [k] __bpf_prog_enter
   0.12%  bench     [k] __bpf_prog_exit

Happy to confirm that rcu_trace overhead is negligible.

v1->v2:
- split fmod_ret fix into separate patch
- added blacklist

v1:
This patch set introduces the minimal viable support for sleepable bpf programs.
In this patch only fentry/fexit/fmod_ret and lsm progs can be sleepable.
Only array and pre-allocated hash and lru maps allowed.

Alexei Starovoitov (5):
  bpf: Remove redundant synchronize_rcu.
  bpf: Introduce sleepable BPF programs
  bpf: Add bpf_copy_from_user() helper.
  libbpf: support sleepable progs
  selftests/bpf: Add sleepable tests

 arch/x86/net/bpf_jit_comp.c                   | 32 ++++++----
 include/linux/bpf.h                           |  4 ++
 include/uapi/linux/bpf.h                      | 19 +++++-
 init/Kconfig                                  |  1 +
 kernel/bpf/arraymap.c                         | 10 +--
 kernel/bpf/hashtab.c                          | 20 +++---
 kernel/bpf/helpers.c                          | 22 +++++++
 kernel/bpf/lpm_trie.c                         |  5 --
 kernel/bpf/queue_stack_maps.c                 |  7 --
 kernel/bpf/reuseport_array.c                  |  2 -
 kernel/bpf/ringbuf.c                          |  7 --
 kernel/bpf/stackmap.c                         |  3 -
 kernel/bpf/syscall.c                          | 13 +++-
 kernel/bpf/trampoline.c                       | 33 +++++++++-
 kernel/bpf/verifier.c                         | 62 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |  2 +
 tools/include/uapi/linux/bpf.h                | 19 +++++-
 tools/lib/bpf/libbpf.c                        | 25 +++++++-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 +++++
 .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
 tools/testing/selftests/bpf/progs/lsm.c       | 64 ++++++++++++++++++-
 .../selftests/bpf/progs/trigger_bench.c       |  7 ++
 23 files changed, 318 insertions(+), 67 deletions(-)

-- 
2.23.0

