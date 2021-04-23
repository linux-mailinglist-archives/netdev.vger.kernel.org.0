Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9077A369A72
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhDWSyk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:54:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59480 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231735AbhDWSyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:54:38 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13NIr62f004075
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:54:01 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3839vureac-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:54:01 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:54:00 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3FF652ED5CA8; Fri, 23 Apr 2021 11:53:59 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 0/6] BPF static linker: support static vars and maps
Date:   Fri, 23 Apr 2021 11:53:51 -0700
Message-ID: <20210423185357.1992756-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: v2mgFgPPOqazxbUVsBJNBqB6mLyH-M3h
X-Proofpoint-GUID: v2mgFgPPOqazxbUVsBJNBqB6mLyH-M3h
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230122
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

  [0] https://patchwork.kernel.org/project/netdevbpf/list/?series=472405&state=*

v1->v2:
  - rebased on top of v3 of BPF static linker extern support patch set;
  - dropped selftests doc update, which went into mentioned patch set;
  - added skip modifiers for .data/.bss which was missed on initial submission.

Andrii Nakryiko (6):
  bpftool: strip const/volatile/restrict modifiers from .bss and .data
    vars
  libbpf: rename static variables during linking
  libbpf: support static map definitions
  bpftool: handle transformed static map names in BPF skeleton
  selftests/bpf: extend linked_vars selftests with static variables
  selftests/bpf: extend linked_maps selftests with static maps

 tools/bpf/bpftool/gen.c                       |  40 +++---
 tools/lib/bpf/libbpf.c                        |   7 +-
 tools/lib/bpf/libbpf.h                        |  12 +-
 tools/lib/bpf/linker.c                        | 121 +++++++++++++++++-
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
 19 files changed, 244 insertions(+), 51 deletions(-)

-- 
2.30.2

