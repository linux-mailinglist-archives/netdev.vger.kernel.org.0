Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F981E7783
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 09:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgE2HzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 03:55:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13610 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbgE2Hy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 03:54:58 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T7nZcS028844
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=lZqsurspAeVfg36M35XLTZa0ieRYdUbCi/y/irs6JyY=;
 b=Jg2+lsBWbbmMLQy+Nw2u6QIMc36jpjjfRf5o/IDgeihwXiTwrWktO/raFfB09pzhlhai
 8NHh8FVUDnRxxgVt/e23RBHia2xPFGedUf+ffDdgFzIXHgh7oEfzz4/3BH/Mp4EXwoiR
 8Oi+H7CuPxON7EDH75VrzaBE6Eg3YusRWvc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 319bqd2pcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 00:54:52 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 29 May 2020 00:54:51 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 87CCE2EC3747; Fri, 29 May 2020 00:54:45 -0700 (PDT)
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
Subject: [PATCH v4 bpf-next 4/5] bpf: add BPF ringbuf and perf buffer benchmarks
Date:   Fri, 29 May 2020 00:54:23 -0700
Message-ID: <20200529075424.3139988-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200529075424.3139988-1-andriin@fb.com>
References: <20200529075424.3139988-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=9 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 adultscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005290062
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend bench framework with ability to have benchmark-provided child argu=
ment
parser for custom benchmark-specific parameters. This makes bench generic=
 code
modular and independent from any specific benchmark.

Also implement a set of benchmarks for new BPF ring buffer and existing p=
erf
buffer. 4 benchmarks were implemented: 2 variations for each of BPF ringb=
uf
and perfbuf:,
  - rb-libbpf utilizes stock libbpf ring_buffer manager for reading data;
  - rb-custom implements custom ring buffer setup and reading code, to
    eliminate overheads inherent in generic libbpf code due to callback
    functions and the need to update consumer position after each consume=
d
    record, instead of batching updates (due to pessimistic assumption th=
at
    user callback might take long time and thus could unnecessarily hold =
ring
    buffer space for too long);
  - pb-libbpf uses stock libbpf perf_buffer code with all the default
    settings, though uses higher-performance raw event callback to minimi=
ze
    unnecessary overhead;
  - pb-custom implements its own custom consumer code to minimize any pos=
sible
    overhead of generic libbpf implementation and indirect function calls=
.

All of the test support default, no data notification skipped, mode, as w=
ell
as sampled mode (with --rb-sampled flag), which allows to trigger epoll
notification less frequently and reduce overhead. As will be shown, this =
mode
is especially critical for perf buffer, which suffers from high overhead =
of
wakeups in kernel.

Otherwise, all benchamrks implement similar way to generate a batch of re=
cords
by using fentry/sys_getpgid BPF program, which pushes a bunch of records =
in
a tight loop and records number of successful and dropped samples. Each r=
ecord
is a small 8-byte integer, to minimize the effect of memory copying with
bpf_perf_event_output() and bpf_ringbuf_output().

Benchmarks that have only one producer implement optional back-to-back mo=
de,
in which record production and consumption is alternating on the same CPU=
.
This is the highest-throughput happy case, showing ultimate performance
achievable with either BPF ringbuf or perfbuf.

All the below scenarios are implemented in a script in
benchs/run_bench_ringbufs.sh. Tests were performed on 28-core/56-thread
Intel Xeon CPU E5-2680 v4 @ 2.40GHz CPU.

Single-producer, parallel producer
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
rb-libbpf            12.054 =C2=B1 0.320M/s (drops 0.000 =C2=B1 0.000M/s)
rb-custom            8.158 =C2=B1 0.118M/s (drops 0.001 =C2=B1 0.003M/s)
pb-libbpf            0.931 =C2=B1 0.007M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            0.965 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)

Single-producer, parallel producer, sampled notification
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
rb-libbpf            11.563 =C2=B1 0.067M/s (drops 0.000 =C2=B1 0.000M/s)
rb-custom            15.895 =C2=B1 0.076M/s (drops 0.000 =C2=B1 0.000M/s)
pb-libbpf            9.889 =C2=B1 0.032M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            9.866 =C2=B1 0.028M/s (drops 0.000 =C2=B1 0.000M/s)

Single producer on one CPU, consumer on another one, both running at full
speed. Curiously, rb-libbpf has higher throughput than objectively faster=
 (due
to more lightweight consumer code path) rb-custom. It appears that faster
consumer causes kernel to send notifications more frequently, because con=
sumer
appears to be caught up more frequently. Performance of perfbuf suffers f=
rom
default "no sampling" policy and huge overhead that causes.

In sampled mode, rb-custom is winning very significantly eliminating too
frequent in-kernel wakeups, the gain appears to be more than 2x.

Perf buffer achieves even more impressive wins, compared to stock perfbuf
settings, with 10x improvements in throughput with 1:500 sampling rate. T=
he
trade-off is that with sampling, application might not get next X events =
until
X+1st arrives, which is not always acceptable. With steady influx of even=
ts,
though, this shouldn't be a problem.

Overall, single-producer performance of ring buffers seems to be better n=
o
matter the sampled/non-sampled modes, but it especially beats ring buffer
without sampling due to its adaptive notification approach.

Single-producer, back-to-back mode
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
rb-libbpf            15.507 =C2=B1 0.247M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf-sampled    14.692 =C2=B1 0.195M/s (drops 0.000 =C2=B1 0.000M/s)
rb-custom            21.449 =C2=B1 0.157M/s (drops 0.000 =C2=B1 0.000M/s)
rb-custom-sampled    20.024 =C2=B1 0.386M/s (drops 0.000 =C2=B1 0.000M/s)
pb-libbpf            1.601 =C2=B1 0.015M/s (drops 0.000 =C2=B1 0.000M/s)
pb-libbpf-sampled    8.545 =C2=B1 0.064M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            1.607 =C2=B1 0.022M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom-sampled    8.988 =C2=B1 0.144M/s (drops 0.000 =C2=B1 0.000M/s)

Here we test a back-to-back mode, which is arguably best-case scenario bo=
th
for BPF ringbuf and perfbuf, because there is no contention and for ringb=
uf
also no excessive notification, because consumer appears to be behind aft=
er
the first record. For ringbuf, custom consumer code clearly wins with 21.=
5 vs
16 million records per second exchanged between producer and consumer. Sa=
mpled
mode actually hurts a bit due to slightly slower producer logic (it needs=
 to
fetch amount of data available to decide whether to skip or force notific=
ation).

Perfbuf with wakeup sampling gets 5.5x throughput increase, compared to
no-sampling version. There also doesn't seem to be noticeable overhead fr=
om
generic libbpf handling code.

Perfbuf back-to-back, effect of sample rate
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
pb-sampled-1         1.035 =C2=B1 0.012M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-5         3.476 =C2=B1 0.087M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-10        5.094 =C2=B1 0.136M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-25        7.118 =C2=B1 0.153M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-50        8.169 =C2=B1 0.156M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-100       8.887 =C2=B1 0.136M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-250       9.180 =C2=B1 0.209M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-500       9.353 =C2=B1 0.281M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-1000      9.411 =C2=B1 0.217M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-2000      9.464 =C2=B1 0.167M/s (drops 0.000 =C2=B1 0.000M/s)
pb-sampled-3000      9.575 =C2=B1 0.273M/s (drops 0.000 =C2=B1 0.000M/s)

This benchmark shows the effect of event sampling for perfbuf. Back-to-ba=
ck
mode for highest throughput. Just doing every 5th record notification giv=
es
3.5x speed up. 250-500 appears to be the point of diminishing return, wit=
h
almost 9x speed up. Most benchmarks use 500 as the default sampling for p=
b-raw
and pb-custom.

Ringbuf back-to-back, effect of sample rate
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
rb-sampled-1         1.106 =C2=B1 0.010M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-5         4.746 =C2=B1 0.149M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-10        7.706 =C2=B1 0.164M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-25        12.893 =C2=B1 0.273M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-50        15.961 =C2=B1 0.361M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-100       18.203 =C2=B1 0.445M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-250       19.962 =C2=B1 0.786M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-500       20.881 =C2=B1 0.551M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-1000      21.317 =C2=B1 0.532M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-2000      21.331 =C2=B1 0.535M/s (drops 0.000 =C2=B1 0.000M/s)
rb-sampled-3000      21.688 =C2=B1 0.392M/s (drops 0.000 =C2=B1 0.000M/s)

Similar benchmark for ring buffer also shows a great advantage (in terms =
of
throughput) of skipping notifications. Skipping every 5th one gives 4x bo=
ost.
Also similar to perfbuf case, 250-500 seems to be the point of diminishin=
g
returns, giving roughly 20x better results.

Keep in mind, for this test, notifications are controlled manually with
BPF_RB_NO_WAKEUP and BPF_RB_FORCE_WAKEUP. As can be seen from previous
benchmarks, adaptive notifications based on consumer's positions provides=
 same
(or even slightly better due to simpler load generator on BPF side) benef=
its in
favorable back-to-back scenario. Over zealous and fast consumer, which is
almost always caught up, will make thoughput numbers smaller. That's the =
case
when manual notification control might prove to be extremely beneficial.

Ringbuf back-to-back, reserve+commit vs output
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
reserve              22.819 =C2=B1 0.503M/s (drops 0.000 =C2=B1 0.000M/s)
output               18.906 =C2=B1 0.433M/s (drops 0.000 =C2=B1 0.000M/s)

Ringbuf sampled, reserve+commit vs output
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
reserve-sampled      15.350 =C2=B1 0.132M/s (drops 0.000 =C2=B1 0.000M/s)
output-sampled       14.195 =C2=B1 0.144M/s (drops 0.000 =C2=B1 0.000M/s)

BPF ringbuf supports two sets of APIs with various usability and performa=
nce
tradeoffs: bpf_ringbuf_reserve()+bpf_ringbuf_commit() vs bpf_ringbuf_outp=
ut().
This benchmark clearly shows superiority of reserve+commit approach, desp=
ite
using a small 8-byte record size.

Single-producer, consumer/producer competing on the same CPU, low batch c=
ount
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
rb-libbpf            3.045 =C2=B1 0.020M/s (drops 3.536 =C2=B1 0.148M/s)
rb-custom            3.055 =C2=B1 0.022M/s (drops 3.893 =C2=B1 0.066M/s)
pb-libbpf            1.393 =C2=B1 0.024M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            1.407 =C2=B1 0.016M/s (drops 0.000 =C2=B1 0.000M/s)

This benchmark shows one of the worst-case scenarios, in which producer a=
nd
consumer do not coordinate *and* fight for the same CPU. No batch count a=
nd
sampling settings were able to eliminate drops for ringbuffer, producer i=
s
just too fast for consumer to keep up. But ringbuf and perfbuf still able=
 to
pass through quite a lot of messages, which is more than enough for a lot=
 of
applications.

Ringbuf, multi-producer contention
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
rb-libbpf nr_prod 1  10.916 =C2=B1 0.399M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 2  4.931 =C2=B1 0.030M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 3  4.880 =C2=B1 0.006M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 4  3.926 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 8  4.011 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 12 3.967 =C2=B1 0.016M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 16 2.604 =C2=B1 0.030M/s (drops 0.001 =C2=B1 0.002M/s)
rb-libbpf nr_prod 20 2.233 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 24 2.085 =C2=B1 0.015M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 28 2.055 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 32 1.962 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 36 2.089 =C2=B1 0.005M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 40 2.118 =C2=B1 0.006M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 44 2.105 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 48 2.120 =C2=B1 0.058M/s (drops 0.000 =C2=B1 0.001M/s)
rb-libbpf nr_prod 52 2.074 =C2=B1 0.024M/s (drops 0.007 =C2=B1 0.014M/s)

Ringbuf uses a very short-duration spinlock during reservation phase, to =
check
few invariants, increment producer count and set record header. This is t=
he
biggest point of contention for ringbuf implementation. This benchmark
evaluates the effect of multiple competing writers on overall throughput =
of
a single shared ringbuffer.

Overall throughput drops almost 2x when going from single to two
highly-contended producers, gradually dropping with additional competing
producers.  Performance drop stabilizes at around 20 producers and hovers
around 2mln even with 50+ fighting producers, which is a 5x drop compared=
 to
non-contended case. Good kernel implementation in kernel helps maintain d=
ecent
performance here.

Note, that in the intended real-world scenarios, it's not expected to get=
 even
close to such a high levels of contention. But if contention will become
a problem, there is always an option of sharding few ring buffers across =
a set
of CPUs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bench.c           |  16 +
 .../selftests/bpf/benchs/bench_ringbufs.c     | 566 ++++++++++++++++++
 .../bpf/benchs/run_bench_ringbufs.sh          |  75 +++
 .../selftests/bpf/progs/perfbuf_bench.c       |  33 +
 .../selftests/bpf/progs/ringbuf_bench.c       |  60 ++
 6 files changed, 754 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_ringbufs.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_ringbufs=
.sh
 create mode 100644 tools/testing/selftests/bpf/progs/perfbuf_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/ringbuf_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index e716e931d0c9..3ce548eff8a8 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -413,12 +413,15 @@ $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
 	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
 $(OUTPUT)/bench_rename.o: $(OUTPUT)/test_overhead.skel.h
 $(OUTPUT)/bench_trigger.o: $(OUTPUT)/trigger_bench.skel.h
+$(OUTPUT)/bench_ringbufs.o: $(OUTPUT)/ringbuf_bench.skel.h \
+			    $(OUTPUT)/perfbuf_bench.skel.h
 $(OUTPUT)/bench.o: bench.h testing_helpers.h
 $(OUTPUT)/bench: LDLIBS +=3D -lm
 $(OUTPUT)/bench: $(OUTPUT)/bench.o $(OUTPUT)/testing_helpers.o \
 		 $(OUTPUT)/bench_count.o \
 		 $(OUTPUT)/bench_rename.o \
-		 $(OUTPUT)/bench_trigger.o
+		 $(OUTPUT)/bench_trigger.o \
+		 $(OUTPUT)/bench_ringbufs.o
 	$(call msg,BINARY,,$@)
 	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
=20
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftest=
s/bpf/bench.c
index 14390689ef90..944ad4721c83 100644
--- a/tools/testing/selftests/bpf/bench.c
+++ b/tools/testing/selftests/bpf/bench.c
@@ -130,6 +130,13 @@ static const struct argp_option opts[] =3D {
 	{},
 };
=20
+extern struct argp bench_ringbufs_argp;
+
+static const struct argp_child bench_parsers[] =3D {
+	{ &bench_ringbufs_argp, 0, "Ring buffers benchmark", 0 },
+	{},
+};
+
 static error_t parse_arg(int key, char *arg, struct argp_state *state)
 {
 	static int pos_args;
@@ -208,6 +215,7 @@ static void parse_cmdline_args(int argc, char **argv)
 		.options =3D opts,
 		.parser =3D parse_arg,
 		.doc =3D argp_program_doc,
+		.children =3D bench_parsers,
 	};
 	if (argp_parse(&argp, argc, argv, 0, NULL, NULL))
 		exit(1);
@@ -310,6 +318,10 @@ extern const struct bench bench_trig_rawtp;
 extern const struct bench bench_trig_kprobe;
 extern const struct bench bench_trig_fentry;
 extern const struct bench bench_trig_fmodret;
+extern const struct bench bench_rb_libbpf;
+extern const struct bench bench_rb_custom;
+extern const struct bench bench_pb_libbpf;
+extern const struct bench bench_pb_custom;
=20
 static const struct bench *benchs[] =3D {
 	&bench_count_global,
@@ -327,6 +339,10 @@ static const struct bench *benchs[] =3D {
 	&bench_trig_kprobe,
 	&bench_trig_fentry,
 	&bench_trig_fmodret,
+	&bench_rb_libbpf,
+	&bench_rb_custom,
+	&bench_pb_libbpf,
+	&bench_pb_custom,
 };
=20
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/=
testing/selftests/bpf/benchs/bench_ringbufs.c
new file mode 100644
index 000000000000..da87c7f31891
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -0,0 +1,566 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <asm/barrier.h>
+#include <linux/perf_event.h>
+#include <linux/ring_buffer.h>
+#include <sys/epoll.h>
+#include <sys/mman.h>
+#include <argp.h>
+#include <stdlib.h>
+#include "bench.h"
+#include "ringbuf_bench.skel.h"
+#include "perfbuf_bench.skel.h"
+
+static struct {
+	bool back2back;
+	int batch_cnt;
+	bool sampled;
+	int sample_rate;
+	int ringbuf_sz; /* per-ringbuf, in bytes */
+	bool ringbuf_use_output; /* use slower output API */
+	int perfbuf_sz; /* per-CPU size, in pages */
+} args =3D {
+	.back2back =3D false,
+	.batch_cnt =3D 500,
+	.sampled =3D false,
+	.sample_rate =3D 500,
+	.ringbuf_sz =3D 512 * 1024,
+	.ringbuf_use_output =3D false,
+	.perfbuf_sz =3D 128,
+};
+
+enum {
+	ARG_RB_BACK2BACK =3D 2000,
+	ARG_RB_USE_OUTPUT =3D 2001,
+	ARG_RB_BATCH_CNT =3D 2002,
+	ARG_RB_SAMPLED =3D 2003,
+	ARG_RB_SAMPLE_RATE =3D 2004,
+};
+
+static const struct argp_option opts[] =3D {
+	{ "rb-b2b", ARG_RB_BACK2BACK, NULL, 0, "Back-to-back mode"},
+	{ "rb-use-output", ARG_RB_USE_OUTPUT, NULL, 0, "Use bpf_ringbuf_output(=
) instead of bpf_ringbuf_reserve()"},
+	{ "rb-batch-cnt", ARG_RB_BATCH_CNT, "CNT", 0, "Set BPF-side record batc=
h count"},
+	{ "rb-sampled", ARG_RB_SAMPLED, NULL, 0, "Notification sampling"},
+	{ "rb-sample-rate", ARG_RB_SAMPLE_RATE, "RATE", 0, "Notification sample=
 rate"},
+	{},
+};
+
+static error_t parse_arg(int key, char *arg, struct argp_state *state)
+{
+	switch (key) {
+	case ARG_RB_BACK2BACK:
+		args.back2back =3D true;
+		break;
+	case ARG_RB_USE_OUTPUT:
+		args.ringbuf_use_output =3D true;
+		break;
+	case ARG_RB_BATCH_CNT:
+		args.batch_cnt =3D strtol(arg, NULL, 10);
+		if (args.batch_cnt < 0) {
+			fprintf(stderr, "Invalid batch count.");
+			argp_usage(state);
+		}
+		break;
+	case ARG_RB_SAMPLED:
+		args.sampled =3D true;
+		break;
+	case ARG_RB_SAMPLE_RATE:
+		args.sample_rate =3D strtol(arg, NULL, 10);
+		if (args.sample_rate < 0) {
+			fprintf(stderr, "Invalid perfbuf sample rate.");
+			argp_usage(state);
+		}
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+	return 0;
+}
+
+/* exported into benchmark runner */
+const struct argp bench_ringbufs_argp =3D {
+	.options =3D opts,
+	.parser =3D parse_arg,
+};
+
+/* RINGBUF-LIBBPF benchmark */
+
+static struct counter buf_hits;
+
+static inline void bufs_trigger_batch()
+{
+	(void)syscall(__NR_getpgid);
+}
+
+static void bufs_validate()
+{
+	if (env.consumer_cnt !=3D 1) {
+		fprintf(stderr, "rb-libbpf benchmark doesn't support multi-consumer!\n=
");
+		exit(1);
+	}
+
+	if (args.back2back && env.producer_cnt > 1) {
+		fprintf(stderr, "back-to-back mode makes sense only for single-produce=
r case!\n");
+		exit(1);
+	}
+}
+
+static void *bufs_sample_producer(void *input)
+{
+	if (args.back2back) {
+		/* initial batch to get everything started */
+		bufs_trigger_batch();
+		return NULL;
+	}
+
+	while (true)
+		bufs_trigger_batch();
+	return NULL;
+}
+
+static struct ringbuf_libbpf_ctx {
+	struct ringbuf_bench *skel;
+	struct ring_buffer *ringbuf;
+} ringbuf_libbpf_ctx;
+
+static void ringbuf_libbpf_measure(struct bench_res *res)
+{
+	struct ringbuf_libbpf_ctx *ctx =3D &ringbuf_libbpf_ctx;
+
+	res->hits =3D atomic_swap(&buf_hits.value, 0);
+	res->drops =3D atomic_swap(&ctx->skel->bss->dropped, 0);
+}
+
+static struct ringbuf_bench *ringbuf_setup_skeleton()
+{
+	struct ringbuf_bench *skel;
+
+	setup_libbpf();
+
+	skel =3D ringbuf_bench__open();
+	if (!skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	skel->rodata->batch_cnt =3D args.batch_cnt;
+	skel->rodata->use_output =3D args.ringbuf_use_output ? 1 : 0;
+
+	if (args.sampled)
+		/* record data + header take 16 bytes */
+		skel->rodata->wakeup_data_size =3D args.sample_rate * 16;
+
+	bpf_map__resize(skel->maps.ringbuf, args.ringbuf_sz);
+
+	if (ringbuf_bench__load(skel)) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	return skel;
+}
+
+static int buf_process_sample(void *ctx, void *data, size_t len)
+{
+	atomic_inc(&buf_hits.value);
+	return 0;
+}
+
+static void ringbuf_libbpf_setup()
+{
+	struct ringbuf_libbpf_ctx *ctx =3D &ringbuf_libbpf_ctx;
+	struct bpf_link *link;
+
+	ctx->skel =3D ringbuf_setup_skeleton();
+	ctx->ringbuf =3D ring_buffer__new(bpf_map__fd(ctx->skel->maps.ringbuf),
+					buf_process_sample, NULL, NULL);
+	if (!ctx->ringbuf) {
+		fprintf(stderr, "failed to create ringbuf\n");
+		exit(1);
+	}
+
+	link =3D bpf_program__attach(ctx->skel->progs.bench_ringbuf);
+	if (IS_ERR(link)) {
+		fprintf(stderr, "failed to attach program!\n");
+		exit(1);
+	}
+}
+
+static void *ringbuf_libbpf_consumer(void *input)
+{
+	struct ringbuf_libbpf_ctx *ctx =3D &ringbuf_libbpf_ctx;
+
+	while (ring_buffer__poll(ctx->ringbuf, -1) >=3D 0) {
+		if (args.back2back)
+			bufs_trigger_batch();
+	}
+	fprintf(stderr, "ringbuf polling failed!\n");
+	return NULL;
+}
+
+/* RINGBUF-CUSTOM benchmark */
+struct ringbuf_custom {
+	__u64 *consumer_pos;
+	__u64 *producer_pos;
+	__u64 mask;
+	void *data;
+	int map_fd;
+};
+
+static struct ringbuf_custom_ctx {
+	struct ringbuf_bench *skel;
+	struct ringbuf_custom ringbuf;
+	int epoll_fd;
+	struct epoll_event event;
+} ringbuf_custom_ctx;
+
+static void ringbuf_custom_measure(struct bench_res *res)
+{
+	struct ringbuf_custom_ctx *ctx =3D &ringbuf_custom_ctx;
+
+	res->hits =3D atomic_swap(&buf_hits.value, 0);
+	res->drops =3D atomic_swap(&ctx->skel->bss->dropped, 0);
+}
+
+static void ringbuf_custom_setup()
+{
+	struct ringbuf_custom_ctx *ctx =3D &ringbuf_custom_ctx;
+	const size_t page_size =3D getpagesize();
+	struct bpf_link *link;
+	struct ringbuf_custom *r;
+	void *tmp;
+	int err;
+
+	ctx->skel =3D ringbuf_setup_skeleton();
+
+	ctx->epoll_fd =3D epoll_create1(EPOLL_CLOEXEC);
+	if (ctx->epoll_fd < 0) {
+		fprintf(stderr, "failed to create epoll fd: %d\n", -errno);
+		exit(1);
+	}
+
+	r =3D &ctx->ringbuf;
+	r->map_fd =3D bpf_map__fd(ctx->skel->maps.ringbuf);
+	r->mask =3D args.ringbuf_sz - 1;
+
+	/* Map writable consumer page */
+	tmp =3D mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
+		   r->map_fd, 0);
+	if (tmp =3D=3D MAP_FAILED) {
+		fprintf(stderr, "failed to mmap consumer page: %d\n", -errno);
+		exit(1);
+	}
+	r->consumer_pos =3D tmp;
+
+	/* Map read-only producer page and data pages. */
+	tmp =3D mmap(NULL, page_size + 2 * args.ringbuf_sz, PROT_READ, MAP_SHAR=
ED,
+		   r->map_fd, page_size);
+	if (tmp =3D=3D MAP_FAILED) {
+		fprintf(stderr, "failed to mmap data pages: %d\n", -errno);
+		exit(1);
+	}
+	r->producer_pos =3D tmp;
+	r->data =3D tmp + page_size;
+
+	ctx->event.events =3D EPOLLIN;
+	err =3D epoll_ctl(ctx->epoll_fd, EPOLL_CTL_ADD, r->map_fd, &ctx->event)=
;
+	if (err < 0) {
+		fprintf(stderr, "failed to epoll add ringbuf: %d\n", -errno);
+		exit(1);
+	}
+
+	link =3D bpf_program__attach(ctx->skel->progs.bench_ringbuf);
+	if (IS_ERR(link)) {
+		fprintf(stderr, "failed to attach program\n");
+		exit(1);
+	}
+}
+
+#define RINGBUF_BUSY_BIT (1 << 31)
+#define RINGBUF_DISCARD_BIT (1 << 30)
+#define RINGBUF_META_LEN 8
+
+static inline int roundup_len(__u32 len)
+{
+	/* clear out top 2 bits */
+	len <<=3D 2;
+	len >>=3D 2;
+	/* add length prefix */
+	len +=3D RINGBUF_META_LEN;
+	/* round up to 8 byte alignment */
+	return (len + 7) / 8 * 8;
+}
+
+static void ringbuf_custom_process_ring(struct ringbuf_custom *r)
+{
+	unsigned long cons_pos, prod_pos;
+	int *len_ptr, len;
+	bool got_new_data;
+
+	cons_pos =3D smp_load_acquire(r->consumer_pos);
+	while (true) {
+		got_new_data =3D false;
+		prod_pos =3D smp_load_acquire(r->producer_pos);
+		while (cons_pos < prod_pos) {
+			len_ptr =3D r->data + (cons_pos & r->mask);
+			len =3D smp_load_acquire(len_ptr);
+
+			/* sample not committed yet, bail out for now */
+			if (len & RINGBUF_BUSY_BIT)
+				return;
+
+			got_new_data =3D true;
+			cons_pos +=3D roundup_len(len);
+
+			atomic_inc(&buf_hits.value);
+		}
+		if (got_new_data)
+			smp_store_release(r->consumer_pos, cons_pos);
+		else
+			break;
+	};
+}
+
+static void *ringbuf_custom_consumer(void *input)
+{
+	struct ringbuf_custom_ctx *ctx =3D &ringbuf_custom_ctx;
+	int cnt;
+
+	do {
+		if (args.back2back)
+			bufs_trigger_batch();
+		cnt =3D epoll_wait(ctx->epoll_fd, &ctx->event, 1, -1);
+		if (cnt > 0)
+			ringbuf_custom_process_ring(&ctx->ringbuf);
+	} while (cnt >=3D 0);
+	fprintf(stderr, "ringbuf polling failed!\n");
+	return 0;
+}
+
+/* PERFBUF-LIBBPF benchmark */
+static struct perfbuf_libbpf_ctx {
+	struct perfbuf_bench *skel;
+	struct perf_buffer *perfbuf;
+} perfbuf_libbpf_ctx;
+
+static void perfbuf_measure(struct bench_res *res)
+{
+	struct perfbuf_libbpf_ctx *ctx =3D &perfbuf_libbpf_ctx;
+
+	res->hits =3D atomic_swap(&buf_hits.value, 0);
+	res->drops =3D atomic_swap(&ctx->skel->bss->dropped, 0);
+}
+
+static struct perfbuf_bench *perfbuf_setup_skeleton()
+{
+	struct perfbuf_bench *skel;
+
+	setup_libbpf();
+
+	skel =3D perfbuf_bench__open();
+	if (!skel) {
+		fprintf(stderr, "failed to open skeleton\n");
+		exit(1);
+	}
+
+	skel->rodata->batch_cnt =3D args.batch_cnt;
+
+	if (perfbuf_bench__load(skel)) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	return skel;
+}
+
+static enum bpf_perf_event_ret
+perfbuf_process_sample_raw(void *input_ctx, int cpu,
+			   struct perf_event_header *e)
+{
+	switch (e->type) {
+	case PERF_RECORD_SAMPLE:
+		atomic_inc(&buf_hits.value);
+		break;
+	case PERF_RECORD_LOST:
+		break;
+	default:
+		return LIBBPF_PERF_EVENT_ERROR;
+	}
+	return LIBBPF_PERF_EVENT_CONT;
+}
+
+static void perfbuf_libbpf_setup()
+{
+	struct perfbuf_libbpf_ctx *ctx =3D &perfbuf_libbpf_ctx;
+	struct perf_event_attr attr;
+	struct perf_buffer_raw_opts pb_opts =3D {
+		.event_cb =3D perfbuf_process_sample_raw,
+		.ctx =3D (void *)(long)0,
+		.attr =3D &attr,
+	};
+	struct bpf_link *link;
+
+	ctx->skel =3D perfbuf_setup_skeleton();
+
+	memset(&attr, 0, sizeof(attr));
+	attr.config =3D PERF_COUNT_SW_BPF_OUTPUT,
+	attr.type =3D PERF_TYPE_SOFTWARE;
+	attr.sample_type =3D PERF_SAMPLE_RAW;
+	/* notify only every Nth sample */
+	if (args.sampled) {
+		attr.sample_period =3D args.sample_rate;
+		attr.wakeup_events =3D args.sample_rate;
+	} else {
+		attr.sample_period =3D 1;
+		attr.wakeup_events =3D 1;
+	}
+
+	if (args.sample_rate > args.batch_cnt) {
+		fprintf(stderr, "sample rate %d is too high for given batch count %d\n=
",
+			args.sample_rate, args.batch_cnt);
+		exit(1);
+	}
+
+	ctx->perfbuf =3D perf_buffer__new_raw(bpf_map__fd(ctx->skel->maps.perfb=
uf),
+					    args.perfbuf_sz, &pb_opts);
+	if (!ctx->perfbuf) {
+		fprintf(stderr, "failed to create perfbuf\n");
+		exit(1);
+	}
+
+	link =3D bpf_program__attach(ctx->skel->progs.bench_perfbuf);
+	if (IS_ERR(link)) {
+		fprintf(stderr, "failed to attach program\n");
+		exit(1);
+	}
+}
+
+static void *perfbuf_libbpf_consumer(void *input)
+{
+	struct perfbuf_libbpf_ctx *ctx =3D &perfbuf_libbpf_ctx;
+
+	while (perf_buffer__poll(ctx->perfbuf, -1) >=3D 0) {
+		if (args.back2back)
+			bufs_trigger_batch();
+	}
+	fprintf(stderr, "perfbuf polling failed!\n");
+	return NULL;
+}
+
+/* PERFBUF-CUSTOM benchmark */
+
+/* copies of internal libbpf definitions */
+struct perf_cpu_buf {
+	struct perf_buffer *pb;
+	void *base; /* mmap()'ed memory */
+	void *buf; /* for reconstructing segmented data */
+	size_t buf_size;
+	int fd;
+	int cpu;
+	int map_key;
+};
+
+struct perf_buffer {
+	perf_buffer_event_fn event_cb;
+	perf_buffer_sample_fn sample_cb;
+	perf_buffer_lost_fn lost_cb;
+	void *ctx; /* passed into callbacks */
+
+	size_t page_size;
+	size_t mmap_size;
+	struct perf_cpu_buf **cpu_bufs;
+	struct epoll_event *events;
+	int cpu_cnt; /* number of allocated CPU buffers */
+	int epoll_fd; /* perf event FD */
+	int map_fd; /* BPF_MAP_TYPE_PERF_EVENT_ARRAY BPF map FD */
+};
+
+static void *perfbuf_custom_consumer(void *input)
+{
+	struct perfbuf_libbpf_ctx *ctx =3D &perfbuf_libbpf_ctx;
+	struct perf_buffer *pb =3D ctx->perfbuf;
+	struct perf_cpu_buf *cpu_buf;
+	struct perf_event_mmap_page *header;
+	size_t mmap_mask =3D pb->mmap_size - 1;
+	struct perf_event_header *ehdr;
+	__u64 data_head, data_tail;
+	size_t ehdr_size;
+	void *base;
+	int i, cnt;
+
+	while (true) {
+		if (args.back2back)
+			bufs_trigger_batch();
+		cnt =3D epoll_wait(pb->epoll_fd, pb->events, pb->cpu_cnt, -1);
+		if (cnt <=3D 0) {
+			fprintf(stderr, "perf epoll failed: %d\n", -errno);
+			exit(1);
+		}
+
+		for (i =3D 0; i < cnt; ++i) {
+			cpu_buf =3D pb->events[i].data.ptr;
+			header =3D cpu_buf->base;
+			base =3D ((void *)header) + pb->page_size;
+
+			data_head =3D ring_buffer_read_head(header);
+			data_tail =3D header->data_tail;
+			while (data_head !=3D data_tail) {
+				ehdr =3D base + (data_tail & mmap_mask);
+				ehdr_size =3D ehdr->size;
+
+				if (ehdr->type =3D=3D PERF_RECORD_SAMPLE)
+					atomic_inc(&buf_hits.value);
+
+				data_tail +=3D ehdr_size;
+			}
+			ring_buffer_write_tail(header, data_tail);
+		}
+	}
+	return NULL;
+}
+
+const struct bench bench_rb_libbpf =3D {
+	.name =3D "rb-libbpf",
+	.validate =3D bufs_validate,
+	.setup =3D ringbuf_libbpf_setup,
+	.producer_thread =3D bufs_sample_producer,
+	.consumer_thread =3D ringbuf_libbpf_consumer,
+	.measure =3D ringbuf_libbpf_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_rb_custom =3D {
+	.name =3D "rb-custom",
+	.validate =3D bufs_validate,
+	.setup =3D ringbuf_custom_setup,
+	.producer_thread =3D bufs_sample_producer,
+	.consumer_thread =3D ringbuf_custom_consumer,
+	.measure =3D ringbuf_custom_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_pb_libbpf =3D {
+	.name =3D "pb-libbpf",
+	.validate =3D bufs_validate,
+	.setup =3D perfbuf_libbpf_setup,
+	.producer_thread =3D bufs_sample_producer,
+	.consumer_thread =3D perfbuf_libbpf_consumer,
+	.measure =3D perfbuf_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_pb_custom =3D {
+	.name =3D "pb-custom",
+	.validate =3D bufs_validate,
+	.setup =3D perfbuf_libbpf_setup,
+	.producer_thread =3D bufs_sample_producer,
+	.consumer_thread =3D perfbuf_custom_consumer,
+	.measure =3D perfbuf_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
diff --git a/tools/testing/selftests/bpf/benchs/run_bench_ringbufs.sh b/t=
ools/testing/selftests/bpf/benchs/run_bench_ringbufs.sh
new file mode 100755
index 000000000000..af4aa04caba6
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_ringbufs.sh
@@ -0,0 +1,75 @@
+#!/bin/bash
+
+set -eufo pipefail
+
+RUN_BENCH=3D"sudo ./bench -w3 -d10 -a"
+
+function hits()
+{
+	echo "$*" | sed -E "s/.*hits\s+([0-9]+\.[0-9]+ =C2=B1 [0-9]+\.[0-9]+M\/=
s).*/\1/"
+}
+
+function drops()
+{
+	echo "$*" | sed -E "s/.*drops\s+([0-9]+\.[0-9]+ =C2=B1 [0-9]+\.[0-9]+M\=
/s).*/\1/"
+}
+
+function header()
+{
+	local len=3D${#1}
+
+	printf "\n%s\n" "$1"
+	for i in $(seq 1 $len); do printf '=3D'; done
+	printf '\n'
+}
+
+function summarize()
+{
+	bench=3D"$1"
+	summary=3D$(echo $2 | tail -n1)
+	printf "%-20s %s (drops %s)\n" "$bench" "$(hits $summary)" "$(drops $su=
mmary)"
+}
+
+header "Single-producer, parallel producer"
+for b in rb-libbpf rb-custom pb-libbpf pb-custom; do
+	summarize $b "$($RUN_BENCH $b)"
+done
+
+header "Single-producer, parallel producer, sampled notification"
+for b in rb-libbpf rb-custom pb-libbpf pb-custom; do
+	summarize $b "$($RUN_BENCH --rb-sampled $b)"
+done
+
+header "Single-producer, back-to-back mode"
+for b in rb-libbpf rb-custom pb-libbpf pb-custom; do
+	summarize $b "$($RUN_BENCH --rb-b2b $b)"
+	summarize $b-sampled "$($RUN_BENCH --rb-sampled --rb-b2b $b)"
+done
+
+header "Ringbuf back-to-back, effect of sample rate"
+for b in 1 5 10 25 50 100 250 500 1000 2000 3000; do
+	summarize "rb-sampled-$b" "$($RUN_BENCH --rb-b2b --rb-batch-cnt $b --rb=
-sampled --rb-sample-rate $b rb-custom)"
+done
+header "Perfbuf back-to-back, effect of sample rate"
+for b in 1 5 10 25 50 100 250 500 1000 2000 3000; do
+	summarize "pb-sampled-$b" "$($RUN_BENCH --rb-b2b --rb-batch-cnt $b --rb=
-sampled --rb-sample-rate $b pb-custom)"
+done
+
+header "Ringbuf back-to-back, reserve+commit vs output"
+summarize "reserve" "$($RUN_BENCH --rb-b2b                 rb-custom)"
+summarize "output"  "$($RUN_BENCH --rb-b2b --rb-use-output rb-custom)"
+
+header "Ringbuf sampled, reserve+commit vs output"
+summarize "reserve-sampled" "$($RUN_BENCH --rb-sampled                 r=
b-custom)"
+summarize "output-sampled"  "$($RUN_BENCH --rb-sampled --rb-use-output r=
b-custom)"
+
+header "Single-producer, consumer/producer competing on the same CPU, lo=
w batch count"
+for b in rb-libbpf rb-custom pb-libbpf pb-custom; do
+	summarize $b "$($RUN_BENCH --rb-batch-cnt 1 --rb-sample-rate 1 --prod-a=
ffinity 0 --cons-affinity 0 $b)"
+done
+
+header "Ringbuf, multi-producer contention"
+for b in 1 2 3 4 8 12 16 20 24 28 32 36 40 44 48 52; do
+	summarize "rb-libbpf nr_prod $b" "$($RUN_BENCH -p$b --rb-batch-cnt 50 r=
b-libbpf)"
+done
+
diff --git a/tools/testing/selftests/bpf/progs/perfbuf_bench.c b/tools/te=
sting/selftests/bpf/progs/perfbuf_bench.c
new file mode 100644
index 000000000000..e5ab4836a641
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/perfbuf_bench.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(value_size, sizeof(int));
+	__uint(key_size, sizeof(int));
+} perfbuf SEC(".maps");
+
+const volatile int batch_cnt =3D 0;
+
+long sample_val =3D 42;
+long dropped __attribute__((aligned(128))) =3D 0;
+
+SEC("fentry/__x64_sys_getpgid")
+int bench_perfbuf(void *ctx)
+{
+	__u64 *sample;
+	int i;
+
+	for (i =3D 0; i < batch_cnt; i++) {
+		if (bpf_perf_event_output(ctx, &perfbuf, BPF_F_CURRENT_CPU,
+					  &sample_val, sizeof(sample_val)))
+			__sync_add_and_fetch(&dropped, 1);
+	}
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/ringbuf_bench.c b/tools/te=
sting/selftests/bpf/progs/ringbuf_bench.c
new file mode 100644
index 000000000000..123607d314d6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/ringbuf_bench.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+} ringbuf SEC(".maps");
+
+const volatile int batch_cnt =3D 0;
+const volatile long use_output =3D 0;
+
+long sample_val =3D 42;
+long dropped __attribute__((aligned(128))) =3D 0;
+
+const volatile long wakeup_data_size =3D 0;
+
+static __always_inline long get_flags()
+{
+	long sz;
+
+	if (!wakeup_data_size)
+		return 0;
+
+	sz =3D bpf_ringbuf_query(&ringbuf, BPF_RB_AVAIL_DATA);
+	return sz >=3D wakeup_data_size ? BPF_RB_FORCE_WAKEUP : BPF_RB_NO_WAKEU=
P;
+}
+
+SEC("fentry/__x64_sys_getpgid")
+int bench_ringbuf(void *ctx)
+{
+	long *sample, flags;
+	int i;
+
+	if (!use_output) {
+		for (i =3D 0; i < batch_cnt; i++) {
+			sample =3D bpf_ringbuf_reserve(&ringbuf,
+					             sizeof(sample_val), 0);
+			if (!sample) {
+				__sync_add_and_fetch(&dropped, 1);
+			} else {
+				*sample =3D sample_val;
+				flags =3D get_flags();
+				bpf_ringbuf_submit(sample, flags);
+			}
+		}
+	} else {
+		for (i =3D 0; i < batch_cnt; i++) {
+			flags =3D get_flags();
+			if (bpf_ringbuf_output(&ringbuf, &sample_val,
+					       sizeof(sample_val), flags))
+				__sync_add_and_fetch(&dropped, 1);
+		}
+	}
+	return 0;
+}
--=20
2.24.1

