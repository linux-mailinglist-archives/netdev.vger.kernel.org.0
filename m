Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F381CFE9C
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 21:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgELTrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 15:47:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbgELTrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 15:47:01 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CJjMdR021161
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:47:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=UgE04U6IhngmVBWnVNaYINbDp7OgNY58I5uqal3oBxU=;
 b=aPmwj2DDO646UItxruF+avvPSd5HtXCzNEcj9qVDRrXbJiEuWWLcahLR+7lBcFWxgcGN
 C7JXf3U7bPH6IvVLKmzmKeq24eYJlaDM7QT0FdGY/I8U/zgv4tGqfWKFXaThOJWd2483
 m4a7QeRGarHWihtgXES517WNo94VXZnHNY8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100xb0fcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 12:47:00 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 12:47:00 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E1BA82EC317E; Tue, 12 May 2020 12:46:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/4] Add benchmark runner and few benchmarks
Date:   Tue, 12 May 2020 12:24:41 -0700
Message-ID: <20200512192445.2351848-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_07:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=9 lowpriorityscore=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add generic benchmark runner framework which simplifies writing various
performance benchmarks in a consistent fashion.  This framework will be u=
sed
in follow up patches to test performance of perf buffer and ring buffer a=
s
well.

Patch #1 extracts parse_num_list to be re-used between test_progs and ben=
ch.

Patch #2 adds generic runner implementation and atomic counter benchmarks=
 to
validate benchmark runner's behavior.

Patch #3 implements test_overhead benchmark as part of bench runner. It a=
lso
add fmod_ret BPF program type to a set of benchmarks.

Patch #4 tests faster alternatives to set_task_comm() approach, tested in
test_overhead, in search for minimal-overhead way to trigger BPF program
execution from user-space on demand.

v2->v3:
  - added --prod-affinity and --cons-affinity (Yonghong);
  - removed ringbuf-related options leftovers (Yonghong);
  - added more benchmarking results for test_overhead performance discrep=
ancies;
v1->v2:
  - moved benchmarks into benchs/ subdir (John);
  - added benchmark "suite" scripts (John);
  - few small clean ups, change defaults, etc.

Andrii Nakryiko (4):
  selftests/bpf: extract parse_num_list into generic testing_helpers.c
  selftests/bpf: add benchmark runner infrastructure
  selftest/bpf: fmod_ret prog and implement test_overhead as part of
    bench
  selftest/bpf: add BPF triggering benchmark

 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  20 +-
 tools/testing/selftests/bpf/bench.c           | 449 ++++++++++++++++++
 tools/testing/selftests/bpf/bench.h           |  81 ++++
 .../selftests/bpf/benchs/bench_count.c        |  91 ++++
 .../selftests/bpf/benchs/bench_rename.c       | 195 ++++++++
 .../selftests/bpf/benchs/bench_trigger.c      | 167 +++++++
 .../selftests/bpf/benchs/run_bench_rename.sh  |   9 +
 .../selftests/bpf/benchs/run_bench_trigger.sh |   9 +
 .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
 .../selftests/bpf/progs/test_overhead.c       |   6 +
 .../selftests/bpf/progs/trigger_bench.c       |  47 ++
 tools/testing/selftests/bpf/test_progs.c      |  67 +--
 tools/testing/selftests/bpf/test_progs.h      |   1 +
 tools/testing/selftests/bpf/testing_helpers.c |  66 +++
 tools/testing/selftests/bpf/testing_helpers.h |   5 +
 16 files changed, 1162 insertions(+), 66 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bench.c
 create mode 100644 tools/testing/selftests/bpf/bench.h
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_count.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_rename.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_trigger.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_rename.s=
h
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_trigger.=
sh
 create mode 100644 tools/testing/selftests/bpf/progs/trigger_bench.c
 create mode 100644 tools/testing/selftests/bpf/testing_helpers.c
 create mode 100644 tools/testing/selftests/bpf/testing_helpers.h

--=20
2.24.1

