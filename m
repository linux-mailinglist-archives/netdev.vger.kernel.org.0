Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D985812779B
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLTIz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:55:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:34861 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbfLTIzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:55:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 00:55:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,335,1571727600"; 
   d="scan'208";a="218434375"
Received: from unknown (HELO localhost.localdomain) ([10.190.210.212])
  by orsmga006.jf.intel.com with ESMTP; 20 Dec 2019 00:55:12 -0800
Received: from localhost.localdomain (localhost [127.0.0.1])
        by localhost.localdomain (8.15.2/8.15.2/Debian-10) with ESMTPS id xBK8tYGH005036
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Fri, 20 Dec 2019 14:25:34 +0530
Received: (from root@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id xBK8tYtc005035;
        Fri, 20 Dec 2019 14:25:34 +0530
From:   Jay Jayatheerthan <jay.jayatheerthan@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        Jay Jayatheerthan <jay.jayatheerthan@intel.com>
Subject: [PATCH bpf-next 1/6] samples/bpf: xdpsock: Add duration option to specify how long to run
Date:   Fri, 20 Dec 2019 14:25:25 +0530
Message-Id: <20191220085530.4980-2-jay.jayatheerthan@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
References: <20191220085530.4980-1-jay.jayatheerthan@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The application now supports '-d' or '--duration' option to specify number of
seconds to run. This is used in tx, rx and l2fwd features. If this option is
not provided, the application runs forever.

Signed-off-by: Jay Jayatheerthan <jay.jayatheerthan@intel.com>
---
 samples/bpf/xdpsock_user.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index e7829e5baaff..e188a79a9c31 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -65,6 +65,9 @@ static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static const char *opt_if = "";
 static int opt_ifindex;
 static int opt_queue;
+static unsigned long opt_duration;
+static unsigned long start_time;
+static bool benchmark_done;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -167,10 +170,21 @@ static void dump_stats(void)
 	}
 }
 
+static bool is_benchmark_done(void)
+{
+	if (opt_duration > 0) {
+		unsigned long dt = (get_nsecs() - start_time);
+
+		if (dt >= opt_duration)
+			benchmark_done = true;
+	}
+	return benchmark_done;
+}
+
 static void *poller(void *arg)
 {
 	(void)arg;
-	for (;;) {
+	while (!is_benchmark_done()) {
 		sleep(opt_interval);
 		dump_stats();
 	}
@@ -375,6 +389,7 @@ static struct option long_options[] = {
 	{"unaligned", no_argument, 0, 'u'},
 	{"shared-umem", no_argument, 0, 'M'},
 	{"force", no_argument, 0, 'F'},
+	{"duration", required_argument, 0, 'd'},
 	{0, 0, 0, 0}
 };
 
@@ -399,6 +414,8 @@ static void usage(const char *prog)
 		"  -u, --unaligned	Enable unaligned chunk placement\n"
 		"  -M, --shared-umem	Enable XDP_SHARED_UMEM\n"
 		"  -F, --force		Force loading the XDP prog\n"
+		"  -d, --duration=n	Duration in secs to run command.\n"
+		"			Default: forever.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
 	exit(EXIT_FAILURE);
@@ -411,7 +428,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:muM",
+		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:muMd:",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -469,6 +486,10 @@ static void parse_command_line(int argc, char **argv)
 		case 'M':
 			opt_num_xsks = MAX_SOCKS;
 			break;
+		case 'd':
+			opt_duration = atoi(optarg);
+			opt_duration *= 1000000000;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -622,6 +643,9 @@ static void rx_drop_all(void)
 
 		for (i = 0; i < num_socks; i++)
 			rx_drop(xsks[i], fds);
+
+		if (benchmark_done)
+			break;
 	}
 }
 
@@ -671,6 +695,9 @@ static void tx_only_all(void)
 
 		for (i = 0; i < num_socks; i++)
 			tx_only(xsks[i], frame_nb[i]);
+
+		if (benchmark_done)
+			break;
 	}
 }
 
@@ -739,6 +766,9 @@ static void l2fwd_all(void)
 
 		for (i = 0; i < num_socks; i++)
 			l2fwd(xsks[i], fds);
+
+		if (benchmark_done)
+			break;
 	}
 }
 
@@ -852,6 +882,7 @@ int main(int argc, char **argv)
 		exit_with_error(ret);
 
 	prev_time = get_nsecs();
+	start_time = prev_time;
 
 	if (opt_bench == BENCH_RXDROP)
 		rx_drop_all();
@@ -860,5 +891,7 @@ int main(int argc, char **argv)
 	else
 		l2fwd_all();
 
+	pthread_join(pt, NULL);
+
 	return 0;
 }
-- 
2.17.1

