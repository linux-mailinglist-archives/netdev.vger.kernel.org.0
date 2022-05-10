Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1A521474
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241387AbiEJMB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241368AbiEJMBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:01:06 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52601BD712;
        Tue, 10 May 2022 04:56:59 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id b19so23453640wrh.11;
        Tue, 10 May 2022 04:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0NbQnsAHGSoodBL7RWkdZ9Gi+Iz4OOxKMu0gOxSm1YQ=;
        b=KGNf36sqI5V+RAnd+RDfrx+9rckUxGzQ1bETQBTWq81nWpcQFLhu9LRDNcjkW8/Bds
         2r+oNZxZ7/BYKwTsvycLsBG+6Qp3H7tARfB+ODHqJVpjHKWhNcLcNhvO1ZofaS1KqcDy
         cSYoFyICqkm72vPqTcEvb3aVrzNBw2Fs+t+bW8pRj0RPvNLQ9ORbh7HTnDHZLpzG7kce
         XAR6dL2kVIFcRbMwT8iHixZkZBsZHQSka+dskT0+gyZSH2UhBAmX85mharQaQJ0A37RL
         77RTmAdyn3T+E5yEWeFOnqmKfpmW3PRHFSZQXUCvRsy/VQxARu1diyR5XyUMC7e1bIEK
         ck1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0NbQnsAHGSoodBL7RWkdZ9Gi+Iz4OOxKMu0gOxSm1YQ=;
        b=gIt5xtAg8msYRazqms+TV2XQTxOjWBlgrtC/x6o3XqN3n0vucif4fMCJtECcYQGXDA
         al/RnkCK/HTAnpvphwQuQb0r+IMow26fu8gq5MIG+27sQMdZ/WDv8jtbtonlg3giFjTB
         aynoWLN4mjlEQPf1Q+BgiJ1BVcvzR0Lg4PgbxSRUe3O11N9WW5PTz/KEmO/xkt7N/i0P
         sUgD0WXXrEe8VLFXxGn1hZ0lXK8ldb8cSlIVtUppJe+bO49WMrBVKjaE28AJd9WBE+l6
         6GY1cRwsTuceXGNn4BztwgGeeT1+Idr6TBo6QDZq8iz/PNyHEIMRhhyAWxPktA8yB0UA
         HR0w==
X-Gm-Message-State: AOAM5303ZFX4yeQU+ROOvp7iLbj1n/l8rWzV1sJE8SUCcgSn67LKx8pl
        eeGsL/ikqlsh4ejfMD99fSQ=
X-Google-Smtp-Source: ABdhPJziefuhMPdZi/pHOK1g08t7m6QA8dbyDiKbcZdVE33yWQgesJtExTc28F5DcdjK/d3OyuRA6A==
X-Received: by 2002:a05:6000:1ac7:b0:20c:6c81:c8e5 with SMTP id i7-20020a0560001ac700b0020c6c81c8e5mr18832665wry.580.1652183819341;
        Tue, 10 May 2022 04:56:59 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:58 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 7/9] selftests: xsk: introduce validation functions
Date:   Tue, 10 May 2022 13:56:02 +0200
Message-Id: <20220510115604.8717-8-magnus.karlsson@gmail.com>
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

Introduce validation functions that can be optionally called by the Rx
and Tx threads. These are then used to replace the Rx and Tx stats
dispatchers. This so that we in the next commit can make the stats
tests proper normal tests and not be some special case, as today.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 117 +++++++++++++++--------
 tools/testing/selftests/bpf/xdpxceiver.h |   3 +
 2 files changed, 82 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index dc21951a1b0a..3eef29cacf94 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -426,6 +426,7 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		ifobj->use_poll = false;
 		ifobj->pacing_on = true;
 		ifobj->pkt_stream = test->pkt_stream_default;
+		ifobj->validation_func = NULL;
 
 		if (i == 0) {
 			ifobj->rx_on = false;
@@ -951,54 +952,90 @@ static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
 	return TEST_PASS;
 }
 
-static int rx_stats_validate(struct ifobject *ifobject)
+static int get_xsk_stats(struct xsk_socket *xsk, struct xdp_statistics *stats)
+{
+	int fd = xsk_socket__fd(xsk), err;
+	socklen_t optlen, expected_len;
+
+	optlen = sizeof(*stats);
+	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, stats, &optlen);
+	if (err) {
+		ksft_print_msg("[%s] getsockopt(XDP_STATISTICS) error %u %s\n",
+			       __func__, -err, strerror(-err));
+		return TEST_FAILURE;
+	}
+
+	expected_len = sizeof(struct xdp_statistics);
+	if (optlen != expected_len) {
+		ksft_print_msg("[%s] getsockopt optlen error. Expected: %u got: %u\n",
+			       __func__, expected_len, optlen);
+		return TEST_FAILURE;
+	}
+
+	return TEST_PASS;
+}
+
+static int validate_rx_dropped(struct ifobject *ifobject)
 {
-	u32 xsk_stat = 0, expected_stat = ifobject->pkt_stream->nb_pkts;
 	struct xsk_socket *xsk = ifobject->xsk->xsk;
-	int fd = xsk_socket__fd(xsk);
 	struct xdp_statistics stats;
-	socklen_t optlen;
 	int err;
 
 	kick_rx(ifobject->xsk);
 
-	optlen = sizeof(stats);
-	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
-	if (err) {
-		ksft_print_msg("[%s] getsockopt(XDP_STATISTICS) error %u %s\n",
-			       __func__, -err, strerror(-err));
+	err = get_xsk_stats(xsk, &stats);
+	if (err)
 		return TEST_FAILURE;
-	}
 
-	if (optlen == sizeof(struct xdp_statistics)) {
-		switch (stat_test_type) {
-		case STAT_TEST_RX_DROPPED:
-			xsk_stat = stats.rx_dropped;
-			break;
-		case STAT_TEST_TX_INVALID:
-			return true;
-		case STAT_TEST_RX_FULL:
-			xsk_stat = stats.rx_ring_full;
-			if (ifobject->umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
-				expected_stat = ifobject->umem->num_frames - RX_FULL_RXQSIZE;
-			else
-				expected_stat = XSK_RING_PROD__DEFAULT_NUM_DESCS - RX_FULL_RXQSIZE;
-			break;
-		case STAT_TEST_RX_FILL_EMPTY:
-			xsk_stat = stats.rx_fill_ring_empty_descs;
-			break;
-		default:
-			break;
-		}
+	if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts)
+		return TEST_PASS;
 
-		if (xsk_stat == expected_stat)
-			return TEST_PASS;
-	}
+	return TEST_CONTINUE;
+}
+
+static int validate_rx_full(struct ifobject *ifobject)
+{
+	struct xsk_socket *xsk = ifobject->xsk->xsk;
+	struct xdp_statistics stats;
+	u32 expected_stat;
+	int err;
+
+	kick_rx(ifobject->xsk);
+
+	err = get_xsk_stats(xsk, &stats);
+	if (err)
+		return TEST_FAILURE;
+
+	if (ifobject->umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
+		expected_stat = ifobject->umem->num_frames - RX_FULL_RXQSIZE;
+	else
+		expected_stat = XSK_RING_PROD__DEFAULT_NUM_DESCS - RX_FULL_RXQSIZE;
+
+	if (stats.rx_ring_full == expected_stat)
+		return TEST_PASS;
+
+	return TEST_CONTINUE;
+}
+
+static int validate_fill_empty(struct ifobject *ifobject)
+{
+	struct xsk_socket *xsk = ifobject->xsk->xsk;
+	struct xdp_statistics stats;
+	int err;
+
+	kick_rx(ifobject->xsk);
+
+	err = get_xsk_stats(xsk, &stats);
+	if (err)
+		return TEST_FAILURE;
+
+	if (stats.rx_fill_ring_empty_descs == ifobject->pkt_stream->nb_pkts)
+		return TEST_PASS;
 
 	return TEST_CONTINUE;
 }
 
-static int tx_stats_validate(struct ifobject *ifobject)
+static int validate_tx_invalid_descs(struct ifobject *ifobject)
 {
 	struct xsk_socket *xsk = ifobject->xsk->xsk;
 	int fd = xsk_socket__fd(xsk);
@@ -1106,8 +1143,8 @@ static void *worker_testapp_validate_tx(void *arg)
 		goto out;
 	}
 
-	if (stat_test_type == STAT_TEST_TX_INVALID) {
-		err = tx_stats_validate(ifobject);
+	if (ifobject->validation_func) {
+		err = ifobject->validation_func(ifobject);
 		report_failure(test);
 	}
 
@@ -1165,9 +1202,9 @@ static void *worker_testapp_validate_rx(void *arg)
 
 	pthread_barrier_wait(&barr);
 
-	if (test_type == TEST_TYPE_STATS) {
+	if (ifobject->validation_func) {
 		do {
-			err = rx_stats_validate(ifobject);
+			err = ifobject->validation_func(ifobject);
 		} while (err == TEST_CONTINUE);
 	} else {
 		err = receive_pkts(ifobject, &fds);
@@ -1302,16 +1339,19 @@ static void testapp_stats(struct test_spec *test)
 			test_spec_set_name(test, "STAT_RX_DROPPED");
 			test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
 				XDP_PACKET_HEADROOM - 1;
+			test->ifobj_rx->validation_func = validate_rx_dropped;
 			testapp_validate_traffic(test);
 			break;
 		case STAT_TEST_RX_FULL:
 			test_spec_set_name(test, "STAT_RX_FULL");
 			test->ifobj_rx->xsk->rxqsize = RX_FULL_RXQSIZE;
+			test->ifobj_rx->validation_func = validate_rx_full;
 			testapp_validate_traffic(test);
 			break;
 		case STAT_TEST_TX_INVALID:
 			test_spec_set_name(test, "STAT_TX_INVALID");
 			pkt_stream_replace(test, DEFAULT_PKT_CNT, XSK_UMEM__INVALID_FRAME_SIZE);
+			test->ifobj_tx->validation_func = validate_tx_invalid_descs;
 			testapp_validate_traffic(test);
 
 			pkt_stream_restore_default(test);
@@ -1323,6 +1363,7 @@ static void testapp_stats(struct test_spec *test)
 			if (!test->ifobj_rx->pkt_stream)
 				exit_with_error(ENOMEM);
 			test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
+			test->ifobj_rx->validation_func = validate_fill_empty;
 			testapp_validate_traffic(test);
 
 			pkt_stream_restore_default(test);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 79ba344d2765..f271c7b35a2c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -130,6 +130,8 @@ struct pkt_stream {
 	bool use_addr_for_fill;
 };
 
+struct ifobject;
+typedef int (*validation_func_t)(struct ifobject *ifobj);
 typedef void *(*thread_func_t)(void *arg);
 
 struct ifobject {
@@ -139,6 +141,7 @@ struct ifobject {
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
 	thread_func_t func_ptr;
+	validation_func_t validation_func;
 	struct pkt_stream *pkt_stream;
 	int ns_fd;
 	int xsk_map_fd;
-- 
2.34.1

