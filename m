Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72331E7779
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 09:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgE2Hyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 03:54:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7464 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgE2Hyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 03:54:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T7oqd5009279
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=50VC0B8LeA2ntIfCcJ6QrFPLpJZw7hHFVsX7VYW2LTY=;
 b=ShjcekY3ul5HpTuvmbbcuIPU4Ns+0eic7y0PJqjNfQtKpoZx5kwTa2QY3d48DbkqhN3t
 W7PqOetckTIup6bP6+fOYJKssrsjoa72mRQ7C5G6K1Q3VQ+oIpXccGWX4Tmegdz5MHV0
 W/zqsGQNOZTFddp0JdjmY4w9PZRBbYYNPow= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ajbjp50y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:45 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 29 May 2020 00:54:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7AC6B2EC3747; Fri, 29 May 2020 00:54:36 -0700 (PDT)
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
Subject: [PATCH v4 bpf-next 0/5] BPF ring buffer
Date:   Fri, 29 May 2020 00:54:19 -0700
Message-ID: <20200529075424.3139988-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 cotscore=-2147483648 bulkscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=2 phishscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290062
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
- patch #2 adds libbpf consumer implementation for BPF ringbuf;
- patch #3 adds selftest, both for single BPF ring buf use case, as well =
as
  using it with array/hash of maps;
- patch #4 adds extensive benchmarks and provide some analysis in commit
  message, it builds upon selftests/bpf's bench runner.
- patch #5 adds most of patch #1 commit message as a doc under
  Documentation/bpf/ringbuf.rst.

Litmus tests, validating consumer/producer protocols and memory orderings=
,
were moved out as discussed in [1] and are going to be posted against -rc=
u
tree and put under Documentation/litmus-tests/bpf-rb.

  [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe=
0fAqcmJY95t_qr0w
  [1] https://lkml.org/lkml/2020/5/22/1011

v3->v4:
- fix ringbuf freeing (vunmap, __free_page); verified with a trivial loop
  creating and closing ringbuf map endlessly (Daniel);

v2->v3:
- dropped unnecessary smp_wmb() (Paul);
- verifier reference type enhancement patch was dropped (Alexei);
- better verifier message for various memory access checks (Alexei);
- clarified a bit roundup_len() bit shifting (Alexei);
- converted doc to .rst (Alexei);
- fixed warning on 32-bit arches regarding tautological ring area size ch=
eck.

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

Andrii Nakryiko (5):
  bpf: implement BPF ring buffer and verifier support for it
  libbpf: add BPF ring buffer support
  selftests/bpf: add BPF ringbuf selftests
  bpf: add BPF ringbuf and perf buffer benchmarks
  docs/bpf: add BPF ring buffer design notes

 Documentation/bpf/ringbuf.rst                 | 209 +++++++
 include/linux/bpf.h                           |  13 +
 include/linux/bpf_types.h                     |   1 +
 include/linux/bpf_verifier.h                  |   4 +
 include/uapi/linux/bpf.h                      |  84 ++-
 kernel/bpf/Makefile                           |   2 +-
 kernel/bpf/helpers.c                          |  10 +
 kernel/bpf/ringbuf.c                          | 501 ++++++++++++++++
 kernel/bpf/syscall.c                          |  12 +
 kernel/bpf/verifier.c                         | 195 ++++--
 kernel/trace/bpf_trace.c                      |  10 +
 tools/include/uapi/linux/bpf.h                |  84 ++-
 tools/lib/bpf/Build                           |   2 +-
 tools/lib/bpf/libbpf.h                        |  21 +
 tools/lib/bpf/libbpf.map                      |   5 +
 tools/lib/bpf/libbpf_probes.c                 |   5 +
 tools/lib/bpf/ringbuf.c                       | 285 +++++++++
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
 tools/testing/selftests/bpf/verifier/and.c    |   4 +-
 .../selftests/bpf/verifier/array_access.c     |   4 +-
 tools/testing/selftests/bpf/verifier/bounds.c |   6 +-
 tools/testing/selftests/bpf/verifier/calls.c  |   2 +-
 .../bpf/verifier/direct_value_access.c        |   4 +-
 .../bpf/verifier/helper_access_var_len.c      |   2 +-
 .../bpf/verifier/helper_value_access.c        |   6 +-
 .../selftests/bpf/verifier/value_ptr_arith.c  |   8 +-
 35 files changed, 2630 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/bpf/ringbuf.rst
 create mode 100644 kernel/bpf/ringbuf.c
 create mode 100644 tools/lib/bpf/ringbuf.c
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

