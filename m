Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7951E9A9D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 23:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgEaVr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 17:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbgEaVr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 17:47:56 -0400
Received: from lore-desk.lan (unknown [151.48.128.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A7A206F1;
        Sun, 31 May 2020 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590961675;
        bh=pEkohytzk8BTk5rJBYiyBRumDJxbzzz7NsqRuJs1Tjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RG9IAKTFP3/SRtpg6AFGh6YgFj6UBRSQa9QLvfUNSg2yo6sPies7yyaKSC7bWNx+7
         WiFcsMRkAPMaiwS+dMpf8mkzDb46E6D0DJwJKU0HWNrzNnEq3vBTPqE6HmOcDCRYFG
         UJCLg6GdEnuRKYMpoe3ERYkQK1o1YpSp6DWjO+b8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH bpf-next 6/6] samples/bpf: xdp_redirect_cpu: load an eBPF program on cpumap
Date:   Sun, 31 May 2020 23:46:51 +0200
Message-Id: <71d8945da7e190f2e56e9d6f86bef83c9625cac0.1590960613.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590960613.git.lorenzo@kernel.org>
References: <cover.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xdp_redirect_cpu_{usr,kern}.c adding the possibility to load
a XDP program on cpumap entries

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_kern.c |  34 ++++++---
 samples/bpf/xdp_redirect_cpu_user.c | 106 ++++++++++++++++++++++++----
 2 files changed, 119 insertions(+), 21 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index 2baf8db1f7e7..30f500237753 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -17,11 +17,20 @@
 
 #define MAX_CPUS NR_CPUS
 
+/* CPUMAP value */
+struct bpf_cpumap_val {
+	u32 qsize;
+	union {
+		int fd;
+		u32 id;
+	} prog;
+};
+
 /* Special map type that can XDP_REDIRECT frames to another CPU */
 struct {
 	__uint(type, BPF_MAP_TYPE_CPUMAP);
 	__uint(key_size, sizeof(u32));
-	__uint(value_size, sizeof(u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
 	__uint(max_entries, MAX_CPUS);
 } cpu_map SEC(".maps");
 
@@ -30,6 +39,9 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
+	__u64 xdp_redirect;
 };
 
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
@@ -692,13 +704,16 @@ int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
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
@@ -712,6 +727,9 @@ int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
 		return 0;
 	rec->processed += ctx->processed;
 	rec->dropped   += ctx->drops;
+	rec->xdp_pass  += ctx->xdp_pass;
+	rec->xdp_drop  += ctx->xdp_drop;
+	rec->xdp_redirect  += ctx->xdp_redirect;
 
 	/* Count times kthread yielded CPU via schedule call */
 	if (ctx->sched)
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 1a054737c35a..13f598a24759 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -30,6 +30,15 @@ static const char *__doc__ =
 
 #include "bpf_util.h"
 
+/* CPUMAP value */
+struct bpf_cpumap_val {
+	__u32 qsize;
+	union {
+		int fd;
+		__u32 id;
+	} prog;
+};
+
 static int ifindex = -1;
 static char ifname_buf[IF_NAMESIZE];
 static char *ifname;
@@ -70,6 +79,8 @@ static const struct option long_options[] = {
 	{"stress-mode", no_argument,		NULL, 'x' },
 	{"no-separators", no_argument,		NULL, 'z' },
 	{"force",	no_argument,		NULL, 'F' },
+	{"map-prog-filename", required_argument, NULL, 'f' },
+	{"map-prog-name", required_argument,	NULL, 'P' },
 	{0, 0, NULL,  0 }
 };
 
@@ -156,6 +167,9 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
+	__u64 xdp_redirect;
 };
 struct record {
 	__u64 timestamp;
@@ -175,6 +189,9 @@ static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
 	/* For percpu maps, userspace gets a value per possible CPU */
 	unsigned int nr_cpus = bpf_num_possible_cpus();
 	struct datarec values[nr_cpus];
+	__u64 sum_xdp_redirect = 0;
+	__u64 sum_xdp_pass = 0;
+	__u64 sum_xdp_drop = 0;
 	__u64 sum_processed = 0;
 	__u64 sum_dropped = 0;
 	__u64 sum_issue = 0;
@@ -196,10 +213,19 @@ static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
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
 
@@ -405,6 +431,9 @@ static void stats_print(struct stats_record *stats_rec,
 			if (pps > 0)
 				printf(fmt_k, "cpumap_kthread",
 				       i, pps, drop, err, e_str);
+			printf("%d xdp-pass %llu xdp-drop %llu "
+			       "xdp-redirect %llu\n", i, r->xdp_pass,
+			       r->xdp_drop, r->xdp_redirect);
 		}
 		pps = calc_pps(&rec->total, &prev->total, t);
 		drop = calc_drop_pps(&rec->total, &prev->total, t);
@@ -412,6 +441,9 @@ static void stats_print(struct stats_record *stats_rec,
 		if (err > 0)
 			e_str = "sched-sum";
 		printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
+		printf("xdp-pass %llu xdp-drop %llu xdp-redirect %llu\n",
+		       rec->total.xdp_pass, rec->total.xdp_drop,
+		       rec->total.xdp_redirect);
 	}
 
 	/* XDP redirect err tracepoints (very unlikely) */
@@ -494,7 +526,7 @@ static inline void swap(struct stats_record **a, struct stats_record **b)
 	*b = tmp;
 }
 
-static int create_cpu_entry(__u32 cpu, __u32 queue_size,
+static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 			    __u32 avail_idx, bool new)
 {
 	__u32 curr_cpus_count = 0;
@@ -504,7 +536,7 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(cpu_map_fd, &cpu, &queue_size, 0);
+	ret = bpf_map_update_elem(cpu_map_fd, &cpu, value, 0);
 	if (ret) {
 		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
 		exit(EXIT_FAIL_BPF);
@@ -535,9 +567,9 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
 		}
 	}
 	/* map_fd[7] = cpus_iterator */
-	printf("%s CPU:%u as idx:%u queue_size:%d (total cpus_count:%u)\n",
+	printf("%s CPU:%u as idx:%u qsize:%d prog_fd: %d (cpus_count:%u)\n",
 	       new ? "Add-new":"Replace", cpu, avail_idx,
-	       queue_size, curr_cpus_count);
+	       value->qsize, value->prog.fd, curr_cpus_count);
 
 	return 0;
 }
@@ -561,19 +593,22 @@ static void mark_cpus_unavailable(void)
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
-		       bool stress_mode)
+		       struct bpf_cpumap_val *value, bool stress_mode)
 {
 	struct stats_record *record, *prev;
 
@@ -591,7 +626,7 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 		stats_print(record, prev, prog_name);
 		sleep(interval);
 		if (stress_mode)
-			stress_cpumap();
+			stress_cpumap(value);
 	}
 
 	free_stats_record(record);
@@ -664,15 +699,47 @@ static int init_map_fds(struct bpf_object *obj)
 	return 0;
 }
 
+static int load_cpumap_prog(char *file_name, char *prog_name)
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
+	char *map_prog_filename = "xdp_redirect_kern.o";
+	char *map_prog_name = "xdp_redirect_dummy";
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
+	struct bpf_cpumap_val value;
 	bool use_separators = true;
 	bool stress_mode = false;
 	struct bpf_program *prog;
@@ -728,7 +795,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzF",
+	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:P:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
@@ -762,6 +829,12 @@ int main(int argc, char **argv)
 			/* Selecting eBPF prog to load */
 			prog_name = optarg;
 			break;
+		case 'f':
+			map_prog_filename = optarg;
+			break;
+		case 'P':
+			map_prog_name = optarg;
+			break;
 		case 'c':
 			/* Add multiple CPUs */
 			add_cpu = strtoul(optarg, NULL, 0);
@@ -807,8 +880,15 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
+	value.prog.fd = load_cpumap_prog(map_prog_filename, map_prog_name);
+	if (value.prog.fd < 0) {
+		err = value.prog.fd;
+		goto out;
+	}
+	value.qsize = qsize;
+
 	for (i = 0; i < added_cpus; i++)
-		create_cpu_entry(cpu[i], qsize, i, true);
+		create_cpu_entry(cpu[i], &value, i, true);
 
 	/* Remove XDP program when program is interrupted or killed */
 	signal(SIGINT, int_exit);
@@ -841,7 +921,7 @@ int main(int argc, char **argv)
 	}
 	prog_id = info.id;
 
-	stats_poll(interval, use_separators, prog_name, stress_mode);
+	stats_poll(interval, use_separators, prog_name, &value, stress_mode);
 out:
 	free(cpu);
 	return err;
-- 
2.26.2

