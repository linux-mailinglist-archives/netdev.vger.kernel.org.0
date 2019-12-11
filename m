Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB311A4B5
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 07:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfLKGuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 01:50:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25436 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727777AbfLKGuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 01:50:23 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBB6oLVW011414
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 22:50:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=VFRtLBc7W10U+5ioQoLMMywjohLBuv1Bl8DUvZCi9ec=;
 b=rKsee+fVp1TwVbknz2SRVRuDdqWQNjsgIP53FbX56Qb9iusGsttAjgX5BxtjFS5PbRgY
 /F2PVhGstQQw7qiuyKaBzNzJnVfcLm9EA7ReFZRScw4rLZXVEVlxhMQznjYjmI3aizhU
 vVAgWR8ejeK6WnaauTG/9tTDWtLgeZXfeks= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wt831dks7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 22:50:22 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 10 Dec 2019 22:50:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D26E12EC194D; Tue, 10 Dec 2019 22:50:05 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] Add libbpf-provided extern variables support
Date:   Tue, 10 Dec 2019 22:49:59 -0800
Message-ID: <20191211065002.2074074-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_01:2019-12-10,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110058
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
- patch #1 adds all of the libbpf internal machinery for externs support,
  including setting up BTF information for .extern data section;
- patch #2 adds support for .extern into BPF skeleton;
- patch #3 adds externs selftests, as well as enhances test_skeleton.c te=
st to
  validate mmap()-ed .extern datasection functionality.

This patch set is based off BPF skeleton patch set ([0]).

  [0] https://patchwork.ozlabs.org/project/netdev/list/?series=3D147459&s=
tate=3D*

v1->v2:
- use BTF type information for externs (Alexei);
- add strings support;
- add BPF skeleton support for .extern.

Andrii Nakryiko (3):
  libbpf: support libbpf-provided extern variables
  bpftool: generate externs datasec in BPF skeleton
  selftests/bpf: add tests for libbpf-provided externs

 include/uapi/linux/btf.h                      |   3 +-
 tools/bpf/bpftool/gen.c                       |   4 +
 tools/include/uapi/linux/btf.h                |   7 +-
 tools/lib/bpf/Makefile                        |  15 +-
 tools/lib/bpf/bpf_helpers.h                   |   9 +
 tools/lib/bpf/btf.c                           |   9 +-
 tools/lib/bpf/libbpf.c                        | 769 ++++++++++++++++--
 tools/lib/bpf/libbpf.h                        |   6 +-
 tools/lib/bpf/libbpf_internal.h               |   6 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/core_extern.c    | 192 +++++
 .../selftests/bpf/prog_tests/skeleton.c       |  18 +-
 .../selftests/bpf/progs/test_core_extern.c    |  62 ++
 .../selftests/bpf/progs/test_skeleton.c       |   9 +
 14 files changed, 1024 insertions(+), 87 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_extern.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_extern.c

--=20
2.17.1

