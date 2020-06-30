Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FED20FE4D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgF3VAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:00:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:43670 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgF3VAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:00:11 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jqNMP-0000mb-0F; Tue, 30 Jun 2020 23:00:09 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2020-06-30
Date:   Tue, 30 Jun 2020 23:00:08 +0200
Message-Id: <20200630210008.16989-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25859/Tue Jun 30 15:38:05 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

We've added 28 non-merge commits during the last 9 day(s) which contain
a total of 35 files changed, 486 insertions(+), 232 deletions(-).

The main changes are:

1) Fix an incorrect verifier branch elimination for PTR_TO_BTF_ID pointer
   types, from Yonghong Song.

2) Fix UAPI for sockmap and flow_dissector progs that were ignoring various
   arguments passed to BPF_PROG_{ATTACH,DETACH}, from Lorenz Bauer & Jakub Sitnicki.

3) Fix broken AF_XDP DMA hacks that are poking into dma-direct and swiotlb
   internals and integrate it properly into DMA core, from Christoph Hellwig.

4) Fix RCU splat from recent changes to avoid skipping ingress policy when
   kTLS is enabled, from John Fastabend.

5) Fix BPF ringbuf map to enforce size to be the power of 2 in order for its
   position masking to work, from Andrii Nakryiko.

6) Fix regression from CAP_BPF work to re-allow CAP_SYS_ADMIN for loading
   of network programs, from Maciej Żenczykowski.

7) Fix libbpf section name prefix for devmap progs, from Jesper Dangaard Brouer.

8) Fix formatting in UAPI documentation for BPF helpers, from Quentin Monnet.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Jakub Sitnicki, John Fastabend, John Stultz, kernel 
test robot, Martin KaFai Lau, Song Liu, Wenbo Zhang, Yonghong Song

----------------------------------------------------------------

The following changes since commit b0c34bde72a59c05e826bf0a5aeca0d73f38f791:

  MAINTAINERS: update email address for Felix Fietkau (2020-06-22 12:57:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to d923021c2ce12acb50dc7086a1bf66eed82adf6a:

  bpf: Add tests for PTR_TO_BTF_ID vs. null comparison (2020-06-30 22:21:29 +0200)

----------------------------------------------------------------
Alexei Starovoitov (3):
      Merge branch 'fix-sockmap'
      Merge branch 'bpf-multi-prog-prep'
      Merge branch 'fix-sockmap-flow_dissector-uapi'

Andrii Nakryiko (3):
      libbpf: Forward-declare bpf_stats_type for systems with outdated UAPI headers
      libbpf: Fix CO-RE relocs against .text section
      bpf: Enforce BPF ringbuf size to be the power of 2

Christoph Hellwig (4):
      dma-mapping: Add a new dma_need_sync API
      xsk: Replace the cheap_dma flag with a dma_need_sync flag
      xsk: Remove a double pool->dev assignment in xp_dma_map
      xsk: Use dma_need_sync instead of reimplenting it

Jakub Sitnicki (5):
      flow_dissector: Pull BPF program assignment up to bpf-netns
      bpf, netns: Keep attached programs in bpf_prog_array
      bpf, netns: Keep a list of attached bpf_link's
      selftests/bpf: Test updating flow_dissector link with same program
      bpf, netns: Fix use-after-free in pernet pre_exit callback

Jesper Dangaard Brouer (1):
      libbpf: Adjust SEC short cut for expected attach type BPF_XDP_DEVMAP

John Fastabend (4):
      bpf: Do not allow btf_ctx_access with __int128 types
      bpf, sockmap: RCU splat with redirect and strparser error or TLS
      bpf, sockmap: RCU dereferenced psock may be used outside RCU block
      bpf, sockmap: Add ingres skb tests that utilize merge skbs

Lorenz Bauer (6):
      bpf: flow_dissector: Check value of unused flags to BPF_PROG_ATTACH
      bpf: flow_dissector: Check value of unused flags to BPF_PROG_DETACH
      bpf: sockmap: Check value of unused args to BPF_PROG_ATTACH
      bpf: sockmap: Require attach_bpf_fd when detaching a program
      selftests: bpf: Pass program and target_fd in flow_dissector_reattach
      selftests: bpf: Pass program to bpf_prog_detach in flow_dissector

Maciej Żenczykowski (1):
      bpf: Restore behaviour of CAP_SYS_ADMIN allowing the loading of networking bpf programs

Quentin Monnet (1):
      bpf: Fix formatting in documentation for BPF helpers

Yonghong Song (3):
      bpf: Set the number of exception entries properly for subprograms
      bpf: Fix an incorrect branch elimination by verifier
      bpf: Add tests for PTR_TO_BTF_ID vs. null comparison

 Documentation/core-api/dma-api.rst                 |   8 +
 include/linux/bpf-netns.h                          |   5 +-
 include/linux/bpf.h                                |  13 +-
 include/linux/btf.h                                |   5 +
 include/linux/dma-direct.h                         |   1 +
 include/linux/dma-mapping.h                        |   5 +
 include/linux/skmsg.h                              |  13 ++
 include/net/flow_dissector.h                       |   3 +-
 include/net/netns/bpf.h                            |   7 +-
 include/net/xsk_buff_pool.h                        |   6 +-
 include/uapi/linux/bpf.h                           |  41 ++---
 kernel/bpf/btf.c                                   |   4 +-
 kernel/bpf/net_namespace.c                         | 194 ++++++++++++++-------
 kernel/bpf/ringbuf.c                               |  18 +-
 kernel/bpf/syscall.c                               |   8 +-
 kernel/bpf/verifier.c                              |  13 +-
 kernel/dma/direct.c                                |   6 +
 kernel/dma/mapping.c                               |  10 ++
 net/bpf/test_run.c                                 |  19 +-
 net/core/flow_dissector.c                          |  32 ++--
 net/core/skmsg.c                                   |  23 ++-
 net/core/sock_map.c                                |  53 +++++-
 net/xdp/xsk_buff_pool.c                            |  54 +-----
 tools/include/uapi/linux/bpf.h                     |  41 ++---
 tools/lib/bpf/bpf.h                                |   2 +
 tools/lib/bpf/libbpf.c                             |  10 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c        |   2 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   4 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |  44 +++--
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |   2 +-
 tools/testing/selftests/bpf/progs/fentry_test.c    |  22 +++
 tools/testing/selftests/bpf/progs/fexit_test.c     |  22 +++
 .../selftests/bpf/progs/test_sockmap_kern.h        |   8 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |   2 +-
 tools/testing/selftests/bpf/test_sockmap.c         |  18 ++
 35 files changed, 486 insertions(+), 232 deletions(-)
