Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439724DDAE
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 01:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfFTXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 19:10:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbfFTXKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 19:10:30 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KN6qra020995
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=7WiuzXGPcyjb/Y/cjmhxDi2935+jdaqDqmdrkkZdOKE=;
 b=JqnZik8IolqIFvI7aa8xGNQOq4vjbmxoPPcGeU6cuNcv3HI3l8nPa6E5hoI3jt+HYi+4
 giQfHrb5fuuALecxzI3hBQ+2N8zg4o/BfiTOsjg1z181b+ok1tOdbDzbQivaJ5BTFi9t
 rler3YG2KZtCk91ZAXXm+S1zXggCblrQ/6o= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2t8aj9a3gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 16:10:29 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Jun 2019 16:10:28 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 7E81186173D; Thu, 20 Jun 2019 16:10:26 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 7/7] selftests/bpf: convert existing tracepoint tests to new APIs
Date:   Thu, 20 Jun 2019 16:09:51 -0700
Message-ID: <20190620230951.3155955-8-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190620230951.3155955-1-andriin@fb.com>
References: <20190620230951.3155955-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert existing tests that attach to tracepoints to use
bpf_program__attach_tracepoint API instead.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/prog_tests/stacktrace_build_id.c      | 49 +++-------------
 .../selftests/bpf/prog_tests/stacktrace_map.c | 42 +++-----------
 .../bpf/prog_tests/stacktrace_map_raw_tp.c    | 14 ++++-
 .../bpf/prog_tests/task_fd_query_rawtp.c      | 10 +++-
 .../bpf/prog_tests/task_fd_query_tp.c         | 51 +++++------------
 .../bpf/prog_tests/tp_attach_query.c          | 56 ++++++-------------
 6 files changed, 65 insertions(+), 157 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index 3aab2b083c71..9ef3b66f3644 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -4,10 +4,11 @@
 void test_stacktrace_build_id(void)
 {
 	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
+	const char *prog_name = "tracepoint/random/urandom_read";
 	const char *file = "./test_stacktrace_build_id.o";
-	int bytes, efd, err, pmu_fd, prog_fd, stack_trace_len;
-	struct perf_event_attr attr = {};
+	int err, pmu_fd, prog_fd, stack_trace_len;
 	__u32 key, previous_key, val, duration = 0;
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char buf[256];
 	int i, j;
@@ -20,42 +21,14 @@ void test_stacktrace_build_id(void)
 	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
 		goto out;
 
-	/* Get the ID for the sched/sched_switch tracepoint */
-	snprintf(buf, sizeof(buf),
-		 "/sys/kernel/debug/tracing/events/random/urandom_read/id");
-	efd = open(buf, O_RDONLY, 0);
-	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
 		goto close_prog;
 
-	bytes = read(efd, buf, sizeof(buf));
-	close(efd);
-	if (CHECK(bytes <= 0 || bytes >= sizeof(buf),
-		  "read", "bytes %d errno %d\n", bytes, errno))
+	pmu_fd = bpf_program__attach_tracepoint(prog, "random", "urandom_read");
+	if (CHECK(pmu_fd < 0, "attach_tp", "err %d\n", pmu_fd))
 		goto close_prog;
 
-	/* Open the perf event and attach bpf progrram */
-	attr.config = strtol(buf, NULL, 0);
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN;
-	attr.sample_period = 1;
-	attr.wakeup_events = 1;
-	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
-			 0 /* cpu 0 */, -1 /* group id */,
-			 0 /* flags */);
-	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
-		  pmu_fd, errno))
-		goto close_prog;
-
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
-	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
-		  err, errno))
-		goto close_pmu;
-
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
-	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
-		  err, errno))
-		goto disable_pmu;
-
 	/* find map fds */
 	control_map_fd = bpf_find_map(__func__, obj, "control_map");
 	if (CHECK(control_map_fd < 0, "bpf_find_map control_map",
@@ -133,8 +106,7 @@ void test_stacktrace_build_id(void)
 	 * try it one more time.
 	 */
 	if (build_id_matches < 1 && retry--) {
-		ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-		close(pmu_fd);
+		libbpf_perf_event_disable_and_close(pmu_fd);
 		bpf_object__close(obj);
 		printf("%s:WARN:Didn't find expected build ID from the map, retrying\n",
 		       __func__);
@@ -152,10 +124,7 @@ void test_stacktrace_build_id(void)
 	      "err %d errno %d\n", err, errno);
 
 disable_pmu:
-	ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-
-close_pmu:
-	close(pmu_fd);
+	libbpf_perf_event_disable_and_close(pmu_fd);
 
 close_prog:
 	bpf_object__close(obj);
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
index 2bfd50a0d6d1..df0716e69b96 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map.c
@@ -4,50 +4,25 @@
 void test_stacktrace_map(void)
 {
 	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
+	const char *prog_name = "tracepoint/sched/sched_switch";
+	int efd, err, prog_fd, stack_trace_len;
 	const char *file = "./test_stacktrace_map.o";
-	int bytes, efd, err, pmu_fd, prog_fd, stack_trace_len;
-	struct perf_event_attr attr = {};
 	__u32 key, val, duration = 0;
+	struct bpf_program *prog;
 	struct bpf_object *obj;
-	char buf[256];
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
 	if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
 		return;
 
-	/* Get the ID for the sched/sched_switch tracepoint */
-	snprintf(buf, sizeof(buf),
-		 "/sys/kernel/debug/tracing/events/sched/sched_switch/id");
-	efd = open(buf, O_RDONLY, 0);
-	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
 		goto close_prog;
 
-	bytes = read(efd, buf, sizeof(buf));
-	close(efd);
-	if (bytes <= 0 || bytes >= sizeof(buf))
-		goto close_prog;
-
-	/* Open the perf event and attach bpf progrram */
-	attr.config = strtol(buf, NULL, 0);
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN;
-	attr.sample_period = 1;
-	attr.wakeup_events = 1;
-	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
-			 0 /* cpu 0 */, -1 /* group id */,
-			 0 /* flags */);
-	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
-		  pmu_fd, errno))
+	efd = bpf_program__attach_tracepoint(prog, "sched", "sched_switch");
+	if (CHECK(efd < 0, "attach_tp", "err %d\n", efd))
 		goto close_prog;
 
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
-	if (err)
-		goto disable_pmu;
-
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
-	if (err)
-		goto disable_pmu;
-
 	/* find map fds */
 	control_map_fd = bpf_find_map(__func__, obj, "control_map");
 	if (control_map_fd < 0)
@@ -96,8 +71,7 @@ void test_stacktrace_map(void)
 disable_pmu:
 	error_cnt++;
 disable_pmu_noerr:
-	ioctl(pmu_fd, PERF_EVENT_IOC_DISABLE);
-	close(pmu_fd);
+	close(efd);
 close_prog:
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
index 1f8387d80fd7..4d14a08b1d99 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_map_raw_tp.c
@@ -3,18 +3,24 @@
 
 void test_stacktrace_map_raw_tp(void)
 {
+	const char *prog_name = "tracepoint/sched/sched_switch";
 	int control_map_fd, stackid_hmap_fd, stackmap_fd;
 	const char *file = "./test_stacktrace_map.o";
-	int efd, err, prog_fd;
 	__u32 key, val, duration = 0;
+	int efd = -1, err, prog_fd;
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 
 	err = bpf_prog_load(file, BPF_PROG_TYPE_RAW_TRACEPOINT, &obj, &prog_fd);
 	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
 		return;
 
-	efd = bpf_raw_tracepoint_open("sched_switch", prog_fd);
-	if (CHECK(efd < 0, "raw_tp_open", "err %d errno %d\n", efd, errno))
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
+		goto close_prog;
+
+	efd = bpf_program__attach_raw_tracepoint(prog, "sched_switch");
+	if (CHECK(efd < 0, "attach_raw_tp", "err %d\n", efd))
 		goto close_prog;
 
 	/* find map fds */
@@ -55,5 +61,7 @@ void test_stacktrace_map_raw_tp(void)
 close_prog:
 	error_cnt++;
 close_prog_noerr:
+	if (efd >= 0)
+		close(efd);
 	bpf_object__close(obj);
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c b/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
index 958a3d88de99..6ad73cb8c7e3 100644
--- a/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
+++ b/tools/testing/selftests/bpf/prog_tests/task_fd_query_rawtp.c
@@ -3,9 +3,11 @@
 
 void test_task_fd_query_rawtp(void)
 {
+	const char *prog_name = "tracepoint/raw_syscalls/sys_enter";
 	const char *file = "./test_get_stack_rawtp.o";
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 	int efd, err, prog_fd;
 	__u32 duration = 0;
@@ -15,8 +17,12 @@ void test_task_fd_query_rawtp(void)
 	if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
 		return;
 
-	efd = bpf_raw_tracepoint_open("sys_enter", prog_fd);
-	if (CHECK(efd < 0, "raw_tp_open", "err %d errno %d\n", efd, errno))
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
+		goto close_prog;
+
+	efd = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+	if (CHECK(efd < 0, "attach_raw_tp", "err %d\n", efd))
 		goto close_prog;
 
 	/* query (getpid(), efd) */
diff --git a/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c b/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
index f9b70e81682b..034870692636 100644
--- a/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
+++ b/tools/testing/selftests/bpf/prog_tests/task_fd_query_tp.c
@@ -1,15 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 
-static void test_task_fd_query_tp_core(const char *probe_name,
+static void test_task_fd_query_tp_core(const char *tp_category,
 				       const char *tp_name)
 {
+	const char *prog_name = "tracepoint/sched/sched_switch";
 	const char *file = "./test_tracepoint.o";
-	int err, bytes, efd, prog_fd, pmu_fd;
-	struct perf_event_attr attr = {};
 	__u64 probe_offset, probe_addr;
 	__u32 len, prog_id, fd_type;
+	int err, prog_fd, pmu_fd;
 	struct bpf_object *obj = NULL;
+	struct bpf_program *prog;
 	__u32 duration = 0;
 	char buf[256];
 
@@ -17,37 +18,13 @@ static void test_task_fd_query_tp_core(const char *probe_name,
 	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
 		goto close_prog;
 
-	snprintf(buf, sizeof(buf),
-		 "/sys/kernel/debug/tracing/events/%s/id", probe_name);
-	efd = open(buf, O_RDONLY, 0);
-	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
 		goto close_prog;
-	bytes = read(efd, buf, sizeof(buf));
-	close(efd);
-	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
-		  "bytes %d errno %d\n", bytes, errno))
-		goto close_prog;
-
-	attr.config = strtol(buf, NULL, 0);
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.sample_type = PERF_SAMPLE_RAW;
-	attr.sample_period = 1;
-	attr.wakeup_events = 1;
-	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
-			 0 /* cpu 0 */, -1 /* group id */,
-			 0 /* flags */);
-	if (CHECK(err, "perf_event_open", "err %d errno %d\n", err, errno))
-		goto close_pmu;
 
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
-	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
-		  errno))
-		goto close_pmu;
-
-	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
-	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
-		  errno))
-		goto close_pmu;
+	pmu_fd = bpf_program__attach_tracepoint(prog, tp_category, tp_name);
+	if (CHECK(pmu_fd < 0, "attach_tp", "err %d\n", pmu_fd))
+		goto close_prog;
 
 	/* query (getpid(), pmu_fd) */
 	len = sizeof(buf);
@@ -62,11 +39,11 @@ static void test_task_fd_query_tp_core(const char *probe_name,
 		  fd_type, buf))
 		goto close_pmu;
 
-	close(pmu_fd);
+	libbpf_perf_event_disable_and_close(pmu_fd);
 	goto close_prog_noerr;
 
 close_pmu:
-	close(pmu_fd);
+	libbpf_perf_event_disable_and_close(pmu_fd);
 close_prog:
 	error_cnt++;
 close_prog_noerr:
@@ -75,8 +52,6 @@ static void test_task_fd_query_tp_core(const char *probe_name,
 
 void test_task_fd_query_tp(void)
 {
-	test_task_fd_query_tp_core("sched/sched_switch",
-				   "sched_switch");
-	test_task_fd_query_tp_core("syscalls/sys_enter_read",
-				   "sys_enter_read");
+	test_task_fd_query_tp_core("sched", "sched_switch");
+	test_task_fd_query_tp_core("syscalls", "sys_enter_read");
 }
diff --git a/tools/testing/selftests/bpf/prog_tests/tp_attach_query.c b/tools/testing/selftests/bpf/prog_tests/tp_attach_query.c
index fb095e5cd9af..5e129eb3eb47 100644
--- a/tools/testing/selftests/bpf/prog_tests/tp_attach_query.c
+++ b/tools/testing/selftests/bpf/prog_tests/tp_attach_query.c
@@ -6,9 +6,9 @@ void test_tp_attach_query(void)
 	const int num_progs = 3;
 	int i, j, bytes, efd, err, prog_fd[num_progs], pmu_fd[num_progs];
 	__u32 duration = 0, info_len, saved_prog_ids[num_progs];
+	const char *prog_name = "tracepoint/sched/sched_switch";
 	const char *file = "./test_tracepoint.o";
 	struct perf_event_query_bpf *query;
-	struct perf_event_attr attr = {};
 	struct bpf_object *obj[num_progs];
 	struct bpf_prog_info prog_info;
 	char buf[256];
@@ -27,19 +27,19 @@ void test_tp_attach_query(void)
 		  "read", "bytes %d errno %d\n", bytes, errno))
 		return;
 
-	attr.config = strtol(buf, NULL, 0);
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN;
-	attr.sample_period = 1;
-	attr.wakeup_events = 1;
-
 	query = malloc(sizeof(*query) + sizeof(__u32) * num_progs);
 	for (i = 0; i < num_progs; i++) {
+		struct bpf_program *prog;
+
 		err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj[i],
 				    &prog_fd[i]);
 		if (CHECK(err, "prog_load", "err %d errno %d\n", err, errno))
 			goto cleanup1;
 
+		prog = bpf_object__find_program_by_title(obj[i], prog_name);
+		if (CHECK(!prog, "find_prog", "prog '%s' not found\n", prog_name))
+			goto cleanup1;
+
 		bzero(&prog_info, sizeof(prog_info));
 		prog_info.jited_prog_len = 0;
 		prog_info.xlated_prog_len = 0;
@@ -51,32 +51,10 @@ void test_tp_attach_query(void)
 			goto cleanup1;
 		saved_prog_ids[i] = prog_info.id;
 
-		pmu_fd[i] = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
-				    0 /* cpu 0 */, -1 /* group id */,
-				    0 /* flags */);
-		if (CHECK(pmu_fd[i] < 0, "perf_event_open", "err %d errno %d\n",
-			  pmu_fd[i], errno))
+		pmu_fd[i] = bpf_program__attach_tracepoint(prog, "sched",
+							   "sched_switch");
+		if (CHECK(pmu_fd[i] < 0, "attach_tp", "err %d\n", pmu_fd[i]))
 			goto cleanup2;
-		err = ioctl(pmu_fd[i], PERF_EVENT_IOC_ENABLE, 0);
-		if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n",
-			  err, errno))
-			goto cleanup3;
-
-		if (i == 0) {
-			/* check NULL prog array query */
-			query->ids_len = num_progs;
-			err = ioctl(pmu_fd[i], PERF_EVENT_IOC_QUERY_BPF, query);
-			if (CHECK(err || query->prog_cnt != 0,
-				  "perf_event_ioc_query_bpf",
-				  "err %d errno %d query->prog_cnt %u\n",
-				  err, errno, query->prog_cnt))
-				goto cleanup3;
-		}
-
-		err = ioctl(pmu_fd[i], PERF_EVENT_IOC_SET_BPF, prog_fd[i]);
-		if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n",
-			  err, errno))
-			goto cleanup3;
 
 		if (i == 1) {
 			/* try to get # of programs only */
@@ -86,7 +64,7 @@ void test_tp_attach_query(void)
 				  "perf_event_ioc_query_bpf",
 				  "err %d errno %d query->prog_cnt %u\n",
 				  err, errno, query->prog_cnt))
-				goto cleanup3;
+				goto cleanup2;
 
 			/* try a few negative tests */
 			/* invalid query pointer */
@@ -95,7 +73,7 @@ void test_tp_attach_query(void)
 			if (CHECK(!err || errno != EFAULT,
 				  "perf_event_ioc_query_bpf",
 				  "err %d errno %d\n", err, errno))
-				goto cleanup3;
+				goto cleanup2;
 
 			/* no enough space */
 			query->ids_len = 1;
@@ -104,7 +82,7 @@ void test_tp_attach_query(void)
 				  "perf_event_ioc_query_bpf",
 				  "err %d errno %d query->prog_cnt %u\n",
 				  err, errno, query->prog_cnt))
-				goto cleanup3;
+				goto cleanup2;
 		}
 
 		query->ids_len = num_progs;
@@ -113,21 +91,19 @@ void test_tp_attach_query(void)
 			  "perf_event_ioc_query_bpf",
 			  "err %d errno %d query->prog_cnt %u\n",
 			  err, errno, query->prog_cnt))
-			goto cleanup3;
+			goto cleanup2;
 		for (j = 0; j < i + 1; j++)
 			if (CHECK(saved_prog_ids[j] != query->ids[j],
 				  "perf_event_ioc_query_bpf",
 				  "#%d saved_prog_id %x query prog_id %x\n",
 				  j, saved_prog_ids[j], query->ids[j]))
-				goto cleanup3;
+				goto cleanup2;
 	}
 
 	i = num_progs - 1;
 	for (; i >= 0; i--) {
- cleanup3:
-		ioctl(pmu_fd[i], PERF_EVENT_IOC_DISABLE);
  cleanup2:
-		close(pmu_fd[i]);
+		libbpf_perf_event_disable_and_close(pmu_fd[i]);
  cleanup1:
 		bpf_object__close(obj[i]);
 	}
-- 
2.17.1

