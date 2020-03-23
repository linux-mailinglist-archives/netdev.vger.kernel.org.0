Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFA7518F834
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgCWPG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40879 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:59 -0400
Received: by mail-pf1-f194.google.com with SMTP id l184so7607044pfl.7;
        Mon, 23 Mar 2020 08:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k5BQoe9jbS+ljT5BZobJtV36SBznrFc/2buMjlXPw5c=;
        b=cRZH7sAhHokoxsvtvs2eVxXLrcYhXL4TMxzPQheG0iPn3I3c1eFba4r/J8kAeZXJ5m
         brh2yNLhaaxmRO675+htft3BgAv4JyYgoH1kf2dDqCnftafqLW42JDsGlkRuqiY8IDNV
         ECzsWpeD7Hb7rPnyd1l4jj5X0oYyjABv9beB0OEdkbzv/6nz95ukx8b6Zdy5IPGqXeyo
         fRjCuQNGrUQb6iVc+pqVmXiasZeAYXcYY7K6Y9rIRMQe2dqMTghKQvtxxswo789+ooGO
         IlYFnocK0E2rSecHKbuJU9KJExNRNJaW8VfKTscwh9e/ubbd9PbkTeeqfzDHISdEuh01
         qyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k5BQoe9jbS+ljT5BZobJtV36SBznrFc/2buMjlXPw5c=;
        b=itgzkP+q2cTPHM7aO9YtnDRuSzNA2imzKaSnZHdQTkVaVvsMWLpwIGncefBxCB3KZL
         YGAySQUSBuktqNZhwANVxxdbYy8Cu7Oda+KL5lxOZzzACL1Vydj72RvzX2t1cx0iEb6R
         LVtdCltcFQuXS/u4npkz7WwQvqUwfVvjPJV684LfxeW3uZcHwvrTfYl+NgyC1Jv+smEg
         RSp5GrMBH+GgoubReAE21Jm5oWyGnVVqQB50GW4BSbTh4MLRAN/TeAHGVincHXSXLMuq
         gSs8rBrKkiVm/YrNyqvBWWGQsMS9j58zB/+ZXgXBZ1V2xYHS+NSriBHZLBD3IZ/acwEo
         JKMA==
X-Gm-Message-State: ANhLgQ13a0gGEhX2Urp6rPmHyDOlq2hdpMwCAvJpTF1AVpljvrx7Dcej
        Ja0bQ11EwYfmo4a5SB9ZKsU=
X-Google-Smtp-Source: ADFU+vsV9wpdv2b4IOp7n+XGMj5YycsMJQZ5FCkD2iV+SZ1kJUZrQL06pe1MM/fVRR9r1jK/gbFOTg==
X-Received: by 2002:a63:cd12:: with SMTP id i18mr21301071pgg.98.1584976017540;
        Mon, 23 Mar 2020 08:06:57 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id a13sm12065399pgi.77.2020.03.23.08.06.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:57 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 06/10] net: phy: marvell10g: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 23:05:56 +0800
Message-Id: <20200323150600.21382-7-zhengdejin5@gmail.com>
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
simplify mv3310_reset() function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v6 -> v7:
	- adapt to a newly added parameter sleep_before_read.
v5 -> v6:
	- no changed.
v4 -> v5:
	- add msleep() to before call phy_read_mmd_poll_timeout()
	  to keep the code more similar.
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!


 drivers/net/phy/marvell10g.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7e05b92504f0..7621badae64d 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -241,22 +241,17 @@ static int mv3310_power_up(struct phy_device *phydev)
 
 static int mv3310_reset(struct phy_device *phydev, u32 unit)
 {
-	int retries, val, err;
+	int val, err;
 
 	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
 			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
 	if (err < 0)
 		return err;
 
-	retries = 20;
-	do {
-		msleep(5);
-		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
-		if (val < 0)
-			return val;
-	} while (val & MDIO_CTRL1_RESET && --retries);
-
-	return val & MDIO_CTRL1_RESET ? -ETIMEDOUT : 0;
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_PCS,
+					 unit + MDIO_CTRL1, val,
+					 !(val & MDIO_CTRL1_RESET),
+					 5000, 100000, true);
 }
 
 static int mv3310_get_edpd(struct phy_device *phydev, u16 *edpd)
-- 
2.25.0

