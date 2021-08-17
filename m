Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273443EE9DA
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239735AbhHQJaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239545AbhHQJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:52 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D612C0612A6;
        Tue, 17 Aug 2021 02:29:14 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id r6so27606566wrt.4;
        Tue, 17 Aug 2021 02:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ixu1iPh3iWecT/uWFiaHnEfJPTFsaPdaDKCliFl7NM=;
        b=UacUlKGYTJKjpJF0jKt0lHLw9oRmYDUy6fSrjSekyYNQzTBJ1OWX8RDjR5knC04jpr
         NDN0AQEOgmcwhB8VbkkXkA/dURLA7PPlSwvZXAhLeIBFDen//c+y2M1n4diZOgFNDHSH
         Q0h1hgCxR86mOXiYY9k+gchqRQQ/RJwQACUqr+yDDcf65lYON6Z47Y0kvug5TjBkdChq
         ZeGDnLnNqMiADvn/8MwBskinLc4uuuMQvzlh9aW5kyjfh42DC5mzK13wOD07cImuwBDM
         /Pt+ZJke1QJuv+TxpI6NRcAdU2eIjvYaqM28Wq1uYKkbAxfQCSrUFNdyN953LHg3BD+B
         gWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ixu1iPh3iWecT/uWFiaHnEfJPTFsaPdaDKCliFl7NM=;
        b=jHS2Rg6uYh36PYnB3Ph9ZzZ7oz1EV7Y4g19SIu+msQm8llqBrHiv0+UmZpIHW8LNiJ
         EQv4EV1ePxrLquZtnvM5Dh6oDc2AOtHaG6jl4uvFyuIi6Kf40bRIwrWARteTno2tMRga
         dtKMxuM0/aqHibKtimfIgw1SAxBCXtVl/jghLwTflDENajJQUVqiGBaA2fDPoBR1xV4D
         +Ffnrd5pwSCyuqg7O7AEMB2rMTiWR8fuU/YGjQMMYJq3NLv/yLiL/lJq98YIuJ9mJPyM
         SQ+h3mZHT2iSOFf4FW9eThabl/i6LFEgELz6cYGLYAFomUesxA/MnfmuhkrdpgktGyRH
         V1zg==
X-Gm-Message-State: AOAM533jcsLVqlnMVOPFSdXn7uL8ExEmeRsPP3xhKHHMM2S8W/MugXeS
        9s/TrNqrZ5b4Vjak5aq+xVU=
X-Google-Smtp-Source: ABdhPJy8ikMiLYbVJlmsrCK2Fk6zospXdkYwlQz8qgq9BS49HoQnEbXjfFCbndagHKWsuRlXQohagA==
X-Received: by 2002:a5d:4d4b:: with SMTP id a11mr2765551wru.411.1629192552630;
        Tue, 17 Aug 2021 02:29:12 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:12 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 13/16] selftests: xsk: generate packet directly in umem
Date:   Tue, 17 Aug 2021 11:27:26 +0200
Message-Id: <20210817092729.433-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Generate the packet directly in the umem instead of in a temporary
buffer that is copied out. Simplifies the code and improves
performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 70 +++++++++++-------------
 tools/testing/selftests/bpf/xdpxceiver.h |  5 --
 2 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index c1bb03e0ca07..a62e5ebb0f2c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -125,7 +125,7 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 			       test_type == TEST_TYPE_STATS ? "Stats" : "",\
 			       test_type == TEST_TYPE_BPF_RES ? "BPF RES" : ""))
 
-static void *memset32_htonl(void *dest, u32 val, u32 size)
+static void memset32_htonl(void *dest, u32 val, u32 size)
 {
 	u32 *ptr = (u32 *)dest;
 	int i;
@@ -134,11 +134,6 @@ static void *memset32_htonl(void *dest, u32 val, u32 size)
 
 	for (i = 0; i < (size & (~0x3)); i += 4)
 		ptr[i >> 2] = val;
-
-	for (; i < size; i++)
-		((char *)dest)[i] = ((char *)&val)[i & 3];
-
-	return dest;
 }
 
 /*
@@ -229,13 +224,13 @@ static void gen_ip_hdr(struct ifobject *ifobject, struct iphdr *ip_hdr)
 	ip_hdr->check = 0;
 }
 
-static void gen_udp_hdr(struct generic_data *data, struct ifobject *ifobject,
+static void gen_udp_hdr(u32 payload, void *pkt, struct ifobject *ifobject,
 			struct udphdr *udp_hdr)
 {
 	udp_hdr->source = htons(ifobject->src_port);
 	udp_hdr->dest = htons(ifobject->dst_port);
 	udp_hdr->len = htons(UDP_PKT_SIZE);
-	memset32_htonl(pkt_data + PKT_HDR_SIZE, htonl(data->seqnum), UDP_PKT_DATA_SIZE);
+	memset32_htonl(pkt + PKT_HDR_SIZE, payload, UDP_PKT_DATA_SIZE);
 }
 
 static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
@@ -245,11 +240,6 @@ static void gen_udp_csum(struct udphdr *udp_hdr, struct iphdr *ip_hdr)
 	    udp_csum(ip_hdr->saddr, ip_hdr->daddr, UDP_PKT_SIZE, IPPROTO_UDP, (u16 *)udp_hdr);
 }
 
-static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
-{
-	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
-}
-
 static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size, int idx)
 {
 	struct xsk_umem_config cfg = {
@@ -427,6 +417,20 @@ static void parse_command_line(int argc, char **argv)
 	}
 }
 
+static void pkt_generate(struct ifobject *ifobject, u32 pkt_nb, u64 addr)
+{
+	void *data = xsk_umem__get_data(ifobject->umem->buffer, addr);
+	struct udphdr *udp_hdr =
+		(struct udphdr *)(data + sizeof(struct ethhdr) + sizeof(struct iphdr));
+	struct iphdr *ip_hdr = (struct iphdr *)(data + sizeof(struct ethhdr));
+	struct ethhdr *eth_hdr = (struct ethhdr *)data;
+
+	gen_udp_hdr(pkt_nb, data, ifobject, udp_hdr);
+	gen_ip_hdr(ifobject, ip_hdr);
+	gen_udp_csum(udp_hdr, ip_hdr);
+	gen_eth_hdr(ifobject, eth_hdr);
+}
+
 static void pkt_dump(void *pkt, u32 len)
 {
 	char s[INET_ADDRSTRLEN];
@@ -464,22 +468,23 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "---------------------------------------\n");
 }
 
-static void pkt_validate(void *pkt)
+static void pkt_validate(void *buffer, u64 addr)
 {
-	struct iphdr *iphdr = (struct iphdr *)(pkt + sizeof(struct ethhdr));
+	void *data = xsk_umem__get_data(buffer, addr);
+	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
 
-	/*do not increment pktcounter if !(tos=0x9 and ipv4) */
 	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
-		u32 payloadseqnum = *((uint32_t *)(pkt + PKT_HDR_SIZE));
+		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
+		u32 expected_seqnum = pkt_counter % num_frames;
 
 		if (debug_pkt_dump && test_type != TEST_TYPE_STATS)
-			pkt_dump(pkt, PKT_SIZE);
+			pkt_dump(data, PKT_SIZE);
 
-		if (pkt_counter % num_frames != payloadseqnum) {
+		if (expected_seqnum != seqnum) {
 			ksft_test_result_fail
 				("ERROR: [%s] expected seqnum [%d], got seqnum [%d]\n",
-					__func__, pkt_counter, payloadseqnum);
-			ksft_exit_xfail();
+					__func__, expected_seqnum, seqnum);
+			sigvar = 1;
 		}
 
 		if (++pkt_counter == opt_pkt_count)
@@ -488,6 +493,7 @@ static void pkt_validate(void *pkt)
 		ksft_print_msg("Invalid frame received: ");
 		ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
 			       iphdr->tos);
+		sigvar = 1;
 	}
 }
 
@@ -555,7 +561,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 		orig = xsk_umem__extract_addr(addr);
 
 		addr = xsk_umem__add_offset_to_addr(addr);
-		pkt_validate(xsk_umem__get_data(xsk->umem->buffer, addr));
+		pkt_validate(xsk->umem->buffer, addr);
 
 		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
 	}
@@ -564,8 +570,9 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 	xsk_ring_cons__release(&xsk->rx, rcvd);
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
+static void tx_only(struct ifobject *ifobject, u32 *frameptr, int batch_size)
 {
+	struct xsk_socket_info *xsk = ifobject->xsk;
 	u32 idx = 0;
 	unsigned int i;
 	bool tx_invalid_test = stat_test_type == STAT_TEST_TX_INVALID;
@@ -579,6 +586,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 
 		tx_desc->addr = (*frameptr + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
 		tx_desc->len = len;
+		pkt_generate(ifobject, *frameptr + i, tx_desc->addr);
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
@@ -635,7 +643,7 @@ static void tx_only_all(struct ifobject *ifobject)
 				continue;
 		}
 
-		tx_only(ifobject->xsk, &frame_nb, batch_size);
+		tx_only(ifobject, &frame_nb, batch_size);
 		pkt_cnt += batch_size;
 	}
 
@@ -767,26 +775,12 @@ static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
 
 static void *worker_testapp_validate_tx(void *arg)
 {
-	struct udphdr *udp_hdr =
-	    (struct udphdr *)(pkt_data + sizeof(struct ethhdr) + sizeof(struct iphdr));
-	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
-	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
 	struct ifobject *ifobject = (struct ifobject *)arg;
-	struct generic_data data;
 	void *bufs = NULL;
 
 	if (!second_step)
 		thread_common_ops(ifobject, bufs);
 
-	for (int i = 0; i < num_frames; i++) {
-		data.seqnum = i;
-		gen_udp_hdr(&data, ifobject, udp_hdr);
-		gen_ip_hdr(ifobject, ip_hdr);
-		gen_udp_csum(udp_hdr, ip_hdr);
-		gen_eth_hdr(ifobject, eth_hdr);
-		gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
-	}
-
 	print_verbose("Sending %d packets on interface %s\n", opt_pkt_count, ifobject->ifname);
 	tx_only_all(ifobject);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 1c5457e9f1d6..b3087270d837 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -79,7 +79,6 @@ static u8 opt_verbose;
 
 static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
-static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
 static int sigvar;
 static int stat_test_type;
@@ -108,10 +107,6 @@ struct flow_vector {
 	} vector;
 };
 
-struct generic_data {
-	u32 seqnum;
-};
-
 struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
-- 
2.29.0

