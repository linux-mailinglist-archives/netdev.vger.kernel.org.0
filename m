Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3683220ECA2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgF3Eds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgF3Edr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:33:47 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649F4C061755;
        Mon, 29 Jun 2020 21:33:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i4so8948687pjd.0;
        Mon, 29 Jun 2020 21:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YJEZJNUqA4+NkEDurnjYTYANxLG0Cw6C3owASw7BzMk=;
        b=dn7VKS282aYitnl5WXpBMkxo4aWnBRxqrHeAHS5dH9p6attgk7Ats1rbo5J5QY43mn
         aSSer9WxYj5Moqz6bEOP29W56ojLrxJyJs79tWiOd0LMo0BNHAJLNMQKgsSac7kw4d5t
         E7no8pXupLcrONOUs5XiVOXtluCJJDKBSJk38rkTf2AytU5XLHijdAIqWNAQmRtigez/
         n9wIaKGD/gO3GtOEPSJVo55+ijkMRD/D91ZVmiPlHFRQ/V36ZXuvEinkhcTm8EUmDmED
         sH/ciVyAXFNqXbLsQPPloOJnyczbkGPmRc5Gr6J1quVDB3hOigbkR2of+Ro1/X6lk9hP
         DM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YJEZJNUqA4+NkEDurnjYTYANxLG0Cw6C3owASw7BzMk=;
        b=Wll12zbrV9uaH6kQW9sDCsdPejdB1ZKA5ig7Nj2RKQ13zmIYZrhOWCImKM7KD+Ctga
         I3ie/9epH3r2MxuEXvnd3OO41RobNP7XnORK9un+h+qeb0Uw5hF9XWUOSZAYkjC1mSBL
         jUu6YiyAyjavZ9QJ2ZtozTLMrM88tSMglZxmes7hBVcU2IAVvqUJt6eswyq9jc+DlByU
         7bWNaRYBoJRetSFpohLse0nWK5scDTzpAyslsW3ZWXz7Gi1IbLdTiW/Hn+QyMfs+gnZ2
         qZ7iIc1ERRPKLqHhjx1rIAi/N3uwf2VWLPldZCw5ohGPxYU990RPjUWKR7z7fpvTrqc+
         e3hA==
X-Gm-Message-State: AOAM533HvmHwCRh2gaGmbUgYdchopnUO4jSfTXz7QjK3pMzaVbFdkpHR
        GrAkSURTVim9L09N/39UlIQ=
X-Google-Smtp-Source: ABdhPJylDXTpxg7S7jnxT51KNDy3sPjAg9m+A+KvN2OyIUgonciPi1+A3rJRKMMW6LgXEoV0cSfMIA==
X-Received: by 2002:a17:90a:1544:: with SMTP id y4mr20213329pja.130.1593491626794;
        Mon, 29 Jun 2020 21:33:46 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id 21sm1111234pfv.43.2020.06.29.21.33.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 21:33:45 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 0/5] bpf: Introduce minimal support for sleepable progs
Date:   Mon, 29 Jun 2020 21:33:38 -0700
Message-Id: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v4->v5:
- addressed Andrii's feedback.

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

 arch/x86/net/bpf_jit_comp.c                   | 32 +++++----
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
 kernel/bpf/trampoline.c                       | 28 +++++++-
 kernel/bpf/verifier.c                         | 62 ++++++++++++++++-
 kernel/trace/bpf_trace.c                      |  2 +
 tools/include/uapi/linux/bpf.h                | 19 +++++-
 tools/lib/bpf/libbpf.c                        | 25 ++++++-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 +++++
 .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
 tools/testing/selftests/bpf/progs/lsm.c       | 66 ++++++++++++++++++-
 .../selftests/bpf/progs/trigger_bench.c       |  7 ++
 23 files changed, 315 insertions(+), 67 deletions(-)

-- 
2.23.0

