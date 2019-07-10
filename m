Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B435364BD0
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbfGJSAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:00:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43488 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727546AbfGJSAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:00:30 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AHwsA7001508
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6WEzr//yaDglSJhUOKkjNMmHDEmGgaj3M7ezL/S0PGM=;
 b=XMhi3ivE86qgix1yKqGYD2IVERtcjFjHAf1jFDsfnrsuY4NJumrzOw4Dx9GkMirG5gLn
 iw/3qpJu4fbpeyWCyR7wnR1gCvVgXKBsb6gzzUcIOyqq/CDWVyWsENDE7vWrRSGlt53J
 8/UD9jRD7mR/5tw1TnxA9x5aKkOrVZrfKPY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tnj4ts8um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:27 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 10 Jul 2019 11:00:26 -0700
Received: by devvm424.lla2.facebook.com (Postfix, from userid 134475)
        id D791111FAA304; Wed, 10 Jul 2019 11:00:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Javier Honduvilla Coto <javierhonduco@fb.com>
Smtp-Origin-Hostname: devvm424.lla2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <yhs@fb.com>, <kernel-team@fb.com>, <jonhaslam@fb.com>
Smtp-Origin-Cluster: lla2c09
Subject: [PATCH v6 bpf-next 3/3] bpf: add tests for bpf_descendant_of
Date:   Wed, 10 Jul 2019 11:00:25 -0700
Message-ID: <20190710180025.94726-4-javierhonduco@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190710180025.94726-1-javierhonduco@fb.com>
References: <20190410203631.1576576-1-javierhonduco@fb.com>
 <20190710180025.94726-1-javierhonduco@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100203
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the following test cases:

- bpf_descendant_of(current->pid) == 1
- bpf_descendant_of(current->real_parent->pid) == 1
- bpf_descendant_of(1) == 1
- bpf_descendant_of(0) == 1

- bpf_descendant_of(-1) == 0
- bpf_descendant_of(current->children[0]->pid) == 0

Signed-off-by: Javier Honduvilla Coto <javierhonduco@fb.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 .../bpf/progs/test_descendant_of_kern.c       |  43 +++
 .../selftests/bpf/test_descendant_of_user.c   | 266 ++++++++++++++++++
 5 files changed, 314 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_descendant_of_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_descendant_of_user.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 90f70d2c7c22..4b63d7105ba2 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -43,3 +43,4 @@ test_sockopt
 test_sockopt_sk
 test_sockopt_multi
 test_tcp_rtt
+test_descendant_of_user
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2620406a53ec..b3dc1e26c41c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -27,7 +27,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_cgroup_storage test_select_reuseport test_section_names \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
 	test_btf_dump test_cgroup_attach xdping test_sockopt test_sockopt_sk \
-	test_sockopt_multi test_tcp_rtt
+	test_sockopt_multi test_tcp_rtt test_descendant_of_user
 
 BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
 TEST_GEN_FILES = $(BPF_OBJ_FILES)
diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 5a3d92c8bec8..7525783ffbc9 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -1,4 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <sys/types.h>
+
 #ifndef __BPF_HELPERS_H
 #define __BPF_HELPERS_H
 
@@ -228,6 +230,7 @@ static void *(*bpf_sk_storage_get)(void *map, struct bpf_sock *sk,
 static int (*bpf_sk_storage_delete)(void *map, struct bpf_sock *sk) =
 	(void *)BPF_FUNC_sk_storage_delete;
 static int (*bpf_send_signal)(unsigned sig) = (void *)BPF_FUNC_send_signal;
+static int (*bpf_descendant_of)(pid_t pid) = (void *) BPF_FUNC_descendant_of;
 
 /* llvm builtin functions that eBPF C program may use to
  * emit BPF_LD_ABS and BPF_LD_IND instructions
diff --git a/tools/testing/selftests/bpf/progs/test_descendant_of_kern.c b/tools/testing/selftests/bpf/progs/test_descendant_of_kern.c
new file mode 100644
index 000000000000..802e01595527
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_descendant_of_kern.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct bpf_map_def SEC("maps") pidmap = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 2,
+};
+
+struct bpf_map_def SEC("maps") resultmap = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32),
+	.max_entries = 1,
+};
+
+SEC("tracepoint/syscalls/sys_enter_open")
+int trace(void *ctx)
+{
+	__u32 pid = bpf_get_current_pid_tgid();
+	__u32 current_key = 0, ancestor_key = 1, *expected_pid, *ancestor_pid;
+	__u32 *val;
+
+	expected_pid = bpf_map_lookup_elem(&pidmap, &current_key);
+	if (!expected_pid || *expected_pid != pid)
+		return 0;
+
+	ancestor_pid = bpf_map_lookup_elem(&pidmap, &ancestor_key);
+	if (!ancestor_pid)
+		return 0;
+
+	val = bpf_map_lookup_elem(&resultmap, &current_key);
+	if (val)
+		*val = bpf_descendant_of(*ancestor_pid);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_descendant_of_user.c b/tools/testing/selftests/bpf/test_descendant_of_user.c
new file mode 100644
index 000000000000..f616c8c976a4
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_descendant_of_user.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <syscall.h>
+#include <unistd.h>
+#include <linux/perf_event.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define CHECK(condition, tag, format...)                                       \
+	({                                                                     \
+		int __ret = !!(condition);                                     \
+		if (__ret) {                                                   \
+			printf("%s:FAIL:%s ", __func__, tag);                  \
+			printf(format);                                        \
+		} else {                                                       \
+			printf("%s:PASS:%s\n", __func__, tag);                 \
+		}                                                              \
+		__ret;                                                         \
+	})
+
+static int bpf_find_map(const char *test, struct bpf_object *obj,
+			const char *name)
+{
+	struct bpf_map *map;
+
+	map = bpf_object__find_map_by_name(obj, name);
+	if (!map)
+		return -1;
+	return bpf_map__fd(map);
+}
+
+int main(int argc, char **argv)
+{
+	const char *probe_name = "syscalls/sys_enter_open";
+	const char *file = "test_descendant_of_kern.o";
+	int err, bytes, efd, prog_fd, pmu_fd;
+	int resultmap_fd, pidmap_fd;
+	struct perf_event_attr attr = {};
+	struct bpf_object *obj;
+	__u32 descendant_of_result = 0;
+	__u32 key = 0, pid;
+	int exit_code = EXIT_FAILURE;
+	char buf[256];
+
+	int child_pid, ancestor_pid, root_fd, nonexistant = -42;
+	__u32 ancestor_key = 1;
+	int pipefd[2];
+	char marker[1];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_TRACEPOINT, &obj, &prog_fd);
+	if (CHECK(err, "bpf_prog_load", "err %d errno %d\n", err, errno))
+		goto fail;
+
+	resultmap_fd = bpf_find_map(__func__, obj, "resultmap");
+	if (CHECK(resultmap_fd < 0, "bpf_find_map", "err %d errno %d\n",
+		  resultmap_fd, errno))
+		goto close_prog;
+
+	pidmap_fd = bpf_find_map(__func__, obj, "pidmap");
+	if (CHECK(pidmap_fd < 0, "bpf_find_map", "err %d errno %d\n", pidmap_fd,
+		  errno))
+		goto close_prog;
+
+	pid = getpid();
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+	bpf_map_update_elem(pidmap_fd, &ancestor_key, &pid, 0);
+
+	snprintf(buf, sizeof(buf), "/sys/kernel/debug/tracing/events/%s/id",
+		 probe_name);
+	efd = open(buf, O_RDONLY, 0);
+	if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
+		goto close_prog;
+	bytes = read(efd, buf, sizeof(buf));
+	close(efd);
+	if (CHECK(bytes <= 0 || bytes >= sizeof(buf), "read",
+		  "bytes %d errno %d\n", bytes, errno))
+		goto close_prog;
+
+	attr.config = strtol(buf, NULL, 0);
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.sample_type = PERF_SAMPLE_RAW;
+	attr.sample_period = 1;
+	attr.wakeup_events = 1;
+
+	pmu_fd = syscall(__NR_perf_event_open, &attr, getpid(), -1, -1, 0);
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n", pmu_fd,
+		  errno))
+		goto close_prog;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
+	if (CHECK(err, "perf_event_ioc_enable", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	err = ioctl(pmu_fd, PERF_EVENT_IOC_SET_BPF, prog_fd);
+	if (CHECK(err, "perf_event_ioc_set_bpf", "err %d errno %d\n", err,
+		  errno))
+		goto close_pmu;
+
+	// Test that descendant_of(current->pid) is true
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+	bpf_map_update_elem(pidmap_fd, &ancestor_key, &pid, 0);
+	bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
+
+	root_fd = open("/", O_RDONLY);
+	if (CHECK(efd < 0, "open", "errno %d\n", errno))
+		goto close_prog;
+	close(root_fd);
+
+	err = bpf_map_lookup_elem(resultmap_fd, &key, &descendant_of_result);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+	if (CHECK(descendant_of_result != 1,
+		  "descendant_of is true with same pid", "%d == %d\n",
+		  descendant_of_result, 1))
+		goto close_pmu;
+
+	// Test that PID 1 an ancestor
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+	ancestor_pid = 1;
+	bpf_map_update_elem(pidmap_fd, &ancestor_key, &ancestor_pid, 0);
+	bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
+
+	root_fd = open("/", O_RDONLY);
+	if (CHECK(efd < 0, "open", "errno %d\n", errno))
+		goto close_prog;
+	close(root_fd);
+
+	err = bpf_map_lookup_elem(resultmap_fd, &key, &descendant_of_result);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+	if (CHECK(descendant_of_result != 1, "descendant_of reaches init",
+		  "%d == %d\n", descendant_of_result, 1))
+		goto close_pmu;
+
+	// Test that PID 0 is an ancestor
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+	ancestor_pid = 0;
+	bpf_map_update_elem(pidmap_fd, &ancestor_key, &ancestor_pid, 0);
+	bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
+
+	root_fd = open("/", O_RDONLY);
+	if (CHECK(efd < 0, "open", "errno %d\n", errno))
+		goto close_prog;
+	close(root_fd);
+
+	err = bpf_map_lookup_elem(resultmap_fd, &key, &descendant_of_result);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+	if (CHECK(descendant_of_result != 1, "PID 0 is our ancestor",
+		  "%d == %d\n", descendant_of_result, 1))
+		goto close_pmu;
+
+	// Test that we don't go over PID 0
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+	ancestor_pid = -1;
+	bpf_map_update_elem(pidmap_fd, &ancestor_key, &ancestor_pid, 0);
+	bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
+
+	root_fd = open("/", O_RDONLY);
+	if (CHECK(efd < 0, "open", "errno %d\n", errno))
+		goto close_prog;
+	close(root_fd);
+
+	err = bpf_map_lookup_elem(resultmap_fd, &key, &descendant_of_result);
+	if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err, errno))
+		goto close_pmu;
+	if (CHECK(descendant_of_result != 0,
+		  "descendant_of does not go over PID 0", "%d == %d\n",
+		  descendant_of_result, 0))
+		goto close_pmu;
+
+	// Test that we are an ancestor of our child
+	pipe(pipefd);
+	child_pid = fork();
+	if (child_pid == -1) {
+		printf("fork failed\n");
+		goto close_pmu;
+	} else if (child_pid == 0) {
+		close(pipefd[1]);
+		read(pipefd[0], &marker, 1);
+
+		root_fd = open("/", O_RDONLY);
+		if (CHECK(efd < 0, "open", "errno %d\n", errno))
+			goto close_prog;
+		close(root_fd);
+
+		close(pipefd[0]);
+		_exit(EXIT_SUCCESS);
+	} else {
+		close(pipefd[0]);
+		bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
+		bpf_map_update_elem(pidmap_fd, &key, &child_pid, 0);
+		bpf_map_update_elem(pidmap_fd, &ancestor_key, &pid, 0);
+
+		write(pipefd[1], &marker, 1);
+		wait(NULL);
+		close(pipefd[1]);
+
+		err = bpf_map_lookup_elem(resultmap_fd, &key,
+					  &descendant_of_result);
+		if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err,
+			  errno))
+			goto close_pmu;
+		if (CHECK(descendant_of_result != 1, "descendant_of of parent",
+			  "%d == %d\n", descendant_of_result, 1))
+			goto close_pmu;
+	}
+
+	// Test that a child of ours doesn't belong to our ancestors
+	bpf_map_update_elem(pidmap_fd, &key, &pid, 0);
+	bpf_map_update_elem(resultmap_fd, &key, &nonexistant, 0);
+
+	pipe(pipefd);
+	child_pid = fork();
+	if (child_pid == -1) {
+		printf("fork failed\n");
+		goto close_pmu;
+	} else if (child_pid == 0) {
+		close(pipefd[1]);
+		read(pipefd[0], marker, 1);
+		close(pipefd[0]);
+		_exit(EXIT_SUCCESS);
+	} else {
+		close(pipefd[0]);
+
+		bpf_map_update_elem(pidmap_fd, &ancestor_key, &child_pid, 0);
+
+		root_fd = open("/", O_RDONLY);
+		if (CHECK(efd < 0, "open", "errno %d\n", errno))
+			goto close_prog;
+		close(root_fd);
+
+		write(pipefd[1], marker, 1);
+		wait(NULL);
+		close(pipefd[1]);
+
+		err = bpf_map_lookup_elem(resultmap_fd, &key,
+					  &descendant_of_result);
+		if (CHECK(err, "bpf_map_lookup_elem", "err %d errno %d\n", err,
+			  errno))
+			goto close_pmu;
+		if (CHECK(descendant_of_result != 0, "descendant_of of child",
+			  "%d == %d\n", descendant_of_result, 0))
+			goto close_pmu;
+	}
+
+	exit_code = EXIT_SUCCESS;
+	printf("%s:PASS\n", argv[0]);
+
+close_pmu:
+	close(pmu_fd);
+close_prog:
+	bpf_object__close(obj);
+fail:
+	return exit_code;
+}
-- 
2.17.1

