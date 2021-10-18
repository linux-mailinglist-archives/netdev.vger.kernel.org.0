Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA6C431A84
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhJRNSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:18:47 -0400
Received: from mx22.baidu.com ([220.181.50.185]:59764 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231167AbhJRNSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 09:18:46 -0400
Received: from BJHW-Mail-Ex06.internal.baidu.com (unknown [10.127.64.16])
        by Forcepoint Email with ESMTPS id 965CB9716616C3D051F6;
        Mon, 18 Oct 2021 21:16:31 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex06.internal.baidu.com (10.127.64.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 18 Oct 2021 21:16:31 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 18 Oct 2021 21:16:30 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Krzysztof Halasa <khalasa@piap.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: ethernet: ixp4xx: Make use of dma_pool_zalloc() instead of dma_pool_alloc/memset()
Date:   Mon, 18 Oct 2021 21:16:29 +0800
Message-ID: <20211018131630.328-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex06_2021-10-18 21:16:31:597
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replacing dma_pool_alloc/memset() with dma_pool_zalloc()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 3e5fd952aeaa..65fdad1107fc 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1103,10 +1103,9 @@ static int init_queues(struct port *port)
 			return -ENOMEM;
 	}
 
-	if (!(port->desc_tab = dma_pool_alloc(dma_pool, GFP_KERNEL,
-					      &port->desc_tab_phys)))
+	port->desc_tab = dma_pool_zalloc(dma_pool, GFP_KERNEL, &port->desc_tab_phys);
+	if (!port->desc_tab)
 		return -ENOMEM;
-	memset(port->desc_tab, 0, POOL_ALLOC_SIZE);
 	memset(port->rx_buff_tab, 0, sizeof(port->rx_buff_tab)); /* tables */
 	memset(port->tx_buff_tab, 0, sizeof(port->tx_buff_tab));
 
-- 
2.25.1

