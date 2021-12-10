Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3E347024A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbhLJOFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:05:13 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:32909 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbhLJOFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:05:13 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J9Xcy2fJtzcbsj;
        Fri, 10 Dec 2021 22:01:22 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 10 Dec
 2021 22:01:35 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 0/4] introduce bpf_strncmp() helper
Date:   Fri, 10 Dec 2021 22:16:48 +0800
Message-ID: <20211210141652.877186-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The motivation for introducing bpf_strncmp() helper comes from
two aspects:

(1) clang doesn't always replace strncmp() automatically
In tracing program, sometimes we need to using a home-made
strncmp() to check whether or not the file name is expected.

(2) the performance of home-made strncmp is not so good
As shown in the benchmark in patch #4, the performance of
bpf_strncmp() helper is 18% or 33% better than home-made strncmp()
under x86-64 or arm64 when the compared string length is 64. When
the string length grows to 4095, the performance win will be
179% or 600% under x86-64 or arm64.

Any comments are welcome.
Regards,
Tao

Change Log:
v2:
 * rebased on bpf-next
 * drop patch "selftests/bpf: factor out common helpers for benchmarks"
   (suggested by Andrii)
 * remove unnecessary inline functions and add comments for programs which
   will be rejected by verifier in patch 4 (suggested by Andrii)
 * rename variables used in will-fail programs to clarify the purposes.

v1: https://lore.kernel.org/bpf/20211130142215.1237217-1-houtao1@huawei.com
 * change API to bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
 * add benchmark refactor and benchmark between bpf_strncmp() and strncmp()

RFC: https://lore.kernel.org/bpf/20211106132822.1396621-1-houtao1@huawei.com/

Hou Tao (4):
  bpf: add bpf_strncmp helper
  selftests/bpf: fix checkpatch error on empty function parameter
  selftests/bpf: add benchmark for bpf_strncmp() helper
  selftests/bpf: add test cases for bpf_strncmp()

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  11 ++
 kernel/bpf/helpers.c                          |  16 ++
 tools/include/uapi/linux/bpf.h                |  11 ++
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |   8 +-
 tools/testing/selftests/bpf/bench.h           |   9 +-
 .../selftests/bpf/benchs/bench_count.c        |   2 +-
 .../selftests/bpf/benchs/bench_rename.c       |  16 +-
 .../selftests/bpf/benchs/bench_ringbufs.c     |  14 +-
 .../selftests/bpf/benchs/bench_strncmp.c      | 161 +++++++++++++++++
 .../selftests/bpf/benchs/bench_trigger.c      |  24 +--
 .../selftests/bpf/benchs/run_bench_strncmp.sh |  12 ++
 .../selftests/bpf/prog_tests/test_strncmp.c   | 167 ++++++++++++++++++
 .../selftests/bpf/progs/strncmp_bench.c       |  50 ++++++
 .../selftests/bpf/progs/strncmp_test.c        |  54 ++++++
 16 files changed, 526 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_strncmp.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_strncmp.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_test.c

-- 
2.29.2

