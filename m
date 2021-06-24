Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18AC3B24EC
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhFXC1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFXC1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 22:27:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37620C061574;
        Wed, 23 Jun 2021 19:25:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l11so2558844pji.5;
        Wed, 23 Jun 2021 19:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gBDkP/YiOUEMyO5mZxM7/jMFDwqcwkBMCzgZ1WIXwq4=;
        b=dVz0kovALaQbBSg89U0RE7dPxwlGUlBAEx7IUH0N8zsVYw2WkvhXy3551McMCD15SM
         TOqwA3T3xlE2noIsMG0QdE5PW3rMR2D8GPtGPMOevZgUl2+mqZ9vgGWxo/rqxGF64s7J
         ag8ccZSggwqzp20Z8pRCFIMxfDLI9ejdepJtaUxZvhrk5BCCyyhGdEYaGuYVM0ALirWy
         UhUCdIzTlYAhJAnms3IWmPBOCeaE0IHM58+Os9Ln90lio34S9E4yFkH6BOmsSHWiR60n
         u1BbisDb8A5Nf7GlFII4SkTqQSyi2Bp3J9FFpW8UA8DuiIMKQJdL1bYnJ+CZ35hsbSNF
         yVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gBDkP/YiOUEMyO5mZxM7/jMFDwqcwkBMCzgZ1WIXwq4=;
        b=CYpxdSnNdyx2drZScJiYDpbTccG1IneQTKjLjiM044A7niiGpXCmL9gn9LjxhHuSZw
         qZgrRfOiLNCgD0eDPO+yufz33UVMb1G9AeianC2m9DSrbFhh8QahyWRPgBwqR8s4/0su
         9MtJwFbrjtNUMmeAy5V8vi0PW7m9aGfjWxmfCqu1xf8pkG29P8uYwluRZk1DgDrE2eS+
         LYjVuj1d9qGpX9f6y1iUhuURm8Lyi89vVMVWgZF3FRyN9s0FWYAGKJWvjCn4qgBVrBIg
         L97kLqWTmmp03NzkeZVNqNF0JvKMfkroa/PBkWmZ4D3HZp4o1cAacBXgHohj4Df24BDS
         Gbww==
X-Gm-Message-State: AOAM5335Wa0YN8XJ3KYZ6AHtOHirdwDQcFwe2bpeYPgJcbBH05nSOmx8
        zTUf4ugOQj3xnQCQORB2Ap4=
X-Google-Smtp-Source: ABdhPJwe/JOBSKQ3IlBYz6VPRxxUW2imDCJ4sXDLNnNVZcm426x/yy9zaVWmROy1Ak1Ak5ACCoN67A==
X-Received: by 2002:a17:90a:65c8:: with SMTP id i8mr12723111pjs.207.1624501521555;
        Wed, 23 Jun 2021 19:25:21 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:a319])
        by smtp.gmail.com with ESMTPSA id f17sm4675965pjj.21.2021.06.23.19.25.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:25:20 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 0/8] bpf: Introduce BPF timers.
Date:   Wed, 23 Jun 2021 19:25:10 -0700
Message-Id: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

The first request to support timers in bpf was made in 2013 before sys_bpf syscall
was added. That use case was periodic sampling. It was address with attaching
bpf programs to perf_events. Then during XDP development the timers were requested
to do garbage collection and health checks. They were worked around by implementing
timers in user space and triggering progs with BPF_PROG_RUN command.
The user space timers and perf_event+bpf timers are not armed by the bpf program.
They're done asynchronously vs program execution. The XDP program cannot send a
packet and arm the timer at the same time. The tracing prog cannot record an
event and arm the timer right away. This large class of use cases remained
unaddressed. The jiffy based and hrtimer based timers are essential part of the
kernel development and with this patch set the hrtimer based timers will be
available to bpf programs.

TLDR: bpf timers is a wrapper of hrtimers with all the extra safety added
to make sure bpf progs cannot crash the kernel.

v2->v3:
The v2 approach attempted to bump bpf_prog refcnt when bpf_timer_start is
called to make sure callback code doesn't disappear when timer is active and
drop refcnt when timer cb is done. That led to a ton of race conditions between
callback running and concurrent bpf_timer_init/start/cancel on another cpu,
and concurrent bpf_map_update/delete_elem, and map destroy.

Then v2.5 approach skipped prog refcnt altogether. Instead it remembered all
timers that bpf prog armed in a link list and canceled them when prog refcnt
went to zero. The race conditions disappeared, but timers in map-in-map could
not be supported cleanly, since timers in inner maps have inner map's life time
and don't match prog's life time.

This v3 approach makes timers to be owned by maps. It allows timers in inner
maps to be supported from the start. This apporach relies on "user refcnt"
scheme used in prog_array that stores bpf programs for bpf_tail_call. The
bpf_timer_start() increments prog refcnt, but unlike 1st approach the timer
callback does decrement the refcnt. The ops->map_release_uref is
responsible for cancelling the timers and dropping prog refcnt when user space
reference to a map is dropped. That addressed all the races and simplified
locking.

Andrii presented a use case where specifying callback_fn in bpf_timer_init()
is inconvenient vs specifying in bpf_timer_start(). The bpf_timer_init()
typically is called outside for timer callback, while bpf_timer_start() most
likely will be called from the callback. 
timer_cb() { ... bpf_timer_start(timer_cb); ...} looks like recursion and as
infinite loop to the verifier. The verifier had to be made smarter to recognize
such async callbacks. Patches 4,5,6 addressed that.

Patch 1 implements bpf timer helpers and locking.
Patch 2 implements map side of bpf timer support.
Patch 3 adds support for BTF in inner maps.
Patch 4 teaches check_cfg() pass to understand async callbacks.
Patch 5 teaches do_check() pass to understand async callbacks.
Patch 6 teaches check_max_stack_depth() pass to understand async callbacks.
Patches 7 and 8 are the tests.

v1->v2:
- Addressed great feedback from Andrii and Toke.
- Fixed race between parallel bpf_timer_*() ops.
- Fixed deadlock between timer callback and LRU eviction or bpf_map_delete/update.
- Disallowed mmap and global timers.
- Allow spin_lock and bpf_timer in an element.
- Fixed memory leaks due to map destruction and LRU eviction.
- A ton more tests.

Alexei Starovoitov (8):
  bpf: Introduce bpf timers.
  bpf: Add map side support for bpf timers.
  bpf: Remember BTF of inner maps.
  bpf: Relax verifier recursion check.
  bpf: Implement verifier support for validation of async callbacks.
  bpf: Teach stack depth check about async callbacks.
  selftests/bpf: Add bpf_timer test.
  selftests/bpf: Add a test with bpf_timer in inner map.

 include/linux/bpf.h                           |  47 ++-
 include/linux/bpf_verifier.h                  |  10 +-
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  55 ++++
 kernel/bpf/arraymap.c                         |  22 ++
 kernel/bpf/btf.c                              |  77 ++++-
 kernel/bpf/hashtab.c                          |  96 +++++-
 kernel/bpf/helpers.c                          | 279 ++++++++++++++++
 kernel/bpf/local_storage.c                    |   4 +-
 kernel/bpf/map_in_map.c                       |   7 +
 kernel/bpf/syscall.c                          |  21 +-
 kernel/bpf/verifier.c                         | 311 +++++++++++++++++-
 kernel/trace/bpf_trace.c                      |   2 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  55 ++++
 .../testing/selftests/bpf/prog_tests/timer.c  |  55 ++++
 .../selftests/bpf/prog_tests/timer_mim.c      |  59 ++++
 tools/testing/selftests/bpf/progs/timer.c     | 293 +++++++++++++++++
 tools/testing/selftests/bpf/progs/timer_mim.c |  81 +++++
 19 files changed, 1425 insertions(+), 52 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c

-- 
2.30.2

