Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6DB395D
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbfIPLci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:32:38 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61885 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731391AbfIPLci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:32:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633557; x=1600169557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=kkheEyHu6uwwlO0e9c45TIGCnTBqo0jznNlv4m4lhts=;
  b=GY7s0tHQ1TiGyZDiGEamNFJ2I5cGc61SfY+7ojEOsjDbr0H/ny1eaKDI
   ijeWyqqHNPxJiRWP5Tytwooyxj1Zh1ZNX39JB+CTWmcL7d8uICk0n5jf4
   sGMLw1yr5Rl5h6Gj4tB0N8Cw6CAz7ViRs+lbrbEhWTbovaKmijjyUpKIp
   E=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="750940114"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Sep 2019 11:32:37 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 571A9A2300;
        Mon, 16 Sep 2019 11:32:37 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:11 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:11 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:32:08 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 09/11] net: ena: fix update of interrupt moderation register
Date:   Mon, 16 Sep 2019 14:31:34 +0300
Message-ID: <1568633496-4143-10-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Current implementation always updates the interrupt register with
the smoothed_interval of the rx_ring. However this should be
done only in case of adaptive interrupt moderation. If non-adaptive
interrupt moderation is used, the non-adaptive interrupt moderation
interval should be used. This commit fixes that.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 8b9f8b90e525..54539e57aa73 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1187,12 +1187,15 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
 	struct ena_eth_io_intr_reg intr_reg;
+	u32 rx_interval = ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev) ?
+		rx_ring->smoothed_interval :
+		ena_com_get_nonadaptive_moderation_interval_rx(rx_ring->ena_dev);
 
 	/* Update intr register: rx intr delay,
 	 * tx intr delay and interrupt unmask
 	 */
 	ena_com_update_intr_reg(&intr_reg,
-				rx_ring->smoothed_interval,
+				rx_interval,
 				tx_ring->smoothed_interval,
 				true);
 
-- 
2.17.2

