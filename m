Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A481CBB2C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgEHXUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:20:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13728 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727110AbgEHXUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:20:40 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 048NFia7021854
        for <netdev@vger.kernel.org>; Fri, 8 May 2020 16:20:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=7F3/DqpA3eMucNKg8/kSbwvpuOaOeiTP0+l0+/XW678=;
 b=bZ27d52FkTjZdcS0vSMY9swMi3sARo7gcZfTaUnvKfp7KoSAooMJlL6ISzdaKZw+BVkb
 9W9xjsSswCc76GX5CAc8SPBtwR1XejZtAYfOIVgU+OfK4ZwDhqCvpvB/kHmMRFOlFAbm
 X3Eg8qnuy26hntwCq7GD/2hNEdd2IIgKYa0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30vtd0endb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 16:20:38 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 16:20:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EECE02EC321F; Fri,  8 May 2020 16:20:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] Add benchmark runner and few benchmarks
Date:   Fri, 8 May 2020 16:20:29 -0700
Message-ID: <20200508232032.1974027-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=9 malwarescore=0 spamscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080195
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

Patch #1 adds generic runner implementation and atomic counter benchmarks=
 to
validate benchmark runner's behavior.

Patch #2 implements test_overhead benchmark as part of bench runner. It a=
lso
add fmod_ret BPF program type to a set of benchmarks.

Patch #3 tests faster alternatives to set_task_comm() approach, tested in
test_overhead, in search for minimal-overhead way to trigger BPF program
execution from user-space on demand.

v1->v2:
  - moved benchmarks into benchs/ subdir (John);
  - added benchmark "suite" scripts (John);
  - few small clean ups, change defaults, etc.

Andrii Nakryiko (3):
  selftests/bpf: add benchmark runner infrastructure
  selftest/bpf: fmod_ret prog and implement test_overhead as part of
    bench
  selftest/bpf: add BPF triggering benchmark

 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  17 +-
 tools/testing/selftests/bpf/bench.c           | 398 ++++++++++++++++++
 tools/testing/selftests/bpf/bench.h           |  74 ++++
 .../selftests/bpf/benchs/bench_count.c        |  91 ++++
 .../selftests/bpf/benchs/bench_rename.c       | 195 +++++++++
 .../selftests/bpf/benchs/bench_trigger.c      | 167 ++++++++
 .../selftests/bpf/benchs/run_bench_rename.sh  |   9 +
 .../selftests/bpf/benchs/run_bench_trigger.sh |   9 +
 .../selftests/bpf/prog_tests/test_overhead.c  |  14 +-
 .../selftests/bpf/progs/test_overhead.c       |   6 +
 .../selftests/bpf/progs/trigger_bench.c       |  47 +++
 12 files changed, 1026 insertions(+), 2 deletions(-)
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

--=20
2.24.1

