Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF743AF44F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhFUSIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234320AbhFUSFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9101C61370;
        Mon, 21 Jun 2021 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298181;
        bh=N1HyRh+smJA+KgiA9Llg+9G9JVCUrbjQdQkAgZgjwRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YmS2Ptwm/5vvgxilPh/7j/7n0TThoJ4eLed3ioy1d+7uM+WTuGp73bp4a2OdLEZlO
         gRD3Ci/FgUsquS+vO/q6CD4URPTgR1oH4qFlnvrYpoXBOGSLTKVTMjmo+FILpUKKWi
         4iWnjoMq72W5Lr8eY0Iaa5W6/RAO+HUrZxAR6PCyBSxuxbdBb0jlUt0ady7tzyU4m/
         vMSvZqxoI89+fWMt+Zjrb8A3u9uFgJTKU0hZos9IvDrZPj7qNH1gGiMU43eoWBRjvq
         wJKjZ09o/RzhEISQcUY83SnhtqXXVyfkSzUtPK3mvkL8p+/z3RKdvdC17Rl+lu2e54
         RoKc4niumoyYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 9/9] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
Date:   Mon, 21 Jun 2021 13:56:07 -0400
Message-Id: <20210621175608.736581-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175608.736581-1-sashal@kernel.org>
References: <20210621175608.736581-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit f6396341194234e9b01cd7538bc2c6ac4501ab14 ]

As documented in Documentation/networking/driver.rst, the ndo_start_xmit
method must not return NETDEV_TX_BUSY under any normal circumstances, and
as recommended, we simply stop the tx queue in advance, when there is a
risk that the next xmit would cause a NETDEV_TX_BUSY return.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index ed6a88cf3281..98a1c712b62a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -735,6 +735,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	/* Kick off the transfer */
 	lp->dma_out(lp, TX_TAILDESC_PTR, tail_p); /* DMA start */
 
+	if (temac_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
+		netdev_info(ndev, "%s -> netif_stop_queue\n", __func__);
+		netif_stop_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 }
 
-- 
2.30.2

