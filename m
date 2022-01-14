Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2F248EEB8
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbiANQvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:51:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243608AbiANQvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:51:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642179071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMS81FhIXAhrhd3SbohJHPgZgutuOpNyMHUEJRSUutc=;
        b=Y26/wZHr+wwhhlIxEqz0XCg+nc+StsljnIjpBKlJnichEK3Yr7PKpfSu5/bA7Qh15C57Kd
        0+OFQwYM6SMPo3DB71YpE3+HIDeRMhNwB6V1sxtZ+piqIlzZOVJZ+/UPqkdMgvyYXPxJQN
        ePArRUVdbOePrxCOMTtSWCB0zUNDDP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-heNMeN4POfiO7iT8hQD2zg-1; Fri, 14 Jan 2022 11:51:10 -0500
X-MC-Unique: heNMeN4POfiO7iT8hQD2zg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30B1381CCB4;
        Fri, 14 Jan 2022 16:51:09 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78AD785F1A;
        Fri, 14 Jan 2022 16:51:08 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id E6CF4A8078A; Fri, 14 Jan 2022 17:51:06 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 1/2 net-next v3] igc: avoid kernel warning when changing RX ring parameters
Date:   Fri, 14 Jan 2022 17:51:05 +0100
Message-Id: <20220114165106.1085474-2-vinschen@redhat.com>
In-Reply-To: <20220114165106.1085474-1-vinschen@redhat.com>
References: <20220114165106.1085474-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling ethtool changing the RX ring parameters like this:

  $ ethtool -G eth0 rx 1024

on igc triggers the "Missing unregister, handled but fix driver" warning in
xdp_rxq_info_reg().

igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
reset the xdp_rxq_info member before calling igc_setup_rx_resources().
This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.

Make sure to unregister the xdp_rxq_info structure first in
igc_setup_rx_resources.  Move xdp_rxq_info handling down to bethe last
action, thus allowing to remove the xdp_rxq_info_unreg call in the error path.

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2f17f36e94fd..97144f6db36e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -505,14 +505,6 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 	u8 index = rx_ring->queue_index;
 	int size, desc_len, res;
 
-	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
-			       rx_ring->q_vector->napi.napi_id);
-	if (res < 0) {
-		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
-			   index);
-		return res;
-	}
-
 	size = sizeof(struct igc_rx_buffer) * rx_ring->count;
 	rx_ring->rx_buffer_info = vzalloc(size);
 	if (!rx_ring->rx_buffer_info)
@@ -534,10 +526,20 @@ int igc_setup_rx_resources(struct igc_ring *rx_ring)
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 
+	/* XDP RX-queue info */
+	if (xdp_rxq_info_is_reg(&rx_ring->xdp_rxq))
+		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
+	res = xdp_rxq_info_reg(&rx_ring->xdp_rxq, ndev, index,
+			       rx_ring->q_vector->napi.napi_id);
+	if (res < 0) {
+		netdev_err(ndev, "Failed to register xdp_rxq index %u\n",
+			   index);
+		return res;
+	}
+
 	return 0;
 
 err:
-	xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
 	vfree(rx_ring->rx_buffer_info);
 	rx_ring->rx_buffer_info = NULL;
 	netdev_err(ndev, "Unable to allocate memory for Rx descriptor ring\n");
-- 
2.27.0

