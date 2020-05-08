Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918181CBB30
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgEHXUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:20:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728165AbgEHXUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:20:49 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 048NK25j001271
        for <netdev@vger.kernel.org>; Fri, 8 May 2020 16:20:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=SnrtZfpqBunxQAwpzobS4fbsD6+r7Ztcq7DC4Pr+xI8=;
 b=LLgEHBfkqS7JiNSnETM1ITjiqZU5tVRVDfuP/k52M4ufltmYhoqzgoYRGy5SJYX76e01
 +633GezOY3dg+bHVjtRvn/uug0afcwsgcbapCaHyIr6PqAO38c7JguRk/kY3ct3GNuPG
 755PKNFKcwnhEHdGp5+MoFrDGMueuuMQ85Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30vtccpn4f-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 16:20:47 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 8 May 2020 16:20:38 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 304752EC321F; Fri,  8 May 2020 16:20:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 1/3] selftests/bpf: add benchmark runner infrastructure
Date:   Fri, 8 May 2020 16:20:30 -0700
Message-ID: <20200508232032.1974027-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200508232032.1974027-1-andriin@fb.com>
References: <20200508232032.1974027-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-08_20:2020-05-08,2020-05-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080195
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While working on BPF ringbuf implementation, testing, and benchmarking, I=
've
developed a pretty generic and modular benchmark runner, which seems to b=
e
generically useful, as I've already used it for one more purpose (testing
fastest way to trigger BPF program, to minimize overhead of in-kernel cod=
e).

This patch adds generic part of benchmark runner and sets up Makefile for
extending it with more sets of benchmarks.

Benchmarker itself operates by spinning up specified number of producer a=
nd
consumer threads, setting up interval timer sending SIGALARM signal to
application once a second. Every second, current snapshot with hits/drops
counters are collected and stored in an array. Drops are useful for
producer/consumer benchmarks in which producer might overwhelm consumers.

Once test finishes after given amount of warm-up and testing seconds, mea=
n and
stddev are calculated (ignoring warm-up results) and is printed out to st=
dout.
This setup seems to give consistent and accurate results.

To validate behavior, I added two atomic counting tests: global and local=
.
For global one, all the producer threads are atomically incrementing same
counter as fast as possible. This, of course, leads to huge drop of
performance once there is more than one producer thread due to CPUs fight=
ing
for the same memory location.

Local counting, on the other hand, maintains one counter per each produce=
r
thread, incremented independently. Once per second, all counters are read=
 and
added together to form final "counting throughput" measurement. As expect=
ed,
such setup demonstrates linear scalability with number of producers (as l=
ong
as there are enough physical CPU cores, of course). See example output be=
low.
Also, this setup can nicely demonstrate disastrous effects of false shari=
ng,
if care is not taken to take those per-producer counters apart into
independent cache lines.

Demo output shows global counter first with 1 producer, then with 4. Both
total and per-producer performance significantly drop. The last run is lo=
cal
counter with 4 producers, demonstrating near-perfect scalability.

$ ./bench -a -w1 -d2 -p1 count-global
Setting up benchmark 'count-global'...
Benchmark 'count-global' started.
Iter   0 ( 24.822us): hits  148.179M/s (148.179M/prod), drops    0.000M/s
Iter   1 ( 37.939us): hits  149.308M/s (149.308M/prod), drops    0.000M/s
Iter   2 (-10.774us): hits  150.717M/s (150.717M/prod), drops    0.000M/s
Iter   3 (  3.807us): hits  151.435M/s (151.435M/prod), drops    0.000M/s
Summary: hits  150.488 =C2=B1 1.079M/s (150.488M/prod), drops    0.000 =C2=
=B1 0.000M/s

$ ./bench -a -w1 -d2 -p4 count-global
Setting up benchmark 'count-global'...
Benchmark 'count-global' started.
Iter   0 ( 60.659us): hits   53.910M/s ( 13.477M/prod), drops    0.000M/s
Iter   1 (-17.658us): hits   53.722M/s ( 13.431M/prod), drops    0.000M/s
Iter   2 (  5.865us): hits   53.495M/s ( 13.374M/prod), drops    0.000M/s
Iter   3 (  0.104us): hits   53.606M/s ( 13.402M/prod), drops    0.000M/s
Summary: hits   53.608 =C2=B1 0.113M/s ( 13.402M/prod), drops    0.000 =C2=
=B1 0.000M/s

$ ./bench -a -w1 -d2 -p4 count-local
Setting up benchmark 'count-local'...
Benchmark 'count-local' started.
Iter   0 ( 23.388us): hits  640.450M/s (160.113M/prod), drops    0.000M/s
Iter   1 (  2.291us): hits  605.661M/s (151.415M/prod), drops    0.000M/s
Iter   2 ( -6.415us): hits  607.092M/s (151.773M/prod), drops    0.000M/s
Iter   3 ( -1.361us): hits  601.796M/s (150.449M/prod), drops    0.000M/s
Summary: hits  604.849 =C2=B1 2.739M/s (151.212M/prod), drops    0.000 =C2=
=B1 0.000M/s

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  13 +-
 tools/testing/selftests/bpf/bench.c           | 372 ++++++++++++++++++
 tools/testing/selftests/bpf/bench.h           |  74 ++++
 .../selftests/bpf/benchs/bench_count.c        |  91 +++++
 5 files changed, 550 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/bench.c
 create mode 100644 tools/testing/selftests/bpf/bench.h
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_count.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
index 3ff031972975..1bb204cee853 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -38,3 +38,4 @@ test_cpp
 /bpf_gcc
 /tools
 /runqslower
+/bench
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 3d942be23d09..289fffbf975e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -77,7 +77,7 @@ TEST_PROGS_EXTENDED :=3D with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED =3D test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping test_cpp runqslower
+	test_lirc_mode2_user xdping test_cpp runqslower bench
=20
 TEST_CUSTOM_PROGS =3D urandom_read
=20
@@ -405,6 +405,17 @@ $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core=
_extern.skel.h $(BPFOBJ)
 	$(call msg,CXX,,$@)
 	$(CXX) $(CFLAGS) $^ $(LDLIBS) -o $@
=20
+# Benchmark runner
+$(OUTPUT)/bench_%.o: benchs/bench_%.c bench.h
+	$(call msg,CC,,$@)
+	$(CC) $(CFLAGS) -c $(filter %.c,$^) $(LDLIBS) -o $@
+$(OUTPUT)/bench.o: bench.h
+$(OUTPUT)/bench: LDLIBS +=3D -lm
+$(OUTPUT)/bench: $(OUTPUT)/bench.o \
+		 $(OUTPUT)/bench_count.o
+	$(call msg,BINARY,,$@)
+	$(CC) $(LDFLAGS) -o $@ $(filter %.a %.o,$^) $(LDLIBS)
+
 EXTRA_CLEAN :=3D $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR)			\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature								\
diff --git a/tools/testing/selftests/bpf/bench.c b/tools/testing/selftest=
s/bpf/bench.c
new file mode 100644
index 000000000000..dddc97cd4db6
--- /dev/null
+++ b/tools/testing/selftests/bpf/bench.c
@@ -0,0 +1,372 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define _GNU_SOURCE
+#include <argp.h>
+#include <linux/compiler.h>
+#include <sys/time.h>
+#include <sched.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sys/sysinfo.h>
+#include <sys/resource.h>
+#include <signal.h>
+#include "bench.h"
+
+struct env env =3D {
+	.warmup_sec =3D 1,
+	.duration_sec =3D 5,
+	.affinity =3D false,
+	.consumer_cnt =3D 1,
+	.producer_cnt =3D 1,
+};
+
+static int libbpf_print_fn(enum libbpf_print_level level,
+		    const char *format, va_list args)
+{
+	if (level =3D=3D LIBBPF_DEBUG && !env.verbose)
+		return 0;
+	return vfprintf(stderr, format, args);
+}
+
+static int bump_memlock_rlimit(void)
+{
+	struct rlimit rlim_new =3D {
+		.rlim_cur	=3D RLIM_INFINITY,
+		.rlim_max	=3D RLIM_INFINITY,
+	};
+
+	return setrlimit(RLIMIT_MEMLOCK, &rlim_new);
+}
+
+void setup_libbpf()
+{
+	int err;
+
+	libbpf_set_print(libbpf_print_fn);
+
+	err =3D bump_memlock_rlimit();
+	if (err)
+		fprintf(stderr, "failed to increase RLIMIT_MEMLOCK: %d", err);
+}
+
+void hits_drops_report_progress(int iter, struct bench_res *res, long de=
lta_ns)
+{
+	double hits_per_sec, drops_per_sec;
+	double hits_per_prod;
+
+	hits_per_sec =3D res->hits / 1000000.0 / (delta_ns / 1000000000.0);
+	hits_per_prod =3D hits_per_sec / env.producer_cnt;
+	drops_per_sec =3D res->drops / 1000000.0 / (delta_ns / 1000000000.0);
+
+	printf("Iter %3d (%7.3lfus): ",
+	       iter, (delta_ns - 1000000000) / 1000.0);
+
+	printf("hits %8.3lfM/s (%7.3lfM/prod), drops %8.3lfM/s\n",
+	       hits_per_sec, hits_per_prod, drops_per_sec);
+}
+
+void hits_drops_report_final(struct bench_res res[], int res_cnt)
+{
+	int i;
+	double hits_mean =3D 0.0, drops_mean =3D 0.0;
+	double hits_stddev =3D 0.0, drops_stddev =3D 0.0;
+
+	for (i =3D 0; i < res_cnt; i++) {
+		hits_mean +=3D res[i].hits / 1000000.0 / (0.0 + res_cnt);
+		drops_mean +=3D res[i].drops / 1000000.0 / (0.0 + res_cnt);
+	}
+
+	if (res_cnt > 1)  {
+		for (i =3D 0; i < res_cnt; i++) {
+			hits_stddev +=3D (hits_mean - res[i].hits / 1000000.0) *
+				       (hits_mean - res[i].hits / 1000000.0) /
+				       (res_cnt - 1.0);
+			drops_stddev +=3D (drops_mean - res[i].drops / 1000000.0) *
+					(drops_mean - res[i].drops / 1000000.0) /
+					(res_cnt - 1.0);
+		}
+		hits_stddev =3D sqrt(hits_stddev);
+		drops_stddev =3D sqrt(drops_stddev);
+	}
+	printf("Summary: hits %8.3lf \u00B1 %5.3lfM/s (%7.3lfM/prod), ",
+	       hits_mean, hits_stddev, hits_mean / env.producer_cnt);
+	printf("drops %8.3lf \u00B1 %5.3lfM/s\n",
+	       drops_mean, drops_stddev);
+}
+
+const char *argp_program_version =3D "benchmark";
+const char *argp_program_bug_address =3D "<bpf@vger.kernel.org>";
+const char argp_program_doc[] =3D
+"benchmark    Generic benchmarking framework.\n"
+"\n"
+"This tool runs benchmarks.\n"
+"\n"
+"USAGE: benchmark <bench-name>\n"
+"\n"
+"EXAMPLES:\n"
+"    # run 'count-local' benchmark with 1 producer and 1 consumer\n"
+"    benchmark count-local\n"
+"    # run 'count-local' with 16 producer and 8 consumer thread, pinned =
to CPUs\n"
+"    benchmark -p16 -c8 -a count-local\n";
+
+static const struct argp_option opts[] =3D {
+	{ "list", 'l', NULL, 0, "List available benchmarks"},
+	{ "duration", 'd', "SEC", 0, "Duration of benchmark, seconds"},
+	{ "warmup", 'w', "SEC", 0, "Warm-up period, seconds"},
+	{ "producers", 'p', "NUM", 0, "Number of producer threads"},
+	{ "consumers", 'c', "NUM", 0, "Number of consumer threads"},
+	{ "verbose", 'v', NULL, 0, "Verbose debug output"},
+	{ "affinity", 'a', NULL, 0, "Set consumer/producer thread affinity"},
+	{ "b2b", 'b', NULL, 0, "Back-to-back mode"},
+	{ "rb-output", 10001, NULL, 0, "Set consumer/producer thread affinity"}=
,
+	{},
+};
+
+static error_t parse_arg(int key, char *arg, struct argp_state *state)
+{
+	static int pos_args;
+
+	switch (key) {
+	case 'v':
+		env.verbose =3D true;
+		break;
+	case 'l':
+		env.list =3D true;
+		break;
+	case 'd':
+		env.duration_sec =3D strtol(arg, NULL, 10);
+		if (env.duration_sec <=3D 0) {
+			fprintf(stderr, "Invalid duration: %s\n", arg);
+			argp_usage(state);
+		}
+		break;
+	case 'w':
+		env.warmup_sec =3D strtol(arg, NULL, 10);
+		if (env.warmup_sec <=3D 0) {
+			fprintf(stderr, "Invalid warm-up duration: %s\n", arg);
+			argp_usage(state);
+		}
+		break;
+	case 'p':
+		env.producer_cnt =3D strtol(arg, NULL, 10);
+		if (env.producer_cnt <=3D 0) {
+			fprintf(stderr, "Invalid producer count: %s\n", arg);
+			argp_usage(state);
+		}
+		break;
+	case 'c':
+		env.consumer_cnt =3D strtol(arg, NULL, 10);
+		if (env.consumer_cnt <=3D 0) {
+			fprintf(stderr, "Invalid consumer count: %s\n", arg);
+			argp_usage(state);
+		}
+		break;
+	case 'a':
+		env.affinity =3D true;
+		break;
+	case ARGP_KEY_ARG:
+		if (pos_args++) {
+			fprintf(stderr,
+				"Unrecognized positional argument: %s\n", arg);
+			argp_usage(state);
+		}
+		env.bench_name =3D strdup(arg);
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+	return 0;
+}
+
+static void parse_cmdline_args(int argc, char **argv)
+{
+	static const struct argp argp =3D {
+		.options =3D opts,
+		.parser =3D parse_arg,
+		.doc =3D argp_program_doc,
+	};
+	if (argp_parse(&argp, argc, argv, 0, NULL, NULL))
+		exit(1);
+	if (!env.list && !env.bench_name) {
+		argp_help(&argp, stderr, ARGP_HELP_DOC, "bench");
+		exit(1);
+	}
+}
+
+static void collect_measurements(long delta_ns);
+
+static __u64 last_time_ns;
+static void sigalarm_handler(int signo)
+{
+	long new_time_ns =3D get_time_ns();
+	long delta_ns =3D new_time_ns - last_time_ns;
+
+	collect_measurements(delta_ns);
+
+	last_time_ns =3D new_time_ns;
+}
+
+/* set up periodic 1-second timer */
+static void setup_timer()
+{
+	static struct sigaction sigalarm_action =3D {
+		.sa_handler =3D sigalarm_handler,
+	};
+	struct itimerval timer_settings =3D {};
+	int err;
+
+	last_time_ns =3D get_time_ns();
+	err =3D sigaction(SIGALRM, &sigalarm_action, NULL);
+	if (err < 0) {
+		fprintf(stderr, "failed to install SIGALARM handler: %d\n", -errno);
+		exit(1);
+	}
+	timer_settings.it_interval.tv_sec =3D 1;
+	timer_settings.it_value.tv_sec =3D 1;
+	err =3D setitimer(ITIMER_REAL, &timer_settings, NULL);
+	if (err < 0) {
+		fprintf(stderr, "failed to arm interval timer: %d\n", -errno);
+		exit(1);
+	}
+}
+
+static void set_thread_affinity(pthread_t thread, int cpu)
+{
+	cpu_set_t cpuset;
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(cpu, &cpuset);
+	if (pthread_setaffinity_np(thread, sizeof(cpuset), &cpuset)) {
+		fprintf(stderr, "setting affinity to CPU #%d failed: %d\n",
+			cpu, errno);
+		exit(1);
+	}
+}
+
+static struct bench_state {
+	int res_cnt;
+	struct bench_res *results;
+	pthread_t *consumers;
+	pthread_t *producers;
+} state;
+
+const struct bench *bench =3D NULL;
+
+extern const struct bench bench_count_global;
+extern const struct bench bench_count_local;
+
+static const struct bench *benchs[] =3D {
+	&bench_count_global,
+	&bench_count_local,
+};
+
+static void setup_benchmark()
+{
+	int i, err;
+
+	if (!env.bench_name) {
+		fprintf(stderr, "benchmark name is not specified\n");
+		exit(1);
+	}
+
+	for (i =3D 0; i < ARRAY_SIZE(benchs); i++) {
+		if (strcmp(benchs[i]->name, env.bench_name) =3D=3D 0) {
+			bench =3D benchs[i];
+			break;
+		}
+	}
+	if (!bench) {
+		fprintf(stderr, "benchmark '%s' not found\n", env.bench_name);
+		exit(1);
+	}
+
+	printf("Setting up benchmark '%s'...\n", bench->name);
+
+	state.producers =3D calloc(env.producer_cnt, sizeof(*state.producers));
+	state.consumers =3D calloc(env.consumer_cnt, sizeof(*state.consumers));
+	state.results =3D calloc(env.duration_sec + env.warmup_sec + 2,
+			       sizeof(*state.results));
+	if (!state.producers || !state.consumers || !state.results)
+		exit(1);
+
+	if (bench->validate)
+		bench->validate();
+	if (bench->setup)
+		bench->setup();
+
+	for (i =3D 0; i < env.consumer_cnt; i++) {
+		err =3D pthread_create(&state.consumers[i], NULL,
+				     bench->consumer_thread, (void *)(long)i);
+		if (err) {
+			fprintf(stderr, "failed to create consumer thread #%d: %d\n",
+				i, -errno);
+			exit(1);
+		}
+		if (env.affinity)
+			set_thread_affinity(state.consumers[i], i);
+	}
+	for (i =3D 0; i < env.producer_cnt; i++) {
+		err =3D pthread_create(&state.producers[i], NULL,
+				     bench->producer_thread, (void *)(long)i);
+		if (err) {
+			fprintf(stderr, "failed to create producer thread #%d: %d\n",
+				i, -errno);
+			exit(1);
+		}
+		if (env.affinity)
+			set_thread_affinity(state.producers[i],
+					    env.consumer_cnt + i);
+	}
+
+	printf("Benchmark '%s' started.\n", bench->name);
+}
+
+static pthread_mutex_t bench_done_mtx =3D PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t bench_done =3D PTHREAD_COND_INITIALIZER;
+
+static void collect_measurements(long delta_ns) {
+	int iter =3D state.res_cnt++;
+	struct bench_res *res =3D &state.results[iter];
+
+	bench->measure(res);
+
+	if (bench->report_progress)
+		bench->report_progress(iter, res, delta_ns);
+
+	if (iter =3D=3D env.duration_sec + env.warmup_sec) {
+		pthread_mutex_lock(&bench_done_mtx);
+		pthread_cond_signal(&bench_done);
+		pthread_mutex_unlock(&bench_done_mtx);
+	}
+}
+
+int main(int argc, char **argv)
+{
+	parse_cmdline_args(argc, argv);
+
+	if (env.list) {
+		int i;
+
+		printf("Available benchmarks:\n");
+		for (i =3D 0; i < ARRAY_SIZE(benchs); i++) {
+			printf("- %s\n", benchs[i]->name);
+		}
+		return 0;
+	}
+
+	setup_benchmark();
+
+	setup_timer();
+
+	pthread_mutex_lock(&bench_done_mtx);
+	pthread_cond_wait(&bench_done, &bench_done_mtx);
+	pthread_mutex_unlock(&bench_done_mtx);
+
+	if (bench->report_final)
+		/* skip first sample */
+		bench->report_final(state.results + env.warmup_sec,
+				    state.res_cnt - env.warmup_sec);
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/bpf/bench.h b/tools/testing/selftest=
s/bpf/bench.h
new file mode 100644
index 000000000000..08aa0c5b1177
--- /dev/null
+++ b/tools/testing/selftests/bpf/bench.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#pragma once
+#include <stdlib.h>
+#include <stdbool.h>
+#include <linux/err.h>
+#include <errno.h>
+#include <unistd.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <math.h>
+#include <time.h>
+#include <sys/syscall.h>
+
+struct env {
+	char *bench_name;
+	int duration_sec;
+	int warmup_sec;
+	bool verbose;
+	bool list;
+	bool back2back;
+	bool affinity;
+	int consumer_cnt;
+	int producer_cnt;
+};
+
+struct bench_res {
+	long hits;
+	long drops;
+};
+
+struct bench {
+	const char *name;
+	void (*validate)();
+	void (*setup)();
+	void *(*producer_thread)(void *ctx);
+	void *(*consumer_thread)(void *ctx);
+	void (*measure)(struct bench_res* res);
+	void (*report_progress)(int iter, struct bench_res* res, long delta_ns)=
;
+	void (*report_final)(struct bench_res res[], int res_cnt);
+};
+
+struct counter {
+	long value;
+} __attribute__((aligned(128)));
+
+extern struct env env;
+extern const struct bench *bench;
+
+void setup_libbpf();
+void hits_drops_report_progress(int iter, struct bench_res *res, long de=
lta_ns);
+void hits_drops_report_final(struct bench_res res[], int res_cnt);
+
+static inline __u64 get_time_ns() {
+	struct timespec t;
+
+	clock_gettime(CLOCK_MONOTONIC, &t);
+
+	return (u64)t.tv_sec * 1000000000 + t.tv_nsec;
+}
+
+static inline void atomic_inc(long *value)
+{
+	(void)__atomic_add_fetch(value, 1, __ATOMIC_RELAXED);
+}
+
+static inline void atomic_add(long *value, long n)
+{
+	(void)__atomic_add_fetch(value, n, __ATOMIC_RELAXED);
+}
+
+static inline long atomic_swap(long *value, long n)
+{
+	return __atomic_exchange_n(value, n, __ATOMIC_RELAXED);
+}
diff --git a/tools/testing/selftests/bpf/benchs/bench_count.c b/tools/tes=
ting/selftests/bpf/benchs/bench_count.c
new file mode 100644
index 000000000000..befba7a82643
--- /dev/null
+++ b/tools/testing/selftests/bpf/benchs/bench_count.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bench.h"
+
+/* COUNT-GLOBAL benchmark */
+
+static struct count_global_ctx {
+	struct counter hits;
+} count_global_ctx;
+
+static void *count_global_producer(void *input)
+{
+	struct count_global_ctx *ctx =3D &count_global_ctx;
+
+	while (true) {
+		atomic_inc(&ctx->hits.value);
+	}
+	return NULL;
+}
+
+static void *count_global_consumer(void *input)
+{
+	return NULL;
+}
+
+static void count_global_measure(struct bench_res *res)
+{
+	struct count_global_ctx *ctx =3D &count_global_ctx;
+
+	res->hits =3D atomic_swap(&ctx->hits.value, 0);
+}
+
+/* COUNT-local benchmark */
+
+static struct count_local_ctx {
+	struct counter *hits;
+} count_local_ctx;
+
+static void count_local_setup()
+{
+	struct count_local_ctx *ctx =3D &count_local_ctx;
+
+	ctx->hits =3D calloc(env.consumer_cnt, sizeof(*ctx->hits));
+	if (!ctx->hits)
+		exit(1);
+}
+
+static void *count_local_producer(void *input)
+{
+	struct count_local_ctx *ctx =3D &count_local_ctx;
+	int idx =3D (long)input;
+
+	while (true) {
+		atomic_inc(&ctx->hits[idx].value);
+	}
+	return NULL;
+}
+
+static void *count_local_consumer(void *input)
+{
+	return NULL;
+}
+
+static void count_local_measure(struct bench_res *res)
+{
+	struct count_local_ctx *ctx =3D &count_local_ctx;
+	int i;
+
+	for (i =3D 0; i < env.producer_cnt; i++) {
+		res->hits +=3D atomic_swap(&ctx->hits[i].value, 0);
+	}
+}
+
+const struct bench bench_count_global =3D {
+	.name =3D "count-global",
+	.producer_thread =3D count_global_producer,
+	.consumer_thread =3D count_global_consumer,
+	.measure =3D count_global_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
+
+const struct bench bench_count_local =3D {
+	.name =3D "count-local",
+	.setup =3D count_local_setup,
+	.producer_thread =3D count_local_producer,
+	.consumer_thread =3D count_local_consumer,
+	.measure =3D count_local_measure,
+	.report_progress =3D hits_drops_report_progress,
+	.report_final =3D hits_drops_report_final,
+};
--=20
2.24.1

