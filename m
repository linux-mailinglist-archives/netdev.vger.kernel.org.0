Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D947D8EB4C
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbfHOMOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:14:34 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35047 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731775AbfHOMOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:14:31 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so1088628wmg.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TkCpQzt0O3mAU4bSRFh9V9Ndb1XFdaaoT4NDtQM1d/Y=;
        b=k/UO0KmRhx5ZUzKaLJEFscFrqjYBm3taa1v8//uvW15TfBenL95b9qBKiNpj+6Chsa
         f6MD9YZcerfideRPen/MPfxSpgYqcyVaRuIlVe5S6Rf4nZIC9daWf4+fKcUGanfjvtB7
         QJR/L7EtExYaBEOff4V1XcwZ5x4u92qPx4TnfTrWIOz3dUfqmE81xsjCfNdmT9KVWZlY
         AWh7msYEvyyKGXCmirZvmGofFU4dRhEJZcaoepLZpQbfp+b6DWq/gXiecUFhy+l1IMq6
         gL7E3jff9/CFWOK8YX7VK3TMo6PzDOUNI/9cEUJXS4WPy2id38AKyagcnkPlq0ET3qBs
         SgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TkCpQzt0O3mAU4bSRFh9V9Ndb1XFdaaoT4NDtQM1d/Y=;
        b=BCc7pgqzxXYL/zxh8e3q7II+IuGnj0UetXMj2+LD9nuEnWwKVzXBPNEFEvDUDP0akZ
         CZDG9jYv5GziD6PkYmiQBFEPCQM1OCE5SAaM3C9+czpk8Hq5Nk2WUfoVZ69Jw5Y/JPCW
         DJUfs3RE5OaVxTiqPk9AvMIzj+0A0SwoQXwgNDPRU8iZ7ZroKIWJEDsseFseSsNYn/M7
         EQ7/Tduhmlf3VJBlYZzDlNv9ZZpmgM5n4YExNtEXL8FTI1h/pwmiXnU8JbAfBmsnzyIJ
         B6CkRCirrMKWi4zALWDzqs9w4Wrmx7e7O2D4ii01UEg83GrLtBIg5XXbQpQ0MN8QJ+rX
         tDtQ==
X-Gm-Message-State: APjAAAWnZgdLvJzCn8IKWsTW0sBCvvEv11Ef9lckovZPOJoiFDRttPIM
        iB5hnh7Re6swZCUQujh7O+ns9grf
X-Google-Smtp-Source: APXvYqzGfeqzJJoplUlHuGZ7KWcFX5SUAYF1tywu/FIraZ4nn3U9Dq/+kQ77HL22v/PP6FuNzKReSw==
X-Received: by 2002:a1c:b6d4:: with SMTP id g203mr2497944wmf.100.1565871269206;
        Thu, 15 Aug 2019 05:14:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id g12sm2661241wrv.9.2019.08.15.05.14.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:14:28 -0700 (PDT)
Subject: [PATCH net-next v2 1/2] net: phy: realtek: add support for EEE
 registers on integrated PHY's
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
Message-ID: <b9d96a3b-8301-fb4f-c7f5-911c964c15cf@gmail.com>
Date:   Thu, 15 Aug 2019 14:12:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EEE-related registers on newer integrated PHY's have the standard
layout, but are accessible not via MMD but via vendor-specific
registers. Emulating the standard MMD registers allows to use the
generic functions for EEE control.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index c49a1fb13..2635ad1ff 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -266,6 +266,45 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+static int rtlgen_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
+{
+	int ret;
+
+	if (devnum == MDIO_MMD_PCS && regnum == MDIO_PCS_EEE_ABLE) {
+		rtl821x_write_page(phydev, 0xa5c);
+		ret = __phy_read(phydev, 0x12);
+		rtl821x_write_page(phydev, 0);
+	} else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV) {
+		rtl821x_write_page(phydev, 0xa5d);
+		ret = __phy_read(phydev, 0x10);
+		rtl821x_write_page(phydev, 0);
+	} else if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_LPABLE) {
+		rtl821x_write_page(phydev, 0xa5d);
+		ret = __phy_read(phydev, 0x11);
+		rtl821x_write_page(phydev, 0);
+	} else {
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+static int rtlgen_write_mmd(struct phy_device *phydev, int devnum, u16 regnum,
+			    u16 val)
+{
+	int ret;
+
+	if (devnum == MDIO_MMD_AN && regnum == MDIO_AN_EEE_ADV) {
+		rtl821x_write_page(phydev, 0xa5d);
+		ret = __phy_write(phydev, 0x10, val);
+		rtl821x_write_page(phydev, 0);
+	} else {
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
 static int rtl8125_get_features(struct phy_device *phydev)
 {
 	int val;
@@ -422,6 +461,8 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.read_mmd	= rtlgen_read_mmd,
+		.write_mmd	= rtlgen_write_mmd,
 	}, {
 		.name		= "RTL8125 2.5Gbps internal",
 		.match_phy_device = rtl8125_match_phy_device,
@@ -432,6 +473,8 @@ static struct phy_driver realtek_drvs[] = {
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
+		.read_mmd	= rtlgen_read_mmd,
+		.write_mmd	= rtlgen_write_mmd,
 	}, {
 		PHY_ID_MATCH_EXACT(0x001cc961),
 		.name		= "RTL8366RB Gigabit Ethernet",
-- 
2.22.1



