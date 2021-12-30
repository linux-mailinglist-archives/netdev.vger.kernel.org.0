Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37350481922
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbhL3D6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhL3D6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836720; x=1672372720;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9aVPYndc9Wg5HQBqqI8m8H5Kq7Ppvb3tsb4FHCaoJ0w=;
  b=IbQfktWMPBP0u/onJuh6tJ2qolnf6LvJYma3AcmRK9CXHInvGxNjzdE/
   VYYYC+La/00jVy79AVXL1Ic1ATfkF+EKMTru4CiwQXpQWrjFI3ScQGk93
   u1hsOyk6rGzrhPfsFLR4P8kLT19vJPFArCiu+z6VfFrJ2gIjqTzlX3T4y
   qy/thuF8T/HCYCMpylOfZd62s1M8z1LGnIRYQ+bVSqM9DdrfFqm4L0tCC
   Upg8j3nA0qyQdMPiMPRLZlvS3EYMDrVAiTTLBuJOVopq7croRsrjiJLLy
   0n4rGuy+4eRSadS/MqirqEz7H1tx6asdzZS1wZ6k2TOmiWArcMVTDaDBT
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154635"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154635"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801543"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:36 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next v2 4/7] samples/bpf: xdpsock: add cyclic TX operation capability
Date:   Thu, 30 Dec 2021 11:54:44 +0800
Message-Id: <20211230035447.523177-5-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230035447.523177-1-boon.leong.ong@intel.com>
References: <20211230035447.523177-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx cycle time is in micro-seconds unit. By combining the batch size (-b M)
and Tx cycle time (-T|--tx-cycle N), xdpsock now can transmit batch-size of
packets every N-us periodically. Cyclic TX operation is not applicable if
--poll mode is used.

To transmit 16 packets every 1ms cycle time for total of 100000 packets
silently:
 $ xdpsock -i eth0 -T -N -z -T 1000 -b 16 -C 100000

To print cyclic TX schedule variance stats, use --app-stats|-a:
 $ xdpsock -i eth0 -T -N -z -T 1000 -b 16 -C 100000 -a

 sock0@eth0:0 txonly xdp-drv
                   pps            pkts           0.00
rx                 0              0
tx                 0              100000

                   calls/s        count
rx empty polls     0              0
fill fail polls    0              0
copy tx sendtos    0              0
tx wakeup sendtos  0              6254
opt polls          0              0

                   period     min        ave        max        cycle
Cyclic TX          1000000    53507      75334      712642     6250

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 85 +++++++++++++++++++++++++++++++++++---
 1 file changed, 80 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index e6e9a20375c..a2a42ec4b0e 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -63,12 +63,19 @@
 #define VLAN_VID__DEFAULT	1
 #define VLAN_PRI__DEFAULT	0
 
+#define NSEC_PER_SEC		1000000000UL
+#define NSEC_PER_USEC		1000
+
 typedef __u64 u64;
 typedef __u32 u32;
 typedef __u16 u16;
 typedef __u8  u8;
 
 static unsigned long prev_time;
+static long tx_cycle_diff_min;
+static long tx_cycle_diff_max;
+static double tx_cycle_diff_ave;
+static long tx_cycle_cnt;
 
 enum benchmark_type {
 	BENCH_RXDROP = 0,
@@ -115,6 +122,7 @@ static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
 static clockid_t opt_clock = CLOCK_MONOTONIC;
+static unsigned long opt_tx_cycle_ns;
 
 struct vlan_ethhdr {
 	unsigned char h_dest[6];
@@ -305,6 +313,15 @@ static void dump_app_stats(long dt)
 		xsks[i]->app_stats.prev_tx_wakeup_sendtos = xsks[i]->app_stats.tx_wakeup_sendtos;
 		xsks[i]->app_stats.prev_opt_polls = xsks[i]->app_stats.opt_polls;
 	}
+
+	if (opt_tx_cycle_ns) {
+		printf("\n%-18s %-10s %-10s %-10s %-10s %-10s\n",
+		       "", "period", "min", "ave", "max", "cycle");
+		printf("%-18s %-10lu %-10lu %-10lu %-10lu %-10lu\n",
+		       "Cyclic TX", opt_tx_cycle_ns, tx_cycle_diff_min,
+		       (long)(tx_cycle_diff_ave / tx_cycle_cnt),
+		       tx_cycle_diff_max, tx_cycle_cnt);
+	}
 }
 
 static bool get_interrupt_number(void)
@@ -1001,6 +1018,7 @@ static struct option long_options[] = {
 	{"tx-vlan-pri", required_argument, 0, 'K'},
 	{"tx-dmac", required_argument, 0, 'G'},
 	{"tx-smac", required_argument, 0, 'H'},
+	{"tx-cycle", required_argument, 0, 'T'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
@@ -1047,6 +1065,7 @@ static void usage(const char *prog)
 		"  -K, --tx-vlan-pri=n  Tx VLAN Priority [0-7]. Default: %d (For -V|--tx-vlan)\n"
 		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
+		"  -T, --tx-cycle=n     Tx cycle time in micro-seconds (For -t|--txonly).\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
@@ -1069,7 +1088,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:w:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:w:czf:muMd:b:C:s:P:VJ:K:G:H:T:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1183,6 +1202,10 @@ static void parse_command_line(int argc, char **argv)
 				usage(basename(argv[0]));
 			}
 			break;
+		case 'T':
+			opt_tx_cycle_ns = atoi(optarg);
+			opt_tx_cycle_ns *= NSEC_PER_USEC;
+			break;
 		case 'x':
 			opt_extra_stats = 1;
 			break;
@@ -1388,7 +1411,7 @@ static void rx_drop_all(void)
 	}
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
+static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
@@ -1397,7 +1420,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 				      batch_size) {
 		complete_tx_only(xsk, batch_size);
 		if (benchmark_done)
-			return;
+			return 0;
 	}
 
 	for (i = 0; i < batch_size; i++) {
@@ -1413,6 +1436,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	*frame_nb += batch_size;
 	*frame_nb %= NUM_FRAMES;
 	complete_tx_only(xsk, batch_size);
+
+	return batch_size;
 }
 
 static inline int get_batch_size(int pkt_cnt)
@@ -1446,16 +1471,39 @@ static void tx_only_all(void)
 {
 	struct pollfd fds[MAX_SOCKS] = {};
 	u32 frame_nb[MAX_SOCKS] = {};
+	unsigned long next_tx_ns = 0;
 	int pkt_cnt = 0;
 	int i, ret;
 
+	if (opt_poll && opt_tx_cycle_ns) {
+		fprintf(stderr,
+			"Error: --poll and --tx-cycles are both set\n");
+		return;
+	}
+
 	for (i = 0; i < num_socks; i++) {
 		fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
 		fds[0].events = POLLOUT;
 	}
 
+	if (opt_tx_cycle_ns) {
+		/* Align Tx time to micro-second boundary */
+		next_tx_ns = (get_nsecs() / NSEC_PER_USEC + 1) *
+			     NSEC_PER_USEC;
+		next_tx_ns += opt_tx_cycle_ns;
+
+		/* Initialize periodic Tx scheduling variance */
+		tx_cycle_diff_min = 1000000000;
+		tx_cycle_diff_max = 0;
+		tx_cycle_diff_ave = 0.0;
+	}
+
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
+		struct timespec next;
+		int tx_cnt = 0;
+		long diff;
+		int err;
 
 		if (opt_poll) {
 			for (i = 0; i < num_socks; i++)
@@ -1468,13 +1516,40 @@ static void tx_only_all(void)
 				continue;
 		}
 
+		if (opt_tx_cycle_ns) {
+			next.tv_sec = next_tx_ns / NSEC_PER_SEC;
+			next.tv_nsec = next_tx_ns % NSEC_PER_SEC;
+			err = clock_nanosleep(opt_clock, TIMER_ABSTIME, &next, NULL);
+			if (err) {
+				if (err != EINTR)
+					fprintf(stderr,
+						"clock_nanosleep failed. Err:%d errno:%d\n",
+						err, errno);
+				break;
+			}
+
+			/* Measure periodic Tx scheduling variance */
+			diff = get_nsecs() - next_tx_ns;
+			if (diff < tx_cycle_diff_min)
+				tx_cycle_diff_min = diff;
+
+			if (diff > tx_cycle_diff_max)
+				tx_cycle_diff_max = diff;
+
+			tx_cycle_diff_ave += (double)diff;
+			tx_cycle_cnt++;
+		}
+
 		for (i = 0; i < num_socks; i++)
-			tx_only(xsks[i], &frame_nb[i], batch_size);
+			tx_cnt += tx_only(xsks[i], &frame_nb[i], batch_size);
 
-		pkt_cnt += batch_size;
+		pkt_cnt += tx_cnt;
 
 		if (benchmark_done)
 			break;
+
+		if (opt_tx_cycle_ns)
+			next_tx_ns += opt_tx_cycle_ns;
 	}
 
 	if (opt_pkt_count)
-- 
2.25.1

