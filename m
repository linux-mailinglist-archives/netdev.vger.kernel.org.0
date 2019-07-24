Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9ACA73F85
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388612AbfGXUdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:33:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728866AbfGXT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:28:08 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OJQl8F002976
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 12:28:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=4KW8/KRP3Z8GnYCXZc7tu1W/ygafKTQ4fjFva83PXGw=;
 b=IdjTIQdEKxKV/ByHuHMOExMTf/voKrd340ZknWEqz6ari0Niw6P/3qzKtjzupfj9WZ+R
 RQKKsOfFnWJEafxG91mpDl5mGP6m0eDFP1woAwZyERAJB+YkJ0OqrJTClsGJJJepoMlt
 XMgp7QymJOIREAp6m2tFLbFfhksqhaYNF1o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2txu1ugp62-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 12:28:06 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 24 Jul 2019 12:28:05 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8407A8615F8; Wed, 24 Jul 2019 12:27:59 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 00/10] CO-RE offset relocations
Date:   Wed, 24 Jul 2019 12:27:32 -0700
Message-ID: <20190724192742.1419254-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=813 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set implements central part of CO-RE (Compile Once - Run
Everywhere, see [0] and [1] for slides and video): relocating field offsets.
Most of the details are written down as comments to corresponding parts of the
code.

Patch #1 adds loading of .BTF.ext offset relocations section and macros to
work with its contents.
Patch #2 implements CO-RE relocations algorithm in libbpf.
Patches #3-#10 adds selftests validating various parts of relocation handling,
type compatibility, etc.

For all tests to work, you'll need latest Clang/LLVM supporting
__builtin_preserve_access_index intrinsic, used for recording offset
relocations. Kernel on which selftests run should have BTF information built
in (CONFIG_DEBUG_INFO_BTF=y).

  [0] http://vger.kernel.org/bpfconf2019.html#session-2
  [1] http://vger.kernel.org/lpc-bpf2018.html#session-2CO-RE relocations

This patch set implements central part of CO-RE (Compile Once - Run
Everywhere, see [0] and [1] for slides and video): relocating field offsets.
Most of the details are written down as comments to corresponding parts of the
code.

Patch #1 adds loading of .BTF.ext offset relocations section and macros to
work with its contents.
Patch #2 implements CO-RE relocations algorithm in libbpf.
Patches #3-#10 adds selftests validating various parts of relocation handling,
type compatibility, etc.

For all tests to work, you'll need latest Clang/LLVM supporting
__builtin_preserve_access_index intrinsic, used for recording offset
relocations. Kernel on which selftests run should have BTF information built
in (CONFIG_DEBUG_INFO_BTF=y).

  [0] http://vger.kernel.org/bpfconf2019.html#session-2
  [1] http://vger.kernel.org/lpc-bpf2018.html#session-2

Andrii Nakryiko (10):
  libbpf: add .BTF.ext offset relocation section loading
  libbpf: implement BPF CO-RE offset relocation algorithm
  selftests/bpf: add CO-RE relocs testing setup
  selftests/bpf: add CO-RE relocs struct flavors tests
  selftests/bpf: add CO-RE relocs nesting tests
  selftests/bpf: add CO-RE relocs array tests
  selftests/bpf: add CO-RE relocs enum/ptr/func_proto tests
  selftests/bpf: add CO-RE relocs modifiers/typedef tests
  selftest/bpf: add CO-RE relocs ptr-as-array tests
  selftests/bpf: add CO-RE relocs ints tests

 tools/lib/bpf/btf.c                           |  64 +-
 tools/lib/bpf/btf.h                           |   4 +
 tools/lib/bpf/libbpf.c                        | 866 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf_internal.h               |  91 ++
 .../selftests/bpf/prog_tests/core_reloc.c     | 363 ++++++++
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
 .../selftests/bpf/progs/core_reloc_types.h    | 642 +++++++++++++
 .../bpf/progs/test_core_reloc_arrays.c        |  58 ++
 .../bpf/progs/test_core_reloc_flavors.c       |  65 ++
 .../bpf/progs/test_core_reloc_ints.c          |  48 +
 .../bpf/progs/test_core_reloc_kernel.c        |  39 +
 .../bpf/progs/test_core_reloc_mods.c          |  68 ++
 .../bpf/progs/test_core_reloc_nesting.c       |  48 +
 .../bpf/progs/test_core_reloc_primitives.c    |  50 +
 .../bpf/progs/test_core_reloc_ptr_as_arr.c    |  34 +
 58 files changed, 2527 insertions(+), 47 deletions(-)
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
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_mods.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_nesting.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_primitives.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_ptr_as_arr.c

-- 
2.17.1

