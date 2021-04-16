Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DC336292C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbhDPUYg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 16:24:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19528 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244549AbhDPUYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:24:34 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GKIuCY026836
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:09 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37yb5e2dgn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:08 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 13:24:06 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 308832ED4EE0; Fri, 16 Apr 2021 13:24:05 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 00/17] BPF static linker: support externs
Date:   Fri, 16 Apr 2021 13:23:47 -0700
Message-ID: <20210416202404.3443623-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: gmhZ-6SBWcyYOwtYgubj7pkJd1B7MbGb
X-Proofpoint-ORIG-GUID: gmhZ-6SBWcyYOwtYgubj7pkJd1B7MbGb
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 phishscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF static linker support for extern resolution of global variables,
functions, and BTF-defined maps.

This patch set consists of 4 parts:
  - few patches are extending bpftool to simplify working with BTF dump;
  - libbpf object loading logic is extended to support __hidden functions and
    overriden (unused) __weak functions; also BTF-defined map parsing logic is
    refactored to be re-used by linker;
  - the crux of the patch set is BPF static linker logic extension to perform
    extern resolution for three categories: global variables, BPF
    sub-programs, BTF-defined maps;
  - a set of selftests that validate that all the combinations of
    extern/weak/__hidden are working as expected.

See respective patches for more details.

One aspect hasn't been addressed yet and is going to be resolved in the next
patch set, but is worth mentioning. With BPF static linking of multiple .o
files, dealing with static everything becomes more problematic for BPF
skeleton and in general for any by name look up APIs. This is due to static
entities are allowed to have non-unique name. Historically this was never
a problem due to BPF programs were always confined to a single C file. That
changes now and needs to be addressed. The thinking so far is for BPF static
linker to prepend filename to each static variable and static map (which is
currently not supported by libbpf, btw), so that they can be unambiguously
resolved by (mostly) unique name. Mostly, because even filenames can be
duplicated, but that should be rare and easy to address by wiser choice of
filenames by users. Fortunately, static BPF subprograms don't suffer from this
issues, as they are not independent entities and are neither exposed in BPF
skeleton, nor is lookup-able by any of libbpf APIs (and there is little reason
to do that anyways).

This and few other things will be the topic of the next set of patches.

Some tests rely on Clang fix ([0]), so need latest Clang built from main.

  [0] https://reviews.llvm.org/D100362

v1->v2:
  - make map externs support full attribute list, adjust linked_maps selftest
    to demonstrate that typedef works now (though no shared header file was
    added to simplicity sake) (Alexei);
  - remove commented out parts from selftests and fix few minor code style
    issues;
  - special __weak map definition semantics not yet implemented and will be
    addressed in a follow up.

Andrii Nakryiko (17):
  bpftool: support dumping BTF VAR's "extern" linkage
  bpftool: dump more info about DATASEC members
  libbpf: suppress compiler warning when using SEC() macro with externs
  libbpf: mark BPF subprogs with hidden visibility as static for BPF
    verifier
  libbpf: allow gaps in BPF program sections to support overriden weak
    functions
  libbpf: refactor BTF map definition parsing
  libbpf: factor out symtab and relos sanity checks
  libbpf: make few internal helpers available outside of libbpf.c
  libbpf: extend sanity checking ELF symbols with externs validation
  libbpf: tighten BTF type ID rewriting with error checking
  libbpf: add linker extern resolution support for functions and global
    variables
  libbpf: support extern resolution for BTF-defined maps in .maps
    section
  selftests/bpf: use -O0 instead of -Og in selftests builds
  selftests/bpf: omit skeleton generation for multi-linked BPF object
    files
  selftests/bpf: add function linking selftest
  selftests/bpf: add global variables linking selftest
  sleftests/bpf: add map linking selftest

 tools/bpf/bpftool/btf.c                       |   30 +-
 tools/lib/bpf/bpf_helpers.h                   |   19 +-
 tools/lib/bpf/btf.c                           |    5 -
 tools/lib/bpf/libbpf.c                        |  370 +++--
 tools/lib/bpf/libbpf_internal.h               |   45 +
 tools/lib/bpf/linker.c                        | 1261 ++++++++++++++---
 tools/testing/selftests/bpf/Makefile          |   18 +-
 .../selftests/bpf/prog_tests/linked_funcs.c   |   42 +
 .../selftests/bpf/prog_tests/linked_maps.c    |   30 +
 .../selftests/bpf/prog_tests/linked_vars.c    |   43 +
 .../selftests/bpf/progs/linked_funcs1.c       |   73 +
 .../selftests/bpf/progs/linked_funcs2.c       |   73 +
 .../selftests/bpf/progs/linked_maps1.c        |   82 ++
 .../selftests/bpf/progs/linked_maps2.c        |   76 +
 .../selftests/bpf/progs/linked_vars1.c        |   54 +
 .../selftests/bpf/progs/linked_vars2.c        |   55 +
 16 files changed, 1922 insertions(+), 354 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_maps.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_vars.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps2.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars2.c

-- 
2.30.2

