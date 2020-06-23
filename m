Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA7B206656
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394055AbgFWVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394049AbgFWVkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:40:20 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E38420780;
        Tue, 23 Jun 2020 21:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592948418;
        bh=5FNcKNx4n/XdZZiHXIVql9Al04c7hPk3B5QDRdWbxOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6e6SeI3pGUFSSCFQn4yq0gkEoHZ/iH6NxXHMRZn52qL5u93jN9nXYsKmbH7nMsNF
         az0WllP8C/O4E1L3LlZNzQfZscaIVpypqB0uXae4Iz9ZaXmP5g4UeQjOL+pfmn95fO
         61R9EdFD6ih7Guf0tfZeCd5ZG8OSC+feupnrX+M8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v3 bpf-next 8/9] samples/bpf: xdp_redirect_cpu: load a eBPF program on cpumap
Date:   Tue, 23 Jun 2020 23:39:33 +0200
Message-Id: <cba75456c04b1df529c20d5a94092fb1011c0628.1592947694.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xdp_redirect_cpu_{usr,kern}.c adding the possibility to load
a XDP program on cpumap entries. The following options have been added:
- mprog-name: cpumap entry program name
- mprog-filename: cpumap entry program filename
- redirect-device: output interface if the cpumap program performs a
  XDP_REDIRECT to an egress interface
- redirect-map: bpf map used to perform XDP_REDIRECT to an egress
  interface
- mprog-disable: disable loading XDP program on cpumap entries

Add xdp_pass, xdp_drop, xdp_redirect stats accounting

Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_kern.c |  25 ++--
 samples/bpf/xdp_redirect_cpu_user.c | 174 +++++++++++++++++++++++++---
 2 files changed, 177 insertions(+), 22 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index 2baf8db1f7e7..8255025dea97 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -21,7 +21,7 @@
 struct {
 	__uint(type, BPF_MAP_TYPE_CPUMAP);
 	__uint(key_size, sizeof(u32));
-	__uint(value_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
 	__uint(max_entries, MAX_CPUS);
 } cpu_map SEC(".maps");
 
@@ -30,6 +30,9 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
+	__u64 xdp_redirect;
 };
 
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
@@ -692,13 +695,16 @@ int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
  * Code in:         kernel/include/trace/events/xdp.h
  */
 struct cpumap_kthread_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int sched;		//	offset:28; size:4; signed:1;
+	u64 __pad;			// First 8 bytes are not accessible
+	int map_id;			//	offset:8;  size:4; signed:1;
+	u32 act;			//	offset:12; size:4; signed:0;
+	int cpu;			//	offset:16; size:4; signed:1;
+	unsigned int drops;		//	offset:20; size:4; signed:0;
+	unsigned int processed;		//	offset:24; size:4; signed:0;
+	int sched;			//	offset:28; size:4; signed:1;
+	unsigned int xdp_pass;		//	offset:32; size:4; signed:0;
+	unsigned int xdp_drop;		//	offset:36; size:4; signed:0;
+	unsigned int xdp_redirect;	//	offset:40; size:4; signed:0;
 };
 
 SEC("tracepoint/xdp/xdp_cpumap_kthread")
@@ -712,6 +718,9 @@ int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
 		return 0;
 	rec->processed += ctx->processed;
 	rec->dropped   += ctx->drops;
+	rec->xdp_pass  += ctx->xdp_pass;
+	rec->xdp_drop  += ctx->xdp_drop;
+	rec->xdp_redirect  += ctx->xdp_redirect;
 
 	/* Count times kthread yielded CPU via schedule call */
 	if (ctx->sched)
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 1a054737c35a..4b1264ca7ab7 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -70,6 +70,11 @@ static const struct option long_options[] = {
 	{"stress-mode", no_argument,		NULL, 'x' },
 	{"no-separators", no_argument,		NULL, 'z' },
 	{"force",	no_argument,		NULL, 'F' },
+	{"mprog-disable", no_argument,		NULL, 'n' },
+	{"mprog-name",	required_argument,	NULL, 'e' },
+	{"mprog-filename", required_argument,	NULL, 'f' },
+	{"redirect-device", required_argument,	NULL, 'r' },
+	{"redirect-map", required_argument,	NULL, 'm' },
 	{0, 0, NULL,  0 }
 };
 
@@ -156,6 +161,9 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
+	__u64 xdp_redirect;
 };
 struct record {
 	__u64 timestamp;
@@ -175,6 +183,9 @@ static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
 	/* For percpu maps, userspace gets a value per possible CPU */
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec values[nr_cpus];
+	__u64 sum_xdp_redirect = 0;
+	__u64 sum_xdp_pass = 0;
+	__u64 sum_xdp_drop = 0;
 	__u64 sum_processed = 0;
 	__u64 sum_dropped = 0;
 	__u64 sum_issue = 0;
@@ -196,10 +207,19 @@ static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
 		sum_dropped        += values[i].dropped;
 		rec->cpu[i].issue = values[i].issue;
 		sum_issue        += values[i].issue;
+		rec->cpu[i].xdp_pass = values[i].xdp_pass;
+		sum_xdp_pass += values[i].xdp_pass;
+		rec->cpu[i].xdp_drop = values[i].xdp_drop;
+		sum_xdp_drop += values[i].xdp_drop;
+		rec->cpu[i].xdp_redirect = values[i].xdp_redirect;
+		sum_xdp_redirect += values[i].xdp_redirect;
 	}
 	rec->total.processed = sum_processed;
 	rec->total.dropped   = sum_dropped;
 	rec->total.issue     = sum_issue;
+	rec->total.xdp_pass  = sum_xdp_pass;
+	rec->total.xdp_drop  = sum_xdp_drop;
+	rec->total.xdp_redirect = sum_xdp_redirect;
 	return true;
 }
 
@@ -303,17 +323,33 @@ static __u64 calc_errs_pps(struct datarec *r,
 	return pps;
 }
 
+static void calc_xdp_pps(struct datarec *r, struct datarec *p,
+			 double *xdp_pass, double *xdp_drop,
+			 double *xdp_redirect, double period_)
+{
+	*xdp_pass = 0, *xdp_drop = 0, *xdp_redirect = 0;
+	if (period_ > 0) {
+		*xdp_redirect = (r->xdp_redirect - p->xdp_redirect) / period_;
+		*xdp_pass = (r->xdp_pass - p->xdp_pass) / period_;
+		*xdp_drop = (r->xdp_drop - p->xdp_drop) / period_;
+	}
+}
+
 static void stats_print(struct stats_record *stats_rec,
 			struct stats_record *stats_prev,
-			char *prog_name)
+			char *prog_name, char *mprog_name, int mprog_fd)
 {
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	double pps = 0, drop = 0, err = 0;
+	bool mprog_enabled = false;
 	struct record *rec, *prev;
 	int to_cpu;
 	double t;
 	int i;
 
+	if (mprog_fd > 0)
+		mprog_enabled = true;
+
 	/* Header */
 	printf("Running XDP/eBPF prog_name:%s\n", prog_name);
 	printf("%-15s %-7s %-14s %-11s %-9s\n",
@@ -458,6 +494,33 @@ static void stats_print(struct stats_record *stats_rec,
 		printf(fm2_err, "xdp_exception", "total", pps, drop);
 	}
 
+	/* CPUMAP attached XDP program that runs on remote/destination CPU */
+	if (mprog_enabled) {
+		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f\n";
+		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f\n";
+		double xdp_pass, xdp_drop, xdp_redirect;
+
+		printf("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name);
+		printf("%-15s %-7s %-14s %-11s %-9s\n",
+		       "XDP-cpumap", "CPU:to", "xdp-pass", "xdp-drop", "xdp-redir");
+
+		rec  = &stats_rec->kthread;
+		prev = &stats_prev->kthread;
+		t = calc_period(rec, prev);
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+
+			calc_xdp_pps(r, p, &xdp_pass, &xdp_drop,
+				     &xdp_redirect, t);
+			if (xdp_pass > 0 || xdp_drop > 0 || xdp_redirect > 0)
+				printf(fmt_k, "xdp-in-kthread", i, xdp_pass, xdp_drop, xdp_redirect);
+		}
+		calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
+			     &xdp_redirect, t);
+		printf(fm2_k, "xdp-in-kthread", "total", xdp_pass, xdp_drop, xdp_redirect);
+	}
+
 	printf("\n");
 	fflush(stdout);
 }
@@ -494,7 +557,7 @@ static inline void swap(struct stats_record **a, struct stats_record **b)
 	*b = tmp;
 }
 
-static int create_cpu_entry(__u32 cpu, __u32 queue_size,
+static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 			    __u32 avail_idx, bool new)
 {
 	__u32 curr_cpus_count = 0;
@@ -504,7 +567,7 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(cpu_map_fd, &cpu, &queue_size, 0);
+	ret = bpf_map_update_elem(cpu_map_fd, &cpu, value, 0);
 	if (ret) {
 		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
 		exit(EXIT_FAIL_BPF);
@@ -535,9 +598,9 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
 		}
 	}
 	/* map_fd[7] = cpus_iterator */
-	printf("%s CPU:%u as idx:%u queue_size:%d (total cpus_count:%u)\n",
+	printf("%s CPU:%u as idx:%u qsize:%d prog_fd: %d (cpus_count:%u)\n",
 	       new ? "Add-new":"Replace", cpu, avail_idx,
-	       queue_size, curr_cpus_count);
+	       value->qsize, value->bpf_prog.fd, curr_cpus_count);
 
 	return 0;
 }
@@ -561,21 +624,26 @@ static void mark_cpus_unavailable(void)
 }
 
 /* Stress cpumap management code by concurrently changing underlying cpumap */
-static void stress_cpumap(void)
+static void stress_cpumap(struct bpf_cpumap_val *value)
 {
 	/* Changing qsize will cause kernel to free and alloc a new
 	 * bpf_cpu_map_entry, with an associated/complicated tear-down
 	 * procedure.
 	 */
-	create_cpu_entry(1,  1024, 0, false);
-	create_cpu_entry(1,     8, 0, false);
-	create_cpu_entry(1, 16000, 0, false);
+	value->qsize = 1024;
+	create_cpu_entry(1, value, 0, false);
+	value->qsize = 8;
+	create_cpu_entry(1, value, 0, false);
+	value->qsize = 16000;
+	create_cpu_entry(1, value, 0, false);
 }
 
 static void stats_poll(int interval, bool use_separators, char *prog_name,
+		       char *mprog_name, struct bpf_cpumap_val *value,
 		       bool stress_mode)
 {
 	struct stats_record *record, *prev;
+	int mprog_fd;
 
 	record = alloc_stats_record();
 	prev   = alloc_stats_record();
@@ -587,11 +655,12 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 
 	while (1) {
 		swap(&prev, &record);
+		mprog_fd = value->bpf_prog.fd;
 		stats_collect(record);
-		stats_print(record, prev, prog_name);
+		stats_print(record, prev, prog_name, mprog_name, mprog_fd);
 		sleep(interval);
 		if (stress_mode)
-			stress_cpumap();
+			stress_cpumap(value);
 	}
 
 	free_stats_record(record);
@@ -664,15 +733,66 @@ static int init_map_fds(struct bpf_object *obj)
 	return 0;
 }
 
+static int load_cpumap_prog(char *file_name, char *prog_name,
+			    char *redir_interface, char *redir_map)
+{
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type		= BPF_PROG_TYPE_XDP,
+		.expected_attach_type	= BPF_XDP_CPUMAP,
+		.file = file_name,
+	};
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int fd;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &fd))
+		return -1;
+
+	if (fd < 0) {
+		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n",
+			strerror(errno));
+		return fd;
+	}
+
+	if (redir_interface && redir_map) {
+		int err, map_fd, ifindex_out, key = 0;
+
+		map_fd = bpf_object__find_map_fd_by_name(obj, redir_map);
+		if (map_fd < 0)
+			return map_fd;
+
+		ifindex_out = if_nametoindex(redir_interface);
+		if (!ifindex_out)
+			return -1;
+
+		err = bpf_map_update_elem(map_fd, &key, &ifindex_out, 0);
+		if (err < 0)
+			return err;
+	}
+
+	prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (!prog) {
+		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
+		return EXIT_FAIL;
+	}
+
+	return bpf_program__fd(prog);
+}
+
 int main(int argc, char **argv)
 {
 	struct rlimit r = {10 * 1024 * 1024, RLIM_INFINITY};
 	char *prog_name = "xdp_cpu_map5_lb_hash_ip_pairs";
+	char *mprog_filename = "xdp_redirect_kern.o";
+	char *redir_interface = NULL, *redir_map = NULL;
+	char *mprog_name = "xdp_redirect_dummy";
+	bool mprog_disable = false;
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
+	struct bpf_cpumap_val value;
 	bool use_separators = true;
 	bool stress_mode = false;
 	struct bpf_program *prog;
@@ -728,7 +848,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzF",
+	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
@@ -762,6 +882,21 @@ int main(int argc, char **argv)
 			/* Selecting eBPF prog to load */
 			prog_name = optarg;
 			break;
+		case 'n':
+			mprog_disable = true;
+			break;
+		case 'f':
+			mprog_filename = optarg;
+			break;
+		case 'e':
+			mprog_name = optarg;
+			break;
+		case 'r':
+			redir_interface = optarg;
+			break;
+		case 'm':
+			redir_map = optarg;
+			break;
 		case 'c':
 			/* Add multiple CPUs */
 			add_cpu = strtoul(optarg, NULL, 0);
@@ -807,8 +942,18 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
+	value.bpf_prog.fd = 0;
+	if (!mprog_disable)
+		value.bpf_prog.fd = load_cpumap_prog(mprog_filename, mprog_name,
+						     redir_interface, redir_map);
+	if (value.bpf_prog.fd < 0) {
+		err = value.bpf_prog.fd;
+		goto out;
+	}
+	value.qsize = qsize;
+
 	for (i = 0; i < added_cpus; i++)
-		create_cpu_entry(cpu[i], qsize, i, true);
+		create_cpu_entry(cpu[i], &value, i, true);
 
 	/* Remove XDP program when program is interrupted or killed */
 	signal(SIGINT, int_exit);
@@ -841,7 +986,8 @@ int main(int argc, char **argv)
 	}
 	prog_id = info.id;
 
-	stats_poll(interval, use_separators, prog_name, stress_mode);
+	stats_poll(interval, use_separators, prog_name, mprog_name,
+		   &value, stress_mode);
 out:
 	free(cpu);
 	return err;
-- 
2.26.2

