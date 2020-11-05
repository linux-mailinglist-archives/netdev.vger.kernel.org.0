Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDE2A7674
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgKEEeS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61854 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730906AbgKEEeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:17 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54Ti8q005834
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:17 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34kg7kykak-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:17 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:12 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 80C262EC8E04; Wed,  4 Nov 2020 20:34:03 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 00/11] libbpf: split BTF support
Date:   Wed, 4 Nov 2020 20:33:50 -0800
Message-ID: <20201105043402.2530976-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=8 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1034 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for generating and deduplicating split BTF. This
is an enhancement to the BTF, which allows to designate one BTF as the "base
BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.,
kernel module BTF), which are building upon and extending base BTF with extra
types and strings.

Once loaded, split BTF appears as a single unified BTF superset of base BTF,
with continuous and transparent numbering scheme. This allows all the existing
users of BTF to work correctly and stay agnostic to the base/split BTFs
composition.  The only difference is in how to instantiate split BTF: it
requires base BTF to be alread instantiated and passed to btf__new_xxx_split()
or btf__parse_xxx_split() "constructors" explicitly.

This split approach is necessary if we are to have a reasonably-sized kernel
module BTFs. By deduping each kernel module's BTF individually, resulting
module BTFs contain copies of a lot of kernel types that are already present
in vmlinux BTF. Even those single copies result in a big BTF size bloat. On my
kernel configuration with 700 modules built, non-split BTF approach results in
115MBs of BTFs across all modules. With split BTF deduplication approach,
total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
around 4MBs). This seems reasonable and practical. As to why we'd need kernel
module BTFs, that should be pretty obvious to anyone using BPF at this point,
as it allows all the BTF-powered features to be used with kernel modules:
tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.

This patch set is a pre-requisite to adding split BTF support to pahole, which
is a prerequisite to integrating split BTF into the Linux kernel build setup
to generate BTF for kernel modules. The latter will come as a follow-up patch
series once this series makes it to the libbpf and pahole makes use of it.

Patch #4 introduces necessary basic support for split BTF into libbpf APIs.
Patch #8 implements minimal changes to BTF dedup algorithm to allow
deduplicating split BTFs. Patch #11 adds extra -B flag to bpftool to allow to
specify the path to base BTF for cases when one wants to dump or inspect split
BTF. All the rest are refactorings, clean ups, bug fixes and selftests.

v1->v2:
  - addressed Song's feedback.


Andrii Nakryiko (11):
  libbpf: factor out common operations in BTF writing APIs
  selftest/bpf: relax btf_dedup test checks
  libbpf: unify and speed up BTF string deduplication
  libbpf: implement basic split BTF support
  selftests/bpf: add split BTF basic test
  selftests/bpf: add checking of raw type dump in BTF writer APIs
    selftests
  libbpf: fix BTF data layout checks and allow empty BTF
  libbpf: support BTF dedup of split BTFs
  libbpf: accomodate DWARF/compiler bug with duplicated identical arrays
  selftests/bpf: add split BTF dedup selftests
  tools/bpftool: add bpftool support for split BTF

 tools/bpf/bpftool/btf.c                       |   9 +-
 tools/bpf/bpftool/main.c                      |  15 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/lib/bpf/btf.c                           | 807 ++++++++++--------
 tools/lib/bpf/btf.h                           |   8 +
 tools/lib/bpf/libbpf.map                      |   9 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/btf_helpers.c     | 259 ++++++
 tools/testing/selftests/bpf/btf_helpers.h     |  19 +
 tools/testing/selftests/bpf/prog_tests/btf.c  |  40 +-
 .../bpf/prog_tests/btf_dedup_split.c          | 325 +++++++
 .../selftests/bpf/prog_tests/btf_split.c      |  99 +++
 .../selftests/bpf/prog_tests/btf_write.c      |  43 +
 tools/testing/selftests/bpf/test_progs.h      |  11 +
 14 files changed, 1292 insertions(+), 355 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.c
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_split.c

-- 
2.24.1

