Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC34FA009
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 01:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235682AbiDHXTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 19:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDHXTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 19:19:51 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2C936E04;
        Fri,  8 Apr 2022 16:17:45 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ncxrK-000CuE-2f; Sat, 09 Apr 2022 01:17:42 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-04-09
Date:   Sat,  9 Apr 2022 01:17:41 +0200
Message-Id: <20220408231741.19116-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26506/Fri Apr  8 10:23:48 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 63 non-merge commits during the last 9 day(s) which contain
a total of 68 files changed, 4852 insertions(+), 619 deletions(-).

The main changes are:

1) Add libbpf support for USDT (User Statically-Defined Tracing) probes.
   USDTs are an abstraction built on top of uprobes, critical for tracing
   and BPF, and widely used in production applications, from Andrii Nakryiko.

2) While Andrii was adding support for x86{-64}-specific logic of parsing
   USDT argument specification, Ilya followed-up with USDT support for s390
   architecture, from Ilya Leoshkevich.

3) Support name-based attaching for uprobe BPF programs in libbpf. The format
   supported is `u[ret]probe/binary_path:[raw_offset|function[+offset]]`, e.g.
   attaching to libc malloc can be done in BPF via SEC("uprobe/libc.so.6:malloc")
   now, from Alan Maguire.

4) Various load/store optimizations for the arm64 JIT to shrink the image
   size by using arm64 str/ldr immediate instructions. Also enable pointer
   authentication to verify return address for JITed code, from Xu Kuohai.

5) BPF verifier fixes for write access checks to helper functions, e.g.
   rd-only memory from bpf_*_cpu_ptr() must not be passed to helpers that
   write into passed buffers, from Kumar Kartikeya Dwivedi.

6) Fix overly excessive stack map allocation for its base map structure and
   buckets which slipped-in from cleanups during the rlimit accounting removal
   back then, from Yuntao Wang.

7) Extend the unstable CT lookup helpers for XDP and tc/BPF to report netfilter
   connection tracking tuple direction, from Lorenzo Bianconi.

8) Improve bpftool dump to show BPF program/link type names, Milan Landaverde.

9) Minor cleanups all over the place from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Abaci Robot, Alan Maguire, Dave Marchevsky, Hao Luo, Hengqi Chen, Joanne 
Koong, Naresh Kamboju, Quentin Monnet, Shuah Khan, Yonghong Song

----------------------------------------------------------------

The following changes since commit 2975dbdc3989cd66a4cb5a7c5510de2de8ee4d14:

  Merge tag 'net-5.18-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-31 11:23:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to b45043192b3e481304062938a6561da2ceea46a6:

  bpf: Fix excessive memory allocation in stack_map_alloc() (2022-04-09 00:28:21 +0200)

----------------------------------------------------------------
Alan Maguire (8):
      libbpf: auto-resolve programs/libraries when necessary for uprobes
      libbpf: Support function name-based attach uprobes
      libbpf: Add auto-attach for uprobes based on section name
      selftests/bpf: Add tests for u[ret]probe attach by name
      selftests/bpf: Add tests for uprobe auto-attach via skeleton
      libbpf: Improve library identification for uprobe binary path resolution
      libbpf: Improve string parsing for uprobe auto-attach
      selftests/bpf: Uprobe tests should verify param/return values

Alexander Lobakin (1):
      samples: bpf: Fix linking xdp_router_ipv4 after migration

Alexei Starovoitov (1):
      Merge branch 'Add libbpf support for USDTs'

Andrii Nakryiko (17):
      Merge branch 'libbpf: name-based u[ret]probe attach'
      Merge branch 'bpf/bpftool: add program & link type names'
      libbpf: Add BPF-side of USDT support
      libbpf: Wire up USDT API and bpf_link integration
      libbpf: Add USDT notes parsing and resolution logic
      libbpf: Wire up spec management and other arch-independent USDT logic
      libbpf: Add x86-specific USDT arg spec parsing logic
      selftests/bpf: Add basic USDT selftests
      selftests/bpf: Add urandom_read shared lib and USDTs
      Merge branch 'libbpf: uprobe name-based attach followups'
      libbpf: Fix use #ifdef instead of #if to avoid compiler warning
      Merge branch 'Add USDT support for s390'
      libbpf: Use strlcpy() in path resolution fallback logic
      libbpf: Allow WEAK and GLOBAL bindings during BTF fixup
      libbpf: Don't error out on CO-RE relos for overriden weak subprogs
      libbpf: Use weak hidden modifier for USDT BPF-side API functions
      selftests/bpf: Add CO-RE relos into linked_funcs selftests

Artem Savkov (1):
      selftests/bpf: Use bpf_num_possible_cpus() in per-cpu map allocations

Colin Ian King (1):
      libbpf: Fix spelling mistake "libaries" -> "libraries"

Eyal Birger (1):
      selftests/bpf: Remove unused variable from bpf_sk_assign test

Haiyue Wang (1):
      bpf: Correct the comment for BTF kind bitfield

Haowen Bai (2):
      selftests/bpf: Return true/false (not 1/0) from bool functions
      libbpf: Potential NULL dereference in usdt_manager_attach_usdt()

Ilya Leoshkevich (5):
      selftests/bpf: Define SYS_NANOSLEEP_KPROBE_NAME for aarch64
      libbpf: Support Debian in resolve_full_path()
      libbpf: Minor style improvements in USDT code
      libbpf: Make BPF-side of USDT support work on big-endian machines
      libbpf: Add s390-specific USDT arg spec parsing logic

Jakob Koschel (1):
      bpf: Replace usage of supported with dedicated list iterator variable

Jiapeng Chong (1):
      bpf: Use swap() instead of open coding it

Kumar Kartikeya Dwivedi (5):
      bpf: Do write access check for kfunc and global func
      bpf: Check PTR_TO_MEM | MEM_RDONLY in check_helper_mem_access
      bpf: Reject writes for PTR_TO_MAP_KEY in check_helper_mem_access
      selftests/bpf: Test passing rdonly mem to global func
      selftests/bpf: Test for writes to map key from BPF helpers

Lorenzo Bianconi (3):
      samples: bpf: Convert xdp_router_ipv4 to XDP samples helper
      net: netfilter: Reports ct direction in CT lookup helpers for XDP and TC-BPF
      samples, bpf: Move routes monitor in xdp_router_ipv4 in a dedicated thread

Milan Landaverde (3):
      bpftool: Add syscall prog type
      bpftool: Add missing link types
      bpftool: Handle libbpf_probe_prog_type errors

Nikolay Borisov (1):
      selftests/bpf: Fix vfs_link kprobe definition

Quentin Monnet (1):
      selftests/bpf: Fix parsing of prog types in UAPI hdr for bpftool sync

Song Chen (1):
      sample: bpf: syscall_tp_user: Print result of verify_map

Xu Kuohai (6):
      arm64, insn: Add ldr/str with immediate offset
      bpf, arm64: Optimize BPF store/load using arm64 str/ldr(immediate offset)
      bpf, arm64: Adjust the offset of str/ldr(immediate) to positive number
      bpf, tests: Add tests for BPF_LDX/BPF_STX with different offsets
      bpf, tests: Add load store test case for tail call
      bpf, arm64: Sign return address for JITed code

Yauheni Kaliuta (1):
      bpf, test_offload.py: Skip base maps without names

Yuntao Wang (7):
      bpf: Remove redundant assignment to smap->map.value_size
      selftests/bpf: Fix cd_flavor_subdir() of test_progs
      libbpf: Don't return -EINVAL if hdr_len < offsetofend(core_relo_len)
      selftests/bpf: Fix file descriptor leak in load_kallsyms()
      selftests/bpf: Fix issues in parse_num_list()
      selftests/bpf: Fix return value checks in perf_event_stackmap test
      bpf: Fix excessive memory allocation in stack_map_alloc()

 arch/arm64/include/asm/insn.h                      |    9 +
 arch/arm64/lib/insn.c                              |   67 +-
 arch/arm64/net/bpf_jit.h                           |   17 +
 arch/arm64/net/bpf_jit_comp.c                      |  255 +++-
 include/uapi/linux/btf.h                           |    4 +-
 kernel/bpf/bpf_iter.c                              |   30 +-
 kernel/bpf/stackmap.c                              |    2 -
 kernel/bpf/verifier.c                              |   61 +-
 kernel/trace/bpf_trace.c                           |    6 +-
 lib/test_bpf.c                                     |  315 ++++-
 net/netfilter/nf_conntrack_bpf.c                   |   22 +-
 samples/bpf/Makefile                               |   10 +-
 samples/bpf/syscall_tp_user.c                      |    3 +
 samples/bpf/xdp_router_ipv4.bpf.c                  |  180 +++
 samples/bpf/xdp_router_ipv4_kern.c                 |  186 ---
 samples/bpf/xdp_router_ipv4_user.c                 |  455 +++----
 tools/bpf/bpftool/feature.c                        |    2 +-
 tools/bpf/bpftool/link.c                           |    3 +
 tools/bpf/bpftool/prog.c                           |    1 +
 tools/include/uapi/linux/btf.h                     |    4 +-
 tools/lib/bpf/Build                                |    3 +-
 tools/lib/bpf/Makefile                             |    2 +-
 tools/lib/bpf/btf.c                                |    6 +-
 tools/lib/bpf/libbpf.c                             |  488 ++++++-
 tools/lib/bpf/libbpf.h                             |   41 +-
 tools/lib/bpf/libbpf.map                           |    1 +
 tools/lib/bpf/libbpf_internal.h                    |   30 +
 tools/lib/bpf/usdt.bpf.h                           |  259 ++++
 tools/lib/bpf/usdt.c                               | 1335 ++++++++++++++++++++
 tools/testing/selftests/bpf/Makefile               |   25 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   85 +-
 tools/testing/selftests/bpf/prog_tests/for_each.c  |   12 +
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |   17 +-
 tools/testing/selftests/bpf/prog_tests/netcnt.c    |    2 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |    1 +
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |   49 +
 tools/testing/selftests/bpf/prog_tests/usdt.c      |  421 ++++++
 .../bpf/progs/for_each_map_elem_write_key.c        |   27 +
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |    8 +
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |    8 +
 .../selftests/bpf/progs/perf_event_stackmap.c      |    4 +-
 tools/testing/selftests/bpf/progs/profiler.inc.h   |    5 +-
 .../selftests/bpf/progs/test_attach_probe.c        |   41 +-
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |    4 +-
 .../selftests/bpf/progs/test_global_func17.c       |   16 +
 .../bpf/progs/test_ksyms_btf_write_check.c         |   18 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |    2 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |    4 +-
 .../selftests/bpf/progs/test_task_pt_regs.c        |    2 +-
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |   73 ++
 .../selftests/bpf/progs/test_urandom_usdt.c        |   70 +
 tools/testing/selftests/bpf/progs/test_usdt.c      |   96 ++
 .../selftests/bpf/progs/test_usdt_multispec.c      |   32 +
 .../selftests/bpf/progs/test_xdp_noinline.c        |   12 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |    2 +-
 tools/testing/selftests/bpf/sdt-config.h           |    6 +
 tools/testing/selftests/bpf/sdt.h                  |  513 ++++++++
 .../selftests/bpf/test_bpftool_synctypes.py        |    2 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c  |    3 +-
 tools/testing/selftests/bpf/test_offload.py        |    2 +-
 tools/testing/selftests/bpf/test_progs.c           |    6 +-
 tools/testing/selftests/bpf/test_progs.h           |    2 +
 tools/testing/selftests/bpf/testing_helpers.c      |    2 +-
 tools/testing/selftests/bpf/trace_helpers.c        |    9 +-
 tools/testing/selftests/bpf/urandom_read.c         |   63 +-
 tools/testing/selftests/bpf/urandom_read_aux.c     |    9 +
 tools/testing/selftests/bpf/urandom_read_lib1.c    |   13 +
 tools/testing/selftests/bpf/urandom_read_lib2.c    |    8 +
 68 files changed, 4852 insertions(+), 619 deletions(-)
 create mode 100644 samples/bpf/xdp_router_ipv4.bpf.c
 delete mode 100644 samples/bpf/xdp_router_ipv4_kern.c
 create mode 100644 tools/lib/bpf/usdt.bpf.h
 create mode 100644 tools/lib/bpf/usdt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/usdt.c
 create mode 100644 tools/testing/selftests/bpf/progs/for_each_map_elem_write_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func17.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_urandom_usdt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_usdt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_usdt_multispec.c
 create mode 100644 tools/testing/selftests/bpf/sdt-config.h
 create mode 100644 tools/testing/selftests/bpf/sdt.h
 create mode 100644 tools/testing/selftests/bpf/urandom_read_aux.c
 create mode 100644 tools/testing/selftests/bpf/urandom_read_lib1.c
 create mode 100644 tools/testing/selftests/bpf/urandom_read_lib2.c
