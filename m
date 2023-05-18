Return-Path: <netdev+bounces-3741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E60C870879E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:13:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C06D01C2114F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A2E36D95;
	Thu, 18 May 2023 18:06:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DFF36D82;
	Thu, 18 May 2023 18:06:58 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6A78F;
	Thu, 18 May 2023 11:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433216; x=1715969216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JLRI9w7J8tNxgPMgG5VTS8fXd8CXzLu49u53Tfuumb0=;
  b=ASooOm+DvsGSMhr5wjj8Hdv4Z3niO8mTDVX5MKhRWe9F0NCZMIUh30U4
   jT57wWwLhMFTK2t2jGKISd1FFtCf0OAZSaAheSTDpckt3orVgCtpNITKw
   jHgPbvHhI6wtQyJ6dRh6L1gTEdTQSXdtDC7+jRqMHbwvGHZu/BjzqQSRF
   +sGyLthfFWxbbJ1VrA4UDsV8Au24UW4DzC9G5vd9g065eWj86DKr6fsbV
   7mNknIXU+I6oBaNp8oDhYVPhvvBcxaC3VJSYo3J/FWmeMNR9B68qWPQk1
   nhsz8Masnz2MjJ9sOMXCU9oqqSHmUywVoPtVR5Z5JOnDM+je4EA4LkAFX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350985025"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350985025"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780517"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780517"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:28 -0700
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
Subject: [PATCH bpf-next 15/21] selftests/xsk: transmit and receive multi-buffer packets
Date: Thu, 18 May 2023 20:05:39 +0200
Message-Id: <20230518180545.159100-16-maciej.fijalkowski@intel.com>
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

Add the ability to send and receive packets that are larger than the
size of a umem frame, using the AF_XDP /XDP multi-buffer
support. There are three pieces of code that need to be changed to
achieve this: the Rx path, the Tx path, and the validation logic.

Both the Rx path and Tx could only deal with a single fragment per
packet. The Tx path is extended with a new function called
pkt_nb_frags() that can be used to retrieve the number of fragments a
packet will consume. We then create these many fragments in a loop and
fill the N-1 first ones to the max size limit to use the buffer space
efficiently, and the Nth one with whatever data that is left. This
goes on until we have filled in at the most BATCH_SIZE worth of
descriptors and fragments. If we detect that the next packet would
lead to BATCH_SIZE number of fragments sent being exceeded, we do not
send this packet and finish the batch. This packet is instead sent in
the next iteration of BATCH_SIZE fragments.

For Rx, we loop over all fragments we receive as usual, but for every
descriptor that we receive we call a new validation function called
is_frag_valid() to validate the consistency of this fragment. The code
then checks if the packet continues in the next frame. If so, it loops
over the next packet and performs the same validation. once we have
received the last fragment of the packet we also call the function
is_pkt_valid() to validate the packet as a whole. If we get to the end
of the batch and we are not at the end of the current packet, we back
out the partial packet and end the loop. Once we get into the receive
loop next time, we start over from the beginning of that packet. This
so the code becomes simpler at the cost of some performance.

The validation function is_frag_valid() checks that the sequence and
packet numbers are correct at the start and end of each fragment.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/include/uapi/linux/if_xdp.h        |   3 +
 tools/testing/selftests/bpf/xskxceiver.c | 167 ++++++++++++++++++-----
 tools/testing/selftests/bpf/xskxceiver.h |   3 +-
 3 files changed, 139 insertions(+), 34 deletions(-)

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index a78a8096f4ce..80245f5b4dd7 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -106,6 +106,9 @@ struct xdp_desc {
 	__u32 options;
 };
 
+/* Flag indicating packet constitutes of multiple buffers*/
+#define XDP_PKT_CONTD (1 << 0)
+
 /* UMEM descriptor is __u64 */
 
 #endif /* _LINUX_IF_XDP_H */
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 218d7f694e5c..5e29e8850488 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -533,6 +533,11 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
 	return pkt_stream;
 }
 
+static bool pkt_continues(const struct xdp_desc *desc)
+{
+	return desc->options & XDP_PKT_CONTD;
+}
+
 static u32 ceil_u32(u32 a, u32 b)
 {
 	return (a + b - 1) / b;
@@ -549,7 +554,7 @@ static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, int offset, u32
 {
 	pkt->offset = offset;
 	pkt->len = len;
-	if (len > umem->frame_size - XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 2 - umem->frame_headroom)
+	if (len > MAX_ETH_JUMBO_SIZE)
 		pkt->valid = false;
 	else
 		pkt->valid = true;
@@ -637,6 +642,11 @@ static u64 pkt_get_addr(struct pkt *pkt, struct xsk_umem_info *umem)
 	return pkt->offset + umem_alloc_buffer(umem);
 }
 
+static void pkt_stream_cancel(struct pkt_stream *pkt_stream)
+{
+	pkt_stream->current_pkt_nb--;
+}
+
 static void pkt_generate(struct ifobject *ifobject, u64 addr, u32 len, u32 pkt_nb,
 			 u32 bytes_written)
 {
@@ -765,43 +775,81 @@ static bool is_metadata_correct(struct pkt *pkt, void *buffer, u64 addr)
 	return true;
 }
 
-static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
+static bool is_frag_valid(struct xsk_umem_info *umem, u64 addr, u32 len, u32 expected_pkt_nb,
+			  u32 bytes_processed)
 {
-	void *data = xsk_umem__get_data(buffer, addr);
-	u32 seqnum, pkt_data;
+	u32 seqnum, pkt_nb, *pkt_data, words_to_end, expected_seqnum;
+	void *data = xsk_umem__get_data(umem->buffer, addr);
 
-	if (!pkt) {
-		ksft_print_msg("[%s] too many packets received\n", __func__);
-		goto error;
+	addr -= umem->base_addr;
+
+	if (addr >= umem->num_frames * umem->frame_size ||
+	    addr + len > umem->num_frames * umem->frame_size) {
+		ksft_print_msg("Frag invalid addr: %llx len: %u\n", addr, len);
+		return false;
+	}
+	if (!umem->unaligned_mode && addr % umem->frame_size + len > umem->frame_size) {
+		ksft_print_msg("Frag crosses frame boundary addr: %llx len: %u\n", addr, len);
+		return false;
 	}
 
-	if (len < MIN_PKT_SIZE || pkt->len < MIN_PKT_SIZE) {
-		/* Do not try to verify packets that are smaller than minimum size. */
-		return true;
+	pkt_data = data;
+	if (!bytes_processed) {
+		pkt_data += PKT_HDR_SIZE / sizeof(*pkt_data);
+		len -= PKT_HDR_SIZE;
+	} else {
+		bytes_processed -= PKT_HDR_SIZE;
 	}
 
-	if (pkt->len != len) {
-		ksft_print_msg("[%s] expected length [%d], got length [%d]\n",
-			       __func__, pkt->len, len);
+	expected_seqnum = bytes_processed / sizeof(*pkt_data);
+	seqnum = ntohl(*pkt_data) & 0xffff;
+	pkt_nb = ntohl(*pkt_data) >> 16;
+
+	if (expected_pkt_nb != pkt_nb) {
+		ksft_print_msg("[%s] expected pkt_nb [%u], got pkt_nb [%u]\n",
+			       __func__, expected_pkt_nb, pkt_nb);
+		goto error;
+	}
+	if (expected_seqnum != seqnum) {
+		ksft_print_msg("[%s] expected seqnum at start [%u], got seqnum [%u]\n",
+			       __func__, expected_seqnum, seqnum);
 		goto error;
 	}
 
-	pkt_data = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
-	seqnum = pkt_data >> 16;
-
-	if (pkt->pkt_nb != seqnum) {
-		ksft_print_msg("[%s] expected seqnum [%d], got seqnum [%d]\n",
-			       __func__, pkt->pkt_nb, seqnum);
+	words_to_end = len / sizeof(*pkt_data) - 1;
+	pkt_data += words_to_end;
+	seqnum = ntohl(*pkt_data) & 0xffff;
+	expected_seqnum += words_to_end;
+	if (expected_seqnum != seqnum) {
+		ksft_print_msg("[%s] expected seqnum at end [%u], got seqnum [%u]\n",
+			       __func__, expected_seqnum, seqnum);
 		goto error;
 	}
 
 	return true;
 
 error:
-	pkt_dump(data, len, true);
+	pkt_dump(data, len, !bytes_processed);
 	return false;
 }
 
+static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
+{
+	if (!pkt) {
+		ksft_print_msg("[%s] too many packets received\n", __func__);
+		return false;
+	}
+
+	if (pkt->len != len) {
+		ksft_print_msg("[%s] expected packet length [%d], got length [%d]\n",
+			       __func__, pkt->len, len);
+		pkt_dump(xsk_umem__get_data(buffer, addr), len, true);
+		return false;
+	}
+
+	return true;
+}
+
 static void kick_tx(struct xsk_socket_info *xsk)
 {
 	int ret;
@@ -854,8 +902,8 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 {
 	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
 	struct pkt_stream *pkt_stream = test->ifobj_rx->pkt_stream;
-	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkts_sent = 0;
 	struct xsk_socket_info *xsk = test->ifobj_rx->xsk;
+	u32 idx_rx = 0, idx_fq = 0, rcvd, pkts_sent = 0;
 	struct ifobject *ifobj = test->ifobj_rx;
 	struct xsk_umem_info *umem = xsk->umem;
 	struct pkt *pkt;
@@ -868,6 +916,9 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 
 	pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &pkts_sent);
 	while (pkt) {
+		u32 frags_processed = 0, nb_frags = 0, pkt_len = 0;
+		u64 first_addr;
+
 		ret = gettimeofday(&tv_now, NULL);
 		if (ret)
 			exit_with_error(errno);
@@ -913,27 +964,53 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 			}
 		}
 
-		for (i = 0; i < rcvd; i++) {
+		while (frags_processed < rcvd) {
 			const struct xdp_desc *desc = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
 			u64 addr = desc->addr, orig;
 
 			orig = xsk_umem__extract_addr(addr);
 			addr = xsk_umem__add_offset_to_addr(addr);
 
-			if (!is_pkt_valid(pkt, umem->buffer, addr, desc->len) ||
+			if (!is_frag_valid(umem, addr, desc->len, pkt->pkt_nb, pkt_len) ||
 			    !is_offset_correct(umem, pkt, addr) ||
 			    (ifobj->use_metadata && !is_metadata_correct(pkt, umem->buffer, addr)))
 				return TEST_FAILURE;
 
+			if (!nb_frags++)
+				first_addr = addr;
+			frags_processed++;
+			pkt_len += desc->len;
 			if (ifobj->use_fill_ring)
 				*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
+
+			if (pkt_continues(desc))
+				continue;
+
+			/* The complete packet has been received */
+			if (!is_pkt_valid(pkt, umem->buffer, first_addr, pkt_len) ||
+			    !is_offset_correct(umem, pkt, addr))
+				return TEST_FAILURE;
+
 			pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &pkts_sent);
+			nb_frags = 0;
+			pkt_len = 0;
+		}
+
+		if (nb_frags) {
+			/* In the middle of a packet. Start over from beginning of packet. */
+			idx_rx -= nb_frags;
+			xsk_ring_cons__cancel(&xsk->rx, nb_frags);
+			if (ifobj->use_fill_ring) {
+				idx_fq -= nb_frags;
+				xsk_ring_prod__cancel(&umem->fq, nb_frags);
+			}
+			frags_processed -= nb_frags;
 		}
 
 		if (ifobj->use_fill_ring)
-			xsk_ring_prod__submit(&umem->fq, rcvd);
+			xsk_ring_prod__submit(&umem->fq, frags_processed);
 		if (ifobj->release_rx)
-			xsk_ring_cons__release(&xsk->rx, rcvd);
+			xsk_ring_cons__release(&xsk->rx, frags_processed);
 
 		pthread_mutex_lock(&pacing_mutex);
 		pkts_in_flight -= pkts_sent;
@@ -946,13 +1023,14 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 
 static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeout)
 {
+	u32 i, idx = 0, valid_pkts = 0, valid_frags = 0, buffer_len;
+	struct pkt_stream *pkt_stream = ifobject->pkt_stream;
 	struct xsk_socket_info *xsk = ifobject->xsk;
 	struct xsk_umem_info *umem = ifobject->umem;
-	u32 i, idx = 0, valid_pkts = 0, buffer_len;
 	bool use_poll = ifobject->use_poll;
 	int ret;
 
-	buffer_len = pkt_get_buffer_len(umem, ifobject->pkt_stream->max_pkt_len);
+	buffer_len = pkt_get_buffer_len(umem, pkt_stream->max_pkt_len);
 	/* pkts_in_flight might be negative if many invalid packets are sent */
 	if (pkts_in_flight >= (int)((umem_size(umem) - BATCH_SIZE * buffer_len) / buffer_len)) {
 		kick_tx(xsk);
@@ -983,17 +1061,40 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 	}
 
 	for (i = 0; i < BATCH_SIZE; i++) {
-		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
-		struct pkt *pkt = pkt_stream_get_next_tx_pkt(ifobject->pkt_stream);
+		struct pkt *pkt = pkt_stream_get_next_tx_pkt(pkt_stream);
+		u32 nb_frags, bytes_written = 0;
 
 		if (!pkt)
 			break;
 
-		tx_desc->addr = pkt_get_addr(pkt, umem);
-		tx_desc->len = pkt->len;
+		nb_frags = pkt_nb_frags(umem->frame_size, pkt);
+		if (nb_frags > BATCH_SIZE - i) {
+			pkt_stream_cancel(pkt_stream);
+			xsk_ring_prod__cancel(&xsk->tx, BATCH_SIZE - i);
+			break;
+		}
+
 		if (pkt->valid) {
 			valid_pkts++;
-			pkt_generate(ifobject, tx_desc->addr, tx_desc->len, pkt->pkt_nb, 0);
+			valid_frags += nb_frags;
+		}
+
+		while (nb_frags--) {
+			struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
+
+			tx_desc->addr = pkt_get_addr(pkt, ifobject->umem);
+			if (nb_frags) {
+				tx_desc->len = umem->frame_size;
+				tx_desc->options = XDP_PKT_CONTD;
+				i++;
+			} else {
+				tx_desc->len = pkt->len - bytes_written;
+				tx_desc->options = 0;
+			}
+			if (pkt->valid)
+				pkt_generate(ifobject, tx_desc->addr, tx_desc->len, pkt->pkt_nb,
+					     bytes_written);
+			bytes_written += tx_desc->len;
 		}
 	}
 
@@ -1002,7 +1103,7 @@ static int __send_pkts(struct ifobject *ifobject, struct pollfd *fds, bool timeo
 	pthread_mutex_unlock(&pacing_mutex);
 
 	xsk_ring_prod__submit(&xsk->tx, i);
-	xsk->outstanding_tx += valid_pkts;
+	xsk->outstanding_tx += valid_frags;
 
 	if (use_poll) {
 		ret = poll(fds, 1, POLL_TMOUT);
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index aaf27e067640..310b48ad8a3a 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -38,6 +38,7 @@
 #define MAX_TEARDOWN_ITER 10
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + 2) /* Just to align the data in the packet */
 #define MIN_PKT_SIZE 64
+#define MAX_ETH_JUMBO_SIZE 9000
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
@@ -47,7 +48,7 @@
 #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
 #define RX_FULL_RXQSIZE 32
 #define UMEM_HEADROOM_TEST_SIZE 128
-#define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
+#define XSK_UMEM__INVALID_FRAME_SIZE (MAX_ETH_JUMBO_SIZE + 1)
 #define HUGEPAGE_SIZE (2 * 1024 * 1024)
 #define PKT_DUMP_NB_TO_PRINT 16
 
-- 
2.34.1


