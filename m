Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6318F832
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCWPGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:06:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33108 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgCWPGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 11:06:53 -0400
Received: by mail-pl1-f196.google.com with SMTP id g18so6037597plq.0;
        Mon, 23 Mar 2020 08:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1HUb4AeGuA2g7c/unfMsKtYIp8g+5knhSs9R57JNtH4=;
        b=KouZ1u0Mj1k5eEV1NnNHk+oS3OUnarKwDPPMF4o04MgXWTrmqghhofCNycRRg9w9Zi
         TcLjaV8B1A63XzJrcKY1ECt35XOCiyzezDOeqqoxoW+O18li0TDSKxPv9dL2vxIOvKeQ
         6W60/Hm3F+zWXNAUBoix0xZlOYKhMQEyib0zMTMlKo4MdSv/asDkllGVOTWQY2+ZG5eR
         RyIkMs6tm8A8GGouX6a1e8WsWgPqvG5lOt2TPXlV8cIrRpVAv1E26Yqq/xuoV2yiUcio
         j/m9oLQRUm0BgM09zTMKv4f91C1DpCzuoiREadTumTfCH3axXlsYpBYNJpGhry7rU9LG
         o3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1HUb4AeGuA2g7c/unfMsKtYIp8g+5knhSs9R57JNtH4=;
        b=jbiJIZMwdVyjxOzYVhLW9yGKOFOpba26M70VE2970P6i6B4yK35wM+AeyCSBZdr41n
         Naju9wUeyMf3dhKAGSDWSB2vV1NAtboBq3U4WYqLUx+hvHoepkqcl85cLTNiX6f9Wpyt
         kbFohQrfGA8SBtxGw1+k7ybYHfufF1R2SaaHtOMfQYdoU+tfKKisCZgA+OdRXQS/JSSq
         /PdRL8i0Au6hUqzGSdj0g8Ao+TRGc++pnBV9JsMm4+GDMvpypX/wNZcFC2VIdV7abFOP
         GXW+U55HbyBnWrJ/cccy1cMwPq9isJA+BFuLgoox/dSQoYwq+V7TuYxGsBSN1jp1zHD1
         zKww==
X-Gm-Message-State: ANhLgQ2p7yTQYMaQJRPyElCp+8gVrSrL9FzzKo+D/pgQMc4rQkkNC2Ni
        R6DV5JBFiA+jNmwurEF0Q7p/h7pl
X-Google-Smtp-Source: ADFU+vtlO1XgD5CECuh8IzNbnSjrxlBg4gjjwqsN4cBoSEqiMi/n50Rz4XR9ndWr3lr+f7a0EBkZ+g==
X-Received: by 2002:a17:90a:208:: with SMTP id c8mr25825941pjc.153.1584976012130;
        Mon, 23 Mar 2020 08:06:52 -0700 (PDT)
Received: from localhost (176.122.158.203.16clouds.com. [176.122.158.203])
        by smtp.gmail.com with ESMTPSA id h11sm13796776pfn.103.2020.03.23.08.06.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 23 Mar 2020 08:06:51 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, corbet@lwn.net,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v7 05/10] net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 23:05:55 +0800
Message-Id: <20200323150600.21382-6-zhengdejin5@gmail.com>
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
simplify aqr107_wait_reset_complete() function.

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


 drivers/net/phy/aquantia_main.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 31927b2c7d5a..d6829839ba60 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -451,16 +451,11 @@ static int aqr107_set_tunable(struct phy_device *phydev,
  */
 static int aqr107_wait_reset_complete(struct phy_device *phydev)
 {
-	int val, retries = 100;
-
-	do {
-		val = phy_read_mmd(phydev, MDIO_MMD_VEND1, VEND1_GLOBAL_FW_ID);
-		if (val < 0)
-			return val;
-		msleep(20);
-	} while (!val && --retries);
+	int val;
 
-	return val ? 0 : -ETIMEDOUT;
+	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
+					 VEND1_GLOBAL_FW_ID, val, val != 0,
+					 20000, 2000000, false);
 }
 
 static void aqr107_chip_info(struct phy_device *phydev)
-- 
2.25.0

