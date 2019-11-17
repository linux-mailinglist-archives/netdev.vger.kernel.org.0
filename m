Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D7FF829
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 08:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbfKQHIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 02:08:14 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46226 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbfKQHIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 02:08:14 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAH744gL027326
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=BqhFGWKCuC9qUWVvoI9kyc+5I4v5V82hLouZtrFOQ+0=;
 b=HELgwWiNO47HLEimjkNIigfANBABP3M/oyz43QjuuRBBoOVn+mEuEWjm8eoTy8m0nOJm
 KF9QbCc7UuUYrC9Xy13leyhATITw18bvjGIbZIFH45MJ1AavbE9+mw14QkqLyMmv6yZA
 miWVU1eNs2RxbQ9J3R+nwuJwWLmuDRPl7SY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wafqr9gqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 23:08:12 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 16 Nov 2019 23:08:12 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 533762EC19AE; Sat, 16 Nov 2019 23:08:11 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/6] Add libbpf-provided extern variables support
Date:   Sat, 16 Nov 2019 23:08:01 -0800
Message-ID: <20191117070807.251360-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-17_01:2019-11-15,2019-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 mlxscore=0 malwarescore=0 suspectscore=9
 impostorscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911170066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's often important for BPF program to know kernel version or some speci=
fic
config values (e.g., CONFIG_HZ to convert jiffies to seconds) and change =
or
adjust program logic based on their values. As of today, any such need ha=
s to
be resolved by recompiling BPF program for specific kernel and kernel
configuration. In practice this is usually achieved by using BCC and its
embedded LLVM/Clang. With such set up #ifdef CONFIG_XXX and similar
compile-time constructs allow to deal with kernel varieties.

With CO-RE (Compile Once =E2=80=93 Run Everywhere) approach, this is not =
an option,
unfortunately. All such logic variations have to be done as a normal
C language constructs (i.e., if/else, variables, etc), not a preprocessor
directives. This patch series add support for such advanced scenarios thr=
ough
C extern variables. These extern variables will be recognized by libbpf a=
nd
supplied through extra .extern internal map, similarly to global data. Th=
is
.extern map is read-only, which allows BPF verifier to track its content
precisely as constants. That gives an opportunity to have pre-compiled BP=
F
program, which can potentially use BPF functionality (e.g., BPF helpers) =
or
kernel features (types, fields, etc), that are available only on a subset=
 of
targeted kernels, while effectively eleminating (through verifier's dead =
code
detection) such unsupported functionality for other kernels (typically, o=
lder
versions). Patch #5 contains all the details. Patch #5 explicitly tests
a scenario of using unsupported BPF helper, to validate the approach.

As part of this patch set, libbpf also allows usage of initialized global
(non-static) variables, which provides better Clang semantics, which is c=
loser
and better aligned witht kernel vs userspace BPF map contents sharing.

Outline of the patch set:
- patches #1-#3 do some preliminary refactorings of libbpf relocation log=
ic
  and some more clean ups;
- patch #4 allows non-static variables and converts few tests to use them=
;
- patch #5 adds support for externs to libbpf;
- patch #6 adds tests for externs.

Andrii Nakryiko (6):
  selftests/bpf: ensure no DWARF relocations for BPF object files
  libbpf: refactor relocation handling
  libbpf: fix various errors and warning reported by checkpatch.pl
  libbpf: support initialized global variables
  libbpf: support libbpf-provided extern variables
  selftests/bpf: add tests for libbpf-provided externs

 tools/lib/bpf/Makefile                        |  17 +-
 tools/lib/bpf/libbpf.c                        | 758 +++++++++++++-----
 tools/lib/bpf/libbpf.h                        |   8 +-
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/prog_tests/core_extern.c    | 186 +++++
 .../selftests/bpf/progs/test_core_extern.c    |  43 +
 .../bpf/progs/test_core_reloc_arrays.c        |   4 +-
 .../progs/test_core_reloc_bitfields_direct.c  |   4 +-
 .../progs/test_core_reloc_bitfields_probed.c  |   4 +-
 .../bpf/progs/test_core_reloc_existence.c     |   4 +-
 .../bpf/progs/test_core_reloc_flavors.c       |   4 +-
 .../bpf/progs/test_core_reloc_ints.c          |   4 +-
 .../bpf/progs/test_core_reloc_kernel.c        |   4 +-
 .../bpf/progs/test_core_reloc_misc.c          |   4 +-
 .../bpf/progs/test_core_reloc_mods.c          |   4 +-
 .../bpf/progs/test_core_reloc_nesting.c       |   4 +-
 .../bpf/progs/test_core_reloc_primitives.c    |   4 +-
 .../bpf/progs/test_core_reloc_ptr_as_arr.c    |   4 +-
 .../bpf/progs/test_core_reloc_size.c          |   4 +-
 19 files changed, 820 insertions(+), 248 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_extern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_extern.c

--=20
2.17.1

