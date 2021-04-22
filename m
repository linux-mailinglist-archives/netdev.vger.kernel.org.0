Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309E03676F2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 03:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234154AbhDVBqs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Apr 2021 21:46:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25360 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229740AbhDVBqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 21:46:43 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13M1i4Yk032207
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 18:46:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 382kqnvvvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 18:46:09 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 18:46:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9E2572ED59F8; Wed, 21 Apr 2021 18:45:58 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/6] BPF static linker: support static vars and maps
Date:   Wed, 21 Apr 2021 18:45:50 -0700
Message-ID: <20210422014556.3451936-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: bPaioutebEwZIc_oxkQI1auTP12mIkX-
X-Proofpoint-ORIG-GUID: bPaioutebEwZIc_oxkQI1auTP12mIkX-
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1034 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Deal with static variables and maps better to make them work with BPF skeleton
well. All static variables and maps are renamed in corresponding BTF
information so as to have an "<obj_name>.." prefix, which allows to
distinguish name-conflicting static entities between multiple linked files.

Also make libbpf support static maps properly. Previously static map reference
resulted in the most probably erroneous use of the very *first* defined map,
because it was the one with offset 0. Now static map references are resolved
properly and thus static maps are finally usable. BPF static linker already
supports static maps and no further changes are required, beyond variable
renaming.

Patch #1 adds missed documentation of the latest Clang dependency.

N.B. This patch set is based on top of patch set [0].

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=468825

Andrii Nakryiko (6):
  selftests/bpf: document latest Clang fix expectations for linking
    tests
  libbpf: rename static variables during linking
  libbpf: support static map definitions
  bpftool: handle transformed static map names in BPF skeleton
  selftests/bpf: extend linked_vars selftests with static variables
  selftests/bpf: extend linked_maps selftests with static maps

 tools/bpf/bpftool/gen.c                       |  38 +++---
 tools/lib/bpf/libbpf.c                        |   7 +-
 tools/lib/bpf/libbpf.h                        |  12 +-
 tools/lib/bpf/linker.c                        | 121 +++++++++++++++++-
 tools/testing/selftests/bpf/README.rst        |   9 ++
 .../selftests/bpf/prog_tests/linked_maps.c    |  20 ++-
 .../selftests/bpf/prog_tests/linked_vars.c    |  12 +-
 .../selftests/bpf/prog_tests/skeleton.c       |   8 +-
 .../selftests/bpf/prog_tests/static_linked.c  |   8 +-
 .../selftests/bpf/progs/bpf_iter_test_kern4.c |   4 +-
 .../selftests/bpf/progs/linked_maps1.c        |  13 ++
 .../selftests/bpf/progs/linked_maps2.c        |  18 +++
 .../selftests/bpf/progs/linked_vars1.c        |   4 +-
 .../selftests/bpf/progs/linked_vars2.c        |   4 +-
 .../selftests/bpf/progs/test_check_mtu.c      |   4 +-
 .../selftests/bpf/progs/test_cls_redirect.c   |   4 +-
 .../bpf/progs/test_snprintf_single.c          |   2 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 .../selftests/bpf/progs/test_static_linked1.c |   6 +-
 .../selftests/bpf/progs/test_static_linked2.c |   4 +-
 20 files changed, 251 insertions(+), 51 deletions(-)

-- 
2.30.2

