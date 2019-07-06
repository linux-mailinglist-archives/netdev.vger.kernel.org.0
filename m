Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1894260EE9
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 06:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfGFEfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 00:35:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14046 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725971AbfGFEfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 00:35:39 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x664YOeO022799
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 21:35:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=RGkCnDzu8Hs6pZHF+GZE1sy/dRNYYUtBdhWC2IgSfaE=;
 b=Fp906ZhAe+tIZILEUPhO+EQVdLz16OhiQnoHGRrpYNVv6PDlcDWQT1dvNQFnQDdDfJiE
 9MHh3njBjpdMFQ51h72/1dTbwsK0lgQtW5xR2GRJUW6yXE/p/QIRMvavU2OGlMPz0ECn
 Xfr1hd23XX0p94C0EkgmjxTLEoDidlj9+x4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tj6qajpqe-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 21:35:38 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Jul 2019 21:35:37 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id DF9F486163A; Fri,  5 Jul 2019 21:35:34 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 4/5] tools/bpftool: switch map event_pipe to libbpf's perf_buffer
Date:   Fri, 5 Jul 2019 21:35:21 -0700
Message-ID: <20190706043522.1559005-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190706043522.1559005-1-andriin@fb.com>
References: <20190706043522.1559005-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch event_pipe implementation to rely on new libbpf perf buffer API
(it's raw low-level variant).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/map_perf_ring.c | 201 ++++++++++--------------------
 1 file changed, 64 insertions(+), 137 deletions(-)

diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index 0507dfaf7a8f..3f108ab17797 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -28,7 +28,7 @@
 
 #define MMAP_PAGE_CNT	16
 
-static bool stop;
+static volatile bool stop;
 
 struct event_ring_info {
 	int fd;
@@ -44,32 +44,44 @@ struct perf_event_sample {
 	unsigned char data[];
 };
 
+struct perf_event_lost {
+	struct perf_event_header header;
+	__u64 id;
+	__u64 lost;
+};
+
 static void int_exit(int signo)
 {
 	fprintf(stderr, "Stopping...\n");
 	stop = true;
 }
 
+struct event_pipe_ctx {
+	bool all_cpus;
+	int cpu;
+	int idx;
+};
+
 static enum bpf_perf_event_ret
-print_bpf_output(struct perf_event_header *event, void *private_data)
+print_bpf_output(void *private_data, int cpu, struct perf_event_header *event)
 {
-	struct perf_event_sample *e = container_of(event, struct perf_event_sample,
+	struct perf_event_sample *e = container_of(event,
+						   struct perf_event_sample,
 						   header);
-	struct event_ring_info *ring = private_data;
-	struct {
-		struct perf_event_header header;
-		__u64 id;
-		__u64 lost;
-	} *lost = (typeof(lost))event;
+	struct perf_event_lost *lost = container_of(event,
+						    struct perf_event_lost,
+						    header);
+	struct event_pipe_ctx *ctx = private_data;
+	int idx = ctx->all_cpus ? cpu : ctx->idx;
 
 	if (json_output) {
 		jsonw_start_object(json_wtr);
 		jsonw_name(json_wtr, "type");
 		jsonw_uint(json_wtr, e->header.type);
 		jsonw_name(json_wtr, "cpu");
-		jsonw_uint(json_wtr, ring->cpu);
+		jsonw_uint(json_wtr, cpu);
 		jsonw_name(json_wtr, "index");
-		jsonw_uint(json_wtr, ring->key);
+		jsonw_uint(json_wtr, idx);
 		if (e->header.type == PERF_RECORD_SAMPLE) {
 			jsonw_name(json_wtr, "timestamp");
 			jsonw_uint(json_wtr, e->time);
@@ -89,7 +101,7 @@ print_bpf_output(struct perf_event_header *event, void *private_data)
 		if (e->header.type == PERF_RECORD_SAMPLE) {
 			printf("== @%lld.%09lld CPU: %d index: %d =====\n",
 			       e->time / 1000000000ULL, e->time % 1000000000ULL,
-			       ring->cpu, ring->key);
+			       cpu, idx);
 			fprint_hex(stdout, e->data, e->size, " ");
 			printf("\n");
 		} else if (e->header.type == PERF_RECORD_LOST) {
@@ -103,87 +115,25 @@ print_bpf_output(struct perf_event_header *event, void *private_data)
 	return LIBBPF_PERF_EVENT_CONT;
 }
 
-static void
-perf_event_read(struct event_ring_info *ring, void **buf, size_t *buf_len)
-{
-	enum bpf_perf_event_ret ret;
-
-	ret = bpf_perf_event_read_simple(ring->mem,
-					 MMAP_PAGE_CNT * get_page_size(),
-					 get_page_size(), buf, buf_len,
-					 print_bpf_output, ring);
-	if (ret != LIBBPF_PERF_EVENT_CONT) {
-		fprintf(stderr, "perf read loop failed with %d\n", ret);
-		stop = true;
-	}
-}
-
-static int perf_mmap_size(void)
-{
-	return get_page_size() * (MMAP_PAGE_CNT + 1);
-}
-
-static void *perf_event_mmap(int fd)
-{
-	int mmap_size = perf_mmap_size();
-	void *base;
-
-	base = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
-	if (base == MAP_FAILED) {
-		p_err("event mmap failed: %s\n", strerror(errno));
-		return NULL;
-	}
-
-	return base;
-}
-
-static void perf_event_unmap(void *mem)
-{
-	if (munmap(mem, perf_mmap_size()))
-		fprintf(stderr, "Can't unmap ring memory!\n");
-}
-
-static int bpf_perf_event_open(int map_fd, int key, int cpu)
+int do_event_pipe(int argc, char **argv)
 {
-	struct perf_event_attr attr = {
+	struct perf_event_attr perf_attr = {
 		.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_TIME,
 		.type = PERF_TYPE_SOFTWARE,
 		.config = PERF_COUNT_SW_BPF_OUTPUT,
+		.sample_period = 1,
+		.wakeup_events = 1,
 	};
-	int pmu_fd;
-
-	pmu_fd = sys_perf_event_open(&attr, -1, cpu, -1, 0);
-	if (pmu_fd < 0) {
-		p_err("failed to open perf event %d for CPU %d", key, cpu);
-		return -1;
-	}
-
-	if (bpf_map_update_elem(map_fd, &key, &pmu_fd, BPF_ANY)) {
-		p_err("failed to update map for event %d for CPU %d", key, cpu);
-		goto err_close;
-	}
-	if (ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
-		p_err("failed to enable event %d for CPU %d", key, cpu);
-		goto err_close;
-	}
-
-	return pmu_fd;
-
-err_close:
-	close(pmu_fd);
-	return -1;
-}
-
-int do_event_pipe(int argc, char **argv)
-{
-	int i, nfds, map_fd, index = -1, cpu = -1;
 	struct bpf_map_info map_info = {};
-	struct event_ring_info *rings;
-	size_t tmp_buf_sz = 0;
-	void *tmp_buf = NULL;
-	struct pollfd *pfds;
+	struct perf_buffer_raw_opts opts = {};
+	struct event_pipe_ctx ctx = {
+		.all_cpus = true,
+		.cpu = -1,
+		.idx = -1,
+	};
+	struct perf_buffer *pb;
 	__u32 map_info_len;
-	bool do_all = true;
+	int err, map_fd;
 
 	map_info_len = sizeof(map_info);
 	map_fd = map_parse_fd_and_info(&argc, &argv, &map_info, &map_info_len);
@@ -205,7 +155,7 @@ int do_event_pipe(int argc, char **argv)
 			char *endptr;
 
 			NEXT_ARG();
-			cpu = strtoul(*argv, &endptr, 0);
+			ctx.cpu = strtoul(*argv, &endptr, 0);
 			if (*endptr) {
 				p_err("can't parse %s as CPU ID", **argv);
 				goto err_close_map;
@@ -216,7 +166,7 @@ int do_event_pipe(int argc, char **argv)
 			char *endptr;
 
 			NEXT_ARG();
-			index = strtoul(*argv, &endptr, 0);
+			ctx.idx = strtoul(*argv, &endptr, 0);
 			if (*endptr) {
 				p_err("can't parse %s as index", **argv);
 				goto err_close_map;
@@ -228,45 +178,32 @@ int do_event_pipe(int argc, char **argv)
 			goto err_close_map;
 		}
 
-		do_all = false;
+		ctx.all_cpus = false;
 	}
 
-	if (!do_all) {
-		if (index == -1 || cpu == -1) {
+	if (!ctx.all_cpus) {
+		if (ctx.idx == -1 || ctx.cpu == -1) {
 			p_err("cpu and index must be specified together");
 			goto err_close_map;
 		}
-
-		nfds = 1;
 	} else {
-		nfds = min(get_possible_cpus(), map_info.max_entries);
-		cpu = 0;
-		index = 0;
+		ctx.cpu = 0;
+		ctx.idx = 0;
 	}
 
-	rings = calloc(nfds, sizeof(rings[0]));
-	if (!rings)
+	opts.attr = &perf_attr;
+	opts.event_cb = print_bpf_output;
+	opts.ctx = &ctx;
+	opts.cpu_cnt = ctx.all_cpus ? 0 : 1;
+	opts.cpus = &ctx.cpu;
+	opts.map_keys = &ctx.idx;
+
+	pb = perf_buffer__new_raw(map_fd, MMAP_PAGE_CNT, &opts);
+	err = libbpf_get_error(pb);
+	if (err) {
+		p_err("failed to create perf buffer: %s (%d)",
+		      strerror(err), err);
 		goto err_close_map;
-
-	pfds = calloc(nfds, sizeof(pfds[0]));
-	if (!pfds)
-		goto err_free_rings;
-
-	for (i = 0; i < nfds; i++) {
-		rings[i].cpu = cpu + i;
-		rings[i].key = index + i;
-
-		rings[i].fd = bpf_perf_event_open(map_fd, rings[i].key,
-						  rings[i].cpu);
-		if (rings[i].fd < 0)
-			goto err_close_fds_prev;
-
-		rings[i].mem = perf_event_mmap(rings[i].fd);
-		if (!rings[i].mem)
-			goto err_close_fds_current;
-
-		pfds[i].fd = rings[i].fd;
-		pfds[i].events = POLLIN;
 	}
 
 	signal(SIGINT, int_exit);
@@ -277,34 +214,24 @@ int do_event_pipe(int argc, char **argv)
 		jsonw_start_array(json_wtr);
 
 	while (!stop) {
-		poll(pfds, nfds, 200);
-		for (i = 0; i < nfds; i++)
-			perf_event_read(&rings[i], &tmp_buf, &tmp_buf_sz);
+		err = perf_buffer__poll(pb, 200);
+		if (err < 0 && err != -EINTR) {
+			p_err("perf buffer polling failed: %s (%d)",
+			      strerror(err), err);
+			goto err_close_pb;
+		}
 	}
-	free(tmp_buf);
 
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
-	for (i = 0; i < nfds; i++) {
-		perf_event_unmap(rings[i].mem);
-		close(rings[i].fd);
-	}
-	free(pfds);
-	free(rings);
+	perf_buffer__free(pb);
 	close(map_fd);
 
 	return 0;
 
-err_close_fds_prev:
-	while (i--) {
-		perf_event_unmap(rings[i].mem);
-err_close_fds_current:
-		close(rings[i].fd);
-	}
-	free(pfds);
-err_free_rings:
-	free(rings);
+err_close_pb:
+	perf_buffer__free(pb);
 err_close_map:
 	close(map_fd);
 	return -1;
-- 
2.17.1

