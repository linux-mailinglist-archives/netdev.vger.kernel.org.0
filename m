Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721EA18E73A
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 07:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgCVG4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 02:56:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45786 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgCVG4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 02:56:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so4429131pls.12;
        Sat, 21 Mar 2020 23:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GdjHs4uUTEBEfa5bLl7pWyzl+sdKTsngOqpzF9tHKx0=;
        b=B+Fb7vYa1OwSqi53f2jHu81D4h+fKGweze3oPxYIxntMpACPtg8c6IVdrUzsN3Qt59
         KCa7HLHaRC0RB+g/F1i3eGEefWIF9V3hH+hhkdk2QUHoRKAVpEr5Y0moCxYkhkzx3Rz3
         gxJxTu8ZPssy1pCuDJCT3OOqMs4sFj85MN67xE7ry9iBO092b2JxPi7o3or4BSi9s1mo
         BQ/CUbJ33LUnRJ09cnm8byNn41awi8rsPjbq7vOSyeY/RJ2Nag7gDS9JIhtZjbD8KvMj
         n+ePhGdSpwKdPKDBrck1l/upp3oDXkNJi1e+WAG4f3ZHVUwJlN654HKPYOUja9gDBilG
         laNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GdjHs4uUTEBEfa5bLl7pWyzl+sdKTsngOqpzF9tHKx0=;
        b=hT3k06J5c2XUnQLkQpsCTYUUA8R7eQ9NjJHhBYfanDSH666niIKqZYXK4/ipF7+VVL
         HSsrUzeSf1pc6ZAa/Prry0ZQS0qeVjsuQ8RqmXkr99T/u/lTfOUGBBDR9MiKvxPSBjsg
         LSY2t7lX0uqWqQtknU3CdQev9xhEjooWfMGM2Duz2E1UpnMXHaiG75tWvdqYiN07WFfR
         M897BcnmCvuL+IfHVLeHhst4xi54jQ3E7C6VxJh39q4aKxL6bZRqVGtxP7mgGn2M4kaR
         9HuoZK/egg9Bv30o6tWv3oLVzJGjClkwTHAtuDaU/Aa9xMQinjj/yspHfUQiRjNhdYJM
         wYZg==
X-Gm-Message-State: ANhLgQ00kUjeMHQGAejSlrCu6gH4GgPEpX+c7A+WlEAjCiQfUeYd+otR
        VPfLukWqnTfpcJ08+Unujg0=
X-Google-Smtp-Source: ADFU+vv0+KJgfK6kHs0v647YRfmLYrRdEqeK5RAmb2w2EnOCUK3b8p8EaGlUogz99eMAbeNRekNTjg==
X-Received: by 2002:a17:90b:1889:: with SMTP id mn9mr17983892pjb.85.1584860198569;
        Sat, 21 Mar 2020 23:56:38 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id r14sm8877530pjj.48.2020.03.21.23.56.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 21 Mar 2020 23:56:38 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        gregkh@linuxfoundation.org, broonie@kernel.org,
        alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v4 9/9] net: phy: tja11xx: use phy_read_poll_timeout() to simplify the code
Date:   Sun, 22 Mar 2020 14:55:55 +0800
Message-Id: <20200322065555.17742-10-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200322065555.17742-1-zhengdejin5@gmail.com>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_poll_timeout() to replace the poll codes for
simplify tja11xx_check() function.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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

