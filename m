Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B97A3AF3A7
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbhFUSC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhFUSAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB94861405;
        Mon, 21 Jun 2021 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298086;
        bh=ndlGodXSrOZjCU0P5E7osT1RPL4coRj6KmesOWxD0Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COq5Y8PlGzXjrPe4gGW+S82Z37LQwWMaAtJ3LNCSw1cMULyOkxcJ8r6hEv5jUvz4e
         YbJ5dbE/KeZtqmuZ6hgkWEIFMvP7QKTfa0K7AWHrs7wJe6mSxknHEOKaC6q7w9Rl1I
         W+ozftO3RhvTBSLAx/Gx7aOxiNZk6g2OzHffoNr8IqQTOAdq3npYUL2XSkdzwdzkF2
         Def7hm327kAPvEhCB8Auk4wxp7F0hY6/w9XbGov/QMIDc+p2pqmVazb18tyKIjubeE
         wMX93CEAAzrKq+A4+kYAcB8ukX6dsuhqaIAvHGTKAtdW0QmoxEhCILTq6M3FC/iVj4
         TjXTHS2ggN8tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esben Haabendal <esben@geanix.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 26/26] net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY
Date:   Mon, 21 Jun 2021 13:53:59 -0400
Message-Id: <20210621175400.735800-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175400.735800-1-sashal@kernel.org>
References: <20210621175400.735800-1-sashal@kernel.org>
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
index 63aabe051332..918fdc180cea 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -935,6 +935,11 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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

