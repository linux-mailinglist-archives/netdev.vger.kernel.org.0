Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AA3EC8BD
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 19:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfKAS7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 14:59:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727498AbfKAS7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 14:59:19 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA1Iwlb4008869
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 11:59:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=mb4cXXCQzz099Lm10VHOPZfUmwU3klSJ9VmAYRalvtk=;
 b=fwAzQgk+/9hdfZIN5V6MTR4yfhls1lpdKFbc66zFeuHIUMqs3+BDQb2LnrBhuBeP3qVe
 a8jnCMqQbX98wazRjggiZg0mZFrZezKQt+BEauU/8vxXp3fYUNmP0PRyragQQjoOAPhE
 Z/139y2qA0NzM0XJvNx+AkkjXikVGugyqc8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2w01b27fpb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 11:59:17 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 1 Nov 2019 11:59:15 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 79C7B2EC1A58; Fri,  1 Nov 2019 11:59:14 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/5] Bitfield and size relocations support in libbpf
Date:   Fri, 1 Nov 2019 11:59:06 -0700
Message-ID: <20191101185912.594925-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_07:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=8
 phishscore=0 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=580 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911010172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for reading bitfields in a relocatable manner
through a set of relocations emitted by Clang, corresponding libbpf support
for those relocations, as well as abstracting details into
BPF_CORE_READ_BITFIELD macro.

We also add support for capturing relocatable field size, so that BPF program
code can adjust its logic to actual amount of data it needs to operate on,
even if it changes between kernels. New convenience macro is added to
bpf_core_read.h (bpf_core_field_size(), in the same family of macro as
bpf_core_read() and bpf_core_field_exists()). Corresponding set of selftests
are added to excercise this logic and validate correctness in a variety of
scenarios.

Some of the overly strict logic of matching fields is relaxed to support wider
variety of scenarios. See patch #1 for that.

Patch #1 removes few overly strict test cases.
Patch #2 adds support for bitfield-related relocations.
Patch #3 adds some further adjustments to support generic field size
relocations and introduces bpf_core_field_size() macro.
Patch #4 tests bitfield reading.
Patch #5 tests field size relocations.

Andrii Nakryiko (5):
  selftests/bpf: remove too strict field offset relo test cases
  libbpf: add support for relocatable bitfields
  libbpf: add support for field size relocations
  selftest/bpf: add relocatable bitfield reading tests
  selftests/bpf: add field size relocation tests

 tools/lib/bpf/bpf_core_read.h                 |  47 ++++
 tools/lib/bpf/libbpf.c                        | 243 +++++++++++++-----
 tools/lib/bpf/libbpf_internal.h               |   4 +
 .../no_alu32/btf_dump_test_case_bitfields.c   |  92 +++++++
 .../no_alu32/btf_dump_test_case_multidim.c    |  35 +++
 .../no_alu32/btf_dump_test_case_namespacing.c |  73 ++++++
 .../no_alu32/btf_dump_test_case_ordering.c    |  63 +++++
 .../bpf/no_alu32/btf_dump_test_case_packing.c |  75 ++++++
 .../bpf/no_alu32/btf_dump_test_case_padding.c | 114 ++++++++
 .../bpf/no_alu32/btf_dump_test_case_syntax.c  | 229 +++++++++++++++++
 .../selftests/bpf/prog_tests/core_reloc.c     |  92 ++++++-
 ...__core_reloc_arrays___err_wrong_val_type.c |   3 +
 ..._core_reloc_arrays___err_wrong_val_type1.c |   3 -
 ..._core_reloc_arrays___err_wrong_val_type2.c |   3 -
 .../bpf/progs/btf__core_reloc_bitfields.c     |   3 +
 ...tf__core_reloc_bitfields___bit_sz_change.c |   3 +
 ...__core_reloc_bitfields___bitfield_vs_int.c |   3 +
 ...e_reloc_bitfields___err_too_big_bitfield.c |   3 +
 ...__core_reloc_bitfields___just_big_enough.c |   3 +
 .../btf__core_reloc_ints___err_bitfield.c     |   3 -
 .../btf__core_reloc_ints___err_wrong_sz_16.c  |   3 -
 .../btf__core_reloc_ints___err_wrong_sz_32.c  |   3 -
 .../btf__core_reloc_ints___err_wrong_sz_64.c  |   3 -
 .../btf__core_reloc_ints___err_wrong_sz_8.c   |   3 -
 .../bpf/progs/btf__core_reloc_size.c          |   3 +
 .../progs/btf__core_reloc_size___diff_sz.c    |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    | 173 ++++++++-----
 .../bpf/progs/test_core_reloc_bitfields.c     |  69 +++++
 .../bpf/progs/test_core_reloc_size.c          |  51 ++++
 29 files changed, 1246 insertions(+), 159 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_multidim.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_namespacing.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_ordering.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_packing.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_padding.c
 create mode 100644 tools/testing/selftests/bpf/no_alu32/btf_dump_test_case_syntax.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type1.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_arrays___err_wrong_val_type2.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bit_sz_change.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___bitfield_vs_int.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___err_too_big_bitfield.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_bitfields___just_big_enough.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_bitfield.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_16.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_32.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_64.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_ints___err_wrong_sz_8.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_size.c

-- 
2.17.1

