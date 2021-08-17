Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF6F3EE9CF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbhHQJ3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239505AbhHQJ3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:50 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13655C06129E;
        Tue, 17 Aug 2021 02:29:07 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h13so27634976wrp.1;
        Tue, 17 Aug 2021 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v2G7VaPISORqVkgrkmEmFicS9tj5hklL0AfR8I06gQY=;
        b=kTW8+G3yKhuKYr0muHLe9pZmoevpfryh596urdwdqn9AqwUY/+iIFE+ZKg+78hZevt
         4fjyM7lN/ebbRYSyChRzJTAHTM4yRSe/cmnyiRi0wRo2J+fYp8hxaPg98C5cHPgj5ZoM
         ALrmdHER5otVY0Rt6Byqv6mZXlB5JRBI+9dwNDBo7bkfpQHOAvoL+tTtRhKbqwnp92hX
         ljqTSHSdfJY6BCde6hEyDKDz50rLHXz8DPKDtSvmfo2XiQ8hSUJQftP4VjWKSnbGq2Fc
         NIQOIQP5AzPGKkqTgSYEwqcMoWAWBRMJrhT663MnF21aOlnuSa5Uk5y8Usj4p9u2oi3y
         D0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v2G7VaPISORqVkgrkmEmFicS9tj5hklL0AfR8I06gQY=;
        b=Bfe3Lv9Fl6F4K/YKRy54m/2TbkTsLQ/MxbH8Iq+aLgXPkXMCGJe1jodAmh/GtUcLH8
         LK6BcFz2ykBrdMQl9EgG/OvEXb6tRWyBAc3EvC26QAXcToNMhZa9/VQPecowSRHXgoDZ
         Nc4m67m6CRVdYgMWKh1/gwYrTPPk6zHn4fPz+h8zJK2/BbrfEddAT92Dd5ba62t9jfkn
         60iHmN++ibRZVwKeNu3jg8/Yyxw9ePxshWdDzvqg5K2cA/1cV0kTyySoRn73adIjw7A5
         JN1JyHRCKnNU56Ivv/khgp27Q8XwUxTxWG1a/f4biP7k/7WG5kHYT5clNnAHGvqneFPO
         VQQg==
X-Gm-Message-State: AOAM5307x+B9fe3CmcqZo5uRDdGXlVyKRCdJq5Q2eVO8JQYLHU9f9X6m
        v0pthCaFYBHYY3sByGsZNAQ=
X-Google-Smtp-Source: ABdhPJxBeIXRyG9/OWZMR/tf4t3xlnI0HrJIMyWGhX8WcOXNoP895UI2g3xwb7QFsqnwNkI69czJXQ==
X-Received: by 2002:a5d:6451:: with SMTP id d17mr2879604wrw.154.1629192546528;
        Tue, 17 Aug 2021 02:29:06 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:06 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 09/16] selftests: xsk: simplify packet validation in xsk tests
Date:   Tue, 17 Aug 2021 11:27:22 +0200
Message-Id: <20210817092729.433-10-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Simplify packet validation in the xsk selftests by performing it at
once for every packet. The current code performed this per batch and
did this on copied packet data. Make it simpler and faster by
validating it at once and on the umem packet data thus skipping the
copy and the memory allocation for the temprary buffer.

The optional packet dump feature is also simplified in the same
manner. Memory allocation and copying is removed and the dump is
performed directly on the umem data.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 182 ++++++++---------------
 tools/testing/selftests/bpf/xdpxceiver.h |  14 --
 2 files changed, 65 insertions(+), 131 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 17956fdeb49e..fe3d281a0575 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -427,6 +427,70 @@ static void parse_command_line(int argc, char **argv)
 	}
 }
 
+static void pkt_dump(void *pkt, u32 len)
+{
+	char s[INET_ADDRSTRLEN];
+	struct ethhdr *ethhdr;
+	struct udphdr *udphdr;
+	struct iphdr *iphdr;
+	int payload, i;
+
+	ethhdr = pkt;
+	iphdr = pkt + sizeof(*ethhdr);
+	udphdr = pkt + sizeof(*ethhdr) + sizeof(*iphdr);
+
+	/*extract L2 frame */
+	fprintf(stdout, "DEBUG>> L2: dst mac: ");
+	for (i = 0; i < ETH_ALEN; i++)
+		fprintf(stdout, "%02X", ethhdr->h_dest[i]);
+
+	fprintf(stdout, "\nDEBUG>> L2: src mac: ");
+	for (i = 0; i < ETH_ALEN; i++)
+		fprintf(stdout, "%02X", ethhdr->h_source[i]);
+
+	/*extract L3 frame */
+	fprintf(stdout, "\nDEBUG>> L3: ip_hdr->ihl: %02X\n", iphdr->ihl);
+	fprintf(stdout, "DEBUG>> L3: ip_hdr->saddr: %s\n",
+		inet_ntop(AF_INET, &iphdr->saddr, s, sizeof(s)));
+	fprintf(stdout, "DEBUG>> L3: ip_hdr->daddr: %s\n",
+		inet_ntop(AF_INET, &iphdr->daddr, s, sizeof(s)));
+	/*extract L4 frame */
+	fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
+	fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
+	/*extract L5 frame */
+	payload = *((uint32_t *)(pkt + PKT_HDR_SIZE));
+
+	fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
+	fprintf(stdout, "---------------------------------------\n");
+}
+
+static void pkt_validate(void *pkt)
+{
+	struct iphdr *iphdr = (struct iphdr *)(pkt + sizeof(struct ethhdr));
+
+	/*do not increment pktcounter if !(tos=0x9 and ipv4) */
+	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
+		u32 payloadseqnum = *((uint32_t *)(pkt + PKT_HDR_SIZE));
+
+		if (debug_pkt_dump && test_type != TEST_TYPE_STATS)
+			pkt_dump(pkt, PKT_SIZE);
+
+		if (pkt_counter % num_frames != payloadseqnum) {
+			ksft_test_result_fail
+				("ERROR: [%s] expected seqnum [%d], got seqnum [%d]\n",
+					__func__, pkt_counter, payloadseqnum);
+			ksft_exit_xfail();
+		}
+
+		if (++pkt_counter == opt_pkt_count)
+			sigvar = 1;
+	} else {
+		ksft_print_msg("Invalid frame received: ");
+		ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
+			       iphdr->tos);
+	}
+}
+
 static void kick_tx(struct xsk_socket_info *xsk)
 {
 	int ret;
@@ -491,18 +555,7 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 		orig = xsk_umem__extract_addr(addr);
 
 		addr = xsk_umem__add_offset_to_addr(addr);
-		pkt_node_rx = malloc(sizeof(struct pkt) + PKT_SIZE);
-		if (!pkt_node_rx)
-			exit_with_error(errno);
-
-		pkt_node_rx->pkt_frame = malloc(PKT_SIZE);
-		if (!pkt_node_rx->pkt_frame)
-			exit_with_error(errno);
-
-		memcpy(pkt_node_rx->pkt_frame, xsk_umem__get_data(xsk->umem->buffer, addr),
-		       PKT_SIZE);
-
-		TAILQ_INSERT_HEAD(&head, pkt_node_rx, pkt_nodes);
+		pkt_validate(xsk_umem__get_data(xsk->umem->buffer, addr));
 
 		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
 	}
@@ -589,48 +642,6 @@ static void tx_only_all(struct ifobject *ifobject)
 	complete_tx_only_all(ifobject);
 }
 
-static void pkt_dump(void)
-{
-	struct ethhdr *ethhdr;
-	struct iphdr *iphdr;
-	struct udphdr *udphdr;
-	char s[128];
-	int payload;
-	void *ptr;
-
-	fprintf(stdout, "---------------------------------------\n");
-	for (int iter = 0; iter < num_frames; iter++) {
-		ptr = pkt_buf[iter]->payload;
-		ethhdr = ptr;
-		iphdr = ptr + sizeof(*ethhdr);
-		udphdr = ptr + sizeof(*ethhdr) + sizeof(*iphdr);
-
-		/*extract L2 frame */
-		fprintf(stdout, "DEBUG>> L2: dst mac: ");
-		for (int i = 0; i < ETH_ALEN; i++)
-			fprintf(stdout, "%02X", ethhdr->h_dest[i]);
-
-		fprintf(stdout, "\nDEBUG>> L2: src mac: ");
-		for (int i = 0; i < ETH_ALEN; i++)
-			fprintf(stdout, "%02X", ethhdr->h_source[i]);
-
-		/*extract L3 frame */
-		fprintf(stdout, "\nDEBUG>> L3: ip_hdr->ihl: %02X\n", iphdr->ihl);
-		fprintf(stdout, "DEBUG>> L3: ip_hdr->saddr: %s\n",
-			inet_ntop(AF_INET, &iphdr->saddr, s, sizeof(s)));
-		fprintf(stdout, "DEBUG>> L3: ip_hdr->daddr: %s\n",
-			inet_ntop(AF_INET, &iphdr->daddr, s, sizeof(s)));
-		/*extract L4 frame */
-		fprintf(stdout, "DEBUG>> L4: udp_hdr->src: %d\n", ntohs(udphdr->source));
-		fprintf(stdout, "DEBUG>> L4: udp_hdr->dst: %d\n", ntohs(udphdr->dest));
-		/*extract L5 frame */
-		payload = *((uint32_t *)(ptr + PKT_HDR_SIZE));
-
-		fprintf(stdout, "DEBUG>> L5: payload: %d\n", payload);
-		fprintf(stdout, "---------------------------------------\n");
-	}
-}
-
 static void stats_validate(struct ifobject *ifobject)
 {
 	struct xdp_statistics stats;
@@ -673,52 +684,6 @@ static void stats_validate(struct ifobject *ifobject)
 	}
 }
 
-static void pkt_validate(void)
-{
-	u32 payloadseqnum = -2;
-	struct iphdr *iphdr;
-
-	while (1) {
-		pkt_node_rx_q = TAILQ_LAST(&head, head_s);
-		if (!pkt_node_rx_q)
-			break;
-
-		iphdr = (struct iphdr *)(pkt_node_rx_q->pkt_frame + sizeof(struct ethhdr));
-
-		/*do not increment pktcounter if !(tos=0x9 and ipv4) */
-		if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
-			payloadseqnum = *((uint32_t *)(pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
-			if (debug_pkt_dump) {
-				pkt_obj = malloc(sizeof(*pkt_obj));
-				pkt_obj->payload = malloc(PKT_SIZE);
-				memcpy(pkt_obj->payload, pkt_node_rx_q->pkt_frame, PKT_SIZE);
-				pkt_buf[payloadseqnum] = pkt_obj;
-			}
-
-			if (pkt_counter % num_frames != payloadseqnum) {
-				ksft_test_result_fail
-				    ("ERROR: [%s] expected counter [%d], payloadseqnum [%d]\n",
-				     __func__, pkt_counter, payloadseqnum);
-				ksft_exit_xfail();
-			}
-
-			if (++pkt_counter == opt_pkt_count) {
-				sigvar = 1;
-				break;
-			}
-		} else {
-			ksft_print_msg("Invalid frame received: ");
-			ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n", iphdr->version,
-				       iphdr->tos);
-		}
-
-		TAILQ_REMOVE(&head, pkt_node_rx_q, pkt_nodes);
-		free(pkt_node_rx_q->pkt_frame);
-		free(pkt_node_rx_q);
-		pkt_node_rx_q = NULL;
-	}
-}
-
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 {
 	u64 umem_sz = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
@@ -818,13 +783,6 @@ static void *worker_testapp_validate_rx(void *arg)
 	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
 		xsk_populate_fill_ring(ifobject->umem);
 
-	TAILQ_INIT(&head);
-	if (debug_pkt_dump) {
-		pkt_buf = calloc(num_frames, sizeof(*pkt_buf));
-		if (!pkt_buf)
-			exit_with_error(errno);
-	}
-
 	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds[0].events = POLLIN;
 
@@ -833,7 +791,6 @@ static void *worker_testapp_validate_rx(void *arg)
 	while (1) {
 		if (test_type != TEST_TYPE_STATS) {
 			rx_pkt(ifobject->xsk, fds);
-			pkt_validate();
 		} else {
 			stats_validate(ifobject);
 		}
@@ -872,15 +829,6 @@ static void testapp_validate(void)
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
 
-	if (debug_pkt_dump && test_type != TEST_TYPE_STATS) {
-		pkt_dump();
-		for (int iter = 0; iter < num_frames; iter++) {
-			free(pkt_buf[iter]->payload);
-			free(pkt_buf[iter]);
-		}
-		free(pkt_buf);
-	}
-
 	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi && !bpf && !(test_type == TEST_TYPE_STATS))
 		print_ksft_result();
 }
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 131bd998e374..0fb657b505ae 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -139,18 +139,4 @@ static struct ifobject *ifdict_tx;
 pthread_barrier_t barr;
 pthread_t t0, t1;
 
-TAILQ_HEAD(head_s, pkt) head = TAILQ_HEAD_INITIALIZER(head);
-struct head_s *head_p;
-struct pkt {
-	char *pkt_frame;
-
-	TAILQ_ENTRY(pkt) pkt_nodes;
-} *pkt_node_rx, *pkt_node_rx_q;
-
-struct pkt_frame {
-	char *payload;
-} *pkt_obj;
-
-struct pkt_frame **pkt_buf;
-
 #endif				/* XDPXCEIVER_H */
-- 
2.29.0

