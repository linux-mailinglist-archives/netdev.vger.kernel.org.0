Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211B815AF2
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbfEGFkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729038AbfEGFkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:40:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5008C2087F;
        Tue,  7 May 2019 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207615;
        bh=N8ajWXn71Lm1wn4HdOG/RTY7uqgJZAxINuEKsuT+bp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGk611XQmEx0iAM+/5I9S3xzt9MCqL5QTv2Mj76tmzEiz11U1vI1OJ8gwPg/u5lRw
         eVna28ECrwuxN0mdAPQ0jCANDSzomy97ZiItb//b+58wtEwUriBnWw5EDI5WWdr2/3
         sTpqS4H1M4AeMFTbANsQbJylA9OW4CPdFxwZhVQ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 58/95] net: stmmac: Move debugfs init/exit to ->probe()/->remove()
Date:   Tue,  7 May 2019 01:37:47 -0400
Message-Id: <20190507053826.31622-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 5f2b8b62786853341a20d4cd4948f9cbca3db002 ]

Setting up and tearing down debugfs is current unbalanced, as seen by
this error during resume from suspend:

    [  752.134067] dwc-eth-dwmac 2490000.ethernet eth0: ERROR failed to create debugfs directory
    [  752.134347] dwc-eth-dwmac 2490000.ethernet eth0: stmmac_hw_setup: failed debugFS registration

The imbalance happens because the driver creates the debugfs hierarchy
when the device is opened and tears it down when the device is closed.
There's little gain in that, and it could be argued that it is even
surprising because it's not usually done for other devices. Fix the
imbalance by moving the debugfs creation and teardown to the driver's
->probe() and ->remove() implementations instead.

Note that the ring descriptors cannot be read while the interface is
down, so make sure to return an empty file when the descriptors_status
debugfs file is read.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Acked-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ecf3f8c1bc0e..3389545353a7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2530,12 +2530,6 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			netdev_warn(priv->dev, "PTP init failed\n");
 	}
 
-#ifdef CONFIG_DEBUG_FS
-	ret = stmmac_init_fs(dev);
-	if (ret < 0)
-		netdev_warn(priv->dev, "%s: failed debugFS registration\n",
-			    __func__);
-#endif
 	priv->tx_lpi_timer = STMMAC_DEFAULT_TWT_LS;
 
 	if ((priv->use_riwt) && (priv->hw->dma->rx_watchdog)) {
@@ -2729,10 +2723,6 @@ static int stmmac_release(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-#ifdef CONFIG_DEBUG_FS
-	stmmac_exit_fs(dev);
-#endif
-
 	stmmac_release_ptp(priv);
 
 	return 0;
@@ -3837,6 +3827,9 @@ static int stmmac_sysfs_ring_read(struct seq_file *seq, void *v)
 	u32 tx_count = priv->plat->tx_queues_to_use;
 	u32 queue;
 
+	if ((dev->flags & IFF_UP) == 0)
+		return 0;
+
 	for (queue = 0; queue < rx_count; queue++) {
 		struct stmmac_rx_queue *rx_q = &priv->rx_queue[queue];
 
@@ -4308,6 +4301,13 @@ int stmmac_dvr_probe(struct device *device,
 		goto error_netdev_register;
 	}
 
+#ifdef CONFIG_DEBUG_FS
+	ret = stmmac_init_fs(ndev);
+	if (ret < 0)
+		netdev_warn(priv->dev, "%s: failed debugFS registration\n",
+			    __func__);
+#endif
+
 	return ret;
 
 error_netdev_register:
@@ -4341,6 +4341,9 @@ int stmmac_dvr_remove(struct device *dev)
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
+#ifdef CONFIG_DEBUG_FS
+	stmmac_exit_fs(ndev);
+#endif
 	stmmac_stop_all_dma(priv);
 
 	priv->hw->mac->set_mac(priv->ioaddr, false);
-- 
2.20.1

