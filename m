Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E1C29E9B
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391510AbfEXS7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:59:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44800 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbfEXS7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:59:15 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OIxAmS004477
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=VGNk/z685rkUcaU0J2KYCIjYdLVKdGIQA6fNh0aC3Fc=;
 b=CaYIYx/yOuqRNIuzP7ltNKjpLfYGwIboKLPrhGS7N5gHDZk0gdShqLSxrhSQb9V1jsRM
 mNBZlnTW+e6Dn4TtjsWbmrMuusjj/eho89Fw3Yoe7CGv3jmKVL9sltcaQMdrar1Pm1fP
 TZKD0Fg5nycbrVIy8qw3nFMpfmAgrWTWkK0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2spbs6a4gc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:14 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 11:59:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 157378613DC; Fri, 24 May 2019 11:59:09 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 00/12] BTF-to-C converter
Date:   Fri, 24 May 2019 11:58:55 -0700
Message-ID: <20190524185908.3562231-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds BTF-to-C dumping APIs to libbpf, allowing to output
a subset of BTF types as a compilable C type definitions. This is useful by
itself, as raw BTF output is not easy to inspect and comprehend. But it's also
a big part of BPF CO-RE (compile once - run everywhere) initiative aimed at
allowing to write relocatable BPF programs, that won't require on-the-host
kernel headers (and would be able to inspect internal kernel structures, not
exposed through kernel headers).

This patch set consists of three groups of patches and one pre-patch, with the
BTF-to-C dumper API depending on the first two groups.

Pre-patch #1 fixes issue with libbpf_internal.h.

btf__parse_elf() API patches:
- patch #2 adds btf__parse_elf() API to libbpf, allowing to load BTF and/or
  BTF.ext from ELF file;
- patch #3 utilizies btf__parse_elf() from bpftool for `btf dump file` command;
- patch #4 switches test_btf.c to use btf__parse_elf() to check for presence
  of BTF data in object file.

libbpf's internal hashmap patches:
- patch #5 adds resizeable non-thread safe generic hashmap to libbpf;
- patch #6 adds tests for that hashmap;
- patch #7 migrates btf_dedup()'s dedup_table to use hashmap w/ APPEND.

BTF-to-C dumper API patches:
- patch #8 adds btf_dump APIs with all the logic for laying out type
  definitions in correct order and emitting C syntax for them;
- patch #9 adds lots of tests for common and quirky parts of C type system;
- patch #10 adds support for C-syntax btf dumping to bpftool;
- patch #11 updates bpftool documentation to mention C-syntax dump option;
- patch #12 update bash-completion for btf dump sub-command.

v2->v3:
- fix bpftool-btf.rst formatting (Quentin);
- simplify bash autocompletion script (Quentin);
- better error message in btf dump (Quentin);

v1->v2:
- removed unuseful file header (Jakub);
- removed inlines in .c (Jakub);
- added 'format {c|raw}' keyword/option (Jakub);
- re-use i var for iteration in btf_dump_c() (Jakub);
- bumped libbpf version to 0.0.4;

v0->v1:
- fix bug in hashmap__for_each_bucket_entry() not handling empty hashmap;
- removed `btf dump`-specific libbpf logging hook up (Quentin has more generic
  patchset);
- change btf__parse_elf() to always load .BTF and return it as a result, with
  .BTF.ext being optional and returned through struct btf_ext** arg (Alexei);
- endianness check to use __BYTE_ORDER__ (Alexei);
- bool:1 to __u8:1 in type_aux_state (Alexei);
- added HASHMAP_APPEND strategy to hashmap, changed
  hashmap__for_each_key_entry() to also check for key equality during
  iteration (multimap iteration for key);
- added new tests for empty hashmap and hashmap as a multimap;
- tried to clarify weak/strong dependency ordering comments (Alexei)
- btf dump test's expected output - support better commenting aproach (Alexei);
- added bash-completion for a new "c" option (Alexei).

Andrii Nakryiko (12):
  libbpf: ensure libbpf.h is included along libbpf_internal.h
  libbpf: add btf__parse_elf API to load .BTF and .BTF.ext
  bpftool: use libbpf's btf__parse_elf API
  selftests/bpf: use btf__parse_elf to check presence of BTF/BTF.ext
  libbpf: add resizable non-thread safe internal hashmap
  selftests/bpf: add tests for libbpf's hashmap
  libbpf: switch btf_dedup() to hashmap for dedup table
  libbpf: add btf_dump API for BTF-to-C conversion
  selftests/bpf: add btf_dump BTF-to-C conversion tests
  bpftool: add C output format option to btf dump subcommand
  bpftool/docs: add description of btf dump C option
  bpftool: update bash-completion w/ new c option for btf dump

 .../bpf/bpftool/Documentation/bpftool-btf.rst |   35 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   21 +-
 tools/bpf/bpftool/btf.c                       |  162 +-
 tools/lib/bpf/Build                           |    4 +-
 tools/lib/bpf/btf.c                           |  329 ++--
 tools/lib/bpf/btf.h                           |   19 +
 tools/lib/bpf/btf_dump.c                      | 1336 +++++++++++++++++
 tools/lib/bpf/hashmap.c                       |  229 +++
 tools/lib/bpf/hashmap.h                       |  173 +++
 tools/lib/bpf/libbpf.map                      |    8 +
 tools/lib/bpf/libbpf_internal.h               |    2 +
 tools/testing/selftests/bpf/.gitignore        |    2 +
 tools/testing/selftests/bpf/Makefile          |    3 +-
 .../bpf/progs/btf_dump_test_case_bitfields.c  |   92 ++
 .../bpf/progs/btf_dump_test_case_multidim.c   |   35 +
 .../progs/btf_dump_test_case_namespacing.c    |   73 +
 .../bpf/progs/btf_dump_test_case_ordering.c   |   63 +
 .../bpf/progs/btf_dump_test_case_packing.c    |   75 +
 .../bpf/progs/btf_dump_test_case_padding.c    |  111 ++
 .../bpf/progs/btf_dump_test_case_syntax.c     |  229 +++
 tools/testing/selftests/bpf/test_btf.c        |   71 +-
 tools/testing/selftests/bpf/test_btf_dump.c   |  143 ++
 tools/testing/selftests/bpf/test_hashmap.c    |  382 +++++
 23 files changed, 3306 insertions(+), 291 deletions(-)
 create mode 100644 tools/lib/bpf/btf_dump.c
 create mode 100644 tools/lib/bpf/hashmap.c
 create mode 100644 tools/lib/bpf/hashmap.h
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_namespacing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_ordering.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
 create mode 100644 tools/testing/selftests/bpf/test_btf_dump.c
 create mode 100644 tools/testing/selftests/bpf/test_hashmap.c

-- 
2.17.1

