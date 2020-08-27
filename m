Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2652550D7
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgH0WBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH0WBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:01:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88BAC061264;
        Thu, 27 Aug 2020 15:01:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id t9so4548022pfq.8;
        Thu, 27 Aug 2020 15:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZHhZPmfMM8w4lA9baRiaWiLPa66wAuHgYphisGjv/W4=;
        b=K7Xv9kWvuFugMHsINEndmO32Pt+zZxvKfOy4qyNucheUJ99TbqWOm8fXweX2PWjcsE
         yiw9yhlGwrFIvzBJjW6QJXQOThJxWBj4kpXCfqTTOviCWL//5Md+FquUMfrpBqJFjPaz
         mvhbG4DHd9WPp5ZD6oSRkPKXnj+7R1jp3Jk9VvG1YWVsbgHiQ3TuiY+UDyqU1DPJTpTw
         uaIkArUK3J8dvN4eKxqElHoxX9WkfFyx791BgEG8hKmiMoNU6YcxyhxKbTefuVNQDnvu
         IMYyosAWML+tz4tc+/YH9iD2j+APimI96s3CrflF8ccGUevfaKw9+EMtwwH7pOoJ2t/1
         1CWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZHhZPmfMM8w4lA9baRiaWiLPa66wAuHgYphisGjv/W4=;
        b=IQDJnBsZ9SkVU+gTHSwUxRp9K6uecHKYygVq/MYIwL3PYB6CjA+dkbcAjgKAq2WHWa
         vp4LkRHW+aFDVHIuwslsfDrGONKkEyskyfRp1gKfg6faXIZieLdckgkifV0OiwhiUWQ7
         0hKlqRh57vyhEkFsncSJFx4e2r7PnNd9NBdmi58ljDg4xKTddPN55k3XlWfY9Y4cnpeM
         zFWOwtAzaQq626FcIePlK0jwK+ys8wAllML7PZcuGA9cvVZupCSWcpDzAKCoaNprpdBS
         pQvfWz4B725iPTUJooR+kTZgfVvEvGJx4tT0+P93JRDw9x1/+S8YF6ByDnU9sUJILBkP
         o2rw==
X-Gm-Message-State: AOAM533YZwtFaD6n909wEDoHOah2iIerEJsI/8zgGOOvnq1Nr9f1z8eR
        NNoVAzElzBbRaOgWdTbIpAo=
X-Google-Smtp-Source: ABdhPJzuh8texfB50wida4qkUSjtZNbZtqaKEmGtUOsbhrllJR1uFZJsDRLL1rZ9Q0CwjAKLG7U9uQ==
X-Received: by 2002:a63:2a96:: with SMTP id q144mr931719pgq.447.1598565678306;
        Thu, 27 Aug 2020 15:01:18 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id x28sm3997564pfq.62.2020.08.27.15.01.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 15:01:17 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, josef@toxicpanda.com, bpoirier@suse.com,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 0/5] bpf: Introduce minimal support for sleepable progs
Date:   Thu, 27 Aug 2020 15:01:09 -0700
Message-Id: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v2->v3:
- switched to minimal allowlist approach. Essentially that means that syscall
  entry, few btrfs allow_error_inject functions, should_fail_bio(), and two LSM
  hooks: file_mprotect and bprm_committed_creds are the only hooks that allow
  attaching of sleepable BPF programs. When comprehensive analysis of LSM hooks
  will be done this allowlist will be extended.
- added patch 1 that fixes prototypes of two mm functions to reliably work with
  error injection. It's also necessary for resolve_btfids tool to recognize
  these two funcs, but that's secondary.

v1->v2:
- split fmod_ret fix into separate patch
- added denylist

v1:
This patch set introduces the minimal viable support for sleepable bpf programs.
In this patch only fentry/fexit/fmod_ret and lsm progs can be sleepable.
Only array and pre-allocated hash and lru maps allowed.

Here is 'perf report' difference of sleepable vs non-sleepable:
   3.86%  bench     [k] __srcu_read_unlock
   3.22%  bench     [k] __srcu_read_lock
   0.92%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
   0.50%  bench     [k] bpf_trampoline_10297
   0.26%  bench     [k] __bpf_prog_exit_sleepable
   0.21%  bench     [k] __bpf_prog_enter_sleepable
vs
   0.88%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry
   0.84%  bench     [k] bpf_trampoline_10297
   0.13%  bench     [k] __bpf_prog_enter
   0.12%  bench     [k] __bpf_prog_exit
vs
   0.79%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
   0.72%  bench     [k] bpf_trampoline_10381
   0.31%  bench     [k] __bpf_prog_exit_sleepable
   0.29%  bench     [k] __bpf_prog_enter_sleepable

Sleepable vs non-sleepable program invocation overhead is only marginally higher
due to rcu_trace. srcu approach is much slower.

Alexei Starovoitov (5):
  mm/error_inject: Fix allow_error_inject function signatures.
  bpf: Introduce sleepable BPF programs
  bpf: Add bpf_copy_from_user() helper.
  libbpf: support sleepable progs
  selftests/bpf: Add sleepable tests

 arch/x86/net/bpf_jit_comp.c                   | 32 +++++---
 include/linux/bpf.h                           |  4 +
 include/uapi/linux/bpf.h                      | 16 ++++
 init/Kconfig                                  |  1 +
 kernel/bpf/arraymap.c                         |  1 +
 kernel/bpf/hashtab.c                          | 12 +--
 kernel/bpf/helpers.c                          | 22 +++++
 kernel/bpf/syscall.c                          | 13 ++-
 kernel/bpf/trampoline.c                       | 28 ++++++-
 kernel/bpf/verifier.c                         | 81 ++++++++++++++++++-
 kernel/trace/bpf_trace.c                      |  2 +
 mm/filemap.c                                  |  8 +-
 mm/page_alloc.c                               |  2 +-
 tools/include/uapi/linux/bpf.h                | 16 ++++
 tools/lib/bpf/libbpf.c                        | 25 +++++-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 ++++
 .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
 tools/testing/selftests/bpf/progs/lsm.c       | 66 ++++++++++++++-
 .../selftests/bpf/progs/trigger_bench.c       |  7 ++
 20 files changed, 331 insertions(+), 33 deletions(-)

-- 
2.23.0

