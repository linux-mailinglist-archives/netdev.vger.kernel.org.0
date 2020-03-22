Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5878418E732
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCVG4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:21 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39300 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgCVG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:20 -0400
Received: by mail-pf1-f196.google.com with SMTP id d25so5743791pfn.6;
        Sat, 21 Mar 2020 23:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w7dg5mwf5hBLgGL0WYd3zbQSc32Vl1MfolHl5YvY8Pc=;
        b=nvj8MmsOGDqEeB4HLneG64ApzRU2R0LlfZrOCjWymsIpiF5X6XrccrAODIpOeY2Ohf
         V533OFe401bpd8l+/Gt5DpvT3NE+jVTWMO/6nR9MnHgAbI/DzDCcuz2sxUEzOGvRUCWI
         FriPq76l03pUn+rBfkupcUioRbsHsg51nDukM8+g60O37P2Thu4CqJoLdugpYhUm6IcU
         QmlKn9Kz54aKa8V5Fga63VWM21bLSObo1A+CGlxMyipyyWQDU4+3QsNR5lwkwUIJdaU7
         5T60wwPlbTaO8c41Ekpk8RwNooFGUkc+l5S+O0g11c3tmIF3Y875ezKwj1/jZD95oEOY
         7CfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w7dg5mwf5hBLgGL0WYd3zbQSc32Vl1MfolHl5YvY8Pc=;
        b=EHPpfdMAGPb4sd0l4+lnzdzSu82mSxccwVQ/XtiTLevUD0NBfNfz5n6Hfs/xoNO/PW
         d9YvEDXtfl4kEN2xQSoV38XJ5Y1YBiY0wR3bIlbq0QIyDJ94mn8tiflmERnHq/uQmrlB
         SldnW3gBfc4B+eZawDuTsaBGBZ7Cs6+P3TWMKE4S7C5A6Qb8gEWbcflwcqUHuo2XWnHk
         lmVjT5h1u4WeZnDAp2zQ5j5M/So6X20rdAO27k+pwGW5GF6r8o7ADIO1tyR9Ifr1y8b0
         0pmETUHW2m9hqEJ2cNc8zfBOSch0C30R91Xa5R9CPdmng3mVNGgBWxAgQRhJlRHv5otw
         AlPw==
X-Gm-Message-State: ANhLgQ1JpJD8PECeKZX2+vwFIKieSjE+XafoEMvnIofqLBcPJIRS+RWo
        VqRs8y3rH7yEjvzVbep+jM4=
X-Google-Smtp-Source: ADFU+vtU7uU1m6IY6PWZoJHIjgaCRReXZ0EXb3Mt5sRMpOpmxljVCYpv2wHUTh8SNSR0E2sCp6DFZg==
X-Received: by 2002:a63:b34d:: with SMTP id x13mr16541196pgt.317.1584860179160;
        Sat, 21 Mar 2020 23:56:19 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id 189sm9930789pfw.203.2020.03.21.23.56.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:18 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 4/9] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 14:55:50 +0800
Message-Id: <20200322065555.17742-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify bcm84881_wait_init() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v3 -> v4:
	- no changed
v2 -> v3:
	- adapt to it after modifying the parameter order of the
	  newly added function
v1 -> v2:
	- remove the handle of phy_read_mmd's return error.

 drivers/net/phy/bcm84881.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 14d55a77eb28..b70be775909c 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -22,30 +22,11 @@ enum {
 
 static int bcm84881_wait_init(struct phy_device *phydev)
 {
-	unsigned int tries = 20;
-	int ret, val;
-
-	do {
-		val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1);
-		if (val < 0) {
-			ret = val;
-			break;
-		}
-		if (!(val & MDIO_CTRL1_RESET)) {
-			ret = 0;
-			break;
-		}
-		if (!--tries) {
-			ret = -ETIMEDOUT;
-			break;
-		}
-		msleep(100);
-	} while (1);
+	int val;
 
-	if (ret)
-		phydev_err(phydev, "%s failed: %d\n", __func__, ret);
-
-	return ret;
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1,
+					 val, !(val & MDIO_CTRL1_RESET),
+					 100000, 2000000);
 }
 
 static int bcm84881_config_init(struct phy_device *phydev)
-- 
2.25.0

