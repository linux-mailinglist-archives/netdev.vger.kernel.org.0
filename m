Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8473405A7
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 13:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCRMja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 08:39:30 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45109 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhCRMjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 08:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616071150; x=1647607150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=UYnJMQ6RYtMBvwm1a3yqun4V8k9TX7I+LIQhHjKph1A=;
  b=uKXhicQLgRr+QZMTcFSyAf8fjYeNVXoiCcgjFt2t2ebsbGNZUFu9jmk+
   3RajYiGZ9LrC8zY3/xc+io+IbMi/EZTZ2lRx/k1gH9TdAaLCBrB1Ec3zQ
   rl8QH/dCEKJ2+rOv0byzFRfemZ1qxwoYCYgfXuCcFQicHxFzQNG7939/N
   x6VNC7nuf7+SicFg7XfPQNcnoh22BnLW5dZC6wszug3oSbALQO1fpGq9S
   vcTfnpZ1YNllNNN22S69XgARGvf3Dy2nIw4QyLs5sBjzcxX8uuXY441ox
   cUh/oTTSuClw7JCUnsIXAipY31CE2b6Y4jfKuUYBPPpLxBAXWD3TYe5gp
   g==;
IronPort-SDR: XZS1MXVotDYa40YKmlX+SRzEhnuUlQA8aW6YRDm5u02dmJ09c6b1cqLxRFUQfw5Xta+CkNqtB7
 bYuHXkkBKHiGytvafsxuZiUoPlqAcijfNonRhrlMJmcm/KxcS/rrFiaLJcr+TdpzXdIKDeUamt
 O106SOhk/vyR1hfgWSsi2TfFzPz2ZZkckzu06oMaaCBpSKZIyhSqOThBHg3XYbLIKhDk5zbYsi
 lIq1QaHR0hzT3QHeNNkpvH31vYjWHkb2jkhtbBgY24UzMSV299CvuFO7/m8nucCdoWggr5Bvfk
 ymU=
X-IronPort-AV: E=Sophos;i="5.81,258,1610434800"; 
   d="scan'208";a="48023907"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2021 05:39:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 05:39:09 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 18 Mar 2021 05:39:06 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v1 1/3] net: phy: mscc: Applying LCPLL reset to VSC8584
Date:   Thu, 18 Mar 2021 13:38:49 +0100
Message-ID: <20210318123851.10324-2-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
References: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduced LCPLL reset in
commit d15e08d9fb82 ("net: phy: mscc: adding LCPLL reset to VSC8514").
Now applying this reset to the VSC8584 phy familiy.

Fixes: a5afc1678044a ("net: phy: mscc: add support for VSC8584 PHYY.")
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/mscc/mscc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 3a7705228ed5..2c2a3424dcc1 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1362,6 +1362,12 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 	u16 crc, reg;
 	int ret;
 
+	ret = vsc8584_pll5g_reset(phydev);
+	if (ret < 0) {
+		dev_err(dev, "failed LCPLL reset, ret: %d\n", ret);
+		return ret;
+	}
+
 	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
 	/* all writes below are broadcasted to all PHYs in the same package */
-- 
2.17.1

