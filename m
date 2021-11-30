Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFEA463619
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhK3OKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:10:24 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:27320 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbhK3OKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:10:20 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J3PCw13ytzbjBL;
        Tue, 30 Nov 2021 22:06:52 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 22:06:58 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 0/5] introduce bpf_strncmp() helper
Date:   Tue, 30 Nov 2021 22:22:10 +0800
Message-ID: <20211130142215.1237217-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

The prototype of bpf_strncmp() has changed from

  bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)

to

  bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)

The main reason is readability and there is nearly no performance
difference between these two APIs (refer to the data attached below
[1]).

Any comments are welcome.
Regards,
Tao

Change Log:
v1:
 * change API to bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
 * add benchmark refactor and benchmark between bpf_strncmp() and strncmp()

RFC: https://lore.kernel.org/bpf/20211106132822.1396621-1-houtao1@huawei.com/

[1] Performance difference between two APIs under x86-64:

helper_rfc-X: use bpf_strncmp in RFC to compare X-sized string
helper-Y: use bpf_strncmp in v1 to compare Y-sized string

helper_rfc-1         3.482 ± 0.002M/s (drops 0.000 ± 0.000M/s)
helper-1             3.485 ± 0.001M/s (drops 0.000 ± 0.000M/s)

helper_rfc-8         3.428 ± 0.001M/s (drops 0.000 ± 0.000M/s)
helper-8             3.434 ± 0.001M/s (drops 0.000 ± 0.000M/s)

helper_rfc-32        3.253 ± 0.002M/s (drops 0.000 ± 0.000M/s)
helper-32            3.234 ± 0.001M/s (drops 0.000 ± 0.000M/s)

helper_rfc-64        3.039 ± 0.000M/s (drops 0.000 ± 0.000M/s)
helper-64            3.042 ± 0.001M/s (drops 0.000 ± 0.000M/s)

helper_rfc-128       2.640 ± 0.000M/s (drops 0.000 ± 0.000M/s)
helper-128           2.633 ± 0.000M/s (drops 0.000 ± 0.000M/s)

helper_rfc-512       1.576 ± 0.000M/s (drops 0.000 ± 0.000M/s)
helper-512           1.574 ± 0.000M/s (drops 0.000 ± 0.000M/s)

helper_rfc-2048      0.602 ± 0.000M/s (drops 0.000 ± 0.000M/s)
helper-2048          0.602 ± 0.000M/s (drops 0.000 ± 0.000M/s)

helper_rfc-4095      0.328 ± 0.000M/s (drops 0.000 ± 0.000M/s)
helper-4095          0.328 ± 0.000M/s (drops 0.000 ± 0.000M/s)

Hou Tao (5):
  bpf: add bpf_strncmp helper
  selftests/bpf: fix checkpatch error on empty function parameter
  selftests/bpf: factor out common helpers for benchmarks
  selftests/bpf: add benchmark for bpf_strncmp() helper
  selftests/bpf: add test cases for bpf_strncmp()

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  11 ++
 kernel/bpf/helpers.c                          |  16 ++
 tools/include/uapi/linux/bpf.h                |  11 ++
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/bench.c           |  21 ++-
 tools/testing/selftests/bpf/bench.h           |  34 +++-
 .../bpf/benchs/bench_bloom_filter_map.c       |  44 ++---
 .../selftests/bpf/benchs/bench_count.c        |  16 +-
 .../selftests/bpf/benchs/bench_rename.c       |  43 ++---
 .../selftests/bpf/benchs/bench_ringbufs.c     |  21 +--
 .../selftests/bpf/benchs/bench_strncmp.c      | 150 ++++++++++++++++
 .../selftests/bpf/benchs/bench_trigger.c      |  79 ++++----
 .../selftests/bpf/benchs/run_bench_strncmp.sh |  12 ++
 .../selftests/bpf/prog_tests/test_strncmp.c   | 170 ++++++++++++++++++
 .../selftests/bpf/progs/strncmp_bench.c       |  50 ++++++
 .../selftests/bpf/progs/strncmp_test.c        |  59 ++++++
 17 files changed, 604 insertions(+), 138 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_strncmp.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_strncmp.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_test.c

-- 
2.29.2

