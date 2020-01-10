Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCC9136797
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731628AbgAJGli convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 10 Jan 2020 01:41:38 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731616AbgAJGlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:41:37 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00A6bNZo018955
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 22:41:37 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2xdrj8r36e-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 22:41:37 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 9 Jan 2020 22:41:35 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 43A3A760DBA; Thu,  9 Jan 2020 22:41:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/6] bpf: Introduce global functions
Date:   Thu, 9 Jan 2020 22:41:18 -0800
Message-ID: <20200110064124.1760511-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1034 mlxscore=0 mlxlogscore=473 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2->v3:
- cleaned up a check spotted by Song.
- rebased and dropped patch 2 that was trying to improve BTF based on ELF.
- added one more unit test for scalar return value from global func.

v1->v2:
- addressed review comments from Song, Andrii, Yonghong
- fixed memory leak in error path
- added modified ctx check
- added more tests in patch 7

v1:
Introduce static vs global functions and function by function verification.
This is another step toward dynamic re-linking (or replacement) of global
functions. See patch 2 for details.

Alexei Starovoitov (6):
  libbpf: Sanitize global functions
  bpf: Introduce function-by-function verification
  selftests/bpf: Add fexit-to-skb test for global funcs
  selftests/bpf: Add a test for a large global function
  selftests/bpf: Modify a test to check global functions
  selftests/bpf: Add unit tests for global functions

 include/linux/bpf.h                           |   7 +-
 include/linux/bpf_verifier.h                  |  10 +-
 include/uapi/linux/btf.h                      |   6 +
 kernel/bpf/btf.c                              | 175 +++++++++---
 kernel/bpf/verifier.c                         | 252 ++++++++++++++----
 tools/include/uapi/linux/btf.h                |   6 +
 tools/lib/bpf/libbpf.c                        |  35 ++-
 .../bpf/prog_tests/bpf_verif_scale.c          |   2 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   1 +
 .../bpf/prog_tests/test_global_funcs.c        |  82 ++++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  15 ++
 tools/testing/selftests/bpf/progs/pyperf.h    |   9 +-
 .../selftests/bpf/progs/pyperf_global.c       |   5 +
 .../selftests/bpf/progs/test_global_func1.c   |  45 ++++
 .../selftests/bpf/progs/test_global_func2.c   |   4 +
 .../selftests/bpf/progs/test_global_func3.c   |  65 +++++
 .../selftests/bpf/progs/test_global_func4.c   |   4 +
 .../selftests/bpf/progs/test_global_func5.c   |  31 +++
 .../selftests/bpf/progs/test_global_func6.c   |  31 +++
 .../selftests/bpf/progs/test_global_func7.c   |  18 ++
 .../selftests/bpf/progs/test_pkt_access.c     |  28 ++
 .../selftests/bpf/progs/test_xdp_noinline.c   |   4 +-
 22 files changed, 746 insertions(+), 89 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf_global.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func3.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func4.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func5.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func6.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func7.c

-- 
2.23.0

