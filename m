Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780FF18EB1D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCVRuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:50:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44204 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCVRue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:50:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id 142so694929pgf.11;
        Sun, 22 Mar 2020 10:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AymXtp3nG2LLyQijF0AdQUTMbx+e63yTlaZBg9wNr3E=;
        b=IlEFI136z2Ku169Qafi1L04lNH2PtWbJTwkZVbsZIH5y4xUSSUnY468PQp+D6aIJ73
         HIH4XuPjOJ5ZYRDfLgnzR2fJfVLVcjM7B0Hk0B5DcmojpC2qnaBhFSHbd+M7ilNoiU+a
         VqPMI5HZHFugtDQF9TyN6mlczdpxlI1xRTxdJzXNaf03HwPWNHalBJs3h1uBo2QQEcpr
         ydD88vMRIOCDkYFu53YPaoyYBDvpumsFqf7ue7wzeAtREUsps/XCYgSEIBbqpJqYUeTB
         Bp4HjJdHldmCms0+4I08eDqRldrPUuUzdJPzlhFprC7YoqpVQLgdVzdGkgSl91F8538z
         uVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AymXtp3nG2LLyQijF0AdQUTMbx+e63yTlaZBg9wNr3E=;
        b=qSa4WkxywL+AvxAcR6NQgROtPd/h18oPZkQ3+tR3bYrl3sdjpbtH+h2DiV0Qk5Gp5V
         fZb0sBLHwnuvFzF8hV9rBDk5AoUExjG+M2ZjN0YrdRxpxInL8nrrZh494ScXpkjQXmKm
         e8320WtKqQEA3jeIRDZK3jAl24vIAN5ZtMSiJV5lWJwnkazqo2u+Ik+8WoWi0gBaWiN1
         NabkZdgluhs64Wtsp3gII8qZ7fvnI3hIcJo96p8DvxO9xh8hYN/+raa+bvXn+4/EWmtd
         AKr9cuE5lbRYAPdXuuPHGFd89Lcju3klg21neDqVWIwkEouCWFaFdlNI2WY8Z22NVITY
         fUNg==
X-Gm-Message-State: ANhLgQ1ZCX8BOqurTAg5t/u6py5sPwnbEOHvn0VAdgC5asfP/nCcQFdG
        8z3ZNXnoDKpk9OmoeR+syJ0=
X-Google-Smtp-Source: ADFU+vubfSt1fEHY9S2nQ7rDmb5y7eWgE6gS4SDOOl5P/pjQymmoxGN0DZN8GGvtnTLoleWBYfWKJg==
X-Received: by 2002:aa7:99c8:: with SMTP id v8mr19918083pfi.151.1584899433441;
        Sun, 22 Mar 2020 10:50:33 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id c8sm11594453pfj.108.2020.03.22.10.50.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:50:33 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 10/10] net: phy: tja11xx: use phy_read_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 01:49:43 +0800
Message-Id: <20200322174943.26332-11-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322174943.26332-1-zhengdejin5@gmail.com>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify tja11xx_check() function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v4 -> v5:
	- no changed.
v3 -> v4:
	- add this patch by Andrew's suggestion. Thanks Andrew!

 drivers/net/phy/nxp-tja11xx.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index b705d0bd798b..32ef32a4af3c 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -72,20 +72,10 @@ static struct tja11xx_phy_stats tja11xx_hw_stats[] = {
 
 static int tja11xx_check(struct phy_device *phydev, u8 reg, u16 mask, u16 set)
 {
-	int i, ret;
-
-	for (i = 0; i < 200; i++) {
-		ret = phy_read(phydev, reg);
-		if (ret < 0)
-			return ret;
-
-		if ((ret & mask) == set)
-			return 0;
-
-		usleep_range(100, 150);
-	}
+	int val;
 
-	return -ETIMEDOUT;
+	return phy_read_poll_timeout(phydev, reg, val, (val & mask) == set,
+				     150, 30000);
 }
 
 static int phy_modify_check(struct phy_device *phydev, u8 reg,
-- 
2.25.0

