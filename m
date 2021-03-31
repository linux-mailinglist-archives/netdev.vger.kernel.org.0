Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0334B2F7
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCZXVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:21:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:11386 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231441AbhCZXVj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:21:39 -0400
IronPort-SDR: 6NAMR7eejeFU7i2vGmja0LY6kB2cUyfIFeeV5jklvh+sXtF1Q+nIl6Ckaj+hiRu3D3DnOY9fi5
 Ml0PdGHvEiyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190681425"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="190681425"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 16:21:11 -0700
IronPort-SDR: efyfZwMerYRGLz7xqBAL2xZQLezC6X9uIqb4d74n+OamWckprsX/HO14qlGeldzktinc0cOoUJ
 RJd3PhZM7G+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="410113266"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 26 Mar 2021 16:21:09 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 05/17] selftests: xsk: simplify frame traversal in dumping thread
Date:   Sat, 27 Mar 2021 00:09:26 +0100
Message-Id: <20210326230938.49998-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
References: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store offsets to each layer in a separate variables rather than compute
them every single time.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 47 +++++++++++-------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 08058a3d9aec..cf30c7943ac0 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -658,45 +658,40 @@ static void tx_only_all(struct ifobject *ifobject)
 
 static void worker_pkt_dump(void)
 {
-	struct in_addr ipaddr;
+	struct ethhdr *ethhdr;
+	struct iphdr *iphdr;
+	struct udphdr *udphdr;
+	char s[128];
+	int payload;
+	void *ptr;
 
 	fprintf(stdout, "---------------------------------------\n");
 	for (int iter = 0; iter < num_frames - 1; iter++) {
+		ptr = pkt_buf[iter]->payload;
+		ethhdr = ptr;
+		iphdr = ptr + sizeof(*ethhdr);
+		udphdr = ptr + sizeof(*ethhdr) + sizeof(*iphdr);
+
 		/*extract L2 frame */
 		fprintf(stdout, "DEBUG>> L2: dst mac: ");
 		for (int i = 0; i < ETH_ALEN; i++)
-			fprintf(stdout, "%02X", ((struct ethhdr *)
-						 pkt_buf[iter]->payload)->h_dest[i]);
+			fprintf(stdout, "%02X", ethhdr->h_dest[i]);
 
 		fprintf(stdout, "\nDEBUG>> L2: src mac: ");
 		for (int i = 0; i < ETH_ALEN; i++)
-			fprintf(stdout, "%02X", ((struct ethhdr *)
-						 pkt_buf[iter]->payload)->h_source[i]);
+			fprintf(stdout, "%02X", ethhdr->h_source[i]);
 
 		/*extract L3 frame */
-		fprintf(stdout, "\nDEBUG>> L3: ip_hdr->ihl: %02X\n",
-			((struct iphdr *)(pkt_buf[iter]->payload + sizeof(struct ethhdr)))->ihl);
-
-		ipaddr.s_addr =
-		    ((struct iphdr *)(pkt_buf[iter]->payload + sizeof(struct ethhdr)))->saddr;
-		fprintf(stdout, "DEBUG>> L3: ip_hdr->saddr: %s\n", inet_ntoa(ipaddr));
-
-		ipaddr.s_addr =
-		    ((struct iphdr *)(pkt_buf[iter]->payload + sizeof(struct ethhdr)))->daddr;
-		fprintf(stdout, "DEBUG>> L3: ip_hdr->daddr: %s\n", inet_ntoa(ipaddr));
-
+		fprintf(stdout, "\nDEBUG>> L3: ip_hdr->ihl: %02X\n", iphdr->ihl);
+		fprintf(stdout, "DEBUG>> L3: ip_hdr->saddr: %s\n",
+			inet_ntop(AF_INET, &iphdr->saddr, s, sizeof(s)));
+		fprintf(stdout, "DEBUG>> L3: ip_hdr->daddr: %s\n",
+			inet_ntop(AF_INET, &iphdr->daddr, s, sizeof(s)));
 		/*extract L4 frame */
-		fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n",
-			ntohs(((struct udphdr *)(pkt_buf[iter]->payload +
-						 sizeof(struct ethhdr) +
-						 sizeof(struct iphdr)))->source));
-
-		fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n",
-			ntohs(((struct udphdr *)(pkt_buf[iter]->payload +
-						 sizeof(struct ethhdr) +
-						 sizeof(struct iphdr)))->dest));
+		fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
+		fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
 		/*extract L5 frame */
-		int payload = *((uint32_t *)(pkt_buf[iter]->payload + PKT_HDR_SIZE));
+		payload = *((uint32_t *)(ptr + PKT_HDR_SIZE));
 
 		if (payload == EOT) {
 			print_verbose("End-of-transmission frame received\n");
-- 
2.20.1

