Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79A31D6CA5
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgEQT5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:57:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3428 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbgEQT5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:57:47 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04HJrW2Z031361
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:57:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=9DXltpBw7QkyZX7KCYQu4UPTEdtWUSiiI+lHL2stpZk=;
 b=qfML178YYgLac8BMPPIVzIjZsA02uFesyChw0Mj3Lfr6iYgkfRYt1U+W/naRf197YJ2k
 5K4R0RHBtASFjNnIrD2RcPL3P87RLWm6hUJ/fs3nzQZFPMDCVf/q+pNvw+440oHIe8zz
 +xW0CLGXG9eNwpQvPPr8JRLsiVfbfIqK3yw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3130eu4e77-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:57:46 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 17 May 2020 12:57:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1A32B2EC32DC; Sun, 17 May 2020 12:57:35 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 0/7] BPF ring buffer
Date:   Sun, 17 May 2020 12:57:20 -0700
Message-ID: <20200517195727.279322-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-17_07:2020-05-15,2020-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 cotscore=-2147483648 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005170182
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
- patch #7 adds most of patch #1 commit message as a doc under
  Documentation/bpf/ringbuf.txt.

  [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe=
0fAqcmJY95t_qr0w

v1->v2:
- commit()/discard()/output() accept flags (NO_WAKEUP/FORCE_WAKEUP) (Stan=
islav);
- bpf_ringbuf_query() added, returning available data size, ringbuf size,
  consumer/producer positions, needed to implement smarter notification p=
olicy
  (Stanislav);
- added ringbuf UAPI constants to include/uapi/linux/bpf.h (Jonathan);
- fixed sample size check, added proper ringbuf size check (Jonathan, Ale=
xei);
- wake_up_all() is done through irq_work (Alexei);
- consistent use of smp_load_acquire/smp_store_release, no
  READ_ONCE/WRITE_ONCE (Alexei);
- added Documentation/bpf/ringbuf.txt (Stanislav);
- updated litmus test with smp_load_acquire/smp_store_release changes;
- added ring_buffer__consume() API to libbpf for busy-polling;
- ring_buffer__poll() on success returns number of records consumed;
- fixed EPOLL notifications, don't assume available data, done similarly =
to
  perfbuf's implementation;
- both ringbuf and perfbuf now have --rb-sampled mode, instead of
  pb-raw/pb-custom mode, updated benchmark results;
- extended ringbuf selftests to validate epoll logic/manual notification
  logic, as well as bpf_ringbuf_query().

Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>

Andrii Nakryiko (7):
  bpf: implement BPF ring buffer and verifier support for it
  tools/memory-model: add BPF ringbuf MPSC litmus tests
  bpf: track reference type in verifier
  libbpf: add BPF ring buffer support
  selftests/bpf: add BPF ringbuf selftests
  bpf: add BPF ringbuf and perf buffer benchmarks
  docs/bpf: add BPF ring buffer design notes

 Documentation/bpf/ringbuf.txt                 | 191 ++++++
 include/linux/bpf.h                           |  13 +
 include/linux/bpf_types.h                     |   1 +
 include/linux/bpf_verifier.h                  |  12 +
 include/uapi/linux/bpf.h                      |  84 ++-
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/helpers.c                          |  10 +
 kernel/bpf/ringbuf.c                          | 487 +++++++++++++++
 kernel/bpf/syscall.c                          |  12 +
 kernel/bpf/verifier.c                         | 253 ++++++--
 kernel/trace/bpf_trace.c                      |  10 +
 tools/include/uapi/linux/bpf.h                |  90 ++-
 tools/lib/bpf/Build                           |   2 +-
 tools/lib/bpf/libbpf.h                        |  21 +
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/lib/bpf/libbpf_probes.c                 |   5 +
 tools/lib/bpf/ringbuf.c                       | 285 +++++++++
 .../litmus-tests/mpsc-rb+1p1c+bounded.litmus  |  92 +++
 .../litmus-tests/mpsc-rb+1p1c+unbound.litmus  |  83 +++
 .../litmus-tests/mpsc-rb+2p1c+bounded.litmus  | 152 +++++
 .../litmus-tests/mpsc-rb+2p1c+unbound.litmus  | 137 +++++
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bench.c           |  16 +
 .../selftests/bpf/benchs/bench_ringbufs.c     | 566 ++++++++++++++++++
 .../bpf/benchs/run_bench_ringbufs.sh          |  75 +++
 .../selftests/bpf/prog_tests/ringbuf.c        | 211 +++++++
 .../selftests/bpf/prog_tests/ringbuf_multi.c  | 102 ++++
 .../selftests/bpf/progs/perfbuf_bench.c       |  33 +
 .../selftests/bpf/progs/ringbuf_bench.c       |  60 ++
 .../selftests/bpf/progs/test_ringbuf.c        |  78 +++
 .../selftests/bpf/progs/test_ringbuf_multi.c  |  77 +++
 31 files changed, 3112 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/bpf/ringbuf.txt
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

