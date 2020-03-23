Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BA118EE3C
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 03:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCWC5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 22:57:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35380 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgCWC5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 22:57:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7so6460764pgr.2;
        Sun, 22 Mar 2020 19:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mifl2ikKJNKf9Y0+MA8EZLncr03EmrnFMDIlWtiHq4E=;
        b=vNb/KEz3bAt7X6kr6oAgcFWun+PsRezIj3xzygvRXA4JOwqsNnVMvncVjBwZCTMMNL
         T7AciISiKpIB6GnGz2uz87D6u6350q5Q/iPjrOxqOv5D9hYbSbWy0N1mW0xo/2AKy4zk
         6dhhuWui6UydKJ4AJ4RWuBoPWOp4um2YzKIqiZaSapX9qXbOnZ3+3DMBQvMxugEFG+sd
         EKanBHoEC8oQ7qEGcYqakGHmaBcIMVYF98IboJ3iWoMD1e3mbmN83jgRjcfM/yzt9XM7
         PiBvcNIiriX4TIUi0ogk+VlKgeLan5WNVZblMsXn34ryvhQFeJSQpdDt5dit2z9Y/5sx
         vKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mifl2ikKJNKf9Y0+MA8EZLncr03EmrnFMDIlWtiHq4E=;
        b=P+PwHB8XxbImrZxq7RctS7alvwxkqPQhbGiKe9BXB3MWWvw+ChKQkXAYlWf03CWxtT
         5sAbuRec0ZHO/+RnL1Y5SI1WVMU0eRXNJhYlXe3ryWG4+QOQ6hqlLDMZA+drU9AxgEdU
         4V078ZUJ3VFVpla8LzriqQ0mKHuj4pqS9QZNr7e7ekPJ/E1TiKNEOEnuIz/6vZFWCjok
         0qqTjycW2prie3bk9MhYByNJMXxLA7jUiMzzmXAhupbnGYDf9lHDF8sw58CE9vPqwrwa
         8iAhvmvCI86q2y3pEygNy9JSJxbvrNa7jsjDr/R1cg5OvO37JN2ujvmG/I4hbGoGPOJd
         Lfng==
X-Gm-Message-State: ANhLgQ3cDB0ciqwhghfB4KGUMO/QI/1lTePfSDwyLX7HNTcP0bCDREzK
        grQLYmYEdwCzFWtvhbHetcY=
X-Google-Smtp-Source: ADFU+vvtJ6VVES5MpYj5dXV9cn4A/doa2f+0gxiUXwDoDU5wJ5cJuNPYTV9PlIHyavJHr5zb55o1PQ==
X-Received: by 2002:a62:6807:: with SMTP id d7mr22401640pfc.230.1584932243020;
        Sun, 22 Mar 2020 19:57:23 -0700 (PDT)
Received: from localhost (104.128.80.227.16clouds.com. [104.128.80.227])
        by smtp.gmail.com with ESMTPSA id c15sm5600915pfo.139.2020.03.22.19.57.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Mar 2020 19:57:22 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        mchehab+samsung@kernel.org, gregkh@linuxfoundation.org,
        broonie@kernel.org, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v6 05/10] net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Mon, 23 Mar 2020 10:56:28 +0800
Message-Id: <20200323025633.6069-6-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200323025633.6069-1-zhengdejin5@gmail.com>
References: <20200323025633.6069-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify aqr107_wait_reset_complete() function.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
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

