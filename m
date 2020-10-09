Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51273288DA6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389550AbgJIQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388882AbgJIQEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:04:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4E0C0613D2;
        Fri,  9 Oct 2020 09:04:10 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g9so7522018pgh.8;
        Fri, 09 Oct 2020 09:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7TQ83eOdZ4FjcmEwBPTJUQmUcFxDoGvC50jVJ9z1QZ8=;
        b=uRirM4zHWOxlMK2yQO4FOrMdgovMThVlnnsBWxbyJbSHl7bnzGc6uaA2WwyM2gUkCd
         Df5LTgh9Zm0omMOWmP4wmqcyXCLSlkJ8854+ag/hz1U6TAXAp7Q9mhnP5Jn05KIMMeqr
         beKxThVAKSCBMRNaY/Gj7HiJwXwfZiAMxQ7EnM3aGMQwyQ4TUx+19jSvq18pQtfTc8zP
         /ZOIupzM5wkLDz60+ESIVBNViYo477cmPhu54LO00ILZk+opYP0o6v1iVhmAVGpKYpsq
         WYA+WecW/FyVJnW3fQKa/+ma7muqzCUpIoFtkM8OLuJcnktOnFQGc8OFEefXexGeleV+
         vIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TQ83eOdZ4FjcmEwBPTJUQmUcFxDoGvC50jVJ9z1QZ8=;
        b=CySHUREPXriBobSRHuwTn110JSJ+06gkGJiMUZkRv8z2ZcsWdd8riUcC7eR4ugjjyj
         L8PoIJ1v+yAjBp+Stx1GMgrEiEAS3rX1wi4rhkZH+uz92Z7lGkGsSSmS16T6rv+Ivk6j
         xxEZyRbWsabm+ALR4JQ8TVyRyhBuP1WYUpVQbI2kl05JSZWgL1p3t6ErW6C2/lxwV8a0
         NKURF8YYCP6CWGbaQH/gbuVBFgMek3ET7dNRGTlEc9Mj3r9Bj+c8POOc01IHurfcFWMy
         BaUQWnkwMHi+AXIwpCQF6BkvLCUc7JLQpv8ZHXEdtsfhTToPVJgrwWXWSHA1d9rT8sSg
         jR+g==
X-Gm-Message-State: AOAM533MW8W80BJ+tF4J0tY2FiYx1EAXl8Ztll2bNGnIaBnivgiQRRi0
        VY26bEUUkEEyL5H34LcM3Q==
X-Google-Smtp-Source: ABdhPJwYfc0gmnliqufd7THSOF0Jx28Yza1U9oR5ikZRUBHcaqFQvzQBuVOVqOTyzVhfQpVMale8sQ==
X-Received: by 2002:a65:580c:: with SMTP id g12mr3980112pgr.257.1602259450400;
        Fri, 09 Oct 2020 09:04:10 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id y19sm11287435pfp.52.2020.10.09.09.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 09:04:09 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 1/3] samples: bpf: Refactor xdp_monitor with libbpf
Date:   Sat, 10 Oct 2020 01:03:51 +0900
Message-Id: <20201009160353.1529-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201009160353.1529-1-danieltimlee@gmail.com>
References: <20201009160353.1529-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid confusion caused by the increasing fragmentation of the BPF
Loader program, this commit would like to change to the libbpf loader
instead of using the bpf_load.

Thanks to libbpf's bpf_link interface, managing the tracepoint BPF
program is much easier. bpf_program__attach_tracepoint manages the
enable of tracepoint event and attach of BPF programs to it with a
single interface bpf_link, so there is no need to manage event_fd and
prog_fd separately.

This commit refactors xdp_monitor with using this libbpf API, and the
bpf_load is removed and migrated to libbpf.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile           |   2 +-
 samples/bpf/xdp_monitor_user.c | 144 ++++++++++++++++++++++++---------
 2 files changed, 108 insertions(+), 38 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4f1ed0e3cf9f..0cee2aa8970f 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -99,7 +99,7 @@ per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
-xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
+xdp_monitor-objs := xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index ef53b93db573..c627c53d6ada 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -26,12 +26,36 @@ static const char *__doc_err_only__=
 #include <net/if.h>
 #include <time.h>
 
+#include <signal.h>
 #include <bpf/bpf.h>
-#include "bpf_load.h"
+#include <bpf/libbpf.h>
 #include "bpf_util.h"
 
+enum map_type {
+	REDIRECT_ERR_CNT,
+	EXCEPTION_CNT,
+	CPUMAP_ENQUEUE_CNT,
+	CPUMAP_KTHREAD_CNT,
+	DEVMAP_XMIT_CNT,
+};
+
+static const char *const map_type_strings[] = {
+	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
+	[EXCEPTION_CNT] = "exception_cnt",
+	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
+	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
+	[DEVMAP_XMIT_CNT] = "devmap_xmit_cnt",
+};
+
+#define NUM_MAP 5
+#define NUM_TP 8
+
+static int tp_cnt;
+static int map_cnt;
 static int verbose = 1;
 static bool debug = false;
+struct bpf_map *map_data[NUM_MAP] = { 0 };
+struct bpf_link *tp_links[NUM_TP] = { 0 };
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -41,6 +65,15 @@ static const struct option long_options[] = {
 	{0, 0, NULL,  0 }
 };
 
+static void int_exit(int sig)
+{
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
+	exit(0);
+}
+
 /* C standard specifies two constants, EXIT_SUCCESS(0) and EXIT_FAILURE(1) */
 #define EXIT_FAIL_MEM	5
 
@@ -483,23 +516,23 @@ static bool stats_collect(struct stats_record *rec)
 	 * this can happen by someone running perf-record -e
 	 */
 
-	fd = map_data[0].fd; /* map0: redirect_err_cnt */
+	fd = bpf_map__fd(map_data[REDIRECT_ERR_CNT]);
 	for (i = 0; i < REDIR_RES_MAX; i++)
 		map_collect_record_u64(fd, i, &rec->xdp_redirect[i]);
 
-	fd = map_data[1].fd; /* map1: exception_cnt */
+	fd = bpf_map__fd(map_data[EXCEPTION_CNT]);
 	for (i = 0; i < XDP_ACTION_MAX; i++) {
 		map_collect_record_u64(fd, i, &rec->xdp_exception[i]);
 	}
 
-	fd = map_data[2].fd; /* map2: cpumap_enqueue_cnt */
+	fd = bpf_map__fd(map_data[CPUMAP_ENQUEUE_CNT]);
 	for (i = 0; i < MAX_CPUS; i++)
 		map_collect_record(fd, i, &rec->xdp_cpumap_enqueue[i]);
 
-	fd = map_data[3].fd; /* map3: cpumap_kthread_cnt */
+	fd = bpf_map__fd(map_data[CPUMAP_KTHREAD_CNT]);
 	map_collect_record(fd, 0, &rec->xdp_cpumap_kthread);
 
-	fd = map_data[4].fd; /* map4: devmap_xmit_cnt */
+	fd = bpf_map__fd(map_data[DEVMAP_XMIT_CNT]);
 	map_collect_record(fd, 0, &rec->xdp_devmap_xmit);
 
 	return true;
@@ -598,8 +631,8 @@ static void stats_poll(int interval, bool err_only)
 
 	/* TODO Need more advanced stats on error types */
 	if (verbose) {
-		printf(" - Stats map0: %s\n", map_data[0].name);
-		printf(" - Stats map1: %s\n", map_data[1].name);
+		printf(" - Stats map0: %s\n", bpf_map__name(map_data[0]));
+		printf(" - Stats map1: %s\n", bpf_map__name(map_data[1]));
 		printf("\n");
 	}
 	fflush(stdout);
@@ -616,46 +649,52 @@ static void stats_poll(int interval, bool err_only)
 	free_stats_record(prev);
 }
 
-static void print_bpf_prog_info(void)
+static void print_bpf_prog_info(struct bpf_object *obj)
 {
-	int i;
+	struct bpf_program *prog;
+	struct bpf_map *map;
+	int i = 0;
 
 	/* Prog info */
-	printf("Loaded BPF prog have %d bpf program(s)\n", prog_cnt);
-	for (i = 0; i < prog_cnt; i++) {
-		printf(" - prog_fd[%d] = fd(%d)\n", i, prog_fd[i]);
+	printf("Loaded BPF prog have %d bpf program(s)\n", tp_cnt);
+	bpf_object__for_each_program(prog, obj) {
+		printf(" - prog_fd[%d] = fd(%d)\n", i++, bpf_program__fd(prog));
 	}
 
+	i = 0;
 	/* Maps info */
-	printf("Loaded BPF prog have %d map(s)\n", map_data_count);
-	for (i = 0; i < map_data_count; i++) {
-		char *name = map_data[i].name;
-		int fd     = map_data[i].fd;
+	printf("Loaded BPF prog have %d map(s)\n", map_cnt);
+	bpf_object__for_each_map(map, obj) {
+		const char *name = bpf_map__name(map);
+		int fd		 = bpf_map__fd(map);
 
-		printf(" - map_data[%d] = fd(%d) name:%s\n", i, fd, name);
+		printf(" - map_data[%d] = fd(%d) name:%s\n", i++, fd, name);
 	}
 
 	/* Event info */
-	printf("Searching for (max:%d) event file descriptor(s)\n", prog_cnt);
-	for (i = 0; i < prog_cnt; i++) {
-		if (event_fd[i] != -1)
-			printf(" - event_fd[%d] = fd(%d)\n", i, event_fd[i]);
+	printf("Searching for (max:%d) event file descriptor(s)\n", tp_cnt);
+	for (i = 0; i < tp_cnt; i++) {
+		int fd = bpf_link__fd(tp_links[i]);
+
+		if (fd != -1)
+			printf(" - event_fd[%d] = fd(%d)\n", i, fd);
 	}
 }
 
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_program *prog;
+	struct bpf_object *obj;
 	int longindex = 0, opt;
 	int ret = EXIT_SUCCESS;
-	char bpf_obj_file[256];
+	enum map_type type;
+	char filename[256];
 
 	/* Default settings: */
 	bool errors_only = true;
 	int interval = 2;
 
-	snprintf(bpf_obj_file, sizeof(bpf_obj_file), "%s_kern.o", argv[0]);
-
 	/* Parse commands line args */
 	while ((opt = getopt_long(argc, argv, "hDSs:",
 				  long_options, &longindex)) != -1) {
@@ -676,33 +715,64 @@ int main(int argc, char **argv)
 		}
 	}
 
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
 		perror("setrlimit(RLIMIT_MEMLOCK)");
 		return EXIT_FAILURE;
 	}
 
-	if (load_bpf_file(bpf_obj_file)) {
-		printf("ERROR - bpf_log_buf: %s", bpf_log_buf);
+	/* Remove tracepoint program when program is interrupted or killed */
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		printf("ERROR: opening BPF object file failed\n");
+		obj = NULL;
 		return EXIT_FAILURE;
 	}
-	if (!prog_fd[0]) {
-		printf("ERROR - load_bpf_file: %s\n", strerror(errno));
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		printf("ERROR: loading BPF object file failed\n");
 		return EXIT_FAILURE;
 	}
 
+	for (type = 0; type < NUM_MAP; type++) {
+		map_data[type] =
+			bpf_object__find_map_by_name(obj, map_type_strings[type]);
+
+		if (libbpf_get_error(map_data[type])) {
+			printf("ERROR: finding a map in obj file failed\n");
+			return EXIT_FAILURE;
+		}
+		map_cnt++;
+	}
+
+	bpf_object__for_each_program(prog, obj) {
+		tp_links[tp_cnt] = bpf_program__attach(prog);
+		if (libbpf_get_error(tp_links[tp_cnt])) {
+			printf("ERROR: bpf_program__attach failed\n");
+			tp_links[tp_cnt] = NULL;
+			return EXIT_FAILURE;
+		}
+		tp_cnt++;
+	}
+
 	if (debug) {
-		print_bpf_prog_info();
+		print_bpf_prog_info(obj);
 	}
 
-	/* Unload/stop tracepoint event by closing fd's */
+	/* Unload/stop tracepoint event by closing bpf_link's */
 	if (errors_only) {
-		/* The prog_fd[i] and event_fd[i] depend on the
-		 * order the functions was defined in _kern.c
+		/* The bpf_link[i] depend on the order of
+		 * the functions was defined in _kern.c
 		 */
-		close(event_fd[2]); /* tracepoint/xdp/xdp_redirect */
-		close(prog_fd[2]);  /* func: trace_xdp_redirect */
-		close(event_fd[3]); /* tracepoint/xdp/xdp_redirect_map */
-		close(prog_fd[3]);  /* func: trace_xdp_redirect_map */
+		bpf_link__destroy(tp_links[2]);	/* tracepoint/xdp/xdp_redirect */
+		tp_links[2] = NULL;
+
+		bpf_link__destroy(tp_links[3]);	/* tracepoint/xdp/xdp_redirect_map */
+		tp_links[3] = NULL;
 	}
 
 	stats_poll(interval, errors_only);
-- 
2.25.1

