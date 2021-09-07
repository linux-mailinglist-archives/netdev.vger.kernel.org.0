Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D6402418
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhIGHWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240450AbhIGHVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:20 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E2C06175F;
        Tue,  7 Sep 2021 00:20:14 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so557648wmq.1;
        Tue, 07 Sep 2021 00:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KsqQOWG3KYoZ56i/cq7e4DYZHkGdG+nc9XpclIIvTEk=;
        b=lBNdh9L/a1rBFGn+jJkavKv3HOqsr34A93mTXe5TWizzvorqo/fcg0c9fOeBWzsL0Q
         uHU03FgTgmp2vU6qnTDiRQqA3lH+AIoUgr+ZDUJWgyTwJe2v6cap+MW+UkV4DOBWeAUA
         ixzVjCM43m3wdhCpzKfy+xZ/QaiKjbEahabLR2wvcPFRz5HjUsZkyOwCiDf8cyPS9EyT
         7JtcnA2vWQ2vXQcMlKPmPvf8MtGoUTErL0uGFNOOzRNVX0JBPwzphk2/oO65+s60jOY0
         TfWTQJwZuAF5mWRH2d0dz1b3zaA2lr7R995DbHywgmHr8ktsVHQJTm1psAR3du3Vhymz
         2bGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KsqQOWG3KYoZ56i/cq7e4DYZHkGdG+nc9XpclIIvTEk=;
        b=SqIcCW4B/9cC6iM8OdWdUKDMKgPueDpC0kX4cfEjc9qzX6VKTS7zBPBojoZBi+MYB9
         bT6YFHmP1uhcIsehtkrYEKY5kU/WxkGt37G7J6e1kHxhrGMAX7SXPaOvBmqzTm+LPB2v
         SZtSzWK0QiCBJ/LlsA97+J4rmJ/RTaccztf+i5b45oADoekeaBc4WMQB2aZylPL+2YQ6
         27vcf2kMuBpCktCE7uehJUz50owuqT7XSKRqo6HDXbluwkMarMXFbBoeMrUSrlzwql+g
         pQCB+wTm/6RNY1EMiym+khNFsVdNOJ6ODVRVhwZ/82EFw9wbSo6gIYxui6BJpAVujMHe
         QpbA==
X-Gm-Message-State: AOAM530XL29o64cTXnAKDrE9gTKNSzYy4KQN5yMWi1jIIW2ArDgAsokm
        2bYiPbTwn0qMirp9nkkUIGU=
X-Google-Smtp-Source: ABdhPJwUrtUFLkgS6DeUsOKWtc+HQNdhahRFR0+xUqI12QFUVEsJ5xG8jbNr/vcLGW5sGqdYIeAX1w==
X-Received: by 2002:a7b:c4c2:: with SMTP id g2mr2431332wmk.134.1630999213356;
        Tue, 07 Sep 2021 00:20:13 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:12 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 16/20] selftests: xsk: introduce replacing the default packet stream
Date:   Tue,  7 Sep 2021 09:19:24 +0200
Message-Id: <20210907071928.9750-17-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce the concept of a default packet stream that is the set of
packets sent by most tests. Then add the ability to replace it for a
test that would like to send or receive something else through the use
of the function pkt_stream_replace() and then restored with
pkt_stream_restore_default(). These are then used to convert the
STAT_TEST_TX_INVALID to use these new APIs.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 65 +++++++++++++++++-------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 2 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 09d2854c10e6..70a8435e3d5e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -390,6 +390,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		ifobj->umem = &ifobj->umem_arr[0];
 		ifobj->xsk = &ifobj->xsk_arr[0];
 		ifobj->use_poll = false;
+		ifobj->pkt_stream = test->pkt_stream_default;
 
 		if (i == 0) {
 			ifobj->rx_on = false;
@@ -418,9 +419,12 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 			   struct ifobject *ifobj_rx, enum test_mode mode)
 {
+	struct pkt_stream *pkt_stream;
 	u32 i;
 
+	pkt_stream = test->pkt_stream_default;
 	memset(test, 0, sizeof(*test));
+	test->pkt_stream_default = pkt_stream;
 
 	for (i = 0; i < MAX_INTERFACES; i++) {
 		struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
@@ -455,6 +459,19 @@ static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
 	return &pkt_stream->pkts[pkt_nb];
 }
 
+static void pkt_stream_delete(struct pkt_stream *pkt_stream)
+{
+	free(pkt_stream->pkts);
+	free(pkt_stream);
+}
+
+static void pkt_stream_restore_default(struct test_spec *test)
+{
+	pkt_stream_delete(test->ifobj_tx->pkt_stream);
+	test->ifobj_tx->pkt_stream = test->pkt_stream_default;
+	test->ifobj_rx->pkt_stream = test->pkt_stream_default;
+}
+
 static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
 {
 	struct pkt_stream *pkt_stream;
@@ -483,6 +500,15 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 	return pkt_stream;
 }
 
+static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
+{
+	struct pkt_stream *pkt_stream;
+
+	pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
+	test->ifobj_tx->pkt_stream = pkt_stream;
+	test->ifobj_rx->pkt_stream = pkt_stream;
+}
+
 static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
@@ -557,7 +583,7 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, const struct xdp_desc *d
 	if (iphdr->version == IP_PKT_VER && iphdr->tos == IP_PKT_TOS) {
 		u32 seqnum = ntohl(*((u32 *)(data + PKT_HDR_SIZE)));
 
-		if (opt_pkt_dump && test_type != TEST_TYPE_STATS)
+		if (opt_pkt_dump)
 			pkt_dump(data, PKT_SIZE);
 
 		if (pkt->len != desc->len) {
@@ -598,9 +624,6 @@ static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 	unsigned int rcvd;
 	u32 idx;
 
-	if (!xsk->outstanding_tx)
-		return;
-
 	if (xsk_ring_prod__needs_wakeup(&xsk->tx))
 		kick_tx(xsk);
 
@@ -831,6 +854,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 
 static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
 {
+	print_verbose("Destroying socket\n");
 	xsk_socket__delete(ifobj->xsk->xsk);
 	xsk_umem__delete(ifobj->umem->umem);
 }
@@ -878,9 +902,6 @@ static void *worker_testapp_validate_rx(void *arg)
 	else
 		receive_pkts(ifobject->pkt_stream, ifobject->xsk, &fds);
 
-	if (test_type == TEST_TYPE_TEARDOWN)
-		print_verbose("Destroying socket\n");
-
 	if (test->total_steps == test->current_step)
 		testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
@@ -890,19 +911,11 @@ static void testapp_validate_traffic(struct test_spec *test)
 {
 	struct ifobject *ifobj_tx = test->ifobj_tx;
 	struct ifobject *ifobj_rx = test->ifobj_rx;
-	struct pkt_stream *pkt_stream;
 	pthread_t t0, t1;
 
 	if (pthread_barrier_init(&barr, NULL, 2))
 		exit_with_error(errno);
 
-	if (stat_test_type == STAT_TEST_TX_INVALID)
-		pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, DEFAULT_PKT_CNT,
-						 XSK_UMEM__INVALID_FRAME_SIZE);
-	else
-		pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
-	ifobj_tx->pkt_stream = pkt_stream;
-	ifobj_rx->pkt_stream = pkt_stream;
 	test->current_step++;
 
 	/*Spawn RX thread */
@@ -982,7 +995,9 @@ static void testapp_bpf_res(struct test_spec *test)
 
 static void testapp_stats(struct test_spec *test)
 {
-	for (int i = 0; i < STAT_TEST_TYPE_MAX; i++) {
+	int i;
+
+	for (i = 0; i < STAT_TEST_TYPE_MAX; i++) {
 		test_spec_reset(test);
 		stat_test_type = i;
 
@@ -991,21 +1006,27 @@ static void testapp_stats(struct test_spec *test)
 			test_spec_set_name(test, "STAT_RX_DROPPED");
 			test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
 				XDP_PACKET_HEADROOM - 1;
+			testapp_validate_traffic(test);
 			break;
 		case STAT_TEST_RX_FULL:
 			test_spec_set_name(test, "STAT_RX_FULL");
 			test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
+			testapp_validate_traffic(test);
 			break;
 		case STAT_TEST_TX_INVALID:
 			test_spec_set_name(test, "STAT_TX_INVALID");
-			continue;
+			pkt_stream_replace(test, DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
+			testapp_validate_traffic(test);
+
+			pkt_stream_restore_default(test);
+			break;
 		case STAT_TEST_RX_FILL_EMPTY:
 			test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
+			testapp_validate_traffic(test);
 			break;
 		default:
 			break;
 		}
-		testapp_validate_traffic(test);
 	}
 
 	/* To only see the whole stat set being completed unless an individual test fails. */
@@ -1105,6 +1126,7 @@ static void ifobject_delete(struct ifobject *ifobj)
 int main(int argc, char **argv)
 {
 	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
+	struct pkt_stream *pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
 	struct test_spec test;
 	u32 i, j;
@@ -1133,6 +1155,12 @@ int main(int argc, char **argv)
 	init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
 		   worker_testapp_validate_rx);
 
+	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
+	pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
+	if (!pkt_stream_default)
+		exit_with_error(ENOMEM);
+	test.pkt_stream_default = pkt_stream_default;
+
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
 	for (i = 0; i < TEST_MODE_MAX; i++)
@@ -1142,6 +1170,7 @@ int main(int argc, char **argv)
 			usleep(USLEEP_MAX);
 		}
 
+	pkt_stream_delete(pkt_stream_default);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index c5baa7c5f560..e27fe348ae50 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -132,6 +132,7 @@ struct ifobject {
 struct test_spec {
 	struct ifobject *ifobj_tx;
 	struct ifobject *ifobj_rx;
+	struct pkt_stream *pkt_stream_default;
 	u16 total_steps;
 	u16 current_step;
 	u16 nb_sockets;
-- 
2.29.0

