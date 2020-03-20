Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0C7018CF0F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgCTNfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 09:35:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45457 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgCTNfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:35:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id m15so3077293pgv.12;
        Fri, 20 Mar 2020 06:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=98UkHK54MJKr9CT41iYYpXXQonjAIYwiHEmxW2wwqMs=;
        b=Iuh63tzFCrN3CmlrQ69Hv/UBCRif0hQ2CdxxB/iAshYGJ2voHLTf/RLyEngu4jQEpn
         pjboXeFnj87hfudDFG0MUqSDDGVUm3nUVya1utX+/LqoJGpWbo7WOYo8lH9Any2wecdU
         96scoHZdjrq/xuL/6JXvQmHzQcByvbnCcO+gUu4zBYNXbEetquDRhixQ/N9nwbH4zOUB
         VNoD3d8B5JlqrfqMBeMT5ckryhFiWjKr2lfDQlxsoUjA2ArerawBJxNq+/6V3nLgmS6d
         qgHY6z2svVOd5diRD7eomcgQjSgJVuNoXExjY3ZXcaDWh+mFnczFVudn1Ifo5ZSL0Zyk
         K+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=98UkHK54MJKr9CT41iYYpXXQonjAIYwiHEmxW2wwqMs=;
        b=m07ZE6a+Y6NngBbbaTWKVPkJuqYLZFg5czth7x/3pvsUtfTKKLG3hlq1w9aw5HcauM
         8fC/a7e476IRCCfJVbCV/mR9hKySYz/hpV078HSIzlXtVu16lhY4o7wyT2iQpiyskvDL
         6RDsmFzB8Lo4Yy991Z7OeZBRgeMTXoeN9FuXq4U8m1soMjpufBaagH0AJlzCsvmymyyc
         sC4yv1j30URMMw9nkD4/Fl1VK3TsRcWZcLGygfwD8e1dInckzA3hhxliqGXiGQgMyRKA
         KgyG0qmsXUdILXn4PmMOUff3LQdrHtQNZ06esQXBOJExkedS73XBzVQ+9LALcns5sPmi
         kzCA==
X-Gm-Message-State: ANhLgQ1lxO15D8Lr/agX0MHF74Q3jo6rLl8HPCOUx0Q4km+n1IFbm8ab
        PCgAdoRN5t9Qe6MTDeM8A0E=
X-Google-Smtp-Source: ADFU+vuc1HwnZOvWl6kXOOdBCPls63uknpqDfLbz6MKAheeIewV3nvNJB+gbV/W9lhzfRQNqVcgM4w==
X-Received: by 2002:a63:6a49:: with SMTP id f70mr8927010pgc.246.1584711303771;
        Fri, 20 Mar 2020 06:35:03 -0700 (PDT)
Received: from localhost (216.24.188.11.16clouds.com. [216.24.188.11])
        by smtp.gmail.com with ESMTPSA id o137sm5699611pfg.34.2020.03.20.06.35.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 06:35:03 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, allison@lohutok.net,
        corbet@lwn.net, alexios.zavras@intel.com, broonie@kernel.org,
        tglx@linutronix.de, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v2 5/7] net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Fri, 20 Mar 2020 21:34:29 +0800
Message-Id: <20200320133431.9354-6-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use phy_read_mmd_poll_timeout() to replace the poll codes for
simplify the code in aqr107_wait_reset_complete() function.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- remove the handle of phy_read_mmd's return error.

drivers/net/phy/aquantia_main.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 31927b2c7d5a..5b9d98b05f76 100644
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
+	return phy_read_mmd_poll_timeout(val, val != 0, 20000, 2000000,
+					 phydev, MDIO_MMD_VEND1,
+					 VEND1_GLOBAL_FW_ID);
 }
 
 static void aqr107_chip_info(struct phy_device *phydev)
-- 
2.25.0

