Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98ACC8E9F3
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfHOLP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:15:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46299 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbfHOLP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 07:15:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so1858727wru.13
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 04:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pU/gZcvXTrUGBRORLcssgibA3MHXhRSMFGXZ+UG31PU=;
        b=hfSzFs93zYL3J1Hmddnszowt8PlFUKtJdqp/mgePZb4cbQQLDca5DCGB1N2vsUFe3X
         F6QxiA8IoCZgNROYABU7HSIFMaCx1b+hjhD8Nd4GHrdWtOfZLmcnoGsog8UxBoV7OqAY
         Jru2PLSlySufxYinyZZd1RqGcJqCANVdx3XzTFmqgi+VfQ9MNOo0U0Pxe8tITb2vJSSi
         Mu7UH2HacWzACeLtnZN5/WQl2b69buhJRFQS1ZkOKRqYwkCk/M9xFuK6nopZPhQkRzZz
         XeDmBIbmHY2RJPaq4dseH3qSzQF6r76tcjLg4Z8FCsDlCAxF2gV3wrFQ0mcrwymggbzN
         tMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pU/gZcvXTrUGBRORLcssgibA3MHXhRSMFGXZ+UG31PU=;
        b=Pzs1u9VxJJ472o1Qg8k+x1Na4+cQ4wYqoYbFOw7ZjGkedK0Mp5bDIirZpJFLd88bK2
         dLCsgbJd7Fs/vYRiJeFrPvGcgfzwu4mlcKlETfn4TL7xbYHwnZ27YFX8NuxnZC+Yb2zz
         Hx0yqARd9RoCcMVRDjnCr31yK8ZqTzHkUYguAvouxF427HaInsp5DqYezwYohdRNj13y
         hXIluD4OogGW4bvynW/sj73cPb+EsDtKCoJTz6iSLRVC8SQzXB5a93Zcm/ZdhXeKxwgZ
         UetWyAElpNXkfXT/mySbjwU2v3zUz8CLALCFGROfcBEKIZthkULimBYxU9xWVpwkmPjJ
         07cA==
X-Gm-Message-State: APjAAAXWoS3rMdHVi2GjD+BhKwJHe+rKpVJt3K/6mIIp8lfY/IU1q+Uz
        tilmHH+JzKCgTDUQZ+9vBDBKVkoy
X-Google-Smtp-Source: APXvYqwm1x9BcSh+uEKN1DkH9WdBltfpy7q/61DBZrGEzcEj3oHcrH4iczGXft8GALjTwnaQ23klNg==
X-Received: by 2002:a5d:664a:: with SMTP id f10mr4993478wrw.90.1565867726582;
        Thu, 15 Aug 2019 04:15:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id h9sm2076424wrt.53.2019.08.15.04.15.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 04:15:26 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: read MII_CTRL1000 in genphy_read_status
 only if needed
Message-ID: <84cbdf69-70b4-3dd0-c34d-7db0a4f69653@gmail.com>
Date:   Thu, 15 Aug 2019 13:15:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Value of MII_CTRL1000 is needed only if LPA_1000MSFAIL is set.
Therefore move reading this register.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 54f80af31..4f4ddc05c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1794,7 +1794,7 @@ EXPORT_SYMBOL(genphy_update_link);
  */
 int genphy_read_status(struct phy_device *phydev)
 {
-	int adv, lpa, lpagb, err, old_link = phydev->link;
+	int lpa, lpagb, err, old_link = phydev->link;
 
 	/* Update the link, but return if there was an error */
 	err = genphy_update_link(phydev);
@@ -1816,11 +1816,12 @@ int genphy_read_status(struct phy_device *phydev)
 			if (lpagb < 0)
 				return lpagb;
 
-			adv = phy_read(phydev, MII_CTRL1000);
-			if (adv < 0)
-				return adv;
-
 			if (lpagb & LPA_1000MSFAIL) {
+				int adv = phy_read(phydev, MII_CTRL1000);
+
+				if (adv < 0)
+					return adv;
+
 				if (adv & CTL1000_ENABLE_MASTER)
 					phydev_err(phydev, "Master/Slave resolution failed, maybe conflicting manual settings?\n");
 				else
-- 
2.22.0

