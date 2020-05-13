Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471341D1F1B
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390656AbgEMT0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:26:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20878 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390575AbgEMT0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:26:31 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DJPhPK022370
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=u69t6G5CwZsyO+gFFoHypZYKKS9/GK48ZqeST75G5Y8=;
 b=gHJGOSlDtsNDjlyJep5y4qbsrHtXDrAF+xMv/N4NX5zkOLaKv/aFodGHLT6ANcWNTMvU
 IWwZA1M8JCF61eGisNEbv//da6KLb0mYz2W2wdiZfPlT5n7pseJ/zoMRdx80sNet3r3v
 fsMQxOSZXPdxxboJm+OkN3jpEqSZLmKSnX0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100xb6sdy-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:26:27 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 12:26:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EBDFA2EC3007; Wed, 13 May 2020 12:26:13 -0700 (PDT)
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
Subject: [PATCH bpf-next 6/6] bpf: add BPF ringbuf and perf buffer benchmarks
Date:   Wed, 13 May 2020 12:25:32 -0700
Message-ID: <20200513192532.4058934-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513192532.4058934-1-andriin@fb.com>
References: <20200513192532.4058934-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=9 lowpriorityscore=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 adultscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130166
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
buffer. 5 benchmarks were implemented: 2 variations for BPF ringbuf,
3 variations for perfbuf:
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
    settings; default settings are good safe defaults, but are far from
    providing highest throughput -- perf buffer allows to specify
    wakeup_events and sample_period > 1, that will cause perf code to tri=
gger
    epoll notifications less frequently, which boosts throughput immensel=
y;
  - pb-raw uses perf_buffer__new_raw() API to specify custom wakeup_event=
s and
    sample_period and specifies raw sample callback, which removes some o=
f the
    overhead in generic case;
  - pb-custom does the same setup as pb-raw, but implements custom consum=
er
    code eliminating all the callback overhead.

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
rb-libbpf            11.302 =C2=B1 0.564M/s (drops 0.000 =C2=B1 0.000M/s)
rb-custom            8.895 =C2=B1 0.148M/s (drops 0.000 =C2=B1 0.000M/s)
pb-libbpf            0.927 =C2=B1 0.008M/s (drops 0.000 =C2=B1 0.000M/s)
pb-raw               9.884 =C2=B1 0.058M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            9.724 =C2=B1 0.068M/s (drops 0.000 =C2=B1 0.001M/s)

Single producer on one CPU, consumer on another one, both running at full
speed. Curiously, rb-libbpf has higher throughput than objectively faster=
 (due
to more lightweight consumer code path) rb-custom. It appears that faster
consumer causes kernel to send notifications more frequently, because con=
sumer
appears to be caught up more frequently.

Stock perfbuf settings are about 10x slower, compared to pb-raw/pb-custom=
 with
wakeup_events/sample_period set to 500. The trade-off is that with sampli=
ng,
application might not get next X events until X+1st arrives, which is not
always acceptable.

Single-producer, back-to-back mode
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
rb-libbpf            15.991 =C2=B1 0.456M/s (drops 0.000 =C2=B1 0.000M/s)
rb-custom            21.646 =C2=B1 0.457M/s (drops 0.000 =C2=B1 0.000M/s)
pb-libbpf            1.608 =C2=B1 0.040M/s (drops 0.000 =C2=B1 0.000M/s)
pb-raw               8.866 =C2=B1 0.098M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            8.858 =C2=B1 0.137M/s (drops 0.000 =C2=B1 0.000M/s)

Here we test a back-to-back mode, which is arguably best-case scenario bo=
th
for BPF ringbuf and perfbuf, because there is no contention and for ringb=
uf
also no excessive notification, because consumer appears to be behind aft=
er
the first record. For ringbuf, custom consumer code clearly wins with 22 =
vs 16
million records per second exchanged between producer and consumer.

Perfbuf with wakeup sampling gets 5.5x throughput increase, compared to
no-sampling version. There also doesn't seem to be noticeable overhead fr=
om
generic libbpf handling code.

Perfbuf, effect of sample rate, back-to-back
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
sample rate 1        1.634 =C2=B1 0.023M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 5        4.510 =C2=B1 0.082M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 10       5.875 =C2=B1 0.085M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 25       7.361 =C2=B1 0.150M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 50       7.574 =C2=B1 0.559M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 100      8.486 =C2=B1 0.274M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 250      8.787 =C2=B1 0.183M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 500      8.494 =C2=B1 0.732M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 1000     8.445 =C2=B1 0.336M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 2000     9.000 =C2=B1 0.187M/s (drops 0.000 =C2=B1 0.000M/s)
sample rate 3000     8.684 =C2=B1 0.556M/s (drops 0.000 =C2=B1 0.000M/s)

This benchmark shows the effect of event sampling for perfbuf. Back-to-ba=
ck
mode for highest throughput. Just doing every 5th record notification giv=
es 3x
speed up. 250-500 appears to be the point of diminishing return, with 5.5=
x
speed up. Most benchmarks use 500 as the default sampling for pb-raw and
pb-custom.

Ringbuf, reserve+commit vs output, back-to-back
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
reserve              22.570 =C2=B1 0.490M/s (drops 0.000 =C2=B1 0.000M/s)
output               19.037 =C2=B1 0.429M/s (drops 0.000 =C2=B1 0.000M/s)

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
rb-libbpf            1.485 =C2=B1 0.015M/s (drops 1.969 =C2=B1 0.058M/s)
rb-custom            1.489 =C2=B1 0.017M/s (drops 1.910 =C2=B1 0.098M/s)
pb-libbpf            1.242 =C2=B1 0.042M/s (drops 0.000 =C2=B1 0.000M/s)
pb-raw               1.217 =C2=B1 0.043M/s (drops 0.000 =C2=B1 0.000M/s)
pb-custom            1.264 =C2=B1 0.023M/s (drops 0.000 =C2=B1 0.000M/s)

This benchmark shows one of the worst-case scenarios, in which producer a=
nd
consumer do not coordinate *and* fight for the same CPU. No batch count a=
nd
sampling settings were able to eliminate drops for ringbuffer, producer i=
s
just too fast for consumer to keep up. Still, ringbuf and perfbuf still a=
ble
to pass through more than a million messages per second, which is more th=
an
enough for a lot of applications.

Ringbuf, multi-producer contention, low batch count
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
rb-libbpf nr_prod 1  9.559 =C2=B1 0.134M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 2  6.542 =C2=B1 0.039M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 3  4.444 =C2=B1 0.007M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 4  3.764 =C2=B1 0.021M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 8  4.147 =C2=B1 0.013M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 12 3.652 =C2=B1 0.185M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 16 2.338 =C2=B1 0.020M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 20 2.055 =C2=B1 0.006M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 24 1.961 =C2=B1 0.006M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 28 2.136 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 32 2.069 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 36 2.177 =C2=B1 0.002M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 40 2.323 =C2=B1 0.002M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 44 2.274 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 48 2.069 =C2=B1 0.003M/s (drops 0.000 =C2=B1 0.000M/s)
rb-libbpf nr_prod 52 2.041 =C2=B1 0.004M/s (drops 0.000 =C2=B1 0.000M/s)

Ringbuf uses a very short-duration spinlock during reservation phase, to =
check
few invariants, increment producer count and set record header. This is t=
he
biggest point of contention for ringbuf implementation. This benchmark
evaluates the effect of multiple competing writers on overall throughput =
of
a single shared ringbuffer.

Overall throughput drops by about 30% when going from single to two
highly-contended producers, losing another 30% with third producer added.
Performance drop stabilizes at around 16 producers and hovers around 2mln=
 even
with 50+ fighting producers, which is a 4.75x drop in throughput and
a testament to a good implementation of spinlock in the kernel.

Note, that in the intended real-world scenarios, it's not expected to get=
 even
close to such a high levels of contention. But if contention will become
a problem, there is always an option of sharding few ring buffers across =
a set
of CPUs.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bench.c           |  18 +
 .../selftests/bpf/benchs/bench_ringbufs.c     | 593 ++++++++++++++++++
 .../bpf/benchs/run_bench_ringbufs.sh          |  61 ++
 .../selftests/bpf/progs/perfbuf_bench.c       |  33 +
 .../selftests/bpf/progs/ringbuf_bench.c       |  45 ++
 6 files changed, 754 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_ringbufs.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_ringbufs=
.sh
 create mode 100644 tools/testing/selftests/bpf/progs/perfbuf_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/ringbuf_bench.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 352d17a16bae..a95ac4d691d2 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -412,12 +412,15 @@ $(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
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
index 8c0dfbfe6088..a18f93804da7 100644
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
@@ -310,6 +318,11 @@ extern const struct bench bench_trig_rawtp;
 extern const struct bench bench_trig_kprobe;
 extern const struct bench bench_trig_fentry;
 extern const struct bench bench_trig_fmodret;
+extern const struct bench bench_rb_libbpf;
+extern const struct bench bench_rb_custom;
+extern const struct bench bench_pb_libbpf;
+extern const struct bench bench_pb_raw;
+extern const struct bench bench_pb_custom;
=20
 static const struct bench *benchs[] =3D {
 	&bench_count_global,
@@ -327,6 +340,11 @@ static const struct bench *benchs[] =3D {
 	&bench_trig_kprobe,
 	&bench_trig_fentry,
 	&bench_trig_fmodret,
+	&bench_rb_libbpf,
+	&bench_rb_custom,
+	&bench_pb_libbpf,
+	&bench_pb_raw,
+	&bench_pb_custom,
 };
=20
 static void setup_benchmark()
diff --git a/tools/testing/selftests/bpf/benchs/bench_ringbufs.c b/tools/=
testing/selftests/bpf/benchs/bench_ringbufs.c
new file mode 100644
index 000000000000..01017105ac08
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_ringbufs.c
@@ -0,0 +1,593 @@
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
+	int ringbuf_sz; /* per-ringbuf, in bytes */
+	bool ringbuf_use_reserve; /* use reserve/submit or output API */
+	int perfbuf_sz; /* per-CPU size, in pages */
+	int perfbuf_sample_rate;
+} args =3D {
+	.back2back =3D false,
+	.batch_cnt =3D 500,
+	.ringbuf_sz =3D 512 * 1024,
+	.ringbuf_use_reserve =3D true,
+	.perfbuf_sz =3D 128,
+	.perfbuf_sample_rate =3D 500,
+};
+
+enum {
+	ARG_RB_BACK2BACK =3D 2000,
+	ARG_RB_USE_OUTPUT =3D 2001,
+	ARG_RB_BATCH_CNT =3D 2002,
+	ARG_RB_SAMPLE_RATE =3D 2003,
+};
+
+static const struct argp_option opts[] =3D {
+	{ "rb-b2b", ARG_RB_BACK2BACK, NULL, 0, "Back-to-back mode"},
+	{ "rb-use-output", ARG_RB_USE_OUTPUT, NULL, 0, "Use bpf_ringbuf_output(=
) instead of bpf_ringbuf_reserve()"},
+	{ "rb-batch-cnt", ARG_RB_BATCH_CNT, "CNT", 0, "Set BPF-side record batc=
h count"},
+	{ "rb-sample-rate", ARG_RB_SAMPLE_RATE, "RATE", 0, "Perf buf's sample r=
ate"},
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
+		args.ringbuf_use_reserve =3D false;
+		break;
+	case ARG_RB_BATCH_CNT:
+		args.batch_cnt =3D strtol(arg, NULL, 10);
+		if (args.batch_cnt < 0) {
+			fprintf(stderr, "Invalid batch count.");
+			argp_usage(state);
+		}
+		break;
+	case ARG_RB_SAMPLE_RATE:
+		args.perfbuf_sample_rate =3D strtol(arg, NULL, 10);
+		if (args.perfbuf_sample_rate < 0) {
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
+	skel->rodata->use_reserve =3D args.ringbuf_use_reserve ? 1 : 0;
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
+	__u64 cons_pos, prod_pos;
+	int *len_ptr, len;
+	bool got_new_data;
+
+	cons_pos =3D *r->consumer_pos;
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
+		{
+			ringbuf_custom_process_ring(&ctx->ringbuf);
+		}
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
+static void perfbuf_process_sample(void *input_ctx, int cpu, void *data,
+				   __u32 len)
+{
+	atomic_inc(&buf_hits.value);
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
+	struct perf_buffer_opts pb_opts =3D {
+		.sample_cb =3D perfbuf_process_sample,
+		.ctx =3D (void *)(long)0,
+	};
+	struct bpf_link *link;
+
+	ctx->skel =3D perfbuf_setup_skeleton();
+	ctx->perfbuf =3D perf_buffer__new(bpf_map__fd(ctx->skel->maps.perfbuf),
+					args.perfbuf_sz, &pb_opts);
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
+static void perfbuf_raw_setup()
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
+	attr.sample_period =3D args.perfbuf_sample_rate;
+	attr.wakeup_events =3D args.perfbuf_sample_rate;
+
+	if (args.perfbuf_sample_rate > args.batch_cnt) {
+		fprintf(stderr, "sample rate %d is too high for given batch count %d\n=
",
+			args.perfbuf_sample_rate, args.batch_cnt);
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
+const struct bench bench_pb_raw =3D {
+	.name =3D "pb-raw",
+	.validate =3D bufs_validate,
+	.setup =3D perfbuf_raw_setup,
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
+	.setup =3D perfbuf_raw_setup,
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
index 000000000000..15b6cd5bd9b3
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/run_bench_ringbufs.sh
@@ -0,0 +1,61 @@
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
+for b in rb-libbpf rb-custom pb-libbpf pb-raw pb-custom; do
+	summarize $b "$($RUN_BENCH $b)"
+done
+
+header "Single-producer, back-to-back mode"
+for b in rb-libbpf rb-custom pb-libbpf pb-raw pb-custom; do
+	summarize $b "$($RUN_BENCH --rb-b2b $b)"
+done
+
+header "Perfbuf, effect of sample rate, back-to-back"
+for b in 1 5 10 25 50 100 250 500 1000 2000 3000; do
+	summarize "sample rate $b" "$($RUN_BENCH --rb-b2b --rb-batch-cnt 3000 -=
-rb-sample-rate $b pb-raw)"
+done
+
+header "Ringbuf, reserve+commit vs output, back-to-back"
+summarize "reserve" "$($RUN_BENCH --rb-b2b                 rb-custom)"
+summarize "output"  "$($RUN_BENCH --rb-b2b --rb-use-output rb-custom)"
+
+header "Single-producer, consumer/producer competing on the same CPU, lo=
w batch count"
+for b in rb-libbpf rb-custom pb-libbpf pb-raw pb-custom; do
+	summarize $b "$($RUN_BENCH --rb-sample-rate 1 --rb-batch-cnt 1 --prod-a=
ffinity 0 --cons-affinity 0 $b)"
+done
+
+header "Ringbuf, multi-producer contention, low batch count"
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
index 000000000000..6008ec5d6a22
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/ringbuf_bench.c
@@ -0,0 +1,45 @@
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
+const volatile long use_reserve =3D 1;
+
+long sample_val =3D 42;
+long dropped __attribute__((aligned(128))) =3D 0;
+
+SEC("fentry/__x64_sys_getpgid")
+int bench_ringbuf(void *ctx)
+{
+	long *sample;
+	int i;
+
+	if (use_reserve) {
+		for (i =3D 0; i < batch_cnt; i++) {
+			sample =3D bpf_ringbuf_reserve(&ringbuf,
+						     sizeof(sample_val), 0);
+			if (!sample) {
+				__sync_add_and_fetch(&dropped, 1);
+			} else {
+				*sample =3D sample_val;
+				bpf_ringbuf_submit(sample);
+			}
+		}
+	} else {
+		for (i =3D 0; i < batch_cnt; i++) {
+			if (bpf_ringbuf_output(&ringbuf, &sample_val,
+					       sizeof(sample_val), 0))
+				__sync_add_and_fetch(&dropped, 1);
+		}
+	}
+	return 0;
+}
--=20
2.24.1

