Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6345248DB31
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 17:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiAMQAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 11:00:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236394AbiAMQAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 11:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642089649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=isyCxdsKfaQeXmUO7H2IJ7WTnHh6LyWWkT2qzdA4nrs=;
        b=bkiQxkJBhUnOEYbQbu1acH0jMbA2S2rLCPKex1QORVC1cUPsgKT6FB/6slqmDwyfZWdsO2
        kr4CW7QqcfBgoGZS8tZwVkWXv0Ck2dGNIjyDKndX3eZ7Oevqj32sQSTg9I8h//Rmt+UNSF
        oBPuKOD+IQSW683LMeBZ7L7i9bENyM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-lB6uJ8-pMpy4jzjK-XeUmw-1; Thu, 13 Jan 2022 11:00:43 -0500
X-MC-Unique: lB6uJ8-pMpy4jzjK-XeUmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FFDC101AAA2;
        Thu, 13 Jan 2022 16:00:23 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1993B1091ED0;
        Thu, 13 Jan 2022 16:00:23 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 88EFDA807A2; Thu, 13 Jan 2022 17:00:21 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     Andre Guedes <andre.guedes@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>
Subject: [PATCH net-next] igc: avoid kernel warning when changing RX ring parameters
Date:   Thu, 13 Jan 2022 17:00:21 +0100
Message-Id: <20220113160021.1027704-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling ethtool changing the RX ring parameters like this:

  $ ethtool -G eth0 rx 1024

triggers the "Missing unregister, handled but fix driver" warning in
xdp_rxq_info_reg().

igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
reset the xdp_rxq_info member before calling igc_setup_rx_resources().
This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.

This fix initializes the xdp_rxq_info member prior to calling
igc_setup_rx_resources(), exactly like igb.

Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 8cc077b712ad..93839106504d 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -671,6 +671,10 @@ igc_ethtool_set_ringparam(struct net_device *netdev,
 			memcpy(&temp_ring[i], adapter->rx_ring[i],
 			       sizeof(struct igc_ring));
 
+			/* Clear copied XDP RX-queue info */
+			memset(&temp_ring[i].xdp_rxq, 0,
+			       sizeof(temp_ring[i].xdp_rxq));
+
 			temp_ring[i].count = new_rx_count;
 			err = igc_setup_rx_resources(&temp_ring[i]);
 			if (err) {
-- 
2.27.0

