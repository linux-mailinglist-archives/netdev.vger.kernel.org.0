Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF10148CF24
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 00:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiALXdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 18:33:09 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:7551 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiALXdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 18:33:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1642030388; x=1673566388;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fc55L5MUZDiGbQZ8eZAKde645irQFkn06aL3kIXwU2k=;
  b=D+jIjxjho6qc83Z0AbyKQimWrHH7sov8wmGEnbjmJ4+1vmsT5RotdfHV
   DvC45EP0qMQZL6SqhA+Nz2DWQsWtX/Lw1jsA9pzFE35l9ezxIvoNL9wkV
   sW29gPQeIBuUcXbA/rQgK+uwQ8z1iTcsPMQ7OAhX5i96T/4N1sjaF0fZi
   g=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208,223";a="54973163"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 12 Jan 2022 23:33:07 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-b27d4a00.us-east-1.amazon.com (Postfix) with ESMTPS id A17DB811B2;
        Wed, 12 Jan 2022 23:33:05 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 12 Jan 2022 23:33:04 +0000
Received: from u46989501580c5c.ant.amazon.com (10.43.161.183) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 12 Jan 2022 23:33:04 +0000
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     Samuel Mendoza-Jonas <samjonas@amazon.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Tony Nguyen" <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ixgbevf: Require large buffers for build_skb on 82599VF
Date:   Wed, 12 Jan 2022 15:32:31 -0800
Message-ID: <20220112233231.317259-1-samjonas@amazon.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D40UWA002.ant.amazon.com (10.43.160.149) To
 EX13d01UWA002.ant.amazon.com (10.43.160.74)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 4.17 onwards the ixgbevf driver uses build_skb() to build an skb
around new data in the page buffer shared with the ixgbe PF.
This uses either a 2K or 3K buffer, and offsets the DMA mapping by
NET_SKB_PAD + NET_IP_ALIGN. When using a smaller buffer RXDCTL is set to
ensure the PF does not write a full 2K bytes into the buffer, which is
actually 2K minus the offset.

However on the 82599 virtual function, the RXDCTL mechanism is not
available. The driver attempts to work around this by using the SET_LPE
mailbox method to lower the maximm frame size, but the ixgbe PF driver
ignores this in order to keep the PF and all VFs in sync[0].

This means the PF will write up to the full 2K set in SRRCTL, causing it
to write NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the buffer.
With 4K pages split into two buffers, this means it either writes
NET_SKB_PAD + NET_IP_ALIGN bytes past the first buffer (and into the
second), or NET_SKB_PAD + NET_IP_ALIGN bytes past the end of the DMA
mapping.

Avoid this by only enabling build_skb when using "large" buffers (3K).
These are placed in each half of an order-1 page, preventing the PF from
writing past the end of the mapping.

[0]: Technically it only ever raises the max frame size, see
ixgbe_set_vf_lpe() in ixgbe_sriov.c

Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 0015fcf1df2b..0f293acd17e8 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1984,14 +1984,15 @@ static void ixgbevf_set_rx_buffer_len(struct ixgbevf_adapter *adapter,
 	if (adapter->flags & IXGBEVF_FLAGS_LEGACY_RX)
 		return;
 
-	set_ring_build_skb_enabled(rx_ring);
+	if (PAGE_SIZE < 8192)
+		if (max_frame > IXGBEVF_MAX_FRAME_BUILD_SKB)
+			set_ring_uses_large_buffer(rx_ring);
 
-	if (PAGE_SIZE < 8192) {
-		if (max_frame <= IXGBEVF_MAX_FRAME_BUILD_SKB)
-			return;
+	/* 82599 can't rely on RXDCTL.RLPML to restrict the size of the frame */
+	if (adapter->hw.mac.type == ixgbe_mac_82599_vf && !ring_uses_large_buffer(rx_ring))
+		return;
 
-		set_ring_uses_large_buffer(rx_ring);
-	}
+	set_ring_build_skb_enabled(rx_ring);
 }
 
 /**
-- 
2.25.1

