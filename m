Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17500272CF
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfEVXQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:16:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728802AbfEVXQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:16:44 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MND2An013639
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:16:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=iUYIynhmg5d8v3/lg7yS5geEDYkTS8VfTDmyW8dt1gM=;
 b=Mz9U5toLyCTj0N5Ps1gI9+Q0Wv3Mkf1ygKTiUUSZRpDGdQ2S5DggMohooAnx38rIfUKv
 eY2kR/jcv8+QNXsJyXxcZ+mr+ybzQI7UzanEIcuigctyR/mdrF7Nb6b3NmOHTxG7CHQl
 I7AlG4l6/wu3KDGA7llmQ5AhoLTR5/2wHxc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn9bgsp82-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:16:43 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 22 May 2019 16:16:41 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 3A0433702482; Wed, 22 May 2019 16:16:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 3/3] tools/bpf: add selftest in test_progs for bpf_send_signal() helper
Date:   Wed, 22 May 2019 16:16:39 -0700
Message-ID: <20190522231639.506052-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522231636.505712-1-yhs@fb.com>
References: <20190522231636.505712-1-yhs@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test covered both nmi and tracepoint perf events.
  $ ./test_progs
  ...
  test_send_signal_tracepoint:PASS:tracepoint 0 nsec
  ...
  test_send_signal_common:PASS:tracepoint 0 nsec
  ...
  test_send_signal_common:PASS:perf_event 0 nsec
  ...
  test_send_signal:OK

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/testing/selftests/bpf/bpf_helpers.h     |   1 +
 .../selftests/bpf/prog_tests/send_signal.c    | 193 ++++++++++++++++++
 .../bpf/progs/test_send_signal_kern.c         |  51 +++++
 3 files changed, 245 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/send_signal.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_send_signal_kern.c

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 5f6f9e7aba2a..cb02521b8e58 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -216,6 +216,7 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 	(void *) BPF_FUNC_sk_storage_get;
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
+static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools/testing/selftests/bpf/prog_tests/send_signal.c
new file mode 100644
index 000000000000..ff2cabd3d8c4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+static volatile int sigusr1_received = 0;
+
+static void sigusr1_handler(int signum)
+{
+	sigusr1_received++;
+}
+
+static int test_send_signal_common(struct perf_event_attr *attr,
+				    int prog_type,
+				    const char *test_name)
+{
+	int err = -1, pmu_fd, prog_fd, info_map_fd, status_map_fd;
+	const char *file = "./test_send_signal_kern.o";
+	struct bpf_object *obj = NULL;
+	int pipe_c2p[2], pipe_p2c[2];
+	__u32 key = 0, duration = 0;
+	char buf[256];
+	pid_t pid;
+	__u64 val;
+
+	if (CHECK(pipe(pipe_c2p), test_name,
+		  "pipe pipe_c2p error: %s\n", strerror(errno)))
+		goto no_fork_done;
+
+	if (CHECK(pipe(pipe_p2c), test_name,
+		  "pipe pipe_p2c error: %s\n", strerror(errno))) {
+		close(pipe_c2p[0]);
+		close(pipe_c2p[1]);
+		goto no_fork_done;
+	}
+
+	pid = fork();
+	if (CHECK(pid < 0, test_name, "fork error: %s\n", strerror(errno))) {
+		close(pipe_c2p[0]);
+		close(pipe_c2p[1]);
+		close(pipe_p2c[0]);
+		close(pipe_p2c[1]);
+		goto no_fork_done;
+	}
+
+	if (pid == 0) {
+		/* install signal handler and notify parent */
+		signal(SIGUSR1, sigusr1_handler);
+
+		close(pipe_c2p[0]); /* close read */
+		close(pipe_p2c[1]); /* close write */
+
+		/* notify parent signal handler is installed */
+		write(pipe_c2p[1], buf, 1);
+
+		/* make sense parent enabled bpf program to send_signal */
+		read(pipe_p2c[0], buf, 1);
+
+		/* wait a little for signal handler */
+		sleep(1);
+
+		if (sigusr1_received)
+			write(pipe_c2p[1], "2", 1);
+		else
+			write(pipe_c2p[1], "0", 1);
+
+		/* wait for parent notification and exit */
+		read(pipe_p2c[0], buf, 1);
+
+		close(pipe_c2p[1]);
+		close(pipe_p2c[0]);
+		exit(0);
+	}
+
+	close(pipe_c2p[1]); /* close write */
+	close(pipe_p2c[0]); /* close read */
+
+	err = bpf_prog_load(file, prog_type, &obj, &prog_fd);
+	if (CHECK(err < 0, test_name, "bpf_prog_load error: %s\n",
+		  strerror(errno)))
+		goto prog_load_failure;
+
+	pmu_fd = syscall(__NR_perf_event_open, attr, pid, -1,
+			 -1 /* group id */, 0 /* flags */);
+	if (CHECK(pmu_fd < 0, test_name, "perf_event_open error: %s\n",
+		  strerror(errno))) {
+		err = -1;
+		goto close_prog;
+	}
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK(err < 0, test_name, "ioctl perf_event_ioc_enable error: %s\n",
+		  strerror(errno)))
+		goto disable_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK(err < 0, test_name, "ioctl perf_event_ioc_set_bpf error: %s\n",
+		  strerror(errno)))
+		goto disable_pmu;
+
+	err = -1;
+	info_map_fd = bpf_object__find_map_fd_by_name(obj, "info_map");
+	if (CHECK(info_map_fd < 0, test_name, "find map %s error\n", "info_map"))
+		goto disable_pmu;
+
+	status_map_fd = bpf_object__find_map_fd_by_name(obj, "status_map");
+	if (CHECK(status_map_fd < 0, test_name, "find map %s error\n", "status_map"))
+		goto disable_pmu;
+
+	/* wait until child signal handler installed */
+	read(pipe_c2p[0], buf, 1);
+
+	/* trigger the bpf send_signal */
+	key = 0;
+	val = (((__u64)(SIGUSR1)) << 32) | pid;
+	bpf_map_update_elem(info_map_fd, &key, &val, 0);
+
+	/* notify child that bpf program can send_signal now */
+	write(pipe_p2c[1], buf, 1);
+
+	/* wait for result */
+	read(pipe_c2p[0], buf, 1);
+
+	err = CHECK(buf[0] != '2', test_name, "incorrect result\n");
+
+	/* notify child safe to exit */
+	write(pipe_p2c[1], buf, 1);
+
+disable_pmu:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+prog_load_failure:
+	close(pipe_c2p[0]);
+	close(pipe_p2c[1]);
+	wait(NULL);
+no_fork_done:
+	return err;
+}
+
+static int test_send_signal_tracepoint(void)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_TRACEPOINT,
+		.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_CALLCHAIN,
+		.sample_period = 1,
+		.wakeup_events = 1,
+	};
+	__u32 duration = 0;
+	int bytes, efd;
+	char buf[256];
+
+	snprintf(buf, sizeof(buf),
+		 "/sys/kernel/debug/tracing/events/syscalls/sys_enter_nanosleep/id");
+	efd = open(buf, O_RDONLY, 0);
+	if (CHECK(efd < 0, "tracepoint",
+		  "open syscalls/sys_enter_nanosleep/id failure: %s\n",
+		  strerror(errno)))
+		return -1;
+
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "tracepoint",
+		  "read syscalls/sys_enter_nanosleep/id failure: %s\n",
+		  strerror(errno)))
+		return -1;
+
+	attr.config = strtol(buf, NULL, 0);
+
+	return test_send_signal_common(&attr, BPF_PROG_TYPE_TRACEPOINT, "tracepoint");
+}
+
+static int test_send_signal_nmi(void)
+{
+	struct perf_event_attr attr = {
+		.sample_freq = 50,
+		.freq = 1,
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_CPU_CYCLES,
+	};
+
+	return test_send_signal_common(&attr, BPF_PROG_TYPE_PERF_EVENT, "perf_event");
+}
+
+void test_send_signal(void)
+{
+	int ret = 0;
+
+	ret |= test_send_signal_tracepoint();
+	ret |= test_send_signal_nmi();
+	if (!ret)
+		printf("test_send_signal:OK\n");
+	else
+		printf("test_send_signal:FAIL\n");
+}
diff --git a/tools/testing/selftests/bpf/progs/test_send_signal_kern.c b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
new file mode 100644
index 000000000000..45a1a1a2c345
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_send_signal_kern.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/bpf.h>
+#include <linux/version.h>
+#include "bpf_helpers.h"
+
+struct bpf_map_def SEC("maps") info_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u64),
+	.max_entries = 1,
+};
+
+BPF_ANNOTATE_KV_PAIR(info_map, __u32, __u64);
+
+struct bpf_map_def SEC("maps") status_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u64),
+	.max_entries = 1,
+};
+
+BPF_ANNOTATE_KV_PAIR(status_map, __u32, __u64);
+
+SEC("send_signal_demo")
+int bpf_send_signal_test(void *ctx)
+{
+	__u64 *info_val, *status_val;
+	__u32 key = 0, pid, sig;
+	int ret;
+
+	status_val = bpf_map_lookup_elem(&status_map, &key);
+	if (!status_val || *status_val != 0)
+		return 0;
+
+	info_val = bpf_map_lookup_elem(&info_map, &key);
+	if (!info_val || *info_val == 0)
+		return 0;
+
+	sig = *info_val >> 32;
+	pid = *info_val & 0xffffFFFF;
+
+	if ((bpf_get_current_pid_tgid() >> 32) == pid) {
+		ret = bpf_send_signal(sig);
+		if (ret == 0)
+			*status_val = 1;
+	}
+
+	return 0;
+}
+char __license[] SEC("license") = "GPL";
-- 
2.17.1

