Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A8835FC1E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353606AbhDNUCZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:02:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhDNUCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:22 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EJu1xR015734
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:01 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvfuuhth-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:00 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:01:58 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 389F72ED4A00; Wed, 14 Apr 2021 13:01:54 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 00/17] BPF static linker: support externs
Date:   Wed, 14 Apr 2021 13:01:29 -0700
Message-ID: <20210414200146.2663044-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: qKZGg5iI2benHEWCPywv7BlqbTwUbOyG
X-Proofpoint-ORIG-GUID: qKZGg5iI2benHEWCPywv7BlqbTwUbOyG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104140127
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
 tools/lib/bpf/linker.c                        | 1292 ++++++++++++++---
 tools/testing/selftests/bpf/Makefile          |   18 +-
 .../selftests/bpf/prog_tests/linked_funcs.c   |   42 +
 .../selftests/bpf/prog_tests/linked_maps.c    |   33 +
 .../selftests/bpf/prog_tests/linked_vars.c    |   43 +
 .../selftests/bpf/progs/linked_funcs1.c       |   73 +
 .../selftests/bpf/progs/linked_funcs2.c       |   73 +
 .../selftests/bpf/progs/linked_maps1.c        |  102 ++
 .../selftests/bpf/progs/linked_maps2.c        |  112 ++
 .../selftests/bpf/progs/linked_vars1.c        |   60 +
 .../selftests/bpf/progs/linked_vars2.c        |   61 +
 16 files changed, 2028 insertions(+), 350 deletions(-)
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

