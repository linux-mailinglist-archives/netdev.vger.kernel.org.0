Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D495867F34B
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 01:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbjA1Asf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 19:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjA1Ase (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 19:48:34 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D39EC72;
        Fri, 27 Jan 2023 16:48:32 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pLZOO-0008sU-5S; Sat, 28 Jan 2023 01:48:29 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2023-01-28
Date:   Sat, 28 Jan 2023 01:48:27 +0100
Message-Id: <20230128004827.21371-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26794/Fri Jan 27 09:44:08 2023)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 124 non-merge commits during the last 22 day(s) which contain
a total of 124 files changed, 6386 insertions(+), 1827 deletions(-).

There is a merge conflict in kernel/bpf/offload.c between the commit
ef01f4e25c17 ("bpf: restore the ebpf program ID for BPF_AUDIT_UNLOAD and
PERF_BPF_EVENT_PROG_UNLOAD") from net-next tree and the commit 89bbc53a4dbb
("bpf: Reshuffle some parts of bpf/offload.c") from bpf-next tree. Easiest
is to follow Stephen's diff removing the bpf_prog_free_id() from offload:
https://lore.kernel.org/bpf/20230124094403.76e0011f@canb.auug.org.au

The main changes are:

1) Implement XDP hints via kfuncs with initial support for RX hash and timestamp
   metadata kfuncs, from Stanislav Fomichev and Toke Høiland-Jørgensen.
   Measurements on overhead: https://lore.kernel.org/bpf/875yellcx6.fsf@toke.dk

2) Extend libbpf's bpf_tracing.h support for tracing arguments of kprobes/uprobes
   and syscall as a special case, from Andrii Nakryiko.

3) Significantly reduce the search time for module symbols by livepatch and BPF,
   from Jiri Olsa and Zhen Lei.

4) Enable cpumasks to be used as kptrs, which is useful for tracing programs tracking
   which tasks end up running on which CPUs in different time intervals, from David Vernet.

5) Fix several issues in the dynptr processing such as stack slot liveness propagation,
   missing checks for PTR_TO_STACK variable offset, etc, from Kumar Kartikeya Dwivedi.

6) Various performance improvements, fixes, and introduction of more than just one
   XDP program to XSK selftests, from Magnus Karlsson.

7) Big batch to BPF samples to reduce deprecated functionality, from Daniel T. Lee.

8) Enable struct_ops programs to be sleepable in verifier, from David Vernet.

9) Reduce pr_warn() noise on BTF mismatches when they are expected under the
   CONFIG_MODULE_ALLOW_BTF_MISMATCH config anyway, from Connor O'Brien.

10) Describe modulo and division by zero behavior of the BPF runtime in BPF's
    instruction specification document, from Dave Thaler.

11) Several improvements to libbpf API documentation in libbpf.h, from Grant Seltzer.

12) Improve resolve_btfids header dependencies related to subcmd and add proper
    support for HOSTCC, from Ian Rogers.

13) Add ipip6 and ip6ip decapsulation support for bpf_skb_adjust_room() helper
    along with BPF selftests, from Ziyang Xuan.

14) Simplify the parsing logic of structure parameters for BPF trampoline in the
    x86-64 JIT compiler, from Pu Lehui.

15) Get BTF working for kernels with CONFIG_RUST enabled by excluding Rust compilation
    units with pahole, from Martin Rodriguez Reboredo.

16) Get bpf_setsockopt() working for kTLS on top of TCP sockets, from Kui-Feng Lee.

17) Disable stack protection for BPF objects in bpftool given BPF backends don't
    support it, from Holger Hoffstätte.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Andrii Nakryiko, Arnaldo Carvalho de Melo, David Vernet, 
Eduard Zingerman, Eric Curtin, Ilya Leoshkevich, Jakub Kicinski, Jesper 
Dangaard Brouer, Jiri Olsa, Joanne Koong, Luis Chamberlain, Maciej 
Fijalkowski, Miguel Ojeda, Miroslav Benes, Neal Gompa, Petr Mladek, Pu 
Lehui, Quentin Monnet, Song Liu, Stanislav Fomichev, Tariq Toukan, 
Willem de Bruijn, Yonghong Song, Zhen Lei

----------------------------------------------------------------

The following changes since commit 6bd4755c7c499dbcef46eaaeafa1a319da583b29:

  Merge branch 'devlink-unregister' (2023-01-06 12:56:20 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 16809afdcbad5fa45f34622f62873c7d7114cde5:

  selftest/bpf: Make crashes more debuggable in test_progs (2023-01-27 15:22:00 -0800)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (6):
      Merge branch 'selftests/xsk: speed-ups, fixes, and new XDP programs'
      Merge branch 'samples/bpf: modernize BPF functionality test programs'
      Merge branch 'kallsyms: Optimize the search for module symbols by livepatch and bpf'
      Merge branch 'Dynptr fixes'
      Merge branch 'Enable cpumasks to be used as kptrs'
      Merge branch 'Enable struct_ops programs to be sleepable'

Andrii Nakryiko (25):
      libbpf: Add support for fetching up to 8 arguments in kprobes
      libbpf: Add 6th argument support for x86-64 in bpf_tracing.h
      libbpf: Fix arm and arm64 specs in bpf_tracing.h
      libbpf: Complete mips spec in bpf_tracing.h
      libbpf: Complete powerpc spec in bpf_tracing.h
      libbpf: Complete sparc spec in bpf_tracing.h
      libbpf: Complete riscv arch spec in bpf_tracing.h
      libbpf: Fix and complete ARC spec in bpf_tracing.h
      libbpf: Complete LoongArch (loongarch) spec in bpf_tracing.h
      libbpf: Add BPF_UPROBE and BPF_URETPROBE macro aliases
      selftests/bpf: Validate arch-specific argument registers limits
      libbpf: Improve syscall tracing support in bpf_tracing.h
      libbpf: Define x86-64 syscall regs spec in bpf_tracing.h
      libbpf: Define i386 syscall regs spec in bpf_tracing.h
      libbpf: Define s390x syscall regs spec in bpf_tracing.h
      libbpf: Define arm syscall regs spec in bpf_tracing.h
      libbpf: Define arm64 syscall regs spec in bpf_tracing.h
      libbpf: Define mips syscall regs spec in bpf_tracing.h
      libbpf: Define powerpc syscall regs spec in bpf_tracing.h
      libbpf: Define sparc syscall regs spec in bpf_tracing.h
      libbpf: Define riscv syscall regs spec in bpf_tracing.h
      libbpf: Define arc syscall regs spec in bpf_tracing.h
      libbpf: Define loongarch syscall regs spec in bpf_tracing.h
      selftests/bpf: Add 6-argument syscall tracing test
      libbpf: Clean up now not needed __PT_PARM{1-6}_SYSCALL_REG defaults

Chethan Suresh (1):
      bpftool: fix output for skipping kernel config check

Connor O'Brien (1):
      bpf: btf: limit logging of ignored BTF mismatches

Daniel Borkmann (1):
      Merge branch 'libbpf-extend-arguments-tracing'

Daniel T. Lee (11):
      samples/bpf: ensure ipv6 is enabled before running tests
      samples/bpf: refactor BPF functionality testing scripts
      samples/bpf: fix broken lightweight tunnel testing
      samples/bpf: fix broken cgroup socket testing
      samples/bpf: replace broken overhead microbenchmark with fib_table_lookup
      samples/bpf: replace legacy map with the BTF-defined map
      samples/bpf: split common macros to net_shared.h
      samples/bpf: replace BPF programs header with net_shared.h
      samples/bpf: use vmlinux.h instead of implicit headers in BPF test program
      samples/bpf: change _kern suffix to .bpf with BPF test programs
      selftests/bpf: Fix vmtest static compilation error

Dave Thaler (1):
      bpf, docs: Fix modulo zero, division by zero, overflow, and underflow

David Vernet (14):
      selftests/bpf: Use __failure macro in task kfunc testsuite
      bpf: Enable annotating trusted nested pointers
      bpf: Allow trusted args to walk struct when checking BTF IDs
      bpf: Disallow NULLable pointers for trusted kfuncs
      bpf: Enable cpumasks to be queried and used as kptrs
      selftests/bpf: Add nested trust selftests suite
      selftests/bpf: Add selftest suite for cpumask kfuncs
      bpf/docs: Document cpumask kfuncs in a new file
      bpf/docs: Document how nested trusted fields may be defined
      bpf/docs: Document the nocast aliasing behavior of ___init
      bpf: Allow BPF_PROG_TYPE_STRUCT_OPS programs to be sleepable
      libbpf: Support sleepable struct_ops.s section
      bpf: Pass const struct bpf_prog * to .check_member
      bpf/selftests: Verify struct_ops prog sleepable behavior

Eduard Zingerman (1):
      selftests/bpf: convenience macro for use with 'asm volatile' blocks

Grant Seltzer (2):
      libbpf: Fix malformed documentation formatting
      libbpf: Add documentation to map pinning API functions

Haiyue Wang (1):
      bpf: Remove the unnecessary insn buffer comparison

Holger Hoffstätte (1):
      bpftool: Always disable stack protection for BPF objects

Ian Rogers (2):
      tools/resolve_btfids: Install subcmd headers
      tools/resolve_btfids: Alter how HOSTCC is forced

James Hilliard (1):
      bpftool: Add missing quotes to libbpf bootstrap submake vars

Jiri Olsa (4):
      bpf: Do not allow to load sleepable BPF_TRACE_RAW_TP program
      bpf/selftests: Add verifier tests for loading sleepable programs
      selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module tests
      bpf: Change modules resolving for kprobe multi link

Kees Cook (1):
      bpf: Replace 0-length arrays with flexible arrays

Kui-Feng Lee (2):
      bpf: Check the protocol of a sock to agree the calls to bpf_setsockopt().
      selftests/bpf: Calls bpf_setsockopt() on a ktls enabled socket.

Kumar Kartikeya Dwivedi (11):
      bpf: Fix state pruning for STACK_DYNPTR stack slots
      bpf: Fix missing var_off check for ARG_PTR_TO_DYNPTR
      bpf: Fix partial dynptr stack slot reads/writes
      bpf: Invalidate slices on destruction of dynptrs on stack
      bpf: Allow reinitializing unreferenced dynptr stack slots
      bpf: Combine dynptr_get_spi and is_spi_bounds_valid
      bpf: Avoid recomputing spi in process_dynptr_func
      selftests/bpf: Add dynptr pruning tests
      selftests/bpf: Add dynptr var_off tests
      selftests/bpf: Add dynptr partial slot overwrite tests
      selftests/bpf: Add dynptr helper tests

Ludovic L'Hours (1):
      libbpf: Fix map creation flags sanitization

Magnus Karlsson (15):
      selftests/xsk: print correct payload for packet dump
      selftests/xsk: do not close unused file descriptors
      selftests/xsk: submit correct number of frames in populate_fill_ring
      selftests/xsk: print correct error codes when exiting
      selftests/xsk: remove unused variable outstanding_tx
      selftests/xsk: add debug option for creating netdevs
      selftests/xsk: replace asm acquire/release implementations
      selftests/xsk: remove namespaces
      selftests/xsk: load and attach XDP program only once per mode
      selftests/xsk: remove unnecessary code in control path
      selftests/xsk: get rid of built-in XDP program
      selftests/xsk: add test when some packets are XDP_DROPed
      selftests/xsk: merge dual and single thread dispatchers
      selftests/xsk: automatically restore packet stream
      selftests/xsk: automatically switch XDP programs

Martin KaFai Lau (3):
      Merge branch 'bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()'
      Merge branch 'xdp: hints via kfuncs'
      Merge branch 'Enable bpf_setsockopt() on ktls enabled sockets.'

Martin Rodriguez Reboredo (1):
      btf, scripts: Exclude Rust CUs with pahole

Menglong Dong (1):
      libbpf: Replace '.' with '_' in legacy kprobe event name

Michal Suchanek (1):
      bpf_doc: Fix build error with older python versions

Pu Lehui (1):
      bpf, x86: Simplify the parsing logic of structure parameters

Roberto Valenzuela (1):
      selftests/bpf: Fix missing space error

Rong Tao (1):
      libbpf: Poison strlcpy()

Stanislav Fomichev (15):
      bpf: Document XDP RX metadata
      bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
      bpf: Move offload initialization into late_initcall
      bpf: Reshuffle some parts of bpf/offload.c
      bpf: Introduce device-bound XDP programs
      selftests/bpf: Update expected test_offload.py messages
      bpf: XDP metadata RX kfuncs
      veth: Introduce veth_xdp_buff wrapper for xdp_buff
      veth: Support RX XDP metadata
      selftests/bpf: Verify xdp_metadata xdp->af_xdp path
      net/mlx4_en: Introduce wrapper for xdp_buff
      net/mlx4_en: Support RX XDP metadata
      selftests/bpf: Simple program to dump XDP RX metadata
      selftests/bpf: Properly enable hwtstamp in xdp_hw_metadata
      selftest/bpf: Make crashes more debuggable in test_progs

Tiezhu Yang (1):
      selftests/bpf: Fix build errors if CONFIG_NF_CONNTRACK=m

Toke Høiland-Jørgensen (4):
      bpf: Support consuming XDP HW metadata from fext programs
      xsk: Add cb area to struct xdp_buff_xsk
      net/mlx5e: Introduce wrapper for xdp_buff
      net/mlx5e: Support RX XDP metadata

Zhen Lei (1):
      livepatch: Improve the search performance of module_kallsyms_on_each_symbol()

Ziyang Xuan (2):
      bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
      selftests/bpf: add ipip6 and ip6ip decap to test_tc_tunnel

 Documentation/bpf/cpumasks.rst                     | 393 ++++++++++++
 Documentation/bpf/index.rst                        |   1 +
 Documentation/bpf/instruction-set.rst              |  16 +-
 Documentation/bpf/kfuncs.rst                       |  76 ++-
 Documentation/networking/index.rst                 |   1 +
 Documentation/networking/xdp-rx-metadata.rst       | 110 ++++
 arch/x86/net/bpf_jit_comp.c                        | 101 ++-
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |  13 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   6 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |  63 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  31 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |  47 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  99 +--
 drivers/net/netdevsim/bpf.c                        |   4 -
 drivers/net/veth.c                                 |  87 ++-
 include/linux/bpf.h                                |  79 ++-
 include/linux/bpf_verifier.h                       |   5 +-
 include/linux/module.h                             |   6 +-
 include/linux/netdevice.h                          |   8 +
 include/net/xdp.h                                  |  21 +
 include/net/xsk_buff_pool.h                        |   5 +
 include/uapi/linux/bpf.h                           |  12 +
 init/Kconfig                                       |   2 +-
 kernel/bpf/Makefile                                |   1 +
 kernel/bpf/btf.c                                   | 160 ++++-
 kernel/bpf/core.c                                  |  12 +-
 kernel/bpf/cpumask.c                               | 476 +++++++++++++++
 kernel/bpf/offload.c                               | 425 ++++++++-----
 kernel/bpf/syscall.c                               |  34 +-
 kernel/bpf/verifier.c                              | 544 ++++++++++++++---
 kernel/livepatch/core.c                            |  10 +-
 kernel/module/kallsyms.c                           |  13 +-
 kernel/trace/bpf_trace.c                           |  93 +--
 kernel/trace/ftrace.c                              |   2 +-
 lib/Kconfig.debug                                  |   9 +
 net/bpf/bpf_dummy_struct_ops.c                     |  18 +
 net/bpf/test_run.c                                 |   3 +
 net/core/dev.c                                     |   9 +-
 net/core/filter.c                                  |  41 +-
 net/core/xdp.c                                     |  64 ++
 net/ipv4/bpf_tcp_ca.c                              |   3 +-
 samples/bpf/Makefile                               |  14 +-
 .../{lwt_len_hist_kern.c => lwt_len_hist.bpf.c}    |  29 +-
 samples/bpf/lwt_len_hist.sh                        |   4 +-
 samples/bpf/net_shared.h                           |  32 +
 .../bpf/{sock_flags_kern.c => sock_flags.bpf.c}    |  24 +-
 samples/bpf/tc_l2_redirect.sh                      |   3 +
 samples/bpf/test_cgrp2_sock.sh                     |  16 +-
 samples/bpf/test_cgrp2_sock2.sh                    |   9 +-
 .../{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c}  |  34 +-
 samples/bpf/test_cgrp2_tc.sh                       |   8 +-
 samples/bpf/test_lwt_bpf.c                         |  50 +-
 samples/bpf/test_lwt_bpf.sh                        |  19 +-
 ...est_map_in_map_kern.c => test_map_in_map.bpf.c} |   7 +-
 samples/bpf/test_map_in_map_user.c                 |   2 +-
 ...ad_kprobe_kern.c => test_overhead_kprobe.bpf.c} |   6 +-
 ...ad_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} |   4 +-
 ...t_overhead_tp_kern.c => test_overhead_tp.bpf.c} |  29 +-
 samples/bpf/test_overhead_user.c                   |  34 +-
 samples/bpf/xdp_sample.bpf.h                       |  22 +-
 scripts/bpf_doc.py                                 |   2 +-
 scripts/pahole-flags.sh                            |   4 +
 tools/bpf/bpftool/Makefile                         |   5 +-
 tools/bpf/bpftool/feature.c                        |   8 +-
 tools/bpf/resolve_btfids/Makefile                  |  34 +-
 tools/bpf/resolve_btfids/main.c                    |   2 +-
 tools/include/uapi/linux/bpf.h                     |  12 +
 tools/lib/bpf/bpf_tracing.h                        | 303 +++++++--
 tools/lib/bpf/libbpf.c                             |  10 +-
 tools/lib/bpf/libbpf.h                             |  90 ++-
 tools/lib/bpf/libbpf_internal.h                    |   4 +-
 tools/testing/selftests/bpf/.gitignore             |   1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   3 +
 tools/testing/selftests/bpf/Makefile               |  20 +-
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |   4 +-
 tools/testing/selftests/bpf/prog_tests/cpumask.c   |  74 +++
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |  52 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |   2 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  19 +-
 .../selftests/bpf/prog_tests/nested_trust.c        |  12 +
 .../selftests/bpf/prog_tests/setget_sockopt.c      |  73 +++
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |  71 +--
 .../bpf/prog_tests/test_bpf_syscall_macro.c        |  17 +
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |  33 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c        | 410 +++++++++++++
 tools/testing/selftests/bpf/progs/bpf_misc.h       |  32 +
 .../selftests/bpf/progs/bpf_syscall_macro.c        |  26 +
 tools/testing/selftests/bpf/progs/cpumask_common.h | 114 ++++
 .../testing/selftests/bpf/progs/cpumask_failure.c  | 126 ++++
 .../testing/selftests/bpf/progs/cpumask_success.c  | 426 +++++++++++++
 .../selftests/bpf/progs/dummy_st_ops_fail.c        |  27 +
 .../{dummy_st_ops.c => dummy_st_ops_success.c}     |  19 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    | 453 +++++++++++++-
 .../selftests/bpf/progs/nested_trust_common.h      |  12 +
 .../selftests/bpf/progs/nested_trust_failure.c     |  33 +
 .../selftests/bpf/progs/nested_trust_success.c     |  19 +
 tools/testing/selftests/bpf/progs/setget_sockopt.c |   8 +
 .../selftests/bpf/progs/task_kfunc_failure.c       |  18 +
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  11 +-
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c |  91 ++-
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |  48 +-
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c  |   2 +-
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |  81 +++
 tools/testing/selftests/bpf/progs/xdp_metadata.c   |  64 ++
 tools/testing/selftests/bpf/progs/xdp_metadata2.c  |  23 +
 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c  |  30 +
 tools/testing/selftests/bpf/test_offload.py        |  10 +-
 tools/testing/selftests/bpf/test_progs.c           |   4 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |  15 +-
 tools/testing/selftests/bpf/test_xsk.sh            |  42 +-
 tools/testing/selftests/bpf/verifier/sleepable.c   |  91 +++
 tools/testing/selftests/bpf/xdp_hw_metadata.c      | 446 ++++++++++++++
 tools/testing/selftests/bpf/xdp_metadata.h         |  15 +
 tools/testing/selftests/bpf/xsk.c                  | 677 ++-------------------
 tools/testing/selftests/bpf/xsk.h                  |  97 +--
 tools/testing/selftests/bpf/xsk_prereqs.sh         |  12 +-
 tools/testing/selftests/bpf/xskxceiver.c           | 382 ++++++------
 tools/testing/selftests/bpf/xskxceiver.h           |  17 +-
 124 files changed, 6386 insertions(+), 1827 deletions(-)
 create mode 100644 Documentation/bpf/cpumasks.rst
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst
 create mode 100644 kernel/bpf/cpumask.c
 rename samples/bpf/{lwt_len_hist_kern.c => lwt_len_hist.bpf.c} (75%)
 create mode 100644 samples/bpf/net_shared.h
 rename samples/bpf/{sock_flags_kern.c => sock_flags.bpf.c} (66%)
 rename samples/bpf/{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c} (70%)
 rename samples/bpf/{test_map_in_map_kern.c => test_map_in_map.bpf.c} (97%)
 rename samples/bpf/{test_overhead_kprobe_kern.c => test_overhead_kprobe.bpf.c} (92%)
 rename samples/bpf/{test_overhead_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} (82%)
 rename samples/bpf/{test_overhead_tp_kern.c => test_overhead_tp.bpf.c} (61%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cpumask.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/nested_trust.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/cpumask_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/cpumask_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/cpumask_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops_fail.c
 rename tools/testing/selftests/bpf/progs/{dummy_st_ops.c => dummy_st_ops_success.c} (72%)
 create mode 100644 tools/testing/selftests/bpf/progs/nested_trust_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/nested_trust_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/nested_trust_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
 create mode 100644 tools/testing/selftests/bpf/verifier/sleepable.c
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h
