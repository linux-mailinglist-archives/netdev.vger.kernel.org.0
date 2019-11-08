Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAD3F4082
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 07:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbfKHGkn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Nov 2019 01:40:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbfKHGkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 01:40:43 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA86eZJY026350
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 22:40:42 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41ue9pd5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 22:40:41 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 7 Nov 2019 22:40:40 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 711A5760F61; Thu,  7 Nov 2019 22:40:39 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 00/18] Introduce BPF trampoline
Date:   Thu, 7 Nov 2019 22:40:21 -0800
Message-ID: <20191108064039.2041889-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_01:2019-11-07,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1034 malwarescore=0 mlxlogscore=648 suspectscore=1 adultscore=0
 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080065
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
bpf_tail_call-based program chaining.

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

Most of the interesting details are in patches 2,3,14,15.

Alexei Starovoitov (18):
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
  bpf: Compare BTF types of functions arguments with actual types
  bpf: Support attaching tracing BPF program to other BPF programs
  libbpf: Add support for attaching BPF programs to other BPF programs
  selftests/bpf: Extend test_pkt_access test
  selftests/bpf: Add a test for attaching BPF prog to another BPF prog
    and subprog

 arch/x86/net/bpf_jit_comp.c                   | 425 +++++++++++++++---
 include/linux/bpf.h                           | 121 ++++-
 include/linux/bpf_verifier.h                  |   1 +
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/btf.c                              | 274 ++++++++++-
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  73 ++-
 kernel/bpf/trampoline.c                       | 250 +++++++++++
 kernel/bpf/verifier.c                         | 131 +++++-
 kernel/trace/bpf_trace.c                      |   2 -
 net/bpf/test_run.c                            |  41 ++
 net/core/filter.c                             |   2 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/bpf.c                           |   9 +-
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
 .../selftests/bpf/prog_tests/fexit_stress.c   |  77 ++++
 .../selftests/bpf/prog_tests/fexit_test.c     |  64 +++
 .../selftests/bpf/prog_tests/kfree_skb.c      |  39 +-
 .../testing/selftests/bpf/progs/fentry_test.c |  90 ++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  91 ++++
 .../testing/selftests/bpf/progs/fexit_test.c  |  98 ++++
 tools/testing/selftests/bpf/progs/kfree_skb.c |  52 +++
 .../selftests/bpf/progs/test_pkt_access.c     |  38 +-
 34 files changed, 2198 insertions(+), 133 deletions(-)
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

