Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64271EBCFF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFBNWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:22:00 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:15722 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgFBNV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1591104118; x=1622640118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IQoxF8qAlyS+QVBNfqUNBhngPSWBNqmeZsjGbB1Bw9E=;
  b=v43mFc914X/ZWAEh7SZfuoN7GiRVJFLK+RSsobu+R0WipCjE25jS94Ia
   s3zVnBFG23XU9drehwMfeA1jtGFCXDeHyfFRhAjVg2GdRP0YWvxm+X8MM
   mNaZ21aRCSRgkCU/r3C076IEXoFU/KWlmGmHhm308kC6Bmg9luhSLxOeA
   U=;
IronPort-SDR: UL5ihLmlmMHjl1qMvm/M/j0YHbmz7gCxT8kHBQObbHMoXZ3qpg2X9cTGNbDe65nkSp4jGTxJ55
 r6Jkcvt0jjWQ==
X-IronPort-AV: E=Sophos;i="5.73,464,1583193600"; 
   d="scan'208";a="47843125"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Jun 2020 13:21:55 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id 1F6B7A1F9D;
        Tue,  2 Jun 2020 13:21:54 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Jun 2020 13:21:53 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 2 Jun 2020 13:21:53 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 2 Jun 2020 13:21:53 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 1FB3381CC1; Tue,  2 Jun 2020 13:21:53 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 1/2] net: ena: xdp: XDP_TX: fix memory leak
Date:   Tue, 2 Jun 2020 13:21:50 +0000
Message-ID: <20200602132151.366-2-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200602132151.366-1-sameehj@amazon.com>
References: <20200602132151.366-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

When sending very high packet rate, the XDP tx queues can get full and
start dropping packets. In this case we don't free the pages which
results in ena driver draining the system memory.

Fix:
Simply free the pages when necessary.

Fixes: cad451dd2427 ("net: ena: Implement XDP_TX action")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 281896542..ec115b753 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -355,7 +355,7 @@ error_unmap_dma:
 	ena_unmap_tx_buff(xdp_ring, tx_info);
 	tx_info->xdpf = NULL;
 error_drop_packet:
-
+	__free_page(tx_info->xdp_rx_page);
 	return NETDEV_TX_OK;
 }
 
-- 
2.24.1.AMZN

