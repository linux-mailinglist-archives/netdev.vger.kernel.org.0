Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA1424A72D
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHSTtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:49:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26752 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgHSTtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:49:20 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JJnJHo023102
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:49:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=X/r9VZgrV1LaURTeyhaRs6HnlrElR6hrezVteihKZU4=;
 b=auveu8FbESV+yQYvC6PjhZV930aY28/fFs87cFkHgOZxnVR1U2JrnkcuKpPwQj140cES
 taN3eWzUsQquJc7XchWZQKPP2cM+eSNis8aCpK8RQw4IB8g/NP/mktwsXn2LaNw/3oFs
 UJvgGrDDowBXaI5FuAllMR3Z3PyD/7iVUhg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304nxt9sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 12:49:19 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 12:45:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 958232EC5DF2; Wed, 19 Aug 2020 12:45:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/5] Add libbpf support for type- and enum value-based CO-RE relocations
Date:   Wed, 19 Aug 2020 12:45:14 -0700
Message-ID: <20200819194519.3375898-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=811 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds libbpf support for two new classes of CO-RE relocatio=
ns:
type-based (TYPE_EXISTS/TYPE_SIZE/TYPE_ID_LOCAL/TYPE_ID_TARGET) and enum
value-vased (ENUMVAL_EXISTS/ENUMVAL_VALUE):
  - TYPE_EXISTS allows to detect presence in kernel BTF of a locally-reco=
rded
    BTF type. Useful for feature detection (new functionality often comes=
 with
    new internal kernel types), as well as handling type renames and bigg=
er
    refactorings.
  - TYPE_SIZE allows to get the real size (in bytes) of a specified kerne=
l
    type. Useful for dumping internal structure as-is through perfbuf or
    ringbuf.
  - TYPE_ID_LOCAL/TYPE_ID_TARGET allow to capture BTF type ID of a BTF ty=
pe in
    program's BTF or kernel BTF, respectively. These could be used for
    high-performance and space-efficient generic data dumping/logging by
    relying on small and cheap BTF type ID as a data layout descriptor, f=
or
    post-processing on user-space side.
  - ENUMVAL_EXISTS can be used for detecting the presence of enumerator v=
alue
    in kernel's enum type. Most direct application is to detect BPF helpe=
r
    support in kernel.
  - ENUMVAL_VALUE allows to relocate real integer value of kernel enumera=
tor
    value, which is subject to change (e.g., always a potential issue for
    internal, non-UAPI, kernel enums).

I've indicated potential applications for these relocations, but relocati=
ons
themselves are generic and unassuming and are designed to work correctly =
even
in unintended applications. Furthermore, relocated values become constant=
s,
known to the verifier and could and would be used for dead branch code
detection and elimination. This makes them ideal to do all sorts of featu=
re
detection and guarding functionality that's not available on some older (=
but
still supported by BPF program) kernels, while having to compile and main=
tain
one unified source code.

Selftests are added for all the new features. Selftests utilizing new Cla=
ng
built-ins are designed such that they will compile with older Clangs and =
will
be skipped during test runs. So this shouldn't cause any build and test
failures on systems with slightly outdated Clang compiler.

LLVM patches adding these relocation in Clang:
  - __builtin_btf_type_id() ([0], [1], [2]);
  - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3],=
 [4]).

  [0] https://reviews.llvm.org/D74572
  [1] https://reviews.llvm.org/D74668
  [2] https://reviews.llvm.org/D85174
  [3] https://reviews.llvm.org/D83878
  [4] https://reviews.llvm.org/D83242

v2->v3:
  - fix feature detection for __builtin_btf_type_id() test (Yonghong);
  - fix extra empty lines at the end of files (Yonghong);

v1->v2:
  - selftests detect built-in support and are skipped if not found (Alexe=
i).

Andrii Nakryiko (5):
  libbpf: implement type-based CO-RE relocations support
  selftests/bpf: test TYPE_EXISTS and TYPE_SIZE CO-RE relocations
  selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
  libbpf: implement enum value-based CO-RE relocations
  selftests/bpf: add tests for ENUMVAL_EXISTS/ENUMVAL_VALUE relocations

 tools/lib/bpf/bpf_core_read.h                 |  80 +++-
 tools/lib/bpf/libbpf.c                        | 376 ++++++++++++++++--
 tools/lib/bpf/libbpf_internal.h               |   6 +
 .../selftests/bpf/prog_tests/core_reloc.c     | 349 ++++++++++++++--
 .../bpf/progs/btf__core_reloc_enumval.c       |   3 +
 .../progs/btf__core_reloc_enumval___diff.c    |   3 +
 .../btf__core_reloc_enumval___err_missing.c   |   3 +
 .../btf__core_reloc_enumval___val3_missing.c  |   3 +
 .../bpf/progs/btf__core_reloc_type_based.c    |   3 +
 ...btf__core_reloc_type_based___all_missing.c |   3 +
 .../btf__core_reloc_type_based___diff_sz.c    |   3 +
 ...f__core_reloc_type_based___fn_wrong_args.c |   3 +
 .../btf__core_reloc_type_based___incompat.c   |   3 +
 .../bpf/progs/btf__core_reloc_type_id.c       |   3 +
 ...tf__core_reloc_type_id___missing_targets.c |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 327 ++++++++++++++-
 .../bpf/progs/test_core_reloc_enumval.c       |  72 ++++
 .../bpf/progs/test_core_reloc_kernel.c        |   2 +
 .../bpf/progs/test_core_reloc_type_based.c    | 110 +++++
 .../bpf/progs/test_core_reloc_type_id.c       | 113 ++++++
 20 files changed, 1412 insertions(+), 56 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval___err_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval___val3_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___all_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___fn_wrong_args.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_based___incompat.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_id.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_typ=
e_id___missing_targets.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enu=
mval.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_typ=
e_based.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_typ=
e_id.c

--=20
2.24.1

