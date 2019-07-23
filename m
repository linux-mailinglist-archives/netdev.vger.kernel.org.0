Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70221721A2
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403923AbfGWVfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:35:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34232 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392151AbfGWVfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:35:07 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NLWShk003213
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:35:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=a41foeAJEmXaLbQ6sJINdLX8bT2C8WatkeQYIh9FUDI=;
 b=Hy/R0LJLI2MnMpYUTN/eD/vp80k/r7/ngUfGwtndsZIEPnKV4A1I5WTB8WlrVqYR7YS0
 Ih5gnnmJEZXysbsCY/uqIwbck0+SCpj5yr5/03U9hLs5HC0ddWBr7KeZz8uBla8+A7e/
 etr4jBfFAgPIHINIWx5NuSXj401sJ14L2kw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tx61313dm-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:35:06 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 14:35:03 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 3DF718615A2; Tue, 23 Jul 2019 14:35:00 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <songliubraving@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 2/5] selftests/bpf: switch test_tcpnotify to perf_buffer API
Date:   Tue, 23 Jul 2019 14:34:42 -0700
Message-ID: <20190723213445.1732339-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723213445.1732339-1-andriin@fb.com>
References: <20190723213445.1732339-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=848 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230217
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch test_tcpnotify test to use libbpf's perf_buffer API instead of
re-implementing portion of it.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/test_tcpnotify_user.c       | 90 ++++++++-----------
 1 file changed, 36 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/testing/selftests/bpf/test_tcpnotify_user.c
index 86152d9ae95b..f9765ddf0761 100644
--- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
+++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
@@ -17,6 +17,7 @@
 #include <linux/rtnetlink.h>
 #include <signal.h>
 #include <linux/perf_event.h>
+#include <linux/err.h>
 
 #include "bpf_rlimit.h"
 #include "bpf_util.h"
@@ -30,28 +31,34 @@
 pthread_t tid;
 int rx_callbacks;
 
-static int dummyfn(void *data, int size)
+static void dummyfn(void *ctx, int cpu, void *data, __u32 size)
 {
 	struct tcp_notifier *t = data;
 
 	if (t->type != 0xde || t->subtype != 0xad ||
 	    t->source != 0xbe || t->hash != 0xef)
-		return 1;
+		return;
 	rx_callbacks++;
-	return 0;
 }
 
-void tcp_notifier_poller(int fd)
+void tcp_notifier_poller(struct perf_buffer *pb)
 {
-	while (1)
-		perf_event_poller(fd, dummyfn);
+	int err;
+
+	while (1) {
+		err = perf_buffer__poll(pb, 100);
+		if (err < 0 && err != -EINTR) {
+			printf("failed perf_buffer__poll: %d\n", err);
+			return;
+		}
+	}
 }
 
 static void *poller_thread(void *arg)
 {
-	int fd = *(int *)arg;
+	struct perf_buffer *pb = arg;
 
-	tcp_notifier_poller(fd);
+	tcp_notifier_poller(pb);
 	return arg;
 }
 
@@ -60,52 +67,20 @@ int verify_result(const struct tcpnotify_globals *result)
 	return (result->ncalls > 0 && result->ncalls == rx_callbacks ? 0 : 1);
 }
 
-static int bpf_find_map(const char *test, struct bpf_object *obj,
-			const char *name)
-{
-	struct bpf_map *map;
-
-	map = bpf_object__find_map_by_name(obj, name);
-	if (!map) {
-		printf("%s:FAIL:map '%s' not found\n", test, name);
-		return -1;
-	}
-	return bpf_map__fd(map);
-}
-
-static int setup_bpf_perf_event(int mapfd)
-{
-	struct perf_event_attr attr = {
-		.sample_type = PERF_SAMPLE_RAW,
-		.type = PERF_TYPE_SOFTWARE,
-		.config = PERF_COUNT_SW_BPF_OUTPUT,
-	};
-	int key = 0;
-	int pmu_fd;
-
-	pmu_fd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, 0);
-	if (pmu_fd < 0)
-		return pmu_fd;
-	bpf_map_update_elem(mapfd, &key, &pmu_fd, BPF_ANY);
-
-	ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
-	return pmu_fd;
-}
-
 int main(int argc, char **argv)
 {
 	const char *file = "test_tcpnotify_kern.o";
-	int prog_fd, map_fd, perf_event_fd;
+	struct bpf_map *perf_map, *global_map;
+	struct perf_buffer_opts pb_opts = {};
 	struct tcpnotify_globals g = {0};
+	struct perf_buffer *pb = NULL;
 	const char *cg_path = "/foo";
+	int prog_fd, rv, cg_fd = -1;
 	int error = EXIT_FAILURE;
 	struct bpf_object *obj;
-	int cg_fd = -1;
-	__u32 key = 0;
-	int rv;
 	char test_script[80];
-	int pmu_fd;
 	cpu_set_t cpuset;
+	__u32 key = 0;
 
 	CPU_ZERO(&cpuset);
 	CPU_SET(0, &cpuset);
@@ -133,19 +108,24 @@ int main(int argc, char **argv)
 		goto err;
 	}
 
-	perf_event_fd = bpf_find_map(__func__, obj, "perf_event_map");
-	if (perf_event_fd < 0)
+	perf_map = bpf_object__find_map_by_name(obj, "perf_event_map");
+	if (!perf_map) {
+		printf("FAIL:map '%s' not found\n", "perf_event_map");
 		goto err;
+	}
 
-	map_fd = bpf_find_map(__func__, obj, "global_map");
-	if (map_fd < 0)
-		goto err;
+	global_map = bpf_object__find_map_by_name(obj, "global_map");
+	if (!global_map) {
+		printf("FAIL:map '%s' not found\n", "global_map");
+		return -1;
+	}
 
-	pmu_fd = setup_bpf_perf_event(perf_event_fd);
-	if (pmu_fd < 0 || perf_event_mmap(pmu_fd) < 0)
+	pb_opts.sample_cb = dummyfn;
+	pb = perf_buffer__new(bpf_map__fd(perf_map), 8, &pb_opts);
+	if (IS_ERR(pb))
 		goto err;
 
-	pthread_create(&tid, NULL, poller_thread, (void *)&pmu_fd);
+	pthread_create(&tid, NULL, poller_thread, pb);
 
 	sprintf(test_script,
 		"iptables -A INPUT -p tcp --dport %d -j DROP",
@@ -162,7 +142,7 @@ int main(int argc, char **argv)
 		TESTPORT);
 	system(test_script);
 
-	rv = bpf_map_lookup_elem(map_fd, &key, &g);
+	rv = bpf_map_lookup_elem(bpf_map__fd(global_map), &key, &g);
 	if (rv != 0) {
 		printf("FAILED: bpf_map_lookup_elem returns %d\n", rv);
 		goto err;
@@ -182,5 +162,7 @@ int main(int argc, char **argv)
 	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
 	close(cg_fd);
 	cleanup_cgroup_environment();
+	if (!IS_ERR_OR_NULL(pb))
+		perf_buffer__free(pb);
 	return error;
 }
-- 
2.17.1

