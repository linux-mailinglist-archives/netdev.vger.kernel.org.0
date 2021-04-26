Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1C36BA0D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhDZTav convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Apr 2021 15:30:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36550 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240343AbhDZTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 15:30:46 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QJNnxt024587
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:30:04 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3853g8fga5-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:30:03 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 12:30:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 073BD2ED6122; Mon, 26 Apr 2021 12:29:51 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 bpf-next 0/5] CO-RE relocation selftests fixes
Date:   Mon, 26 Apr 2021 12:29:44 -0700
Message-ID: <20210426192949.416837-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 82nSTUbMD7_ukYNk96GnkLob_8rOjYzx
X-Proofpoint-GUID: 82nSTUbMD7_ukYNk96GnkLob_8rOjYzx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_09:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260149
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer noticed that core_reloc selftest has two inverted CHECK()
conditions, allowing failing tests to pass unnoticed. Fixing that opened up
few long-standing (field existence and direct memory bitfields) and one recent
failures (BTF_KIND_FLOAT relos).

This patch set fixes core_reloc selftest to capture such failures reliably in
the future. It also fixes all the newly failing tests. See individual patches
for details.

This patch set also completes a set of ASSERT_xxx() macros, so now there
should be a very little reason to use verbose and error-prone generic CHECK()
macro.

v1->v2:
  - updated bpf_core_fields_are_compat() comment to mention FLOAT (Lorenz).

Cc: Lorenz Bauer <lmb@cloudflare.com>

Andrii Nakryiko (5):
  selftests/bpf: add remaining ASSERT_xxx() variants
  libbpf: support BTF_KIND_FLOAT during type compatibility checks in
    CO-RE
  selftests/bpf: fix BPF_CORE_READ_BITFIELD() macro
  selftests/bpf: fix field existence CO-RE reloc tests
  selftests/bpf: fix core_reloc test runner

 tools/lib/bpf/bpf_core_read.h                 | 16 ++++--
 tools/lib/bpf/libbpf.c                        |  6 ++-
 .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
 .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
 .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
 .../selftests/bpf/prog_tests/core_reloc.c     | 51 +++++++++++--------
 .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
 .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
 ...ore_reloc_existence___err_wrong_arr_kind.c |  3 --
 ...loc_existence___err_wrong_arr_value_type.c |  3 --
 ...ore_reloc_existence___err_wrong_int_kind.c |  3 --
 ..._core_reloc_existence___err_wrong_int_sz.c |  3 --
 ...ore_reloc_existence___err_wrong_int_type.c |  3 --
 ..._reloc_existence___err_wrong_struct_type.c |  3 --
 ..._core_reloc_existence___wrong_field_defs.c |  3 ++
 .../selftests/bpf/progs/core_reloc_types.h    | 20 +-------
 tools/testing/selftests/bpf/test_progs.h      | 50 +++++++++++++++++-
 18 files changed, 108 insertions(+), 77 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c

-- 
2.30.2

