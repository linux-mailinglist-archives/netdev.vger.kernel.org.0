Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7D943BB78
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbhJZUVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:21:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:55858 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhJZUVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:21:47 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfSum-0000pV-Sw; Tue, 26 Oct 2021 22:19:20 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-10-26
Date:   Tue, 26 Oct 2021 22:19:20 +0200
Message-Id: <20211026201920.11296-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26334/Tue Oct 26 10:22:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 12 non-merge commits during the last 7 day(s) which contain
a total of 23 files changed, 118 insertions(+), 98 deletions(-).

The main changes are:

1) Fix potential race window in BPF tail call compatibility check, from Toke Høiland-Jørgensen.

2) Fix memory leak in cgroup fs due to missing cgroup_bpf_offline(), from Quanyang Wang.

3) Fix file descriptor reference counting in generic_map_update_batch(), from Xu Kuohai.

4) Fix bpf_jit_limit knob to the max supported limit by the arch's JIT, from Lorenz Bauer.

5) Fix BPF sockmap ->poll callbacks for UDP and AF_UNIX sockets, from Cong Wang and Yucong Sun.

6) Fix BPF sockmap concurrency issue in TCP on non-blocking sendmsg calls, from Liu Jian.

7) Fix build failure of INODE_STORAGE and TASK_STORAGE maps on !CONFIG_NET, from Tejun Heo.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, John Fastabend, kernel test robot, Lorenzo Bianconi, Luke 
Nelson, Martin KaFai Lau, Roman Gushchin, Yucong Sun

----------------------------------------------------------------

The following changes since commit 4225fea1cb28370086e17e82c0f69bec2779dca0:

  ptp: Fix possible memory leak in ptp_clock_register() (2021-10-20 14:44:33 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 54713c85f536048e685258f880bf298a74c3620d:

  bpf: Fix potential race in tail call compatibility check (2021-10-26 12:37:28 -0700)

----------------------------------------------------------------
Alexei Starovoitov (2):
      Merge branch 'Fix up bpf_jit_limit some more'
      Merge branch 'sock_map: fix ->poll() and update selftests'

Cong Wang (3):
      net: Rename ->stream_memory_read to ->sock_is_readable
      skmsg: Extract and reuse sk_msg_is_readable()
      net: Implement ->sock_is_readable() for UDP and AF_UNIX

Liu Jian (1):
      tcp_bpf: Fix one concurrency problem in the tcp_bpf_send_verdict function

Lorenz Bauer (3):
      bpf: Define bpf_jit_alloc_exec_limit for riscv JIT
      bpf: Define bpf_jit_alloc_exec_limit for arm64 JIT
      bpf: Prevent increasing bpf_jit_limit above max

Quanyang Wang (1):
      cgroup: Fix memory leak caused by missing cgroup_bpf_offline

Tejun Heo (1):
      bpf: Move BPF_MAP_TYPE for INODE_STORAGE and TASK_STORAGE outside of CONFIG_NET

Toke Høiland-Jørgensen (1):
      bpf: Fix potential race in tail call compatibility check

Xu Kuohai (1):
      bpf: Fix error usage of map_fd and fdget() in generic_map_update_batch()

Yucong Sun (1):
      selftests/bpf: Use recv_timeout() instead of retries

 arch/arm64/net/bpf_jit_comp.c                      |  5 ++
 arch/riscv/net/bpf_jit_core.c                      |  5 ++
 include/linux/bpf.h                                |  7 +-
 include/linux/bpf_types.h                          |  8 +--
 include/linux/filter.h                             |  1 +
 include/linux/skmsg.h                              |  1 +
 include/net/sock.h                                 |  8 ++-
 include/net/tls.h                                  |  2 +-
 kernel/bpf/arraymap.c                              |  1 +
 kernel/bpf/core.c                                  | 24 ++++---
 kernel/bpf/syscall.c                               | 11 ++--
 kernel/cgroup/cgroup.c                             |  4 +-
 net/core/skmsg.c                                   | 14 ++++
 net/core/sysctl_net_core.c                         |  2 +-
 net/ipv4/tcp.c                                     |  5 +-
 net/ipv4/tcp_bpf.c                                 | 27 ++++----
 net/ipv4/udp.c                                     |  3 +
 net/ipv4/udp_bpf.c                                 |  1 +
 net/tls/tls_main.c                                 |  4 +-
 net/tls/tls_sw.c                                   |  2 +-
 net/unix/af_unix.c                                 |  4 ++
 net/unix/unix_bpf.c                                |  2 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      | 75 ++++++----------------
 23 files changed, 118 insertions(+), 98 deletions(-)
