Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895AC48E95B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbiANLoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:44:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237600AbiANLoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642160644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iogx5i2QkC24IABpCodgDKaQcW1VO0VWZwvo0dBw1UA=;
        b=QqXhh5alNyy1ZmsmkraPXxAZurITUImRRTrI0hse9IQQIhRvx0Si+ZANFWUvJbFz2avg6p
        F7b5zt5uw6/D+EP4kzJyEBWCdv51UbZp9rD6ut1Y76jAkeeTwy07EKER+Hb4hjc27pcZHO
        S7XnTqyextJkUtJgyW2Re8T8AKUerQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-5Czr7m8KNjaCf9lBfcACrg-1; Fri, 14 Jan 2022 06:43:58 -0500
X-MC-Unique: 5Czr7m8KNjaCf9lBfcACrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B2F64143;
        Fri, 14 Jan 2022 11:43:57 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73C222617D;
        Fri, 14 Jan 2022 11:43:56 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id BB189A81472; Fri, 14 Jan 2022 12:43:54 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 2/2 net-next v2] igb: refactor XDP registration
Date:   Fri, 14 Jan 2022 12:43:54 +0100
Message-Id: <20220114114354.1071776-3-vinschen@redhat.com>
In-Reply-To: <20220114114354.1071776-1-vinschen@redhat.com>
References: <20220114114354.1071776-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On changing the RX ring parameters igb uses a hack to avoid a warning
when calling xdp_rxq_info_reg via igb_setup_rx_resources.  It just
clears the struct xdp_rxq_info content.

Change this to unregister if we're already registered instead.  ALign
code to the igc code.

Fixes: 9cbc948b5a20c ("igb: add XDP support")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 15 +++++++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

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
index 38ba92022cd4..9638cb9c6014 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4352,7 +4352,7 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 {
 	struct igb_adapter *adapter = netdev_priv(rx_ring->netdev);
 	struct device *dev = rx_ring->dev;
-	int size;
+	int size, res;
 
 	size = sizeof(struct igb_rx_buffer) * rx_ring->count;
 
@@ -4376,9 +4376,16 @@ int igb_setup_rx_resources(struct igb_ring *rx_ring)
 	rx_ring->xdp_prog = adapter->xdp_prog;
 
 	/* XDP RX-queue info */
-	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
-			     rx_ring->queue_index, 0) < 0)
-		goto err;
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, rx_ring->netdev,
+			       rx_ring->queue_index, 0);
+	if (res < 0) {
+		netdev_err(rx_ring->netdev,
+			   "Failed to register xdp_rxq index %u\n",
+			   rx_ring->queue_index);
+		return res;
+	}
 
 	return 0;
 
-- 
2.27.0

