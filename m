Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC39470AF0
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbhLJTyH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Dec 2021 14:54:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60638 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242606AbhLJTyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:54:07 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAJd3fs017207
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:50:31 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cvd18g6nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:50:31 -0800
Received: from intmgw001.46.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 11:50:30 -0800
Received: by devbig019.vll3.facebook.com (Postfix, from userid 137359)
        id 23E00C913D24; Fri, 10 Dec 2021 11:50:27 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <andrii@kernel.org>, <kernel-team@fb.com>
Subject: pull-request: bpf-next 2021-12-10
Date:   Fri, 10 Dec 2021 11:50:27 -0800
Message-ID: <20211210195027.730934-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset="UTF-8"
X-FB-Internal: Safe
X-FB-Source: Intern
X-Proofpoint-GUID: KJxRWwDL53ytTKHfjmmAWC8vL_Vqem8T
X-Proofpoint-ORIG-GUID: KJxRWwDL53ytTKHfjmmAWC8vL_Vqem8T
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_07,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112100108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net-next* tree.

There are three merge conflicts between bpf and bpf-next:

1. Documentation/bpf/index.rst. Please Just drop the libbpf and BTF sections,
   so that the resulting content is like this:

  [...]

  This kernel side documentation is still work in progress.
  The Cilium project also maintains a `BPF and XDP Reference Guide`_
  that goes into great technical depth about the BPF Architecture.

  .. toctree::
     :maxdepth: 1
  
     instruction-set
     verifier
  [...]

2. kernel/bpf/btf.c. There was a big chunk of code added at the end, but git
   is confused about #endif. Please keep the original #endif (corresponding to
   #ifdef CONFIG_DEBUG_INTO_BTF_MODULES) and all the newly added code goes to
   the end of the file:

  --- a/kernel/bpf/btf.c
  +++ b/kernel/bpf/btf.c
  @@@ -6418,384 -6390,4 +6409,386 @@@ bool bpf_check_mod_kfunc_call(struct kf
    DEFINE_KFUNC_BTF_ID_LIST(bpf_tcp_ca_kfunc_list);
    DEFINE_KFUNC_BTF_ID_LIST(prog_test_kfunc_list);

  + #endif
  ++
   +int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
   +                            const struct btf *targ_btf, __u32 targ_id)
   +{
   +      return -EOPNOTSUPP;
   +}
  [...]

3. tools/lib/bpf/libbpf.c, attr->log_level should be replaced with
   extra_log_level, but otherwise 4-parameter invocation of btf_gen__init()
   wins:

  --- a/tools/lib/bpf/libbpf.c
  +++ b/tools/lib/bpf/libbpf.c
  @@@ -7477,7 -7258,7 +7477,7 @@@ static int bpf_object_load(struct bpf_o
          }

          if (obj->gen_loader)
  -               bpf_gen__init(obj->gen_loader, extra_log_level);
   -              bpf_gen__init(obj->gen_loader, attr->log_level, obj->nr_programs, obj->nr_maps);
  ++              bpf_gen__init(obj->gen_loader, extra_log_level, obj->nr_programs, obj->nr_maps);

          err = bpf_object__probe_loading(obj);
          err = err ? : bpf_object__load_vmlinux_btf(obj, false);

We've added 116 non-merge commits during the last 26 day(s) which contain
a total of 182 files changed, 5748 insertions(+), 2568 deletions(-).

The main changes are:

1) Various samples fixes, from Alexander Lobakin.

2) BPF CO-RE support in kernel and light skeleton, from Alexei Starovoitov.

3) A batch of new unified APIs for libbpf, logging improvements, version
   querying, etc. Also a batch of old deprecations for old APIs and various
   bug fixes, in preparation for libbpf 1.0, from Andrii Nakryiko.

4) BPF documentation reorganization and improvements, from Christoph Hellwig
   and Dave Tucker.

5) Support for declarative initialization of BPF_MAP_TYPE_PROG_ARRAY in
   libbpf, from Hengqi Chen.

6) Verifier log fixes, from Hou Tao.

7) Runtime-bounded loops support with bpf_loop() helper, from Joanne Koong.

8) Extend branch record capturing to all platforms that support it,
   from Kajol Jain.

9) Light skeleton codegen improvements, from Kumar Kartikeya Dwivedi.

10) bpftool doc-generating script improvements, from Quentin Monnet.

11) Two libbpf v0.6 bug fixes, from Shuyi Cheng and Vincent Minet.

12) Deprecation warning fix for perf/bpf_counter, from Song Liu.

13) MAX_TAIL_CALL_CNT unification and MIPS build fix for libbpf,
    from Tiezhu Yang.

14) BTF_KING_TYPE_TAG follow-up fixes, from Yonghong Song.

15) Selftests fixes and improvements, from Ilya Leoshkevich, Jean-Philippe
    Brucker, Jiri Olsa, Maxim Mikityanskiy, Tirthendu Sarkar, Yucong Sun,
    and others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Björn Töpel, Evgeny Vereshchagin, Gustavo A. R. Silva, 
Ilya Leoshkevich, Jiri Olsa, Johan Almbladh, John Fastabend, KP Singh, 
Kumar Kartikeya Dwivedi, Maciej Fijalkowski, Martin KaFai Lau, Quentin 
Monnet, Song Liu, Toke Høiland-Jørgensen, Yonghong Song, Zeal Robot

----------------------------------------------------------------

The following changes since commit a5bdc36354cbf1a1a91396f4da548ff484686305:

  Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2021-11-15 08:49:23 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 733719ec4e0b7b4e94e053979f0bbfc489b76f0b:

  libbpf: Add "bool skipped" to struct bpf_map (2021-12-10 10:17:59 -0800)

----------------------------------------------------------------
Alan Maguire (1):
      libbpf: Silence uninitialized warning/error in btf_dump_dump_type_data

Alexander Lobakin (3):
      samples: bpf: Fix conflicting types in fds_example
      samples: bpf: Fix xdp_sample_user.o linking with Clang
      samples: bpf: Fix 'unknown warning group' build warning on Clang

Alexei Starovoitov (22):
      Merge branch 'Add bpf_loop helper'
      libbpf: Replace btf__type_by_id() with btf_type_by_id().
      bpf: Rename btf_member accessors.
      bpf: Prepare relo_core.c for kernel duty.
      bpf: Define enum bpf_core_relo_kind as uapi.
      bpf: Pass a set of bpf_core_relo-s to prog_load command.
      bpf: Adjust BTF log size limit.
      bpf: Add bpf_core_add_cands() and wire it into bpf_core_apply_relo_insn().
      libbpf: Use CO-RE in the kernel in light skeleton.
      libbpf: Support init of inner maps in light skeleton.
      libbpf: Clean gen_loader's attach kind.
      selftests/bpf: Add lskel version of kfunc test.
      selftests/bpf: Improve inner_map test coverage.
      selftests/bpf: Convert map_ptr_kern test to use light skeleton.
      selftests/bpf: Additional test for CO-RE in the kernel.
      selftests/bpf: Revert CO-RE removal in test_ksyms_weak.
      selftests/bpf: Add CO-RE relocations to verifier scale test.
      Merge branch 'Deprecate bpf_prog_load_xattr() API'
      libbpf: Reduce bpf_core_apply_relo_insn() stack usage.
      bpftool: Add debug mode for gen_loader.
      bpf: Silence purge_cand_cache build warning.
      Merge branch 'Enhance and rework logging controls in libbpf'

Andrii Nakryiko (48):
      selftests/bpf: Add uprobe triggering overhead benchmarks
      libbpf: Add runtime APIs to query libbpf version
      libbpf: Accommodate DWARF/compiler bug with duplicated structs
      libbpf: Load global data maps lazily on legacy kernels
      selftests/bpf: Mix legacy (maps) and modern (vars) BPF in one test
      libbpf: Unify low-level map creation APIs w/ new bpf_map_create()
      libbpf: Use bpf_map_create() consistently internally
      libbpf: Prevent deprecation warnings in xsk.c
      selftests/bpf: Migrate selftests to bpf_map_create()
      tools/resolve_btf_ids: Close ELF file on error
      libbpf: Fix potential misaligned memory access in btf_ext__new()
      libbpf: Don't call libc APIs with NULL pointers
      libbpf: Fix glob_syms memory leak in bpf_linker
      libbpf: Fix using invalidated memory in bpf_linker
      selftests/bpf: Fix UBSan complaint about signed __int128 overflow
      selftests/bpf: Fix possible NULL passed to memcpy() with zero size
      selftests/bpf: Prevent misaligned memory access in get_stack_raw_tp test
      selftests/bpf: Fix misaligned memory access in queue_stack_map test
      selftests/bpf: Prevent out-of-bounds stack access in test_bpffs
      selftests/bpf: Fix misaligned memory accesses in xdp_bonding test
      selftests/bpf: Fix misaligned accesses in xdp and xdp_bpf2bpf tests
      Merge branch 'Support static initialization of BPF_MAP_TYPE_PROG_ARRAY'
      Merge branch 'Apply suggestions for typeless/weak ksym series'
      libbpf: Cleanup struct bpf_core_cand.
      Merge branch 'bpf: CO-RE support in the kernel'
      libbpf: Use __u32 fields in bpf_map_create_opts
      libbpf: Add API to get/set log_level at per-program level
      bpftool: Migrate off of deprecated bpf_create_map_xattr() API
      selftests/bpf: Remove recently reintroduced legacy btf__dedup() use
      selftests/bpf: Mute xdpxceiver.c's deprecation warnings
      selftests/bpf: Remove all the uses of deprecated bpf_prog_load_xattr()
      samples/bpf: Clean up samples/bpf build failes
      samples/bpf: Get rid of deprecated libbpf API uses
      libbpf: Deprecate bpf_prog_load_xattr() API
      perf: Mute libbpf API deprecations temporarily
      Merge branch 'samples: bpf: fix build issues with Clang/LLVM'
      libbpf: Fix bpf_prog_load() log_buf logic for log_level 0
      libbpf: Add OPTS-based bpf_btf_load() API
      libbpf: Allow passing preallocated log_buf when loading BTF into kernel
      libbpf: Allow passing user log setting through bpf_object_open_opts
      libbpf: Improve logging around BPF program loading
      libbpf: Preserve kernel error code and remove kprobe prog type guessing
      libbpf: Add per-program log buffer setter and getter
      libbpf: Deprecate bpf_object__load_xattr()
      selftests/bpf: Replace all uses of bpf_load_btf() with bpf_btf_load()
      selftests/bpf: Add test for libbpf's custom log_buf behavior
      selftests/bpf: Remove the only use of deprecated bpf_object__load_xattr()
      bpftool: Switch bpf_object__load_xattr() to bpf_object__load()

Christoph Hellwig (5):
      x86, bpf: Cleanup the top of file header in bpf_jit_comp.c
      bpf: Remove a redundant comment on bpf_prog_free
      bpf, docs: Prune all references to "internal BPF"
      bpf, docs: Move handling of maps to Documentation/bpf/maps.rst
      bpf, docs: Split general purpose eBPF documentation out of filter.rst

Colin Ian King (1):
      bpf: Remove redundant assignment to pointer t

Dave Tucker (3):
      bpf, docs: Change underline in btf to match style guide
      bpf, docs: Rename bpf_lsm.rst to prog_lsm.rst
      bpf, docs: Fix ordering of bpf documentation

Drew Fustini (1):
      selftests/bpf: Fix trivial typo

Florent Revest (1):
      libbpf: Change bpf_program__set_extra_flags to bpf_program__set_flags

Grant Seltzer (1):
      libbpf: Add doc comments in libbpf.h

Hengqi Chen (2):
      libbpf: Support static initialization of BPF_MAP_TYPE_PROG_ARRAY
      selftests/bpf: Test BPF_MAP_TYPE_PROG_ARRAY static initialization

Hou Tao (2):
      bpf: Clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
      bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)

Ilya Leoshkevich (1):
      selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes

Jean-Philippe Brucker (1):
      selftests/bpf: Build testing_helpers.o out of tree

Jiri Olsa (1):
      selftests/bpf: Add btf_dedup case with duplicated structs within CU

Joanne Koong (4):
      bpf: Add bpf_loop helper
      selftests/bpf: Add bpf_loop test
      selftests/bpf: Measure bpf_loop verifier performance
      selftest/bpf/benchs: Add bpf_loop benchmark

Kajol Jain (1):
      bpf: Remove config check to enable bpf support for branch records

Kumar Kartikeya Dwivedi (3):
      bpf: Change bpf_kallsyms_lookup_name size type to ARG_CONST_SIZE_OR_ZERO
      libbpf: Avoid double stores for success/failure case of ksym relocations
      libbpf: Avoid reload of imm for weak, unresolved, repeating ksym

Maxim Mikityanskiy (1):
      bpf: Fix the test_task_vma selftest to support output shorter than 1 kB

Mehrdad Arshad Rad (1):
      libbpf: Remove duplicate assignments

Minghao Chi (1):
      samples/bpf: Remove unneeded variable

Paul E. McKenney (1):
      selftests/bpf: Update test names for xchg and cmpxchg

Quentin Monnet (3):
      bpftool: Add SPDX tags to RST documentation files
      bpftool: Update doc (use susbtitutions) and test_bpftool_synctypes.py
      selftests/bpf: Configure dir paths via env in test_bpftool_synctypes.py

Shuyi Cheng (1):
      libbpf: Add "bool skipped" to struct bpf_map

Song Liu (1):
      perf/bpf_counter: Use bpf_map_create instead of bpf_create_map

Stanislav Fomichev (1):
      bpftool: Add current libbpf_strict mode to version output

Tiezhu Yang (2):
      bpf: Change value of MAX_TAIL_CALL_CNT from 32 to 33
      bpf, mips: Fix build errors about __NR_bpf undeclared

Tirthendu Sarkar (1):
      selftests/bpf: Fix xdpxceiver failures for no hugepages

Vincent Minet (1):
      libbpf: Fix typo in btf__dedup@LIBBPF_0.0.2 definition

Yihao Han (1):
      samples/bpf: xdpsock: Fix swap.cocci warning

Yonghong Song (3):
      libbpf: Fix a couple of missed btf_type_tag handling in btf.c
      selftests/bpf: Add a dedup selftest with equivalent structure types
      selftests/bpf: Fix a compilation warning

Yucong Sun (3):
      selftests/bpf: Move summary line after the error logs
      selftests/bpf: Variable naming fix
      selftests/bpf: Mark variable as static

huangxuesen (1):
      libbpf: Fix trivial typo

 Documentation/bpf/btf.rst                          |   44 +-
 Documentation/bpf/faq.rst                          |   11 +
 Documentation/bpf/helpers.rst                      |    7 +
 Documentation/bpf/index.rst                        |  102 +-
 Documentation/bpf/instruction-set.rst              |  467 +++++++++
 Documentation/bpf/libbpf/index.rst                 |    4 +-
 Documentation/bpf/maps.rst                         |   52 +
 Documentation/bpf/other.rst                        |    9 +
 Documentation/bpf/{bpf_lsm.rst => prog_lsm.rst}    |    0
 Documentation/bpf/programs.rst                     |    9 +
 Documentation/bpf/syscall_api.rst                  |   11 +
 Documentation/bpf/test_debug.rst                   |    9 +
 Documentation/bpf/verifier.rst                     |  529 ++++++++++
 Documentation/networking/filter.rst                | 1036 +-------------------
 MAINTAINERS                                        |    2 +-
 arch/arm/net/bpf_jit_32.c                          |    7 +-
 arch/arm64/net/bpf_jit_comp.c                      |    7 +-
 arch/mips/net/bpf_jit_comp32.c                     |    3 +-
 arch/mips/net/bpf_jit_comp64.c                     |    2 +-
 arch/powerpc/net/bpf_jit_comp32.c                  |    4 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |    4 +-
 arch/riscv/net/bpf_jit_comp32.c                    |    6 +-
 arch/riscv/net/bpf_jit_comp64.c                    |    7 +-
 arch/s390/net/bpf_jit_comp.c                       |    6 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |    4 +-
 arch/x86/net/bpf_jit_comp.c                        |   14 +-
 arch/x86/net/bpf_jit_comp32.c                      |    4 +-
 include/linux/bpf.h                                |   11 +-
 include/linux/bpf_verifier.h                       |    7 +
 include/linux/btf.h                                |   89 +-
 include/uapi/linux/bpf.h                           |  105 +-
 kernel/bpf/Makefile                                |    4 +
 kernel/bpf/bpf_iter.c                              |   35 +
 kernel/bpf/bpf_struct_ops.c                        |    6 +-
 kernel/bpf/btf.c                                   |  410 +++++++-
 kernel/bpf/core.c                                  |    6 +-
 kernel/bpf/helpers.c                               |    2 +
 kernel/bpf/syscall.c                               |    4 +-
 kernel/bpf/verifier.c                              |  180 +++-
 kernel/trace/bpf_trace.c                           |    6 +-
 lib/test_bpf.c                                     |    4 +-
 net/core/filter.c                                  |   11 +-
 net/ipv4/bpf_tcp_ca.c                              |    6 +-
 samples/bpf/Makefile                               |   18 +-
 samples/bpf/Makefile.target                        |   11 -
 samples/bpf/cookie_uid_helper_example.c            |   14 +-
 samples/bpf/fds_example.c                          |   29 +-
 samples/bpf/hbm_kern.h                             |    2 -
 samples/bpf/lwt_len_hist_kern.c                    |    7 -
 samples/bpf/map_perf_test_user.c                   |   15 +-
 samples/bpf/sock_example.c                         |   12 +-
 samples/bpf/sockex1_user.c                         |   15 +-
 samples/bpf/sockex2_user.c                         |   14 +-
 samples/bpf/test_cgrp2_array_pin.c                 |    4 +-
 samples/bpf/test_cgrp2_attach.c                    |   13 +-
 samples/bpf/test_cgrp2_sock.c                      |    8 +-
 samples/bpf/test_lru_dist.c                        |   11 +-
 samples/bpf/trace_output_user.c                    |    4 +-
 samples/bpf/xdp_redirect_cpu.bpf.c                 |    4 +-
 samples/bpf/xdp_sample_pkts_user.c                 |   22 +-
 samples/bpf/xdp_sample_user.h                      |    2 +
 samples/bpf/xdpsock_ctrl_proc.c                    |    3 +
 samples/bpf/xdpsock_user.c                         |    3 +
 samples/bpf/xsk_fwd.c                              |    8 +-
 tools/bpf/bpftool/Documentation/Makefile           |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |    7 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    7 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |    6 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |    7 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |    6 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |    7 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    7 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |    6 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |    6 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    6 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |    6 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |    7 +-
 tools/bpf/bpftool/Documentation/common_options.rst |    2 +
 tools/bpf/bpftool/Documentation/substitutions.rst  |    3 +
 tools/bpf/bpftool/gen.c                            |   11 +-
 tools/bpf/bpftool/main.c                           |   12 +-
 tools/bpf/bpftool/map.c                            |   23 +-
 tools/bpf/bpftool/prog.c                           |   44 +-
 tools/bpf/bpftool/struct_ops.c                     |   15 +-
 tools/bpf/resolve_btfids/main.c                    |    5 +-
 tools/build/feature/test-bpf.c                     |    6 +
 tools/include/uapi/linux/bpf.h                     |  105 +-
 tools/lib/bpf/bpf.c                                |  234 +++--
 tools/lib/bpf/bpf.h                                |   55 +-
 tools/lib/bpf/bpf_gen_internal.h                   |    9 +-
 tools/lib/bpf/btf.c                                |  139 ++-
 tools/lib/bpf/btf.h                                |    2 +-
 tools/lib/bpf/btf_dump.c                           |    2 +-
 tools/lib/bpf/gen_loader.c                         |  160 ++-
 tools/lib/bpf/libbpf.c                             |  649 ++++++++----
 tools/lib/bpf/libbpf.h                             |  115 ++-
 tools/lib/bpf/libbpf.map                           |   15 +-
 tools/lib/bpf/libbpf_common.h                      |    5 +
 tools/lib/bpf/libbpf_internal.h                    |   24 +-
 tools/lib/bpf/libbpf_probes.c                      |   32 +-
 tools/lib/bpf/libbpf_version.h                     |    2 +-
 tools/lib/bpf/linker.c                             |    6 +-
 tools/lib/bpf/relo_core.c                          |  231 +++--
 tools/lib/bpf/relo_core.h                          |  103 +-
 tools/lib/bpf/skel_internal.h                      |   13 +-
 tools/lib/bpf/xsk.c                                |   18 +-
 tools/perf/tests/bpf.c                             |    4 +
 tools/perf/util/bpf-loader.c                       |    3 +
 tools/perf/util/bpf_counter.c                      |   18 +-
 tools/testing/selftests/bpf/Makefile               |   49 +-
 tools/testing/selftests/bpf/bench.c                |   47 +
 tools/testing/selftests/bpf/bench.h                |    2 +
 .../testing/selftests/bpf/benchs/bench_bpf_loop.c  |  105 ++
 tools/testing/selftests/bpf/benchs/bench_trigger.c |  146 +++
 .../selftests/bpf/benchs/run_bench_bpf_loop.sh     |   15 +
 tools/testing/selftests/bpf/benchs/run_common.sh   |   15 +
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |   13 +-
 .../selftests/bpf/map_tests/htab_map_batch_ops.c   |   13 +-
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         |   15 +-
 .../selftests/bpf/map_tests/sk_storage_map.c       |   52 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |    4 +-
 .../selftests/bpf/prog_tests/bloom_filter_map.c    |   36 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   13 +-
 tools/testing/selftests/bpf/prog_tests/bpf_loop.c  |  145 +++
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |    6 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   42 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |  127 ++-
 .../selftests/bpf/prog_tests/btf_dedup_split.c     |  113 +++
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    4 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |   12 +-
 .../selftests/bpf/prog_tests/connect_force_port.c  |   17 +-
 tools/testing/selftests/bpf/prog_tests/core_kern.c |   14 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    3 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   14 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   58 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   24 +
 .../selftests/bpf/prog_tests/legacy_printk.c       |   65 ++
 tools/testing/selftests/bpf/prog_tests/log_buf.c   |  276 ++++++
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |   16 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |    4 +-
 .../selftests/bpf/prog_tests/prog_array_init.c     |   32 +
 .../selftests/bpf/prog_tests/queue_stack_map.c     |   12 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |    4 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |   21 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |    4 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |    2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |    4 +-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |   12 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |   12 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |   21 +-
 .../testing/selftests/bpf/prog_tests/test_bpffs.c  |    6 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |   28 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |   11 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |   36 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |    6 +-
 tools/testing/selftests/bpf/progs/bpf_loop.c       |  112 +++
 tools/testing/selftests/bpf/progs/bpf_loop_bench.c |   26 +
 tools/testing/selftests/bpf/progs/core_kern.c      |  104 ++
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |   16 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |   71 +-
 .../selftests/bpf/progs/pyperf600_bpf_loop.c       |    6 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |   75 +-
 .../selftests/bpf/progs/strobemeta_bpf_loop.c      |    9 +
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |    2 +-
 .../selftests/bpf/progs/test_legacy_printk.c       |   73 ++
 tools/testing/selftests/bpf/progs/test_log_buf.c   |   24 +
 .../selftests/bpf/progs/test_prog_array_init.c     |   39 +
 .../selftests/bpf/progs/test_verif_scale2.c        |    4 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |    7 +
 .../selftests/bpf/test_bpftool_synctypes.py        |   94 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c  |    8 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |   27 +-
 tools/testing/selftests/bpf/test_lru_map.c         |   16 +-
 tools/testing/selftests/bpf/test_maps.c            |  110 ++-
 tools/testing/selftests/bpf/test_progs.c           |   28 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |   33 +-
 tools/testing/selftests/bpf/test_tag.c             |    5 +-
 tools/testing/selftests/bpf/test_verifier.c        |   54 +-
 tools/testing/selftests/bpf/testing_helpers.c      |   14 +-
 tools/testing/selftests/bpf/vmtest.sh              |   46 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |   15 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   12 +-
 182 files changed, 5748 insertions(+), 2568 deletions(-)
 create mode 100644 Documentation/bpf/faq.rst
 create mode 100644 Documentation/bpf/helpers.rst
 create mode 100644 Documentation/bpf/instruction-set.rst
 create mode 100644 Documentation/bpf/maps.rst
 create mode 100644 Documentation/bpf/other.rst
 rename Documentation/bpf/{bpf_lsm.rst => prog_lsm.rst} (100%)
 create mode 100644 Documentation/bpf/programs.rst
 create mode 100644 Documentation/bpf/syscall_api.rst
 create mode 100644 Documentation/bpf/test_debug.rst
 create mode 100644 Documentation/bpf/verifier.rst
 create mode 100644 tools/bpf/bpftool/Documentation/substitutions.rst
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_loop.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_kern.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/legacy_printk.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/log_buf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/prog_array_init.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_loop_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/core_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_legacy_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_log_buf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_prog_array_init.c
