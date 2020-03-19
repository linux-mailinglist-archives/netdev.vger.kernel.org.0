Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE2A18BCCA
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgCSQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:40:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46742 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgCSQkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:40:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id c19so1692411pfo.13;
        Thu, 19 Mar 2020 09:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1z4w1X/c7B728VEf17hnPejETHpmRt4BuaYwHqMynC8=;
        b=ufCIlzq2j7T3SKr4a3w5dlf1Ql75HiGV2Zb70QdqlUssk+sOJQ5NLA6nsfsdVwotjj
         CpEI72RL7wFE7Yy+Nb/RdAtWfdfzgPHeUQ2Y4d8+0dbOE5ncjDzSWsJsIq126bS0zo3a
         ZAct5oR7fkJPWSa1+XyEHYojHIkhIl36nbgRsQNw0n8MRQJElsbFBCDYEg1z2D12BDGH
         62EIkGS5CO9zfb0VXJysPs6fD2GmDi78Pqyz4MfapLY1XNUDqqlJruCQXOQAvt7bTF2N
         3+NO29/SSY1AQU2z8bzPdaTQMKy97RqSFqbKm4Tgw+n9OjoALzOBLylZf6g30ltf25TB
         t/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1z4w1X/c7B728VEf17hnPejETHpmRt4BuaYwHqMynC8=;
        b=MBOO5W9Iw3C/YPJB3gy5UFOvRQ+fOmKa1V2D4UZlCOVzqc8xas1fMvT+Uj8WLzTJmJ
         ICeCBMPe2fK587TyU4CVrEZZcw993JGnLTi/+QcM9TK9+S7CTkMRWC7VIy+gel618A8T
         FITrXxLB5EM2x8f+Xh03sMh//CrhJFNlqp9rn2lw8eVKyNPsLyyMG3YXxp8bW9MN+AlF
         BQksBfCzd3LFEw0T+ck3iDHu7rUih/UnDKSLnYaa57KaKSd6R2OR9yWHQVfQI3dLIFZq
         yzfir0R7HuG+nxUICFV6kToUxv6gsp3SdR0I6xGLaqO/inkOoMxl8tAka15sIpLd3g0C
         k8og==
X-Gm-Message-State: ANhLgQ0QivgtoQEs9FTBJU0fq0b4XUme/kx+jP8xEW49GtUlG6k2NauE
        B9Jg2s6zkebdO6MpNx2FAn4=
X-Google-Smtp-Source: ADFU+vsQjtM68pFCpLzBOv+jWE6Rjl5ulnFENE/+ZxG1wiBpZ+65WYX5Zr/yHJZ9OOTFLB73TjoypQ==
X-Received: by 2002:a63:2bd1:: with SMTP id r200mr4041229pgr.351.1584636005125;
        Thu, 19 Mar 2020 09:40:05 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id l7sm2382554pfl.171.2020.03.19.09.40.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:40:04 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 5/7] net: phy: aquantia: use phy_read_mmd_poll_timeout() to simplify the code
Date:   Fri, 20 Mar 2020 00:39:08 +0800
Message-Id: <20200319163910.14733-6-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200319163910.14733-1-zhengdejin5@gmail.com>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
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
 drivers/net/phy/aquantia_main.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 31927b2c7d5a..fdd037383217 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -451,16 +451,14 @@ static int aqr107_set_tunable(struct phy_device *phydev,
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
+	int val, ret;
 
-	return val ? 0 : -ETIMEDOUT;
+	ret = phy_read_mmd_poll_timeout(val, val < 0 || val != 0, 20000,
+					2000000, phydev, MDIO_MMD_VEND1,
+					VEND1_GLOBAL_FW_ID);
+	if (val < 0)
+		ret = val;
+	return ret;
 }
 
 static void aqr107_chip_info(struct phy_device *phydev)
-- 
2.25.0

