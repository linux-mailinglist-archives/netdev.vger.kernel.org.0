Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFB548F09A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 20:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbiANTp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 14:45:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237113AbiANTpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 14:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642189525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cv6sltPUkJtlMZoFEjr9r3hY/JFy9Ol9gLxXn9Aa8qw=;
        b=FPuuN+xy8TnSCjULo/KyvWgW5r2P4+ETnw3LB4Hg4PJQmBhKftOJUCShtoox96YKVrOfs9
        wkegzWHBXE15m/jPpr18LYhPFfmFvKKgvTBfuiBNorecJ1dAMEheX1u+DhaA4LEFI3kQ7x
        u4RvGnq+NBUPyGDfzkJm2bwL17xyFzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-f6MhAsJVOS2CFhD8RS4fBg-1; Fri, 14 Jan 2022 14:45:23 -0500
X-MC-Unique: f6MhAsJVOS2CFhD8RS4fBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3723F92500;
        Fri, 14 Jan 2022 19:45:22 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03E8460FDD;
        Fri, 14 Jan 2022 19:45:22 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 8ED5AA81472; Fri, 14 Jan 2022 20:45:20 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 2/2 net-next v4] igb: refactor XDP registration
Date:   Fri, 14 Jan 2022 20:45:20 +0100
Message-Id: <20220114194520.1092894-3-vinschen@redhat.com>
In-Reply-To: <20220114194520.1092894-1-vinschen@redhat.com>
References: <20220114194520.1092894-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On changing the RX ring parameters igb uses a hack to avoid a warning
when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
clears the struct xdp_rxq_info content.

Change this to unregister if we're already registered instead.  Align
code to the igc code.

Fixes: 9cbc948b5a20c ("igb: add XDP support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 12 +++++++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 51a2dcaf553d..2a5782063f4c 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -965,10 +965,6 @@ static int igb_set_ringparam(struct net_device *netdev,
 			memcpy(&temp_ring[i], adapter->rx_ring[i],
 			       sizeof(struct igb_ring));
 
-			/* Clear copied XDP RX-queue info */
-			memset(&temp_ring[i].xdp_rxq, 0,
-			       sizeof(temp_ring[i].xdp_rxq));
-
 			temp_ring[i].count = new_rx_count;
 			err = igb_setup_rx_resources(&temp_ring[i]);
 			if (err) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 38ba92022cd4..cea89d301bfd 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4352,7 +4352,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 {
 	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
 	struct device *dev = rx_ring->dev;
-	int size;
+	int size, res;
 
 	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
 
@@ -4376,9 +4376,15 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 	rx_ring->xdp_prog = adapter->xdp_prog;
 
 	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			     rx_ring->queue_index, 0) < 0)
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+			       rx_ring->queue_index, 0);
+	if (res < 0) {
+		dev_err(dev, "Failed to register xdp_rxq index %u\n",
+			rx_ring->queue_index);
 		goto err;
+	}
 
 	return 0;
 
-- 
2.27.0

