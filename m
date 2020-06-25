Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C099020A23E
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405922AbgFYPoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:44:54 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:35411 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405159AbgFYPov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:44:51 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 8BC14240015;
        Thu, 25 Jun 2020 15:44:47 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 2/8] net: phy: mscc: fix a possible double unlock
Date:   Thu, 25 Jun 2020 17:42:05 +0200
Message-Id: <20200625154211.606591-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625154211.606591-1-antoine.tenart@bootlin.com>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On vsc8584_ptp_init failure we jump to the 'err' label, which unlocks
the MDIO bus lock. But vsc8584_ptp_init isn't called with the MDIO bus
lock taken, which could result in a double unlock. Fix this.

Fixes: ab2bf9339357 ("net: phy: mscc: 1588 block initialization")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/mscc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 2a7082983c09..cb4e15d6e2db 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1436,7 +1436,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	ret = vsc8584_ptp_init(phydev);
 	if (ret)
-		goto err;
+		return ret;
 
 	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
-- 
2.26.2

