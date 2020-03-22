Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9437618E73D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgCVG41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:27 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32846 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgCVG40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:26 -0400
Received: by mail-pg1-f195.google.com with SMTP id d17so4849078pgo.0;
        Sat, 21 Mar 2020 23:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v/Y9MRgSestXRv5aFL8kUofLFxL8S+t01EkAKu3WkqU=;
        b=ZwwUB76QnbPnqF3lxT+AD2ijN0eEERaXZ23yMNZ613vZZyimndIs36zNTR9ppXPwVp
         ggiJ2oZFPyadu+b2u4zhft5jzL8Ln5WAQkMhIYAEeh/cFqUjL42Vr+CY5bUs6LjLvZu8
         UZjRX4OUJ1E/9Zwu4DUl/k6oVJR3cyuwxqjeNtqjLX+egsLxS7ilRtdktiCBfEM+wGok
         IiBrA1svG0mu2NblxkChTXhZPzWM3HX9Buvn3cS0yJc1sntzcH2ULkOSGmyXTKPG55d5
         htyCglWusroRxZcky49BJNZuJ7r6DcFMCvtYQYhPXJqZrxVe/lQZ3qDa48QLaCtKH91Z
         X/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v/Y9MRgSestXRv5aFL8kUofLFxL8S+t01EkAKu3WkqU=;
        b=kh5mviPlJNFJgdj4R3o1z59F61H1lQeDeTqmByWFXui4omq1QX5kiMB5jWRn999BKe
         CWwzhHkrOC+22ea5z0/aNoq9ffAWwTZV3X0yMnCYL0Ytvf6ZTTSkOUZBcAr4RTHMmKvn
         LvAaew2NxMf9aAoH4uXhl0EFZx7nx4lvVY5C8KMBDJRCtxMGLjksvS8tm7KzJYwkW4J5
         J7D4WjJgqrM2TSdAuBhsLkGCEWqaUoPymNCWvDANLjH1kadN2VhmmOLBekJXWFtoI9ST
         sxtkoKWiakR9f5Co8CgkEi5yn6wXJKC4ucKAKj6xJAcUEeYMxvtMTnpEim0gt+Ibnh0f
         c1Dw==
X-Gm-Message-State: ANhLgQ2mnhrLDcLVytg7YRDt7mLye8WxzEwZK9TvLZhvIciLdLD31A1u
        XtaVKfw5bbuAgunMn6ZsE2Y=
X-Google-Smtp-Source: ADFU+vsYyIKDx9jr83tGx4o8zL5ZXgR6D5nOnG7o8HkNNuE1vKBcnS0zOqMrFjRDFuYd9AiFurJ95A==
X-Received: by 2002:a63:9c4:: with SMTP id 187mr16010147pgj.389.1584860183744;
        Sat, 21 Mar 2020 23:56:23 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id x4sm390612pfi.202.2020.03.21.23.56.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:23 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 5/9] net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 14:55:51 +0800
Message-Id: <20200322065555.17742-6-zhengdejin5@gmail.com>
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
simplify aqr107_wait_reset_complete() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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
index 31927b2c7d5a..db3e20938729 100644
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
+					 VEND1_GLOBAL_FW_ID, val,
+					 val != 0, 20000, 2000000);
 }
 
 static void aqr107_chip_info(struct phy_device *phydev)
-- 
2.25.0

