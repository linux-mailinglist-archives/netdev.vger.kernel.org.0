Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3479B11EEDF
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfLMXwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:52:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9064 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbfLMXwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:52:03 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBDNpONM012067
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:52:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=YXOOuOZ03EcBnBrGGLDOz6IisuvLp9MdqpEZ7nS9B/g=;
 b=pY7vJz7G6UP4p/KBydswKOCaGya7JIYTaxpegapejIsWywt+NmSAY7kQ8uEj1jAxo5MQ
 1+/zyN4OfqR/Gcw6I0iXgHfr3DlQuqLj1wP6Fj4Ll42fb3pDIQFUOQvJCz0ZVRiZ+IRE
 26btOw2mG+EAqUTvvDeuci3d7sgSoE80iYU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wvfg8sejy-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:52:01 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 15:51:47 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 33A842EC1A1D; Fri, 13 Dec 2019 15:51:46 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/4] Add libbpf-provided extern variables support
Date:   Fri, 13 Dec 2019 15:51:40 -0800
Message-ID: <20191213235144.3063354-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130165
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
versions). Patch #3 explicitly tests a scenario of using unsupported BPF
helper, to validate the approach.

This patch set heavily relies on BTF type information emitted by compiler=
 for
each extern variable declaration. Based on specific types, libbpf does st=
rict
checks of config data values correctness. See patch #1 for details.

Outline of the patch set:
- patch #1 does a small clean up of internal map names contants;
- patch #2 adds all of the libbpf internal machinery for externs support,
  including setting up BTF information for .extern data section;
- patch #3 adds support for .extern into BPF skeleton;
- patch #4 adds externs selftests, as well as enhances test_skeleton.c te=
st to
  validate mmap()-ed .extern datasection functionality.

This patch set is based off BPF skeleton patch set ([0]).

  [0] https://patchwork.ozlabs.org/project/netdev/list/?series=3D148468&s=
tate=3D*

v2->v3:
- truncate too long strings (Alexei);
- clean ups, adding comments (Alexei);

v1->v2:
- use BTF type information for externs (Alexei);
- add strings support;
- add BPF skeleton support for .extern.

Andrii Nakryiko (4):
  libbpf: extract internal map names into constants
  libbpf: support libbpf-provided extern variables
  bpftool: generate externs datasec in BPF skeleton
  selftests/bpf: add tests for libbpf-provided externs

 include/uapi/linux/btf.h                      |   3 +-
 tools/bpf/bpftool/gen.c                       |   4 +
 tools/include/uapi/linux/btf.h                |   7 +-
 tools/lib/bpf/Makefile                        |  15 +-
 tools/lib/bpf/bpf_helpers.h                   |   9 +
 tools/lib/bpf/btf.c                           |   9 +-
 tools/lib/bpf/libbpf.c                        | 786 ++++++++++++++++--
 tools/lib/bpf/libbpf.h                        |  12 +-
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/core_extern.c    | 193 +++++
 .../selftests/bpf/prog_tests/skeleton.c       |  18 +-
 .../selftests/bpf/progs/test_core_extern.c    |  62 ++
 .../selftests/bpf/progs/test_skeleton.c       |   9 +
 13 files changed, 1042 insertions(+), 87 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_extern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_extern.c

--=20
2.17.1

