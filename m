Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7252F45B751
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhKXJZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:25:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:54132 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhKXJZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 04:25:01 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="232735455"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="232735455"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 01:21:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="674799205"
Received: from sashimi-thinkstation-p920.png.intel.com ([10.158.65.178])
  by orsmga005.jf.intel.com with ESMTP; 24 Nov 2021 01:20:56 -0800
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
Subject: [PATCH bpf-next 2/4] samples/bpf: xdpsock: add Dest and Src MAC setting for Tx-only operation
Date:   Wed, 24 Nov 2021 17:18:19 +0800
Message-Id: <20211124091821.3916046-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211124091821.3916046-1-boon.leong.ong@intel.com>
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To set Dest MAC address (-G|--tx-dmac) only:
 $ xdpsock -i eth0 -t -N -z -G aa:bb:cc:dd:ee:ff

To set Source MAC address (-H|--tx-smac) only:
 $ xdpsock -i eth0 -t -N -z -H 11:22:33:44:55:66

To set both Dest and Source MAC address:
 $ xdpsock -i eth0 -t -N -z -G aa:bb:cc:dd:ee:ff \
   -H 11:22:33:44:55:66

The default Dest and Source MAC address remain the same as before.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index e09fabecd69..691f442bbb2 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -14,6 +14,7 @@
 #include <arpa/inet.h>
 #include <locale.h>
 #include <net/ethernet.h>
+#include <netinet/ether.h>
 #include <net/if.h>
 #include <poll.h>
 #include <pthread.h>
@@ -87,6 +88,10 @@ static u32 opt_pkt_fill_pattern = 0x12345678;
 static bool opt_vlan_tag;
 static u16 opt_pkt_vlan_id = VLAN_VID__DEFAULT;
 static u16 opt_pkt_vlan_pri = VLAN_PRI__DEFAULT;
+static struct ether_addr opt_txdmac = {{ 0x3c, 0xfd, 0xfe,
+					 0x9e, 0x7f, 0x71 }};
+static struct ether_addr opt_txsmac = {{ 0xec, 0xb1, 0xd7,
+					 0x98, 0x3a, 0xc0 }};
 static bool opt_extra_stats;
 static bool opt_quiet;
 static bool opt_app_stats;
@@ -782,8 +787,9 @@ static void gen_eth_hdr_data(void)
 					  sizeof(struct vlan_ethhdr));
 
 		/* ethernet & VLAN header */
-		memcpy(veth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
-		memcpy(veth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+
+		memcpy(veth_hdr->h_dest, &opt_txdmac, ETH_ALEN);
+		memcpy(veth_hdr->h_source, &opt_txsmac, ETH_ALEN);
 		veth_hdr->h_vlan_proto = htons(ETH_P_8021Q);
 		vlan_tci = opt_pkt_vlan_id & VLAN_VID_MASK;
 		vlan_tci |= (opt_pkt_vlan_pri << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;
@@ -799,8 +805,8 @@ static void gen_eth_hdr_data(void)
 					  sizeof(struct ethhdr));
 
 		/* ethernet header */
-		memcpy(eth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
-		memcpy(eth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+		memcpy(eth_hdr->h_dest, &opt_txdmac, ETH_ALEN);
+		memcpy(eth_hdr->h_source, &opt_txsmac, ETH_ALEN);
 		eth_hdr->h_proto = htons(ETH_P_IP);
 	}
 
@@ -964,6 +970,8 @@ static struct option long_options[] = {
 	{"tx-vlan", no_argument, 0, 'V'},
 	{"tx-vlan-id", required_argument, 0, 'J'},
 	{"tx-vlan-pri", required_argument, 0, 'K'},
+	{"tx-dmac", required_argument, 0, 'G'},
+	{"tx-smac", required_argument, 0, 'H'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
@@ -1007,6 +1015,8 @@ static void usage(const char *prog)
 		"  -V, --tx-vlan        Send VLAN tagged  packets (For -t|--txonly)\n"
 		"  -J, --tx-vlan-id=n   Tx VLAN ID [1-4095]. Default: %d (For -V|--tx-vlan)\n"
 		"  -K, --tx-vlan-pri=n  Tx VLAN Priority [0-7]. Default: %d (For -V|--tx-vlan)\n"
+		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
+		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
@@ -1029,7 +1039,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1119,6 +1129,22 @@ static void parse_command_line(int argc, char **argv)
 		case 'K':
 			opt_pkt_vlan_pri = atoi(optarg);
 			break;
+		case 'G':
+			if (!ether_aton_r(optarg,
+					  (struct ether_addr *)&opt_txdmac)) {
+				fprintf(stderr, "Invalid dmac address:%s\n",
+					optarg);
+				usage(basename(argv[0]));
+			}
+			break;
+		case 'H':
+			if (!ether_aton_r(optarg,
+					  (struct ether_addr *)&opt_txsmac)) {
+				fprintf(stderr, "Invalid smac address:%s\n",
+					optarg);
+				usage(basename(argv[0]));
+			}
+			break;
 		case 'x':
 			opt_extra_stats = 1;
 			break;
-- 
2.25.1

