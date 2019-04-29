Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56B8DE07
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbfD2Ig3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:36:29 -0400
Received: from first.geanix.com ([116.203.34.67]:49962 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfD2IfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:02 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id EE9FA308E8C;
        Mon, 29 Apr 2019 08:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526818; bh=kBuhGD+tQqRGMTFLDCOwN4VlK8tZ2dL1x7CaTog3pJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=KZMzVQ3Q7KoOpA3dke/c3LhxS8iHMqVw86U0Fo8S56sKnFDYZ4vH5lYUdJaB5Z4Gh
         Naw8UIJ9I6BE2TIUIFJSq35j/kleyjKCdeuVFJXec6C+0XXfL4AtN/6qfzfr9iw/rD
         wsWeicjyEeQQ+zXILFFlkN46NQOleE55MJ8fUtsXyCeUglcUBopAvBGHAiDcZeoR/j
         QUPgJJ62sAvwqmGb2ou3f2JDWMk7Bfi8dhea4SZLZDRx74p4lmvQmXH2m3oPTlfGLo
         HC/2JQR5XFGZ1tyPhuvPgFn/ZoUkr0mYzailrkVqL6Z+IBVGnAInSOh4FSb1Ei/j4G
         teiwd9cjZoSuw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] net: ll_temac: Fix iommu/swiotlb leak
Date:   Mon, 29 Apr 2019 10:34:18 +0200
Message-Id: <20190429083422.4356-9-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
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
index 1c5d126..72ec338 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -821,7 +821,7 @@ static void ll_temac_recv(struct net_device *ndev)
 		length = be32_to_cpu(cur_p->app4) & 0x3FFF;
 
 		dma_unmap_single(ndev->dev.parent, be32_to_cpu(cur_p->phys),
-				 length, DMA_FROM_DEVICE);
+				 XTE_MAX_JUMBO_FRAME_SIZE, DMA_FROM_DEVICE);
 
 		skb_put(skb, length);
 		skb->protocol = eth_type_trans(skb, ndev);
-- 
2.4.11

