Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5A521475
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbiEJMBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241384AbiEJMBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:01:07 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D7825D10C;
        Tue, 10 May 2022 04:57:04 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 125-20020a1c0283000000b003946c466c17so1212057wmc.4;
        Tue, 10 May 2022 04:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=smlcGBoGNk26tIu6S0Ew0q2w45mtqsrMZ7K5MqdCC/U=;
        b=Kpo1PEu6ihdRfHxR61dqK07phiATYtQ/nOyJDA0Wc6kcKHDDDGo1fRZYBc34Zo2vn4
         K4rHV4WmFrd9cqfcys3AwJHU852EQNlV+8sMvcTzjNoqYMLMyB+u6Gyeqsag0EknBghp
         74nQrp4j6M8KFMRqSXGRPsiFdIuMGdlrHaFslMScdOAEdHDF2vjTsnjCMFNkXO01yaq1
         Y2NDKPM6Y+AC0oPPLnCMnMFWsMqXSQ351mke+w2ZXxcXUlSw2lTDnMQKcfF3Jxqzuq4S
         67yQmMDfcmkGvyTCDvZTkowrXZn7eHFrxG4hmj8uk++/SXesKaQQntq1An+astnlv9FJ
         hE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=smlcGBoGNk26tIu6S0Ew0q2w45mtqsrMZ7K5MqdCC/U=;
        b=UmhcBEaUS0QIbd2CS3w+S3G/mlQ5C5DJ7cFjjVeBxzG1ph6hrOAUD3rK2H3hu/WCg+
         U7qZ0uIpSZXan2ypt0PNqVsz3/zIrDyA5VHdeZPVi6FtIYxTuYzjEOdam0v1X3xyxhnG
         Gcwh2MqZvEHITcDr/pPDjD2M6NZ2TiSwhgbrXtz360VbWYzVlz75EduJBcQhgetzz7su
         BiW94xFl2ETK6Q8WsrtGSKvq2VgS2Kkv8z0EZLLLaYtfmCLvAclmxXUmelZ9L9oPLnbG
         rjjP32Sc93mMxNkeW2d+Pfms1yiVb+Ev2vlur51sRhes+m/TOlTstuWq2+pGtfeSSTY2
         7trg==
X-Gm-Message-State: AOAM531grHl+4ZA2qtvTNfC9O7JeMG/2sxeP9mOl/CKnEbCOaMLbIa7/
        OcreWJbtFMfl0B9JxTEqpko=
X-Google-Smtp-Source: ABdhPJzrM/WszR8KhnhRvz9EnhdyGJF0dAFqm48rYJhF7OtwUEDdjo8yBo80pMxBo8UR2JH4cn50+A==
X-Received: by 2002:a05:600c:4f95:b0:394:8919:7557 with SMTP id n21-20020a05600c4f9500b0039489197557mr13207851wmq.166.1652183823080;
        Tue, 10 May 2022 04:57:03 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.57.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:57:02 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 9/9] selftests: xsk: make stat tests not spin on getsockopt
Date:   Tue, 10 May 2022 13:56:04 +0200
Message-Id: <20220510115604.8717-10-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Convert the stats tests from spinning on the getsockopt to just check
getsockopt once when the Rx thread has received all the packets. The
actual completion of receiving the last packet forms a natural point
in time when the receiver is ready to call the getsockopt to check the
stats. In the previous version , we just span on the getsockopt until
we received the right answer. This could be forever or just getting
the "correct" answer by shear luck.

The pacing_on variable can now be dropped since all test can now
handle pacing properly.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 170 +++++++++++++----------
 tools/testing/selftests/bpf/xdpxceiver.h |   6 +-
 2 files changed, 99 insertions(+), 77 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index a75af0ea19a3..e5992a6b5e09 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -424,7 +424,8 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 
 		ifobj->xsk = &ifobj->xsk_arr[0];
 		ifobj->use_poll = false;
-		ifobj->pacing_on = true;
+		ifobj->use_fill_ring = true;
+		ifobj->release_rx = true;
 		ifobj->pkt_stream = test->pkt_stream_default;
 		ifobj->validation_func = NULL;
 
@@ -503,9 +504,10 @@ static struct pkt *pkt_stream_get_pkt(struct pkt_stream *pkt_stream, u32 pkt_nb)
 	return &pkt_stream->pkts[pkt_nb];
 }
 
-static struct pkt *pkt_stream_get_next_rx_pkt(struct pkt_stream *pkt_stream)
+static struct pkt *pkt_stream_get_next_rx_pkt(struct pkt_stream *pkt_stream, u32 *pkts_sent)
 {
 	while (pkt_stream->rx_pkt_nb < pkt_stream->nb_pkts) {
+		(*pkts_sent)++;
 		if (pkt_stream->pkts[pkt_stream->rx_pkt_nb].valid)
 			return &pkt_stream->pkts[pkt_stream->rx_pkt_nb++];
 		pkt_stream->rx_pkt_nb++;
@@ -521,10 +523,16 @@ static void pkt_stream_delete(struct pkt_stream *pkt_stream)
 
 static void pkt_stream_restore_default(struct test_spec *test)
 {
-	if (test->ifobj_tx->pkt_stream != test->pkt_stream_default) {
+	struct pkt_stream *tx_pkt_stream = test->ifobj_tx->pkt_stream;
+
+	if (tx_pkt_stream != test->pkt_stream_default) {
 		pkt_stream_delete(test->ifobj_tx->pkt_stream);
 		test->ifobj_tx->pkt_stream = test->pkt_stream_default;
 	}
+
+	if (test->ifobj_rx->pkt_stream != test->pkt_stream_default &&
+	    test->ifobj_rx->pkt_stream != tx_pkt_stream)
+		pkt_stream_delete(test->ifobj_rx->pkt_stream);
 	test->ifobj_rx->pkt_stream = test->pkt_stream_default;
 }
 
@@ -546,6 +554,16 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
 	return pkt_stream;
 }
 
+static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, u64 addr, u32 len)
+{
+	pkt->addr = addr;
+	pkt->len = len;
+	if (len > umem->frame_size - XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 2 - umem->frame_headroom)
+		pkt->valid = false;
+	else
+		pkt->valid = true;
+}
+
 static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb_pkts, u32 pkt_len)
 {
 	struct pkt_stream *pkt_stream;
@@ -557,14 +575,9 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
 
 	pkt_stream->nb_pkts = nb_pkts;
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size;
-		pkt_stream->pkts[i].len = pkt_len;
+		pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
+			pkt_len);
 		pkt_stream->pkts[i].payload = i;
-
-		if (pkt_len > umem->frame_size)
-			pkt_stream->pkts[i].valid = false;
-		else
-			pkt_stream->pkts[i].valid = true;
 	}
 
 	return pkt_stream;
@@ -592,15 +605,27 @@ static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int off
 	u32 i;
 
 	pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
-	for (i = 1; i < test->pkt_stream_default->nb_pkts; i += 2) {
-		pkt_stream->pkts[i].addr = (i % umem->num_frames) * umem->frame_size + offset;
-		pkt_stream->pkts[i].len = pkt_len;
-	}
+	for (i = 1; i < test->pkt_stream_default->nb_pkts; i += 2)
+		pkt_set(umem, &pkt_stream->pkts[i],
+			(i % umem->num_frames) * umem->frame_size + offset, pkt_len);
 
 	test->ifobj_tx->pkt_stream = pkt_stream;
 	test->ifobj_rx->pkt_stream = pkt_stream;
 }
 
+static void pkt_stream_receive_half(struct test_spec *test)
+{
+	struct xsk_umem_info *umem = test->ifobj_rx->umem;
+	struct pkt_stream *pkt_stream = test->ifobj_tx->pkt_stream;
+	u32 i;
+
+	test->ifobj_rx->pkt_stream = pkt_stream_generate(umem, pkt_stream->nb_pkts,
+							 pkt_stream->pkts[0].len);
+	pkt_stream = test->ifobj_rx->pkt_stream;
+	for (i = 1; i < pkt_stream->nb_pkts; i += 2)
+		pkt_stream->pkts[i].valid = false;
+}
+
 static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 {
 	struct pkt *pkt = pkt_stream_get_pkt(ifobject->pkt_stream, pkt_nb);
@@ -795,11 +820,11 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 {
 	struct timeval tv_end, tv_now, tv_timeout = {RECV_TMOUT, 0};
+	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkts_sent = 0;
 	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
-	struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
 	struct xsk_socket_info *xsk = ifobj->xsk;
 	struct xsk_umem_info *umem = xsk->umem;
-	u32 idx_rx = 0, idx_fq = 0, rcvd, i;
+	struct pkt *pkt;
 	int ret;
 
 	ret = gettimeofday(&tv_now, NULL);
@@ -807,6 +832,7 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 		exit_with_error(errno);
 	timeradd(&tv_now, &tv_timeout, &tv_end);
 
+	pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &pkts_sent);
 	while (pkt) {
 		ret = gettimeofday(&tv_now, NULL);
 		if (ret)
@@ -828,30 +854,24 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 			continue;
 		}
 
-		ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
-		while (ret != rcvd) {
-			if (ret < 0)
-				exit_with_error(-ret);
-			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
-				ret = poll(fds, 1, POLL_TMOUT);
+		if (ifobj->use_fill_ring) {
+			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
+			while (ret != rcvd) {
 				if (ret < 0)
 					exit_with_error(-ret);
+				if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
+					ret = poll(fds, 1, POLL_TMOUT);
+					if (ret < 0)
+						exit_with_error(-ret);
+				}
+				ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 			}
-			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
 
 		for (i = 0; i < rcvd; i++) {
 			const struct xdp_desc *desc = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
 			u64 addr = desc->addr, orig;
 
-			if (!pkt) {
-				ksft_print_msg("[%s] Received too many packets.\n",
-					       __func__);
-				ksft_print_msg("Last packet has addr: %llx len: %u\n",
-					       addr, desc->len);
-				return TEST_FAILURE;
-			}
-
 			orig = xsk_umem__extract_addr(addr);
 			addr = xsk_umem__add_offset_to_addr(addr);
 
@@ -859,18 +879,22 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 			    !is_offset_correct(umem, pkt_stream, addr, pkt->addr))
 				return TEST_FAILURE;
 
-			*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
-			pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
+			if (ifobj->use_fill_ring)
+				*xsk_ring_prod__fill_addr(&umem->fq, idx_fq++) = orig;
+			pkt = pkt_stream_get_next_rx_pkt(pkt_stream, &pkts_sent);
 		}
 
-		xsk_ring_prod__submit(&umem->fq, rcvd);
-		xsk_ring_cons__release(&xsk->rx, rcvd);
+		if (ifobj->use_fill_ring)
+			xsk_ring_prod__submit(&umem->fq, rcvd);
+		if (ifobj->release_rx)
+			xsk_ring_cons__release(&xsk->rx, rcvd);
 
 		pthread_mutex_lock(&pacing_mutex);
-		pkts_in_flight -= rcvd;
+		pkts_in_flight -= pkts_sent;
 		if (pkts_in_flight < umem->num_frames)
 			pthread_cond_signal(&pacing_cond);
 		pthread_mutex_unlock(&pacing_mutex);
+		pkts_sent = 0;
 	}
 
 	return TEST_PASS;
@@ -900,7 +924,8 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
 
 	pthread_mutex_lock(&pacing_mutex);
 	pkts_in_flight += valid_pkts;
-	if (ifobject->pacing_on && pkts_in_flight >= ifobject->umem->num_frames - BATCH_SIZE) {
+	/* pkts_in_flight might be negative if many invalid packets are sent */
+	if (pkts_in_flight >= (int)(ifobject->umem->num_frames - BATCH_SIZE)) {
 		kick_tx(xsk);
 		pthread_cond_wait(&pacing_cond, &pacing_mutex);
 	}
@@ -987,34 +1012,29 @@ static int validate_rx_dropped(struct ifobject *ifobject)
 	if (err)
 		return TEST_FAILURE;
 
-	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts)
+	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2)
 		return TEST_PASS;
 
-	return TEST_CONTINUE;
+	return TEST_FAILURE;
 }
 
 static int validate_rx_full(struct ifobject *ifobject)
 {
 	struct xsk_socket *xsk = ifobject->xsk->xsk;
 	struct xdp_statistics stats;
-	u32 expected_stat;
 	int err;
 
+	usleep(1000);
 	kick_rx(ifobject->xsk);
 
 	err = get_xsk_stats(xsk, &stats);
 	if (err)
 		return TEST_FAILURE;
 
-	if (ifobject->umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
-		expected_stat = ifobject->umem->num_frames - RX_FULL_RXQSIZE;
-	else
-		expected_stat = XSK_RING_PROD__DEFAULT_NUM_DESCS - RX_FULL_RXQSIZE;
-
-	if (stats.rx_ring_full == expected_stat)
+	if (stats.rx_ring_full)
 		return TEST_PASS;
 
-	return TEST_CONTINUE;
+	return TEST_FAILURE;
 }
 
 static int validate_fill_empty(struct ifobject *ifobject)
@@ -1023,16 +1043,17 @@ static int validate_fill_empty(struct ifobject *ifobject)
 	struct xdp_statistics stats;
 	int err;
 
+	usleep(1000);
 	kick_rx(ifobject->xsk);
 
 	err = get_xsk_stats(xsk, &stats);
 	if (err)
 		return TEST_FAILURE;
 
-	if (stats.rx_fill_ring_empty_descs == ifobject->pkt_stream->nb_pkts)
+	if (stats.rx_fill_ring_empty_descs)
 		return TEST_PASS;
 
-	return TEST_CONTINUE;
+	return TEST_FAILURE;
 }
 
 static int validate_tx_invalid_descs(struct ifobject *ifobject)
@@ -1051,7 +1072,7 @@ static int validate_tx_invalid_descs(struct ifobject *ifobject)
 		return TEST_FAILURE;
 	}
 
-	if (stats.tx_invalid_descs != ifobject->pkt_stream->nb_pkts) {
+	if (stats.tx_invalid_descs != ifobject->pkt_stream->nb_pkts / 2) {
 		ksft_print_msg("[%s] tx_invalid_descs incorrect. Got [%u] expected [%u]\n",
 			       __func__, stats.tx_invalid_descs, ifobject->pkt_stream->nb_pkts);
 		return TEST_FAILURE;
@@ -1138,17 +1159,12 @@ static void *worker_testapp_validate_tx(void *arg)
 	print_verbose("Sending %d packets on interface %s\n", ifobject->pkt_stream->nb_pkts,
 		      ifobject->ifname);
 	err = send_pkts(test, ifobject);
-	if (err) {
-		report_failure(test);
-		goto out;
-	}
 
-	if (ifobject->validation_func) {
+	if (!err && ifobject->validation_func)
 		err = ifobject->validation_func(ifobject);
+	if (err)
 		report_failure(test);
-	}
 
-out:
 	if (test->total_steps == test->current_step || err)
 		testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
@@ -1202,14 +1218,10 @@ static void *worker_testapp_validate_rx(void *arg)
 
 	pthread_barrier_wait(&barr);
 
-	if (ifobject->validation_func) {
-		do {
-			err = ifobject->validation_func(ifobject);
-		} while (err == TEST_CONTINUE);
-	} else {
-		err = receive_pkts(ifobject, &fds);
-	}
+	err = receive_pkts(ifobject, &fds);
 
+	if (!err && ifobject->validation_func)
+		err = ifobject->validation_func(ifobject);
 	if (err) {
 		report_failure(test);
 		pthread_mutex_lock(&pacing_mutex);
@@ -1327,9 +1339,10 @@ static void testapp_headroom(struct test_spec *test)
 static void testapp_stats_rx_dropped(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_DROPPED");
-	test->ifobj_tx->pacing_on = false;
 	test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
-		XDP_PACKET_HEADROOM - 1;
+		XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 3;
+	pkt_stream_replace_half(test, MIN_PKT_SIZE * 4, 0);
+	pkt_stream_receive_half(test);
 	test->ifobj_rx->validation_func = validate_rx_dropped;
 	testapp_validate_traffic(test);
 }
@@ -1337,8 +1350,7 @@ static void testapp_stats_rx_dropped(struct test_spec *test)
 static void testapp_stats_tx_invalid_descs(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_TX_INVALID");
-	test->ifobj_tx->pacing_on = false;
-	pkt_stream_replace(test, DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
+	pkt_stream_replace_half(test, XSK_UMEM__INVALID_FRAME_SIZE, 0);
 	test->ifobj_tx->validation_func = validate_tx_invalid_descs;
 	testapp_validate_traffic(test);
 
@@ -1348,20 +1360,30 @@ static void testapp_stats_tx_invalid_descs(struct test_spec *test)
 static void testapp_stats_rx_full(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_FULL");
-	test->ifobj_tx->pacing_on = false;
-	test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
+	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, PKT_SIZE);
+	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
+							 DEFAULT_UMEM_BUFFERS, PKT_SIZE);
+	if (!test->ifobj_rx->pkt_stream)
+		exit_with_error(ENOMEM);
+
+	test->ifobj_rx->xsk->rxqsize = DEFAULT_UMEM_BUFFERS;
+	test->ifobj_rx->release_rx = false;
 	test->ifobj_rx->validation_func = validate_rx_full;
 	testapp_validate_traffic(test);
+
+	pkt_stream_restore_default(test);
 }
 
 static void testapp_stats_fill_empty(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
-	test->ifobj_tx->pacing_on = false;
-	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem, 0, MIN_PKT_SIZE);
+	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, PKT_SIZE);
+	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
+							 DEFAULT_UMEM_BUFFERS, PKT_SIZE);
 	if (!test->ifobj_rx->pkt_stream)
 		exit_with_error(ENOMEM);
-	test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
+
+	test->ifobj_rx->use_fill_ring = false;
 	test->ifobj_rx->validation_func = validate_fill_empty;
 	testapp_validate_traffic(test);
 
@@ -1504,7 +1526,7 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
 		test->ifobj_tx->umem->frame_size = 2048;
 		test->ifobj_rx->umem->frame_size = 2048;
-		pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
+		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
 		testapp_validate_traffic(test);
 
 		pkt_stream_restore_default(test);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index bf18a95be48c..8f672b0fe0e1 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -27,7 +27,6 @@
 
 #define TEST_PASS 0
 #define TEST_FAILURE -1
-#define TEST_CONTINUE -2
 #define MAX_INTERFACES 2
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
@@ -147,7 +146,8 @@ struct ifobject {
 	bool rx_on;
 	bool use_poll;
 	bool busy_poll;
-	bool pacing_on;
+	bool use_fill_ring;
+	bool release_rx;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
 };
@@ -167,6 +167,6 @@ pthread_barrier_t barr;
 pthread_mutex_t pacing_mutex = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t pacing_cond = PTHREAD_COND_INITIALIZER;
 
-u32 pkts_in_flight;
+int pkts_in_flight;
 
 #endif				/* XDPXCEIVER_H */
-- 
2.34.1

