Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E76414311
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbhIVH6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhIVH6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EF0C0613D9;
        Wed, 22 Sep 2021 00:56:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u18so4135194wrg.5;
        Wed, 22 Sep 2021 00:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N8P5TsrKa5fKsa9esmtHOEyefOPkA8rjZDUUJkReKLQ=;
        b=k2hvLXZogT6OLWQJ+GqmVeM1gvG/wj343Tsyhi00hAjSm8fJ1v6V+YeKmiFyKbcA1d
         wnaMWJqB74yEPkI5zIPF4X7wRL6HWglv2VUznLg3FyfnElR2g9sjlddQkxzi8emDVCqJ
         L85Ze1s022Lip9p0BUWFR4S9OJEyLZqkmDbu6JnUCX5PY0M4UGvguQOZ69rh6083JV/n
         2GDwA1ElWuatuyEOeqL4ykkmS+OdPIPgrNE/aRv63HzcN4dsJJV49d5mBrXY0YgdrsQJ
         jk8Lxf3hXDuJXViDm7e7pGfUgoHI5QHDPGJcCzP7uelCQeTrGaysKBC7J8NRvDBIjPYl
         bO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N8P5TsrKa5fKsa9esmtHOEyefOPkA8rjZDUUJkReKLQ=;
        b=XiK8ut2wm1OOQ3Z1jwRR9SvzGh8FCbgRnx0yunr3U6UCYYaneXiPrUQYeLnHG2XELH
         hPYpUad937CDmLrXWjR0pn5015t5kDFmEYJdcNT+NTX8/fWFyi/Nneku/I9cu2Oy31mY
         mH68WFYy4rGdB/Bva4EFNqKryf6KQo1/Jj/Z5bCuzIFp9+kbTtf6eprFmfh29Que5XY3
         WDjlAO0oNj2umsxL4VRJA31ol3nGBPkEaogEBvXMNrmF4fvaXMAyJP+IOzJMB7C/5WCP
         lWxqMJW20qzwtTh84PcCnBxUMcBYBhTQu/q6V2Cywxfv8/svmq2N1E+h1/DjuMEyubZp
         VNqw==
X-Gm-Message-State: AOAM5321DZC33iqVR2BRuGVzHYYKvCEJyJNGy6o+uenaPJktTqvn+ABI
        xeSUEtgoUy7T84z+slmVsLiT71slkOAYAfVW
X-Google-Smtp-Source: ABdhPJwTLZfi22224IECGQ8mf9z+HXjs4kJQfyvKK4FZNIXbo6+U3GJEzchnsyWFlaar+VoM8pstkg==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr39368603wrx.177.1632297415828;
        Wed, 22 Sep 2021 00:56:55 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:55 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 10/13] selftests: xsk: introduce pacing of traffic
Date:   Wed, 22 Sep 2021 09:56:10 +0200
Message-Id: <20210922075613.12186-11-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce pacing of traffic so that the Tx thread can never send more
packets than the receiver has processed plus the number of packets it
can have in its umem. So at any point in time, the number of in flight
packets (not processed by the Rx thread) are less than or equal to the
number of packets that can be held in the Rx thread's umem.

The batch size is also increased to improve running time.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 29 +++++++++++++++++++-----
 tools/testing/selftests/bpf/xdpxceiver.h |  7 +++++-
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index aa5660dc0699..597fbe206026 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -384,6 +384,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		ifobj->umem = &ifobj->umem_arr[0];
 		ifobj->xsk = &ifobj->xsk_arr[0];
 		ifobj->use_poll = false;
+		ifobj->pacing_on = true;
 		ifobj->pkt_stream = test->pkt_stream_default;
 
 		if (i == 0) {
@@ -724,6 +725,7 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 {
 	struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
 	u32 idx_rx = 0, idx_fq = 0, rcvd, i;
+	u32 total = 0;
 	int ret;
 
 	while (pkt) {
@@ -772,6 +774,13 @@ static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *
 
 		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
 		xsk_ring_cons__release(&xsk->rx, rcvd);
+
+		pthread_mutex_lock(&pacing_mutex);
+		pkts_in_flight -= rcvd;
+		total += rcvd;
+		if (pkts_in_flight < umem->num_frames)
+			pthread_cond_signal(&pacing_cond);
+		pthread_mutex_unlock(&pacing_mutex);
 	}
 }
 
@@ -797,10 +806,19 @@ static u32 __send_pkts(struct ifobject *ifobject, u32 pkt_nb)
 			valid_pkts++;
 	}
 
+	pthread_mutex_lock(&pacing_mutex);
+	pkts_in_flight += valid_pkts;
+	if (ifobject->pacing_on && pkts_in_flight >= ifobject->umem->num_frames - BATCH_SIZE) {
+		kick_tx(xsk);
+		pthread_cond_wait(&pacing_cond, &pacing_mutex);
+	}
+	pthread_mutex_unlock(&pacing_mutex);
+
 	xsk_ring_prod__submit(&xsk->tx, i);
 	xsk->outstanding_tx += valid_pkts;
-	complete_pkts(xsk, BATCH_SIZE);
+	complete_pkts(xsk, i);
 
+	usleep(10);
 	return i;
 }
 
@@ -819,8 +837,6 @@ static void send_pkts(struct ifobject *ifobject)
 	fds.events = POLLOUT;
 
 	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
-		u32 sent;
-
 		if (ifobject->use_poll) {
 			int ret;
 
@@ -832,9 +848,7 @@ static void send_pkts(struct ifobject *ifobject)
 				continue;
 		}
 
-		sent = __send_pkts(ifobject, pkt_cnt);
-		pkt_cnt += sent;
-		usleep(10);
+		pkt_cnt += __send_pkts(ifobject, pkt_cnt);
 	}
 
 	wait_for_tx_completion(ifobject->xsk);
@@ -1043,6 +1057,7 @@ static void testapp_validate_traffic(struct test_spec *test)
 
 	test->current_step++;
 	pkt_stream_reset(ifobj_rx->pkt_stream);
+	pkts_in_flight = 0;
 
 	/*Spawn RX thread */
 	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
@@ -1126,6 +1141,8 @@ static void testapp_stats(struct test_spec *test)
 	for (i = 0; i < STAT_TEST_TYPE_MAX; i++) {
 		test_spec_reset(test);
 		stat_test_type = i;
+		/* No or few packets will be received so cannot pace packets */
+		test->ifobj_tx->pacing_on = false;
 
 		switch (stat_test_type) {
 		case STAT_TEST_RX_DROPPED:
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 5ac4a5e64744..00790c976f4f 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -35,7 +35,7 @@
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
-#define BATCH_SIZE 8
+#define BATCH_SIZE 64
 #define POLL_TMOUT 1000
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
@@ -136,6 +136,7 @@ struct ifobject {
 	bool tx_on;
 	bool rx_on;
 	bool use_poll;
+	bool pacing_on;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
 };
@@ -151,5 +152,9 @@ struct test_spec {
 };
 
 pthread_barrier_t barr;
+pthread_mutex_t pacing_mutex = PTHREAD_MUTEX_INITIALIZER;
+pthread_cond_t pacing_cond = PTHREAD_COND_INITIALIZER;
+
+u32 pkts_in_flight;
 
 #endif				/* XDPXCEIVER_H */
-- 
2.29.0

