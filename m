Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD4113E54
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbfLEJkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 04:40:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:49978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728629AbfLEJkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 04:40:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38DBEB320;
        Thu,  5 Dec 2019 09:40:21 +0000 (UTC)
From:   Mian Yousaf Kaukab <ykaukab@suse.de>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tharvey@gateworks.com, davem@davemloft.net, rric@kernel.org,
        sgoutham@cavium.com, sergei.shtylyov@cogentembedded.com,
        andrew@lunn.ch, Mian Yousaf Kaukab <ykaukab@suse.de>
Subject: [PATCH net v2] net: thunderx: start phy before starting autonegotiation
Date:   Thu,  5 Dec 2019 10:41:16 +0100
Message-Id: <20191205094116.4904-1-ykaukab@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 2b3e88ea6528 ("net: phy: improve phy state checking")
phy_start_aneg() expects phy state to be >= PHY_UP. Call phy_start()
before calling phy_start_aneg() during probe so that autonegotiation
is initiated.

As phy_start() takes care of calling phy_start_aneg(), drop the explicit
call to phy_start_aneg().

Network fails without this patch on Octeon TX.

Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
---
v2:
-Add fixes tag and net tree as suggested by Andrew Lunn
v1:
-Remove call to phy_start_aneg() as suggested by Andrew Lunn
-Fix reference to patch in change log as suggested by Sergei Shtylyov

 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index 1e09fdb63c4f..c4f6ec0cd183 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1115,7 +1115,7 @@ static int bgx_lmac_enable(struct bgx *bgx, u8 lmacid)
 				       phy_interface_mode(lmac->lmac_type)))
 			return -ENODEV;
 
-		phy_start_aneg(lmac->phydev);
+		phy_start(lmac->phydev);
 		return 0;
 	}
 
-- 
2.16.4

