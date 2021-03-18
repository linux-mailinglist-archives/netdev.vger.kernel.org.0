Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C601B33FF9A
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 07:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhCRGbp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 02:31:45 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1670 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229558AbhCRGbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 02:31:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12I6P3Dr004474
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 23:31:20 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37b3bs18xs-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 23:31:20 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 17 Mar 2021 23:31:19 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AD0C72ED24FA; Wed, 17 Mar 2021 23:31:16 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 00/12] BPF static linking
Date:   Wed, 17 Mar 2021 23:31:03 -0700
Message-ID: <20210318063115.49613-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_02:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180050
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds new libbpf APIs and their bpftool integration that allows
to perform static linking of BPF object files. Currently no extern resolution
across object files is performed. This is going to be the focus of the follow
up patches. But, given amount of code and logic necessary to perform just
basic functionality of linking together mostly independent BPF object files,
it was decided to land basic BPF linker code and logic first and extend it
afterwards.

The motivation for BPF static linking is to provide the functionality that is
naturally assumed for user-space development process: ability to structure
application's code without artificial restrictions of having all the code and
data (variables and maps) inside a single source code file.

This enables better engineering practices of splitting code into
well-encapsulated parts. It provides ability to hide internal state from other
parts of the code base through static variables and maps. It is also a first
steps towards having generic reusable BPF libraries.

Please see individual patches (mostly #6 and #7) for more details. Patch #10
passes all test_progs' individual BPF .o files through BPF static linker,
which is supposed to be a no-op operation, so is essentially validating that
BPF static linker doesn't produce corrupted ELF object files. Patch #11 adds
Makefile infra to be able to specify multi-file BPF object files and adds the
first multi-file test to validate correctness.

v2->v3:
  - added F(F(F(X))) = F(F(X)) test for all linked BPF object files (Alexei);
  - used reallocarray() more consistently in few places (Alexei);
  - improved bash completions for `gen object` (Quentin);
  - dropped .bpfo extension, but had to add optional `name OBJECT_FILE`
    parameter (path #8) to `gen skeleton` command to specify desired object
    name during skeleton generation;
  - fixed bug with not skipping license and version DATASECs in 2nd and later
    object files, resulting in symbol lookup failure on subsequent linking
    passes;
v1->v2:
  - extracted `struct strset` to manage unique set of strings both for BTF and
    ELF SYMTAB (patch #4, refactors btf and btf_dedup logic as well) (Alexei);
  - fixed bugs in bpftool gen command; renamed it to `gen object`, added BASH
    completions and extended/updated man page (Quentin).

Andrii Nakryiko (12):
  libbpf: expose btf_type_by_id() internally
  libbpf: generalize BTF and BTF.ext type ID and strings iteration
  libbpf: rename internal memory-management helpers
  libbpf: extract internal set-of-strings datastructure APIs
  libbpf: add generic BTF type shallow copy API
  libbpf: add BPF static linker APIs
  libbpf: add BPF static linker BTF and BTF.ext support
  bpftool: add ability to specify custom skeleton object name
  bpftool: add `gen object` command to perform BPF static linking
  selftests/bpf: re-generate vmlinux.h and BPF skeletons if bpftool
    changed
  selftests/bpf: pass all BPF .o's through BPF static linker
  selftests/bpf: add multi-file statically linked BPF object file test

 .../bpf/bpftool/Documentation/bpftool-gen.rst |   78 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   17 +-
 tools/bpf/bpftool/gen.c                       |   70 +-
 tools/lib/bpf/Build                           |    2 +-
 tools/lib/bpf/btf.c                           |  714 +++---
 tools/lib/bpf/btf.h                           |    2 +
 tools/lib/bpf/btf_dump.c                      |    8 +-
 tools/lib/bpf/libbpf.c                        |   15 +-
 tools/lib/bpf/libbpf.h                        |   13 +
 tools/lib/bpf/libbpf.map                      |    5 +
 tools/lib/bpf/libbpf_internal.h               |   38 +-
 tools/lib/bpf/linker.c                        | 1941 +++++++++++++++++
 tools/lib/bpf/strset.c                        |  176 ++
 tools/lib/bpf/strset.h                        |   21 +
 tools/testing/selftests/bpf/Makefile          |   27 +-
 .../selftests/bpf/prog_tests/static_linked.c  |   40 +
 .../selftests/bpf/progs/test_static_linked1.c |   30 +
 .../selftests/bpf/progs/test_static_linked2.c |   31 +
 18 files changed, 2805 insertions(+), 423 deletions(-)
 create mode 100644 tools/lib/bpf/linker.c
 create mode 100644 tools/lib/bpf/strset.c
 create mode 100644 tools/lib/bpf/strset.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/static_linked.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked2.c

-- 
2.30.2

