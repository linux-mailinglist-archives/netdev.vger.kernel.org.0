Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19D544676F
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhKERAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 13:00:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:37182 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbhKERAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 13:00:45 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mj2XT-0001XY-RL; Fri, 05 Nov 2021 17:58:03 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-11-05
Date:   Fri,  5 Nov 2021 17:58:03 +0100
Message-Id: <20211105165803.29372-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26344/Fri Nov  5 09:18:44 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 15 non-merge commits during the last 3 day(s) which contain
a total of 14 files changed, 199 insertions(+), 90 deletions(-).

The main changes are:

1) Fix regression from stack spill/fill of <8 byte scalars, from Martin KaFai Lau.

2) Fix perf's build of bpftool's bootstrap version due to missing libbpf
   headers, from Quentin Monnet.

3) Fix riscv{32,64} BPF exception tables build errors and warnings, from Björn Töpel.

4) Fix bpf fs to allow RENAME_EXCHANGE support for atomic upgrades on sk_lookup
   control planes, from Lorenz Bauer.

5) Fix libbpf's error reporting in bpf_map_lookup_and_delete_elem_flags() due to
   missing libbpf_err_errno(), from Mehrdad Arshad Rad.

6) Various fixes to make xdp_redirect_multi selftest more reliable, from Hangbin Liu.

7) Fix netcnt selftest to make it run serial and thus avoid conflicts with other
   cgroup/skb selftests run in parallel that could cause flakes, from Andrii Nakryiko.

8) Fix reuseport_bpf_numa networking selftest to skip unavailable NUMA nodes,
   from Kleber Sacilotto de Souza.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Arnaldo Carvalho de Melo, Christian Brauner, Hengqi Chen, Jiri Benc, 
Miklos Szeredi, Tong Tiangen, Yonghong Song

----------------------------------------------------------------

The following changes since commit 92f62485b3715882cd397b0cbd80a96d179b86d6:

  net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge (2021-11-03 14:22:00 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to f47d4ffe3a84ae11fc4bddc37939b9719467042c:

  riscv, bpf: Fix RV32 broken build, and silence RV64 warning (2021-11-05 16:52:34 +0100)

----------------------------------------------------------------
Andrii Nakryiko (1):
      selftests/bpf: Make netcnt selftests serial to avoid spurious failures

Björn Töpel (1):
      riscv, bpf: Fix RV32 broken build, and silence RV64 warning

Hangbin Liu (4):
      selftests/bpf/xdp_redirect_multi: Put the logs to tmp folder
      selftests/bpf/xdp_redirect_multi: Use arping to accurate the arp number
      selftests/bpf/xdp_redirect_multi: Give tcpdump a chance to terminate cleanly
      selftests/bpf/xdp_redirect_multi: Limit the tests in netns

Kleber Sacilotto de Souza (1):
      selftests/net: Fix reuseport_bpf_numa by skipping unavailable nodes

Lorenz Bauer (4):
      libfs: Move shmem_exchange to simple_rename_exchange
      libfs: Support RENAME_EXCHANGE in simple_rename()
      selftests/bpf: Convert test_bpffs to ASSERT macros
      selftests/bpf: Test RENAME_EXCHANGE and RENAME_NOREPLACE on bpffs

Martin KaFai Lau (2):
      bpf: Do not reject when the stack read size is different from the tracked scalar size
      selftests/bpf: Verifier test on refill from a smaller spill

Mehrdad Arshad Rad (1):
      libbpf: Fix lookup_and_delete_elem_flags error reporting

Quentin Monnet (1):
      bpftool: Install libbpf headers for the bootstrap version, too

 arch/riscv/mm/extable.c                            |  4 +-
 arch/riscv/net/bpf_jit_comp64.c                    |  2 +
 fs/libfs.c                                         | 29 +++++++-
 include/linux/fs.h                                 |  2 +
 kernel/bpf/verifier.c                              | 18 ++---
 mm/shmem.c                                         | 24 +-----
 tools/bpf/bpftool/Makefile                         | 32 +++++---
 tools/lib/bpf/bpf.c                                |  4 +-
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |  2 +-
 .../testing/selftests/bpf/prog_tests/test_bpffs.c  | 85 +++++++++++++++++++---
 .../selftests/bpf/test_xdp_redirect_multi.sh       | 62 +++++++++-------
 tools/testing/selftests/bpf/verifier/spill_fill.c  | 17 +++++
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |  4 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c   |  4 +
 14 files changed, 199 insertions(+), 90 deletions(-)
