Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AB1341E34
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 14:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhCSN3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 09:29:40 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29461 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhCSN30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 09:29:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616160566; x=1647696566;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=UYnJMQ6RYtMBvwm1a3yqun4V8k9TX7I+LIQhHjKph1A=;
  b=AcfvKiF0LzD+N8OuH83rK2h8iUPKbgQFdJYepaXIxjnMP31wk7gIrLdd
   LA9FfafKfgLRAl2ZMp8Lu6oK+V7SiiGb6XhFEnfqy3psV3tIt17zdPVO7
   6UPbUQYKsAvuRB9rRqn+I8BlkeV8AhWMPyUyDc8b4QFG6AqKRQ5Sepjy1
   KoAA2UDweMTKnD+fhoREZtlBAcuX9Cyq/QumGbuN6rtNwzRQ1J09d0u+e
   ffLrzN0wqujHyH9Oyxl2nPAgHpieQfPjoMmuZ0ysrpdfwDTj/CQgcm3e+
   mHcXwN78ftsLq57ZIjUePOqIIB/X36oIoQDp6JfeAGG9DrQuUl5h/AKIP
   g==;
IronPort-SDR: o5Gn9lTGDdn7yG3/J+1uPIMSLyZF0zfmP2g7QQnlJ6rzJODcG2+47fEcCAbgMzCDJuwN2MywPh
 qJncJal4ZIKHZ9OGebyPgma23CU7zwokFmZvwAjKBbqFbVEjPGd8q8iVAtzTOx/uL6TAHH4KwI
 pNbBJJ8Ie1PXghNa4J60GlfaAj1kMKvkry58jRef/9bq4xFGVxnqT6Yb6G5cMfr+2FsyPnWk4p
 wN9UEKhp88JnHXgNTMOxwsYspQW4kqrNARyzFuR54f/SQvmlQYt8RjtOyK+AkxDoTX5d9uuXZT
 Jlk=
X-IronPort-AV: E=Sophos;i="5.81,261,1610434800"; 
   d="scan'208";a="110624544"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Mar 2021 06:29:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 06:29:19 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 19 Mar 2021 06:29:16 -0700
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
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 1/3] net: phy: mscc: Applying LCPLL reset to VSC8584
Date:   Fri, 19 Mar 2021 14:29:03 +0100
Message-ID: <20210319132905.9846-2-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
References: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
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

