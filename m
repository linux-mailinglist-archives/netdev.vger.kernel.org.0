Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0729D3BF367
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhGHBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhGHBVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:21:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBD1C061574;
        Wed,  7 Jul 2021 18:18:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b8-20020a17090a4888b02901725eedd346so2765638pjh.4;
        Wed, 07 Jul 2021 18:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/lxhq739fE59uqLHDsDnHPVFR5tUA59Nz8504QOZZSM=;
        b=CV2bovhLX+ouOVzoq/SPCunxOqgHXzFWnh68vL8QMe1Zf3hWHPS2J9SaXiCHLnu7Nx
         Le9Ko54F8XKSd45kUaj1T6871dsF7VZjYdi2HWOhVm1afDEBXc+/4ZyBdhZqrdt0Ef9Z
         n7461wM6c+zflgifVKloFYWlx9o2GkdEH3BO/v0/+pLOzP64OVmP1EiqX4SqVBqggY4w
         YaiVYWHQBZxIwrcLvAvNkOqrY7Wg/BCeIvUmAE8tT9aTQafG5l6xjkpQDPdYt2eYYQ12
         M8zjB+MtF1xfX4Z9x2BvhngML6bWxiwDSwoMiESbGPvne5cPy/1u11+DUXyUABVgEPrH
         KtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/lxhq739fE59uqLHDsDnHPVFR5tUA59Nz8504QOZZSM=;
        b=APttVNJZ4zk+h/Njld6Uei1hMP0jbkyjWEiCytbBupclqrVxjVLsuzwIa6S4WK80Gp
         rgoY9axCaf33eRRZPNz3WmvitoX4X51twkqqrfM5IWS1iw8FsziXVbB+BAhmHUzrxYQ+
         aXOfkS6KTVTakZ2bnykyXi1x+umTSDDqKcJNCWsiHYRXq9HtA74yRr7cI8fqzVags7Bm
         khnrCvcXBhDiYaSCC/MX/0syUnChEE79wNnZxPOBl55V5q7MXway/CsL+nqJyJba/Na2
         w+gEx/7yrC5x7Y+TwtTnb9lVUWlh86osK1nkoDSUhhjO5Idy6ldEZHg5nkNUZTBSB44p
         O7KQ==
X-Gm-Message-State: AOAM532Wc1DavBG1jKfIZ/spdmVnb/eCQLcHGjYzI+bYKZQGLnzWp0Kj
        DnIpqQKZKiempvIaI6mJNWg=
X-Google-Smtp-Source: ABdhPJzEqmmXWY9O8AUtuStQsYBl3ArpXsC5pkG4s7mcnwdsKOy71Jr0Y1N9Ei01LRFnt3Rb4i9ZJg==
X-Received: by 2002:a17:90a:fa98:: with SMTP id cu24mr1944472pjb.0.1625707117424;
        Wed, 07 Jul 2021 18:18:37 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id d20sm417450pfn.219.2021.07.07.18.18.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:18:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 00/11] bpf: Introduce BPF timers.
Date:   Wed,  7 Jul 2021 18:18:22 -0700
Message-Id: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

v4->v5:
- Martin noticed the following issues:
. prog could be reallocated bpf_patch_insn_data().
Fixed by passing 'aux' into bpf_timer_set_callback, since 'aux' is stable
during insn patching.
. Added missing rcu_read_lock.
. Removed redundant record_map.
- Discovered few bugs with stress testing:
. One cpu does htab_free_prealloced_timers->bpf_timer_cancel_and_free->hrtimer_cancel
while another is trying to do something with the timer like bpf_timer_start/set_callback.
Those ops try to acquire bpf_spin_lock that is already taken by bpf_timer_cancel_and_free,
so both cpus spin forever. The same problem existed in bpf_timer_cancel().
One bpf prog on one cpu might call bpf_timer_cancel and wait, while another cpu is in
the timer callback that tries to do bpf_timer_*() helper on the same timer.
The fix is to do drop_prog_refcnt() and unlock. And only then hrtimer_cancel.
Because of this had to add callback_fn != NULL check to bpf_timer_cb().
Also removed redundant bpf_prog_inc/put from bpf_timer_cb() and replaced
with rcu_dereference_check similar to recent rcu_read_lock-removal from drivers.
bpf_timer_cb is in softirq.
. Managed to hit refcnt==0 while doing bpf_prog_put from bpf_timer_cancel_and_free().
That exposed the issue that bpf_prog_put wasn't ready to be called from irq context.
Fixed similar to bpf_map_put which is irq ready.
- Refactored BPF_CALL_1(bpf_spin_lock) into __bpf_spin_lock_irqsave() to
make the main logic more clear, since Martin and Yonghong brought up this concern.

v3->v4:
1.
Split callback_fn from bpf_timer_start into bpf_timer_set_callback as
suggested by Martin. That makes bpf timer api match one to one to
kernel hrtimer api and provides greater flexibility.
2.
Martin also discovered the following issue with uref approach:
bpftool prog load xdp_timer.o /sys/fs/bpf/xdp_timer type xdp
bpftool net attach xdpgeneric pinned /sys/fs/bpf/xdp_timer dev lo
rm /sys/fs/bpf/xdp_timer
nc -6 ::1 8888
bpftool net detach xdpgeneric dev lo
The timer callback stays active in the kernel though the prog was detached
and map usercnt == 0.
It happened because 'bpftool prog load' pinned the prog only.
The map usercnt went to zero. Subsequent attach and runs didn't
affect map usercnt. The timer was able to start and bpf_prog_inc itself.
When the prog was detached the prog stayed active.
To address this issue added
if (!atomic64_read(&(t->map->usercnt))) return -EPERM;
to the first patch.
Which means that timers are allowed only in the maps that are held
by user space with open file descriptor or maps pinned in bpffs.
3.
Discovered that timers in inner maps were broken.
The inner map pointers are dynamic. Therefore changed bpf_timer_init()
to accept explicit map pointer supplied by the program instead
of hidden map pointer supplied by the verifier.
To make sure that pointer to a timer actually belongs to that map
added the verifier check in patch 3.
4.
Addressed Yonghong's feedback. Improved comments and added
dynamic in_nmi() check.
Added Acks.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com> # for the feature

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

Alexei Starovoitov (11):
  bpf: Prepare bpf_prog_put() to be called from irq context.
  bpf: Factor out bpf_spin_lock into helpers.
  bpf: Introduce bpf timers.
  bpf: Add map side support for bpf timers.
  bpf: Prevent pointer mismatch in bpf_timer_init.
  bpf: Remember BTF of inner maps.
  bpf: Relax verifier recursion check.
  bpf: Implement verifier support for validation of async callbacks.
  bpf: Teach stack depth check about async callbacks.
  selftests/bpf: Add bpf_timer test.
  selftests/bpf: Add a test with bpf_timer in inner map.

 include/linux/bpf.h                           |  47 ++-
 include/linux/bpf_verifier.h                  |  19 +-
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  69 ++++
 kernel/bpf/arraymap.c                         |  22 ++
 kernel/bpf/btf.c                              |  77 +++-
 kernel/bpf/hashtab.c                          | 104 +++++-
 kernel/bpf/helpers.c                          | 334 +++++++++++++++++-
 kernel/bpf/local_storage.c                    |   4 +-
 kernel/bpf/map_in_map.c                       |   8 +
 kernel/bpf/syscall.c                          |  53 ++-
 kernel/bpf/verifier.c                         | 307 +++++++++++++++-
 kernel/trace/bpf_trace.c                      |   2 +-
 scripts/bpf_doc.py                            |   2 +
 tools/include/uapi/linux/bpf.h                |  69 ++++
 .../testing/selftests/bpf/prog_tests/timer.c  |  55 +++
 .../selftests/bpf/prog_tests/timer_mim.c      |  69 ++++
 tools/testing/selftests/bpf/progs/timer.c     | 297 ++++++++++++++++
 tools/testing/selftests/bpf/progs/timer_mim.c |  88 +++++
 .../selftests/bpf/progs/timer_mim_reject.c    |  74 ++++
 20 files changed, 1637 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim.c
 create mode 100644 tools/testing/selftests/bpf/progs/timer_mim_reject.c

-- 
2.30.2

