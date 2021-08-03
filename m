Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0BB3DF3A2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237810AbhHCRKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:10:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:16898 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237732AbhHCRKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:10:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213466147"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213466147"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:22 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521327165"
Received: from shyamasr-mobl.amr.corp.intel.com ([10.209.65.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:20 -0700
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com
Cc:     Jithu Joseph <jithu.joseph@intel.com>
Subject: [RFC bpf-next 5/5] samples/bpf/xdpsock_user.c: Launchtime/TXTIME API usage
Date:   Tue,  3 Aug 2021 13:10:06 -0400
Message-Id: <20210803171006.13915-6-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20210803171006.13915-1-kishen.maloor@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jithu Joseph <jithu.joseph@intel.com>

Adds -L flag to the xdpsock commandline options. Using this
in conjuction with "-t txonly" option exercises the
Launchtime/Txtime APIs. These allows the application to specify
when each packet should be transmitted by the NIC.

Below is an example of how this option may be exercised:

sudo xdpsock -i enp1s0  -t -q 1 -N -s 128 -z -L

The above invocation would transmit  "batch_size" packets each spaced
1us apart. The first packet in the batch is to be launched
"LAUNCH_TIME_ADVANCE_NS" into the future and the remaining packets
in the batch should be spaced 1us apart.

Since launch-time enabled NICs would wait LAUNCH_TIME_ADVANCE_NS(500us)
between batches of packets, the emphasis of this path is not throughput.

Launch-time should be enabled for the chosen hardware queue using the
appropriate tc qdisc command before starting the application and
also NIC hardware clock should be synchronized to the system clock
using a mechanism like phc2sys.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 samples/bpf/xdpsock_user.c | 64 +++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 3fd2f6a0d1eb..a0fd3d5414ba 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -55,6 +55,9 @@
 
 #define DEBUG_HEXDUMP 0
 
+#define LAUNCH_TIME_ADVANCE_NS (500000)
+#define CLOCK_SYNC_DELAY (60)
+
 typedef __u64 u64;
 typedef __u32 u32;
 typedef __u16 u16;
@@ -99,6 +102,7 @@ static u32 opt_num_xsks = 1;
 static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
+static bool opt_launch_time;
 
 struct xsk_ring_stats {
 	unsigned long rx_npkts;
@@ -741,6 +745,8 @@ static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len,
 
 #define ETH_FCS_SIZE 4
 
+#define MD_SIZE (sizeof(struct xdp_user_tx_metadata))
+
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 		      sizeof(struct udphdr))
 
@@ -798,8 +804,10 @@ static void gen_eth_hdr_data(void)
 
 static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 {
-	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data,
-	       PKT_SIZE);
+	if (opt_launch_time)
+		memcpy(xsk_umem__get_data(umem->buffer, addr) + MD_SIZE, pkt_data, PKT_SIZE);
+	else
+		memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
 }
 
 static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
@@ -927,6 +935,7 @@ static struct option long_options[] = {
 	{"irq-string", no_argument, 0, 'I'},
 	{"busy-poll", no_argument, 0, 'B'},
 	{"reduce-cap", no_argument, 0, 'R'},
+	{"launch-time", no_argument, 0, 'L'},
 	{0, 0, 0, 0}
 };
 
@@ -967,6 +976,7 @@ static void usage(const char *prog)
 		"  -I, --irq-string	Display driver interrupt statistics for interface associated with irq-string.\n"
 		"  -B, --busy-poll      Busy poll.\n"
 		"  -R, --reduce-cap	Use reduced capabilities (cannot be used with -M)\n"
+		"  -L, --launch-time	Toy example of launchtime using XDP\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
@@ -982,7 +992,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:BRL",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1087,6 +1097,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'R':
 			opt_reduced_cap = true;
 			break;
+		case 'L':
+			opt_launch_time = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -1272,6 +1285,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 {
 	u32 idx;
 	unsigned int i;
+	u64 cur_ts, launch_time;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
 				      batch_size) {
@@ -1280,10 +1294,28 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 			return;
 	}
 
+	cur_ts = get_nsecs(CLOCK_TAI);
+
 	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
-		tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size;
+		if (opt_launch_time) {
+			/*
+			 * Direct the NIC to launch "batch_size" packets each spaced 1us apart.
+			 * The below calculation specifies that the first packet in the batch
+			 * is to be launched "LAUNCH_TIME_ADVANCE_NS" into the future and the
+			 * remaining packets in the batch should be spaced 1us apart.
+			 */
+			launch_time = cur_ts + LAUNCH_TIME_ADVANCE_NS + (1000 * i);
+			xsk_umem__set_md_txtime(xsk->umem->buffer,
+						((*frame_nb + i) * opt_xsk_frame_size),
+						launch_time);
+			tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size + MD_SIZE;
+			tx_desc->options = XDP_DESC_OPTION_METADATA;
+		} else {
+			tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size;
+		}
+
 		tx_desc->len = PKT_SIZE;
 	}
 
@@ -1293,6 +1325,16 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	*frame_nb += batch_size;
 	*frame_nb %= NUM_FRAMES;
 	complete_tx_only(xsk, batch_size);
+	if (opt_launch_time) {
+		/*
+		 * Hold the Tx loop until all the frames from this batch has been
+		 * transmitted by the driver. This also ensures that all packets from
+		 * this batch reach the driver ASAP before the proposed future launchtime
+		 * becomes stale
+		 */
+		while (xsk->outstanding_tx)
+			complete_tx_only(xsk, opt_batch_size);
+	}
 }
 
 static inline int get_batch_size(int pkt_cnt)
@@ -1334,6 +1376,20 @@ static void tx_only_all(void)
 		fds[0].events = POLLOUT;
 	}
 
+	if (opt_launch_time) {
+		/*
+		 * For launch-time to be meaningful, the system clock and NIC h/w clock
+		 * needs to be synchronized. Many NIC driver implementations resets the NIC
+		 * during the bind operation in the XDP initialization flow path.
+		 * The delay below is intended as a best case approach to hold off packet
+		 * transmission till the syncronization is acheived.
+		 */
+		xsk_socket__enable_so_txtime(xsks[0]->xsk, true);
+		printf("Waiting for %ds for the NIC clock to synchronize with the system clock\n",
+		       CLOCK_SYNC_DELAY);
+		sleep(CLOCK_SYNC_DELAY);
+	}
+
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
 
-- 
2.24.3 (Apple Git-128)

