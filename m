Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0096818A79A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 23:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCRWHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 18:07:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44981 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbgCRWHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 18:07:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id y2so332291wrn.11
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 15:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6XomNomuOUp5mTqPVWMdJV3PwK1ZBiaMrtREgNxOD9E=;
        b=NRZ1yZHeL8bPyH5qSeIMKntZVBaNgWn9u9OcAHjQVsc5du0BAcSB9b/kcE7amFNMpa
         6J5vcHTUPARF8Q2DMTaDSusNvhbAiidkQVtj6MtYeJu3sn7mQ2/V89SV3TWh0yPHLUyo
         LQKNtgjcB2YXUUgpAK67Lx+bvl/nBnwlmR58dhHWc3hvBfO7nEA1o2+Tsc66HGRc4FFR
         ELLPQCg8HVPLOuUk2tWLTM0Edq45kPuASWQhM+occlmQsaFZgcJYiSRbm7o9t7RmWbUI
         7hI6GibKCpBOajPHP8w6C8hjdnb9dtwX/mFw2IQJUoWZ4RZrvVCy6Cl4t4+ubUBwz7Ay
         Kayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6XomNomuOUp5mTqPVWMdJV3PwK1ZBiaMrtREgNxOD9E=;
        b=QFRhO13jvdkvZl/l4LGHJ6Whz8fHBA6faDsG8xr6c/MwDFI//uQgHsRDNVYib9Bo+h
         IPyXHyUxWpAgTRJ/DTmOn+uxK1iSSO21KEQFAQmYCrsg6ZpKMO05rMRrHyx03oIEPvVe
         MYXwIFleeFCUMTh+Q0chvrHMd17vLTTW1iUPpUxlXH8ZAK78vYpTh/MzCMgp0wcW0u/y
         BFHB/VKPwMmZqEjA8+YdrCn3UX4fO5vvdk/KkyxqKpmkUvKPQDXlS1NP7evnBwlSeW+I
         SbM3P+wIybvNSVolHCpBASxn9c/RVXt/ELd5T6JffsUMR7gIs1qNXx3BnB5sS7hm2pnT
         JaSg==
X-Gm-Message-State: ANhLgQ20WkcRVwKajaHClJ4PvxnCcNLWlitxUO/7UwhHGOgn9S7g9EZ9
        tVe1AD1+4PI2TI1WeDspDg5IGNRh
X-Google-Smtp-Source: ADFU+vtGzDbNGfSJvaVgRVE0PKWmLd/jhMkB5t519rITTk2UnxQyu8xlruDxMEJg1YbPUZyt+l8LhA==
X-Received: by 2002:adf:ec82:: with SMTP id z2mr57431wrn.302.1584569249044;
        Wed, 18 Mar 2020 15:07:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c8fb:eee:cf86:ecdf? (p200300EA8F296000C8FB0EEECF86ECDF.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c8fb:eee:cf86:ecdf])
        by smtp.googlemail.com with ESMTPSA id z11sm169627wmc.30.2020.03.18.15.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 15:07:28 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: realtek: read actual speed to detect
 downshift
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <11d0287d-2cd2-4174-9d23-1203f5f45bfb@gmail.com>
Date:   Wed, 18 Mar 2020 23:07:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At least some integrated PHY's in RTL8168/RTL8125 chip versions support
downshift, and the actual link speed can be read from a vendor-specific
register. Info about this register was provided by Realtek.
More details about downshift configuration (e.g. number of attempts)
aren't available, therefore the downshift tunable is not implemented.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/realtek.c | 60 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index f5fa2fff3..2d99e9de6 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -49,6 +49,8 @@
 #define RTL_LPADV_5000FULL			BIT(6)
 #define RTL_LPADV_2500FULL			BIT(5)
 
+#define RTLGEN_SPEED_MASK			0x0630
+
 #define RTL_GENERIC_PHYID			0x001cc800
 
 MODULE_DESCRIPTION("Realtek PHY driver");
@@ -309,6 +311,55 @@ static int rtl8366rb_config_init(struct phy_device *phydev)
 	return ret;
 }
 
+/* get actual speed to cover the downshift case */
+static int rtlgen_get_speed(struct phy_device *phydev)
+{
+	int val;
+
+	if (!phydev->link)
+		return 0;
+
+	val = phy_read_paged(phydev, 0xa43, 0x12);
+	if (val < 0)
+		return val;
+
+	switch (val & RTLGEN_SPEED_MASK) {
+	case 0x0000:
+		phydev->speed = SPEED_10;
+		break;
+	case 0x0010:
+		phydev->speed = SPEED_100;
+		break;
+	case 0x0020:
+		phydev->speed = SPEED_1000;
+		break;
+	case 0x0200:
+		phydev->speed = SPEED_10000;
+		break;
+	case 0x0210:
+		phydev->speed = SPEED_2500;
+		break;
+	case 0x0220:
+		phydev->speed = SPEED_5000;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int rtlgen_read_status(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_read_status(phydev);
+	if (ret < 0)
+		return ret;
+
+	return rtlgen_get_speed(phydev);
+}
+
 static int rtlgen_read_mmd(struct phy_device *phydev, int devnum, u16 regnum)
 {
 	int ret;
@@ -429,6 +480,8 @@ static int rtl8125_config_aneg(struct phy_device *phydev)
 
 static int rtl8125_read_status(struct phy_device *phydev)
 {
+	int ret;
+
 	if (phydev->autoneg == AUTONEG_ENABLE) {
 		int lpadv = phy_read_paged(phydev, 0xa5d, 0x13);
 
@@ -443,7 +496,11 @@ static int rtl8125_read_status(struct phy_device *phydev)
 			phydev->lp_advertising, lpadv & RTL_LPADV_2500FULL);
 	}
 
-	return genphy_read_status(phydev);
+	ret = genphy_read_status(phydev);
+	if (ret < 0)
+		return ret;
+
+	return rtlgen_get_speed(phydev);
 }
 
 static bool rtlgen_supports_2_5gbps(struct phy_device *phydev)
@@ -550,6 +607,7 @@ static struct phy_driver realtek_drvs[] = {
 	}, {
 		.name		= "Generic FE-GE Realtek PHY",
 		.match_phy_device = rtlgen_match_phy_device,
+		.read_status	= rtlgen_read_status,
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
 		.read_page	= rtl821x_read_page,
-- 
2.25.1

