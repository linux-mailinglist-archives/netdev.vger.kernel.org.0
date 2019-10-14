Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7622D69DF
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 21:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387722AbfJNTG1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Oct 2019 15:06:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23462 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387685AbfJNTG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 15:06:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9EJ5hlK022186
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 12:06:26 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vkxgenwd8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 12:06:25 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 14 Oct 2019 12:06:22 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id D66A57606B9; Mon, 14 Oct 2019 12:06:20 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: pull-request: bpf-next 2019-10-14
Date:   Mon, 14 Oct 2019 12:06:20 -0700
Message-ID: <20191014190620.1588663-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_09:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 clxscore=1034 phishscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

The following pull-request contains BPF updates for your *net-next* tree.

12 days of development and
85 files changed, 1889 insertions(+), 1020 deletions(-)

The main changes are:

1) auto-generation of bpf_helper_defs.h, from Andrii.

2) split of bpf_helpers.h into bpf_{helpers, helper_defs, endian, tracing}.h
   and move into libbpf, from Andrii.

3) Track contents of read-only maps as scalars in the verifier, from Andrii.

4) small x86 JIT optimization, from Daniel.

5) cross compilation support, from Ivan.

6) bpf flow_dissector enhancements, from Jakub and Stanislav.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

Note there will be a conflict in tools/lib/bpf/Makefile
that should be resolved the way Stephen did in:
https://lore.kernel.org/lkml/20191014103232.09c09e53@canb.auug.org.au/

Thanks a lot!

----------------------------------------------------------------

The following changes since commit 37a2fce0900119bd5e8b2989970578a34584da97:

  dt-bindings: sh_eth convert bindings to json-schema (2019-10-01 15:31:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git 

for you to fetch changes up to b8fc345d6b5d661e1125bd6a0e30b6fabf1a076e:

  Merge branch 'selftests-bpf-Makefile-cleanup' (2019-10-12 16:15:15 -0700)

----------------------------------------------------------------
Alexei Starovoitov (6):
      Merge branch 'libbpf-api'
      Merge branch 'autogen-bpf-helpers'
      Merge branch 'enforce-global-flow-dissector'
      Merge branch 'btf2c-padding'
      Merge branch 'samples-cross-compile'
      Merge branch 'selftests-bpf-Makefile-cleanup'

Andrii Nakryiko (29):
      libbpf: Bump current version to v0.0.6
      libbpf: Fix BTF-defined map's __type macro handling of arrays
      libbpf: stop enforcing kern_version, populate it for users
      libbpf: add bpf_object__open_{file, mem} w/ extensible opts
      libbpf: fix bpf_object__name() to actually return object name
      selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs
      uapi/bpf: fix helper docs
      scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions
      libbpf: auto-generate list of BPF helper definitions
      selftests/bpf: Fix dependency ordering for attach_probe test
      bpftool: Fix bpftool build by switching to bpf_object__open_file()
      selftests/bpf: Undo GCC-specific bpf_helpers.h changes
      selftests/bpf: samples/bpf: Split off legacy stuff from bpf_helpers.h
      selftests/bpf: Adjust CO-RE reloc tests for new bpf_core_read() macro
      selftests/bpf: Split off tracing-only helpers into bpf_tracing.h
      libbpf: Move bpf_{helpers, helper_defs, endian, tracing}.h into libbpf
      libbpf: Add BPF_CORE_READ/BPF_CORE_READ_INTO helpers
      selftests/bpf: Add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro tests
      libbpf: Fix struct end padding in btf_dump
      selftests/bpf: Convert test_btf_dump into test_progs test
      selftests/bpf: Fix btf_dump padding test case
      scripts/bpf: Fix xdp_md forward declaration typo
      bpf: Track contents of read-only maps as scalars
      selftests/bpf: Add read-only map values propagation tests
      bpf: Fix cast to pointer from integer of different size warning
      libbpf: Generate more efficient BPF_CORE_READ code
      libbpf: Handle invalid typedef emitted by old GCC
      selftests/bpf: Enforce libbpf build before BPF programs are built
      selftests/bpf: Remove obsolete pahole/BTF support detection

Anton Ivanov (2):
      samples/bpf: Trivial - fix spelling mistake in usage
      xdp: Trivial, fix spelling in function description

Daniel Borkmann (4):
      bpf, x86: Small optimization in comparing against imm0
      bpf: Add loop test case with 32 bit reg comparison against 0
      Merge branch 'bpf-libbpf-helpers'
      Merge branch 'bpf-romap-known-scalars'

Daniel T. Lee (1):
      samples: bpf: Add max_pckt_size option at xdp_adjust_tail

Eric Dumazet (1):
      bpf: Align struct bpf_prog_stats

Ilya Maximets (1):
      libbpf: Fix passing uninitialized bytes to setsockopt

Ivan Khoronzhuk (17):
      selftests/bpf: Add static to enable_all_controllers()
      selftests/bpf: Correct path to include msg + path
      samples/bpf: Fix HDR_PROBE "echo"
      samples/bpf: Fix cookie_uid_helper_example obj build
      samples/bpf: Use --target from cross-compile
      samples/bpf: Use own EXTRA_CFLAGS for clang commands
      samples/bpf: Use __LINUX_ARM_ARCH__ selector for arm
      samples/bpf: Drop unnecessarily inclusion for bpf_load
      samples/bpf: Add makefile.target for separate CC target build
      samples/bpf: Base target programs rules on Makefile.target
      samples/bpf: Use own flags but not HOSTCFLAGS
      samples/bpf: Use target CC environment for HDR_PROBE
      libbpf: Don't use cxx to test_libpf target
      libbpf: Add C/LDFLAGS to libbpf.so and test_libpf targets
      samples/bpf: Provide C/LDFLAGS to libbpf
      samples/bpf: Add sysroot support
      samples/bpf: Add preparation steps and sysroot info to readme

Jakub Sitnicki (2):
      flow_dissector: Allow updating the flow dissector program atomically
      selftests/bpf: Check that flow dissector can be re-attached

Stanislav Fomichev (2):
      bpf/flow_dissector: add mode to enforce global BPF flow dissector
      selftests/bpf: add test for BPF flow dissector in the root namespace

Toke Høiland-Jørgensen (1):
      libbpf: Add cscope and tags targets to Makefile

 Documentation/bpf/prog_flow_dissector.rst          |   3 +
 arch/x86/net/bpf_jit_comp.c                        |  10 +
 include/linux/bpf.h                                |   2 +-
 include/uapi/linux/bpf.h                           |  32 +-
 kernel/bpf/verifier.c                              |  57 ++-
 net/core/flow_dissector.c                          |  46 +-
 net/core/xdp.c                                     |   2 +-
 samples/bpf/Makefile                               | 164 ++++---
 samples/bpf/Makefile.target                        |  75 +++
 samples/bpf/README.rst                             |  41 +-
 samples/bpf/hbm_kern.h                             |  27 +-
 samples/bpf/map_perf_test_kern.c                   |  24 +-
 samples/bpf/offwaketime_kern.c                     |   1 +
 samples/bpf/parse_ldabs.c                          |   1 +
 samples/bpf/sampleip_kern.c                        |   1 +
 samples/bpf/sockex1_kern.c                         |   1 +
 samples/bpf/sockex2_kern.c                         |   1 +
 samples/bpf/sockex3_kern.c                         |   1 +
 samples/bpf/spintest_kern.c                        |   1 +
 samples/bpf/tcbpf1_kern.c                          |   1 +
 samples/bpf/test_map_in_map_kern.c                 |  16 +-
 samples/bpf/test_overhead_kprobe_kern.c            |   1 +
 samples/bpf/test_probe_write_user_kern.c           |   1 +
 samples/bpf/trace_event_kern.c                     |   1 +
 samples/bpf/tracex1_kern.c                         |   1 +
 samples/bpf/tracex2_kern.c                         |   1 +
 samples/bpf/tracex3_kern.c                         |   1 +
 samples/bpf/tracex4_kern.c                         |   1 +
 samples/bpf/tracex5_kern.c                         |   1 +
 samples/bpf/xdp_adjust_tail_kern.c                 |   7 +-
 samples/bpf/xdp_adjust_tail_user.c                 |  29 +-
 samples/bpf/xdpsock_user.c                         |   2 +-
 scripts/bpf_helpers_doc.py                         | 155 +++++-
 tools/bpf/bpftool/main.c                           |   4 +-
 tools/bpf/bpftool/main.h                           |   2 +-
 tools/bpf/bpftool/prog.c                           |  22 +-
 tools/include/uapi/linux/bpf.h                     |  32 +-
 tools/lib/bpf/.gitignore                           |   4 +
 tools/lib/bpf/Makefile                             |  52 +-
 tools/lib/bpf/bpf_core_read.h                      | 167 +++++++
 tools/{testing/selftests => lib}/bpf/bpf_endian.h  |   0
 tools/lib/bpf/bpf_helpers.h                        |  41 ++
 tools/lib/bpf/bpf_tracing.h                        | 195 ++++++++
 tools/lib/bpf/btf_dump.c                           |  19 +-
 tools/lib/bpf/libbpf.c                             | 183 ++++---
 tools/lib/bpf/libbpf.h                             |  48 +-
 tools/lib/bpf/libbpf.map                           |   6 +
 tools/lib/bpf/libbpf_internal.h                    |  32 ++
 tools/lib/bpf/{test_libbpf.cpp => test_libbpf.c}   |  14 +-
 tools/lib/bpf/xsk.c                                |   1 +
 tools/testing/selftests/bpf/Makefile               |  61 +--
 tools/testing/selftests/bpf/bpf_helpers.h          | 535 ---------------------
 tools/testing/selftests/bpf/bpf_legacy.h           |  39 ++
 tools/testing/selftests/bpf/cgroup_helpers.c       |   4 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |  49 +-
 .../bpf/{test_btf_dump.c => prog_tests/btf_dump.c} |  88 ++--
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   8 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       | 127 +++++
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |  99 ++++
 .../selftests/bpf/prog_tests/reference_tracking.c  |  16 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |   5 +-
 .../testing/selftests/bpf/progs/core_reloc_types.h |   9 +
 tools/testing/selftests/bpf/progs/loop1.c          |   1 +
 tools/testing/selftests/bpf/progs/loop2.c          |   1 +
 tools/testing/selftests/bpf/progs/loop3.c          |   1 +
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |  13 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c        |  13 +-
 .../selftests/bpf/progs/test_attach_probe.c        |   1 -
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   1 +
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   1 +
 .../selftests/bpf/progs/test_core_reloc_arrays.c   |  11 +-
 .../selftests/bpf/progs/test_core_reloc_flavors.c  |   9 +-
 .../selftests/bpf/progs/test_core_reloc_ints.c     |  19 +-
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |  61 ++-
 .../selftests/bpf/progs/test_core_reloc_misc.c     |   9 +-
 .../selftests/bpf/progs/test_core_reloc_mods.c     |  19 +-
 .../selftests/bpf/progs/test_core_reloc_nesting.c  |   7 +-
 .../bpf/progs/test_core_reloc_primitives.c         |  13 +-
 .../bpf/progs/test_core_reloc_ptr_as_arr.c         |   5 +-
 .../selftests/bpf/progs/test_get_stack_rawtp.c     |   4 +-
 .../testing/selftests/bpf/progs/test_perf_buffer.c |   1 -
 .../testing/selftests/bpf/progs/test_rdonly_maps.c |  83 ++++
 .../selftests/bpf/progs/test_stacktrace_map.c      |   1 -
 tools/testing/selftests/bpf/test_flow_dissector.sh |  48 +-
 tools/testing/selftests/bpf/verifier/loops1.c      |  17 +
 85 files changed, 1889 insertions(+), 1020 deletions(-)
 create mode 100644 samples/bpf/Makefile.target
 create mode 100644 tools/lib/bpf/bpf_core_read.h
 rename tools/{testing/selftests => lib}/bpf/bpf_endian.h (100%)
 create mode 100644 tools/lib/bpf/bpf_helpers.h
 create mode 100644 tools/lib/bpf/bpf_tracing.h
 rename tools/lib/bpf/{test_libbpf.cpp => test_libbpf.c} (61%)
 delete mode 100644 tools/testing/selftests/bpf/bpf_helpers.h
 create mode 100644 tools/testing/selftests/bpf/bpf_legacy.h
 rename tools/testing/selftests/bpf/{test_btf_dump.c => prog_tests/btf_dump.c} (51%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_rdonly_maps.c
