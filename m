Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2D12B95D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfL0SEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbfL0SDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:03:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5DC2173E;
        Fri, 27 Dec 2019 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577469799;
        bh=0H7jxEWn0kJ94GucQWB7iemHQgpagReOFqt9e26JIAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tej11M6xbyjvQ9/RqmmzvExE8bs2D8d0NCLrjgBQUjpKXoPkjXcybsytpeKAqQRgU
         sH99UyzXEQFaYWA+ukOfTMHVeuBDgMLS4YQ+k6H0q34cP7qkg7EupOnRGHjIuFGuBb
         YaW2E816yplW+OWk2e2kiGEYKLqd+UVxlBfb8WTY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 47/57] net: stmmac: Do not accept invalid MTU values
Date:   Fri, 27 Dec 2019 13:02:12 -0500
Message-Id: <20191227180222.7076-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227180222.7076-1-sashal@kernel.org>
References: <20191227180222.7076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit eaf4fac478077d4ed57cbca2c044c4b58a96bd98 ]

The maximum MTU value is determined by the maximum size of TX FIFO so
that a full packet can fit in the FIFO. Add a check for this in the MTU
change callback.

Also check if provided and rounded MTU does not passes the maximum limit
of 16K.

Changes from v2:
- Align MTU before checking if its valid

Fixes: 7ac6653a085b ("stmmac: Move the STMicroelectronics driver")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e6d16c48ffef..4ef923f1094a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3597,12 +3597,24 @@ static void stmmac_set_rx_mode(struct net_device *dev)
 static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
+	int txfifosz = priv->plat->tx_fifo_size;
+
+	if (txfifosz == 0)
+		txfifosz = priv->dma_cap.tx_fifo_size;
+
+	txfifosz /= priv->plat->tx_queues_to_use;
 
 	if (netif_running(dev)) {
 		netdev_err(priv->dev, "must be stopped to change its MTU\n");
 		return -EBUSY;
 	}
 
+	new_mtu = STMMAC_ALIGN(new_mtu);
+
+	/* If condition true, FIFO is too small or MTU too large */
+	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
+		return -EINVAL;
+
 	dev->mtu = new_mtu;
 
 	netdev_update_features(dev);
-- 
2.20.1

