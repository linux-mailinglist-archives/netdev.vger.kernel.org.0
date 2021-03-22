Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A325834517B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhCVVJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:09:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhCVVJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:03 -0400
IronPort-SDR: 6yAVLOLvkB5OOvWY7cc7bfg06HXJ6EkElYJfA42CBMfOHmroPVAwocVQFftA0VLOM5nKxDRo1z
 2rwjh3bi19RA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423706"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423706"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:03 -0700
IronPort-SDR: J2+G59hDM0ddldQMTj6qShF9Bv0ScXYU4gEAH482u8XHbGU7nzZsvMqHrW0FFD3Ema26DWGJU2
 nYE4iCyirzcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448744"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:01 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 02/17] selftests: xsk: remove struct ifaceconfigobj
Date:   Mon, 22 Mar 2021 21:58:01 +0100
Message-Id: <20210322205816.65159-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ifaceconfigobj is not really useful, it is possible to keep the
functionality and simplify the code.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 65 +++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  9 ----
 2 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 04574c2b4f41..04bc007d5b08 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -93,6 +93,13 @@ typedef __u16 __sum16;
 #include "xdpxceiver.h"
 #include "../kselftest.h"
 
+static const char *MAC1 = "\x00\x0A\x56\x9E\xEE\x62";
+static const char *MAC2 = "\x00\x0A\x56\x9E\xEE\x61";
+static const char *IP1 = "192.168.100.162";
+static const char *IP2 = "192.168.100.161";
+static const u16 UDP_PORT1 = 2020;
+static const u16 UDP_PORT2 = 2121;
+
 static void __exit_with_error(int error, const char *file, const char *func, int line)
 {
 	if (configured_mode == TEST_MODE_UNCONFIGURED) {
@@ -1053,25 +1060,24 @@ static void testapp_stats(void)
 	print_ksft_result();
 }
 
-static void init_iface_config(struct ifaceconfigobj *ifaceconfig)
+static void init_iface(struct ifobject *ifobj, const char *dst_mac,
+		       const char *src_mac, const char *dst_ip,
+		       const char *src_ip, const u16 dst_port,
+		       const u16 src_port)
 {
-	/*Init interface0 */
-	ifdict[0]->fv.vector = tx;
-	memcpy(ifdict[0]->dst_mac, ifaceconfig->dst_mac, ETH_ALEN);
-	memcpy(ifdict[0]->src_mac, ifaceconfig->src_mac, ETH_ALEN);
-	ifdict[0]->dst_ip = ifaceconfig->dst_ip.s_addr;
-	ifdict[0]->src_ip = ifaceconfig->src_ip.s_addr;
-	ifdict[0]->dst_port = ifaceconfig->dst_port;
-	ifdict[0]->src_port = ifaceconfig->src_port;
-
-	/*Init interface1 */
-	ifdict[1]->fv.vector = rx;
-	memcpy(ifdict[1]->dst_mac, ifaceconfig->src_mac, ETH_ALEN);
-	memcpy(ifdict[1]->src_mac, ifaceconfig->dst_mac, ETH_ALEN);
-	ifdict[1]->dst_ip = ifaceconfig->src_ip.s_addr;
-	ifdict[1]->src_ip = ifaceconfig->dst_ip.s_addr;
-	ifdict[1]->dst_port = ifaceconfig->src_port;
-	ifdict[1]->src_port = ifaceconfig->dst_port;
+	struct in_addr ip;
+
+	memcpy(ifobj->dst_mac, dst_mac, ETH_ALEN);
+	memcpy(ifobj->src_mac, src_mac, ETH_ALEN);
+
+	inet_aton(dst_ip, &ip);
+	ifobj->dst_ip = ip.s_addr;
+
+	inet_aton(src_ip, &ip);
+	ifobj->src_ip = ip.s_addr;
+
+	ifobj->dst_port = dst_port;
+	ifobj->src_port = src_port;
 }
 
 static void *nsdisablemodethread(void *args)
@@ -1175,26 +1181,11 @@ static void run_pkt_test(int mode, int type)
 int main(int argc, char **argv)
 {
 	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
+	int i, j;
 
 	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
 		exit_with_error(errno);
 
-	const char *MAC1 = "\x00\x0A\x56\x9E\xEE\x62";
-	const char *MAC2 = "\x00\x0A\x56\x9E\xEE\x61";
-	const char *IP1 = "192.168.100.162";
-	const char *IP2 = "192.168.100.161";
-	u16 UDP_DST_PORT = 2020;
-	u16 UDP_SRC_PORT = 2121;
-	int i, j;
-
-	ifaceconfig = malloc(sizeof(struct ifaceconfigobj));
-	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
-	memcpy(ifaceconfig->src_mac, MAC2, ETH_ALEN);
-	inet_aton(IP1, &ifaceconfig->dst_ip);
-	inet_aton(IP2, &ifaceconfig->src_ip);
-	ifaceconfig->dst_port = UDP_DST_PORT;
-	ifaceconfig->src_port = UDP_SRC_PORT;
-
 	for (int i = 0; i < MAX_INTERFACES; i++) {
 		ifdict[i] = malloc(sizeof(struct ifobject));
 		if (!ifdict[i])
@@ -1209,7 +1200,11 @@ int main(int argc, char **argv)
 
 	num_frames = ++opt_pkt_count;
 
-	init_iface_config(ifaceconfig);
+	ifdict[0]->fv.vector = tx;
+	init_iface(ifdict[0], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2);
+
+	ifdict[1]->fv.vector = rx;
+	init_iface(ifdict[1], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1);
 
 	disable_xdp_mode(XDP_FLAGS_DRV_MODE);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 30314ef305c2..8f9308099318 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -125,15 +125,6 @@ struct generic_data {
 	u32 seqnum;
 };
 
-struct ifaceconfigobj {
-	u8 dst_mac[ETH_ALEN];
-	u8 src_mac[ETH_ALEN];
-	struct in_addr dst_ip;
-	struct in_addr src_ip;
-	u16 src_port;
-	u16 dst_port;
-} *ifaceconfig;
-
 struct ifobject {
 	int ifindex;
 	int ifdict_index;
-- 
2.20.1

