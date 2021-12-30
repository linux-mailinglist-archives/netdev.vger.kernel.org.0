Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD12481928
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhL3D6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235655AbhL3D6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836733; x=1672372733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oRE/Ouq20toHwPXmADMDAGnRpYi0U/CeEOTCL3FwLDk=;
  b=JSXlXbSptgtuCciMRhiRPx7j29K5XRQIjzoQdJLkOB9Ws7EhRdRsN4tF
   oGfCrs6GIzlKkYR0SgT4H4dldXT7nA3pg6INEn14kHdqlKYJhwa8vO+pt
   okL3oDGD3uEMzCyCbGFeNs/d65FWT0akW/b7vfpMTmzc5n/TCRrOJq/ir
   8xiDYeuGeDJDsMk0golXOogntWXfNvUsY0pVyzSTzRMaOJyLexdtlNdVk
   bGuUfp0vRYqiYPnqeGaBvI/dvgcpagTkXtKqHG1XAGX/bHL2VrTuShRoX
   X9jJTW+ndpqsW3oyWmdp+hX83uby1+cKz6Gr+NmZCujr2C20O3v4A0ArN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154650"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154650"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801560"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:49 -0800
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
Subject: [PATCH bpf-next v2 7/7] samples/bpf: xdpsock: add timestamp for Tx-only operation
Date:   Thu, 30 Dec 2021 11:54:47 +0800
Message-Id: <20211230035447.523177-8-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230035447.523177-1-boon.leong.ong@intel.com>
References: <20211230035447.523177-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may be useful to add timestamp for Tx packets for continuous or cyclic
transmit operation. The timestamp and sequence ID of a Tx packet are
stored according to pktgen header format. To enable per-packet timestamp,
use -y|--tstamp option. If timestamp is off, pktgen header is not
included in the UDP payload. This means receiving side can use the magic
number for pktgen for differentiation.

The implementation supports both VLAN tagged and untagged option. By
default, the minimum packet size is set at 64B. However, if VLAN tagged
is on (-V), the minimum packet size is increased to 66B just so to fit
the pktgen_hdr size.

Added hex_dump() into the code path just for future cross-checking.
As before, simply change to "#define DEBUG_HEXDUMP 1" to inspect the
accuracy of TX packet.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 77 +++++++++++++++++++++++++++++++++-----
 1 file changed, 68 insertions(+), 9 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 319cb3cdb22..aa50864e441 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -111,6 +111,7 @@ static bool opt_app_stats;
 static const char *opt_irq_str = "";
 static u32 irq_no;
 static int irqs_at_init = -1;
+static u32 sequence;
 static int opt_poll;
 static int opt_interval = 1;
 static int opt_retries = 3;
@@ -129,6 +130,7 @@ static clockid_t opt_clock = CLOCK_MONOTONIC;
 static unsigned long opt_tx_cycle_ns;
 static int opt_schpolicy = SCHED_OTHER;
 static int opt_schprio = SCHED_PRI__DEFAULT;
+static bool opt_tstamp;
 
 struct vlan_ethhdr {
 	unsigned char h_dest[6];
@@ -138,6 +140,14 @@ struct vlan_ethhdr {
 	__be16 h_vlan_encapsulated_proto;
 };
 
+#define PKTGEN_MAGIC 0xbe9be955
+struct pktgen_hdr {
+	__be32 pgh_magic;
+	__be32 seq_num;
+	__be32 tv_sec;
+	__be32 tv_usec;
+};
+
 struct xsk_ring_stats {
 	unsigned long rx_npkts;
 	unsigned long tx_npkts;
@@ -836,18 +846,25 @@ static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len,
 
 #define ETH_HDR_SIZE (opt_vlan_tag ? sizeof(struct vlan_ethhdr) : \
 		      sizeof(struct ethhdr))
+#define PKTGEN_HDR_SIZE (opt_tstamp ? sizeof(struct pktgen_hdr) : 0)
 #define PKT_HDR_SIZE (ETH_HDR_SIZE + sizeof(struct iphdr) + \
-		      sizeof(struct udphdr))
+		      sizeof(struct udphdr) + PKTGEN_HDR_SIZE)
+#define PKTGEN_HDR_OFFSET (ETH_HDR_SIZE + sizeof(struct iphdr) + \
+			   sizeof(struct udphdr))
+#define PKTGEN_SIZE_MIN (PKTGEN_HDR_OFFSET + sizeof(struct pktgen_hdr) + \
+			 ETH_FCS_SIZE)
 
 #define PKT_SIZE		(opt_pkt_size - ETH_FCS_SIZE)
 #define IP_PKT_SIZE		(PKT_SIZE - ETH_HDR_SIZE)
 #define UDP_PKT_SIZE		(IP_PKT_SIZE - sizeof(struct iphdr))
-#define UDP_PKT_DATA_SIZE	(UDP_PKT_SIZE - sizeof(struct udphdr))
+#define UDP_PKT_DATA_SIZE	(UDP_PKT_SIZE - \
+				 (sizeof(struct udphdr) + PKTGEN_HDR_SIZE))
 
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 
 static void gen_eth_hdr_data(void)
 {
+	struct pktgen_hdr *pktgen_hdr;
 	struct udphdr *udp_hdr;
 	struct iphdr *ip_hdr;
 
@@ -860,7 +877,10 @@ static void gen_eth_hdr_data(void)
 					    sizeof(struct iphdr));
 		ip_hdr = (struct iphdr *)(pkt_data +
 					  sizeof(struct vlan_ethhdr));
-
+		pktgen_hdr = (struct pktgen_hdr *)(pkt_data +
+						   sizeof(struct vlan_ethhdr) +
+						   sizeof(struct iphdr) +
+						   sizeof(struct udphdr));
 		/* ethernet & VLAN header */
 		memcpy(veth_hdr->h_dest, &opt_txdmac, ETH_ALEN);
 		memcpy(veth_hdr->h_source, &opt_txsmac, ETH_ALEN);
@@ -877,7 +897,10 @@ static void gen_eth_hdr_data(void)
 					    sizeof(struct iphdr));
 		ip_hdr = (struct iphdr *)(pkt_data +
 					  sizeof(struct ethhdr));
-
+		pktgen_hdr = (struct pktgen_hdr *)(pkt_data +
+						   sizeof(struct ethhdr) +
+						   sizeof(struct iphdr) +
+						   sizeof(struct udphdr));
 		/* ethernet header */
 		memcpy(eth_hdr->h_dest, &opt_txdmac, ETH_ALEN);
 		memcpy(eth_hdr->h_source, &opt_txsmac, ETH_ALEN);
@@ -906,6 +929,9 @@ static void gen_eth_hdr_data(void)
 	udp_hdr->dest = htons(0x1000);
 	udp_hdr->len = htons(UDP_PKT_SIZE);
 
+	if (opt_tstamp)
+		pktgen_hdr->pgh_magic = htonl(PKTGEN_MAGIC);
+
 	/* UDP data */
 	memset32_htonl(pkt_data + PKT_HDR_SIZE, opt_pkt_fill_pattern,
 		       UDP_PKT_DATA_SIZE);
@@ -1049,6 +1075,7 @@ static struct option long_options[] = {
 	{"tx-dmac", required_argument, 0, 'G'},
 	{"tx-smac", required_argument, 0, 'H'},
 	{"tx-cycle", required_argument, 0, 'T'},
+	{"tstamp", no_argument, 0, 'y'},
 	{"policy", required_argument, 0, 'W'},
 	{"schpri", required_argument, 0, 'U'},
 	{"extra-stats", no_argument, 0, 'x'},
@@ -1099,6 +1126,7 @@ static void usage(const char *prog)
 		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -T, --tx-cycle=n     Tx cycle time in micro-seconds (For -t|--txonly).\n"
+		"  -y, --tstamp         Add time-stamp to packet (For -t|--txonly).\n"
 		"  -W, --policy=POLICY  Schedule policy. Default: SCHED_OTHER\n"
 		"  -U, --schpri=n       Schedule priority. Default: %d\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
@@ -1125,7 +1153,7 @@ static void parse_command_line(int argc, char **argv)
 
 	for (;;) {
 		c = getopt_long(argc, argv,
-				"Frtli:q:pSNn:w:O:czf:muMd:b:C:s:P:VJ:K:G:H:T:W:U:xQaI:BR",
+				"Frtli:q:pSNn:w:O:czf:muMd:b:C:s:P:VJ:K:G:H:T:yW:U:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1246,6 +1274,9 @@ static void parse_command_line(int argc, char **argv)
 			opt_tx_cycle_ns = atoi(optarg);
 			opt_tx_cycle_ns *= NSEC_PER_USEC;
 			break;
+		case 'y':
+			opt_tstamp = 1;
+			break;
 		case 'W':
 			if (get_schpolicy(&opt_schpolicy, optarg)) {
 				fprintf(stderr,
@@ -1462,9 +1493,10 @@ static void rx_drop_all(void)
 	}
 }
 
-static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
+static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb,
+		   int batch_size, unsigned long tx_ns)
 {
-	u32 idx;
+	u32 idx, tv_sec, tv_usec;
 	unsigned int i;
 
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
@@ -1474,11 +1506,31 @@ static int tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 			return 0;
 	}
 
+	if (opt_tstamp) {
+		tv_sec = (u32)(tx_ns / NSEC_PER_SEC);
+		tv_usec = (u32)((tx_ns % NSEC_PER_SEC) / 1000);
+	}
+
 	for (i = 0; i < batch_size; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx,
 								  idx + i);
 		tx_desc->addr = (*frame_nb + i) * opt_xsk_frame_size;
 		tx_desc->len = PKT_SIZE;
+
+		if (opt_tstamp) {
+			struct pktgen_hdr *pktgen_hdr;
+			u64 addr = tx_desc->addr;
+			char *pkt;
+
+			pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
+			pktgen_hdr = (struct pktgen_hdr *)(pkt + PKTGEN_HDR_OFFSET);
+
+			pktgen_hdr->seq_num = htonl(sequence++);
+			pktgen_hdr->tv_sec = htonl(tv_sec);
+			pktgen_hdr->tv_usec = htonl(tv_usec);
+
+			hex_dump(pkt, PKT_SIZE, addr);
+		}
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
@@ -1552,6 +1604,7 @@ static void tx_only_all(void)
 
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
+		unsigned long tx_ns = 0;
 		struct timespec next;
 		int tx_cnt = 0;
 		long diff;
@@ -1581,7 +1634,8 @@ static void tx_only_all(void)
 			}
 
 			/* Measure periodic Tx scheduling variance */
-			diff = get_nsecs() - next_tx_ns;
+			tx_ns = get_nsecs();
+			diff = tx_ns - next_tx_ns;
 			if (diff < tx_cycle_diff_min)
 				tx_cycle_diff_min = diff;
 
@@ -1590,10 +1644,12 @@ static void tx_only_all(void)
 
 			tx_cycle_diff_ave += (double)diff;
 			tx_cycle_cnt++;
+		} else if (opt_tstamp) {
+			tx_ns = get_nsecs();
 		}
 
 		for (i = 0; i < num_socks; i++)
-			tx_cnt += tx_only(xsks[i], &frame_nb[i], batch_size);
+			tx_cnt += tx_only(xsks[i], &frame_nb[i], batch_size, tx_ns);
 
 		pkt_cnt += tx_cnt;
 
@@ -1895,6 +1951,9 @@ int main(int argc, char **argv)
 		apply_setsockopt(xsks[i]);
 
 	if (opt_bench == BENCH_TXONLY) {
+		if (opt_tstamp && opt_pkt_size < PKTGEN_SIZE_MIN)
+			opt_pkt_size = PKTGEN_SIZE_MIN;
+
 		gen_eth_hdr_data();
 
 		for (i = 0; i < NUM_FRAMES; i++)
-- 
2.25.1

