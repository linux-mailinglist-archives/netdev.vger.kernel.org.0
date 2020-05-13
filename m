Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538711D1F0E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390464AbgEMT0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:26:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17542 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390263AbgEMT0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:26:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DJNiLx025201
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=wlqZfXBe2UuLn3XAQesydiy+j4R9Kl9ykccFbIRuZRs=;
 b=fud/MrEzdyWLcd09smFVLNu7cLsfHJXiYOZDROMFE0KBtGCj1OFLzZlu3w6JxCND0+o2
 1SNyP5IESXNnbfRdWEPrBwhrudvSV3Cla9B/ZAKBFJlET4Hegplv1ceyqZmccJFHp0ga
 AsHB0Wmr37e+a1W6cWT+SDHa0cbRLuVDhG4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100wfxv86-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:01 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 12:25:59 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8D49F2EC3007; Wed, 13 May 2020 12:25:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/6] BPF ring buffer
Date:   Wed, 13 May 2020 12:25:26 -0700
Message-ID: <20200513192532.4058934-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0
 cotscore=-2147483648 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a new BPF ring buffer, as presented at BPF virtual conference (=
[0]).
It presents an alternative to perf buffer, following its semantics closel=
y,
but allowing sharing same instance of ring buffer across multiple CPUs
efficiently.

Most patches have extensive commentary explaining various aspects, so I'l=
l
keep cover letter short. Overall structure of the patch set:
- patch #1 adds BPF ring buffer implementation to kernel and necessary
  verifier support;
- patch #2 adds litmus tests validating all the memory orderings and lock=
ing
  is correct;
- patch #3 is an optional patch that generalizes verifier's reference tra=
cking
  machinery to capture type of reference;
- patch #4 adds libbpf consumer implementation for BPF ringbuf;
- path #5 adds selftest, both for single BPF ring buf use case, as well a=
s
  using it with array/hash of maps;
- patch #6 adds extensive benchmarks and provide some analysis in commit
  message, it build upon selftests/bpf's bench runner.

  [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe=
0fAqcmJY95t_qr0w

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>

Andrii Nakryiko (6):
  bpf: implement BPF ring buffer and verifier support for it
  tools/memory-model: add BPF ringbuf MPSC litmus tests
  bpf: track reference type in verifier
  libbpf: add BPF ring buffer support
  selftests/bpf: add BPF ringbuf selftests
  bpf: add BPF ringbuf and perf buffer benchmarks

 include/linux/bpf.h                           |  12 +
 include/linux/bpf_types.h                     |   1 +
 include/linux/bpf_verifier.h                  |  12 +
 include/uapi/linux/bpf.h                      |  33 +-
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/helpers.c                          |   8 +
 kernel/bpf/ringbuf.c                          | 409 ++++++++++++
 kernel/bpf/syscall.c                          |  12 +
 kernel/bpf/verifier.c                         | 252 ++++++--
 kernel/trace/bpf_trace.c                      |   8 +
 tools/include/uapi/linux/bpf.h                |  33 +-
 tools/lib/bpf/Build                           |   2 +-
 tools/lib/bpf/libbpf.h                        |  20 +
 tools/lib/bpf/libbpf.map                      |   4 +
 tools/lib/bpf/libbpf_probes.c                 |   5 +
 tools/lib/bpf/ringbuf.c                       | 264 ++++++++
 .../litmus-tests/mpsc-rb+1p1c+bounded.litmus  |  92 +++
 .../litmus-tests/mpsc-rb+1p1c+unbound.litmus  |  83 +++
 .../litmus-tests/mpsc-rb+2p1c+bounded.litmus  | 152 +++++
 .../litmus-tests/mpsc-rb+2p1c+unbound.litmus  | 137 ++++
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bench.c           |  18 +
 .../selftests/bpf/benchs/bench_ringbufs.c     | 593 ++++++++++++++++++
 .../bpf/benchs/run_bench_ringbufs.sh          |  61 ++
 .../selftests/bpf/prog_tests/ringbuf.c        | 101 +++
 .../selftests/bpf/prog_tests/ringbuf_multi.c  | 102 +++
 .../selftests/bpf/progs/perfbuf_bench.c       |  33 +
 .../selftests/bpf/progs/ringbuf_bench.c       |  45 ++
 .../selftests/bpf/progs/test_ringbuf.c        |  63 ++
 .../selftests/bpf/progs/test_ringbuf_multi.c  |  77 +++
 30 files changed, 2584 insertions(+), 55 deletions(-)
 create mode 100644 kernel/bpf/ringbuf.c
 create mode 100644 tools/lib/bpf/ringbuf.c
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+1p1c+bounded.=
litmus
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+1p1c+unbound.=
litmus
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+2p1c+bounded.=
litmus
 create mode 100644 tools/memory-model/litmus-tests/mpsc-rb+2p1c+unbound.=
litmus
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_ringbufs.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_ringbufs=
.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ringbuf_multi.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/perfbuf_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/ringbuf_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf_multi.=
c

--=20
2.24.1

