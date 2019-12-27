Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937D512B9CD
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfL0SI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:08:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:58480 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfL0SIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 13:08:25 -0500
Received: from [185.105.41.29] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iku26-0002cY-6M; Fri, 27 Dec 2019 19:08:18 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, bjorn.topel@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-12-27
Date:   Fri, 27 Dec 2019 19:08:17 +0100
Message-Id: <20191227180817.30438-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25676/Fri Dec 27 11:04:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 127 non-merge commits during the last 17 day(s) which contain
a total of 110 files changed, 6901 insertions(+), 2721 deletions(-).

There are three merge conflicts. Conflicts and resolution looks as follows:

1) Merge conflict in net/bpf/test_run.c:

There was a tree-wide cleanup c593642c8be0 ("treewide: Use sizeof_field() macro")
which gets in the way with b590cb5f802d ("bpf: Switch to offsetofend in
BPF_PROG_TEST_RUN"):

  <<<<<<< HEAD
          if (!range_is_zero(__skb, offsetof(struct __sk_buff, priority) +
                             sizeof_field(struct __sk_buff, priority),
  =======
          if (!range_is_zero(__skb, offsetofend(struct __sk_buff, priority),
  >>>>>>> 7c8dce4b166113743adad131b5a24c4acc12f92c

There are a few occasions that look similar to this. Always take the chunk with
offsetofend(). Note that there is one where the fields differ in here:

  <<<<<<< HEAD
          if (!range_is_zero(__skb, offsetof(struct __sk_buff, tstamp) +
                             sizeof_field(struct __sk_buff, tstamp),
  =======
          if (!range_is_zero(__skb, offsetofend(struct __sk_buff, gso_segs),
  >>>>>>> 7c8dce4b166113743adad131b5a24c4acc12f92c

Just take the one with offsetofend() /and/ gso_segs. Latter is correct due to
850a88cc4096 ("bpf: Expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_RUN").

2) Merge conflict in arch/riscv/net/bpf_jit_comp.c:

(I'm keeping Bjorn in Cc here for a double-check in case I got it wrong.)

  <<<<<<< HEAD
          if (is_13b_check(off, insn))
                  return -1;
          emit(rv_blt(tcc, RV_REG_ZERO, off >> 1), ctx);
  =======
          emit_branch(BPF_JSLT, RV_REG_T1, RV_REG_ZERO, off, ctx);
  >>>>>>> 7c8dce4b166113743adad131b5a24c4acc12f92c

Result should look like:

          emit_branch(BPF_JSLT, tcc, RV_REG_ZERO, off, ctx);

3) Merge conflict in arch/riscv/include/asm/pgtable.h:

  <<<<<<< HEAD
  =======
  #define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
  #define VMALLOC_END      (PAGE_OFFSET - 1)
  #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
  
  #define BPF_JIT_REGION_SIZE     (SZ_128M)
  #define BPF_JIT_REGION_START    (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
  #define BPF_JIT_REGION_END      (VMALLOC_END)
  
  /*
   * Roughly size the vmemmap space to be large enough to fit enough
   * struct pages to map half the virtual address space. Then
   * position vmemmap directly below the VMALLOC region.
   */
  #define VMEMMAP_SHIFT \
          (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
  #define VMEMMAP_SIZE    BIT(VMEMMAP_SHIFT)
  #define VMEMMAP_END     (VMALLOC_START - 1)
  #define VMEMMAP_START   (VMALLOC_START - VMEMMAP_SIZE)
  
  #define vmemmap         ((struct page *)VMEMMAP_START)
  
  >>>>>>> 7c8dce4b166113743adad131b5a24c4acc12f92c

Only take the BPF_* defines from there and move them higher up in the
same file. Remove the rest from the chunk. The VMALLOC_* etc defines
got moved via 01f52e16b868 ("riscv: define vmemmap before pfn_to_page
calls"). Result:

  [...]
  #define __S101  PAGE_READ_EXEC
  #define __S110  PAGE_SHARED_EXEC
  #define __S111  PAGE_SHARED_EXEC
  
  #define VMALLOC_SIZE     (KERN_VIRT_SIZE >> 1)
  #define VMALLOC_END      (PAGE_OFFSET - 1)
  #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
  
  #define BPF_JIT_REGION_SIZE     (SZ_128M)
  #define BPF_JIT_REGION_START    (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
  #define BPF_JIT_REGION_END      (VMALLOC_END)
  
  /*
   * Roughly size the vmemmap space to be large enough to fit enough
   * struct pages to map half the virtual address space. Then
   * position vmemmap directly below the VMALLOC region.
   */
  #define VMEMMAP_SHIFT \
          (CONFIG_VA_BITS - PAGE_SHIFT - 1 + STRUCT_PAGE_MAX_SHIFT)
  #define VMEMMAP_SIZE    BIT(VMEMMAP_SHIFT)
  #define VMEMMAP_END     (VMALLOC_START - 1)
  #define VMEMMAP_START   (VMALLOC_START - VMEMMAP_SIZE)
  
  [...]

Let me know if there are any other issues.

Anyway, the main changes are:

1) Extend bpftool to produce a struct (aka "skeleton") tailored and specific
   to a provided BPF object file. This provides an alternative, simplified API
   compared to standard libbpf interaction. Also, add libbpf extern variable
   resolution for .kconfig section to import Kconfig data, from Andrii Nakryiko.

2) Add BPF dispatcher for XDP which is a mechanism to avoid indirect calls by
   generating a branch funnel as discussed back in bpfconf'19 at LSF/MM. Also,
   add various BPF riscv JIT improvements, from Björn Töpel.

3) Extend bpftool to allow matching BPF programs and maps by name,
   from Paul Chaignon.

4) Support for replacing cgroup BPF programs attached with BPF_F_ALLOW_MULTI
   flag for allowing updates without service interruption, from Andrey Ignatov.

5) Cleanup and simplification of ring access functions for AF_XDP with a
   bonus of 0-5% performance improvement, from Magnus Karlsson.

6) Enable BPF JITs for x86-64 and arm64 by default. Also, final version of
   audit support for BPF, from Daniel Borkmann and latter with Jiri Olsa.

7) Move and extend test_select_reuseport into BPF program tests under
   BPF selftests, from Jakub Sitnicki.

8) Various BPF sample improvements for xdpsock for customizing parameters
   to set up and benchmark AF_XDP, from Jay Jayatheerthan.

9) Improve libbpf to provide a ulimit hint on permission denied errors.
   Also change XDP sample programs to attach in driver mode by default,
   from Toke Høiland-Jørgensen.

10) Extend BPF test infrastructure to allow changing skb mark from tc BPF
    programs, from Nikita V. Shirokov.

11) Optimize prologue code sequence in BPF arm32 JIT, from Russell King.

12) Fix xdp_redirect_cpu BPF sample to manually attach to tracepoints after
    libbpf conversion, from Jesper Dangaard Brouer.

13) Minor misc improvements from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Andrii Narkyiko, Björn Töpel, David 
Ahern, Jesper Dangaard Brouer, Justin Forbes, Luke Nelson, Martin KaFai 
Lau, Naresh Kamboju, Nikita Shirokov, Paul Moore, Quentin Monnet, Toke 
Høiland-Jørgensen, Will Deacon, Yonghong Song

----------------------------------------------------------------

The following changes since commit c21939998802b48e7afd0c0568193f6e4e4954f8:

  cxgb4: add support for high priority filters (2019-12-10 17:52:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 7c8dce4b166113743adad131b5a24c4acc12f92c:

  bpftool: Make skeleton C code compilable with C++ compiler (2019-12-27 10:11:05 +0100)

----------------------------------------------------------------
Aditya Pakki (1):
      bpf: Remove unnecessary assertion on fp_old

Alexei Starovoitov (13):
      Merge branch 'reuseport_to_test_progs'
      Merge branch 'bpf-dispatcher'
      Merge branch 'bpftool-match-by-name'
      Merge branch 'bpf-obj-skel'
      Merge branch 'extern-var-support'
      Merge branch 'support-flex-arrays'
      Merge branch 'skel-fixes'
      Merge branch 'libbpf-extern-followups'
      selftests/bpf: Fix test_attach_probe
      Merge branch 'simplify-do_redirect'
      Merge branch 'replace-cg_bpf-prog'
      Merge branch 'xsk-cleanup'
      Merge branch 'xdpsock'

Andrey Ignatov (7):
      bpf: Simplify __cgroup_bpf_attach
      bpf: Remove unused new_flags in hierarchy_allows_attach()
      bpf: Support replacing cgroup-bpf program in MULTI mode
      libbpf: Introduce bpf_prog_attach_xattr
      selftests/bpf: Convert test_cgroup_attach to prog_tests
      selftests/bpf: Test BPF_F_REPLACE in cgroup_attach_multi
      selftests/bpf: Preserve errno in test_progs CHECK macros

Andrii Nakryiko (44):
      libbpf: Bump libpf current version to v0.0.7
      libbpf: Fix printf compilation warnings on ppc64le arch
      libbpf: Extract and generalize CPU mask parsing logic
      selftests/bpf: Add CPU mask parsing tests
      libbpf: Don't attach perf_buffer to offline/missing CPUs
      selftests/bpf: Fix perf_buffer test on systems w/ offline CPUs
      libbpf: Don't require root for bpf_object__open()
      libbpf: Add generic bpf_program__attach()
      libbpf: Move non-public APIs from libbpf.h to libbpf_internal.h
      libbpf: Add BPF_EMBED_OBJ macro for embedding BPF .o files
      libbpf: Extract common user-facing helpers
      libbpf: Expose btf__align_of() API
      libbpf: Expose BTF-to-C type declaration emitting API
      libbpf: Expose BPF program's function name
      libbpf: Refactor global data map initialization
      libbpf: Postpone BTF ID finding for TRACING programs to load phase
      libbpf: Reduce log level of supported section names dump
      libbpf: Add BPF object skeleton support
      bpftool: Add skeleton codegen command
      selftests/bpf: Add BPF skeletons selftests and convert attach_probe.c
      selftests/bpf: Convert few more selftest to skeletons
      selftests/bpf: Add test validating data section to struct convertion layout
      bpftool: Add `gen skeleton` BASH completions
      libbpf: Extract internal map names into constants
      libbpf: Support libbpf-provided extern variables
      bpftool: Generate externs datasec in BPF skeleton
      selftests/bpf: Add tests for libbpf-provided externs
      libbpf: Support flexible arrays in CO-RE
      selftests/bpf: Add flexible array relocation tests
      libbpf: Add zlib as a dependency in pkg-config template
      selftests/bpf: More succinct Makefile output
      libbpf: Reduce log level for custom section names
      bpftool, selftests/bpf: Embed object file inside skeleton
      libbpf: Remove BPF_EMBED_OBJ macro from libbpf.h
      bpftool: Add gen subcommand manpage
      bpftool: Simplify format string to not use positional args
      bpftool: Work-around rst2man conversion bug
      libbpf: Add bpf_link__disconnect() API to preserve underlying BPF resource
      libbpf: Put Kconfig externs into .kconfig section
      libbpf: Allow to augment system Kconfig through extra optional config
      libbpf: BTF is required when externs are present
      libbpf: Fix another __u64 printf warning
      libbpf: Support CO-RE relocations for LDX/ST/STX instructions
      bpftool: Make skeleton C code compilable with C++ compiler

Björn Töpel (23):
      bpf: Move trampoline JIT image allocation to a function
      bpf: Introduce BPF dispatcher
      bpf, xdp: Start using the BPF dispatcher for XDP
      bpf: Start using the BPF dispatcher in BPF_TEST_RUN
      selftests: bpf: Add xdp_perf test
      bpf, x86: Align dispatcher branch targets to 16B
      riscv, bpf: Fix broken BPF tail calls
      riscv, bpf: Add support for far branching
      riscv, bpf: Add support for far branching when emitting tail call
      riscv, bpf: Add support for far jumps and exits
      riscv, bpf: Optimize BPF tail calls
      riscv, bpf: Provide RISC-V specific JIT image alloc/free
      riscv, bpf: Optimize calls
      riscv, bpf: Add missing uapi header for BPF_PROG_TYPE_PERF_EVENT programs
      riscv, perf: Add arch specific perf_arch_bpf_user_pt_regs
      xdp: Simplify devmap cleanup
      xdp: Simplify cpumap cleanup
      xdp: Fix graze->grace type-o in cpumap comments
      xsk: Make xskmap flush_list common for all map instances
      xdp: Make devmap flush_list common for all map instances
      xdp: Make cpumap flush_list common for all map instances
      xdp: Remove map_to_flush and map swap detection
      xdp: Simplify __bpf_tx_xdp_map()

Daniel Borkmann (3):
      bpf: Emit audit messages upon successful prog load and unload
      bpf, x86, arm64: Enable jit by default when not built as always-on
      Merge branch 'bpf-riscv-jit-improvements'

Hechao Li (1):
      bpf: Print error message for bpftool cgroup show

Jakub Sitnicki (10):
      libbpf: Recognize SK_REUSEPORT programs from section name
      selftests/bpf: Let libbpf determine program type from section name
      selftests/bpf: Use sa_family_t everywhere in reuseport tests
      selftests/bpf: Add helpers for getting socket family & type name
      selftests/bpf: Unroll the main loop in reuseport test
      selftests/bpf: Run reuseport tests in a loop
      selftests/bpf: Propagate errors during setup for reuseport tests
      selftests/bpf: Pull up printing the test name into test runner
      selftests/bpf: Move reuseport tests under prog_tests/
      selftests/bpf: Switch reuseport tests for test_progs framework

Jay Jayatheerthan (6):
      samples/bpf: xdpsock: Add duration option to specify how long to run
      samples/bpf: xdpsock: Use common code to handle signal and main exit
      samples/bpf: xdpsock: Add option to specify batch size
      samples/bpf: xdpsock: Add option to specify number of packets to send
      samples/bpf: xdpsock: Add option to specify tx packet size
      samples/bpf: xdpsock: Add option to specify transmit fill pattern

Jesper Dangaard Brouer (1):
      samples/bpf: Xdp_redirect_cpu fix missing tracepoint attach

Magnus Karlsson (12):
      xsk: Eliminate the lazy update threshold
      xsk: Simplify detection of empty and full rings
      xsk: Consolidate to one single cached producer pointer
      xsk: Standardize naming of producer ring access functions
      xsk: Eliminate the RX batch size
      xsk: Simplify xskq_nb_avail and xskq_nb_free
      xsk: Simplify the consumer ring access functions
      xsk: Change names of validation functions
      xsk: ixgbe: i40e: ice: mlx5: Xsk_umem_discard_addr to xsk_umem_release_addr
      xsk: Remove unnecessary READ_ONCE of data
      xsk: Add function naming comments and reorder functions
      xsk: Use struct_size() helper

Nikita V. Shirokov (1):
      bpf: Allow to change skb mark in test_run

Paul Chaignon (4):
      bpftool: Match several programs with same tag
      bpftool: Match programs by name
      bpftool: Match maps by name
      bpftool: Fix compilation warning on shadowed variable

Prashant Bhole (2):
      libbpf: Fix build by renaming variables
      samples/bpf: Reintroduce missed build targets

Russell King (1):
      ARM: net: bpf: Improve prologue code sequence

Stanislav Fomichev (3):
      bpf: Switch to offsetofend in BPF_PROG_TEST_RUN
      bpf: Expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_RUN
      selftests/bpf: Test wire_len/gso_segs in BPF_PROG_TEST_RUN

Thadeu Lima de Souza Cascardo (1):
      libbpf: Fix readelf output parsing for Fedora

Toke Høiland-Jørgensen (7):
      samples/bpf: Add missing -lz to TPROGS_LDLIBS
      samples/bpf: Set -fno-stack-protector when building BPF programs
      samples/bpf: Attach XDP programs in driver mode by default
      libbpf: Print hint about ulimit when getting permission denied error
      libbpf: Fix libbpf_common.h when installing libbpf through 'make install'
      libbpf: Add missing newline in opts validation macro
      libbpf: Fix printing of ulimit value

 arch/arm/net/bpf_jit_32.c                          |   30 +-
 arch/arm64/Kconfig                                 |    1 +
 arch/riscv/include/asm/perf_event.h                |    4 +
 arch/riscv/include/asm/pgtable.h                   |    4 +
 arch/riscv/include/uapi/asm/bpf_perf_event.h       |    9 +
 arch/riscv/net/bpf_jit_comp.c                      |  531 +++---
 arch/x86/Kconfig                                   |    1 +
 arch/x86/net/bpf_jit_comp.c                        |  150 ++
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |    4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |    2 +-
 include/linux/bpf-cgroup.h                         |    4 +-
 include/linux/bpf.h                                |   80 +-
 include/linux/filter.h                             |   41 +-
 include/net/xdp_sock.h                             |   25 +-
 include/uapi/linux/audit.h                         |    1 +
 include/uapi/linux/bpf.h                           |   10 +
 include/uapi/linux/btf.h                           |    3 +-
 init/Kconfig                                       |    7 +
 kernel/bpf/Makefile                                |    1 +
 kernel/bpf/cgroup.c                                |   97 +-
 kernel/bpf/core.c                                  |    6 +-
 kernel/bpf/cpumap.c                                |   76 +-
 kernel/bpf/devmap.c                                |   78 +-
 kernel/bpf/dispatcher.c                            |  158 ++
 kernel/bpf/syscall.c                               |   63 +-
 kernel/bpf/trampoline.c                            |   24 +-
 kernel/bpf/xskmap.c                                |   18 +-
 kernel/cgroup/cgroup.c                             |    5 +-
 net/bpf/test_run.c                                 |   54 +-
 net/core/dev.c                                     |   19 +-
 net/core/filter.c                                  |   71 +-
 net/xdp/xsk.c                                      |   79 +-
 net/xdp/xsk_queue.c                                |   15 +-
 net/xdp/xsk_queue.h                                |  371 +++--
 samples/bpf/Makefile                               |    5 +-
 samples/bpf/xdp1_user.c                            |    5 +-
 samples/bpf/xdp_adjust_tail_user.c                 |    5 +-
 samples/bpf/xdp_fwd_user.c                         |   17 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   63 +-
 samples/bpf/xdp_redirect_map_user.c                |    5 +-
 samples/bpf/xdp_redirect_user.c                    |    5 +-
 samples/bpf/xdp_router_ipv4_user.c                 |    3 +
 samples/bpf/xdp_rxq_info_user.c                    |    4 +
 samples/bpf/xdp_sample_pkts_user.c                 |   12 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |    5 +-
 samples/bpf/xdpsock_user.c                         |  431 ++++-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |  305 ++++
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   12 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   18 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |    3 +-
 tools/bpf/bpftool/bash-completion/bpftool          |  156 +-
 tools/bpf/bpftool/cgroup.c                         |   56 +-
 tools/bpf/bpftool/gen.c                            |  609 +++++++
 tools/bpf/bpftool/main.c                           |    3 +-
 tools/bpf/bpftool/main.h                           |    5 +-
 tools/bpf/bpftool/map.c                            |  384 ++++-
 tools/bpf/bpftool/net.c                            |    1 +
 tools/bpf/bpftool/prog.c                           |  388 +++--
 tools/include/uapi/asm/bpf_perf_event.h            |    2 +
 tools/include/uapi/linux/bpf.h                     |   10 +
 tools/include/uapi/linux/btf.h                     |    7 +-
 tools/lib/bpf/Makefile                             |   18 +-
 tools/lib/bpf/bpf.c                                |   17 +-
 tools/lib/bpf/bpf.h                                |   17 +-
 tools/lib/bpf/bpf_helpers.h                        |   11 +
 tools/lib/bpf/btf.c                                |   48 +-
 tools/lib/bpf/btf.h                                |   29 +-
 tools/lib/bpf/btf_dump.c                           |  115 +-
 tools/lib/bpf/libbpf.c                             | 1741 ++++++++++++++++----
 tools/lib/bpf/libbpf.h                             |  107 +-
 tools/lib/bpf/libbpf.map                           |   16 +
 tools/lib/bpf/libbpf.pc.template                   |    2 +-
 tools/lib/bpf/libbpf_common.h                      |   40 +
 tools/lib/bpf/libbpf_internal.h                    |   21 +-
 tools/testing/selftests/bpf/.gitignore             |    3 +-
 tools/testing/selftests/bpf/Makefile               |   81 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  161 +-
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |  111 ++
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |  285 ++++
 .../bpf/prog_tests/cgroup_attach_override.c        |  148 ++
 .../testing/selftests/bpf/prog_tests/core_extern.c |  169 ++
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    4 +
 tools/testing/selftests/bpf/prog_tests/cpu_mask.c  |   78 +
 .../selftests/bpf/prog_tests/fentry_fexit.c        |  101 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   69 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |   56 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   29 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |    6 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |   11 +-
 .../select_reuseport.c}                            |  514 +++---
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |    7 +
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |   63 +
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |   77 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |   82 +-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |   25 +
 .../btf__core_reloc_arrays___equiv_zero_sz_arr.c   |    3 +
 .../btf__core_reloc_arrays___err_bad_zero_sz_arr.c |    3 +
 .../bpf/progs/btf__core_reloc_arrays___fixed_arr.c |    3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |   39 +
 .../selftests/bpf/progs/test_attach_probe.c        |   34 +-
 .../testing/selftests/bpf/progs/test_core_extern.c |   62 +
 .../selftests/bpf/progs/test_core_reloc_arrays.c   |    8 +-
 .../bpf/progs/test_select_reuseport_kern.c         |    2 +-
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |    6 +
 tools/testing/selftests/bpf/progs/test_skeleton.c  |   46 +
 tools/testing/selftests/bpf/test_cgroup_attach.c   |  571 -------
 tools/testing/selftests/bpf/test_cpp.cpp           |   10 +
 tools/testing/selftests/bpf/test_progs.h           |    4 +
 110 files changed, 6901 insertions(+), 2721 deletions(-)
 create mode 100644 arch/riscv/include/uapi/asm/bpf_perf_event.h
 create mode 100644 kernel/bpf/dispatcher.c
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-gen.rst
 create mode 100644 tools/bpf/bpftool/gen.c
 create mode 100644 tools/lib/bpf/libbpf_common.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_attach_autodetach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_attach_multi.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_attach_override.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_extern.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c
 rename tools/testing/selftests/bpf/{test_select_reuseport.c => prog_tests/select_reuseport.c} (54%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skeleton.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_perf.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___equiv_zero_sz_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_bad_zero_sz_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___fixed_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_extern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skeleton.c
 delete mode 100644 tools/testing/selftests/bpf/test_cgroup_attach.c
