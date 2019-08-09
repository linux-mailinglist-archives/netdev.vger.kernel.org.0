Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E24786F05
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405178AbfHIA6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:58:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51019 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405170AbfHIA6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:58:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so4034440wml.0;
        Thu, 08 Aug 2019 17:57:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dWdYMxAI1ypKnjw8jNgCL8qIFx+wNHVV5igKAhGW5CI=;
        b=Jkb3TAe3w1O84D7gncg5GOV4gZOImhlIzPVP5rDDbxyr4E3yhaXE2TzCugfhdaW5qH
         HoJu0z1y3EUFlqOAx0fN8K8NWpBTRId/VFQMlzDtql/CvHVi7pv/4VuWCUZ+44BbSQ3X
         caw0m9d7H5j08MyzWj1hc4LjSdOdZ5fz7LAy+05Na45l3ou5HQfkxqHRqAWj3G/TsLnr
         CTIdi0EkFTkbWgHWTDhf37ONiz7aAiImt/a6cZ+AiC89jzFs0DorgI3WwDWSi7g7BsT2
         /OSIMFyMUMxuQdFu6Eu3MM06eMnF1kS79wlztr+go9jR4sQe9iO4X6krIzMqGxlLfv24
         tWFQ==
X-Gm-Message-State: APjAAAVy2YY3/eZl9tG99nWJQuTBY1WNgeM57Kue+nRRHKAnXd/X89Mr
        ye9gEH+I9tAttpnW+3gwBu1uaJaEVWDnWQ==
X-Google-Smtp-Source: APXvYqxvNdcPKmYyJqFdDpyD8hN09Lhi/ZxjrIfbE5smap98ue6G7p71s4CzSX2U9BHm+k/iME4x2g==
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr7385931wmh.58.1565312278518;
        Thu, 08 Aug 2019 17:57:58 -0700 (PDT)
Received: from tfsielt31850.garage.tyco.com ([79.97.20.138])
        by smtp.gmail.com with ESMTPSA id x11sm3119393wmi.26.2019.08.08.17.57.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 17:57:57 -0700 (PDT)
From:   =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: phy: at803x: stop switching phy delay config needlessly
Date:   Fri,  9 Aug 2019 01:57:54 +0100
Message-Id: <20190809005754.23009-1-git@andred.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver does a funny dance disabling and re-enabling
RX and/or TX delays. In any of the RGMII-ID modes, it first
disables the delays, just to re-enable them again right
away. This looks like a needless exercise.

Just enable the respective delays when in any of the
relevant 'id' modes, and disable them otherwise.

Also, remove comments which don't add anything that can't be
seen by looking at the code.

Signed-off-by: André Draszik <git@andred.net>
CC: Andrew Lunn <andrew@lunn.ch>
CC: Florian Fainelli <f.fainelli@gmail.com>
CC: Heiner Kallweit <hkallweit1@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
---
 drivers/net/phy/at803x.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 222ccd9ecfce..2ab51f552e92 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -257,35 +257,21 @@ static int at803x_config_init(struct phy_device *phydev)
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
 	 *   value before reset.
-	 *
-	 * So let's first disable the RX and TX delays in PHY and enable
-	 * them based on the mode selected (this also takes care of RGMII
-	 * mode where we expect delays to be disabled)
 	 */
-
-	ret = at803x_disable_rx_delay(phydev);
-	if (ret < 0)
-		return ret;
-	ret = at803x_disable_tx_delay(phydev);
-	if (ret < 0)
-		return ret;
-
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
-		/* If RGMII_ID or RGMII_RXID are specified enable RX delay,
-		 * otherwise keep it disabled
-		 */
 		ret = at803x_enable_rx_delay(phydev);
-		if (ret < 0)
-			return ret;
+	} else {
+		ret = at803x_disable_rx_delay(phydev);
 	}
+	if (ret < 0)
+		return ret;
 
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
 	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
-		/* If RGMII_ID or RGMII_TXID are specified enable TX delay,
-		 * otherwise keep it disabled
-		 */
 		ret = at803x_enable_tx_delay(phydev);
+	} else {
+		ret = at803x_disable_tx_delay(phydev);
 	}
 
 	return ret;
-- 
2.20.1

