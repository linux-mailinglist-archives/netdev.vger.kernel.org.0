Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0E69B560
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjBQWRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBQWRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:17:51 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF88C64B30;
        Fri, 17 Feb 2023 14:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References;
        bh=B0LFNuh0B48DPjcpSQRk/ZGkwnuRsgrzZQIpoRNIMpw=; b=YM0auQ97p0VNrZQmszEgCBkt6O
        fKCta4nIK4NfKL30KVQmgHiefJjNPu1+EcM49Bd9CPRlbsMQLWODfr1KnKtIHWKDzE2fyzlkX7u4V
        BvFD6OEz8na9uerD6mL/zoUinRIhhBtyGKbOZTKbfB8jn9RhhUkbMf4q4rykbma0ds2X0YsGVkZcu
        6+m7WokFWSTa4DtXXF6W+2IfHUc0dcBVF+LsJVsezX8RhQ4Zjbw0G8/tU4hVDexFUCVwnGfqnqNj0
        uEI0sOvkKqxBU7YNLIxGr8I4nzz9Q0M5RZ23mwj9UUKnbs+0XfKZKEdEYVMqsfRdmODMxYxaW4Sun
        1F77mFjg==;
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pT92v-000MRO-OY; Fri, 17 Feb 2023 23:17:37 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org,
        aleksander.lobakin@intel.com, maciej.fijalkowski@intel.com
Subject: pull-request: bpf-next 2023-02-17
Date:   Fri, 17 Feb 2023 23:17:37 +0100
Message-Id: <20230217221737.31122-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26815/Fri Feb 17 09:41:01 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 64 non-merge commits during the last 7 day(s) which contain
a total of 158 files changed, 4190 insertions(+), 988 deletions(-).

There is a small merge conflict between aa1d3faf71a6 ("ice: Robustify
cleaning/completing XDP Tx buffers") from bpf-next and recent merge in
675f176b4dcc ("Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net"),
result should look like the following (CC'ing Alexander & Maciej just in
case):

  [...]
                if (tx_buf->type == ICE_TX_BUF_XSK_TX) {
                        tx_buf->type = ICE_TX_BUF_EMPTY;
                        ice_clean_xdp_tx_buf(xdp_ring, tx_buf);
                } else {
  [...]

The main changes are:

1) Add a rbtree data structure following the "next-gen data structure" precedent
   set by recently-added linked-list, that is, by using kfunc + kptr instead of
   adding a new BPF map type, from Dave Marchevsky.

2) Add a new benchmark for hashmap lookups to BPF selftests, from Anton Protopopov.

3) Fix bpf_fib_lookup to only return valid neighbors and add an option to skip
   the neigh table lookup, from Martin KaFai Lau.

4) Add cgroup.memory=nobpf kernel parameter option to disable BPF memory
   accouting for container environments, from Yafang Shao.

5) Batch of ice multi-buffer and driver performance fixes, from Alexander Lobakin.

6) Fix a bug in determining whether global subprog's argument is PTR_TO_CTX,
   which is based on type names which breaks kprobe progs, from Andrii Nakryiko.

7) Prep work for future -mcpu=v4 LLVM option which includes usage of BPF_ST insn.
   Thus improve BPF_ST-related value tracking in verifier, from Eduard Zingerman.

8) More prep work for later building selftests with Memory Sanitizer in order
   to detect usages of undefined memory, from Ilya Leoshkevich.

9) Fix xsk sockets to check IFF_UP earlier to avoid a NULL pointer dereference
   via sendmsg(), from Maciej Fijalkowski.

10) Implement BPF trampoline for RV64 JIT compiler, from Pu Lehui.

11) Fix BPF memory allocator in combination with BPF hashtab where it could
    corrupt special fields e.g. used in bpf_spin_lock, from Hou Tao.

12) Fix LoongArch BPF JIT to always use 4 instructions for function address
    so that instruction sequences don't change between passes, from Hengqi Chen.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexander Lobakin, Arnaldo Carvalho de Melo, Björn Töpel, Conor Dooley, 
David Vernet, Jiri Olsa, Johannes Weiner, kernel test robot, Kumar 
Kartikeya Dwivedi, Maciej Fijalkowski, Quentin Monnet, Randy Dunlap, 
Roberto Sassu, Roman Gushchin, Stanislav Fomichev, Stephen Rothwell, 
Tiezhu Yang, Toke Høiland-Jørgensen

----------------------------------------------------------------

The following changes since commit de4287336794f49323a5223c8b6e131f4840a866:

  Daniel Borkmann says: (2023-02-10 17:51:27 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 168de0233586fb06c5c5c56304aa9a928a09b0ba:

  selftests/bpf: Add bpf_fib_lookup test (2023-02-17 22:12:04 +0100)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alan Maguire (1):
      bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25

Alexander Lobakin (7):
      ice: fix ice_tx_ring:: Xdp_tx_active underflow
      ice: Fix XDP Tx ring overrun
      ice: Remove two impossible branches on XDP Tx cleaning
      ice: Robustify cleaning/completing XDP Tx buffers
      ice: Fix freeing XDP frames backed by Page Pool
      ice: Micro-optimize .ndo_xdp_xmit() path
      bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES

Alexei Starovoitov (6):
      Merge branch 'bpf, mm: introduce cgroup.memory=nobpf'
      Merge branch 'BPF rbtree next-gen datastructure'
      Revert "bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25"
      selftests/bpf: Fix map_kptr test.
      Merge branch 'Improvements for BPF_ST tracking by verifier '
      Merge branch 'Use __GFP_ZERO in bpf memory allocator'

Andrii Nakryiko (4):
      Merge branch 'New benchmark for hashmap lookups'
      bpf: Fix global subprog context argument resolution logic
      selftests/bpf: Convert test_global_funcs test to test_loader framework
      selftests/bpf: Add global subprog context passing tests

Anton Protopopov (7):
      selftest/bpf/benchs: Fix a typo in bpf_hashmap_full_update
      selftest/bpf/benchs: Make a function static in bpf_hashmap_full_update
      selftest/bpf/benchs: Enhance argp parsing
      selftest/bpf/benchs: Remove an unused header
      selftest/bpf/benchs: Make quiet option common
      selftest/bpf/benchs: Print less if the quiet option is set
      selftest/bpf/benchs: Add benchmark for hashmap lookups

Bagas Sanjaya (1):
      Documentation: bpf: Add missing line break separator in node_data struct code block

Björn Töpel (1):
      selftests/bpf: Cross-compile bpftool

Daniel Borkmann (2):
      docs, bpf: Ensure IETF's BPF mailing list gets copied for ISA doc changes
      Merge branch 'xdp-ice-mbuf'

Dave Marchevsky (9):
      bpf: Migrate release_on_unlock logic to non-owning ref semantics
      bpf: Add basic bpf_rb_{root,node} support
      bpf: Add bpf_rbtree_{add,remove,first} kfuncs
      bpf: Add support for bpf_rb_root and bpf_rb_node in kfunc args
      bpf: Add callback validation to kfunc verifier logic
      bpf: Special verifier handling for bpf_rbtree_{remove, first}
      bpf: Add bpf_rbtree_{add,remove,first} decls to bpf_experimental.h
      selftests/bpf: Add rbtree selftests
      bpf, documentation: Add graph documentation for non-owning refs

David Vernet (1):
      bpf, docs: Add myself to BPF docs MAINTAINERS entry

Eduard Zingerman (4):
      bpf: track immediate values written to stack by BPF_ST instruction
      selftests/bpf: check if verifier tracks constants spilled by BPF_ST_MEM
      bpf: BPF_ST with variable offset should preserve STACK_ZERO marks
      selftests/bpf: check if BPF_ST with variable offset preserves STACK_ZERO

Hengqi Chen (1):
      LoongArch, bpf: Use 4 instructions for function address in JIT

Hou Tao (2):
      bpf: Zeroing allocated object from slab in bpf memory allocator
      selftests/bpf: Add test case for element reuse in htab map

Ilya Leoshkevich (6):
      selftests/bpf: Fix out-of-srctree build
      libbpf: Introduce bpf_{btf,link,map,prog}_get_info_by_fd()
      libbpf: Use bpf_{btf,link,map,prog}_get_info_by_fd()
      bpftool: Use bpf_{btf,link,map,prog}_get_info_by_fd()
      samples/bpf: Use bpf_{btf,link,map,prog}_get_info_by_fd()
      selftests/bpf: Use bpf_{btf,link,map,prog}_get_info_by_fd()

Joanne Koong (2):
      selftests/bpf: Clean up user_ringbuf, cgrp_kfunc, kfunc_dynptr_param tests
      selftests/bpf: Clean up dynptr prog_tests

Maciej Fijalkowski (1):
      xsk: check IFF_UP earlier in Tx path

Martin KaFai Lau (5):
      bpf: Disable bh in bpf_test_run for xdp and tc prog
      bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state
      Revert "bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES"
      bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
      selftests/bpf: Add bpf_fib_lookup test

Pu Lehui (4):
      riscv: Extend patch_text for multiple instructions
      riscv, bpf: Factor out emit_call for kernel and bpf context
      riscv, bpf: Add bpf_arch_text_poke support for RV64
      riscv, bpf: Add bpf trampoline support for RV64

Taichi Nishimura (1):
      Fix typos in selftest/bpf files

Tiezhu Yang (1):
      selftests/bpf: Fix build error for LoongArch

Yafang Shao (4):
      mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
      bpf: use bpf_map_kvcalloc in bpf_local_storage
      bpf: allow to disable bpf map memory accounting
      bpf: allow to disable bpf prog memory accounting

 Documentation/admin-guide/kernel-parameters.txt    |   1 +
 Documentation/bpf/graph_ds_impl.rst                | 267 +++++++++
 Documentation/bpf/other.rst                        |   3 +-
 MAINTAINERS                                        |   7 +
 arch/loongarch/net/bpf_jit.c                       |   2 +-
 arch/loongarch/net/bpf_jit.h                       |  21 +
 arch/riscv/include/asm/patch.h                     |   2 +-
 arch/riscv/kernel/patch.c                          |  19 +-
 arch/riscv/kernel/probes/kprobes.c                 |  15 +-
 arch/riscv/net/bpf_jit.h                           |   5 +
 arch/riscv/net/bpf_jit_comp64.c                    | 435 ++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  67 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |  37 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |  88 +--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  12 +-
 include/linux/bpf.h                                |  47 ++
 include/linux/bpf_verifier.h                       |  38 +-
 include/linux/memcontrol.h                         |  11 +
 include/uapi/linux/bpf.h                           |  17 +
 kernel/bpf/bpf_local_storage.c                     |   4 +-
 kernel/bpf/btf.c                                   | 199 +++++--
 kernel/bpf/core.c                                  |  13 +-
 kernel/bpf/hashtab.c                               |   4 +-
 kernel/bpf/helpers.c                               |  94 ++++
 kernel/bpf/memalloc.c                              |   5 +-
 kernel/bpf/syscall.c                               |  48 +-
 kernel/bpf/verifier.c                              | 606 +++++++++++++++++----
 mm/memcontrol.c                                    |  18 +
 net/bpf/test_run.c                                 |   2 +
 net/core/filter.c                                  |  43 +-
 net/xdp/xsk.c                                      |  59 +-
 samples/bpf/test_map_in_map_user.c                 |   2 +-
 samples/bpf/xdp1_user.c                            |   2 +-
 samples/bpf/xdp_adjust_tail_user.c                 |   2 +-
 samples/bpf/xdp_fwd_user.c                         |   4 +-
 samples/bpf/xdp_redirect_cpu_user.c                |   4 +-
 samples/bpf/xdp_rxq_info_user.c                    |   2 +-
 samples/bpf/xdp_sample_pkts_user.c                 |   2 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |   2 +-
 tools/bpf/bpftool/btf.c                            |  13 +-
 tools/bpf/bpftool/btf_dumper.c                     |   4 +-
 tools/bpf/bpftool/cgroup.c                         |   4 +-
 tools/bpf/bpftool/common.c                         |  13 +-
 tools/bpf/bpftool/link.c                           |   4 +-
 tools/bpf/bpftool/main.h                           |   3 +-
 tools/bpf/bpftool/map.c                            |   8 +-
 tools/bpf/bpftool/prog.c                           |  22 +-
 tools/bpf/bpftool/struct_ops.c                     |   6 +-
 tools/include/uapi/asm/bpf_perf_event.h            |   2 +
 tools/include/uapi/linux/bpf.h                     |  17 +
 tools/lib/bpf/bpf.c                                |  20 +
 tools/lib/bpf/bpf.h                                |   9 +
 tools/lib/bpf/btf.c                                |   8 +-
 tools/lib/bpf/libbpf.c                             |  14 +-
 tools/lib/bpf/libbpf.map                           |   5 +
 tools/lib/bpf/netlink.c                            |   2 +-
 tools/lib/bpf/ringbuf.c                            |   4 +-
 tools/testing/selftests/bpf/Makefile               |  37 +-
 tools/testing/selftests/bpf/bench.c                |  59 +-
 tools/testing/selftests/bpf/bench.h                |   2 +
 .../selftests/bpf/benchs/bench_bloom_filter_map.c  |   5 +
 .../bpf/benchs/bench_bpf_hashmap_full_update.c     |   5 +-
 .../bpf/benchs/bench_bpf_hashmap_lookup.c          | 283 ++++++++++
 .../testing/selftests/bpf/benchs/bench_bpf_loop.c  |   1 +
 .../selftests/bpf/benchs/bench_local_storage.c     |   3 +
 .../benchs/bench_local_storage_rcu_tasks_trace.c   |  16 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |   4 +
 tools/testing/selftests/bpf/benchs/bench_strncmp.c |   2 +
 .../benchs/run_bench_bpf_hashmap_full_update.sh    |   2 +-
 .../run_bench_local_storage_rcu_tasks_trace.sh     |   2 +-
 tools/testing/selftests/bpf/bpf_experimental.h     |  24 +
 .../selftests/bpf/map_tests/map_in_map_batch_ops.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   8 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |  20 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  24 +-
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |   2 +-
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |  69 +--
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |  18 +-
 .../selftests/bpf/prog_tests/enable_stats.c        |   2 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  14 +-
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  | 187 +++++++
 .../bpf/prog_tests/flow_dissector_reattach.c       |  10 +-
 .../testing/selftests/bpf/prog_tests/htab_reuse.c  | 101 ++++
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |  72 +--
 .../bpf/prog_tests/libbpf_get_fd_by_id_opts.c      |   4 +-
 .../testing/selftests/bpf/prog_tests/linked_list.c |  51 +-
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |   3 +-
 tools/testing/selftests/bpf/prog_tests/metadata.c  |   8 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |   2 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |   2 +-
 tools/testing/selftests/bpf/prog_tests/perf_link.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |   2 +-
 .../selftests/bpf/prog_tests/prog_run_opts.c       |   2 +-
 tools/testing/selftests/bpf/prog_tests/rbtree.c    | 117 ++++
 tools/testing/selftests/bpf/prog_tests/recursion.c |   4 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   6 +-
 .../selftests/bpf/prog_tests/task_local_storage.c  |   8 +-
 tools/testing/selftests/bpf/prog_tests/tc_bpf.c    |   4 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   | 133 ++---
 .../selftests/bpf/prog_tests/tp_attach_query.c     |   5 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |   2 +-
 .../selftests/bpf/prog_tests/unpriv_bpf_disabled.c |   8 +-
 .../selftests/bpf/prog_tests/user_ringbuf.c        |  62 +--
 .../testing/selftests/bpf/prog_tests/verif_stats.c |   5 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   4 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |   8 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |   8 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |  10 +-
 .../selftests/bpf/progs/bpf_hashmap_lookup.c       |  63 +++
 .../bpf/progs/btf_dump_test_case_syntax.c          |   2 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |  17 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |   2 +-
 tools/testing/selftests/bpf/progs/fib_lookup.c     |  22 +
 tools/testing/selftests/bpf/progs/htab_reuse.c     |  19 +
 tools/testing/selftests/bpf/progs/linked_list.c    |   2 +-
 .../testing/selftests/bpf/progs/linked_list_fail.c | 100 ++--
 tools/testing/selftests/bpf/progs/map_kptr.c       |  12 +-
 tools/testing/selftests/bpf/progs/rbtree.c         | 176 ++++++
 .../bpf/progs/rbtree_btf_fail__add_wrong_type.c    |  52 ++
 .../bpf/progs/rbtree_btf_fail__wrong_node_type.c   |  49 ++
 tools/testing/selftests/bpf/progs/rbtree_fail.c    | 322 +++++++++++
 tools/testing/selftests/bpf/progs/strobemeta.h     |   2 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |   6 +-
 .../selftests/bpf/progs/test_global_func1.c        |   6 +-
 .../selftests/bpf/progs/test_global_func10.c       |   4 +-
 .../selftests/bpf/progs/test_global_func11.c       |   4 +-
 .../selftests/bpf/progs/test_global_func12.c       |   4 +-
 .../selftests/bpf/progs/test_global_func13.c       |   4 +-
 .../selftests/bpf/progs/test_global_func14.c       |   4 +-
 .../selftests/bpf/progs/test_global_func15.c       |   4 +-
 .../selftests/bpf/progs/test_global_func16.c       |   4 +-
 .../selftests/bpf/progs/test_global_func17.c       |   4 +-
 .../selftests/bpf/progs/test_global_func2.c        |  43 +-
 .../selftests/bpf/progs/test_global_func3.c        |  10 +-
 .../selftests/bpf/progs/test_global_func4.c        |  55 +-
 .../selftests/bpf/progs/test_global_func5.c        |   4 +-
 .../selftests/bpf/progs/test_global_func6.c        |   4 +-
 .../selftests/bpf/progs/test_global_func7.c        |   4 +-
 .../selftests/bpf/progs/test_global_func8.c        |   4 +-
 .../selftests/bpf/progs/test_global_func9.c        |   4 +-
 .../bpf/progs/test_global_func_ctx_args.c          | 104 ++++
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |   4 +
 tools/testing/selftests/bpf/progs/test_subprogs.c  |   2 +-
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c  |   2 +-
 .../selftests/bpf/progs/user_ringbuf_fail.c        |  31 +-
 tools/testing/selftests/bpf/test_cpp.cpp           |   2 +-
 tools/testing/selftests/bpf/test_maps.c            |   2 +-
 .../selftests/bpf/test_skb_cgroup_id_user.c        |   2 +-
 .../selftests/bpf/test_tcp_check_syncookie_user.c  |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        |   8 +-
 tools/testing/selftests/bpf/testing_helpers.c      |   2 +-
 .../bpf/verifier/bounds_mix_sign_unsign.c          | 110 ++--
 tools/testing/selftests/bpf/verifier/bpf_st_mem.c  |  67 +++
 tools/testing/selftests/bpf/veristat.c             |   4 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |  15 +-
 158 files changed, 4190 insertions(+), 988 deletions(-)
 create mode 100644 Documentation/bpf/graph_ds_impl.rst
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_lookup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fib_lookup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/htab_reuse.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rbtree.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/fib_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/htab_reuse.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree_btf_fail__add_wrong_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree_btf_fail__wrong_node_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func_ctx_args.c
 create mode 100644 tools/testing/selftests/bpf/verifier/bpf_st_mem.c
