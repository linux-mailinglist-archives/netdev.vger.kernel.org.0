Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B763E54E920
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377502AbiFPSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377257AbiFPSGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:06:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DB94F478;
        Thu, 16 Jun 2022 11:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655402803; x=1686938803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yoJU0XWCvXr4uzbVKv2qENxyjofzoZ6PyeDkjXXPL+I=;
  b=flws9H0GL2ni6+7YRVkjnFv1R5EmkGt1I7yAmcXvpblqWlNcfvRbGXsB
   C0AQaz1Mx4lia0H8rDUr3hdf8efTH4n0V9OhBrhOcWu2xKPx1kuuwLANj
   Ox5r7lMduS4+xNYJ+BG6PYcl7WoHOL9G74bBRCSS+rw1Kc/X4JbolMrmg
   wuRNAURHfRon+i3a43LsnT4WK0/cCPGa0dynWepPFJZP8VDePrzIkS366
   cbyqaPq7H0+MoZ18lpqJK17Eibptfjo60AgOP7T3/8gEiFVuIqK7Exgqv
   SaND0ns995JBj+3J4BEKRXNxSft04w4YEfnPth2IUsJ9RqxwEZq4f3bro
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343275970"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="343275970"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 11:06:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641664413"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jun 2022 11:06:40 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 10/10] selftests: xsk: add support for zero copy testing
Date:   Thu, 16 Jun 2022 20:06:09 +0200
Message-Id: <20220616180609.905015-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 76 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 13a3b2ac2399..98177ae01e54 100644
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
 
@@ -1557,6 +1618,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
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
@@ -1735,8 +1800,11 @@ int main(int argc, char **argv)
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
index f364a92675f8..4e552eb852b9 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -61,6 +61,7 @@
 enum test_mode {
 	TEST_MODE_SKB,
 	TEST_MODE_DRV,
+	TEST_MODE_ZC,
 	TEST_MODE_MAX
 };
 
@@ -163,6 +164,7 @@ struct test_spec {
 	u16 current_step;
 	u16 nb_sockets;
 	bool fail;
+	enum test_mode mode;
 	char name[MAX_TEST_NAME_SIZE];
 };
 
-- 
2.27.0

