Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 495D8854AC
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 22:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389540AbfHGUtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 16:49:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56416 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389513AbfHGUtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 16:49:06 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77KmoRa001238
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 13:49:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5gQZqy1csSMTmg0Hx4PueIFoYGvh/unmwJm+FWTrFk0=;
 b=Wt/Y7Mt2tZurUsPwg5mT6EDpagtY2aVmGcqj3ESN+yMN/L3kwJmASi8anD0i/fvZMMW+
 w2VVANyY63SMz8gzpvCBaw/iDaUoFBz8O+cqnGaJwugghYQD5qVGX6Xa3LyYjSjjunjj
 opLY1XKoL6PTO73ACMEE87D9a25cHy14In4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u83wp8eu4-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 13:49:05 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 7 Aug 2019 13:48:50 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id ECB2986167B; Wed,  7 Aug 2019 13:48:45 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 00/14] CO-RE offset relocations
Date:   Wed, 7 Aug 2019 13:48:29 -0700
Message-ID: <20190807204843.513594-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set implements central part of CO-RE (Compile Once - Run
Everywhere, see [0] and [1] for slides and video): relocating fields offsets.
Most of the details are written down as comments to corresponding parts of the
code.

Patch #1 adds a bunch of commonly useful btf_xxx helpers to simplify working
with BTF types.
Patch #2 converts existing libbpf code to these new helpers and removes some
of pre-existing ones.
Patch #3 adds loading of .BTF.ext offset relocations section and macros to
work with its contents.
Patch #4 implements CO-RE relocations algorithm in libbpf.
Patch #5 introduced BPF_CORE_READ macro, hiding usage of Clang's
__builtin_preserve_access_index intrinsic that records offset relocation.
Patches #6-#14 adds selftests validating various parts of relocation handling,
type compatibility, etc.

For all tests to work, you'll need latest Clang/LLVM supporting
__builtin_preserve_access_index intrinsic, used for recording offset
relocations. Kernel on which selftests run should have BTF information built
in (CONFIG_DEBUG_INFO_BTF=y).

  [0] http://vger.kernel.org/bpfconf2019.html#session-2
  [1] http://vger.kernel.org/lpc-bpf2018.html#session-2

v4->v5:
- drop constness for btf_xxx() helpers, allowing to avoid type casts (Alexei);
- rebase on latest bpf-next, change test__printf back to printf;

v3->v4:
- added btf_xxx helpers (Alexei);
- switched libbpf code to new helpers;
- reduced amount of logging and simplified format in few places (Alexei);
- made flavor name parsing logic more strict (exactly three underscores);
- no uname() error checking (Alexei);
- updated misc tests to reflect latest Clang fixes (Yonghong);

v2->v3:
- enclose BPF_CORE_READ args in parens (Song);

v1->v2:
- add offsetofend(), fix btf_ext optional fields checks (Song);
- add bpf_core_dump_spec() for logging spec representation;
- move special first element processing out of the loop (Song);
- typo fixes (Song);
- drop BPF_ST | BPF_MEM insn relocation (Alexei);
- extracted BPF_CORE_READ into bpf_helpers (Alexei);
- added extra tests validating Clang capturing relocs correctly (Yonghong);
- switch core_relocs.c to use sub-tests;
- updated mods tests after Clang bug was fixed (Yonghong);
- fix bug enumerating candidate types;

Andrii Nakryiko (14):
  libbpf: add helpers for working with BTF types
  libbpf: convert libbpf code to use new btf helpers
  libbpf: add .BTF.ext offset relocation section loading
  libbpf: implement BPF CO-RE offset relocation algorithm
  selftests/bpf: add BPF_CORE_READ relocatable read macro
  selftests/bpf: add CO-RE relocs testing setup
  selftests/bpf: add CO-RE relocs struct flavors tests
  selftests/bpf: add CO-RE relocs nesting tests
  selftests/bpf: add CO-RE relocs array tests
  selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
  selftests/bpf: add CO-RE relocs modifiers/typedef tests
  selftests/bpf: add CO-RE relocs ptr-as-array tests
  selftests/bpf: add CO-RE relocs ints tests
  selftests/bpf: add CO-RE relocs misc tests

 tools/lib/bpf/btf.c                           | 250 ++---
 tools/lib/bpf/btf.h                           | 180 ++++
 tools/lib/bpf/btf_dump.c                      | 138 +--
 tools/lib/bpf/libbpf.c                        | 941 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf_internal.h               | 105 ++
 tools/testing/selftests/bpf/bpf_helpers.h     |  20 +
 .../selftests/bpf/prog_tests/core_reloc.c     | 385 +++++++
 .../bpf/progs/btf__core_reloc_arrays.c        |   3 +
 .../btf__core_reloc_arrays___diff_arr_dim.c   |   3 +
 ...btf__core_reloc_arrays___diff_arr_val_sz.c |   3 +
 .../btf__core_reloc_arrays___err_non_array.c  |   3 +
 ...btf__core_reloc_arrays___err_too_shallow.c |   3 +
 .../btf__core_reloc_arrays___err_too_small.c  |   3 +
 ..._core_reloc_arrays___err_wrong_val_type1.c |   3 +
 ..._core_reloc_arrays___err_wrong_val_type2.c |   3 +
 .../bpf/progs/btf__core_reloc_flavors.c       |   3 +
 .../btf__core_reloc_flavors__err_wrong_name.c |   3 +
 .../bpf/progs/btf__core_reloc_ints.c          |   3 +
 .../bpf/progs/btf__core_reloc_ints___bool.c   |   3 +
 .../btf__core_reloc_ints___err_bitfield.c     |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_16.c  |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_32.c  |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_64.c  |   3 +
 .../btf__core_reloc_ints___err_wrong_sz_8.c   |   3 +
 .../btf__core_reloc_ints___reverse_sign.c     |   3 +
 .../bpf/progs/btf__core_reloc_misc.c          |   5 +
 .../bpf/progs/btf__core_reloc_mods.c          |   3 +
 .../progs/btf__core_reloc_mods___mod_swap.c   |   3 +
 .../progs/btf__core_reloc_mods___typedefs.c   |   3 +
 .../bpf/progs/btf__core_reloc_nesting.c       |   3 +
 .../btf__core_reloc_nesting___anon_embed.c    |   3 +
 ...f__core_reloc_nesting___dup_compat_types.c |   5 +
 ...core_reloc_nesting___err_array_container.c |   3 +
 ...tf__core_reloc_nesting___err_array_field.c |   3 +
 ...e_reloc_nesting___err_dup_incompat_types.c |   4 +
 ...re_reloc_nesting___err_missing_container.c |   3 +
 ...__core_reloc_nesting___err_missing_field.c |   3 +
 ..._reloc_nesting___err_nonstruct_container.c |   3 +
 ...e_reloc_nesting___err_partial_match_dups.c |   4 +
 .../btf__core_reloc_nesting___err_too_deep.c  |   3 +
 .../btf__core_reloc_nesting___extra_nesting.c |   3 +
 ..._core_reloc_nesting___struct_union_mixup.c |   3 +
 .../bpf/progs/btf__core_reloc_primitives.c    |   3 +
 ...f__core_reloc_primitives___diff_enum_def.c |   3 +
 ..._core_reloc_primitives___diff_func_proto.c |   3 +
 ...f__core_reloc_primitives___diff_ptr_type.c |   3 +
 ...tf__core_reloc_primitives___err_non_enum.c |   3 +
 ...btf__core_reloc_primitives___err_non_int.c |   3 +
 ...btf__core_reloc_primitives___err_non_ptr.c |   3 +
 .../bpf/progs/btf__core_reloc_ptr_as_arr.c    |   3 +
 .../btf__core_reloc_ptr_as_arr___diff_sz.c    |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 667 +++++++++++++
 .../bpf/progs/test_core_reloc_arrays.c        |  55 +
 .../bpf/progs/test_core_reloc_flavors.c       |  62 ++
 .../bpf/progs/test_core_reloc_ints.c          |  44 +
 .../bpf/progs/test_core_reloc_kernel.c        |  36 +
 .../bpf/progs/test_core_reloc_misc.c          |  57 ++
 .../bpf/progs/test_core_reloc_mods.c          |  62 ++
 .../bpf/progs/test_core_reloc_nesting.c       |  46 +
 .../bpf/progs/test_core_reloc_primitives.c    |  43 +
 .../bpf/progs/test_core_reloc_ptr_as_arr.c    |  30 +
 62 files changed, 2979 insertions(+), 281 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_reloc.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_dim.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___diff_arr_val_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_non_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_shallow.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_too_small.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_flavors.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_flavors__err_wrong_name.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___bool.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___reverse_sign.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_misc.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods___mod_swap.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_mods___typedefs.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___anon_embed.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___dup_compat_types.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_array_field.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_dup_incompat_types.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_missing_field.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_nonstruct_container.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_partial_match_dups.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___err_too_deep.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___extra_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_nesting___struct_union_mixup.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_enum_def.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_func_proto.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___diff_ptr_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_enum.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_primitives___err_non_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ptr_as_arr___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/core_reloc_types.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_arrays.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_flavors.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ints.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_misc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c

-- 
2.17.1

