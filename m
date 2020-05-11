Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1607E1CE561
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731643AbgEKUZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbgEKUZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 16:25:00 -0400
Received: from localhost.localdomain.com (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B066206E6;
        Mon, 11 May 2020 20:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589228699;
        bh=3Fv/LzO0yAUlesVoV9zizj4xjyauXSI+3Mbgil0DTqM=;
        h=From:To:Cc:Subject:Date:From;
        b=z9EwmRtZiBiZTeWRJBnVfXZadxJHyiI/fnxaj+OtoBlZug989cJv7Uup8gb5OjA33
         N8zbeXouwanCS/TRbO757KCfDTdXgGPuXxngSyiFYhrrZXTUO3qsv1kUFl41Wwj3GH
         p8xqYNAr/kR1ZT7tLzUYbvRB8AG3BfgGRHrApSSU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com
Subject: [PATCH bpf-next] samples/bpf: xdp_redirect_cpu: set MAX_CPUS according to NR_CPUS
Date:   Mon, 11 May 2020 22:24:21 +0200
Message-Id: <79b8dd36280e5629a5e64b89528f9d523cb7262b.1589227441.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_redirect_cpu is currently failing in bpf_prog_load_xattr()
allocating cpu_map map if CONFIG_NR_CPUS is less than 64 since
cpu_map_alloc() requires max_entries to be less than NR_CPUS.
Set cpu_map max_entries according to NR_CPUS in xdp_redirect_cpu_kern.c
and get currently running cpus in xdp_redirect_cpu_user.c

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_kern.c |  2 +-
 samples/bpf/xdp_redirect_cpu_user.c | 29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
index 313a8fe6d125..2baf8db1f7e7 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu_kern.c
@@ -15,7 +15,7 @@
 #include <bpf/bpf_helpers.h>
 #include "hash_func01.h"
 
-#define MAX_CPUS 64 /* WARNING - sync with _user.c */
+#define MAX_CPUS NR_CPUS
 
 /* Special map type that can XDP_REDIRECT frames to another CPU */
 struct {
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 15bdf047a222..100e72cb4cf5 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -13,6 +13,7 @@ static const char *__doc__ =
 #include <unistd.h>
 #include <locale.h>
 #include <sys/resource.h>
+#include <sys/sysinfo.h>
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
@@ -24,8 +25,6 @@ static const char *__doc__ =
 #include <arpa/inet.h>
 #include <linux/if_link.h>
 
-#define MAX_CPUS 64 /* WARNING - sync with _kern.c */
-
 /* How many xdp_progs are defined in _kern.c */
 #define MAX_PROG 6
 
@@ -40,6 +39,7 @@ static char *ifname;
 static __u32 prog_id;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int n_cpus;
 static int cpu_map_fd;
 static int rx_cnt_map_fd;
 static int redirect_err_cnt_map_fd;
@@ -170,7 +170,7 @@ struct stats_record {
 	struct record redir_err;
 	struct record kthread;
 	struct record exception;
-	struct record enq[MAX_CPUS];
+	struct record enq[];
 };
 
 static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
@@ -225,10 +225,11 @@ static struct datarec *alloc_record_per_cpu(void)
 static struct stats_record *alloc_stats_record(void)
 {
 	struct stats_record *rec;
-	int i;
+	int i, size;
 
-	rec = malloc(sizeof(*rec));
-	memset(rec, 0, sizeof(*rec));
+	size = sizeof(*rec) + n_cpus * sizeof(struct record);
+	rec = malloc(size);
+	memset(rec, 0, size);
 	if (!rec) {
 		fprintf(stderr, "Mem alloc error\n");
 		exit(EXIT_FAIL_MEM);
@@ -237,7 +238,7 @@ static struct stats_record *alloc_stats_record(void)
 	rec->redir_err.cpu = alloc_record_per_cpu();
 	rec->kthread.cpu   = alloc_record_per_cpu();
 	rec->exception.cpu = alloc_record_per_cpu();
-	for (i = 0; i < MAX_CPUS; i++)
+	for (i = 0; i < n_cpus; i++)
 		rec->enq[i].cpu = alloc_record_per_cpu();
 
 	return rec;
@@ -247,7 +248,7 @@ static void free_stats_record(struct stats_record *r)
 {
 	int i;
 
-	for (i = 0; i < MAX_CPUS; i++)
+	for (i = 0; i < n_cpus; i++)
 		free(r->enq[i].cpu);
 	free(r->exception.cpu);
 	free(r->kthread.cpu);
@@ -350,7 +351,7 @@ static void stats_print(struct stats_record *stats_rec,
 	}
 
 	/* cpumap enqueue stats */
-	for (to_cpu = 0; to_cpu < MAX_CPUS; to_cpu++) {
+	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
 		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
 		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
 		char *errstr = "";
@@ -475,7 +476,7 @@ static void stats_collect(struct stats_record *rec)
 	map_collect_percpu(fd, 1, &rec->redir_err);
 
 	fd = cpumap_enqueue_cnt_map_fd;
-	for (i = 0; i < MAX_CPUS; i++)
+	for (i = 0; i < n_cpus; i++)
 		map_collect_percpu(fd, i, &rec->enq[i]);
 
 	fd = cpumap_kthread_cnt_map_fd;
@@ -549,10 +550,10 @@ static int create_cpu_entry(__u32 cpu, __u32 queue_size,
  */
 static void mark_cpus_unavailable(void)
 {
-	__u32 invalid_cpu = MAX_CPUS;
+	__u32 invalid_cpu = n_cpus;
 	int ret, i;
 
-	for (i = 0; i < MAX_CPUS; i++) {
+	for (i = 0; i < n_cpus; i++) {
 		ret = bpf_map_update_elem(cpus_available_map_fd, &i,
 					  &invalid_cpu, 0);
 		if (ret) {
@@ -688,6 +689,8 @@ int main(int argc, char **argv)
 	int prog_fd;
 	__u32 qsize;
 
+	n_cpus = get_nprocs();
+
 	/* Notice: choosing he queue size is very important with the
 	 * ixgbe driver, because it's driver page recycling trick is
 	 * dependend on pages being returned quickly.  The number of
@@ -757,7 +760,7 @@ int main(int argc, char **argv)
 		case 'c':
 			/* Add multiple CPUs */
 			add_cpu = strtoul(optarg, NULL, 0);
-			if (add_cpu >= MAX_CPUS) {
+			if (add_cpu >= n_cpus) {
 				fprintf(stderr,
 				"--cpu nr too large for cpumap err(%d):%s\n",
 					errno, strerror(errno));
-- 
2.26.2

