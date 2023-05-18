Return-Path: <netdev+bounces-3745-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C767087AC
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84001C208EB
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320173A2F7;
	Thu, 18 May 2023 18:07:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6C53A2E3;
	Thu, 18 May 2023 18:07:00 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D36910E;
	Thu, 18 May 2023 11:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433218; x=1715969218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=avcr4BRH7HPjOKHbQAZh4dMCLxdDtBanegdAPLkL72w=;
  b=C+0fVn9qb+14djF5ZylvnESPamPkpxsxwRMw/cOOebje/iyjLoIAmQmj
   ZgY7GR3xQc8RpZroU+70xJUovCuI0cXhep/NMOh4AmA+WCWSLb+eoGhDM
   bFXtIqkish5N4QQTv8Vbbem+poxTuCPLjo2NN4FjoOCzs/kPiHpGo65mB
   o9CowzVdkZNrYKWYhA9NmW8rhn5kn9BEn9/6LT36u/aYtPr0XhT4qMXO6
   QMdFI+zn3vuWqtCX+AhKSXX7Wh8s+mrL19vuoKfraO7OzfyNddhphNnwO
   J3vo0Hr48AfRwU+NDCDDpufRqFEuhPbVLwwJOytPhQZHYj16/oJst6Ofa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350985061"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350985061"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780597"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780597"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:36 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 18/21] selftests/xsk: add invalid descriptor test for multi-buffer
Date: Thu, 18 May 2023 20:05:42 +0200
Message-Id: <20230518180545.159100-19-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a test that produces lots of nasty descriptors testing the corner
cases of the descriptor validation. Some of these descriptors are
valid and some are not as indicated by the valid flag. For a
description of all the test combinations, please see the code.

To stress the API, we need to be able to generate combinations of
descriptors that make little sense. A new verbatim mode is introduced
for the packet_stream to accomplish this. In this mode, all packets in
the packet_stream are sent as is. We do not try to chop them up into
frames that are of the right size that we know are going to work as we
would normally do. The packets are just written into the Tx ring even
if we know they make no sense.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com> # adjusted valid flags for frags
---
 tools/testing/selftests/bpf/xskxceiver.c | 185 ++++++++++++++++++-----
 tools/testing/selftests/bpf/xskxceiver.h |   7 +
 2 files changed, 151 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 8ad98eda90ad..1e1e9422ca0a 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -52,8 +52,8 @@
  *    j. If multi-buffer is supported, send 9k packets divided into 3 frames
  *    k. If multi-buffer and huge pages are supported, send 9k packets in a single frame
  *       using unaligned mode
- *
- * Total tests: 12
+ *    l. If multi-buffer is supported, try various nasty combinations of descriptors to
+ *       check if they pass the validation or not
  *
  * Flow:
  * -----
@@ -76,7 +76,6 @@
 #include <fcntl.h>
 #include <errno.h>
 #include <getopt.h>
-#include <asm/barrier.h>
 #include <linux/if_link.h>
 #include <linux/if_ether.h>
 #include <linux/mman.h>
@@ -95,7 +94,6 @@
 #include <sys/socket.h>
 #include <sys/time.h>
 #include <sys/types.h>
-#include <time.h>
 #include <unistd.h>
 
 #include "xsk_xdp_progs.skel.h"
@@ -560,9 +558,9 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
 	return pkt_stream;
 }
 
-static bool pkt_continues(const struct xdp_desc *desc)
+static bool pkt_continues(u32 options)
 {
-	return desc->options & XDP_PKT_CONTD;
+	return options & XDP_PKT_CONTD;
 }
 
 static u32 ceil_u32(u32 a, u32 b)
@@ -570,11 +568,32 @@ static u32 ceil_u32(u32 a, u32 b)
 	return (a + b - 1) / b;
 }
 
-static u32 pkt_nb_frags(u32 frame_size, struct pkt *pkt)
+static u32 pkt_nb_frags(u32 frame_size, struct pkt_stream *pkt_stream, struct pkt *pkt)
 {
-	if (!pkt || !pkt->valid)
+	u32 nb_frags = 1, next_frag;
+
+	if (!pkt)
 		return 1;
-	return ceil_u32(pkt->len, frame_size);
+
+	if (!pkt_stream->verbatim) {
+		if (!pkt->valid || !pkt->len)
+			return 1;
+		return ceil_u32(pkt->len, frame_size);
+	}
+
+	/* Search for the end of the packet in verbatim mode */
+	if (!pkt_continues(pkt->options))
+		return nb_frags;
+
+	next_frag = pkt_stream->current_pkt_nb;
+	pkt++;
+	while (next_frag++ < pkt_stream->nb_pkts) {
+		nb_frags++;
+		if (!pkt_continues(pkt->options) || !pkt->valid)
+			break;
+		pkt++;
+	}
+	return nb_frags;
 }
 
 static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, int offset, u32 len)
@@ -694,34 +713,59 @@ static void pkt_generate(struct ifobject *ifobject, u64 addr, u32 len, u32 pkt_n
 	write_payload(data, pkt_nb, bytes_written, len);
 }
 
-static void __pkt_stream_generate_custom(struct ifobject *ifobj,
-					 struct pkt *pkts, u32 nb_pkts)
+static struct pkt_stream *__pkt_stream_generate_custom(struct ifobject *ifobj, struct pkt *frames,
+						       u32 nb_frames, bool verbatim)
 {
+	u32 i, len = 0, pkt_nb = 0, payload = 0;
 	struct pkt_stream *pkt_stream;
-	u32 i;
 
-	pkt_stream = __pkt_stream_alloc(nb_pkts);
+	pkt_stream = __pkt_stream_alloc(nb_frames);
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
-	for (i = 0; i < nb_pkts; i++) {
-		struct pkt *pkt = &pkt_stream->pkts[i];
+	for (i = 0; i < nb_frames; i++) {
+		struct pkt *pkt = &pkt_stream->pkts[pkt_nb];
+		struct pkt *frame = &frames[i];
 
-		pkt->offset = pkts[i].offset;
-		pkt->len = pkts[i].len;
-		pkt->pkt_nb = i;
-		pkt->valid = pkts[i].valid;
-		if (pkt->len > pkt_stream->max_pkt_len)
+		pkt->offset = frame->offset;
+		if (verbatim) {
+			*pkt = *frame;
+			pkt->pkt_nb = payload;
+			if (!frame->valid || !pkt_continues(frame->options))
+				payload++;
+		} else {
+			if (frame->valid)
+				len += frame->len;
+			if (frame->valid && pkt_continues(frame->options))
+				continue;
+
+			pkt->pkt_nb = pkt_nb;
+			pkt->len = len;
+			pkt->valid = frame->valid;
+			pkt->options = 0;
+
+			len = 0;
+		}
+
+		if (pkt->valid && pkt->len > pkt_stream->max_pkt_len)
 			pkt_stream->max_pkt_len = pkt->len;
+		pkt_nb++;
 	}
 
-	ifobj->pkt_stream = pkt_stream;
+	pkt_stream->nb_pkts = pkt_nb;
+	pkt_stream->verbatim = verbatim;
+	return pkt_stream;
 }
 
 static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts, u32 nb_pkts)
 {
-	__pkt_stream_generate_custom(test->ifobj_tx, pkts, nb_pkts);
-	__pkt_stream_generate_custom(test->ifobj_rx, pkts, nb_pkts);
+	struct pkt_stream *pkt_stream;
+
+	pkt_stream = __pkt_stream_generate_custom(test->ifobj_tx, pkts, nb_pkts, true);
+	test->ifobj_tx->pkt_stream = pkt_stream;
+
+	pkt_stream = __pkt_stream_generate_custom(test->ifobj_rx, pkts, nb_pkts, false);
+	test->ifobj_rx->pkt_stream = pkt_stream;
 }
 
 static void pkt_print_data(u32 *data, u32 cnt)
@@ -862,11 +906,6 @@ static bool is_frag_valid(struct xsk_umem_info *umem, u64 addr, u32 len, u32 exp
 
 static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
-	if (!pkt) {
-		ksft_print_msg("[%s] too many packets received\n", __func__);
-		return false;
-	}
-
 	if (pkt->len != len) {
 		ksft_print_msg("[%s] expected packet length [%d], got length [%d]\n",
 			       __func__, pkt->len, len);
@@ -966,7 +1005,6 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 
 				ksft_print_msg("ERROR: [%s] Poll timed out\n", __func__);
 				return TEST_FAILURE;
-
 			}
 
 			if (!(fds->revents & POLLIN))
@@ -998,6 +1036,12 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 			orig = xsk_umem__extract_addr(addr);
 			addr = xsk_umem__add_offset_to_addr(addr);
 
+			if (!pkt) {
+				ksft_print_msg("[%s] received too many packets addr: %lx len %u\n",
+					       __func__, addr, desc->len);
+				return TEST_FAILURE;
+			}
+
 			if (!is_frag_valid(umem, addr, desc->len, pkt->pkt_nb, pkt_len) ||
 			    !is_offset_correct(umem, pkt, addr) ||
 			    (ifobj->use_metadata && !is_metadata_correct(pkt, umem->buffer, addr)))
@@ -1010,7 +1054,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 			if (ifobj->use_fill_ring)
 				*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
 
-			if (pkt_continues(desc))
+			if (pkt_continues(desc->options))
 				continue;
 
 			/* The complete packet has been received */
@@ -1089,31 +1133,29 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 
 	for (i = 0; i < BATCH_SIZE; i++) {
 		struct pkt *pkt = pkt_stream_get_next_tx_pkt(pkt_stream);
-		u32 nb_frags, bytes_written = 0;
+		u32 nb_frags_left, nb_frags, bytes_written = 0;
 
 		if (!pkt)
 			break;
 
-		nb_frags = pkt_nb_frags(umem->frame_size, pkt);
+		nb_frags = pkt_nb_frags(umem->frame_size, pkt_stream, pkt);
 		if (nb_frags > BATCH_SIZE - i) {
 			pkt_stream_cancel(pkt_stream);
 			xsk_ring_prod__cancel(&xsk->tx, BATCH_SIZE - i);
 			break;
 		}
+		nb_frags_left = nb_frags;
 
-		if (pkt->valid) {
-			valid_pkts++;
-			valid_frags += nb_frags;
-		}
-
-		while (nb_frags--) {
+		while (nb_frags_left--) {
 			struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
 
 			tx_desc->addr = pkt_get_addr(pkt, ifobject->umem);
-			if (nb_frags) {
+			if (pkt_stream->verbatim) {
+				tx_desc->len = pkt->len;
+				tx_desc->options = pkt->options;
+			} else if (nb_frags_left) {
 				tx_desc->len = umem->frame_size;
 				tx_desc->options = XDP_PKT_CONTD;
-				i++;
 			} else {
 				tx_desc->len = pkt->len - bytes_written;
 				tx_desc->options = 0;
@@ -1122,6 +1164,17 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 				pkt_generate(ifobject, tx_desc->addr, tx_desc->len, pkt->pkt_nb,
 					     bytes_written);
 			bytes_written += tx_desc->len;
+
+			if (nb_frags_left) {
+				i++;
+				if (pkt_stream->verbatim)
+					pkt = pkt_stream_get_next_tx_pkt(pkt_stream);
+			}
+		}
+
+		if (pkt && pkt->valid) {
+			valid_pkts++;
+			valid_frags += nb_frags;
 		}
 	}
 
@@ -1350,7 +1403,7 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream
 		u64 addr;
 		u32 i;
 
-		for (i = 0; i < pkt_nb_frags(rx_frame_size, pkt); i++) {
+		for (i = 0; i < pkt_nb_frags(rx_frame_size, pkt_stream, pkt); i++) {
 			if (!pkt) {
 				if (!fill_up)
 					break;
@@ -1783,6 +1836,46 @@ static int testapp_multi_buffer(struct test_spec *test)
 	return testapp_validate_traffic(test);
 }
 
+static int testapp_invalid_desc_mb(struct test_spec *test)
+{
+	struct xsk_umem_info *umem = test->ifobj_tx->umem;
+	u64 umem_size = umem->num_frames * umem->frame_size;
+	struct pkt pkts[] = {
+		/* Valid packet for synch to start with */
+		{0, MIN_PKT_SIZE, 0, true, 0},
+		/* Zero frame len is not legal */
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{0, 0, 0, false, 0},
+		/* Invalid address in the second frame */
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{umem_size, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		/* Invalid len in the middle */
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{0, XSK_UMEM__INVALID_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		/* Invalid options in the middle */
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XSK_DESC__INVALID_OPTION},
+		/* Transmit 2 frags, receive 3 */
+		{0, XSK_UMEM__MAX_FRAME_SIZE, 0, true, XDP_PKT_CONTD},
+		{0, XSK_UMEM__MAX_FRAME_SIZE, 0, true, 0},
+		/* Middle frame crosses chunk boundary with small length */
+		{0, XSK_UMEM__LARGE_FRAME_SIZE, 0, false, XDP_PKT_CONTD},
+		{-MIN_PKT_SIZE / 2, MIN_PKT_SIZE, 0, false, 0},
+		/* Valid packet for synch so that something is received */
+		{0, MIN_PKT_SIZE, 0, true, 0}};
+
+	if (umem->unaligned_mode) {
+		/* Crossing a chunk boundary allowed */
+		pkts[12].valid = true;
+		pkts[13].valid = true;
+	}
+
+	test->mtu = MAX_ETH_JUMBO_SIZE;
+	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
+	return testapp_validate_traffic(test);
+}
+
 static int testapp_invalid_desc(struct test_spec *test)
 {
 	struct xsk_umem_info *umem = test->ifobj_tx->umem;
@@ -2037,6 +2130,16 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		ret = testapp_invalid_desc(test);
 		break;
 	}
+	case TEST_TYPE_ALIGNED_INV_DESC_MB:
+		test_spec_set_name(test, "ALIGNED_INV_DESC_MULTI_BUFF");
+		ret = testapp_invalid_desc_mb(test);
+		break;
+	case TEST_TYPE_UNALIGNED_INV_DESC_MB:
+		test_spec_set_name(test, "UNALIGNED_INV_DESC_MULTI_BUFF");
+		test->ifobj_tx->umem->unaligned_mode = true;
+		test->ifobj_rx->umem->unaligned_mode = true;
+		ret = testapp_invalid_desc_mb(test);
+		break;
 	case TEST_TYPE_UNALIGNED:
 		ret = testapp_unaligned(test);
 		break;
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 42bde17e8d17..de781357ea15 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -50,6 +50,9 @@
 #define RX_FULL_RXQSIZE 32
 #define UMEM_HEADROOM_TEST_SIZE 128
 #define XSK_UMEM__INVALID_FRAME_SIZE (MAX_ETH_JUMBO_SIZE + 1)
+#define XSK_UMEM__LARGE_FRAME_SIZE (3 * 1024)
+#define XSK_UMEM__MAX_FRAME_SIZE (4 * 1024)
+#define XSK_DESC__INVALID_OPTION (0xffff)
 #define HUGEPAGE_SIZE (2 * 1024 * 1024)
 #define PKT_DUMP_NB_TO_PRINT 16
 
@@ -87,6 +90,8 @@ enum test_type {
 	TEST_TYPE_XDP_METADATA_COUNT,
 	TEST_TYPE_RUN_TO_COMPLETION_MB,
 	TEST_TYPE_UNALIGNED_MB,
+	TEST_TYPE_ALIGNED_INV_DESC_MB,
+	TEST_TYPE_UNALIGNED_INV_DESC_MB,
 	TEST_TYPE_MAX
 };
 
@@ -119,6 +124,7 @@ struct pkt {
 	u32 len;
 	u32 pkt_nb;
 	bool valid;
+	u16 options;
 };
 
 struct pkt_stream {
@@ -126,6 +132,7 @@ struct pkt_stream {
 	u32 current_pkt_nb;
 	struct pkt *pkts;
 	u32 max_pkt_len;
+	bool verbatim;
 };
 
 struct ifobject;
-- 
2.34.1


