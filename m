Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6263A45B753
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbhKXJZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:25:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:54155 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhKXJZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 04:25:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232735528"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232735528"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 01:21:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674799226"
Received: from sashimi-thinkstation-p920.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 01:21:01 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
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
        KP Singh <kpsingh@kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH bpf-next 3/4] samples/bpf: xdpsock: add period cycle time to Tx operation
Date:   Wed, 24 Nov 2021 17:18:20 +0800
Message-Id: <20211124091821.3916046-4-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211124091821.3916046-1-boon.leong.ong@intel.com>
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx cycle time is in micro-seconds unit. By combining the batch size (-b M)
and Tx cycle time (-T|--tx-cycle N), xdpsock now can transmit batch-size of
packets every N-us periodically.

For example to transmit 1 packet each 1ms cycle time for total of 2000000
packets:

 $ xdpsock -i eth0 -T -N -z -T 1000 -b 1 -C 2000000

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 1000           1996872

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 1000           1997872

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 1000           1998872

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 1000           1999872

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           1.00
rx                 0              0
tx                 128            2000000

 sock0@enp0s29f1:2 txonly xdp-drv
                   pps            pkts           0.00
rx                 0              0
tx                 0              2000000

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 691f442bbb2..61d4063f11a 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -111,6 +111,7 @@ static u32 opt_num_xsks = 1;
 static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
+static unsigned long opt_cycle_time;
 
 struct vlan_ethhdr {
 	unsigned char h_dest[6];
@@ -173,6 +174,8 @@ struct xsk_socket_info {
 	struct xsk_app_stats app_stats;
 	struct xsk_driver_stats drv_stats;
 	u32 outstanding_tx;
+	unsigned long prev_tx_time;
+	unsigned long tx_cycle_time;
 };
 
 static int num_socks;
@@ -972,6 +975,7 @@ static struct option long_options[] = {
 	{"tx-vlan-pri", required_argument, 0, 'K'},
 	{"tx-dmac", required_argument, 0, 'G'},
 	{"tx-smac", required_argument, 0, 'H'},
+	{"tx-cycle", required_argument, 0, 'T'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
@@ -1017,6 +1021,7 @@ static void usage(const char *prog)
 		"  -K, --tx-vlan-pri=n  Tx VLAN Priority [0-7]. Default: %d (For -V|--tx-vlan)\n"
 		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
+		"  -T, --tx-cycle=n     Tx cycle time in micro-seconds (For -t|--txonly).\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
@@ -1039,7 +1044,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:T:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1145,6 +1150,10 @@ static void parse_command_line(int argc, char **argv)
 				usage(basename(argv[0]));
 			}
 			break;
+		case 'T':
+			opt_cycle_time = atoi(optarg);
+			opt_cycle_time *= 1000;
+			break;
 		case 'x':
 			opt_extra_stats = 1;
 			break;
@@ -1350,16 +1359,25 @@ static void rx_drop_all(void)
 	}
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
+static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
 
+	if (xsk->tx_cycle_time) {
+		unsigned long now = get_nsecs();
+
+		if ((now - xsk->prev_tx_time) < xsk->tx_cycle_time)
+			return 0;
+
+		xsk->prev_tx_time = now;
+	}
+
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
 				      batch_size) {
 		complete_tx_only(xsk, batch_size);
 		if (benchmark_done)
-			return;
+			return 0;
 	}
 
 	for (i = 0; i < batch_size; i++) {
@@ -1375,6 +1393,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	*frame_nb += batch_size;
 	*frame_nb %= NUM_FRAMES;
 	complete_tx_only(xsk, batch_size);
+
+	return batch_size;
 }
 
 static inline int get_batch_size(int pkt_cnt)
@@ -1407,6 +1427,7 @@ static void complete_tx_only_all(void)
 static void tx_only_all(void)
 {
 	struct pollfd fds[MAX_SOCKS] = {};
+	unsigned long now = get_nsecs();
 	u32 frame_nb[MAX_SOCKS] = {};
 	int pkt_cnt = 0;
 	int i, ret;
@@ -1414,10 +1435,15 @@ static void tx_only_all(void)
 	for (i = 0; i < num_socks; i++) {
 		fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
 		fds[0].events = POLLOUT;
+		if (opt_cycle_time) {
+			xsks[i]->prev_tx_time = now;
+			xsks[i]->tx_cycle_time = opt_cycle_time;
+		}
 	}
 
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
+		int tx_cnt = 0;
 
 		if (opt_poll) {
 			for (i = 0; i < num_socks; i++)
@@ -1431,9 +1457,9 @@ static void tx_only_all(void)
 		}
 
 		for (i = 0; i < num_socks; i++)
-			tx_only(xsks[i], &frame_nb[i], batch_size);
+			tx_cnt += tx_only(xsks[i], &frame_nb[i], batch_size);
 
-		pkt_cnt += batch_size;
+		pkt_cnt += tx_cnt;
 
 		if (benchmark_done)
 			break;
-- 
2.25.1

