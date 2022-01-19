Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C0E493C41
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355299AbiASOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:53:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:50202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355296AbiASOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642603986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WYpFN6jD3NddkSrlHA/3O9g9jz5Y6MIz520Okk741Oo=;
        b=WkGHoS3rpnBzUq1Pl0cG6+tAA0LEPQbJDS3HtPw5u4IWAB9NpBYhPnGINIuaH2TcwubqWq
        yZdCr+5LI9/LjLVtJkvUcmwsg14zH7DqUPJXQxhZjdHL113glzFQTM0CgeREjm+XyzvyOB
        Gn4yz8cgHHrb0ctw8DzZykMzJOAwZbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-JmE8UmHUPUmUtLQLIdyb5Q-1; Wed, 19 Jan 2022 09:53:02 -0500
X-MC-Unique: JmE8UmHUPUmUtLQLIdyb5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A72918B613D;
        Wed, 19 Jan 2022 14:53:01 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-9.ams2.redhat.com [10.36.112.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C311084D1A;
        Wed, 19 Jan 2022 14:53:00 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 6713BA80D85; Wed, 19 Jan 2022 15:52:59 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 2/2 net-next v6] igb: refactor XDP registration
Date:   Wed, 19 Jan 2022 15:52:59 +0100
Message-Id: <20220119145259.1790015-3-vinschen@redhat.com>
In-Reply-To: <20220119145259.1790015-1-vinschen@redhat.com>
References: <20220119145259.1790015-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On changing the RX ring parameters igb uses a hack to avoid a warning
when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
clears the struct xdp_rxq_info content.

Instead, change this to unregister if we're already registered.  Align
code to the igc code.

Fixes: 9cbc948b5a20c ("igb: add XDP support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 19 +++++++++++++------
 2 files changed, 13 insertions(+), 10 deletions(-)

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
index 38ba92022cd4..c1e4ad65b02d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4352,7 +4352,18 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 {
 	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
 	struct device *dev = rx_ring->dev;
-	int size;
+	int size, res;
+
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+			       rx_ring->queue_index, 0);
+	if (res < 0) {
+		dev_err(dev, "Failed to register xdp_rxq index %u\n",
+			rx_ring->queue_index);
+		return res;
+	}
 
 	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
 
@@ -4375,14 +4386,10 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 
 	rx_ring->xdp_prog = adapter->xdp_prog;
 
-	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			     rx_ring->queue_index, 0) < 0)
-		goto err;
-
 	return 0;
 
 err:
+	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 	dev_err(dev, "Unable to allocate memory for the Rx descriptor ring\n");
-- 
2.27.0

