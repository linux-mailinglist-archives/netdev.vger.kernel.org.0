Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B727B65E148
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 01:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjAEAJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 19:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjAEAJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 19:09:32 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB2C42E37;
        Wed,  4 Jan 2023 16:09:30 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pDDp0-0005nv-Tf; Thu, 05 Jan 2023 01:09:26 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-01-04
Date:   Thu,  5 Jan 2023 01:09:26 +0100
Message-Id: <20230105000926.31350-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26771/Wed Jan  4 09:47:43 2023)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 45 non-merge commits during the last 21 day(s) which contain
a total of 50 files changed, 1454 insertions(+), 375 deletions(-).

The main changes are:

1) Fixes, improvements and refactoring of parts of BPF verifier's state equivalence
   checks, from Andrii Nakryiko.

2) Fix a few corner cases in libbpf's BTF-to-C converter in particular around padding
   handling and enums, also from Andrii Nakryiko.

3) Add BPF_F_NO_TUNNEL_KEY extension to bpf_skb_set_tunnel_key to better support decap
   on GRE tunnel devices not operating in collect metadata, from Christian Ehrig.

4) Improve x86 JIT's codegen for PROBE_MEM runtime error checks, from Dave Marchevsky.

5) Remove the need for trace_printk_lock for bpf_trace_printk and bpf_trace_vprintk
   helpers, from Jiri Olsa.

6) Add proper documentation for BPF_MAP_TYPE_SOCK{MAP,HASH} maps, from Maryam Tahhan.

7) Improvements in libbpf's btf_parse_elf error handling, from Changbin Du.

8) Bigger batch of improvements to BPF tracing code samples, from Daniel T. Lee.

9) Add LoongArch support to libbpf's bpf_tracing helper header, from Hengqi Chen.

10) Fix a libbpf compiler warning in perf_event_open_probe on arm32, from Khem Raj.

11) Optimize bpf_local_storage_elem by removing 56 bytes of padding, from Martin KaFai Lau.

12) Use pkg-config to locate libelf for resolve_btfids build, from Shen Jiamin.

13) Various libbpf improvements around API documentation and errno handling, from Xin Liu.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Bagas Sanjaya, David Vernet, Eduard Zingerman, Hao Sun, 
Huacai Chen, Jakub Sitnicki, Jiri Olsa, John Fastabend, Per Sundström 
XP, Quentin Monnet, Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91:

  Merge tag 'net-next-6.2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2022-12-13 15:47:48 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to acd3b7768048fe338248cdf43ccfbf8c084a6bc1:

  libbpf: Return -ENODATA for missing btf section (2023-01-03 14:27:42 -0800)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (1):
      libbpf: Restore errno after pr_warn.

Andrii Nakryiko (16):
      libbpf: Fix single-line struct definition output in btf_dump
      libbpf: Handle non-standardly sized enums better in BTF-to-C dumper
      selftests/bpf: Add non-standardly sized enum tests for btf_dump
      libbpf: Fix btf__align_of() by taking into account field offsets
      libbpf: Fix BTF-to-C converter's padding logic
      selftests/bpf: Add few corner cases to test padding handling of btf_dump
      libbpf: Fix btf_dump's packed struct determination
      Merge branch 'bpftool: improve error handing for missing .BTF section'
      libbpf: start v1.2 development cycle
      bpf: teach refsafe() to take into account ID remapping
      bpf: reorganize struct bpf_reg_state fields
      bpf: generalize MAYBE_NULL vs non-MAYBE_NULL rule
      bpf: reject non-exact register type matches in regsafe()
      bpf: perform byte-by-byte comparison only when necessary in regsafe()
      bpf: fix regs_exact() logic in regsafe() to remap IDs correctly
      Merge branch 'samples/bpf: enhance syscall tracing program'

Changbin Du (3):
      libbpf: Show error info about missing ".BTF" section
      bpf: makefiles: Do not generate empty vmlinux.h
      libbpf: Return -ENODATA for missing btf section

Christian Ehrig (2):
      bpf: Add flag BPF_F_NO_TUNNEL_KEY to bpf_skb_set_tunnel_key()
      selftests/bpf: Add BPF_F_NO_TUNNEL_KEY test

Daniel Borkmann (1):
      selftests/bpf: Add jit probe_mem corner case tests to s390x denylist

Daniel T. Lee (9):
      samples/bpf: remove unused function with test_lru_dist
      samples/bpf: replace meaningless counter with tracex4
      samples/bpf: fix uninitialized warning with test_current_task_under_cgroup
      samples/bpf: Use kyscall instead of kprobe in syscall tracing program
      samples/bpf: Use vmlinux.h instead of implicit headers in syscall tracing program
      samples/bpf: Change _kern suffix to .bpf with syscall tracing program
      samples/bpf: Fix tracex2 by using BPF_KSYSCALL macro
      samples/bpf: Use BPF_KSYSCALL macro in syscall tracing programs
      libbpf: Fix invalid return address register in s390

Dave Marchevsky (3):
      bpf, x86: Improve PROBE_MEM runtime load check
      selftests/bpf: Add verifier test exercising jit PROBE_MEM logic
      bpf: rename list_head -> graph_root in field info types

Hengqi Chen (1):
      libbpf: Add LoongArch support to bpf_tracing.h

Jiri Olsa (3):
      bpf: Add struct for bin_args arg in bpf_bprintf_prepare
      bpf: Do cleanup in bpf_bprintf_cleanup only when needed
      bpf: Remove trace_printk_lock

Khem Raj (1):
      libbpf: Fix build warning on ref_ctr_off for 32-bit architectures

Martin KaFai Lau (2):
      Merge branch 'samples/bpf: fix LLVM compilation warning'
      bpf: Reduce smap->elem_size

Maryam Tahhan (1):
      docs: BPF_MAP_TYPE_SOCK[MAP|HASH]

Ricardo Ribalda (1):
      bpf: Remove unused field initialization in bpf's ctl_table

Shen Jiamin (1):
      tools/resolve_btfids: Use pkg-config to locate libelf

Xin Liu (3):
      libbpf: Optimized return value in libbpf_strerror when errno is libbpf errno
      libbpf: fix errno is overwritten after being closed.
      libbpf: Added the description of some API functions

 Documentation/bpf/map_sockmap.rst                  | 498 +++++++++++++++++++++
 arch/x86/net/bpf_jit_comp.c                        |  70 +--
 include/linux/bpf.h                                |  16 +-
 include/linux/bpf_verifier.h                       |  40 +-
 include/uapi/linux/bpf.h                           |   4 +
 kernel/bpf/bpf_local_storage.c                     |   4 +-
 kernel/bpf/btf.c                                   |  21 +-
 kernel/bpf/helpers.c                               |  71 +--
 kernel/bpf/syscall.c                               |   1 -
 kernel/bpf/verifier.c                              | 153 ++++---
 kernel/trace/bpf_trace.c                           |  56 ++-
 net/core/filter.c                                  |   5 +-
 samples/bpf/Makefile                               |  10 +-
 samples/bpf/gnu/stubs.h                            |   1 +
 .../{map_perf_test_kern.c => map_perf_test.bpf.c}  |  48 +-
 samples/bpf/map_perf_test_user.c                   |   2 +-
 ...kern.c => test_current_task_under_cgroup.bpf.c} |  11 +-
 samples/bpf/test_current_task_under_cgroup_user.c  |   8 +-
 samples/bpf/test_lru_dist.c                        |   5 -
 samples/bpf/test_map_in_map_kern.c                 |   1 -
 ...ite_user_kern.c => test_probe_write_user.bpf.c} |  20 +-
 samples/bpf/test_probe_write_user_user.c           |   2 +-
 samples/bpf/trace_common.h                         |  13 -
 .../{trace_output_kern.c => trace_output.bpf.c}    |   6 +-
 samples/bpf/trace_output_user.c                    |   2 +-
 samples/bpf/{tracex2_kern.c => tracex2.bpf.c}      |  13 +-
 samples/bpf/tracex2_user.c                         |   2 +-
 samples/bpf/tracex4_user.c                         |   4 +-
 tools/bpf/bpftool/Makefile                         |   3 +
 tools/bpf/resolve_btfids/Makefile                  |   8 +-
 tools/include/uapi/linux/bpf.h                     |   4 +
 tools/lib/bpf/bpf_tracing.h                        |  25 +-
 tools/lib/bpf/btf.c                                |  16 +-
 tools/lib/bpf/btf_dump.c                           | 199 +++++---
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/lib/bpf/libbpf.h                             |  29 +-
 tools/lib/bpf/libbpf.map                           |   3 +
 tools/lib/bpf/libbpf_errno.c                       |  16 +-
 tools/lib/bpf/libbpf_internal.h                    |   1 +
 tools/lib/bpf/libbpf_version.h                     |   2 +-
 tools/testing/selftests/bpf/DENYLIST.s390x         |   1 +
 tools/testing/selftests/bpf/Makefile               |   3 +
 .../selftests/bpf/prog_tests/jit_probe_mem.c       |  28 ++
 .../bpf/progs/btf_dump_test_case_bitfields.c       |   2 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |  80 +++-
 .../bpf/progs/btf_dump_test_case_padding.c         | 162 ++++++-
 .../bpf/progs/btf_dump_test_case_syntax.c          |  36 ++
 tools/testing/selftests/bpf/progs/jit_probe_mem.c  |  61 +++
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |  21 +
 tools/testing/selftests/bpf/test_tunnel.sh         |  40 +-
 50 files changed, 1454 insertions(+), 375 deletions(-)
 create mode 100644 Documentation/bpf/map_sockmap.rst
 create mode 100644 samples/bpf/gnu/stubs.h
 rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
 rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
 rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
 delete mode 100644 samples/bpf/trace_common.h
 rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
 rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/jit_probe_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/jit_probe_mem.c
