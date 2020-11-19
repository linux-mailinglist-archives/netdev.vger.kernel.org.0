Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA42B9C01
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 21:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgKSUar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 15:30:47 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:10247 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgKSUaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 15:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1605817846; x=1637353846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=26D/4+8MgXEm/GmImR17KomqwYUP7LW7XQyydu3A9WI=;
  b=TVj+MqZAPqRGrEs8l7outZ96j26zUd0t34ZzFyzC2C7JiYhVSrPLD+0i
   X444mvM4c5Ht6Lt+RAiTkoTVokwFrePaUPqxJ5uAv8JHLXAj1MU6TdcAh
   cZMY/3TNru7RvfmhHxZpV8W3CsOPVMj4pYbq6zNyLbRlgd4INbs0b+3cb
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,354,1599523200"; 
   d="scan'208";a="64986625"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 19 Nov 2020 20:30:38 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 48362241429;
        Thu, 19 Nov 2020 20:30:38 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com (10.43.162.53) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 19 Nov 2020 20:30:30 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: [PATCH V2 net 4/4] net: ena: return error code from ena_xdp_xmit_buff
Date:   Thu, 19 Nov 2020 22:28:51 +0200
Message-ID: <20201119202851.28077-5-shayagr@amazon.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119202851.28077-1-shayagr@amazon.com>
References: <20201119202851.28077-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.53]
X-ClientProxiedBy: EX13D05UWC002.ant.amazon.com (10.43.162.92) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function mistakenly returns NETDEV_TX_OK regardless of the
transmission success. This patch fixes this behavior by returning the
error code from the function.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index df1884d57d1a..66b67ab51478 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -284,9 +284,9 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
 	u16 next_to_use, req_id;
-	int rc;
 	void *push_hdr;
 	u32 push_len;
+	int rc;
 
 	xdp_ring = &adapter->tx_ring[qid];
 	next_to_use = xdp_ring->next_to_use;
@@ -322,14 +322,14 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 	xdp_ring->tx_stats.doorbells++;
 	u64_stats_update_end(&xdp_ring->syncp);
 
-	return NETDEV_TX_OK;
+	return rc;
 
 error_unmap_dma:
 	ena_unmap_tx_buff(xdp_ring, tx_info);
 	tx_info->xdpf = NULL;
 error_drop_packet:
 	__free_page(tx_info->xdp_rx_page);
-	return NETDEV_TX_OK;
+	return rc;
 }
 
 static int ena_xdp_execute(struct ena_ring *rx_ring,
-- 
2.17.1

