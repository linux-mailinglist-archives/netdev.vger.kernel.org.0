Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B933D75D5
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbhG0NTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbhG0NSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:34 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0ABC0613D3;
        Tue, 27 Jul 2021 06:18:32 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c16so5344539wrp.13;
        Tue, 27 Jul 2021 06:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQPmUHx3ExIJyP3g1VjcIYbZhs6EloTH/kclmwmlLpo=;
        b=hmLUwPwh85LS1kH9SyFwSrC+XwEEVYhlI2QpM/w46WgSID6KzZOBAMuv5fZ8XsGiWr
         nodH6RT5DKckXEREbbe0oGb8jCyIHpgH7/NE0jBZHb5aQoP6sTx3er8TG+o28nOCf9el
         LyOhlqCJYD9xKioh3x1zIzq+FxtKKiO1178TtASZaH1COVuJihwxUqkSUR69tvYaU+NM
         3NWUvPgQ3e6t5/0YrvibDKzoak9DHuk177TXdpYnNcVWBMNHfbGlBlDJ0xFB9pFwwAO2
         LigKKf/8udop+0vTalR2QeHfl3Hy5uYb1ISAOW2ItmTdOjNtSnqjw/3XMdxF+BbB+Ggn
         gZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQPmUHx3ExIJyP3g1VjcIYbZhs6EloTH/kclmwmlLpo=;
        b=H+8IhG2aqacKSNrPnPjxITaCdEdYCGfaNsPvp7TQo6usg1kCnmcPb/BraCpu8vlwME
         QMWfm7NS6LDs+3u5kGkfsxvejM0Pi5QmC+pUE6SrO+7ZXhWxaRZ2FndLlAHZDMxZnr81
         LzL95vV0hjp4CBFmKWh5Rq3I2XQWEjLtAtXIK6OPOsrGiUNEIH2m6yRems5BhhMt9Co0
         CcprnrmWjU2FPu6jCTXXacQKJKs7x4ZpjicwN/yIYb6BoXu4r4cJ13N3N/LLW0a90WHs
         DToi214FoeYOQqTaR3ywhTf7mlyp+1WR2eYbCgvmCr9XvK8oY9jYZSuMXym21gam4TLe
         U3gg==
X-Gm-Message-State: AOAM533qsMJqMZgGCpUP8Fp7LrOGvuXXk1rDSWx/AcHFDLDxXK10IqM1
        NN408+6pLVRMeM8kEZmehUA=
X-Google-Smtp-Source: ABdhPJysPH5E+v6FYDKWxwTnBXHVFQWM6LoU5D2o/cJawJHwlmPtv7ipVGE+tNEJkhRzPfNDsYwNPw==
X-Received: by 2002:a5d:63cf:: with SMTP id c15mr10377513wrw.230.1627391910700;
        Tue, 27 Jul 2021 06:18:30 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:30 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 14/17] selftests: xsk: generate packet directly in umem
Date:   Tue, 27 Jul 2021 15:17:50 +0200
Message-Id: <20210727131753.10924-15-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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
index 8cc66c3ce94a..285151cbe5fe 100644
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
 	const struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
@@ -432,6 +422,20 @@ static void parse_command_line(int argc, char **argv)
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
@@ -469,22 +473,23 @@ static void pkt_dump(void *pkt, u32 len)
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
@@ -493,6 +498,7 @@ static void pkt_validate(void *pkt)
 		ksft_print_msg("Invalid frame received: ");
 		ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
 			       iphdr->tos);
+		sigvar = 1;
 	}
 }
 
@@ -560,7 +566,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 		orig = xsk_umem__extract_addr(addr);
 
 		addr = xsk_umem__add_offset_to_addr(addr);
-		pkt_validate(xsk_umem__get_data(xsk->umem->buffer, addr));
+		pkt_validate(xsk->umem->buffer, addr);
 
 		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
 	}
@@ -569,8 +575,9 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 	xsk_ring_cons__release(&xsk->rx, rcvd);
 }
 
-static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
+static void tx_only(struct ifobject *ifobject, u32 *frameptr, int batch_size)
 {
+	struct xsk_socket_info *xsk = ifobject->xsk;
 	u32 idx = 0;
 	unsigned int i;
 	bool tx_invalid_test = stat_test_type == STAT_TEST_TX_INVALID;
@@ -584,6 +591,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
 
 		tx_desc->addr = (*frameptr + i) << XSK_UMEM__DEFAULT_FRAME_SHIFT;
 		tx_desc->len = len;
+		pkt_generate(ifobject, *frameptr + i, tx_desc->addr);
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
@@ -640,7 +648,7 @@ static void tx_only_all(struct ifobject *ifobject)
 				continue;
 		}
 
-		tx_only(ifobject->xsk, &frame_nb, batch_size);
+		tx_only(ifobject, &frame_nb, batch_size);
 		pkt_cnt += batch_size;
 	}
 
@@ -772,26 +780,12 @@ static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
 
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

