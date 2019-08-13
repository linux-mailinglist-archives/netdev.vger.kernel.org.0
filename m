Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24068C3A1
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfHMV05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:26:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50890 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfHMV05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:26:57 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so2785294wml.0
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 14:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+DnrLkkUGSrar4dai6IrWQi0jA2Wj8yWkD4aW6/OpNU=;
        b=D1+wG149GSMZxhWfL0gMn5hDxSXaGn0zMnTMPjsCsbRoY+J0smxGJN+1wQiIY5FuQD
         R3Jv0dHgWZcviRgM/z9+SAX6/bvzL82oQbyzNNygHVPjYZHVVKhDmkZPxcqZWXVEMIZa
         YSKXcmlR8qJiC55k9dkqLn/WS1LUwLwRgBHdKeAWO5rIxtld6YO4eeK6pyg2mt1j3P5T
         RMW+/dRRJuHltlLlNOUMymk2lDJUTKuMF/1fkgODySS0IkKONyaVCGQ4X8TXoPBK1C8e
         byQ5rlm1yxhF4dgUwQDu8Uv5zvSif1yYUqWC1et1Ug6oc/JRVbRpykU/xUVLuT5BrMPo
         2sKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+DnrLkkUGSrar4dai6IrWQi0jA2Wj8yWkD4aW6/OpNU=;
        b=gDpOgL+kG4GL5cwicPRRvNnfbaKwYMfv0Fwry4ZIdgxiLr3ZX1OjmwnA0Jg7h+CrjA
         OqjXAH5xx5mbgzqt8YHWd/n+1vrfsw8+yorOl3KqvH0mj81y0iyMZI59WhE1plQD+3Zo
         fbHbLYWBs71rwFIZcrkL9n0YV34fSQEZCW55f+gp891xblgaP4IqcXATOLjMT6K0r4FK
         Y8OXP5z+7E/k6gpq+ncb1XmwrfCilkh6Stzj8voKdI31DwYY0mwL6P/DUv4/578AmSoO
         yKu+Uz/j42LaBj+v1y3b1eMPuqtAmITRV5kZpRfoc3UM3vvbQiea/nkwuH7F9TUZeK2C
         aunw==
X-Gm-Message-State: APjAAAXJ+yZpJQ/mJ2XZyHk/hM6UtijyFPNpU194M3O81j5DrwovTU65
        HK+y8b99DlG3hFRAEN7os2tqLMfL
X-Google-Smtp-Source: APXvYqwkSAQEDqLxNB359+W7QqzztZKYilz1k7KkJIz6D2TwF/xm7FPWWr5SswYI36QrwwfuHJ6mKg==
X-Received: by 2002:a1c:541e:: with SMTP id i30mr4790474wmb.54.1565731615155;
        Tue, 13 Aug 2019 14:26:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a? (p200300EA8F2F3200E1E264B7EE242D4A.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e1e2:64b7:ee24:2d4a])
        by smtp.googlemail.com with ESMTPSA id z8sm2026413wmi.7.2019.08.13.14.26.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 14:26:54 -0700 (PDT)
Subject: [PATCH RFC 2/4] net: phy: allow to bind genphy driver at probe time
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marek Behun <marek.behun@nic.cz>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Message-ID: <b066560d-2cc3-2ea5-5233-e63a612c5aa1@gmail.com>
Date:   Tue, 13 Aug 2019 23:25:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ac3471d5-deb7-b711-6e74-23f59914758a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cases like a fixed phy that is never attached to a net_device we
may want to bind the genphy driver at probe time. Setting a PHY ID of
0xffffffff to bind the genphy driver would fail due to a check in
get_phy_device(). Therefore let's change the PHY ID the genphy driver
binds to to 0xfffffffe. This still shouldn't match any real PHY,
and it will pass the check in get_phy_devcie().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 3 +--
 include/linux/phy.h          | 4 ++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 163295dbc..54f80af31 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2388,8 +2388,7 @@ void phy_drivers_unregister(struct phy_driver *drv, int n)
 EXPORT_SYMBOL(phy_drivers_unregister);
 
 static struct phy_driver genphy_driver = {
-	.phy_id		= 0xffffffff,
-	.phy_id_mask	= 0xffffffff,
+	PHY_ID_MATCH_EXACT(GENPHY_ID),
 	.name		= "Generic PHY",
 	.soft_reset	= genphy_no_soft_reset,
 	.get_features	= genphy_read_abilities,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5ac7d2137..3b07bce78 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -37,6 +37,10 @@
 #define PHY_1000BT_FEATURES	(SUPPORTED_1000baseT_Half | \
 				 SUPPORTED_1000baseT_Full)
 
+#define GENPHY_ID_HIGH		0xffffU
+#define GENPHY_ID_LOW		0xfffeU
+#define GENPHY_ID		((GENPHY_ID_HIGH << 16) | GENPHY_ID_LOW)
+
 extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_basic_features) __ro_after_init;
 extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_basic_t1_features) __ro_after_init;
 extern __ETHTOOL_DECLARE_LINK_MODE_MASK(phy_gbit_features) __ro_after_init;
-- 
2.22.0


