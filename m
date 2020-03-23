Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7579618EE45
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgCWC5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:50 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42500 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:50 -0400
Received: by mail-pg1-f196.google.com with SMTP id h8so6438194pgs.9;
        Sun, 22 Mar 2020 19:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2RzrjnjlFsoE4gKq8dQtt+6wyLVwzt/6FPHXx4r1hZA=;
        b=nzeGKEcWF80+UA+29o2nRKvtsVKO7NLrB2Fs8rln3kn/f9OuoDarpGeRXZhqQXWHYZ
         FlM0huwSRiS9tNjMmd9kFCdLKBD/85rZynKRWnVgzZdOrUI8Dc4bvvnz59BUuCyNZ5xA
         5FX964y6HwMDCRKZyI+0oZ/iMo/iXuMiSiKNKdmfPxUlrG8YoVFq+yYtjN8Lo0xaewjG
         ElDJEH1fVcLTcL8+0qqZ755FZKVFHWlghv8FczyHHjX0DjVEtlwb85EGwD6t06vHXs+Y
         Rhup4Uu7yVmNBFkqyTxlX84/dSqHIUi3uIR9xRYHeOAa/mJmMqoMAPXeIVai6JkXXMys
         2bWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2RzrjnjlFsoE4gKq8dQtt+6wyLVwzt/6FPHXx4r1hZA=;
        b=N0sLGz27LIbbdOwWOvDKsbzJiGAHc6uyLIlfEjRfzJXL8u8BLuVaEcPEzZDhQ0KRsv
         j4GoCgTKxKK+c9mdUtKFp56ZhmHYdyCDq/clRb+2uSNOmv1a8OWg1LpOrRsEZ6rEZm+R
         bjJRcQFeNXWHUwkabQZHh3c+7vf9EV+spiJ1GHHlIbAK7hp1MT5DdBKZMN8HJYje2I7B
         qoV9vHQzM4Zde1Wvg6ORbuR0GOJeEC3a1HBNspd85wEBo8qLI2CqH/cL09NZPGnFAe7e
         Yf6nUiLzBYCEOUH51iUvtrWJaS0MqgDauylyh+UkJmkhe7Z+DIkLxC8kVUIAAjC8EXBH
         ifSA==
X-Gm-Message-State: ANhLgQ3BbFlag7VAenpWmdwWkxkB9WFMqX4O10i6EfYsMx5BjskzoLT7
        3BWiZ6rfdW9QVekydImBnXI=
X-Google-Smtp-Source: ADFU+vtcDRozhnR3XI1zbXILvCGDDVn8CYx431KkNfHnlOhfzRnvMYK0f0sW9XeYw1IzeFXJ5Nkbmg==
X-Received: by 2002:aa7:94a5:: with SMTP id a5mr22524685pfl.67.1584932268481;
        Sun, 22 Mar 2020 19:57:48 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id z17sm11762499pff.12.2020.03.22.19.57.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:48 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 09/10] net: phy: smsc: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 10:56:32 +0800
Message-Id: <20200323025633.6069-10-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify lan87xx_read_status() function.

it should be add msleep(10) before call phy_read_poll_timeout()
to keep the code more similar, but it will report that warning, so
modify it to msleep(20).

./scripts/checkpatch.pl
v5-0009-net-phy-smsc-use-phy_read_poll_timeout-to-simplif.patch
WARNING: msleep < 20ms can sleep for up to 20ms; see Documentation/timers/timers-howto.rst
#42: FILE: drivers/net/phy/smsc.c:126:
+		msleep(10);

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v5 -> v6:
	- no changed.
v4 -> v5:
	- add msleep before phy_read_poll_timeout() to keep the
	  code more similar
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!

 drivers/net/phy/smsc.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index b73298250793..f888523086ed 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -112,8 +112,6 @@ static int lan87xx_read_status(struct phy_device *phydev)
 	int err = genphy_read_status(phydev);
 
 	if (!phydev->link && priv->energy_enable) {
-		int i;
-
 		/* Disable EDPD to wake up PHY */
 		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
@@ -125,15 +123,12 @@ static int lan87xx_read_status(struct phy_device *phydev)
 			return rc;
 
 		/* Wait max 640 ms to detect energy */
-		for (i = 0; i < 64; i++) {
-			/* Sleep to allow link test pulses to be sent */
-			msleep(10);
-			rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-			if (rc < 0)
-				return rc;
-			if (rc & MII_LAN83C185_ENERGYON)
-				break;
-		}
+		msleep(20);
+		phy_read_poll_timeout(phydev, MII_LAN83C185_CTRL_STATUS, rc,
+				      rc & MII_LAN83C185_ENERGYON, 10000,
+				      620000);
+		if (rc < 0)
+			return rc;
 
 		/* Re-enable EDPD */
 		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
-- 
2.25.0

