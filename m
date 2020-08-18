Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364B3249107
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHRWjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:39:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23074 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726957AbgHRWjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:39:37 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGOU2002561
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=nma8tot9rRwTO5qxrDZMQrTsjCyz/EcBnR3sRhh1OZI=;
 b=mKHRqZKNRXEcRx1kvyOaJQQSQyOkAkbo4vzRzHDQh+WRQjxQREMEXbflzOiUsMFtELSy
 MipkptrLcsedHVj9PsOb2h88nNNi9PGCpA6Bjn5B6w1t9J9JRe3lHCfS01Ame16EbXiq
 k0zhmhdD405kExrA/KM1wxYN4eAwhR7H+pI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pawdrn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:39:37 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:39:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 57F322EC5EB9; Tue, 18 Aug 2020 15:39:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/9] Add support for type-based and enum value-based CO-RE relocations
Date:   Tue, 18 Aug 2020 15:39:12 -0700
Message-ID: <20200818223921.2911963-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 mlxlogscore=991 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds libbpf support to two new classes of CO-RE relocation=
s:
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

As part of this patch set, one potential issue with ambiguous CO-RE
relocations was solved (see patch #3). There are also some improvements t=
o the
way debug relocation logs are emitted, helping to get a high-level idea o=
f
what's going on for users that are willing to dive deeper into the intern=
als
of libbpf (or libbpf contributors, of course).

Selftests are added for all the new features and relocation ambiguity iss=
ue is
excercised as well.

LLVM patches adding these relocation in Clang:
  - __builtin_btf_type_id() ([0], [1], [2]);
  - __builtin_preserve_type_info(), __builtin_preserve_enum_value() ([3],=
 [4]).

rfc -> v1:
  - I've rebased patches on top of series [5], there is a very minor conf=
lict
    in bpf_core_read.h due to comment change. Series [5] would most
    probably go in first anyway.

  [0] https://reviews.llvm.org/D74572
  [1] https://reviews.llvm.org/D74668
  [2] https://reviews.llvm.org/D85174
  [3] https://reviews.llvm.org/D83878
  [4] https://reviews.llvm.org/D83242
  [5] https://patchwork.ozlabs.org/project/netdev/list/?series=3D196308&s=
tate=3D*

Andrii Nakryiko (9):
  libbpf: improve error logging for mismatched BTF kind cases
  libbpf: clean up and improve CO-RE reloc logging
  libbpf: improve relocation ambiguity detection
  selftests/bpf: add test validating failure on ambiguous relocation
    value
  libbpf: implement type-based CO-RE relocations support
  selftests/bpf: test TYPE_EXISTS and TYPE_SIZE CO-RE relocations
  selftests/bpf: add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
  libbpf: implement enum value-based CO-RE relocations
  selftests/bpf: add tests for ENUMVAL_EXISTS/ENUMVAL_VALUE relocations

 tools/lib/bpf/bpf_core_read.h                 |  80 +-
 tools/lib/bpf/btf.c                           |  17 +-
 tools/lib/bpf/btf.h                           |  38 -
 tools/lib/bpf/libbpf.c                        | 754 ++++++++++++++----
 tools/lib/bpf/libbpf_internal.h               |  84 +-
 .../selftests/bpf/prog_tests/core_reloc.c     | 328 +++++++-
 .../bpf/progs/btf__core_reloc_enumval.c       |   3 +
 .../progs/btf__core_reloc_enumval___diff.c    |   3 +
 .../btf__core_reloc_enumval___err_missing.c   |   3 +
 .../btf__core_reloc_enumval___val3_missing.c  |   3 +
 .../btf__core_reloc_size___err_ambiguous.c    |   4 +
 .../bpf/progs/btf__core_reloc_type_based.c    |   3 +
 ...btf__core_reloc_type_based___all_missing.c |   3 +
 .../btf__core_reloc_type_based___diff_sz.c    |   3 +
 ...f__core_reloc_type_based___fn_wrong_args.c |   3 +
 .../btf__core_reloc_type_based___incompat.c   |   3 +
 .../bpf/progs/btf__core_reloc_type_id.c       |   3 +
 ...tf__core_reloc_type_id___missing_targets.c |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 352 +++++++-
 .../bpf/progs/test_core_reloc_enumval.c       |  69 ++
 .../bpf/progs/test_core_reloc_type_based.c    | 107 +++
 .../bpf/progs/test_core_reloc_type_id.c       |  94 +++
 22 files changed, 1727 insertions(+), 233 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval___err_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enu=
mval___val3_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_siz=
e___err_ambiguous.c
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

