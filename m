Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10F8288DA9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389560AbgJIQEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388882AbgJIQEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:04:13 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65EFC0613D2;
        Fri,  9 Oct 2020 09:04:13 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u24so7548490pgi.1;
        Fri, 09 Oct 2020 09:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aUh1zYgtvdeGQ4NrdJFcN+F5igjh3obq7FgwLuFl/y4=;
        b=i4GA8DTzZzELOX8lz4EqYs6Kevv7YS/RqgwT2cg9z+4+Sn7aGnJ4CrpCpeMQmWbx4K
         gauDZYKE3S3f9UOY9ByKEVy1K7iQshyPpQ+3JiG3o/9UQyGkjdG6cgAnem9VjoF72rOT
         ZZi9Oa74NvD2vSIgj2Li1AnfTm56ELw0uBXTWb2HRi0bU7ZQCv6WXTnBCIsFeqQZFqLY
         8LC+GpbTgGig1VnD/vgET4vtDMNyQc3A5S/JngNfFVBNFLGv8WP5mNJR89QiKTi+6D6d
         OB6gx1Wkm/dlYc40w3F9WiDWkbXjFqFH374DGjD6mp1AXY6MN1mpRj4wnkZ6BElxFJtE
         Ur5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aUh1zYgtvdeGQ4NrdJFcN+F5igjh3obq7FgwLuFl/y4=;
        b=pxAfCo5eSwEOvDuFsKzHg0E5JFpCMGZ1f4ov0G4v3zT/ftVxdOvnkb/kPCLEYJt3P2
         zknxNHROO3/ys2Sel2cQzl9kTOOlQsTh5r94AhWJ2kwKQDgBk+zwE2DFofahfey3Sepw
         fncjkVrnVqCWcWRJ/ZURM2iQ2GldA6l55/tQQa4CqY5AjV3Vx1A8aOiXj+TpMNNwl2xe
         QN1OY6UgS4UYQ81ov/UlINwZg1/DA95ThKBdSLbAaoabYRJ40FNbl3La414otixJaTg1
         d1qfqnFaRTB7B0gh63G1IVr2q+DMkAjwY8xjynD7QRL/LDdywvXd46EyYAEMXeS4H9z1
         ObEw==
X-Gm-Message-State: AOAM530scyeQffhyMRP/O5zaxCvwW/fnObOA2Bs0qTpcFppbUWMl78CH
        XUZQwpK11YG3EE2TgMM5og==
X-Google-Smtp-Source: ABdhPJzs7bNtTvjmaS3Wcg33J1aO5au22kflGtd/amgYFbY7wHtEvbZBLjAlApofpOt1ba64wLjNIQ==
X-Received: by 2002:a05:6a00:2a5:b029:152:5652:7191 with SMTP id q5-20020a056a0002a5b029015256527191mr12482498pfs.7.1602259453271;
        Fri, 09 Oct 2020 09:04:13 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id y19sm11287435pfp.52.2020.10.09.09.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 09:04:12 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 2/3] samples: bpf: Replace attach_tracepoint() to attach() in xdp_redirect_cpu
Date:   Sat, 10 Oct 2020 01:03:52 +0900
Message-Id: <20201009160353.1529-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201009160353.1529-1-danieltimlee@gmail.com>
References: <20201009160353.1529-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From commit d7a18ea7e8b6 ("libbpf: Add generic bpf_program__attach()"),
for some BPF programs, it is now possible to attach BPF programs
with __attach() instead of explicitly calling __attach_<type>().

This commit refactors the __attach_tracepoint() with libbpf's generic
__attach() method. In addition, this refactors the logic of setting
the map FD to simplify the code. Also, the missing removal of
bpf_load.o in Makefile has been fixed.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile                |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c | 138 +++++++++++++---------------
 2 files changed, 67 insertions(+), 73 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 0cee2aa8970f..ac9175705b2f 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -98,7 +98,7 @@ test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
-xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
+xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
 xdp_monitor-objs := xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 3dd366e9474d..805b5df5e47b 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -37,18 +37,35 @@ static __u32 prog_id;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int n_cpus;
-static int cpu_map_fd;
-static int rx_cnt_map_fd;
-static int redirect_err_cnt_map_fd;
-static int cpumap_enqueue_cnt_map_fd;
-static int cpumap_kthread_cnt_map_fd;
-static int cpus_available_map_fd;
-static int cpus_count_map_fd;
-static int cpus_iterator_map_fd;
-static int exception_cnt_map_fd;
+
+enum map_type {
+	CPU_MAP,
+	RX_CNT,
+	REDIRECT_ERR_CNT,
+	CPUMAP_ENQUEUE_CNT,
+	CPUMAP_KTHREAD_CNT,
+	CPUS_AVAILABLE,
+	CPUS_COUNT,
+	CPUS_ITERATOR,
+	EXCEPTION_CNT,
+};
+
+static const char *const map_type_strings[] = {
+	[CPU_MAP] = "cpu_map",
+	[RX_CNT] = "rx_cnt",
+	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
+	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
+	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
+	[CPUS_AVAILABLE] = "cpus_available",
+	[CPUS_COUNT] = "cpus_count",
+	[CPUS_ITERATOR] = "cpus_iterator",
+	[EXCEPTION_CNT] = "exception_cnt",
+};
 
 #define NUM_TP 5
+#define NUM_MAP 9
 struct bpf_link *tp_links[NUM_TP] = { 0 };
+static int map_fds[NUM_MAP];
 static int tp_cnt = 0;
 
 /* Exit return codes */
@@ -527,20 +544,20 @@ static void stats_collect(struct stats_record *rec)
 {
 	int fd, i;
 
-	fd = rx_cnt_map_fd;
+	fd = map_fds[RX_CNT];
 	map_collect_percpu(fd, 0, &rec->rx_cnt);
 
-	fd = redirect_err_cnt_map_fd;
+	fd = map_fds[REDIRECT_ERR_CNT];
 	map_collect_percpu(fd, 1, &rec->redir_err);
 
-	fd = cpumap_enqueue_cnt_map_fd;
+	fd = map_fds[CPUMAP_ENQUEUE_CNT];
 	for (i = 0; i < n_cpus; i++)
 		map_collect_percpu(fd, i, &rec->enq[i]);
 
-	fd = cpumap_kthread_cnt_map_fd;
+	fd = map_fds[CPUMAP_KTHREAD_CNT];
 	map_collect_percpu(fd, 0, &rec->kthread);
 
-	fd = exception_cnt_map_fd;
+	fd = map_fds[EXCEPTION_CNT];
 	map_collect_percpu(fd, 0, &rec->exception);
 }
 
@@ -565,7 +582,7 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(cpu_map_fd, &cpu, value, 0);
+	ret = bpf_map_update_elem(map_fds[CPU_MAP], &cpu, value, 0);
 	if (ret) {
 		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
 		exit(EXIT_FAIL_BPF);
@@ -574,21 +591,21 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 	/* Inform bpf_prog's that a new CPU is available to select
 	 * from via some control maps.
 	 */
-	ret = bpf_map_update_elem(cpus_available_map_fd, &avail_idx, &cpu, 0);
+	ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &avail_idx, &cpu, 0);
 	if (ret) {
 		fprintf(stderr, "Add to avail CPUs failed\n");
 		exit(EXIT_FAIL_BPF);
 	}
 
 	/* When not replacing/updating existing entry, bump the count */
-	ret = bpf_map_lookup_elem(cpus_count_map_fd, &key, &curr_cpus_count);
+	ret = bpf_map_lookup_elem(map_fds[CPUS_COUNT], &key, &curr_cpus_count);
 	if (ret) {
 		fprintf(stderr, "Failed reading curr cpus_count\n");
 		exit(EXIT_FAIL_BPF);
 	}
 	if (new) {
 		curr_cpus_count++;
-		ret = bpf_map_update_elem(cpus_count_map_fd, &key,
+		ret = bpf_map_update_elem(map_fds[CPUS_COUNT], &key,
 					  &curr_cpus_count, 0);
 		if (ret) {
 			fprintf(stderr, "Failed write curr cpus_count\n");
@@ -612,7 +629,7 @@ static void mark_cpus_unavailable(void)
 	int ret, i;
 
 	for (i = 0; i < n_cpus; i++) {
-		ret = bpf_map_update_elem(cpus_available_map_fd, &i,
+		ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &i,
 					  &invalid_cpu, 0);
 		if (ret) {
 			fprintf(stderr, "Failed marking CPU unavailable\n");
@@ -665,68 +682,40 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 	free_stats_record(prev);
 }
 
-static struct bpf_link * attach_tp(struct bpf_object *obj,
-				   const char *tp_category,
-				   const char* tp_name)
+static int init_tracepoints(struct bpf_object *obj)
 {
+	char *tp_section = "tracepoint/";
 	struct bpf_program *prog;
-	struct bpf_link *link;
-	char sec_name[PATH_MAX];
-	int len;
+	const char *section;
 
-	len = snprintf(sec_name, PATH_MAX, "tracepoint/%s/%s",
-		       tp_category, tp_name);
-	if (len < 0)
-		exit(EXIT_FAIL);
+	bpf_object__for_each_program(prog, obj) {
+		section = bpf_program__section_name(prog);
+		if (strncmp(section, tp_section, strlen(tp_section)) != 0)
+			continue;
 
-	prog = bpf_object__find_program_by_title(obj, sec_name);
-	if (!prog) {
-		fprintf(stderr, "ERR: finding progsec: %s\n", sec_name);
-		exit(EXIT_FAIL_BPF);
+		tp_links[tp_cnt] = bpf_program__attach(prog);
+		if (libbpf_get_error(tp_links[tp_cnt])) {
+			tp_links[tp_cnt] = NULL;
+			return -EINVAL;
+		}
+		tp_cnt++;
 	}
 
-	link = bpf_program__attach_tracepoint(prog, tp_category, tp_name);
-	if (libbpf_get_error(link))
-		exit(EXIT_FAIL_BPF);
-
-	return link;
-}
-
-static void init_tracepoints(struct bpf_object *obj) {
-	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_redirect_err");
-	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_redirect_map_err");
-	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_exception");
-	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_cpumap_enqueue");
-	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_cpumap_kthread");
+	return 0;
 }
 
 static int init_map_fds(struct bpf_object *obj)
 {
-	/* Maps updated by tracepoints */
-	redirect_err_cnt_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "redirect_err_cnt");
-	exception_cnt_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "exception_cnt");
-	cpumap_enqueue_cnt_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "cpumap_enqueue_cnt");
-	cpumap_kthread_cnt_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "cpumap_kthread_cnt");
-
-	/* Maps used by XDP */
-	rx_cnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rx_cnt");
-	cpu_map_fd = bpf_object__find_map_fd_by_name(obj, "cpu_map");
-	cpus_available_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "cpus_available");
-	cpus_count_map_fd = bpf_object__find_map_fd_by_name(obj, "cpus_count");
-	cpus_iterator_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "cpus_iterator");
-
-	if (cpu_map_fd < 0 || rx_cnt_map_fd < 0 ||
-	    redirect_err_cnt_map_fd < 0 || cpumap_enqueue_cnt_map_fd < 0 ||
-	    cpumap_kthread_cnt_map_fd < 0 || cpus_available_map_fd < 0 ||
-	    cpus_count_map_fd < 0 || cpus_iterator_map_fd < 0 ||
-	    exception_cnt_map_fd < 0)
-		return -ENOENT;
+	enum map_type type;
+
+	for (type = 0; type < NUM_MAP; type++) {
+		map_fds[type] =
+			bpf_object__find_map_fd_by_name(obj,
+							map_type_strings[type]);
+
+		if (map_fds[type] < 0)
+			return -ENOENT;
+	}
 
 	return 0;
 }
@@ -831,7 +820,12 @@ int main(int argc, char **argv)
 			strerror(errno));
 		return EXIT_FAIL;
 	}
-	init_tracepoints(obj);
+
+	if (init_tracepoints(obj) < 0) {
+		fprintf(stderr, "ERR: bpf_program__attach failed\n");
+		return EXIT_FAIL;
+	}
+
 	if (init_map_fds(obj) < 0) {
 		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
 		return EXIT_FAIL;
-- 
2.25.1

