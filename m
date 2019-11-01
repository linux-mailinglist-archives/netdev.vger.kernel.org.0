Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5417ECB5B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKAW2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 18:28:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56670 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbfKAW2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:28:15 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1MSCha023529
        for <netdev@vger.kernel.org>; Fri, 1 Nov 2019 15:28:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=iZlUY9B94obQKmMhRu/kyepqa8e0Aj04qrU3BHGiGjQ=;
 b=YS42IpCHyaqf3z+yDCkxg5la64bbqeQt4kDznG0NFXe4LUfB31IKyOqiFLbPC2J6NN1z
 VPzNrn6GouTwPY9bMIHgl7kikR8EeG5SVLNk77jO/URgn7laG1ZyMDBQt44xb+AJ6kub
 kQXpam73JW1GlWws0ogDz9A9ao+IS7q0K9M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w0sgmhafe-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 15:28:14 -0700
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 1 Nov 2019 15:28:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7D2E32EC1B43; Fri,  1 Nov 2019 15:28:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/5] Bitfield and size relocations support in libbpf
Date:   Fri, 1 Nov 2019 15:28:05 -0700
Message-ID: <20191101222810.1246166-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_08:2019-11-01,2019-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=596 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=8
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1911010208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for reading bitfields in a relocatable manner
through a set of relocations emitted by Clang, corresponding libbpf support
for those relocations, as well as abstracting details into
BPF_CORE_READ_BITFIELD/BPF_CORE_READ_BITFIELD_PROBED macro.

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

v1->v2:
- added direct memory read-based macro and tests for bitfield reads.

Andrii Nakryiko (5):
  selftests/bpf: remove too strict field offset relo test cases
  libbpf: add support for relocatable bitfields
  libbpf: add support for field size relocations
  selftest/bpf: add relocatable bitfield reading tests
  selftests/bpf: add field size relocation tests

 tools/lib/bpf/bpf_core_read.h                 |  79 ++++++
 tools/lib/bpf/libbpf.c                        | 243 +++++++++++++-----
 tools/lib/bpf/libbpf_internal.h               |   4 +
 .../selftests/bpf/prog_tests/core_reloc.c     | 123 ++++++++-
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
 .../progs/test_core_reloc_bitfields_direct.c  |  63 +++++
 .../progs/test_core_reloc_bitfields_probed.c  |  62 +++++
 .../bpf/progs/test_core_reloc_size.c          |  51 ++++
 23 files changed, 682 insertions(+), 161 deletions(-)
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
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_direct.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_bitfields_probed.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_size.c

-- 
2.17.1

