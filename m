Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0828A200
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbgJJWx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgJJSo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:44:27 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E08C08EC67;
        Sat, 10 Oct 2020 11:17:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w21so9742667pfc.7;
        Sat, 10 Oct 2020 11:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+PD1+9LxtrbZLPhCmTKFgS/KC0LBYYbezLQcohdy+HE=;
        b=gYg2Evfh7f6PF6/ik05IyidjXnyoLUaYhly2TgQQul8pT5qT02DX8RKpIiDW////wr
         /LKJgW2r9KKMDCvwiuMH94KyLMHo/GYmMh7J2xXfu7pomva8Y6nvqBZmGlfsoiWBFWC7
         u3CcqHcn3uA2u/j28X3t63Pfyag1Sf9qKdIzSGLnjR1+zYNoSdlBYgMiV1BG4JIl8LAk
         CbZ0uuzvzN/4F61oRpkh+2H05H+EC6VH0PoHlwtKRl6NNDc5jZWMZNtmKiIhGIHSQYF1
         6IVvlBXa7qawSeVHv/xE4AwVSYGatPLHTb6pPShCcoQ/mwylo895DLVcVeVQc9nczwfH
         0P7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+PD1+9LxtrbZLPhCmTKFgS/KC0LBYYbezLQcohdy+HE=;
        b=qYBau+/G94OO55/ElOfAOSY2RUDbssl2m+uM2lA8K6PNa0bcldB7KO2vPAPG4SdO0W
         v9YQk0TfZQdFt1OIRVLIDoPr9N/0ngkXqzbPLXIs2+4v9LGxCjmw/lWneuNs1gzfoT8C
         1oo48/NGAJS1p+dYhFuQYIdXj+RvYY+Pv599B05MaqIu9SUBY/+HrOyW3l/CfUdr6KKL
         tsMutPLQBmYnz09yUyyqRLpwZUP1tewrmiMHG3uXwS8VPMOv6/PiW7gzWJXjij90fK27
         HmcwZqTNjyBr95u5vxECDOeFgfB/HPkJvJfr52FxkGHO2RvbeOLQwL1sxi/JBSnD4yWp
         t+Ew==
X-Gm-Message-State: AOAM533Q+64ZkhvkjGw21jMRI8vXhN+A4pJ6nLUKUK3eqN0K/rmpVPlc
        l+GK3oAuxV4XMEZw2WXTjQ==
X-Google-Smtp-Source: ABdhPJx4EF+FMyt2dg+E1LgfQreBQ7n6O3tCRM+NCXScTjovNZHQL1WKFQofvN7j55V9VuvVYf0xfw==
X-Received: by 2002:a63:3d8c:: with SMTP id k134mr7595120pga.22.1602353869490;
        Sat, 10 Oct 2020 11:17:49 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q65sm14974615pfq.219.2020.10.10.11.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 11:17:48 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 2/3] samples: bpf: Replace attach_tracepoint() to attach() in xdp_redirect_cpu
Date:   Sun, 11 Oct 2020 03:17:33 +0900
Message-Id: <20201010181734.1109-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201010181734.1109-1-danieltimlee@gmail.com>
References: <20201010181734.1109-1-danieltimlee@gmail.com>
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
Changes in v2:
 - program section match with bpf_program__is_<type> instead of strncmp
 - refactor pointer array initialization
 - error code cleanup

 samples/bpf/Makefile                |   2 +-
 samples/bpf/xdp_redirect_cpu_user.c | 153 +++++++++++++---------------
 2 files changed, 73 insertions(+), 82 deletions(-)

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
index 3dd366e9474d..6fb8dbde62c5 100644
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
-struct bpf_link *tp_links[NUM_TP] = { 0 };
+#define NUM_MAP 9
+struct bpf_link *tp_links[NUM_TP] = {};
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
@@ -665,68 +682,37 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 	free_stats_record(prev);
 }
 
-static struct bpf_link * attach_tp(struct bpf_object *obj,
-				   const char *tp_category,
-				   const char* tp_name)
+static int init_tracepoints(struct bpf_object *obj)
 {
 	struct bpf_program *prog;
-	struct bpf_link *link;
-	char sec_name[PATH_MAX];
-	int len;
 
-	len = snprintf(sec_name, PATH_MAX, "tracepoint/%s/%s",
-		       tp_category, tp_name);
-	if (len < 0)
-		exit(EXIT_FAIL);
+	bpf_object__for_each_program(prog, obj) {
+		if (bpf_program__is_tracepoint(prog) != true)
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
@@ -795,13 +781,13 @@ int main(int argc, char **argv)
 	bool stress_mode = false;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
+	int err = EXIT_FAIL;
 	char filename[256];
 	int added_cpus = 0;
 	int longindex = 0;
 	int interval = 2;
 	int add_cpu = -1;
-	int opt, err;
-	int prog_fd;
+	int opt, prog_fd;
 	int *cpu, i;
 	__u32 qsize;
 
@@ -824,24 +810,29 @@ int main(int argc, char **argv)
 	}
 
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
-		return EXIT_FAIL;
+		return err;
 
 	if (prog_fd < 0) {
 		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n",
 			strerror(errno));
-		return EXIT_FAIL;
+		return err;
 	}
-	init_tracepoints(obj);
+
+	if (init_tracepoints(obj) < 0) {
+		fprintf(stderr, "ERR: bpf_program__attach failed\n");
+		return err;
+	}
+
 	if (init_map_fds(obj) < 0) {
 		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
-		return EXIT_FAIL;
+		return err;
 	}
 	mark_cpus_unavailable();
 
 	cpu = malloc(n_cpus * sizeof(int));
 	if (!cpu) {
 		fprintf(stderr, "failed to allocate cpu array\n");
-		return EXIT_FAIL;
+		return err;
 	}
 	memset(cpu, 0, n_cpus * sizeof(int));
 
@@ -960,14 +951,12 @@ int main(int argc, char **argv)
 	prog = bpf_object__find_program_by_title(obj, prog_name);
 	if (!prog) {
 		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
-		err = EXIT_FAIL;
 		goto out;
 	}
 
 	prog_fd = bpf_program__fd(prog);
 	if (prog_fd < 0) {
 		fprintf(stderr, "bpf_program__fd failed\n");
-		err = EXIT_FAIL;
 		goto out;
 	}
 
@@ -986,6 +975,8 @@ int main(int argc, char **argv)
 
 	stats_poll(interval, use_separators, prog_name, mprog_name,
 		   &value, stress_mode);
+
+	err = EXIT_OK;
 out:
 	free(cpu);
 	return err;
-- 
2.25.1

