Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA1DF274A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbfKGFrJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58770 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbfKGFrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:07 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75hGl9016600
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:06 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vxuh9v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:06 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:46:45 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2C405760BC0; Wed,  6 Nov 2019 21:46:44 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 00/17] Introduce BPF trampoline
Date:   Wed, 6 Nov 2019 21:46:27 -0800
Message-ID: <20191107054644.1285697-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1034 mlxscore=0
 suspectscore=1 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=688
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
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

Goes without saying: all new features are root only.

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

Most of the interesting details are in patches 2,3,13,14.

Alexei Starovoitov (17):
  bpf: refactor x86 JIT into helpers
  bpf: Add bpf_arch_text_poke() helper
  bpf: Introduce BPF trampoline
  libbpf: Add support to attach to fentry/fexit tracing progs
  selftest/bpf: Simple test for fentry/fexit
  bpf: Add kernel test functions for fentry testing
  selftests/bpf: Add test for BPF trampoline
  selftests/bpf: Add fexit tests for BPF trampoline
  selftests/bpf: Add combined fentry/fexit test
  selftests/bpf: Add stress test for maximum number of progs
  bpf: Reserver space for BPF trampoline in BPF programs
  bpf: Fix race in btf_resolve_helper_id()
  bpf: Compare BTF types of functions arguments with actual types
  bpf: Support attaching tracing BPF program to other BPF programs
  selftests/bpf: Extend test_pkt_access test
  libbpf: Add support for attaching BPF programs to other BPF programs
  selftests/bpf: Add a test for attaching BPF prog to another BPF prog
    and subprog

 arch/x86/net/bpf_jit_comp.c                   | 421 +++++++++++++++---
 include/linux/bpf.h                           | 114 ++++-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/btf.h                           |   1 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/btf.c                              | 234 +++++++++-
 kernel/bpf/core.c                             |   9 +
 kernel/bpf/syscall.c                          |  72 ++-
 kernel/bpf/trampoline.c                       | 252 +++++++++++
 kernel/bpf/verifier.c                         | 136 +++++-
 kernel/trace/bpf_trace.c                      |   2 -
 net/bpf/test_run.c                            |  41 ++
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/bpf.c                           |   9 +-
 tools/lib/bpf/bpf.h                           |   5 +-
 tools/lib/bpf/bpf_helpers.h                   |  13 +
 tools/lib/bpf/libbpf.c                        | 114 ++++-
 tools/lib/bpf/libbpf.h                        |   8 +-
 tools/lib/bpf/libbpf.map                      |   2 +
 .../selftests/bpf/prog_tests/fentry_fexit.c   |  90 ++++
 .../selftests/bpf/prog_tests/fentry_test.c    |  64 +++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  73 +++
 .../selftests/bpf/prog_tests/fexit_stress.c   |  76 ++++
 .../selftests/bpf/prog_tests/fexit_test.c     |  64 +++
 .../selftests/bpf/prog_tests/kfree_skb.c      |  42 +-
 .../testing/selftests/bpf/progs/fentry_test.c |  90 ++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  48 ++
 .../testing/selftests/bpf/progs/fexit_test.c  |  98 ++++
 tools/testing/selftests/bpf/progs/kfree_skb.c |  52 +++
 .../selftests/bpf/progs/test_pkt_access.c     |  12 +-
 31 files changed, 2039 insertions(+), 112 deletions(-)
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

