Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1B5375FC3
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 07:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhEGFm1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 01:42:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230446AbhEGFm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 01:42:26 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1475dndV020971
        for <netdev@vger.kernel.org>; Thu, 6 May 2021 22:41:27 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38csqa9aqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 22:41:27 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 22:41:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 01CC72ED7617; Thu,  6 May 2021 22:41:22 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [RFC PATCH bpf-next 0/7] BPF static linker: global symbols visibility
Date:   Thu, 6 May 2021 22:41:12 -0700
Message-ID: <20210507054119.270888-1-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: fDdLOkZPi8o05Lbrld5IUhbxzNkIdOgq
X-Proofpoint-ORIG-GUID: fDdLOkZPi8o05Lbrld5IUhbxzNkIdOgq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_01:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105070042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC explores dropping static variables from BPF skeleton and leaving them
for use only within BPF object file. Instead, BPF static linker is extended
with support for controlling global symbol visibility outside of a single BPF
object file through STV_HIDDEN and STV_INTERNAL ELF symbol visibility.

See patch #7 for all the details, justification, and comparison with
user-space linker behavior.

Andrii Nakryiko (7):
  bpftool: strip const/volatile/restrict modifiers from .bss and .data
    vars
  libbpf: add per-file linker opts
  selftests/bpf: stop using static variables for passing data to/from
    user-space
  bpftool: stop emitting static variables in BPF skeleton
  libbpf: fix ELF symbol visibility update logic
  libbpf: treat STV_INTERNAL same as STV_HIDDEN for functions
  libbpf: convert STV_HIDDEN symbols into STV_INTERNAL after linking

 tools/bpf/bpftool/gen.c                       |  8 ++-
 tools/lib/bpf/libbpf.c                        | 11 ++--
 tools/lib/bpf/libbpf.h                        | 10 ++-
 tools/lib/bpf/linker.c                        | 62 +++++++++++++++----
 .../selftests/bpf/prog_tests/send_signal.c    |  2 +-
 .../selftests/bpf/prog_tests/skeleton.c       |  6 +-
 .../selftests/bpf/prog_tests/static_linked.c  |  5 --
 .../selftests/bpf/progs/bpf_iter_test_kern4.c |  4 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c |  4 +-
 tools/testing/selftests/bpf/progs/tailcall3.c |  2 +-
 tools/testing/selftests/bpf/progs/tailcall4.c |  2 +-
 tools/testing/selftests/bpf/progs/tailcall5.c |  2 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c   |  2 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c   |  2 +-
 .../selftests/bpf/progs/test_check_mtu.c      |  4 +-
 .../selftests/bpf/progs/test_cls_redirect.c   |  4 +-
 .../bpf/progs/test_global_func_args.c         |  2 +-
 .../selftests/bpf/progs/test_rdonly_maps.c    |  6 +-
 .../selftests/bpf/progs/test_skeleton.c       |  4 +-
 .../bpf/progs/test_snprintf_single.c          |  2 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |  4 +-
 .../selftests/bpf/progs/test_static_linked1.c |  8 +--
 .../selftests/bpf/progs/test_static_linked2.c |  8 +--
 23 files changed, 105 insertions(+), 59 deletions(-)

-- 
2.30.2

