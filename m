Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9CB285A5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfEWSJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:09:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38727 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731117AbfEWSJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:09:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so7288672wrs.5;
        Thu, 23 May 2019 11:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MUoTI3lFf39uXeM0VMygbT8Su2qPCBrpSTIiYNMYwMo=;
        b=rr02zRjWHPqO2iKOD8uh3r3TDWyeBMV2gm4f8JstYzBGZAVHOzfjcHXFyB95eJlnMc
         dL8XAkDoWzYcc7kBADW3J5ATrKlhXVlg9G1zneiH5N6x/yEO7FbzEsKyR5ch1bQrsJoB
         1VzQ+Jzdwkp/i6jm9V5+z9M3VJfa2X20K6I3sM9OTEpZcOXVvCG7E2KBd4t753EBf7i1
         TpTuyu0q30SBw4RRwL1AuzYiDk/xF832kDs3Vs2MLeczRxm+QxIT71muIg3U95bNMDAL
         ucBJ7TeAwEmjmU8Wm7iXmJEz8BBkZ4Lt1ZGVcqoPR+cLHbsPPUEllfK2wlmG/et4K5N+
         dS9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MUoTI3lFf39uXeM0VMygbT8Su2qPCBrpSTIiYNMYwMo=;
        b=Ubxx66Dg+h6uDQ/EwMqTkhXMfFTZ/JLRBIcNT4kx+xtJ810hJab6E25I1SWb97k7wm
         lA9ABSe5VdWDsTAvvm8DEEhEQifflNfRECt/4NgnqF3HN6EwTGwfQ6Hhuf1spgc+uFbW
         cvlTe+y5Efqz6uHCEgSISf9A7B26fwXODQGvcr7r2/MfFJU4R8jitmfHGNdcgYVD0Rmy
         PkxSChnkgctC4AP91dq4TxDPsUZJ5UJ7qgDj1aFrFyRHUAwEfTjpvCX5C6+t8tIjbkVM
         liDulw74ZSFshVZ2rhLzCxvP4Af2bDN2n56dpPVJAuj/ZK/o2bwhGfDSIQBCiTtaKYnu
         l4mA==
X-Gm-Message-State: APjAAAWGUzttL+nOlrDD7LjHOeb38uTQMalQQXpzdJOAmKl/4aEhmMcI
        5TEB7bhswT2z6JUg8IJ08Ksi+ooS
X-Google-Smtp-Source: APXvYqw7fovl5AhusgJmiVAm3W+wCGx8IE3r1LsoQJIUn2wT4olUeQsRIvDQvuLXGpmYD62Gu1I1pw==
X-Received: by 2002:adf:a4d8:: with SMTP id h24mr3714696wrb.171.1558634964298;
        Thu, 23 May 2019 11:09:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0? (p200300EA8BE97A003CD1E8FED810B3F0.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0])
        by smtp.googlemail.com with ESMTPSA id b10sm64526588wrh.59.2019.05.23.11.09.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:09:23 -0700 (PDT)
Subject: [PATCH net-next v2 3/3] net: phy: aquantia: add USXGMII support and
 warn if XGMII mode is set
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Message-ID: <96437cfa-b1f9-eeae-f9ca-c658c81f61c0@gmail.com>
Date:   Thu, 23 May 2019 20:09:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we didn't support mode USXGMII, and in order to not break few
boards mode XGMII was accepted for the AQR107 family even though it
doesn't support XGMII. Add USXGMII support to the Aquantia PHY driver
and warn if XGMII mode is set.

v2:
- add warning if XGMII mode is set

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/aquantia_main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
index 0fedd28fd..3b29d3811 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -27,6 +27,7 @@
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_MASK	GENMASK(7, 3)
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_KR	0
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI	2
+#define MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII	3
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII	6
 #define MDIO_PHYXS_VEND_IF_STATUS_TYPE_OCSGMII	10
 
@@ -360,6 +361,9 @@ static int aqr107_read_status(struct phy_device *phydev)
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_XFI:
 		phydev->interface = PHY_INTERFACE_MODE_10GKR;
 		break;
+	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_USXGMII:
+		phydev->interface = PHY_INTERFACE_MODE_USXGMII;
+		break;
 	case MDIO_PHYXS_VEND_IF_STATUS_TYPE_SGMII:
 		phydev->interface = PHY_INTERFACE_MODE_SGMII;
 		break;
@@ -488,9 +492,13 @@ static int aqr107_config_init(struct phy_device *phydev)
 	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
+	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
 		return -ENODEV;
 
+	WARN(phydev->interface == PHY_INTERFACE_MODE_XGMII,
+	     "Your devicetree is out of date, please update it. The AQR107 family doesn't support XGMII, maybe you mean USXGMII.\n");
+
 	ret = aqr107_wait_reset_complete(phydev);
 	if (!ret)
 		aqr107_chip_info(phydev);
-- 
2.21.0


