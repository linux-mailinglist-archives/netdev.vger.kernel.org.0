Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0531B6492
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgDWTiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgDWTip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:38:45 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E08C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:38:45 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so7945236wmh.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LPDfm1bWMc1tOXzhfJc7Hh2VRBSeCLo2rYZ2ZoMb5UA=;
        b=QeMftwk3YsnEXtoCWf+MPLDy/nYfUoZ/5bzYW1rzzIoKGVd5nF4HFAPVl1xh0TLHfi
         seI0H9NcPyoQPgx0AnyPYiqNPnBEXdYleWhZQmGfuq5lZlgZiRKAGLb1q6JqftrUdauE
         hB1/tZkerFTt+yJFmE/xalr0zKFlY08Z3XXVbIAFv4jeHZ6TgNjVfhl7+F7Ub7bvYf3i
         MK8yuT1Z6nNZvo/8yydW40slHejqD/VJ4He4XDsvLJcXPCRsqVWNgFubD4DA7zr7h6p/
         2w1GkFJXrVYvAlcpxPZc2gZNE30WFIAC8hqtbmKBG/n3CaDBczUeph/iKSz8gV7EiSC5
         D2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LPDfm1bWMc1tOXzhfJc7Hh2VRBSeCLo2rYZ2ZoMb5UA=;
        b=VPoMt+hpO9ZRTDkt6JOl3wyLst+f7CejNYkXaHJCcLYTfhL7L/EogONEPn5xo6GKvq
         dGf4mM7AWos/mSs7H8pUkjJFJaQ0MTeLPWhORpDO6bs/KP5EKOHu8/AtJINC/mGe8MVb
         KTeVXXLQkaa92MUBxQR4yTTwLjPAOoJ3Xlc9Ns59DdN4AqqVdPWW2aCQWgpGc7u1rVJY
         hg/sIwP39COpV6wt+fhZRw3jPI/pUEhhfeHXfrfJ8Bxf/9Yg1Yyk9fhN8D3ZwrCV/RUu
         p139seJysEKTCR6MwBprBec2ElKRkoVi0beSmpfTsMNpQNSVHW3k8ZYVDIm025kDtaiX
         K2RQ==
X-Gm-Message-State: AGi0PuZeyuG4Rd9xUpW3CVKQysIqpcgyAQQYNIbdIoAnFqT1BPiiL8yQ
        vkVlmWCw279TNnsGJ3/lhqaNg9Gb
X-Google-Smtp-Source: APiQypIoevss9x4ztefjIfJqh21GSZtJZvT1ky7Gw5ztWd5qa5zk2REnBwUt1OLagE7ixXclsOd/pg==
X-Received: by 2002:a5d:6851:: with SMTP id o17mr6492142wrw.267.1587670723879;
        Thu, 23 Apr 2020 12:38:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c569:21dc:2ec:9a23? (p200300EA8F296000C56921DC02EC9A23.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c569:21dc:2ec:9a23])
        by smtp.googlemail.com with ESMTPSA id y9sm4751480wmm.26.2020.04.23.12.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 12:38:43 -0700 (PDT)
Subject: [PATCH net-next 3/3] net: phy: clear phydev->suspended after soft
 reset
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Message-ID: <adbdf4e7-04ed-629e-57e5-2157b2b655da@gmail.com>
Date:   Thu, 23 Apr 2020 21:38:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a soft reset is triggered whilst PHY is in power-down, then
phydev->suspended will remain set. Seems we didn't face any issue yet
caused by this, but better reset the suspended flag after soft reset.

See also the following from 22.2.4.1.1
Resetting a PHY is accomplished by setting bit 0.15 to a logic one.
This action shall set the status and control registers to their default
states.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c8f8fd990..7e1ddd574 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1082,8 +1082,12 @@ int phy_init_hw(struct phy_device *phydev)
 	if (!phydev->drv)
 		return 0;
 
-	if (phydev->drv->soft_reset)
+	if (phydev->drv->soft_reset) {
 		ret = phydev->drv->soft_reset(phydev);
+		/* see comment in genphy_soft_reset for an explanation */
+		if (!ret)
+			phydev->suspended = 0;
+	}
 
 	if (ret < 0)
 		return ret;
@@ -2157,6 +2161,12 @@ int genphy_soft_reset(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
+	/* Clause 22 states that setting bit BMCR_RESET sets control registers
+	 * to their default value. Therefore the POWER DOWN bit is supposed to
+	 * be cleared after soft reset.
+	 */
+	phydev->suspended = 0;
+
 	ret = phy_poll_reset(phydev);
 	if (ret)
 		return ret;
-- 
2.26.2


