Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3262FC02
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 15:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfE3NLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 09:11:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37898 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfE3NLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 09:11:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id t5so3800800wmh.3
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 06:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQeQtqLUspvgPD616RLoN929/S7ESYKav10669VC5bg=;
        b=FehErZNS19AvDvhY4/a74efvPf5j6NEF2NlKkWMlOj+uKyS11VrnxmKnCvrHl+L/sW
         LW1fAAo0RawgKPvXHrKr+LGWmOQc+dwhZh19LOMV+dOQPpKSfHOLuYA65fPKM8nhyAk5
         lZJU+GdR1jWaYWYJI3PF3xv0hafmgLGXHsamm3jazhofhXciZC28B2PAY5SHRS1pXwLn
         9zWMH7B+luimUayNZMCKlhshA4qmbUzTUuH6t0G/ygB4BxJHckE0sPHiUaI86RDBuIj8
         6hJDku3lkiI53U6DAUklHXOUWPV+tFWFotE/xFDD38InEH2Sim89vU0j5RBGulrSSkaT
         HY/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mQeQtqLUspvgPD616RLoN929/S7ESYKav10669VC5bg=;
        b=R//K5vIhYmaJD/KBrZPN6iC3aMGEfd+PPQT+IwDU7p9orBa/Wtk1JsU5ltz9vCqf1s
         Xj2BBN/YaffOdvBDG2aCVbdo9rdbMYSB/fbTl/ZvwlQ/Y5jLSJD0mDDuIMWl8vAdR4pF
         pj6AlrlugrKI6cBZ9Q2QAC4MF+G2b34JtxVVqv29rAEY/SiYtO+7UuX56/ZVA6QbAxOC
         oEsRPmpFbWuzAY/4SZM5vM3ATGKlhrN3ap7czk3SG8XouzBKGolCv9B62K6N3xhfP648
         4iIZUC/cFdYpgU9RwKhKOVRtY4lJ7iACmMHJDMPQz6/1DzUFOZowj1KpTkoK8OPs69b+
         D+Dg==
X-Gm-Message-State: APjAAAWiuEepkxcNX2+e6UWFmQyeSZXLfEb0OefdBToiA0BDnRmaUBJR
        lR5pczUz3YPpzN99KHa7okfsxU1+
X-Google-Smtp-Source: APXvYqxZJxTT3NBXguIFEJZ99LF1GTogWLAohGArJ/EzO5Sff9JcKmrk4YDWh/rcO1nMcpIRK/CGSw==
X-Received: by 2002:a1c:be12:: with SMTP id o18mr2364080wmf.124.1559221880741;
        Thu, 30 May 2019 06:11:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:7d95:5542:24c5:5635? (p200300EA8BF3BD007D95554224C55635.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:7d95:5542:24c5:5635])
        by smtp.googlemail.com with ESMTPSA id k2sm4771348wrg.41.2019.05.30.06.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 06:11:20 -0700 (PDT)
Subject: [PATCH net-next v2 2/3] net: phy: add callback for custom interrupt
 handler to struct phy_driver
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Message-ID: <acb8507d-d5a3-2190-8d5c-988f1062f2e7@gmail.com>
Date:   Thu, 30 May 2019 15:10:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phylib interrupt handler handles link change events only currently.
However PHY drivers may want to use other interrupt sources too,
e.g. to report temperature monitoring events. Therefore add a callback
to struct phy_driver allowing PHY drivers to implement a custom
interrupt handler.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy.c | 9 +++++++--
 include/linux/phy.h   | 3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d90d9863e..068f0a126 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -772,8 +772,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	if (phydev->drv->did_interrupt && !phydev->drv->did_interrupt(phydev))
 		return IRQ_NONE;
 
-	/* reschedule state queue work to run as soon as possible */
-	phy_trigger_machine(phydev);
+	if (phydev->drv->handle_interrupt) {
+		if (phydev->drv->handle_interrupt(phydev))
+			goto phy_err;
+	} else {
+		/* reschedule state queue work to run as soon as possible */
+		phy_trigger_machine(phydev);
+	}
 
 	if (phy_clear_interrupt(phydev))
 		goto phy_err;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 72e1196f9..16cd33915 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -537,6 +537,9 @@ struct phy_driver {
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 
+	/* Override default interrupt handling */
+	int (*handle_interrupt)(struct phy_device *phydev);
+
 	/* Clears up any memory if needed */
 	void (*remove)(struct phy_device *phydev);
 
-- 
2.21.0


