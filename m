Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E21C512586
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbiD0WvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiD0WvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:51:15 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9347E5B2;
        Wed, 27 Apr 2022 15:48:01 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1njqRy-0001GN-Ut; Thu, 28 Apr 2022 00:47:59 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-04-27
Date:   Thu, 28 Apr 2022 00:47:58 +0200
Message-Id: <20220427224758.20976-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26525/Wed Apr 27 10:19:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 85 non-merge commits during the last 18 day(s) which contain
a total of 163 files changed, 4499 insertions(+), 1521 deletions(-).

The main changes are:

1) Teach libbpf to enhance BPF verifier log with human-readable and relevant
   information about failed CO-RE relocations, from Andrii Nakryiko.

2) Add typed pointer support in BPF maps and enable it for unreferenced pointers
   (via probe read) and referenced ones that can be passed to in-kernel helpers,
   from Kumar Kartikeya Dwivedi.

3) Improve xsk to break NAPI loop when rx queue gets full to allow for forward
   progress to consume descriptors, from Maciej Fijalkowski & Björn Töpel.

4) Fix a small RCU read-side race in BPF_PROG_RUN routines which dereferenced
   the effective prog array before the rcu_read_lock, from Stanislav Fomichev.

5) Implement BPF atomic operations for RV64 JIT, and add libbpf parsing logic
   for USDT arguments under riscv{32,64}, from Pu Lehui.

6) Implement libbpf parsing of USDT arguments under aarch64, from Alan Maguire.

7) Enable bpftool build for musl and remove nftw with FTW_ACTIONRETVAL usage
   so it can be shipped under Alpine which is musl-based, from Dominique Martinet.

8) Clean up {sk,task,inode} local storage trace RCU handling as they do not
   need to use call_rcu_tasks_trace() barrier, from KP Singh.

9) Improve libbpf API documentation and fix error return handling of various
   API functions, from Grant Seltzer.

10) Enlarge offset check for bpf_skb_{load,store}_bytes() helpers given data
    length of frags + frag_list may surpass old offset limit, from Liu Jian.

11) Various improvements to prog_tests in area of logging, test execution
    and by-name subtest selection, from Mykola Lysenko.

12) Simplify map_btf_id generation for all map types by moving this process
    to build time with help of resolve_btfids infra, from Menglong Dong.

13) Fix a libbpf bug in probing when falling back to legacy bpf_probe_read*()
    helpers; the probing caused always to use old helpers, from Runqing Yang.

14) Add support for ARCompact and ARCv2 platforms for libbpf's PT_REGS
    tracing macros, from Vladimir Isaev.

15) Cleanup BPF selftests to remove old & unneeded rlimit code given kernel
    switched to memcg-based memory accouting a while ago, from Yafang Shao.

16) Refactor of BPF sysctl handlers to move them to BPF core, from Yan Zhu.

17) Fix BPF selftests in two occasions to work around regressions caused by latest
    LLVM to unblock CI until their fixes are worked out, from Yonghong Song.

18) Misc cleanups all over the place, from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, Jesper Dangaard Brouer, Joanne Koong, kernel test robot, 
Kuifeng Lee, Kui-Feng Lee, Martin KaFai Lau, Quentin Monnet, Song Liu, 
Yafang Shao, Yonghong Song

----------------------------------------------------------------

The following changes since commit 34ba23b44c664792a4308ec37b5788a3162944ec:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2022-04-08 17:07:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to d54d06a4c4bc5d76815d02e4b041b31d9dbb3fef:

  Merge branch 'Teach libbpf to "fix up" BPF verifier log' (2022-04-26 15:41:47 -0700)

----------------------------------------------------------------
Alan Maguire (1):
      libbpf: Usdt aarch64 arg parsing support

Alexei Starovoitov (3):
      Merge branch 'Ensure type tags are always ordered first in BTF'
      Merge branch 'Introduce typed pointer support in BPF maps'
      Merge branch 'Teach libbpf to "fix up" BPF verifier log'

Andrii Nakryiko (17):
      Merge branch 'bpf: RLIMIT_MEMLOCK cleanups'
      libbpf: Support opting out from autoloading BPF programs declaratively
      selftests/bpf: Use non-autoloaded programs in few tests
      Merge branch 'Support riscv libbpf USDT arg parsing logic'
      bpf: Allow attach TRACING programs through LINK_CREATE command
      libbpf: Teach bpf_link_create() to fallback to bpf_raw_tracepoint_open()
      selftests/bpf: Switch fexit_stress to bpf_link_create() API
      libbpf: Fix anonymous type check in CO-RE logic
      libbpf: Drop unhelpful "program too large" guess
      libbpf: Fix logic for finding matching program for CO-RE relocation
      libbpf: Avoid joining .BTF.ext data with BPF programs by section name
      selftests/bpf: Add CO-RE relos and SEC("?...") to linked_funcs selftests
      libbpf: Record subprog-resolved CO-RE relocations unconditionally
      libbpf: Refactor CO-RE relo human description formatting routine
      libbpf: Simplify bpf_core_parse_spec() signature
      libbpf: Fix up verifier log for unguarded failed CO-RE relos
      selftests/bpf: Add libbpf's log fixup logic selftests

Artem Savkov (3):
      selftests/bpf: Fix attach tests retcode checks
      selftests/bpf: Fix prog_tests uprobe_autoattach compilation error
      selftests/bpf: Fix map tests errno checks

Björn Töpel (1):
      xsk: Improve xdp_do_redirect() error codes

Daniel Borkmann (1):
      Merge branch 'pr/bpf-sysctl' into bpf-next

Dominique Martinet (2):
      bpftool, musl compat: Replace nftw with FTW_ACTIONRETVAL
      bpftool, musl compat: Replace sys/fcntl.h by fcntl.h

Gaosheng Cui (1):
      libbpf: Remove redundant non-null checks on obj_elf

Geliang Tang (1):
      selftests/bpf: Drop duplicate max/min definitions

Grant Seltzer (4):
      libbpf: Add error returns to two API functions
      libbpf: Update API functions usage to check error
      libbpf: Add documentation to API functions
      libbpf: Improve libbpf API documentation link position

KP Singh (1):
      bpf: Fix usage of trace RCU in local storage.

Kumar Kartikeya Dwivedi (17):
      bpf: Ensure type tags precede modifiers in BTF
      selftests/bpf: Add tests for type tag order validation
      bpf: Make btf_find_field more generic
      bpf: Move check_ptr_off_reg before check_map_access
      bpf: Allow storing unreferenced kptr in map
      bpf: Tag argument to be released in bpf_func_proto
      bpf: Allow storing referenced kptr in map
      bpf: Prevent escaping of kptr loaded from maps
      bpf: Adapt copy_map_value for multiple offset case
      bpf: Populate pairs of btf_id and destructor kfunc in btf
      bpf: Wire up freeing of referenced kptr
      bpf: Teach verifier about kptr_get kfunc helpers
      bpf: Make BTF type match stricter for release arguments
      libbpf: Add kptr type tag macros to bpf_helpers.h
      selftests/bpf: Add C tests for kptr
      selftests/bpf: Add verifier tests for kptr
      selftests/bpf: Add test for strict BTF type check

Liu Jian (3):
      bpf: Enlarge offset check value to INT_MAX in bpf_skb_{load,store}_bytes
      net: Change skb_ensure_writable()'s write_len param to unsigned int type
      selftests/bpf: Add test for skb_load_bytes

Maciej Fijalkowski (15):
      xsk: Diversify return codes in xsk_rcv_check()
      ice, xsk: Decorate ICE_XDP_REDIR with likely()
      ixgbe, xsk: Decorate IXGBE_XDP_REDIR with likely()
      ice, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full
      i40e, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full
      ixgbe, xsk: Terminate Rx side of NAPI when XSK Rx queue gets full
      ice, xsk: Diversify return values from xsk_wakeup call paths
      i40e, xsk: Diversify return values from xsk_wakeup call paths
      ixgbe, xsk: Diversify return values from xsk_wakeup call paths
      mlx5, xsk: Diversify return values from xsk_wakeup call paths
      stmmac, xsk: Diversify return values from xsk_wakeup call paths
      ice, xsk: Avoid refilling single Rx descriptors
      xsk: Drop ternary operator from xskq_cons_has_entries
      ixgbe, xsk: Get rid of redundant 'fallthrough'
      i40e, xsk: Get rid of redundant 'fallthrough'

Menglong Dong (1):
      bpf: Compute map_btf_id during build time

Mykola Lysenko (2):
      selftests/bpf: Improve by-name subtest selection logic in prog_tests
      selftests/bpf: Refactor prog_tests logging and test execution

Pu Lehui (3):
      riscv, bpf: Implement more atomic operations for RV64
      libbpf: Fix usdt_cookie being cast to 32 bits
      libbpf: Support riscv USDT argument parsing logic

Runqing Yang (1):
      libbpf: Fix a bug with checking bpf_probe_read_kernel() support in old kernels

Stanislav Fomichev (2):
      bpf: Move rcu lock management out of BPF_PROG_RUN routines
      bpf: Use bpf_prog_run_array_cg_flags everywhere

Vladimir Isaev (1):
      libbpf: Add ARC support to bpf_tracing.h

Yafang Shao (4):
      samples/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
      selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
      bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK
      tools/runqslower: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK

Yan Zhu (1):
      bpf: Move BPF sysctls from kernel/sysctl.c to BPF core

Yonghong Song (2):
      selftests/bpf: Limit unroll_count for pyperf600 test
      selftests/bpf: Workaround a verifier issue for test exhandler

Yu Zhe (1):
      bpf: Remove unnecessary type castings

Yuntao Wang (2):
      bpf: Remove redundant assignment to meta.seq in __task_seq_show()
      libbpf: Remove unnecessary type cast

Zhengchao Shao (1):
      samples/bpf: Reduce the sampling interval in xdp1_user

 Documentation/bpf/libbpf/index.rst                 |   3 +-
 arch/riscv/net/bpf_jit.h                           |  67 +++
 arch/riscv/net/bpf_jit_comp64.c                    | 110 +++-
 drivers/media/rc/bpf-lirc.c                        |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx_common.h |   1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  39 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  53 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  53 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   4 +-
 include/linux/bpf-cgroup.h                         |   8 +-
 include/linux/bpf.h                                | 231 +++-----
 include/linux/bpf_local_storage.h                  |   4 +-
 include/linux/bpf_verifier.h                       |   3 +-
 include/linux/btf.h                                |  23 +
 include/linux/skbuff.h                             |   2 +-
 include/uapi/linux/bpf.h                           |  12 +
 kernel/bpf/arraymap.c                              |  44 +-
 kernel/bpf/bloom_filter.c                          |   6 +-
 kernel/bpf/bpf_inode_storage.c                     |  10 +-
 kernel/bpf/bpf_iter.c                              |   2 +-
 kernel/bpf/bpf_local_storage.c                     |  29 +-
 kernel/bpf/bpf_struct_ops.c                        |  10 +-
 kernel/bpf/bpf_task_storage.c                      |   9 +-
 kernel/bpf/btf.c                                   | 634 ++++++++++++++++++---
 kernel/bpf/cgroup.c                                | 106 +++-
 kernel/bpf/cpumap.c                                |   6 +-
 kernel/bpf/devmap.c                                |  10 +-
 kernel/bpf/hashtab.c                               |  88 +--
 kernel/bpf/helpers.c                               |  24 +
 kernel/bpf/local_storage.c                         |   7 +-
 kernel/bpf/lpm_trie.c                              |   6 +-
 kernel/bpf/map_in_map.c                            |   5 +-
 kernel/bpf/queue_stack_maps.c                      |  10 +-
 kernel/bpf/reuseport_array.c                       |   6 +-
 kernel/bpf/ringbuf.c                               |  10 +-
 kernel/bpf/stackmap.c                              |   5 +-
 kernel/bpf/syscall.c                               | 431 ++++++++++++--
 kernel/bpf/task_iter.c                             |   1 -
 kernel/bpf/verifier.c                              | 446 ++++++++++++---
 kernel/sysctl.c                                    |  79 ---
 kernel/trace/bpf_trace.c                           |   5 +-
 net/bpf/test_run.c                                 |  67 ++-
 net/core/bpf_sk_storage.c                          |  11 +-
 net/core/filter.c                                  |   6 +-
 net/core/skbuff.c                                  |   2 +-
 net/core/sock_map.c                                |  10 +-
 net/xdp/xsk.c                                      |   4 +-
 net/xdp/xsk_queue.h                                |   4 +-
 net/xdp/xskmap.c                                   |   6 +-
 samples/bpf/cpustat_user.c                         |   1 -
 samples/bpf/hbm.c                                  |   5 +-
 samples/bpf/ibumad_user.c                          |   1 -
 samples/bpf/map_perf_test_user.c                   |   1 -
 samples/bpf/offwaketime_user.c                     |   1 -
 samples/bpf/sockex2_user.c                         |   1 -
 samples/bpf/sockex3_user.c                         |   1 -
 samples/bpf/spintest_user.c                        |   1 -
 samples/bpf/syscall_tp_user.c                      |   1 -
 samples/bpf/task_fd_query_user.c                   |   1 -
 samples/bpf/test_lru_dist.c                        |   1 -
 samples/bpf/test_map_in_map_user.c                 |   1 -
 samples/bpf/test_overhead_user.c                   |   1 -
 samples/bpf/tracex2_user.c                         |   1 -
 samples/bpf/tracex3_user.c                         |   1 -
 samples/bpf/tracex4_user.c                         |   1 -
 samples/bpf/tracex5_user.c                         |   1 -
 samples/bpf/tracex6_user.c                         |   1 -
 samples/bpf/xdp1_user.c                            |   3 +-
 samples/bpf/xdp_adjust_tail_user.c                 |   1 -
 samples/bpf/xdp_monitor_user.c                     |   1 -
 samples/bpf/xdp_redirect_cpu_user.c                |   1 -
 samples/bpf/xdp_redirect_map_multi_user.c          |   1 -
 samples/bpf/xdp_redirect_user.c                    |   1 -
 samples/bpf/xdp_router_ipv4_user.c                 |   1 -
 samples/bpf/xdp_rxq_info_user.c                    |   1 -
 samples/bpf/xdp_sample_pkts_user.c                 |   1 -
 samples/bpf/xdp_sample_user.c                      |   1 -
 samples/bpf/xdp_tx_iptunnel_user.c                 |   1 -
 samples/bpf/xdpsock_user.c                         |   9 +-
 samples/bpf/xsk_fwd.c                              |   7 +-
 tools/bpf/bpftool/common.c                         |   8 -
 tools/bpf/bpftool/feature.c                        |   2 -
 tools/bpf/bpftool/main.c                           |   6 +-
 tools/bpf/bpftool/main.h                           |   2 -
 tools/bpf/bpftool/map.c                            |   2 -
 tools/bpf/bpftool/perf.c                           | 112 ++--
 tools/bpf/bpftool/pids.c                           |   1 -
 tools/bpf/bpftool/prog.c                           |   3 -
 tools/bpf/bpftool/struct_ops.c                     |   2 -
 tools/bpf/bpftool/tracelog.c                       |   2 +-
 tools/bpf/runqslower/runqslower.c                  |  18 +-
 tools/include/uapi/asm/bpf_perf_event.h            |   2 +
 tools/include/uapi/linux/bpf.h                     |  12 +
 tools/lib/bpf/bpf.c                                |  34 +-
 tools/lib/bpf/bpf_helpers.h                        |   7 +
 tools/lib/bpf/bpf_tracing.h                        |  23 +
 tools/lib/bpf/btf.c                                |   9 +-
 tools/lib/bpf/libbpf.c                             | 322 ++++++++---
 tools/lib/bpf/libbpf.h                             |  82 ++-
 tools/lib/bpf/libbpf_internal.h                    |   9 +-
 tools/lib/bpf/relo_core.c                          | 104 ++--
 tools/lib/bpf/relo_core.h                          |   6 +
 tools/lib/bpf/usdt.c                               | 191 ++++++-
 tools/testing/selftests/bpf/bench.c                |   1 -
 tools/testing/selftests/bpf/bpf_rlimit.h           |  28 -
 tools/testing/selftests/bpf/flow_dissector_load.c  |   6 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |   4 +-
 .../testing/selftests/bpf/prog_tests/arg_parsing.c | 107 ++++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   4 +-
 .../selftests/bpf/prog_tests/bpf_mod_race.c        |   4 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   6 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       | 100 +++-
 .../selftests/bpf/prog_tests/fexit_stress.c        |   2 +-
 .../selftests/bpf/prog_tests/helper_restricted.c   |  10 +-
 .../selftests/bpf/prog_tests/linked_funcs.c        |   6 +
 tools/testing/selftests/bpf/prog_tests/log_fixup.c | 114 ++++
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |  37 ++
 .../bpf/prog_tests/prog_tests_framework.c          |  56 ++
 .../selftests/bpf/prog_tests/reference_tracking.c  |  23 +-
 .../selftests/bpf/prog_tests/skb_load_bytes.c      |  45 ++
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |   4 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   1 -
 .../selftests/bpf/prog_tests/test_strncmp.c        |  25 +-
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |   3 +-
 tools/testing/selftests/bpf/progs/exhandler_kern.c |  15 +-
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |   7 +-
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |   7 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       | 190 ++++++
 tools/testing/selftests/bpf/progs/pyperf.h         |   4 +
 tools/testing/selftests/bpf/progs/pyperf600.c      |  11 +-
 tools/testing/selftests/bpf/progs/skb_load_bytes.c |  19 +
 tools/testing/selftests/bpf/progs/strncmp_test.c   |   8 +-
 .../selftests/bpf/progs/test_helper_restricted.c   |  16 +-
 tools/testing/selftests/bpf/progs/test_log_fixup.c |  38 ++
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |  18 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c  |   4 +-
 tools/testing/selftests/bpf/test_dev_cgroup.c      |   4 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |  43 +-
 tools/testing/selftests/bpf/test_lru_map.c         |  70 +--
 tools/testing/selftests/bpf/test_progs.c           | 481 ++++++----------
 tools/testing/selftests/bpf/test_progs.h           |  62 +-
 .../selftests/bpf/test_skb_cgroup_id_user.c        |   4 +-
 tools/testing/selftests/bpf/test_sock.c            |   6 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |   4 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   5 +-
 tools/testing/selftests/bpf/test_sysctl.c          |   6 +-
 tools/testing/selftests/bpf/test_tag.c             |   4 +-
 .../selftests/bpf/test_tcp_check_syncookie_user.c  |   4 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |   1 -
 tools/testing/selftests/bpf/test_verifier.c        |  55 +-
 tools/testing/selftests/bpf/test_verifier_log.c    |   5 +-
 tools/testing/selftests/bpf/testing_helpers.c      |  89 +++
 tools/testing/selftests/bpf/testing_helpers.h      |   8 +
 tools/testing/selftests/bpf/verifier/calls.c       |  20 +
 tools/testing/selftests/bpf/verifier/map_kptr.c    | 469 +++++++++++++++
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   2 +-
 tools/testing/selftests/bpf/verifier/sock.c        |   6 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |   1 -
 tools/testing/selftests/bpf/xdping.c               |   8 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   6 +-
 163 files changed, 4499 insertions(+), 1521 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arg_parsing.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/log_fixup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_kptr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/prog_tests_framework.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_kptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_log_fixup.c
 create mode 100644 tools/testing/selftests/bpf/verifier/map_kptr.c
