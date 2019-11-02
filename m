Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B428ED0B5
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 23:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKBWAd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Nov 2019 18:00:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11428 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfKBWAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 18:00:33 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA2LwspG032520
        for <netdev@vger.kernel.org>; Sat, 2 Nov 2019 15:00:32 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w17mgt2ra-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 15:00:31 -0700
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 2 Nov 2019 15:00:30 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DACA2760F5C; Sat,  2 Nov 2019 15:00:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/7] Introduce BPF trampoline
Date:   Sat, 2 Nov 2019 15:00:18 -0700
Message-ID: <20191102220025.2475981-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-02_13:2019-11-01,2019-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=649 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911020218
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce BPF trampoline that works as a bridge between kernel functions and
BPF programs. The first use case is fentry/fexit BPF programs that are roughly
equivalent to kprobe/kretprobe. Unlike k[ret]probe there is practically zero
overhead to call a set of BPF programs before or after kernel function. In the
future patches networking use cases will be explored. For example: BPF
trampoline can be used to call XDP programs from drivers with direct calls or
wrapping BPF program into another BPF program.

The patch set depends on register_ftrace_direct() API. It's not upstream yet
and available in [1]. The first patch is a hack to workaround this dependency.
The idea is to land this set via bpf-next tree and land register_ftrace_direct
via Steven's ftrace tree. Then during the merge window revert the first patch.
Steven,
do you think it's workable?
As an alternative we can route register_ftrace_direct patches via bpf-next ?

Peter's static_call patches [2] are solving the issue of indirect call overhead
for large class of kernel use cases, but unfortunately don't help calling into
a set of BPF programs.  BPF trampoline's first goal is to translate kernel
calling convention into BPF calling convention. The second goal is to call a
set of programs efficiently. In the future we can replace BPF_PROG_RUN_ARRAY
with BPF trampoline variant. Another future work is to add support for static_key,
static_jmp and static_call inside generated BPF trampoline.

Please see patch 3 for details.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git/commit/?h=ftrace/direct&id=3ac423d902727884a389699fd7294c0e2e94b29c
[2]
https://lore.kernel.org/lkml/20191007082708.01393931.1@infradead.org/

Alexei Starovoitov (7):
  bpf, ftrace: temporary workaround
  bpf: refactor x86 JIT into helpers
  bpf: Introduce BPF trampoline
  libbpf: Add support to attach to fentry/fexit tracing progs
  selftest/bpf: Simple test for fentry/fexit
  bpf: Add kernel test functions for fentry testing
  selftests/bpf: Add test for BPF trampoline

 arch/x86/kernel/ftrace.c                      |  36 ++
 arch/x86/net/bpf_jit_comp.c                   | 352 +++++++++++++++---
 include/linux/bpf.h                           |  90 +++++
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/btf.c                              |  73 +++-
 kernel/bpf/core.c                             |  31 ++
 kernel/bpf/syscall.c                          |  53 ++-
 kernel/bpf/trampoline.c                       | 252 +++++++++++++
 kernel/bpf/verifier.c                         |  39 ++
 net/bpf/test_run.c                            |  41 ++
 tools/include/uapi/linux/bpf.h                |   2 +
 tools/lib/bpf/bpf_helpers.h                   |  13 +
 tools/lib/bpf/libbpf.c                        |  55 ++-
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/fentry_test.c    |  65 ++++
 .../selftests/bpf/prog_tests/kfree_skb.c      |  37 +-
 .../testing/selftests/bpf/progs/fentry_test.c |  90 +++++
 tools/testing/selftests/bpf/progs/kfree_skb.c |  52 +++
 20 files changed, 1215 insertions(+), 72 deletions(-)
 create mode 100644 kernel/bpf/trampoline.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fentry_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/fentry_test.c

-- 
2.23.0

