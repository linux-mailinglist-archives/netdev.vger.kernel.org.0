Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544612F42A5
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 04:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbhAMDuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 22:50:19 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:53370 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAMDuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 22:50:19 -0500
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2021 22:50:17 EST
Received: from localhost (unknown [192.168.167.235])
        by lucky1.263xmail.com (Postfix) with ESMTP id 8915FCA88D;
        Wed, 13 Jan 2021 11:41:36 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-ABS-CHECKED: 0
Received: from thinkpad-p51.mshome.net (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P25768T139698924463872S1610509294957598_;
        Wed, 13 Jan 2021 11:41:36 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <5523297ee3983dc260e5c9721f8e3364>
X-RL-SENDER: david.wu@rock-chips.com
X-SENDER: wdc@rock-chips.com
X-LOGIN-NAME: david.wu@rock-chips.com
X-FST-TO: netdev@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   David Wu <david.wu@rock-chips.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, joabreu@synopsys.com,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        linux-kernel@vger.kernel.org, David Wu <david.wu@rock-chips.com>
Subject: [PATCH] net: stmmac: Fixed mtu channged by cache aligned
Date:   Wed, 13 Jan 2021 11:41:09 +0800
Message-Id: <20210113034109.27865-1-david.wu@rock-chips.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the original mtu is not used when the mtu is updated,
the mtu is aligned with cache, this will get an incorrect.
For example, if you want to configure the mtu to be 1500,
but mtu 1536 is configured in fact.

Fixed: eaf4fac478077 ("net: stmmac: Do not accept invalid MTU values")
Signed-off-by: David Wu <david.wu@rock-chips.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5b1c12ff98c0..e8640123db76 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4025,7 +4025,7 @@ static void stmmac_set_rx_mode(struct net_device *dev)
 static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	int txfifosz = priv->plat->tx_fifo_size;
+	int txfifosz = priv->plat->tx_fifo_size, mtu = new_mtu;
 
 	if (txfifosz == 0)
 		txfifosz = priv->dma_cap.tx_fifo_size;
@@ -4043,7 +4043,7 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	if ((txfifosz < new_mtu) || (new_mtu > BUF_SIZE_16KiB))
 		return -EINVAL;
 
-	dev->mtu = new_mtu;
+	dev->mtu = mtu;
 
 	netdev_update_features(dev);
 
-- 
2.19.1



