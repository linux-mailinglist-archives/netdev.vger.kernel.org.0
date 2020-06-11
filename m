Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205D11F7000
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgFKWXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgFKWXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:23:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB26C03E96F;
        Thu, 11 Jun 2020 15:23:45 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d8so2868150plo.12;
        Thu, 11 Jun 2020 15:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TJXwWhWHgRowfSiaYlhH0hkxP6lLQW6aVVbjEVNwqDI=;
        b=FtKT9Gi+CW4XbXykluivixVWUig0fktvKjdhauIJR/UAq9q1tFu2u8zQKCvaMsx0Pt
         0QWZfuaH1p3lpvrK1PiRGqndbriLwZN1eBlTHcGZkf34AQDpBiqOc8JxuttVlTvorymD
         h4naDaa65xXg8foPTH+ungEJmE+hvi8VRG4t5LwdVjWt7X0fzcpGBaHatSJsk+df9CBG
         8YXF8Txbl5OJetmpxtvjUTNlqeOop5g7SKrt5kEblaediS8bCnJ1V3NnaPy965AEeEh/
         jsLf3PeIOhSJPoTs238IgUjtAn+VFf9wPPppbf8LC1owxV2jO1JcMu4tkMGha/98oHc0
         GO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TJXwWhWHgRowfSiaYlhH0hkxP6lLQW6aVVbjEVNwqDI=;
        b=jQpEa93nWCuv/dNUldBbb1lPEmtSI61/dE+b0m4KDCohYE2/akAeLQSIvJ5/tvqiA+
         5aSXEkIGDCdy5PEf2EPK4YtEUySZ0wIJfJZfirUmklojkHB2k2jCeoH1EqnOwDe4VHTD
         Bpgd5GTuCk3prrYArDkVEjHEBFmbVJlh0g7oF5s3Nq1p1/2nxCKWd2svmfpgCC+c1JE0
         XJ1brTCY5lHfB+AXqYmHdOpW2/2uPzBWfyE8muk02rFJSggkIRbEaNpHFjn8KK4wqCIa
         gTXYYHBEkM9NoJq896tBxo5iU++/0GCTZbZY0G10wyKhheW8is3PHjR6SPIuIeG1Qk5b
         0BUg==
X-Gm-Message-State: AOAM532NJQZsOYqACH7DpywQ6sAlBorYT0LRVawNyr8ZabNp9uKykJtQ
        u12Tloy24hm73bHd1WFbPHU=
X-Google-Smtp-Source: ABdhPJxhZ+7gqvf9hh0vbTMGLv2oEPy44FRL/9F42QoIxRUCuXlqg1awnml5i3rlP4xorI6jQBbXyw==
X-Received: by 2002:a17:90b:234c:: with SMTP id ms12mr10682295pjb.164.1591914223366;
        Thu, 11 Jun 2020 15:23:43 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id nl11sm8660651pjb.0.2020.06.11.15.23.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 15:23:42 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH RFC v3 bpf-next 0/4] bpf: Introduce minimal support for sleepable progs
Date:   Thu, 11 Jun 2020 15:23:36 -0700
Message-Id: <20200611222340.24081-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

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

Alexei Starovoitov (4):
  bpf: Introduce sleepable BPF programs
  bpf: Add bpf_copy_from_user() helper.
  libbpf: support sleepable progs
  selftests/bpf: basic sleepable tests

 arch/x86/net/bpf_jit_comp.c                   | 32 ++++++----
 include/linux/bpf.h                           |  4 ++
 include/uapi/linux/bpf.h                      | 19 +++++-
 init/Kconfig                                  |  1 +
 kernel/bpf/arraymap.c                         |  6 ++
 kernel/bpf/hashtab.c                          | 20 ++++--
 kernel/bpf/helpers.c                          | 22 +++++++
 kernel/bpf/syscall.c                          | 13 +++-
 kernel/bpf/trampoline.c                       | 37 ++++++++---
 kernel/bpf/verifier.c                         | 62 ++++++++++++++++++-
 kernel/trace/bpf_trace.c                      |  2 +
 tools/include/uapi/linux/bpf.h                | 19 +++++-
 tools/lib/bpf/libbpf.c                        | 25 +++++++-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 +++++
 tools/testing/selftests/bpf/progs/lsm.c       | 14 ++++-
 .../selftests/bpf/progs/trigger_bench.c       |  7 +++
 17 files changed, 268 insertions(+), 34 deletions(-)

-- 
2.23.0

