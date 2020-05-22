Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736451DF132
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbgEVVbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:31:13 -0400
Received: from foss.arm.com ([217.140.110.172]:42348 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731157AbgEVVbN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B70541FB;
        Fri, 22 May 2020 14:31:12 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AFFF53F68F;
        Fri, 22 May 2020 14:31:12 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 06/11] net: phy: Hoist no phy detected state
Date:   Fri, 22 May 2020 16:30:54 -0500
Message-Id: <20200522213059.1535892-7-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522213059.1535892-1-jeremy.linton@arm.com>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Default initializing the phy_id to "invalid" allows
us to avoid setting it on the error returns.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/phy/phy_device.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 360c3a72c498..b2cd22d6315c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -742,6 +742,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 	bool c22_present = false;
 	bool valid_id = false;
 
+	*phy_id = 0xffffffff;
 	/* Find first non-zero Devices In package. Device zero is reserved
 	 * for 802.3 c45 complied PHYs, We will ask it for a devices list,
 	 * but later we won't ask for identification from it.
@@ -762,10 +763,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 	}
 
 	/* no reported devices */
-	if (!valid_phy_id(*devs)) {
-		*phy_id = 0xffffffff;
+	if (!valid_phy_id(*devs))
 		return 0;
-	}
 
 	/* Bit 0 doesn't represent a device, it indicates c22 regs presence */
 	c22_present = *devs & BIT(0);
@@ -783,10 +782,9 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
 			valid_id = true;
 	}
 
-	if (!valid_id && c22_present) {
-		*phy_id = 0xffffffff;
+	if (!valid_id && c22_present)
 	        return 0;
-	}
+
 	*phy_id = 0;
 	return 0;
 }
-- 
2.26.2

