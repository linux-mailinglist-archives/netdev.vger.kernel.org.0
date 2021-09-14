Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FB540ACDD
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhINL6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:58:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:52286 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbhINL6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:58:00 -0400
Received: from 65.47.5.85.dynamic.wline.res.cust.swisscom.ch ([85.5.47.65] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mQ73I-0008Yp-0I; Tue, 14 Sep 2021 13:56:40 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-09-14
Date:   Tue, 14 Sep 2021 13:56:39 +0200
Message-Id: <20210914115639.20251-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26294/Tue Sep 14 10:22:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 7 non-merge commits during the last 13 day(s) which contain
a total of 18 files changed, 334 insertions(+), 193 deletions(-).

The main changes are:

1) Fix mmap_lock lockdep splat in BPF stack map's build_id lookup, from Yonghong Song.

2) Fix BPF cgroup v2 program bypass upon net_cls/prio activation, from Daniel Borkmann.

3) Fix kvcalloc() BTF line info splat on oversized allocation attempts, from Bixuan Cui.

4) Fix BPF selftest build of task_pt_regs test for arm64/s390, from Jean-Philippe Brucker.

5) Fix BPF's disasm.{c,h} to dual-license so that it is aligned with bpftool given the former
   is a build dependency for the latter, from Daniel Borkmann with ACKs from contributors.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Brendan Jackman, Edward Cree, Ilya 
Leoshkevich, Jakub Kicinski, Jiri Olsa, Liam R. Howlett, Martin KaFai 
Lau, Simon Horman, Stanislav Fomichev, Tejun Heo, Thomas Graf, Xu 
Kuohai, Yonghong Song

----------------------------------------------------------------

The following changes since commit 9e9fb7655ed585da8f468e29221f0ba194a5f613:

  Merge tag 'net-next-5.15' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2021-08-31 16:43:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 43d2b88c29f2d120b4dc22f27b3483eb14bd9815:

  bpf, selftests: Add test case for mixed cgroup v1/v2 (2021-09-13 16:35:58 -0700)

----------------------------------------------------------------
Bixuan Cui (1):
      bpf: Add oversize check before call kvcalloc()

Daniel Borkmann (4):
      bpf: Relicense disassembler as GPL-2.0-only OR BSD-2-Clause
      bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
      bpf, selftests: Add cgroup v1 net_cls classid helpers
      bpf, selftests: Add test case for mixed cgroup v1/v2

Jean-Philippe Brucker (1):
      selftests/bpf: Fix build of task_pt_regs test for arm64

Yonghong Song (1):
      bpf, mm: Fix lockdep warning triggered by stack_map_get_build_id_offset()

 include/linux/cgroup-defs.h                        | 107 ++++------------
 include/linux/cgroup.h                             |  22 +---
 include/linux/mmap_lock.h                          |   9 --
 kernel/bpf/disasm.c                                |   2 +-
 kernel/bpf/disasm.h                                |   2 +-
 kernel/bpf/stackmap.c                              |  10 +-
 kernel/bpf/verifier.c                              |   2 +
 kernel/cgroup/cgroup.c                             |  50 ++------
 net/core/netclassid_cgroup.c                       |   7 +-
 net/core/netprio_cgroup.c                          |  10 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       | 137 +++++++++++++++++++--
 tools/testing/selftests/bpf/cgroup_helpers.h       |  16 ++-
 tools/testing/selftests/bpf/network_helpers.c      |  27 +++-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../testing/selftests/bpf/prog_tests/cgroup_v1v2.c |  79 ++++++++++++
 .../selftests/bpf/prog_tests/task_pt_regs.c        |   1 -
 .../testing/selftests/bpf/progs/connect4_dropper.c |  26 ++++
 .../selftests/bpf/progs/test_task_pt_regs.c        |  19 ++-
 18 files changed, 334 insertions(+), 193 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_v1v2.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect4_dropper.c
