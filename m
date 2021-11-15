Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7516A450986
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhKOQXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:23:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:47448 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbhKOQXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:23:09 -0500
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mmeiH-00017B-14; Mon, 15 Nov 2021 17:20:09 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, quentin@isovalent.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: pull-request: bpf-next 2021-11-15
Date:   Mon, 15 Nov 2021 17:20:08 +0100
Message-Id: <20211115162008.25916-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26354/Mon Nov 15 10:21:07 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

There are two merge conflicts in tools/bpf/bpftool/Makefile due to commit
e41ac2020bca ("bpftool: Install libbpf headers for the bootstrap version, too")
from bpf tree and commit 6501182c08f7 ("bpftool: Normalize compile rules to
specify output file last") from bpf-next tree. Resolve as follows:

Conflict 1:

<<<<<<< HEAD
                -I$(LIBBPF_BOOTSTRAP_INCLUDE) \
                -g -O2 -Wall -target bpf -c $< -o $@ && $(LLVM_STRIP) -g $@
=======
                -I$(LIBBPF_INCLUDE) \
                -g -O2 -Wall -target bpf -c $< -o $@
        $(Q)$(LLVM_STRIP) -g $@
>>>>>>> e5043894b21f7d99d3db31ad06308d6c5726caa6

Result should look like:

$(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF_BOOTSTRAP)
        $(QUIET_CLANG)$(CLANG) \
                -I$(if $(OUTPUT),$(OUTPUT),.) \
                -I$(srctree)/tools/include/uapi/ \
                -I$(LIBBPF_BOOTSTRAP_INCLUDE) \
                -g -O2 -Wall -target bpf -c $< -o $@
        $(Q)$(LLVM_STRIP) -g $@

Conflict 2:

<<<<<<< HEAD
$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
        $(QUIET_CC)$(HOSTCC) \
                $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),$(CFLAGS)) \
                -c -MMD -o $@ $<
=======
$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
        $(QUIET_CC)$(HOSTCC) $(CFLAGS) -c -MMD $< -o $@
>>>>>>> e5043894b21f7d99d3db31ad06308d6c5726caa6

Result should look like:

$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_BOOTSTRAP_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
        $(QUIET_CC)$(HOSTCC) \
                $(subst -I$(LIBBPF_INCLUDE),-I$(LIBBPF_BOOTSTRAP_INCLUDE),$(CFLAGS)) \
                -c -MMD $< -o $@

We've added 72 non-merge commits during the last 13 day(s) which contain
a total of 171 files changed, 2728 insertions(+), 1143 deletions(-).

The main changes are:

1) Add btf_type_tag attributes to bring kernel annotations like __user/__rcu to
   BTF such that BPF verifier will be able to detect misuse, from Yonghong Song.

2) Big batch of libbpf improvements including various fixes, future proofing APIs,
   and adding a unified, OPTS-based bpf_prog_load() low-level API, from Andrii Nakryiko.

3) Add ingress_ifindex to BPF_SK_LOOKUP program type for selectively applying the
   programmable socket lookup logic to packets from a given netdev, from Mark Pashmfouroush.

4) Remove the 128M upper JIT limit for BPF programs on arm64 and add selftest to
   ensure exception handling still works, from Russell King and Alan Maguire.

5) Add a new bpf_find_vma() helper for tracing to map an address to the backing
   file such as shared library, from Song Liu.

6) Batch of various misc fixes to bpftool, fixing a memory leak in BPF program dump,
   updating documentation and bash-completion among others, from Quentin Monnet.

7) Deprecate libbpf bpf_program__get_prog_info_linear() API and migrate its users as
   the API is heavily tailored around perf and is non-generic, from Dave Marchevsky.

8) Enable libbpf's strict mode by default in bpftool and add a --legacy option as an
   opt-out for more relaxed BPF program requirements, from Stanislav Fomichev.

9) Fix bpftool to use libbpf_get_error() to check for errors, from Hengqi Chen.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alan Maguire, Alexei Starovoitov, Andrii Nakryiko, Dave Marchevsky, Eric 
Dumazet, Hengqi Chen, Jakub Kicinski, Jean-Philippe Brucker, Jesper 
Dangaard Brouer, Joe Stringer, Kumar Kartikeya Dwivedi, Quentin Monnet, 
Song Liu, Tobias Klauser, Yonghong Song

----------------------------------------------------------------

The following changes since commit cc0356d6a02e064387c16a83cb96fe43ef33181e:

  Merge tag 'x86_core_for_v5.16_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2021-11-02 07:56:47 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to e5043894b21f7d99d3db31ad06308d6c5726caa6:

  bpftool: Use libbpf_get_error() to check error (2021-11-14 18:38:13 -0800)

----------------------------------------------------------------
Alan Maguire (1):
      selftests/bpf: Add exception handling selftests for tp_bpf program

Alexei Starovoitov (9):
      Merge branch 'libbpf ELF sanity checking improvements'
      Merge branch 'libbpf: add unified bpf_prog_load() low-level API'
      Merge branch 'Fix leaks in libbpf and selftests'
      Merge branch 'introduce bpf_find_vma'
      Merge branch 'Get ingress_ifindex in BPF_SK_LOOKUP prog type'
      Merge branch 'selftests/bpf: fix test_progs' log_level logic'
      Merge branch 'Future-proof more tricky libbpf APIs'
      Merge branch 'Support BTF_KIND_TYPE_TAG for btf_type_tag attributes'
      Merge branch 'introduce btf_tracing_ids'

Andrii Nakryiko (41):
      Merge branch 'libbpf: deprecate bpf_program__get_prog_info_linear'
      libbpf: Detect corrupted ELF symbols section
      libbpf: Improve sanity checking during BTF fix up
      libbpf: Validate that .BTF and .BTF.ext sections contain data
      libbpf: Fix section counting logic
      libbpf: Improve ELF relo sanitization
      libbpf: Deprecate bpf_program__load() API
      libbpf: Fix non-C89 loop variable declaration in gen_loader.c
      libbpf: Rename DECLARE_LIBBPF_OPTS into LIBBPF_OPTS
      libbpf: Pass number of prog load attempts explicitly
      libbpf: Unify low-level BPF_PROG_LOAD APIs into bpf_prog_load()
      libbpf: Remove internal use of deprecated bpf_prog_load() variants
      libbpf: Stop using to-be-deprecated APIs
      bpftool: Stop using deprecated bpf_load_program()
      libbpf: Remove deprecation attribute from struct bpf_prog_prep_result
      selftests/bpf: Fix non-strict SEC() program sections
      selftests/bpf: Convert legacy prog load APIs to bpf_prog_load()
      selftests/bpf: Merge test_stub.c into testing_helpers.c
      selftests/bpf: Use explicit bpf_prog_test_load() calls everywhere
      selftests/bpf: Use explicit bpf_test_load_program() helper calls
      selftests/bpf: Pass sanitizer flags to linker through LDFLAGS
      libbpf: Free up resources used by inner map definition
      selftests/bpf: Fix memory leaks in btf_type_c_dump() helper
      selftests/bpf: Free per-cpu values array in bpf_iter selftest
      selftests/bpf: Free inner strings index in btf selftest
      selftests/bpf: Clean up btf and btf_dump in dump_datasec test
      selftests/bpf: Avoid duplicate btf__parse() call
      selftests/bpf: Destroy XDP link correctly
      selftests/bpf: Fix bpf_object leak in skb_ctx selftest
      libbpf: Add ability to get/set per-program load flags
      selftests/bpf: Fix bpf_prog_test_load() logic to pass extra log level
      bpftool: Normalize compile rules to specify output file last
      selftests/bpf: Minor cleanups and normalization of Makefile
      libbpf: Turn btf_dedup_opts into OPTS-based struct
      libbpf: Ensure btf_dump__new() and btf_dump_opts are future-proof
      libbpf: Make perf_buffer__new() use OPTS-based interface
      selftests/bpf: Migrate all deprecated perf_buffer uses
      selftests/bpf: Update btf_dump__new() uses to v1.0+ variant
      tools/runqslower: Update perf_buffer__new() calls
      bpftool: Update btf_dump__new() and perf_buffer__new_raw() calls
      Merge branch 'bpftool: miscellaneous fixes'

Dave Marchevsky (4):
      bpftool: Migrate -1 err checks of libbpf fn calls
      bpftool: Use bpf_obj_get_info_by_fd directly
      perf: Pull in bpf_program__get_prog_info_linear
      libbpf: Deprecate bpf_program__get_prog_info_linear

Hengqi Chen (1):
      bpftool: Use libbpf_get_error() to check error

Kumar Kartikeya Dwivedi (1):
      libbpf: Compile using -std=gnu89

Mark Pashmfouroush (2):
      bpf: Add ingress_ifindex to bpf_sk_lookup
      selftests/bpf: Add tests for accessing ingress_ifindex in bpf_sk_lookup

Quentin Monnet (6):
      bpftool: Fix SPDX tag for Makefiles and .gitignore
      bpftool: Fix memory leak in prog_dump()
      bpftool: Remove inclusion of utilities.mak from Makefiles
      bpftool: Fix indent in option lists in the documentation
      bpftool: Update the lists of names for maps and prog-attach types
      bpftool: Fix mixed indentation in documentation

Russell King (1):
      arm64/bpf: Remove 128MB limit for BPF JIT programs

Song Liu (4):
      bpf: Introduce helper bpf_find_vma
      selftests/bpf: Add tests for bpf_find_vma
      bpf: Extend BTF_ID_LIST_GLOBAL with parameter for number of IDs
      bpf: Introduce btf_tracing_ids

Stanislav Fomichev (1):
      bpftool: Enable libbpf's strict mode by default

Yonghong Song (12):
      bpf: Support BTF_KIND_TYPE_TAG for btf_type_tag attributes
      libbpf: Support BTF_KIND_TYPE_TAG
      bpftool: Support BTF_KIND_TYPE_TAG
      selftests/bpf: Test libbpf API function btf__add_type_tag()
      selftests/bpf: Add BTF_KIND_TYPE_TAG unit tests
      selftests/bpf: Test BTF_KIND_DECL_TAG for deduplication
      selftests/bpf: Rename progs/tag.c to progs/btf_decl_tag.c
      selftests/bpf: Add a C test for btf_type_tag
      selftests/bpf: Clarify llvm dependency with btf_tag selftest
      docs/bpf: Update documentation for BTF_KIND_TYPE_TAG support
      selftests/bpf: Fix an unused-but-set-variable compiler warning
      selftests/bpf: Fix a tautological-constant-out-of-range-compare compiler warning

 Documentation/bpf/btf.rst                          |  13 +-
 arch/arm64/include/asm/extable.h                   |   9 -
 arch/arm64/include/asm/memory.h                    |   5 +-
 arch/arm64/kernel/traps.c                          |   2 +-
 arch/arm64/mm/ptdump.c                             |   2 -
 arch/arm64/net/bpf_jit_comp.c                      |   7 +-
 include/linux/bpf.h                                |   1 +
 include/linux/btf_ids.h                            |  20 +-
 include/linux/filter.h                             |   7 +-
 include/uapi/linux/bpf.h                           |  21 ++
 include/uapi/linux/btf.h                           |   3 +-
 kernel/bpf/bpf_task_storage.c                      |   4 +-
 kernel/bpf/btf.c                                   |  19 +-
 kernel/bpf/mmap_unlock_work.h                      |  65 ++++
 kernel/bpf/stackmap.c                              |  82 +----
 kernel/bpf/task_iter.c                             |  82 ++++-
 kernel/bpf/verifier.c                              |  34 ++
 kernel/trace/bpf_trace.c                           |   6 +-
 net/core/filter.c                                  |  13 +-
 net/ipv4/inet_hashtables.c                         |   8 +-
 net/ipv4/udp.c                                     |   8 +-
 net/ipv6/inet6_hashtables.c                        |   8 +-
 net/ipv6/udp.c                                     |   8 +-
 tools/bpf/bpftool/.gitignore                       |   2 +-
 tools/bpf/bpftool/Documentation/Makefile           |   3 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |  12 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   8 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |  66 ++--
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   8 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |   6 +-
 tools/bpf/bpftool/Documentation/common_options.rst |   9 +
 tools/bpf/bpftool/Makefile                         |  19 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   5 +-
 tools/bpf/bpftool/btf.c                            |  13 +-
 tools/bpf/bpftool/btf_dumper.c                     |  42 ++-
 tools/bpf/bpftool/common.c                         |   1 +
 tools/bpf/bpftool/feature.c                        |   2 +-
 tools/bpf/bpftool/gen.c                            |  12 +-
 tools/bpf/bpftool/iter.c                           |   7 +-
 tools/bpf/bpftool/main.c                           |  13 +-
 tools/bpf/bpftool/main.h                           |   3 +-
 tools/bpf/bpftool/map.c                            |  13 +-
 tools/bpf/bpftool/map_perf_ring.c                  |   9 +-
 tools/bpf/bpftool/prog.c                           | 214 +++++++++---
 tools/bpf/bpftool/struct_ops.c                     |  16 +-
 tools/bpf/runqslower/runqslower.c                  |   6 +-
 tools/include/uapi/linux/bpf.h                     |  21 ++
 tools/include/uapi/linux/btf.h                     |   3 +-
 tools/lib/bpf/Makefile                             |   1 +
 tools/lib/bpf/bpf.c                                | 166 +++++----
 tools/lib/bpf/bpf.h                                |  74 +++-
 tools/lib/bpf/bpf_gen_internal.h                   |   8 +-
 tools/lib/bpf/btf.c                                |  69 ++--
 tools/lib/bpf/btf.h                                |  80 ++++-
 tools/lib/bpf/btf_dump.c                           |  40 ++-
 tools/lib/bpf/gen_loader.c                         |  33 +-
 tools/lib/bpf/libbpf.c                             | 376 ++++++++++++---------
 tools/lib/bpf/libbpf.h                             | 102 +++++-
 tools/lib/bpf/libbpf.map                           |  13 +
 tools/lib/bpf/libbpf_common.h                      |  14 +-
 tools/lib/bpf/libbpf_internal.h                    |  33 +-
 tools/lib/bpf/libbpf_legacy.h                      |   1 +
 tools/lib/bpf/libbpf_probes.c                      |  20 +-
 tools/lib/bpf/linker.c                             |   4 +-
 tools/lib/bpf/xsk.c                                |  34 +-
 tools/perf/Documentation/perf.data-file-format.txt |   2 +-
 tools/perf/util/Build                              |   1 +
 tools/perf/util/annotate.c                         |   3 +-
 tools/perf/util/bpf-event.c                        |  41 ++-
 tools/perf/util/bpf-event.h                        |   2 +-
 tools/perf/util/bpf-utils.c                        | 261 ++++++++++++++
 tools/perf/util/bpf-utils.h                        |  76 +++++
 tools/perf/util/bpf_counter.c                      |   6 +-
 tools/perf/util/dso.c                              |   1 +
 tools/perf/util/env.c                              |   1 +
 tools/perf/util/header.c                           |  13 +-
 tools/testing/selftests/bpf/Makefile               |  71 ++--
 tools/testing/selftests/bpf/README.rst             |   9 +-
 .../selftests/bpf/benchs/bench_bloom_filter_map.c  |  17 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |   8 +-
 tools/testing/selftests/bpf/btf_helpers.c          |  17 +-
 tools/testing/selftests/bpf/flow_dissector_load.h  |   3 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |   5 +-
 tools/testing/selftests/bpf/prog_tests/align.c     |  11 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   8 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       | 207 +++++++++---
 .../selftests/bpf/prog_tests/btf_dedup_split.c     |   6 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  41 ++-
 tools/testing/selftests/bpf/prog_tests/btf_split.c |   4 +-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   |  44 ++-
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  67 ++--
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |   2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |   2 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |   2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/exhandler.c |  43 +++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   8 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |  33 +-
 tools/testing/selftests/bpf/prog_tests/find_vma.c  | 117 +++++++
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |   2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |   4 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   9 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   2 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |   2 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   8 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |   2 +-
 .../selftests/bpf/prog_tests/load_bytes_relative.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |   4 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |   4 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   6 +-
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |   2 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |   2 +-
 .../selftests/bpf/prog_tests/queue_stack_map.c     |   2 +-
 .../raw_tp_writable_reject_nbd_invalid.c           |  14 +-
 .../bpf/prog_tests/raw_tp_writable_test_run.c      |  29 +-
 .../selftests/bpf/prog_tests/signal_pending.c      |   2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |  31 ++
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   4 +-
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   2 +-
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |  19 +-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |   4 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |   2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |   2 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  18 +-
 .../selftests/bpf/prog_tests/task_fd_query_rawtp.c |   2 +-
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |   4 +-
 .../testing/selftests/bpf/prog_tests/tcp_estats.c  |   2 +-
 .../selftests/bpf/prog_tests/tp_attach_query.c     |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |   2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |   6 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   6 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   7 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |   2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |   2 +-
 .../selftests/bpf/progs/{tag.c => btf_decl_tag.c}  |   4 -
 tools/testing/selftests/bpf/progs/btf_type_tag.c   |  25 ++
 tools/testing/selftests/bpf/progs/exhandler_kern.c |  43 +++
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |   2 +-
 tools/testing/selftests/bpf/progs/find_vma.c       |  69 ++++
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |  29 ++
 tools/testing/selftests/bpf/progs/find_vma_fail2.c |  29 ++
 tools/testing/selftests/bpf/progs/test_l4lb.c      |   2 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |   2 +-
 tools/testing/selftests/bpf/progs/test_map_lock.c  |   2 +-
 .../selftests/bpf/progs/test_queue_stack_map.h     |   2 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |   8 +
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |   2 +-
 tools/testing/selftests/bpf/progs/test_spin_lock.c |   2 +-
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |   2 +-
 tools/testing/selftests/bpf/test_btf.h             |   3 +
 tools/testing/selftests/bpf/test_cgroup_storage.c  |   3 +-
 tools/testing/selftests/bpf/test_dev_cgroup.c      |   3 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |   6 +-
 tools/testing/selftests/bpf/test_lru_map.c         |   9 +-
 tools/testing/selftests/bpf/test_maps.c            |   7 +-
 tools/testing/selftests/bpf/test_sock.c            |  23 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |  13 +-
 tools/testing/selftests/bpf/test_stub.c            |  44 ---
 tools/testing/selftests/bpf/test_sysctl.c          |  23 +-
 tools/testing/selftests/bpf/test_tag.c             |   3 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |   7 +-
 tools/testing/selftests/bpf/test_verifier.c        |  38 +--
 tools/testing/selftests/bpf/testing_helpers.c      |  60 ++++
 tools/testing/selftests/bpf/testing_helpers.h      |   6 +
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |  32 ++
 tools/testing/selftests/bpf/xdping.c               |   3 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   2 -
 171 files changed, 2728 insertions(+), 1143 deletions(-)
 create mode 100644 kernel/bpf/mmap_unlock_work.h
 create mode 100644 tools/perf/util/bpf-utils.c
 create mode 100644 tools/perf/util/bpf-utils.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 rename tools/testing/selftests/bpf/progs/{tag.c => btf_decl_tag.c} (94%)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_type_tag.c
 create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c
 delete mode 100644 tools/testing/selftests/bpf/test_stub.c
