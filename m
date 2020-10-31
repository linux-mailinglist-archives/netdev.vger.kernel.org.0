Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 511D62A122D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgJaAuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgJaAuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYf5z-004RiV-E8; Sat, 31 Oct 2020 01:50:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/7] drivers: net: smc911x: Work around set but unused status
Date:   Sat, 31 Oct 2020 01:49:54 +0100
Message-Id: <20201031004958.1059797-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004958.1059797-1-andrew@lunn.ch>
References: <20201031004958.1059797-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/smsc/smc911x.c: In function ‘smc911x_phy_interrupt’:
drivers/net/ethernet/smsc/smc911x.c:976:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
  976 |  int status;

A comment indicates the status needs to be read from the PHY,
otherwise bad things happen. But due to the macro magic, it is hard to
perform the read without assigning it to a variable. So add
_always_unused attribute to status to tell the compiler we don't
expect to use the value.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 01069dfaf75c..8f748a0c057e 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -879,7 +879,7 @@ static void smc911x_phy_configure(struct work_struct *work)
 	int phyaddr = lp->mii.phy_id;
 	int my_phy_caps; /* My PHY capabilities */
 	int my_ad_caps; /* My Advertised capabilities */
-	int status;
+	int status __always_unused;
 	unsigned long flags;
 
 	DBG(SMC_DEBUG_FUNC, dev, "--> %s()\n", __func__);
@@ -973,7 +973,7 @@ static void smc911x_phy_interrupt(struct net_device *dev)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	int phyaddr = lp->mii.phy_id;
-	int status;
+	int status __always_unused;
 
 	DBG(SMC_DEBUG_FUNC, dev, "--> %s\n", __func__);
 
-- 
2.28.0

