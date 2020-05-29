Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97CC1E74EF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgE2Ein (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgE2Ein (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 00:38:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC33C08C5C6;
        Thu, 28 May 2020 21:38:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 64so428854pfg.8;
        Thu, 28 May 2020 21:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dSZP+5Cp1x0E1DLERDzYBVsmNkrcZVYPhsQUkOvGm9Y=;
        b=Vo4Vc423rFBWtJmwLZYo30psUkLNC7JbGGy8YzvOIOIIGanrfg2rBTkm6GHAKyBriV
         W7O9spuQsOsPnzk9eYk0O6rlLSsvvgZvVgllS9ocRtgeXOnEv3XDWXpjkEk+dqBuZ9AK
         0Ao+JQjqcpN3zDhPEffLVosnFQOAEODGPSLMEohN6GMD8NMAgSS1zOmtXCvd18sCeTbb
         b9n85OCw31ECxbhJRTdcV+uEVegFd/H4oLSrHgnouTBqEYuQ+4mMZQjWU0llirAkNDNq
         Q0oi4ZgLTDuhv0nDym2A+8dElB6veEh2m3fszlxPSMdy1Em+NWV7T37vlQXn/+152okm
         VjdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dSZP+5Cp1x0E1DLERDzYBVsmNkrcZVYPhsQUkOvGm9Y=;
        b=Wyl7LlD4qUm5iyBDeb50cBH6AN8InEecLHQSze3eUo/dIrUpTcXSKzcASFego/QYWM
         S/2uwc+Kew8jn4epKvgAJSEU4xP7iX8fNuPJJPqbRSz/LhX/qbJO4duTkZ3/MlT6S53n
         IzGERv+TquE7kDNjzGff9YP5fL1dqK4IgVDlPe0dPax6OEtxSev3LdV3A2oddo0j5ocG
         9jL6IjKeYXpkvfl2q3NDK5P2vbb/8pvP5/TnXl/Wx9MfmGFfpubU3FtakKq2PWXgG2D1
         WOqzMi6pTeG27uVy0f34vkthNrpPJ/KqZZ2QmurxKK92LOTO/dVUna8oQ4Di5aXqknE1
         LJ7Q==
X-Gm-Message-State: AOAM530b2b74HX3cBWKs5XyT2PM9vHjcNPeSSowSdU04P1rvA4MqDR8p
        +AlHtcyKP7AxCHgNQCUmKjQcgYJy
X-Google-Smtp-Source: ABdhPJw4YSLjA3HJOBwXqf/MudgOL8i4p3L/emQWg+YpoNJCN53Hm5galyVR70+OhntdF6ZyUxBR+Q==
X-Received: by 2002:a63:f502:: with SMTP id w2mr6377801pgh.321.1590727122450;
        Thu, 28 May 2020 21:38:42 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id w73sm6288777pfd.113.2020.05.28.21.38.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 21:38:41 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v2 bpf-next 0/4] bpf: Introduce minimal support for sleepable progs
Date:   Thu, 28 May 2020 21:38:35 -0700
Message-Id: <20200529043839.15824-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

v1->v2:
- split fmod_ret fix into separate patch
- added blacklist

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

Clearly sleepable vs non-sleepable program invocation overhead is high, but it
could be acceptable in certain cases until rcu_trace is available.

bpf_copy_from_user(), bpf_msleep() will be coming in the future patches.
Support for perf_event_array and bpf_perf_event_output() will follow as well.

Alexei Starovoitov (4):
  bpf: Fix use-after-free in fmod_ret check
  bpf: Introduce sleepable BPF programs
  libbpf: support sleepable progs
  selftests/bpf: basic sleepable tests

 arch/x86/net/bpf_jit_comp.c                   | 36 +++++---
 include/linux/bpf.h                           |  4 +
 include/uapi/linux/bpf.h                      |  8 ++
 kernel/bpf/arraymap.c                         |  5 ++
 kernel/bpf/hashtab.c                          | 19 +++--
 kernel/bpf/syscall.c                          | 12 ++-
 kernel/bpf/trampoline.c                       | 33 +++++++-
 kernel/bpf/verifier.c                         | 84 ++++++++++++++++---
 tools/include/uapi/linux/bpf.h                |  8 ++
 tools/lib/bpf/libbpf.c                        | 25 +++++-
 tools/testing/selftests/bpf/bench.c           |  2 +
 .../selftests/bpf/benchs/bench_trigger.c      | 17 ++++
 tools/testing/selftests/bpf/progs/lsm.c       |  9 +-
 .../selftests/bpf/progs/trigger_bench.c       |  7 ++
 14 files changed, 232 insertions(+), 37 deletions(-)

-- 
2.23.0

