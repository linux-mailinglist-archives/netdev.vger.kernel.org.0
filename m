Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 923F618E61B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgCVCtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:49:41 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40712 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgCVCti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:49:38 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so4297686plk.7;
        Sat, 21 Mar 2020 19:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vsYdU7rh2RiW9uB6cmSa7Aol56BWlbGP1JB/9O4K9os=;
        b=Gy+CDJfgDqGXn0dlY+EV/zR7bqeOmMdxNPPyVrxJz8Nx67QoILGtuXu/tmjaF/x5Uh
         Bd1jLkNHUcqGBP8oiivNPXfVGqKl9ky3kb4qWq83lRHcPdPjU/K5OYLZLhk4WCGsQNJi
         5BuEjW52NPLOrYQUurACb6G74Hk7Hs22qp2sNB5318GkXDCtnSXuQPEh4FwUh8Zj0K5o
         hJ1ixGrfr9bq2gWPbUiyLOq89AHv2B+5ejcgCzYYJt2LL0Eh0uhcadk9pUCArQC/Ug1G
         PF+Vcbr6pC20pWa/I04Z1gLs2voAvLF0ukoC2SxmwYHtGHTt43NbIWZOx+7uOzvArj8y
         +eYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vsYdU7rh2RiW9uB6cmSa7Aol56BWlbGP1JB/9O4K9os=;
        b=p5FUQln3W8L3IlIJPwxKvrnJAihCFS+ZsZZCng9Spu793xpmKtLX+VL2532e6l6nmz
         hmrduX/ibjc5947Nqll4OIEC0ImAZyOqJo5WLH7DmBzUdmqAZ0If0E/HC+/TKAHfgmhY
         Ry0r2TUSinTESRoI0TCag+hhOOnYZTZROJwYG1sizeikzLl9KPQq4HuegDb2yk6dPPkG
         NEAGjSnIpaaGrlGd9VvEMn7W1fze89YkE4qc1HphW/JBYrMSSbrn4lPmhC0l9fuwb+o/
         OOFGFxGeO39T0+jkZ+Zx4cWa8IUBm7qcPMYaB02uMAgvzfRbfzVIW7abGkqDFKk5jBMI
         QpAA==
X-Gm-Message-State: ANhLgQ2rGXQ2FD7dQ/YZrJoYyornGDZcuCYeQlFFSHb1c62XME6KM8HP
        KxHWT0jkHErkUzI9ICbtC60=
X-Google-Smtp-Source: ADFU+vshsiv5OohaPyJbaqK+WpIIEDduknJC1uwAIANgWLUXLVZeTPjZz+V95B/a4xqLi8hCnA7I0A==
X-Received: by 2002:a17:90a:928c:: with SMTP id n12mr17983736pjo.45.1584845377433;
        Sat, 21 Mar 2020 19:49:37 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id u129sm9451597pfb.101.2020.03.21.19.49.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:49:37 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 4/7] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 10:48:31 +0800
Message-Id: <20200322024834.31402-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322024834.31402-1-zhengdejin5@gmail.com>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify the code in bcm84881_wait_init() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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

