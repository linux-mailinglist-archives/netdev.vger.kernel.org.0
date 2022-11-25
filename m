Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8F5638217
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 02:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKYBYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 20:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKYBYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 20:24:54 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D782036A;
        Thu, 24 Nov 2022 17:24:53 -0800 (PST)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1oyNSU-0007nb-Lm; Fri, 25 Nov 2022 02:24:50 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2022-11-25
Date:   Fri, 25 Nov 2022 02:24:50 +0100
Message-Id: <20221125012450.441-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26730/Thu Nov 24 09:18:49 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 101 non-merge commits during the last 11 day(s) which contain
a total of 109 files changed, 8827 insertions(+), 1129 deletions(-).

There is a merge conflict between commits 1f6e04a1c7b8 ("bpf: Fix offset
calculation error in __copy_map_value and zero_map_value") from net-next
and e5feed0f64f7 ("bpf: Fix copy_map_value, zero_map_value") from bpf-next
in include/linux/bpf.h. Adapt the two hunks to just use the code from the
latter commit.

The main changes are:

1) Support for user defined BPF objects: the use case is to allocate own objects,
   build own object hierarchies and use the building blocks to build own data
   structures flexibly, for example, linked lists in BPF, from Kumar Kartikeya Dwivedi.

2) Add bpf_rcu_read_{,un}lock() support for sleepable programs, from Yonghong Song.

3) Add support storing struct task_struct objects as kptrs in maps, from David Vernet.

4) Batch of BPF map documentation improvements, from Maryam Tahhan and Donald Hunter.

5) Improve BPF verifier to propagate nullness information for branches of register
   to register comparisons, from Eduard Zingerman.

6) Fix cgroup BPF iter infra to hold reference on the start cgroup, from Hou Tao.

7) Fix BPF verifier to not mark fentry/fexit program arguments as trusted given
   it is not the case for them, from Alexei Starovoitov.

8) Improve BPF verifier's realloc handling to better play along with dynamic
   runtime analysis tools like KASAN and friends, from Kees Cook.

9) Remove legacy libbpf mode support from bpftool, from Sahid Orentino Ferdjaoui.

10) Rework zero-len skb redirection checks to avoid potentially breaking existing
    BPF test infra users, from Stanislav Fomichev.

11) Two small refactorings which are independent and have been split out of the
    XDP queueing RFC series, from Toke Høiland-Jørgensen.

12) Fix a memory leak in LSM cgroup BPF selftest, from Wang Yufen.

13) Documentation on how to run BPF CI without patch submission, from Daniel Müller.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Akira Yokosawa, Alan Maguire, Anders Roxell, Bagas Sanjaya, Dan 
Carpenter, Dave Marchevsky, David Vernet, Hao Luo, Jiri Olsa, Joanne 
Koong, kernel test robot, KP Singh, Martin KaFai Lau, Nathan Chancellor, 
Quentin Monnet, Song Liu, Stanislav Fomichev, Toke Høiland-Jørgensen, 
Yonghong Song

----------------------------------------------------------------

The following changes since commit f12ed9c04804eec4f1819097a0fd0b4800adac2f:

  Merge tag 'mlx5-updates-2022-11-12' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux (2022-11-14 11:35:28 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git tags/for-netdev

for you to fetch changes up to 2b3e8f6f5b939ceeb2e097339bf78ebaaf11dfe9:

  docs/bpf: Add BPF_MAP_TYPE_XSKMAP documentation (2022-11-25 00:33:14 +0100)

----------------------------------------------------------------
bpf-next-for-netdev

----------------------------------------------------------------
Alexei Starovoitov (10):
      Merge branch 'propagate nullness information for reg to reg comparisons'
      Merge branch 'Allocated objects, BPF linked lists'
      Merge branch 'Support storing struct task_struct objects as kptrs'
      Merge branch 'bpf: Implement two type cast kfuncs'
      Merge branch 'clean-up bpftool from legacy support'
      Revert "selftests/bpf: Temporarily disable linked list tests"
      selftests/bpf: Workaround for llvm nop-4 bug
      Merge branch 'Support storing struct cgroup * objects as kptrs'
      Merge branch 'bpf: Add bpf_rcu_read_lock() support'
      bpf: Don't mark arguments to fentry/fexit programs as trusted.

Andrii Nakryiko (2):
      Merge branch 'libbpf: Fixed various checkpatch issues'
      libbpf: Ignore hashmap__find() result explicitly in btf_dump

Björn Töpel (2):
      selftests/bpf: Explicitly pass RESOLVE_BTFIDS to sub-make
      selftests/bpf: Pass target triple to get_sys_includes macro

Daniel Müller (2):
      bpf/docs: Document how to run CI without patch submission
      bpf/docs: Include blank lines between bullet points in bpf_devel_QA.rst

David Michael (1):
      libbpf: Fix uninitialized warning in btf_dump_dump_type_data

David Vernet (11):
      bpf: Allow multiple modifiers in reg_type_str() prefix
      bpf: Allow trusted pointers to be passed to KF_TRUSTED_ARGS kfuncs
      bpf: Add kfuncs for storing struct task_struct * as a kptr
      bpf/selftests: Add selftests for new task kfuncs
      bpf: Enable cgroups to be used as kptrs
      selftests/bpf: Add cgroup kfunc / kptr selftests
      bpf: Add bpf_cgroup_ancestor() kfunc
      selftests/bpf: Add selftests for bpf_cgroup_ancestor() kfunc
      bpf: Don't use idx variable when registering kfunc dtors
      bpf: Add bpf_task_from_pid() kfunc
      selftests/bpf: Add selftests for bpf_task_from_pid()

Donald Hunter (4):
      docs/bpf: Fix sample code in MAP_TYPE_ARRAY docs
      docs/bpf: Add table of BPF program types to libbpf docs
      docs/bpf: Document BPF_MAP_TYPE_BLOOM_FILTER
      docs/bpf: Fix sphinx warnings in BPF map docs

Eduard Zingerman (3):
      bpf: propagate nullness information for reg to reg comparisons
      selftests/bpf: check nullness propagation for reg to reg comparisons
      selftests/bpf: allow unpriv bpf for selftests by default

Hou Tao (4):
      bpf: Pass map file to .map_update_batch directly
      bpf: Pin the start cgroup in cgroup_iter_seq_init()
      selftests/bpf: Add cgroup helper remove_cgroup()
      selftests/bpf: Add test for cgroup iterator on a dead cgroup

Ji Rongfeng (1):
      bpf: Update bpf_{g,s}etsockopt() documentation

Kang Minchul (3):
      libbpf: checkpatch: Fixed code alignments in btf.c
      libbpf: Fixed various checkpatch issues in libbpf.c
      libbpf: checkpatch: Fixed code alignments in ringbuf.c

Kees Cook (1):
      bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage

Kumar Kartikeya Dwivedi (33):
      bpf: Remove local kptr references in documentation
      bpf: Remove BPF_MAP_OFF_ARR_MAX
      bpf: Fix copy_map_value, zero_map_value
      bpf: Support bpf_list_head in map values
      bpf: Rename RET_PTR_TO_ALLOC_MEM
      bpf: Rename MEM_ALLOC to MEM_RINGBUF
      bpf: Refactor btf_struct_access
      bpf: Fix early return in map_check_btf
      bpf: Do btf_record_free outside map_free callback
      bpf: Free inner_map_meta when btf_record_dup fails
      bpf: Populate field_offs for inner_map_meta
      bpf: Introduce allocated objects support
      bpf: Recognize lock and list fields in allocated objects
      bpf: Verify ownership relationships for user BTF types
      bpf: Allow locking bpf_spin_lock in allocated objects
      bpf: Allow locking bpf_spin_lock global variables
      bpf: Allow locking bpf_spin_lock in inner map values
      bpf: Rewrite kfunc argument handling
      bpf: Support constant scalar arguments for kfuncs
      bpf: Introduce bpf_obj_new
      bpf: Introduce bpf_obj_drop
      bpf: Permit NULL checking pointer with non-zero fixed offset
      bpf: Introduce single ownership BPF linked list API
      bpf: Add 'release on unlock' logic for bpf_list_push_{front,back}
      bpf: Add comments for map BTF matching requirement for bpf_list_head
      selftests/bpf: Add __contains macro to bpf_experimental.h
      selftests/bpf: Update spinlock selftest
      selftests/bpf: Add failure test cases for spin lock pairing
      selftests/bpf: Add BPF linked list API tests
      selftests/bpf: Add BTF sanity tests
      selftests/bpf: Temporarily disable linked list tests
      selftests/bpf: Skip spin lock failure test on s390x
      bpf: Disallow bpf_obj_new_impl call when bpf_mem_alloc_init fails

Maryam Tahhan (5):
      bpf, docs: Fixup cpumap sphinx >= 3.1 warning
      bpf, docs: DEVMAPs and XDP_REDIRECT
      docs/bpf: Fix sphinx warnings for cpumap
      docs/bpf: Fix sphinx warnings for devmap
      docs/bpf: Add BPF_MAP_TYPE_XSKMAP documentation

Rong Tao (2):
      docs/bpf: Update btf selftests program and add link
      samples/bpf: Fix wrong allocation size in xdp_router_ipv4_user

Sahid Orentino Ferdjaoui (5):
      bpftool: remove support of --legacy option for bpftool
      bpftool: replace return value PTR_ERR(NULL) with 0
      bpftool: fix error message when function can't register struct_ops
      bpftool: clean-up usage of libbpf_get_error()
      bpftool: remove function free_btf_vmlinux()

Stanislav Fomichev (6):
      bpf: Move skb->len == 0 checks into __bpf_redirect
      selftests/bpf: Make sure zero-len skbs aren't redirectable
      selftests/bpf: Mount debugfs in setns_by_fd
      bpf: Prevent decl_tag from being referenced in func_proto arg
      selftests/bpf: Add reproducer for decl_tag in func_proto argument
      bpf: Unify and simplify btf_func_proto_check error handling

Tiezhu Yang (2):
      bpftool: Check argc first before "file" in do_batch()
      bpf, samples: Use "grep -E" instead of "egrep"

Toke Høiland-Jørgensen (2):
      dev: Move received_rps counter next to RPS members in softnet data
      bpf: Expand map key argument of bpf_redirect_map to u64

Wang Yufen (1):
      selftests/bpf: fix memory leak of lsm_cgroup

Yonghong Song (9):
      bpf: Add support for kfunc set with common btf_ids
      bpf: Add a kfunc to type cast from bpf uapi ctx to kernel ctx
      bpf: Add a kfunc for generic type cast
      bpf: Add type cast unit tests
      bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set
      compiler_types: Define __rcu as __attribute__((btf_type_tag("rcu")))
      bpf: Introduce might_sleep field in bpf_func_proto
      bpf: Add kfunc bpf_rcu_read_lock/unlock()
      selftests/bpf: Add tests for bpf_rcu_read_lock()

 Documentation/bpf/bpf_design_QA.rst                |   11 +-
 Documentation/bpf/bpf_devel_QA.rst                 |   27 +
 Documentation/bpf/btf.rst                          |    7 +-
 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/kfuncs.rst                       |   54 +-
 Documentation/bpf/libbpf/index.rst                 |    3 +
 Documentation/bpf/libbpf/program_types.rst         |  203 +++
 Documentation/bpf/map_array.rst                    |   22 +-
 Documentation/bpf/map_bloom_filter.rst             |  174 ++
 Documentation/bpf/map_cpumap.rst                   |   59 +-
 Documentation/bpf/map_devmap.rst                   |  238 +++
 Documentation/bpf/map_hash.rst                     |   33 +-
 Documentation/bpf/map_lpm_trie.rst                 |   24 +-
 Documentation/bpf/map_of_maps.rst                  |    6 +-
 Documentation/bpf/map_queue_stack.rst              |   36 +-
 Documentation/bpf/map_xskmap.rst                   |  192 +++
 Documentation/bpf/programs.rst                     |    3 +
 Documentation/bpf/redirect.rst                     |   81 +
 include/linux/bpf.h                                |  154 +-
 include/linux/bpf_verifier.h                       |   37 +-
 include/linux/btf.h                                |  137 +-
 include/linux/btf_ids.h                            |    2 +-
 include/linux/compiler_types.h                     |    3 +-
 include/linux/filter.h                             |   20 +-
 include/linux/netdevice.h                          |    2 +-
 include/uapi/linux/bpf.h                           |   33 +-
 kernel/bpf/arraymap.c                              |    1 -
 kernel/bpf/bpf_lsm.c                               |    6 +-
 kernel/bpf/btf.c                                   |  882 +++++-----
 kernel/bpf/cgroup_iter.c                           |   14 +
 kernel/bpf/core.c                                  |   16 +
 kernel/bpf/cpumap.c                                |    4 +-
 kernel/bpf/devmap.c                                |    4 +-
 kernel/bpf/hashtab.c                               |    1 -
 kernel/bpf/helpers.c                               |  363 +++-
 kernel/bpf/map_in_map.c                            |   48 +-
 kernel/bpf/ringbuf.c                               |    6 +-
 kernel/bpf/syscall.c                               |   96 +-
 kernel/bpf/verifier.c                              | 1791 +++++++++++++++++---
 kernel/trace/bpf_trace.c                           |    6 +-
 net/bpf/bpf_dummy_struct_ops.c                     |   14 +-
 net/bpf/test_run.c                                 |    3 -
 net/core/filter.c                                  |   57 +-
 net/ipv4/bpf_tcp_ca.c                              |   17 +-
 net/netfilter/nf_conntrack_bpf.c                   |   17 +-
 net/xdp/xskmap.c                                   |    4 +-
 samples/bpf/test_cgrp2_tc.sh                       |    2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |    2 +-
 tools/bpf/bpftool/Documentation/common_options.rst |    9 -
 tools/bpf/bpftool/Documentation/substitutions.rst  |    2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    2 +-
 tools/bpf/bpftool/btf.c                            |   19 +-
 tools/bpf/bpftool/btf_dumper.c                     |    2 +-
 tools/bpf/bpftool/gen.c                            |   10 +-
 tools/bpf/bpftool/iter.c                           |   10 +-
 tools/bpf/bpftool/main.c                           |   28 +-
 tools/bpf/bpftool/main.h                           |    3 +-
 tools/bpf/bpftool/map.c                            |   20 +-
 tools/bpf/bpftool/prog.c                           |   15 +-
 tools/bpf/bpftool/struct_ops.c                     |   22 +-
 tools/include/uapi/linux/bpf.h                     |   33 +-
 tools/lib/bpf/btf.c                                |    5 +-
 tools/lib/bpf/btf_dump.c                           |    4 +-
 tools/lib/bpf/libbpf.c                             |   48 +-
 tools/lib/bpf/ringbuf.c                            |    4 +-
 tools/testing/selftests/bpf/DENYLIST.aarch64       |    2 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |    5 +
 tools/testing/selftests/bpf/Makefile               |   14 +-
 tools/testing/selftests/bpf/bpf_experimental.h     |   68 +
 tools/testing/selftests/bpf/cgroup_helpers.c       |   19 +
 tools/testing/selftests/bpf/cgroup_helpers.h       |    1 +
 tools/testing/selftests/bpf/config                 |    1 +
 tools/testing/selftests/bpf/network_helpers.c      |    4 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |   14 +
 .../testing/selftests/bpf/prog_tests/cgroup_iter.c |   76 +
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |  175 ++
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |    2 +-
 tools/testing/selftests/bpf/prog_tests/empty_skb.c |  146 ++
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |    2 +-
 .../testing/selftests/bpf/prog_tests/linked_list.c |  740 ++++++++
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |   17 +-
 .../selftests/bpf/prog_tests/rcu_read_lock.c       |  158 ++
 tools/testing/selftests/bpf/prog_tests/spin_lock.c |  142 ++
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |   45 -
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |  163 ++
 tools/testing/selftests/bpf/prog_tests/type_cast.c |  114 ++
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |    2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |    2 +-
 .../selftests/bpf/progs/cgrp_kfunc_common.h        |   72 +
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |  260 +++
 .../selftests/bpf/progs/cgrp_kfunc_success.c       |  170 ++
 tools/testing/selftests/bpf/progs/empty_skb.c      |   37 +
 tools/testing/selftests/bpf/progs/linked_list.c    |  370 ++++
 tools/testing/selftests/bpf/progs/linked_list.h    |   56 +
 .../testing/selftests/bpf/progs/linked_list_fail.c |  581 +++++++
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |    8 +
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |  290 ++++
 .../selftests/bpf/progs/task_kfunc_common.h        |   72 +
 .../selftests/bpf/progs/task_kfunc_failure.c       |  273 +++
 .../selftests/bpf/progs/task_kfunc_success.c       |  222 +++
 tools/testing/selftests/bpf/progs/test_spin_lock.c |    4 +-
 .../selftests/bpf/progs/test_spin_lock_fail.c      |  204 +++
 tools/testing/selftests/bpf/progs/type_cast.c      |   83 +
 .../selftests/bpf/test_bpftool_synctypes.py        |    6 +-
 tools/testing/selftests/bpf/verifier/calls.c       |    2 +-
 .../selftests/bpf/verifier/jeq_infer_not_null.c    |  174 ++
 .../testing/selftests/bpf/verifier/ref_tracking.c  |    4 +-
 tools/testing/selftests/bpf/verifier/ringbuf.c     |    2 +-
 tools/testing/selftests/bpf/verifier/spill_fill.c  |    2 +-
 109 files changed, 8827 insertions(+), 1129 deletions(-)
 create mode 100644 Documentation/bpf/libbpf/program_types.rst
 create mode 100644 Documentation/bpf/map_bloom_filter.rst
 create mode 100644 Documentation/bpf/map_devmap.rst
 create mode 100644 Documentation/bpf/map_xskmap.rst
 create mode 100644 Documentation/bpf/redirect.rst
 create mode 100644 tools/testing/selftests/bpf/bpf_experimental.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgrp_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/empty_skb.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_list.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rcu_read_lock.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/spin_lock.c
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/spinlock.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/type_cast.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/empty_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_list.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_list.h
 create mode 100644 tools/testing/selftests/bpf/progs/linked_list_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/rcu_read_lock.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_kfunc_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/task_kfunc_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_kfunc_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_spin_lock_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/type_cast.c
 create mode 100644 tools/testing/selftests/bpf/verifier/jeq_infer_not_null.c
