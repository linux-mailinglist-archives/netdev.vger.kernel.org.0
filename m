Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6FA95A65C5
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiH3N5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiH3N5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:57:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27BAFE062;
        Tue, 30 Aug 2022 06:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867785; x=1693403785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H3+CjpdjlQe2ENG7rS7zHEMziq23DuEiUxhr2P7FboM=;
  b=AHs1AAC3klQu5IAG8wZXy0gZYG804gI1pIWnGjNaC5DVbsiObelqarGW
   Lro0buIG/tsanmkAeaZJ117eDbMvWhVXYxln+9/L/FEZw147HT1NC/btU
   gCWHsamO5zYQwDb3vFs1ssjQN1NSuXkTW2niyWFG4FzEGujuMulIeKa1d
   JVrtMgU2RqY1xqIaGJFHgjwGNonSe3dilVmpLdEArjiwl4Jte2/0Kgy6x
   TWl2zdoT5QWrqjcL9ekLK2E43bRj2xkIxW8p8XekSlWQAe20x4saMNnm4
   BLstd10Jv75CBDwbgpxNd8h+jNFOzRJzPFP1fUUW+xzAyask0jTZzVtLx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295180376"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295180376"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:56:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="562651312"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 06:56:23 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 2/6] selftests: xsk: introduce default Rx pkt stream
Date:   Tue, 30 Aug 2022 15:56:00 +0200
Message-Id: <20220830135604.10173-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prepare xskxceiver for physical device testing, let us
introduce default Rx pkt stream. Reason for doing it is that physical
device testing will use a UMEM with a doubled size where half of it will
be used by Tx and other half by Rx. This means that pkt addresses will
differ for Tx and Rx streams. Rx thread will initialize the
xsk_umem_info::base_addr that is added here so that pkt_set(), when
working on Rx UMEM will add this offset and second half of UMEM space
will be used. Note that currently base_addr is 0 on both sides. Future
commit will do the mentioned initialization.

Previously, veth based testing worked on separate UMEMs, so single
default stream was fine.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 74 +++++++++++++++---------
 tools/testing/selftests/bpf/xskxceiver.h |  4 +-
 2 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index d64652558d12..90d5691c0490 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -433,15 +433,16 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		ifobj->use_poll = false;
 		ifobj->use_fill_ring = true;
 		ifobj->release_rx = true;
-		ifobj->pkt_stream = test->pkt_stream_default;
 		ifobj->validation_func = NULL;
 
 		if (i == 0) {
 			ifobj->rx_on = false;
 			ifobj->tx_on = true;
+			ifobj->pkt_stream = test->tx_pkt_stream_default;
 		} else {
 			ifobj->rx_on = true;
 			ifobj->tx_on = false;
+			ifobj->pkt_stream = test->rx_pkt_stream_default;
 		}
 
 		memset(ifobj->umem, 0, sizeof(*ifobj->umem));
@@ -465,12 +466,15 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 			   struct ifobject *ifobj_rx, enum test_mode mode)
 {
-	struct pkt_stream *pkt_stream;
+	struct pkt_stream *tx_pkt_stream;
+	struct pkt_stream *rx_pkt_stream;
 	u32 i;
 
-	pkt_stream = test->pkt_stream_default;
+	tx_pkt_stream = test->tx_pkt_stream_default;
+	rx_pkt_stream = test->rx_pkt_stream_default;
 	memset(test, 0, sizeof(*test));
-	test->pkt_stream_default = pkt_stream;
+	test->tx_pkt_stream_default = tx_pkt_stream;
+	test->rx_pkt_stream_default = rx_pkt_stream;
 
 	for (i = 0; i < MAX_INTERFACES; i++) {
 		struct ifobject *ifobj = i ? ifobj_rx : ifobj_tx;
@@ -531,16 +535,17 @@ static void pkt_stream_delete(struct pkt_stream *pkt_stream)
 static void pkt_stream_restore_default(struct test_spec *test)
 {
 	struct pkt_stream *tx_pkt_stream = test->ifobj_tx->pkt_stream;
+	struct pkt_stream *rx_pkt_stream = test->ifobj_rx->pkt_stream;
 
-	if (tx_pkt_stream != test->pkt_stream_default) {
+	if (tx_pkt_stream != test->tx_pkt_stream_default) {
 		pkt_stream_delete(test->ifobj_tx->pkt_stream);
-		test->ifobj_tx->pkt_stream = test->pkt_stream_default;
+		test->ifobj_tx->pkt_stream = test->tx_pkt_stream_default;
 	}
 
-	if (test->ifobj_rx->pkt_stream != test->pkt_stream_default &&
-	    test->ifobj_rx->pkt_stream != tx_pkt_stream)
+	if (rx_pkt_stream != test->rx_pkt_stream_default) {
 		pkt_stream_delete(test->ifobj_rx->pkt_stream);
-	test->ifobj_rx->pkt_stream = test->pkt_stream_default;
+		test->ifobj_rx->pkt_stream = test->rx_pkt_stream_default;
+	}
 }
 
 static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
@@ -563,7 +568,7 @@ static struct pkt_stream *__pkt_stream_alloc(u32 nb_pkts)
 
 static void pkt_set(struct xsk_umem_info *umem, struct pkt *pkt, u64 addr, u32 len)
 {
-	pkt->addr = addr;
+	pkt->addr = addr + umem->base_addr;
 	pkt->len = len;
 	if (len > umem->frame_size - XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 2 - umem->frame_headroom)
 		pkt->valid = false;
@@ -602,22 +607,29 @@ static void pkt_stream_replace(struct test_spec *test, u32 nb_pkts, u32 pkt_len)
 
 	pkt_stream = pkt_stream_generate(test->ifobj_tx->umem, nb_pkts, pkt_len);
 	test->ifobj_tx->pkt_stream = pkt_stream;
+	pkt_stream = pkt_stream_generate(test->ifobj_rx->umem, nb_pkts, pkt_len);
 	test->ifobj_rx->pkt_stream = pkt_stream;
 }
 
-static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int offset)
+static void __pkt_stream_replace_half(struct ifobject *ifobj, u32 pkt_len,
+				      int offset)
 {
-	struct xsk_umem_info *umem = test->ifobj_tx->umem;
+	struct xsk_umem_info *umem = ifobj->umem;
 	struct pkt_stream *pkt_stream;
 	u32 i;
 
-	pkt_stream = pkt_stream_clone(umem, test->pkt_stream_default);
-	for (i = 1; i < test->pkt_stream_default->nb_pkts; i += 2)
+	pkt_stream = pkt_stream_clone(umem, ifobj->pkt_stream);
+	for (i = 1; i < ifobj->pkt_stream->nb_pkts; i += 2)
 		pkt_set(umem, &pkt_stream->pkts[i],
 			(i % umem->num_frames) * umem->frame_size + offset, pkt_len);
 
-	test->ifobj_tx->pkt_stream = pkt_stream;
-	test->ifobj_rx->pkt_stream = pkt_stream;
+	ifobj->pkt_stream = pkt_stream;
+}
+
+static void pkt_stream_replace_half(struct test_spec *test, u32 pkt_len, int offset)
+{
+	__pkt_stream_replace_half(test->ifobj_tx, pkt_len, offset);
+	__pkt_stream_replace_half(test->ifobj_rx, pkt_len, offset);
 }
 
 static void pkt_stream_receive_half(struct test_spec *test)
@@ -659,7 +671,8 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 	return pkt;
 }
 
-static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts, u32 nb_pkts)
+static void __pkt_stream_generate_custom(struct ifobject *ifobj,
+					 struct pkt *pkts, u32 nb_pkts)
 {
 	struct pkt_stream *pkt_stream;
 	u32 i;
@@ -668,15 +681,20 @@ static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts,
 	if (!pkt_stream)
 		exit_with_error(ENOMEM);
 
-	test->ifobj_tx->pkt_stream = pkt_stream;
-	test->ifobj_rx->pkt_stream = pkt_stream;
-
 	for (i = 0; i < nb_pkts; i++) {
-		pkt_stream->pkts[i].addr = pkts[i].addr;
+		pkt_stream->pkts[i].addr = pkts[i].addr + ifobj->umem->base_addr;
 		pkt_stream->pkts[i].len = pkts[i].len;
 		pkt_stream->pkts[i].payload = i;
 		pkt_stream->pkts[i].valid = pkts[i].valid;
 	}
+
+	ifobj->pkt_stream = pkt_stream;
+}
+
+static void pkt_stream_generate_custom(struct test_spec *test, struct pkt *pkts, u32 nb_pkts)
+{
+	__pkt_stream_generate_custom(test->ifobj_tx, pkts, nb_pkts);
+	__pkt_stream_generate_custom(test->ifobj_rx, pkts, nb_pkts);
 }
 
 static void pkt_dump(void *pkt, u32 len)
@@ -1749,7 +1767,8 @@ static bool is_xdp_supported(struct ifobject *ifobject)
 
 int main(int argc, char **argv)
 {
-	struct pkt_stream *pkt_stream_default;
+	struct pkt_stream *rx_pkt_stream_default;
+	struct pkt_stream *tx_pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
 	int modes = TEST_MODE_SKB + 1;
 	u32 i, j, failed_tests = 0;
@@ -1783,10 +1802,12 @@ int main(int argc, char **argv)
 		modes++;
 
 	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
-	pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
-	if (!pkt_stream_default)
+	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
+	rx_pkt_stream_default = pkt_stream_generate(ifobj_rx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
+	if (!tx_pkt_stream_default || !rx_pkt_stream_default)
 		exit_with_error(ENOMEM);
-	test.pkt_stream_default = pkt_stream_default;
+	test.tx_pkt_stream_default = tx_pkt_stream_default;
+	test.rx_pkt_stream_default = rx_pkt_stream_default;
 
 	ksft_set_plan(modes * TEST_TYPE_MAX);
 
@@ -1800,7 +1821,8 @@ int main(int argc, char **argv)
 				failed_tests++;
 		}
 
-	pkt_stream_delete(pkt_stream_default);
+	pkt_stream_delete(tx_pkt_stream_default);
+	pkt_stream_delete(rx_pkt_stream_default);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index ee97576757a9..8d1c31f127e7 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -99,6 +99,7 @@ struct xsk_umem_info {
 	u32 frame_headroom;
 	void *buffer;
 	u32 frame_size;
+	u32 base_addr;
 	bool unaligned_mode;
 };
 
@@ -159,7 +160,8 @@ struct ifobject {
 struct test_spec {
 	struct ifobject *ifobj_tx;
 	struct ifobject *ifobj_rx;
-	struct pkt_stream *pkt_stream_default;
+	struct pkt_stream *tx_pkt_stream_default;
+	struct pkt_stream *rx_pkt_stream_default;
 	u16 total_steps;
 	u16 current_step;
 	u16 nb_sockets;
-- 
2.34.1

