Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1573979D
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbfFGVTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:19:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:57894 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbfFGVTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:19:23 -0400
Received: from [178.197.248.32] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZMGd-0002UZ-9j; Fri, 07 Jun 2019 23:19:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2019-06-07
Date:   Fri,  7 Jun 2019 23:19:18 +0200
Message-Id: <20190607211918.23744-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25473/Fri Jun  7 10:00:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net* tree.

The main changes are:

1) Fix several bugs in riscv64 JIT code emission which forgot to clear high
   32-bits for alu32 ops, from Björn and Luke with selftests covering all
   relevant BPF alu ops from Björn and Jiong.

2) Two fixes for UDP BPF reuseport that avoid calling the program in case of
   __udp6_lib_err and UDP GRO which broke reuseport_select_sock() assumption
   that skb->data is pointing to transport header, from Martin.

3) Two fixes for BPF sockmap: a use-after-free from sleep in psock's backlog
   workqueue, and a missing restore of sk_write_space when psock gets dropped,
   from Jakub and John.

4) Fix unconnected UDP sendmsg hook API which is insufficient as-is since it
   breaks standard applications like DNS if reverse NAT is not performed upon
   receive, from Daniel.

5) Fix an out-of-bounds read in __bpf_skc_lookup which in case of AF_INET6
   fails to verify that the length of the tuple is long enough, from Lorenz.

6) Fix libbpf's libbpf__probe_raw_btf to return an fd instead of 0/1 (for
   {un,}successful probe) as that is expected to be propagated as an fd to
   load_sk_storage_btf() and thus closing the wrong descriptor otherwise,
   from Michal.

7) Fix bpftool's JSON output for the case when a lookup fails, from Krzesimir.

8) Minor misc fixes in docs, samples and selftests, from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

----------------------------------------------------------------

The following changes since commit af8f3fb7fb077c9df9fed97113a031e792163def:

  net: stmmac: dma channel control register need to be init first (2019-05-20 20:55:39 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 4aeba328019ab9fbaad725b923b4c11c3725b24e:

  Merge branch 'fix-unconnected-udp' (2019-06-06 16:53:13 -0700)

----------------------------------------------------------------
Alakesh Haloi (1):
      selftests: bpf: fix compiler warning in flow_dissector test

Alexei Starovoitov (2):
      Merge branch 'reuseport-fixes'
      Merge branch 'fix-unconnected-udp'

Björn Töpel (2):
      bpf, riscv: clear target register high 32-bits for and/or/xor on ALU32
      selftests: bpf: add zero extend checks for ALU32 and/or/xor

Chang-Hsien Tsai (1):
      samples, bpf: fix to change the buffer size for read()

Daniel Borkmann (7):
      Merge branch 'bpf-subreg-tests'
      bpf: fix unconnected udp hooks
      bpf: sync tooling uapi header
      bpf, libbpf: enable recvmsg attach types
      bpf, bpftool: enable recvmsg attach types
      bpf: more msg_name rewrite tests to test_sock_addr
      bpf: expand section tests for test_section_names

Hangbin Liu (1):
      selftests/bpf: move test_lirc_mode2_user to TEST_GEN_PROGS_EXTENDED

Jakub Sitnicki (1):
      bpf: sockmap, restore sk_write_space when psock gets dropped

Jiong Wang (2):
      selftests: bpf: move sub-register zero extension checks into subreg.c
      selftests: bpf: complete sub-register zero extension checks

John Fastabend (1):
      bpf: sockmap, fix use after free from sleep in psock backlog workqueue

Krzesimir Nowak (1):
      tools: bpftool: Fix JSON output when lookup fails

Lorenz Bauer (1):
      bpf: fix out-of-bounds read in __bpf_skc_lookup

Luke Nelson (1):
      bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh

Martin KaFai Lau (3):
      bpf: Check sk_fullsock() before returning from bpf_sk_lookup()
      bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err
      bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro

Matteo Croce (1):
      samples, bpf: suppress compiler warning

Michal Rostecki (1):
      libbpf: Return btf_fd for load_sk_storage_btf

Randy Dunlap (1):
      Documentation/networking: fix af_xdp.rst Sphinx warnings

 Documentation/networking/af_xdp.rst                |   8 +-
 arch/riscv/net/bpf_jit_comp.c                      |  24 +
 include/linux/bpf-cgroup.h                         |   8 +
 include/linux/skmsg.h                              |   2 +
 include/uapi/linux/bpf.h                           |   2 +
 kernel/bpf/syscall.c                               |   8 +
 kernel/bpf/verifier.c                              |  12 +-
 net/core/filter.c                                  |  26 +-
 net/core/skbuff.c                                  |   1 +
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/udp.c                                     |   8 +-
 samples/bpf/bpf_load.c                             |   2 +-
 samples/bpf/task_fd_query_user.c                   |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   6 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   5 +-
 tools/bpf/bpftool/cgroup.c                         |   5 +-
 tools/bpf/bpftool/map.c                            |   2 +
 tools/bpf/bpftool/prog.c                           |   3 +-
 tools/include/uapi/linux/bpf.h                     |   2 +
 tools/lib/bpf/libbpf.c                             |  32 +-
 tools/lib/bpf/libbpf_internal.h                    |   4 +-
 tools/lib/bpf/libbpf_probes.c                      |  13 +-
 tools/testing/selftests/bpf/Makefile               |   7 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   1 +
 tools/testing/selftests/bpf/test_section_names.c   |  10 +
 tools/testing/selftests/bpf/test_sock_addr.c       | 213 +++++++-
 tools/testing/selftests/bpf/verifier/subreg.c      | 533 +++++++++++++++++++++
 28 files changed, 887 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/subreg.c
