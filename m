Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892E0E6007
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 01:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfJZXrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 19:47:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:36254 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfJZXrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 19:47:12 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iOVlv-0005jk-DS; Sun, 27 Oct 2019 01:47:03 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     jakub.kicinski@netronome.com, daniel@iogearbox.net, ast@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf-next 2019-10-27
Date:   Sun, 27 Oct 2019 01:47:02 +0200
Message-Id: <20191026234702.20595-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25614/Sat Oct 26 11:04:41 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

We've added 52 non-merge commits during the last 11 day(s) which contain
a total of 65 files changed, 2604 insertions(+), 1100 deletions(-).

The main changes are:

 1) Revolutionize BPF tracing by using in-kernel BTF to type check BPF
    assembly code. The work here teaches BPF verifier to recognize
    kfree_skb()'s first argument as 'struct sk_buff *' in tracepoints
    such that verifier allows direct use of bpf_skb_event_output() helper
    used in tc BPF et al (w/o probing memory access) that dumps skb data
    into perf ring buffer. Also add direct loads to probe memory in order
    to speed up/replace bpf_probe_read() calls, from Alexei Starovoitov.

 2) Big batch of changes to improve libbpf and BPF kselftests. Besides
    others: generalization of libbpf's CO-RE relocation support to now
    also include field existence relocations, revamp the BPF kselftest
    Makefile to add test runner concept allowing to exercise various
    ways to build BPF programs, and teach bpf_object__open() and friends
    to automatically derive BPF program type/expected attach type from
    section names to ease their use, from Andrii Nakryiko.

 3) Fix deadlock in stackmap's build-id lookup on rq_lock(), from Song Liu.

 4) Allow to read BTF as raw data from bpftool. Most notable use case
    is to dump /sys/kernel/btf/vmlinux through this, from Jiri Olsa.

 5) Use bpf_redirect_map() helper in libbpf's AF_XDP helper prog which
    manages to improve "rx_drop" performance by ~4%., from Björn Töpel.

 6) Fix to restore the flow dissector after reattach BPF test and also
    fix error handling in bpf_helper_defs.h generation, from Jakub Sitnicki.

 7) Improve verifier's BTF ctx access for use outside of raw_tp, from
    Martin KaFai Lau.

 8) Improve documentation for AF_XDP with new sections and to reflect
    latest features, from Magnus Karlsson.

 9) Add back 'version' section parsing to libbpf for old kernels, from
    John Fastabend.

10) Fix strncat bounds error in libbpf's libbpf_prog_type_by_name(),
    from KP Singh.

11) Turn on -mattr=+alu32 in LLVM by default for BPF kselftests in order
    to improve insn coverage for built BPF progs, from Yonghong Song.

12) Misc minor cleanups and fixes, from various others.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Alexei Starovoitov, Andrii Nakryiko, Daniel Borkmann, Hulk Robot, Jakub 
Kicinski, John Fastabend, kernel test robot, Martin KaFai Lau, Sergey 
Senozhatsky, Toke Høiland-Jørgensen, Yonghong Song

----------------------------------------------------------------

The following changes since commit 14f2cf607ccd1fa05e767f0191fd5d07b35534c2:

  net: Update address for vrf and l3mdev in MAINTAINERS (2019-10-15 10:56:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to 027cbaaf61983351622c29f5a2adc7340340cb7f:

  selftests/bpf: Fix .gitignore to ignore no_alu32/ (2019-10-25 23:41:22 +0200)

----------------------------------------------------------------
Alexei Starovoitov (14):
      Merge branch 'libbpf-field-existence'
      bpf: Add typecast to raw_tracepoints to help BTF generation
      bpf: Add typecast to bpf helpers to help BTF generation
      bpf: Process in-kernel BTF
      bpf: Add attach_btf_id attribute to program load
      libbpf: Auto-detect btf_id of BTF-based raw_tracepoints
      bpf: Implement accurate raw_tp context access via BTF
      bpf: Attach raw_tp program with BTF via type name
      bpf: Add support for BTF pointers to interpreter
      bpf: Add support for BTF pointers to x86 JIT
      bpf: Check types of arguments passed into helpers
      selftests/bpf: Add kfree_skb raw_tp test
      Merge branch 'cleanup-selftests-bpf-makefile'
      bpf: Fix bpf_attr.attach_btf_id check

Andrii Nakryiko (23):
      libbpf: Update BTF reloc support to latest Clang format
      libbpf: Refactor bpf_object__open APIs to use common opts
      libbpf: Add support for field existance CO-RE relocation
      libbpf: Add BPF-side definitions of supported field relocation kinds
      selftests/bpf: Add field existence CO-RE relocs tests
      selftests/bpf: Teach test_progs to cd into subdir
      selftests/bpf: Make CO-RE reloc test impartial to test_progs flavor
      selftests/bpf: Switch test_maps to test_progs' test.h format
      selftests/bpf: Add simple per-test targets to Makefile
      selftests/bpf: Replace test_progs and test_maps w/ general rule
      selftests/bpf: Move test_queue_stack_map.h into progs/ where it belongs
      selftest/bpf: Remove test_libbpf.sh and test_libbpf_open
      tools: Sync if_link.h
      libbpf: Add bpf_program__get_{type, expected_attach_type) APIs
      libbpf: Add uprobe/uretprobe and tp/raw_tp section suffixes
      libbpf: Teach bpf_object__open to guess program types
      selftests/bpf: Make a copy of subtest name
      selftests/bpf: Make reference_tracking test use subtests
      selftest/bpf: Get rid of a bunch of explicit BPF program type setting
      libbpf: Make DECLARE_LIBBPF_OPTS macro strictly a variable declaration
      selftests/bpf: Move test_section_names into test_progs and fix it
      selftests/bpf: Fix LDLIBS order
      selftests/bpf: Fix .gitignore to ignore no_alu32/

Ben Dooks (Codethink) (1):
      xdp: Fix type of string pointer in __XDP_ACT_SYM_TAB

Björn Töpel (1):
      libbpf: Use implicit XSKMAP lookup from AF_XDP XDP program

Daniel Borkmann (2):
      Merge branch 'bpf-btf-trace'
      Merge branch 'bpf-libbpf-cleanups'

Jakub Sitnicki (3):
      scripts/bpf: Emit an #error directive known types list needs updating
      selftests/bpf: Restore the netns after flow dissector reattach test
      scripts/bpf: Print an error when known types list needs updating

Jiri Olsa (1):
      bpftool: Allow to read btf as raw data

Jiri Pirko (1):
      selftests: bpf: Don't try to read files without read permission

John Fastabend (1):
      bpf, libbpf: Add kernel version section parsing back

KP Singh (1):
      libbpf: Fix strncat bounds error in libbpf_prog_type_by_name

Kefeng Wang (1):
      tools, bpf: Rename pr_warning to pr_warn to align with kernel logging

Magnus Karlsson (1):
      xsk: Improve documentation for AF_XDP

Martin KaFai Lau (1):
      bpf: Prepare btf_ctx_access for non raw_tp use case

Song Liu (1):
      bpf/stackmap: Fix deadlock with rq_lock in bpf_get_stack()

Stanislav Fomichev (2):
      bpf: Allow __sk_buff tstamp in BPF_PROG_TEST_RUN
      selftests: bpf: Add selftest for __sk_buff tstamp

Yonghong Song (1):
      tools/bpf: Turn on llvm alu32 attribute by default

YueHaibing (1):
      bpf: Fix build error without CONFIG_NET

 Documentation/networking/af_xdp.rst                | 259 +++++-
 arch/x86/net/bpf_jit_comp.c                        |  97 +-
 include/linux/bpf.h                                |  44 +-
 include/linux/bpf_verifier.h                       |   8 +-
 include/linux/btf.h                                |  32 +
 include/linux/extable.h                            |  10 +
 include/linux/filter.h                             |   6 +-
 include/trace/bpf_probe.h                          |   3 +-
 include/trace/events/xdp.h                         |   2 +-
 include/uapi/linux/bpf.h                           |  28 +-
 kernel/bpf/btf.c                                   | 322 ++++++-
 kernel/bpf/core.c                                  |  39 +-
 kernel/bpf/stackmap.c                              |   7 +-
 kernel/bpf/syscall.c                               |  91 +-
 kernel/bpf/verifier.c                              | 211 ++++-
 kernel/extable.c                                   |   2 +
 kernel/trace/bpf_trace.c                           |  10 +-
 net/bpf/test_run.c                                 |   9 +
 net/core/filter.c                                  |  15 +-
 scripts/bpf_helpers_doc.py                         |   4 +-
 tools/bpf/bpftool/btf.c                            |  57 +-
 tools/bpf/bpftool/prog.c                           |   8 +-
 tools/include/uapi/linux/bpf.h                     |  28 +-
 tools/include/uapi/linux/if_link.h                 |   2 +
 tools/lib/bpf/Makefile                             |   3 +
 tools/lib/bpf/bpf.c                                |   3 +
 tools/lib/bpf/bpf_core_read.h                      |  24 +-
 tools/lib/bpf/btf.c                                |  72 +-
 tools/lib/bpf/btf.h                                |   4 +-
 tools/lib/bpf/btf_dump.c                           |  18 +-
 tools/lib/bpf/libbpf.c                             | 981 ++++++++++++---------
 tools/lib/bpf/libbpf.h                             |  28 +-
 tools/lib/bpf/libbpf.map                           |   2 +
 tools/lib/bpf/libbpf_internal.h                    |  33 +-
 tools/lib/bpf/xsk.c                                |  46 +-
 tools/testing/selftests/bpf/.gitignore             |   6 +-
 tools/testing/selftests/bpf/Makefile               | 351 ++++----
 .../selftests/bpf/prog_tests/attach_probe.c        |   7 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  81 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |  21 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |  89 ++
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |   4 -
 .../selftests/bpf/prog_tests/reference_tracking.c  |   5 +-
 .../section_names.c}                               |  90 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   5 +
 .../bpf/progs/btf__core_reloc_existence.c          |   3 +
 ...tf__core_reloc_existence___err_wrong_arr_kind.c |   3 +
 ...re_reloc_existence___err_wrong_arr_value_type.c |   3 +
 ...tf__core_reloc_existence___err_wrong_int_kind.c |   3 +
 .../btf__core_reloc_existence___err_wrong_int_sz.c |   3 +
 ...tf__core_reloc_existence___err_wrong_int_type.c |   3 +
 ..._core_reloc_existence___err_wrong_struct_type.c |   3 +
 .../progs/btf__core_reloc_existence___minimal.c    |   3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  58 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c      | 103 +++
 .../bpf/progs/test_core_reloc_existence.c          |  79 ++
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |   3 +-
 .../bpf/{ => progs}/test_queue_stack_map.h         |   0
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |  18 +-
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |   1 +
 tools/testing/selftests/bpf/test_libbpf.sh         |  43 -
 tools/testing/selftests/bpf/test_libbpf_open.c     | 144 ---
 tools/testing/selftests/bpf/test_maps.c            |  12 +-
 tools/testing/selftests/bpf/test_offload.py        |   2 +-
 tools/testing/selftests/bpf/test_progs.c           |  50 +-
 65 files changed, 2604 insertions(+), 1100 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
 rename tools/testing/selftests/bpf/{test_section_names.c => prog_tests/section_names.c} (73%)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___minimal.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_existence.c
 rename tools/testing/selftests/bpf/{ => progs}/test_queue_stack_map.h (100%)
 delete mode 100755 tools/testing/selftests/bpf/test_libbpf.sh
 delete mode 100644 tools/testing/selftests/bpf/test_libbpf_open.c
