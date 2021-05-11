Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE5237B130
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 23:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhEKWA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:00:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:60114 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhEKWA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 18:00:57 -0400
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lgaPq-000AFW-Ln; Tue, 11 May 2021 23:59:46 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf 2021-05-11
Date:   Tue, 11 May 2021 23:59:46 +0200
Message-Id: <20210511215946.15578-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26167/Tue May 11 13:12:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 13 non-merge commits during the last 8 day(s) which contain
a total of 21 files changed, 817 insertions(+), 382 deletions(-).

The main changes are:

1) Fix multiple ringbuf bugs in particular to prevent writable mmap of
   read-only pages, from Andrii Nakryiko & Thadeu Lima de Souza Cascardo.

2) Fix verifier alu32 known-const subregister bound tracking for bitwise
   operations and/or/xor, from Daniel Borkmann.

3) Reject trampoline attachment for functions with variable arguments,
   and also add a deny list of other forbidden functions, from Jiri Olsa.

4) Fix nested bpf_bprintf_prepare() calls used by various helpers by
   switching to per-CPU buffers, from Florent Revest.

5) Fix kernel compilation with BTF debug info on ppc64 due to pahole
   missing TCP-CC functions like cubictcp_init, from Martin KaFai Lau.

6) Add a kconfig entry to provide an option to disallow unprivileged
   BPF by default, from Daniel Borkmann.

7) Fix libbpf compilation for older libelf when GELF_ST_VISIBILITY()
   macro is not available, from Arnaldo Carvalho de Melo.

8) Migrate test_tc_redirect to test_progs framework as prep work
   for upcoming skb_change_head() fix & selftest, from Jussi Maki.

9) Fix a libbpf segfault in add_dummy_ksym_var() if BTF is not
   present, from Ian Rogers.

10) Fix tx_only micro-benchmark in xdpsock BPF sample with proper frame
    size, from Magnus Karlsson.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, John Fastabend, Maciej Fijalkowski, 
Ryota Shiga, Manfred Paul, Thadeu Lima de Souza Cascardo

----------------------------------------------------------------

The following changes since commit 1682d8df20aa505f6ab12c76e934b26ede39c529:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2021-05-03 18:40:17 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 569c484f9995f489f2b80dd134269fe07d2b900d:

  bpf: Limit static tcp-cc functions in the .BTF_ids list to x86 (2021-05-11 23:23:07 +0200)

----------------------------------------------------------------
Andrii Nakryiko (1):
      bpf: Prevent writable memory-mapping of read-only ringbuf pages

Arnaldo Carvalho de Melo (1):
      libbpf: Provide GELF_ST_VISIBILITY() define for older libelf

Daniel Borkmann (3):
      bpf: Fix alu32 const subreg bound tracking on bitwise operations
      bpf, kconfig: Add consolidated menu entry for bpf with core options
      bpf: Add kconfig knob for disabling unpriv bpf by default

Florent Revest (1):
      bpf: Fix nested bpf_bprintf_prepare with more per-cpu buffers

Ian Rogers (1):
      libbpf: Add NULL check to add_dummy_ksym_var

Jiri Olsa (2):
      bpf: Forbid trampoline attach for functions with variable arguments
      bpf: Add deny list of btf ids check for tracing programs

Jussi Maki (1):
      selftests/bpf: Rewrite test_tc_redirect.sh as prog_tests/tc_redirect.c

Magnus Karlsson (1):
      samples/bpf: Consider frame size in tx_only of xdpsock sample

Martin KaFai Lau (1):
      bpf: Limit static tcp-cc functions in the .BTF_ids list to x86

Thadeu Lima de Souza Cascardo (1):
      bpf, ringbuf: Deny reserve of buffers larger than ringbuf

 Documentation/admin-guide/sysctl/kernel.rst        |  17 +-
 init/Kconfig                                       |  41 +-
 kernel/bpf/Kconfig                                 |  88 +++
 kernel/bpf/btf.c                                   |  12 +
 kernel/bpf/helpers.c                               |  27 +-
 kernel/bpf/ringbuf.c                               |  24 +-
 kernel/bpf/syscall.c                               |   3 +-
 kernel/bpf/verifier.c                              |  36 +-
 kernel/sysctl.c                                    |  29 +-
 net/Kconfig                                        |  27 -
 net/ipv4/bpf_tcp_ca.c                              |   2 +
 samples/bpf/xdpsock_user.c                         |   2 +-
 tools/lib/bpf/libbpf.c                             |   3 +
 tools/lib/bpf/libbpf_internal.h                    |   5 +
 tools/testing/selftests/bpf/network_helpers.c      |   2 +-
 tools/testing/selftests/bpf/network_helpers.h      |   1 +
 .../testing/selftests/bpf/prog_tests/tc_redirect.c | 589 +++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |  33 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c        |   9 +-
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |  33 +-
 tools/testing/selftests/bpf/test_tc_redirect.sh    | 216 --------
 21 files changed, 817 insertions(+), 382 deletions(-)
 create mode 100644 kernel/bpf/Kconfig
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_redirect.c
 delete mode 100755 tools/testing/selftests/bpf/test_tc_redirect.sh
