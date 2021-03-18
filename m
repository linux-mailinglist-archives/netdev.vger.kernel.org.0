Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57042340135
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhCRIvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:51:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhCRIu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 04:50:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22201AC17;
        Thu, 18 Mar 2021 08:50:56 +0000 (UTC)
From:   Mian Yousaf Kaukab <ykaukab@suse.de>
To:     jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, kuba@kernel.org, masahisa.kojima@linaro.org,
        osaki.yoshitoyo@socionext.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mian Yousaf Kaukab <ykaukab@suse.de>, stable@vger.kernel.org
Subject: [PATCH net] netsec: restore phy power state after controller reset
Date:   Thu, 18 Mar 2021 09:50:26 +0100
Message-Id: <20210318085026.30475-1-ykaukab@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8e850f25b581 ("net: socionext: Stop PHY before resetting
netsec") netsec_netdev_init() power downs phy before resetting the
controller. However, the state is not restored once the reset is
complete. As a result it is not possible to bring up network on a
platform with Broadcom BCM5482 phy.

Fix the issue by restoring phy power state after controller reset is
complete.

Fixes: 8e850f25b581 ("net: socionext: Stop PHY before resetting netsec")
Cc: stable@vger.kernel.org
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
---
 drivers/net/ethernet/socionext/netsec.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 3c53051bdacf..200785e703c8 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1715,14 +1715,17 @@ static int netsec_netdev_init(struct net_device *ndev)
 		goto err1;
 
 	/* set phy power down */
-	data = netsec_phy_read(priv->mii_bus, priv->phy_addr, MII_BMCR) |
-		BMCR_PDOWN;
-	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR, data);
+	data = netsec_phy_read(priv->mii_bus, priv->phy_addr, MII_BMCR);
+	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR,
+			 data | BMCR_PDOWN);
 
 	ret = netsec_reset_hardware(priv, true);
 	if (ret)
 		goto err2;
 
+	/* Restore phy power state */
+	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR, data);
+
 	spin_lock_init(&priv->desc_ring[NETSEC_RING_TX].lock);
 	spin_lock_init(&priv->desc_ring[NETSEC_RING_RX].lock);
 
-- 
2.26.2

