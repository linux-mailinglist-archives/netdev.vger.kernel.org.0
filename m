Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDE2CB11E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbfJCV3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:29:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30474 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729891AbfJCV3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:29:19 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x93LT8KU012494
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 14:29:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=3vELgHnZDojMJeC2FUiElHXkNBXPGXO44HuiMQjREI0=;
 b=ApSB2+tujKDUymBY/FjTyAeWf8Oy44qpWh/ujxHshsg4Htu1gHjX8qQrKEI91X+tH+wD
 wDmclwmSr9C4KF4+2KN83U9CoZyluH52VUXYy6fzfRT+X68o85cf74R8JyDNyTRpeihg
 D7GXwvPU8WMpRLpziogmhM6OUvkmWJewmAA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdjr2j1nd-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:29:18 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 3 Oct 2019 14:28:58 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id CCFB38618DE; Thu,  3 Oct 2019 14:28:57 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 0/7] Move bpf_helpers and add BPF_CORE_READ macros
Date:   Thu, 3 Oct 2019 14:28:49 -0700
Message-ID: <20191003212856.1222735-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-03_08:2019-10-03,2019-10-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=8 lowpriorityscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910030172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes bpf_helpers.h and bpf_endian.h a part of libbpf itself
for consumption by user BPF programs, not just selftests. It also splits off
tracing helpers into bpf_tracing.h, which also becomes part of libbpf. Some of
the legacy stuff (BPF_ANNOTATE_KV_PAIR, load_{byte,half,word}, bpf_map_def
with unsupported fields, etc, is extracted into selftests-only bpf_legacy.h.
All the selftests and samples are switched to use libbpf's headers and
selftests' ones are removed.

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
- patch #2 splits off legacy stuff we don't want to carry over;
- patch #3 adjusts CO-RE reloc tests to avoid subsequent naming conflict with
  BPF_CORE_READ;
- patch #4 splits off bpf_tracing.h;
- patch #5 moves bpf_{helpers,endian,tracing}.h into libbpf and adjusts
  Makefiles to include libbpf for header search;
- patch #6 adds variadic BPF_CORE_READ() macro family, as described above;
- patch #7 adds tests to verify all possible levels of pointer nestedness for
  BPF_CORE_READ(), as well as correctness test for BPF_CORE_READ_STR_INTO().

v2->v3:
- small formatting fixes and macro () fixes (Song);

v1->v2:
- fix CO-RE reloc tests before bpf_helpers.h move (Song);
- split off legacy stuff we don't want to carry over (Daniel, Toke);
- split off bpf_tracing.h (Daniel);
- fix samples/bpf build (assuming other fixes are applied);
- switch remaining maps either to bpf_map_def_legacy or BTF-defined maps;

Andrii Nakryiko (7):
  selftests/bpf: undo GCC-specific bpf_helpers.h changes
  selftests/bpf: samples/bpf: split off legacy stuff from bpf_helpers.h
  selftests/bpf: adjust CO-RE reloc tests for new bpf_core_read() macro
  selftests/bpf: split off tracing-only helpers into bpf_tracing.h
  libbpf: move bpf_{helpers,endian,tracing}.h into libbpf
  libbpf: add BPF_CORE_READ/BPF_CORE_READ_INTO helpers
  selftests/bpf: add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro
    tests

 samples/bpf/Makefile                          |   2 +-
 samples/bpf/hbm_kern.h                        |  27 +-
 samples/bpf/map_perf_test_kern.c              |  24 +-
 samples/bpf/offwaketime_kern.c                |   1 +
 samples/bpf/parse_ldabs.c                     |   1 +
 samples/bpf/sampleip_kern.c                   |   1 +
 samples/bpf/sockex1_kern.c                    |   1 +
 samples/bpf/sockex2_kern.c                    |   1 +
 samples/bpf/sockex3_kern.c                    |   1 +
 samples/bpf/spintest_kern.c                   |   1 +
 samples/bpf/tcbpf1_kern.c                     |   1 +
 samples/bpf/test_map_in_map_kern.c            |  16 +-
 samples/bpf/test_overhead_kprobe_kern.c       |   1 +
 samples/bpf/test_probe_write_user_kern.c      |   1 +
 samples/bpf/trace_event_kern.c                |   1 +
 samples/bpf/tracex1_kern.c                    |   1 +
 samples/bpf/tracex2_kern.c                    |   1 +
 samples/bpf/tracex3_kern.c                    |   1 +
 samples/bpf/tracex4_kern.c                    |   1 +
 samples/bpf/tracex5_kern.c                    |   1 +
 tools/lib/bpf/Makefile                        |   5 +-
 .../selftests => lib}/bpf/bpf_endian.h        |   0
 .../selftests => lib}/bpf/bpf_helpers.h       | 399 +++++++-----------
 tools/lib/bpf/bpf_tracing.h                   | 195 +++++++++
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/bpf_legacy.h      |  39 ++
 .../selftests/bpf/prog_tests/core_reloc.c     |   8 +-
 .../selftests/bpf/progs/core_reloc_types.h    |   9 +
 tools/testing/selftests/bpf/progs/loop1.c     |   1 +
 tools/testing/selftests/bpf/progs/loop2.c     |   1 +
 tools/testing/selftests/bpf/progs/loop3.c     |   1 +
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  13 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c   |  13 +-
 .../selftests/bpf/progs/test_btf_haskv.c      |   1 +
 .../selftests/bpf/progs/test_btf_newkv.c      |   1 +
 .../bpf/progs/test_core_reloc_arrays.c        |  10 +-
 .../bpf/progs/test_core_reloc_flavors.c       |   8 +-
 .../bpf/progs/test_core_reloc_ints.c          |  18 +-
 .../bpf/progs/test_core_reloc_kernel.c        |  60 ++-
 .../bpf/progs/test_core_reloc_misc.c          |   8 +-
 .../bpf/progs/test_core_reloc_mods.c          |  18 +-
 .../bpf/progs/test_core_reloc_nesting.c       |   6 +-
 .../bpf/progs/test_core_reloc_primitives.c    |  12 +-
 .../bpf/progs/test_core_reloc_ptr_as_arr.c    |   4 +-
 44 files changed, 592 insertions(+), 325 deletions(-)
 rename tools/{testing/selftests => lib}/bpf/bpf_endian.h (100%)
 rename tools/{testing/selftests => lib}/bpf/bpf_helpers.h (65%)
 create mode 100644 tools/lib/bpf/bpf_tracing.h
 create mode 100644 tools/testing/selftests/bpf/bpf_legacy.h

-- 
2.17.1

