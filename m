Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FCC1E5680
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgE1Fdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgE1Fdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:33:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08351C05BD1E;
        Wed, 27 May 2020 22:33:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bg4so5756159plb.3;
        Wed, 27 May 2020 22:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wK1oDgt7bzl4BAzyRGfnZYUGhz6C2+/WS6taIc+uvS4=;
        b=VqOgodyom8H/IbLXokV8ZMQXRqmu6MIXX98fxBTYUWF+nvazAccD7QTIqHcYISTwvb
         /IiOvN5vdpcZvqA+pE8r3O0e/O6ucquBfqNaRb8eU/YlUC+1V2Ta5ccTK/WqvTehBjxe
         5cY1yr5lFmLqQn4jAaoL97kTn5klDJxdawnUXxSlmUioXybhf9/wciQB8MoKDJ7Gu94k
         qtwJXZJR2wekBlLVWeHCXo+Lm92MuYxuFb3pWu6zkt8jl0xkGHQEQ1u0OGnM/7Nmkwb6
         LD6z275dEd2UbJziVcSkWxrd1LdW4DaQmIq8aeQLme3dTn4ggrcHwTDF5T4U4XA3av4n
         06pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wK1oDgt7bzl4BAzyRGfnZYUGhz6C2+/WS6taIc+uvS4=;
        b=o7RbqBjEo2FAIgaCDc7G5VHkmfYeInCoP8LvhckYLhAXekq+MYXGRVJ3XrgwajwY9M
         Wz0tP2wpP0QDGIVv0cC9nEGK7kAgP3AOuHY9D2gqJDESscje36EBEo090jZlDLl7YV5B
         2NDcs+1XDdmnMc7mS/cD/XwDC5+U6uB90e3LIXLDkmGgh/hzudgcF6JJWCG92BDDBcEw
         UCAENriLMwX2L5qxdaWdZfJXn67ovw7lGA2cbCIeRdTluFAV5/5Ob3m71IxUy13NgTOx
         ki3aN8Zxj4GMGKOBh7zkmHyB8RkhSCOtWlAyjJovT9zuRDgFdSr6YiHCI0tPHMIMRXLZ
         Guuw==
X-Gm-Message-State: AOAM531/Fnoffz+ARmqFudTOhffR4xcgaKvJZd78+AlyNu0UaMSzXnZ5
        AzSp5vISqBRdSl748nLPOZs=
X-Google-Smtp-Source: ABdhPJxgwSwA2d3q3vJ0zYQ4nhhCPgvYuqX8a+nnmvFPlanu1q1wXr+wEafYkAT6rOgh4KyOSJvkDw==
X-Received: by 2002:a17:90a:f098:: with SMTP id cn24mr1957390pjb.201.1590644017433;
        Wed, 27 May 2020 22:33:37 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id o27sm3502461pgd.18.2020.05.27.22.33.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2020 22:33:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 0/3] bpf: Introduce minimal support for sleepable progs
Date:   Wed, 27 May 2020 22:33:31 -0700
Message-Id: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

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

Clearly sleepable vs non-sleepable program invocation overhead is high, but it
could be acceptable in certain cases until rcu_trace is available.

bpf_copy_from_user(), bpf_msleep() will be coming in the future patches.
Support for perf_event_array and bpf_perf_event_output() will follow as well.

Alexei Starovoitov (3):
  bpf: Introduce sleepable BPF programs
  libbpf: support sleepable progs
  selftests/bpf: basic sleepable tests

 arch/x86/net/bpf_jit_comp.c                   | 36 ++++++++----
 include/linux/bpf.h                           |  4 ++
 include/uapi/linux/bpf.h                      |  8 +++
 kernel/bpf/arraymap.c                         |  5 ++
 kernel/bpf/hashtab.c                          | 19 +++++--
 kernel/bpf/syscall.c                          | 12 +++-
 kernel/bpf/trampoline.c                       | 33 ++++++++++-
 kernel/bpf/verifier.c                         | 56 ++++++++++++++-----
 tools/include/uapi/linux/bpf.h                |  8 +++
 tools/lib/bpf/libbpf.c                        | 25 ++++++++-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 ++++++
 tools/testing/selftests/bpf/progs/lsm.c       |  4 +-
 .../selftests/bpf/progs/trigger_bench.c       |  7 +++
 14 files changed, 199 insertions(+), 37 deletions(-)

-- 
2.23.0

