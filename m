Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBB58784D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 13:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfHILUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 07:20:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43970 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfHILUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 07:20:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so23312433wru.10;
        Fri, 09 Aug 2019 04:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2TA4E4ioABoApo3cN10r+bj+j/F58l9Z+lpydwND1/A=;
        b=jcxCYjjPC4sqE62z3SxLSdG/ix84v8vX0Z/CRAqbAqNrnccE5dHy3x/TUJGOHBtxfC
         BC7rt9vBcPPhkPEL3ZGRVXESN0hp6wqp2r+s4KhAGEw652ndQklPtePHFTrS4N79bpBE
         UYEpTf5ooI+Z6C/SBQyBemQ+pNoxJGmG13ArTVyh1wtG8gsG01TyCDJD4WLqHwiwMabW
         EZKs+PylXnmAPbOuQJgzWNhODNW2WG1l3REoW/JeVA5XqCrHX/jBAXmS7qxph9wYcXO6
         DbLQZHGbFBK31cQ0yqaBIhugmLg8uWomK6i2s424+eCyEe/Ls7UMneWtlKLY7AeWT297
         dUwA==
X-Gm-Message-State: APjAAAVwaKiw0wMphc4eQ7K+TTl4iSLWDK9fyLP7XTmrmUAz75V2zrMU
        AHCf0+nB+9I2bXVrhm8/sJFX46+TZzdQ8Q==
X-Google-Smtp-Source: APXvYqzMgDe8oAcjmYxs+wCUDunJMXo2Ep3gbIXH69T6o9itmzxiNjv2oqHt+mp890zSOrxC69dTrA==
X-Received: by 2002:adf:e884:: with SMTP id d4mr13902945wrm.99.1565349631718;
        Fri, 09 Aug 2019 04:20:31 -0700 (PDT)
Received: from tfsielt31850.garage.tyco.com ([77.107.218.170])
        by smtp.gmail.com with ESMTPSA id u1sm6018079wml.14.2019.08.09.04.20.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 04:20:30 -0700 (PDT)
From:   =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH v2] net: phy: at803x: stop switching phy delay config needlessly
Date:   Fri,  9 Aug 2019 12:20:25 +0100
Message-Id: <20190809112025.27482-1-git@andred.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809005754.23009-1-git@andred.net>
References: <20190809005754.23009-1-git@andred.net>
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
v2: also remove braces around single lines
---
 drivers/net/phy/at803x.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 222ccd9ecfce..6ad8b1c63c34 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -257,36 +257,20 @@ static int at803x_config_init(struct phy_device *phydev)
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
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
-		/* If RGMII_ID or RGMII_RXID are specified enable RX delay,
-		 * otherwise keep it disabled
-		 */
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
 		ret = at803x_enable_rx_delay(phydev);
-		if (ret < 0)
-			return ret;
-	}
+	else
+		ret = at803x_disable_rx_delay(phydev);
+	if (ret < 0)
+		return ret;
 
 	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
-		/* If RGMII_ID or RGMII_TXID are specified enable TX delay,
-		 * otherwise keep it disabled
-		 */
+	    phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
 		ret = at803x_enable_tx_delay(phydev);
-	}
+	else
+		ret = at803x_disable_tx_delay(phydev);
 
 	return ret;
 }
-- 
2.20.1

