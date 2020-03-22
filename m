Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7920B18EB1B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 18:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgCVRuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 13:50:15 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54332 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgCVRuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 13:50:09 -0400
Received: by mail-pj1-f67.google.com with SMTP id np9so5010962pjb.4;
        Sun, 22 Mar 2020 10:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EW5XLK9JrPHqzxs/NVCXKQ0OXP2FtbApwSHVemtiYBc=;
        b=Scc6yoHCUc5Ttdxmq8ORfcZ3QQR97YVqSsWSGI35vQORCr7dzC/8/k0S0O+PzF3Wgk
         NRgLWfbIfLTWhWKFMLWpoGhZKFp4buRqQrHvMSmbcTjUkiq1m3ycPx8PWpjqDyqxrr6S
         BbH85S5DrTpneMigsd6oP4jSgLvRtz64G21PeiU7Liwmv4qfWR7LYnc3mjVGDLKg2QyZ
         yqzWSAC7SXIehzyky8JkvvlUxEfABJVYqRMfP4UprNOb/7q/dLczCm6w1MdHlFPw8xkg
         oDwc2YTY1i1ZIXT4y3+iCTX6AgmPvE2gbU7VPUh8df5eHhvgk79RY0CMs8IhdLQEZwKi
         1V8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EW5XLK9JrPHqzxs/NVCXKQ0OXP2FtbApwSHVemtiYBc=;
        b=RGHxVktoSDT99MhQ6j+pTa/9iiSPXZIuCVjr1N/NxFOJKjNv6OTDNUili9BE15Ymv3
         99DZrUtoDuW3ZKSGU6MoRRxJ3B+TKgID7/3sKY/rhei4Ww7rygjtik8gjoaNzUHSYC4b
         mfQmPjFf5LVneFd7DAzSS2ydd7Qcg1d3XnuPIAnBFYJUy6XRwrFalHyDAKc18UzhGV8H
         TwG5dFeSP3NavYh6i5ScX+fCcHxNkM70Z9FCIRJ6Ss7kfdtlovYzu4YenThJ4ZiL1dzb
         GLr3ocptpRYH9PwQoOyICbmNUpNeemi04CJoDJV1LVV+aiVEpmrNqXTOmK8wkS7tzBCu
         XOpw==
X-Gm-Message-State: ANhLgQ3LuP/CA/ANuRlJ5AdkYg10bOt0ISz4km/mjxvK8zM89nMasXck
        bx4TsFlp73+JkFvHwyWFo58=
X-Google-Smtp-Source: ADFU+vt6phtugyviM9LoZ112CZOqpzA/IfsyBe5FY8nK/4NTIvqci95/BX6rOYgi4+B7yFs9HDOHpQ==
X-Received: by 2002:a17:902:7d97:: with SMTP id a23mr16462613plm.31.1584899408179;
        Sun, 22 Mar 2020 10:50:08 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id s15sm11168314pfd.164.2020.03.22.10.50.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 10:50:07 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v5 04/10] net: phy: bcm84881: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 01:49:37 +0800
Message-Id: <20200322174943.26332-5-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322174943.26332-1-zhengdejin5@gmail.com>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
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

