Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4384E33A07C
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 20:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhCMTgN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 14:36:13 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1254 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234447AbhCMTfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 14:35:42 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DJXsfR009808
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:35:42 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 378wk2939p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:35:42 -0800
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 11:35:41 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3C0662ED20BF; Sat, 13 Mar 2021 11:35:39 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 00/11] BPF static linking
Date:   Sat, 13 Mar 2021 11:35:26 -0800
Message-ID: <20210313193537.1548766-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_07:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 mlxscore=0 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 mlxlogscore=884 clxscore=1034 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130151
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

v1->v2:
  - extracted `struct strset` to manage unique set of strings both for BTF and
    ELF SYMTAB (patch #4, refactors btf and btf_dedup logic as well) (Alexei);
  - fixed bugs in bpftool gen command; renamed it to `gen object`, added BASH
    completions and extended/updated man page (Quentin).

Andrii Nakryiko (11):
  libbpf: expose btf_type_by_id() internally
  libbpf: generalize BTF and BTF.ext type ID and strings iteration
  libbpf: rename internal memory-management helpers
  libbpf: extract internal set-of-strings datastructure APIs
  libbpf: add generic BTF type shallow copy API
  libbpf: add BPF static linker APIs
  libbpf: add BPF static linker BTF and BTF.ext support
  bpftool: add `gen object` command to perform BPF static linking
  selftests/bpf: re-generate vmlinux.h and BPF skeletons if bpftool
    changed
  selftests/bpf: pass all BPF .o's through BPF static linker
  selftests/bpf: add multi-file statically linked BPF object file test

 .../bpf/bpftool/Documentation/bpftool-gen.rst |   65 +-
 tools/bpf/bpftool/bash-completion/bpftool     |    2 +-
 tools/bpf/bpftool/gen.c                       |   49 +-
 tools/lib/bpf/Build                           |    2 +-
 tools/lib/bpf/btf.c                           |  714 +++---
 tools/lib/bpf/btf.h                           |    2 +
 tools/lib/bpf/btf_dump.c                      |    8 +-
 tools/lib/bpf/libbpf.c                        |   15 +-
 tools/lib/bpf/libbpf.h                        |   13 +
 tools/lib/bpf/libbpf.map                      |    5 +
 tools/lib/bpf/libbpf_internal.h               |   38 +-
 tools/lib/bpf/linker.c                        | 1944 +++++++++++++++++
 tools/lib/bpf/strset.c                        |  176 ++
 tools/lib/bpf/strset.h                        |   21 +
 tools/testing/selftests/bpf/.gitignore        |    1 +
 tools/testing/selftests/bpf/Makefile          |   21 +-
 .../selftests/bpf/prog_tests/static_linked.c  |   40 +
 .../selftests/bpf/progs/test_static_linked1.c |   30 +
 .../selftests/bpf/progs/test_static_linked2.c |   31 +
 19 files changed, 2760 insertions(+), 417 deletions(-)
 create mode 100644 tools/lib/bpf/linker.c
 create mode 100644 tools/lib/bpf/strset.c
 create mode 100644 tools/lib/bpf/strset.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/static_linked.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked2.c

-- 
2.24.1

