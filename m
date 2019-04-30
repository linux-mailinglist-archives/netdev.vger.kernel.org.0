Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC29DF123
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfD3HSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:18:41 -0400
Received: from first.geanix.com ([116.203.34.67]:43728 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbfD3HSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:37 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 93690308E9D;
        Tue, 30 Apr 2019 07:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608710; bh=DAjULfeqzzhfRAwoGb6qT4ROYTcoiZ5UMEfG1sSyqwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=XrR5isrIxnDNZT6BiKSVeGFIiLNNkraLx1S1jEjxtIsnSttINxL4DbM895/VaNTMO
         RWeCntKFPGSoH2ceWfb7vXq0DjFKKou4YzUKGs1Cv6jFlb94URnExlu8h/otCDJ+Va
         3KEjR0aqg7g0mrTckcapDYV0n/e/ZmhkUCPaf4PjTi/ljmfCkwZBRtOImTIflleANq
         r3OsMJGwyy7tyOjFQMViLhOC0FGSnAUg2V83UJFuStzevzZwNvM4UNPlicC/7+3IHX
         LBhTr0DX1UKsQDlg2pLgutrTmet6e9q+CCp6NnT+c0CFuVaWkoL6RpR+Ffdol48MJ/
         O3Ax46WjCS5pg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 08/12] net: ll_temac: Fix iommu/swiotlb leak
Date:   Tue, 30 Apr 2019 09:17:55 +0200
Message-Id: <20190430071759.2481-9-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unmap the actual buffer length, not the amount of data received, avoiding
resource exhaustion of swiotlb (seen on x86_64 platform).

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index d3899e7..7e42746 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -820,7 +820,7 @@ static void ll_temac_recv(struct net_device *ndev)
 		length = be32_to_cpu(cur_p->app4) & 0x3FFF;
 
 		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
-				 length, DMA_FROM_DEVICE);
+				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
 
 		skb_put(skb, length);
 		skb->protocol = eth_type_trans(skb, ndev);
-- 
2.4.11

