Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A8C3AF2C0
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhFUR4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhFURzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788F36115B;
        Mon, 21 Jun 2021 17:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297976;
        bh=xWGsgCXd7OEaijrEvpsTLlP6MXTD0C9RJegrSoeQg78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BEwhlBILWI2IYFlJkbHxvFjHqQA6KzoKbI7JuWZRd4jKjaznIGBXENPEYHOHJyyyo
         h2+FT71Bx6KK3fttrzhbif56iCkPGwvYeimC/e0aYGWqSWXWuSYE4mIraBlrg0saJY
         x4NqUUikPSut78Sjwm9Cv1Ni3fns5ZCvl/6w5enY1kwGppb1RVEXrNcd0rdXRQ34zD
         Xk0Ziyzy+eld4heQQhA/tHYwWX+hKompOLItjVFKdpg5B9PTJBGuodJAiQEmfPdP2d
         WMH5XdoJ9HFRER7Lb7Mb2/EXbJjjdJgZFsKsPEWGjJ9OpE6RS1QSanrzqpSMd1UimV
         n0KOCYYtTlDcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 38/39] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
Date:   Mon, 21 Jun 2021 13:51:54 -0400
Message-Id: <20210621175156.735062-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
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
index fb977bc4d838..b1caf56b2584 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -938,6 +938,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
2.30.2

