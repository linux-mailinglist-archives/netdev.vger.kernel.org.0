Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0BD174F99
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 21:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgCAUgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 15:36:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51433 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgCAUgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 15:36:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id 9so2694745wmo.1
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 12:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bO2uU4xt8XRrT2TB2BVQJ+MNi6v5ShBU2SdztrglYm0=;
        b=a3crX0S+Au2VyJ9qH0U1TMM3AwwLRHvTCJcFhKQZjR2ABsdYsnRqjDqIUyXDH9210Q
         TRhcYyfw4WYJu3pmIQ8idbLoTdYGbclNEYaaa/1M4DKPjhARMVIn+yio66UWOLyPa1gv
         bkEp1TDn3uEussVa3pVlTo+PmIeZWQzgCIcnvoI92g0nD56aRUvFMNXBN/sIgGs/mGfG
         kTczj68HtSGO06pr8SVz8bRTTY82Xgx6sYu/v3c09qHFLZN6w6CwCEcmRU5FI/9JdH9U
         X87+2rTL8hrmNhZHZbsVNemz7IZT4DABVVvgMe6/RKowxFzklgMVF8XpzFNO4A/coa5i
         2/Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bO2uU4xt8XRrT2TB2BVQJ+MNi6v5ShBU2SdztrglYm0=;
        b=kvnsV91KellsFhiB+6F2AqH1RDVBKrG0DyCcFYASyaJZpfw2q8ru3ZQQI6rt8eCFh9
         wTlKrDAGw+cGywlaaMOqts0KugGwhWE8N1wltoB2Y2lWenNT0XSdGuQQS9HdOO9RB4La
         v3JW+tsmM/FB7oSWrZiF3+z3+9eVo4CGdr1LQ2ElgscPojN6mFp29AXNVtSwbiriXfN1
         b0PBIAzbYRNUSuU5spxViyL638YTl85mARYM7Jp5T0SdVAlQEM24sjet89dRzdAHkYj7
         dtfHh078ZiMSrs3b0O15Hrux3KgKKvem5+22yD2jIF26VZKCtEUV0WtV961I9kms580G
         9dJg==
X-Gm-Message-State: APjAAAWORqPaPbkI8WuEJukj4LvYqf/NcBZvl5ObiwfF07Ik+Vr2svE4
        L7i/ch5eEWx0LTOivxx/RyA=
X-Google-Smtp-Source: APXvYqzSHoJ3mgbqj8HOsb0ZQpbMFyj6Mr6ED9hiJfnQNHiA4xpyOK0BsjPxL5WQ8qmvF5+ud5mWjA==
X-Received: by 2002:a1c:5f54:: with SMTP id t81mr16273725wmb.155.1583094978171;
        Sun, 01 Mar 2020 12:36:18 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:f915:e49c:5a8a:4fcb? (p200300EA8F296000F915E49C5A8A4FCB.dip0.t-ipconnect.de. [2003:ea:8f29:6000:f915:e49c:5a8a:4fcb])
        by smtp.googlemail.com with ESMTPSA id g25sm26911971wmh.3.2020.03.01.12.36.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 12:36:17 -0800 (PST)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Walle <michael@walle.cc>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: avoid clearing PHY interrupts twice in irq
 handler
Message-ID: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
Date:   Sun, 1 Mar 2020 21:36:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On all PHY drivers that implement did_interrupt() reading the interrupt
status bits clears them. This means we may loose an interrupt that
is triggered between calling did_interrupt() and phy_clear_interrupt().
As part of the fix make it a requirement that did_interrupt() clears
the interrupt.

The Fixes tag refers to the first commit where the patch applies
cleanly.

Fixes: 49644e68f472 ("net: phy: add callback for custom interrupt handler to struct phy_driver")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 3 ++-
 include/linux/phy.h   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d76e038cf..16e3fb79e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -727,7 +727,8 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 		phy_trigger_machine(phydev);
 	}
 
-	if (phy_clear_interrupt(phydev))
+	/* did_interrupt() may have cleared the interrupt already */
+	if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
 		goto phy_err;
 	return IRQ_HANDLED;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 80f8b2158..8b299476b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -557,6 +557,7 @@ struct phy_driver {
 	/*
 	 * Checks if the PHY generated an interrupt.
 	 * For multi-PHY devices with shared PHY interrupt pin
+	 * Set interrupt bits have to be cleared.
 	 */
 	int (*did_interrupt)(struct phy_device *phydev);
 
-- 
2.25.1

