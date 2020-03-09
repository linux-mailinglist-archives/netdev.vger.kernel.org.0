Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA817E04F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 13:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCIMc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 08:32:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:35512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCIMc6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 08:32:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 36E61ACD6;
        Mon,  9 Mar 2020 12:32:56 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Ralf Baechle <ralf@linux-mips.org>, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: sgi: ioc3-eth: Remove phy workaround
Date:   Mon,  9 Mar 2020 13:32:40 +0100
Message-Id: <20200309123240.15035-1-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a8d0f11ee50d ("MIPS: SGI-IP27: Enable ethernet phy on second
Origin 200 module") fixes the root cause of not detected PHYs.
Therefore the workaround can go away now.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index db6b2988e632..7305e8e86c51 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -582,40 +582,23 @@ static void ioc3_timer(struct timer_list *t)
 
 /* Try to find a PHY.  There is no apparent relation between the MII addresses
  * in the SGI documentation and what we find in reality, so we simply probe
- * for the PHY.  It seems IOC3 PHYs usually live on address 31.  One of my
- * onboard IOC3s has the special oddity that probing doesn't seem to find it
- * yet the interface seems to work fine, so if probing fails we for now will
- * simply default to PHY 31 instead of bailing out.
+ * for the PHY.
  */
 static int ioc3_mii_init(struct ioc3_private *ip)
 {
-	int ioc3_phy_workaround = 1;
-	int i, found = 0, res = 0;
 	u16 word;
+	int i;
 
 	for (i = 0; i < 32; i++) {
 		word = ioc3_mdio_read(ip->mii.dev, i, MII_PHYSID1);
 
 		if (word != 0xffff && word != 0x0000) {
-			found = 1;
-			break;			/* Found a PHY		*/
+			ip->mii.phy_id = i;
+			return 0;
 		}
 	}
-
-	if (!found) {
-		if (ioc3_phy_workaround) {
-			i = 31;
-		} else {
-			ip->mii.phy_id = -1;
-			res = -ENODEV;
-			goto out;
-		}
-	}
-
-	ip->mii.phy_id = i;
-
-out:
-	return res;
+	ip->mii.phy_id = -1;
+	return -ENODEV;
 }
 
 static void ioc3_mii_start(struct ioc3_private *ip)
-- 
2.25.0

