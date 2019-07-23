Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13187109E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 06:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731840AbfGWEbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 00:31:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50368 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731695AbfGWEb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 00:31:29 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N4RI73024478
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=YdSKoc9rjaPX0nywjvzhkRX7TBB5gr+4O+5IY0w600Y=;
 b=K1VvcfGkIK5P6B6wgnrvTZgjp3PDZFiU6/L15pp9XnCyTQTdtrUPEY6uXwQRzuJPSGNB
 fOimMk1ptQ9eiJylkrreO5np6djFteYhdHrHtcsjAJ9ktTTSpIwcJ6tvJETalWcpJ6DW
 b/iHn2hPEvftF5gVotxDqj9HmO3TPVk55p4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2twg5ytbj3-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:27 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 22 Jul 2019 21:31:25 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id BCF2D8614ED; Mon, 22 Jul 2019 21:31:24 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 4/5] samples/bpf: switch trace_output sample to perf_buffer API
Date:   Mon, 22 Jul 2019 21:31:11 -0700
Message-ID: <20190723043112.3145810-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723043112.3145810-1-andriin@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=937 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert trace_output sample to libbpf's perf_buffer API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
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

