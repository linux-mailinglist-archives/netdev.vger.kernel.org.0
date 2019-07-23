Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECBE0721A9
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403961AbfGWVfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:35:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52820 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403957AbfGWVfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:35:20 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6NLYkLL026307
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:35:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=+IbkZA52+CSWhttM7Nop/CTIk408uavqulZJeySTpgc=;
 b=fPJU5QaeGOQ2Bm4MoJSzJ1QhGQILFN+4E3mqFxUExQT220kYiTZ4xkQT7lDhy3UVogby
 VeDKz7fb3RdLKmX2/NaMMNtoIb6r2BS+CGC4Ep/tg+mCURSpxLXn3Z7QzmEaN9HPrKKz
 bpSU6cq+MOmUwgu4fpSISs+ar26AMfswslg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tx61y93u5-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 14:35:19 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 23 Jul 2019 14:35:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 50DCF8615A2; Tue, 23 Jul 2019 14:35:04 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <songliubraving@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 4/5] samples/bpf: switch trace_output sample to perf_buffer API
Date:   Tue, 23 Jul 2019 14:34:44 -0700
Message-ID: <20190723213445.1732339-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723213445.1732339-1-andriin@fb.com>
References: <20190723213445.1732339-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=975 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907230218
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert trace_output sample to libbpf's perf_buffer API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 samples/bpf/trace_output_user.c | 43 +++++++++++----------------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/samples/bpf/trace_output_user.c b/samples/bpf/trace_output_user.c
index 2dd1d39b152a..8ee47699a870 100644
--- a/samples/bpf/trace_output_user.c
+++ b/samples/bpf/trace_output_user.c
@@ -18,9 +18,6 @@
 #include <libbpf.h>
 #include "bpf_load.h"
 #include "perf-sys.h"
-#include "trace_helpers.h"
-
-static int pmu_fd;
 
 static __u64 time_get_ns(void)
 {
@@ -31,12 +28,12 @@ static __u64 time_get_ns(void)
 }
 
 static __u64 start_time;
+static __u64 cnt;
 
 #define MAX_CNT 100000ll
 
-static int print_bpf_output(void *data, int size)
+static void print_bpf_output(void *ctx, int cpu, void *data, __u32 size)
 {
-	static __u64 cnt;
 	struct {
 		__u64 pid;
 		__u64 cookie;
@@ -45,7 +42,7 @@ static int print_bpf_output(void *data, int size)
 	if (e->cookie != 0x12345678) {
 		printf("BUG pid %llx cookie %llx sized %d\n",
 		       e->pid, e->cookie, size);
-		return LIBBPF_PERF_EVENT_ERROR;
+		return;
 	}
 
 	cnt++;
@@ -53,30 +50,14 @@ static int print_bpf_output(void *data, int size)
 	if (cnt == MAX_CNT) {
 		printf("recv %lld events per sec\n",
 		       MAX_CNT * 1000000000ll / (time_get_ns() - start_time));
-		return LIBBPF_PERF_EVENT_DONE;
+		return;
 	}
-
-	return LIBBPF_PERF_EVENT_CONT;
-}
-
-static void test_bpf_perf_event(void)
-{
-	struct perf_event_attr attr = {
-		.sample_type = PERF_SAMPLE_RAW,
-		.type = PERF_TYPE_SOFTWARE,
-		.config = PERF_COUNT_SW_BPF_OUTPUT,
-	};
-	int key = 0;
-
-	pmu_fd = sys_perf_event_open(&attr, -1/*pid*/, 0/*cpu*/, -1/*group_fd*/, 0);
-
-	assert(pmu_fd >= 0);
-	assert(bpf_map_update_elem(map_fd[0], &key, &pmu_fd, BPF_ANY) == 0);
-	ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0);
 }
 
 int main(int argc, char **argv)
 {
+	struct perf_buffer_opts pb_opts = {};
+	struct perf_buffer *pb;
 	char filename[256];
 	FILE *f;
 	int ret;
@@ -88,16 +69,20 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	test_bpf_perf_event();
-
-	if (perf_event_mmap(pmu_fd) < 0)
+	pb_opts.sample_cb = print_bpf_output;
+	pb = perf_buffer__new(map_fd[0], 8, &pb_opts);
+	ret = libbpf_get_error(pb);
+	if (ret) {
+		printf("failed to setup perf_buffer: %d\n", ret);
 		return 1;
+	}
 
 	f = popen("taskset 1 dd if=/dev/zero of=/dev/null", "r");
 	(void) f;
 
 	start_time = time_get_ns();
-	ret = perf_event_poller(pmu_fd, print_bpf_output);
+	while ((ret = perf_buffer__poll(pb, 1000)) >= 0 && cnt < MAX_CNT) {
+	}
 	kill(0, SIGINT);
 	return ret;
 }
-- 
2.17.1

