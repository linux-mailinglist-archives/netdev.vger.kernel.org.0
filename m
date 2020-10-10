Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA6628A3DD
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389535AbgJJWzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730234AbgJJTtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:49:32 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB960C0613E7;
        Sat, 10 Oct 2020 03:44:29 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f19so9097030pfj.11;
        Sat, 10 Oct 2020 03:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7XtdEIP/yMYueLEMBvBgxI2I7uijB3xDVdLEjuFSqs8=;
        b=NNvnDy902xeSBWv18xDhNY9YCijgL/LQlbw2ITLcbbT1yStbUi6e6KO4Nt5aH+PuuA
         IsF9SwQlxklQM+cWFTVl1bK8z6ZT5QWGKGvhLYgs2ZwDPcd5AFTuFoF4e8cS04aIXfSw
         2IEgA7OQzeEH0guNKZh75h5aXj0IzvltJ8FVrd9aSpPjmaWpHp+LgK0wZ25AEuv7JOow
         f0YSKBzH4K4lIhSV5Ii7/XnjGRXQliL4zoQr2U4V876E3NYEpbpGr0UElW5Sn6piwJxe
         L7RS9ShIBeO4LEOaP3ED/Hm/Abm28S4rYct/Y2grsCQyTuz0KXp3ntpycTA1Ciz/j6fg
         gtGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7XtdEIP/yMYueLEMBvBgxI2I7uijB3xDVdLEjuFSqs8=;
        b=h4H752sN3QOLHQCgLHleKzW3lVIEMvhFQks5oPOj3xkre+fecQdwqW++i/Ji65zrnW
         9ATqlMoO30jUZ9X+ZffGNnBauHHiS1d/XgYjJbEcmCbzw3SRoQVZ1bYAL8oVHJ1ER6kH
         +6OUPLWCHPx7jCLDaeoubJDE2wg3fdXQnrv2iNJtzvB+Jw2uFz0xROAcFpT0uGYMHH33
         4Vb5R15GlI8Av3KNJkVtZjDbFX/eRcx4HlueTDhtK1P71xEpLsH6rwElas/J3O+BkAFM
         inL5FF0JEVSLS4UqsRFc5vbJ58LVnYCyj/Fq2/6H6ZlB9DRNf2bND8NblvHh4XKL+nHL
         Q+Iw==
X-Gm-Message-State: AOAM5311f5HRw1XWXuhcz3393+F+j+L6pY48448xpEy5IjMQqzHlD6OP
        SHFIQlg7rAZ2SpqIu/5SMA==
X-Google-Smtp-Source: ABdhPJwpAlBKEVdw4DEvKvEkTQq6Chn0XkiBZioZMpVxYCTEYXMzxDtRMwtRN6iPe8XNxPA1BohDHA==
X-Received: by 2002:a17:90a:7f8c:: with SMTP id m12mr9933456pjl.22.1602326669421;
        Sat, 10 Oct 2020 03:44:29 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n127sm13307286pfn.155.2020.10.10.03.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 03:44:28 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 1/3] samples: bpf: Refactor xdp_monitor with libbpf
Date:   Sat, 10 Oct 2020 19:44:14 +0900
Message-Id: <20201010104416.1421-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201010104416.1421-1-danieltimlee@gmail.com>
References: <20201010104416.1421-1-danieltimlee@gmail.com>
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
Changes in v2:
 - added cleanup logic for bpf_link and bpf_object
 - split increment into seperate satement
 - refactor pointer array initialization

 samples/bpf/Makefile           |   2 +-
 samples/bpf/xdp_monitor_user.c | 159 +++++++++++++++++++++++++--------
 2 files changed, 121 insertions(+), 40 deletions(-)

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
index ef53b93db573..03d0a182913f 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -26,12 +26,37 @@ static const char *__doc_err_only__=
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
+struct bpf_map *map_data[NUM_MAP] = {};
+struct bpf_link *tp_links[NUM_TP] = {};
+struct bpf_object *obj;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -41,6 +66,16 @@ static const struct option long_options[] = {
 	{0, 0, NULL,  0 }
 };
 
+static void int_exit(int sig)
+{
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
+	bpf_object__close(obj);
+	exit(0);
+}
+
 /* C standard specifies two constants, EXIT_SUCCESS(0) and EXIT_FAILURE(1) */
 #define EXIT_FAIL_MEM	5
 
@@ -483,23 +518,23 @@ static bool stats_collect(struct stats_record *rec)
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
@@ -598,8 +633,8 @@ static void stats_poll(int interval, bool err_only)
 
 	/* TODO Need more advanced stats on error types */
 	if (verbose) {
-		printf(" - Stats map0: %s\n", map_data[0].name);
-		printf(" - Stats map1: %s\n", map_data[1].name);
+		printf(" - Stats map0: %s\n", bpf_map__name(map_data[0]));
+		printf(" - Stats map1: %s\n", bpf_map__name(map_data[1]));
 		printf("\n");
 	}
 	fflush(stdout);
@@ -618,44 +653,51 @@ static void stats_poll(int interval, bool err_only)
 
 static void print_bpf_prog_info(void)
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
+		printf(" - prog_fd[%d] = fd(%d)\n", i, bpf_program__fd(prog));
+		i++;
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
 
 		printf(" - map_data[%d] = fd(%d) name:%s\n", i, fd, name);
+		i++;
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
 	int longindex = 0, opt;
-	int ret = EXIT_SUCCESS;
-	char bpf_obj_file[256];
+	int ret = EXIT_FAILURE;
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
@@ -672,40 +714,79 @@ int main(int argc, char **argv)
 		case 'h':
 		default:
 			usage(argv);
-			return EXIT_FAILURE;
+			return ret;
 		}
 	}
 
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
 		perror("setrlimit(RLIMIT_MEMLOCK)");
-		return EXIT_FAILURE;
+		return ret;
 	}
 
-	if (load_bpf_file(bpf_obj_file)) {
-		printf("ERROR - bpf_log_buf: %s", bpf_log_buf);
-		return EXIT_FAILURE;
+	/* Remove tracepoint program when program is interrupted or killed */
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj)) {
+		printf("ERROR: opening BPF object file failed\n");
+		obj = NULL;
+		goto cleanup;
+	}
+
+	/* load BPF program */
+	if (bpf_object__load(obj)) {
+		printf("ERROR: loading BPF object file failed\n");
+		goto cleanup;
+	}
+
+	for (type = 0; type < NUM_MAP; type++) {
+		map_data[type] =
+			bpf_object__find_map_by_name(obj, map_type_strings[type]);
+
+		if (libbpf_get_error(map_data[type])) {
+			printf("ERROR: finding a map in obj file failed\n");
+			goto cleanup;
+		}
+		map_cnt++;
 	}
-	if (!prog_fd[0]) {
-		printf("ERROR - load_bpf_file: %s\n", strerror(errno));
-		return EXIT_FAILURE;
+
+	bpf_object__for_each_program(prog, obj) {
+		tp_links[tp_cnt] = bpf_program__attach(prog);
+		if (libbpf_get_error(tp_links[tp_cnt])) {
+			printf("ERROR: bpf_program__attach failed\n");
+			tp_links[tp_cnt] = NULL;
+			goto cleanup;
+		}
+		tp_cnt++;
 	}
 
 	if (debug) {
 		print_bpf_prog_info();
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
 
+	ret = EXIT_SUCCESS;
+
+cleanup:
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
+	bpf_object__close(obj);
 	return ret;
 }
-- 
2.25.1

