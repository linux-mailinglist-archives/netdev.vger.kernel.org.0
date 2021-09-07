Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFE6402422
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbhIGHWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240786AbhIGHVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C20DC061575;
        Tue,  7 Sep 2021 00:20:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x6so12874039wrv.13;
        Tue, 07 Sep 2021 00:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0zvd97MQ2awkaDR2YzW4F2poI6DAfk+808PDcd11PWI=;
        b=dsqxrqNxDtR4q/0DALD6PYam9JAji708itkl2C9QFEUbQd5BNVLcU06SDx0R1gEYNd
         qVI7TlS188o6V6Yu1bT3FRMbYnxK+So7JeBdVle8DimvwgIn29IPwYwbZb1A+rA6Ph2g
         4wcZnmJPowKOun0s01BCTP94RZF9dx+35lYnRY5Qlq4hAmjbJF5kC3gOjbkFtMS4Dgy4
         gmUxx73h6th57V7u2xikwHhSg0+RBhPUInyeQpxtVUBoSlf6jwZDOrERr8CTj44JmoOF
         Q66wNxbkKlnuwqr95OdvJZPpw8sz7NYPCK2Pi3+wH70iq1Sj47YzqUcPJr6Sdu0BX5O8
         N+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0zvd97MQ2awkaDR2YzW4F2poI6DAfk+808PDcd11PWI=;
        b=qxNR3I/ZqccuRQhkUvbmcMWxM7tCnAVHxSNZr41XdYaU0pFhv0kNa+o7qtjY7aoRKp
         W3F+LJVCCzG5qvX5Cubu1rPZDPi/in/pNH8vM9flLs7VwjGznW2iusAUok53xx9w+BsD
         +jUl/fcex9oJfG+jzmevENXcVDuYj2t+4ES0Ls2CB7QpWVumGmp6eIZn2Q2rN6KFX9F5
         bESbrlhkZm3k0eD9CqE7ao97a0c3mDaNd+VYvAvZMhs/9XRB6D/gjFg9ZTILcFK6C7EB
         /+ZC9SHeNjTH8P6nLBrpBp6fyhk4YW2YGDnCH/cC/YN33EDZO+rmcdgg9W48cxy0JmSB
         b8+g==
X-Gm-Message-State: AOAM531XvCIkGsitBeXzMwzlm7XYLNX3yOhz7q2oO1aVPIBvOq7KR1VW
        f0G9l0ED6hgODe84reRzlWM=
X-Google-Smtp-Source: ABdhPJxzuliIzWj1RK+f40OmVQxh5dLydOHDVtE9cMOp+mfdGGi2ADBAGHDVQPLEG3LBSZ+bIC94AA==
X-Received: by 2002:adf:ec81:: with SMTP id z1mr16863983wrn.181.1630999214962;
        Tue, 07 Sep 2021 00:20:14 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:14 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 17/20] selftests: xsk: add test for unaligned mode
Date:   Tue,  7 Sep 2021 09:19:25 +0200
Message-Id: <20210907071928.9750-18-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a test for unaligned mode in which packet buffers can be placed
anywhere within the umem. Some packets are made to straddle page
boundaries in order to check for correctness. On the Tx side, buffers
are now allocated according to the addresses found in the packet
stream. Thus, the placement of buffers can be controlled with the
boolean use_addr_for_fill in the packet stream.

One new pkt_stream interface is introduced: pkt_stream_replace_half()
that replaces every other packet in the default packet stream with the
specified new packet. The constant DEFAULT_OFFSET is also
introduced. It specifies at what offset from the start of a chunk a Tx
packet is placed by the sending thread. This is just to be able to
test that it is possible to send packets at an offset not equal to
zero.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 127 +++++++++++++++++++----
 tools/testing/selftests/bpf/xdpxceiver.h |   4 +
 2 files changed, 108 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 70a8435e3d5e..7cc75d1481e2 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -19,7 +19,7 @@
  * Virtual Ethernet interfaces.
  *
  * For each mode, the following tests are run:
- *    a. nopoll - soft-irq processing
+ *    a. nopoll - soft-irq processing in run-to-completion mode
  *    b. poll - using poll() syscall
  *    c. Socket Teardown
  *       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
@@ -45,6 +45,7 @@
  *       Configure sockets at indexes 0 and 1, run a traffic on queue ids 0,
  *       then remove xsk sockets from queue 0 on both veth interfaces and
  *       finally run a traffic on queues ids 1
+ *    g. unaligned mode
  *
  * Total tests: 12
  *
@@ -243,6 +244,9 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 	};
 	int ret;
 
+	if (umem->unaligned_mode)
+		cfg.flags |= XDP_UMEM_UNALIGNED_CHUNK_FLAG;
+
 	ret = xsk_umem__create(&umem->umem, buffer, size,
 			       &umem->fq, &umem->cq, &cfg);
 	if (ret)
@@ -252,19 +256,6 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 	return 0;
 }
 
-static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
-{
-	int ret, i;
-	u32 idx = 0;
-
-	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
-	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
-		exit_with_error(-ret);
-	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
-		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = i * umem->frame_size;
-	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
-}
-
 static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
 				struct ifobject *ifobject, u32 qid)
 {
@@ -477,7 +468,7 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	struct pkt_stream *pkt_stream;
 	u32 i;
 
-	pkt_stream = malloc(sizeof(*pkt_stream));
+	pkt_stream = calloc(1, sizeof(*pkt_stream));
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
@@ -487,7 +478,8 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 
 	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
+		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size +
+			DEFAULT_OFFSET;
 		pkt_stream->pkts[i].len = pkt_len;
 		pkt_stream->pkts[i].payload = i;
 
@@ -500,6 +492,12 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	return pkt_stream;
 }
 
+static struct pkt_stream *pkt_stream_clone(struct xsk_umem_info *umem,
+					   struct pkt_stream *pkt_stream)
+{
+	return pkt_stream_generate(umem, pkt_stream->nb_pkts, pkt_stream->pkts[0].len);
+}
+
 static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
 {
 	struct pkt_stream *pkt_stream;
@@ -509,6 +507,22 @@ static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
 	test->ifobj_rx->pkt_stream = pkt_stream;
 }
 
+static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, u32 offset)
+{
+	struct xsk_umem_info *umem = test->ifobj_tx->umem;
+	struct pkt_stream *pkt_stream;
+	u32 i;
+
+	pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
+	for (i = 0; i < test->pkt_stream_default->nb_pkts; i += 2) {
+		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size + offset;
+		pkt_stream->pkts[i].len = pkt_len;
+	}
+
+	test->ifobj_tx->pkt_stream = pkt_stream;
+	test->ifobj_rx->pkt_stream = pkt_stream;
+}
+
 static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
@@ -570,9 +584,9 @@ static void pkt_dump(void *pkt, u32 len)
 	fprintf(stdout, "---------------------------------------\n");
 }
 
-static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *desc)
+static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 {
-	void *data = xsk_umem__get_data(buffer, desc->addr);
+	void *data = xsk_umem__get_data(buffer, addr);
 	struct iphdr *iphdr = (struct iphdr *)(data + sizeof(struct ethhdr));
 
 	if (!pkt) {
@@ -586,10 +600,10 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *d
 		if (opt_pkt_dump)
 			pkt_dump(data, PKT_SIZE);
 
-		if (pkt->len != desc->len) {
+		if (pkt->len != len) {
 			ksft_test_result_fail
 				("ERROR: [%s] expected length [%d], got length [%d]\n",
-					__func__, pkt->len, desc->len);
+					__func__, pkt->len, len);
 			return false;
 		}
 
@@ -671,7 +685,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 
 			orig = xsk_umem__extract_addr(addr);
 			addr = xsk_umem__add_offset_to_addr(addr);
-			if (!is_pkt_valid(pkt, xsk->umem->buffer, desc))
+			if (!is_pkt_valid(pkt, xsk->umem->buffer, addr, desc->len))
 				return;
 
 			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = orig;
@@ -815,13 +829,16 @@ static void tx_stats_validate(struct ifobject *ifobject)
 
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 {
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 	u32 i;
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
+	if (ifobject->umem->unaligned_mode)
+		mmap_flags |= MAP_HUGETLB;
+
 	for (i = 0; i < test->nb_sockets; i++) {
 		u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
-		int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
 		u32 ctr = 0;
 		void *bufs;
 
@@ -879,6 +896,32 @@ static void *worker_testapp_validate_tx(void *arg)
 	pthread_exit(NULL);
 }
 
+static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
+{
+	u32 idx = 0, i;
+	int ret;
+
+	ret = xsk_ring_prod__reserve(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
+	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
+		exit_with_error(ENOSPC);
+	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++) {
+		u64 addr;
+
+		if (pkt_stream->use_addr_for_fill) {
+			struct pkt *pkt = pkt_stream_get_pkt(pkt_stream, i);
+
+			if (!pkt)
+				break;
+			addr = pkt->addr;
+		} else {
+			addr = (i % umem->num_frames) * umem->frame_size + DEFAULT_OFFSET;
+		}
+
+		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
+	}
+	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
+}
+
 static void *worker_testapp_validate_rx(void *arg)
 {
 	struct test_spec *test = (struct test_spec *)arg;
@@ -889,7 +932,7 @@ static void *worker_testapp_validate_rx(void *arg)
 		thread_common_ops(test, ifobject);
 
 	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
-		xsk_populate_fill_ring(ifobject->umem);
+		xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
 
 	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds.events = POLLIN;
@@ -1033,6 +1076,40 @@ static void testapp_stats(struct test_spec *test)
 	test_spec_set_name(test, "STATS");
 }
 
+/* Simple test */
+static bool hugepages_present(struct ifobject *ifobject)
+{
+	const size_t mmap_sz = 2 * ifobject->umem->num_frames * ifobject->umem->frame_size;
+	void *bufs;
+
+	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_HUGETLB, -1, 0);
+	if (bufs == MAP_FAILED)
+		return false;
+
+	munmap(bufs, mmap_sz);
+	return true;
+}
+
+static bool testapp_unaligned(struct test_spec *test)
+{
+	if (!hugepages_present(test->ifobj_tx)) {
+		ksft_test_result_skip("No 2M huge pages present.\n");
+		return false;
+	}
+
+	test_spec_set_name(test, "UNALIGNED_MODE");
+	test->ifobj_tx->umem->unaligned_mode = true;
+	test->ifobj_rx->umem->unaligned_mode = true;
+	/* Let half of the packets straddle a buffer boundrary */
+	pkt_stream_replace_half(test, PKT_SIZE, test->ifobj_tx->umem->frame_size - 32);
+	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
+	testapp_validate_traffic(test);
+
+	pkt_stream_restore_default(test);
+	return true;
+}
+
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
 		       const char *dst_ip, const char *src_ip, const u16 dst_port,
 		       const u16 src_port, thread_func_t func_ptr)
@@ -1084,6 +1161,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "POLL");
 		testapp_validate_traffic(test);
 		break;
+	case TEST_TYPE_UNALIGNED:
+		if (!testapp_unaligned(test))
+			return;
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index e27fe348ae50..129801eb013c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -39,6 +39,7 @@
 #define POLL_TMOUT 1000
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define RX_FULL_RXQSIZE 32
+#define DEFAULT_OFFSET 256
 #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
@@ -52,6 +53,7 @@ enum test_mode {
 enum test_type {
 	TEST_TYPE_NOPOLL,
 	TEST_TYPE_POLL,
+	TEST_TYPE_UNALIGNED,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
 	TEST_TYPE_STATS,
@@ -81,6 +83,7 @@ struct xsk_umem_info {
 	u32 frame_headroom;
 	void *buffer;
 	u32 frame_size;
+	bool unaligned_mode;
 };
 
 struct xsk_socket_info {
@@ -102,6 +105,7 @@ struct pkt {
 struct pkt_stream {
 	u32 nb_pkts;
 	struct pkt *pkts;
+	bool use_addr_for_fill;
 };
 
 typedef void *(*thread_func_t)(void *arg);
-- 
2.29.0

