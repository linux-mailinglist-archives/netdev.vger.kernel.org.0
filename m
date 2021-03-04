Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA3732D34B
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240984AbhCDMfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:35:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:37600 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241001AbhCDMei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:34:38 -0500
IronPort-SDR: P4kUpiV+7I4SoaBiOnsotBaQn+tqt4tnT4AIVSqVX/6QpdvJeo6QBrOR23v1H1nb2u8Gj5fw8P
 LVYnP5noZJYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="207113165"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="207113165"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:34 -0800
IronPort-SDR: +3I0QyypeCV7zhAfr/KVUo5nVfl2jzuvP903v3uhyovntpagFZVjYZJaCaR63Km/JOIj3WDbPH
 dxjw1Gt/O0jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="374534706"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 04 Mar 2021 04:31:32 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id D41C860B; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 16/18] thunderbolt: Add KUnit tests for DMA tunnels
Date:   Thu,  4 Mar 2021 15:31:23 +0300
Message-Id: <20210304123125.43630-17-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a couple of tests to check DMA tunneling functionality.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/test.c | 240 +++++++++++++++++++++++++++++++++++++
 1 file changed, 240 insertions(+)

diff --git a/drivers/thunderbolt/test.c b/drivers/thunderbolt/test.c
index 4e1e7ae2d90d..5ff5a03bc9ce 100644
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -119,6 +119,7 @@ static struct tb_switch *alloc_host(struct kunit *test)
 	sw->ports[7].config.type = TB_TYPE_NHI;
 	sw->ports[7].config.max_in_hop_id = 11;
 	sw->ports[7].config.max_out_hop_id = 11;
+	sw->ports[7].config.nfc_credits = 0x41800000;
 
 	sw->ports[8].config.type = TB_TYPE_PCIE_DOWN;
 	sw->ports[8].config.max_in_hop_id = 8;
@@ -1594,6 +1595,240 @@ static void tb_test_tunnel_port_on_path(struct kunit *test)
 	tb_tunnel_free(dp_tunnel);
 }
 
+static void tb_test_tunnel_dma(struct kunit *test)
+{
+	struct tb_port *nhi, *port;
+	struct tb_tunnel *tunnel;
+	struct tb_switch *host;
+
+	/*
+	 * Create DMA tunnel from NHI to port 1 and back.
+	 *
+	 *   [Host 1]
+	 *    1 ^ In HopID 1 -> Out HopID 8
+	 *      |
+	 *      v In HopID 8 -> Out HopID 1
+	 * ............ Domain border
+	 *      |
+	 *   [Host 2]
+	 */
+	host = alloc_host(test);
+	nhi = &host->ports[7];
+	port = &host->ports[1];
+
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, 8, 1, 8, 1);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+	KUNIT_EXPECT_EQ(test, tunnel->type, (enum tb_tunnel_type)TB_TUNNEL_DMA);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, nhi);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->dst_port, port);
+	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)2);
+	/* RX path */
+	KUNIT_ASSERT_EQ(test, tunnel->paths[0]->path_length, 1);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].in_port, port);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].in_hop_index, 8);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].out_port, nhi);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].next_hop_index, 1);
+	/* TX path */
+	KUNIT_ASSERT_EQ(test, tunnel->paths[1]->path_length, 1);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[0].in_port, nhi);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[1]->hops[0].in_hop_index, 1);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[0].out_port, port);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[1]->hops[0].next_hop_index, 8);
+
+	tb_tunnel_free(tunnel);
+}
+
+static void tb_test_tunnel_dma_rx(struct kunit *test)
+{
+	struct tb_port *nhi, *port;
+	struct tb_tunnel *tunnel;
+	struct tb_switch *host;
+
+	/*
+	 * Create DMA RX tunnel from port 1 to NHI.
+	 *
+	 *   [Host 1]
+	 *    1 ^
+	 *      |
+	 *      | In HopID 15 -> Out HopID 2
+	 * ............ Domain border
+	 *      |
+	 *   [Host 2]
+	 */
+	host = alloc_host(test);
+	nhi = &host->ports[7];
+	port = &host->ports[1];
+
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, -1, -1, 15, 2);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+	KUNIT_EXPECT_EQ(test, tunnel->type, (enum tb_tunnel_type)TB_TUNNEL_DMA);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, nhi);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->dst_port, port);
+	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)1);
+	/* RX path */
+	KUNIT_ASSERT_EQ(test, tunnel->paths[0]->path_length, 1);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].in_port, port);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].in_hop_index, 15);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].out_port, nhi);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].next_hop_index, 2);
+
+	tb_tunnel_free(tunnel);
+}
+
+static void tb_test_tunnel_dma_tx(struct kunit *test)
+{
+	struct tb_port *nhi, *port;
+	struct tb_tunnel *tunnel;
+	struct tb_switch *host;
+
+	/*
+	 * Create DMA TX tunnel from NHI to port 1.
+	 *
+	 *   [Host 1]
+	 *    1 | In HopID 2 -> Out HopID 15
+	 *      |
+	 *      v
+	 * ............ Domain border
+	 *      |
+	 *   [Host 2]
+	 */
+	host = alloc_host(test);
+	nhi = &host->ports[7];
+	port = &host->ports[1];
+
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, 15, 2, -1, -1);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+	KUNIT_EXPECT_EQ(test, tunnel->type, (enum tb_tunnel_type)TB_TUNNEL_DMA);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, nhi);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->dst_port, port);
+	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)1);
+	/* TX path */
+	KUNIT_ASSERT_EQ(test, tunnel->paths[0]->path_length, 1);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].in_port, nhi);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].in_hop_index, 2);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].out_port, port);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].next_hop_index, 15);
+
+	tb_tunnel_free(tunnel);
+}
+
+static void tb_test_tunnel_dma_chain(struct kunit *test)
+{
+	struct tb_switch *host, *dev1, *dev2;
+	struct tb_port *nhi, *port;
+	struct tb_tunnel *tunnel;
+
+	/*
+	 * Create DMA tunnel from NHI to Device #2 port 3 and back.
+	 *
+	 *   [Host 1]
+	 *    1 ^ In HopID 1 -> Out HopID x
+	 *      |
+	 *    1 | In HopID x -> Out HopID 1
+	 *  [Device #1]
+	 *         7 \
+	 *          1 \
+	 *         [Device #2]
+	 *           3 | In HopID x -> Out HopID 8
+	 *             |
+	 *             v In HopID 8 -> Out HopID x
+	 * ............ Domain border
+	 *             |
+	 *          [Host 2]
+	 */
+	host = alloc_host(test);
+	dev1 = alloc_dev_default(test, host, 0x1, true);
+	dev2 = alloc_dev_default(test, dev1, 0x701, true);
+
+	nhi = &host->ports[7];
+	port = &dev2->ports[3];
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, 8, 1, 8, 1);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+	KUNIT_EXPECT_EQ(test, tunnel->type, (enum tb_tunnel_type)TB_TUNNEL_DMA);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, nhi);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->dst_port, port);
+	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)2);
+	/* RX path */
+	KUNIT_ASSERT_EQ(test, tunnel->paths[0]->path_length, 3);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].in_port, port);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[0].in_hop_index, 8);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[0].out_port,
+			    &dev2->ports[1]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[1].in_port,
+			    &dev1->ports[7]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[1].out_port,
+			    &dev1->ports[1]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[2].in_port,
+			    &host->ports[1]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[0]->hops[2].out_port, nhi);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[0]->hops[2].next_hop_index, 1);
+	/* TX path */
+	KUNIT_ASSERT_EQ(test, tunnel->paths[1]->path_length, 3);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[0].in_port, nhi);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[1]->hops[0].in_hop_index, 1);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[1].in_port,
+			    &dev1->ports[1]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[1].out_port,
+			    &dev1->ports[7]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[2].in_port,
+			    &dev2->ports[1]);
+	KUNIT_EXPECT_PTR_EQ(test, tunnel->paths[1]->hops[2].out_port, port);
+	KUNIT_EXPECT_EQ(test, tunnel->paths[1]->hops[2].next_hop_index, 8);
+
+	tb_tunnel_free(tunnel);
+}
+
+static void tb_test_tunnel_dma_match(struct kunit *test)
+{
+	struct tb_port *nhi, *port;
+	struct tb_tunnel *tunnel;
+	struct tb_switch *host;
+
+	host = alloc_host(test);
+	nhi = &host->ports[7];
+	port = &host->ports[1];
+
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, 15, 1, 15, 1);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, 15, 1, 15, 1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, 8, 1, 15, 1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, 15, 1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, 15, 1, -1, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, 15, -1, -1, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, 1, -1, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, 15, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, -1, 1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, -1, -1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, 8, -1, 8, -1));
+
+	tb_tunnel_free(tunnel);
+
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, 15, 1, -1, -1);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, 15, 1, -1, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, 15, -1, -1, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, 1, -1, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, -1, -1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, 15, 1, 15, 1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, -1, -1, 15, 1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, 15, 11, -1, -1));
+
+	tb_tunnel_free(tunnel);
+
+	tunnel = tb_tunnel_alloc_dma(NULL, nhi, port, -1, -1, 15, 11);
+	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, 15, 11));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, 15, -1));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, -1, 11));
+	KUNIT_ASSERT_TRUE(test, tb_tunnel_match_dma(tunnel, -1, -1, -1, -1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, -1, -1, 15, 1));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, -1, -1, 10, 11));
+	KUNIT_ASSERT_FALSE(test, tb_tunnel_match_dma(tunnel, 15, 11, -1, -1));
+
+	tb_tunnel_free(tunnel);
+}
+
 static const u32 root_directory[] = {
 	0x55584401,	/* "UXD" v1 */
 	0x00000018,	/* Root directory length */
@@ -1865,6 +2100,11 @@ static struct kunit_case tb_test_cases[] = {
 	KUNIT_CASE(tb_test_tunnel_dp_max_length),
 	KUNIT_CASE(tb_test_tunnel_port_on_path),
 	KUNIT_CASE(tb_test_tunnel_usb3),
+	KUNIT_CASE(tb_test_tunnel_dma),
+	KUNIT_CASE(tb_test_tunnel_dma_rx),
+	KUNIT_CASE(tb_test_tunnel_dma_tx),
+	KUNIT_CASE(tb_test_tunnel_dma_chain),
+	KUNIT_CASE(tb_test_tunnel_dma_match),
 	KUNIT_CASE(tb_test_property_parse),
 	KUNIT_CASE(tb_test_property_format),
 	KUNIT_CASE(tb_test_property_copy),
-- 
2.30.1

