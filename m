Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576AD18EE3B
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgCWC5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:19 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51293 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:18 -0400
Received: by mail-pj1-f68.google.com with SMTP id hg10so5492756pjb.1;
        Sun, 22 Mar 2020 19:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VjOHBjGR87qpp8CU/Kgadc3V2zHMTdTnD2NkZSmmj1U=;
        b=aB5STMVSrMl9v8bsz0ISkUT1OeUIH7aM0kLNh+KewnpNdek4laPhhFz3RyQJEXY2Ru
         6DyyRvedSL7Woq0OnIgLvklaCHEI9K9wLWFr1IxfdqiMKgmOx5++rTL1bKGACBqOOg7m
         sUOUWKbpMOdFGFBc4z3H4p8MUuIlIif7yYDnreyjlDOuLw1kGxSqJshF1ykOobys5H8h
         gRLyEOi/tiX8+nZxPxt61LuArFMFfse4oqeXiCJp7nTVjjkZjmHfhRxVBwSM0cLM0z+y
         +UBV9VS12hdb0g/+ont05OsUm62XYoNP+q3OluCubGeEtduW2my39vDRKJcmJ6mH3695
         ukdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VjOHBjGR87qpp8CU/Kgadc3V2zHMTdTnD2NkZSmmj1U=;
        b=uakUSFcmzHyXmmeUPXI6igNbYaTEF0+zEJnOXFzU1wsdw8/Zx2rFnBGsBiSMvaoJjq
         V94GpSDTlELhh4QgqWZF+WFcQ0UOFBcrHACF7KON3W9lJgYiNTYkF6vvI9lV5qUTytyL
         2fOplMZMVplOvInR5zDZOS5Dty/dPuhfw83z4cVF2v9iqz1hXxIE3wk2Mb7ggjEb8oWP
         72by8LBmEeDrWJOKpdU5aHwrvYmd7GU8GRXd+mBelC/AlxSGVqh0yIXmrEFkftVY4HHq
         X13n/edutayfi11CsF2eS9n3nTkoz08rCQWx2ngFoMyKjD1YwtYCBzoWHzObNK18VCcX
         EGqg==
X-Gm-Message-State: ANhLgQ1V+bEyk+XrxrJZOwC3gTv9ZhzSF7PeIQz1OxRfWFmS+vPuF3eX
        HWibH0Crh/jvx0BcrMkCrsg=
X-Google-Smtp-Source: ADFU+vtw9q2PV1+llLtO84n4rnZmfPJUVGySxaDhuUhnxp5j+s9xPDk6ftqWHWoCPiyFEqPh3LsuCg==
X-Received: by 2002:a17:90a:30c3:: with SMTP id h61mr22771353pjb.18.1584932237770;
        Sun, 22 Mar 2020 19:57:17 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id e4sm10849286pgc.60.2020.03.22.19.57.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:17 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 04/10] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 10:56:27 +0800
Message-Id: <20200323025633.6069-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify bcm84881_wait_init() function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- no changed
v4 -> v5:
	- no changed
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

