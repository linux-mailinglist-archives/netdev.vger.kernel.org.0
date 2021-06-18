Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774FC3AC934
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhFRKzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:55:23 -0400
Received: from first.geanix.com ([116.203.34.67]:53926 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhFRKyv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:54:51 -0400
Received: from localhost (80-62-117-165-mobile.dk.customer.tdc.net [80.62.117.165])
        by first.geanix.com (Postfix) with ESMTPSA id 96BCB4C36E0;
        Fri, 18 Jun 2021 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1624013560; bh=ZxZg/ybmf0dZDYjJCDKl8z7xwrG15DvFCOiKFYT8Emg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=JMbFP/ewH8KSoz8S07Vt0P7YRLnwiDSZeuhNglezIxCi6xetcRHC8znkPUs78aGa/
         MYHH/zw1Q17TtC6myWWPsuqG86tuFXKD3RDUuk5O5gEPGhXswq5pq34Ycr/tvLGL2H
         tMHKTiVVu/ioETu+vBYTyqbt8OW844ITdE4HuulSIFSsOI4XfzigdfQnjf8/Eh1Uap
         G7XU6OPYVb7OifbPG/uU9VEcdy5MaGKsk27qoZDD1kcZ+Zqt4uZNHdlm6FdS5wbDdf
         SZ5qaJAC6/3AWiyhEvl45+85pv2Vvl9iwGvej+XqLrPIYlRIrWVnucbahyWH7XyIx4
         gTHzINRodCK/Q==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Wang Hai <wanghai38@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
Date:   Fri, 18 Jun 2021 12:52:38 +0200
Message-Id: <4c927f4c3da854dc60145d170008a2a09ab25027.1624013456.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
References: <d9200a5023973fbe372a2d51dc4e500400450ecd.1624013456.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As documented in Documentation/networking/driver.rst, the ndo_start_xmit
method must not return NETDEV_TX_BUSY under any normal circumstances, and
as recommended, we simply stop the tx queue in advance, when there is a
risk that the next xmit would cause a NETDEV_TX_BUSY return.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index cc482ee36501..9a13953ea70f 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -942,6 +942,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	wmb();
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
+		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+		netif_stop_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 }
 
-- 
2.32.0

