Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE518F830
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCWPGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36964 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id h72so5401518pfe.4;
        Mon, 23 Mar 2020 08:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aczxO6GwDiorwLoDN3fHadbtsX816dfm9JlNEnnSNQE=;
        b=dsT00cSS6aNi0DqhxCiXWUaVLOie4MnL/FkV6GzSP+zrMfIJBRCMJ6caPEqussT5LM
         rNc4ROPzbrQK19S4O8Ff2sJHpzeEB0rsharmB/ba/JEUPFqETGnbBTU5Hmf76iXsdNvJ
         ZhtGGzQBbEduKjFdUkRIPaNDrBtQh8d+jPEAuJhUpkksYmVLVCcEleHny1fwOCKSrccA
         1KEUXgxBII10ZA3yCfmVn4BHQqoBZiDORmuS+IbhIgqII1CkzZl1linPSXi3Sqs4mUT9
         rx0Ld206IooBDzumlITrqkik0EUmF9MGI+Ssb1xoagPZK0I0OCgkoUGigczQIwOuJgI4
         dRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aczxO6GwDiorwLoDN3fHadbtsX816dfm9JlNEnnSNQE=;
        b=scWa1HAFrFhdSacRJv4BsvrhzVhf01GjfB6mZjJk/f07jn0u2NoM0Aap4yvxWo8WK7
         XGuLF41aBgmwCoOojHbcyvRTkZbCXWuaRy1BSne9upeBdG19CSBZZ7lcm3OxP4tOVZ/4
         2qmI2A3rrf2TpWOGPxv7Ej3GD3vXqmr6FiTwVXlMLqwAWKhnDROLm7dNz4V3/N7tLOCa
         cZgy0zVRpOr1C1MamNvgC8dpBo1YpYMWRytLkFHCNlfzLogaApUPYGoTyhVehITVzCKJ
         tnKfORuQIjOlIORirM0lqoQHathSC20eFFOq+rgfDjo+FsdyAiJ8XwU8putDa857DKFT
         4HEA==
X-Gm-Message-State: ANhLgQ35qWumBTwXs0Kqu4bt7hBMxLejPW0qjWG/us6coiuJlBOb+GXV
        BUS3ZKfqhksG+je+YPQO7VU=
X-Google-Smtp-Source: ADFU+vt+X8qOTflBVbj4ub+CmXf6J3C8cr+m3gFZ4w9c8RwXebfDt6u0XLRwAy/cC3zbqRbBbr3Mxw==
X-Received: by 2002:aa7:8d82:: with SMTP id i2mr25503829pfr.179.1584976005502;
        Mon, 23 Mar 2020 08:06:45 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id x15sm13306119pfq.107.2020.03.23.08.06.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:44 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 04/10] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 23:05:54 +0800
Message-Id: <20200323150600.21382-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323150600.21382-1-zhengdejin5@gmail.com>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify bcm84881_wait_init() function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v6 -> v7:
	- adapt to a newly added parameter sleep_before_read.
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
index 14d55a77eb28..3840d2adbbb9 100644
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
+					 100000, 2000000, false);
 }
 
 static int bcm84881_config_init(struct phy_device *phydev)
-- 
2.25.0

