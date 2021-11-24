Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619DB45B74F
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhKXJYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:24:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:54118 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhKXJYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 04:24:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232735397"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232735397"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 01:20:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674799160"
Received: from sashimi-thinkstation-p920.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 01:20:52 -0800
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
Subject: [PATCH bpf-next 1/4] samples/bpf: xdpsock: add VLAN support for Tx-only operation
Date:   Wed, 24 Nov 2021 17:18:18 +0800
Message-Id: <20211124091821.3916046-2-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211124091821.3916046-1-boon.leong.ong@intel.com>
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In multi-queue environment testing, the support for VLAN-tag based
steering is useful. So, this patch adds the capability to add
VLAN tag (VLAN ID and Priority) to the generated Tx frame.

To set the VLAN ID=10 and Priority=2 for Tx only through TxQ=3:
 $ xdpsock -i eth0 -t -N -z -q 3 -V -J 10 -K 2

If VLAN ID (-J) and Priority (-K) is set, it default to
  VLAN ID = 1
  VLAN Priority = 0.

For example, VLAN-tagged Tx only, xdp copy mode through TxQ=1:
 $ xdpsock -i eth0 -t -N -c -q 1 -V

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 90 +++++++++++++++++++++++++++++++-------
 1 file changed, 75 insertions(+), 15 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 49d7a6ad7e3..e09fabecd69 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -53,6 +53,12 @@
 
 #define DEBUG_HEXDUMP 0
 
+#define VLAN_PRIO_MASK		0xe000 /* Priority Code Point */
+#define VLAN_PRIO_SHIFT		13
+#define VLAN_VID_MASK		0x0fff /* VLAN Identifier */
+#define VLAN_VID__DEFAULT	1
+#define VLAN_PRI__DEFAULT	0
+
 typedef __u64 u64;
 typedef __u32 u32;
 typedef __u16 u16;
@@ -78,6 +84,9 @@ static u32 opt_batch_size = 64;
 static int opt_pkt_count;
 static u16 opt_pkt_size = MIN_PKT_SIZE;
 static u32 opt_pkt_fill_pattern = 0x12345678;
+static bool opt_vlan_tag;
+static u16 opt_pkt_vlan_id = VLAN_VID__DEFAULT;
+static u16 opt_pkt_vlan_pri = VLAN_PRI__DEFAULT;
 static bool opt_extra_stats;
 static bool opt_quiet;
 static bool opt_app_stats;
@@ -98,6 +107,14 @@ static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
 
+struct vlan_ethhdr {
+	unsigned char h_dest[6];
+	unsigned char h_source[6];
+	__be16 h_vlan_proto;
+	__be16 h_vlan_TCI;
+	__be16 h_vlan_encapsulated_proto;
+};
+
 struct xsk_ring_stats {
 	unsigned long rx_npkts;
 	unsigned long tx_npkts;
@@ -737,11 +754,13 @@ static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len,
 
 #define ETH_FCS_SIZE 4
 
-#define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
+#define ETH_HDR_SIZE (opt_vlan_tag ? sizeof(struct vlan_ethhdr) : \
+		      sizeof(struct ethhdr))
+#define PKT_HDR_SIZE (ETH_HDR_SIZE + sizeof(struct iphdr) + \
 		      sizeof(struct udphdr))
 
 #define PKT_SIZE		(opt_pkt_size - ETH_FCS_SIZE)
-#define IP_PKT_SIZE		(PKT_SIZE - sizeof(struct ethhdr))
+#define IP_PKT_SIZE		(PKT_SIZE - ETH_HDR_SIZE)
 #define UDP_PKT_SIZE		(IP_PKT_SIZE - sizeof(struct iphdr))
 #define UDP_PKT_DATA_SIZE	(UDP_PKT_SIZE - sizeof(struct udphdr))
 
@@ -749,17 +768,42 @@ static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 
 static void gen_eth_hdr_data(void)
 {
-	struct udphdr *udp_hdr = (struct udphdr *)(pkt_data +
-						   sizeof(struct ethhdr) +
-						   sizeof(struct iphdr));
-	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data +
-						sizeof(struct ethhdr));
-	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
-
-	/* ethernet header */
-	memcpy(eth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
-	memcpy(eth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
-	eth_hdr->h_proto = htons(ETH_P_IP);
+	struct udphdr *udp_hdr;
+	struct iphdr *ip_hdr;
+
+	if (opt_vlan_tag) {
+		struct vlan_ethhdr *veth_hdr = (struct vlan_ethhdr *)pkt_data;
+		u16 vlan_tci = 0;
+
+		udp_hdr = (struct udphdr *)(pkt_data +
+					    sizeof(struct vlan_ethhdr) +
+					    sizeof(struct iphdr));
+		ip_hdr = (struct iphdr *)(pkt_data +
+					  sizeof(struct vlan_ethhdr));
+
+		/* ethernet & VLAN header */
+		memcpy(veth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
+		memcpy(veth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+		veth_hdr->h_vlan_proto = htons(ETH_P_8021Q);
+		vlan_tci = opt_pkt_vlan_id & VLAN_VID_MASK;
+		vlan_tci |= (opt_pkt_vlan_pri << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;
+		veth_hdr->h_vlan_TCI = htons(vlan_tci);
+		veth_hdr->h_vlan_encapsulated_proto = htons(ETH_P_IP);
+	} else {
+		struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
+
+		udp_hdr = (struct udphdr *)(pkt_data +
+					    sizeof(struct ethhdr) +
+					    sizeof(struct iphdr));
+		ip_hdr = (struct iphdr *)(pkt_data +
+					  sizeof(struct ethhdr));
+
+		/* ethernet header */
+		memcpy(eth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
+		memcpy(eth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+		eth_hdr->h_proto = htons(ETH_P_IP);
+	}
+
 
 	/* IP header */
 	ip_hdr->version = IPVERSION;
@@ -917,6 +961,9 @@ static struct option long_options[] = {
 	{"tx-pkt-count", required_argument, 0, 'C'},
 	{"tx-pkt-size", required_argument, 0, 's'},
 	{"tx-pkt-pattern", required_argument, 0, 'P'},
+	{"tx-vlan", no_argument, 0, 'V'},
+	{"tx-vlan-id", required_argument, 0, 'J'},
+	{"tx-vlan-pri", required_argument, 0, 'K'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
@@ -957,6 +1004,9 @@ static void usage(const char *prog)
 		"			(Default: %d bytes)\n"
 		"			Min size: %d, Max size %d.\n"
 		"  -P, --tx-pkt-pattern=nPacket fill pattern. Default: 0x%x\n"
+		"  -V, --tx-vlan        Send VLAN tagged  packets (For -t|--txonly)\n"
+		"  -J, --tx-vlan-id=n   Tx VLAN ID [1-4095]. Default: %d (For -V|--tx-vlan)\n"
+		"  -K, --tx-vlan-pri=n  Tx VLAN Priority [0-7]. Default: %d (For -V|--tx-vlan)\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
@@ -966,7 +1016,8 @@ static void usage(const char *prog)
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
-		XSK_UMEM__DEFAULT_FRAME_SIZE, opt_pkt_fill_pattern);
+		XSK_UMEM__DEFAULT_FRAME_SIZE, opt_pkt_fill_pattern,
+		VLAN_VID__DEFAULT, VLAN_PRI__DEFAULT);
 
 	exit(EXIT_FAILURE);
 }
@@ -978,7 +1029,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1059,6 +1110,15 @@ static void parse_command_line(int argc, char **argv)
 		case 'P':
 			opt_pkt_fill_pattern = strtol(optarg, NULL, 16);
 			break;
+		case 'V':
+			opt_vlan_tag = true;
+			break;
+		case 'J':
+			opt_pkt_vlan_id = atoi(optarg);
+			break;
+		case 'K':
+			opt_pkt_vlan_pri = atoi(optarg);
+			break;
 		case 'x':
 			opt_extra_stats = 1;
 			break;
-- 
2.25.1

