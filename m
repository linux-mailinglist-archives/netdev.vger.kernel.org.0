Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34F371099
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 06:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbfGWEb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 00:31:26 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32030 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731647AbfGWEbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 00:31:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6N4PSD7012025
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=6D59SxVgo01iksX+4knX7/AjvanKarP7V8WmCIwhom8=;
 b=SZXKIV0akrL0wqNrZ1+R49lseEG1XX/DJY5sJFlJrMnVVJY1ZOlRDZIwamNbEFe9XBSi
 7ZQnPE2mm97U1KctoTn7guqDCIru1f8ohC6x1Fx0v8gV8t9rnEgbaBbr0IR/mMAZHD4l
 KJJKMPsNGXkhk38AWK4vAUKRxy79P6q8tKM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2twg6aabx4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:31:24 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 22 Jul 2019 21:31:23 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B0C5E8614ED; Mon, 22 Jul 2019 21:31:22 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 3/5] samples/bpf: convert xdp_sample_pkts_user to perf_buffer API
Date:   Mon, 22 Jul 2019 21:31:10 -0700
Message-ID: <20190723043112.3145810-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190723043112.3145810-1-andriin@fb.com>
References: <20190723043112.3145810-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=25 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=994 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907230039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert xdp_sample_pkts_user to libbpf's perf_buffer API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 samples/bpf/xdp_sample_pkts_user.c | 61 +++++++++---------------------
 1 file changed, 17 insertions(+), 44 deletions(-)

diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index dc66345a929a..3002714e3cd5 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -17,14 +17,13 @@
 #include <linux/if_link.h>
 
 #include "perf-sys.h"
-#include "trace_helpers.h"
 
 #define MAX_CPUS 128
-static int pmu_fds[MAX_CPUS], if_idx;
-static struct perf_event_mmap_page *headers[MAX_CPUS];
+static int if_idx;
 static char *if_name;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static __u32 prog_id;
+static struct perf_buffer *pb = NULL;
 
 static int do_attach(int idx, int fd, const char *name)
 {
@@ -73,7 +72,7 @@ static int do_detach(int idx, const char *name)
 
 #define SAMPLE_SIZE 64
 
-static int print_bpf_output(void *data, int size)
+static void print_bpf_output(void *ctx, int cpu, void *data, __u32 size)
 {
 	struct {
 		__u16 cookie;
@@ -83,45 +82,20 @@ static int print_bpf_output(void *data, int size)
 	int i;
 
 	if (e->cookie != 0xdead) {
-		printf("BUG cookie %x sized %d\n",
-		       e->cookie, size);
-		return LIBBPF_PERF_EVENT_ERROR;
+		printf("BUG cookie %x sized %d\n", e->cookie, size);
+		return;
 	}
 
 	printf("Pkt len: %-5d bytes. Ethernet hdr: ", e->pkt_len);
 	for (i = 0; i < 14 && i < e->pkt_len; i++)
 		printf("%02x ", e->pkt_data[i]);
 	printf("\n");
-
-	return LIBBPF_PERF_EVENT_CONT;
-}
-
-static void test_bpf_perf_event(int map_fd, int num)
-{
-	struct perf_event_attr attr = {
-		.sample_type = PERF_SAMPLE_RAW,
-		.type = PERF_TYPE_SOFTWARE,
-		.config = PERF_COUNT_SW_BPF_OUTPUT,
-		.wakeup_events = 1, /* get an fd notification for every event */
-	};
-	int i;
-
-	for (i = 0; i < num; i++) {
-		int key = i;
-
-		pmu_fds[i] = sys_perf_event_open(&attr, -1/*pid*/, i/*cpu*/,
-						 -1/*group_fd*/, 0);
-
-		assert(pmu_fds[i] >= 0);
-		assert(bpf_map_update_elem(map_fd, &key,
-					   &pmu_fds[i], BPF_ANY) == 0);
-		ioctl(pmu_fds[i], PERF_EVENT_IOC_ENABLE, 0);
-	}
 }
 
 static void sig_handler(int signo)
 {
 	do_detach(if_idx, if_name);
+	perf_buffer__free(pb);
 	exit(0);
 }
 
@@ -140,13 +114,13 @@ int main(int argc, char **argv)
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_XDP,
 	};
+	struct perf_buffer_opts pb_opts = {};
 	const char *optstr = "F";
 	int prog_fd, map_fd, opt;
 	struct bpf_object *obj;
 	struct bpf_map *map;
 	char filename[256];
-	int ret, err, i;
-	int numcpus;
+	int ret, err;
 
 	while ((opt = getopt(argc, argv, optstr)) != -1) {
 		switch (opt) {
@@ -169,10 +143,6 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	numcpus = get_nprocs();
-	if (numcpus > MAX_CPUS)
-		numcpus = MAX_CPUS;
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
 
@@ -211,14 +181,17 @@ int main(int argc, char **argv)
 		return 1;
 	}
 
-	test_bpf_perf_event(map_fd, numcpus);
+	pb_opts.sample_cb = print_bpf_output;
+	pb = perf_buffer__new(map_fd, 8, &pb_opts);
+	err = libbpf_get_error(pb);
+	if (err) {
+		perror("perf_buffer setup failed");
+		return 1;
+	}
 
-	for (i = 0; i < numcpus; i++)
-		if (perf_event_mmap_header(pmu_fds[i], &headers[i]) < 0)
-			return 1;
+	while ((ret = perf_buffer__poll(pb, 1000)) >= 0) {
+	}
 
-	ret = perf_event_poller_multi(pmu_fds, headers, numcpus,
-				      print_bpf_output);
 	kill(0, SIGINT);
 	return ret;
 }
-- 
2.17.1

