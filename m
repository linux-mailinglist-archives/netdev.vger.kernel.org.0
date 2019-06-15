Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0957F471CA
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 21:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfFOTM3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 15 Jun 2019 15:12:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34494 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfFOTM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 15:12:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5FJ9qFQ032310
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 12:12:28 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2t4v07h7a4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 12:12:28 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 15 Jun 2019 12:12:27 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 2A2E4760AA7; Sat, 15 Jun 2019 12:12:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/9] bpf: bounded loops and other features
Date:   Sat, 15 Jun 2019 12:12:16 -0700
Message-ID: <20190615191225.2409862-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-15_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=850 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906150181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2->v3: fixed issues in backtracking pointed out by Andrii.
The next step is to add a lot more tests for backtracking.

v1->v2: addressed Andrii's feedback.

this patch set introduces verifier support for bounded loops and
adds several other improvements.
Ideally they would be introduced one at a time,
but to support bounded loop the verifier needs to 'step back'
in the patch 1. That patch introduces tracking of spill/fill
of constants through the stack. Though it's a useful feature
it hurts cilium tests.
Patch 3 introduces another feature by extending is_branch_taken
logic to 'if rX op rY' conditions. This feature is also
necessary to support bounded loops.
Then patch 4 adds support for the loops while adding
key heuristics with jmp_processed.
Introduction of parentage chain of verifier states in patch 4
allows patch 9 to add backtracking of precise scalar registers
which finally resolves degradation from patch 1.

The end result is much faster verifier for existing programs
and new support for loops.
See patch 8 for many kinds of loops that are now validated.
Patch 9 is the most tricky one and could be rewritten with
a different algorithm in the future.

Alexei Starovoitov (9):
  bpf: track spill/fill of constants
  selftests/bpf: fix tests due to const spill/fill
  bpf: extend is_branch_taken to registers
  bpf: introduce bounded loops
  bpf: fix callees pruning callers
  selftests/bpf: fix tests
  selftests/bpf: add basic verifier tests for loops
  selftests/bpf: add realistic loop tests
  bpf: precise scalar_value tracking

 include/linux/bpf_verifier.h                  |  69 +-
 kernel/bpf/verifier.c                         | 767 ++++++++++++++++--
 .../bpf/prog_tests/bpf_verif_scale.c          |  67 +-
 tools/testing/selftests/bpf/progs/loop1.c     |  28 +
 tools/testing/selftests/bpf/progs/loop2.c     |  28 +
 tools/testing/selftests/bpf/progs/loop3.c     |  22 +
 tools/testing/selftests/bpf/progs/pyperf.h    |   6 +-
 tools/testing/selftests/bpf/progs/pyperf600.c |   9 +
 .../selftests/bpf/progs/pyperf600_nounroll.c  |   8 +
 .../testing/selftests/bpf/progs/strobemeta.c  |  10 +
 .../testing/selftests/bpf/progs/strobemeta.h  | 528 ++++++++++++
 .../bpf/progs/strobemeta_nounroll1.c          |   9 +
 .../bpf/progs/strobemeta_nounroll2.c          |   9 +
 .../selftests/bpf/progs/test_seg6_loop.c      | 261 ++++++
 .../selftests/bpf/progs/test_sysctl_loop1.c   |  71 ++
 .../selftests/bpf/progs/test_sysctl_loop2.c   |  72 ++
 .../selftests/bpf/progs/test_xdp_loop.c       | 231 ++++++
 tools/testing/selftests/bpf/test_verifier.c   |  11 +-
 tools/testing/selftests/bpf/verifier/calls.c  |  22 +-
 tools/testing/selftests/bpf/verifier/cfg.c    |  11 +-
 .../bpf/verifier/direct_packet_access.c       |   3 +-
 .../bpf/verifier/helper_access_var_len.c      |  28 +-
 tools/testing/selftests/bpf/verifier/loops1.c | 161 ++++
 23 files changed, 2317 insertions(+), 114 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/loop1.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop2.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop3.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_nounroll.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta.h
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_nounroll1.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_nounroll2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_seg6_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sysctl_loop1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_loop.c
 create mode 100644 tools/testing/selftests/bpf/verifier/loops1.c

-- 
2.20.0

