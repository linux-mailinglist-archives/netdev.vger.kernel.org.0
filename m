Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062E8C272C
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbfI3UsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:48:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726425AbfI3UsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:48:02 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8UIqk8r017936
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=UaZYVBAYCbEdw9yzOZD9pu5G17Mr26abEl+DfapN+vo=;
 b=Sq4hHaV/d9s3XfrvMfs3m2aX5Y2NXubEtnu11ntLTHxUBo2Y99k4EZXfnMNXzgMtK/gJ
 va54hz7RD9Jj5I1rG4KZgqWwzTOjZtSohfD0QF7hf76HYc1JNrhsrELKkbr3BzdZKFQ5
 V1yEJuato5bJaXLCFOXueERQ7wTHfLZ/1Rg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vaqu66wms-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 11:59:03 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 11:59:02 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id BC7B586185A; Mon, 30 Sep 2019 11:59:00 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/6] Move bpf_helpers and add BPF_CORE_READ macros
Date:   Mon, 30 Sep 2019 11:58:49 -0700
Message-ID: <20190930185855.4115372-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_11:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 suspectscore=8 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set make bpf_helpers.h and bpf_endian.h part of libbpf itself for
consumption by user BPF programs, not just selftests. All the selftests are
switched to use libbpf's bpf_helpers/bpf_endian and selftests' ones are
removed.

As part of this patch set we also add BPF_CORE_READ variadic macros, that are
simplifying BPF CO-RE reads, especially the ones that have to follow few
pointers. E.g., what in non-BPF world (and when using BCC) would be:

int x = s->a->b.c->d; /* s, a, and b.c are pointers */

today would have to be written using explicit bpf_probe_read() calls as:

  void *t;
  int x;
  bpf_probe_read(&t, sizeof(t), s->a);
  bpf_probe_read(&t, sizeof(t), ((struct b *)t)->b.c);
  bpf_probe_read(&x, sizeof(x), ((struct c *)t)->d);

This is super inconvenient and distracts from program logic a lot. Now, with
added BPF_CORE_READ() macros, you can write the above as:

  int x = BPF_CORE_READ(s, a, b.c, d);

Up to 9 levels of pointer chasing are supported, which should be enough for
any practical purpose, hopefully, without adding too much boilerplate macro
definitions (though there is admittedly some, given how variadic and recursive
C macro have to be implemented).

There is also BPF_CORE_READ_INTO() variant, which relies on caller to allocate
space for result:

  int x;
  BPF_CORE_READ_INTO(&x, s, a, b.c, d);

Result of last bpf_probe_read() call in the chain of calls is the result of
BPF_CORE_READ_INTO(). If any intermediate bpf_probe_read() aall fails, then
all the subsequent ones will fail too, so this is sufficient to know whether
overall "operation" succeeded or not. No short-circuiting of bpf_probe_read()s
is done, though.

BPF_CORE_READ_STR_INTO() is added as well, which differs from
BPF_CORE_READ_INTO() only in that last bpf_probe_read() call (to read final
field after chasing pointers) is replaced with bpf_probe_read_str(). Result of
bpf_probe_read_str() is returned as a result of BPF_CORE_READ_STR_INTO() macro
itself, so that applications can track return code and/or length of read
string.

Patch set outline:
- patch #1 undoes previously added GCC-specific bpf-helpers.h include;
- patch #2 adds bpf_helper.h and bpf_endian.h into libbpf sources;
- patch #3 adjusts selftests (Makefile only) and removes
  bpf_helpers.h/bpf_endian.h from seftests/bpf;
- patch #4 adds variadic BPF_CORE_READ() macro family, as described above;
- patch #5 fixes existing BPF CO-RE reloc selftest as it previously re-used
  BPF_CORE_READ() macro name with slightly different syntax;
- patch #6 adds tests to verify all possible levels of pointer nestedness for
  BPF_CORE_READ(), as well as correctness test for BPF_CORE_READ_STR_INTO().

Andrii Nakryiko (6):
  selftests/bpf: undo GCC-specific bpf_helpers.h changes
  libbpf: move bpf_helpers.h, bpf_endian.h into libbpf
  selftests/bpf: switch test to use libbpf's helpers
  libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO helpers
  selftests/bpf: adjust CO-RE reloc tests for new BPF_CORE_READ macro
  selftests/bpf: add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro
    tests

 tools/lib/bpf/Makefile                        |   4 +-
 .../selftests => lib}/bpf/bpf_endian.h        |   0
 .../selftests => lib}/bpf/bpf_helpers.h       | 159 ++++++++++++++++--
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |   8 +-
 .../selftests/bpf/progs/core_reloc_types.h    |   9 +
 .../bpf/progs/test_core_reloc_arrays.c        |  10 +-
 .../bpf/progs/test_core_reloc_flavors.c       |   8 +-
 .../bpf/progs/test_core_reloc_ints.c          |  18 +-
 .../bpf/progs/test_core_reloc_kernel.c        |  60 ++++++-
 .../bpf/progs/test_core_reloc_misc.c          |   8 +-
 .../bpf/progs/test_core_reloc_mods.c          |  18 +-
 .../bpf/progs/test_core_reloc_nesting.c       |   6 +-
 .../bpf/progs/test_core_reloc_primitives.c    |  12 +-
 .../bpf/progs/test_core_reloc_ptr_as_arr.c    |   4 +-
 15 files changed, 273 insertions(+), 53 deletions(-)
 rename tools/{testing/selftests => lib}/bpf/bpf_endian.h (100%)
 rename tools/{testing/selftests => lib}/bpf/bpf_helpers.h (77%)

-- 
2.17.1

