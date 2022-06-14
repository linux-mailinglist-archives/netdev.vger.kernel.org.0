Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292E554B7FC
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345048AbiFNRsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344154AbiFNRsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:48:17 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D98331524;
        Tue, 14 Jun 2022 10:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655228896; x=1686764896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PcAqMrcRi8l2EuPHJhjKJIGR3L8Ij8N8UzWdZcRFr60=;
  b=TQB2f85iUGlzbKcw4HofjEtL8K4ikX9ZHg+yBfZe59XweyWLp1aImw7Y
   Orsa6yUPP39N+19OFR82qeLC2yyaEi+j1KfripjUQpjFJG2/+a7pnXOmy
   M6/hAH3rRUzLNKuGMOfG89V9zCWQbEJDC0+f1uzI7CQnwhy/qwjdjT4AV
   qAVVUz5SNXxBW42IDD1adLEM4/81QKy798VgBcZroMzRULR2uzE+DPfbm
   CRxrFb/dqRfRYvMtpvpL/f6E176EbgYOp5QA/NVojmYRotbESnu2iAkUL
   5+iNgGJyMoMNtf4F1KkvLum5H11KRNH9Af4IsX6zJZFGWLfM85s3JqJzo
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340356848"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340356848"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 10:48:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="570110160"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 14 Jun 2022 10:48:12 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 10/10] selftests: xsk: add support for zero copy testing
Date:   Tue, 14 Jun 2022 19:47:49 +0200
Message-Id: <20220614174749.901044-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce new mode to xdpxceiver responsible for testing AF_XDP zero
copy support of driver that serves underlying physical device. When
setting up test suite, determine whether driver has ZC support or not by
trying to bind XSK ZC socket to the interface. If it succeeded,
interpret it as ZC support being in place and do softirq and busy poll
tests for zero copy mode.

Note that Rx dropped tests are skipped since ZC path is not touching
rx_dropped stat at all.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 76 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index ade9d87e7a7c..66bfb365b656 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -124,9 +124,20 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 }
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
-
-#define mode_string(test) (test)->ifobj_tx->xdp_flags & XDP_FLAGS_SKB_MODE ? "SKB" : "DRV"
 #define busy_poll_string(test) (test)->ifobj_tx->busy_poll ? "BUSY-POLL " : ""
+static char *mode_string(struct test_spec *test)
+{
+	switch (test->mode) {
+	case TEST_MODE_SKB:
+		return "SKB";
+	case TEST_MODE_DRV:
+		return "DRV";
+	case TEST_MODE_ZC:
+		return "ZC";
+	default:
+		return "BOGUS";
+	}
+}
 
 static void report_failure(struct test_spec *test)
 {
@@ -317,6 +328,51 @@ static int __xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_i
 	return xsk_socket__create(&xsk->xsk, ifobject->ifname, 0, umem->umem, rxr, txr, &cfg);
 }
 
+static bool ifobj_zc_avail(struct ifobject *ifobject)
+{
+	size_t umem_sz = DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+	struct xsk_socket_info *xsk;
+	struct xsk_umem_info *umem;
+	bool zc_avail = false;
+	void *bufs;
+	int ret;
+
+	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
+	if (bufs == MAP_FAILED)
+		exit_with_error(errno);
+
+	umem = calloc(1, sizeof(struct xsk_umem_info));
+	if (!umem) {
+		munmap(bufs, umem_sz);
+		exit_with_error(-ENOMEM);
+	}
+	umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
+	ret = xsk_configure_umem(umem, bufs, umem_sz);
+	if (ret)
+		exit_with_error(-ret);
+
+	xsk = calloc(1, sizeof(struct xsk_socket_info));
+	if (!xsk)
+		goto out;
+	ifobject->xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+	ifobject->xdp_flags |= XDP_FLAGS_DRV_MODE;
+	ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
+	ifobject->rx_on = true;
+	xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
+	ret = __xsk_configure_socket(xsk, umem, ifobject, false);
+	if (!ret)
+		zc_avail = true;
+
+	xsk_socket__delete(xsk->xsk);
+	free(xsk);
+out:
+	munmap(umem->buffer, umem_sz);
+	xsk_umem__delete(umem->umem);
+	free(umem);
+	return zc_avail;
+}
+
 static struct option long_options[] = {
 	{"interface", required_argument, 0, 'i'},
 	{"busy-poll", no_argument, 0, 'b'},
@@ -483,9 +539,14 @@ static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		else
 			ifobj->xdp_flags |= XDP_FLAGS_DRV_MODE;
 
-		ifobj->bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
+		ifobj->bind_flags = XDP_USE_NEED_WAKEUP;
+		if (mode == TEST_MODE_ZC)
+			ifobj->bind_flags |= XDP_ZEROCOPY;
+		else
+			ifobj->bind_flags |= XDP_COPY;
 	}
 
+	test->mode = mode;
 	__test_spec_init(test, ifobj_tx, ifobj_rx);
 }
 
@@ -1543,6 +1604,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 {
 	switch (type) {
 	case TEST_TYPE_STATS_RX_DROPPED:
+		if (mode == TEST_MODE_ZC) {
+			ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
+			return;
+		}
 		testapp_stats_rx_dropped(test);
 		break;
 	case TEST_TYPE_STATS_TX_INVALID_DESCS:
@@ -1721,8 +1786,11 @@ int main(int argc, char **argv)
 	init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
 		   worker_testapp_validate_rx);
 
-	if (is_xdp_supported(ifobj_tx))
+	if (is_xdp_supported(ifobj_tx)) {
 		modes++;
+		if (ifobj_zc_avail(ifobj_tx))
+			modes++;
+	}
 
 	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
 	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 12b792004163..a86331c6b0c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -61,6 +61,7 @@
 enum test_mode {
 	TEST_MODE_SKB,
 	TEST_MODE_DRV,
+	TEST_MODE_ZC,
 	TEST_MODE_MAX
 };
 
@@ -162,6 +163,7 @@ struct test_spec {
 	u16 current_step;
 	u16 nb_sockets;
 	bool fail;
+	enum test_mode mode;
 	char name[MAX_TEST_NAME_SIZE];
 };
 
-- 
2.27.0

