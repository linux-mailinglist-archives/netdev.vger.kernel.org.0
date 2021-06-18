Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E37D3AC92E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhFRKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:54:39 -0400
Received: from first.geanix.com ([116.203.34.67]:53864 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233846AbhFRKyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:54:38 -0400
Received: from localhost (80-62-117-165-mobile.dk.customer.tdc.net [80.62.117.165])
        by first.geanix.com (Postfix) with ESMTPSA id 83127C7E;
        Fri, 18 Jun 2021 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1624013545; bh=q1b5bexcq1vlomibUUd2NWw4q2kj339YQtJG09H39VU=;
        h=From:To:Cc:Subject:Date;
        b=HeMztwFs+X1USFI5ZxW5uim5+GUirflBTScWidkBQiyZTPd/hni4X5UMrAybMrgwf
         4RDZtH4mfxImXHD7rVhta2VS6VgONNoeaNSgJtY8BEAkFjy5A1b7KEeOjE8Fo3HaqA
         5fXVJoy5WJzFHpvZ4XGeTw8tGgk2uHdNjw0xXP8D7KygA0+pQ/dN8jN5xtnJvIz8UP
         JnMGeR3FTQju3J5QMBZW4aSkNMh2OdUK0UpO7OR4w28Y8/dGvtrPhGEWYV7rA01rYU
         72fsuOeMlEIPaMRgx2Hv6gWcPzkUthBFgy+Fjob6htZOO8R0vJwpmI4pj2XCRmZ1qr
         snoEGnIsZjwPg==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Wang Hai <wanghai38@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Michael Walle <michael@walle.cc>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] net: ll_temac: Make sure to free skb when it is completely used
Date:   Fri, 18 Jun 2021 12:52:23 +0200
Message-Id: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the skb pointer piggy-backed on the TX BD, we have a simple and
efficient way to free the skb buffer when the frame has been transmitted.
But in order to avoid freeing the skb while there are still fragments from
the skb in use, we need to piggy-back on the TX BD of the skb, not the
first.

Without this, we are doing use-after-free on the DMA side, when the first
BD of a multi TX BD packet is seen as completed in xmit_done, and the
remaining BDs are still being processed.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index a1f5f07f4ca9..e82f162cd80c 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -876,7 +876,6 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_OK;
 	}
 	cur_p->phys = cpu_to_be32(skb_dma_addr);
-	ptr_to_txbd((void *)skb, cur_p);
 
 	for (ii = 0; ii < num_frag; ii++) {
 		if (++lp->tx_bd_tail >= lp->tx_bd_num)
@@ -915,6 +914,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	}
 	cur_p->app0 |= cpu_to_be32(STS_CTRL_APP0_EOP);
 
+	/* Mark last fragment with skb address, so it can be consumed
+	 * in temac_start_xmit_done()
+	 */
+	ptr_to_txbd((void *)skb, cur_p);
+
 	tail_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	lp->tx_bd_tail++;
 	if (lp->tx_bd_tail >= lp->tx_bd_num)
-- 
2.32.0

