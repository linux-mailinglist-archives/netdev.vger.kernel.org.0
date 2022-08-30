Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51C85A6774
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiH3Pcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH3Pck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:32:40 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B620AB8A67;
        Tue, 30 Aug 2022 08:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661873559; x=1693409559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8UrC6dfbE1tCNABiEQzXKijmPHbOIJwMBaMF9WQYhwk=;
  b=b6Fk1dochJGV1vaxj/ys90oUNEO88huBXMQ9ZrkW+Tct7UeytCuoRPC3
   MH4yHXTCJW8rz7zU4aVqxOtDkk/RAKDV6P0G33QfuyBl6KiL9zDHZOT8c
   KxY+d4ocwMw3RvYLvk31L4fhjQjicwUaRjmwLu+Ro146HLWdd4YLZ3hHf
   2fneXsG3B6vrr6zPREEwgPlpTM+qXlEOOv7WMziyaDZQ7WZIUUaxHM5jh
   5Yzi6YUYHeYaEUw+Ix9GC/xd4ps5GSJCdx2k8NRhUlVCod19vw8XTdq4d
   rOLhwbFuvbIv+DuNHLM6wxkBGeTUdPezxRnVwp0xhr8i1KrmOUsc8W5ro
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="356923005"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="356923005"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 08:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="644871183"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 30 Aug 2022 08:32:36 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 2672D41; Tue, 30 Aug 2022 18:32:51 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: [PATCH 1/5] net: thunderbolt: Enable DMA paths only after rings are enabled
Date:   Tue, 30 Aug 2022 18:32:46 +0300
Message-Id: <20220830153250.15496-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
References: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the other host starts sending packets early on it is possible that we
are still in the middle of populating the initial Rx ring packets to the
ring. This causes the tbnet_poll() to mess over the queue and causes
list corruption. This happens specifically when connected with macOS as
it seems start sending various IP discovery packets as soon as its side
of the paths are configured.

To prevent this we move the DMA path enabling to happen after we have
primed the Rx ring. This makes sure no incoming packets can arrive
before we are ready to handle them.

Fixes: e69b6c02b4c3 ("net: Add support for networking over Thunderbolt cable")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ff5d0e98a088..ab3f04562980 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -612,18 +612,13 @@ static void tbnet_connected_work(struct work_struct *work)
 		return;
 	}
 
-	/* Both logins successful so enable the high-speed DMA paths and
-	 * start the network device queue.
+	/* Both logins successful so enable the rings, high-speed DMA
+	 * paths and start the network device queue.
+	 *
+	 * Note we enable the DMA paths last to make sure we have primed
+	 * the Rx ring before any incoming packets are allowed to
+	 * arrive.
 	 */
-	ret = tb_xdomain_enable_paths(net->xd, net->local_transmit_path,
-				      net->rx_ring.ring->hop,
-				      net->remote_transmit_path,
-				      net->tx_ring.ring->hop);
-	if (ret) {
-		netdev_err(net->dev, "failed to enable DMA paths\n");
-		return;
-	}
-
 	tb_ring_start(net->tx_ring.ring);
 	tb_ring_start(net->rx_ring.ring);
 
@@ -635,10 +630,21 @@ static void tbnet_connected_work(struct work_struct *work)
 	if (ret)
 		goto err_free_rx_buffers;
 
+	ret = tb_xdomain_enable_paths(net->xd, net->local_transmit_path,
+				      net->rx_ring.ring->hop,
+				      net->remote_transmit_path,
+				      net->tx_ring.ring->hop);
+	if (ret) {
+		netdev_err(net->dev, "failed to enable DMA paths\n");
+		goto err_free_tx_buffers;
+	}
+
 	netif_carrier_on(net->dev);
 	netif_start_queue(net->dev);
 	return;
 
+err_free_tx_buffers:
+	tbnet_free_buffers(&net->tx_ring);
 err_free_rx_buffers:
 	tbnet_free_buffers(&net->rx_ring);
 err_stop_rings:
-- 
2.35.1

