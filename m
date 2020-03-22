Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8ADF18E620
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 03:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgCVCtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 22:49:53 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32892 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbgCVCtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 22:49:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17so4683599pgo.0;
        Sat, 21 Mar 2020 19:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Us52jAlL+55uuDXphB68RLJ2IVOdVneyxLYuT22jhHI=;
        b=XGGjj6FL+oA1WSqtGzwFK2Ee4MI+/xyDCgCdYJsfPXCRor8NB6BD2+aV9f0/1p9Y7L
         u2iDdBEUv0bllxYh8Hn4kv2NiO3R3LSq/ZPaEajxEkY3vksUDIeePlLuVXp4EsQPZPl3
         gHKn6hy+dD7sVAMwdeKKpCq36OcCBwZVJO6BHEYy4XP5K/QEbJSYjSZldOMuq5pPSruq
         gVoEciYAliPE9zNaGNDBOupnXZKxpP7cCUDDzW8Jz/M+oZauZAU43EGIYMpMk2lP0TTk
         FdMsOgbKfJ8P83LhTErmbD2w/PNpktiXLy/3VEU0RxN4v04XWUCcRCFhSp0ViPs16Byk
         qZWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Us52jAlL+55uuDXphB68RLJ2IVOdVneyxLYuT22jhHI=;
        b=AULu17efb/wNU0KuV9Gksgw8nWzBZ2PPlCMoltWVjezeAUjVG4a0uMylMV4/sZ+FcD
         pVezTGkGU3Be+IP+xCgjskz+LCjwNOVpDPKsqIS/0sqRlrxg2I8xKmnYi3U72ckBmqXl
         5ZhCZfxpMstZxqKdT2GNPt2GJHowiHOuB2pKsuQi/2RcDEV6ri6K7TjgmplTw1MUY7zQ
         gwupqmWMu+x3rpObMrndC2cKyjEt2gDfBGHlJcc3P5M5lWXY8kreeuJS7gD8EpSPnODj
         DG572AgRua6nyE4Z6394ckO33YEeZ1JX0s0tpIRxBha4kBRXfO8ANYCRbReh43jp6zDY
         Sfwg==
X-Gm-Message-State: ANhLgQ1WJhNtqaRLYOvhB8HyjmlmmaTC95cBRZNV6aDh+cHn+4t2Jtmp
        i/bAzIcjwZXC90bB+rvPcbQlv5Hq
X-Google-Smtp-Source: ADFU+vtqyrj9MH8Z+rM1OT1Emb8ZgxbaZC7FZ8IaH67o8I/Stm2UcRCYBcoj2c+2XCNOyGOKhi2cnA==
X-Received: by 2002:a63:ba5d:: with SMTP id l29mr15530077pgu.67.1584845389316;
        Sat, 21 Mar 2020 19:49:49 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id u3sm9598372pfb.36.2020.03.21.19.49.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 19:49:48 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v3 7/7] net: phy: use phy_read_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 10:48:34 +0800
Message-Id: <20200322024834.31402-8-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322024834.31402-1-zhengdejin5@gmail.com>
References: <20200322024834.31402-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify the code in phy_poll_reset() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v2 -> v3:
	- adapt to it after modifying the parameter order of the
	  newly added function
v1 -> v2:
	- remove the handle of phy_read()'s return error.

 drivers/net/phy/phy_device.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a585faf8b844..cfe7aae35084 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1059,23 +1059,15 @@ EXPORT_SYMBOL(phy_disconnect);
 static int phy_poll_reset(struct phy_device *phydev)
 {
 	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
-	unsigned int retries = 12;
-	int ret;
-
-	do {
-		msleep(50);
-		ret = phy_read(phydev, MII_BMCR);
-		if (ret < 0)
-			return ret;
-	} while (ret & BMCR_RESET && --retries);
-	if (ret & BMCR_RESET)
-		return -ETIMEDOUT;
+	int ret, val;
 
+	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
+				    50000, 600000);
 	/* Some chips (smsc911x) may still need up to another 1ms after the
 	 * BMCR_RESET bit is cleared before they are usable.
 	 */
 	msleep(1);
-	return 0;
+	return ret;
 }
 
 int phy_init_hw(struct phy_device *phydev)
-- 
2.25.0

