Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA6A44639
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfFMQt5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 12:49:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbfFMEUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 00:20:12 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5D4HIHi010663
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:20:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2t3562209t-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 21:20:10 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 12 Jun 2019 21:20:07 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 53E23760CD6; Wed, 12 Jun 2019 21:20:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <jakub.kicinski@netronome.com>,
        <ecree@solarflare.com>, <john.fastabend@gmail.com>,
        <andriin@fb.com>, <jannh@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/9] bpf: bounded loops and other features
Date:   Wed, 12 Jun 2019 21:19:54 -0700
Message-ID: <20190613042003.3791852-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=815 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

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
 kernel/bpf/verifier.c                         | 688 ++++++++++++++++--
 .../bpf/prog_tests/bpf_verif_scale.c          |  67 +-
 tools/testing/selftests/bpf/progs/loop1.c     |  28 +
 tools/testing/selftests/bpf/progs/loop2.c     |  28 +
 tools/testing/selftests/bpf/progs/loop3.c     |  22 +
 tools/testing/selftests/bpf/progs/pyperf.h    |   6 +-
 tools/testing/selftests/bpf/progs/pyperf600.c |   9 +
 .../selftests/bpf/progs/pyperf600_nounroll.c  |   8 +
 .../testing/selftests/bpf/progs/strobemeta.c  |  10 +
 .../testing/selftests/bpf/progs/strobemeta.h  | 528 ++++++++++++++
 .../bpf/progs/strobemeta_nounroll1.c          |   9 +
 .../bpf/progs/strobemeta_nounroll2.c          |   9 +
 .../selftests/bpf/progs/test_seg6_loop.c      | 261 +++++++
 .../selftests/bpf/progs/test_sysctl_loop1.c   |  68 ++
 .../selftests/bpf/progs/test_sysctl_loop2.c   |  69 ++
 .../selftests/bpf/progs/test_xdp_loop.c       | 231 ++++++
 tools/testing/selftests/bpf/test_verifier.c   |  11 +-
 tools/testing/selftests/bpf/verifier/calls.c  |  22 +-
 tools/testing/selftests/bpf/verifier/cfg.c    |  11 +-
 .../bpf/verifier/direct_packet_access.c       |   3 +-
 .../bpf/verifier/helper_access_var_len.c      |  28 +-
 tools/testing/selftests/bpf/verifier/loops1.c | 161 ++++
 23 files changed, 2258 insertions(+), 88 deletions(-)
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

