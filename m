Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EE6FCE38
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKNS5Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:57:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47320 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725976AbfKNS5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:57:24 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAEIgtv9031812
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:22 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w8jxpqkh4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:57:22 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 14 Nov 2019 10:57:21 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id E842076071B; Thu, 14 Nov 2019 10:57:20 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 00/20] Introduce BPF trampoline
Date:   Thu, 14 Nov 2019 10:57:00 -0800
Message-ID: <20191114185720.1641606-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF trampoline that works as a bridge between kernel functions, BPF
programs and other BPF programs.

The first use case is fentry/fexit BPF programs that are roughly equivalent to
kprobe/kretprobe. Unlike k[ret]probe there is practically zero overhead to call
a set of BPF programs before or after kernel function.

The second use case is heavily influenced by pain points in XDP development.
BPF trampoline allows attaching similar fentry/fexit BPF program to any
networking BPF program. It's now possible to see packets on input and output of
any XDP, TC, lwt, cgroup programs without disturbing them. This greatly helps
BPF-based network troubleshooting.

The third use case of BPF trampoline will be explored in the follow up patches.
The BPF trampoline will be used to dynamicly link BPF programs. It's more
generic mechanism than array and link list of programs used in tracing,
networking, cgroups. In many cases it can be used as a replacement for
bpf_tail_call-based program chaining. See [1] for long term design discussion.

v3->v4:
- Included Peter's
  "86/alternatives: Teach text_poke_bp() to emulate instructions" as a first patch.
  If it changes between now and merge window, I'll rebease to newer version.
  The patch is necessary to do s/text_poke/text_poke_bp/ in patch 3 to fix the race.
- In patch 4 fixed bpf_trampoline creation race spotted by Andrii.
- Added patch 15 that annotates prog->kern bpf context types. It made patches 16
  and 17 cleaner and more generic.
- Addressed Andrii's feedback in other patches.

v2->v3:
- Addressed Song's and Andrii's comments
- Fixed few minor bugs discovered while testing
- Added one more libbpf patch

v1->v2:
- Addressed Andrii's comments
- Added more test for fentry/fexit to kernel functions. Including stress test
  for maximum number of progs per trampoline.
- Fixed a race btf_resolve_helper_id()
- Added a patch to compare BTF types of functions arguments with actual types.
- Added support for attaching BPF program to another BPF program via trampoline
- Converted to use text_poke() API. That's the only viable mechanism to
  implement BPF-to-BPF attach. BPF-to-kernel attach can be refactored to use
  register_ftrace_direct() whenever it's available.

[1]
https://lore.kernel.org/bpf/20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com/

Alexei Starovoitov (19):
  bpf: refactor x86 JIT into helpers
  bpf: Add bpf_arch_text_poke() helper
  bpf: Introduce BPF trampoline
  libbpf: Introduce btf__find_by_name_kind()
  libbpf: Add support to attach to fentry/fexit tracing progs
  selftest/bpf: Simple test for fentry/fexit
  bpf: Add kernel test functions for fentry testing
  selftests/bpf: Add test for BPF trampoline
  selftests/bpf: Add fexit tests for BPF trampoline
  selftests/bpf: Add combined fentry/fexit test
  selftests/bpf: Add stress test for maximum number of progs
  bpf: Reserve space for BPF trampoline in BPF programs
  bpf: Fix race in btf_resolve_helper_id()
  bpf: Annotate context types
  bpf: Compare BTF types of functions arguments with actual types
  bpf: Support attaching tracing BPF program to other BPF programs
  libbpf: Add support for attaching BPF programs to other BPF programs
  selftests/bpf: Extend test_pkt_access test
  selftests/bpf: Add a test for attaching BPF prog to another BPF prog
    and subprog

Peter Zijlstra (1):
  x86/alternatives: Teach text_poke_bp() to emulate instructions

 arch/x86/include/asm/text-patching.h          |  24 +-
 arch/x86/kernel/alternative.c                 | 132 ++++--
 arch/x86/kernel/jump_label.c                  |   9 +-
 arch/x86/kernel/kprobes/opt.c                 |  11 +-
 arch/x86/net/bpf_jit_comp.c                   | 424 +++++++++++++++---
 include/linux/bpf.h                           | 138 +++++-
 include/linux/bpf_types.h                     |  78 ++--
 include/linux/bpf_verifier.h                  |   1 +
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/btf.c                              | 363 ++++++++++++++-
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  77 +++-
 kernel/bpf/trampoline.c                       | 253 +++++++++++
 kernel/bpf/verifier.c                         | 131 +++++-
 net/bpf/test_run.c                            |  41 ++
 net/core/filter.c                             |  12 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/bpf.c                           |   8 +-
 tools/lib/bpf/bpf.h                           |   5 +-
 tools/lib/bpf/bpf_helpers.h                   |  13 +
 tools/lib/bpf/btf.c                           |  22 +
 tools/lib/bpf/btf.h                           |   2 +
 tools/lib/bpf/libbpf.c                        | 154 +++++--
 tools/lib/bpf/libbpf.h                        |   7 +-
 tools/lib/bpf/libbpf.map                      |   3 +
 .../selftests/bpf/prog_tests/fentry_fexit.c   |  90 ++++
 .../selftests/bpf/prog_tests/fentry_test.c    |  64 +++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  76 ++++
 .../selftests/bpf/prog_tests/fexit_stress.c   |  76 ++++
 .../selftests/bpf/prog_tests/fexit_test.c     |  64 +++
 .../selftests/bpf/prog_tests/kfree_skb.c      |  39 +-
 .../testing/selftests/bpf/progs/fentry_test.c |  90 ++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  91 ++++
 .../testing/selftests/bpf/progs/fexit_test.c  |  98 ++++
 tools/testing/selftests/bpf/progs/kfree_skb.c |  52 +++
 .../selftests/bpf/progs/test_pkt_access.c     |  38 +-
 38 files changed, 2484 insertions(+), 219 deletions(-)
 create mode 100644 kernel/bpf/trampoline.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_fexit.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_stress.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fexit_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/fexit_test.c

-- 
2.23.0

