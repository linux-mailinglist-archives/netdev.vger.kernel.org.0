Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7F1DECF4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730652AbgEVQMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730627AbgEVQMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 12:12:01 -0400
Received: from localhost.localdomain.com (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 272082078D;
        Fri, 22 May 2020 16:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590163920;
        bh=ojW/ndKpAjlzGYxqaelvsnqo95x+vwcQ2J1XBA7kCxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsWC2BIsG3FguQ5N2B1hzhHKK5K3MhapLmTr0WworZEOVSukl/XGh5gF2RFH0OXK1
         VIqJY2mH8nkc2LUEya6Vd9CcQPnSO0wuTTsAq6HrvFfxiKfBdf3taar15S9yrJqskm
         DWjpK9roWKegFD451BvDIxQdNkVba6nPjxTUt9p8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [RFC bpf-next 2/2] samples/bpf: xdp_redirect_cpu: load a eBPF program on cpu_map
Date:   Fri, 22 May 2020 18:11:32 +0200
Message-Id: <306cf77cf6c849d4ccac5d1ac685e709badcc1e6.1590162098.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1590162098.git.lorenzo@kernel.org>
References: <cover.1590162098.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xdp_redirect_cpu_{usr,kern}.c adding the possibility to load a
simple XDP program on each cpu_map entry that just returns XDP_PASS

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_kern.c | 24 ++++++++-
 samples/bpf/xdp_redirect_cpu_user.c | 83 ++++++++++++++++++++++++-----
 2 files changed, 93 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index 2baf8db1f7e7..72d322ae295a 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -17,11 +17,17 @@
 
 #define MAX_CPUS NR_CPUS
 
+/* Special map type that can XDP_REDIRECT frames to another CPU */
+struct cpu_map_entry {
+	__u32 prog_id;
+	__u32 qsize;
+};
+
 /* Special map type that can XDP_REDIRECT frames to another CPU */
 struct {
 	__uint(type, BPF_MAP_TYPE_CPUMAP);
 	__uint(key_size, sizeof(u32));
-	__uint(value_size, sizeof(u32));
+	__uint(value_size, sizeof(struct cpu_map_entry));
 	__uint(max_entries, MAX_CPUS);
 } cpu_map SEC(".maps");
 
@@ -30,6 +36,9 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
+	__u64 xdp_redirect;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
 };
 
 /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
@@ -227,6 +236,19 @@ int  xdp_prognum0_no_touch(struct xdp_md *ctx)
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
+SEC("xdp_cpu_prog_pass")
+int xdp_cpumap_prog_pass(struct xdp_md *ctx)
+{
+	struct datarec *rec;
+	u32 key = 0;
+
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (rec)
+		rec->xdp_pass++;
+
+	return XDP_PASS;
+}
+
 SEC("xdp_cpu_map1_touch_data")
 int  xdp_prognum1_touch_data(struct xdp_md *ctx)
 {
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index f3468168982e..f60875f32cd9 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -30,6 +30,11 @@ static const char *__doc__ =
 
 #include "bpf_util.h"
 
+struct cpu_map_entry {
+	__u32 prog_id;
+	__u32 qsize;
+};
+
 static int ifindex = -1;
 static char ifname_buf[IF_NAMESIZE];
 static char *ifname;
@@ -156,6 +161,9 @@ struct datarec {
 	__u64 processed;
 	__u64 dropped;
 	__u64 issue;
+	__u64 xdp_redirect;
+	__u64 xdp_pass;
+	__u64 xdp_drop;
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
+	rec->total.xdp_redirect  = sum_xdp_redirect;
+	rec->total.xdp_pass  = sum_xdp_pass;
+	rec->total.xdp_drop  = sum_xdp_drop;
 	return true;
 }
 
@@ -340,11 +360,20 @@ static void stats_print(struct stats_record *stats_rec,
 			if (pps > 0)
 				printf(fmt_rx, "XDP-RX",
 					i, pps, drop, err, errstr);
+			printf("cpu%d: xdp_pass %llu "
+			       "xdp_drop %llu xdp_redirect %llu\n",
+			       i, r->xdp_pass - p->xdp_pass,
+			       r->xdp_drop - p->xdp_drop,
+			       r->xdp_redirect - p->xdp_redirect);
 		}
 		pps  = calc_pps(&rec->total, &prev->total, t);
 		drop = calc_drop_pps(&rec->total, &prev->total, t);
 		err  = calc_errs_pps(&rec->total, &prev->total, t);
 		printf(fm2_rx, "XDP-RX", "total", pps, drop);
+		printf("xdp_pass %llu xdp_drop %llu xdp_redirect %llu\n",
+		       rec->total.xdp_pass - prev->total.xdp_pass,
+		       rec->total.xdp_drop - prev->total.xdp_drop,
+		       rec->total.xdp_redirect - prev->total.xdp_redirect);
 	}
 
 	/* cpumap enqueue stats */
@@ -495,8 +524,13 @@ static inline void swap(struct stats_record **a, struct stats_record **b)
 }
 
 static int create_cpu_entry(__u32 cpu, __u32 queue_size,
-			    __u32 avail_idx, bool new)
+			    __u32 avail_idx, int prog_id,
+			    bool new)
 {
+	struct cpu_map_entry prog_map_entry = {
+		.qsize = queue_size,
+		.prog_id = prog_id,
+	};
 	__u32 curr_cpus_count = 0;
 	__u32 key = 0;
 	int ret;
@@ -504,7 +538,7 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(cpu_map_fd, &cpu, &queue_size, 0);
+	ret = bpf_map_update_elem(cpu_map_fd, &cpu, &prog_map_entry, 0);
 	if (ret) {
 		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
 		exit(EXIT_FAIL_BPF);
@@ -561,19 +595,19 @@ static void mark_cpus_unavailable(void)
 }
 
 /* Stress cpumap management code by concurrently changing underlying cpumap */
-static void stress_cpumap(void)
+static void stress_cpumap(__u32 prog_id)
 {
 	/* Changing qsize will cause kernel to free and alloc a new
 	 * bpf_cpu_map_entry, with an associated/complicated tear-down
 	 * procedure.
 	 */
-	create_cpu_entry(1,  1024, 0, false);
-	create_cpu_entry(1,     8, 0, false);
-	create_cpu_entry(1, 16000, 0, false);
+	create_cpu_entry(1,  1024, 0, prog_id, false);
+	create_cpu_entry(1,     8, 0, prog_id, false);
+	create_cpu_entry(1, 16000, 0, prog_id, false);
 }
 
 static void stats_poll(int interval, bool use_separators, char *prog_name,
-		       bool stress_mode)
+		       bool stress_mode, __u32 prog_id)
 {
 	struct stats_record *record, *prev;
 
@@ -591,7 +625,7 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 		stats_print(record, prev, prog_name);
 		sleep(interval);
 		if (stress_mode)
-			stress_cpumap();
+			stress_cpumap(prog_id);
 	}
 
 	free_stats_record(record);
@@ -666,16 +700,17 @@ static int init_map_fds(struct bpf_object *obj)
 
 int main(int argc, char **argv)
 {
+	__u32 info_len = sizeof(struct bpf_prog_info), cpu_map_prog_id;
 	struct rlimit r = {10 * 1024 * 1024, RLIM_INFINITY};
 	char *prog_name = "xdp_cpu_map5_lb_hash_ip_pairs";
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
+	struct bpf_program *prog, *cpu_map_prog;
 	struct bpf_prog_info info = {};
-	__u32 info_len = sizeof(info);
+	int prog_fd, cpu_map_prog_fd;
 	bool use_separators = true;
 	bool stress_mode = false;
-	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char filename[256];
 	int added_cpus = 0;
@@ -683,7 +718,6 @@ int main(int argc, char **argv)
 	int interval = 2;
 	int add_cpu = -1;
 	int opt, err;
-	int prog_fd;
 	__u32 qsize;
 
 	n_cpus = get_nprocs_conf();
@@ -719,6 +753,24 @@ int main(int argc, char **argv)
 	}
 	mark_cpus_unavailable();
 
+	cpu_map_prog = bpf_object__find_program_by_title(obj,
+							 "xdp_cpu_prog_pass");
+	if (!cpu_map_prog) {
+		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
+		return EXIT_FAIL;
+	}
+	cpu_map_prog_fd = bpf_program__fd(cpu_map_prog);
+	if (cpu_map_prog_fd < 0) {
+		fprintf(stderr, "bpf_program__fd failed\n");
+		return EXIT_FAIL;
+	}
+	err = bpf_obj_get_info_by_fd(cpu_map_prog_fd, &info, &info_len);
+	if (err) {
+		printf("can't get prog info - %s\n", strerror(errno));
+		return err;
+	}
+	cpu_map_prog_id = info.id;
+
 	/* Parse commands line args */
 	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzF",
 				  long_options, &longindex)) != -1) {
@@ -763,7 +815,8 @@ int main(int argc, char **argv)
 					errno, strerror(errno));
 				goto error;
 			}
-			create_cpu_entry(add_cpu, qsize, added_cpus, true);
+			create_cpu_entry(add_cpu, qsize, added_cpus,
+					 cpu_map_prog_id, true);
 			added_cpus++;
 			break;
 		case 'q':
@@ -818,6 +871,9 @@ int main(int argc, char **argv)
 		return EXIT_FAIL_XDP;
 	}
 
+	memset(&info, 0, sizeof(info));
+	info_len = sizeof(struct bpf_prog_info);
+
 	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
 	if (err) {
 		printf("can't get prog info - %s\n", strerror(errno));
@@ -825,6 +881,7 @@ int main(int argc, char **argv)
 	}
 	prog_id = info.id;
 
-	stats_poll(interval, use_separators, prog_name, stress_mode);
+	stats_poll(interval, use_separators, prog_name, stress_mode,
+		   cpu_map_prog_id);
 	return EXIT_OK;
 }
-- 
2.26.2

