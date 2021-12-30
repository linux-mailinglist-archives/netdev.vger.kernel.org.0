Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9F48191E
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbhL3D6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:58:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:3816 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233004AbhL3D6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 22:58:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640836712; x=1672372712;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n4dCRbk8wrr5bdAIsDms8x7I3EKsrTvye882PklfrUI=;
  b=VwcSuKvfbDSEvWtyEtXrAteVluLsaWa4HgTVCwcxlnOzdi9o344MkiNH
   WeHr32c96avdpG1R3Z6gUpsNzWCjDEHm2G0N8LTfYWcwa4GAgrv4DzUCV
   Tb+pjWpmZ9nLDideeUbuuIZbBtDtL9xx4XI7TlAKCQcuvMZeN94Z7weEE
   BxqXNJbUDCfF+xAby+CexOJ6xvZUJnulnxXZe/IK2HKbzw8qJdmL48ZHJ
   lPDgZuUtEB7G4qmyTaycp3WlpDgzeBbynUuDZY76PKj0kbs1HHxpXpwkX
   E3NrSfAHgq5pEXLXboKnfLqUeFSgs0obv02z8v6qJU+xREpPMoP3LLm45
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10212"; a="239154620"
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="239154620"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 19:58:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,247,1635231600"; 
   d="scan'208";a="609801534"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 19:58:28 -0800
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
Subject: [PATCH bpf-next v2 2/7] samples/bpf: xdpsock: add Dest and Src MAC setting for Tx-only operation
Date:   Thu, 30 Dec 2021 11:54:42 +0800
Message-Id: <20211230035447.523177-3-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211230035447.523177-1-boon.leong.ong@intel.com>
References: <20211230035447.523177-1-boon.leong.ong@intel.com>
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

Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 samples/bpf/xdpsock_user.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index d5e298ccf49..c9a8748a460 100644
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
@@ -90,6 +91,10 @@ static u32 opt_pkt_fill_pattern = 0x12345678;
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
@@ -785,8 +790,8 @@ static void gen_eth_hdr_data(void)
 					  sizeof(struct vlan_ethhdr));
 
 		/* ethernet & VLAN header */
-		memcpy(veth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
-		memcpy(veth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+		memcpy(veth_hdr->h_dest, &opt_txdmac, ETH_ALEN);
+		memcpy(veth_hdr->h_source, &opt_txsmac, ETH_ALEN);
 		veth_hdr->h_vlan_proto = htons(ETH_P_8021Q);
 		vlan_tci = opt_pkt_vlan_id & VLAN_VID_MASK;
 		vlan_tci |= (opt_pkt_vlan_pri << VLAN_PRIO_SHIFT) & VLAN_PRIO_MASK;
@@ -802,8 +807,8 @@ static void gen_eth_hdr_data(void)
 					  sizeof(struct ethhdr));
 
 		/* ethernet header */
-		memcpy(eth_hdr->h_dest, "\x3c\xfd\xfe\x9e\x7f\x71", ETH_ALEN);
-		memcpy(eth_hdr->h_source, "\xec\xb1\xd7\x98\x3a\xc0", ETH_ALEN);
+		memcpy(eth_hdr->h_dest, &opt_txdmac, ETH_ALEN);
+		memcpy(eth_hdr->h_source, &opt_txsmac, ETH_ALEN);
 		eth_hdr->h_proto = htons(ETH_P_IP);
 	}
 
@@ -967,6 +972,8 @@ static struct option long_options[] = {
 	{"tx-vlan", no_argument, 0, 'V'},
 	{"tx-vlan-id", required_argument, 0, 'J'},
 	{"tx-vlan-pri", required_argument, 0, 'K'},
+	{"tx-dmac", required_argument, 0, 'G'},
+	{"tx-smac", required_argument, 0, 'H'},
 	{"extra-stats", no_argument, 0, 'x'},
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
@@ -1010,6 +1017,8 @@ static void usage(const char *prog)
 		"  -V, --tx-vlan        Send VLAN tagged  packets (For -t|--txonly)\n"
 		"  -J, --tx-vlan-id=n   Tx VLAN ID [1-4095]. Default: %d (For -V|--tx-vlan)\n"
 		"  -K, --tx-vlan-pri=n  Tx VLAN Priority [0-7]. Default: %d (For -V|--tx-vlan)\n"
+		"  -G, --tx-dmac=<MAC>  Dest MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
+		"  -H, --tx-smac=<MAC>  Src MAC addr of TX frame in aa:bb:cc:dd:ee:ff format (For -V|--tx-vlan)\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
@@ -1032,7 +1041,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:xQaI:BR",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:VJ:K:G:H:xQaI:BR",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1122,6 +1131,22 @@ static void parse_command_line(int argc, char **argv)
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

